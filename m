From: Jens Axboe <axboe@suse.de>
Subject: Re: Max IO size
Date: Fri, 2 Aug 2002 08:44:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802064403.GG1512@suse.de>
References: <20020801084547.GA12715@suse.de> <20020801235432.14372.qmail@web14005.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020801235432.14372.qmail@web14005.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 01 2002, Mukul Kotwani wrote:
> 
> Thanks for the reply!
> 
> All my values are set high. The sg_tablesize value is
> set to 249, max_sectors set to 1024, and I dont think
> there is any other value which affects IO size as
> such. I didnt see anything called max segment size/max
> size in the host template. Any other things I am
> missing?

The max segment size is a property of the queue associated with the SCSI
devices, it's in fact not directly controllable by the low level driver
in the 2.4 kernels. What you can set in this regard is 'use_clustering'.
With that set, the mid layer will attempt to merge contigious pages into
the same scatter gather segment. This usually only provides a benefit
with 1kb transfers (since they will typically be submitted in multiples
anyway from the same page, thus it's easy to cluster them), with eg 4kb
transfer sizes the amount of clustering that will happen is neglible.

-- 
Jens Axboe

