Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401BB306B25
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 13:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769002849; cv=none; b=TO23VAh8Zo2quaj1pLN8IvGPe9Ei5oVfIcEpDK1H11KS0I5jU7XjSnIOBf5BKINQuCd2kx1hj727kYdIz3AjPHck3XI4vRfT4CNC4rtGvhPx220yLmYO9KXlbj6qrRsdJrYFdBUPZFqp0Gp0FnQRKbhfJTfubigjsZVOeHA8ExM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769002849; c=relaxed/simple;
	bh=Zj98ZO/ts5b/MYgZaQn1CeOkJWBxcPQsjM8uYXM3aaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ecOpJCnmuxh+wDWcURwZcGYIBAP9pQ9Gdk92m1YZys1JIhOepBROLrcT4S8UDIZPdUPT7cb86HypaMvL7BCml6TnDn+oAwGFQnm7tpQSxcmkaxhYdi9N50Hg5C0p1CjN47wzgFVGrXQdEWl4jev8dAxv3IFAmcg6lZTg4rPEh14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1tMCEeK; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1tMCEeK"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-81e8b1bdf0cso3775679b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 05:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769002847; x=1769607647; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pPaaLejyMj+/qnEy2gN+yRCN0UmH2KujytP4NRWmWr8=;
        b=F1tMCEeKELRa0nVdKgeXsW8TRYImYt3BKVrYRDHTahS2rVVOcf8mJ+GAy1C+fELbWg
         PW4LIcjathuH7f6y1DNK5rt6VLeFzlrz2ZIYhEojVBO38z51OZEJhMNFaWOzR7gjI6U8
         7wO6gx/M7bZ3PCMx80W/P4jZTzFUs3zFukyku+nSRk4ogSigIVVbnW1RDHF10botbyyW
         SRHPXGxHkAdfNbJS/nPUiL4MvxbcTbIOUAGz/exnZriGx/ZD+CTDytP6+3LcHjEWs0rv
         XVeqwJTufUcMDHkxXhrS5v53nYFNbpVYrwKCGsuyhQQ26AGtQQqYTMmW3uYWv1t9Egkp
         2mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769002847; x=1769607647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPaaLejyMj+/qnEy2gN+yRCN0UmH2KujytP4NRWmWr8=;
        b=bCWI/mPGwA4CZqNj22cAbFsY1kI5/oBJDDq7I+IZqU0TZNPVCGoUn+nae19RHfVTYo
         +ML8vIhH4yd2hrM2tq7aDMNKKQ1BXLDC/tfuplgHnVU/MeFXbfjdkx3BRxB5uDNyxEwm
         c5OshzqjWjWhMs4FcMuqemE3qvEJA+4nQBd1IQaqZb7hwhHaPFfQA+oEekXD0A77T8sa
         KZG9HV/ARyuBhLhK3BOwZewwuAPn+663NmIQF6HlnhF40i+S0S97lGN2/gmvnAxrig8k
         pNKXr8vOCHseV/EZFUaVBF+6r3MjSU7PHMaT8r1BbCSkkQcqQ5ANXORoido7vQeByCqS
         nFgA==
X-Forwarded-Encrypted: i=1; AJvYcCVOuoZwbut3sf5HDr+b8nMIwyRGKGexCU1+iXCtkWa/1x3cSEgTX3eBp55D0a0mbMPo7vzzvIQ/eCuS@vger.kernel.org
X-Gm-Message-State: AOJu0YxwFy/1L17q5QvlKoUBcq06BuXvsCgq6hAw56fLnCb0s15gb93T
	D5orraI+rROq9OqmLY+k6YXUTHTeClK3p4BcoyXfmw+/2paj5IyUM2K8
X-Gm-Gg: AZuq6aIjh1Lxix7rHFn+eixdYB1hJ8VRcmVERSlrrGeLvD5snBRzgFYSvZfdkeGOT5z
	J5bnkaA2rliqx6Cc6pK+I5pDm9g/Ad8WJyMSmweD0lVDY/zGG7FwXcgVGIJNh/3Qri+cQjCpJeA
	64OtD5V1Jkwf6xx9gt33ur0+1y3Vl8AqaiB4U0z03zV1b7fuF08UdyHRmTjTri5w5EmEfHlMQTE
	jnyEq5bUuJpmJ+MdZ/Osss+355+Ngo/P1V4pGoMVhDeEiIEWXy5JO0M5VKyo36IwMjkIqjXnUAb
	JRJtrIPbTp4OpmhBW9FyZmLpXkxspKZ6JjOgTArAuEe+paYMkpXb20eqYTNOSm26d8zLV7/gb+F
	C47zav/pbqCQZQKpbDr4DtPACH5mdSf06jI6rqcdQDvUH4g/mzF/Hytge/p7fdg+UPmYiL26DwN
	va2BnqyunIb54=
X-Received: by 2002:a17:90b:4fc2:b0:34e:630c:616c with SMTP id 98e67ed59e1d1-352c4055083mr3706750a91.31.1769002847164;
        Wed, 21 Jan 2026 05:40:47 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352c114c2absm5238039a91.13.2026.01.21.05.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 05:40:46 -0800 (PST)
Date: Wed, 21 Jan 2026 19:10:37 +0530
From: Prithvi <activprithvi@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@lst.de, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix recursive locking in
 __configfs_open_file()
Message-ID: <20260121134037.kh3rfrgmwsylcl5r@inspiron>
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <2f88aa9b-b1c2-4b02-81e8-1c43b982db1b@acm.org>
 <20260119185049.mvcjjntdkmtdk4je@inspiron>
 <ac604919-1620-4fea-9401-869fd15f3533@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac604919-1620-4fea-9401-869fd15f3533@acm.org>

On Tue, Jan 20, 2026 at 05:48:16AM -0800, Bart Van Assche wrote:
> On 1/19/26 10:50 AM, Prithvi wrote:
> >   Possible unsafe locking scenario:
> > 
> >         CPU0
> >         ----
> >    lock(&p->frag_sem);
> >    lock(&p->frag_sem);
> The least intrusive way to suppress this type of lockdep complaints is
> by using lockdep_register_key() and lockdep_unregister_key().
> 
> Thanks,
> 
> Bart.

Sure. I will make v2 patch for the same.

Thanks,
Prithvi
