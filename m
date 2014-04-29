From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
 messages when blk_execute_rq fails.  Also add printing of sense info.
Date: Tue, 29 Apr 2014 11:30:35 +0200
Message-ID: <20140429093035.GA2219@dhcp-27-189.brq.redhat.com>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
 <20140425131219.GA20644@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbaD2KUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2014 06:20:51 -0400
Content-Disposition: inline
In-Reply-To: <20140425131219.GA20644@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com

Hi Christoph,

On Fri, Apr 25, 2014 at 03:12:19PM +0200, Christoph Hellwig wrote:
> 
> Looks useful, but why do we have basically two copies of the same
> code for different commands? Looking at them in detail they mostly look
> like copies of scsi_execute/scsi_execute_req_flags and should be switched
> to that.

I've tried to write a patch but unfortunately there are some problems with that.
For example, look at the submit_rtpg() function:

If the blk_execute_rq() function returns an error, the h->sense buffer
is updated.

        rq->sense = h->sense;  <---------
        memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
        rq->sense_len = h->senselen = 0;

        err = blk_execute_rq(rq->q, NULL, rq, 1);
        if (err == -EIO) {
                sdev_printk(KERN_INFO, sdev,
                            "%s: rtpg failed with %x\n",
                            ALUA_DH_NAME, rq->errors);
                h->senselen = rq->sense_len;  <--------
                err = SCSI_DH_IO;
        }

If I convert submit_rtpg() to make use of scsi_execute() then I'll not be
able to read the updated sense buffer.

scsi_execute() accepts a pointer to the sense buffer as parameter, but
it does not update its content in case blk_execute_rq() returns an error.

Maurizio Lombardi
