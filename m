From: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
Subject: SCSI/SD layer modifying sdev_state to SDEV_RUNNING when it is already
 blocked by LLD
Date: Wed, 1 Oct 2014 15:25:54 -0600
Message-ID: <CAM+6EX1gQycpym+867=2UwJMTfwOTiL9LQhtL9WPp6E0ZUZ8mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:51324 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaJAVco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 17:32:44 -0400
Received: by mail-vc0-f177.google.com with SMTP id hq11so937747vcb.36
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2014 14:32:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@avagotech.com>

Hi,

In a topology involving mpt2sas/mpt3sas drivers for a particular
scenario during disk addition through asynchronous scanning (post
target ID enumeration, but before device handle assignment by SCSI/SD
layer), the driver blocks the I/O to the disk using
scsi_internal_device_block() SCSI lib API, performs some cleanup in
the driver/FW, then unblock the I/O using
scsi_internal_device_unblock(). But before we unblock I notice that
the scsi_device->sdev_state is no longer SDEV_BLOCK (which the driver
had set to earlier) but the sdev_state is SDEV_RUNNING at that
juncture. I assume the SCSI Mid layer/SD driver somewhere in the disk
probe routine is setting the device to SDEV_RUNNING without checking
that it is in blocked state. Also, though the state is set to
SDEV_RUNNING by the SCSI/SD layer the block layer's request queue to
the disk is still frozen.

When we use scsi_internal_device_unblock() API to unblock from the
driver, the SCSI lib function exits with -EINVAL as the scsi_device is
already in SDEV_RUNNING state. ie, the block layer's request queue for
this disk is still frozen therefore no new I/Os could be sent to this
disk. I modified our driver with a workaround to check for the -EINVAL
return value and if it is, I perform a block followed by an unblock.
This seems to unfreeze the request queue and I/Os resume.

Therefore, we would like to understand if the behavior in the SCSI
layer could be changed by either of these 2 options in the future.

1. Ensuring the SCSI/SD layer doesn't set the device state to
SDEV_RUNNING without checking if it is already in SDEV_BLOCKED state.
2. Modifying the scsi_internal_device_unblock() function to
accommodate a case for SDEV_RUNNING state and unblocking the request
queue if it is in frozen state.

Regards,
Praveen
