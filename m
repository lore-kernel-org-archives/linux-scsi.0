From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] SCSI: kill compat SDEV_MEDIA_CHANGE event
Date: Tue, 28 Dec 2010 16:38:55 +0100
Message-ID: <AANLkTimDMfSDjpK8ff3gnr6Vhnqvok5DwLCZdP3OkCsP@mail.gmail.com>
References: <20101228152047.GJ488@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46420 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0L1PjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2010 10:39:12 -0500
Received: by fxm20 with SMTP id 20so9843825fxm.19
        for <linux-scsi@vger.kernel.org>; Tue, 28 Dec 2010 07:39:10 -0800 (PST)
In-Reply-To: <20101228152047.GJ488@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Tue, Dec 28, 2010 at 16:20, Tejun Heo <tj@kernel.org> wrote:
> SDEV_MEDIA_CHANGE event was first added by commit a341cd0f (SCSI: add
> asynchronous event notification API) for SATA AN support and then
> extended to cover generic media change events by commit 285e9670
> ([SCSI] sr,sd: send media state change modification events).
>
> This event was mapped to block device in userland with all properties
> stripped to simulate CHANGE event on the block device, which, in turn=
,
> was used to trigger further userspace action on media change.
>
> The recent addition of disk event framework kept this event for
> backward compatibility but it turns out to be unnecessary and causes
> erratic and inefficient behavior. =C2=A0The new disk event generates =
proper
> events on the block devices and the compat events are mapped to block
> device with all properties stripped, so the block device ends up
> generating multiple duplicate events for single actual event.
>
> This patch removes the compat event generation from both sr and sd as
> suggested by Kay Sievers. =C2=A0Both existing and newer versions of u=
dev
> and the associated tools will behave better with the removal of these
> events as they from the beginning were expecting events on the block
> devices.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jeff Garzik <jgarzik@redhat.com>

Here's my:
  Tested-By: Kay Sievers <kay.sievers@vrfy.org>

Works fine for me with udev/udisks.

Udev uses a rule to "forward" the SCSI events to the block device, and
fake an event there. Now that we have the events proper from the
device itself, where they belong to, we can stop doing such weird
hacks.

I'm happy to see that mess cleaned up. Thanks a lot for doing all that!

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
