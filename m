Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05557C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 16:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D356D61185
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 16:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhFHQZj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 12:25:39 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:33732 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhFHQZi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 12:25:38 -0400
Received: by mail-pj1-f54.google.com with SMTP id k22-20020a17090aef16b0290163512accedso2065345pjz.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jun 2021 09:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=P5dOXHsb9BAY0WGdY4eBnCLUl3mYfxLRGw8UvehP4+E=;
        b=gLY3vBMdEhseIxOtbIgyq3+s9pRQ7ZNnnZiOpltKql5gMKTFPCugMRpByqqmDg2cmm
         pM4wpQ87yubIwa/ltDMB7SLNCDVS5KNZ1HJB4dR5w1aSZ1xHiLPVYJ50GddJ8TLGxS6o
         NirOJtHG6p04w16Y+JtNj0JEs36aRlZQjvujg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=P5dOXHsb9BAY0WGdY4eBnCLUl3mYfxLRGw8UvehP4+E=;
        b=QbrjkjDEzUtFV9VSwL7pY9yLJ7jBneAPZhIxRk+dWkXwkmZvnUhpjg4gENi3jbAyte
         VEBlGoDC+fyumnpgAzOl0ESZK8D5qROHo16OqgoEulNo/NaS40aujMF/aYXU3l8oMCIA
         nlb2QbVTNYxE/ce82iFGV80IoXuG8MYoj1p+DMzn57kyCM8owD378nRQnQIU5WZ3wo57
         Dm8KPMgANm26YK1Kk53MPHZpEyf9oa4R1hUbNHS3tATTp9nPuNZRoxg4HoxarsXnWDiX
         77uHXRZULQIHUWDlbfGeIASK0vGcnqx9pOb5LUuMUqyzvkPocLKMH6RI1ndIEqcOAo3v
         CzHw==
X-Gm-Message-State: AOAM533iBzipL0Uqtkmav4qcvubwpvG5dus6h0VVkXNNCedB6hyuyqR5
        JVsY2mJwHQT+PUWX1MZaoJYD6fI+mWqdh1Ucevu7eRh1vUfXn8uQeZPO3b/1HxrT4DCjpbe8YvP
        EELJE5e8poG/v
X-Google-Smtp-Source: ABdhPJwYsgsahnZ3pWQ0o6mgM81uy5t2QPvMXtHLNown2S36MKgo1Tqv0T3zuw1BiYsfSshZ0sumgA==
X-Received: by 2002:a17:902:d48e:b029:108:cd42:f914 with SMTP id c14-20020a170902d48eb0290108cd42f914mr420258plg.7.1623169365609;
        Tue, 08 Jun 2021 09:22:45 -0700 (PDT)
Received: from [192.168.0.217] (ip98-167-23-218.lv.lv.cox.net. [98.167.23.218])
        by smtp.gmail.com with ESMTPSA id o9sm12136791pfh.217.2021.06.08.09.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 09:22:44 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: lpfc_mem: Removed unnecessary 'return'
To:     lijian_8010a29@163.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
References: <20210608060422.256554-1-lijian_8010a29@163.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <022cff51-db32-1da4-1e42-ecae09e313f2@broadcom.com>
Date:   Tue, 8 Jun 2021 09:22:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608060422.256554-1-lijian_8010a29@163.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007878bd05c443915e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000007878bd05c443915e
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Language: en-US



On 6/7/2021 11:04 PM, lijian_8010a29@163.com wrote:
> From: lijian <lijian@yulong.com>
>
> Removed unnecessary 'return'.
>
> Signed-off-by: lijian <lijian@yulong.com>
> ---
>   drivers/scsi/lpfc/lpfc_mem.c | 7 -------
>   1 file changed, 7 deletions(-)
>
>

Looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


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

--0000000000007878bd05c443915e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
PXdbw8NJD55W/TyL5SqwLhkniLbboSA3j8lnH2Irpzm5VWjULsVCgV6+584AQ7cIYxFuSU2iy9oC
VOMV1KZcfEMa2w69xAPeGaT4svn9q4PyT7nKiygbAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU38f2heZreKHlV6siVOSG/emDAbMw
DQYJKoZIhvcNAQELBQADggEBAFxOL7NTWX6Z3GGXKqmCIS7A9MeBSusGyxInLdVymGQsxEItQhHo
JsU6Nck6c8X77/ebCikLmw87STnywRJNGxUVRhcN/1p7Qyf246oxhG31fcVeSx/fEWzAbSrNTkLf
eAGDDdAlZdLD7C1DWW8Z4wYkkoAlQ/HX7/pShjmuT6UK3gkc7SxbWT0w3vpBYP0sbj0I+pdeNFBm
9mc9+qMcR1bhq+sAyYmBebwsAuCKTT1oY7Pfq1981wGcENAbCE/M0QL+PJwLYcM4UONNVqIfX6VL
rosksbNQhwjUlEcPdVzlzWQjhia2Gl3yjSb8HBLcnu4rh0oVjIP3NfBsRUkBYCYxggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwooxvJJXw5eyVAy38wDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILEY/r+17jxdq+FViqRFEiGUiLHHaP9oxpZz
5qB50IXrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDYwODE2
MjI0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQBGpK0wjzQQs5x0JqFNdiNPpXcm299V9XSRc6er1bxaqfvP3rxld0P4
LX7qeZpba24uUtyb5QC1iz7ElFzdEo06Dbs432wbBPzCkn5Ty4PEgdv/o1npGerJWY4ZRVWmomNI
ZjeSme9jA5xDGSX+WKefL8qJxDB/f7kr8e1aTZh1ejbcK0cfF/FRLI3RvHvR5IzJ46KC921pk21P
qrBN3YI3gQAkxjaociESJaJJ6bbJtzShVrRxbK3mHJqn/IdGOnbhe0xfl5fbj6IcCVbp++ZfSl+K
lJwDKVXTCy8rr/75cMSa5PkUD6GOLIeL8aeOFDD5quHfDeE9cfMFkRb491JD
--0000000000007878bd05c443915e--
