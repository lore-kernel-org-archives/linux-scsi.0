From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] bfa: Add support to read/update the FRU data.
Date: Thu, 11 Oct 2012 09:57:29 +0300
Message-ID: <20121011065729.GE31607@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45755 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2JKG5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2012 02:57:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org

Hello Krishna Gudipati,

The patch e6826c96ced7: "[SCSI] bfa: Add support to read/update the 
FRU data." from Sep 21, 2012, leads to the following warning:
drivers/scsi/bfa/bfad_bsg.c:114 bfad_iocmd_ioc_get_info()
	 error: buffer overflow 'iocmd->adapter_hwpath' 32 <= 32

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 0ab1d40..555e7db 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -107,9 +107,10 @@ bfad_iocmd_ioc_get_info(struct bfad_s *bfad, void *cmd)
 
        /* set adapter hw path */
        strcpy(iocmd->adapter_hwpath, bfad->pci_name);
-       i = strlen(iocmd->adapter_hwpath) - 1;
-       while (iocmd->adapter_hwpath[i] != '.')
-               i--;
+       for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32; i++)
+               ;

i is 32 here.

+       for (; iocmd->adapter_hwpath[++i] != ':' && i < BFA_STRING_32; )
+               ;

i is 33 after the increment.

        iocmd->adapter_hwpath[i] = '\0';

We are placing a NUL char 2 places past the end of the array.

        iocmd->status = BFA_STATUS_OK;
        return 0;

regards,
dan carpenter

