From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH/RFT] check non-scsi part of status in scsi_status_is_good
Date: Wed, 29 Oct 2003 08:46:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029084656.B18130@beaverton.ibm.com>
References: <1067313069.1277.17.camel@ronald.kuetemeier.com> <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org> <20031028071637.B8503@beaverton.ibm.com> <1067355769.1102.17.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:22189 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261923AbTJ2QsC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 11:48:02 -0500
Content-Disposition: inline
In-Reply-To: <1067355769.1102.17.camel@ronald.kuetemeier.com>; from ronald@kuetemeier.com on Tue, Oct 28, 2003 at 08:42:49AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>

Ronald can you test this out, and send usb storage logs?

For your device I assume we will now send a MODE SENSE page 0x0 that will
get a bogus ILLEGAL REQUEST, but then the following MODE SENSE page 0x3f
with a longer length might work.

I test booted, but do not have any removable media or USB storage
attached.

----------------

Only the scsi status byte is being checked for all callers of
scsi_status_is_good. This means non-scsi errors are treated as no error at
all without this fix.

diff -uprN -X /home/patman/dontdiff bl-25/include/scsi/scsi.h status-fix-bl-2.5/include/scsi/scsi.h
--- bl-25/include/scsi/scsi.h	Mon Sep 29 12:21:10 2003
+++ status-fix-bl-2.5/include/scsi/scsi.h	Wed Oct 29 07:19:56 2003
@@ -126,6 +126,8 @@ extern const unsigned char scsi_command_
  */
 static inline int scsi_status_is_good(int status)
 {
+	if (status & 0xffffff00)
+		return 0;
 	/*
 	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
 	 * significant in SCSI-3.  For now, we follow the SCSI-2

-- Patrick Mansfield
