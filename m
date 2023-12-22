Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA3A6112;
	Fri, 22 Dec 2023 05:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FJLHiuOd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3shKBIvhLWjsCiSjY85TEmaxzTG7BMW14R+xGNs9tzU=; b=FJLHiuOd8g/VKYYccOIaQxdGOZ
	+2fuv1sq672PBRaBDJFiQ4jDPcXQawRxmtlcgIoSZivPkVN/d+Y2jCaL0VQ8l4EHJ7En0Ts5mJeIy
	K1Ey6aZexE84ec/5gTBJNZnAIZhArgxCdoUcH1PN1PkPduPdUT5DjEu2Mb4oFe9G/ya1wI1fyb/SH
	Slza91DDVfucNamH/zqB6RwD9U6YCgQ9o+nOer4YNxItcpBjFRbcPF0P1lR9sXQY3DZHeXMXBDnG0
	gn/E3zZYaMd1M1z4Eeg0luXFDWlqsVI3A7Q8W4bo4tqf7o23+KRqXrt/EBxGDtyI8blwCaInQyHAB
	zL+mUu4A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rGXqx-007AOG-3A; Fri, 22 Dec 2023 05:13:43 +0000
Date: Fri, 22 Dec 2023 05:13:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZYUbB3brQ0K3rP97@casper.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>

On Thu, Dec 21, 2023 at 12:33:08PM -0800, Bart Van Assche wrote:
> I'm interested in this topic. But I'm wondering whether the disadvantages of
> large blocks will be covered? Some NAND storage vendors are less than
> enthusiast about increasing the logical block size beyond 4 KiB because it
> increases the size of many writes to the device and hence increases write
> amplification.

I've been mulling this over for a few hours and I don't really understand
it.  The push for larger block sizes is coming from (some) storage
vendors.  If it doesn't make sense for (other) storage vendors, they
don't have to do it.  Just like nobody is forced to ship shingled drives,
or vertical NAND or four-bit-per-cell or fill their drives with helium.
Vendors do it if it makes sense for them, and don't if it doesn't.

It clearly solves a problem (and the one I think it's solving is the
size of the FTL map).  But I can't see why we should stop working on it,
just because not all drive manufacturers want to support it.
