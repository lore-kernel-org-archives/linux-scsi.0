From: Colin Ian King <colin.king@canonical.com>
Subject: re: scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Thu, 13 Jul 2017 18:12:33 +0100
Message-ID: <0139728b-7bdc-62b7-9415-c01c79c5f3af@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44261 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbdGMRMg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2017 13:12:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

minor nit-pick on the following commit:

scsi: sg: fix SG_DXFER_FROM_DEV transfers

SG_DXFER_FROM_DEV transfers do not necessarily have a dxferp as we set
it to NULL for the old sg_io read/write interface, but must have a
length bigger than 0. This fixes a regression introduced by commit
28676d869bbb ("scsi: sg: check for valid direction before starting the
request")


diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 21225d62b0c1..1e82d4128a84 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -758,8 +758,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
                if (hp->dxferp || hp->dxfer_len > 0)
                        return false;
                return true;
-       case SG_DXFER_TO_DEV:
        case SG_DXFER_FROM_DEV:
+               if (hp->dxfer_len < 0)

hp->dxfer_len is an unsigned int so this condition is redundant and
false is never returned.  Is that intentional?

+                       return false;
+               return true;
+       case SG_DXFER_TO_DEV:

Colin
