From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: Improvements for struct se_mem <-> SGL mapping logic
Date: Wed, 18 Aug 2010 15:23:29 -0700
Message-ID: <1282170209-23460-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:23911 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751419Ab0HRWXd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 18:23:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings hch, Jens and Co,

The following are three patches improve the handling of struct scatterlist -> struct se_mem
and struct se_mem -> struct scatterlist mapping within the TCM core algorithms.  These
patches also fix a bug for the struct se_mem -> struct scatterlist case with an underlying
struct block_device is reporting max_sectors=255, and when multiple struct tasks carrying
an struct se_mem *in_se_mem and u32 *task_offset pointer need to be carried between
allocations in transport_generic_get_cdb_count() and for struct se_subsystem_api I/O of
struct se_task.

The last two commits are difficult decipher without looking at the larger context, which is:

Starting in transport_generic_get_cdb_count(), which the generation of N tasks
based on enforced max_sectors for a single received CDB in struct se_cmd:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_transport.c;hb=refs/heads/lio-4.0#l6960

then into dev_obj_do_se_mem_map() for an single individual struct se_task:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_seobj.c;hb=refs/heads/lio-4.0#l103

and finally into transport_calc_sg_num() and transport_map_mem_to_sg() respectively to
allocate struct se_task->task_sg[] and map the struct se_mem from the per CDB I/O
descriptor context in T_TASK(se_cmd)->t_mem_list.  This goes into a single struct se_task
context mapping into struct se_task->task_sg[], that is then dispatched to individual subsystem
plugin I/O via struct se_subsystem_api->do_task().

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_transport.c;hb=refs/heads/lio-4.0#l6553
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_transport.c;hb=refs/heads/lio-4.0#l6857

So far this has been tested on v2.6.35 using TCM_Loop for patch #1, and TCM/IBLOCK +
scsi_debug w/ max_sectors 255-251 for the patch #2 and #3.  I am going to keep testing
this with some various odd numbered max_sectors values with scsi_debug and see if all
combinations of SGL -> struct se_mem and struct se_mem -> SGL mapping are working as
expected.

Best,

--nab

Nicholas Bellinger (3):
  tcm: Remove task_offset parameter from transport_map_sg_to_mem()
  tcm: Make transport_calc_sg_num() properly handle task_offset
  tcm: Make transport_map_mem_to_sg() properly handle task_offset

 drivers/target/target_core_transport.c |  212 +++++++++++++------------------
 include/target/target_core_transport.h |    2 +-
 2 files changed, 90 insertions(+), 124 deletions(-)

