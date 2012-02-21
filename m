From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi (sg) device status vs FC connectivity
Date: Tue, 21 Feb 2012 17:36:20 -0500
Message-ID: <4F441C64.8070001@interlog.com>
References: <1329860107.22873.YahooMailNeo@web46407.mail.sp1.yahoo.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33770 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab2BUWg0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 17:36:26 -0500
In-Reply-To: <1329860107.22873.YahooMailNeo@web46407.mail.sp1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Candid Shot <candid_shot_1@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On 12-02-21 04:35 PM, Candid Shot wrote:
> (I hope this list is the right place to ask SG Driver related question ..)
>
> Background: A FC cable-pull is simulated by disabling the FC switch (Brocade) port.
>
>
> While /sys/class/fc_host/hostx/port_state might confirm the FC connectivity is missing,
>
> /proc/scsi/sg/devices will show the scsi device to be 'online'.
>
> My goal is to be able to return an error to the application, should a cable-pull happen.
>
> Is there a way to be able to tweak this behavior where the scsi driver is able to look at port events,
> and possibly return errors during read/write operations?

The sg driver works at the SCSI level and these days
asynchronous notifications are being left to the
transport layer.

I don't know much about FC. Using SAS (disks connected via
an expander which seems to be functionally similar to a
FC switch) then if an expander port connecting a disk
is disabled then the expander will generate a
Broadcast(Change) which all initiators (HBAs) should
receive and those HBAs should do another device discover
process. That should lead to various events being generated
which udev sees and removes the disk device node.

Hopefully someone who knows about FC and Linux can
supply more details for your case.

Doug Gilbert

