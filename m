Received: from out30-76.freemail.mail.aliyun.com (out30-76.freemail.mail.aliyun.com [115.124.30.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621D2390214;
	Wed,  4 Mar 2026 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772617423; cv=none; b=IqUb9X++bhSSsyjucHAG697Ov7hEm6Ga7FEt6xVbvodLUzYWVeAMdLmEsLE7hRIRTSVYfNlWGZm82BDWewBrjqCrwKQ/0/zk2lu0fpBkNhJ18mAsi40gvl7ZPzvdWgmn+vAO06chNJTN+LTzNntb0eH80O7NU+p041mfdtec/Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772617423; c=relaxed/simple;
	bh=oZlX3+22ZLyuC1Ack40OMHQ1E6dKLQwmWaRuhoEXjyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NAC1UuO4uOSBPFVjvEIRq5tPc6We2v3AySyXOeVzIMTECgr0iHyWy8eEyPhBLTWkRtUkwavIDPJ/PEqPdG3cTXVRihZ6NzQtKiy+RUSEeY3tBcA/Rj5G2XE1NcIZZlzpPVtPt/V/9xCzu1U8pQF6UA1kOXb6LAT0G2rUPeuRr/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=WwI+vnV6; arc=none smtp.client-ip=115.124.30.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="WwI+vnV6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1772617419; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=3kUpOQOANoHXp/ZfrIsuYNvlu25k9cuYl7xItGwySRQ=;
	b=WwI+vnV6++h+fXZwFgLk+sCYKYzMKthn0vsdwBJtCEESGfeFWDJ1teKc+c7CfJr3PtHLCyGFK27gSpgLe6xV3gOEX+NcARqIHeMXtADN97vCIVQDh4ndqjFVg5QyTnFtkJGSjLXcHmBdo23Sb8BqviwxzkWUy03jO56G4GQtNWg=
Received: from VM-209-93-tencentos(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0X-Ec8fd_1772617413 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Mar 2026 17:43:38 +0800
Date: Wed, 4 Mar 2026 17:43:33 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	dlemoal@kernel.org, bvanassche@acm.org, hch@infradead.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: core: Fix async_scan race condition with
 READ_ONCE/WRITE_ONCE
Message-ID: <aaf+ucySU/sSN8WZ@VM-209-93-tencentos>
References: <20260304075712.3039960-1-wdhh6@aliyun.com>
 <2885ac50-2326-4548-b92c-c5ae566a8013@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2885ac50-2326-4548-b92c-c5ae566a8013@oracle.com>

On Wed, Mar 04, 2026 at 09:20:25AM +0000, John Garry wrote:
> On 04/03/2026 07:57, Chaohai Chen wrote:
> > Previously, host_lock was used to prevent bit-set conflicts in async_scan,
> > but this approach introduced naked reads in some code paths.
> > 
> > Convert async_scan from a bitfield to a bool type to eliminate bit-level
> > conflicts entirely. Use READ_ONCE() and WRITE_ONCE() to ensure proper
> > memory ordering on Alpha and satisfy KCSAN requirements.
> 
> Is the shost->scan_mutex always held when shost->async_scan is read/written?
> 
Yes. In theory, there is no need for READ-ONCE/WRITE-ONCE. Plus, this belongs 
to defensive programming. And it indicates that this is a shared variable, 
which means that this variable will be accessed by multiple threads and 
concurrency issues need to be handled carefully.
