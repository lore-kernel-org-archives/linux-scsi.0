Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D818DF80;
	Mon, 24 Aug 2026 01:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787535970; cv=none; b=TjS7/WkVG4FLc/mZ1fGxaXelqqzoGcRFqafm+Hjcb/2WthC6qEs7g5KZqtBI32QtVEwiHFyFFIJD6TUd+2wdLcpFv5mtVhpRxYDdBMXEzn0el0mg2pAug6YCoX3O7qg7n4/9yAjn6SbILspR83SdWmcxT4DjhDPHc9w2poXs9hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787535970; c=relaxed/simple;
	bh=xdionEwZ7rv79S4Fslq9yCLQmIfavIRIsURWlDX8NCY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=pyr1Tw8F794OyQm9TsjC5C1ZJoDsvdUHWx1HHjB28gCVA6rxCeLUPsR9GECOLyiG/3/iGE4Etk7+bXzec9HW9PMlA79x4/8ARnBimfqjjLYeN8IbsTw9tLtLvEGDQ77U1rvZ62kwdfY+ok7gKkHbLsMhyu8NdY3sbrja2u2Nosg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFl6ALVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFl6ALVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09FF1F000E9;
	Mon, 24 Aug 2026 01:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787535969;
	bh=SbtRND+smjTExRAIyFpMx6vZqlcjcbq/FmX7kVb41dc=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=TFl6ALVxKqbFXllLJWXAmep4pTATLtvsKLcbK1ZEMP4fd5JfVk2t8dXzRFWRPD5ir
	 BmU9Hafw2U/diwKmgiTggh60OeXQWVrEPe9V/A6cTQ5B2xJJB0eHQpO862mYKOdrd3
	 35GtiB3C5oMmqyFy3I4PG4p6ZQbEDisTvjUF0QWe3q03DsUifsV+yAoYpHyQyk98SV
	 2iXIzbzDHik/mxbVMefFm1Y6aLY5vti1NYZgWcf8iRKJ7kUhwQJnrMBYYbaXpSumtw
	 sKtV+nALBS2ZHIBNK1s7aKSEDOUWmHPVWSvCrndTR0vMpiBu6QfFsYUbPNjo2uIfMa
	 FrHBqzxRvlumQ==
To: Dan Carpenter <error27@gmail.com>
Cc: Nilesh Javali <njavali@marvell.com>,
  GR-QLogic-Storage-Upstream@marvell.com,  "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix an error code in qla_get_tmf()
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <an1taxANE_4_vzJT@stanley.mountain> (Dan Carpenter's message of
	"Thu, 13 Aug 2026 10:08:27 +0300")
Message-ID: <yq1bjasp9yi.fsf@mail.kernel.org>
References: <an1taxANE_4_vzJT@stanley.mountain>
Date: Sun, 23 Aug 2026 21:46:07 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Dan,

> Negative -EIO was intended instead of positive EIO. The caller,
> doesn't care so this doesn't affect runtime. It's just a cleanup.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
