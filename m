Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1B43515F7;
	Sat, 26 Sep 2026 02:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790390125; cv=none; b=YVY6U4DqCNvuCINraHvBk7s0yvJzbAG3rbuDzJg4L77FbcOtWO+9ksnbR+clHIJaFyeQycV4fsx4lXiPvO90DgT18pv5D8KjOlK1Ao25FKhx8XN7lfSqadL5VZ5DW+LQ9dbci6L7e929P/aWLlyefrx1mHd0knfnIQWmdy4GxHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790390125; c=relaxed/simple;
	bh=OJMxgEox36tYozF0iWWdmi3CQZcsDbuP5fXNMc4gSME=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=DMZqNEn/MDosRnVrX3CFhnoT/R15iS9HziQOXBm2cq3Kqc4w1glJi2+/UA4WyzvlDj5eJmnKL/55RE5M8tfqYuoKymujeCCAJd5WUtblJWKZIdDDHPSgn8LFGbkAAGn4V2WZ7p4oeXhgpj1/Gr3M6R98ND5+v5mX1NRlLwiwTPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtkQuMAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtkQuMAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4C21F000FF;
	Sat, 26 Sep 2026 02:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790390124;
	bh=QYTNCSyn+MnVe2CYrE8mENVHio1Q92qRhf5glKT/NiE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=NtkQuMAa86y1Z1iD8daiiy7wOF6HDa60+N6f3ZIZ92EjoS78NyEiM32fq318fa1Aj
	 PB7imPFk1miaUjB9DT1qgKOKYVfJ4gyLNRjciq7m8LIJCxGocyywzj9xIURimfKvIB
	 Cyczl55t8+4Z9nvz5s+NadlCN1qKLjofjBo++X2rj7B7Rerfad1Zk1l8Oem3P0c6qa
	 yaGpl1Yb2OErAHbqizFwc9pnme/A+swg7nq8uQkbLydcU2mHtERE2IfT512IQKzQ/R
	 0d8dhlbVumQXRreXRTmeXSXhx3wk8cZApPY2n/C9PGZVUFd8xo/BOycMs6b2LdFz8E
	 J0QGM33KXdicQ==
To: Kees Cook <kees@kernel.org>
Cc: Don Brace <don.brace@microchip.com>,  Kees Cook
 <kees+treewide@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  storagedev@microchip.com,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: hpsa: Make buff allocation type unsigned
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260917211137.i.357-kees@kernel.org>
Message-ID: <yq1ecegpwo1.fsf@mail.kernel.org>
References: <20260917211137.i.357-kees@kernel.org>
Date: Fri, 25 Sep 2026 22:35:23 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Kees,

> The assigned type is "unsigned char **", but the converted allocation
> type would be "char **", whose elements point to a character type of a
> different signedness, so the two pointer types are not compatible.
> Take the size from the assignment target instead. No change in
> allocation size results.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
