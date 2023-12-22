Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DA5249E5;
	Fri, 22 Dec 2023 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IN66h3fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BE1C433C9;
	Fri, 22 Dec 2023 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703257857;
	bh=jj2Z4UzDBfG4TrpZAn+WY65WDkHUYpWkxVo4G50GhjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IN66h3fddKRYluEoG8tMXspnU52/OIoPT8qyGxpDlX7QZplgwPhbNGKhyDYVB+ba3
	 xfS+rS8Pbl0d4WyiJU6jtf5wUjxqbY33nnLOM/l0KfLJGcuJwXDw4TOs/G2D6LO+nN
	 lI84IPiWYg6Q55aXY91lD9zWpSnBAWW9o7UsKcpvFWC5KvifnsjStyMJvLYvnI4TSU
	 Wca1GQlsm4cd1tEDt1DV6MOyYXxYYJsM4DHt/yhC71QsefXtoX0B7rautzn7uU7fok
	 3GubVzIH6YP1eiulSfcywSjiiIRVcyZT93OzPjbGTie+ClXeTgK3B16e0dSXVB6eiX
	 Q9pDkFv2myIqA==
Date: Fri, 22 Dec 2023 08:10:54 -0700
From: Keith Busch <kbusch@kernel.org>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
	lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZYWm_tMtfrKaNf3t@kbusch-mbp>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <BB694C7D-0000-4E2F-B26C-F0E719119B0C@dubeyko.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BB694C7D-0000-4E2F-B26C-F0E719119B0C@dubeyko.com>

On Fri, Dec 22, 2023 at 11:23:26AM +0300, Viacheslav Dubeyko wrote:
> > On Dec 21, 2023, at 11:33 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> > I'm interested in this topic. But I'm wondering whether the disadvantages of
> > large blocks will be covered? Some NAND storage vendors are less than
> > enthusiast about increasing the logical block size beyond 4 KiB because it
> > increases the size of many writes to the device and hence increases write
> > amplification.
> > 
> 
> I  am also interested in this discussion. Every SSD manufacturer carefully hides
> the details of architecture and FTL´s behavior. I believe that switching on bigger
> logical size (like 8KB, 16KB, etc) could be even better for SSD's internal mapping
> scheme and erase blocks management. I assume that it could require significant
> reworking the firmware and, potentially, ASIC logic. This could be the main pain
> for SSD manufactures. Frankly speaking, I don´t see the direct relation between
> increasing logical block size and increasing write amplification. If you have 16KB
> logical block size on SSD side and file system will continue to use 4KB logical
> block size, then, yes, I can see the problem. But if file system manages the space
> in 16KB logical blocks and carefully issue the I/O requests of proper size, then
> everything should be good. Again, FTL is simply trying to write logical blocks into
> erase block. And we have, for example, 8MB erase block, then mapping and writing
> 16KB logical blocks looks like more beneficial operation compared with 4KB logical
> block.

If the host really wants to write in small granularities, then larger
block sizes just shifts the write amplification from the device to the
host, which seems worse than letting the device deal with it.

I've done some early profiling on my fleet and there are definitely
applications that overwhelming prefer larger writes. Those should be
great candidates to use these kinds of logical block formats. It's
already flash-friendly, but aligning filesystems and memory management
to the same granularity is a nice plus.

Other applications, though, still need 4k writes. Turning those to RMW
on the host to modify 4k in the middle of a 16k block is obviously a bad
fit.

Anyway, your mileage may vary. This example BPF program provides an okay
starting point for examining disk usage to see if large logical block
sizes are a good fit for your application:

  https://github.com/iovisor/bpftrace/blob/master/tools/bitesize.bt
 
> So, I see more troubles on file systems side to support bigger logical
> size. For example, we discussed the 8KB folio size support recently.
> Matthew already shared the patch for supporting 8KB folio size, but
> everything should be carefully tested. Also, I experienced the issue
> with read ahead logic. For example, if I format my file system volume
> with 32KB logical block, then read ahead logic returns to me 16KB
> folios that was slightly surprising to me. So, I assume we can find a
> lot of potential issues on file systems side for bigger logical size
> from the point of view of efficiency of metadata and user data
> operations.  Also, high-loaded systems could have fragmented memory
> that could make the memory allocation more tricky operation. I mean
> here that it could be not easy to allocate one big folio.
> Log-structured file systems can easily aligned write I/O requests for
> bigger logical size. But in-place update file systems can increase
> write amplification for bigger logical size because of necessity to
> flush bigger portion of data for small modification. However, FTL can
> use delta-encoding and smart logic of compaction several logical
> blocks into one NAND flash page. And, by the way, NAND flash page
> usually is bigger than 4KB.
