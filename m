Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353D8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 10:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiGYKE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 06:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiGYKEz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 06:04:55 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7738917AA1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 03:04:54 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id u9so12881768oiv.12
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 03:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GRJaRWVgAZQLfQcSgamEIasT0fs6gv7QfF4LmzheM1U=;
        b=b111Dwl66WJJyHBhoMe60hnpcnNtd8FgXcIR+LeQl/gcE1fCwHrCgaIOayG42qBb2D
         A03ZyXyX+os1Kuj3K9IXA1Z1RYG9K3ckUefQKL22jPRJYTudEosqEc5p1nr0xP43oXd5
         JoqNJq3VWCsVzA8GbMpi9HggbyLCm8E/ivn6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GRJaRWVgAZQLfQcSgamEIasT0fs6gv7QfF4LmzheM1U=;
        b=hvoaQXj6TEofOHpiS1HLVfM7LoGrj2NI2ew1iE+QfqNseotE25Yme697kC+e1XC7vq
         D41WYpDSh8S/AhnZ8+2Kpqm9iewd/LiwiHT5Ixcmn+vyx4D2NlvGy6ImgbE5rFMNrQ6N
         LTjHF6PkDfaJFrLwm7EuXW0JyJvljeNH9smhhON7zj+eP1KrYTUjVocQQdnlHTdCRg6m
         ckqwDbz1Jip7ecOd7BMFSL7SnLzh5+mhRWI38jqBTr9tPhjoUj/EZz4A4kkLmbq7bah0
         LbE9ApKkCDQNqbKCxnL/oCYQc7vkdTbWVYomY77Eh2LESWh5b40zcxbpB0DptG+hg4Wt
         5AbA==
X-Gm-Message-State: AJIora+KDAMg2GMNAZMJXE1lLcUZiew1HJHIDZp2eRNtqyTmSZG+6M9E
        2Ly5ikpJ4VxqbWh9h5CERR7zTSDnV2JOnCU7BdI+qg==
X-Google-Smtp-Source: AGRyM1uFbrGj7HsWZgSXp3KhJrPMEURmFTBiV7WJZGEgPxGmRFplUzEzCkFoZSE2hN9aMWqaHhMYg0ujeR3ayBTx7O0=
X-Received: by 2002:a54:478d:0:b0:33a:d3c1:5881 with SMTP id
 o13-20020a54478d000000b0033ad3c15881mr3421807oic.234.1658743493552; Mon, 25
 Jul 2022 03:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220725072703.5562-1-xi.fengfei@h3c.com>
In-Reply-To: <20220725072703.5562-1-xi.fengfei@h3c.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 25 Jul 2022 15:34:41 +0530
Message-ID: <CAK=zhgpD=+LFReApyqN3X_0LKoMOdsEivQD6ehQf4zQkFa5o_w@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix kernel panic in scsih_qcmd after shutdown/unload
To:     Fengfei Xi <xi.fengfei@h3c.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        zhou.kete@h3c.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bb58cc05e49e5058"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000bb58cc05e49e5058
Content-Type: text/plain; charset="UTF-8"

Hi Fengfei,

Driver is already returinging the SCSI IO commands (except for
SYNCHRONIZE_CACHE & START_STOP) with DID_NO_CONNECT when remove_host
is set to one.

Also during the shutdown driver is not freeing any controller memory
pools. And during driver unload driver is freeing the memory pools
only after target devices are unregistered with SML.

Can you please share the kernel panic call trace once. Also please let
me know which driver version is used.

Thanks,
Sreekanth

On Mon, Jul 25, 2022 at 1:01 PM Fengfei Xi <xi.fengfei@h3c.com> wrote:
>
> We encountered a kernel crash problem after the user performed a
> shutdown operation. By analyzing the vmcore file, it is confirmed
> that it is scsih_qcmd called memset to access ioc->request resources
> that have been released in shutdown/module unload path.
>
> crash> struct MPT3SAS_ADAPTER 0xffff00ff85806880
> struct MPT3SAS_ADAPTER {
>   list = {
>     next = 0xffff800008eb8038 <mpt3sas_ioc_list>,
>     prev = 0xffff800008eb8038 <mpt3sas_ioc_list>
>   },
>   ...
>   name = "mpt3sas_cm0\000\000\000\000\000\000\000\
>   ...
>   remove_host = 1 '\001',
>   ...
>   request_sz = 128,
>   request = 0x0,
>   ...
>   sense = 0x0,
>
> The SCSI queuecommand handlers(scsih_qcmd) may be invoked after
> shutdown/unload, depending on other components. So we should add
> checks for 'ioc->remove_host' in scsih_qcmd, so not to access
> pointers/resources potentially freed in the PCI shutdown/module
> unload path.
>
> Just like the following commit:
>   9ff549ffb4fb4cc9a4b24d1de9dc3e68287797c4
>   scsi: mpt3sas: fix oops in error handlers after shutdown/unload
>
> Signed-off-by: Fengfei Xi <xi.fengfei@h3c.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index b519f4b59..d8994eaec 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -5140,7 +5140,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>                 scsi_print_command(scmd);
>
>         sas_device_priv_data = scmd->device->hostdata;
> -       if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
> +       if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
> +           ioc->remove_host) {
>                 scmd->result = DID_NO_CONNECT << 16;
>                 scsi_done(scmd);
>                 return 0;
> --
> 2.17.1
>

--000000000000bb58cc05e49e5058
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKwIbWjfUA54hsb9XXfh
uCPGnlVumN0f7LcB0+nMpa4vMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyNTEwMDQ1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBnAvcB849JgeSocLxo8oLLHWR8D0o7spFrDJS4
icMvUMS6tYlnV6kZitEA9WQjsYs69R7PBYu/lfJBOOvVut2Xv+7uWq41oYVKRJaMTdEBKuy16BhC
mzstBlgMSk5OjMVVzKHVDfqzeC1oGi1RajB3FuHfzXji23NFeWyoGJ6ODxWcMlRrNCaN5zzjNhXG
jnIjoH9E5rXDb3dkzgew+kqUCGTlwDKPYmnASRKIzMpR53HK6L//OjelausOeqcrBimc9/BrV3mF
S2bzh8FHHz7ResJZ+oXLbtP1wP1hsOPSTwe/GRCvo1YUoo+3KATvzD1PDWu39w9VM0X5+4n1Acpg
--000000000000bb58cc05e49e5058--
