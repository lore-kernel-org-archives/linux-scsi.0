From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] tcm: Add support for BIDI operation and
	XDWRITE_READ_10 emulation
Date: Wed, 15 Sep 2010 13:29:21 -0700
Message-ID: <1284582561.13344.36.camel@haakon2.linux-iscsi.org>
References: <1284552402-30546-1-git-send-email-nab@linux-iscsi.org>
	 <4C90E2F1.4040904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C90E2F1.4040904@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-15 at 17:14 +0200, Boaz Harrosh wrote:
> On 09/15/2010 02:06 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch series adds DMA_BIDIRECTIONAL support to TCM Core.  This
> > includes the following for struct se_cmd to handle BIDI READ payloads using a new
> > struct se_transport_task->t_mem_bidi_list and struct se_transport_task->t_tasks_se_bidi_num.
> > The model used to keep the WRITE payload at struct se_transport_task->t_mem_list,
> > and add a new READ payload memory list at struct se_transport_task->t_mem_bidi_list.
> > 
> > *) desciptor setup:
> > 
> > This patch adds support for XDWRITEREAD_10 within transport_generic_cmd_sequencer(),
> > and sets up the new struct se_cmd->transport_xor_callback() completion function
> > at transport_xor_callback().  It then updates transport_new_cmd_obj() to handle the
> > BIDI READ case.
> > 
> > It also adds support for DMA_BIDIRECTIONAL to transport_generic_map_mem_to_cmd()
> > to setup struct se_transport_task->t_mem_bidi_list for BIDI READ payloads
> > 
> > *) memory mapping:
> > 
> > This patch updates transport_generic_get_cdb_count() to accept a enum dma_data_direction
> > parameter to handle the BIDI and the existing WRITE/READ cases for SCF_SCSI_DATA_SG_IO_CDB.
> > This patch also updates transport_generic_map_mem_to_cmd() to accept a 'void *mem_bidi_in'
> > and 'u32 se_mem_bidi_num' from BIDI capable TCM fabric modules.
> > 
> > It then updates transport_generic_get_task() and struct se_cmd->transport_get_task()
> > to accept a enum dma_data_direction function parameter.
> > 
> > *) descriptor callback:
> > 
> > For the struct se_cmd callback, it updates transport_generic_complete_ok() to support
> > DMA_BIDIRECTIONAL and looks for the new struct se_cmd->transport_xor_callback() in
> > transport_generic_cmd_sequencer() to perform the post READ/WRITE XOR emulation.
> > This also includes the additon of transport_memcpy_se_mem_read_contig() used to copy the
> > WRITE scatterlists into a local contigious buffer for the XOR instructions within
> > transport_xor_callback();
> > 
> > *) descriptor release:
> > 
> > Update transport_free_pages() to walk the new T_TASK(cmd)->t_mem_bidi_list (when available)
> > and release struct se_mem and pages.
> > 
> > So far this has been tested with TCM_Loop using BSG w/ userspace code generating
> > BIDI XDWRITE_READ_10 CDBs.
> > 
> 
> Hi.
> 
> OK so lets see if we can manage with the scsi-ml model of:
> 
> BIDI-COMMANDS ==>  data_direction == DMA_TO_DEVICE && se_transport_task->t_mem_bidi is present

This makes perfect sense..  I will removing the use of DMA_BIDIRECTIONAL
from TCM Core, and follow the above logic to signal BIDI-COMMAND usage.

> 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_transport.c |  282 ++++++++++++++++++++++++++++----
> >  include/target/target_core_base.h      |    9 +-
> >  include/target/target_core_transport.h |   10 +-
> >  3 files changed, 261 insertions(+), 40 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 517a59c..37afc39 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -2529,7 +2529,8 @@ static inline int transport_check_device_cdb_sector_count(
> >  static struct se_task *transport_generic_get_task(
> >  	struct se_transform_info *ti,
> >  	struct se_cmd *cmd,
> > -	void *se_obj_ptr)
> > +	void *se_obj_ptr,
> > +	enum dma_data_direction data_direction)
> 
> We don't need this direction I think

This is required because we expect to have the T_TASK(cmd)->t_mem_list
for BIDI WRITE and T_TASK(cmd)->t_mem_bidi_list for BIDI READ, eg: this
will be called multiple times individually to satisfy the BIDI WRITE and
READ portions of the struct se_cmd.

> 
> >  {
> >  	struct se_task *task;
> >  	struct se_device *dev = SE_DEV(cmd);
> > @@ -2625,7 +2626,8 @@ static int transport_process_control_sg_transform(
> >  		return -1;
> >  	}
> >  
> > -	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr);
> > +	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr,
> > +				cmd->data_direction);
> 
> I can't seem to find the changed implementation of cmd->transport_get_task
> in this patch or the next one. But it seems this here is just a pass throw
> to cmd->transport_get_task so the argument should go there.

Yes, cmd->transport_get_task() translates to the above
transport_generic_get_task().  It is slightly confusing, and I may end
up dropping this now and just use transport_generic_get_task() directly
in a seperate patch, so please ignore this for the moment..  :-)

> 
> >  	if (!(task))
> >  		return -1;
> >  
> > @@ -2665,7 +2667,8 @@ static int transport_process_control_nonsg_transform(
> >  	unsigned char *cdb;
> >  	struct se_task *task;
> >  
> > -	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr);
> > +	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr,
> > +				cmd->data_direction);
> 
> Same
> 
> >  	if (!(task))
> >  		return -1;
> >  
> > @@ -2699,7 +2702,8 @@ static int transport_process_non_data_transform(
> >  	unsigned char *cdb;
> >  	struct se_task *task;
> >  
> > -	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr);
> > +	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr,
> > +				cmd->data_direction);
> 
> Same
> 
> >  	if (!(task))
> >  		return -1;
> >  
> > @@ -5183,6 +5187,54 @@ int transport_generic_emulate_request_sense(
> >  }
> >  EXPORT_SYMBOL(transport_generic_emulate_request_sense);
> >  
> > +static void transport_xor_callback(struct se_cmd *cmd)
> > +{
> > +	unsigned char *buf, *addr;
> > +	struct se_mem *se_mem;
> > +	unsigned int offset;
> > +	int i;
> > +	/*
> > +	 * From sbc3r22.pdf section 5.48 XDWRITEREAD (10) command
> > +	 * 
> > +	 * 1) read the specified logical block(s);
> > +	 * 2) transfer logical blocks from the data-out buffer;
> > +	 * 3) XOR the logical blocks transferred from the data-out buffer with
> > +	 *    the logical blocks read, storing the resulting XOR data in a buffer;
> > +	 * 4) if the DISABLE WRITE bit is set to zero, then write the logical
> > +	 *    blocks transferred from the data-out buffer; and
> > +	 * 5) transfer the resulting XOR data to the data-in buffer.
> > +	 */
> > +	buf = kmalloc(cmd->data_length, GFP_KERNEL);
> > +	if (!(buf)) {
> > +		printk(KERN_ERR "Unable to allocate xor_callback buf\n");
> > +		return;
> > +	}
> > +	/*
> > +	 * Copy the scatterlist WRITE buffer located at T_TASK(cmd)->t_mem_list
> > +	 * into the locally allocated *buf
> > +	 */
> > +	transport_memcpy_se_mem_read_contig(cmd, buf, T_TASK(cmd)->t_mem_list);
> 
> This is not relevant to our discussion but did you copy the out-buffer to a
> contiguous buffer so not to juggle a double-list traversal? Or am I missing
> something more cardinal.
> 

Yeah, I was simply following what scsi_debug.c currently does in this
regard.

> If so the a TODO: comment might be in place. Surely it's possible to walk
> two sg-list lists and xor them.

The thing is that we are dealing with the linked list struct se_mem
style memory here, and not a struct scatterlist array and/or chained
links.  This is because the scatterlists live in struct
se_task->task_sg[] which are arrays that be mapped out into the TCM
struct se_subsystem_api to IBLOCK, FILEIO, pSCSI, etc.

There is actually a case for HW target mode in
transport_do_task_sg_chain() where we chain together each of the struct
se_task->task_sg[] in order to use pci_map_sg() here..  I was thinking
about doing something similar for BIDI (and I still need to look at BIDI
for HW target mode), but really it's more trouble than it's worth using
it here.

> 
> > +	/*
> > +	 * Now perform the XOR against the BIDI read memory located at
> > +	 * T_TASK(cmd)->t_mem_bidi_list
> > +	 */
> > +
> > +	offset = 0;
> > +	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_bidi_list, se_list) {
> > +		addr = (unsigned char *)kmap_atomic(se_mem->se_page, KM_USER0);
> > +		if (!(addr))
> > +			goto out;
> > +
> > +		for (i = 0; i < se_mem->se_len; i++)
> > +			*(addr + se_mem->se_off + i) ^= *(buf + offset + i);
> > +
> > +		offset += se_mem->se_len;
> > +		kunmap_atomic(addr, KM_USER0);
> > +	}
> > +out:
> > +	kfree(buf);
> > +}
> > +
> >  /*
> >   * Used to obtain Sense Data from underlying Linux/SCSI struct scsi_cmnd
> >   */
> > @@ -5472,6 +5524,25 @@ static int transport_generic_cmd_sequencer(
> >  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> >  		ret = TGCS_DATA_SG_IO_CDB;
> >  		break;
> > +	case XDWRITEREAD_10:
> > +		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
> > +		if (cmd->data_direction != DMA_BIDIRECTIONAL)
> > +			return TGCS_INVALID_CDB_FIELD;
> 
> Just check for the presences of the bidi_list. Where is it?

Ok, this will become a:

	if (cmd->data_direction != DMA_TO_DEVICE)

check, because the t_mem_bidi_list has not been setup at this point..

> 
> > +		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
> > +		if (sector_ret)
> > +			return TGCS_UNSUPPORTED_CDB;
> > +		size = transport_get_size(sectors, cdb, cmd);
> > +		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
> > +		transport_get_maps(cmd);
> > +		cmd->transport_split_cdb = &split_cdb_XX_10;
> > +		cmd->transport_get_lba = &transport_lba_32;
> > +		/*
> > +		 * Setup BIDI XOR callback to be run during transport_generic_complete_ok()
> > +		 */
> > +		cmd->transport_xor_callback = &transport_xor_callback;
> > +		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> > +		ret = TGCS_DATA_SG_IO_CDB;
> > +		break;
> >  	case 0xa3:
> >  		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
> >  		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
> > @@ -5842,9 +5913,10 @@ static int transport_generic_cmd_sequencer(
> >  
> >  		cmd->cmd_spdtl = size;
> >  
> > -		if (cmd->data_direction == DMA_TO_DEVICE) {
> > +		if ((cmd->data_direction == DMA_TO_DEVICE) ||
> > +		    (cmd->data_direction == DMA_BIDIRECTIONAL)) {
> >  			printk(KERN_ERR "Rejecting underflow/overflow"
> > -					" WRITE data\n");
> > +					" WRITE or BIDI data\n");
> 
> The data_direction == DMA_TO_DEVICE will stay with our alternate model
> so this does not change

<nod>

> 
> >  			return TGCS_INVALID_CDB_FIELD;
> >  		}
> >  		/*
> > @@ -6096,6 +6168,33 @@ void transport_memcpy_read_contig(
> >  }
> >  EXPORT_SYMBOL(transport_memcpy_read_contig);
> >  
> > +void transport_memcpy_se_mem_read_contig(
> > +	struct se_cmd *cmd,
> > +	unsigned char *dst,
> > +	struct list_head *se_mem_list)
> > +{
> > +	struct se_mem *se_mem;
> > +	void *src;
> > +	u32 length = 0, total_length = cmd->data_length;
> > +
> > +	list_for_each_entry(se_mem, se_mem_list, se_list) {
> > +		length = se_mem->se_len;
> > +		
> > +		if (length > total_length)
> > +			length = total_length;
> > +
> > +		src = page_address(se_mem->se_page) + se_mem->se_off;
> > +		
> > +		memcpy(dst, src, length);
> > +
> > +		if (!(total_length -= length))
> > +			return;
> > +
> > +		dst += length;
> > +	}
> > +}
> > +
> > +
> >  /*     transport_generic_passthrough():
> >   *
> >   *
> > @@ -6252,6 +6351,18 @@ void transport_generic_complete_ok(struct se_cmd *cmd)
> >  
> >  	switch (cmd->data_direction) {
> >  	case DMA_FROM_DEVICE:
> > +	case DMA_BIDIRECTIONAL:
> > +		/*
> > +		 * Check for the XOR BIDI callback emulation for XD_WRITEREAD_*
> > +		 */
> > +		if (cmd->transport_xor_callback) {
> 
> What? this one place is a bad hack. There are 200 and some BIDI commands in the
> scsi-protocol. XOR is just a small group of them. Do you intend to add such an if
> for every command type? I don't think so. The target in question should just be
> able to proprly hook into the transport_complete mechanics and clean after itself
> some how. What does the cmd->transport_xor_callback do? Why no just do a:
> 
> if (cmd->transport_complete__callback)
> 	cmd->transport_complete_callback(cmd);
> 
> for any kind of direction, as a target set policy. (When there are chained
> processing to do)

Hmmmmm, the thing is that this particular xor callback is not required
for non XOR BIDI operation, but point taken on naming it something
generic.  I do agree that a cmd->transport_complete_callback() may be
more useful for this.



> 
> > +			/*
> > +			 * For fully emulated HBAs, this will translate to
> > +			 * transport_xor_callback()
> > +			 */
> > +			cmd->transport_xor_callback(cmd);
> > +		}
> > +
> 
> >  		spin_lock(&cmd->se_lun->lun_sep_lock);
> >  		if (SE_LUN(cmd)->lun_sep) {
> >  			SE_LUN(cmd)->lun_sep->sep_stats.tx_data_octets +=
> > @@ -6347,6 +6458,23 @@ static inline void transport_free_pages(struct se_cmd *cmd)
> >  		kmem_cache_free(se_mem_cache, se_mem);
> >  	}
> >  
> > +	if (T_TASK(cmd)->t_mem_bidi_list && T_TASK(cmd)->t_tasks_se_bidi_num) {
> 
> See here: we have a buffer we take care of it. Simple

<nod>

> 
> > +		list_for_each_entry_safe(se_mem, se_mem_tmp,
> > +				T_TASK(cmd)->t_mem_bidi_list, se_list) {
> > +			/*
> > +			 * We only release call __free_page(struct se_mem->se_page) when
> > +			 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
> > +			 */
> > +			if (free_page)
> > +				__free_page(se_mem->se_page);
> > +
> > +			list_del(&se_mem->se_list);
> > +			kmem_cache_free(se_mem_cache, se_mem);
> > +		}
> > +	}
> > +
> > +	kfree(T_TASK(cmd)->t_mem_bidi_list);
> > +	T_TASK(cmd)->t_mem_bidi_list = NULL;
> >  	kfree(T_TASK(cmd)->t_mem_list);
> >  	T_TASK(cmd)->t_mem_list = NULL;
> >  	T_TASK(cmd)->t_tasks_se_num = 0;
> > @@ -6477,18 +6605,34 @@ release_cmd:
> >  int transport_generic_map_mem_to_cmd(
> >  	struct se_cmd *cmd,
> >  	void *mem,
> > -	u32 se_mem_num)
> > +	u32 se_mem_num,
> > +	void *mem_bidi_in,
> > +	u32 se_mem_bidi_num)
> >  {
> >  	u32 se_mem_cnt_out = 0;
> >  	int ret;
> >  
> >  	if (!(mem) || !(se_mem_num))
> >  		return 0;
> > +
> > +	if ((cmd->data_direction == DMA_BIDIRECTIONAL) &&
> > +	    (!(mem_bidi_in) || !(se_mem_bidi_num))) {
> > +		printk(KERN_ERR "Unable to process DMA_BIDIRECTIONAL with mem_bidi_in:"
> > +			" %p and se_mem_bidi_num: %u\n", mem_bidi_in, se_mem_bidi_num);
> > +		return -EINVAL;
> > +	}
> > +
> 
> In our new model this just drops. Because only one member caries information. mem_bidi_in
> is the flag for bidi presence.

<nod>

> 
> >  	/*
> >  	 * Passed *mem will contain a list_head containing preformatted
> >  	 * struct se_mem elements...
> >  	 */
> >  	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM)) {
> > +		if (cmd->data_direction == DMA_BIDIRECTIONAL) {
> > +			printk(KERN_ERR "SCF_CMD_PASSTHROUGH_NOALLOC not supported"
> > +				" with DMA_BIDIRECTIONAL\n");
> > +			return -ENOSYS;
> 
> What is the issue here. Why can't we bidi in this case?

This assumes incoming struct se_mem memory for *mem, and not struct
scatterlist.  This flag is only used for some special internal
passthrough cases for getting INQUIRY, et al, so this is just a safety
check..

> 
> > +		}
> > +
> >  		T_TASK(cmd)->t_mem_list = (struct list_head *)mem;
> >  		T_TASK(cmd)->t_tasks_se_num = se_mem_num;
> >  		cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH_NOALLOC;
> > @@ -6507,14 +6651,35 @@ int transport_generic_map_mem_to_cmd(
> >  		 */ 
> >  		T_TASK(cmd)->t_mem_list = transport_init_se_mem_list();
> >  		if (!(T_TASK(cmd)->t_mem_list))
> > -			return -1;
> > +			return -ENOMEM;
> >  
> >  		ret = transport_map_sg_to_mem(cmd,
> >  			T_TASK(cmd)->t_mem_list, mem, &se_mem_cnt_out);
> >  		if (ret < 0)
> > -			return -1;
> > +			return -ENOMEM;
> 
> These two belong to another patch right?

Sorry, Konrad has got me doing this conversion automatically now..

> 
> >  
> >  		T_TASK(cmd)->t_tasks_se_num = se_mem_cnt_out;
> > +		/*
> > +		 * Setup BIDI READ list of struct se_mem elements
> > +		 */
> > +		if (cmd->data_direction == DMA_BIDIRECTIONAL) {
> 
> Just if (mem_bidi_in) no?

<nod>

> 
> > +			T_TASK(cmd)->t_mem_bidi_list = transport_init_se_mem_list();
> > +			if (!(T_TASK(cmd)->t_mem_bidi_list)) {
> > +				kfree(T_TASK(cmd)->t_mem_list);
> > +				return -ENOMEM;
> > +			}
> > +			se_mem_cnt_out = 0;
> > +
> > +			ret = transport_map_sg_to_mem(cmd,
> > +				T_TASK(cmd)->t_mem_bidi_list, mem_bidi_in,
> > +				&se_mem_cnt_out);
> > +			if (ret < 0) {
> > +				kfree(T_TASK(cmd)->t_mem_list);
> > +				return -ENOMEM;
> > +			}
> > +
> > +			T_TASK(cmd)->t_tasks_se_bidi_num = se_mem_cnt_out;
> > +		}	
> >  		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
> >  
> >  	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> > @@ -6610,6 +6775,11 @@ non_scsi_data:
> >   */
> >  int transport_generic_do_transform(struct se_cmd *cmd, struct se_transform_info *ti)
> >  {
> > +	if (!(cmd->transport_cdb_transform)) {
> > +		dump_stack();
> > +		return -1;
> > +	}
> > +	
> >  	if (cmd->transport_cdb_transform(cmd, ti) < 0)
> >  		return -1;
> >  
> > @@ -6656,9 +6826,9 @@ int transport_new_cmd_obj(
> >  	struct se_transform_info *ti,
> >  	int post_execute)
> >  {
> > -	u32 task_cdbs = 0;
> > -	struct se_mem *se_mem_out = NULL;
> >  	struct se_device *dev = SE_DEV(cmd);
> > +	enum dma_data_direction data_direction;
> > +	u32 task_cdbs = 0, rc;
> >  
> >  	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)) {
> >  		task_cdbs++;
> > @@ -6666,11 +6836,38 @@ int transport_new_cmd_obj(
> >  	} else {
> >  		ti->ti_set_counts = 1;
> >  		ti->ti_dev = dev;
> > -
> > +		/*
> > +		 * Setup any BIDI READ tasks and memory from
> > +		 * T_TASK(cmd)->t_mem_bidi_list so the READ struct se_tasks
> > +		 * are queued first..
> > +		 */
> > +		if (cmd->data_direction == DMA_BIDIRECTIONAL) {
> 
> if (T_TASK(cmd)->t_mem_bidi_list)
> 

<nod>

> > +			rc = transport_generic_get_cdb_count(cmd, ti,
> > +				T_TASK(cmd)->t_task_lba,
> > +				T_TASK(cmd)->t_tasks_sectors,
> > +				DMA_FROM_DEVICE, T_TASK(cmd)->t_mem_bidi_list);
> > +			if (!(rc)) {
> > +				cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> > +				cmd->scsi_sense_reason =
> > +					TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> > +				return PYX_TRANSPORT_LU_COMM_FAILURE;
> > +			}
> > +			ti->ti_set_counts = 0;
> > +			/*
> > +			 * Setup the DMA_TO_DEVICE direction for the next
> > +			 * call to transport_generic_get_cdb_count()
> > +			 */
> > +			data_direction = DMA_TO_DEVICE;
> 
> If I understand this code correctly. Then this here is wrong. You are assuming a XOR operation
> where we read some data then write some when that's finish. But other BIDI commands might be different
> they might write first then read. Or they might might read and write in parallel. Any such decisions
> should be left to the target to make. And at a per-command basis.

Ahhh OK, then I will have to signal this in struct se_cmd within
transport_generic_cmd_sequencer() depending on the type of XOR.  This
will be XOR_READ_THEN_WRITE for XDWRITE_READ_10, and will add a
XOR_WRITE_THEN_READ for future CDB emulation..

> 
> I know that in stgt (In user mode) the backend (what you call target, right) receives both buffers
> and decides what to do with them then calls complete.
> 
> If you need any cache flushing and such. Then the DMA_TO_DEVICE main-buffer is flushed before hand
> amd the bidi_read buffer if present is flushed after-hand (or is that the other way) but the generic
> layer should no assume any ordering or execution.
> 
> Please explain why you had to set the direction here. What would not happen if you did not.

The "data_direction = DMA_TO_DEVICE;" assignment here was simlpy because
of the TCM Core internal use of DMA_BIDIRECTIONAL.  This will be going
away following your comments..

> 
> > +		} else
> > +			data_direction = cmd->data_direction;
> > +		/*
> > +		 * Setup the tasks and memory from T_TASK(cmd)->t_mem_list
> > +		 * Note for BIDI transfers this will contain the WRITE payload
> > +		 */
> >  		task_cdbs = transport_generic_get_cdb_count(cmd, ti,
> >  				T_TASK(cmd)->t_task_lba,
> >  				T_TASK(cmd)->t_tasks_sectors,
> > -				NULL, &se_mem_out);
> > +				data_direction,	T_TASK(cmd)->t_mem_list);
> >  		if (!(task_cdbs)) {
> >  			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> >  			cmd->scsi_sense_reason =
> > @@ -6743,7 +6940,17 @@ int transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
> >  
> >  	T_TASK(cmd)->t_mem_list = transport_init_se_mem_list();
> >  	if (!(T_TASK(cmd)->t_mem_list))
> > -		return -1;
> > +		return -ENOMEM;
> > +	/*
> > +	 * Setup BIDI READ list of struct se_mem elements
> > +	 */
> > +	if (cmd->data_direction == DMA_BIDIRECTIONAL) {
> 
> If (T_TASK(cmd)->t_mem_bidi_list)
> And the second check just drops

This is not setup yet, so we will need another method to signal
BIDI-COMMANDS.

> 
> > +		T_TASK(cmd)->t_mem_bidi_list = transport_init_se_mem_list();
> > +		if (!(T_TASK(cmd)->t_mem_bidi_list)) {
> > +			kfree(T_TASK(cmd)->t_mem_list);
> > +			return -ENOMEM;
> > +		}
> > +	}
> >  
> >  	while (length) {
> >  		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
> > @@ -7240,28 +7447,28 @@ u32 transport_generic_get_cdb_count(
> >  	struct se_transform_info *ti,
> >  	unsigned long long starting_lba,
> >  	u32 sectors,
> > -	struct se_mem *se_mem_in,
> > -	struct se_mem **se_mem_out)
> > +	enum dma_data_direction data_direction,
> > +	struct list_head *mem_list)
> 
> Note for me:
> You moved from an se_mem * to a struct list_head *, than also added a direction.
> 
> >  {
> >  	unsigned char *cdb = NULL;
> >  	struct se_task *task;
> > -	struct se_mem *se_mem, *se_mem_lout = NULL;
> > +	struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
> >  	struct se_device *dev = SE_DEV(cmd);
> >  	int max_sectors_set = 0, ret;
> >  	u32 task_offset_in = 0, se_mem_cnt = 0, task_cdbs = 0;
> >  	unsigned long long lba;
> >  
> > -	if (!se_mem_in) {
> > -		list_for_each_entry(se_mem_in, T_TASK(cmd)->t_mem_list, se_list)
> > -			break;
> > -
> > -		if (!se_mem_in) {
> > -			printk(KERN_ERR "se_mem_in is NULL\n");
> > -			return 0;
> > -		}
> > +	if (!mem_list) {
> > +		printk(KERN_ERR "mem_list is NULL in transport_generic_get"
> > +				"_cdb_count()\n");
> > +		return 0;
> >  	}
> > -	se_mem = se_mem_in;
> > -
> > +	/*
> > +	 * While using RAMDISK_DR backstores is the only case where
> > +	 * mem_list will ever be empty at this point.
> > +	 */
> > +	if (!(list_empty(mem_list)))
> > +		se_mem = list_entry(mem_list->next, struct se_mem, se_list);
> >  	/*
> >  	 * Locate the start volume segment in which the received LBA will be
> >  	 * executed upon.
> > @@ -7280,7 +7487,12 @@ u32 transport_generic_get_cdb_count(
> >  			CMD_TFO(cmd)->get_task_tag(cmd), lba, sectors,
> >  			transport_dev_end_lba(dev));
> >  
> > -		task = cmd->transport_get_task(ti, cmd, dev);
> > +		if (!(cmd->transport_get_task)) {
> > +			dump_stack();
> > +			goto out;
> > +		}
> > +
> > +		task = cmd->transport_get_task(ti, cmd, dev, data_direction);
> 
> Again this mysterious cmd->transport_get_task(). What I don't understand is if
> the transport (The transport is the fabric right? like iscsi or tcm_loop) wants
> to give you the next task to preform. Then it should know better then anybody
> what kind of command it is, No? what is the data_direction used for?

Ok, the usage of the 'transport' is really confusion here.  These are
allocating struct se_task to be mapped from struct se_task->task_sg[]
and then dispatched via struct se_subsystem_api->do_task() into IBLOCK,
FILEIO, PSCSI, et al. subsystem plugin code.  The reason why enum
dma_data_direction is passing this around is because the data_direction
type is currently stored in each struct se_subsystem_api I/O descriptor.

We would always add a struct se_subsystem_api->get_dma_dir() caller, but
this may be overkill.  Passing the data_direction into the functions is
still a clear method I think.

> 
> >  		if (!(task))
> >  			goto out;
> >  
> > @@ -7293,7 +7505,7 @@ u32 transport_generic_get_cdb_count(
> >  		task->task_size = (task->task_sectors *
> >  				   DEV_ATTRIB(dev)->block_size);
> >  		task->transport_map_task = transport_dev_get_map_SG(dev,
> > -					cmd->data_direction);
> > +					data_direction);
> >  
> >  		cdb = TRANSPORT(dev)->get_cdb(task);
> >  		if ((cdb)) {
> > @@ -7306,14 +7518,13 @@ u32 transport_generic_get_cdb_count(
> >  		 * Perform the SE OBJ plugin and/or Transport plugin specific
> >  		 * mapping for T_TASK(cmd)->t_mem_list.
> >  		 */
> > -		ret = transport_do_se_mem_map(dev, task,
> > -				T_TASK(cmd)->t_mem_list, NULL, se_mem,
> > -				&se_mem_lout, &se_mem_cnt, &task_offset_in);
> > +		ret = transport_do_se_mem_map(dev, task, mem_list,
> > +				NULL, se_mem, &se_mem_lout, &se_mem_cnt,
> > +				&task_offset_in);
> >  		if (ret < 0)
> >  			goto out;
> >  
> >  		se_mem = se_mem_lout;
> > -		*se_mem_out = se_mem_lout;
> 
> I don't understand these changes. I'm out of context. It looks like most of them
> are not relevant to the bidi issue, and are cleanups where now you don't need
> the *se_mem_out results and it was just dropped. (Perhaps because no body used it)
> is that relevant to BIDI? Or you just took the chance of removing a parameter when
> you had to add one. (I hope the data_direction will not be needed after all)

Sorry yeah, this was one non BIDI related cleanup that was included in
the series.  Please ignore.

So I will look at making the necessary changes to
lio-core-2.6.git/lio-4.0 with a follow up patch this afternoon, and
respin a BIDI new series for you to review.

Many thanks for your very helpful comments!

--nab
