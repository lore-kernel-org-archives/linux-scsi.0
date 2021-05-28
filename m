Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28130C47087
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 21:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB24C6135C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 21:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhE1VvL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 17:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhE1VvK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 17:51:10 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E570C061574
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 14:49:35 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x18so4221195pfi.9
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 14:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=scoxAMM1P2uhqhvf3Y2UXIutQPJLBJand6Q8b3hTPJ8=;
        b=JRxoTvzk+F9SpsCGcRNXYWmZXt2+7sqAgCrb7EvYrMO1I21DaHvIPq24H4hXEuM0Fq
         TKhzsIslaysPU/AwlFUniG75oevk3gaOd9/EJLb5yQJiKdCA9sK/aH7XWpyRW2ipzM/G
         FE1zzyPp9o0OITe0dfzg50WxF2vqBc5J3dRFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=scoxAMM1P2uhqhvf3Y2UXIutQPJLBJand6Q8b3hTPJ8=;
        b=XKGglGof2ACyw33cTFNwcBJAQg0a91MSv5LrMp1QrFxEAQVwQSTXIBi75OcBLoTZGI
         MtWLB7KW+8LjMzlLJA6rJq2L9qm68LtftHAJYHEHlsPb+VOe1W1azrIEoNLBbS96bMLS
         01x48xl4J6FseM1ZuaK830oWZLQi+pjPKxmFJ5wprtknFAKW5L4w2HOeJQY3BGd8ulk7
         qFBznys6HSkI1j5fG5CoYoa+2CLPGXb4DxfQRn3dYPgoIrP9eQYkpxPIDcK75yrKfq9h
         O5Nhm0/BvasQc+1TBUB+xiUgbakLJNQKQLLniQQSFOAPxLBFAdTWUyoKW6hVG+NKPkr0
         QG4w==
X-Gm-Message-State: AOAM53027iCC/fy5cPwLmQgcbwHYkHuf7E4Y5IyGZJ4mFZwSUQvl3FGI
        sexfXpU/8JA1gdhd7FiVRxLWmG+DavYEDBrPNDnqhs3bW9vuigrY5AQft0RXcrMeXSL+z1w8agD
        a5PWQ20P5GVT1
X-Google-Smtp-Source: ABdhPJwlba5DzI4zgvP9fd8dj6DgfvdHuDbCQIc4At8S+N1r/cQ8Y+rsfoGN9I7Srif/KncQ1JBJbg==
X-Received: by 2002:a63:5f55:: with SMTP id t82mr11149917pgb.453.1622238574408;
        Fri, 28 May 2021 14:49:34 -0700 (PDT)
Received: from [10.69.69.102] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u21sm4962937pfm.89.2021.05.28.14.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 14:49:33 -0700 (PDT)
Subject: scsi_transport_fc: FPIN LI statistics
To:     Nilesh Javali <njavali@marvell.com>,
        Shyam Sundar <ssundar@marvell.com>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20201021092715.22669-1-njavali@marvell.com>
 <20201021092715.22669-4-njavali@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <b472606d-e67c-66f1-06d1-ecc5fbb2071a@broadcom.com>
Date:   Fri, 28 May 2021 14:49:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20201021092715.22669-4-njavali@marvell.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fff59e05c36ad9a1"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000fff59e05c36ad9a1
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Nilesh, Shyam,

I'm looking at commit 3dcfe0de5a97.=C2=A0 When we increment stats, we are=
=20
incrementing by the event_count:
> +static void
> +fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +		   struct fc_fpin_stats *stats)
> +{
> +	stats->li +=3D be32_to_cpu(li_desc->event_count);
> +	switch (be16_to_cpu(li_desc->event_type)) {
> +	case FPIN_LI_UNKNOWN:
> +		stats->li_failure_unknown +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LINK_FAILURE:
> +		stats->li_link_failure_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LOSS_OF_SYNC:
> +		stats->li_loss_of_sync_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LOSS_OF_SIG:
> +		stats->li_loss_of_signals_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_PRIM_SEQ_ERR:
> +		stats->li_prim_seq_err_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_INVALID_TX_WD:
> +		stats->li_invalid_tx_word_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_INVALID_CRC:
> +		stats->li_invalid_crc_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_DEVICE_SPEC:
> +		stats->li_device_specific +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	}
> +}

I'm wondering if this is really what we want.=C2=A0=C2=A0 Event_count is th=
e=20
minimum # of events that must occur before an FPIN is sent.=C2=A0 Thus, its=
=20
not the actual number of events, and could be significantly off (low).=C2=
=A0=C2=A0=20
Are we ok with that ?=C2=A0 Do we set the wrong impression with the user=20
(here's a count, but its not necessary accurate) ? =C2=A0=C2=A0 Would it be=
 better=20
to simply count the # of FPINs (increment by 1 each time) ?

-- james


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

--000000000000fff59e05c36ad9a1
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILBCWVyXvQnCOe9tOVovsxY+LMUzFRNhc/3M
WaOfH3PIMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDUyODIx
NDkzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQAqbRRkssPzziXuJXYkLdHFS5mWcV+FawkJm2i2i+OhWd4ImNQXWTDn
WAdO6bhei26KXszVO0qLFC6UQRIj5dHJSPY/0O/e1frCiQlzO5Tq35xppj7XAi1ANx5bI+w1uIuN
O2DMWWjkFB0EpgrasStUzSIFqmS1wh1NQ+lftpuiZYsFxadBfpy2dFTfl4QVzyN75bBpGOAV0LxU
Em4KaUO791RKTCYOeGTOMxE6BbEV/DeicrkTMXIGLULQt4szSHyY6TQ0lp/1Ccws+SqheP2/y8jT
5AyMUXbZ5mzrhs7+B21mUkG4ZFyMaG6c0sEbH0YXQTuewjPKqt1M76T0XVI8
--000000000000fff59e05c36ad9a1--
