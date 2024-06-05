Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F259831A8F;
	Thu,  6 Jun 2024 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717650142; cv=none; b=CzLKRFehFRWve3GkFDPxoV0OOvX+r25J5TUlN58MYfw1exMgBsZO+hkaZsS5fMGBrf2tKxp/VytWGmo+HAUSTAOy8LqRXG01yIqpOIgvLVn+7XJ9qPkOiFN8RXxG70ZzFONvy2Qg4SXFhNZ1sDyrfXvgMYN/4IHFnzrqUzDYYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717650142; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D79jmlYNFawq0+3ovLJxQLdiB3iwaKoo+ldGmvX/sADaDN3+4v3OWMJuL3CUimwhvM+LQWSTvC+BJfjbLb6Wy7jAan6B1V5rb1k2gvO7vtVHzlto4r8KDdd9diQhccDCsRvTR6Z3Taw9IrGpF8rqErGli7ajImF7SPR3MasQhkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXugaK8E; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXugaK8E"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6f264d5dadaso269650a34.0;
        Wed, 05 Jun 2024 22:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717650140; x=1718254940; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=OXugaK8EfXgybpgiuR/a4ldF9V9+1FcUO+/0aLHy5U88/tjJGaNgwWlKqZB+oqgKF/
         wic++bd0rYkr8R8pxtcNRoVFbZrS7A7yD6PduAx5DSa20qBG1tMs3mq6xlHPXrZKC6GX
         0FPukP6x7eWZY+Np9ZHDtjUvpnRtsPDXxhWP9ja+Q0a+XCGJHxu9l1sV9mxlEFDSpY42
         AZS+adHnskHpKAcLaU+6jiv9h7cYlrhkWNKjhPBkNXcK/4sHCL+jLAaL4XUAQZl925Th
         p87kdg15FoSJElF/j2qC0jVEpf6vArCdY3OmvmqIKOLdoN8GMg8mDhbS5eP+5bqmzij7
         CxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717650140; x=1718254940;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=TyqzNqmczOEkcSUQjmTLpoSEc26mX/ITUasguWx66w9Dq//13VIghihN15w2+n6x0h
         vuPP93HbSGpWyr0lT3wxSGCJHTz6x4a/XsfJyHksB4/wjbfATXLuuhs9ByB3VZHs/f59
         davANWYuA1Pw7sMx7siI70Op6nhj5T45uCP21zKzzlhdRoTl8oFYHWohrptk6VGEDJw4
         JLnXqRkSoDQzOqB2LGTPvsEBe8kMqBp7enQR1EK7Biu1IY7ZtabzJ8/+OGEEQnhkz/No
         FyTynExIg/GV8Ea9RwDbW1YM371vTPUiqrOog+i3IaAkLRus0HOoY/FC3tObNBHE+50e
         8GdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqKAQJaXFmYz8ej2CGZnx+TSY8j7gGpN1dWXD4+Re2tKOhsVkTzKyf/X8GzUGskhVCyMzesJ/QnH24lifqeZZPoKcbnULT7U79y2Jgj3i2ugyRAL1iisgEzBmDMuwNBex97MHQrZ3NA69kuTy6UYDv3eIo+fWpN4lkPNGJWqE+JzOp9w==
X-Gm-Message-State: AOJu0YwT2cUyf8nBMzqAD2PzEUHrSZ61/iTcxlTXmp8Jl1hK5PfGFRQ2
	lC/1GF/KeyDNbAcP62E2PPckBW5ERZOpWcVg+ArcN5avK70oFmTtDjah7wXykvOKsmRz/wW1Iwe
	etUkk3E46Jb476P3ah0U+9I3+5go=
X-Google-Smtp-Source: AGHT+IHPqrwGLrOpiYOHRKHF6jjAJEe69uLlr8JRuR9rDqq7Rjpi5pT7mqAtKEV0L+JskZqRkbXl08yzChKNyWs0Mrk=
X-Received: by 2002:a05:6871:79c:b0:250:6be5:1fc5 with SMTP id
 586e51a60fabf-251228adf01mr5001314fac.38.1717650140012; Wed, 05 Jun 2024
 22:02:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-4-hch@lst.de>
In-Reply-To: <20240605063031.3286655-4-hch@lst.de>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Thu, 6 Jun 2024 05:01:53 +0530
Message-ID: <CA+1E3rKjG+kG1Z1N0c69Z_P5eNq9BzshKqdB5Ee0ySPzJGg-0g@mail.gmail.com>
Subject: Re: [PATCH 03/12] block: remove the BIP_IP_CHECKSUM flag
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
