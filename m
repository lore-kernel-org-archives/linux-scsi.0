Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69966C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 422DD20780
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="JPm7VwxR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgF3Krp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:47:45 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.113]:15403 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732510AbgF3Krk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593514056; i=@ts.fujitsu.com;
        bh=uzwwfKMyrBAypom2X1E4BHvjFp4urHBOJhUxT8iANSk=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=JPm7VwxRqPfNo354K6ydy2P+4w7xipbEX95kZ+N+0hAdOSJ+9Rg+YeLbuPdsr6o+w
         N6bix9gtt7Q0aMs4is+j+nkR9HwfRcIb/8PkJDdaWJnC+zCluENddxmwyWcXcBx0LX
         iLkqcUbG6hIT/aR/Ldtin9bx+fYeDYqF3+IgH7KCmBlwvyrNUkQ8dISlVJWfodSqT4
         QFNdXg4APa7uNwZ7KpeLTAxz77jgu5KobvPVcK3mecFx7Dn7iV++5S8w29uwHk/k9a
         U20ls95kPwPdC1EVwy6z9Crij3KVY7r3oao8qiIE7oTpvrFoIyL3R2tvxghpGGvmX5
         TAcmsQKyeMsfw==
Received: from [100.113.4.241] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-central-1.aws.symcld.net id 77/DC-49188-7481BFE5; Tue, 30 Jun 2020 10:47:35 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRWlGSWpSXmKPExsViZ8MxRddd4ne
  cwYajyhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjG+bbrIV
  tMtUnJq1gqmBcYp4FyMXh5DAZEaJudc+MEM40xkl1h/4y9LFyMnBJmAgsWLSfRaQhIjAGkaJl
  XfmMYMkmAX0JKb9W8cOYgsLeElMbdwHZrMIqEqcm7KQDcTmFbCTuNi1FWyQhIC8RMeBySwTGD
  kXMDKsYrRMKspMzyjJTczM0TU0MNA1NDTWNdc1MjbUS6zSTdJLLdVNTs0rKUoEyuollhfrFVf
  mJuek6OWllmxiBPo+pZD9+Q7GVW8+6B1ilORgUhLlvffvV5wQX1J+SmVGYnFGfFFpTmrxIUYZ
  Dg4lCd6n4r/jhASLUtNTK9Iyc4BhCJOW4OBREuHdD5LmLS5IzC3OTIdInWLU5bj5fskiZiGWv
  Py8VClx3pViQEUCIEUZpXlwI2AxcYlRVkqYl5GBgUGIpyC1KDezBFX+FaM4B6OSMG8CyCqezL
  wSuE2vgI5gAjrimtYvkCNKEhFSUg1Mel/lVkl4a7Ct2+Bd3fVHiyXPK0nmtb/GpttJfvuyHR9
  6yp2LEi2btUQ47eG3pJ+Wl30S3i2Z5Lsj6obQ00/bP9ln/rN0Vuxe8uX4wT1z358T6Tqzo2uR
  4Ow5H98dk50Xo39w6yEuPV+/M39c7jm77W6ayq6o6XboU3RZP0e9l8O22zG26+qSGO9fP2//+
  as0+3edJ/+nX7vd//CpuSmjw7S03HAjtwbPLbW1nrds7Lr6Jy2Z88NFK/CjzuqrjlmNUyo87i
  iJZd5q/fn+gOP0WydWFL8xetPW1cp37/Vz564D8a8Ea6Yf45/CfcP6Q8eWNF1H/v9f87YkBpf
  8Vq4qnbR9sqrRit6Ybqmk0m8WSizFGYmGWsxFxYkAkcT9BgQDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-12.tower-248.messagelabs.com!1593514054!1288548!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18769 invoked from network); 30 Jun 2020 10:47:35 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-12.tower-248.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 10:47:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UAlRoN025845;
        Tue, 30 Jun 2020 11:47:27 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 9583720251;
        Tue, 30 Jun 2020 12:47:24 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC PATCH 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Date:   Tue, 30 Jun 2020 12:47:01 +0200
Message-Id: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
 and it can send command completion earlier than it would
without TMR notification.
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
A possible new command having the cmd_id as one of the aborted
commands will always appear on the ring after the TMR
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
 drivers/target/target_core_user.c      | 377 +++++++++++++++++++++++++++------
 include/target/target_core_backend.h   |   2 +
 include/target/target_core_base.h      |   1 +
 include/uapi/linux/target_core_user.h  |  25 +++
 6 files changed, 369 insertions(+), 73 deletions(-)

-- 
2.12.3

