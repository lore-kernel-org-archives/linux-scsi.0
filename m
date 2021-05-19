Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24054C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 07:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 092E4613AA
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 07:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbhESHpo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 03:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241094AbhESHpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 03:45:32 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D43C061760
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 00:44:13 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a11so6543340plh.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 00:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AYbFN+Aw90iCnFE0e4jSNCZfmGKgYaKHVhInNaCf2qg=;
        b=cmDstEpmhsthg5rOyyt2j70y63GbQio7Nk15AbMOYbyamDVYfvh/JmwuU0F7M+a7dL
         ZZ429N9/SrwAsuzSXms1ttgeuVi387wWf93l25LGH+Vk6J58DUJdptyiWADFTK+0Snvx
         EhSx/ts6gk8e1SR8DIcHH1NwODQH623YsR+uI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AYbFN+Aw90iCnFE0e4jSNCZfmGKgYaKHVhInNaCf2qg=;
        b=SVKa9MsBezMuLMLG0VV2SuiJNMP5V209Jyi7vkfLmN8j8VwjYTMyimippABflVv7TE
         YGmth7s2Zv1JBLg0Xqrt4T7g9kli+unXJh3RqH1jufPMuIHt5YrhE9zuJtMfX5trDvxE
         nbb2KThuSf8gfjYjVh0lU0GQ2V7+S1pBnp7mBJOYURPjMGXGTEJyKSp6zV5QDygCgWme
         udQUrJdv9Lm1RpKmGBVjaHTVc275k4Nb3GbopmQdMUjKlua+HvwzSoQnyTb+QLJOkPXc
         dWl0wvXeZeRGvud8eR4EInvqjxPEifWFbeaCYL+valF/WNmsWRfeK5IsJwKqq1ODOvtP
         b0Rg==
X-Gm-Message-State: AOAM532PWaxHbh4VJ2ufmlY7q/PE9EbfWvsNzPts5f8Z9HMJ/BiLH9Cx
        80/nQB3L4dVWmRO9zjoAzYcBOJ+wFMfDXvebJR2Q5g==
X-Google-Smtp-Source: ABdhPJyeMqZD+08Y+2bikigoj//rrOE0XJfZfnnJArhRUteOCLw4k2AwkVnm2DJTHcKv0cjHxYGiyZyG0F79F914AY4=
X-Received: by 2002:a17:902:a3cd:b029:f3:d14:a17 with SMTP id
 q13-20020a170902a3cdb02900f30d140a17mr9100268plb.3.1621410252454; Wed, 19 May
 2021 00:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210518174450.20664-1-bvanassche@acm.org> <20210518174450.20664-28-bvanassche@acm.org>
In-Reply-To: <20210518174450.20664-28-bvanassche@acm.org>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Wed, 19 May 2021 13:13:46 +0530
Message-ID: <CAL2rwxq8Ogs65e_4j-112MsE1pT38m7AothpDaPMERyi=0GiNA@mail.gmail.com>
Subject: Re: [PATCH v2 27/50] megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002aa73f05c2a9fee5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002aa73f05c2a9fee5
Content-Type: text/plain; charset="UTF-8"

On Tue, May 18, 2021 at 11:15 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  4 ++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 +++++-----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 8ed347eebf07..8fc7a3074a21 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1443,10 +1443,10 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
>          * pthru timeout to the os layer timeout value.
>          */
>         if (scp->device->type == TYPE_TAPE) {
> -               if ((scp->request->timeout / HZ) > 0xFFFF)
> +               if (scsi_cmd_to_rq(scp)->timeout / HZ > 0xFFFF)
>                         pthru->timeout = cpu_to_le16(0xFFFF);
>                 else
> -                       pthru->timeout = cpu_to_le16(scp->request->timeout / HZ);
> +                       pthru->timeout = cpu_to_le16(scsi_cmd_to_rq(scp)->timeout / HZ);
>         }
>
>         /*
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 2221175ae051..b894451a3e09 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -402,7 +402,7 @@ megasas_get_msix_index(struct megasas_instance *instance,
>                         (mega_mod64(atomic64_add_return(1, &instance->total_io_count),
>                                 instance->msix_vectors));
>         } else if (instance->host->nr_hw_queues > 1) {
> -               u32 tag = blk_mq_unique_tag(scmd->request);
> +               u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
>
>                 cmd->request_desc->SCSIIO.MSIxIndex = blk_mq_unique_tag_to_hwq(tag) +
>                         instance->low_latency_index_start;
> @@ -3024,7 +3024,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
>                 io_request->DevHandle = cpu_to_le16(device_id);
>                 io_request->LUN[1] = scmd->device->lun;
>                 pRAID_Context->timeout_value =
> -                       cpu_to_le16 (scmd->request->timeout / HZ);
> +                       cpu_to_le16(scsi_cmd_to_rq(scmd)->timeout / HZ);
>                 cmd->request_desc->SCSIIO.RequestFlags =
>                         (MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
>                         MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
> @@ -3087,7 +3087,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
>
>         device_id = MEGASAS_DEV_INDEX(scmd);
>         pd_index = MEGASAS_PD_INDEX(scmd);
> -       os_timeout_value = scmd->request->timeout / HZ;
> +       os_timeout_value = scsi_cmd_to_rq(scmd)->timeout / HZ;
>         mr_device_priv_data = scmd->device->hostdata;
>         cmd->pd_interface = mr_device_priv_data->interface_type;
>
> @@ -3376,7 +3376,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
>                 return SCSI_MLQUEUE_HOST_BUSY;
>         }
>
> -       cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
> +       cmd = megasas_get_cmd_fusion(instance, scsi_cmd_to_rq(scmd)->tag);
>
>         if (!cmd) {
>                 atomic_dec(&instance->fw_outstanding);
> @@ -3417,7 +3417,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
>          */
>         if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
>                 r1_cmd = megasas_get_cmd_fusion(instance,
> -                               (scmd->request->tag + instance->max_fw_cmds));
> +                               scsi_cmd_to_rq(scmd)->tag + instance->max_fw_cmds);
>                 megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
>         }
>

--0000000000002aa73f05c2a9fee5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDxolcBPGdbv2EO+F2mpWSk7Hrl00EH2
QLLUtzoKXG8LMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDUx
OTA3NDQxM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDYgIDfNbZ9+Ew98tFQN54EcgCXx5AWYDIB4Ylc97VNyw0JhK4K
9iKOWUP5OH45S3KmR4muuz7zeTFrk5IceAmKDWqqois+zRfHuVYFaC5psiBitIERK381Z6bANhdw
hDotsa4wVtDu4Ybe4HHEG/OnPRvI0fjF2Y7HcT9Oivo9kM6igjU87uGZc90KRE+E/A3Ep40iAdgt
eJm4oJTey2X00vzG77dRJBau9bleH+oujc+9Auyx7wet0DZOaIPh9Xzz6YlB3EMOnBd/OMcQiGt3
y4dHsjoj8lH5qQHKybn/To5oAssVA94PXrhfn0QVw/5PI4ga5bbkdKVc9ym8qpYu
--0000000000002aa73f05c2a9fee5--
