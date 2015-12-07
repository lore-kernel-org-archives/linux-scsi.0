From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108771] scsi: ses: kasan: ses_enclosure_data_process use after
 free on boot SAS2X28
Date: Mon, 07 Dec 2015 14:01:41 +0000
Message-ID: <bug-108771-11613-NEJGozmw2J@https.bugzilla.kernel.org/>
References: <bug-108771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34695 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbbLGOBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2015 09:01:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E4AE203F3
	for <linux-scsi@vger.kernel.org>; Mon,  7 Dec 2015 14:01:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C1F29203B8
	for <linux-scsi@vger.kernel.org>; Mon,  7 Dec 2015 14:01:41 +0000 (UTC)
In-Reply-To: <bug-108771-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108771

--- Comment #1 from Pavel Tikhomirov <ptikhomirov@virtuozzo.com> ---
Aditional info about enclosue(from that node, but older 3.10 based kernel):

[root@p9 crash]# modprobe sg
[root@p9 crash]#  sg_map -i
/dev/sg0  LSI       SAS2X28           0e12
/dev/sg1  /dev/sda  LSI  MR9260-4i  2.13
[root@p9 crash]# lsscsi -gs
[1:0:16:0]   enclosu LSI      SAS2X28          0e12  -          /dev/sg0       
-
[1:2:0:0]    disk    LSI      MR9260-4i        2.13  /dev/sda   /dev/sg1  
3.99TB
[root@p9 crash]#  sg_ses /dev/sg0
  LSI       SAS2X28           0e12
Supported diagnostic pages:
  Supported Diagnostic Pages [sdp] [0x0]
  Configuration (SES) [cf] [0x1]
  Enclosure Status/Control (SES) [ec,es] [0x2]
  Element Descriptor (SES) [ed] [0x7]
  Additional Element Status (SES-2) [aes] [0xa]
  Download Microcode (SES-2) [dm] [0xe]
[root@p9 crash]#  sg_ses /dev/sg1
  LSI  MR9260-4i  2.13
    disk device (not an enclosure)
Supported diagnostic pages:

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
