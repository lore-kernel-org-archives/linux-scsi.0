From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/2] target: Fixes for AllRegistrants reservation handling
Date: Tue, 16 Dec 2014 00:09:02 +0000
Message-ID: <1418688544-18825-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50083 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaLPAk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 19:40:26 -0500
Received: by mail-ob0-f179.google.com with SMTP id va2so20736566obc.10
        for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2014 16:40:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

This series addresses two issues raised recently by Ilias wrt
AllRegistrants reservation handling in target code that does not
adhere to SPC-4 specification requirements.

This first is a informational change to PR-IN READ_FULL_STATUS,
that when an AllRegistrants reservation is in place, all active
registrations should be setting R_HOLDER=1 within their respective
descriptors.

The second is a functional change to PR-OUT REGISTER w/ SARK=0
operation, to avoid dropping the AllRegistrants reservation until
the last registered I_T nexus has been released.  It also ensures
that the correct reservation type + scope is retained when the
new reservation is set within __core_scsi3_complete_pro_release()
for this AllRegistrants special case.

Also, thanks to James for the extra SPC-4 clarifications.

Please review.

--nab

Nicholas Bellinger (2):
  target: Fix R_HOLDER bit usage for AllRegistrants
  target: Avoid dropping AllRegistrants reservation during unregister

 drivers/target/target_core_pr.c | 113 +++++++++++++++++++++++++++++++---------
 1 file changed, 88 insertions(+), 25 deletions(-)

-- 
1.9.1

