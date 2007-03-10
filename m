From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ PATCH ] mptsas: Fix oops for insmod during kexec
Date: Sat, 10 Mar 2007 09:26:43 +0000
Message-ID: <20070310092643.GB22182@infradead.org>
References: <20070309212237.GA25326@infradead.org> <664A4EBB07F29743873A87CF62C26D70623D04@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42429 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030310AbXCJJ0s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Mar 2007 04:26:48 -0500
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70623D04@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Judith Lebzelter <judith@linux-foundation.org>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Fri, Mar 09, 2007 at 03:22:13PM -0700, Moore, Eric wrote:
> On Friday, March 09, 2007 2:23 PM, Christoph Hellwig wrote: 
> 
> 
> > This needs a much better explanation.  Please show the codepath
> > leading to this.
> > 
> >
> 
> I was working with Judith on this patch earlier this week, so this is
> approved by LSI,,, ACK.
> 
> This fix's an oops during driver load time.   mptsas_probe calls
> mpt_attach(over in mptbase.c).  Inside that call, we read some
> manufacturing config pages to setup some defaults.  While reading the
> config pages, the firmware doesn't complete the reply in time, and we
> have a timeout. The timeout results in hardreset handler being called.
> The hardreset handler calls all the fusion upper layer driver reset
> callback handlers.  The mptsas_ioc_reset function is the callback
> handler in mptsas.c.   So where I'm getting to, is mptsas_ioc_reset is
> getting called before scsi_host_alloc is called, and the pointer ioc->sh
> is NULL.,,, as well as the hostdata. 

Ok.  Please put a reformulated version of the above statement as a comment
above the checks, so that people don't rip it out again.

