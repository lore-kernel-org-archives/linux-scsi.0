From: Thomas Tonino <ttonino@corp.home.nl>
Subject: Re: QLA2200 driver
Date: Thu, 13 Jun 2002 13:53:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D0887A0.4090802@corp.home.nl>
References: <3CC7E9E0.5050107@corp.home.nl> <1019754409.2413.2.camel@lvadp.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew@fc.hp.com>
Cc: linux-scsi@vger.kernel.org

Andrew Patterson wrote:

>>The Qlogic fibre driver in 2.4.18 crashes very quickly in this setup, 
>>with the message "qlogicfc0 : no handle slots, this should not happen". 
>>This crash happens after writing less than 100GB of data to the JBODs.
>> 
> I have included a patch below that fixes this problem.  It works on
> 2.4.17.  I haven't tested it on 2.4.17.

I've used it on 2.4.19pre9aa2. I wanted to use the highio facility, so 
decided to go back to the in-kernel driver which is patched for that in 
2.4.19pre9aa2. Patch applied without problems, and the system is now up 
for a day, while the driver in 2.4.18 would die in around 15 minutes 
with the same use.

Thanks for making the patch available. I guess it is safe to put it in 
the kernel. Please note that the driver as in 2.4.18 is useless - at 
least for me, when using more than 6 drives as targets in a loop.

Thanks for the great help,


Thomas


> --- linux.orig/drivers/scsi/qlogicfc.c	Fri Apr 27 14:59:19 2001
> +++ linux/drivers/scsi/qlogicfc.c	Sun Aug  5 13:32:32 2001
> @@ -14,6 +14,11 @@
>   * General Public License for more details.
>   */
>  
> +/* Added fix for handle slot full error and command queuing logic
> + * Jeff Mast <jeff@mastfamily.com> 
> + * Andrew Patterson <andrew_patterson@hp.com>
> + */
> +
>  /* Renamed and updated to 1.3.x by Michael Griffith <grif@cs.ucr.edu> */
>  
>  /* This is a version of the isp1020 driver which was modified by
> @@ -23,6 +28,8 @@
>   * by Jakub Jelinek <jakub@redhat.com>.
>   */
>  
> +/* Test mods to attempt to prevent handle slot fillup */
> +
>  /*
>   * $Date: 1995/09/22 02:23:15 $
>   * $Revision: 0.5 $
> @@ -669,8 +676,8 @@
>  	struct init_cb control_block;
>  	int adapter_state;
>  	unsigned long int tag_ages[QLOGICFC_MAX_ID + 1];
> -	Scsi_Cmnd *handle_ptrs[QLOGICFC_REQ_QUEUE_LEN + 1];
> -	unsigned long handle_serials[QLOGICFC_REQ_QUEUE_LEN + 1];
> +	Scsi_Cmnd *handle_ptrs[QLOGICFC_MAX_HANDLES];
> +	unsigned long handle_serials[QLOGICFC_MAX_HANDLES];
>  	struct id_name_map port_db[QLOGICFC_MAX_ID + 1];
>  	u_char mbox_done;
>  	u64 wwn;
> @@ -779,6 +786,7 @@
>  			}
>  			hostdata->req = hostdata->res + (RES_QUEUE_LEN + 1)*QUEUE_ENTRY_LEN;
>  			hostdata->queued = 0;
> +
>  			/* set up the control block */
>  			hostdata->control_block.version = 0x1;
>  			hostdata->control_block.firm_opts = cpu_to_le16(0x800e);
> @@ -1156,7 +1164,6 @@
>  	return buf;
>  }
>  
> -
>  /*
>   * The middle SCSI layer ensures that queuecommand never gets invoked
>   * concurrently with itself or the interrupt handler (though the
> @@ -1173,6 +1180,8 @@
>  	struct Continuation_Entry *cont;
>  	struct Scsi_Host *host;
>  	struct isp2x00_hostdata *hostdata;
> +   	short req_q_count;
> +   	u_short  req_count;
>  
>  	ENTER("isp2x00_queuecommand");
>  
> @@ -1207,6 +1216,36 @@
>  	DEBUG(printk("qlogicfc%d : request queue depth %d\n", hostdata->host_id,
>  		     REQ_QUEUE_DEPTH(in_ptr, out_ptr)));
>  
> +
> +   /* Calculate number of entries and segments required. */
> +   sg_count = 0;
> +   req_count = 1;
> +   if ( Cmnd->use_sg ) { 
> +      /* 4.10 64 bit S/G Data Transfer */
> +      sg = (struct scatterlist *) Cmnd->request_buffer;
> +      sg_count = pci_map_sg(hostdata->pci_dev,
> +                              sg,Cmnd->use_sg, 
> +                              scsi_to_pci_dma_dir(Cmnd->sc_data_direction));
> +
> +      if( sg_count > DATASEGS_PER_COMMAND ) {
> +        req_count += (u_short)(sg_count - DATASEGS_PER_COMMAND) / DATASEGS_PER_CONT;
> +        if( (u_short)(sg_count - DATASEGS_PER_COMMAND) % DATASEGS_PER_CONT )
> +            req_count++;
> +      }
> +   } else if( Cmnd->request_bufflen ) {   /* no S/G Data Transfer */
> +        sg_count = 1;
> +   }
> +
> +   /* Calculate number of free request q out entries. */
> +   if( in_ptr < out_ptr )
> +       req_q_count = out_ptr - in_ptr;
> +   else
> +       req_q_count = QLOGICFC_REQ_QUEUE_LEN - (in_ptr - out_ptr);
> +
> +   /* If no room for request in request ring. */
> +   if ( (u_short)(req_count + DATASEGS_PER_COMMAND) >= req_q_count )
> +      return 1;
> +
>  	cmd = (struct Command_Entry *) &hostdata->req[in_ptr*QUEUE_ENTRY_LEN];
>  	in_ptr = (in_ptr + 1) & QLOGICFC_REQ_QUEUE_LEN;
>  	if (in_ptr == out_ptr) {
> @@ -1242,20 +1281,23 @@
>  	memset(cmd, 0, sizeof(struct Command_Entry));
>  
>  	/* find a free handle mapping slot */
> -	for (i = in_ptr; i != (in_ptr - 1) && hostdata->handle_ptrs[i]; i = ((i + 1) % (QLOGICFC_REQ_QUEUE_LEN + 1)));
> +	for (i=0; i<QLOGICFC_MAX_HANDLES && hostdata->handle_ptrs[i]; i++)
> +		;
>  
>  	if (!hostdata->handle_ptrs[i]) {
>  		cmd->handle = cpu_to_le32(i);
>  		hostdata->handle_ptrs[i] = Cmnd;
>  		hostdata->handle_serials[i] = Cmnd->serial_number;
>  	} else {
> +		int counter = 0;
>  		printk("qlogicfc%d : no handle slots, this should not happen.\n", hostdata->host_id);
>  		printk("hostdata->queued is %x, in_ptr: %x\n", hostdata->queued, in_ptr);
> -		for (i = 0; i <= QLOGICFC_REQ_QUEUE_LEN; i++){
> +		for (i = 0; i <= QLOGICFC_MAX_HANDLES; i++){
>  			if (!hostdata->handle_ptrs[i]){
> -				printk("slot %d has %p\n", i, hostdata->handle_ptrs[i]);
> +				counter++;
>  			}
>  		}
> +		printk("full handles slots = %d of %d\n", counter, QLOGICFC_MAX_HANDLES);
>  		return 1;
>  	}
>  
> @@ -1382,7 +1424,10 @@
>  
>  	hostdata->queued++;
>  
> -	num_free = QLOGICFC_REQ_QUEUE_LEN - REQ_QUEUE_DEPTH(in_ptr, out_ptr);
> +	if ( in_ptr > out_ptr )
> +		num_free = QLOGICFC_REQ_QUEUE_LEN - REQ_QUEUE_DEPTH(in_ptr, out_ptr);
> +	else
> +		num_free = QLOGICFC_REQ_QUEUE_LEN - REQ_QUEUE_DEPTH(out_ptr, in_ptr);
>  	num_free = (num_free > 2) ? num_free - 2 : 0;
>  	host->can_queue = hostdata->queued + num_free;
>  	if (host->can_queue > QLOGICFC_REQ_QUEUE_LEN)
> @@ -1401,7 +1446,6 @@
>  	return 0;
>  }
>  
> -
>  /* we have received an event, such as a lip or an RSCN, which may mean that
>   * our port database is incorrect so the port database must be recreated.
>   */
> @@ -1431,7 +1475,7 @@
>  			printk("\n");
>  		}
>  		
> -	        for (i = 0; i < QLOGICFC_REQ_QUEUE_LEN; i++){ 
> +	        for (i = 0; i < QLOGICFC_MAX_HANDLES; i++){ 
>  		        if (hostdata->handle_ptrs[i] && (hostdata->port_db[hostdata->handle_ptrs[i]->target].loop_id > QLOGICFC_MAX_LOOP_ID || hostdata->adapter_state & AS_REDO_LOOP_PORTDB)){
>                                  if (hostdata->port_db[hostdata->handle_ptrs[i]->target].loop_id != hostdata->port_db[0].loop_id){
>  					Scsi_Cmnd *Cmnd = hostdata->handle_ptrs[i];
> @@ -1764,11 +1808,11 @@
>  	host = Cmnd->host;
>  	hostdata = (struct isp2x00_hostdata *) host->hostdata;
>  
> -	for (i = 0; i < QLOGICFC_REQ_QUEUE_LEN; i++)
> +	for (i = 0; i < QLOGICFC_MAX_HANDLES; i++)
>  		if (hostdata->handle_ptrs[i] == Cmnd)
>  			break;
>  
> -	if (i == QLOGICFC_REQ_QUEUE_LEN){
> +	if (i == QLOGICFC_MAX_HANDLES){
>  		return SUCCESS;
>  	}
>  
> --- linux.orig/drivers/scsi/qlogicfc.h	Mon Jun 26 13:02:16 2000
> +++ linux/drivers/scsi/qlogicfc.h	Sun Aug  5 13:33:40 2001
> @@ -70,7 +70,8 @@
>  #define DATASEGS_PER_CONT 7
>  #endif
>  
> -#define QLOGICFC_REQ_QUEUE_LEN	127	/* must be power of two - 1 */
> +#define QLOGICFC_MAX_HANDLES	1024	
> +#define QLOGICFC_REQ_QUEUE_LEN	255	/* must be power of two - 1 */
>  #define QLOGICFC_MAX_SG(ql)	(DATASEGS_PER_COMMAND + (((ql) > 0) ? DATASEGS_PER_CONT*((ql) - 1) : 0))
>  #define QLOGICFC_CMD_PER_LUN    8
>  
> 
> 
> 


