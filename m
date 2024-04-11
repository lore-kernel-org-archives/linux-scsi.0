Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFE12EAE5;
	Thu, 11 Apr 2024 07:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712820555; cv=none; b=Bp0OeJUC86qb6GvEmzSPnyOC0UHR8vVnU3Eq2G5ZpUNyaiISmSmHq7u6v6P7DpaPk6xim40ArHmBK3VSxUFiL1+h8xvsaTMVXqGXBh27CKsK7X/HLAnFyk1WiGLidaXQQqVe/qmnsxwL6d1EI/Ni+HNftsKuBF3Zhg7aWiakvp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712820555; c=relaxed/simple;
	bh=qhh+HFgnD5ox2Pc3uLoIsj/1W0p7M3Gm7DG3ga5Iuks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOxIyueJeIeKrJRZxv2ypyYXoEvJ8rouc8ExE5ak21fbtTt/I4zra+QVo/z2+vkgZr05bRItC6GsLDHscEDFiwF3VTz1ff6W0l8h9V8pgP4eGKfqagDx20j9qOn+qeXpuHBc5/gkw8jjSNgjj33s7VFknDakbXT4WwfJTWuolSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf2Xukhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf2Xukhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38138C433F1;
	Thu, 11 Apr 2024 07:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712820554;
	bh=qhh+HFgnD5ox2Pc3uLoIsj/1W0p7M3Gm7DG3ga5Iuks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qf2Xukhuq1tpqB93E5tlI6wEqqggG95z+q9BPaj3lw5a4Jl9su80qPULn9XnCnDd+
	 65USnrsGSp5WqRnW5CNFyq3bpEpbYA1d5JDtP8FWAsIfu5Rh0a+jg3nSmV0ljdUvU3
	 Zt3Yokb2Y66K+PqruJk6dhrDDAV3hWeZuMBYyshw=
Date: Thu, 11 Apr 2024 09:29:11 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: John David Anglin <dave.anglin@bell.net>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-parisc <linux-parisc@vger.kernel.org>,
	linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Broken Domain Validation in 6.1.84+
Message-ID: <2024041155-croon-dried-f649@gregkh>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
 <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
 <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
 <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
 <cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
 <6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
 <03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
 <yq1wmp9pb0d.fsf@ca-mkp.ca.oracle.com>
 <b3df77f6-2928-46cd-a7ee-f806d4c937d1@bell.net>
 <yq1frvvpymp.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1frvvpymp.fsf@ca-mkp.ca.oracle.com>

On Mon, Apr 08, 2024 at 01:19:50PM -0400, Martin K. Petersen wrote:
> 
> Dave,
> 
> >> Could you please try the patch below on top of v6.1.80?
> > Works okay on top of v6.1.80:
> >
> > [   30.952668] scsi 6:0:0:0: Direct-Access     HP 73.4G ST373207LW       HPC1 PQ: 0 ANSI: 3
> > [   31.072592] scsi target6:0:0: Beginning Domain Validation
> > [   31.139334] scsi 6:0:0:0: Power-on or device reset occurred
> > [   31.186227] scsi target6:0:0: Ending Domain Validation
> > [   31.240482] scsi target6:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > [   31.462587] ata5: SATA link down (SStatus 0 SControl 0)
> > [   31.618798] scsi 6:0:2:0: Direct-Access     HP 73.4G ST373207LW       HPC1 PQ: 0 ANSI: 3
> > [   31.732588] scsi target6:0:2: Beginning Domain Validation
> > [   31.799201] scsi 6:0:2:0: Power-on or device reset occurred
> > [   31.846724] scsi target6:0:2: Ending Domain Validation
> > [   31.900822] scsi target6:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> 
> Great, thanks for testing!
> 
> Greg, please revert the following commits from linux-6.1.y:
> 
> b73dd5f99972 ("scsi: sd: usb_storage: uas: Access media prior to querying device properties")
> cf33e6ca12d8 ("scsi: core: Add struct for args to execution functions")
> 
> and include the patch below instead.

Now done, thanks!

greg k-h
