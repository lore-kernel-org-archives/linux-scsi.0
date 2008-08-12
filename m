From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/2] scsi: sense retry
Date: Tue, 12 Aug 2008 12:11:56 -0700
Message-ID: <1218568318-4065-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:59280 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYHLTMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 15:12:03 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CJC1Yv013914
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 15:12:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CJC1Xj180186
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:12:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CJC0vx018325
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:12:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, Hannes Reinecke <hare@suse.de>

This patch series effects the retry behavior of IO when blk_noretry_request is used.

The patches effect the retries in two areas. The first is that it allows
the scsi_dh check_sense routines to have more control of the retry of a
IO.  Currently if the scsi_dh check_sense functions return NEEDS_RETRY
this will not lead to a retry in the DM-MP configurations where they are
most likely to be used because the blk_noretry_request will be true for
these IOs which will prevent the retry. The second change in behavior of
the HARDWARE_ERROR sense key is to avoid path failures of all DM-MP paths
for the IBM device(s) returning this sense key.  The utilization of
ADD_TO_MLQUEUE for the HARDWARE_ERROR sense key could lead to longer retry
times for the other user of BLIST_RETRY_HWERROR.

I have tried to summarize the scsi_decide_disposition current retry behavior
below.


1.) Based on host_byte
	The host bytes listed below will return ADD_TO_MLQUEUE or NEEDS_RETRY
	which is always retried up to the max scsi mid-layer in-flight time
	(unsigned long  wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;).

	DID_REQUEUE:
		(returns ADD_TO_MLQUEUE)
	DID_IMM_RETRY:
                (returns NEEDS_RETRY)

	The host bytes listed below will use the maybe_retry goto which will
	not be retried if blk_noretry_request is true.

	DID_ERROR:
	DID_SOFT_ERROR:
	DID_BUS_BUSY:
	DID_PARITY:

2.) Based on status_byte
	The status bytes listed below will return ADD_TO_MLQUEUE which is
	always retried up to the max scsi mid-layer in-flight time (unsigned
	long  wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;).

	BUSY:
	QUEUE_FULL:

3.) Based on sense_key
	The sense keys and sense checks listed below will return NEEDS_RETRY
	which will be not be retried if blk_noretry_request is true.

	Note1: There is some if checks removed to simplify the list. Please see
	code for more detailed behavior.

	Note2: All scsi_dh sense_check functions will be effected by the
	blk_noretry_request check.

	scsi_sense_is_deferred
	ABORTED_COMMAND:
	NOT_READY:
	UNIT_ATTENTION:
	MEDIUM_ERROR:
	HARDWARE_ERROR:


I have summarized the change in retry behavior below.

1.) Based on sense_key

	The current scsi_dh sense_check functions will return
	ADD_TO_MLQUEUE.

	HARDWARE_ERROR will return ADD_TO_MLQUEUE if retry_hwerror is set.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com



