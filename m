Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B760C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C93E2076A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="bDjJXZxs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgGQQMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:35 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.82]:32883 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbgGQQMe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595002350; i=@ts.fujitsu.com;
        bh=O/d0VW/jXWhDBE2zBHO+VcUFvEi/68vYHJGqIwinNDE=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=bDjJXZxs0wbaU3LZHVC3TJnXtz7YfBdWQjzG1Ool57goUjQzFBekhWSJjPHwISyr4
         qaCQt+VCPTBaXpSMAQhNPSrHv82Eb2Pi+5pcgqafcx7hlA/jPzqnvvCaFLQKaHrKUC
         24SyndWVPC3l+jNqGq2Tp8TtVc2+V1OZTTATNcR/IoIz31M2AYklNQgm4iffrZpoAA
         83kp+6mV2Wgcp8C5u/m0yrS/EOTxDDnm7zXSszvUZDQl5cHOBmlKJORdf6Ngcp7R9x
         01NUSG5gWWFSEcXcZeSMHoGfAVsnWCZBZIfyl2RikX6soO7LmBVeGmnAF5mh7F90Dc
         mZSTG3F9Le5sA==
Received: from [100.112.197.196] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-west-1.aws.symcld.net id 64/F6-29177-EEDC11F5; Fri, 17 Jul 2020 16:12:30 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRWlGSWpSXmKPExsViZ8MRovvurGC
  8Qe8FFovu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrRk+jcUGn
  XMW7NVtYGxgfSnQxcnEICUxmlFj7aCc7hDOdUaL7xh2WLkZODjYBA4kVk+6zgCREBNYwSqy8M
  48ZJMEsoCcx7d86dhBbWMBT4snuDjYQm0VAVeLg2klMIDavgJ3E5iszGUFsCQF5iY4Dk1kmMH
  IuYGRYxWiRVJSZnlGSm5iZo2toYKBraGika2hprmtobK6XWKWbpJdaqlueWlyia6iXWF6sV1y
  Zm5yTopeXWrKJEej3lIKjnTsYf736oHeIUZKDSUmUt22VYLwQX1J+SmVGYnFGfFFpTmrxIUYZ
  Dg4lCV7xU0A5waLU9NSKtMwcYAjCpCU4eJREeFuBYSjEW1yQmFucmQ6ROsWoy3Hz/ZJFzEIse
  fl5qVLivD0gRQIgRRmleXAjYPFwiVFWSpiXkYGBQYinILUoN7MEVf4VozgHo5Iw716QKTyZeS
  Vwm14BHcEEdMTGz7wgR5QkIqSkGphCvv3aFarpNTN/7r9H3+z9BVLCN/17dEX28fMzPZN3HGt
  cuG7ug5cTD6/I+L7HvlvEem8p2z47Wf9zapvOfzmnO/uzo5L1oz1uN7/N7vH7N/eF+GqZiuaC
  uQ3Tn2xPXHzU+6belNwKjrfMfwOZf9kX+MsWbrdl/B/e8LbusPv9/9rlpVyP7N3nKLktdXhwV
  prvSArjJF2/5D0/naYG50i7zX3CmHnKqn/Xwlalq5s557H2zPj/aYq536Pb14yD4zX4RVmsVB
  IkA85qXmZTv7rgZfP0N13NE0K+FcuwKP1r23i0/Oppt12zmKqa797+cF0v/K6lT8oNy9sRkq2
  eccnfGuXmztvQrGc5wVHu3F0pJZbijERDLeai4kQAwkQlpgIDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-11.tower-285.messagelabs.com!1595002349!816814!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 27790 invoked from network); 17 Jul 2020 16:12:29 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-11.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jul 2020 16:12:29 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06HGCNfS009777;
        Fri, 17 Jul 2020 17:12:23 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id D61EE20199;
        Fri, 17 Jul 2020 18:12:20 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Date:   Fri, 17 Jul 2020 18:12:04 +0200
Message-Id: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
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
 drivers/target/target_core_user.c      | 374 +++++++++++++++++++++++++++------
 include/target/target_core_backend.h   |   2 +
 include/target/target_core_base.h      |   1 +
 include/uapi/linux/target_core_user.h  |  25 +++
 6 files changed, 367 insertions(+), 72 deletions(-)

-- 
2.12.3

