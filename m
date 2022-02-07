Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F31C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 20:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiBGUxr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 15:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiBGUxp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 15:53:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ACFEC061355
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 12:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644267222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R2befhckUMsDs8ijkgTC0j8DKQX2CbQnmj9QyYogAZ8=;
        b=eyEJqGns9su7crLiSAWOKEghfQIn+ovoJPzyyhbnIpJsxTAb0NxA0d6CoJBddSMdL6KWkj
        hGj63PGbeGU+zZHzhR8QhqWrE8KsxGrKlmNRu9sNVgDv2Zbl+9PpC4hLv9Teq1dkqDxGvm
        LlUqMHWJm9kI/ax05EDZiotl9g/1fJU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-pVGaFzLuN16pb584BKWamg-1; Mon, 07 Feb 2022 15:53:40 -0500
X-MC-Unique: pVGaFzLuN16pb584BKWamg-1
Received: by mail-lj1-f197.google.com with SMTP id m13-20020a2e97cd000000b0023e09d49ce4so4988270ljj.6
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2022 12:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2befhckUMsDs8ijkgTC0j8DKQX2CbQnmj9QyYogAZ8=;
        b=Xy2gans/HJ8TZf8abkgLw5Evsb30Qdjj6AtA1WGaCY7qIybGUXYlPZ9AhqdJmHqlad
         PjLE2JbyLtoGaVOqpiC/N/WVtGn1Xu+WfELS11R5YMJ+cn+aKLBXCseoIZBgrHJ1iT3z
         MeBIGIMCB001WRWwwX3aQPeCLvt00boNy3asbPEZl0trCnF1J13Oc0fryuJH7EuqQhUQ
         vEISvVLAvFYEWF7yBh4bc4jfV83JzM20oJGwtyS76fqvWGkDG145NNpCAHi6jQas2jLW
         p1F9DcwvzZcejpQslOYvYWX9LGUVYrnmid+TNEoPeEYX2rRTWMBk3xWMiAihQQ11gYLj
         R+4Q==
X-Gm-Message-State: AOAM5312ep2bqJ+CBxnmE745EdrIOPd5bMz6pYpeTS/+uNlEtMzE7zpc
        Sz4CKoaIYHOXRF/x/OF0svhwHm4iEIhxpHDcfXkfz6QfE0xfgGG2PpYQmsltoOykS/CQd4UOc2M
        lp2oCqdHsiBjyQCndOXNwY7Q5rLwsGF4tt6z0Dw==
X-Received: by 2002:a05:6512:c08:: with SMTP id z8mr816663lfu.644.1644267218669;
        Mon, 07 Feb 2022 12:53:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWmd66yRX4w/kAL/91IiZaO2QwFGfFV1x//tDvegaHtZc0XPcbQZ3wI2rIOdaGfVkKY4Yji85NU+RKaPeZwt8=
X-Received: by 2002:a05:6512:c08:: with SMTP id z8mr816654lfu.644.1644267218436;
 Mon, 07 Feb 2022 12:53:38 -0800 (PST)
MIME-Version: 1.0
References: <CAHZQxyKNqnFro33VrirfkdS8ZNga9vWwJDDu8gQtRdr-yW57iQ@mail.gmail.com>
In-Reply-To: <CAHZQxyKNqnFro33VrirfkdS8ZNga9vWwJDDu8gQtRdr-yW57iQ@mail.gmail.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Mon, 7 Feb 2022 15:53:27 -0500
Message-ID: <CAGtn9rmV=SCxPEegyPc_9zxd9u4+R02LKc3B2X6uK0osY-zWww@mail.gmail.com>
Subject: Re: [PATCH] scsi: scsi_scan purge devices no longer in reported LUN list
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is possible to write a UDEV rule/script in userspace to active the
same result, if desired,
but there are several cases where this is undesirable so I do not
think the kernel should do it.
Having userspace handle policy decisions allows for more flexibility.

-Ewan

On Fri, Jan 14, 2022 at 5:03 PM Brian Bunker <brian@purestorage.com> wrote:
>
> When a new volume is added to an ACL list for a host and a unit
> attention is posted for that host ASC=0x3f ASCQ=0x0e, REPORTED LUNS
> DATA HAS CHANGED, devices are created if the udev rule is active:
>
> ACTION=="change", SUBSYSTEM=="scsi",
> ENV{SDEV_UA}=="REPORTED_LUNS_DATA_HAS_CHANGED",
> RUN+="scan-scsi-target $env{DEVPATH}"
>
> However when a volume is deleted from the ACL list for a host, those
> devices are not deleted. They are orphaned. I am showing multpath
> output to show the connected devices pre-removal from the ACL list and
> post:
>
> Before:
> [root@init501-9 rules.d]# multipath -ll
> 3624a9370d5779477e526433100011019 dm-2 PURE    ,FlashArray
> size=2.0T features='0' hwhandler='1 alua' wp=rw
> `-+- policy='service-time 0' prio=50 status=active
>  |- 0:0:1:1 sdb 8:16 active ready running
>  |- 7:0:1:1 sdc 8:32 active ready running
>  |- 8:0:1:1 sdd 8:48 active ready running
>  `- 9:0:1:1 sde 8:64 active ready running
>
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdb
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E526433100011019
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdc
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E526433100011019
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdd
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E526433100011019
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sde
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E526433100011019
>
> After:
> [root@init501-9 rules.d]# multipath -ll
> 3624a9370d5779477e526433100011019 dm-2 PURE    ,FlashArray
> size=2.0T features='0' hwhandler='1 alua' wp=rw
> `-+- policy='service-time 0' prio=0 status=enabled
>  |- 0:0:1:1 sdb 8:16 failed faulty running
>  |- 7:0:1:1 sdc 8:32 failed faulty running
>  |- 8:0:1:1 sdd 8:48 failed faulty running
>  `- 9:0:1:1 sde 8:64 failed faulty running
> [root@init501-9 rules.d]# sg_map -i -x
> /dev/sg0  1 0 0 0  0  /dev/sda  ATA       TOSHIBA THNSNH25  N101
> /dev/sg1  0 0 1 1  0  /dev/sdb
> /dev/sg2  7 0 1 1  0  /dev/sdc
> /dev/sg3  8 0 1 1  0  /dev/sdd
> /dev/sg4  9 0 1 1  0  /dev/sde
>
> Now if a new volume is connected, different serial number same LUN, it
> will use those orphaned devices:
>
> [root@init501-9 rules.d]# multipath -ll
> 3624a9370d5779477e526433100011019 dm-2 PURE    ,FlashArray
> size=2.0T features='0' hwhandler='1 alua' wp=rw
> `-+- policy='service-time 0' prio=50 status=active
>  |- 0:0:1:1 sdb 8:16 active ready running
>  |- 7:0:1:1 sdc 8:32 active ready running
>  |- 8:0:1:1 sdd 8:48 active ready running
>  `- 9:0:1:1 sde 8:64 active ready running
>
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdb
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101A
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdc
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101A
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdd
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101A
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sde
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101A
>
> This situation becomes more problematic if multiple target devices are
> presenting the same volume and each target device has its own ACL
> management, we can end up in situations where some paths have one
> serial number and some have another.
>
> [root@init501-9 rules.d]# multipath -ll
> 3624a9370d5779477e52643310001101b dm-2 PURE    ,FlashArray
> size=2.0T features='0' hwhandler='1 alua' wp=rw
> `-+- policy='service-time 0' prio=50 status=active
>  |- 0:0:0:1 sdf 8:80  active ready running
>  |- 7:0:0:1 sdg 8:96  active ready running
>  |- 8:0:0:1 sdh 8:112 active ready running
>  |- 9:0:0:1 sdi 8:128 active ready running
>  |- 0:0:1:1 sdb 8:16  active ready running
>  |- 7:0:1:1 sdc 8:32  active ready running
>  |- 8:0:1:1 sdd 8:48  active ready running
>  `- 9:0:1:1 sde 8:64  active ready running
>
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdb
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101B
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdc
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101B
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdd
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101B
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sde
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101B
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdf
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101C
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdg
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101C
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdh
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101C
> [root@init501-9 rules.d]# sg_inq -p 0x80 /dev/sdi
> VPD INQUIRY: Unit serial number page
>  Unit serial number: D5779477E52643310001101C
>
> I understand that this situation can be avoided with a rescan that
> purges stale disks when an ACL is removed like rescan-scsi-bus.sh -r.
> But the ACL removal itself does initiate a rescan, it is just that
> rescan doesn't have the ability to purge devices whose LUNs are no
> longer returned in the reported LUN list.
>
> Signed-off-by: Seamus Conorr <jsconnor@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> Signed-off-by: Krishna Kant <yokim@purestorage.com>
> __
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index c7080454aea9..cfc6c3cc2996 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -220,6 +220,7 @@ static struct {
>        {"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>        {"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
>        {"Promise", "", NULL, BLIST_SPARSELUN},
> +       {"PURE", "FlashArray", "*", BLIST_REMOVE_STALE},
>        {"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
>        {"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
>        {"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3520b9384428..15f6d8a9b61b 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1102,6 +1102,7 @@ static int scsi_probe_and_add_lun(struct
> scsi_target *starget,
>         */
>        sdev = scsi_device_lookup_by_target(starget, lun);
>        if (sdev) {
> +               sdev->in_lun_list = 1;
>                if (rescan != SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
>                        SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
>                                "scsi scan: device exists on %s\n",
> @@ -1198,6 +1199,7 @@ static int scsi_probe_and_add_lun(struct
> scsi_target *starget,
>        }
>
>        res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
> +       sdev->in_lun_list = 1;
>        if (res == SCSI_SCAN_LUN_PRESENT) {
>                if (bflags & BLIST_KEY) {
>                        sdev->lockable = 0;
> @@ -1309,6 +1311,23 @@ static void scsi_sequential_lun_scan(struct
> scsi_target *starget,
>                        return;
> }
>
> +static void
> +_reset_lun_list(struct scsi_device *sdev, void *data)
> +{
> +       if (sdev->is_visible) {
> +               sdev->in_lun_list = 0;
> +       }
> +}
> +
> +static void
> +_remove_stale_devices(struct scsi_device *sdev, void *data)
> +{
> +       if (sdev->in_lun_list || sdev->is_visible == 0)
> +               return;
> +       __scsi_remove_device(sdev);
> +       sdev_printk(KERN_INFO, sdev, "lun_scan: Stale\n");
> +}
> +
> /**
>  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
>  * @starget: which target
> @@ -1373,6 +1392,9 @@ static int scsi_report_lun_scan(struct
> scsi_target *starget, blist_flags_t bflag
>                }
>        }
>
> +       if (bflags & BLIST_REMOVE_STALE)
> +               starget_for_each_device(starget, NULL, _reset_lun_list);
> +
>        /*
>         * Allocate enough to hold the header (the same size as one scsi_lun)
>         * plus the number of luns we are requesting.  511 was the default
> @@ -1487,6 +1509,9 @@ static int scsi_report_lun_scan(struct
> scsi_target *starget, blist_flags_t bflag
>                }
>        }
>
> +       if (bflags & BLIST_REMOVE_STALE)
> +               starget_for_each_device(starget, NULL, _remove_stale_devices);
> +
>  out_err:
>        kfree(lun_data);
>  out:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index ab7557d84f75..c5446ee73af6 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -206,6 +206,7 @@ struct scsi_device {
>        unsigned rpm_autosuspend:1;     /* Enable runtime autosuspend at device
>                                         * creation time */
>        unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
> +       unsigned in_lun_list:1;         /* contained in report luns response */
>
>        unsigned int queue_stopped;     /* request queue is quiesced */
>        bool offline_already;           /* Device offline message logged */
> diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
> index 5d14adae21c7..2e620ca2b7bc 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -68,8 +68,10 @@
> #define BLIST_RETRY_ITF                ((__force blist_flags_t)(1ULL << 32))
> /* Always retry ABORTED_COMMAND with ASC 0xc1 */
> #define BLIST_RETRY_ASC_C1     ((__force blist_flags_t)(1ULL << 33))
> +/* Remove devices no longer in reported luns data */
> +#define BLIST_REMOVE_STALE      ((__force blist_flags_t)(1ULL << 34))
>
> -#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
> +#define __BLIST_LAST_USED BLIST_REMOVE_STALE
>
> #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
>                               (__force blist_flags_t) \
>
>
>
>
> --
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com
>

