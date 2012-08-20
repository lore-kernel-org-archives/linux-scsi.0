From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: request size limit in scsi tape driver
Date: Mon, 20 Aug 2012 21:44:21 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1208202133500.5250@kai.makisara.local>
References: <20120820155032.GA14300@aepfle.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:54262 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2HTSoa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 14:44:30 -0400
In-Reply-To: <20120820155032.GA14300@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 20 Aug 2012, Olaf Hering wrote:

> 
> Currently the st driver does not to break up write requests into smaller
> chunks to satisfy the ->max_hw_sectors limit of the underlying host driver.
> 
>  # modprobe -v scsi_debug ptype=1 opts=1 dev_size_mb=123
>  # dd if=/dev/zero of=/dev/st0 bs=$((1024*54321))
> 
> This leads to -EBUSY from this call chain:
> st_write -> st_do_scsi -> st_scsi_execute -> blk_rq_map_user
> 
> What is the reason for this behaviour?
> Should st_write write in smaller chunks, or would that break real
> hardware because they expect certain block sizes?
> 
In variable block mode the write() byte count determines the size of the 
tape block. Exactly one SCSI command is used to write one block. This is 
why the writes can't be split in variable block mode. In fixed block mode 
the writes are split but this results in several tape blocks for each 
write().

Kai
