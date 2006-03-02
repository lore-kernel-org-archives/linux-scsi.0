From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 02 Mar 2006 17:58:11 +0100
Message-ID: <1141318691.3206.87.camel@laptopd505.fenrus.org>
References: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11739 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1752011AbWCBQ6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 11:58:19 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: "Ju, Seokmann" <Seokmann.Ju@engenio.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2006-03-02 at 09:53 -0700, Ju, Seokmann wrote:
> Hi,
> 
> In the 'scsi_cmnd' structure, there are two entries holding address
> information for data to be transferred. One is 'request_buffer' and the
> other one is 'buffer'.
> In case of 'use_sg' is non-zero, those entries indicates the address of
> the scatter-gather table.

use_sg is never non-zero so that's easy

> 
> Is there way to get virtual address (so that the data could be accessed
> by the driver) of the actual data in the case of 'use_sg' is non-zero?

not really; unless you mapped it. The physical address may already been
translated by the iommu... at which point there is no direct mapping to
kernel memory.

Why do you need to do this? It's generally bad for drivers to snoop
data! 

