Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4634842065;
	Mon, 23 Jun 2025 05:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750655876; cv=none; b=lI5Vz2MADIAtRvf4Eq46+vP6Nct+9bDGSwmF6BG0x7e+yTRWHIdfyH1GjYQ579FfJirhiaWqwU5R0CYA8sWjyB/GdsOnpJDYJMAHbgqq4QiNTk7HyQnJ2ubv/UFKtH23nnvCTnH2VdP8cnN5usH/0UThq4nc+imzThmB/OLkbCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750655876; c=relaxed/simple;
	bh=gdVYohiBe++WE1g53f5ID2TiKNVV9cagqlokp/r/pD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ruveOUMl9mr3LPu7DTFQABTQ7Jm3VLGg6vzsdlVhaiwGPghJxgGCKZzU8d66BKslYSosOpABobdxG5GKCyNBuBfqf3dowPsq3JLnKCY45VZcgVpahnTGI7Am3z5+g9DjrecHR5BgxsGXuyG6tJlNo9A3W42VXjPaMHseRE3pIhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qa+uGOhy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qa+uGOhy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SpEsDHh90A3WyGVKRuH5eJNulD+BVc9pEehwgC5iVD0=; b=Qa+uGOhyPV+NbuMsV9+zMbA4Os
	KzAzfVfGqJTdARrcqZz0qagqkcFtjEECig41AsK4p/sub11yq3QU32J7ZCeydMQRhNt6p7qcbAsKa
	5TW8h7oqDU5k3AgKlJ5bO5PM13WxiA0z0yVtrgwT46QiA5pg7/njuXVU/ucWo7vjpEapXDEI3T8cK
	8AXyqMykZDq/MqdQE/jmwXRWiNkGFk53OZoGMl5DPDer0g28Oa/8P6e4i9jz0LjSvw/sJTm/db09a
	LPgxMtwIzyTPsnTbymXUafl0s8t0XZxrt3PDUcPIIagWTRbfLYwyl0XzMuDC/DuvAfUgHJLgUOkDm
	L27gB4qw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uTZZ1-00000001bGQ-0AVC;
	Mon, 23 Jun 2025 05:17:51 +0000
Date: Sun, 22 Jun 2025 22:17:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>, Daniel Wagner <wagi@kernel.org>
Cc: "Sean A." <sean@ashe.io>,
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>,
	"atomlin@atomlin.com" <atomlin@atomlin.com>,
	"kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
	"sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
	"sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
Message-ID: <aFjjf3qbuEOeWUjt@infradead.org>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
 <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 18, 2025 at 07:49:16AM +0100, John Garry wrote:
> BTW, if you use taskset to set the affinity of a process and ensure that
> /sys/block/xxx/queue/rq_affinity is set so that we complete on same CPU as
> submitted, then I thought that this would ensure that interrupts are not
> bothering other CPUs.

The RT folks want to not even have interrupts on the application CPUs.
That's perfectly reasonable and a common request.  Why doing driver
hacks as in this patch and many others is so completely insane.  Instead
we need common functionality for that.  The core irq layer has added
them for managed interrupts, and Daniel has been working on the blk-mq side
for a while.

