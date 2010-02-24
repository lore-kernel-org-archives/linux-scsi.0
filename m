From: Adar Dembo <adar@vmware.com>
Subject: allow_dio/SG_FLAG_DIRECT_IO for sr devices
Date: Wed, 24 Feb 2010 13:46:09 -0800
Message-ID: <6E637B430FD37A4AB921E6D15291BCAB018054B9B2@EXCH-MBX-4.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:54799 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758098Ab0BXVqQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2010 16:46:16 -0500
Received: from mailhost4.vmware.com (mailhost4.vmware.com [10.16.67.124])
	by smtp-outbound-2.vmware.com (Postfix) with ESMTP id 7966E240EC
	for <linux-scsi@vger.kernel.org>; Wed, 24 Feb 2010 13:46:16 -0800 (PST)
Received: from pa-exht02.vmware.com (pa-exht02.vmware.com [10.113.81.168])
	by mailhost4.vmware.com (Postfix) with ESMTP id 6D8B9C9A1C
	for <linux-scsi@vger.kernel.org>; Wed, 24 Feb 2010 13:46:16 -0800 (PST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

When sending SG_IO ioctls to a device:
- /dev/sgX devices (using sg.c) follow the behavior described at http://tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html in terms of defaulting to indirect I/O, and using direct I/O only if both /proc/scsi/sg/allow_dio and SG_FLAG_DIRECT_IO in the request are set.
- /dev/srX devices (using sr.c) default to direct I/O. At least, that appears to be the case from inspecting the code, as sr_block_ioctl->cdrom_ioctl->scsi_cmd_ioctl->sg_io->blk_rq_map_user->__blk_rq_map_user will attempt to map the pages, regardless of what the user specified in the request or in the proc node.

This difference caught me by surprise; my expectation would be that an sg_io_hdr_t passed via SG_IO would be serviced in the same way regardless of the underlying driver. Is this a bug, or a feature? If the latter, is it documented somewhere?

