From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request
        queue pointer to blk_rq_init()
Date: Mon, 22 May 2017 15:00:40 +0200
Message-ID: <20170522130040.GA12773@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-7-bart.vanassche@sandisk.com> <20170521065003.GE12891@lst.de> <1495384897.3192.3.camel@sandisk.com> <1a2b631a-8b12-f167-b3b8-3a74bd179daa@suse.com> <20170522075443.GC2081@lst.de> <78097a2b-73c6-3206-803a-c108fe464c45@suse.com> <20170522124809.GB11869@lst.de> <95b0aba4-9463-eb8e-5c27-4a6951c3112a@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48026 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933572AbdEVNAl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 09:00:41 -0400
Content-Disposition: inline
In-Reply-To: <95b0aba4-9463-eb8e-5c27-4a6951c3112a@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Mon, May 22, 2017 at 02:56:18PM +0200, Hannes Reinecke wrote:
> > No, we don't.  The driver simply sets a tag aside and doesn't expose
> > it to the block layer.  Similar to what smartpqi already does for LUN
> > resets and AENs, mpt3sas does for the ioctl tags and NVMe does for AERs.
> > Personally I feel a bit uncomfortable by setting aside just one tag for
> TMFs; this assumes we'll never be sending LUN resets to devices in parallel.
> 
> But maybe this is a discussion for another time, if and when we finally
> move to that.

For midlayer initiated EH that's the case - they are serialized by
being issued from the eh thread.  For the ioctl we have the
scsi_block_when_processing_errors / scsi_host_in_recovery magic,
although that hand crafted primitive is a bit of a mess, we'd
be much better off with a real EH mutex.
