From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] scsi: reintroduce scsi_driver.init_command
Date: Mon, 31 Mar 2014 08:08:45 +0200
Message-ID: <20140331060845.GA13184@lst.de>
References: <1395936862-6938-1-git-send-email-hch@lst.de> <1395936862-6938-4-git-send-email-hch@lst.de> <1396244704.22255.46.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60685 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaCaGIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 02:08:49 -0400
Content-Disposition: inline
In-Reply-To: <1396244704.22255.46.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Sun, Mar 30, 2014 at 10:45:04PM -0700, Nicholas A. Bellinger wrote:
> >  int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
> >  {
> > -	struct scsi_cmnd *cmd;
> > -	int ret = scsi_prep_state_check(sdev, req);
> > -
> > -	if (ret != BLKPREP_OK)
> > -		return ret;
> > -
> > -	cmd = scsi_get_cmd_from_req(sdev, req);
> > -	if (unlikely(!cmd))
> > -		return BLKPREP_DEFER;
> > +	struct scsi_cmnd *cmd = req->special;
> >  
> 
> Mmm, I thought that req->special was only holding a pointer to a
> pre-allocated scsi_cmnd during mq operation, no..?

For the mq case the block layer sets up req->special.  For the old case
scsi_get_cmd_from_req sets up req->special the first it is called, and
leaves it in there until the command is done.

> > +	ret = scsi_prep_state_check(sdev, req);
> > +	if (ret != BLKPREP_OK)
> > +		goto out;
> > +
> > +	cmd = scsi_get_cmd_from_req(sdev, req);
> > +	if (unlikely(!cmd)) {
> > +		ret = BLKPREP_DEFER;
> > +		goto out;
> > +	}
> > +


>From here the req->special pointer may or may not be set depending on mq
operation, no..?

a) there is no blk-mq support yet in James tree (+ these patches)
b) even in my scsi-mq tree this code path won't be called for the mq case
c) after scsi_get_cmd_from_req returns req->special will always be set up
   to point to the scsi_cmnd:

static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
		struct request *req)
{
	struct scsi_cmnd *cmd;

	if (!req->special) {
		...

		req->special = cmd;
	} else {
		cmd = req->special;
	}

        /* pull a tag out of the request if we have one */
	cmd->tag = req->tag;
	cmd->request = req;

	cmd->cmnd = req->cmd;   
	cmd->prot_op = SCSI_PROT_NORMAL;

	return cmd;
}

> >  	}
> >  	ret = scsi_setup_fs_cmnd(sdp, rq);
> >  	if (ret != BLKPREP_OK)
> 
> And this currently assumes req->special is always set when calling
> scsi_setup_fs_cmnd()

That is the case both before and after this patch.

