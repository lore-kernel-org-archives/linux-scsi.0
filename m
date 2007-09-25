From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Some plans for scsi_cmnd
Date: Tue, 25 Sep 2007 16:51:06 +0200
Message-ID: <46F9205A.8060003@panasas.com>
References: <20070925133733.GT10625@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19559 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755152AbXIYOvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 10:51:09 -0400
In-Reply-To: <20070925133733.GT10625@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 25 2007 at 15:37 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> Christoph grabbed me on IRC and we debated some of my plans for scsi_cmnd;
> with his permission I'm summarising the result of that debate for posterity.
> There's four main things discussed:
> 
> 1. I'm going to be writing and posting patches over the next week or so
> to kill all the (ab)uses of ->scsi_done in drivers.  Once that is done,
> I'll post a patch that exports the midlayer's scsi_done and switch all
> the drivers to calling that.  After that, I'll post another patch that
> changes the prototype *and the semantics* of queuecommand; the midlayer
> will no longer take the host_lock for the driver.  I'll just push the
> acquisition down into queuecommand, and it'll be up to individual driver
> authors to do something sensible with it then.
> 
> 2. Thanks to a thinko, we also discussed the upper-layer ->done.  We think
> it should be feasible to move this from the scsi_cmnd to the scsi_device
> since sg doesn't use it.
> 
> 3. We also discussed scsi_pointer.  It's really quite crufty, and it
> gets recycled for storing all kinds of things.  The ambitious plan here
> is to change the whole way scsi_cmnds are allocated.  Code is clearer
> than my description ...
> 
> sym2.c:
> 
> struct sym2_cmnd {
> 	struct scsi_cmnd cmd;
> 	int Phase;
> 	char *data_in;
> }
> 
> struct scsi_host_template sym2_template {
> 	.cmnd_size = sizeof(sym2_cmnd);
> }
> 
> int sym2_queuecommand(struct scsi_cmnd *scp)
> {
> 	struct sym2_cmnd *cmnd = container_of(scp, sym2_cmnd, cmd);
> }
> 
> The midlayer will create a slab pool per host template for allocating
> scsi_cmnd.
> 
I have in my Q a small variation on this principle where I wanted
to allocate bigger commands for bidi-able hosts like iscsi_tcp. So
not to pay the extra allocation per command. Above will do just fine.

> As I said, it's ambitious.  But it'll let us get rid of scsi_pointer
> and host_scribble entirely.
> 
This all is an excellent idea and you will find that in the patchset to
gdth, I have made the work of one driver a bit easier for you.

I suggest gradual work, where both Scp and host_scribble are intact
but the .cmnd_size and mechanics are available with few major drivers
moved to that. Than one kernel after that deprecating both, while 
converting lots of drivers, and 1-2 kernels after that remove them when
all drivers are converted. Don't sit on a large patchset with lots of
drivers and submit them all at once.

> 4. We don't understand why sense_buffer is 96 bytes long.  mkp says that
> devices are coming which need more than 96 bytes (the standard allows up
> to 252).  I propose splitting the 96-byte buffer like so:
> 
> -#define SCSI_SENSE_BUFFERSIZE  96
> -       unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
> +       unsigned char sense_buffer_head[8];
> +       unsigned char *sense_buffer_desc;
> 
> and then adding:
> 
> +int scsi_set_sense_buffer(struct scsi_cmnd *cmd, unsigned char *sense,
> +                                                               int sense_len)
> +{
> +       int len = min(sense[7], sense_len - 8);
> +       memcpy(cmd->sense_buffer_head, sense, min(8, sense_len));
> +       if (len <= 0)
> +               return 0;
> +       cmd->sense_buffer_desc = kmalloc(len, GFP_ATOMIC);
> +       if (!cmd->sense_buffer_desc)
> +               return 1;
> +       memcpy(cmd->sense_buffer_desc, sense + 8, len);
> +       return 0;
> +}
> +EXPORT_SYMBOL(scsi_set_sense_buffer);
> 
> Drivers then do something like:
> 
> -                       memset(&cmd->sense_buffer, 0, sizeof(cmd->sense_buffer))
> -                       memcpy(cmd->sense_buffer, cp->sns_bbuf,
> -                             min(sizeof(cmd->sense_buffer),
> -                                 (size_t)SYM_SNS_BBUF_LEN));
> +                       scsi_set_sense_buffer(cmd, cp->sns_bbuf,
> +                                                       SYM_SNS_BBUF_LEN);
> 
> or even ...
> 
> -               /* Copy Sense Data into sense buffer. */
> -               memset(cp->sense_buffer, 0, sizeof(cp->sense_buffer));
> -
>                 if (!(scsi_status & SS_SENSE_LEN_VALID))
>                         break;
>  
> -               if (sense_len >= sizeof(cp->sense_buffer))
> -                       sense_len = sizeof(cp->sense_buffer);
> -
> -               CMD_ACTUAL_SNSLEN(cp) = sense_len;
> -               sp->request_sense_length = sense_len;
> -               sp->request_sense_ptr = cp->sense_buffer;
> -
> -               if (sp->request_sense_length > 32)
> -                       sense_len = 32;
> -
> -               memcpy(cp->sense_buffer, sense_data, sense_len);
> -
> -               sp->request_sense_ptr += sense_len;
> -               sp->request_sense_length -= sense_len;
> -               if (sp->request_sense_length != 0)
> -                       ha->status_srb = sp;
> +               scsi_set_sense_buffer(cp, sense_data, sense_len);
> 
Please review my patches to scsi_error and the REQUEST_SENSE paths
(James are they not going to be accepted into 2.6.24-rcx?)
I have introduced an abstract way to convert a command to point to
it's sense buffer, So drivers can now transfer data to the sense buffer
the way they do to regular IO, throw an sg_list.

Also if you are converting to pointers than please do not do the above.
struct request already has a sense pointer and length. Directly use
these. The transient first 8 bytes are not necessary, and just complicate
the code. The all sense allocation can be settled with part 3 of your mail 
above. we can widen it to be:
struct scsi_host_template sym2_template {
	.cmnd_size = sizeof(sym2_cmnd);
	.sense_size = SYM_SNS_BBUF_LEN;
	.bidi_cmnd = 1;
}
By default .sense_size will be 96 allocated from cmnd-pool and pointed
to by the struct request pointers.
Drivers that want privately allocated space can put 0 in .sense_size 
and use Christoph's alloc/destroy_cmnd to set up their own. 
Drivers should access all these members throw accessors So to be abstracted 
from all that.

> If any of this seems unwelcome, please say so.  It's going to be a lot of
> churn (and part 4 may well take six months or more), so I'd like people
> to voice objections now rather than later.
> 

RFC patches early and set up a git tree, if possible. I will help in any way 
I can also with drivers.

Boaz
