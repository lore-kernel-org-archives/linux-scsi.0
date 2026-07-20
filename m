Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9113ED3A3
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 10:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784544974; cv=none; b=JYVyOSJAdJmRm6ar76DSEi+RF6XlRYbcAnGwAArLfJjc95uUEZnmP+aWacPbiVFqMEyAe8PPieH3mT/XpB0Xw7gGJZuYhhejno+RoX8bMhAsw+Nr0y7yBubj0bndiEHXVdIScOXuysOHJEovgYwEXWtkRr+V6k92x9aTBzK/DHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784544974; c=relaxed/simple;
	bh=QoDcopLbbYP11iEHbn9QL4CnnbXfycGCpxp89Ht/HUA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LFIn8UoGzQh9D7X8BLEgSbQvc9gej8y4TxIGwY0mVjXxVp5+uIvJPWUiCmCtsM6QCALDylVyc7ZdUroUU9vEQ6lv8LbAptiHxEdJmJwnuvPV7XAleAzbNAQAWqYQSLX9QGWfGvd6TYp30qgWy8g97kXej9ouTVd8exsPqcBLFzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DgRWemk2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BaTlqHJq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DgRWemk2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BaTlqHJq"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K9vX6s2403793
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 10:56:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	M7aPhUjEPnnqCaXjWrYJvO18Nn305fIO+ZBJAuJmOYA=; b=DgRWemk2ir6lew4c
	68ydLkiM6rp4cuZtPgr3eX/kC/7+Z/qnzhN0Wl/4crp+57B5htY/DiK5OhMEa9di
	PlgKoOpJroy4wlVXbZTMxfZNrWY4ywhYAea3igczwJIxSBPONestoeJ9WIBv/N6I
	3hgG8AaAOEpSKKWamvOlKg+QuincFxtwYGbzsDkoDisx9WWltTiiSw/cpu9v2JjI
	dyBzzJ0U5YunC/5E3soxUvp40bHXM52Vn9HNDUbXlEueXcVVKx+5/1iSI4N87Swp
	oel4SuL9wY056PJOF9A0sF7JNkTqDwK7kyrvNwfTYf7BpZDmmMEfyFHCbSJc1QqG
	OoejOw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhfdcgu5p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 10:56:08 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51a8db414c7so166131521cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 03:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784544967; x=1785149767; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M7aPhUjEPnnqCaXjWrYJvO18Nn305fIO+ZBJAuJmOYA=;
        b=BaTlqHJqO1qOPF/qXgvyYYabdS4sM8M4+Df4HQZUV4ChqJDROVm8FoHAphc96415ec
         a/5oEEXREMFNXk2UB7akL6yVKkdyfZVhfDqIkeESrMFwh/3ew9F6vBIzLI9qj9TRhArB
         6EUxIDpDWwFeDRZbNHrc/yn4PnEviRCdPPraitZneaGcfPPZIO+czaYBUg3MRNU9uuwY
         SktLVJdutrj3WslrumIBCMMrAUFWFuv/9jaQYTzwgeR4tD5Kj0lEu09LOKak7MMNH/Dd
         bWJlBYe570lDlp12WLoDwwfARcus48wqB++wKDl2IxtXZ0jTKmhdIjR/7yGIm/zfDPKv
         c7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784544967; x=1785149767;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=M7aPhUjEPnnqCaXjWrYJvO18Nn305fIO+ZBJAuJmOYA=;
        b=fSLKuXEHkb6UvmDIwA1FQTV6zCyXoRzp/aCAPiZSUHcc6PSdZdWSTRh7UrlNMWeh8k
         ouo1kRKA98DNviztTK5ItDAn6hy2ALCOUm6buEhXEU3lceb5sIwpx4hW4PJOTztMSkZs
         t5xRsNshOCPZfIvexQz1XGO/ZoQkD7jA3f1HEU/LsZWQk+0juCgyXJHPTrKX3UU50qIE
         bvxiKrHJVjaSKxm9zySbnlo5d/givS0we9lCgZcDT4C39zfscdC0VDjr8YfPR1bgRrDZ
         rI9MMGyVvbaaj4iQrBzt7sYN1InmY+YvfGoiyr+IcetEMsLmqP8SP7AYZ9gd5+ajiAYy
         bV5A==
X-Forwarded-Encrypted: i=1; AHgh+RqRdXool1nsCXZMb6BA54yhQryWJTaB3kVbvS5IRNIS/4FsTBjKrBWkpu1cAREhEdDotR4uyVpWGlqb@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6g5ECskKeA3/lWgcfvX98ZYXx6OEGwsO3dRIwQO7dgJprCbq1
	ocWX6LoRT2+25LecDmM71y8P2KSnrDJICDKapOavTuv6JFF8gOTd9Tq+x2VQR/3kbnCxKrkVv7h
	Qk14McRRQfDfrHD2NG4Mtgi8EQ86PWb/DVU2H7/2Z4y1GaqCad66LM79TEurFjMca
X-Gm-Gg: AfdE7cmzmACUVmxB68wdvHBmuza/LLu3WydUELjM7AWeQ/iEaZbfCQL2fxFZU48R/5j
	3AwlWIjDkpKm91qj2BybJ2ndKH6MfH7AaQqEtj/h15Dkm6kOeUr8nAvWWVxz3c4lou3FSZnAmM8
	OTOCq3eU8/L5bqVp99q+k2YVu8abKfJENpDUu6EdYmoYfaTct9ezSNgPEBHaB26fZMXWzPNOpnf
	N+OqqGwxwmgeRK9oQD9ODjeEoAxh8+8y3P9QZiM4xBYSDopvXrEglHOzy1Qm3zGLRBc06dCP4+Z
	JsFtrelqlttf9THz3G9DlXE213YpvRYnmWuJVB+UFPHBTpjrTWK3w5srIZ52nxOWd364txEJXw/
	h6TiRZh8sV1mfzSSIPZHUtk94oDdQyx1bIMQ=
X-Received: by 2002:a05:622a:87:b0:51c:730:a587 with SMTP id d75a77b69052e-5213ee7817bmr126697971cf.63.1784544967095;
        Mon, 20 Jul 2026 03:56:07 -0700 (PDT)
X-Received: by 2002:a05:622a:87:b0:51c:730:a587 with SMTP id d75a77b69052e-5213ee7817bmr126697591cf.63.1784544966527;
        Mon, 20 Jul 2026 03:56:06 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eeb360sm30368061f8f.34.2026.07.20.03.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 03:56:05 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Mon, 20 Jul 2026 12:56:03 +0200
To: Bean Huo <beanhuo@iokpp.de>
Cc: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        can.guo@oss.qualcomm.com, beanhuo@micron.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
Message-ID: <al3-w3j2-E2twGZj@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
X-Proofpoint-ORIG-GUID: fodv7tG4ZLkdkzGw9XSROmkFnRqVrbZO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDEyMSBTYWx0ZWRfX9+Wj0l+V+rsd
 MrFmNuu+jbSYDPbMAN5AK+MxF5VXXG4wvV896wmPh7ge98vMDPVZmWOo8aBRrlUvi14fuFvvKI+
 xp44Ekx4PiAr0ptaPoU6w++DZ5ehU/45PFdhN5H0+kZ60cbC+msMQk1MEhDDUB5O58elc8pYMf3
 GvDpFIO5aI+r//04lrzdv8Y+uDxcT7bjrc1ItdfhibqcoC9bIXqHf4P2KxVH2QI6eQ7HPYPvzEV
 nQqe6E2RJWF3WKU9GgCXXmHobxZnWBllLRMNWYlBwalO6z8cBksOn7aLmwXO43ox29PhGOZq3Jr
 MaMlLUMyFyPvdm2khjk+zDIT9lqn0gxPjINHGZkXkjYLD9RKYrrs5oQBc/n4AnMdgv49NddkAEO
 cSl6mWHiW7Uvb0+c72yU2pOvnioj6EgU55B3JPBdashU4rSRwzO/q3TXSfvEbewYD3wssagpjWV
 28fFZWWmwLPQ8RXM6xw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDEyMSBTYWx0ZWRfX0cKlXhS4i4um
 og/NcVsA5IntRBi0wXwfsapL+q25Fj7Ly0lYHu5gtsBW4N29O7c2BJLjjM79DiWSd8dB/X63FW5
 LYZ4O1oxiIEpL6eIsA/kIBwrqIqpAqo=
X-Proofpoint-GUID: fodv7tG4ZLkdkzGw9XSROmkFnRqVrbZO
X-Authority-Analysis: v=2.4 cv=bv58wkai c=1 sm=1 tr=0 ts=6a5dfec8 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=8nJEP1OIZ-IA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=_EMmJvYMAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=NEAV23lmAAAA:8
 a=IvsrKC1etgm4sCmQOs8A:9 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=3ZKOabzyN94A:10
 a=wPNLvfGTeEIA:10 a=kacYvNCVWA4VmyqE58fU:22 a=emCv1hD2LFd8cNRmW21v:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_02,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200121

On 20/07/26 12:23:39, Bean Huo wrote:
> 
> This is very strange, coverletter is v1, but the patches are v2?

I messed up (manual edition of the letter) but the thread is proper

> 
> 
> On Mon, 2026-07-20 at 11:16 +0200, Jorge Ramirez-Ortiz wrote:
> > This series makes UFS RPMB work out of the box with an OP-TEE that
> > implements the standard eMMC RPMB key-derivation flow, without requiring
> > any fundamental changes on the OP-TEE side.
> > 
> > RPMB provides an authenticated, replay-protected storage area whose
> > security relies on a secret authentication key. In our setup that key is
> > never exposed to the kernel: OP-TEE derives it in the secure world from
> > its hardware-unique key and a device identifier (dev_id) that the RPMB
> > core hands down. OP-TEE's implementation targets eMMC, where dev_id is
> > the 16-byte eMMC CID, and both the fixed length and the raw-CID layout
> > are baked into its key derivation.
> > 
> > Two things stand in the way of reusing that same, unmodified OP-TEE flow
> > for UFS RPMB:
> > 
> >   1. On a cold boot the very first frame sent to the RPMB well-known LU
> >      comes back with a power-on UNIT ATTENTION (ASC 0x29), which the SCSI
> >      core reports rather than retries. RPMB has no earlier guaranteed
> >      access that could clear the condition first, so RPMB fails on every
> >      power cycle. Patch 1 asks the SCSI core to retry the power-on UNIT
> >      ATTENTION on the RPMB WLUN.
> > 
> >   2. The UFS RPMB id is "<device_id>-R<region>", which is variable length
> >      and longer than 16 bytes. Passing it verbatim would tie the derived
> >      key to a length OP-TEE does not expect and diverge from the fixed
> >      eMMC CID ABI. Patch 2 hashes it into a fixed 16-byte dev_id with
> >      blake2s, keeping the key stable and unique per region while matching
> >      the eMMC CID layout OP-TEE relies on. The hash algorithm and input
> >      string are thus part of the key-derivation ABI and must stay stable.
> > 
> > With both patches, UFS RPMB is functional from the first access after a
> > cold boot and derives keys through the existing eMMC-style OP-TEE flow,
> > (requires minimal OP-TEE changes pending on the CID proposal done here).
> > 
> > Tested on IQ-9075 with Open Firmware [1], pending OP-TEE changes
> > [1]https://ldts.github.io/qcom-buildroot
> > 
> > Dependencies:
> > 
> > U-boot:
> > https://lore.kernel.org/u-boot/20260720085202.537019-1-jorge.ramirez@oss.qualcomm.com/T/#mc423eb4dcf8a15849077029e4f7c1913bb7d8873
> > 
> > OP-TEE:
> > https://github.com/OP-TEE/optee_os/pull/7881
> > 
> > v2:
> >   * ufs: rpmb: replace blake2s with blake2b so that the same support
> >     can be added to u-boot (CRYPTO_LIB_BLAKE2B)
> >   * added links to U-boot and OP-TEE changes.    
> > 
> > v1:
> >   * ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN:
> >      - fix using uses SCMD_FAILURE_ASC_ANY to retry any Unit Attention
> >      - fix unused variable
> >   * ufs: rpmb: use a fixed-length RPMB dev_id
> >      - fix selecting a non-existent Kconfig symbol
> > 
> > Jorge Ramirez-Ortiz (2):
> >   ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
> >   ufs: rpmb: use a fixed-length RPMB dev_id
> > 
> >  drivers/ufs/core/ufs-rpmb.c | 39 ++++++++++++++++++++++++++++++++++---
> >  1 file changed, 36 insertions(+), 3 deletions(-)
> > 
> 
