Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F2235AC1E;
	Mon, 24 Aug 2026 04:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787547517; cv=none; b=D5iuiWGyA42IJlSeVUdItjJPTSwrZfXntrGXPF3hUvwmor75C2W93jfEckB3oPvGuctjKJdDH7Qcb/RjKAliMaC2kqBXftqZmgO3uvs7jpfMHMVIoIXbqaJynr/D+EeyMOs5uboiyBdzb6CaNcQNayQdDC//1RBL+kBui7TZwUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787547517; c=relaxed/simple;
	bh=XJBLDJ4AW0gi0XS5kKB/URu6yfLB2VWh7ue5geCqCrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=en63WPbBOkij1pcs7I9GP5MIUJOVwJF8xeCilT2CaUOO0Fr1seyc8HrOoU/D/mr4d8c/IrnL8Rn9+1oKgdtW1IYbgiGiN/QUb0noKEJ52GUixDDhnmeBv9jj9Ld/BaWx2iddNDRfdE49hvYFDm65DLeYq1HE295PdA2IsUQ8Ju4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 99B2268BFE; Mon, 24 Aug 2026 06:58:30 +0200 (CEST)
Date: Mon, 24 Aug 2026 06:58:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/5] common/scsi_debug: don't slow down I/O
Message-ID: <20260824045830.GA29550@lst.de>
References: <20260821051133.1817670-1-hch@lst.de> <20260821051133.1817670-2-hch@lst.de> <d3289f5b-7b4c-44ce-99ba-c7ff0f59404d@oracle.com> <23760489-a45c-4b00-8500-9e8f4c9189df@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23760489-a45c-4b00-8500-9e8f4c9189df@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 21, 2026 at 09:14:29AM -0700, Bart Van Assche wrote:
> On 8/21/26 12:41 AM, John Garry wrote:
>> On 21/08/2026 06:11, Christoph Hellwig wrote:
>>> scsi_debug by defaults delays I/O 
>>
>> Maybe we can just make delay=0 default for that driver. Or use ndelay > 0.
>
> I'm in favor of changing the default delay to zero. It's what most users
> need and it's easy to forget to specify delay=0 when loading scsi_debug.

I won't object such a patch.  But we'll still want to force this
in xfstests to not rely on such a change.

