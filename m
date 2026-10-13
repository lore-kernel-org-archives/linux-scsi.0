Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F935448A7
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 20:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791923496; cv=pass; b=CwHKG+xYaZ/qbwOxZQuVZ+Vqit1nXmgLvbNa8qmonzoqx5yW9IlnrBf12o+4agECQrY4GKPykjI6GpRlCCe2+IH/s3YPEK+xfZ88A1vYXrXr+0NvJ+aCR9fj0LSFisbiQ+uHA5ytkd3fxBswY4/VjWtHz5M6qsmxPKIkNRxz1ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791923496; c=relaxed/simple;
	bh=P1U2KJcqn+7HTIBgCJXu1/5Q+Ev60OJUfqLEphUdszw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ON8GW+2sqXJDKBo6AFckIUg95FVqdWhzYFcEdu+yhxSaFSKsu9KovJINGwYRHU5CndLdHQKqBeui00vTYyN+NpDqo3IrNCUq32soRknzo+KrGLpJEcAqqXHqROy7KFi4DBr2OSToAwDryd1Z07bo/gMXYiwg7NX4gTmfJq0RSQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YG6QR1y/; arc=pass smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YG6QR1y/"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6cfed5dd071so2437846eaf.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 13:31:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791923494; cv=none;
        d=google.com; s=arc-20260327;
        b=ovhdFi9cfROY49cmyGxMjfZAhqq+ZPyPxgRzUr4j69Mt9OpmZa31AkKsiVvJj/9e2h
         rOOaD0/N4y71HGHKndoHpX8xtSH2W2Q43thagF5kddr0+2V1sLxhIbiva+j0Y6BtLxY4
         +n4+LRlvIrzip07RZxTXJVOui3G6sX29yfNX6LFSwZjdxmKlJ8wkYQiPIujXe2OtNxj8
         GTVfern8yn980C2mQKX/sjnDWR9sMO2R70j3SPPFNVKMIzeznz0BMg8E2SYiXsU4kKg9
         tRqwrg819iV5Zgy/JOpvf3fW0j3WqhTTrBDCNzhr1Tyiz63RDpK2J1aVJzeLk0vK92NB
         SjuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=P1U2KJcqn+7HTIBgCJXu1/5Q+Ev60OJUfqLEphUdszw=;
        fh=uq6ftltCNSGEJVQuHwwTN+87IRZqlNtbihEcoHlQc1w=;
        b=ozOcY49BVtkHAa0R4A9z+R6o+dEs9GR00/s8dHiYCnsdIFGHCi/fqMX41F+qD+VMh9
         BYjAF4FItKJOx7jR9H4eWFSLyvGC2v7vVmRdccu+0lXwKYvNKBF/7X+1nbL1g0UCzAOy
         spOh7D0YxuT7mRKq9EvQH/1wsirbluPAQVOuSunejk3AklOq5tHn+zh8WMPFBY7Irhqh
         sB3sJi/9CxQj2gzRwjW8o3phE1FN6JWz+8iyLjdOC5IHlo+Zx3sB8Twn1fy5+GxiQ0wr
         x7+elRrbOCHg/QYJbS0T7UD0cg3w7P397iLogEgFBcXCarTlWYipmuprjJpzBNwAHPgp
         hddw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791923494; x=1792528294; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P1U2KJcqn+7HTIBgCJXu1/5Q+Ev60OJUfqLEphUdszw=;
        b=YG6QR1y/XKAfrLQ4/T9vTs19LcGRORCy1/+DUXw4ZPzcQ53q8cpQ3SbjffIIdu5BY5
         gVk9Cpo4QHwOcc15oOvS+TG5WcJ9upIPzgwyNCrhlbDePvojUcBO43+Nc3xPXSDHJC0Y
         jg35IKXtJW0uLz41imRw8NKkA268/WEmLSuXLH9UiJTS5uPQ6v31IfeRo+7HZq/m1h5D
         SWgEQtUNz2pl2HqUeUFDjhUKCwKDdh3jiLDIEF7EKgH7fFtJMhzNYIOUTKpbNy9j9jHL
         zuCzaEBZ3jXi2unuhWn67nCqyD6UNudqF2rxZieCH6suOoZ9UcYRCbhBN0ypoTBPV37H
         EjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791923494; x=1792528294;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P1U2KJcqn+7HTIBgCJXu1/5Q+Ev60OJUfqLEphUdszw=;
        b=hpoOcgkZQlAhllV9CeXv6yeQ4HnTCo67yYnj+JwjSV+1P/i9kXstv8b/d+uhcq8nE8
         aiPJFpqseJNMAo0NZAA1KLyMLtBbE9eQJJt0+kj48HVNdXT46VqNMfVd/QJJun7oo9vG
         NTXxjhFmHh05zeHt5BryR1NdhpJEYdvadr3iIhsg+h6XdMxZNJEFtUfmC+mLPm+5tJid
         sHkBQSOJ7WGHHzm8XJ3bPPa60N+Z52i6/RBy7JPJte/CIM8qelWM71KuCFM/XjD3xHhr
         ZmYDsOIAyivWxoHK/rz8oZleiA0+nt/6to6yBhIXWubMIqEhU9OGr6uf0ZZyhArNLTcO
         Gc4w==
X-Forwarded-Encrypted: i=1; AKwUvBzbsUtdD/UDJi50YkwG8r4vt/HUGeXNxs8V2h900igRZTZq3xzVw7e05NXTt/4e0hvoA3lRXpwsJjah@vger.kernel.org
X-Gm-Message-State: AFq9FYI/SzDx/9Lltgmb5BbtkhFbtbC4eCj9zvwxxCmj91az+AzS+TS0
	hLD8Ne0oyLBByOuOcB2VtGhUJAcrth0k85CFAXd9HWeyv2HqXI6lTx1rgfuDTpmwEBlUH36cPzH
	vWX7nrTuHWfGyupCRZXkKSTa+7zmnI3U=
X-Gm-Gg: AYBFou2GEaIADOcfSPbcuDI5HgrJ3/pMQFvJENvF/kywxAEr5q2RUZecxA34MBGpC2N
	6Vc/dSlRN59kjQirDdpLTGnlUBN+vlNxhbrH3DLwUi3gHHhtHpCUNVefRuzjWXg2lxyvql+xJ3Q
	gO0zWGhHB7CcWfEz3p+Q6UQb0/3CEafkpv3I2kIna1xmkNvXORFQD0nfIFBKARTd59V01HmWx8o
	A9Y7T2IWHalYhrpnHSv2uvD+EP4eyJaddyoHkbwr1mssUnAZLdelre9udSyxP5f94AL4BA4OBf+
	e/NmEEA3cdhctSfizwYEgRie9bAz6tCgFqM0F5x/zNp3qvBszyicvE5j5OaOkFM9DIUqGHrEgHQ
	H5T6yZn1cu1qrNw==
X-Received: by 2002:a05:6820:984:b0:6da:82a6:3a13 with SMTP id
 006d021491bc7-6ef0e9dc4damr8661799eaf.28.1791923494303; Tue, 13 Oct 2026
 13:31:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008184328.2857037-1-andrey.misyrov@gmail.com> <irfspelsns7bao36eh5i5gebv2ktqguoinjsvmeebmwpbet34h@kuteiore4fx6>
In-Reply-To: <irfspelsns7bao36eh5i5gebv2ktqguoinjsvmeebmwpbet34h@kuteiore4fx6>
From: =?UTF-8?B?0JDQvdC00YDQtdC5INCc0LjRgdGO0YDQvtCy?= <andrey.misyrov@gmail.com>
Date: Wed, 14 Oct 2026 01:31:21 +0500
X-Gm-Features: AclHuK-SxhHlzeO_FcT0DBvs6n2VY866fwKs3FpS2QkVVf-UWDK_UKtl7-bg2Ro
Message-ID: <CAC=piAoYrNzCX3OutKpoEPVEcJmGttTA0Z6NP=vE9wBK=kqPzA@mail.gmail.com>
Subject: Re: [PATCH 6.1.y] scsi: lpfc: Fix use-after-free of mboxq in lpfc_sli4_driver_resource_setup()
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, sashal@kernel.org, 
	paul.ely@broadcom.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Oct 10, 2026 at 11:19:35AM +0530, Abdun Nihaal wrote:
> How did you detect this? Just curious.

Hi Nihaal,

Thanks for the ack!

I work on kernel live-patching and hit this while backporting the
CVE-2026-72087 fix. I just compared the 6.1.y version with the mainline.

Regards,
Andrey
