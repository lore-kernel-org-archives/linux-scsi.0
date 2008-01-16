From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] use dynamically allocated sense buffer
Date: Wed, 16 Jan 2008 10:18:02 +0900
Message-ID: <20080116101802T.fujita.tomonori@lab.ntt.co.jp>
References: <478CBBA8.4050202@panasas.com>
	<20080116000836Y.tomof@acm.org>
	<478CD4CE.1000703@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:34335 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbYAPBSy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 20:18:54 -0500
In-Reply-To: <478CD4CE.1000703@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, 15 Jan 2008 17:44:14 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > If __scsi_put_command puts a command to shost->free_list, it doesn't
> > free scmd->sense_buffer since it's the sense_buffer for the backup
> > sense_buffer. If __scsi_put_command puts a command to
> > shost->cmd_pool->slab (if shost->free_list isn't empty), it alos puts
> > its sense_buffer to sense_buffer_slab.
> 
> Yes, but these are not necessarily the same commands. Think of this,

Ah, sorry, I need to update shost->backup_sense_buffer when
__scsi_put_command puts a command to the free_list.


> The run queues have commands in them, a request comes that demands
> a cmnd, out-of-memory condition causes the spare from free_list cmnd to
> be issued, and is put at tail of some run queue. Now comes the first
> done cmnd, it is immediately put to free_list, but it's sense_buffer
> was from sense_buffer_slab.
> 
> I think the solution is simple just immediately allocate the sense_buffer
> in scsi_setup_command_freelist() and put it on that first free_list command.
> Then make sure that also the sense_buffer is freed in 
> scsi_destroy_command_freelist().
> 
> This way sense_buffer is always allocated/freed together with cmnd and
> you don't need the shost->backup_sense_buffer pointer.

Yeah, it's more straightforward. I'll submit an update patch soon.

Thanks,
