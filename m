From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 04/22] tcm: Add v4 base data structures and struct
	target_core_fabric_ops
Date: Sat, 04 Sep 2010 16:53:10 -0700
Message-ID: <1283644390.556.74.camel@haakon2.linux-iscsi.org>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
	 <201009020156.53803.konrad@darnok.org>
	 <1283455187.5598.86.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1283455187.5598.86.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-09-02 at 12:19 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2010-09-02 at 01:56 -0400, Konrad Rzeszutek Wilk wrote:
> > On Monday 30 August 2010 05:20:40 Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hey Nicholas,
> > 
> > I did a cursory review .
> > 

<BIG SNIP>

> 
> Ok, I will go ahead and make the changes per the above comments and will
> drop you a line when the push is ready.  I do agree that mixing the
> struct variables with #defines in target_core_base.h does make things a
> bit more readable.  Let me consider this a bit.
> 
> Any comments from the kernel folks on this particular item..?
> 
> Thanks for your comments Konrad!
> 

Hi Konard,

I just pushed most of your recommend cleanups for target_core_base.h to
lio-core-2.6.git/lio-4.0.  The cleanup series has been posted on
lio-devel list to prevent extra noise on linux-scsi, et al, but for
reference the shortlog and diffstat are attached below..  I did not dive
into intermixed struct + #defines, but I am still pretty indifferent on
this particular item.

Please have a look and feel free to make additional comments.

Thanks again!

--nab

Nicholas Bellinger (13):
  tcm: Remove legacy struct se_lun->lun_type usage
  tcm: Remove legacy DEV_STATUS_THR_* defines
  tcm: Convert TCM base defines to enums, round 1
  tcm: Convert NAF_DYNAMIC_NODE_ACL to struct
    se_node_acl->dynamic_node_acl bitfield
  tcm: Convert MAP_SG_KMAP to struct se_map_sg->sg_kmap_active bitfield
  tcm: Convert TCM base defines to enums, round 2:
  tcm: Convert DEF_PR_REGISTERED to struct
    se_dev_entry->def_pr_registered bitfield
  tcm: Convert PRF_ISID_PRESENT_AT_REG to struct
    t10_pr_registration->isid_present_at_reg bitfield
  tcm: Convert struct se_cmd->scsi_sense_reason enum and add TCM_*
    prefix
  tcm: Add comments for t10_alua_index_t, t10_task_attr_index_t and
    t10_reservations_index_t
  tcm/pr: Add proper comment for struct
    t10_reservation_template->pr_res_holder
  tcm/alua: Move (*t10_*)() callers into struct t10_reservation_ops
  tcm: Cleanups for struct se_transport_task usage

 drivers/target/lio-target/iscsi_target.c       |   12 +-
 drivers/target/lio-target/iscsi_target_erl0.c  |    4 +-
 drivers/target/lio-target/iscsi_target_mib.c   |    6 +-
 drivers/target/lio-target/iscsi_target_util.c  |    6 +-
 drivers/target/target_core_device.c            |   17 +-
 drivers/target/target_core_fabric_lib.c        |    5 +-
 drivers/target/target_core_file.c              |    2 +-
 drivers/target/target_core_iblock.c            |    2 +-
 drivers/target/target_core_mib.c               |    6 +-
 drivers/target/target_core_pr.c                |   46 ++--
 drivers/target/target_core_rd.c                |    6 +-
 drivers/target/target_core_tpg.c               |   38 +--
 drivers/target/target_core_transport.c         |  161 ++++++------
 drivers/target/tcm_fc/tfc_cmd.c                |    4 +-
 drivers/target/tcm_fc/tfc_io.c                 |    4 +-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    4 +-
 include/target/target_core_base.h              |  314 ++++++++++++++----------
 include/target/target_core_tpg.h               |    4 +-
 18 files changed, 331 insertions(+), 310 deletions(-)
