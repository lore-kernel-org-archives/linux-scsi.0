From: "Ely, Paul" <Paul.Ely@Emulex.Com>
Subject: RE: suspending I/Os to a device
Date: Mon, 26 Jul 2004 15:11:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28025AB7AA@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:22258 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263585AbUGZTMX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 15:12:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Ely, Paul" <Paul.Ely@Emulex.Com>, 'Christoph Hellwig' <hch@infradead.org>
Cc: "Smart, James" <James.Smart@Emulex.Com>, 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

I think the sysfs implementation for the nodevice_tmo
attribute needs to be rethought.

The nodevice_tmo really is a scsi device-specific attribute
and although it could apply to Fibre Channel, iSCSI,
or usb-connected storage, defining it in the scsi_transport_fc.c/h
files doesn't really work since:
	1. The midlayer doesn't interface with the transport
	   interface directly.
	2. Each transport type would need to replicate the
	   transport_fc at least for the nodevice_tmo.
	3. Implementing this is messy.

I am working on a modification to move the nodevice_timeout
value and timeout error handler into the scsi_device structure
since it really is a scsi device attribute that needs to be
managed by the midlayer.

Thoughts?

Paul


> -----Original Message-----
> From: Ely, Paul 
> Sent: Thursday, July 22, 2004 4:16 PM
> To: 'Christoph Hellwig'
> Cc: Smart, James; 'James Bottomley'; Linux SCSI Reflector
> Subject: RE: suspending I/Os to a device
> 
> 
> All,
> 
> 
> The following patch provides an implementation of
> the proposal contained in this mail thread.  The
> patch does not provide a complete solution such
> as:
> 	nodevice tmo handling by the scsi midlayer
> 	scsi_device structure member for nodevice tmo
> 	handling of SDEV_SUSPEND state by midlayer
> 
> Subsequent patches to address remaining implementation.
> 
> 
> Thanks,
> 
> Paul
> 
> 
> 
> diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_lib.c
> changed_kernel_2_6_7/drivers/scsi/scsi_lib.c
> --- clean_kernel_2_6_7/drivers/scsi/scsi_lib.c	2004-07-19
> 13:04:44.873200000 -0400
> +++ changed_kernel_2_6_7/drivers/scsi/scsi_lib.c	2004-07-22
> 16:03:49.423920000 -0400
> @@ -1581,6 +1581,7 @@
>  		case SDEV_CREATED:
>  		case SDEV_OFFLINE:
>  		case SDEV_QUIESCE:
> +		case SDEV_SUSPEND:
>  			break;
>  		default:
>  			goto illegal;
> @@ -1608,11 +1609,22 @@
>  		}
>  		break;
>  
> +	case SDEV_SUSPEND:
> +		switch (oldstate) {
> +		case SDEV_CREATED:
> +		case SDEV_RUNNING:
> +			break;
> +		default:
> +			goto illegal;
> +		}
> +		break;
> +
>  	case SDEV_CANCEL:
>  		switch (oldstate) {
>  		case SDEV_CREATED:
>  		case SDEV_RUNNING:
>  		case SDEV_OFFLINE:
> +		case SDEV_SUSPEND:
>  			break;
>  		default:
>  			goto illegal;
> @@ -1627,7 +1639,6 @@
>  			goto illegal;
>  		}
>  		break;
> -
>  	}
>  	sdev->sdev_state = state;
>  	return 0;
> @@ -1691,3 +1702,92 @@
>  }
>  EXPORT_SYMBOL(scsi_device_resume);
>  
> +/**
> + * Function:	scsi_device_suspend()
> + *
> + * Purpose:	Suspend request made by scsi lld's to 
> temporarily stop all
> + *		scsi commands on the specified device.  Called from
> interrupt
> + *		or normal process context.
> + *
> + * Arguments:	sdev:	scsi device to suspend
> + *
> + * Lock status:	Assumed that host lock is not held upon entry.
> + *
> + * Returns:	zero if successful 
> + *		an error otherwise (for example, state 
> transition illegal)
> + *		  
> + *
> + * Notes:       
> + *	This routine transitions the device to the SDEV_SUSPEND state
> + *	(which must be a legal transition).  When the device is in this
> + *	state, all commands are deferred until the scsi lld reenables
> + *	the device with scsi_device_continue or 
> device_suspend_tmo fires.
> + **/
> +int
> +scsi_device_suspend(struct scsi_device *sdev)
> +{
> +	request_queue_t *q;
> +	int err;
> +	unsigned long flags;
> +
> +	q = sdev->request_queue;
> +	err = scsi_device_set_state(sdev, SDEV_SUSPEND);
> +	if (err)
> +		return err;
> +
> +	/* 
> +	 * The device has transitioned to SDEV_SUSPEND.  Stop the
> +	 * block layer from calling the midlayer with this device's
> +	 * request queue.  
> +	 */
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	blk_stop_queue(q);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(scsi_device_suspend);
> +
> +/**
> + * Function:	scsi_device_continue()
> + *
> + * Purpose:	Called by scsi lld's or the midlayer to restart 
> the device
> queue
> + *		for the previously suspended scsi device.  Called from
> + *		interrupt or normal process context.
> + *
> + * Arguments:	sdev:	scsi device to restart
> + *
> + * Lock status:	Assumed that host lock is not held upon entry.
> + *
> + * Returns:	zero if successful 
> + *		an error otherwise (for example, state 
> transition illegal)
> + *		  
> + *
> + * Notes:       
> + *	This routine transitions the device to the SDEV_RUNNING state
> + *	(which must be a legal transition) allowing the midlayer to
> + *	goose the queue for this device.
> + **/
> +int
> +scsi_device_continue(struct scsi_device *sdev)
> +{
> +	request_queue_t *q;
> +	int err;
> +	unsigned long flags;
> +
> +	q = sdev->request_queue;
> +	err = scsi_device_set_state(sdev, SDEV_RUNNING);
> +	if (err)
> +		return err;
> +
> +	/* 
> +	 * The device has transitioned to SDEV_RUNNING.  Restart
> +	 * this device's request by calling the block to resume
> +	 * calling the scsi_request_fn.
> +	 */
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	blk_start_queue(q);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL(scsi_device_continue);
> diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_sysfs.c
> changed_kernel_2_6_7/drivers/scsi/scsi_sysfs.c
> --- clean_kernel_2_6_7/drivers/scsi/scsi_sysfs.c	2004-07-19
> 13:04:43.644200000 -0400
> +++ changed_kernel_2_6_7/drivers/scsi/scsi_sysfs.c	2004-07-19
> 12:46:50.470200000 -0400
> @@ -29,6 +29,7 @@
>  	{ SDEV_DEL, "deleted" },
>  	{ SDEV_QUIESCE, "quiesce" },
>  	{ SDEV_OFFLINE,	"offline" },
> +	{ SDEV_SUSPEND,	"suspend" },
>  };
>  
>  const char *scsi_device_state_name(enum scsi_device_state state)
> diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c
> changed_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c
> --- clean_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c	
> 2004-07-19
> 13:04:47.270200000 -0400
> +++ changed_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c	
> 2004-07-22
> 15:52:22.224920000 -0400
> @@ -28,7 +28,7 @@
>  
>  static void transport_class_release(struct class_device *class_dev);
>  
> -#define FC_NUM_ATTRS 	3	/* increase this if you 
> add attributes */
> +#define FC_NUM_ATTRS 	4	/* increase this if you 
> add attributes */
>  #define FC_OTHER_ATTRS 	0	/* increase this if you 
> add "always
> on"
>  				 * attributes */
>  
> @@ -62,10 +62,12 @@
>  static int fc_setup_transport_attrs(struct scsi_device *sdev)
>  {
>  	/* I'm not sure what values are invalid.  We should pick some
> invalid
> -	 * values for the defaults */
> +	 * values for the defaults.  Set the no device timeout 
> to 60 seconds
> +	 * as the default.*/
>  	fc_node_name(sdev) = -1;
>  	fc_port_name(sdev) = -1;
>  	fc_port_id(sdev) = -1;
> +	fc_nodevice_tmo(sdev) = 60;
>  
>  	return 0;
>  }
> @@ -125,6 +127,7 @@
>  fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
>  fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
>  fc_transport_rd_attr(port_id, "0x%06x\n");
> +fc_transport_rw_attr(nodevice_tmo, "%d\n");
>  
>  #define SETUP_ATTRIBUTE_RD(field)				\
>  	i->private_attrs[count] = class_device_attr_##field;	\
> @@ -165,6 +168,7 @@
>  	SETUP_ATTRIBUTE_RD(port_id);
>  	SETUP_ATTRIBUTE_RD(port_name);
>  	SETUP_ATTRIBUTE_RD(node_name);
> +	SETUP_ATTRIBUTE_RW(nodevice_tmo);
>  
>  	BUG_ON(count > FC_NUM_ATTRS);
>  
> diff -uNr clean_kernel_2_6_7/include/scsi/scsi_device.h
> changed_kernel_2_6_7/include/scsi/scsi_device.h
> --- clean_kernel_2_6_7/include/scsi/scsi_device.h	2004-07-19
> 13:05:49.284200000 -0400
> +++ changed_kernel_2_6_7/include/scsi/scsi_device.h	2004-07-19
> 12:46:39.286200000 -0400
> @@ -30,6 +30,9 @@
>  				 * originate in the mid-layer) */
>  	SDEV_OFFLINE,		/* Device offlined (by error handling or
>  				 * user request */
> +	SDEV_SUSPEND,		/* Device suspended by scsi 
> lld.  No block 
> +				 * commands from user and 
> midlayer should be
> issued
> +				 * to the scsi lld. */
>  };
>  
>  struct scsi_device {
> diff -uNr clean_kernel_2_6_7/include/scsi/scsi_transport_fc.h
> changed_kernel_2_6_7/include/scsi/scsi_transport_fc.h
> --- clean_kernel_2_6_7/include/scsi/scsi_transport_fc.h	
> 2004-07-19
> 13:05:49.377200000 -0400
> +++ changed_kernel_2_6_7/include/scsi/scsi_transport_fc.h	
> 2004-07-22
> 14:00:43.519924000 -0400
> @@ -28,18 +28,23 @@
>  	int port_id;
>  	uint64_t node_name;
>  	uint64_t port_name;
> +	uint32_t nodevice_tmo;
>  };
>  
>  /* accessor functions */
>  #define fc_port_id(x)	(((struct fc_transport_attrs
> *)&(x)->transport_data)->port_id)
>  #define fc_node_name(x)	(((struct fc_transport_attrs
> *)&(x)->transport_data)->node_name)
>  #define fc_port_name(x)	(((struct fc_transport_attrs
> *)&(x)->transport_data)->port_name)
> +#define fc_nodevice_tmo(x) (((struct fc_transport_attrs
> *)&(x)->transport_data)->nodevice_tmo)
>  
>  /* The functions by which the transport class and the driver 
> communicate */
>  struct fc_function_template {
>  	void 	(*get_port_id)(struct scsi_device *);
>  	void	(*get_node_name)(struct scsi_device *);
>  	void	(*get_port_name)(struct scsi_device *);
> +	void    (*get_nodevice_tmo)(struct scsi_device *);
> +	void	(*set_nodevice_tmo)(struct scsi_device *, int);
> +
>  	/* The driver sets these to tell the transport class it
>  	 * wants the attributes displayed in sysfs.  If the show_ flag
>  	 * is not set, the attribute will be private to the transport
> @@ -47,6 +52,7 @@
>  	unsigned long	show_port_id:1;
>  	unsigned long	show_node_name:1;
>  	unsigned long	show_port_name:1;
> +	unsigned long   show_nodevice_tmo:1;
>  	/* Private Attributes */
>  };
>  
> @@ -54,3 +60,4 @@
>  void fc_release_transport(struct scsi_transport_template *);
>  
>  #endif /* SCSI_TRANSPORT_FC_H */
> +
> diff -uNr clean_kernel_2_6_7/Makefile changed_kernel_2_6_7/Makefile
> --- clean_kernel_2_6_7/Makefile	2004-07-19 
> 13:03:26.385200000 -0400
> +++ changed_kernel_2_6_7/Makefile	2004-07-19 
> 15:17:14.137200000 -0400
> @@ -1,8 +1,8 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 7
> -EXTRAVERSION =
> -NAME=Zonked Quokka
> +EXTRAVERSION = -pae1.358.4.3smp
> +NAME=pae
>  
>  # *DOCUMENTATION*
>  # To see a list of typical targets execute "make help"
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Saturday, July 17, 2004 8:25 AM
> > To: Ely, Paul
> > Cc: Smart, James; 'James Bottomley'; Linux SCSI Reflector
> > Subject: Re: suspending I/Os to a device
> > 
> > 
> > On Mon, Jul 12, 2004 at 04:53:34PM -0400, Ely, Paul wrote:
> > > The proposal:
> > > 	o A new device state called SDEV_SUSPEND
> > > 		- The device's current state must be SDEV_CREATED or
> > > SDEV_RUNNING.
> > > 		- Once in SDEV_SUSPEND, the device state is allowed to
> > > transition
> > > 		  to SDEV_RUNNING or SDEV_CANCEL.
> > > 
> > > 	o A new routine called scsi_device_suspend to enter the 
> > SDEV_SUSPEND
> > > 	  state.
> > > 		- Called by scsi LLDs only.
> > > 		- scsi LLD must not hold any locks, including 
> > the host lock,
> > > 		  when calling this routine.
> > > 		- Routine can be called from interrupt context or normal
> > > kernel
> > > 		  context.
> > > 		- This routine calls into the scsi_device_set_state
> > > 		  function to handle the state transition.  Other
> > > functionality
> > > 		  is TBD.
> > > 
> > > 	o A routine that the scsi LLD calls to successfully 
> > transition from
> > > 	  SDEV_SUSPEND to SDEV_RUNNING state and restart scsi 
> > commands.  I
> > > am
> > > 	  proposing some alternatives.
> > 
> > This sounds fine to me.
> > 
> > > 		- Reuse scsi_device_resume.
> > > 			+ Overloads quiesce and suspend.  This may work
> > > since
> > > 			  the state machine will not allow transitions
> > > to/from
> > > 			  SDEV_QUIESCE and SDEV_SUSPEND.
> > > 
> > > 		OR
> > > 
> > > 		- Provide a new routine called scsi_device_continue 
> > > 			+ Analogous functionality as 
> > scsi_device_resume, but
> > > is
> > > 			  called specifically to transition out of
> > > SDEV_SUSPEND.
> > 
> > Please use separate functions.
> > 
> > > 	o Provide TMO control that limits the amount of time a 
> > device can 
> > > 	  disappear.  The timeout handling would clean up pending
> > > 	  commands on the device queue.  I am proposing some
> > > 	  alternatives here.
> > > 		- Require the scsi LLD to provide tmo functionality.
> > > Timeout 
> > > 		  value would be a driver default, but also 
> > settable via a
> > > sysfs
> > > 		  class transport attribute.  For example, Fibre Channel
> > > drivers
> > > 		  would use a FC transport value in sysfs.
> > 
> > Not sure if I parsed that correctly.  You want a timeout 
> > after which the
> > device gets unblocked again?  In that case the scsi_device 
> > should get a timer
> > that calls the unblock routine, sounds fine to me and can be 
> > done in the
> > scsi midlayer.
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
