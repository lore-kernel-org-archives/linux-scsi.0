From: Christoph Hellwig <hch@lst.de>
Subject: qla1280 compile problems
Date: Tue, 5 Aug 2003 14:15:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030805121527.GA24550@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:27820 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S272685AbTHEMPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2003 08:15:30 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, es@wildopensource.com
Cc: linux-scsi@vger.kernel.org

The qla1280 update still has some issues, mostly because it backs
out all the 2.5 changes applied to the driver in the last months,
also it doesn't work on ia64 because the IA64 generic build references
sn2-specific symbols that don't exist in that build.

Jes, can you look at the 2.5 changes that went in after your last merge
and make the SN2 vchan workaround a config option?

For reference, this is the compile errors on ppc:

In file included from drivers/scsi/qla1280.c:299:
include/linux/blk.h:1:2: warning: #warning this file is obsolete, please use <linux/blkdev.h> instead
drivers/scsi/qla1280.c: In function `qla1280_done':
drivers/scsi/qla1280.c:1833: warning: implicit declaration of function `qla1280_get_target_options'
drivers/scsi/qla1280.c: At top level:
drivers/scsi/qla1280.c:4506: warning: type mismatch with previous implicit declaration
drivers/scsi/qla1280.c:1833: warning: previous implicit declaration of `qla1280_get_target_options'
drivers/scsi/qla1280.c:4506: warning: `qla1280_get_target_options' was previously implicitly declared to return `int'
drivers/scsi/qla1280.c:4830: warning: initialization from incompatible pointer type
drivers/scsi/qla1280.c:4830: error: unknown field `command' specified in initializer
