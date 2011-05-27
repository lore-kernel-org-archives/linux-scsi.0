From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/42 RESEND+NEW] Target updates for May 27
Date: Fri, 27 May 2011 15:15:40 -0700
Message-ID: <1306534540.23461.203.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34377 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1E0WX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 18:23:57 -0400
In-Reply-To: <1306523240-15543-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Fri, 2011-05-27 at 12:06 -0700, Andy Grover wrote:
> Hi Nicholas,
> 
> The first 24 are a resend (rebased to current lio-41 git) of patches
> from a couple weeks ago.
> 
> The last 18 are new. They include some misc. cleanups, but the heart
> of what they do is to allocate the memory for data buffers in the
> fabric (and from fabric cxt), instead of the core. This saves two context
> switches per command. It also reduces code size, since we no longer need
> to synchronize between the two threads, and we have more direct knowledge
> about the layout of the data buffer.
> 
> iscsi fabric does not rely on se_cmd->t_mem_list at all anymore. After some
> more cleanups of other fabrics, t_mem_list and struct se_mem will be an
> implementation detail of tcm core (as opposed to part of its API), which
> will allow further progress.
> 
> The code has been tested and appears to work fine, and although I haven't
> done any performance measurements, I'd expect to see command servicing
> latencies improve a bit.
> 

Hi Andy,

My apologies for the delayed on the last series..  I will have a look at
these updated bits ahead of next week and start merging these into
lio-core-2.6.git and will follow up with specific comments.

Also, I CC'ed the linux-scsi list here just to keep folks in the loop
for the future.

Btw, I am quiet excited about the iscsi-target conversion to drop direct
se_cmd->t_mem_list usage and some of the other improvements.  Great
stuff.  :)

Thank you!

--nab

> Thanks -- Regards -- Andy
> 
> 
> The following changes since commit 41cb785aaaeeaa2ee3532afe36b9c3ff3e3d94b5:
> 
>   Merge branch 'master' of /pub/scm/linux/kernel/git/torvalds/linux-2.6 into lio-4.1 (2011-05-27 07:57:12 +0000)
> 
> are available in the git repository at:
> 
>   git://fedorapeople.org/home/fedora/grover/public_git/linux-2.6.git for-nab
> 
> Andy Grover (42):
>       target: Replace custom sg<->buf functions with lib funcs
>       target: Simplify sector limiting code
>       target: get_cdb should never return NULL
>       target: Simplify transport_memcpy_se_mem_read_contig
>       target: Use assignment rather than increment for t_task_cdbs
>       target: Don't pass dma_size to generic_get_mem. Don't memset.
>       target: Pass sg with type scatterlist in transport_map_sg_to_mem
>       target: Move task_sg_num next to task_sg in struct se_task
>       target: inline struct se_transport_task into struct se_task
>       target: Rewrite transport_init_task_sg()
>       target: Simplify transport_do_task_sg_chain()
>       target: Change name & semantics of transport_get_sectors()
>       target: Remove unused members of se_cmd
>       target: Rename se_cmd.t_task_cdbs to t_task_list_num
>       target: Fix some spelling
>       target/iscsi: rearrange iscsi_session members to show lock coverage
>       target/iscsi: Fix spelling of enum immediate_data_ret_table members
>       target/iscsi: Remove iscsi_ooo_cmdsn.batch_count
>       target: Remove unused members of iscsi_cmd and iscsi_queue_req
>       target: Remove unused var from transport_generic_do_tmr
>       target: Remove iscsi_session.cmdsn_outoforder flag
>       target: Remove iscsi_session.ooo_cmdsn_count
>       target: Simplify CmdSN sequencing
>       target: Silence a warning in a printk in target_emulate_write_same
>       target: Rename transport_generic_allocate_tasks to _process_cdb
>       target: Rename transport_generic_handle_cdb to _new_cmd
>       target: map_sg_to_mem: return sg_count in return value
>       target/pscsi: Use min_t for sector limits
>       target/pscsi: Unused param for pscsi_get_bio()
>       target: Rename get_cdb_count to allocate_tasks
>       target: Have iscsi fabric allocate its own buffers
>       target/iscsi: Inline params from map_sg into set_iovec_ptrs
>       target/iscsi: pass data_length by value to iscsit_calculate_map_segment
>       target/iscsi: Don't pass lmap to iscsit_get_offset()
>       target/iscsi: Rewrite iscsit_get_offset()
>       target/iscsi: Remove unused function iscsit_send_async_msg
>       target/iscsi: Do not use t_mem_list anymore
>       target/iscsi: use pad_bytes in cmd over local vars
>       target: Call transport_new_cmd instead of adding to cmd queue
>       target: Remove fabric callback to allocate iovecs
>       target/iscsi: remove unsolicited_data_comp completion
>       target/file: Alloc iov[] off the stack
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c           |   22 +-
>  drivers/target/iscsi/iscsi_target.c             |  894 +++++------------
>  drivers/target/iscsi/iscsi_target_configfs.c    |   35 +-
>  drivers/target/iscsi/iscsi_target_core.h        |   39 +-
>  drivers/target/iscsi/iscsi_target_erl1.c        |   24 +-
>  drivers/target/iscsi/iscsi_target_erl2.c        |    1 -
>  drivers/target/iscsi/iscsi_target_tmr.c         |    4 +-
>  drivers/target/iscsi/iscsi_target_util.c        |  257 ++---
>  drivers/target/iscsi/iscsi_target_util.h        |   42 +-
>  drivers/target/loopback/tcm_loop.c              |   17 +-
>  drivers/target/target_core_alua.c               |    4 +-
>  drivers/target/target_core_cdb.c                |   41 +-
>  drivers/target/target_core_device.c             |    6 +-
>  drivers/target/target_core_file.c               |   27 +-
>  drivers/target/target_core_iblock.c             |    4 +-
>  drivers/target/target_core_pr.c                 |   22 +-
>  drivers/target/target_core_pscsi.c              |   20 +-
>  drivers/target/target_core_rd.c                 |    8 +-
>  drivers/target/target_core_tmr.c                |   56 +-
>  drivers/target/target_core_transport.c          | 1213 ++++++++++-------------
>  drivers/target/target_core_ua.c                 |    2 +-
>  drivers/target/tcm_fc/tfc_cmd.c                 |   18 +-
>  drivers/target/tcm_fc/tfc_io.c                  |   21 +-
>  drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c |   34 +-
>  drivers/target/tcm_vhost/tcm_vhost_fabric.c     |    2 +-
>  drivers/target/tcm_vhost/tcm_vhost_scsi.c       |    2 +-
>  include/target/target_core_base.h               |  105 +--
>  include/target/target_core_fabric_ops.h         |    5 -
>  include/target/target_core_transport.h          |    6 +-
>  29 files changed, 1071 insertions(+), 1860 deletions(-)
> 
> 

