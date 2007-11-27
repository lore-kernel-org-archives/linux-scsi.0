From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/2] ide-scsi: use print_hex_dump from <linux/kernel.h>
Date: Tue, 27 Nov 2007 21:34:18 +0100
Message-ID: <200711272134.18527.bzolnier@gmail.com>
References: <1196061373-6394-1-git-send-email-crquan@gmail.com> <20071127013119.d12b7791.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071127013119.d12b7791.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Cheng <crquan@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 27 November 2007, Andrew Morton wrote:
> On Mon, 26 Nov 2007 15:16:13 +0800 Denis Cheng <crquan@gmail.com> wrote:
> 
> > these utilities implemented in lib/hexdump.c are more handy, please use this.
> > 
> > ...
> >
> > --- a/drivers/scsi/ide-scsi.c
> > +++ b/drivers/scsi/ide-scsi.c
> > @@ -242,16 +242,6 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
> >  	}
> >  }
> >  
> > -static void hexdump(u8 *x, int len)
> > -{
> > -	int i;
> > -
> > -	printk("[ ");
> > -	for (i = 0; i < len; i++)
> > -		printk("%x ", x[i]);
> > -	printk("]\n");
> > -}
> > -
> >  static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
> >  {
> >  	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
> > @@ -282,7 +272,7 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
> >  	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
> >  	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
> >  		printk ("ide-scsi: %s: queue cmd = ", drive->name);
> > -		hexdump(pc->c, 6);
> > +		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->c, 6, 1);
> >  	}
> >  	rq->rq_disk = scsi->disk;
> >  	return ide_do_drive_cmd(drive, rq, ide_preempt);
> > @@ -337,7 +327,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
> >  		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
> >  		if (log) {
> >  			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, 
opc->scsi_cmd->serial_number);
> > -			hexdump(pc->buffer,16);
> > +			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->buffer, 16, 1);
> >  		}
> >  		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
> >  		kfree(pc->buffer);
> > @@ -816,10 +806,10 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
> >  
> >  	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
> >  		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
> > -		hexdump(cmd->cmnd, cmd->cmd_len);
> > +		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, cmd->cmnd, cmd->cmd_len, 1);
> >  		if (memcmp(pc->c, cmd->cmnd, cmd->cmd_len)) {
> >  			printk ("ide-scsi: %s: que %lu, tsl = ", drive->name, cmd->serial_number);
> > -			hexdump(pc->c, 12);
> > +			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->c, 12, 1);
> >  		}
> >  	}
> >  

I applied the patch with a couple of fixes:
- s/KERN_DEBUG/KERN_CONT/ as pointed out by Randy
- s/DUMP_PREFIX_OFFSET/DUMP_PREFIX_NONE/
- don't include ASCII dump
- respect 80-columns limit

> Would you believe that this patch (which removes code) actually increases
> drivers/scsi/ide-scsi.o .text by 75 bytes?

Yeah, it somehow shrank down to +58 bytes after fixes but this is still bad.

> I didn't look to see why - probably that huge arg count is hurting,
> possibly some additional strings being emitted?

Probably.

> Either way, perhaps a simple little front-end to print_hex_dump() is called
> for.

Alternatively: it seems that we can easily replace 'prefix_type', 'rowsize',
'groupsize' and 'ascii' args by a single 'flags' arg.

Thanks,
Bart
