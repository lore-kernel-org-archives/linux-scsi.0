From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Thin provisioning
Date: Sat, 03 Oct 2009 09:49:49 -0400
Message-ID: <4AC7567D.2080507@interlog.com>
References: <yq1eipldt0y.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48496 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbZJCNtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Oct 2009 09:49:50 -0400
In-Reply-To: <yq1eipldt0y.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> scsi_debug: Thin provisioning support
> 
> Implement support for thin provisioning in scsi_debug.  No actual memory
> de-allocation is taking place.  The intent is to emulate a thinly
> provisioned storage device, not to be one.
> 
> There are four new module options:
> 
>  - unmap_granularity specifies the granularity at which to track mapped
>    blocks (specified in number of logical blocks).  2048 (1 MB) is a
>    realistic value for disk arrays although some may have a finer
>    granularity.
> 
>  - unmap_alignment specifies the first LBA which is naturally aligned on
>    an unmap_granularity boundary.
> 
>  - unmap_max_desc specifies the maximum number of ranges that can be
>    unmapped using one UNMAP command.  If this is 0, only WRITE SAME is
>    supported and UNMAP will cause a check condition.
> 
>  - unmap_max_blocks specifies the maximum number of blocks that can be
>    unmapped using a single UNMAP command.  Default is 0xffffffff.
> 
> These parameters are reported in the new and extended block limits VPD.
> 
> If unmap_granularity is specified the device is tagged as thin
> provisioning capable in READ CAPACITY(16).  A bitmap is allocated to
> track whether blocks are mapped or not.  A WRITE request will cause a
> block to be mapped.  So will WRITE SAME unless the UNMAP bit is set.
> 
> Blocks can be unmapped using either WRITE SAME or UNMAP.  No accounting
> is done to track partial blocks.  This means that only whole blocks will
> be marked free.  This is how the array people tell me their firmwares
> work.
> 
> GET LBA STATUS is also supported.  This command reports whether a block
> is mapped or not, and how long the adjoining mapped/unmapped extent is.
> 
> The block allocation bitmap can also be viewed from user space via:
> 
> 	/sys/bus/pseudo/drivers/scsi_debug/map
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
