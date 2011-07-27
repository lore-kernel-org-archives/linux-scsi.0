From: Dan Carpenter <error27@gmail.com>
Subject: [smatch stuff] iscsi-target: string size issue in
 lio_target_call_addnptotpg()
Date: Wed, 27 Jul 2011 14:34:50 +0300
Message-ID: <20110727113450.GA7382@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49830 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1G0Lgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 07:36:54 -0400
Received: by pzk37 with SMTP id 37so2578505pzk.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 04:36:54 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>

Smatch complains about the string handling in lio_target_call_addnptotpg().

drivers/target/iscsi/iscsi_target_configfs.c +184 lio_target_call_addnptotpg(21)
	error: snprintf() chops off the last chars of 'name': 257 vs 256

   176          char buf[MAX_PORTAL_LEN + 1];

	buffer holds 257 chars.

   177  
   178          if (strlen(name) > MAX_PORTAL_LEN) {

	string is 256 chars plus NUL.  (257 chars).

   179                  pr_err("strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
   180                          (int)strlen(name), MAX_PORTAL_LEN);
   181                  return ERR_PTR(-EOVERFLOW);
   182          }
   183          memset(buf, 0, MAX_PORTAL_LEN + 1);

	set 257 chars to NULL.

   184          snprintf(buf, MAX_PORTAL_LEN, "%s", name);

	Copy 255 chars and write a NUL char to the second last char
	in the buffer.  The last char is also NUL.

regards,
dan carpenter
