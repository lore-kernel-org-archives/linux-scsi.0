Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25DCC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914E520767
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="o2BaLbDA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGJKsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:48:52 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.115]:22376 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbgGJKss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=v4Pm/rLBWqPUqO04eZ1RpQiUC1Z4Qfk8vZt/HeiQxfA=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=o2BaLbDA/0EgPlKDvNxSPzkrBNUWBt6L2p+XEqbhcw6DUmZeM4l0v1L2ikHOxH8RF
         3vSglNX2qDa2s2zyIVu5HjZ9mAFuS4kRS1OfYKZyRuti5QnFHWsac469zNamwIllrC
         VwWWHW8TwENed79vW/tnBBXGBpBRftnArtmpyrgG85N2DFWqr2L6jrCbL8GJHbZZJM
         x94gFYkMs1XbDwfWhjeMIzLNPmtLHuFajNzRvmUrz4KyrvjUR7vtMm1BI5SNvy0/v/
         sUlCtRB4G/CvdTfeFstj1nq8oHRLaAm9Gxuud8blShGoVBMj6hWQxJdvQEoS2SX9bW
         zGezwhAV1touA==
Received: from [100.113.4.60] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-central-1.aws.symcld.net id 6B/16-24114-C87480F5; Fri, 10 Jul 2020 10:48:44 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRWlGSWpSXmKPExsViZ8MRotvtzhF
  v8G+jmkX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE14+fD2ewF
  f2Urjj+/xtrAeFeii5GLQ0hgMqPEw/U/2LsYOYGc6YwS3ybygthsAgYSKybdZwEpEhFYwyix8
  s48ZpAEs4CexLR/68AahAXcJKZMOQtkc3CwCKhK7P5qBBLmFbCTuDnlPliJhIC8RMeBySwTGD
  kXMDKsYrRIKspMzyjJTczM0TU0MNA1NDTWNQOy9BKrdJP0Ukt1k1PzSooSgZJ6ieXFesWVuck
  5KXp5qSWbGIFeTylk49rB+PT1B71DjJIcTEqivNM+sscL8SXlp1RmJBZnxBeV5qQWH2KU4eBQ
  kuB1cOWIFxIsSk1PrUjLzAEGIExagoNHSYR3vgtQmre4IDG3ODMdInWKUZfj5vsli5iFWPLy8
  1KlxHn/OQMVCYAUZZTmwY2ARcMlRlkpYV5GBgYGIZ6C1KLczBJU+VeM4hyMSkAVIJfwZOaVwG
  16BXQEE9ARRznYQI4oSURISTUwpV49d9dFQZ2fn83oM/e90jQZiTvzvCKmxLcLej+Ut4tzWbN
  EvYvVauL/tIL8CQKFHEfELzQzvRS1P8qdEX7+SN3Nnk7/wlrVMjmW3J+JL5k2KtZONOaYWKq6
  SDKm7+exh4fkF334FjXj1INdBcdOMaRMSbM04Tf58Cmk+EJJ7EHlkNVL366uvfioIvn4nFPZV
  Xs2VLLxOd3fPr/cc/HWUsaI5wdf9umfz+M/t/Bm4xQ/H/XPMSH2YZcd3u4RML7zQ2vf16la+U
  xXhKZOvC45OfYKz0r/aY4SHEc2/Vf7Kfh2wpb9BWuW5Cz/dLb5oZkHT+2C+cutG/7PNwx9/df
  lQnjvo1wJBfNH/O2O9/boKrEUZyQaajEXFScCAO+NjBoBAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-29.tower-245.messagelabs.com!1594378122!1671433!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1539 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-29.tower-245.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmg6T017883;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 4ABF720057;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Date:   Fri, 10 Jul 2020 12:48:09 +0200
Message-Id: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series is made on top of Martin's for-next branch.
I already sent it as "RFC PATCH" 10 days ago. Since there is
no response yet, I decided to be optimistic and re-send the
series as normal patch, just rebased to current for-next.

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
 drivers/target/target_core_user.c      | 375 +++++++++++++++++++++++++++------
 include/target/target_core_backend.h   |   2 +
 include/target/target_core_base.h      |   1 +
 include/uapi/linux/target_core_user.h  |  25 +++
 6 files changed, 368 insertions(+), 72 deletions(-)

-- 
2.12.3

