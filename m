From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] tcm_loop: Add DMA_BIDIRECTIONAL CDB support
Date: Wed, 15 Sep 2010 13:02:17 -0700
Message-ID: <1284580937.13344.9.camel@haakon2.linux-iscsi.org>
References: <1284552412-30567-1-git-send-email-nab@linux-iscsi.org>
	 <4C90D346.1030907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C90D346.1030907@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-15 at 16:08 +0200, Boaz Harrosh wrote:
> On 09/15/2010 02:06 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch series adds DMA_BIDIRECTIONAL CDB to the TCM_Loop Virtual SCSI
> > LLD module.  This includes the following changes:
> > 
> > 	*) Add call to include/scsi/scsi_cmnd.h:scsi_bidi_cmnd() to set
> > 	   TCM struct se_cmd internal data_direction in tcm_loop_allocate_core_cmd()
> > 	*) Update tcm_loop_new_cmd_map() to handle BIDI READ payload from scsi_in()
> > 	*) Drop DMA_BIDIRECTIONAL usage check from tcm_loop_queuecommand()
> > 	*) Add tcm_loop_slave_alloc() and tcm_loop_slave_configure() handlers for
> > 	   struct scsi_host_template to set QUEUE_FLAG_BIDI in the former.
> > 
> > So far this has been tested together with commit 1f8f3eda132c using XDWRITE_READ_10
> > via BSG userspace code on a v2.6.36-rc3 kernel.
> > 
> 
> I'll start the review with this patch. Then we'll move on to the bigger harder one.
> 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   48 ++++++++++++++++++------
> >  1 files changed, 36 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
> > index 644f978..c4139d8 100644
> > --- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
> > +++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
> > @@ -64,6 +64,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
> >  	struct tcm_loop_nexus *tl_nexus = tl_hba->tl_nexus;
> >  	struct tcm_loop_cmd *tl_cmd;
> >  	int sam_task_attr;
> > +	enum dma_data_direction data_direction;
> >  
> >  	if (!(tl_nexus)) {
> >  		scmd_printk(KERN_ERR, sc, "TCM_Loop I_T Nexus"
> > @@ -81,6 +82,13 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
> >  	 * Save the pointer to struct scsi_cmnd *sc
> >  	 */
> >  	tl_cmd->sc = sc;
> > +	/*
> > +	 * Check for scsi_bidi_cmnd() to signal TCM Core for DMA_BIDIRECTIONAL
> > +	 */
> > +	if (scsi_bidi_cmnd(sc))
> > +		data_direction = 
> > +	else
> > +		data_direction = sc->sc_data_direction;
> 
> So you noticed that scsi-ml has a data_direction = DMA_TO_DEVICE and
> scsi_bidi_cmnd(sc) == true. I think you could do the same and code will
> be more simple, see below.
> 
> So for start this here is just droped

Hi Boaz,

Thanks for the previous emails wrt to your comments about
DMA_BIDIRECTIONAL and actual BIDI-COMMAND usage.  This definately
clarifies things for me now, and I will go ahead and drop the incorrect
DMA_BIDIRECTIONAL here.

> 
> >  
> >  	/*
> >  	 * Locate the SAM Task Attr from struct scsi_cmnd *
> > @@ -105,7 +113,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
> >  	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
> >  	 */
> >  	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> > -			scsi_bufflen(sc), sc->sc_data_direction, sam_task_attr,
> > +			scsi_bufflen(sc), data_direction, sam_task_attr,
> 
> And this is dropped

Ditto

> 
> >  			&tl_cmd->tl_sense_buf[0]);
> >  	/*
> >  	 * Locate the struct se_lun pointer and attach it to struct se_cmd
> > @@ -128,14 +136,16 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
> >  /*
> >   * Called by struct target_core_fabric_ops->new_cmd_map()
> >   *
> > - * Always called in process context
> > + * Always called in process context.  A non zero return value
> > + * here will signal to handle an exception based on the return code.
> >   */
> >  int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
> >  {
> >  	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
> >  				struct tcm_loop_cmd, tl_se_cmd);
> >  	struct scsi_cmnd *sc = tl_cmd->sc;
> > -	void *mem_ptr;
> > +	void *mem_ptr, *mem_bidi_ptr = NULL;
> > +	u32 sg_no_bidi = 0;
> >  	int ret;
> >  	/*
> >  	 * Allocate the necessary tasks to complete the received CDB+data
> > @@ -163,6 +173,16 @@ int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
> >  	if (scsi_sg_count(sc)) {
> >  		se_cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM;
> >  		mem_ptr = (void *)scsi_sglist(sc);
> > +		/*
> > +		 * For BIDI commands, pass in the extra READ buffer
> > +		 * to transport_generic_map_mem_to_cmd() below..
> > +		 */
> > +		if (se_cmd->data_direction == DMA_BIDIRECTIONAL) {
> 
> Just change to if (scsi_bidi_cmnd(sc))
> [remember data_direction == DMA_TO_DEVICE]

<nod>

> 
> > +			struct scsi_data_buffer *sdb = scsi_in(sc);
> > +
> > +			mem_bidi_ptr = (void *)sdb->table.sgl;
> > +			sg_no_bidi = sdb->table.nents;
> 
> This is the all bidi secret the presence of the  scsi_in buffer

Makes sense..

> 
> > +		}
> >  	} else {
> >  		/*
> >  		 * Used for DMA_NONE
> > @@ -322,15 +342,6 @@ static int tcm_loop_queuecommand(
> >  	}
> >  	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];transport_get_task
> >  	se_tpg = &tl_tpg->tl_se_tpg;
> > -
> > -	if (sc->sc_data_direction == DMA_BIDIRECTIONAL) {
> > -		spin_lock_irq(host->host_lock);
> > -		printk(KERN_ERR "Unsupported BIDI sc->sc_data_direction: %d\n",
> > -			sc->sc_data_direction);	
> > -		sc->result = host_byte(DID_ERROR);
> > -		(*done)(sc);
> > -		return 0;
> > -	}
> >  	/*
> >  	 * Determine the SAM Task Attribute and allocate tl_cmd and
> >  	 * tl_cmd->tl_se_cmd from TCM infrastructure
> > @@ -446,6 +457,17 @@ release:
> >  	return ret;
> >  }
> >  
> > +static int tcm_loop_slave_alloc(struct scsi_device *sd)
> > +{
> > +	set_bit(QUEUE_FLAG_BIDI, &sd->request_queue->queue_flags);
> 
> Thank got, another new one. We are up to 4

Perfect, I will make these changes to TCM_Loop and follow up on the
larger patch in a moment.

Thanks!

--nab
