Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B44C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 05:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiLMFik (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 00:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiLMFih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 00:38:37 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DBE15FEB
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 21:38:36 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id r15so9759058qvm.6
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 21:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eug0an2KRkG8hSOpYVP0h4Wl+AN65RP8yJhf8Sulz0E=;
        b=R0MJtjaVw0+H1IS+hNVu9GDoT7iAqQswhHfK2LlZ+RIcOyifwseazPh72Eao8n9tGW
         zaN+M9GoJX2MQhsa16W5/kkIfF/zD2kL0ELDPeBTnjynFNmmSq7Nzc+cKqhSCd7rpuR4
         Aloz6OBPdpu6ueyEN0WRqZj44prgv2P49Oxz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eug0an2KRkG8hSOpYVP0h4Wl+AN65RP8yJhf8Sulz0E=;
        b=xgCUaNFFzD7M7MQ6b/XEyPj6K1kol+zm9LuBCLBYfmGTIU1k+dXb/xaxhTRz8xxOgT
         PIjytRVU0wjhJxws/RsTFNj17WjZm0V+/d8EThqSyNJvPIVHOZc8lcUTTkY/Khp6Qz5m
         mDLV8KP18LloJGoNapYwU8gaLzoV+PFFH41N2y4D/KWLzwiHh0fxZZmcYtQ0MvXlJOcg
         h/jwhH6XkUHiumfKjAVllgex+uF6gWia6TG0eF8NoGjcrmaTtfzJEHU8W26h1EtvJ3Pu
         UzJmKsY3bmgaPMiUGEn403pVsySagI8znPk8s99g/+p5xJBjFnu7pLpPUwCVV8K1gTF9
         TK0g==
X-Gm-Message-State: ANoB5pmjW+YZLlXaZZjtHpc+R5ICZbrlurmQgE/+MSzU9iLf2yv+TKPk
        1SuFkr+nzFwmE/d9cIeexOfVv865s1ChRrKSXAYbGKNQRy9IcbVkxt/CA2+91Wga70F7hhpSLD1
        SLWgWeOCbKCnGSQTsyDDlCNsr//g=
X-Google-Smtp-Source: AA0mqf4DPSRZIf6FML2OFrre/4lXXx6dvMXdJZ02YioF+tX89/RbMJYghqToHjJo1ZmwTs4vQRScDoe0jSgzs654g4E=
X-Received: by 2002:a0c:c705:0:b0:4bb:615d:7237 with SMTP id
 w5-20020a0cc705000000b004bb615d7237mr77947893qvi.21.1670909914431; Mon, 12
 Dec 2022 21:38:34 -0800 (PST)
MIME-Version: 1.0
References: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com> <20221213005243.2727877-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20221213005243.2727877-2-shinichiro.kawasaki@wdc.com>
From:   Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date:   Mon, 12 Dec 2022 22:38:17 -0700
Message-ID: <CAFdVvOyyw3Ri8BW3U=vqtyDq6fiBoJVQSqP=2ib6-WAHFaunLA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] scsi: mpi3mr: fix alltgt_info copy size in mpi3mr_get_all_tgt_info
To:     "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ecdbd705efaf072d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ecdbd705efaf072d
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 12, 2022 at 5:52 PM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> The function mpi3mr_get_all_tgt_info calculates size of alltgt_info and
> allocate memory for it. After preparing valid data in alltgt_info, it
> calls sg_copy_from_buffer to copy alltgt_info to job->request_payload,
> specifying length of the payload as copy length. This length is larger
> than the calculated alltgt_info size. It causes memory access to invalid
> address and results in "BUG: KASAN: slab-out-of-bounds". The BUG was
> observed during boot using systems with eHBA-9600. By updating the HBA
> firmware to latest version 8.3.1.0 the BUG was not observed during boot,
> but still observed when command "storcli2 /c0 show" is executed.
>
> Fix the BUG by specifying the calculated alltgt_info size as copy
> length. Also check that the copy destination payload length is larger
> than the copy length.
>
> Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Thanks for the patch, though this code needs a fix, the changes are
not correct and needs modification.
> ---
>  drivers/scsi/mpi3mr/mpi3mr_app.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 9baac224b213..2e35b0fece9c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -322,6 +322,13 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
>
>         kern_entrylen = (num_devices - 1) * sizeof(*devmap_info);
>         size = sizeof(*alltgt_info) + kern_entrylen;
> +
> +       if (size > job->request_payload.payload_len) {
> +               dprint_bsg_err(mrioc, "%s: payload length is too small\n",
> +                              __func__);
> +               return rval;
> +       }
> +
This check is not needed, this is already handled by reducing the size
to be copied to the given payload size
>         alltgt_info = kzalloc(size, GFP_KERNEL);
>         if (!alltgt_info)
>                 return -ENOMEM;
> @@ -358,7 +365,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
>
>         sg_copy_from_buffer(job->request_payload.sg_list,
>                             job->request_payload.sg_cnt,
> -                           alltgt_info, job->request_payload.payload_len);
> +                           alltgt_info, size);
instead of size, this should be min_entry_len+sizeof(u32).
>         rval = 0;
>  out:
>         kfree(alltgt_info);
> --
> 2.37.1
>

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000ecdbd705efaf072d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHOIvm2E
3l3C/8AXYjxFCcfW7q71y3DMK3BdYVQmD9+EMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIyMTIxMzA1MzgzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBIPevqDyP3Jpyp9oOOwd7QRK7n
lq9rzTpzikU/h9xYxA9b4IQ8NchYAD4BezsVc7eZWj21UjEkXZdcQfE1LQaNsTppI8bdDSepcENM
kNUY7l7mSGTdLLz3PyMIOcWL8K8+AxavQI9c3XL5I7QQ1Jd0hDBEjGzXn1+zqYow23NE7ZMbi2Je
Yodu/jMtjqrAvs6hNnu5sPO70kgtO1YBplE8x5HQs+S+jbh71IFuAAeVtxyiflmAQYpBTk6AwFlV
iw21R8eHr2Z7fT1Yb04KJ7wB+imjIzBdYNbm2V4MSpEZPg/6ANy1hs28pgQDq7OtIvM9irYJ+vlE
qtA5m832IqGk
--000000000000ecdbd705efaf072d--
