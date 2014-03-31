From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/4] scsi: reintroduce scsi_driver.init_command
Date: Sun, 30 Mar 2014 23:20:38 -0700
Message-ID: <1396246838.22255.53.camel@haakon3.risingtidesystems.com>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
	 <1395936862-6938-4-git-send-email-hch@lst.de>
	 <1396244704.22255.46.camel@haakon3.risingtidesystems.com>
	 <20140331060845.GA13184@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60900 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaCaGUv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 02:20:51 -0400
In-Reply-To: <20140331060845.GA13184@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Mon, 2014-03-31 at 08:08 +0200, Christoph Hellwig wrote:
> On Sun, Mar 30, 2014 at 10:45:04PM -0700, Nicholas A. Bellinger wrote:
> > >  int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
> > >  {
> > > -	struct scsi_cmnd *cmd;
> > > -	int ret = scsi_prep_state_check(sdev, req);
> > > -
> > > -	if (ret != BLKPREP_OK)
> > > -		return ret;
> > > -
> > > -	cmd = scsi_get_cmd_from_req(sdev, req);
> > > -	if (unlikely(!cmd))
> > > -		return BLKPREP_DEFER;
> > > +	struct scsi_cmnd *cmd = req->special;
> > >  
> > 
> > Mmm, I thought that req->special was only holding a pointer to a
> > pre-allocated scsi_cmnd during mq operation, no..?
> 
> For the mq case the block layer sets up req->special.  For the old case
> scsi_get_cmd_from_req sets up req->special the first it is called, and
> leaves it in there until the command is done.

Er, yes of course.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

