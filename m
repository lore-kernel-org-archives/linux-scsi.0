From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH] add DID_REQUEUE string to scsi_show_result host table
Date: Wed, 31 Oct 2007 20:59:56 -0500
Message-ID: <1193882396.3710.6.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbXKAB77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Oct 2007 21:59:59 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA11xwtq007636
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2007 21:59:58 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA11xvnK006994
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2007 21:59:57 -0400
Received: from [10.11.14.213] (vpn-14-213.rdu.redhat.com [10.11.14.213])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA11xu4A011081
	for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2007 21:59:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was working on patches which add new transport error values, when I
noticed that DID_REQUEUE was not in the hostbyte_table. I do not think
there is any way to hit the code path where scsi_show_result is called
and where you return DID_REQUEUE, because DID_REQUEUE causes scsi-ml to
always requeue the command. However, for completeness and because I want
to one day send a patch that tries to add new host bytes values, I am
sending this patch.

Please apply when you get a chance. It is not critical.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


--- linux-2.6.23/drivers/scsi/constants.c.orig	2007-10-31 20:49:47.000000000 -0500
+++ linux-2.6.23/drivers/scsi/constants.c	2007-10-31 20:50:14.000000000 -0500
@@ -1355,7 +1355,7 @@ EXPORT_SYMBOL(scsi_print_sense);
 static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
-"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY"};
+"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE"};
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={



