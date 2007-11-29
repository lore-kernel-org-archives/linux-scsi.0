From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: 2.6.24-rc3-mm2: Result: hostbyte=0x01 driverbyte=0x00\nend_request:
 I/O error
Date: Thu, 29 Nov 2007 11:33:23 +0200
Message-ID: <474E8763.1020908@panasas.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>	<20071128200130.GA13361@martell.zuzino.mipt.ru>	<20071128134036.417b3def.akpm@linux-foundation.org>	<20071128231421.GB2584@parisc-linux.org> <20071128153636.2ac3ef9f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14686 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756508AbXK2Jdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Nov 2007 04:33:40 -0500
In-Reply-To: <20071128153636.2ac3ef9f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, adobriyan@gmail.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Nov 29 2007 at 1:36 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 28 Nov 2007 16:14:21 -0700
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
>> On Wed, Nov 28, 2007 at 01:40:36PM -0800, Andrew Morton wrote:
>>> On Wed, 28 Nov 2007 23:01:31 +0300
>>> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>>
>>>> Reliably spams dmesg with end_request() horrors. This happens when git
>>>> starts checking out linux tree to fresh ext2 partition. Disk is several
>>>> month old and there were no prolems with, say, 2.6.24-rc3:
>> Could you try reverting 6f5391c283d7fdcf24bf40786ea79061919d1e1d and see
>> if the problem still exists?
>>
> 
> That's not completely trivial..
> 
> I did a hand-made revert against 2.6.24-rc3-mm2 (below) but some other patch
> in there causes:
> 
> drivers/scsi/scsi_lib.c: In function 'scsi_blk_pc_done':
> drivers/scsi/scsi_lib.c:1251: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> 
That would be the bidi patches. You need to use scsi_bufflen(cmd) instead of
cmd->request_bufflen. (See below)
Do you need that I send a patch?

> 
> --- a/drivers/scsi/scsi.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/drivers/scsi/scsi.c
> @@ -59,7 +59,6 @@
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_dbg.h>
>  #include <scsi/scsi_device.h>
> -#include <scsi/scsi_driver.h>
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
> @@ -379,8 +378,9 @@ void scsi_log_send(struct scsi_cmnd *cmd
>  			scsi_print_command(cmd);
>  			if (level > 3) {
>  				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
> -				       " queuecommand 0x%p\n",
> +				       " done = 0x%p, queuecommand 0x%p\n",
>  					scsi_sglist(cmd), scsi_bufflen(cmd),
> +					cmd->done,
>  					cmd->device->host->hostt->queuecommand);
>  
>  			}
> @@ -667,12 +667,6 @@ void __scsi_done(struct scsi_cmnd *cmd)
>  	blk_complete_request(rq);
>  }
>  
> -/* Move this to a header if it becomes more generally useful */
> -static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
> -{
> -	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
> -}
> -
>  /**
>   * scsi_finish_command - cleanup and pass command back to upper layer
>   * @cmd: the command
> @@ -685,8 +679,6 @@ void scsi_finish_command(struct scsi_cmn
>  {
>  	struct scsi_device *sdev = cmd->device;
>  	struct Scsi_Host *shost = sdev->host;
> -	struct scsi_driver *drv;
> -	unsigned int good_bytes;
>  
>  	scsi_device_unbusy(sdev);
>  
> @@ -712,13 +704,7 @@ void scsi_finish_command(struct scsi_cmn
>  				"Notifying upper driver of completion "
>  				"(result %x)\n", cmd->result));
>  
> -	good_bytes = scsi_bufflen(cmd);
> -        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
> -		drv = scsi_cmd_to_driver(cmd);
> -		if (drv->done)
> -			good_bytes = drv->done(cmd);
> -	}
> -	scsi_io_completion(cmd, good_bytes);
> +	cmd->done(cmd);
>  }
>  EXPORT_SYMBOL(scsi_finish_command);
>  
> diff -puN drivers/scsi/scsi_error.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/scsi_error.c
> --- a/drivers/scsi/scsi_error.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/drivers/scsi/scsi_error.c
> @@ -1697,6 +1697,7 @@ scsi_reset_provider(struct scsi_device *
>      
>  	scmd->scsi_done		= scsi_reset_provider_done_command;
>  	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
> +	scmd->done			= NULL;
>  
>  	scmd->cmd_len			= 0;
>  
> diff -puN drivers/scsi/scsi_lib.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/drivers/scsi/scsi_lib.c
> @@ -944,6 +944,7 @@ void scsi_end_bidi_request(struct scsi_c
>  
>  	scsi_finalize_request(cmd, 1);
>  }
> +EXPORT_SYMBOL(scsi_io_completion);
>  
>  /*
>   * Function:    scsi_io_completion()
> @@ -1238,6 +1239,18 @@ static struct scsi_cmnd *scsi_get_cmd_fr
>  	return cmd;
>  }
>  
> +static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
> +{
> +	BUG_ON(!blk_pc_request(cmd->request));
> +	/*
> +	 * This will complete the whole command with uptodate=1 so
> +	 * as far as the block layer is concerned the command completed
> +	 * successfully. Since this is a REQ_BLOCK_PC command the
> +	 * caller should check the request's errors value
> +	 */
> +	scsi_io_completion(cmd, cmd->request_bufflen);
+	scsi_io_completion(cmd, scsi_bufflen(cmd));

> +}
> +
>  int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>  {
>  	struct scsi_cmnd *cmd;
> @@ -1285,6 +1298,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
>  	cmd->transfersize = req->data_len;
>  	cmd->allowed = req->retries;
>  	cmd->timeout_per_command = req->timeout;
> +	cmd->done = scsi_blk_pc_done;
>  	return BLKPREP_OK;
>  }
>  EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
> diff -puN drivers/scsi/scsi_priv.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/scsi_priv.h
> --- a/drivers/scsi/scsi_priv.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/drivers/scsi/scsi_priv.h
> @@ -68,7 +68,6 @@ extern int scsi_maybe_unblock_host(struc
>  extern void scsi_device_unbusy(struct scsi_device *sdev);
>  extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
>  extern void scsi_next_command(struct scsi_cmnd *cmd);
> -extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
>  extern void scsi_run_host_queues(struct Scsi_Host *shost);
>  extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
>  extern void scsi_free_queue(struct request_queue *q);
> diff -puN drivers/scsi/sd.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/drivers/scsi/sd.c
> @@ -86,19 +86,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
>  MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
>  MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
>  
> -static int  sd_revalidate_disk(struct gendisk *);
> -static int  sd_probe(struct device *);
> -static int  sd_remove(struct device *);
> -static void sd_shutdown(struct device *);
> -static int sd_suspend(struct device *, pm_message_t state);
> -static int sd_resume(struct device *);
> -static void sd_rescan(struct device *);
> -static int sd_done(struct scsi_cmnd *);
> -static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
> -static void scsi_disk_release(struct class_device *cdev);
> -static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
> -static void sd_print_result(struct scsi_disk *, int);
> -
>  static DEFINE_IDR(sd_index_idr);
>  static DEFINE_SPINLOCK(sd_index_lock);
>  
> @@ -253,7 +240,6 @@ static struct scsi_driver sd_template = 
>  		.shutdown	= sd_shutdown,
>  	},
>  	.rescan			= sd_rescan,
> -	.done			= sd_done,
>  };
>  
>  /*
> @@ -520,6 +506,12 @@ static int sd_prep_fn(struct request_que
>  	SCpnt->timeout_per_command = timeout;
>  
>  	/*
> +	 * This is the completion routine we use.  This is matched in terms
> +	 * of capability to this function.
> +	 */
> +	SCpnt->done = sd_rw_intr;
> +
> +	/*
>  	 * This indicates that the command is ready from our end to be
>  	 * queued.
>  	 */
> @@ -898,13 +890,13 @@ static struct block_device_operations sd
>  };
>  
>  /**
> - *	sd_done - bottom half handler: called when the lower level
> + *	sd_rw_intr - bottom half handler: called when the lower level
>   *	driver has completed (successfully or otherwise) a scsi command.
>   *	@SCpnt: mid-level's per command structure.
>   *
>   *	Note: potentially run from within an ISR. Must not block.
>   **/
> -static int sd_done(struct scsi_cmnd *SCpnt)
> +static void sd_rw_intr(struct scsi_cmnd * SCpnt)
>  {
>  	int result = SCpnt->result;
>  	unsigned int xfer_size = scsi_bufflen(SCpnt);
> @@ -925,7 +917,7 @@ static int sd_done(struct scsi_cmnd *SCp
>  	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
>  	if (sense_valid) {
>  		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
> -						   "sd_done: sb[respc,sk,asc,"
> +						   "sd_rw_intr: sb[respc,sk,asc,"
>  						   "ascq]=%x,%x,%x,%x\n",
>  						   sshdr.response_code,
>  						   sshdr.sense_key, sshdr.asc,
> @@ -997,7 +989,7 @@ static int sd_done(struct scsi_cmnd *SCp
>  		break;
>  	}
>   out:
> -	return good_bytes;
> +	scsi_io_completion(SCpnt, good_bytes);
>  }
>  
>  static int media_not_present(struct scsi_disk *sdkp,
> diff -puN drivers/scsi/sr.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d drivers/scsi/sr.c
> --- a/drivers/scsi/sr.c~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/drivers/scsi/sr.c
> @@ -78,7 +78,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
>  
>  static int sr_probe(struct device *);
>  static int sr_remove(struct device *);
> -static int sr_done(struct scsi_cmnd *);
>  
>  static struct scsi_driver sr_template = {
>  	.owner			= THIS_MODULE,
> @@ -87,7 +86,6 @@ static struct scsi_driver sr_template = 
>  		.probe		= sr_probe,
>  		.remove		= sr_remove,
>  	},
> -	.done			= sr_done,
>  };
>  
>  static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
> @@ -221,12 +219,12 @@ out:
>  }
>   
>  /*
> - * sr_done is the interrupt routine for the device driver.
> + * rw_intr is the interrupt routine for the device driver.
>   *
> - * It will be notified on the end of a SCSI read / write, and will take one
> + * It will be notified on the end of a SCSI read / write, and will take on
>   * of several actions based on success or failure.
>   */
> -static int sr_done(struct scsi_cmnd *SCpnt)
> +static void rw_intr(struct scsi_cmnd * SCpnt)
>  {
>  	int result = SCpnt->result;
>  	int this_count = scsi_bufflen(SCpnt);
> @@ -299,7 +297,12 @@ static int sr_done(struct scsi_cmnd *SCp
>  		}
>  	}
>  
> -	return good_bytes;
> +	/*
> +	 * This calls the generic completion function, now that we know
> +	 * how many actual sectors finished, and how many sectors we need
> +	 * to say have failed.
> +	 */
> +	scsi_io_completion(SCpnt, good_bytes);
>  }
>  
>  static int sr_prep_fn(struct request_queue *q, struct request *rq)
> @@ -434,6 +437,12 @@ static int sr_prep_fn(struct request_que
>  	SCpnt->timeout_per_command = timeout;
>  
>  	/*
> +	 * This is the completion routine we use.  This is matched in terms
> +	 * of capability to this function.
> +	 */
> +	SCpnt->done = rw_intr;
> +
> +	/*
>  	 * This indicates that the command is ready from our end to be
>  	 * queued.
>  	 */
> diff -puN include/scsi/scsi_cmnd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d include/scsi/scsi_cmnd.h
> --- a/include/scsi/scsi_cmnd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/include/scsi/scsi_cmnd.h
> @@ -41,6 +41,7 @@ struct scsi_cmnd {
>  	struct list_head list;  /* scsi_cmnd participates in queue lists */
>  	struct list_head eh_entry; /* entry for the host eh_cmd_q */
>  	int eh_eflags;		/* Used by error handlr */
> +	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
>  
>  	/*
>  	 * A SCSI Command is assigned a nonzero serial_number before passed
> @@ -121,6 +122,7 @@ extern struct scsi_cmnd *__scsi_get_comm
>  extern void scsi_put_command(struct scsi_cmnd *);
>  extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
>  			       struct device *);
> +extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
>  extern void scsi_finish_command(struct scsi_cmnd *cmd);
>  extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
>  
> diff -puN include/scsi/scsi_driver.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d include/scsi/scsi_driver.h
> --- a/include/scsi/scsi_driver.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/include/scsi/scsi_driver.h
> @@ -15,7 +15,6 @@ struct scsi_driver {
>  	struct device_driver	gendrv;
>  
>  	void (*rescan)(struct device *);
> -	int (*done)(struct scsi_cmnd *);
>  };
>  #define to_scsi_driver(drv) \
>  	container_of((drv), struct scsi_driver, gendrv)
> diff -puN include/scsi/sd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d include/scsi/sd.h
> --- a/include/scsi/sd.h~revert-6f5391c283d7fdcf24bf40786ea79061919d1e1d
> +++ a/include/scsi/sd.h
> @@ -48,6 +48,19 @@ struct scsi_disk {
>  };
>  #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
>  
> +static int  sd_revalidate_disk(struct gendisk *disk);
> +static void sd_rw_intr(struct scsi_cmnd * SCpnt);
> +static int  sd_probe(struct device *);
> +static int  sd_remove(struct device *);
> +static void sd_shutdown(struct device *dev);
> +static int sd_suspend(struct device *dev, pm_message_t state);
> +static int sd_resume(struct device *dev);
> +static void sd_rescan(struct device *);
> +static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
> +static void scsi_disk_release(struct class_device *cdev);
> +static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
> +static void sd_print_result(struct scsi_disk *, int);
> +
>  #define sd_printk(prefix, sdsk, fmt, a...)				\
>          (sdsk)->disk ?							\
>  	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
> _
> 
> -
Boaz
