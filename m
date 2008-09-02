From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/14] scsi: scsi_decide_dispostion update
Date: Tue,  2 Sep 2008 09:05:29 -0700
Message-ID: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48180 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYIBQFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5ncZ031072
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5iei137864
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:44 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5iXf020837
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:44 -0400
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m82G5hYS020784
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch series is an update to a previous set of patches posted by Mike
Christie in the thread referenced below.
http://thread.gmane.org/gmane.linux.scsi/44058/focus=4405

This patch series creates new return codes for scsi_decide_disposition and
scsi_check_sense so that retry restrictions and disposition can be implied
directly from the return code. Retry restrictions have also been moved
into the requeue function.

Mike C and I have tested a few of the return code types, but it would be
good to have other return types check with different hardware.

Change in behavior.
	- dm-mp fast fail on transport errors.
	- device busy and host busy limited by wait_for check.
	- A few more error cases will return DRIVER_TIMEOUT. Possibly should
	  add more DRIVER_ error codes.

A summary of the current disposition is shown below.

1.) Current disposition policy.
2.6.27 policy + DID_TRANSPORT patches

==============================================================================
scsi_queue_insert
==============================================================================
	SCSI_MLQUEUE_EH_RETRY		retry
	SCSI_MLQUEUE_DEVICE_BUSY 	retry, set device_blocked
	SCSI_MLQUEUE_HOST_BUSY		retry, set host_blocked

==============================================================================
scsi_softirq_done
==============================================================================
	disposition SUCCESS:
		scsi_finish_command
	disposition NEEDS_RETRY:
		scsi_queue_insert SCSI_MLQUEUE_EH_RETRY
	disposition ADD_TO_MLQUEUE:
		scsi_queue_insert SCSI_MLQUEUE_DEVICE_BUSY
	default:
		scsi_eh_scmd_add
	

==============================================================================
host_byte		
==============================================================================

DID_OK			goto status_byte
DID_NO_CONNECT		SUCCESS
DID_BUS_BUSY		allowed && !blk_noretry
DID_TIME_OUT		SUCCESS (TUR/INQ) / FAILED
DID_BAD_TARGET		SUCCESS
DID_ABORT		SUCCESS
DID_PARITY		allowed && !blk_noretry
DID_ERROR		allowed && !blk_noretry (status for RES)
DID_RESET		SUCCESS
DID_BAD_INTR		default
DID_PASSTHROUGH		SUCCESS
DID_SOFT_ERROR		allowed && !blk_noretry
DID_IMM_RETRY		NEEDS_RETRY
DID_REQUEUE		ADD_TO_MLQUEUE
DID_TRANSPORT_DISRUPTED ADD_TO_MLQUEUE
DID_TRANSPORT_FAILFAST	SUCCESS
default			FAILED


==============================================================================
status_byte
==============================================================================

QUEUE_FULL		ADD_TO_MLQUEUE
BUSY			ADD_TO_MLQUEUE
GOOD			SUCCESS
COMMAND_TERMINATED	SUCCESS
TASK_ABORTED		SUCCESS
CHECK_CONDITION		SEE SENSE
CONDITION_GOOD		SUCCESS
INTERMEDIATE_GOOD	SUCCESS
INTERMEDIATE_C_GOOD	SUCCESS
ACA_ACTIVE		SUCCESS
RESERVATION_CONFLICT	SUCCESS
default			FAILED

==============================================================================
sense
==============================================================================

!normalize_sense	FAILED
scsi_sense_is_deferred	NEEDS_RETRY (allowed && !blk_noretry)

scsi_dh->check_sense	handler return

FILEMARK, EOM or ILI	SUCCESS

NO_SENSE		SUCCESS
RECOVERED_ERROR		SUCCESS
ABORTED_COMMAND		SUCCESS (DIF) / NEEDS_RETRY
NOT_READY		NEEDS_RETRY (ua, bc rdy) / FAILED (restart) / SUCCESS
UNIT_ATTENTION		NEEDS_RETRY (ua, bc rdy) / FAILED (restart) / SUCCESS
COPY_ABORTED		SUCCESS
VOLUME_OVERFLOW		SUCCESS
MISCOMPARE		SUCCESS
MEDIUM_ERROR		SUCCESS (0x11, 0x13, 0x14) / NEEDS_RETRY
HARDWARE_ERROR		ADD_TO_MLQUEUE (retry_hwerror) / SUCCESS
ILLEGAL_REQUEST		SUCCESS
BLANK_CHECK		SUCCESS
DATA_PROTECT		SUCCESS
default			SUCCESS


