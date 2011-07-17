From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 03/20] target: Make all control CDBs scatter-gather
Date: Sun, 17 Jul 2011 12:40:29 -0700
Message-ID: <1310931629.26130.15.camel@haakon2.linux-iscsi.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
	 <1310174329-22228-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59348 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1GQTtl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jul 2011 15:49:41 -0400
In-Reply-To: <1310174329-22228-4-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2011-07-08 at 18:18 -0700, Andy Grover wrote:
> Previously, some control CDBs did not allocate memory in pages for their
> data buffer, but just did a kmalloc. This patch makes all cdbs allocate
> pages.
> 
> This has the benefit of streamlining some paths that had to behave
> differently when we used two allocation methods. The downside is that
> all accesses to the data buffer need to kmap it before use, and need to
> handle data in page-sized chunks if more than a page is needed for a given
> command's data buffer.
> 
> Finally, note that cdbs with no data buffers are handled a little
> differently. Before, SCSI_NON_DATA_CDBs would not call get_mem at all
> (they'd be in the final else in transport_allocate_resources) but now
> these will make it into generic_get_mem, but just not allocate any
> buffers.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c           |    7 -
>  drivers/scsi/qla2xxx/qla_target.c               |    3 -
>  drivers/target/iscsi/iscsi_target.c             |   74 ++---------
>  drivers/target/iscsi/iscsi_target_core.h        |    1 -
>  drivers/target/iscsi/iscsi_target_util.c        |   11 +-
>  drivers/target/target_core_alua.c               |   42 +++++--
>  drivers/target/target_core_cdb.c                |   65 +++++++--
>  drivers/target/target_core_device.c             |    5 +-
>  drivers/target/target_core_pr.c                 |   60 +++++++--
>  drivers/target/target_core_pscsi.c              |   32 +----
>  drivers/target/target_core_transport.c          |  159 ++++++++---------------
>  drivers/target/tcm_fc/tfc_cmd.c                 |    4 +-
>  drivers/target/tcm_fc/tfc_io.c                  |   61 +++------
>  drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c |   21 ---
>  include/target/target_core_base.h               |    5 +-
>  include/target/target_core_transport.h          |    6 +-
>  16 files changed, 232 insertions(+), 324 deletions(-)
> 

<SNIP>

> +void *transport_kmap_first_data_page(struct se_cmd *cmd)
> +{
> +	struct se_mem *se_mem;
> +
> +	BUG_ON(list_empty(&cmd->t_mem_list));
> +
> +	se_mem = list_first_entry(&cmd->t_mem_list, struct se_mem, se_list);
> +
> +	/*
> +	 * 1st se_mem should point to a page, and we shouldn't need more than
> +	 * that for this cmd
> +	 */
> +	BUG_ON(cmd->data_length > PAGE_SIZE);
> +
> +	return kmap(se_mem->se_page);
> +}
> +EXPORT_SYMBOL(transport_kmap_first_data_page);
> +

So this bit was triggering memory corruption with TCM_Loop because the
SCSI ML is using contigious buffers for certain control CDBs in
drivers/scsi/scsi_scan.c and elsewhere:

The follow patch has been committed (post se_mem removal) to honor
sg->offset to make TCM_Loop function as expected:

commit f6e0c5a75a8056def88c4934e055d28499b073d2
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sat Jul 16 22:44:58 2011 -0700

    target: Make transport_kmap_first_data_page honor sg->offset
    
    This patch makes transport_kmap_first_data_page() honor sg->offset, as
    fabrics like tcm_loop need to handle this case for control CDBs generated
    by the SCSI midlayer that are based on a contigious buffer.
    
    This fixes memory corruption with tcm_loop introduced with commit:
    
    commit 0b5660d2eebadc5853cf268d6136aeecbd251d6a
    Author: Andy Grover <agrover@redhat.com>
    Date:   Fri Jul 8 17:25:13 2011 -0700
    
        target: Make all control CDBs scatter-gather
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 372de32..b3c010c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3933,9 +3933,15 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 
 void *transport_kmap_first_data_page(struct se_cmd *cmd)
 {
-       BUG_ON(!cmd->t_data_sg);
+       struct scatterlist *sg = cmd->t_data_sg;
 
-       return kmap(sg_page(cmd->t_data_sg));
+       BUG_ON(!sg);
+       /*
+        * We need to take into account a possible offset here for fabrics like
+        * tcm_loop who may be using a contig buffer from the SCSI midlayer for
+        * control CDBs passed as SGLs via transport_generic_map_mem_to_cmd()
+        */
+       return kmap(sg_page(sg)) + sg->offset;
 }
 EXPORT_SYMBOL(transport_kmap_first_data_page);
 

> +void transport_kunmap_first_data_page(struct se_cmd *cmd)
> +{
> +	struct se_mem *se_mem;
> +
> +	BUG_ON(list_empty(&cmd->t_mem_list));
> +
> +	se_mem = list_first_entry(&cmd->t_mem_list, struct se_mem, se_list);
> +
> +	kunmap(se_mem->se_page);
> +}
> +EXPORT_SYMBOL(transport_kunmap_first_data_page);
> +


