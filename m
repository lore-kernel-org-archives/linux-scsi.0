Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36729CA9EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14BE721928
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391877AbfJWMxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:53:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:49390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391852AbfJWMxO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 08:53:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76FE6B67A;
        Wed, 23 Oct 2019 12:53:12 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 5/8] docs: cdrom: Add autoclose IOCTL
Date:   Wed, 23 Oct 2019 14:52:44 +0200
Message-Id: <50579dae04d209c6fec62388c596d0e459fe56de.1571834862.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1571834862.git.msuchanek@suse.de>
References: <cover.1571834862.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This IOCTL will be used internally by the sr driver but there is no
reason to not document it for userspace.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 Documentation/ioctl/cdrom.rst | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/ioctl/cdrom.rst b/Documentation/ioctl/cdrom.rst
index 3b4c0506de46..9372ff1b2b47 100644
--- a/Documentation/ioctl/cdrom.rst
+++ b/Documentation/ioctl/cdrom.rst
@@ -60,6 +60,7 @@ are as follows:
 	CDROM_LOCKDOOR		lock or unlock door
 	CDROM_DEBUG		Turn debug messages on/off
 	CDROM_GET_CAPABILITY	get capabilities
+	CDROM_AUTOCLOSE 	If autoclose enabled close the tray
 	CDROMAUDIOBUFSIZ	set the audio buffer size
 	DVD_READ_STRUCT		Read structure
 	DVD_WRITE_STRUCT	Write structure
@@ -1056,6 +1057,30 @@ CDROM_GET_CAPABILITY
 
 
 
+CDROM_AUTOCLOSE
+	Close the tray if the device has one, and autoclose is enabled.
+	Wait for drive to become ready.
+
+
+	usage::
+
+	  ioctl(fd, CDROM_AUTOCLOSE, 0);
+
+
+	inputs:
+		none
+
+
+	outputs:
+		The ioctl return value is 0 or an error code.
+
+
+	error return:
+	  - ENOMEDIUM	No medium found or drive error.
+	  - ERESTARTSYS	Received a signal while waiting for drive to become ready.
+
+
+
 CDROMAUDIOBUFSIZ
 	set the audio buffer size
 
-- 
2.23.0

