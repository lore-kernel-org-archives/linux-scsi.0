Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C2A145A01
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717081471; cv=none; b=HSbyPMdgC9mJ1AHaDFwT3EyPbR8z1J8maIYh6tq9u8i8MlWC8Fc7BpjoCZsKZ9RpnsRySlQQ7hiRaWLwIw9Up6sJh/mfy+1m9sd81sQCFkJ5AC1MmERbUaCYqfwD0hhFoYBFgr4DGMVzsQbjlml99E+ieytigq6e1CbMstEGXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717081471; c=relaxed/simple;
	bh=eKtYororToSKtmxNQEcvcFmprET7yhBZ7lTtUsP1bQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5c1tBaeIxjpG3eVziZ+4awEP0HD3clcAOq/RTufRsgEw2be22n4uBWVSn8kcYlctWPl0cAeW9RjJ0NPZbyyp1uD3v+QRfRNu3GeaIezZIUTh+kljP0dvfRqM/k/3wUcgF4F7+5PCsX7n1QFg0A+jxIcm+sK3UmFJFG/Mh6Ydwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57a196134d1so987353a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 08:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717081468; x=1717686268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjRI6k1pnyFmfsy/h6IOqESLGa47Wobef0S2P34bIx0=;
        b=J69COBkjIP0OH5eEvwBtM+hFztaZezomrgm7aOvT/faFbZiuLdkvJekbfQpkr9vSTA
         o8zxUmRY7oI+WVV0LE3nUz1XDDTNZHQerC9z3mjGY9zxLoHaNzjAay8HU/470yUOsmop
         yLBAisJUiOSLMmRRPFdJeOzbvMFaroQxixtklK7Q6DE5s1g1MdSSAEMcyHPekvsy5R7x
         kObBOw8VObfu4QzTD9X1r7MOj8HTKO5LMualeAdRK6+RrkWBm8iq5i7+VUrXBlMmSYPC
         l/JhEurHj+6MP8X3jo9j0ZCYWwiPukzZqaAxjkBEnSa44ARMXVW+Ft+neBKk7bj/mHuW
         EmAA==
X-Forwarded-Encrypted: i=1; AJvYcCU75QgF5IFrh5JCDxuEmC9C4MFuB6nTxNTTkL8G3w0skPozuQ3jS/A6pkrle79Sjm5/cnuW8qgIEKDHmIWSg6A5Rka1G+lx5d70HA==
X-Gm-Message-State: AOJu0YxlQtFWnEhP3XVyjbDrJJ/dRCJnwSLFutLDo696cOHHVIw6+JCm
	c/kp7xTqpa+88w8ZZ5qhOxDm6quzCsddY0mqp0xlw0UtlAoyubwi
X-Google-Smtp-Source: AGHT+IEqVCK28kSitDJkVAlWQY/CY/i3mjwS3mrDq9HQa5kw3kQTrgO2ledsMVJAavCaKrXlkxqw8w==
X-Received: by 2002:a17:906:8c6:b0:a65:b33a:3574 with SMTP id a640c23a62f3a-a65e891383bmr164732866b.0.1717081468073;
        Thu, 30 May 2024 08:04:28 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-003.fbsv.net. [2a03:2880:30ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626cda8481sm826580066b.213.2024.05.30.08.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:04:27 -0700 (PDT)
Date: Thu, 30 May 2024 08:04:25 -0700
From: Breno Leitao <leitao@debian.org>
To: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Subject: Re: mpt3sas: BUG: KASAN: slab-out-of-bounds in _scsih_add_device
Message-ID: <ZliVeTQU31yTwECi@gmail.com>
References: <ZkNcALr3W3KGYYJG@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkNcALr3W3KGYYJG@gmail.com>

On Tue, May 14, 2024 at 05:41:36AM -0700, Breno Leitao wrote:
> Hello,
> 
> I am running 6.9 kernel in one of my machines, and it shows the
> following KASAN issue. I've tested in linux-next also, and the problem
> is there also. In fact, the snippet below is from linux-next
> (a17ef9e6c2c1cf0fc6cd6ca6a9ce525c67d1da7f)
> 
> Is this a known problem?

Hello Sathya, Sreekanth, Suganath

Have you had a chance to look at this report? This seems an important
issue that can end up corrupting memory.

Thanks
Breno
