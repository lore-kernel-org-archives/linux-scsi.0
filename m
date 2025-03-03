Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82EA2144D3
	for <linux-scsi@vger.kernel.org>; Mon,  3 Mar 2025 14:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741012784; cv=none; b=CwnnnL+dJizbE/cMCNxfdvXMrJIk1KNazZJjMKjmJ24vyc0YmbwiyPk2R3pQfvoOXOtAEbTvGbnGE2ys1rAFfpBHuxm3W65Rv3v0kYiNbXUxzDI0luZ9oFNDqBSJ0eWNazASDh+jxPYF20vcMPUm+q1lp9nYuAhnFZrtTZLYWC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741012784; c=relaxed/simple;
	bh=f/MmzAXL5OQHpffX6sGg4Xf3VuYmFv3FUS7egesUiFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfUMrtYdB+SdtN18YSUynWISwdwgqZUFULz1vbMHLRP093mnOzR36CFy2ixEnHIJKAZDlVhNCWUdlKU5d7at+dX2L1tTVaSAKbai9wZv8UbY1FsuzXpVMedYanVnJ8C9qESurf6cegpGAAFbQLxVoNmMXsvz0+ZyF9DZZKZ5SI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.cmu.edu; spf=pass smtp.mailfrom=andrew.cmu.edu; dkim=pass (2048-bit key) header.d=cs.cmu.edu header.i=@cs.cmu.edu header.b=brJ9tgVk; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.cmu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrew.cmu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.cmu.edu header.i=@cs.cmu.edu header.b="brJ9tgVk"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-474f836eb4cso2824661cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2025 06:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.cmu.edu; s=google-2021; t=1741012780; x=1741617580; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r7AsLn1sMs50UyzmZS5BkUzscifC9xG2WhaFTFTMT1s=;
        b=brJ9tgVkPvWjnCoaI4E5SsjSbz+n96HwUjYfe4g2fhSne9wZkdnh/TRNDfWyS7vvwO
         WfueyuMJAd4BXggwfq1lJSHZOUUyoI+oLHJGb2KFB74I1Db0xIsXhTOw86GBZVhcvGZ1
         /jWWKU9K0ya0UTIzFu0BtldgZhrHlt30x6fXmIkvojWnXiXQI7j5jvfS29igLw2q/H7z
         fRSjAEouFunNNyB3ghgA6BfdaepNl/j3kedLxskViY9yjZSQ5CXjJ5HgUF5ViUKVJU+Y
         nwNXOW9bGODlAdubpJg4P8KXOUZNRNuPUI3+M6FVRYdBawZLmrzLM0PbfzNLSbCpgdRs
         K2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741012780; x=1741617580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7AsLn1sMs50UyzmZS5BkUzscifC9xG2WhaFTFTMT1s=;
        b=n0Ec62Db72nFbrA0F3/2lFn2zmd5wkYMx3ta3idYnRAudOIWtCPgZ8XcttaM4ZNK56
         94yWY/p7lQI3m1QNVhIpssKE8mHuXFvQdB9Vt9Mnbc8mIY5nVoycCAZFXTtl09cxB1Bb
         6vy7vOTBN8tAaH8/48oE/xQ/41mYnF7bWnpLMKRhzuh/2w34lN8I0Hk63L2lBsBFH4sP
         yIJ0g5iesc4FdHUw3KD/MRYjpb/MdZbAzD7eLuJCVYA7i0RAnM0djbEPFmis6lY0CE3m
         z3HOQzgREAjiDJf1KZmaWMhbrF1h94xGTLba/Jr/Ax1gH8Q5lXa3OufbqTc06750pqOq
         hSdw==
X-Forwarded-Encrypted: i=1; AJvYcCWG4ajUO5ZJ20MPknrISRVI3JDjClyTuV+9H1ypmpN0AG1QkB739uenKcFeoU0r4N51rLtoj4toZs2t@vger.kernel.org
X-Gm-Message-State: AOJu0YyEfgDmF5S8kBpqDPyUZTDq2BdO+qqNddTzRA8xW42wSgtuKdko
	G90Ct+tKGggJLBAWXheCieqfZz5aq9omPGdwfWG1e5mM1SmUw90v8a9NWev6uA==
X-Gm-Gg: ASbGncsCxMgHnXvHHTCph6C8yNS/2Tq1fpsFV9Z+Whi2oyd2fT6nHHeDSLmMrjChe4T
	to2DuRpqWYGjN+m4TVIf3s0M6FEd33dPGivbdMgHGEWD0eAduwf1A8y+hGBmCEIkiZbP/SA2Sbc
	+uXTL+Rt3C6XCgTf+4TfpKht/VtQe4e6qCdH9ewO0hCZL6CeLtGunfDyK7gQ2/aqpoVMTHw5vJV
	6nrXGjnU9a/mO6ZAEwGcUX9bm+B1geUv51cfSXzwkwsZu/rqbQNigeNhOko6DrNonHiLHAVNcku
	8AubuVxiElhprL2Qqhkv+AyCtwxWZfoxt57/EYHrcrWYIgKRZDlVxsGmL+QqLq9JNA==
X-Google-Smtp-Source: AGHT+IFQZWctUnPbfZ4JFiToDWuPse3P6E/7UY4w/4me8CrHgeGRMctdZBPOfHW7+lK6TZ19RHYQgg==
X-Received: by 2002:a05:622a:8d:b0:474:f991:b3b1 with SMTP id d75a77b69052e-474f991b60bmr12202431cf.43.1741012780563;
        Mon, 03 Mar 2025 06:39:40 -0800 (PST)
Received: from cs.cmu.edu (tempest.elijah.cs.cmu.edu. [128.2.210.10])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-474e90b8853sm13021411cf.65.2025.03.03.06.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 06:39:40 -0800 (PST)
Date: Mon, 3 Mar 2025 09:39:37 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Joel Granados <joel.granados@kernel.org>
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Joel Granados <j.granados@samsung.com>,
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2 3/6] sysctl/coda: Fixes timeout bounds
Message-ID: <20250303143937.etzv7idjbenugsgw@cs.cmu.edu>
References: <20250224095826.16458-1-nicolas.bouchinet@clip-os.org>
 <20250224095826.16458-4-nicolas.bouchinet@clip-os.org>
 <u7q5rpzw6mohtnnhpa2j3u4photckmgllsl3noafnyfttepbui@rzmndu533xcv>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u7q5rpzw6mohtnnhpa2j3u4photckmgllsl3noafnyfttepbui@rzmndu533xcv>

On Mon, Mar 03, 2025 at 09:16:10AM -0500, Joel Granados wrote:
> On Mon, Feb 24, 2025 at 10:58:18AM +0100, nicolas.bouchinet@clip-os.org wrote:
> > From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
> > 
> > Bound coda timeout sysctl writings between SYSCTL_ZERO
> > and SYSCTL_INT_MAX.
> > 
> > The proc_handler has thus been updated to proc_dointvec_minmax.
> > 
> > Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
> > ---
> >  fs/coda/sysctl.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
> > index 0df46f09b6cc5..d6f8206c51575 100644
> > --- a/fs/coda/sysctl.c
> > +++ b/fs/coda/sysctl.c
> > @@ -20,7 +20,9 @@ static const struct ctl_table coda_table[] = {
> >  		.data		= &coda_timeout,
> I noticed that coda_timeout is an unsigned long. With that in mind I
> would change it to unsigned int. It seems to be a value that can be
> ranged within [0,INT_MAX]

That seems fine by me.

It is a timeout in seconds and it is typically set to some value well
under a minute.

Jan
