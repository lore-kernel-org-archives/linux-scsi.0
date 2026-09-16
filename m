Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4388E3AD539;
	Wed, 16 Sep 2026 02:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526242; cv=none; b=aHNfxYvunBLHP/Qbt+AM2hclFdsJip3JwDxwnRJdi3TXq79LVKajhe190xcqphcxUu8QVN9sZSk4C7dmaXFkMeGFENCfy3viTRIceuuXp5UcWaTlthnjVmwWv+tR7xQ0WmgGJklgPqcxfFsBkjxJFbs0FFHHSEEewRd8VXjq4Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526242; c=relaxed/simple;
	bh=sEWyxsSLvxdF8UPOoTk3qwrJkrNxNUZPc078Gi9r0t8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=d8BIgbdeFYtLSMrrIyQjj+F93eTemylITAxfGiqA0dSNAQrgOqBIaISar6+lRThDiXcmEkQUr/iR+5YkYc/OWowWLE4ek1s2bcBoAMZahVeScjDMUdaseg7Bxv4CPYkAJkEQxBpg5c/+oMOigIYus3V9kulS6wLPko5IEN5Vx+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Txs8Vkt8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Txs8Vkt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69B91F000FF;
	Wed, 16 Sep 2026 02:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789526237;
	bh=+1qHSDx48xAyKCeRw0eoSxxSioX5pqNQgBpxyoOFByU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=Txs8Vkt89cAR8ZV36JBBHKdusMLE5hDnRm3Iq5DJnMw/wdzdQXE7oktiRGSEn/STz
	 KiFA+pHHYs9e59SZI9pBb0MWVI+W0bpZPp7wO4Ix7qiksZ0bW9/+hMdZuSM/f7GCNi
	 mIy7tg72LkekfJgRvTgeL4iFqP8DhIKf51OpTSq9CE0cfvIrkV1DwY1DVK0DpQHTZH
	 uCAd1mbfnqArDov0zcgFAAOj07jtovZXRrSkAmSzhjJ4BQ94irboeHiRyPWH3UZMEw
	 0PqKZmfaYI8WKXFJrTblzMMRHmKIqIwTohA/RLCdEh00KKtD+nxZiVYlngPpvO+cN2
	 5aIWmODfl6yuw==
To: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
Cc: Damien Le Moal <dlemoal@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
  linux-block@vger.kernel.org,  "Martin K . Petersen" <mkp@kernel.org>,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 2/2] scsi: sd_zbc: reject disks with too many zones
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260912080304.78535-3-26066541r@connect.polyu.hk>
Message-ID: <yq1o6dyvsf8.fsf@mail.kernel.org>
References: <20260912080304.78535-1-26066541r@connect.polyu.hk>
	<20260912080304.78535-3-26066541r@connect.polyu.hk>
Date: Tue, 15 Sep 2026 22:37:15 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi Zhou!

Unfortunately whitespace is mangled so your patches don't apply.

> +       if (nr_zones > UINT_MAX) {

sd_zbc_report_zones() uses a signed int for its zone index.

-- 
Martin K. Petersen
