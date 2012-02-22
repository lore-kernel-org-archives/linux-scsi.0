From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi (sg) device status vs FC connectivity
Date: Tue, 21 Feb 2012 21:21:08 -0600
Message-ID: <1329880868.2922.127.camel@dabdike.int.hansenpartnership.com>
References: <1329860107.22873.YahooMailNeo@web46407.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58547 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab2BVDVL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 22:21:11 -0500
In-Reply-To: <1329860107.22873.YahooMailNeo@web46407.mail.sp1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Candid Shot <candid_shot_1@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2012-02-21 at 13:35 -0800, Candid Shot wrote:
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

Yes, set the dev_loss_tmo to zero.  That parameter was introduced to
allow the cables to be disconnected and reconnected without tearing down
the fibre channel connections.  By default it waits 60 seconds for
reconnection, if you set it to zero, teardown will happen immediately.

James


