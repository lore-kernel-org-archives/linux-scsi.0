Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C33B18950B
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 20:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724964520; cv=none; b=u3id5ouFYTotC5p8Eh6DR2PzP/X6ZN0N1FfNUAkfnum2ar/aUkkJ0yVpeYq0vHQnm1ik+2GFrh5DdG8cg1cVR1tEDQ4HQXUfZNMx4CWb8+pb6vMh8dd817T2YsplbTfTCyb5+PfWwNUAStSOa4Ij1Zib0lhuGotR+S9GC8IGNN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724964520; c=relaxed/simple;
	bh=HeGUcpjdKTizRyMkJLVtkySi61Br0ZmnDQQ6LLUk7Ew=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MHycBPOU0utVCaCPYCjKC6H/XlvRWK1TWMpZL32djArvHuDWYHIYwO7fqEH+Ugr/MN7ReGr/qfQJZGrZACMtfExxwPYQYB6Aw6FUwIi7V7g9KHdlbjNu1v5uQ+RNnfKqgIlfZ1xeumvNhZMNextZXqzbmpYWMqjwP4hKd+mPm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hks+/E71; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hks+/E71"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-371a6fcd863so735524f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 13:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724964517; x=1725569317; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HeGUcpjdKTizRyMkJLVtkySi61Br0ZmnDQQ6LLUk7Ew=;
        b=hks+/E71aJfAkFZzAW9EvviaX0Aai8sy3mvlsgkHxi8LJ7byi7+EB48FYSlaUBXNXC
         Dfd2VHsAEtm1UYpUjLHgdchaN1bEZoxEZYkT8sBQh2mngfPfjj+EsweZwfQPgzg8+V+p
         82QoAN5PzfWQirYd0lN+Hj4tVtzs5wl8/tgAhN7ZYxbFy3HuvpefywCEBtN84rsHpXiW
         mCw9EF/WBHsF0hS9Vkhu0mzUj6JqBRev/EYUvKZ1f+d9ePeXShdd8iWQ+kfV7F3ZGj5J
         gBLm7tY3YTRN1/SDfrMZ/PQ6LAcLO5YptMOhilYunA8QYcYpjGWwj8yP4vK/KHbxEOL6
         floQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724964517; x=1725569317;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HeGUcpjdKTizRyMkJLVtkySi61Br0ZmnDQQ6LLUk7Ew=;
        b=SDnoWHJ/lPB9p8TNFWm2qebkL5EOp+2jVWs3KFt7QxL3unmndccsLNMycdnqF6adqa
         YXRPFJhnZ6zGkvAIIHbEvj4gZaDRmDJqAl1LjeN63nRMst3Df0qM681IrYv6t2WGKZaV
         qQWa6BbAgBnyUJRk8Ujy+0AxqAAK2Rok1QpR4m7jYdfFUH03SRSZM4Cmiv70G5hCFYmJ
         edgO+bBSabZRkPrmuy3vPp/G8egbSsj4jAmNfr0b65g+9jeUeonIKzCnkPTjt+Gc56Ph
         B/jGyCAEQ+rT1SB8f1TFxwlg4COWs+3A4XkMR+tfNLWz3R0PdZ3aWHXNKZZ0pRId4rZU
         vX+g==
X-Gm-Message-State: AOJu0Yy7lwa4C33YsTfuwmC+o9YM4RnPDu0QYApmlc+ddg/smBcOXmBF
	Vd3QSYrxz5/WyDjSY9VsqUg9jqyUh7EJLl5pQJNO/0FGMWkVuHOC
X-Google-Smtp-Source: AGHT+IH2JgO+r9iYghypPu4pqCMJtrMC++YtrfV/OszVHTQiDTeaIXA/obUjFk53XoYAW0BCh7ucDA==
X-Received: by 2002:a5d:4a07:0:b0:36b:357a:bfee with SMTP id ffacd0b85a97d-3749b52e5d2mr2644698f8f.1.1724964516185;
        Thu, 29 Aug 2024 13:48:36 -0700 (PDT)
Received: from p200300c5873875912a1b625802803f97.dip0.t-ipconnect.de (p200300c5873875912a1b625802803f97.dip0.t-ipconnect.de. [2003:c5:8738:7591:2a1b:6258:280:3f97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee9bd9esm2235481f8f.57.2024.08.29.13.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 13:48:35 -0700 (PDT)
Message-ID: <6fdda3470cd5b08274fc3f11ce7945acd30bd37e.camel@gmail.com>
Subject: Re: [PATCH v3 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>,  Peter Wang
 <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>, Andrew Halaney
 <ahalaney@redhat.com>
Date: Thu, 29 Aug 2024 22:48:34 +0200
In-Reply-To: <20240828174435.2469498-2-bvanassche@acm.org>
References: <20240828174435.2469498-1-bvanassche@acm.org>
	 <20240828174435.2469498-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-08-28 at 10:43 -0700, Bart Van Assche wrote:
> Move the code for adding a SCSI host and also the code for managing
> TMF tags from ufshcd_init() into a new function called
> ufshcd_add_scsi_host(). This patch prepares for combining the two
> scsi_add_host() calls into a single call. No functionality has been
> changed.
>=20
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Bean Huo <beanhuo@micron.com>

