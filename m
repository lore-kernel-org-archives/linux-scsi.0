From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Setting queue depths in the scsi mid layer, an intro
Date: Mon, 14 Oct 2002 18:15:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021014181512.A7237@eng2.beaverton.ibm.com>
References: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com>; from dledford@redhat.com on Thu, Oct 10, 2002 at 10:46:26PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

Doug -

Finally looking at and using the new queue depth code in 2.5.42.

Why are there two kmalloc()'s in scsi.c scsi_build_commandblocks()? 

They both use the same flags, including GFP_ATOMIC:

void scsi_build_commandblocks(Scsi_Device * SDpnt)
{
	unsigned long flags;
	Scsi_Cmnd *SCpnt;

	if (SDpnt->queue_depth != 0)
		return;
		
	SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
	if (NULL == SCpnt) {
		/*
		 * Since we don't currently have *any* command blocks on this
		 * device, go ahead and try an atomic allocation...
		 */
		SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
		if (NULL == SCpnt)
			return;	/* Oops, we aren't going anywhere for now */
	}

	memset(SCpnt, 0, sizeof(Scsi_Cmnd));

[ ... ]

-- Patrick Mansfield
