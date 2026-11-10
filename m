Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794314343;
	b=i7KKTLtOM1x6mzIcp2AEzsoZsgUojKPso14SRMxxm+RD+geRAv7TkHxNmsAUDIheFVl0
	 UI67qZMQk0aNAioiXAlAhs7g4AYsAOhmmGTg7fTcWx/jOBE1ZrE0l8tzNha71s2tb3IY3
	 UNgI8bA3o6SzTfwUt8bO7bzQjke0+XQUmWam0uK23Eoc2pUAiEkWUTW+igRvpDJfrYl/t
	 Oa4lwFB9GgN6xxHtuyKz+bEZVcoWZT6RN/7X9zzLx9D/G03v6V5NuXL53Enpv8XWX9a57
	 hiJ9+oSaTV1JeJ3XGc1xnZQnepIw6/qMfwZ2A8PdxY0JQHTddBYxSojZzIhrcvRJ2ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794314343;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
	b=YidviqNgDqQBE6fquDm1MUc1UEW2j9G8S2hUvGIeFC9Gem8HQj0F+PNyXHZkOJn6FjjL
	 w0u4rDvx5m0pw63yysXFSkowa0suiixELLOI+7rVtA345RyPgKSQfPEhjjNWLMUtEMQkY
	 v5ncoxKZLBvDipJv/hGrFRKeRIcZRIq+5gv9eDjwuL/VCa31OyAPDfQpmDsuDnQkgBCVJ
	 dMaDBLdLocpTcn0RsTS1449Ecd5lFNgFic/4EN9xDYSguat3kdHKFM2urzKowTaDss9DI
	 hU89aVcomasjF8DiD2dOfwvIN1LpTPcqv2c2h03AH4Y7dFGUB6DlG3ZRR7K1+UY/g1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VQJg7ekj;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Yt+AjHVq;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688CF606A326
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 12:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 688CF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VQJg7ekj;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Yt+AjHVq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794314341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
	b=VQJg7ekjwyrKDFGl+vk+EEUkhTInjylkY3tbJyyyoawPyz0WFJw6xc8Mxofo7hTeWHO2u+
	dU2M37/MXoXD89lRiXQuB7dp46aWf06wgApwrM4p64FYaGZ2bOe2IMCRDoZb14xrv+fga2
	wwtJ/xeh0KTsp5XU69oOrOxrS959VUc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-vzPxepurNEuw6H5TxHpwHw-1; Tue, 10 Nov 2026 07:39:00 -0500
X-MC-Unique: vzPxepurNEuw6H5TxHpwHw-1
X-Mimecast-MFC-AGG-ID: vzPxepurNEuw6H5TxHpwHw_1794314339
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5363b06bcb2so43030551cf.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 04:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794314339; x=1794919139; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
        b=Yt+AjHVq7RHo8lm/veWGZuOeavyeKKDsHpGFL0oGubw/G33dLSPLFNaZT9AaVCkDhm
         QjCpd4tsqT/I411nhwhe9QvzEqx/a4evqFl26+enin5GMtvLE7zh1Ptki4vwxXrNMtUl
         g+VTOiYRptHtfJSyxKGyT6uYPkZ9PdsMDPw75K0M8e8xKC0ELydqqwUEvhFCP67P/CuQ
         zm6Mq6qUuwCVfzwDuYrBvL6hoGF7hBPi1zeF6QsgC2VQBnumcAXh+KVwu5twj0E2yFeG
         /h2uuWLpS0vaqRBfGDhg+IyHgR6ZNoP3+VWWl0XvNm2kwN0hnk2hE1lRItjEoR/30zut
         /KNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794314339; x=1794919139;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
        b=SrWvkl/eZkFKuGF7pU6NzjL1zqY9QlGtkEbVVTIXRlumHCadTZZuHE4idKay5g8kC0
         kH01PXAJR3S/VUrdiFKLLtQg08TRbodb9hMbYDpojKI//bdpdrRAsUBCHdPme5TvkYmh
         6L0Xz1Vl/Bb+56hKzfxr1ple5KT50gXuNgymXi7PMx4qyOOjeVbQsrfEKT6p9s13RVeB
         ODipmoUSJvS6dTEkSGxXQ0d7z9mTb73yS2aGg4jJ38eCvKXx5vgu63CJG5vpCGdmBrGC
         mI6Zq1qxXBtRARlZ5Yt1g0ZURBwkOnQEcrUtm94XAF0y7qeL0P+0z0NkVhooFsKkYoF8
         BK8w==
X-Forwarded-Encrypted: i=1; AL+hErEe7Pum4N4L/PIAKMjLSwFdQ1RGfSwlaog1MmHM31x6okSgROmIjWJTjRetVGPDsa/O65z1QAIsBJwG@vger.kernel.org
X-Gm-Message-State: APuU4Z9m+hDZ2n8LmwfRMoEx+r5f/SA4lIkRIDtkEHcPTbdyQdAXoZb/
	qBL1xFdUfUDR7ycaJa99/RiaaKa3fP+n9GVdW+LqBzprdcLTZYsI1RyG+OzcezB8ltLOcxXCfjK
	pPNjTh2pdlzOznt+WlHHMcT3Mq2KNeQbRIOlHpw5Wxlvdcqwp2zrbdfSx9kycDcfMI2mMSiU=
X-Gm-Gg: AYBFou2B2goz6hMpAtDkV4HedMiP6/KsLjtHcMrZftB2gve8XTN10U/OkChJBCfLkzV
	Vz4bOgU4T8mSUdKwRqQ88nn2qq9A4dj/a06Eu0OS22Z5WIGdYH236C4OFq1RLegcHySncsscBRP
	YI7PdHxv7cSzyv2DGnYSx/y5FnMOhS3cVpkR4rBDEEVnnaujVZQlY6yIX8vy43tMQ6zhDyEtOcx
	rqZPlKgcUS8GRtQm7Noh6NcnybQarPh2m8vECUSJ5ZaNFIADCy6EYVTrpi9GEPCdTr82AO2Fkt9
	xsdO3IvTK0BPifrRE9kZBSVw8bCTxClCdojxhSNlCW1Ls575GLl6RcImglfD2Sw0Yn2ucNu7gMe
	fuwxR1YR/K404CTc90Cvpby3mhHLBo8pfhFnNtHTwtyr+KO/BzqxlTZlG6zc3Bl8dOsxxn9xdGO
	wp6rUVTccdsM5qbfjwL5Pp0J1n8LiAnTwbl+L09F43aED95X4J0648K3SNL7IWP1171/RiSrw=
X-Received: by 2002:a05:622a:343:b0:536:725f:588 with SMTP id d75a77b69052e-5552b93e67bmr33006511cf.76.1794314339407;
        Tue, 10 Nov 2026 04:38:59 -0800 (PST)
X-Received: by 2002:a05:622a:343:b0:536:725f:588 with SMTP id d75a77b69052e-5552b93e67bmr33006111cf.76.1794314338725;
        Tue, 10 Nov 2026 04:38:58 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550bd33340sm22952721cf.21.2026.11.10.04.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 04:38:57 -0800 (PST)
Message-ID: <4a028851191efe6a45f746bc65754a50503c330b.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Maurizio Lombardi <mlombard@arkamax.eu>, Dmitry Bogdanov
	 <d.bogdanov@yadro.com>, Martin Petersen <martin.petersen@oracle.com>, 
 Maurizio Lombardi <mlombard@redhat.com>, target-devel@vger.kernel.org
Cc: michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Tue, 10 Nov 2026 07:38:56 -0500
In-Reply-To: <DMPRS0MF3KC3.1H1C97P5ES18@arkamax.eu>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
	 <DMPRS0MF3KC3.1H1C97P5ES18@arkamax.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, 2026-11-08 at 11:50 +0100, Maurizio Lombardi wrote:
> On Tue Oct 27, 2026 at 7:01 PM CET, Dmitry Bogdanov wrote:
> > ISCSI has some old leftovers in the code that prevents passing the
> > aborted
> > command to the target core to make the actual abort. Such commands
> > hang
> > until connection is closed.
> > So remove those leftovers.
> >=20
> > Dmitry Bogdanov (2):
> > =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING
> > =C2=A0=C2=A0=C2=A0 commands"
> > =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
> >=20
> > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 19 -------------------
> > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> > =C2=A02 files changed, 27 deletions(-)
>=20
> Sorry for the late reply, I was on vacation.
>=20
> I like this solution and since Laurence tested it and confirmed that
> it works
> then I am completely ok with reverting my patch.
>=20
> Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Hello Mike,=C2=A0
Gentle ping for an ACK for this so I can move it along into RHEL.
Thanks as always
Laurence

