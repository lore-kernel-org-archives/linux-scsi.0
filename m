Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A23D8906
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776784880; cv=none; b=GO45InbYe7CPOxsS9V8vLdVm2f6uLWejiJFYO5EgV1mya+ffno6C+t9dplHqrii4cLLeSEnDx16XiC6jHT7q9/yywxchN11Jun45hdKCn0BZHT+4IwcEkVCSYnTPadMRUEllk+x9DosMD4Rit+IpnPkTezQc5r7wPgk/IJj+DuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776784880; c=relaxed/simple;
	bh=Kyk3+wNQNdoAB6SWDPZsFu2inFstrAooXQvG3g3opEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNjxfDu/M8NvageAZmO/bv3stM52eBytft+k3jxJ1XujgdjHYxt2/pDJBASrYVx4tm8j3P+nYupoJSQ+2uQ4mXY2qJqTS+xTs/TE8vD1volv9DB6pJOjnwIOeDg0Pu9P0eDc++24zSG0g3uXc9AbERWmQ2tQuzOGubV5qIKPhzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=PnE3rtHZ; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="PnE3rtHZ"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7986e538decso42206777b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776784878; x=1777389678; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+B+8NSAggTlzgSEBNF7JVWtV7yl/tiBwRJ1+ICjPNI=;
        b=PnE3rtHZrkUDAAshE5K4db3xIHy0sqcovsfzAj/DRChCNXuPebUBoBNXfXqcjFhFm3
         HLTvCJdHlNG7yoZf0qNnBI7jPr0Ey/FmdTV+xnXQRVcgNJBqxdnu7hlV0pXQLq3+C8iK
         Cuo5zVZWuyxOcY9CNEw1egJrCY17MQlvieQgDjnPiYyo1ERorB91YVkBTDSSrgZV/f7g
         z5OciUO1IM7Y9fjnTqp9LJphwAELTieaqHjHkjjXHyPsiNt5y+RrDfnG2bVBbsdarZlq
         VnTeA3xbvVX8Ub388Z2BKLpI1CBGYMiPeIz9Yycv49hD3fOsQooCy4HIZ6f9jDynE3f6
         qjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776784878; x=1777389678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+B+8NSAggTlzgSEBNF7JVWtV7yl/tiBwRJ1+ICjPNI=;
        b=n+OOgBnU0Vjk2LycF5pWOWvrkSUqhBTXVKEzYibBFtJ2iiz0Qpj7JqylpXoWjBbpXw
         ZsjYjnYBCT/WxERhFGAQtsJiSNacabMZECN/5ux3FKj3ijKbTnlUxWpYDnSYvBNp7/Ne
         E69lWkPs1CXkOm8olU4S2WVydaiggly0llR1JScmLteMZ/qoPZeoVOEwum19e22nAnXT
         8hCABHzzkV8x9bE3ntLt1MucgALAXPsAIqiTHpFRqrit41tvrbn4F/2kV/5u2wBw0GkX
         Sue7eo6KTPy2R48VC1KMIFrI15+v2ELQieakagZuT/21HJkSwWOpzWXslcPOuY8ex4e6
         M5ag==
X-Forwarded-Encrypted: i=1; AFNElJ/Wfukf8D/eNUyuvvNtd8bv0s61PXSNPMgzTNOg3Kd8pvHPmdtV69LJMQRnU0qC+1JuU+2wGa8VRWQE@vger.kernel.org
X-Gm-Message-State: AOJu0YzRs02cQ8bzmXxCV4XS5vyg3jILMvoQ6hsSTA56Eqkh72vGw8F/
	Oeg85suyR86dFsQNuf1Q89eyDnCunXbZUi1d/PEqFmTljjZJbmon9Fs9DFqk9Hd7lwdSWSQRSw+
	jAB8i
X-Gm-Gg: AeBDiesXHa04vGMgTk3kKmwk8gqCJSkYNHFWxLiuYRs/bqHbS+GB6kiyF1Lo9YGKLIX
	+YCJapCUPsx/X4bW9N6jmjNbDX3Nn/ZQszHw3EF2YAsUfjWEYjjVyq4Hz9MGC0HvqsKU1DtGpCK
	3RdI4goVbwD7H8NUPBicflsnjjb9D8hU4qgralOUybukzb8V5PU2AgUa85cFmTCkvrZ5feLbj4X
	yEbUUrtMHXJI3eZRjEklfR7J+kHb66hvdv7z/IwCzC1JJYPJKONw9s3xOdbXo7pgF598AFqOqNy
	GdfCS61OuSuIu/PAv239vGNIrh0Dn93w8dPRvgiazV3a3FJqPAPnL7wa/pnrnhjJxn0Go5zf2vv
	g4HUvAT4rXak6PL3eALIuZKk8ktM8fQaV9UzR2FtWWpOzQ8gq3L+ZVpxJ1XwxRILKd8ewHKLOAk
	85WeOwSnXUozF4QmVLBxTmsUgndCpBtAcifqjBZ+sjv1nvNCIg1hJFSBSp0gzljoS26kSpAH9gd
	Gs4e1Dv1g6b/y6BfZEV8sLMcI2PuQ5+WwdVLjOL
X-Received: by 2002:a05:690c:f14:b0:7ba:f677:8c32 with SMTP id 00721157ae682-7baf67794c3mr66413557b3.15.1776784877840;
        Tue, 21 Apr 2026 08:21:17 -0700 (PDT)
Received: from google.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7b9ee9b293fsm56526037b3.40.2026.04.21.08.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 08:21:17 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:21:15 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 5/5] scsi: Enable async shutdown support
Message-ID: <aeeV1e4j4ok9_iQz@google.com>
References: <20260420152608.6244-1-djeffery@redhat.com>
 <20260420152608.6244-6-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420152608.6244-6-djeffery@redhat.com>

On 04-20 11:26, David Jeffery wrote:
> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 
