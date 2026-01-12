Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC942DCF72;
	Mon, 12 Jan 2026 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768230094; cv=none; b=bd3eMZgJd3bGvfSXWDeCHDiaUV8eYOBTD8uOe8ggyV1VPQFArK960kKS9TNK+j88IcQq4b26NH/fBsbvtSiI5QvAgA7IhPWOZxtuwLdJD245VwhGc3qiyOBiZqQ/M3zHihtfX8v9UsNb6EhqTLpJlGFxA9/6PO1yC17yMYjeBO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768230094; c=relaxed/simple;
	bh=x4SOdb+6rSors3dWFld5/1NpFl3cPMZg7CdGI35qeu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aua031ZEbqAddFfUHNwVCw5aW11BG5aAdVZPh8a9Q24cdy5RVphz6Cekj2df5s5/KPy4paqQ4XQ/uAuSr3ik9ig7DPUczDQunSFIInAfJLqiOsY46CQ5EIj+zimPZ34JOsinmKgIhHXi1sFx58eXLugBq/UXU+ZXiR93gUuPzqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpzTHbua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpzTHbua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43004C16AAE;
	Mon, 12 Jan 2026 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768230093;
	bh=x4SOdb+6rSors3dWFld5/1NpFl3cPMZg7CdGI35qeu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zpzTHbuaWxNtJjr2k9mCZKJCu36yC1zQmFNaVKqLBAZP67r5MTrN++Eqz/DuH+eSj
	 aijsGlCNCzZ6hEqnsUHNIhJDiVmOnxLMjbCgaFVX1rl0Lmh3NIvLdCOq6gqEGf9oHK
	 WuD3K9XDpc6HFEhnwuzZLDZABPsLdLuDROt8b2aw=
Date: Mon, 12 Jan 2026 16:01:30 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Thomas Fourier <fourier.thomas@gmail.com>, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com,
	Duane Grigsby <duane.grigsby@marvell.com>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Larry Wisneski <Larry.Wisneski@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Quinn Tran <qutran@marvell.com>, stable@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Message-ID: <2026011219-companion-shakiness-da9e@gregkh>
References: <20260112134326.55466-2-fourier.thomas@gmail.com>
 <4b22eead-086a-43e5-99f5-f2ce609b1567@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b22eead-086a-43e5-99f5-f2ce609b1567@web.de>

On Mon, Jan 12, 2026 at 03:12:54PM +0100, Markus Elfring wrote:
> > Earlier in the function, the ha->flt buffer is allocated with size
> > sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE but freed in the error
> > path with size SFP_DEV_SIZE.
> 
> See also once more:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.19-rc4#n94
> 
> 
> You should probably not only specify message recipients in the header field “Cc”.
> 
> 
> …
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -4489,7 +4489,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
> >  fail_elsrej:
> >  	dma_pool_destroy(ha->purex_dma_pool);
> >  fail_flt:
> > -	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
> > +	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
> >  	    ha->flt, ha->flt_dma);
> …
> 
> How do you think about to adjust the indentation another bit for the passed parameters?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.19-rc4#n110
> 
> Regards,
> Markus
> 


Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
