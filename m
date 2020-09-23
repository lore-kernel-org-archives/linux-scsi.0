Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDF4C4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E532085B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="h50yZKfe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgIWAQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 20:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgIWAQB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 20:16:01 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59917C061755
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 17:16:01 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k133so8503639pgc.7
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 17:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=R/edugTFyx8VkZ4bEmTNtFm+liJwmpZPAdCt00EFRaA=;
        b=h50yZKfecrWCp7cXyRtzSEngolYuNBsNUc8JaY9CkdXt2S3n7y6pipPE28CsR7vxAq
         qRCK2xaoNL2l0EnQAbDC1M5qNccTrdBJpLXo8kguLf91NLgHgSsVuTySmsJz7GEkameN
         F6G2FjXcH5Pb+eoNMazqQURsSV3A+X4GKTwiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=R/edugTFyx8VkZ4bEmTNtFm+liJwmpZPAdCt00EFRaA=;
        b=dOa0X630qhECGX67pRw1trXI8YA4OCqgLIl+Jaer2C2KnCgaumG1FqTKmXHEtcxbiN
         ja16uZFRM2xPQkrtcacLZgw7yZJR/b76HKZYjVMk+XqVpOn2gAMo3hN1Y3nHuinsVJid
         MXgLkrLMqk3DXjHsfrP5exPzk5YCzBMzvfJ8mYj0pm0E+2x2EtdfpSbdf2xkEQSZf/08
         FsPzwb9SO52qvLATL3WdGSVEwty81zHdcWAVKynifYgktHcUCnRRbZGzvWyFTaupOzL5
         WMmhrHdCezLpyfoEtFd0O4bx2P2fLVk8pUW9gN5oGXV/T0NfLuojgRzKDi7ZlcxLd8Yy
         QWGw==
X-Gm-Message-State: AOAM532yqmsJogccGRhnZHFYO7EQlF7MzQb0rblFIp7iEwbdU9y0zT8R
        8fbd/STUJFWJKjDDawH8Hd7hXA==
X-Google-Smtp-Source: ABdhPJxsPxIiudnpfCbvaGl0B5+mDjrLuYPubbAvH2NQ0iMSqo19p1hLgLXeuYZA3WqAkHHyDXiTsA==
X-Received: by 2002:aa7:99c7:0:b029:13e:d13d:a056 with SMTP id v7-20020aa799c70000b029013ed13da056mr6319165pfi.28.1600820160463;
        Tue, 22 Sep 2020 17:16:00 -0700 (PDT)
Received: from [10.69.69.102] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x3sm15715900pgg.54.2020.09.22.17.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 17:15:59 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: fc: Update documentation of sysfs nodes for
 FPIN stats
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200730061116.20111-1-njavali@marvell.com>
 <20200730061116.20111-3-njavali@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <6650af6f-fda9-e2fc-2543-9911f83b5598@broadcom.com>
Date:   Tue, 22 Sep 2020 17:15:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200730061116.20111-3-njavali@marvell.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000b23b205afeffd65"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000b23b205afeffd65
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US



On 7/29/2020 11:11 PM, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
>
> Update documentation for sysfs nodes within,
>         /sys/class/fc_host
>         /sys/class/fc_remote_ports
>
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   Documentation/ABI/testing/sysfs-class-fc_host | 23 +++++++++++++++++++
>   .../ABI/testing/sysfs-class-fc_remote_ports   | 23 +++++++++++++++++++
>   2 files changed, 46 insertions(+)
>   create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
>   create mode 100644 Documentation/ABI/testing/sysfs-class-fc_remote_ports
>
> diff --git a/Documentation/ABI/testing/sysfs-class-fc_host b/Documentation/ABI/testing/sysfs-class-fc_host
> new file mode 100644
> index 000000000000..a1e6ab89b86f
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fc_host
> @@ -0,0 +1,23 @@
> +What:		/sys/class/fc_host/hostX/statistics/fpin_cn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance Impact
> +		Notification (FPIN) events generated by the fabric, to indicate
> +		congestion detected on this host.
> +
> +What:		/sys/class/fc_host/hostX/statistics/fpin_li_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance Impact
> +		Notification (FPIN) events generated by the fabric, to indicate
> +		Link Integrity errors between the fabric and this host.
> +
> +What:		/sys/class/fc_host/hostX/statistics/fpin_dn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance Impact
> +		Notification (FPIN) events generated by the fabric, to indicate
> +		Delivery related errors between the fabric and this host.
> diff --git a/Documentation/ABI/testing/sysfs-class-fc_remote_ports b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
> new file mode 100644
> index 000000000000..185db8ec6c05
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
> @@ -0,0 +1,23 @@
> +What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_cn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance Impact
> +		Notification (FPIN) events generated by the fabric, to indicate
> +		congestion detected on this rport.
> +
> +What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_li_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance Impact
> +		Notification (FPIN) events generated by the fabric, to indicate
> +		Link Integrity errors between the fabric and this rport.
> +
> +What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_dn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance Impact
> +		Notification (FPIN) events generated by the fabric, to indicate
> +		Delivery related errors between the fabric and this rport.

Can you rework these a little. As it's written, it's implying that it's 
counting the FPINs, when it's really summing the number of integrity 
events reported by FPINs.  The number of events may not be the total 
number as it may have had to reach a threshold within a time window in 
order to have an FPIN generated.

-- james



--0000000000000b23b205afeffd65
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgy/pw+Ib1OqhHYfNY
0Qka3pZJW/7syJT0AFVvNqjBp7wwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAwOTIzMDAxNjAwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAI6s1N/SbYOhfS8+cCSWjTS8xBkVy77ZnaRY
kOM1Wut3EKLbhWjNjNm/7CznoOenVpIyCxORv2bLgwRNS+3cbc0SRpRRfbqWddLFLASJcLowVG4o
+M+cHlopzbdJA6CqWJrjASq3mKZNJ7yuXpNYGfTYV2PYvi7sNg2F686k5imW/6uVUtNDpCKWH5m7
xxYvO8arbd+M0z1Uize916KhzwNxkjkGOE4KDOVR2jMytZCQRBQGRTm+nSYv6sEg+tWcVd6OMtlw
U0syf37+OvIEx44I9LVuh0Gma/gfWTTyeVbLPsNJ+fm/Uiq7erVpHSAUPfxtVn8jIZoUyTC9APR7
WpA=
--0000000000000b23b205afeffd65--
