Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36695199FAB
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 00:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776300531; cv=none; b=n6QuD/cPVF7/Zs/gojXZEg65XDOLWyrwQKqbIoz64H/f/Nu7f/B6Hp/cT3/fzQsfeTCWNyNXuGfsuJbXI7FynzspASCZfgZacExBV80hClSUGRg+RdkghDl81CnZPc1K13FSm/XrTl6BU0OUnaSEB3zqgiMqZXukXOtHe3ppOkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776300531; c=relaxed/simple;
	bh=vSZrDHJWdUT3fc0mnfVsASM38Ik77OOrDrcLveHcMs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kwlcvpc/uZms8dMhWDmAipeM6xIP+whrGVGnIbBlGZ8TFlS15iZk3QFw3bUKEatV6Lo5xb4awK0ui/J6i5erL5Z23nOjcDPP5nZvT6HhWmzWuSOWjyfCuw2J4E0FCWQOvLwhZ80DX+0LVC75rKXeD1rWHFs40+BGxFQIZkLZdvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aqqMY83m; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqqMY83m"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so4745978f8f.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 17:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776300528; x=1776905328; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4wHjoL5bgW6OaCvqxEnCcQc9CZYqGIAVWFc6AfVy0os=;
        b=aqqMY83mXjXfuqdCvbeqt503tkOm8p8GpyWrBQN8ZGc8rnh5A0+OuhWNqkh4h+13q0
         0ylJmV1V43qYF9IqK9y31Rbz/Me/FocBeuRfO0e/M3aHXv53ZTC6dGAdeR8OUIM9kvTd
         ibmjHH6sXAWGDCvOuzi1EtVD1020ftZK8LER6mbETRLqSR1UnYBHIItxwQLP7lNm8Id1
         icsNJCnAybogb8O8U3kJjtz28F2WN2ErzkQOydjW6hwNVVK58wkytVlDucqLT5KMEjtV
         K5xE4H7uUFd2InXu43+kzRt2aZYLy5rwrykUdHhUu31ix4FndM7e2vU0Vhya9MAKEwSn
         +5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776300528; x=1776905328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4wHjoL5bgW6OaCvqxEnCcQc9CZYqGIAVWFc6AfVy0os=;
        b=KVEIFD/cs4RRZTe4b03ldnOtpQ+kn5LE0/85ilO8RJPQ+GDRrr3TIyLwLfgUvIqZfu
         KZ4s0LBOtiD3nH9HS73Bx8AKO9Nx0hWx8bfmDSYVNPvOZfmdY1wRqzq3GL9Gx7qWdhiz
         4/07l6V9dQwEY39lW76xaZJLgT6yUSSZUH7WxwShzjqTGmODw00ngCxA/73jtBTQN+Co
         CCFtNLCQ1IJ/gGj7kC3pRhd0nsegvkkPrwF2Rn7GFhWuWo6mO68jAWFIKqocvDDoSSdX
         uBQY7Dfje5gybLa1flhuqJe0ptMhC/OnLr5YivGerfDlyJCAFaq9S5r7KJnRTH7QSuAT
         JW3A==
X-Forwarded-Encrypted: i=1; AFNElJ9vX0yOSD1NKJVrk7YWNoe++TaXrXMYkao2KxFyny4d8d/clDgGNWBNrVK3eVPo4SLgk0GaAXqMgb57@vger.kernel.org
X-Gm-Message-State: AOJu0YxPHAzC0Gc7rj60LPxfPlVaHcmmeCebKtvVJspDMMGx4+KT3GQE
	Iu5bvkWjdzJpffJ3+uoJPSi5ff94yrW7zNaNpGvyaDgF10up9S+oWTL9
X-Gm-Gg: AeBDietlVoMaqzq7Y3PgNe5+57ZvTPjlSrihrmSS3drVeJ8hZNevoq9g9ZzEbTg0t55
	tg82ggYHJ8QSkTESPrlxUWO8+B/iWLbSQc4RMHFXg1NvZm32Opdnefbn8Y5RJnaRnPG27CB0+aN
	+5YkiOEtrD/m8MmqTdZQLPh0uvJwi0F3nPtuiZJNSRQQ9OjYZfpxSQbSzl11QKztLgRnambPrmQ
	n5d6obkC5c2rGLNTbauijqYaEJss5n7N37ELometewEDEBLld0ADpA0i7yHRzpYnbOwPDN6ARcM
	FMbQLrhaCesjkFqia58cuZsqEmjfkxoClaNDkwmrwC+1+W7wKkmmAzhyjJJ+BI/7SgZE7pvxJtK
	CZRn6J3NyQWOH1R9nBnDfRn5cMHcNksaOlTUBxc+H0in0BwvY/E+6UpflNuQXBvEfA9LiCsEhuT
	r+ISubCUGRmfwiAMW3XGwPg0XzPv9E7IoCoB3cCJv/q1nB8PZ+oTYt
X-Received: by 2002:a05:6000:1a89:b0:43d:7b51:5178 with SMTP id ffacd0b85a97d-43d7b515250mr19740589f8f.5.1776300528339;
        Wed, 15 Apr 2026 17:48:48 -0700 (PDT)
Received: from fedora ([2001:250:3c1e:503:ffff:ffff:74aa:4903])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3dfff3sm8344319f8f.26.2026.04.15.17.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:48:47 -0700 (PDT)
Date: Thu, 16 Apr 2026 08:48:26 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	liyihang9@h-partners.com, kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com,
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com,
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org,
	frederic@kernel.org, longman@redhat.com, chenridong@huawei.com,
	hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io,
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <aeAx2g-nJQO2yyS4@fedora>
References: <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
 <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora>
 <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
 <ad0Hk48y5JEeMlFk@fedora>
 <fouvg7qn7g4yah7jsvzkdmweesbp4aqmhx37gf3ow5medzvuyk@5n3ddkijosr6>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fouvg7qn7g4yah7jsvzkdmweesbp4aqmhx37gf3ow5medzvuyk@5n3ddkijosr6>

On Wed, Apr 15, 2026 at 10:56:37AM -0400, Aaron Tomlin wrote:
> On Mon, Apr 13, 2026 at 11:11:15PM +0800, Ming Lei wrote:
> > But typical applications aren't supposed to submit IOs from these
> > isolated CPUs, so in reality, it isn't a big deal.
> 
> Hi Ming,
> 
> While that may be true for general-purpose workloads, it is a fundamentally
> incorrect assumption for the highly specialised environments that actually
> rely on strict CPU isolation, such as High-Frequency Trading (HFT).
> 
> The requirement in these strict environments is not that the isolated CPU
> performs zero I/O. Rather, the requirement is that the isolated CPU must be
> shielded from the unpredictable latency of the hardware completion
> interrupt.

Again it is just your opinion, not a bug report, may not be a fact, right?
Which kind of HFT application submits IO from isolated CPU?

However, as I mentioned, I don't object this patchset, but you have to fix all
wrong comment & document & bug found in review first.


Thanks, 
Ming
