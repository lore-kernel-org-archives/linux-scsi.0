From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH, RFC] st: start using scsi_execute
Date: Mon, 30 Jan 2006 15:36:31 -0600
Message-ID: <43DE86DF.5070901@cs.wisc.edu>
References: <20060130182324.GA6253@lst.de> <Pine.LNX.4.63.0601302308001.4212@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:64162 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030191AbWA3Vgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 16:36:42 -0500
In-Reply-To: <Pine.LNX.4.63.0601302308001.4212@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Mon, 30 Jan 2006, Christoph Hellwig wrote:
> 
> 
>>This patch updates st to use scsi_execute instead of scsi_execute_async
>>for all scsi commands except the main I/O path.  The advantage is that
>>these helpers do all the request tracking for these synchronous I/Os so
>>that there is no need for st_request structures.  It also decouples
>>these helper scsi commands from the main tape buffer, allowing for an
>>easier switchover to the generic block request mapping routines for the
>>main I/O path later on.
>>
> 
> I think the main tape buffer will stay for quite a long time. Using it has 
> the advantage that it is allocated using GFP_DMA if necessary. This is not 
> a problem if scsi_execute does bouncing somewhere if it needs to be done.
> 

scsi_execute needs a blk_queue_bounce call.
