Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF0C329C74
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325810; cv=none; b=HiyX8fr2HN3euQlXEeGaBa86b82gVQHxDwLSUy2sxMpVluUdEmjY8dAkzShfrBv/iNYlaLmD+LfOGBsygbcmwLGN8G9rPtWS9tzYsUJaHoFxjbuZWMpnVWh9Kcd9VrWLVKLmbnZR/zRuacpSLthB+dk6h9LEdnPchc4LyjtxWdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325810; c=relaxed/simple;
	bh=y3JVCu0i9q4GqHC0zxMR3amHic/ht6PmCBNHooabbe8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZfaUqBM7CFrigE0m4yt2hhF8RWaICHxiLu7YLfa66FWsVTQsgHnZig8QLviv3BH3bqM8bQrMFbE+N6X0/YKzvQJwmFP8o4tDvhnCfZZBTi+EIBifRs5icEhuPCcG/hG5D+R/YTNLnqC70z3Sfjo+JXPW8zZsi+/ucJ+03aeNO84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=S4jfwLqa; arc=none smtp.client-ip=209.85.222.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="S4jfwLqa"
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-8b29ff9d18cso834819185a.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 09:36:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768325808; x=1768930608;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOa2o92cw0NXQYHUBKzH2APd6PqAsK6CT9yUvXJq4C0=;
        b=IQoi5uUvEsF6VInmgynFrJ0KE1OJCHFdu7FzBq1VgxWBSl+RXP1UBUazlkWtQXCv/2
         9oYWSsQKkPvU2CRMDxXMNFZSI/Ewh+VkJxlbGhgEcLeRJHpYbOoB2LzbaEzm7JMPp+3h
         d4fMSzqwywuhcOcWMGV4QXHpK4moLlb2KwqAWs+2WO58G6z/LpALMOyTA2rZvT3gnLkw
         DjN9NcIkSWpN75MF7tb60RbdY7CE8I9X1/QUTrqaYipgTQamlCCNWsBttyuxhkdf0h9i
         yRkke3TgwYjF/D1NLAn/NX99ElrOiR4y8CQoA3QHr502kR1/4Rneq0Kz7U14f98FbxM9
         BJ8Q==
X-Gm-Message-State: AOJu0Yy6ejc/D/oCOtZwdm3Kk9j+hgN/261rDmmyONjey61U2orLNz4D
	q6PJdAb0RJvMEs8N4hLZ7CIaVpp5Pjbve0wkDtgDzq16Eeo4sU8GeU9NsAy0gwSuar4tF0oGWmz
	6KXpUNy3KlwBxUryaYIyqus+qkdDB4bSQQH6uNFMz4By5+IsO2as4DdVYl3T821WpiFoUs2VWMu
	eXlQLtlh2D8I79LffTQWfSWNKGd9Q6zTSwdl9HNPNv7jwqcYL+hQlbGW6EYAK9rniQZNG3RXqkw
	RYNim37dx8NRzQX
X-Gm-Gg: AY/fxX73yXb0I/H8xUnZPM43XwaLvnZyeCO5Cux0UlNztIhaUx7L11QycPpXPe0vs7c
	nFl9kh7Blfk8aPE9Nl9awo825FcXhRp183/109xxXES/96W2CYbAhM+vCxFQRdWn8g3ecCr2fh7
	MvF8IRl8w3lsU5MuAkirySzSAVzlrkrQjS1bUTzlrrWKqkk1SSL//oxD8AJa+YcszHT9knVDr+Z
	+SDAlSJrGkdKXRtwm9X+DAbaN6L/DGc0Ak9eksq754hm5e6YCV7GwFdd7BqMm46OpIQvIXOCCt+
	fy1ilN0COC83k3yssYvVZdG+kQDHrg6yvGY8Uc8ico4Wq7wzCIc7/1kfZBlRSlJA7Wp1nCRpHkT
	iAKesy+XB4zY8hq3n7lyhe4ZQTleiEOKrvBUYXmB2ZG03+N8cL8DBweR7gbOtZ2HI01gK1bMmMB
	FMAi4oOTx7tkvk2QA2ejRoY9121ydED4ZN1Hmm9IFYJHoOZcc=
X-Received: by 2002:a05:620a:4606:b0:8a6:ee41:1b48 with SMTP id af79cd13be357-8c52fb47baamr1383185a.26.1768325807479;
        Tue, 13 Jan 2026 09:36:47 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-89076f9f4cbsm25843686d6.0.2026.01.13.09.36.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jan 2026 09:36:47 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b87437a793fso102550866b.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 09:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768325806; x=1768930606; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oOa2o92cw0NXQYHUBKzH2APd6PqAsK6CT9yUvXJq4C0=;
        b=S4jfwLqaebCfrSIal1ViTrhMY6kc/eXYU+H/lEq+8CONe5Dk+0/HZz23JiOzh8tVaV
         dGUhUYuS+1+0OqXAkT1OEHhtBpKdQY78kmwzC6dlFvDUEEjVEESyPQ1/boQBT09rCRnO
         Abns4P09h8yygpjiu8FknFpexhqy2j01mQoSI=
X-Received: by 2002:a17:907:968c:b0:b87:49e1:2760 with SMTP id a640c23a62f3a-b8749e12f4cmr163431766b.41.1768325805822;
        Tue, 13 Jan 2026 09:36:45 -0800 (PST)
X-Received: by 2002:a17:907:968c:b0:b87:49e1:2760 with SMTP id
 a640c23a62f3a-b8749e12f4cmr163430466b.41.1768325805421; Tue, 13 Jan 2026
 09:36:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-2-ranjan.kumar@broadcom.com> <0179528f-72c1-4d95-a49f-69a2adae9b26@kernel.org>
In-Reply-To: <0179528f-72c1-4d95-a49f-69a2adae9b26@kernel.org>
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
Date: Tue, 13 Jan 2026 23:06:31 +0530
X-Gm-Features: AZwV_QiJOpAdb9aWO_C1JKrKpGK3pquoXH64UB5Dm7m7dW4_L5hJuH5_vc3wqn8
Message-ID: <CAMFBP8OiaOzz80A=AzWggMk_p=bDMn-QYOkFbthhQAPQkMa_5Q@mail.gmail.com>
Subject: Re: [PATCH v1 1/7] mpi3mr: Add module parameter to control threaded
 IRQ polling
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com, 
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com, 
	salomondush@google.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000085b2a30648486fd9"

--00000000000085b2a30648486fd9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Damien,

On Mon, Jan 12, 2026 at 7:44=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 1/12/26 09:10, Ranjan Kumar wrote:
> > Add a module parameter to enable or disable threaded IRQ polling
> > in the driver. The default behavior remains unchanged
> > with polling enabled.
> >
> > When disabled, completion processing is kept entirely in the
> > hard IRQ context, avoiding the threaded polling path.
>
> What does that bring ? Better throughput ? Lower latency ? please tell us=
 more
> about the benefits of this change.
>
[Ranjan]: SAS/SATA  completes IOs slowly, so IO polling would increase
CPU utilization, and interrupt-driven
completions are useful whereas for NVMe devices, IO polling is
beneficial as the device completes IOs fast.
> >
> > Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3=
mr_fw.c
> > index 8fe6e0bf342e..869e525f3e73 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > @@ -21,6 +21,10 @@ static int mpi3mr_check_op_admin_proc(struct mpi3mr_=
ioc *mrioc);
> >  static int poll_queues;
> >  module_param(poll_queues, int, 0444);
> >  MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode=
. (Range 1 - 126)");
> > +static bool threaded_isr_poll =3D true;
> > +module_param(threaded_isr_poll, bool, 0444);
> > +MODULE_PARM_DESC(threaded_isr_poll,
> > +                     "Enablement of IRQ polling thread (default=3Dtrue=
)");
> >
> >  #if defined(writeq) && defined(CONFIG_64BIT)
> >  static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
> > @@ -595,7 +599,8 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mr=
ioc,
> >                * Exit completion loop to avoid CPU lockup
> >                * Ensure remaining completion happens from threaded ISR.
> >                */
> > -             if (num_op_reply > mrioc->max_host_ios) {
> > +             if ((num_op_reply > mrioc->max_host_ios) &&
> > +                     (threaded_isr_poll =3D=3D true)) {
> >                       op_reply_q->enable_irq_poll =3D true;
> >                       break;
> >               }
> > @@ -692,7 +697,7 @@ static irqreturn_t mpi3mr_isr(int irq, void *privda=
ta)
> >        * If more IOs are expected, schedule IRQ polling thread.
> >        * Otherwise exit from ISR.
> >        */
> > -     if (!intr_info->op_reply_q)
> > +     if ((threaded_isr_poll =3D=3D false) || !intr_info->op_reply_q)
> >               return ret;
> >
> >       if (!intr_info->op_reply_q->enable_irq_poll ||
>
>
> --
> Damien Le Moal
> Western Digital Research

--00000000000085b2a30648486fd9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zZSItX49nLoa4TBbzuCzoINrv59QeSCVlVdAYussUS3840ZjvcYHSQx3tqYcBN+an07lDASmGEM5
7PEXJPVInjl/Fva3ksL3r8anR4PWc3Xz5jLD8Xg6BU4zmIcR/t1GlqWuz8uTWmQtm40C9m91Q9a+
2alIIV6BTs8IG2ELtt4EfcVvi5af+Hu878sGeBtMx6Z9ljoKl3MfvDdtUNO4bkJ97a7PXy/CKxiy
TApQj4qg9SKQcsH0xzQan67XeXjkvk4frNDhRikCAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQUfLdm66N7GfDsoL8cYp3s4YdO
isMwDQYJKoZIhvcNAQELBQADggIBAA/lnAxDb9jbesclnBxWIKUSxAMIrq4XKO5WKHUYIOOzd2sL
o59fH9AWg1AfVONfWIUNdWDrmNNLs0+drSKaZbGx2RWMbaL9ubo7+BTQV33ZRBxnnkmc9QszlOo5
m6FB9uPOGB9LvJMCkJ8S7hNc9G/p7dB79s1IKc8JGEDIrsgX3s4xSCJA20WdePHY5rLh5ySwXyI2
3sVTUC+oK0HJFRo+TpdMMtdpOetWzIkUbGceiOA2ur8372+0KOmvlIHA/jEnW3BRfmB2vmdk+raY
C/xbXY9JEfS6D881+X/90w+cCQ7nuA1OELebS1RbSdXT6YkRDPWYA/DPFhOYCAiMwVAPRaAH1AQc
8J8yTDigwRUCq4qKCYU9YnqQh3YZRbUYnW+i3+rAO2SUbKl0VM5y0tq+GOGLC7w+v6yGossZmy+6
3w72qp/Colr4r5ZaROb+L2FXqk4tL/HfkRhliyPPPNIjre2mIkvFuShk5A5FcvQYCzDtejAz9JHq
ZVJ1ZD+auQDbIUxT+Dn9bI5XkQnWJ9KrlcORtztdYTDafN8VQuweS3JY0X/VCNBNZkiYXd7fzOza
hvkw/S+v8cIfiakLKBREtiBHqWLdVf5CNDVYpd17yz0LGz0TKARbfuK/EiKflA10pnnnOB33Ru9D
WPp9aHW3szGYr3+H9AHS6IDwkIxyMYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMDcMaKRu9LrbAxERoMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCCioVSf
iu7Ypr/Kh9cBr6GeKYtwg36/fkNhpK8F2VXi+TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjAxMTMxNzM2NDZaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC1QWKyTQ16DrD0PA1lQNMO95Z4Z45NePxRWxd8dm/Y
zU+HDua4UHxpE3PrYKpYl1zoM+VwNWCAnE/JJ4BjBSxvAw06pAYRQ2imH5XwirutTBs51EvYhqBW
+rC3Jn0GKVafoPZ7ttsWeNIKK+Qywc1Z8EHH3ofX+O2+DbKqqvOMo5WuG2yTtpXxulFdMEvJW7j8
qA3APTcrO1dO4oJnVXaHUxTjOM29K3uSSb+Izx6i53UCgO05B4t8nM50JuoLKL8adanXzh04uW+X
0eErCduF2FEP4/OsfR7YRB3Li5b5jwybGg3EZJ7te+vL5dr41sE+3mzGGb336Dgq9RkCQ1XK
--00000000000085b2a30648486fd9--
