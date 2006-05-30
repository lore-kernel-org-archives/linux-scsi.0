From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/5] iscsi update
Date: Tue, 30 May 2006 00:37:17 -0500
Message-ID: <1148967437.3005.12.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:23223 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932102AbWE3F5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 01:57:00 -0400
Received: from [192.168.0.7] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4U5udV1027079
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 00:56:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix a couple bugs including:

- If recovery failed or we are in recovery only overrite the state if we
are going to terminate the session or if we logged back in. This
prevents IO from getting into the LLD when we know we cannot send it and
speeds up dm-multipath failovers.
- We must grab the session lock when modifying the running lists. This
prevents run list corruption.
- remove task type should return a task in success.
- We can race and misset the suspend bit if iscsi_write_space is called
then iscsi_send returns with a failure indicating there is no space.

The patches were made against scsi-misc and put us in a good place for
2.6.18.

