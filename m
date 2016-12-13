From: Tom Yan <tom.ty89@gmail.com>
Subject: Caching Mode Page and DPOFUA bit handling in sd
Date: Tue, 13 Dec 2016 12:56:35 +0800
Message-ID: <CAGnHSEnOHPQBCs0U5fOio2PNnd9N40YFYwJXPNMP6AWvh_5GaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:32784 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932188AbcLME4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 23:56:37 -0500
Received: by mail-qt0-f173.google.com with SMTP id p16so96871203qta.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2016 20:56:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com
Cc: Maarten van Geijn <maarten@fastmail.nl>

Hi all,

I would like to raise some concern over how the SCSI disk driver
handles Caching Mode Page and DPOFUA bit.

The first thing is what the driver assumes when no Caching Mode Page
is found. By default it "assumes write through", which means it
assumes that the disk has no Caching Mode Page because/so it does not
have volatile write cache.

I am not sure what are the pros or reasons doing so in that case. If I
am not missing something, "assuming write back", which means we assume
there is volatile write cache and send SYNCHRONIZE CACHE commands when
necessary, should be the safer fallback.

The only reason I could think of is, there are devices that are
allergic SYNCHRONIZE CACHE commands. However, I am not sure if it
makes any sense to decide that base on whether the device has Caching
Mode Page.

There has been a commit that takes the safer approach for USB drives
that has the corresponding quirk enabled (Commit b81478d82e38, "[SCSI]
set to WCE if usb cache quirk is present."), which is sort of good,
except the fact that it wasn't made general makes the overall logic
nonsensical.

The second thing is about DPOFUA.

Currently the driver would only read the DPOFUA bit returns from a
MODE SENSE command if Caching Mode Page is found, while the bit does
not belong to the page. It is instead a "device-specific parameter"
like the Write Protect flag. You can even notice that by reading only
the code.

I couldn't found anything in any of the SCSI standards that correlates
the bit and the Caching Mode Page either. Truth is, AFAIK, the DPOFUA
bit to some extent eliminates the necessity of the WCE bit, because if
we send FUA write commands, we shouldn't need to care about whether
write cache is enabled, or if it exists at all.

(It might make some sense by doing something like, "assume write
through if FUA is supported; assume write back if it is not"?)

Also compare sd_set_flush_flag in sd.c and blk_queue_write_cache in
blk-settings.c. The block layer does not "depend" FUA on write cache
as the sd driver does either.

I think sd_read_write_protect_flag should be made general for reading
both the WP and the DPOFUA bits, while sd_read_cache_type should be
freed from the job.

Any comments and insights are welcomed.

Regards,
Tom Yan
