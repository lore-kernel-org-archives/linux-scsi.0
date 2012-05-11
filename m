From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.4-rc7
Date: Fri, 11 May 2012 14:52:16 -0700
Message-ID: <1336773136.25759.167.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41711 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422632Ab2EKVwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2012 17:52:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus !

This time around for -rc7, there is only a single outstanding target
pending bugfix ready to be merged..

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.4-urgent

This patch removes some incorrect legacy code to free se_lun_acl memory
in the NodeACL release path that could potentially trigger an OOPs
during shutdown once dynamic -> explicit initiator NodeACL conversion
has occurred.

That said, we've been able to trigger an OOPs in v4.0 code for this
special case when the associated MappedLUNs had not also been made
explicit based on active TPG LUN layout during the conversion, so it
really makes senses to go ahead and drop this extra cruft to avoid any
possible issues here.

This ends up only effecting iscsi-target module code (it's the only
user) and is CC'ed to stable.

Thanks!

--nab

Nicholas Bellinger (1):
  target: Drop incorrect se_lun_acl release for dynamic -> explict ACL
    conversion

 drivers/target/target_core_tpg.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)


