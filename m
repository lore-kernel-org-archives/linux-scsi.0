Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E2CC04A94
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 17:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjG0Rxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjG0Rxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 13:53:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5322118
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 10:53:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3175f17a7baso1333366f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 10:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1690480413; x=1691085213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ce8Q6WUY/OmIsE/WZII+NP3CPm3VOrSyRhj4D4WRswA=;
        b=YpbZLevFq5BjBe5GY03IWAS41WWoNj852ft1YuzB9dvudZAOO+nvuvinSzoLdIZ2Xu
         RrGD/f1ktL0evbzWu6iyt7Xj0ZK7EJAOX2FtvxXN5Yv49DVIALV/Ofn+tiEXDG85LbOt
         IiUiv/FHJo5Y/Juiuk3nXEsbyl94bTeEyPmeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690480413; x=1691085213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ce8Q6WUY/OmIsE/WZII+NP3CPm3VOrSyRhj4D4WRswA=;
        b=RQqb/9a1g1VGfhKJjfrpp7i4JVlpzufxvPC3lHuApLnkLvhhUm5zqy2a86i423+LMk
         dA69pJsiqvnH/S6JalwRtjlJDma2ubqLgQt4WoZzrAd6vRDpMW6BOuGyKgXbI+M/yfRc
         ZxCBikBZZSTzZJWzfGt3ByZ7YMrMm8SR8ePm7+d5sDseSGz/eLfvF8kxZeVZL0AjPuKn
         MARtG2mUbrHkts6WfKdfeQrEeV8ennixTY+wSdwNB1BszLkq2k6GmY3T7bTSS977u0+7
         hoaVJocYhaJvwi+XTE4J4wgSRT1+G+/Rc+5/O8sZQUvOPD/BBlH1n/TfNpZRsYzRu8BB
         k8eQ==
X-Gm-Message-State: ABy/qLbO5NFotKpsDUyMGNrXcDtEu+bjyMSFgqccer1VBKHXk7xEbor9
        4hDJOdCadWcMfY41M1O9dU3RaI4Ec5/ELHOydjtP7UyK4Z7JFtByHaODwHEa/OTvUa3C1M0NWwB
        EG6dFE9B5xfiy/Qna71X7x3Goope9
X-Google-Smtp-Source: APBJJlE7fevlrQD6mEBmgc2PJ7EuaostP8Ot6bIiY31rJj6+l/rIDHF+kuwQnRdjaG8cqC0ZdEaV1/iDkiaHct0eVow=
X-Received: by 2002:a5d:4942:0:b0:314:d19:fc31 with SMTP id
 r2-20020a5d4942000000b003140d19fc31mr2204585wrs.51.1690480413442; Thu, 27 Jul
 2023 10:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230726155342.51623-1-dg573847474@gmail.com> <CAAmqgVOZwYS_TintuQNrE0go_Mxwk3YFJZA41Yt2S2isD7JW_Q@mail.gmail.com>
 <CAAo+4rWOgZvOtUk4_mGALcZOsKObPhvnkbNMG62sM5=qdHduLQ@mail.gmail.com>
In-Reply-To: <CAAo+4rWOgZvOtUk4_mGALcZOsKObPhvnkbNMG62sM5=qdHduLQ@mail.gmail.com>
From:   Justin Tee <justin.tee@broadcom.com>
Date:   Thu, 27 Jul 2023 10:53:21 -0700
Message-ID: <CAAmqgVM6HDtWAex4WkNqWRKQRag3EAHPPgk5HC1wzFg4Ae6gkQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix potential deadlock on &phba->hbalock
To:     Chengfeng Ye <dg573847474@gmail.com>
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000928d7f06017ba4de"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000928d7f06017ba4de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Chengfeng,

That=E2=80=99s still a unlikely scenario:

        /* Check device state for handling interrupt */
        if (unlikely(lpfc_intr_state_check(phba))) {
                /* Check again for link_state with lock held */
                spin_lock_irqsave(&phba->hbalock, iflag);
                if (phba->link_state < LPFC_LINK_DOWN)
                        /* Flush, clear interrupt, and rearm the EQ */
                        lpfc_sli4_eqcq_flush(phba, fpeq);
                spin_unlock_irqrestore(&phba->hbalock, iflag);
                return IRQ_NONE;
        }

In order to enter that if statement and obtain the hbalock, the PCI
channel has to be offline or the HBA=E2=80=99s link is in not in an
initialized state.  If either of those were true, lpfc_cmpl_els_uvem
would never get called to begin with.

Thanks,
Justin


On Wed, Jul 26, 2023 at 10:40=E2=80=AFPM Chengfeng Ye <dg573847474@gmail.co=
m> wrote:
>
> Hi Justin,
>
> Thanks much for the reply,  it is my negligence of not have noticed it,
> and sorry for this.
>
> I inspect the bug report of my tool again and just find that actually
> lpfc_sli4_intr_handler() also acquires that lock.
>
> lpfc_sli4_intr_handler()
>     -> lpfc_sli4_hba_intr_handler()
>     -> spin_lock_irqsave(&phba->hbalock, iflag);
>
> It seems like this isr is called on an SLI4 type HBA. If consider this
> one could it be a deadlock problem?
>
> Thanks again,
> Chengfeng

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

--000000000000928d7f06017ba4de
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQZwYJKoZIhvcNAQcCoIIQWDCCEFQCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2+MIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
XzCCBUYwggQuoAMCAQICDAx3oGwxIEOxqBUW1jANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTAwNDVaFw0yNTA5MTAwOTAwNDVaMIGK
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xEzARBgNVBAMTCkp1c3RpbiBUZWUxJjAkBgkqhkiG9w0BCQEW
F2p1c3Rpbi50ZWVAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
1FcD8UCLr1YJvSijoRgBcjkrFpoHEJ5E6Cs2+JbaWnNDm2jAQzRe31aRiIj+dS2Txzq22qODcTHv
a67nFYHohW7NbgVOxh5G3h55d4aCwK7NvAGjHFcvNdZ9ECpMOpvGg0Pz/nQVVmU/K6mAGkdtF674
niejyV/sWPwqdts/jpWYEN5/h0shrmgChGnWlAarY2gO018avJp8oVJLbMZ7A4gvs76YPXJYhCha
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
AWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOMpIBBGzNHuBiv23fQbIADDYEIuDd7ySR+q67dj
jQgVMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDcyNzE3NTMz
M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkq
hkiG9w0BAQEFAASCAQBd+bP61joL8alCNSm/IdaI7Mf7cdKKzN8UMmtUhTrDapSPpAqDRzHaXGNu
9nLxL+RqWbSOYvRPUYy/8Uur8hu38dylmwK4bIojZabM5McNm3YOk6JwssYBoW5srif+5gdVDjGY
l3gk89PvzCHCuLHQbrt+Mj3ZC/JXRDbSGMTPWu7lEf1H+mE7WO99F1nwjJLVKFBIaphjvACMw1X1
e1d6h+ZuJwPdKtMNst1cgtp6a1MtFunhHoxYB0jRtzYS79iYWAZSoqAnFATUDEdnPIsoZajQIajl
bAsbbvIsGOZoTgRJ2iiI2ru4z39RMdOYJaa/qm9JIVlTaYB2JkocXL61
--000000000000928d7f06017ba4de--
