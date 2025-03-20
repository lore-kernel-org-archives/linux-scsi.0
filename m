Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3EDB665;
	Thu, 20 Mar 2025 06:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742450755; cv=none; b=iGi+tF8CiRqW94uEUPFHJ/HPj7fxj55KBj5aS/KVK68JJbDdoErFzEtBAb13rkD7+cRZHtwdKWnG9HhbemSNsH2jBCx9/c7MdBLDHue/pFkShlTgWhngxvPyK1LDc1lZWxQlI9qtpAaYqZ1RCi9Fo9+RN+xv4Etct9tSJPcED0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742450755; c=relaxed/simple;
	bh=xVPVif3RAlCJoTlHwdrhG8mij1+lx015vJigxtGBqtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+Rs19Z8oJ/yL666NLTQPboXsnB9jmNQNgMX2TZqEsT4sZhUhdaeHEYwEggfaUgx44LsE/egIMpNvzozGXfn8mzxxdJ2zxgbxLD0SJrxmRQ1KXbKRfv7tCpPpe52h+QfBuLbBvqZ3eorClXI9yGowumUAggSoRrPlYzHOsttlmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jXi+DNPd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jXi+DNPd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xVPVif3RAlCJoTlHwdrhG8mij1+lx015vJigxtGBqtE=; b=jXi+DNPd7SBhDNDtxD2nlL0YOF
	6T295RuT7wz7AzsTn0WG5afXXLsQ5p4njqQbTR112g1g1KfOFopqn4XcBuXJX8BzV3SD2YoWKf8X9
	IuA4bc4yTfg6YN6c3YmXQ64x2r03CkWRA1pdgCTVvH5R45TjFAjhD2bWmNy0PJwfN1jwvP3X1Z4og
	ldt2Oq2kX3n99Sr7dILPghP3rG0uCBskdXTZTfT0yAA0ljXpda2rsfNqrJFJkyphfowKooS02PVb9
	dbHHfd8UBU/UmntdkprCd3I5Dk7ADcQprqNBMeMKAAJJW7/TtxYYunY1prUbOhEODlZdOp6vsNHAA
	TqeKBx+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tv92N-0000000BHQD-0L4w;
	Thu, 20 Mar 2025 06:05:51 +0000
Date: Wed, 19 Mar 2025 23:05:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: JiangJianJun <jiangjianjun3@huawei.com>, jejb@linux.ibm.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, lixiaokeng@huawei.com,
	hewenliang4@huawei.com, yangkunlin7@huawei.com
Subject: Re: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new error
 handle mechanism
Message-ID: <Z9uwP4axlXOSWxQD@infradead.org>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
 <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 14, 2025 at 10:01:40AM +0100, Hannes Reinecke wrote:
> 3. The current EH framework is designed around 'struct scsi_cmnd'.
> Which means that the command _initiating_ the error handling can
> only be returned once the _entire_ error handling (with all
> escalations) is finished. And more often than not, the application
> is waiting on that command to be completed before the next I/O
> is sent. And that really limits the effectiveness of any improved
> error handler; the application ultimatively has to wait for a
> host reset before it can contine.

And someone needs to get your old series to fix that merged before
we even start talking about any major EH change.

