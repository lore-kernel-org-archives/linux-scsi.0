From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.6-rc3
Date: Tue, 21 Aug 2012 20:23:54 -0700
Message-ID: <1345605834.23278.280.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38577 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2HVDX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2012 23:23:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Yi Zou <yi.zou@intel.com>, "Rustad, Mark D" <mark.d.rustad@intel.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>

Hello Linus!

The following are pending target fixes destined for v3.6-rc3.  Please go
ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The executive summary includes:

- Post-merge review comments for tcm_vhost (MST + nab)
- Avoid debugging overhead when not debugging for tcm-fc(FCoE) (MDR)
- Fix NULL pointer dereference bug on alloc_page failulre (Yi Zou)
- Fix REPORT_LUNs regression bug with pSCSI export (AlexE + nab)
- Fix regression bug with handling of zero-length data CDBs (nab)
- Fix vhost_scsi_target structure alignment (MST)

Thanks again to everyone who contributed a bugfix patch, gave review
feedback on tcm_vhost code, and/or reported a bug during their own
testing over the last weeks.

There is one other outstanding bug reported by Roland recently related
to SCSI transfer length overflow handling, for which the current
proposed bugfix has been left in queue pending further testing with
other non iscsi-target based fabric drivers.

As the patch is verified with loopback (local SGL memory from SCSI LLD)
+ tcm_qla2xxx (TCM allocated SGL memory mapped to PCI HW) fabric ports,
it will be included into the next 3.6-rc-fixes PULL request.

Thank you!

--nab

Denis Efremov (1):
  tcm_fc: rcu_deref outside rcu lock/unlock section

Fengguang Wu (1):
  tcm_vhost: Fix incorrect IS_ERR() usage in vhost_scsi_map_iov_to_sgl

Mark Rustad (1):
  tcm_fc: Avoid debug overhead when not debugging

Michael S. Tsirkin (1):
  tcm_vhost: Fix vhost_scsi_target structure alignment

Nicholas Bellinger (4):
  tcm_vhost: Post-merge review changes requested by MST
  tcm_vhost: Change vhost_scsi_target->vhost_wwpn to char *
  target/pscsi: Fix bug with REPORT_LUNs handling for SCSI passthrough
  target: Fix regression bug with handling of zero-length data CDBs

Roland Dreier (1):
  target: Remove unused se_cmd.cmd_spdtl

Yi Zou (1):
  target: fix NULL pointer dereference bug alloc_page() fails to get
    memory

 drivers/target/target_core_pscsi.c     |    9 ++-
 drivers/target/target_core_transport.c |   15 ++-
 drivers/target/tcm_fc/tcm_fc.h         |    1 +
 drivers/target/tcm_fc/tfc_cmd.c        |    8 +-
 drivers/target/tcm_fc/tfc_sess.c       |    4 +-
 drivers/vhost/tcm_vhost.c              |  203 ++++++++++++++++++--------------
 drivers/vhost/tcm_vhost.h              |   12 +-
 include/target/target_core_base.h      |    2 -
 8 files changed, 146 insertions(+), 108 deletions(-)

