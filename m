Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73CE5380C;
	Mon,  8 Jan 2024 19:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v7UTSp5y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/CnY1WrNa6ivAwOul4iLunYaBF0zr/21B1/t616St8k=; b=v7UTSp5yHaxoKw/l6drPxI8TGd
	eEQOGfG75PN/u2R8GCSiFXX8/FgIcyz4FeOiqy4Qn1DmN53Lddq27eJPNPHHSau2g22qhNvLBydfL
	omZZQVQV435kP8cVkuKkuBY2Q1kxjCnneG1EcdW34GP0MWJXxP1CMOEo5KhxmLf7fcMhEICOVmRR0
	kCq3gh8g+lvK4JFhi+QT1z0fjI4nASTHvtHk1roiqnhdoxYYexx4LwPVqbnabGYHHntbifHaWDIWR
	M/diELIjTfwbx0tvVBCsP4MejbaeK0NBagqRQ2bnIUuBVluAnx2kWtTGZ5/nIBdpJP1VDUVWbRpV1
	iXZ5dKVA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rMvP3-008I9G-Ol; Mon, 08 Jan 2024 19:35:17 +0000
Date: Mon, 8 Jan 2024 19:35:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZZxOdWoHrKH4ImL7@casper.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYUbB3brQ0K3rP97@casper.infradead.org>
 <ZYUgo0a51nCgjLNZ@infradead.org>
 <9b46c48f-d7c4-4ed3-a644-fba90850eab8@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b46c48f-d7c4-4ed3-a644-fba90850eab8@acm.org>

On Mon, Jan 08, 2024 at 11:30:10AM -0800, Bart Van Assche wrote:
> On 12/21/23 21:37, Christoph Hellwig wrote:
> > On Fri, Dec 22, 2023 at 05:13:43AM +0000, Matthew Wilcox wrote:
> > > It clearly solves a problem (and the one I think it's solving is the
> > > size of the FTL map).  But I can't see why we should stop working on it,
> > > just because not all drive manufacturers want to support it.
> > 
> > I don't think it is drive vendors.  It is is the SSD divisions which
> > all pretty much love it (for certain use cases) vs the UFS/eMMC
> > divisions which tends to often be fearful and less knowledgeable (to
> > say it nicely) no matter what vendor you're talking to.
> 
> Hi Christoph,
> 
> If there is a significant number of 4 KiB writes in a workload (e.g.
> filesystem metadata writes), and the logical block size is increased from
> 4 KiB to 16 KiB, this will increase write amplification no matter how the
> SSD storage controller has been designed, isn't it? Is there perhaps
> something that I'm misunderstanding?

You're misunderstanding that it's the _drive_ which gets to decide the
logical block size.  Filesystems literally can't do 4kB writes to these
drives; you can't do a write smaller than a block.  If your clients
don't think it's a good tradeoff for them, they won't tell Linux that
the minimum IO size is 16kB.

Some workloads are better with a 4kB block size, no doubt.  Others are
better with a 512 byte block size.  That doesn't prevent vendors from
offering 4kB LBA size drives.
