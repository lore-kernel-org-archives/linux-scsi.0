From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 15:23:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210252223.g9PMN9a17551@eng2.beaverton.ibm.com>
References: <200210251834.g9PIY2l03794@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210251834.g9PIY2l03794@localhost.localdomain> from "James Bottomley" at Oct 25, 2002 12:34:02 PM PST
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

I Just tried the patch. No Luck. I get same panic as before...
I am using qla2x00src-v6.03.00b6 driver on qla2200 fc controllers.

- Badari

elm3b81 login: Oops: 0002
qla2200  
CPU:    3
EIP:    0060:[<f89d0cd7>]    Not tainted
EFLAGS: 00010002
EIP is at qla2x00_process_completed_request+0x67/0x150 [qla2200]
eax: 00000000   ebx: f65f02dc   ecx: 00000000   edx: 00000000
esi: f6b9017c   edi: 00000000   ebp: d89bfda3   esp: d89bfd24
ds: 0068   es: 0068   ss: 0068
Process dd (pid: 1512, threadinfo=d89be000 task=d5039760)
Stack: f6b9017c 0000711a 00007100 f89d0efb f6b9017c 00000287 00008020 00000000 
       00008020 00007100 02870000 00000000 00000000 c0134768 f642b110 0000d6a1 
       0000000c c014ed4c f642b10c 00000000 00000008 f7f78a1c f6b9017c f6b9017c 
Call Trace:
 [<f89d0efb>] qla2x00_isr+0x13b/0x610 [qla2200]
 [<c0134768>] find_get_page+0x38/0x50
 [<c014ed4c>] __find_get_block_slow+0x2c/0x110
 [<f89cc17b>] qla2x00_intr_handler+0x9b/0x250 [qla2200]
 [<c010950a>] handle_IRQ_event+0x3a/0x60
 [<c0109812>] do_IRQ+0x112/0x1f0
 [<c0107f38>] common_interrupt+0x18/0x20
 [<c020926c>] __copy_from_user+0x4c/0x70
 [<c0136473>] generic_file_write_nolock+0x743/0xa00
 [<c0130071>] pte_alloc_map+0x121/0x130
 [<c0131103>] zeromap_page_range+0xe3/0x180
 [<c01367a5>] generic_file_write+0x55/0x70
 [<c014cf8f>] vfs_write+0xbf/0x160
 [<c01170ea>] do_schedule+0x38a/0x480
 [<c014d09a>] sys_write+0x2a/0x40
 [<c01075f3>] syscall_call+0x7/0xb

Code: 89 b8 24 01 00 00 8b 43 10 89 88 38 01 00 00 8b 43 10 89 90 
 <0>Kernel panic: Aiee, killing interrupt handler!
In interrupt handler - not syncing

> 
> This is a multipart MIME message.
> 
> --==_Exmh_11899173800
> Content-Type: text/plain; charset=us-ascii
> 
> 
> James.Bottomley@steeleye.com said:
> > This has all the hallmarks of the Qlogic double done bug:  Under
> > certain high  stress/bad bus situations, the Qla driver will call done
> > twice on a SCSI  command structure.  I take it this is the 6.1.0 qla
> > driver, which qlogic has  assured me "really really" has this bug
> > fixed?
> 
> > Is there any way to switch adapters to see if we can confirm this
> > hypothesis? 
> 
> Actually, rather than switching adapters, could you try the attached patch.  
> As long as the command isn't reused too fast after the scsi_done, it should 
> pick up this problem.
> 
> James
> 
> 
> 
> 
> 
> --==_Exmh_11899173800
> Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
> Content-Description: tmp.diff
> Content-Disposition: attachment; filename="tmp.diff"
> 
> ===== drivers/scsi/scsi.c 1.50 vs edited =====
> --- 1.50/drivers/scsi/scsi.c	Tue Oct 22 12:43:29 2002
> +++ edited/drivers/scsi/scsi.c	Fri Oct 25 13:23:32 2002
> @@ -1224,6 +1224,12 @@
>  	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_do_cmd()\n"));
>  }
>  
> +static void scsi_null_done_method(Scsi_Cmnd *SCp)
> +{
> +	printk(KERN_EMERG "Done called on already done command\n");
> +        dump_stack();
> +}
> +
>  /**
>   * scsi_done - Mark this command as done
>   * @SCpnt: The SCSI Command which we think we've completed.
> @@ -1247,6 +1253,10 @@
>  	unsigned long flags;
>  	int cpu, tstatus;
>  	struct softscsi_data *queue;
> +
> +        /* clear out the done method to produce an error for done on the
> +         * same command */
> +        SCpnt->scsi_done = scsi_null_done_method;
>  
>  	/*
>  	 * We don't have to worry about this one timing out any more.
> 
> --==_Exmh_11899173800--
> 
> 
> 


-- 
Badari Pulavarty
pbadari@us.ibm.com
IBM Linux Technology Center - Kernel Team
