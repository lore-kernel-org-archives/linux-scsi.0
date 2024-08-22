Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D605D1EB5B
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724336273; cv=none; b=kO9IoCmc7FsTW8XhYg0Vlv+D68OJjluvBIXoI6n909YFAtY32CePoH+Qj2q3fS9vTxCKB6QyISOkhHTsuBN/ngE/O0iQSOFeYj5XEadQfbsob/JeotCuCFew/lljUONKnAC2uEwE327xhOUA4ciEfkySDIes0Ai+46LdCkb0LDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724336273; c=relaxed/simple;
	bh=ayic0h7aGWCMkrFwLdaig0kTAt32T8VJpgUnHbDPex8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MvjDo91kpT9twFMEuhoqY9dKOurUyW+C5ui5eaZZy5v1mW09N9Ue39BMJgZc/2QjgZ+rMj7VeO7H2N0MzHgmc5decL0i9iaqBoia5vcPOCJQBbUM8aD5eIwUX5Pm222qcylyP1/nJfJXPn68YTpLCQgq5onDVUOeB7Gb5IE0PUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DNosrVOt; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNosrVOt"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a7a9cf7d3f3so128451566b.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 07:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724336270; x=1724941070; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ayic0h7aGWCMkrFwLdaig0kTAt32T8VJpgUnHbDPex8=;
        b=DNosrVOtT2vJEJVRTRI7+Qdi4ck0AD3y1l0qrYEXIK//mM7yRAAC1Mf+f+iEPLuJEr
         uWHFqKVAxwVUTmwqeiIUfFdYE3k0nerivj27uRSjeqwVNaOhukSRHOhwH3zAxY06550z
         gNGDVVjuQKF/vMOg9pdb9elbyGcTZj7/zGO0GjulNVDZieKIxpp8WIyAXBJTV6DepigE
         K/6OiVFNWnc4KBz+LmGKkvvl/nBIz+EZUOFLvvaonUbFHDJu06id2LV5qg2DYmRtUzh8
         nKq75Snt8ZPxii7CrZW6JPfzi+UObnthdo7rJB0xye3jFjZEeyKx5Tf/zdieQWIwvDZx
         jSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724336270; x=1724941070;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ayic0h7aGWCMkrFwLdaig0kTAt32T8VJpgUnHbDPex8=;
        b=f0B/P35KvZtR2YPkqHk+sIIy7L2Ot5dRoRhCKvxVpKNb2ZRWzTHV6zG6SdOewnt4QZ
         g7fkNSMyaIcIhRLVy2AW4foewB2G1wkvXY72ald72SCy/3b8OS1svsKeg2AU6jUAEAxy
         B8H7mvD2HbONY/l408fO/g9EtysTmvrViRifJni4gXSdmg8bpfiB2dy8Ij8443ljJcjd
         jlTx8kwJeiReljjYh0feU+VjEZkHZ9Og3yTnrNG6puXbc/RGZOM9ll/hm3qyMCKMyOm+
         T24I3laZOoh4lYt0PuxfhHAazR+f1uQqSVYUlHzs/kp90za+guEJaFDUXuVt0UA5LsfY
         JPpQ==
X-Gm-Message-State: AOJu0Yw3qfvBM+cNTTbj3dAOYNH+NUcfx/olMeWWlkZw1J6kJBVI4Gb9
	SF0qcF7qwZnHjJAWRdTx7tE3oL87FwjNQO+QBsnIltmGPeWqv26q
X-Google-Smtp-Source: AGHT+IGvDMbTCAdTDvElB+zD64N38BAlHP1dxq/D+ox457/4VN3bhDiPIL0woAD8RVp9//0Ur4tiDQ==
X-Received: by 2002:a17:907:3d8a:b0:a7a:8cb9:7491 with SMTP id a640c23a62f3a-a866f8f391dmr382026466b.54.1724336269573;
        Thu, 22 Aug 2024 07:17:49 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f436bb8sm125983366b.131.2024.08.22.07.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 07:17:49 -0700 (PDT)
Message-ID: <bb2a1649ef94637f236dece7255d497f7fe03f19.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>, Alim
 Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>, Maramaina Naresh
 <quic_mnaresh@quicinc.com>
Date: Thu, 22 Aug 2024 16:17:47 +0200
In-Reply-To: <25ba6504-9a10-4c59-a180-620ddfd06622@acm.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
	 <0e552232c1759ba1749acb9b606a03670bbe1ba1.camel@gmail.com>
	 <25ba6504-9a10-4c59-a180-620ddfd06622@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-08-21 at 14:39 -0700, Bart Van Assche wrote:
> On 8/21/24 2:27 PM, Bean Huo wrote:
> > My only concern is, removing disabling UIC completion IRQ, and
> > keeping
> > is.uccs 1, then we don't read its status in case of
> > ufshcd_uic_pwr_ctrl
> > path, whether this will affect the next UIC access result.
>=20
> Hmm ... I think I need more context information. If the UIC
> completion
> interrupt is left enabled then ufshcd_intr() will execute the code
> "intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS)". This
> statement
> reads all bits from the interrupt status register including the UCCS
> bit, isn't it?
>=20
> Thanks,
>=20
> Bart.

One UIC power ctrl command will generate two Compl interrupts, one is
command complete (UIC_COMMAND_COMPL) and the other is power switch
complete (UFSHCD_UIC_PWR_MASK). Is that right? I checked the current
code and we don't read the UFSHCI registers except when we read intr
status before ufshcd_uic_cmd_compl() and re-enable UIC compl interrupt.

Do you mean re-enabling UIC complete interrupt will cause the problem?


Kind regards,
Bean
