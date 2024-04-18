Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F8F158A05
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 09:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713430806; cv=none; b=MdnNw65eske7eCURhT7LrQx08ddi2VmcWNvk5uoE2DaChjUM4GZj4CnhLE4706ecIEAobaQ3QJlESc6WZQHBAm8b0SwsDN9toa3WjyIejrWsoNz1RwTdiJDX4+RArDvGoLUf1mxAOjguJWXfH8TIVrOLNLL0ZrtjnvT/jP7JWgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713430806; c=relaxed/simple;
	bh=6M7IX6GMRSrb8NNcdYzNd99hn5EHjqT7ZWdZdWCow8o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TZEflXVB0H+f9VCP+lrHOuA+Ct+t8IBEPXkvi7ewhjh/SRUSB7kUmdQExH7evWJFfPq/bHxgt8lULmEf3l6Bw7IOGf+QsrP38Trbe8kQE/1mwMXBiwc0aUzcT4moTjNCZ6niv18IQWhP26i8r7jEh8sfZLGG06ccPVZhteoaRWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QdbnyEBe; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QdbnyEBe"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2db17e8767cso10508211fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 02:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713430802; x=1714035602; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6M7IX6GMRSrb8NNcdYzNd99hn5EHjqT7ZWdZdWCow8o=;
        b=QdbnyEBe6nDPly3QN8DbvzceIu1PX/esEPXAc2NtPU4QVmucdMM2Ql+uHCTIO3MdZP
         dLlzfoCg4seieZkel/RAnSdLiUxXAIOwbxxZBCaCQkPGyZmoEsdORjWG6ixr9bBu/PVc
         9HYvJOTW0T4awOrRDgGJpk0XlsIiMi0ZZNum9QljqnmyZv71djFptcIQPwl7le/8WiRe
         N/Ax76/f+QJ79yp49aMavu2mEIo71p/fQTmQRKibTl8Y7DqJUiQvesdF5bSZp5RCVwQD
         b42b8oe40gM5XVbcp/EnV0efgy7KXjCLeNUoD7PSUAftlHFvxwQGNJFDofWpReaNr8f6
         vDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713430802; x=1714035602;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6M7IX6GMRSrb8NNcdYzNd99hn5EHjqT7ZWdZdWCow8o=;
        b=iHcTgL70A4z219BkwqR6yzZj81SoxyLuIRjcqk5NVFuT2cMNUq2QSaofSmUY7Y4IB/
         AYo6EI6yrXmgkSeFKSAnnjwx9gZ6dskA45YbEGJKvKlUlBGUkD4RZOJLq8bU+KphrC1E
         RM+GQFs6xLbeCNbI+hK7iaDuAXZ60eBxfDYNhxvZChHz5rcZ0RCSIG1y4vZRSICPEkkv
         xrOVJf220vzZXoxR1wU2TLqQGB6xEZkYENc5751p0/2HlQTFMrniY1An0N3WuVt4YIDO
         tzCtvmYcQFkWc6eXQLXTP6MhPT9JWQfCCmhRThLCGQE9EgSqr8Jd3Bzw4MqKxUK3yOMQ
         c47w==
X-Forwarded-Encrypted: i=1; AJvYcCU7fU+svvXwg9BKMuFyqNC2rYYhVABjO6n00M+m970cFmHtRR9c7R54JDsN6gnVj/rNHMHsQS8inpmw+xDJlGK5qqAuR1sP64/RuA==
X-Gm-Message-State: AOJu0YwnVNMY6atiNtxn/uIuMdd3HC1rmZhDcxma0SW4oKVUrGDGQPnG
	ZzQmgi9UBJnXtLKQVLauQ0O4zTN9dq4aAbdXn0vIq9NW1HEVtNW06QGiN+I00N96t//51B5DiFA
	g
X-Google-Smtp-Source: AGHT+IF619CwKkS66uxSEGqX2Je9W4nejrOIpTM2ur25OC4nbCBDHznxTahGCYrQCKIrEVUiKj0P7g==
X-Received: by 2002:ac2:464f:0:b0:518:b7dd:36a3 with SMTP id s15-20020ac2464f000000b00518b7dd36a3mr1028130lfo.54.1713430801831;
        Thu, 18 Apr 2024 02:00:01 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id j23-20020aa7ca57000000b0056e0376286bsm610563edt.24.2024.04.18.02.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 02:00:01 -0700 (PDT)
Message-ID: <e8214e77ac70f452d0b4145d2fa3289263953b27.camel@suse.com>
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
From: Martin Wilck <martin.wilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Hannes
 Reinecke <hare@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley
	 <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
Date: Thu, 18 Apr 2024 11:00:00 +0200
In-Reply-To: <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
References: <20240418070015.27781-1-hare@kernel.org>
	 <20240418070304.GA26607@lst.de>
	 <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-04-18 at 09:42 +0200, Hannes Reinecke wrote:
> On 4/18/24 09:03, Christoph Hellwig wrote:
> > On Thu, Apr 18, 2024 at 09:00:15AM +0200, Hannes Reinecke wrote:
> > > max_sectors can be modified via sysfs, but only in kb units.
> >=20
> > Yes.
> >=20
> > > Which leads to a misalignment on stacked devices if the original
> > > max_sector size is an odd number.
> >=20
> > How?
> >=20
>=20
> That's an issue we've been seeing during testing:
> https://lore.kernel.org/dm-devel/7742003e19b5a49398067dc0c59dfa8ddeffc3d7=
.camel@suse.com/
>=20
> While this can be fixed in userspace (Martin Wilck provided a
> patchset
> to multipath-tools), what I find irritating is that we will always
> display the max_sectors setting in kb, even if the actual value is
> not
> kb aligned.
> _And_ we allow to modify that value (again in kb units). Which means=20
> that we _never_ are able to reset it to its original value.

User space has no way to determine whether the actual max_sectors value
in the kernel is even or odd. By reading max_sectors_kb and writing it
back, one may actually change the kernel-internal value by rounding it
down to the next even number. This can cause breakage if the device
being changed is a multipath path device.

Wrt Hannes' patch: It would fix the issue on the kernel side, but user
space would still have no means to determine whether this patch applied
or not, except for checking the kernel version, which is unreliable.
For user space, it would be more helpful to add a "max_sectors" sysfs
attribute that exposes the actual value in blocks.

> > Note that we really should not stack max_sectors anyway, as it's
> > only
> > used for splitting in the lower device to start with.
>=20
> If that's the case, why don't we inhibit the modification for=20
> max_sectors on the lower devices?

I vote for allowing changes to max_sectors_kb only for devices that
don't have anything stacked on top, even though my late testing
indicates that it's only a real problem with request-based dm aka
multipath. After all, max_sectors only needs to be manipulated in rare
situations, and would be generally recommended to do this in an udev
rule early during boot.

Regards,
Martin

