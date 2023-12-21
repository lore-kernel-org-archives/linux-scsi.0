Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19A6C2FD
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 06:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xLIFS3Pg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B6IEDpKxmFT6XzoVY67nmt1UAN0GIzc6WD3LlcrBHUA=; b=xLIFS3Pg0NZCV8AK8QfxlV0ab4
	A4+EmFJMuo3lBozKSGWcE4eFne9tslAKWUYjyPVcVsEoQTqhCPZ6BWbneVPif4hRTh8jLLgeVYh0E
	aBwZX0Dn2RMJAqpwmM0KPPolvsUN6vNi8yvUUH7Gu1FnXk/M6dHwizLhS/0W1rjfvLk29oysZJMai
	O+2wYVOvrZImLQCg+1uiVwSO8XdgYHZmj9P4I6mt45NgdGFQc3W0/EmBHkHoPKg0LGra7EOW/eTo5
	1s5MAnPR23m/l/cGpAkIn4b9WAF92UUQpkZu74oaXnlKvzxI1NM6jvABbkjtlNAprHnrjzaH9dKAO
	aWRNQsmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGCqt-001qoc-0r;
	Thu, 21 Dec 2023 06:48:15 +0000
Date: Wed, 20 Dec 2023 22:48:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Nilesh Javali <njavali@marvell.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"lduncan@suse.com" <lduncan@suse.com>,
	"cleech@redhat.com" <cleech@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
	"jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [EXT] Re: [PATCH] cnic: change __GFP_COMP allocation method
Message-ID: <ZYPfr5G2j2VWUmfR@infradead.org>
References: <20231219055514.12324-1-njavali@marvell.com>
 <ZYExB52f/iDzD8xL@infradead.org>
 <CO6PR18MB4500F0DCD64925A775A45F2DAF97A@CO6PR18MB4500.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB4500F0DCD64925A775A45F2DAF97A@CO6PR18MB4500.namprd18.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 19, 2023 at 06:16:38AM +0000, Nilesh Javali wrote:
> If you are referring to the series proposed by Chris Leech, then this had
> objections. And that was the reason to look for an alternative method for
> coherent DMA mapping. 
> 
> [PATCH 0/3] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x

Yes.  Well, Greg (rightly) dislikes what the iscsi drivers have been
doing.  But we're stuck supporting them, so I see no way around that.

