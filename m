Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D64C17E0;
	Mon, 24 Mar 2025 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742847805; cv=none; b=ksko+qZKeT/uZODDjjA+G7M+PhFwI7x8LD4P1BeH4SMABGCuuLrVoH3xSl5awrJXClluwyXFEX4FE/+06otwiAxuoTbROARBbGNjBmQPqZ/yLjsiIJHH70pLOyAZu34XoDcLX+3uLaxGwwQadx7p1l98gF7x46VZqSfBC+dRBws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742847805; c=relaxed/simple;
	bh=oyUKXubP2QeX5/W43JfhhMzPCc/CGvuco4rN8IE+Z3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPAJY6VuI7SEJdebMnb+9gssyT4UoMvSG6NovOWk0f03+nJ24lXNnzB8/dZNbMjKtEwpLLmk5wIrM35mOOqqi8PxLVEhB0SMqruQW+7Yl7BL8nb/oA4j4+T9gZ5uONHvoYNSOnBuKorJ7s/BZDNW/AgdiPbllNWgoQelATFC7AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzMC3mEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzMC3mEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB46C4CEDD;
	Mon, 24 Mar 2025 20:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742847803;
	bh=oyUKXubP2QeX5/W43JfhhMzPCc/CGvuco4rN8IE+Z3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bzMC3mEFipY/1rVNUtYsh5pD/7a37NOfUlzQ4ENvlN6qsw0Cqep8ZkEioQeTOdPS4
	 gCzKbiIgV+JA8DCVWuUuFtf3i+0T3mq8zRdB22PwMFR4BlGwpDJ61kDIBzsYcoA9y3
	 0xE9CQSwsg3d8U26E4cIRG6l/NJVK3CFZNdfV3SXgFL1dbSaXiRHRIUNABgovBHqFe
	 ssRVMPsj5v6t94MMiMW6e4pH2hEp+HJcU+hAeqA3Q6yNGv1f9zRwG4WAjmoM9LHdoc
	 xrKHeFlhmCsYjUBg2rEh3VxYofHbqle7mMRupd05tfveHM8c6Ka2r8GWC5dVJx3zxD
	 snlZwdyXb2D4Q==
Date: Mon, 24 Mar 2025 16:23:22 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: John Meneghini <jmeneghi@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	dm-devel@lists.linux.dev, Samuel Petrovic <spetrovi@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [LSF/MM/BPF TOPIC] Multipath bio vs. request
Message-ID: <Z-G_Oj7C4wmLaJnT@kernel.org>
References: <6fc92ed7-5656-4cef-9f36-fd2d37e56e12@redhat.com>
 <Z-G-fAHSygeJuPBV@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-G-fAHSygeJuPBV@kernel.org>

On Mon, Mar 24, 2025 at 04:20:12PM -0400, Mike Snitzer wrote:
> Hi John,
> 
> On Sat, Mar 22, 2025 at 02:38:29PM -0400, John Meneghini wrote:
> > I will be presenting on this topic at LSF/MM/BPF this year, in the IO track.
> > 
> > Here's an introduction for my talk.
> > 
> > DMMP currently supports two different kernel IO interfaces: the BIO interface[1] (struct bio) and the Request interface[2] (struct request).
> > By default DMMP uses the Request interface and over the years much work has been done test and improve the performance of the DMMP Request
> > interface. DMMP can also be manually configured to use the BIO interface. The DMMP BIO interface is supported but little work has been done
> > to test and improve its performance. DMMP is currently the only upstream component which continues to use the Request interface for submitting IO.
> 
> As I clarified at lunch today, your "DMMP is currently the only
> upstream component which continues to use the Request interface for
> submitting IO." makes no sense to me.  The request-based DM multipath
> target is a blk-mq driver.  It just acts like most blk-mq drivers.
> 
> What is different is DM core's request-based code will clone each
> request that gets submitted to the request-based DMMP device.  And
> then when the request is submitted to an underlying path it gets
> directly inserted in the unlering blk-mq request-queue for that path.

Sorry for typoe: s/unlering/underlying/
 
> So in those aspects request-based DM core and DM multipath are unique
> and they do require block interfaces that only benefit DMMP -- but
> that has _always_ been the case (nothing else ever needed to clone
> requests before submitting them).
> 
> > At the ALPSS 2024 conference last October we discussed the possibility of deprecating and eventually removing support the Request interface
> > as kernel API. Such a change could impact DMMP so I was asked if Red Hat would be willing to support the effort by measuring the performance
> > of DMMP's BIO interface[3] and comparing it to its Request based performance. Having such a comparative performance analysis would be very helpful
> > in determining what further changes might be needed to move DMMP away from using the Request interface. This would help with the overall effort
> > to improve BIO interface performance and eventually remove support for Request based IO as a kernel API.
> > 
> > In this presentation I will share the preliminary results of Red Hat's DMMP BIO vs Request performance tests[4] and discuss what the next possible
> > steps could be for moving forward.
> > 
> > The tests and performance graphs in this presentation were developed and run by Samuel Petrovic <spetrovi@redhat.com>.
> > Credit goes to Samuel for creating these performance tests and many thanks to Benjamin Marzinski <bmarzins@redhat.com>,
> > Mikulas Patocka <mpatocka@redhat.com> and others on the Red Hat DMMP and Performance teams who contributed to this work.
> > 
> > [1] https://lwn.net/Articles/736534/
> > [2] https://lwn.net/Articles/738449/
> > [3] https://lore.kernel.org/linux-scsi/643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com
> > [4] https://people.redhat.com/jmeneghi/LSFMM_2025/DMMP_BIOvsRequest/
> 
> Other useful context is the 2007 paper that provides an overview of
> why dm-multipath was switched from bio-based to request-based:
> https://www.kernel.org/doc/ols/2007/ols2007v2-pages-235-244.pdf
> 
