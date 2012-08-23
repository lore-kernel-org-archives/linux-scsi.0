From: Olaf Hering <olaf@aepfle.de>
Subject: Re: request size limit in scsi tape driver
Date: Thu, 23 Aug 2012 15:10:22 +0200
Message-ID: <20120823131022.GA17206@aepfle.de>
References: <20120820155032.GA14300@aepfle.de>
 <alpine.LNX.2.00.1208202133500.5250@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:56192 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2HWNK0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Aug 2012 09:10:26 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1208202133500.5250@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 20, Kai Makisara wrote:

> On Mon, 20 Aug 2012, Olaf Hering wrote:
> 
> > 
> > Currently the st driver does not to break up write requests into smaller
> > chunks to satisfy the ->max_hw_sectors limit of the underlying host driver.
> > 
> >  # modprobe -v scsi_debug ptype=1 opts=1 dev_size_mb=123
> >  # dd if=/dev/zero of=/dev/st0 bs=$((1024*54321))
> > 
> > This leads to -EBUSY from this call chain:
> > st_write -> st_do_scsi -> st_scsi_execute -> blk_rq_map_user
> > 
> > What is the reason for this behaviour?
> > Should st_write write in smaller chunks, or would that break real
> > hardware because they expect certain block sizes?
> > 
> In variable block mode the write() byte count determines the size of the 
> tape block. Exactly one SCSI command is used to write one block. This is 
> why the writes can't be split in variable block mode. In fixed block mode 
> the writes are split but this results in several tape blocks for each 
> write().

Thats very unfortunate.
Would it be possible in theory to split and reassemble the SCSI commands
in backend/frontend to overcome this protocol limit in pvscsi?

Olaf
