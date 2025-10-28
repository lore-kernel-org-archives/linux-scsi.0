Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D8E36A613
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 23:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761693251; cv=none; b=mVcWmfOXrs7XWJk5cfv0e0UkN5UdHy/uwwwdGPW81i23/C0YlRhjGSU7UUWueWy7f+lSIRBXXgG9OgzhnECPRNZuZ489DS4QExxZtQxeu0+9Ahf/Dk+dOnLe9sMTMP/FwzmQNH39FgnHQAPbuZX+hS+dkaOciMNHa03/caL7hXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761693251; c=relaxed/simple;
	bh=u29dU8/qES4/t+4BR4wvuMONlWnDzboFCw9uTggU6Qg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=owyVB7TCaSDf5GBeoe74pjpUEPym4owF9AbOLGu6LHkJJ/ffIs97Vw51VMW5U8nORDrvo+7Gm6yXNojMTOBsdsdr7d0zaz7fjuvVNtnJ1U/EKgK2La36Iy3GsSKDonql4FEFmbwD/CCweBlfQ+EmP/o/w5G8TAmIVuW3Ks9GJ5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bbHIjeEg; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbHIjeEg"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-73b4e3d0756so67435707b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 16:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761693249; x=1762298049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wZnFf3Rr3KgnMO5LFhYQM3Etm2RoRmvVo6nl3KakNw0=;
        b=bbHIjeEgrE0wiz6NbJ8QXfYoA1jbLrSJPMtohobweOLRuBXUNKdtd7+1trjKabIu79
         qaFi5IxU1JsY8ET9Ds4ZjgaCgLIqbpNcaLfuiWF98AjI6nc0W23JMr5A2O6Xh1h5P+Ae
         gpBwX0pxSmtKyjiqlRiur4EFzLxnOLHhqQthAIxdRl2uLTQEg/8obnH+cSX1kX4yKGPR
         9qUacWESvaL6MUDJBX+Dw3T3UFpXR/AbXwOhalYroSodSp7aS/LD/DqMC9sp164ceMfg
         /lm0pITy68ZnRRXwC/5S9tTU2YSFb7L0lAzL5MgNjlTuibXtKqbPZpa1+wqgpbRBda/+
         Aggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761693249; x=1762298049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wZnFf3Rr3KgnMO5LFhYQM3Etm2RoRmvVo6nl3KakNw0=;
        b=w8sN76cHCo7PUhg5rZYP2v1TXj63XR2jUzZJ183EQ6+4eQ4YaGtpP8wiHKzoM63/d9
         w6iQ6on6KEOxV8OGtz6NL8AoMzzcPYvxXaYb8u4z9c/T0LNIvEkpG/2Wm52ZFlQg72y2
         BBprUivqSyK8g1r5/yrpPBqdZ26J+hus8j1UxiQWUePLrSsYlPhfeUT0wRlVa9+G1Wh3
         Ryoq5VNapaoB5YTA/O79EupcrUq5I/A367rUCpkQzby9M1nyw8eQk1uvFarjYNRs703b
         /HUwFHbjUKflfefdGFLP11rsteMgJDtr1rFMg26oOTpjdpBJPfgYwz9mPMtbxzl8eIjx
         uxMQ==
X-Gm-Message-State: AOJu0Yy3GsNTrZ4Qao5g7sLLrWxkyf2zphfshKmPszs//0vb5HDFMYAO
	vgVEvuzTL2zYXlo62qEjbvRjCosBpePxn8k8DHf/0JsqBFdk8zUD9G6yetZNlZvJubIPLdUEYDu
	dTmrLpd6rrT1h7wZd1cpWdjN5/JugLM672uEH
X-Gm-Gg: ASbGncsRNZ/SQahKMzBMbWBHBiYvZsDoZZNQ9ywFQEoY+L5ps6SfR9R0/S9QivxKM4O
	LTyuM91pI+jolbu0+uWUAGdnQUfRRQYFJCDs0FCZibFeHmrozlbs9dtgYzP/RG64u8DFEVwiiBd
	RzIcVwiMOoS7AP2cDVsysLYroLf1DQZc5dejkNarwgdgvIvKzxTJZpaa45N/BtXxrYYDkDWhlMT
	2XyLZivoWomTp7Fpf+gvPWaEzSGpJutMnYPPlBd+s+Opa4crZJCb9b8O5YHVA==
X-Google-Smtp-Source: AGHT+IGotPi1I2tC4VdtpOz6kGS5HPErXwuRoribIqgM3OHq7tM6YuUUvdc1bi6sypxq/wm/+O6uFjchavwIsb4jVOk=
X-Received: by 2002:a05:690c:61c3:b0:784:8647:4958 with SMTP id
 00721157ae682-7862901c1b8mr8445967b3.67.1761693249134; Tue, 28 Oct 2025
 16:14:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027235446.77200-1-justintee8345@gmail.com>
 <20251027235446.77200-12-justintee8345@gmail.com> <0e8f0242-6bc2-4202-bc6f-4aeb0d150e21@kernel.org>
In-Reply-To: <0e8f0242-6bc2-4202-bc6f-4aeb0d150e21@kernel.org>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 28 Oct 2025 16:13:41 -0700
X-Gm-Features: AWmQ_blK-sRd4H5LkJmJXK_pvu630QG7fLENGJE9DiuohI-dgnQukLaYmE_srzQ
Message-ID: <CABPRKS8=RMCC7kY0mcR95W8rGJAk5xvc3qQqkAXq+T=7pK-c7Q@mail.gmail.com>
Subject: Re: [PATCH 11/11] lpfc: Copyright updates for 14.4.0.12 patches
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"

> This makes no sense on its own. We do not care about copyrights and such
> patch has zero meaning to us. Plus it should be result of copyright
> work, IOW, must be squashed if at all.
A separate copyright update patch for file modifications in patchsets
is what was historically requested by certain Linux distributions in
the past.  But, I can certainly repost with this squashed into the
patch that updated lpfc_dish.h itself.

> > Signed-off-by: Justin Tee <justin.tee@broadcom.com>
>
> Does not match from address.
Sure, will revise in an updated patchset.

Regards,
Justin
