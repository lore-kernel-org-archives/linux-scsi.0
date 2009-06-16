From: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Tue, 16 Jun 2009 20:39:22 +0530
Message-ID: <3e7aae30906160809y32f0c8f6j3352cd1ec2bfe34a@mail.gmail.com>
References: <4A363EB4.8000102@panasas.com>
	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
	 <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>
	 <4A365BBE.3010708@panasas.com>
	 <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
	 <4A36776C.5010208@panasas.com>
	 <3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
	 <4A37ABDC.4050308@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4A37ABDC.4050308-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>  >       /* error and abort handlers */
>  >       .eh_abort_handler =             command_abort,
>  >       .eh_device_reset_handler =      device_reset,
>  >       .eh_bus_reset_handler =         bus_reset,

Currently I have not implemented these functions. I will register a
transport handler for the above functions and use strategy handler for
error handling at later point of time.

Here is my queuecommand implementation. Please let me know if any
other part of the code is required to find the problem.


static int queuecommand(struct scsi_cmnd *srb,
			void (*done)(struct scsi_cmnd *))
{
		int res = 0;
	struct uas_task *task;
	struct us_data *us = host_to_us(srb->device->host);
	
	US_DEBUG(usb_stor_show_command(srb));

	/* check for state-transition errors */
	if (us->srb != NULL) {
		printk(KERN_ERR USB_STORAGE "Error in %s: us->srb = %p\n",
			__func__, us->srb);
		return SCSI_MLQUEUE_HOST_BUSY;
	}

	/* fail the command if we are disconnecting */
	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
		US_DEBUGP("Fail command during disconnect\n");
		srb->result = DID_NO_CONNECT << 16;
		done(srb);
		return 0;
	}

		
	/* Create one task per SCSI command */
	task = uas_create_task(srb, us, GFP_ATOMIC);
	if (!task)
	     return -ENOMEM;
	
	

	/* enqueue the command and wake up the control thread */
	srb->scsi_done = done;

          //us->srb = srb; // eliminated, as a task has been created
per SCSI command


	
		/* Queue the above created task */
		res = uas_queue(task, us);

		/* Examine */
		if (res) {
			
	           //Checking the status of the queue
                    if (res == -UAS_QUEUE_FULL) {
        	srb->result = DID_SOFT_ERROR << 16; /* retry */
			res = 0;
			done(srb);
			}
			return res;
		}
	
	

	printk("MyTag: <%s> <%s> Exit!\n",__FILE__, __FUNCTION__);

	return 0;  //Returning 0 to get the next command
}
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
