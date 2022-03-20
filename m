Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC84C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 13:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245172AbiCTNbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Mar 2022 09:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiCTNbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Mar 2022 09:31:35 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BABA4D264
        for <linux-scsi@vger.kernel.org>; Sun, 20 Mar 2022 06:30:12 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id l24-20020a4a8558000000b00320d5a1f938so16227138ooh.8
        for <linux-scsi@vger.kernel.org>; Sun, 20 Mar 2022 06:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6mn921uW65szcwv7WcLRJHGvgxD3RlRwXhaZppOycRM=;
        b=D7OjyZMcugY+FJNqeHJUBB3Y2RV7PO+91szq724UeYPSN06uMTTmqZBB2dyUsM24zM
         2UCub13lriLOvqGlyqpNoLbNLFAMlpI+he+bcQv9mzr+NCEDs9uMpYqKg//vyvyezA3G
         fLRGioyJJVsx3YphraAI6tTv0O6hKpheRrssM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6mn921uW65szcwv7WcLRJHGvgxD3RlRwXhaZppOycRM=;
        b=0InriJIfq7gT0+LxZBHOxbqGo6J5m+D2IXCxDQpKdBUhKNFxhPZXyDO+Bafc1WpVdl
         sD3t4+Q9ws/FqccN3vFDmySoslelGjxSSr06iayLM5dIGiGKvYCU+OcWh6Y3ja2KWHMj
         n44D/4lDeWABU0+caacpHFu25qfPpvjaJblgF4jh2pkfxOn0+uSedEHhmhrLG3bIQKen
         IJFgHIqIT0OnLzYa1mq65bTAx77WxvA1X1XWM509FYij1Mv9CuCnvz7bN+yHyxwNWPSs
         NL7sJb8Oh66lpcNJ09RRepKKmzo/dZEZ6AW2Bps803hjH6W/gtGiMxVUKocs5bX1QwPZ
         94sg==
X-Gm-Message-State: AOAM530S+d75mfYWsNp98yebFmWIAypKTletfr0cwHa4Fto/o0pCmsWf
        XSy+B2Asntw3XDvFQC5YyNOz9PxO8Rhjq74T4HFldg==
X-Google-Smtp-Source: ABdhPJxOeKFjivqgDCK8ooEZWKzMFmInfat3EYd+Mu/7/WgJAmD3cPDZwhnOqEvoJaa5Ozxwqo5NcbzswQ1gTfUsI4I=
X-Received: by 2002:a4a:de16:0:b0:321:3be1:803e with SMTP id
 y22-20020a4ade16000000b003213be1803emr5319571oot.71.1647783011316; Sun, 20
 Mar 2022 06:30:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220316031521.422488-1-damien.lemoal@opensource.wdc.com> <7164859f-fbf8-8e54-3c08-a40e31d7c231@opensource.wdc.com>
In-Reply-To: <7164859f-fbf8-8e54-3c08-a40e31d7c231@opensource.wdc.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Sun, 20 Mar 2022 18:59:59 +0530
Message-ID: <CAK=zhgqrxEW1chA0rzftFd2F29NmjNVQQ9EiapT8J2up0YOdkg@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix use after free in _scsih_expander_node_remove()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000017d54305daa661a5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000017d54305daa661a5
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 18, 2022 at 11:21 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 3/16/22 12:15, Damien Le Moal wrote:
> > The function mpt3sas_transport_port_remove() called in
> > _scsih_expander_node_remove() frees the port field of the sas_expander
> > structure, leading to the following use-after-free spat from Kasan when
> > the ioc_info() call following that function is executed (e.g. when doing
> > rmmod of the driver module):
> >
> > [ 3479.371167] ==================================================================
> > [ 3479.378496] BUG: KASAN: use-after-free in _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> > [ 3479.386936] Read of size 1 at addr ffff8881c037691c by task rmmod/1531
> > [ 3479.393524]
> > [ 3479.395035] CPU: 18 PID: 1531 Comm: rmmod Not tainted 5.17.0-rc8+ #1436
> > [ 3479.401712] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.1 06/02/2021
> > [ 3479.409263] Call Trace:
> > [ 3479.411743]  <TASK>
> > [ 3479.413875]  dump_stack_lvl+0x45/0x59
> > [ 3479.417582]  print_address_description.constprop.0+0x1f/0x120
> > [ 3479.423389]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> > [ 3479.429469]  kasan_report.cold+0x83/0xdf
> > [ 3479.433438]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> > [ 3479.439514]  _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> > [ 3479.445411]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
> > [ 3479.452032]  scsih_remove+0x525/0xc90 [mpt3sas]
> > [ 3479.458212]  ? mpt3sas_expander_remove+0x1d0/0x1d0 [mpt3sas]
> > [ 3479.465529]  ? down_write+0xde/0x150
> > [ 3479.470746]  ? up_write+0x14d/0x460
> > [ 3479.475840]  ? kernfs_find_ns+0x137/0x310
> > [ 3479.481438]  pci_device_remove+0x65/0x110
> > [ 3479.487013]  __device_release_driver+0x316/0x680
> > [ 3479.493180]  driver_detach+0x1ec/0x2d0
> > [ 3479.498499]  bus_remove_driver+0xe7/0x2d0
> > [ 3479.504081]  pci_unregister_driver+0x26/0x250
> > [ 3479.510033]  _mpt3sas_exit+0x2b/0x6cf [mpt3sas]
> > [ 3479.516144]  __x64_sys_delete_module+0x2fd/0x510
> > [ 3479.522315]  ? free_module+0xaa0/0xaa0
> > [ 3479.527593]  ? __cond_resched+0x1c/0x90
> > [ 3479.532951]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
> > [ 3479.539607]  ? syscall_enter_from_user_mode+0x21/0x70
> > [ 3479.546161]  ? trace_hardirqs_on+0x1c/0x110
> > [ 3479.551828]  do_syscall_64+0x35/0x80
> > [ 3479.556884]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [ 3479.563402] RIP: 0033:0x7f1fc482483b
> > ...
> > [ 3479.943087] ==================================================================
> >
> > Fix this by reversing the calls to ioc_info() and
> > mpt3sas_transport_port_remove().
> >
> > Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address & portID")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>> ---
> >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > index 00792767c620..a3a898262f2d 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -11055,15 +11055,15 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
> >                           mpt3sas_port->hba_port);
> >       }
> >
> > -     mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
> > -         sas_expander->sas_address_parent, sas_expander->port);
> > -
> >       ioc_info(ioc,
> >           "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
> >           sas_expander->handle, (unsigned long long)
> >           sas_expander->sas_address,
> >           sas_expander->port->port_id);
> >
> > +     mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
> > +         sas_expander->sas_address_parent, sas_expander->port);
> > +

Damien,

Can we save the port_id to a local variable and use it while printking
the "expander_remove" message? In older issue logs, in some cases we
have observed that device removal at SML get's stuck. So, it will be
easy to identify/debug whether device removal got stuck at the SML or
not if we have a "expander_remove" print message after calling the
mpt3sas_transport_port_remove() (i.e. after device is successfully
unregistered at the SML).

Thanks,
Sreekanth

> >       spin_lock_irqsave(&ioc->sas_node_lock, flags);
> >       list_del(&sas_expander->list);
> >       spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
>
>
> Broadcom team,
>
> Please review !
>
>
> --
> Damien Le Moal
> Western Digital Research

--00000000000017d54305daa661a5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQdgYJKoZIhvcNAQcCoIIQZzCCEGMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3NMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVUwggQ9oAMCAQICDHJ6qvXSR4uS891jDjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMzAyMTFaFw0yMjA5MTUxMTUxNTZaMIGU
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD1NyZWVrYW50aCBSZWRkeTErMCkGCSqGSIb3
DQEJARYcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAM11a0WXhMRf+z55FvPxVs60RyUZmrtnJOnUab8zTrgbomymXdRB6/75SvK5zuoS
vqbhMdvYrRV5ratysbeHnjsfDV+GJzHuvcv9KuCzInOX8G3rXAa0Ow/iodgTPuiGxulzqKO85XKn
bwqwW9vNSVVW+q/zGg4hpJr4GCywE9qkW7qSYva67acR6vw3nrl2OZpwPjoYDRgUI8QRLxItAgyi
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIGFaM91O2zdPLet8ZZN
7BiRLSYVS/VbjEyg6ujCOqaaMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDMyMDEzMzAxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBIoUDrHWearNbD1npxG+YZNQLyXJ3tw8ma2wjv
pXdXsQH4yklDlNPtSsvj/91Oy5696z1Q1x0bksfXeufqi7XvOLJU3BD1/3SxfSTDDcAuog8w5ZJG
dIijLSWNAr33yyTpwotZA/O1DrfQa15AUOuAj4UU9vV2JRpGg1tQacpcwnvwQYwG4PBGCvV1H1zc
S2zPOBRQFw1ZkECSSpEotRp+WvvftD+swOKDNkFfQ/ljoS0RLACZt1EtlLNvi+Ly5xXGgVIN2eIh
+bo8Q70+HRREUCWV0+kr7Rxq0EokXKB1TfF+6VqBh2CAaF+83ZvgJjYonq8+kBGOC0y6A6EblY/I
--00000000000017d54305daa661a5--
