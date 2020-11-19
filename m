Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7423C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 07:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B979246E8
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 07:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iEtrGj8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgKSHJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 02:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgKSHJE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 02:09:04 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E46C0613D4
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2020 23:09:04 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id g17so3683597qts.5
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2020 23:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=3aWraaoNmCOVm9+XTZbbJx2XBSO21zoW6xbtfKySAJE=;
        b=iEtrGj8+1v+oIh6/xMfh2qCdzDwIWG7vEGHzpRjIyce9+2DZZ57CEArrRYetCE1EdK
         7uKEeDzK9AsgJmNM92JAB9cdnJrgoU3kSoWMdetLUFFJ3Xy2vYvpLV4SvEiv7ey0FWsQ
         kMYg3MW625gv54ehz0UeATWqPN+0dhWSZVhW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=3aWraaoNmCOVm9+XTZbbJx2XBSO21zoW6xbtfKySAJE=;
        b=tF0tO8kHQm4KEMWgFGDKNTNRzcHw3PoHDs5E/NtCFa/2XPdY8ClfP93ns3vgRqZkCm
         6so7kuN7Q9SQs1Ts67QnEQDf1yrVC0UFYFEgv+/MwcDCDL088NtxeMon0CJKDtrobplI
         khohrrMztYluh7VYoZQ0BmenAxLZxYGs6qAfzGmsWPYy7ZKK7LaeTWMKL3e77Sd8QUYq
         1crSOeDQ5JFuxIDspUp5kBJQ6uNXftlTNEd4czhAKj5WvqM6AH7OTvN1Iedsu32dUxXc
         4EeMOtfEN/DWzITD9Hew6gotlGqlIbUoSjZTgR2q+XkcPBAzu1OBs0IEnTnMrb6t36VU
         6lxg==
X-Gm-Message-State: AOAM532kqQJHzSj6ThqxJMB7N047obI+jDO1TJDbebjVSzbFWfu2EqmI
        3HsAKSCM8K85YkkC76TpD04AhVm4ScqymIwIjxJbKQ==
X-Google-Smtp-Source: ABdhPJwYQ6tyqsZpg5m9++LrXF0oeZtoNi8kXVF0RzASLC2zqGVDLYZ19AtLZVQ+rxloMDXAGAL+kpq6ikaKTEs3gRA=
X-Received: by 2002:ac8:5c15:: with SMTP id i21mr9400364qti.190.1605769743520;
 Wed, 18 Nov 2020 23:09:03 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201116090737.50989-13-ming.lei@redhat.com> <202011161944.U7XHrbsd-lkp@intel.com>
 <20201118023507.GA92339@T590> <36b8e652641fefca6e8f95d3bbaaf3ca@mail.gmail.com>
 <20201119063407.GB170672@T590>
In-Reply-To: <20201119063407.GB170672@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIS9sCgRF18gKjqcruTOMh+o2IV3QHxSRdOAbmfafcCCFe5eAJDXzHnqRbiriA=
Date:   Thu, 19 Nov 2020 12:39:01 +0530
Message-ID: <94182d5716e46be949b7f17a936e7c7e@mail.gmail.com>
Subject: RE: [PATCH V4 12/12] scsi: replace sdev->device_busy with sbitmap
To:     Ming Lei <ming.lei@redhat.com>
Cc:     kernel test robot <lkp@intel.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, Omar Sandoval <osandov@fb.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002de47a05b4706721"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002de47a05b4706721
Content-Type: text/plain; charset="UTF-8"

> >  /**
> >   * megasas_get_cmd_fusion -    Get a command from the free pool
> >   * @instance:          Adapter soft state
> > @@ -359,10 +385,7 @@ megasas_get_msix_index(struct megasas_instance
> > *instance,  {
> >         int sdev_busy;
> >
> > -       /* TBD - if sml remove device_busy in future, driver
> > -        * should track counter in internal structure.
> > -        */
> > -       sdev_busy = atomic_read(&scmd->device->device_busy);
> > +       sdev_busy = megasas_sdev_busy_read(scmd);
>
> The above is only used for MR_BALANCED_PERF_MODE, so maybe you can
> skip inc/dec/read the counter for other perf mode.

Agree. I have created V2.

Subject: [PATCH] megaraid_sas: v2 replace sdev_busy with local counter

use local tracking of per sdev outstanding command since sdev_busy in
SML is improved for peformance reason using sbitmap (earlier it was
atomic variable).

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 51 +++++++++++++++++----
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h
b/drivers/scsi/megaraid/megaraid_sas.h
index 0f808d63580e..0c6a56b24c6e 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2019,10 +2019,12 @@ union megasas_frame {
  * struct MR_PRIV_DEVICE - sdev private hostdata
  * @is_tm_capable: firmware managed tm_capable flag
  * @tm_busy: TM request is in progress
+ * @sdev_priv_busy: pending command per sdev
  */
 struct MR_PRIV_DEVICE {
        bool is_tm_capable;
        bool tm_busy;
+       atomic_t sdev_priv_busy;
        atomic_t r1_ldio_hint;
        u8 interface_type;
        u8 task_abort_tmo;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fd607287608e..c630404cbb2d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -220,6 +220,44 @@ megasas_clear_intr_fusion(struct megasas_instance
*instance)
        return 1;
 }

+static inline void
+megasas_sdev_busy_inc(struct megasas_instance *instance,
+                     struct scsi_cmnd *scmd)
+{
+       struct MR_PRIV_DEVICE *mr_device_priv_data;
+
+       if (instance->perf_mode != MR_BALANCED_PERF_MODE)
+               return;
+
+       mr_device_priv_data = scmd->device->hostdata;
+       atomic_inc(&mr_device_priv_data->sdev_priv_busy);
+}
+static inline void
+megasas_sdev_busy_dec(struct megasas_instance *instance,
+                     struct scsi_cmnd *scmd)
+{
+       struct MR_PRIV_DEVICE *mr_device_priv_data;
+
+       if (instance->perf_mode != MR_BALANCED_PERF_MODE)
+               return;
+
+       mr_device_priv_data = scmd->device->hostdata;
+       atomic_dec(&mr_device_priv_data->sdev_priv_busy);
+}
+static inline int
+megasas_sdev_busy_read(struct megasas_instance *instance,
+                      struct scsi_cmnd *scmd)
+{
+       struct MR_PRIV_DEVICE *mr_device_priv_data;
+
+       if (instance->perf_mode != MR_BALANCED_PERF_MODE)
+               return 0;
+
+       mr_device_priv_data = scmd->device->hostdata;
+       return atomic_read(&mr_device_priv_data->sdev_priv_busy);
+}
+
+
 /**
  * megasas_get_cmd_fusion -    Get a command from the free pool
  * @instance:          Adapter soft state
@@ -357,15 +395,9 @@ megasas_get_msix_index(struct megasas_instance
*instance,
                       struct megasas_cmd_fusion *cmd,
                       u8 data_arms)
 {
-       int sdev_busy;
-
-       /* TBD - if sml remove device_busy in future, driver
-        * should track counter in internal structure.
-        */
-       sdev_busy = atomic_read(&scmd->device->device_busy);
-
        if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
-           sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH)) {
+           (megasas_sdev_busy_read(instance, scmd) >
+           (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))) {
                cmd->request_desc->SCSIIO.MSIxIndex =
                        mega_mod64((atomic64_add_return(1,
&instance->high_iops_outstanding) /
                                        MR_HIGH_IOPS_BATCH_COUNT),
instance->low_latency_index_start);
@@ -3390,6 +3422,7 @@ megasas_build_and_issue_cmd_fusion(struct
megasas_instance *instance,
         * Issue the command to the FW
         */

+       megasas_sdev_busy_inc(instance, scmd);
        megasas_fire_cmd_fusion(instance, req_desc);

        if (r1_cmd)
@@ -3450,6 +3483,7 @@ megasas_complete_r1_command(struct megasas_instance
*instance,
                scmd_local->SCp.ptr = NULL;
                megasas_return_cmd_fusion(instance, cmd);
                scsi_dma_unmap(scmd_local);
+               megasas_sdev_busy_dec(instance, scmd_local);
                scmd_local->scsi_done(scmd_local);
        }
 }
@@ -3550,6 +3584,7 @@ complete_cmd_fusion(struct megasas_instance
*instance, u32 MSIxIndex,
                                scmd_local->SCp.ptr = NULL;
                                megasas_return_cmd_fusion(instance,
cmd_fusion);
                                scsi_dma_unmap(scmd_local);
+                               megasas_sdev_busy_dec(instance,
scmd_local);
                                scmd_local->scsi_done(scmd_local);
                        } else  /* Optimal VD - R1 FP command completion.
*/
                                megasas_complete_r1_command(instance,
cmd_fusion);
--
>
>
>
> Thanks,
> Ming

--0000000000002de47a05b4706721
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg8eIYugEx
JkSiOk1ftJ1s0Or1mKSAtoBaxycVLYTgCfwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMTE5MDcwOTAzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKLuOtYLXnsvqRiXPfYGQrgyUIfU
QdY0Hc5v3clEsS25V5dt2lnOacYnq0jOwa1fPzWW2M6pEPWOqk/RDmPG0gw+R9SFmqNb+y0XM0Kc
Xm1OE+wiDElqefICY4zb1MN3OvElygSfVqwdEEEp5FjkjF+umm2B+/KBNkaag4UaSKXd+BNSEXRq
v/upgIPKCyU1w8w9PqSC1mFjG4ukSOKP+fYSusXpT1tMrf+zb3Qg6t9CPVwdY/hG5PScdZOMfBd0
F4D+6/pU4uZdJHUXkoaZGFQZwWl5LLOspFuLkv7DCfuhVsPhcBh+Ny3LlV3eJ+uNkVe5f+jWNPNw
0WPpNulK16U=
--0000000000002de47a05b4706721--
