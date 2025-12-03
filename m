Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ED6253958
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 23:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764804405; cv=none; b=fgmYSLGAJaaGLCwqcLjmrthrqayVwj6h9idwEhuDClCox4YmAVs9+vcpD+e+I5pwcwC1Eol+THpUInkmCH09vXuZrSQsmQCtNFYBPPqyh3I57JSpNjp5WnfvjxSGguCxujk9lgvR2LF3b1uK5dIWG049PWh2d1n/kltMlYi8y10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764804405; c=relaxed/simple;
	bh=5x5vkYocjI36WcZfdn9f9hGFy64EQ4zo/N6tlAgeSSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rcpK5LKsJAWEMhiM/AXOXq11voyyO0TRkcI7ctEYRpNyKFNbiJEXnUweKuccWT9/EEZPZluLCAI6w+UYU5HZ/Bt+0GJfp7g5u2wxPPyJ4M5hfU6TFny297jqgYt1NvTY12nBe26RT4xXy2l+h1wU9Z0WvSk2ZK6bFJOCu6FRdlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wwsLUnOt; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wwsLUnOt"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dMDLB6dvQzlgyGq;
	Wed,  3 Dec 2025 23:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764804401; x=1767396402; bh=NP2R2TForyoIubgnyC2b99lu
	xoVTJmXak3KpM4i5OlE=; b=wwsLUnOt0T9Q3dtVt+sCksXiGmcSwRYv9h7RtMEo
	KOsAXmymuZVAkkR9EF+ZKnzdO+aRIw4msZwe3PbABxlaW5izxxHOqbvWgd9rMF2U
	5jTo6ub/L62hKKSba7KeoYTYuFXy581INxLcUAX+NvFvIM4C5FVsD7TUWllwwQoj
	PfuiGALkq1B9G0DegBOfL7803jIL+A+gc6DxCMt85jGm2vpgGW3HIduI+hvpY2MO
	wlooe52DzkRFj4pG0MEBGXpH1JH0RDr+i4Nfzk6fb9OoEjl1y99i7ANB9j0dhDkc
	9Fdy4GDEOgJ5gEOgUsSnSSp2HUeyvn0ony9lAB7LjfH3zQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IGR3Brz-A2RQ; Wed,  3 Dec 2025 23:26:41 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dMDL70x82zlfc3v;
	Wed,  3 Dec 2025 23:26:38 +0000 (UTC)
Message-ID: <3bcc40b9-5085-471b-85a9-259ec25c5c0b@acm.org>
Date: Wed, 3 Dec 2025 13:26:37 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Nitin Rawat <quic_nitirawa@quicinc.com>, Roger Shimizu <rosh@debian.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Nitin Rawat <nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
 <014c3e26-24ea-40e3-a876-bf0336231b18@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <014c3e26-24ea-40e3-a876-bf0336231b18@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/3/25 12:40 PM, Nitin Rawat wrote:
> With the fix shared by you , SDB mode on SM8750 works fine now but MCQ=20
> mode still have below error.
>=20
>=20
> [=C2=A0=C2=A0=C2=A0 3.720396] ufshcd-qcom 1d84000.ufs: ufshcd_err_handl=
er started; HBA=20
> state eh_non_fatal; powered 1; shutting down 0; saved_err =3D 0x4;=20
> saved_uic_err =3D 0x40; force_reset =3D 0
> [=C2=A0=C2=A0=C2=A0 3.740078] Unable to handle kernel NULL pointer dere=
ference at=20
> virtual address 0000000000000378
> [=C2=A0=C2=A0=C2=A0 3.740084] Mem abort info:
> [=C2=A0=C2=A0=C2=A0 3.740086]=C2=A0=C2=A0 ESR =3D 0x0000000096000006
> [=C2=A0=C2=A0=C2=A0 3.740089]=C2=A0=C2=A0 EC =3D 0x25: DABT (current EL=
), IL =3D 32 bits
> [=C2=A0=C2=A0=C2=A0 3.740092]=C2=A0=C2=A0 SET =3D 0, FnV =3D 0
> [=C2=A0=C2=A0=C2=A0 3.740094]=C2=A0=C2=A0 EA =3D 0, S1PTW =3D 0
> [=C2=A0=C2=A0=C2=A0 3.740096]=C2=A0=C2=A0 FSC =3D 0x06: level 2 transla=
tion fault
> [=C2=A0=C2=A0=C2=A0 3.740099] Data abort info:
> [=C2=A0=C2=A0=C2=A0 3.740100]=C2=A0=C2=A0 ISV =3D 0, ISS =3D 0x00000006=
, ISS2 =3D 0x00000000
> [=C2=A0=C2=A0=C2=A0 3.740103]=C2=A0=C2=A0 CM =3D 0, WnR =3D 0, TnD =3D =
0, TagAccess =3D 0
> [=C2=A0=C2=A0=C2=A0 3.740105]=C2=A0=C2=A0 GCS =3D 0, Overlay =3D 0, Dir=
tyBit =3D 0, Xs =3D 0
> [=C2=A0=C2=A0=C2=A0 3.740108] user pgtable: 4k pages, 48-bit VAs, pgdp=3D=
000000088f66d000
> [=C2=A0=C2=A0=C2=A0 3.740111] [0000000000000378] pgd=3D080000088f66c403=
,=20
> p4d=3D080000088f66c403, pud=3D080000088f66b403, pmd=3D0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.740123] Internal error: Oops: 0000000096000006 [#=
1]=C2=A0 SMP
>=20
> [=C2=A0=C2=A0=C2=A0 3.815406] CPU: 7 UID: 0 PID: 213 Comm: kworker/u32:=
2 Not tainted=20
> 6.18.0-next-20251203-00001-gc131083d7359 #27 PREEMPT
> [=C2=A0=C2=A0=C2=A0 3.918160] Hardware name: Qualcomm Technologies, Inc=
. SM8750 MTP (DT)
> [=C2=A0=C2=A0=C2=A0 3.918163] Workqueue: ufs_eh_wq_0 ufshcd_err_handler
> [=C2=A0=C2=A0=C2=A0 3.918171] pstate: 61400005 (nZCv daif +PAN -UAO -TC=
O +DIT -SSBS=20
> BTYPE=3D--)
> [=C2=A0=C2=A0=C2=A0 3.918176] pc : ufshcd_err_handler+0xac/0x9ec
> [=C2=A0=C2=A0=C2=A0 3.918181] lr : ufshcd_err_handler+0x9c/0x9ec
> [=C2=A0=C2=A0=C2=A0 4.023106] Call trace:
> [=C2=A0=C2=A0=C2=A0 4.025629]=C2=A0 ufshcd_err_handler+0xac/0x9ec (P)
> [=C2=A0=C2=A0=C2=A0 4.030207]=C2=A0 process_one_work+0x148/0x290
> [=C2=A0=C2=A0=C2=A0 4.034336]=C2=A0 worker_thread+0x2c8/0x3e4
> [=C2=A0=C2=A0=C2=A0 4.038192]=C2=A0 kthread+0x12c/0x204
> [=C2=A0=C2=A0=C2=A0 4.041527]=C2=A0 ret_from_fork+0x10/0x20
> [=C2=A0=C2=A0=C2=A0 4.045210] Code: f9402760 d503201f 910de000 52800021=
 (b821001f)
> [=C2=A0=C2=A0=C2=A0 4.051474] ---[ end trace 0000000000000000 ]---
> [=C2=A0=C2=A0=C2=A0 4.056981] scsi 0:0:0:49488: Well-known LUN=C2=A0=C2=
=A0=C2=A0 MICRON=20
> MT512GAYAX4U40=C2=A0=C2=A0 0100 PQ: 0 ANSI: 6
>=20
>=20
> [=C2=A0=C2=A0=C2=A0 4.281093] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
> [=C2=A0=C2=A0=C2=A0 4.360921] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
> [=C2=A0=C2=A0=C2=A0 4.746782] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
> [=C2=A0=C2=A0=C2=A0 4.817093] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
> [=C2=A0=C2=A0=C2=A0 4.893131] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
> [=C2=A0=C2=A0=C2=A0 5.013146] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
> [=C2=A0=C2=A0=C2=A0 7.249155] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
> [=C2=A0=C2=A0=C2=A0 7.341071] devfreq 1d84000.ufs: dvfs failed with (-1=
6) error
>=20
>=20
> However, after switching to previous tag next-20251110 of linux-next,=20
> where this series of changes is not present, the issues is not seen.

Hi Nitin,

Does the patch below help? If not, can you please help with translating
the crash address into a source code line number? Please note that the
patch below is unrelated to any of my recent UFS driver kernel patches.

Thanks,

Bart.


diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b834b9635062..0f0944ea8b46 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6698,6 +6698,7 @@ static void ufshcd_err_handler(struct work_struct=20
*work)
  		 hba->saved_uic_err, hba->force_reset,
  		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");

+	if (hba->ufs_device_wlun) {
  	/*
  	 * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
  	 * even if an error occurs during runtime suspend or runtime resume.
@@ -6711,6 +6712,7 @@ static void ufshcd_err_handler(struct work_struct=20
*work)
  		return;
  	}
  	ufshcd_rpm_put(hba);
+	}

  	down(&hba->host_sem);
  	spin_lock_irqsave(hba->host->host_lock, flags);

