From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v2 0/2] tcm/tcm_loop: Add BIDI-COMMAND support
Date: Wed, 15 Sep 2010 15:41:43 -0700
Message-ID: <1284590503-6210-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Boaz and Co,

This is the rebased TCM Core + TCM_Loop module BIDI-COMMAND v2 patch series to
address Boaz's comments about the proper usage of DMA_BIDIRECTIONAL within
TCM Core and TCM_Loop and his other points.  I have already pushed the follow up
patches into lio-core-2.6.git/lio-4.0, and this is a follow up series for Boaz
to add comments w/o the original incorrect DMA_BIDIRECTIONAL usage in the v1 code.

So far this has been tested  with the same custom XDWRITE_READ_10 BSG userspace
code as the v1 patch and things are functioning as expected so far.  I will also
be testing with an BIDI capable sg_raw patch from Doug Gilbert. (Thanks Doug!)

Many thank go to Boaz for sharing his knowledge of BIDI for adding proper support
into TCM Core and TCM_Loop code!

Best,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  tcm: Add support for BIDI-COMMANDS and XDWRITE_READ_10 emulation
  tcm_loop: Add BIDI-COMMAND CDB support

 drivers/target/target_core_pr.c                |    3 +-
 drivers/target/target_core_transport.c         |  278 ++++++++++++++++++++----
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   47 +++-
 include/target/target_core_base.h              |   10 +-
 include/target/target_core_transport.h         |   10 +-
 5 files changed, 288 insertions(+), 60 deletions(-)
