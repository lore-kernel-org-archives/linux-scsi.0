From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] tcm/pscsi: Add proper BIDI-COMMAND passthrough to
	SCSI MidLayer
Date: Wed, 22 Sep 2010 05:21:22 -0700
Message-ID: <1285158082.1849.72.camel@haakon2.linux-iscsi.org>
References: <1285135732-8350-1-git-send-email-nab@linux-iscsi.org>
	 <4C99E4BC.5010301@panasas.com>
	 <1285155525.1849.55.camel@haakon2.linux-iscsi.org>
	 <4C99F1B7.4000806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C99F1B7.4000806@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-22 at 14:08 +0200, Boaz Harrosh wrote:
> On 09/22/2010 01:38 PM, Nicholas A. Bellinger wrote:
> > On Wed, 2010-09-22 at 13:13 +0200, Boaz Harrosh wrote:
> >>
> >> OK, I'm begining to suspect task->task_size is the size of what?
> >> See below (below)
> > 
> > Btw task->task_size is to set to (task->task_sectors * block_size) in
> > target_core_transport.c:transport_generic_get_cdb_count()
> > 
> 
> Maybe you are confused by these XOR functions. But there is no
> task->task_sectors, only for these TYPE_DISK pesky writes/reads
> 
> For general SCSI from tapes, scanners, printers to OSD There is
> in_transfer_length and out_transfer_length. For READ_XXX/WRITE_XXX
> these happen to be task->task_sectors.
> 

OK, in the current code we do the conversion for TYPE_DISK and non
TYPE_DISK backstores w/ TCM/pSCSI in transport_set_tasks_sectors_disk()
and transport_set_tasks_sectors_non_disk().

I am pretty sure we do handle this correctly now, but I have not been
able to test with non TYPE_DISK backstores just yet..

> <snip>
> 
> >>>  	return task->task_sg_num;
> >>
> >> OK Now I'm sure!
> >> You have completely missed the fact that bidi entails two sg_list(s)
> >> two sg_num(s) and two io_byte_count(s).
> >>
> >> The use of sg_table will clear that confusion a bit, though I wanted it
> >> to carry an  io_byte_count as well, but never came to do that.
> > 
> > Hmmm, so this patch currently assumes that BIDI-COMMAND WRITE and extra
> > READ payloads contain the same struct se_task->task_sg_num for both
> > struct se_task->task_sg[] and struct se_task->task_sg_bidi[].
> > 
> > If we need to assume that the internally allocated (LIO-Target iSCSI)
> 
> There is no assumption they are completely separate (Even if they happen
> to be the equal).
> 
> The fabric(s) know that. For pSCSI this comes in the scsi_in()->length
> and the scsi_out()->length (and ->sg_count). For iscsi it has an rlenght
> AHS header that tells it the transfer length of the bidi_read side.
> In iSER and I think FB it is completely symmetrical like with the BSG
> API. (Member for "in" and member for "out")
> 
> And so on. Each side is completely orthogonal to the other, in every
> respect. (They might even execute in parallel)

Hmmm, point taken.  I will address this item later today.

> 
> > *or* pre-exiting SGL mapped T_TASK(cmd)->t_mem_list (TCM_Loop Virtual
> > SCSI LLD) and T_TASK(cmd)->t_mem_bidi_list memory can be mapped
> > differently, then an seperate second call to transport_calc_sg_num() in
> > order to determine a struct se_task->task_sg_bidi_num is required.
> > 
> 
> Perhaps it would be easier to do, if you convert to use of scsi_data_buffer
> in current code. Then apply the double instance. You might also need a similar
> mechanics for your ->t_mem_list and associated members. Group them together
> then double the handling.
> 
> Down the road you'll need a third one for supporting DIFF
> 

Hmmm, another good point for scsi_dat_buffer conversion here.

Best,

--nab
