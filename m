From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx - wrong max memory at driver init
Date: Fri, 15 Dec 2006 11:47:47 -0600
Message-ID: <1166204867.2846.28.camel@mulgrave.il.steeleye.com>
References: <456EBB83.9010300@ext.bull.net>  <45812976.4090000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41767 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753067AbWLORr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Dec 2006 12:47:59 -0500
In-Reply-To: <45812976.4090000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>, xb <xavier.bru@bull.net>, linux-scsi@vger.kernel.org

On Thu, 2006-12-14 at 11:37 +0100, Hannes Reinecke wrote:
> Frederic TEMPORELLI wrote:
> > Hello Hannes,
> > 
> > Aic79xx driver for Adaptec 39320 supports 64-bit addressing, but the
> > initialization code of the driver is wrong: it tests the available
> > memory size instead of testing the maximum available memory address.
> > This is necessary to support servers that provides 1 Terabyte of
> > physical memory space addressing.
> > 
> > Attached is the suggested patch (made against 2.6.17, but 2.6.19 is
> > still using the available memory size instead of using the max memory
> > address) to solve this issue.

Actually, this driver shouldn't be hacking around at all with either the
memory functions or blk_max_pfn, it should be using the provided api,
which is dma_get_required_mask()

James


> > Signed-off-by: xavier.bru@bull.net
> > Signed-off-by: frederic.temporelli@bull.net
> > 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 

