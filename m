From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Fri, 10 Jan 2003 12:06:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301101706.h0AH6rr03943@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA20354
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2003 09:06:57 -0800
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Wed, 08 Jan 2003 13:13:06 PST." <20030108211306.GG1112@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

I got around to looking at the patch.

I think the idea of slab allocation for Scsi_Cmnds is generally worth the 
effort.  There are several issues with the current patch, though:

1) The command for the device has to be allocated in space that respects the 
dma_mask for the device (on a non MMIO bus).  Pretty much for scsi, this 
translates to using GFP_DMA as the allocation flag if unchecked_isa_dma is 
set.  GFP_DMA has to be passed in at kmem_cache_create time.  We therefore 
probably need the capacity to use a different kmem_cache on a per Scsi_Host 
basis and the ability to set up a GFP_DMA kmem_cache if a host with 
unchecked_isa_dma appears.

2) scsi_get_command takes the host lock when obtaining a command from it's 
free_list.  Unfortunately, scsi_get_command looks to be called from places 
(like the prep_fn) where the lock is already held => deadlock.

3) The free_list employs all the list machinery for potentially storing 
multiple commands, but in practice it looks like it only ever stores one of 
them.  Is there a plan to make this free_list size tuneable (probably tuneable 
per device)?

James


