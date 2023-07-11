Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45327EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 17:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjGKRHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 13:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjGKRHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 13:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB401722
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 10:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689095194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yOdGGvbgcEuFz4AAMb4r9LISXx5jZgrZnx83pOkOCq8=;
        b=LWBwtWubQVJBdPzIr5alx5ReMQOwQJvH7pxa9jEysImuTR1LNxRTe00iAVYfaXmiGn7Jfd
        gA5MViWGLBZE1GaxAOPrAxusBFqULajWApG8V5kY5SV3DTfmQY7anlfot6fQGwGwrYMPNy
        LEY0fsKv/ShlHuDNfCaHuFliPYf8wDc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-wu2urR3RPCC1-NBV077Ilw-1; Tue, 11 Jul 2023 13:06:32 -0400
X-MC-Unique: wu2urR3RPCC1-NBV077Ilw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3143c9a3519so4124677f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 10:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689095191; x=1691687191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yOdGGvbgcEuFz4AAMb4r9LISXx5jZgrZnx83pOkOCq8=;
        b=fI+a+v4885b4ZPhMgHjoR7BUfZUpGItC3tIFGtkRTcpQlcKmQuNGCD1t9zS0meq0av
         LLVCyvu2LJoAU7eDZq2Eoj7C4BincV2ViCfCUgOEAOFT75NrFcG2ODmXs6q/F8gB5S4u
         fg92j9tjXvUWZz2AS6+aeXxAYVFGHOKY9UeNhSmd4UmYVf+iaDwWE4geMF+X0clQH843
         IJektpLksB1vo4sdiCAANPtzARhXg+ZlIuvsQ3/OS8u0ScwZxfLKqrPMwQ1RIqTxxZa6
         cVXAZ/lkF1vpj4SRyYPbLTu5P7HE+loYpe6IEevRPquFZXM2CQE5rzACv0HqoLCAlpw3
         WiTg==
X-Gm-Message-State: ABy/qLbrdR8wmpj8jBvvkwyIS/Zdqp9mR9qRiBlNaKdfatlcgavKBmVj
        oLxIL0tKy4Oq8wk0hHjmDYRyYSsxnL4zDdmU3LnDHu3dVrTMZLZBUVp7ceC2onzBX/V1ZdyaPtg
        JMPYLnHG7Z9eHoUcpblcM6w==
X-Received: by 2002:a5d:65c8:0:b0:313:f5f8:b6d2 with SMTP id e8-20020a5d65c8000000b00313f5f8b6d2mr18131721wrw.48.1689095190855;
        Tue, 11 Jul 2023 10:06:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE4vldYHOEvF7yZeJDgvQ0MibxJ3P7oVV4GCN4fn2ayrZQmDQr5Qk1k5wke7DG9oGRZbK24/w==
X-Received: by 2002:a5d:65c8:0:b0:313:f5f8:b6d2 with SMTP id e8-20020a5d65c8000000b00313f5f8b6d2mr18131698wrw.48.1689095190447;
        Tue, 11 Jul 2023 10:06:30 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-6.retail.telecomitalia.it. [82.53.134.6])
        by smtp.gmail.com with ESMTPSA id j3-20020a170906278300b00988a0765e29sm1387559ejc.104.2023.07.11.10.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 10:06:29 -0700 (PDT)
Date:   Tue, 11 Jul 2023 19:06:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        qemu-stable@nongnu.org, Mark Kanda <mark.kanda@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "virtio-scsi: Send "REPORTED LUNS CHANGED" sense
 data upon disk hotplug events"
Message-ID: <i3od362o6unuimlqna3aaedliaabauj6g545esg7txidd4s44e@bkx5des6zytx>
References: <20230705071523.15496-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230705071523.15496-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CCing `./scripts/get_maintainer.pl -f drivers/scsi/virtio_scsi.c`,
since I found a few things in the virtio-scsi driver...

FYI we have seen that Linux has problems with a QEMU patch for the
virtio-scsi device (details at the bottom of this email in the revert
commit message and BZ).


This is what I found when I looked at the Linux code:

In scsi_report_sense() in linux/drivers/scsi/scsi_error.c linux calls
scsi_report_lun_change() that set `sdev_target->expecting_lun_change =
1` when we receive a UNIT ATTENTION with REPORT LUNS CHANGED
(sshdr->asc == 0x3f && sshdr->ascq == 0x0e).

When `sdev_target->expecting_lun_change = 1` is set and we call
scsi_check_sense(), for example to check the next UNIT ATTENTION, it
will return NEEDS_RETRY, that I think will cause the issues we are
seeing.

`sdev_target->expecting_lun_change` is reset only in
scsi_decide_disposition() when `REPORT_LUNS` command returns with
SAM_STAT_GOOD.
That command is issued in scsi_report_lun_scan() called by
__scsi_scan_target(), called for example by scsi_scan_target(),
scsi_scan_host(), etc.

So, checking QEMU, we send VIRTIO_SCSI_EVT_RESET_RESCAN during hotplug
and VIRTIO_SCSI_EVT_RESET_REMOVED during hotunplug. In both cases now we
send also the UNIT ATTENTION.

In the virtio-scsi driver, when we receive VIRTIO_SCSI_EVT_RESET_RESCAN
(hotplug) we call scsi_scan_target() or scsi_add_device(). Both of them
will call __scsi_scan_target() at some points, sending `REPORT_LUNS`
command to the device. This does not happen for
VIRTIO_SCSI_EVT_RESET_REMOVED (hotunplug). Indeed if I remove the
UNIT ATTENTION from the hotunplug in QEMU, everything works well.

So, I tried to add a scan also for VIRTIO_SCSI_EVT_RESET_REMOVED:

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index bd5633667d01..c57658a63097 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -291,6 +291,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
                 }
                 break;
         case VIRTIO_SCSI_EVT_RESET_REMOVED:
+               scsi_scan_host(shost);
                 sdev = scsi_device_lookup(shost, 0, target, lun);
                 if (sdev) {
                         scsi_remove_device(sdev);

This somehow helps, now linux only breaks if the plug/unplug frequency
is really high. If I put a 5 second sleep between plug/unplug events, it
doesn't break (at least for the duration of my test which has been
running for about 30 minutes, before it used to break after about a
minute).

Another thing I noticed is that in QEMU maybe we should set the UNIT
ATTENTION first and then send the event on the virtqueue, because the
scan should happen after the unit attention, but I don't know if in any
case the unit attention is processed before the virtqueue.

I mean something like this:

diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index 45b95ea070..13db40f4f3 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -1079,8 +1079,8 @@ static void virtio_scsi_hotplug(HotplugHandler *hotplug_dev, DeviceState *dev,
          };

          virtio_scsi_acquire(s);
-        virtio_scsi_push_event(s, &info);
          scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
+        virtio_scsi_push_event(s, &info);
          virtio_scsi_release(s);
      }
  }
@@ -1111,8 +1111,8 @@ static void virtio_scsi_hotunplug(HotplugHandler *hotplug_dev, DeviceState *dev,

      if (virtio_vdev_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
          virtio_scsi_acquire(s);
-        virtio_scsi_push_event(s, &info);
          scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
+        virtio_scsi_push_event(s, &info);
          virtio_scsi_release(s);
      }
  }

At this point I think the problem is on the handling of the
VIRTIO_SCSI_EVT_RESET_REMOVED event in the virtio-scsi driver, where
somehow we have to redo the bus scan, but scsi_scan_host() doesn't seem
to be enough when the event rate is very high.

I don't know if along with this fix, we also need to limit the rate in
QEMU somehow.

Sorry for the length of this email, but I'm not familiar with SCSI and
wanted some suggestions on how to proceed.

Paolo, Stefan, Linux SCSI maintainers, any suggestion?


Thanks,
Stefano

On Wed, Jul 05, 2023 at 09:15:23AM +0200, Stefano Garzarella wrote:
>This reverts commit 8cc5583abe6419e7faaebc9fbd109f34f4c850f2.
>
>That commit causes several problems in Linux as described in the BZ.
>In particular, after a while, other devices on the bus are no longer
>usable even if those devices are not affected by the hotunplug.
>This may be a problem in Linux, but we have not been able to identify
>it so far. So better to revert this patch until we find a solution.
>
>Also, Oracle, which initially proposed this patch for a problem with
>Solaris, seems to have already reversed it downstream:
>    https://linux.oracle.com/errata/ELSA-2023-12065.html
>
>Suggested-by: Thomas Huth <thuth@redhat.com>
>Buglink: https://bugzilla.redhat.com/show_bug.cgi?id=2176702
>Cc: qemu-stable@nongnu.org
>Cc: Mark Kanda <mark.kanda@oracle.com>
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>---
> include/hw/scsi/scsi.h |  1 -
> hw/scsi/scsi-bus.c     | 18 ------------------
> hw/scsi/virtio-scsi.c  |  2 --
> 3 files changed, 21 deletions(-)
>
>diff --git a/include/hw/scsi/scsi.h b/include/hw/scsi/scsi.h
>index e2bb1a2fbf..7c8adf10b1 100644
>--- a/include/hw/scsi/scsi.h
>+++ b/include/hw/scsi/scsi.h
>@@ -198,7 +198,6 @@ SCSIDevice *scsi_bus_legacy_add_drive(SCSIBus *bus, BlockBackend *blk,
>                                       BlockdevOnError rerror,
>                                       BlockdevOnError werror,
>                                       const char *serial, Error **errp);
>-void scsi_bus_set_ua(SCSIBus *bus, SCSISense sense);
> void scsi_bus_legacy_handle_cmdline(SCSIBus *bus);
>
> SCSIRequest *scsi_req_alloc(const SCSIReqOps *reqops, SCSIDevice *d,
>diff --git a/hw/scsi/scsi-bus.c b/hw/scsi/scsi-bus.c
>index f80f4cb4fc..42a915f8b7 100644
>--- a/hw/scsi/scsi-bus.c
>+++ b/hw/scsi/scsi-bus.c
>@@ -1617,24 +1617,6 @@ static int scsi_ua_precedence(SCSISense sense)
>     return (sense.asc << 8) | sense.ascq;
> }
>
>-void scsi_bus_set_ua(SCSIBus *bus, SCSISense sense)
>-{
>-    int prec1, prec2;
>-    if (sense.key != UNIT_ATTENTION) {
>-        return;
>-    }
>-
>-    /*
>-     * Override a pre-existing unit attention condition, except for a more
>-     * important reset condition.
>-     */
>-    prec1 = scsi_ua_precedence(bus->unit_attention);
>-    prec2 = scsi_ua_precedence(sense);
>-    if (prec2 < prec1) {
>-        bus->unit_attention = sense;
>-    }
>-}
>-
> void scsi_device_set_ua(SCSIDevice *sdev, SCSISense sense)
> {
>     int prec1, prec2;
>diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
>index 45b95ea070..1f56607100 100644
>--- a/hw/scsi/virtio-scsi.c
>+++ b/hw/scsi/virtio-scsi.c
>@@ -1080,7 +1080,6 @@ static void virtio_scsi_hotplug(HotplugHandler *hotplug_dev, DeviceState *dev,
>
>         virtio_scsi_acquire(s);
>         virtio_scsi_push_event(s, &info);
>-        scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
>         virtio_scsi_release(s);
>     }
> }
>@@ -1112,7 +1111,6 @@ static void virtio_scsi_hotunplug(HotplugHandler *hotplug_dev, DeviceState *dev,
>     if (virtio_vdev_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
>         virtio_scsi_acquire(s);
>         virtio_scsi_push_event(s, &info);
>-        scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
>         virtio_scsi_release(s);
>     }
> }
>-- 
>2.41.0
>

