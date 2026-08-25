Received: from mail-oi1-f228.google.com (mail-oi1-f228.google.com [209.85.167.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B423DD862
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660196; cv=none; b=bw1SD2jYYPmdfRfKNfkfWq/IudzMQqBQy9cVfvFQPKoYbImZ0on+4wiOeHHsZP6Tl2zgcKmobl8nQtp/f60zxfhFU+qeJP7WbO5YjqmSu37pkqAGB0TGvY3cEIGleNmzEMT42C7JXhEjMBsGqWSP4P5TBb2vuXZGOQkLXmKaYsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660196; c=relaxed/simple;
	bh=TH7y86ZxIOBP34KenEOmDd8eYkkxxtWOTCSZKDcjDTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m06/MHDlJMu75kYeXnzAUdZt1SupViLjdl7vWwPDIn12xKDTm1oN1DtUtLJXeIfwuZWwXUiCUeC+T3Tkb1Lbtmz165zNjvL85iQaGfVJXAJ/lP3ZSR2yxkgzcH4vW4BdQ/wDNkae9UDru0kJI32k2Yyavb3UKDqyFZOspj6IJfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ABZK9vkd; arc=none smtp.client-ip=209.85.167.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ABZK9vkd"
Received: by mail-oi1-f228.google.com with SMTP id 5614622812f47-4af81963f35so3995722b6e.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787660187; x=1788264987;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wCc2mK39X+FEcDhr49B3slAMG7nD5fqJ2MMmWfrnhjo=;
        b=p3If9VGFYc0PsbWL5ZQRn3YojnpPVSalgsxVgdr/GL8gVtFkN4leiwVNnqoPNP68Oj
         OufQY5XTU+hG6ef3WGzQS/GTHMgCiREMlFMc+BAGMS1BTJhn/FVfueqbP1svz4lTuWla
         W5EFHwvWe0Huv4aAU8xNoOwFv1Xpjvx1J+/ii1t/1dTroID/fBYli9BudX9m6hFp+1MD
         rgDuOWVaHBpAQJe7BEip0RcDRjPyZt8KblJfA6nK2t9vdUAPaFv4fJMUiZH0AxYViCC4
         p2va15EMttSE5QpflO2BTTR7cSDoCMURSj3zvH1w2KBioPhLygjc/O4s/zibcS+32wNu
         B7iA==
X-Gm-Message-State: AFuF++nDUkd9ACxN2Rt3b/nwo59kFOt+mXlFDmUdbf5ef4CpCed/b2oD
	PkYEIbyMQQrkewSv2QP6xMIPNQPI2BKJSpZVFNgeMHDeePTlMKoAzS+YZXh60JNCoGk2wQWbzkB
	ef8huC0Yd2289zfp3A1ERgZWDa34d3kFYeIZGLwym79K5BLi+sIlkM+aCX3DMil6ZV/8/frm7D1
	dojIWeLVHF6k8Ry/wBrTnnL9v5LNiwbb/Q5cOpES7U/u0DkfD7txQxiiIEls1Qbyg07e+lFD79y
	3qix4QQAv1g5SaKYAbI71hI
X-Gm-Gg: AR+sD13MpZd8DGVPExvO+FoJ1wD5qx4c0ZtISqrE7iMuRT7EP3AMo6we+0HERxhNn4Y
	4TV+MMTPo4RQ1lJrpWSRaafFFczrPM+Li42kPNulOzQdWVsxsy626SMPXJAHoQ1FhrhZ+yut1b2
	DDBZ6b9Zoj9dNh02pROidg74G3lIhljAwHDB1yNQrw+AD8IaxuDshbtA0qEU2xmpwv8tfUgdWFr
	QmUOEh7xTO/HqXkdyAV62U7kmvRsMnGIG5Bk+E++e9KNPC/esecCzVaeiqY0eWAuCz8PH45Vm8L
	sBa2QEon0PVbEdbw7Avl9V1kTFtlpaXRifdKsL1+0dsCoqZlHC0lrwzZBZAuh+e/P6MwEupC4lH
	gUPeABdHdu5sJjV2U9nlLsdmX7xu+wGWtEYlWHwAcvmT4XRKeqLs8l1cvUGjOUQoXzJhF3zCU+u
	lqenuqC26AUvxSVhSqCIHpwM8wGoUD7kOybv58bIQlfMY=
X-Received: by 2002:a05:6808:4482:b0:495:fb79:7712 with SMTP id 5614622812f47-4b2eef561demr35692803b6e.0.1787660187257;
        Tue, 25 Aug 2026 05:16:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc199db398asm767933a12.2.2026.08.25.05.16.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:16:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1c25c44d15so598815266b.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787660185; x=1788264985; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wCc2mK39X+FEcDhr49B3slAMG7nD5fqJ2MMmWfrnhjo=;
        b=ABZK9vkdltYvxRQ6/EJOXxg3RfUmEwsV+e8tYkOCT3YNKCovl1EDF2mjClyz2t1VJq
         hUvmY84DZ9UXNVd3FENtPuy+UZACo9G9esiXPmoNOVU/oELAwe+pe06tMJ6gDZqwFOUp
         J5KxelLyu5s/itfV4FASSTleLWmJxIT5bQHFk=
X-Received: by 2002:a17:907:60cd:b0:c24:c22c:6372 with SMTP id a640c23a62f3a-c24c22c6490mr1546818066b.5.1787660184916;
        Tue, 25 Aug 2026 05:16:24 -0700 (PDT)
X-Received: by 2002:a17:907:60cd:b0:c24:c22c:6372 with SMTP id
 a640c23a62f3a-c24c22c6490mr1546808166b.5.1787660184265; Tue, 25 Aug 2026
 05:16:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-13-chandrakanth.patil@broadcom.com> <20260818183305.2176B1F000E9@smtp.kernel.org>
In-Reply-To: <20260818183305.2176B1F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:46:12 +0530
X-Gm-Features: AcwNN1VQQQma3VCUKOb6iQKKp_C_MDhttD93_oiiSRjR6Jsz60fz-Z41jkLk0rc
Message-ID: <CABvwm=N5jTUGXkwJWh11RMRhzzpy+18SD2bMwpZdMaJee=8vfQ@mail.gmail.com>
Subject: Re: [PATCH 12/17] mpi3mr: Fix out-of-bounds phy array access on link change
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000053cf160659de1222"

--00000000000053cf160659de1222
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 12:03=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] The firmware event handlers for SAS and PCIe topology changes it=
erate up to `num_entries` without ensuring it is strictly bounded by the ev=
ent data length, leading to out-of-bounds reads.
> - [High] This problem wasn't introduced by this patch, but the entirety o=
f `mpi3mr_update_links` continues to access `mr_sas_node` and performs lock=
less list traversals on its structures after releasing `mrioc->sas_node_loc=
k` on the happy path.
> - [High] This problem wasn't introduced by this patch, but a shift-sign-e=
xtension bug exists when updating 64-bit `phy_mask` bitmasks using `1 << i`=
, leading to out-of-bounds array accesses when `i >=3D 31`.
> --
>
> --- Patch [12]: [PATCH 12/17] mpi3mr: Fix out-of-bounds phy array access =
on link change ---
> commit 5a98eebaf3b1e059c60e29aa1529199221440703
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix out-of-bounds phy array access on link change
>
> This commit adds a bounds check to ensure the phy number associated with =
a
> link change does not exceed the allocated number of phys for the node. If=
 it
> does, the event is logged and ignored.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3=
mr/mpi3mr_transport.c
> > index 240f67a8e2e3b..2afff1a002ed9 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > @@ -1090,6 +1090,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrio=
c,
> >               return;
> >       }
> >
> > +     if (phy_number >=3D mr_sas_node->num_phys) {
> > +             spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> > +             ioc_err(mrioc, "%s: phy_number(%d) >=3D num_phys(%d)\n",
> > +                     __func__, phy_number, mr_sas_node->num_phys);
> > +             return;
> > +     }
> > +
> >       mr_sas_phy =3D &mr_sas_node->phy[phy_number];
> >       mr_sas_phy->attached_handle =3D handle;
> >       spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
>
> [Severity: High]
> This is a pre-existing issue, but does dropping the sas_node_lock here le=
ave
> mr_sas_node vulnerable to concurrent modification or use-after-free?
>
> Looking at the remainder of mpi3mr_update_links(), mr_sas_node and its me=
mbers
> continue to be used after the lock is released:
>
>     spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
>     if (handle && (link_rate >=3D MPI3_SAS_NEG_LINK_RATE_1_5)) {
>         mpi3mr_set_identify(mrioc, handle, &mr_sas_phy->remote_identify);
>         mpi3mr_add_phy_to_an_existing_port(mrioc, mr_sas_node, mr_sas_phy=
, ...);
>
> When mpi3mr_add_phy_to_an_existing_port() is called, it iterates over the
> sas_port_list locklessly:
>
>     list_for_each_entry(mr_sas_port, &mr_sas_node->sas_port_list, port_li=
st) {
>
> Since mrioc->sas_node_lock is no longer held, can other events concurrent=
ly add
> or remove ports, corrupting the traversal? Additionally, mr_sas_node is f=
etched
> without acquiring a reference, potentially allowing it to be concurrently=
 freed.
>
> [Severity: High]
> This isn't a bug introduced by this patch, but could the firmware event
> handlers for SAS and PCIe topology changes iterate up to num_entries with=
out
> bounds checking against the event data length?
>
> In mpi3mr_sastopochg_evt_bh() and mpi3mr_pcietopochg_evt_bh() in mpi3mr_o=
s.c,
> the loop blindly iterates up to num_entries:
>
>     for (i =3D 0; i < event_data->num_entries; i++) {
>         handle =3D le16_to_cpu(event_data->phy_entry[i].attached_dev_hand=
le);
>
> If the hardware or an attacker controlling the controller issues an event=
 with
> a num_entries field larger than what fits in the reply buffer, could this
> lead to an out-of-bounds read? Even if the top-half handler attempts to b=
ound
> num_entries, returning early without dropping the event still allows the
> bottom-half to iterate over the truncated buffer.
>
> Additionally, mpi3mr_pcietopochg_evt_th() appears to completely lack any
> bounds checking before iterating over topo_evt->port_entry.
>
> [Severity: High]
> This isn't a bug introduced by this patch, but is there a sign-extension
> regression when updating the 64-bit phy_mask bitmask in
> mpi3mr_add_phy_to_an_existing_port()?
>
>     mr_sas_port->phy_mask |=3D (1 << i);
>
> When i evaluates to 31, the expression 1 << 31 evaluates as a negative 32=
-bit
> integer (0x80000000). When this is bitwise OR'd into the 64-bit phy_mask,=
 it
> sign-extends to 0xFFFFFFFF80000000ULL, erroneously setting bits 31 throug=
h 63.
>
> Later, in mpi3mr_update_mr_sas_port(), this corrupted mask seems to be us=
ed
> in a loop:
>
>     for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u64)) =
{
>         mr_sas_phy =3D &mrioc->sas_hba.phy[i];
>
> If phys_to_be_added inherits the sign-extended mask, won't this loop exce=
ed
> the allocated bounds of mrioc->sas_hba.phy (which may only have 32 elemen=
ts)
> and corrupt memory?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D12

Thanks for the review.

New issues:
- None. This patch specifically prevents an out-of-bounds array access
by checking phy_number against mr_sas_node->num_phys before indexing
mr_sas_node->phy[].

Pre-existing issues:
- The pre-existing issues noted (lock scoping in
mpi3mr_update_links(), bottom-half topology change event iterations,
and the 64-bit phy_mask shift sign-extension)
  are pre-existing in the driver transport layer and will be addressed
in a separate follow-up patch series.

--00000000000053cf160659de1222
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGpzCCBI+g
AwIBAgIMAgfxQ1Z7DrZKmCE/MA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEwMzUwNFoXDTI3MDYyMTEwMzUwNFowgekxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEOMAwGA1UEBBMFUGF0aWwxFTATBgNVBCoTDENoYW5kcmFrYW50aDEWMBQGA1UEChMNQlJP
QURDT00gSU5DLjEoMCYGA1UEAwwfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTEuMCwG
CSqGSIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAJwyF5qSHwwr1zJWkKvkMnY7V/sVFYYjTpjgxS4XA76pD6eLsZvS
4J73HkKSNEzORxBE7OyZSnuBJ9zeeRcypuItG9YrHm+0OSF0psIWsH15FBYJ0nvsUnlFbCSNvOdr
Co0WJ1KTe/7caj014uRZM2j7zH1vC+9fjEgrJdDRZakZXarl8M7k9okvVj1N+EuHiYUMvsAuMadE
a3p31Z6QdvMpr+30UdJXHshV1mXca+UBpCx26GbY6NgxhHM2LtHiaCK8Vn4HMofDkFg4nQ6eK4ai
uCiTtPj5aNlkdpcCzcZ+j1eCu6ZfPIq2ycwDaHi8d6Dwcgm+XoxDmD97Ehp2FOkCAwEAAaOCAeMw
ggHfMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggr
BgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1l
Y2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2Ny
NnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGg
MgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5
LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWlt
ZWNhMjAyMy5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTAT
BgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNV
HQ4EFgQUyqNnwId/JCbRPslVl3nm48YRek0wDQYJKoZIhvcNAQELBQADggIBAKPmllSh8cRXzNRs
3OATCVDgrdOfIsZMB9UVXcYQ+HtR1fu9bafeyuuupF9gcCmi+onLsANYRKaEDjC8h+V5FMAgm6TI
bww4EFGpWvP/XEVKrpcpMkYNMLw89lagx9ZZDhx9DmfQMI9gG9MPpCkSMEPnJvEs7gqtOo08aL1+
ts10tGfePsHF/I42Da21hJIJ01XN+Z91y//1cJkHwCBvDmoB8gdMXp3g4sjzahTxRZ25BdZB9W+n
0jfWJXFKtp9MYS1SaVo17usfrlTeyaH3zPyDvfAfGoLB5+i8vyVL6wta2vgVpfsL9iwhbJnAIxr+
ljECWkh1weDJw3UnV6nooG1RztnwqbG4eAG/KSCToXgVH9qSDv5S1lve5mvhv9AHzLjGLs+QtMeg
WEdMM4G0PWyibzGgNrmVgKaLjV6EMo/IZW7KjBtvjyKQZhes90D4GyxXv+/mrTo2rruz53+FoSc/
nuyLmg/SxnnZRaf7JGHFvu0IbwkeINwdHynAanOg9AD4zits7k7jjQ0fwIdhCaoRA3ao7PXUL1t8
LfSp/K5DCYsrXNqitPmQaAAGAiG4d4WDxBev6vtoyH7ejLcuCKkxCefrLO5qYnuDHsMNCObdslAe
tMVer+USn6AqB//6EwmqdiLr4o20UQ79jxNFMAEKdwyNkA8mVCVUAtTe3mPrMYICVzCCAlMCAQEw
YjBSMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xv
YmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0EgMjAyMwIMAgfxQ1Z7DrZKmCE/MA0GCWCGSAFlAwQCAQUA
oIHHMC8GCSqGSIb3DQEJBDEiBCCUbgL/3cSrMp8FyOnVaOED7MtFm02+9ZIktiz20ePIEjAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjE2MjVaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA/Jp5qobzS
D0sieRcK7SmFruY+p3hPjmxFw6p6zNTHc3o+7Wh1SZhmhQUqzV8cpEkKisBO//HpqAMNzpy6prEu
aCTchFlx6UUpJR6c5kr6ORxn8K9OvdSj+9Qyh5yiItqSgR3dUfAqvrlBBzcewYGgawAKkl0wHOjz
QvhoazybDGY9llo4hERAK4igoTwB+Yebv812Jvw8H2df952y27Yf1H6Gh/TN6/gYvH1KtWxRePiM
W5Vh6EJaj7FsSJH427PZYAAOuY54oVkQR2PgX/GEnXpH1iAJaeSFoabq+IqYPRjtXK/67YRe4Z6o
7ynWFBmuTdjNvGh9nIOXPk9SR97f
--00000000000053cf160659de1222--
