From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Sun, 23 Oct 2005 21:53:06 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0510232120440.14349@kai.makisara.local>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023070011.GA26569@havoc.gtf.org>
 <435B6A62.8070306@torque.net> <435BBD9A.80603@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:47299 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751022AbVJWSxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 14:53:09 -0400
In-Reply-To: <435BBD9A.80603@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Sun, 23 Oct 2005, Jeff Garzik wrote:

> Douglas Gilbert wrote:
> > Which in turn makes me think of applying the same idea
> > to max_sectors
> > 
> > shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;
> 
> 
> Won't work.  max_sectors is communicated to the block layer, where we limit
> the overall size of the request for practical reasons.
> 
> Read the comment in libata-scsi's slave_configure:
> 
> /* TODO: 1024 is an arbitrary number, not the
> * hardware maximum.  This should be increased to
> * 65534 when Jens Axboe's patch for dynamically
> * determining max_sectors is merged.
> */
> 
> Right now, setting the true hardware / command set maximum would use way too
> much memory, with no way to get feedback from the VM.
> 
> This is why SCSI_DEFAULT_MAX_SECTORS is defined to 1024.
> 
So, the block layer is just for devices using the page cache, after all!

If max_sectors is a VM thing, why is it set by _device drivers_?

Now, let me try to more be constructive. max_sectors is enforced in 
__bio_add_page(). Maybe this is not the correct place. Bios are advocated 
as general i/o concepts and they don't have any direct relation with VM.

-- 
Kai
