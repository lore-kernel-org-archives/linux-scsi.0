From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH] virtio_scsi: Reject commands when virtqueue is broken
Date: Thu, 12 Jan 2017 21:45:55 +0800
Message-ID: <20170112134555.GF26504@lemon>
References: <1484172122-18882-1-git-send-email-farman@linux.vnet.ibm.com>
 <1484172122-18882-2-git-send-email-farman@linux.vnet.ibm.com>
 <20170112031159.GD26504@lemon>
 <aa461af2-6fc2-9ece-3b8f-9b6e07268c2f@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751010AbdALNp7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 08:45:59 -0500
Content-Disposition: inline
In-Reply-To: <aa461af2-6fc2-9ece-3b8f-9b6e07268c2f@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Farman <farman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

On Thu, 01/12 08:28, Eric Farman wrote:
> > > -	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd)) != 0)
> > > +	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
> > > +	if (ret == -EIO) {
> > > +		cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
> > > +		virtscsi_complete_cmd(vscsi, cmd);
> > 
> > Is this safe? Calling virtscsi_complete_cmd requires vq_lock but we don't seem
> > to have it here.
> 
> Hrm...  Didn't notice that, and can't speak to its safety.  I had a bit of
> an I/O workload going to other disks, and things seemed okay, but it was by
> no means an exhaustive test.
> 
> I can't use virtscsi_vq_done, which normally handles that acquire/release.
> It calls virtqueue_get_buf prior to calling virtscsi_complete_cmd, which
> returns NULL because the virtqueue is broken.    Thus, no call to
> virtscsi_complete_cmd.
> 
> Can I mock up a wrapping routine that only handles the lock and complete_cmd
> call, and ignore the virtqueue components that virtscsi_vq_done does?

That sounds good to me, taking the vq_lock here around the call to
virtscsi_complete_cmd, just like virtscsi_kick_cmd().

Fam

> 
> Eric
> 
> > 
> > Fam
> > 
> > > +	} else if (ret != 0) {
> > >  		return SCSI_MLQUEUE_HOST_BUSY;
> > > +	}
> > >  	return 0;
> > >  }
> > 
> 
