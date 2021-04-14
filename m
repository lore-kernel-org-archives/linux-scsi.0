Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D203C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 11:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3697961154
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 11:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350554AbhDNLdD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 07:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350557AbhDNLdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 07:33:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88EDC061574
        for <linux-scsi@vger.kernel.org>; Wed, 14 Apr 2021 04:32:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u11so6462574pjr.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Apr 2021 04:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=abd9Ib3pKszbZKtiVG/zzKfpqa3DRQAEjJWBS/57Y74=;
        b=MtklJqAw8VsuqD6a43pkpdkLyf2qBC8C9udDBtATU2U+L3EGhKmTPJ6zUJ6JhQ47PF
         ImzQ50GgCKXxYdzES+JfQshvhK8mr5cmk6VAQWNz6tP924HQJdIMl5x7XzzlYN3grfUs
         yFXpAoww6G/WvTR83ROmgVfMT+LoR2ohc50sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=abd9Ib3pKszbZKtiVG/zzKfpqa3DRQAEjJWBS/57Y74=;
        b=tkYtiATp9EZZMeLAhvljJCdguozmmdCBUlMq1HsXhdXYpI+A4PYUX0oidaV7p74iP8
         uHgvMLV8R9abvKa4Xf5kMAfjb8dJ32l3RilTXHECuOkCz1jFxuMpE7ZoqOthcjkfHXsH
         Y9NY2K9NHtuOyeG1kjfXr0AzsrJzoYdI+OfJlO7c0KSQlt++GePZixDjr4A9sadNtlst
         D8b6Zp3c9J3Bt4/7j0Fo8lZR13ACwUFnExJidwfgReeRYXKyKlqmeshYKbKY1FOPOD7t
         ywaKTw+geIlv5aWD0SKpJqfW8mG0dWCbgcmRa1WakTJ9OZYIAmy9A3fl3VAN4vZ0+8ep
         ys0g==
X-Gm-Message-State: AOAM531Zmk8VW0f/NE5xVZdYJUIwRsCe6khAsgCqOIdxVCxMCCdmvx7N
        c2Xvj/xgIjr8PXthAOoe2bWQ2kcsghwB5FT5fJUvGA==
X-Google-Smtp-Source: ABdhPJx1/4n62GTXObcJgFW/l0kNu98yw7KgH/IE5uEetAHazMVX7QHimQa8bPi8dakaZfZzlS8cwAaEzMCRIUadMRI=
X-Received: by 2002:a17:90b:3b8c:: with SMTP id pc12mr3188659pjb.208.1618399960224;
 Wed, 14 Apr 2021 04:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210325084247.4136519-1-yuyufen@huawei.com> <fe977858-91a3-51e3-f90e-d2ec878499df@huawei.com>
In-Reply-To: <fe977858-91a3-51e3-f90e-d2ec878499df@huawei.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Wed, 14 Apr 2021 17:02:14 +0530
Message-ID: <CAL2rwxpETcUnzEvUbCft_0ZapAdS+DmJsBFxR7AFvN3LikYjyg@mail.gmail.com>
Subject: Re: [RFC PATCH] scsi: megaraid_sas: set msix index for
 NON_READ_WRITE_LDIO type cmd
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c1bed705bfed1ae8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c1bed705bfed1ae8
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 6, 2021 at 2:33 PM Yufen Yu <yuyufen@huawei.com> wrote:
>
> gentle ping.
> Any suggestion are welcome.
>
> Thanks,
> Yufen
>
>
>
> On 2021/3/25 16:42, Yufen Yu wrote:
> > Before commit 132147d7f620 ("scsi: megaraid_sas: Add support for
> > High IOPS queues"), all interrupt of megaraid_sas is managed when
> > smp_affinity_enable for misx_enable. The mapping between vectors and
> > cpus for a 128 vectors likely:
> >      vector0 maps to cpu0
> >      vector1 maps to cpu1
> >      ...
> > If cpu0 is offline, vector0 cannot handle any io.
> >
> > For now, we have not pointed msix index in megasas_build_ld_nonrw_fusion().
> > The default value of index is '0'. So, cmd like TEST_UNIT_READY will hung
> > forever after cpu0 offline. We can simplely reproduce by:
> >
> >      echo 0 > /sys/devices/system/cpu/cpu0/online
> >      sg_turs /dev/sda # hung
> >
> > After commit 132147d7f620, low_latency_index_start is set as 1 (not sure
> > for all scenario), then vector 0 is not managed. Thus, io issue to vector0
> > can be handled by other cpus after cpu0 offline.
> >
> > Nevertheless, we may also conside to set msix index rather than default 0
> > in megasas_build_ld_nonrw_fusion().

This patch does not seem critical. We don't want to change the
behavior at this point
as this driver supports a lot of old controllers and we cannot risk
breaking any of
the supported controllers. Anyways MSI-x 0 is used for non- IO frames only so
no performance gain too with this change.
Hence, NACK for this patch.
> >
> > Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> > ---
> >   drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 38fc9467c625..ddc6176f12c4 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -3021,6 +3021,8 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
> >               io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
> >               io_request->DevHandle = devHandle;
> >       }
> > +
> > +     megasas_get_msix_index(instance, scmd, cmd, 1);
> >   }
> >
> >   /**
> >

--000000000000c1bed705bfed1ae8
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJgWpOzNZP1PSFkyKqptzQM3oUx5ka+3
UFCCJVQtosltMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQx
NDExMzI0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDBd0HGZPlI1aNKX1PANi5xi6TG3uZ5aT98GQD16hiJCITLL6M3
CRioVaGBMQMEDyuiqmfOoCO/XOe9+8bzMVlf2GQ3jfmUrhIA3ZRHy03xnj+jSaSB+gFw9tDD9mfl
FFab8P/1Bex2N/NaoNlKoWpEQEbjceDBhg02db5I7N1OeJp3EvqqC5veGV7+67FQYDTKuyvrMvmV
2KsERnGFeRHcwqLyI2EIMpXDMKklgRHwnH5mfdNfZI6f54BQNL2VRQya13fyHDaQUxSbYH5t1R9+
EN6QvfPJbsSlRY7QBnUtjumW1kcUQaAkuSsV8slZKyvak6L1kGr8KEHxo1Kirf41
--000000000000c1bed705bfed1ae8--
