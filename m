Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9010C4727E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 21:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6119223772
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 21:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EM5GBuq/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgIWVbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 17:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgIWVbR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2020 17:31:17 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DE9C0613CE
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2020 14:31:17 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j7so406574plk.11
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2020 14:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mek+APilVBwLH1bNkfxgi5hnJHu56QOk7+h0jAYcJiE=;
        b=EM5GBuq/l1itTn9i3A/5pEoV3ObKr4y/ajD6jBI4x7QvQtbW2uzOf7qOuDdkvbwMJL
         aI542Dd65f0l9dvW4o/pirw1wTSWxR0+CuGzEx4E595m+aLvUN/OMIHaLTwccqiurZkD
         +xh0gshVRGvzmhI5a/LSstJ9AtlgZvnQM81Ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mek+APilVBwLH1bNkfxgi5hnJHu56QOk7+h0jAYcJiE=;
        b=fBDbil2IBm1iKQxFdHII3qswAnbaAP9I80mfSq8vc6ps7YT6icVKzYbs+uRag6h+WO
         9n58APQbETa2+9wHTcWvKwtvv+wFGdxMYgXCiaae+pVTb6jUMZpwURV63Jff4a2Xl1F8
         D0c7Hv4OwYJ9mta485BmG+aHxsCsSOQaxdvu93CzoED//OeSUMta93Vr1u+zJL79st6x
         mLkzo97jZw57eaYtYtdCIYhAWr8GdKZwNxGtaV7FWMxRIwnIf1u75+HqMP2UGXgnBTdF
         UO3150EAdSw41xhUsIgWK4MqfdE+M2lC/X1nE2CCnKFbRczBITIRO8MQvkjCBvXPyyPA
         wBAQ==
X-Gm-Message-State: AOAM5331C6nRi5RwO8BbZgiSKiht0GUE0lIZZcJw7/KTvQ6M8qFTHENH
        wTj+OUgj/EMT5kCOP+70USTk4JAPEVQCXb+VVGrgDg==
X-Google-Smtp-Source: ABdhPJwAKsog19UlZzKOQGmT7gj+3BPfBCF1diPzU1+4OHdH3U71Cg/5hXhrZuTtARY4PNtJLz0sxyhiZ7vFAOvi6UE=
X-Received: by 2002:a17:90a:d3d5:: with SMTP id d21mr1112482pjw.168.1600896676861;
 Wed, 23 Sep 2020 14:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200923013339.1621784-1-ming.lei@redhat.com>
In-Reply-To: <20200923013339.1621784-1-ming.lei@redhat.com>
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Date:   Wed, 23 Sep 2020 15:31:06 -0600
Message-ID: <CADbZ7FqgpoSdZpSkATRRkUHLzhifATVzseBm3et5__8=gt3NYA@mail.gmail.com>
Subject: Re: [PATCH V3 for 5.11 00/12] blk-mq/scsi: tracking device queue
 depth via sbitmap
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ca998305b001cdc2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ca998305b001cdc2
Content-Type: text/plain; charset="UTF-8"

Hi Ming,

I have tested this patch extensively in our labs.

This patch gives excellent results when a single device can provide
very high IOPs, and only a few of those devices are available on the
system.
Thus, if a RAID 0 volume is created out of many high end NVMe devices,
then that RAID0 volume can potentially reach a max IOPs that is a
summation of the maxs IOPS for all the underlying drives. Without this
patch, the current kernel code cannot get there.

For example, for a simple RAID0 volume with 32 NVMe drives, I got
almost 100% performance boost with this patch.
The NVMe stack does not have this limitation, and this patch goes a
long way in closing that gap.

I have also tested it in many other configurations, and  did not see
any adverse side effects.

Please feel free to add:
Tested-by: Sumanesh Samanta

Thanks,
Sumanesh




On Tue, Sep 22, 2020 at 7:33 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> Hi,
>
> scsi uses one global atomic variable to track queue depth for each
> LUN/request queue. This way can't scale well when there is lots of CPU
> cores and the disk is very fast. Broadcom guys has complained that their
> high end HBA can't reach top performance because .device_busy is
> operated in IO path.
>
> Replace the atomic variable sdev->device_busy with sbitmap for
> tracking scsi device queue depth.
>
> Test on scsi_debug shows this way improve IOPS > 20%. Meantime
> the IOPS difference is just ~1% compared with bypassing .device_busy
> on scsi_debug via patches[1]
>
> The 1st 6 patches moves percpu allocation hint into sbitmap, since
> the improvement by doing percpu allocation hint on sbitmap is observable.
> Meantime export helpers for SCSI.
>
> Patch 7 and 8 prepares for the conversion by returning budget token
> from .get_budget callback, meantime passes the budget token to driver
> via 'struct blk_mq_queue_data' in .queue_rq().
>
> The last four patches changes SCSI for switching to track device queue
> depth via sbitmap.
>
> The patchset have been tested by Broadcom, and obvious performance boost
> can be observed.
>
> Given it is based on both for-5.10/block and 5.10/scsi-queue, the target
> is for v5.11. And it is posted out just for getting full/enough review.
>
> Please comment and review!
>
> V3:
>         - rebase on both for-5.10/block and 5.10/scsi-queue.
>
> V2:
>         - fix one build failure
>
>
> Ming Lei (12):
>   sbitmap: remove sbitmap_clear_bit_unlock
>   sbitmap: maintain allocation round_robin in sbitmap
>   sbitmap: add helpers for updating allocation hint
>   sbitmap: move allocation hint into sbitmap
>   sbitmap: export sbitmap_weight
>   sbitmap: add helper of sbitmap_calculate_shift
>   blk-mq: add callbacks for storing & retrieving budget token
>   blk-mq: return budget token from .get_budget callback
>   scsi: put hot fields of scsi_host_template into one cacheline
>   scsi: add scsi_device_busy() to read sdev->device_busy
>   scsi: make sure sdev->queue_depth is <= shost->can_queue
>   scsi: replace sdev->device_busy with sbitmap
>
>  block/blk-mq-sched.c                 |  17 ++-
>  block/blk-mq.c                       |  38 +++--
>  block/blk-mq.h                       |  25 +++-
>  block/kyber-iosched.c                |   3 +-
>  drivers/message/fusion/mptsas.c      |   2 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |   2 +-
>  drivers/scsi/scsi.c                  |   4 +
>  drivers/scsi/scsi_lib.c              |  69 ++++++---
>  drivers/scsi/scsi_priv.h             |   1 +
>  drivers/scsi/scsi_scan.c             |  22 ++-
>  drivers/scsi/scsi_sysfs.c            |   4 +-
>  drivers/scsi/sg.c                    |   2 +-
>  include/linux/blk-mq.h               |  13 +-
>  include/linux/sbitmap.h              |  84 +++++++----
>  include/scsi/scsi_cmnd.h             |   2 +
>  include/scsi/scsi_device.h           |   8 +-
>  include/scsi/scsi_host.h             |  72 ++++-----
>  lib/sbitmap.c                        | 213 +++++++++++++++------------
>  18 files changed, 376 insertions(+), 205 deletions(-)
>
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
>
> --
> 2.25.2
>

--000000000000ca998305b001cdc2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
jvZFc6XoahS3WClkU2k8jh5NYuPclfcO8hxZ1f4dUqxaz5K+JPi2RCMvHcN9FDM6ycy5nkdlKMwq
k/6VFqsCAwEAAaOCAdQwggHQMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAoBgNVHREEITAfgR1zdW1hbmVzaC5zYW1hbnRhQGJyb2FkY29tLmNvbTAT
BgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNV
HQ4EFgQU/FR1OCHPmDvewYkQowuphVt0VbAwDQYJKoZIhvcNAQELBQADggEBAARVBAvL10Q6XSBr
Qc8cL0dyvN8DNKi97y+3LXCbZ2fZ8xaoHXXuwMzSWepztZTB6jB5vXjGLpb307VKrp7gXiwFhrXV
nu8Ra7CIjogNl35ErAFkqXnBgqrRh7fGAbnE8z6Od/zTX2YTzFDMn6/eYC1QhhEaBq9MfPNwkSsm
4IMnvLdp3v/UDQHDXg9Fna1IPyZf/xCfHcI67tDSPpyDadgY3Wk0uLJyy5t+8jAJ0b3qsLhywVzl
iAppaUyF62nGL95Xtrf0t2ngTdJ3a4b5rSU28IiPdY+3OjqiHFeUXzkWxqNbVT/3pmw96XyWFCgq
yl/cxqVVAV9YyuUjaX+a/MYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBH
bG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0g
U0hBMjU2IC0gRzMCDGMOHuPHLQ4U8FybeTANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQx
IgQg0ItvbcPA/66Jkc5Gvo66IkCZC9pymVY3/bjPzMuSvpowGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwOTIzMjEzMTE3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEB
CjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKn9qxh52F9tsMXq
1AAkfe4VDKyA+Kz59kUAZm4b+IgUOquPw/ek7jnGJymINOmARsQ1i7hG3sGPoTfTDH3thlUDdg7J
Mvi3kyOqPJIxrKB5exM6CzwSE217/szdTAQJzuOGRMYzGWodLQVsI/xjtNgCUcL7L5yiM5N+IJ6I
S97A+D/+fPrA+pA2BJGICbLxF8kEqqBDhrnonVIXa8wQU4jx2VNgYfu4cJ7Lh3rujKopBY6brRaD
T8ju42fcQjWJ+KSesFCyWrwS5WKTCRhdc6P7g9HKLk3fjSiL7sxbln6PgL801RIfj8Cboo/DKhO/
8CcL30TglHgpnBFiyAsSDD0=
--000000000000ca998305b001cdc2--
