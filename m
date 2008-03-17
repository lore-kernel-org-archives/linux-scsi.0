From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: media change events for polled devices broken with current
	sdev_evt_send()
Date: Mon, 17 Mar 2008 16:36:25 +0100
Message-ID: <1205768185.6338.18.camel@lov.site>
References: <1204795762.3136.27.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYCQPfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 11:35:46 -0400
In-Reply-To: <1204795762.3136.27.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: kristen accardi <kaccardi@gmail.com>, scsi <linux-scsi@vger.kernel.org>, David Zeuthen <david@fubar.dk>

Ping! Jeff, please answer the question. We need the media change events
for non AN devices.

Thanks,
Kay

On Thu, 2008-03-06 at 10:29 +0100, Kay Sievers wrote:
> Hi Jeff,
>   a341cd0f (SCSI: add asynchronous event notification API)
> introduces an event filter like:
>   +       if (!test_bit(evt->evt_type, sdev->supported_events)) {
>   +               kfree(evt);
>   +               return;
>   +       }
> 
> which breaks:
>   285e9670 (sr,sd: send media state change modification events)
> 
> Why are events sent through sdev_evt_send() filtered? In which case does
> code send an event which we don't want to deliver?
> 
> 
> Side note: introduced with a341cd0f is the sysfs file:
> "evt_media_change", which has a store() method, but has the permission
> 0444. It should either have no store() method assigned, by introducing
> something like DECLARE_EVT_RO(), or the file permission should be
> changed to 0644.
> 
> Thanks,
> Kay

