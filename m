From: Jan Engelhardt <jengelh@inai.de>
Subject: Arbitrary SCSI commands and CAP_SYS_ADMIN
Date: Tue, 7 May 2013 18:12:26 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1305071807230.27782@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37972 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3EGQM2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 May 2013 12:12:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by ares07.inai.de (Postfix) with ESMTP id DB89D96A07D4
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2013 18:12:26 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In include/uapi/linux/capability.h, next to CAP_SYS_ADMIN, one will find 
the notice

/* Allow enabling/disabling tagged queuing on SCSI controllers and sending
   arbitrary SCSI commands */

#define CAP_SYS_ADMIN 21

To the best of my knowledge, arbitrary commands can be issued with 
the SG_IO ioctl. However, in drivers/scsi/sg.c, SG_IO does not need any 
capabilities. Furthermore, in block/bsg.c, SG_IO suddenly needs 
CAP_SYS_RAWIO (blk_fill_sgv4_hdr_rq < bsg_map_hdr < bsg_ioctl, or 
through __bsg_write). Is the source documentation out of date?
