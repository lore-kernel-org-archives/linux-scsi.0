From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix cpqfc passthrough ioctl for 2.5.30
Date: Mon, 5 Aug 2002 12:00:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020805120021.A23954@eng2.beaverton.ibm.com>
References: <20020802165932.A4175@zuul.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020802165932.A4175@zuul.cca.cpqcorp.net>; from steve.cameron@hp.com on Fri, Aug 02, 2002 at 04:59:32PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Stephen Cameron <steve.cameron@hp.com>
Cc: linux-scsi@vger.kernel.org

Steve -

On Fri, Aug 02, 2002 at 04:59:32PM -0500, Stephen Cameron wrote:
> 
> This patch fixes the cpqfc passthrough ioctl for 2.5.30.
> 
> One question... Is it possible for a user app, by abusing
> a upperlevel driver (e.g. the sg driver) to put a bogus
> value into Scsi_Request->upper_level_private?

You mean upper_private_data, if an upper level driver modifies it
while you have the Scsi_Request it would be a bug.

> This patch kind of depends on this being impossible.
> 
> If it is possible, maybe it's better if I find another way
> to identify passthrough commands on completion than what
> this patch does.  e.g. keep a list of the passthru Scsi_Requests
> that are outstanding, then search the list on each completion...(yuck.)

It would be best if this code could be replaced via usage of sg, rather
than having its own pass through.

Is the user program trying to send commands to devices that sg did not
find (linux did not allocate and/or properly set up a Scsi_Device)?

Having sg be able to send commands to arbitrary (i.e. no current Scsi_Device)
devices would be very useful. It would also help with user level scanning.

In any case, getting rid of scsi_do_cmd() is a good idea - with your
patch, there is only one other user of scsi_do_cmd in gdth_proc.c.

-- Patrick Mansfield

> 
> -- steve
> 
> diff -urN linux-2.5.30-p1/drivers/scsi/cpqfc.Readme linux-2.5.30-p2/drivers/scsi/cpqfc.Readme
> --- linux-2.5.30-p1/drivers/scsi/cpqfc.Readme	Fri Aug  2 15:13:14 2002
> +++ linux-2.5.30-p2/drivers/scsi/cpqfc.Readme	Fri Aug  2 15:15:45 2002
> 
> @@ -7,6 +7,8 @@
>  SEST size 512 Exchanges (simultaneous I/Os) limited by module kmalloc() 
>  	max of 128k bytes contiguous.
>  
> +Ver 2.5.3  Aug 01, 2002
> +   * fix the passthru ioctl to handle the Scsi_Cmnd->request being a pointer
>  Ver 2.5.1  Jul 30, 2002
>     * fix ioctl to pay attention to the specified LUN.
>  Ver 2.5.0  Nov 29, 2001
> diff -urN linux-2.5.30-p1/drivers/scsi/cpqfcTSinit.c linux-2.5.30-p2/drivers/scsi/cpqfcTSinit.c
> --- linux-2.5.30-p1/drivers/scsi/cpqfcTSinit.c	Fri Aug  2 15:13:14 2002
> +++ linux-2.5.30-p2/drivers/scsi/cpqfcTSinit.c	Fri Aug  2 16:37:31 2002
> @@ -68,7 +68,7 @@
>  
>  /* Embedded module documentation macros - see module.h */
>  MODULE_AUTHOR("Compaq Computer Corporation");
> -MODULE_DESCRIPTION("Driver for Compaq 64-bit/66Mhz PCI Fibre Channel HBA v. 2.5.2");
> +MODULE_DESCRIPTION("Driver for Compaq 64-bit/66Mhz PCI Fibre Channel HBA v. 2.5.3");
>  MODULE_LICENSE("GPL");
>    
>  int cpqfcTS_TargetDeviceReset( Scsi_Device *ScsiDev, unsigned int reset_flags);
> @@ -105,15 +105,16 @@
>  #  define CPQFC_WAIT_FOR_COMPLETION(x) down(x)
>  #endif
>  
> +static int cpqfc_alloc_private_data_pool(CPQFCHBA *hba);
> +
>  /* local function to load our per-HBA (local) data for chip
>     registers, FC link state, all FC exchanges, etc.
>  
>     We allocate space and compute address offsets for the
>     most frequently accessed addresses; others (like World Wide
>     Name) are not necessary.
> -   
>  */
> -static void Cpqfc_initHBAdata( CPQFCHBA *cpqfcHBAdata, struct pci_dev *PciDev )
> +static void Cpqfc_initHBAdata(CPQFCHBA *cpqfcHBAdata, struct pci_dev *PciDev )
>  {
>               
>    cpqfcHBAdata->PciDev = PciDev; // copy PCI info ptr
> @@ -226,8 +227,11 @@
>    cpqfcHBAdata->fcChip.ReadWriteWWN = CpqTsReadWriteWWN;
>    cpqfcHBAdata->fcChip.ReadWriteNVRAM = CpqTsReadWriteNVRAM;
>  
> - 
> -
> +      if (cpqfc_alloc_private_data_pool(cpqfcHBAdata) != 0) {
> +		printk(KERN_WARNING 
> +			"cpqfc: unable to allocate pool for passthru ioctls.  "
> +			"Passthru ioctls disabled.\n");
> +      }
>  }
>  
>  
> @@ -483,6 +487,75 @@
>  }   
>  
>  
> +static int cpqfc_alloc_private_data_pool(CPQFCHBA *hba)
> +{
> +	hba->private_data_bits = NULL;
> +	hba->private_data_pool = NULL;
> +	hba->private_data_bits = 
> +		kmalloc(((CPQFC_MAX_PASSTHRU_CMDS+BITS_PER_LONG-1) /
> +				BITS_PER_LONG)*sizeof(unsigned long), 
> +				GFP_KERNEL);
> +	if (hba->private_data_bits == NULL)
> +		return -1;
> +	memset(hba->private_data_bits, 0,
> +		((CPQFC_MAX_PASSTHRU_CMDS+BITS_PER_LONG-1) /
> +				BITS_PER_LONG)*sizeof(unsigned long));
> +	hba->private_data_pool = kmalloc(sizeof(cpqfc_passthru_private_t) *
> +			CPQFC_MAX_PASSTHRU_CMDS, GFP_KERNEL);
> +	if (hba->private_data_pool == NULL) {
> +		kfree(hba->private_data_bits);
> +		hba->private_data_bits = NULL;
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static void cpqfc_free_private_data_pool(CPQFCHBA *hba)
> +{
> +	kfree(hba->private_data_bits);
> +	kfree(hba->private_data_pool);
> +}
> +
> +int is_private_data_of_cpqfc(CPQFCHBA *hba, void *pointer)
> +{
> +	/* Is pointer within our private data pool?
> +	   We use Scsi_Request->upper_private_data (normally
> +	   reserved for upper layer drivers, e.g. the sg driver)
> +	   We check to see if the pointer is ours by looking at
> +	   its address.  Is this ok?   Hmm, it occurs to me that
> +	   a user app might do something bad by using sg to send
> +	   a cpqfc passthrough ioctl with upper_data_private
> +	   forged to be somewhere in our pool..., though they'd
> +	   normally have to be root already to do this.  */
> +
> +	return (pointer != NULL && 
> +		pointer >= (void *) hba->private_data_pool && 
> +		pointer < (void *) hba->private_data_pool + 
> +			sizeof(*hba->private_data_pool) * 
> +				CPQFC_MAX_PASSTHRU_CMDS);
> +}
> +
> +cpqfc_passthru_private_t *cpqfc_alloc_private_data(CPQFCHBA *hba)
> +{
> +	int i;
> +
> +	do {
> +		i = find_first_zero_bit(hba->private_data_bits, 
> +			CPQFC_MAX_PASSTHRU_CMDS);
> +		if (i == CPQFC_MAX_PASSTHRU_CMDS)
> +			return NULL;
> +	} while ( test_and_set_bit(i & (BITS_PER_LONG - 1), 
> +			hba->private_data_bits+(i/BITS_PER_LONG)) != 0);
> +	return &hba->private_data_pool[i];
> +}
> +
> +void cpqfc_free_private_data(CPQFCHBA *hba, cpqfc_passthru_private_t *data)
> +{
> +	int i;
> +	i = data - hba->private_data_pool;
> +	clear_bit(i&(BITS_PER_LONG-1), 
> +			hba->private_data_bits+(i/BITS_PER_LONG));
> +}
>  
>  int cpqfcTS_ioctl( Scsi_Device *ScsiDev, int Cmnd, void *arg)
>  {
> @@ -490,36 +563,19 @@
>    struct Scsi_Host *HostAdapter = ScsiDev->host;
>    CPQFCHBA *cpqfcHBAdata = (CPQFCHBA *)HostAdapter->hostdata;
>    PTACHYON fcChip = &cpqfcHBAdata->fcChip;
> -  PFC_LOGGEDIN_PORT pLoggedInPort;
> +  PFC_LOGGEDIN_PORT pLoggedInPort = NULL;
>    Scsi_Cmnd DumCmnd;
>    int i, j;
>    VENDOR_IOCTL_REQ ioc;
>    cpqfc_passthru_t *vendor_cmd;
>    Scsi_Device *SDpnt;
> -  Scsi_Cmnd *ScsiPassThruCmnd;
> +  Scsi_Request *ScsiPassThruReq;
> +  cpqfc_passthru_private_t *privatedata;
>  
>    ENTER("cpqfcTS_ioctl ");
> -  
> -  // can we find an FC device mapping to this SCSI target?
> -  DumCmnd.channel = ScsiDev->channel;		// For searching
> -  DumCmnd.target  = ScsiDev->id;
> -  DumCmnd.lun     = ScsiDev->lun;
> -  pLoggedInPort = fcFindLoggedInPort( fcChip,
> -    &DumCmnd, // search Scsi Nexus
> -    0,        // DON'T search linked list for FC port id
> -    NULL,     // DON'T search linked list for FC WWN
> -    NULL);    // DON'T care about end of list
> - 
> -  if( pLoggedInPort == NULL )      // not found!
> -  {
> -    result = -ENXIO;
> -  }
> - 
> -  else  // we know what FC device to operate on...
> -  {
> -	// printk("ioctl CMND %d", Cmnd);
> -    switch (Cmnd) 
> -    {
> +
> +    // printk("ioctl CMND %d", Cmnd);
> +    switch (Cmnd) {
>        // Passthrough provides a mechanism to bypass the RAID
>        // or other controller and talk directly to the devices
>        // (e.g. physical disk drive)
> @@ -528,6 +584,10 @@
>        case CPQFCTS_SCSI_PASSTHRU:
>        {
>  	void *buf = NULL; // for kernel space buffer for user data
> +
> +	/* Check that our pool got allocated ok. */
> +	if (cpqfcHBAdata->private_data_pool == NULL)
> +		return -ENOMEM;
>  	
>  	if( !arg)
>  	  return -EINVAL;
> @@ -550,83 +610,70 @@
>  	  if( !buf)
>  	    return -ENOMEM;
>  	}
> +        // Now build a Scsi_Request to pass down...
> +        ScsiPassThruReq = scsi_allocate_request(ScsiDev);
> +	if (ScsiPassThruReq == NULL) {
> +		kfree(buf);
> +		return -ENOMEM;
> +	}
> +	ScsiPassThruReq->upper_private_data = 
> +			cpqfc_alloc_private_data(cpqfcHBAdata);
> +	if (ScsiPassThruReq->upper_private_data == NULL) {
> +		kfree(buf);
> +		scsi_release_request(ScsiPassThruReq); // "de-allocate"
> +		return -ENOMEM;
> +	}
>  
> -        // Now build a SCSI_CMND to pass down...
> -	// This function allocates and sets Scsi_Cmnd ptrs such as
> -	//  ->channel, ->target, ->host
> -        ScsiPassThruCmnd = scsi_allocate_device(ScsiDev, 1, 1);
> -
> -        // Need data from user?
> -	// make sure caller's buffer is in kernel space.
> -	if( (vendor_cmd->rw_flag == VENDOR_WRITE_OPCODE) &&
> -	    vendor_cmd->len)
> -        if(  copy_from_user( buf, vendor_cmd->bufp, vendor_cmd->len))
> -		return( -EFAULT);
> +	if (vendor_cmd->rw_flag == VENDOR_WRITE_OPCODE) {
> +		if (vendor_cmd->len) { // Need data from user?
> +        		if (copy_from_user(buf, vendor_cmd->bufp, 
> +						vendor_cmd->len)) {
> +				kfree(buf);
> +				cpqfc_free_private_data(cpqfcHBAdata, 
> +					ScsiPassThruReq->upper_private_data);
> +				scsi_release_request(ScsiPassThruReq);
> +				return( -EFAULT);
> +			}
> +		}
> +		ScsiPassThruReq->sr_data_direction = SCSI_DATA_WRITE; 
> +	} else if (vendor_cmd->rw_flag == VENDOR_READ_OPCODE) {
> +		ScsiPassThruReq->sr_data_direction = SCSI_DATA_READ; 
> +	} else
> +		// maybe this means a bug in the user app
> +		ScsiPassThruReq->sr_data_direction = SCSI_DATA_NONE;
>  	    
> -	// copy the CDB (if/when MAX_COMMAND_SIZE is 16, remove copy below)
> -        memcpy( &ScsiPassThruCmnd->cmnd[0], 
> -		&vendor_cmd->cdb[0], 
> -		MAX_COMMAND_SIZE);  
> -        // we want to copy all 16 bytes into the FCP-SCSI CDB,
> -	// although the actual passthru only uses up to the
> -	// first 12.
> -	
> -	ScsiPassThruCmnd->cmd_len = 16; // sizeof FCP-SCSI CDB
> +	ScsiPassThruReq->sr_cmd_len = 0; // set correctly by scsi_do_req()
> +	ScsiPassThruReq->sr_sense_buffer[0] = 0;
> +	ScsiPassThruReq->sr_sense_buffer[2] = 0;
>  
> -	// Unfortunately, the SCSI command cmnd[] field has only
> -	// 12 bytes.  Ideally the MAX_COMMAND_SIZE should be increased
> -	// to 16 for newer Fibre Channel and SCSI-3 larger CDBs.
> -	// However, to avoid a mandatory kernel rebuild, we use the SCp
> -	// spare field to store the extra 4 bytes ( ugly :-(
> -
> -	if( MAX_COMMAND_SIZE < 16)
> -	{
> -          memcpy( &ScsiPassThruCmnd->SCp.buffers_residual,
> -		  &vendor_cmd->cdb[12], 4);
> -	}	  
> -                  
> -	
> -        ScsiPassThruCmnd->SCp.sent_command = 1; // PASSTHRU!
> -	                                        // suppress LUN masking
> -	                                        // and VSA logic
> -
> -	// Use spare fields to copy FCP-SCSI LUN address info...
> -        ScsiPassThruCmnd->SCp.phase = vendor_cmd->bus;
> -	ScsiPassThruCmnd->SCp.have_data_in = vendor_cmd->pdrive;
> -
> -        // We copy the scheme used by scsi.c to submit commands
> +        // We copy the scheme used by sd.c:spinup_disk() to submit commands
>  	// to our own HBA.  We do this in order to stall the
>  	// thread calling the IOCTL until it completes, and use
>  	// the same "_quecommand" function for synchronizing
>  	// FC Link events with our "worker thread".
>  
> -        {
> -          CPQFC_DECLARE_COMPLETION(wait);
> -          ScsiPassThruCmnd->request->CPQFC_WAITING = &wait;
> -          // eventually gets us to our own _quecommand routine
> -          scsi_do_cmd( ScsiPassThruCmnd, &vendor_cmd->cdb[0], 
> -	       buf, 
> -	       vendor_cmd->len, 
> -	       my_ioctl_done, 
> -	       10*HZ, 1);// timeout,retries
> -          // Other I/Os can now resume; we wait for our ioctl
> -	  // command to complete
> -	  CPQFC_WAIT_FOR_COMPLETION(&wait);
> -          ScsiPassThruCmnd->request->CPQFC_WAITING = NULL;
> -        }
> +	privatedata = ScsiPassThruReq->upper_private_data;
> +	privatedata->bus = vendor_cmd->bus;
> +	privatedata->pdrive = vendor_cmd->pdrive;
>  	
> -        result = ScsiPassThruCmnd->result;
> +        // eventually gets us to our own _quecommand routine
> +	scsi_wait_req(ScsiPassThruReq, 
> +		&vendor_cmd->cdb[0], buf, vendor_cmd->len, 
> +		10*HZ,  // timeout
> +		1);	// retries
> +        result = ScsiPassThruReq->sr_result;
>  
>          // copy any sense data back to caller
>          if( result != 0 )
>  	{
>  	  memcpy( vendor_cmd->sense_data, // see struct def - size=40
> -		  ScsiPassThruCmnd->sense_buffer, 
> -		  sizeof(ScsiPassThruCmnd->sense_buffer)); 
> +		  ScsiPassThruReq->sr_sense_buffer, 
> +		  sizeof(ScsiPassThruReq->sr_sense_buffer)); 
>  	}
> -        SDpnt = ScsiPassThruCmnd->device;
> -        scsi_release_command(ScsiPassThruCmnd); // "de-allocate"
> -        ScsiPassThruCmnd = NULL;
> +        SDpnt = ScsiPassThruReq->sr_device;
> +	/* upper_private_data is already freed in call_scsi_done() */
> +        scsi_release_request(ScsiPassThruReq); // "de-allocate"
> +        ScsiPassThruReq = NULL;
>  
>          // if (!SDpnt->was_reset && SDpnt->scsi_request_fn)
>          //  (*SDpnt->scsi_request_fn)();
> @@ -680,10 +727,21 @@
>  
>  
>        case CPQFC_IOCTL_FC_TARGET_ADDRESS:
> -      result = 
> -        verify_area(VERIFY_WRITE, arg, sizeof(Scsi_FCTargAddress));
> -      if (result) 
> -	break;
> +	// can we find an FC device mapping to this SCSI target?
> +	DumCmnd.channel = ScsiDev->channel;		// For searching
> +	DumCmnd.target  = ScsiDev->id;
> +	DumCmnd.lun     = ScsiDev->lun;
> +	pLoggedInPort = fcFindLoggedInPort( fcChip,
> +		&DumCmnd, // search Scsi Nexus
> +		0,        // DON'T search linked list for FC port id
> +		NULL,     // DON'T search linked list for FC WWN
> +		NULL);    // DON'T care about end of list
> +	if (pLoggedInPort == NULL) {
> +		result = -ENXIO;
> +		break;
> +	}
> +	result = verify_area(VERIFY_WRITE, arg, sizeof(Scsi_FCTargAddress));
> +	if (result) break;
>   
>        put_user(pLoggedInPort->port_id,
>  		&((Scsi_FCTargAddress *) arg)->host_port_id);
> @@ -710,7 +768,6 @@
>        result = -EINVAL;
>        break;
>      }
> -  }
>  
>    LEAVE("cpqfcTS_ioctl");
>    return result;
> @@ -748,6 +805,7 @@
>      
>    }
>  
> +  cpqfc_free_private_data_pool(cpqfcHBAdata);
>    // free Linux resources
>    DEBUG_PCI( printk(" cpqfcTS: freeing resources...\n"));
>    free_irq( HostAdapter->irq, HostAdapter);
> @@ -1528,6 +1586,12 @@
>    Scsi_Cmnd * SCpnt;
>    Scsi_Device * SDpnt;
>  
> +// FIXME, cpqfcTS_TargetDeviceReset needs to be fixed 
> +// similarly to how the passthrough ioctl was fixed 
> +// around the 2.5.30 kernel.  Scsi_Cmnd replaced with 
> +// Scsi_Request, etc.
> +// For now, so people don't fall into a hole...
> +return -ENOTSUPP;
>  
>    // printk("   ENTERING cpqfcTS_TargetDeviceReset() - flag=%d \n",reset_flags);
>  
> @@ -1541,9 +1605,10 @@
>    SCpnt = scsi_allocate_device(ScsiDev, 1, 0);
>    {
>      CPQFC_DECLARE_COMPLETION(wait);
> -        
> +    
>      SCpnt->SCp.buffers_residual = FCP_TARGET_RESET;
>  
> +	// FIXME: this would panic, SCpnt->request would be NULL.
>  	SCpnt->request->CPQFC_WAITING = &wait;
>  	scsi_do_cmd(SCpnt,  scsi_cdb, NULL,  0, my_ioctl_done,  timeout, retries);
>  	CPQFC_WAIT_FOR_COMPLETION(&wait);
> @@ -1702,6 +1767,18 @@
>    	UCHAR IntStat;
>    	printk(" cpqfcTS adapter PCI error detected\n");
>    	IntStat = readb( cpqfcHBA->fcChip.Registers.INTSTAT.address);
> +	printk("cpqfc: ISR = 0x%02x\n", IntStat);
> +	if (IntStat & 0x1) {
> +		__u16 pcistat;
> +		/* read the pci status register */
> +		pci_read_config_word(cpqfcHBA->PciDev, 0x06, &pcistat);
> +		printk("PCI status register is 0x%04x\n", pcistat);
> +		if (pcistat & 0x8000) printk("Parity Error Detected.\n");
> +		if (pcistat & 0x4000) printk("Signalled System Error\n");
> +		if (pcistat & 0x2000) printk("Received Master Abort\n");
> +		if (pcistat & 0x1000) printk("Received Target Abort\n");
> +		if (pcistat & 0x0800) printk("Signalled Target Abort\n");
> +	}
>  	if (IntStat & 0x4) printk("(INT)\n");
>  	if (IntStat & 0x8) 
>  		printk("CRS: PCI master address crossed 46 bit bouandary\n");
> diff -urN linux-2.5.30-p1/drivers/scsi/cpqfcTSstructs.h linux-2.5.30-p2/drivers/scsi/cpqfcTSstructs.h
> --- linux-2.5.30-p1/drivers/scsi/cpqfcTSstructs.h	Fri Aug  2 15:13:14 2002
> +++ linux-2.5.30-p2/drivers/scsi/cpqfcTSstructs.h	Fri Aug  2 16:38:03 2002
> @@ -33,7 +33,7 @@
>  // don't forget to also change MODULE_DESCRIPTION in cpqfcTSinit.c
>  #define VER_MAJOR 2
>  #define VER_MINOR 5
> -#define VER_SUBMINOR 2
> +#define VER_SUBMINOR 3
>  
>  // Macros for kernel (esp. SMP) tracing using a PCI analyzer
>  // (e.g. x86).
> @@ -907,9 +907,17 @@
>  
>  } FC_SCSI_QUE, *PFC_SCSI_QUE;
>  
> +typedef struct {
> +	/* This is tacked on to a Scsi_Request in upper_private_data 
> +	   for pasthrough ioctls, as a place to hold data that can't 
> +	   be stashed anywhere else in the Scsi_Request.  We differentiate
> +	   this from _real_ upper_private_data by checking if the virt addr
> +	   is within our special pool.  */
> +	ushort bus;
> +	ushort pdrive;
> +} cpqfc_passthru_private_t;
>  
> -
> -
> +#define CPQFC_MAX_PASSTHRU_CMDS 100
>  
>  #define DYNAMIC_ALLOCATIONS 4  // Tachyon aligned allocations: ERQ,IMQ,SFQ,SEST
>  
> @@ -949,6 +957,8 @@
>    PFC_LINK_QUE fcLQ;             // the WorkerThread operates on this
>  
>    spinlock_t hba_spinlock;           // held/released by WorkerThread
> +  cpqfc_passthru_private_t *private_data_pool;
> +  unsigned long *private_data_bits;
>  
>  } CPQFCHBA;
>  
> @@ -1404,6 +1414,7 @@
>  	__u32 uba:13;		/* upper bus address bits 18-31 */
>  	__u32 lba;		/* lower bus address bits 0-31 */
>  }; 
> +
>  
>  // J. McCarty's LINK.H
>  //
> diff -urN linux-2.5.30-p1/drivers/scsi/cpqfcTSworker.c linux-2.5.30-p2/drivers/scsi/cpqfcTSworker.c
> --- linux-2.5.30-p1/drivers/scsi/cpqfcTSworker.c	Fri Aug  2 15:13:14 2002
> +++ linux-2.5.30-p2/drivers/scsi/cpqfcTSworker.c	Fri Aug  2 16:25:16 2002
> @@ -2887,15 +2887,22 @@
>  Done:  
>  }
>  
> +extern int is_private_data_of_cpqfc(CPQFCHBA *hba, void * pointer);
> +extern void cpqfc_free_private_data(CPQFCHBA *hba, cpqfc_passthru_private_t *data);
> +
>  static void 
>  call_scsi_done(Scsi_Cmnd *Cmnd)
>  {
> -	// We have to reinitialize sent_command here, so the scsi-mid
> -	// layer won't re-use the scsi command leaving it set incorrectly.
> -	// (incorrectly for our purposes...it's normally unused.)
> -
> -        if (Cmnd->SCp.sent_command != 0) {	// was it a passthru?
> -		Cmnd->SCp.sent_command = 0;
> +	CPQFCHBA *hba;
> +	hba = (CPQFCHBA *) Cmnd->host->hostdata;
> +	// Was this command a cpqfc passthru ioctl ?
> +        if (Cmnd->sc_request != NULL && Cmnd->host != NULL && 
> +		Cmnd->host->hostdata != NULL &&
> +		is_private_data_of_cpqfc((CPQFCHBA *) Cmnd->host->hostdata,
> +			Cmnd->sc_request->upper_private_data)) {
> +		cpqfc_free_private_data(hba, 
> +			Cmnd->sc_request->upper_private_data);	
> +		Cmnd->sc_request->upper_private_data = NULL;
>  		Cmnd->result &= 0xff00ffff;
>  		Cmnd->result |= (DID_PASSTHROUGH << 16);  // prevents retry
>  	}
> @@ -3293,6 +3300,7 @@
>  }
>  #endif
>  
> +extern cpqfc_passthru_private_t *cpqfc_private(Scsi_Request *sr);
>  
>  // Search the singly (forward) linked list "fcPorts" looking for 
>  // either the SCSI target (if != -1), port_id (if not NULL), 
> @@ -3366,8 +3374,18 @@
>        {
>          // For "passthru" modes, the IOCTL caller is responsible
>  	// for setting the FCP-LUN addressing
> -	if( !Cmnd->SCp.sent_command ) // NOT passthru?
> -	{
> +	if (Cmnd->sc_request != NULL && Cmnd->host != NULL && 
> +		Cmnd->host->hostdata != NULL &&
> +		is_private_data_of_cpqfc((CPQFCHBA *) Cmnd->host->hostdata,
> +			Cmnd->sc_request->upper_private_data)) { 
> +		/* This is a passthru... */
> +		cpqfc_passthru_private_t *pd;
> +		pd = Cmnd->sc_request->upper_private_data;
> +        	Cmnd->SCp.phase = pd->bus;
> +		// Cmnd->SCp.have_data_in = pd->pdrive;
> +		Cmnd->SCp.have_data_in = Cmnd->lun;
> +	} else {
> +	  /* This is not a passthru... */
>  	
>            // set the FCP-LUN addressing type
>            Cmnd->SCp.phase = pLoggedInPort->ScsiNexus.VolumeSetAddressing;	
> @@ -3506,7 +3524,6 @@
>  	{
>            printk("LinkDnCmnd scsi_done ptr null, port_id %Xh\n",
>  		  pLoggedInPort->port_id);
> -	  Cmnd->SCp.sent_command = 0;
>  	}
>  	else
>  	  call_scsi_done(Cmnd);
> @@ -5234,7 +5251,6 @@
>  	sgl = (struct scatterlist*)Cmnd->request_buffer;  
>  	sg_count = pci_map_sg(pcidev, sgl, Cmnd->use_sg, 
>  		scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
> -        // printk("sgl = %p, sg_count = %d\n", (void *) sgl, sg_count);
>    	if( sg_count <= 3 ) {
>  
>  	// we need to be careful here that no individual mapping
> @@ -5263,7 +5279,6 @@
>  	//	printk("totalsgs = %d, sgcount=%d\n",totalsgs,sg_count);
>    }
>  
> -  // printk("totalsgs = %d, sgcount=%d\n", totalsgs, sg_count);
>    if( totalsgs <= 3 ) // can (must) use "local" SEST list
>    {
>      while( bytes_to_go)
> @@ -6166,13 +6181,11 @@
>        }
>        else
>        {
> -	Exchanges->fcExchange[ x_ID ].Cmnd->SCp.sent_command = 0;
>  //	printk(" not calling scsi_done on x_ID %Xh, Cmnd %p\n",
>  //			x_ID, Exchanges->fcExchange[ x_ID ].Cmnd);
>        }
>      }
>      else{
> -	Exchanges->fcExchange[ x_ID ].Cmnd->SCp.sent_command = 0;
>        printk(" x_ID %Xh, type %Xh, Cdb0 %Xh\n", x_ID,
>  	Exchanges->fcExchange[ x_ID ].type, 
>  	Exchanges->fcExchange[ x_ID ].Cmnd->cmnd[0]);	      
> @@ -6465,10 +6478,10 @@
>        for( i=0; (i < Cmnd->cmd_len) && i < MAX_COMMAND_SIZE; i++)
>  	*payload++ = Cmnd->cmnd[i];
>  
> -      if( Cmnd->cmd_len == 16 )
> -      {
> -        memcpy( payload, &Cmnd->SCp.buffers_residual, 4);
> -      }
> +      // if( Cmnd->cmd_len == 16 )
> +      // {
> +      //  memcpy( payload, &Cmnd->SCp.buffers_residual, 4);
> +      // }
>        payload+= (16 - i);  
>  
>  		      // FCP_DL is largest number of expected data bytes
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
