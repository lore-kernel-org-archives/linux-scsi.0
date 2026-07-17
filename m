Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197B83E4C68;
	Fri, 17 Jul 2026 10:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784282702; cv=none; b=j+rDJYXhRT86yB1MWkcPwSiSAgMHa7C24lwWU+iNU8W9tUXwgqoFEpVh/bnE9rTaPmFE1ElwazPgM3qNAXmIe+iLZZP4s9eqf3H0H+/IlG7kB1WuaK2FBC2RX95Fx/o1ttbnpIkiPEkZY91OAVLEjaLynDZPCzbAaRXkjlXmZe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784282702; c=relaxed/simple;
	bh=uWN1w4R/NNcBFhkHNt0/6T05ueR0mTcnWaqUi0OgmNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFIGny1g4IeEq2kPYnv6W73bPGologO3yD0B9Bb+aOybSqGZwGTJucvGb9VGnSmVLx9kMsj+zDGvxsoh4He74fhgX53SgOniSU0VqVMReff4KSrFSZpKBCQydQfljeXmKpGEk0Csc5Vck1TiYwvswFHapbH3Z5+r1AL9VCgx53o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=A/ABolTF; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=5gUHoDab; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="A/ABolTF";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5gUHoDab"
Date: Fri, 17 Jul 2026 12:04:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784282696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWN1w4R/NNcBFhkHNt0/6T05ueR0mTcnWaqUi0OgmNI=;
	b=A/ABolTFPY/NkgZ366QNHXLJBJ4dQR6kVcCvgqKyh+0yqeNRBOnk7GHJCCyc4knAJU0K8N
	8HwEBTKp6iqDm6ryHX6Ah49mUcxl/3izYtt3fIC5JWAiE6cLBbnAZfdfSeDmGubAku/mxo
	tgCjeQSVR2/PsL9Vq/55gd7jWeJ5xDGj6w0tVPXQTaltCDi6kAAih3/KusM2BPyU5Nhxdl
	1yu8lABhe6zPl1OJ3+nOWJduiKndrFv0xQZ3IENtDaSLgi3RdpwDDi63GOdkM4gfjplS2A
	P9c4osLgy1GenPqXfC7OU5OC1Ybmt5qqzyhC5OH8ip2y8WU/kRKYgpYYAzcA4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784282696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWN1w4R/NNcBFhkHNt0/6T05ueR0mTcnWaqUi0OgmNI=;
	b=5gUHoDabpJRWIg7CuHgB0yxd2zqWpr8Ipp/Dc2500tDwWKDVovRwW+UU4hY2miyaxGI2OQ
	hOCK07ey8OKicQCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Adam Radford <aradford@gmail.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>, Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	Yihang Li <liyihang9@h-partners.com>,
	Don Brace <don.brace@microchip.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Brian King <brking@us.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Junrui Luo <moonafterrain@outlook.com>, Kees Cook <kees@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Lukas Wunner <lukas@wunner.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
	storagedev@microchip.com, megaraidlinux.pdl@broadcom.com,
	Markus Schneider-Pargmann <msp@baylibre.com>
Subject: Re: [PATCH] scsi: Consistently define pci_device_ids using named
 initializers
Message-ID: <20260717100454.gUu2taN_@linutronix.de>
References: <20260429101820.3059523-2-u.kleine-koenig@baylibre.com>
 <aigySpryV0ptiBqr@monoceros>
 <aln8-b9iFDzAPo6V@monoceros>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aln8-b9iFDzAPo6V@monoceros>

On 2026-07-17 12:00:27 [+0200], Uwe Kleine-K=C3=B6nig (The Capable Hub) wro=
te:
> Hmm, it seems it isn't? Who is the right person to prod?

James and Martin are the right ones. I suggest to repost.

> Best regards
> Uwe

Sebastian
