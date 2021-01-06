Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B42C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84C6D22EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbhAGEwa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:52:30 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:51646 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbhAGEw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:52:29 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 51FEF3888C;
        Wed,  6 Jan 2021 20:41:57 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 51FEF3888C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609994517;
        bh=wvCrJiGXb8xcRuctcsV00alA53+DUTCUvU9ftBgop/Q=;
        h=From:To:Cc:Subject:Date:From;
        b=aoggN94GeNmKNsgBgMKT+Crztl1hOBlXgHHkta8k0msP7E3LiqtgUyLfM4rXRBFGi
         XuCoIlJ9x8zM3nZUOxOt4tdClIEOUFhAqMynx6J7vQDT9OqpdGCDvWLAzA7VFxSHBW
         tYb3qGPPmlJprENjeeU5FRME860HZzQHorTDokNk=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v8 0/5] scsi: Support to handle Intermittent errors
Date:   Thu,  7 Jan 2021 03:19:03 +0530
Message-Id: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a support to prevent retries of all the
io's after an abort succeeds on a particular device when transport
connectivity to the device is encountering intermittent errors.

Intermittent connectivity is a condition that can be detected by transport
fabric notifications. A service can monitor the ELS notifications and
take action on all the outstanding io's of a scsi device at that instant.

This feature is intended to be used when the device is part of a multipath
environment. When the service detects the poor connectivity, the multipath
path can be placed in a marginal path group and ignored further io
operations.

After placing a path in the marginal path group,the daemon sets the
port_state to Marginal which sets bit in scmd->state for all the
io's on that particular device with the new sysfs interface
provided in this patch.This prevent retries of all the
io's if an io hits a scsi timeout which inturn issues an abort.
On Abort succeeds on a marginal path the io will be immediately retried on
another active path.On abort fails then the things escalates to existing
target reset sg interface recovery process.

Below is the interface provided to set the port state to Marginal
and Online.
echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state


The patches were cut against  5.11-rc2

---
v8:
Rebase the patches on top of 5.11-rc2

v7:

Added New routine in scsi_host_template to decide if a cmd is
retryable instead of checking the same using  SCMD_NORETRIES_ABORT
bit as the cmd retry part can be checked by validating the port state.

Removed the changes related to SCMD_NORETRIES_ABORT bit.

Added a new function fc_eh_should_retry_cmd to check whether the cmd
should be retried based on the rport state.

Reoreder the patch

The patches were cut against  5.11/scsi-queue tree


v6:
Reordered the patches to make patch ordering and more logical.

v5:
Added the DID_TRANSPORT_MARGINAL case to scsi_decide_disposition

Made changes to clear the SCMD_NORETRIES_ABORT bit if the port_state
has changed from marginal to online due to port_delete and port_add
as we need the normal cmd retry behaviour while we are calling the
eh handlers.

Made changes in fc_scsi_scan_rport as we are checking FC_PORTSTATE_ONLINE
instead of FC_PORTSTATE_ONLINE and FC_PORTSTATE_MARGINAL


v4:
Made changes in fc_eh_timed_out callout to set the SCMD_NORETRIES_ABORT if port
state is marginal 

With this change, we  removed the code  to loop over running commands
and fc_remote_port_chkready changes to set the SCMD_NORETRIES_ABORT 

Removed the scsi_cmd argument for fc_remote_port_chkready
and reverted back the patches that addressed this change(argument)

Removed unnecessary comments
Handle the return of errors on failure.

v3:
Removed the port_state from starget attributes.
Enabled the store functionality for port_state under remote port
Added a new argument to scsi_cmd  to fc_remote_port_chkready
Used the existing scsi command iterators scsi_host_busy_iter.
Rearranged the patches
Added new patches to add new argument for fc_remote_port_chkready

v2:
Added new error code DID_TRANSPORT_MARGINAL to handle marginal errors.
Added a new rport_state FC_PORTSTATE_MARGINAL and also added a new
sysfs interface port_state to set the port_state to marginal.
Added the support in lpfc to handle the marginal state.


*** BLURB HERE ***

Muneendra (5):
  scsi: Added a new error code DID_TRANSPORT_MARGINAL in scsi.h
  scsi: No retries on abort success
  scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
  scsi_transport_fc: Added store fucntionality to set the rport
    port_state using sysfs
  scsi:lpfc: Added support for eh_should_retry_cmd

 drivers/scsi/lpfc/lpfc_scsi.c    |   1 +
 drivers/scsi/scsi_error.c        |  23 +++++-
 drivers/scsi/scsi_lib.c          |   1 +
 drivers/scsi/scsi_transport_fc.c | 118 ++++++++++++++++++++++++++-----
 include/scsi/scsi.h              |   1 +
 include/scsi/scsi_host.h         |   6 ++
 include/scsi/scsi_transport_fc.h |   4 +-
 7 files changed, 133 insertions(+), 21 deletions(-)

-- 
2.26.2

