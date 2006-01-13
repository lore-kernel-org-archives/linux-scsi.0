From: Jack Hammer <jack_hammer@adaptec.com>
Subject: ips - Mode Sense (Caching Page ) fix
Date: Fri, 13 Jan 2006 10:06:50 -0500
Message-ID: <43C7C209.3000301@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:5031 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1422711AbWAMPG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 10:06:57 -0500
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 70FCE3B29
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 07:06:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Much better ...  To avoid the "sda: got wrong page" message,
the ServeRAID driver should be setting flags indicating
that the Mode Sense commands are not supported.

Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>



--- a/drivers/scsi/ips.c	Mon Jan  2 22:21:10 2006
+++ b/drivers/scsi/ips.c	Fri Jan 13 09:44:02 2006
@@ -1319,6 +1319,9 @@
 			min = ha->max_cmds - 1;
 		scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
 	}
+
+	SDptr->skip_ms_page_8 = 1;
+	SDptr->skip_ms_page_3f = 1;
 	return 0;
 }
 #endif
