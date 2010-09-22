From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] tcm: Add support for BIDI-COMMAND passthrough
Date: Wed, 22 Sep 2010 04:23:31 -0700
Message-ID: <1285154611.1849.39.camel@haakon2.linux-iscsi.org>
References: <1285135724-8329-1-git-send-email-nab@linux-iscsi.org>
	 <4C99DBEA.5000005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C99DBEA.5000005@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-22 at 12:35 +0200, Boaz Harrosh wrote:
> On 09/22/2010 08:08 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds support for BIDI-COMMAND passthrough into TCM Core by adding
> > new struct se_task->task_sg_bidi[] for the TCM/pSCSI backstore case to setup the
> > extra mapping for the SCSI READ payload from T_TASK(cmd)->t_mem_bidi_list.
> > 
> > This patch updates transport_generic_cmd_sequencer() to check for this case
> > with TCM/pSCSI plugin backstores and does the exntra task->task_sg_bidi[] allocation
> > in transport_calc_sg_num().  It also updates transport_generic_get_cdb_count()
> > and transport_do_se_mem_map() to handle the extra task->task_sg_bidi mapping
> > with a second call to transport_map_mem_to_sg().
> > 
> > This nice thing about this patch is that it allows TCM Core to still handle the
> > recieved XDWRITEREAD_* transfer length > backstore max_sectors case transparently.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_transport.c |  105 +++++++++++++++++++++++++++----
> >  include/target/target_core_base.h      |    1 +
> >  2 files changed, 92 insertions(+), 14 deletions(-)
> > 

<SNIP>

> > @@ -7056,6 +7069,7 @@ extern u32 transport_calc_sg_num(
> >  	u32 task_offset)
> >  {
> >  	struct se_cmd *se_cmd = task->task_se_cmd;
> > +	struct se_device *se_dev = SE_DEV(se_cmd);
> >  	struct se_mem *se_mem = in_se_mem;
> >  	struct target_core_fabric_ops *tfo = CMD_TFO(se_cmd);
> >  	u32 sg_length, task_size = task->task_size, task_sg_num_padded;
> > @@ -7127,15 +7141,31 @@ next:
> >  				" task->task_sg\n");
> >  		return 0;
> >  	}
> > -
> >  	sg_init_table(&task->task_sg[0], task_sg_num_padded);
> >  	/*
> > +	 * Setup task->task_sg_bidi for SCSI READ payload for
> > +	 * TCM/pSCSI passthrough if present for BIDI-COMMAND
> > +	 */
> > +	if ((T_TASK(se_cmd)->t_mem_bidi_list != NULL) &&
> > +	    (TRANSPORT(se_dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)) {
> > +		task->task_sg_bidi = kzalloc(task_sg_num_padded *
> > +				sizeof(struct scatterlist), GFP_KERNEL);
> 
> Is there a place where you make sure (task_sg_num_padded * sizeof(struct scatterlist))
> will not be bigger then a PAGE_SIZE?

Hmmm, I believe that the underlying hardcoded TCM struct se_device
max_sectors backstore value that is currently preventing the per struct
se_task->task_sg*[] allocations from getting larger than PAGE_SIZE here,
depending on what is being reported by struct
se_subsystem_api->get_max_sectors() for the individual various TCM
subsystem plugins in IBLOCK, FILEIO, pSCSI, etc.

Do you think we need an explict task_sg_num_padded > PAGE_SIZE check
here for the default sl*b allocators for contigious memory..?

> 
> Is there any chance to convert this code to use sg_alloc_table() with
> an embedded struct sg_table in task-> ?
> 
> >From my experience the use of struct sg_table cleans up the code
> tremendously. (Perhaps put it on some todo list)

Sure I think this would make sense for this case (and mabye others).

Lets make this a .38 item for the moment.  8-)

> > diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> > index b68dea1..b6f3b75 100644
> > --- a/include/target/target_core_base.h
> > +++ b/include/target/target_core_base.h
> > @@ -471,6 +471,7 @@ struct se_transport_task {
> >  struct se_task {
> >  	unsigned char	task_sense;
> >  	struct scatterlist *task_sg;
> > +	struct scatterlist *task_sg_bidi;
> >  	struct scatterlist sgt;
> 	struct sg_table sgt_bidi;
> 
> See the sg_table has the scatterlist * inside
> plus a couple of element counters for allocation/deallocation.
> 

Great, I will keep this point in mind to see where we can streamline SGL
usage and reduce LOC and/or complexity using struct sg_table structure
members.

Thanks Boaz!

--nab
