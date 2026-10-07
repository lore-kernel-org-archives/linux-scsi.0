Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B2342885F;
	Wed,  7 Oct 2026 14:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383713; cv=none; b=WF3pcbmXpZG7Gi+LQ8zQ0lWQva0Ts8xuZvJMaQrr3aY6ZFip6FmiiuIbpUb7hAkYp3ZtLyZiogUCyErkq94UZd2q9UVhCmGE01rqeWPdFk7h4ZXhKUSJ13aHNLDX+RC5M5eSs+Vn9rqTdSFGxy+2C7EkxdomBtwW3ybGrM26SvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383713; c=relaxed/simple;
	bh=4FEGiK/4wexZFM4ksoXoTuVkaVoope+UGq5Cdfb6M+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkX+MAI0JslxDvEivUk3ynK89+fB2ydweK2dSFbAiWao4Gew09MuKwy1pqPt7JkT6Ss14Gc63Kqc0fztS1tN+rC8qtfwC0NuztLb9RlKWOp+6BdC5bBE9fSC9vDeHzR7UdjhWo8Di/feseRU1DbGUcgZ5mUIE/II9ZKcAOwD1IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFD8V5mm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFD8V5mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D559A1F0089B;
	Wed,  7 Oct 2026 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791383707;
	bh=IHKDwp7mBNQlRDXgIIPfIF3HyFXf8P6BMalBkdyw5RU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jFD8V5mmIP8FtbKd29J88LPq9Dyt4a9nRfyuLrW+eNBpt3XZhWZQ2fXB0606aXc18
	 l1LazzZoX+8cK24b26qJWcmPDSNIwMKb1uABe1q/++79rG9QSONEk/N4Jcezsaq+Dg
	 kleMf7zo8Lmal2CgTAlPVqL8BTp1miQ+1qOP6CyLM7YPmBOCSyD34y5005iA4PVMzI
	 O8wj8EylUzvzA8OpSx4StQArnSfhz9htfq181BzgajKprsl3lb5tZadOezzC3jTZKP
	 ucWVM18RtLEZPloTXqt/Z8PePVuTpgHNSBnUqU7rOG1b9KmqsPLh613h1+8hWPhnHd
	 ptS7g+UtsV1yA==
Message-ID: <c718e8cd-a395-49cf-ba78-4b746b01f563@kernel.org>
Date: Wed, 7 Oct 2026 16:35:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] block: introduce storage element management
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-3-dlemoal@kernel.org> <20261007133537.GB31906@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261007133537.GB31906@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/07 15:35, Christoph Hellwig wrote:
> On Wed, Oct 07, 2026 at 05:23:39PM +0900, Damien Le Moal wrote:
>> Co-developed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> That's a lot of credit for the two or three trivial fixes that got
> folded in, I'd drop that line.
> 
>> +static int disk_wait_for_se_mgmt_completion(struct gendisk *disk)
>> +{
>> +	struct blk_storage_element *elements, *e;
>> +	unsigned int i, nr_se, nr_elements = 0;
>> +	unsigned int noio_flag;
>> +	int ret;
>> +
>> +	/* The callers already checked that disk->fops->se_ops is set. */
>> +	ret = disk->fops->se_ops->report_elements(disk, NULL, &nr_elements);
> 
> Sashikoa thing report_elements could be zero.  Which is of course
> a bit stupid, but maybe we can protect against that by checking that
> all members are set at registration time for the bdops?

Yes, I thought about the same.

>> +		ret = disk->fops->se_ops->report_elements(disk, elements,
>> +							  &nr_se);
>> +		if (ret) {
>> +			pr_err("Failed to get storage elements\n");
>> +			break;
>> +		}
>> +
>> +		e = elements;
> 
> Same for e?  And maybe factor this entire loop into a helper to make
> sure nothing leaks out.

Yes, that will be cleaner.

> 
>> +		for (i = 0; i < nr_se; i++, e++) {
>> +			if (e->status == BLK_SE_STS_REMOVE_IN_PROGRESS ||
>> +			    e->status == BLK_SE_STS_RESTORE_IN_PROGRESS)
>> +				break;
> 
> Switch?  And yeah, the Sashiko comment on the error handling here
> looks correct to me.
> 
>> +		if (i >= nr_se)
>> +			break;
> 
> And this looks a bit odd.  Why not use a goto to get out instead of
> this nesting (splitting it into a separate helper would take care
> of that with a direct return as well).
> 
>> +		/* Not done yet: wait and retry. */
>> +		msleep(1000);
> 
> It would be nice to have a UA for this in future spec versions
> instead of he busy wait.

Yes it would be, but that would be supported by SAS drives only. SATA does not
have UA, and that means that HBAs would need to emulate it... Not
straightforward and probably will lead to lots of differences between adapters.


-- 
Damien Le Moal
Western Digital Research
