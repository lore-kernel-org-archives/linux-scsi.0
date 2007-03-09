From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [ PATCH ] mptsas: Fix oops for insmod during kexec
Date: Fri, 9 Mar 2007 15:22:13 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70623D04@NAMAIL4.ad.lsil.com>
References: <20070309212237.GA25326@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48124 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767566AbXCIWWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Mar 2007 17:22:34 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20070309212237.GA25326@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Judith Lebzelter <judith@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Friday, March 09, 2007 2:23 PM, Christoph Hellwig wrote: 


> This needs a much better explanation.  Please show the codepath
> leading to this.
> 
>

I was working with Judith on this patch earlier this week, so this is
approved by LSI,,, ACK.

This fix's an oops during driver load time.   mptsas_probe calls
mpt_attach(over in mptbase.c).  Inside that call, we read some
manufacturing config pages to setup some defaults.  While reading the
config pages, the firmware doesn't complete the reply in time, and we
have a timeout. The timeout results in hardreset handler being called.
The hardreset handler calls all the fusion upper layer driver reset
callback handlers.  The mptsas_ioc_reset function is the callback
handler in mptsas.c.   So where I'm getting to, is mptsas_ioc_reset is
getting called before scsi_host_alloc is called, and the pointer ioc->sh
is NULL.,,, as well as the hostdata. 
 
