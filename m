From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] bsg: add linux/types.h include to bsg.h
Date: Mon, 09 Mar 2009 10:51:38 -0400
Message-ID: <49B52CFA.3030007@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010805060408040805050604"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56240 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZCIOvm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 10:51:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by elrond2.infotech.no (Postfix) with ESMTP id 738061BF23
	for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2009 15:51:40 +0100 (CET)
Received: from elrond2.infotech.no ([127.0.0.1])
	by localhost (elrond2.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yIs0cl02pJYq for <linux-scsi@vger.kernel.org>;
	Mon,  9 Mar 2009 15:51:40 +0100 (CET)
Received: from [192.168.48.95] (ip-111.51.99.216.dsl-cust.ca.inter.net [216.99.51.111])
	by elrond2.infotech.no (Postfix) with ESMTP id B51E01BF22
	for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2009 15:51:39 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010805060408040805050604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Since bsg.h has recently been added to the list of kernel
headers that should be exported to the user space, this
attachment makes bsg.h more user space "friendly".
Specifically autotools dislike headers that don't compile
freestanding and bsg.h's use of __u32 types (and friends)
are not standard C (C90 or C99). The inclusion of
linux/types.h fixes that.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>



--------------010805060408040805050604
Content-Type: text/x-patch;
 name="bsg_h_linux_types.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bsg_h_linux_types.diff"

--- linux-2.6.28/include/linux/bsg.h_orig	2008-07-15 18:30:10.000000000 -0400
+++ linux-2.6.28/include/linux/bsg.h	2009-03-09 10:36:49.000000000 -0400
@@ -1,6 +1,8 @@
 #ifndef BSG_H
 #define BSG_H
 
+#include <linux/types.h>
+
 #define BSG_PROTOCOL_SCSI		0
 
 #define BSG_SUB_PROTOCOL_SCSI_CMD	0


--------------010805060408040805050604--
