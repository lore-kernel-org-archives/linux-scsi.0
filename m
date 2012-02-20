From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] sd: Implement support for WRITE SAME
Date: Mon, 20 Feb 2012 11:16:45 -0500
Message-ID: <20120220161645.GA29207@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2BTQQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 11:16:51 -0500
Content-Disposition: inline
In-Reply-To: <1327969892-5090-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

On Mon, Jan 30 2012 at  7:31pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Implement support for WRITE SAME(10) and WRITE SAME(16) in the SCSI disk
> driver.

...

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c691fb5..40946a2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c

...

> +/**
> + * sd_setup_write_same_cmnd - write the same data to multiple blocks
> + * @sdp: scsi device to operate one
> + * @rq: Request to prepare
> + *
> + * Will issue either WRITE SAME(10) or WRITE SAME(16) depending on
> + * preference indicated by target device.
> + **/
> +static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)

Just a small nit, this should be scsi_setup_write_same_cmnd given we
already have: scsi_setup_{discard,flush}_cmnd
