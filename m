Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131E02F41
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740747913; cv=none; b=BV0NG5s4YIqjgaNU450IeHMiWX/bIKO+7Ku3Epepctsy+Fs0gpjzn3we1NnZl9RECDuHRqUvEjBCthbjgAlcBYrCNtHh77CDack8l5d1jfquyQOnqoTh9y2zBgi8e2hh+tDyLHqUIbOr7aH7yTQ6ZKPwVayp0eo/IMNdZXM9+vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740747913; c=relaxed/simple;
	bh=VSfL1qZGH4nQoDcv6JU+HItu/g9fzCs5ffSMTFtIeLE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XD3PhprupL3mIWB6jWx6O27IBOO8ay2lAy0ceahfMFoknkMU7khX18Nc1SFh6qYJDPr6COt7OCia9pW54qIF4lEuO/QRT6Z7KrFQK3/PnBRX+R6jWezP1DD6+LbZeULh/1PbKxOw8BdIdaZqlsEl0JV9Vhj9DfHTHPthxLQZ9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=skQs2/tf; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="skQs2/tf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=VSfL1qZGH4nQoDcv6JU+HItu/g9fzCs5ffSMTFtIeLE=;
	b=skQs2/tfHxXV1B45BYj2gtdXl0pXGrNCJ44weOUu56g+v8ZnGyPSVp8x5WXvi8NzBT++E3CnbqryN
	 KCJQ5lJjKBv/WPFaYvX8jHtwQZOdUmLoL+r36tvuehaarCGQHvP5JBLiSwR3OpuHgng9Ls7UTa/iQa
	 K1v6stVa8KONCW67G47yl3y7pzs+urGLqMlkMUcSuUNcD6SKmMNbrENaRsPzL4IE9rJ7ImCaPnKyci
	 fa1PkS9u60nUWjNtFPHDHVCErEkgaaHn5K0V1W4AQZ/dfNLfGrHCVxSpJU2wnC8FPfuv+egJ4owl9r
	 dMsatFK0JZ+VO3B7qLgbzABq+HHn1xA==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id a2bea21b-f5d4-11ef-83b6-005056bdf889;
	Fri, 28 Feb 2025 15:05:08 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH 2/4] scsi: scsi_debug: Enable different command
 definitions for different device types
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20250228124627.177873-4-Kai.Makisara@kolumbus.fi>
Date: Fri, 28 Feb 2025 15:04:58 +0200
Cc: martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E41CFD74-F369-475A-9E9A-A55AA24C910C@kolumbus.fi>
References: <20250228124627.177873-1-Kai.Makisara@kolumbus.fi>
 <20250228124627.177873-4-Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
 dgilbert@interlog.com
X-Mailer: Apple Mail (2.3826.400.131.1.6)


> On 28. Feb 2025, at 14.46, Kai M=C3=A4kisara =
<Kai.Makisara@kolumbus.fi> wrote:
>=20
> Add mask field devsel to the struct opcode_info_t to enable different

My mailing script picked up two versions of the same patch. The code is =
the same but title
and message are slightly different. This is the latest version.

I am sorry for the confusion.
Kai


