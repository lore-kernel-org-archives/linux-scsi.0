From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 0/4] Make aborts work on tcm_qla2xxx, other cleanups
Date: Fri, 16 Nov 2012 08:06:15 -0800
Message-ID: <1353081979-29474-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:44952 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751667Ab2KPQG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2012 11:06:26 -0500
Received: by mail-da0-f70.google.com with SMTP id i30so3104282dad.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Nov 2012 08:06:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

Hi Nic,

Here's a series that makes aborts actually work on qla2xxx.  Stopping
and releasing commands is quite convoluted so I'm not sure the first
patch is totally correct, but without it I can easily reproduce task
hangs or list corruption by having an initiator flood a tcm_qla2xxx
target with aborts.  With those fixes, Steve's patch is pretty
straightforward.

The last two patches are just cleanups I noticed while debugging this.

Just to be clear: to the extent that this is copyrightable work, it is
released exclusively under the GPL.  No permission is granted to
redistribute this under any other terms.

 - R.

Roland Dreier (3):
  target: Fix handling of aborted commands
  target: Clean up logic in transport_put_cmd()
  target: Clean up flow in transport_check_aborted_status()

Steve Hodgson (1):
  qla2xxx: Look up LUN for abort requests

 drivers/scsi/qla2xxx/qla_target.c      |   19 ++++++++++++++-
 drivers/target/target_core_transport.c |   40 ++++++++++++++------------------
 2 files changed, 36 insertions(+), 23 deletions(-)

-- 
1.7.10.4
