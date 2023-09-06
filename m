Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B5CEE14B9
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Sep 2023 17:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242616AbjIFRHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Sep 2023 13:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242611AbjIFRHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Sep 2023 13:07:36 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFF4E70
        for <linux-scsi@vger.kernel.org>; Wed,  6 Sep 2023 10:07:28 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-401d67434daso898555e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 06 Sep 2023 10:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1694020047; x=1694624847; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mq2x0kg01chQRqYJmOxXNvxNYdFKxVojFJwTpdI9odc=;
        b=dHxcth/ObunsrymqCv4EYoILulYg28oVy1AiOztymbnrK1cPoR5F1I/FAZF+mqfCjZ
         hGZO3jXLAV8wsGSPb3c5b4l6LR920/M1K8tZ2kwwb2XYwSTGqTHFA+rVv2c+umnKtEJ5
         Iu/6kxgVNVruUuL6rCtQywlRXJov8WKQuEYdI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694020047; x=1694624847;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mq2x0kg01chQRqYJmOxXNvxNYdFKxVojFJwTpdI9odc=;
        b=VUpxa8cAS9BoyZ699r5vl/ulYbvIlcdrV+Fl2goU+k4HKdOU8UtKK6tDiqNdautaSv
         18eh+TzabqAuez+04HHXJFYT6ZtiUgxFN9DsCngu//njMOrYWs/waUQv0yKyT3P1Iq5q
         nJKnTj+KXxXzL3NrdFSNipGpFhhVpUKpX5nch6JhsQvUp22/PepQP2kn0B0KccF+nBkK
         czy1WCyC3lDRvhlKYTatGLT25HihDsZDg7R/Lz/vAADsqQU2oDn7GK9CxEEdMay68AkU
         zKbEOUNpB4fsWEEgMy+9QyBbyFEMa6zMzZUKzUx5Qe5LX/xduhmuvPN29aktgB2V7NE2
         V/sA==
X-Gm-Message-State: AOJu0YwW3ZuWbA3nM2X9rkNxoVKbPyvQQaqmdl6Tw0Bojo9vMX8T5zcr
        3KjWj/H8et1M1RsE/oQVF9Q441QC6Zdg0yO8bggyPWFJWO6qutiht7XrXaABROxjWX9pPVUYCN7
        Xwy3Bh43/n71oE9Cm2hsHqfdRC2Pe
X-Google-Smtp-Source: AGHT+IFbhRw7YbNHLkweLnbnMA/HHc9DdrAszxbwhLlYSoVImfcMEyqbkKSvn65/dvrnOFRYH6A6R163ZBmyUWlxbUU=
X-Received: by 2002:a05:600c:21cd:b0:401:b76d:3b8b with SMTP id
 x13-20020a05600c21cd00b00401b76d3b8bmr2643141wmj.16.1694020047238; Wed, 06
 Sep 2023 10:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230906030809.2847970-1-ruanjinjie@huawei.com>
In-Reply-To: <20230906030809.2847970-1-ruanjinjie@huawei.com>
From:   Justin Tee <justin.tee@broadcom.com>
Date:   Wed, 6 Sep 2023 10:07:15 -0700
Message-ID: <CAAmqgVNyzfP9enaACQEs0wcF68tmZ_RV64YguqcgkNWCtrL5zA@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix Fix the NULL vs IS_ERR() bug for debugfs_create_file()
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002fec510604b3c7c2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002fec510604b3c7c2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jinjie,

The title of this patch has the word "Fix" twice, but the change
itself looks fine.

Reviewed-by: Justin Tee <justin.tee@broadcom.com>


On Tue, Sep 5, 2023 at 8:08=E2=80=AFPM Jinjie Ruan <ruanjinjie@huawei.com> =
wrote:
>
> Since debugfs_create_file() return ERR_PTR and never return NULL, so use
> IS_ERR() to check it instead of checking NULL.
>
> Fixes: 2fcbc569b9f5 ("scsi: lpfc: Make debugfs ktime stats generic for NV=
ME and SCSI")
> Fixes: 4c47efc140fa ("scsi: lpfc: Move SCSI and NVME Stats to hardware qu=
eue structures")
> Fixes: 6a828b0f6192 ("scsi: lpfc: Support non-uniform allocation of MSIX =
vectors to hardware queues")
> Fixes: 95bfc6d8ad86 ("scsi: lpfc: Make FW logging dynamically configurabl=
e")
> Fixes: 9f77870870d8 ("scsi: lpfc: Add debugfs support for cm framework bu=
ffers")
> Fixes: c490850a0947 ("scsi: lpfc: Adapt partitioned XRI lists to efficien=
t sharing")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_de=
bugfs.c
> index 7f9b221e7c34..ea9b42225e62 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -6073,7 +6073,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>                                             phba->hba_debugfs_root,
>                                             phba,
>                                             &lpfc_debugfs_op_multixripool=
s);
> -               if (!phba->debug_multixri_pools) {
> +               if (IS_ERR(phba->debug_multixri_pools)) {
>                         lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
>                                          "0527 Cannot create debugfs mult=
ixripools\n");
>                         goto debug_failed;
> @@ -6085,7 +6085,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>                         debugfs_create_file(name, S_IFREG | 0644,
>                                             phba->hba_debugfs_root,
>                                             phba, &lpfc_cgn_buffer_op);
> -               if (!phba->debug_cgn_buffer) {
> +               if (IS_ERR(phba->debug_cgn_buffer)) {
>                         lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
>                                          "6527 Cannot create debugfs "
>                                          "cgn_buffer\n");
> @@ -6098,7 +6098,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>                         debugfs_create_file(name, S_IFREG | 0644,
>                                             phba->hba_debugfs_root,
>                                             phba, &lpfc_rx_monitor_op);
> -               if (!phba->debug_rx_monitor) {
> +               if (IS_ERR(phba->debug_rx_monitor)) {
>                         lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
>                                          "6528 Cannot create debugfs "
>                                          "rx_monitor\n");
> @@ -6111,7 +6111,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>                         debugfs_create_file(name, 0644,
>                                             phba->hba_debugfs_root,
>                                             phba, &lpfc_debugfs_ras_log);
> -               if (!phba->debug_ras_log) {
> +               if (IS_ERR(phba->debug_ras_log)) {
>                         lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
>                                          "6148 Cannot create debugfs"
>                                          " ras_log\n");
> @@ -6132,7 +6132,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>                         debugfs_create_file(name, S_IFREG | 0644,
>                                             phba->hba_debugfs_root,
>                                             phba, &lpfc_debugfs_op_lockst=
at);
> -               if (!phba->debug_lockstat) {
> +               if (IS_ERR(phba->debug_lockstat)) {
>                         lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
>                                          "4610 Can't create debugfs locks=
tat\n");
>                         goto debug_failed;
> @@ -6358,7 +6358,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>                 debugfs_create_file(name, 0644,
>                                     vport->vport_debugfs_root,
>                                     vport, &lpfc_debugfs_op_scsistat);
> -       if (!vport->debug_scsistat) {
> +       if (IS_ERR(vport->debug_scsistat)) {
>                 lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
>                                  "4611 Cannot create debugfs scsistat\n")=
;
>                 goto debug_failed;
> @@ -6369,7 +6369,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>                 debugfs_create_file(name, 0644,
>                                     vport->vport_debugfs_root,
>                                     vport, &lpfc_debugfs_op_ioktime);
> -       if (!vport->debug_ioktime) {
> +       if (IS_ERR(vport->debug_ioktime)) {
>                 lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
>                                  "0815 Cannot create debugfs ioktime\n");
>                 goto debug_failed;
> --
> 2.34.1
>

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--0000000000002fec510604b3c7c2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
QsyUohclvlxgt5d/MsBG6WZxZ+uppzNvjEk/wUu+6JQNUVEMviA6eBCCi+4ShjZUbGPES11h5lw/
wuyQZDIjy+1hGPtLHBXI/QQEbU3OVdTRn+aEMwIDAQABo4IB2DCCAdQwDgYDVR0PAQH/BAQDAgWg
MIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUFBzABhjVo
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMDBNBgNV
HSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2ln
bi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAiBgNVHREEGzAZ
gRdqdXN0aW4udGVlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAW
gBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUlHfvnuNaLp52RO2Y2En9J+7MKI4wDQYJ
KoZIhvcNAQELBQADggEBAGaBsEmLZwejb3YsmigadLZGto3hJ7Erq2YZLhL7Pgtxft1/j4JNLsRN
t3ZJIW2Xzfbj0p328xRekSP1gjZ9Szre0fxEFXH1sS1a7WP9E0fHxVW07xVsxGxo5opAh5Gf/bQH
S4x9pCO48FJI310L1RGQiqFKY/OECnXO821y8MAyObbGo9HNHP4Sk6F5J1v2qJzbLtMfj8ybbTGe
SidstRgjOIqMldZs2Koio14QFE7hJY+8KRiKfq+eb1EwQTMzBxZsMOL5vUSZjYg2+Fqwyr6YYp0w
Lsq/wH9o18xSvL/FikpG4JRxiT20RdM6DQrk9lv8ijASZCuN3JR61WUNz2AxggJtMIICaQIBATBr
MFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9i
YWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwMd6BsMSBDsagVFtYwDQYJYIZI
AWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKUUbaJJmQ3LxGirUTzzlEjvyvANpsRReHzzfVxB
ovO1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDkwNjE3MDcy
N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkq
hkiG9w0BAQEFAASCAQBLudasxrTznOba6EYX0Kb1aUw3Sezlok8LF9m086jA89WT7yn7KOpoypqv
rnPXVI8PrfemKm7mFB+7pFokgoqcxzCM7KHWQ41hwc8ITjfJ5gUnlcIKLj98w/5QkzE2GglKi4b3
kL0GpZEaGd2LYQ+TI/RN1yabyUdTQupGLXZ5hLmYuNVbG4Hjeza+lxfbkGIYr/LV0udqR2snCurh
pV9U0EVfgEJz6+qkY0NsmcJMljCG5d9jPbvRTiPkFCLjw/2MtPJfb0/K0Squ5v6wKgJ6AyVj9tpC
GUWcF3nQmqtX+wjhqdDwkaezqLAivcg06gRahAexkayouScpbUIYBUNp
--0000000000002fec510604b3c7c2--
