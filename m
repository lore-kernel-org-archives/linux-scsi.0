Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5B2C4345D
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A5320714
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="crQzICoO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgGZPf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:56 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.1]:29279 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgGZPfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777747; i=@ts.fujitsu.com;
        bh=4bs0X+2ls7rnrb986VYdYSSyH6ROwLrQU8zl+bcuNeU=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=crQzICoO/gbjkvplLxblxAgbEaQKv6ry+8DQgwFSW7OoCwhEz/mFw2cakXHSFi1fS
         ME3o8GFZrDc+iCyzxKnDP0roQQ8xeVL/lceLPRhuBCDWZaC3oo+3m9xNiVTzlyDPJO
         OTeFLKtyj6VULXqfOivFrfQDdsU2sGErNJDitOjrK61B23KmAhRqk93oaL27Nu8nhM
         r5CPc2X6mk25EBQMVaDNKZT+0vofQMRXPTyCFTZE/k4uuio5WI5tlmlk+Sao+Enkmj
         sRGjtzGbQJcnp1M3484R0tlRmynT56P8e9QMX6KsmRUCnZs/uDi6hpDh6+I6u9oDjL
         /lOK3RTgKWLnw==
Received: from [100.112.192.163] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-west-1.aws.symcld.net id 51/1D-19802-3D2AD1F5; Sun, 26 Jul 2020 15:35:47 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRWlGSWpSXmKPExsViZ8MRontpkWy
  8wdUP1hbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjHdX2tkL
  nipVNJ1vZGlgPCvTxcjFISQwmVHi+bYHTBDOdEaJ3h+vmLsYOTnYBAwkVky6zwKSEBFYwyix8
  s48sASzgJ7EtH/r2EFsYQFPice/W9hAbBYBVYmnHzrB4rwCdhL3zn4Gq5cQkJfoODCZZQIj5w
  JGhlWMFklFmekZJbmJmTm6hgYGuoaGRrqGlkBsYqKXWKWbqJdaqlueWlyia6iXWF6sV1yZm5y
  TopeXWrKJEej5lIIDE3Yw7n/9Qe8QoyQHk5Ior8EU2XghvqT8lMqMxOKM+KLSnNTiQ4wyHBxK
  ErxXFwLlBItS01Mr0jJzgEEIk5bg4FES4Z0DkuYtLkjMLc5Mh0idYtTluPl+ySJmIZa8/LxUK
  XHefpAiAZCijNI8uBGwiLjEKCslzMvIwMAgxFOQWpSbWYIq/4pRnINRSZh3PTC+hHgy80rgNr
  0COoIJ6Aj3S5IgR5QkIqSkGpiEW5tPPJCdk101o+3q8/+lD/8+3/pPnPGyS/p/vaPvMqQMj2f
  3zLp5uk/RzrLRdHPKjVctHdstRN6kqSXINAbuE/0Y6Z7l+8d6Z1j90lVqigqHNsSqTlO48X3R
  7rk899+H3b83Y9Oz5mjXMo8FdVGesafl/kjNPT1bpqzB+eW+eGH1ysMnb216//jagsPtVxj0P
  GpDZvT67z+x6dGObmMepvpJaie3bRPTvTM9o9Bn/gZNh+QFv9tnP5pq9/jDS60juzdx/fvzYs
  KhesnZzNxmBSpPnxi5Zp25EulTx2Bm15j2pT7kWW9Ke9XbNWY+CWL85+ZOr7T88VMqyfC9k+d
  3q7in77UObtXe7uYvaPNNiaU4I9FQi7moOBEAVLzUFQMDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-31.tower-267.messagelabs.com!1595777746!466648!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 22254 invoked from network); 26 Jul 2020 15:35:46 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-31.tower-267.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:46 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZdND021563;
        Sun, 26 Jul 2020 16:35:40 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 1AE5F203E0;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Date:   Sun, 26 Jul 2020 17:35:02 +0200
Message-Id: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series is made on top of Martin's for-next branch.

ChangeLog:

v2: in patch "scsi: target: tcmu: Implement tmr_notify callback"
    changed new comment's style from "// ..." to "/* ... */"
    and correctly use "/** " for function doc.

V3:
 - Patch 1 "scsi: target: Modify core_tmr_abort_task()":
   fixed wrong spin_lock handling. Nested calls to
   spin_lock_irqsave and spin_lock_irqrestore used the same
   flags field. Inner pair replaced by spin_lock / spin_unlock
    
 - Patches 5,7,8:
   "scsi: target: tcmu: Factor out new helper ring_insert_padding"
   "scsi: target: tcmu: Implement tmr_notify callback"
   "scsi: target: tcmu: Make TMR notification optional"
   New definitions of struct tcmu_dev *dev renamed to *udev.

 - Patch 8 "scsi: target: tcmu: Make TMR notification optional"
   Spacing fixed at function definition.

---

TCM/LIO core handles TMRs without involving backends.
But TMR completion message is sent to initiator only after
commands aborted by the TMR are completed by the backend.
Especially in case of tcmu backend, if userspace executes long
running commands and therefore initiator sends ABORT_TASK on
timeout, the ABORT itself can time out if core still waits for
userspace/tcmu to complete the command.

It would be very helpful for userspace to get a notification
about received TMR and which commands were aborted by that TMR.
Then userspace can decide whether to cancel command processing,
and it can send command completion earlier than it would without
TMR notification.
It is also helpful for userspace traces and device emulation to
get notification about TMR events.

So this patch series in the first two patches implements in
core the usage of a new optional backend callback for TMR
notifications. The core calls it before core waits for
completion of aborted commands (params: se_dev, TMR type,
and list of se_cmds aborted by this TMR).
Of course other backends than tcmu can use this part of the
series also to implement their own TMR notification if
necessary.

The further six patches implement the TMR notify callback for
tcmu. The new configFS attribute tmr_notification allows to
switch on TMR messages on the cmd ring. The default of the
attribute is the old behavior without TMR info on the ring, but
with following changes:
 - if tcmu receives an already aborted command, it immediately
   rejects it. So it will never appear in userspace.
 - if tcmu finds, that according to TMR notification a cmd on
   the qfull_queue was aborted, tcmu removes it from qfull_queue
   and completes it immediately. So userspace will not 'see'
   those commands.

When attribute tmr_notification is set to 1, tcmu additionally
prepares a list of cmd_ids from those commands, that are aborted
by the TMR and are active in cmd ring (not timed out).
This list together with the TMR type is either immediately
written to cmd ring (new TMR entry type) or queued in a separate
tmr queue if ring space is too small.
TMRs in the tmr queue do not time out. If ring space becomes
available, tcmu moves TMRs from tmr queue to ring with higher
priority than cmds from qfull queue.

This mechanism makes sure that userspace receives TMR
notifications as early as possible. Userspace can use the
list of cmd_ids attached to the TMR notification to identify
aborted commands from its list of received and not yet completed
commands. In case userspace has meanwhile completed some of the
cmd_ids on the list, it can just ignore these cmd_ids.
A possible new command having the same cmd_id as one of the
aborted commands will always appear on the ring after the TMR
notification.

Bodo Stroesser (8):
  scsi: target: Modify core_tmr_abort_task()
  scsi: target: Add tmr_notify backend function
  scsi: target: tcmu: Use priv pointer in se_cmd
  scsi: target: tcmu: Do not queue aborted commands
  scsi: target: tcmu: Factor out new helper ring_insert_padding
  scsi: target: tcmu: Fix and simplify timeout handling
  scsi: target: tcmu: Implement tmr_notify callback
  scsi: target: tcmu: Make TMR notification optional

 drivers/target/target_core_tmr.c       |  36 +++-
 drivers/target/target_core_transport.c |   1 +
 drivers/target/target_core_user.c      | 373 +++++++++++++++++++++++++++------
 include/target/target_core_backend.h   |   2 +
 include/target/target_core_base.h      |   1 +
 include/uapi/linux/target_core_user.h  |  25 +++
 6 files changed, 366 insertions(+), 72 deletions(-)

-- 
2.12.3

