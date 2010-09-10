From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] tcm: Add pre-allocated struct se_cmd descriptor support
Date: Fri, 10 Sep 2010 02:26:24 -0700
Message-ID: <1284110784-32763-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:24537 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750768Ab0IJJ0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 05:26:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Joe Eykholt <jeykholt@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Joe and Co,

This patch series adds support to TCM Core for allowing TCM fabric modules to use
pre-allocated struct se_cmd descriptors and sense data buffers living within
fabric module dependent data structures.  This patch series was orginally inspiried
as a future TCM v4.1 optimization by Joe Eykholt in a thread here:

http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/88a6434fa9cad163

The first patch adds the necessary TCM Core infrastructure to support the
initialization and proper release of struct se_cmd living within TCM fabric
module dependent data structures.  This includes the conversion of existing logic
and the addition of the new transport_init_se_cmd() EXPORT_SYMBOL() code.

The second patch converts the TCM_Loop fabric module to use
struct tcm_loop_cmd->tl_se_cmd and struct tcm_loop_cmd->tl_sense_buf.

The third patch converts the LIO-Target fabric module to use
struct iscsi_cmd->se_cmd and struct iscsi_cmd->sense_buffer.

The forth patch converts the Open-FCoE.org / TCM_FC fabric module to
use struct ft_cmd->se_cmd and struct ft_cmd->ft_sense_buffer.

So far this has been lightly tested with TCM_Loop and LIO-Target fabric
modules on v2.6.36-rc3 HVM x86 guest, and will require more testing
to properly ensure the patch series is functionally correct, and that
other new TCM modules are still 100% functional using the existing
*transport_alloc_se_cmd() callers.

Many thanks again to Joe for noticing the oppourtunity for improvement
within the per I/O descriptor path and making this astute suggestion!!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  tcm: Add support for fabric module provided struct se_cmd descriptors
  tcm_loop: Convert to pre-allocated struct se_cmd descriptors
  lio-target: Convert to use pre-allocated struct se_cmd descriptors
  tcm_fc: Convert to use pre-allocated struct se_cmd descriptors

 drivers/target/lio-target/iscsi_target.c       |   27 +++--
 drivers/target/lio-target/iscsi_target_core.h  |   10 ++-
 drivers/target/lio-target/iscsi_target_erl1.c  |    8 +-
 drivers/target/lio-target/iscsi_target_tmr.c   |   23 ++---
 drivers/target/lio-target/iscsi_target_util.c  |   44 ++++----
 drivers/target/target_core_transport.c         |  131 +++++++++++++++++++-----
 drivers/target/tcm_fc/tcm_fc.h                 |    3 +-
 drivers/target/tcm_fc/tfc_cmd.c                |   59 +++++------
 drivers/target/tcm_fc/tfc_io.c                 |    4 +-
 drivers/target/tcm_loop/tcm_loop_core.h        |    6 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c      |   12 +-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   37 +++----
 include/target/target_core_base.h              |    3 +
 include/target/target_core_transport.h         |    4 +
 14 files changed, 226 insertions(+), 145 deletions(-)

