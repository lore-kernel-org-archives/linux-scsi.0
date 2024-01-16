Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2AE200A0;
	Tue, 16 Jan 2024 23:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705448086; cv=none; b=TBcBDTHJi8gRTEJeXvCJQv7TR9qMwvk9ZAplblooIr9Lj3vlWMe6r5EKOeMDMhrXBQ/iNUJ9vI2dYHFqxlvOtxCFEmrh/D2ms33NRA3yKPWVbPZVzf7NPSkWvndwjuYN+NBSpZ5W0/MMUGF9GrvYFsue2uV2x0pIHHFvKM71Dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705448086; c=relaxed/simple;
	bh=F+6hXN5spcHeGywfeBckLbhuAW6dKw/xoReTzVE+X80=;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding; b=T1gIFfKzdeFk/uy/+5mVCv3LPZUe/M8UKsdbMgRhOBlij0Z46Z7lVxWMr2oRw+ZOsc7EkO19qdeHB7y7hP/cfjG8FPs0/uOiXeKFnx5LLzsqPcRF5c8B1bkD8VSkYXicQ7VXsZk/4+hVntN0X8Hb96Eu8kxDALqoZ5rKUIPWYZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Js4eCoIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Js4eCoIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA1CC433C7;
	Tue, 16 Jan 2024 23:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705448085;
	bh=F+6hXN5spcHeGywfeBckLbhuAW6dKw/xoReTzVE+X80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Js4eCoITLRQgEik6ypAuFRtxiooMJ1RqbV4GqvpJv36OiKDetBzakknn6LJrPRmZF
	 9YJoq0lGGX1NEpiTL+pkwIeAmsiGrcKbdcDtS1KoDqiiMBcba22SCPZXGBeEHK/YL+
	 ipV9f3X0Wze2SvBr4VPTEd7j3eP5epbSZzmc9zSgIbPMTwUsZZiBN9Cbt2jG2o9rm0
	 v9RqXEP4AkklclFdAu5BvvJ8+MwvxwWQ7bffkt3dKMv1Wp01bTGZd/iArQnHv0wX/b
	 l43kslV9FTOp9a03UgglOwXaNED8tDpyYwIf9IYJqBd/6qV9TUuiNZtp96d4RJSo1n
	 I/pZJt6nxU8ow==
Message-ID: <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
Date: Wed, 17 Jan 2024 08:34:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/17/24 03:20, Bart Van Assche wrote:
> The advantages of zoned storage are well known [1]:
> * Higher sequential read and random read performance.
> * Lower write amplification.
> * Lower tail latency.
> * Higher usable capacity because of less overprovisioning.
> 
> For many SSDs the L2P (logical to physical translation) table does not
> fit entirely in the memory of the storage device. Zoned storage reduces
> the size of the L2P table significantly and hence makes it much more
> likely that the L2P table fits in the memory of the storage device. If
> zoned storage eliminates L2P table paging, random read performance is
> improved significantly.
> 
> A zoned storage SSD does not have to perform garbage collection. Hence,
> write amplification and tail latency are reduced.
> 
> Zoned storage gives file systems control over how files are laid out on
> the storage device. With zoned storage it is possible to allocate a
> contiguous range of storage on the storage medium for a file. This
> improves sequential read performance.
> 
> Log-structured file systems are a good match for zoned storage. Such
> filesystems typically submit large bios to the block layer and have
> multiple bios outstanding concurrently. The block layer splits bios if
> their size exceeds the max_sectors limit (512 KiB for UFS; 128 KiB for a
> popular NVMe controller). This increases the number of concurrently
> outstanding bios further.
> 
> While the NVMe standard supports two different commands for writing to
> zoned storage (Write and Zone Append), the SCSI standard only supports a
> single command for writing to zoned storage (WRITE). A write append
> emulation for SCSI exists in drivers/scsi/sd_zbc.c.
> 
> File system implementers have to decide whether to use Write or Zone
> Append. While the Zone Append command tolerates reordering, with this
> command the filesystem cannot control the order in which the data is
> written on the medium without restricting the queue depth to one.
> Additionally, the latency of write operations is lower compared to zone
> append operations. From [2], a paper with performance results for one
> ZNS SSD model: "we observe that the latency of write operations is lower
> than that of append operations, even if the request size is the same".

What is the queue depth for this claim ?

> The mq-deadline I/O scheduler serializes zoned writes even if these got
> reordered by the block layer. However, the mq-deadline I/O scheduler,
> just like any other single-queue I/O scheduler, is a performance
> bottleneck for SSDs that support more than 200 K IOPS. Current NVMe and
> UFS 4.0 block devices support more than 200 K IOPS.

FYI, I am about to post 20-something patches that completely remove zone write
locking and replace it with "zone write plugging". That is done above the IO
scheduler and also provides zone append emulation for drives that ask for it.

With this change:
 - Zone append emulation is moved to the block layer, as a generic
implementation. sd and dm zone append emulation code is removed.
 - Any scheduler can be used, including "none". mq-deadline zone block device
special support is removed.
 - Overall, a lot less code (the series removes more code than it adds).
 - Reordering problems such as due to IO priority is resolved as well.

This will need a lot of testing, which we are working on. But your help with
testing on UFS devices will be appreciated as well.

> 
> Supporting more than 200 K IOPS and giving the filesystem control over
> the data layout is only possible by supporting multiple outstanding
> writes and by preserving the order of these writes. Hence the proposal
> to discuss this topic during the 2024 edition of LSF/MM/BPF summit.
> Potential approaches to preserve the order of zoned writes are as follows:
> * Track (e.g. in a hash table) for which zones there are pending zoned
>    writes and submit all zoned writes per zone to the same hardware
>    queue.
> * For SCSI, if a SCSI device responds with a unit attention to a zoned
>    write, activate the error handler if the block device reports an
>    unaligned write error and sort by LBA and resubmit the zoned writes
>    from inside the error handler.
> 
> In other words, this proposal is about supporting both the Write and
> Zone Append commands as first class operations and to let filesystem
> implementers decide which command(s) to use.
> 
> [1] Stavrinos, Theano, Daniel S. Berger, Ethan Katz-Bassett, and Wyatt
> Lloyd. "Don't be a blockhead: zoned namespaces make work on conventional
> SSDs obsolete." In Proceedings of the Workshop on Hot Topics in
> Operating Systems, pp. 144-151. 2021.
> 
> [2] K. Doekemeijer, N. Tehrany, B. Chandrasekaran, M. Bjørling and A.
> Trivedi, "Performance Characterization of NVMe Flash Devices with Zoned
> Namespaces (ZNS)," 2023 IEEE International Conference on Cluster
> Computing (CLUSTER), Santa Fe, NM, USA, 2023, pp. 118-131, doi:
> 10.1109/CLUSTER52292.2023.00018.
> (https://ieeexplore.ieee.org/abstract/document/10319951).
> 

-- 
Damien Le Moal
Western Digital Research

