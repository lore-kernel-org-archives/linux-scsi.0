From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 2 Mar 2006 10:04:57 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C2651420C2@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:24059 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751390AbWCBRFE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 12:05:04 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On Thursday, March 02, 2006 11:58 AM Arjan van de Ven wrote:
> Why do you need to do this? It's generally bad for drivers to snoop
> data! 
I understood that is bad. I am trying to make sure the data written to disk drive are identical with the data from upper layer by comparing actual data in the driver.
This is a part of debugging only not for release driver, obviously.
So, is it completely unable to get this done?
Any tricky solution?

Thank you,

> -----Original Message-----
> From: Arjan van de Ven [mailto:arjan@infradead.org] 
> Sent: Thursday, March 02, 2006 11:58 AM
> To: Ju, Seokmann
> Cc: Ju, Seokmann; linux-kernel@vger.kernel.org; 
> linux-scsi@vger.kernel.org
> Subject: Re: Question: how to map SCSI data DMA address to 
> virtual address?
> 
> On Thu, 2006-03-02 at 09:53 -0700, Ju, Seokmann wrote:
> > Hi,
> > 
> > In the 'scsi_cmnd' structure, there are two entries holding address
> > information for data to be transferred. One is 
> 'request_buffer' and the
> > other one is 'buffer'.
> > In case of 'use_sg' is non-zero, those entries indicates 
> the address of
> > the scatter-gather table.
> 
> use_sg is never non-zero so that's easy
> 
> > 
> > Is there way to get virtual address (so that the data could 
> be accessed
> > by the driver) of the actual data in the case of 'use_sg' 
> is non-zero?
> 
> not really; unless you mapped it. The physical address may 
> already been
> translated by the iommu... at which point there is no direct 
> mapping to
> kernel memory.
> 
> Why do you need to do this? It's generally bad for drivers to snoop
> data! 
> 
> 
