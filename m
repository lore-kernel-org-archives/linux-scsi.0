Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBF6433E8C
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2026 10:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783162520; cv=none; b=cA+YA/j6IoaIlNEnGDGG3NvF4FrHF1xR9N6YStLp/lFoU3Z366EmszN+9M5yaCPiJ7EcLn3mlGZQxUrgkkQ4QLoNA2N+IFuVhLXRTEiS3UXCJLzY6/kmA8y19alLtOVVlE08hjjRcuonxehIH2MG1b1Kb8viLBDCul79mS5Uy6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783162520; c=relaxed/simple;
	bh=lj1D6n0ntrOE6DtRg8V0l8lmR0uUIhq5alUYbQxjFns=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BtwRkUP/4n/ecY+Y2LgDndfkLmqh4nV9rNIblItzCF41kxeN7UXlWt3sl6fLXrAOjLGDS1oAqDLjgNGWI0OyuUfXkBG5KnaQW2/1g95aJ7p0qhUEUemQPANMqvIFzdHyiP8Af80U/m2eySwBAJH3lINFju+/IY5U/i+m+r2np4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=grArjoOX; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="grArjoOX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:feedback-id:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=lj1D6n0ntrOE6DtRg8V0l8lmR0uUIhq5alUYbQxjFns=;
	b=grArjoOXgyTcxVKM6ghIrm79456jRCtDUUpaJCBa5gbjF8bShCvUT7LVNLGM/jPPIlnUId3dIRRFT
	 hmIsAvVVHi2S4+Lgi/fpo7ARrLQCFff69/PeNDKmI1d81rYQwOMC+NOFyAIkXMXonjRwK6CFd/YEUp
	 l8Mu/SIxqMtz/i88oVbX0d6Ty08lI9jiTNRyY56X0OS/OF3rgJ1PA940T60exUlQp1bHXiotpC2G/N
	 nWXYQO8DeZzv4Qndgn6xvXHof+8G+1CoUg2qJ0CwucPYKdlY+FNQts+ZH1hX2U9vlrneGsHiT7eIN4
	 wEuW1pf7MhtKYA73dczUZIaFTDNBB1w==
Feedback-ID: 5c3835a5:3ccff4:smtpa:elisa
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id d0c312a2-7796-11f1-952d-005056bd6ce9;
	Sat, 04 Jul 2026 13:55:06 +0300 (EEST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCHv2] scsi: st: use kzalloc_array()
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20260703215345.253901-1-rosenp@gmail.com>
Date: Sat, 4 Jul 2026 13:54:55 +0300
Cc: linux-hardening@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:KERNEL HARDENING (not covered by other
 areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org (ope>)
Content-Transfer-Encoding: quoted-printable
Message-Id: <129AD05F-52C8-4A24-9813-51A7BA4E7043@kolumbus.fi>
References: <20260703215345.253901-1-rosenp@gmail.com>
To: Rosen Penev <rosenp@gmail.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

On 4. Jul 2026, at 0.53, Rosen Penev <rosenp@gmail.com> wrote:
>=20
> Merge allocations to simpily memory management with kzalloc_array(). =
No
> need to kfree separately.
>=20
I fail to see what is the real problem this patch fixes? I am not in =
favor of rewiritng working code
just because it can be done.

