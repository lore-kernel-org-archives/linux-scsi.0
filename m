From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE
	Adaptec SCSI controller
Date: Thu, 20 Sep 2007 19:41:47 -0500
Message-ID: <1190335307.3360.66.camel@localhost.localdomain>
References: <1183207551.14436.15.camel@linux.site>
	 <1190300889.31372.4.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38488 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752272AbXIUAlv (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 20:41:51 -0400
In-Reply-To: <1190300889.31372.4.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Anil K. Ravindranath" <anil_ravindranath@adaptec.com>
Cc: Linux-scsi@vger.kernel.org

On Thu, 2007-09-20 at 08:08 -0700, Anil K. Ravindranath wrote:
> Hi,
> 
> We have not heard any comments or inputs on this patch. 
> 
> With regards,
>   Anil
> 
> On Sat, 2007-06-30 at 05:45 -0700, Anil K. Ravindranath wrote:
> > Subject: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE
> > Adaptec SCSI controller
> > 
> > Contribution:
> > 
> > Anil Ravindranath <anil_ravindranath@adaptec.com>
> > 
> > Issue:
> > 
> > Data Bursts that cross from 32- to 64-Bit address space have incorrect
> > address for 29320LPE. This leads to potential data corruption.

Where do you think you see this happening?  The block layer has a
dma_boundary parameter (basically a mask which it refuses to allow dma
to cross).  By default this is set to 4GB (because a lot of PCI cards
have difficulty going from non-DAC to DAC).  The aic79xx driver does
nothing to alter this, so you shouldn't be seeing any DMA segments
crossing the 4GB boundary.

James


