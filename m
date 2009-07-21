From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [PATCH 0/3] scsi_dh: Add ability to set parameters for scsi
 device handler
Date: Tue, 21 Jul 2009 15:36:18 -0400
Message-ID: <1248204978.6416.127.camel@eddie-laptop>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	 <1248095119.6307.17.camel@eddie-laptop>
	 <1248138075.10481.35.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o142.mxlogic.net ([208.65.145.75]:34233 "EHLO
	p02c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbZGUTgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 15:36:35 -0400
In-Reply-To: <1248138075.10481.35.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com, Hannes Reinecke <hare@suse.de>


Tested-by: Eddie Williams <Eddie.Williams@steeleye.com>


On Mon, 2009-07-20 at 18:01 -0700, Chandra Seetharaman wrote:
> Hannes would know about the origin of this. 
> 
> If the patches are working as expected, can you send a "Tested-by" so
> that James can accept this patch.
> 
> Thanks.
> 
> chandra
> On Mon, 2009-07-20 at 09:05 -0400, Eddie Williams wrote:
> > Your patch set works well but the scsi_dh_emc.c in rc1 does not.  I
> > applied your patches to the SLES 11 (2.6.27.23) and I am able to set the
> > parameter with reservations being handled correctly.  As noted in an
> > earlier email when I tested the 2.6.31-rc1 kernel with and without your
> > patches I would see a panic.  I compared the scsi_dh_emc.c in rc1 with
> > SLES 11.  There are a couple of differences.  The panic is resolved with
> > the changes from SLES 11.  I am not sure if these are changes made to
> > SLES 11 and not made to the upstream kernel or whether there was a patch
> > to the upstream kernel after 2.6.27 that broke this.  Here are the
> > changes when applied to rc1 that resolves the panic and allowed me to
> > test your patches.
> > 
> > *** linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
> > 2009-07-20 08:37:14.000000000 -0400
> > --- linux-2.6.31-rc1.0.3/drivers/scsi/device_handler/scsi_dh_emc.c
> > 2009-07-20 08:42:36.000000000 -0400
> > ***************
> > *** 176,182 ****
> >   		err = SCSI_DH_DEV_TEMP_BUSY;
> >   		goto out;
> >   	}
> > ! 	if (csdev->buffer[4] > 2) {
> >   		/* Invalid buffer format */
> >   		sdev_printk(KERN_NOTICE, sdev,
> >   			    "%s: invalid VPD page 0xC0 format\n",
> > --- 176,182 ----
> >   		err = SCSI_DH_DEV_TEMP_BUSY;
> >   		goto out;
> >   	}
> > ! 	if (csdev->buffer[4] < 0 || csdev->buffer[4] > 2) {
> >   		/* Invalid buffer format */
> >   		sdev_printk(KERN_NOTICE, sdev,
> >   			    "%s: invalid VPD page 0xC0 format\n",
> > ***************
> > *** 272,278 ****
> >   	int len = 0;
> >   
> >   	rq = blk_get_request(sdev->request_queue,
> > ! 			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
> >   	if (!rq) {
> >   		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
> >   		return NULL;
> > --- 272,278 ----
> >   	int len = 0;
> >   
> >   	rq = blk_get_request(sdev->request_queue,
> > ! 			(cmd != INQUIRY) ? WRITE : READ, GFP_NOIO);
> >   	if (!rq) {
> >   		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
> >   		return NULL;
> > ***************
> > *** 286,299 ****
> > --- 286,302 ----
> >   		len = sizeof(short_trespass);
> >   		rq->cmd_flags |= REQ_RW;
> >   		rq->cmd[1] = 0x10;
> > + 		rq->cmd[4] = len;
> >   		break;
> >   	case MODE_SELECT_10:
> >   		len = sizeof(long_trespass);
> >   		rq->cmd_flags |= REQ_RW;
> >   		rq->cmd[1] = 0x10;
> > + 		rq->cmd[8] = len;
> >   		break;
> >   	case INQUIRY:
> >   		len = CLARIION_BUFFER_SIZE;
> > + 		rq->cmd[4] = len;
> >   		memset(buffer, 0, len);
> >   		break;
> >   	default:
> > ***************
> > *** 301,307 ****
> >   		break;
> >   	}
> >   
> > - 	rq->cmd[4] = len;
> >   	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> >   	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
> >   			 REQ_FAILFAST_DRIVER;
> > --- 304,309 ----
> > 
> > On Wed, 2009-07-01 at 20:13 -0700, Chandra Seetharaman wrote:
> > > Hello,
> > > 
> > > Last week, Eddie Williams reported a regression w.r.t scsi_dh
> > > (http://www.redhat.com/archives/dm-devel/2009-June/msg00285.html).
> > > Parameter setting part of dm multipath handler has been removed
> > > when we moved to scsi device handler.
> > > 
> > > This set of patches adds an new interface to scsi_dh and uses it.
> > > 
> > > This patch set applies on 2.6.31-rc1 and the following 2 patches:
> > > 	(1) http://patchwork.kernel.org/patch/32646/raw/
> > > 	(2) http://patchwork.kernel.org/patch/32647/raw/
> > > 
> > > This interface part of the patch has been tested.
> > > 
> > > Eddie,
> > > 
> > > If you can test it on an EMC storage and respond with your
> > > findings it will be of great help.
> > > 
> > > Thanks,
> > > 
> > > chandra
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

