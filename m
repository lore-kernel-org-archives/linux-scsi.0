From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
 backward compatibility
Date: Thu, 10 Apr 2003 13:54:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030410135433.67bfed5f.rddunlap@osdl.org>
References: <200304101339.49895.pbadari@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:45784 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264156AbTDJUne (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 16:43:34 -0400
In-Reply-To: <200304101339.49895.pbadari@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 10 Apr 2003 13:39:49 -0700 Badari Pulavarty <pbadari@us.ibm.com> wrote:

| Here is the (sd) patch to support > 4000 disks on 32-bit dev_t work
| in 2.5.67-mm tree.
| 
| This patch addresses the backward compatibility with device nodes
| issue. All the new disks will be addressed by only last major.
| 
| SCSI has 16 majors. Each major supports 16 disks currently.
| This patch leaves this assumption for first 15 majors and all the
| new disks addressable by 32/64 dev_t work will be added to
| SCSI last major#. This way, we don't need to create device
| nodes in /dev, if you switch between 2.4 and 2.5.
| 
| Any comments ?


 #define SD_MAJORS	16
-#define SD_DISKS	(SD_MAJORS << 4)
+#define SD_DISKS	((SD_MAJORS - 1) << 4)
+#define LAST_MAJOR_DISKS	(1 << (KDEV_MINOR_BITS - 4))
+#define TOTAL_SD_DISKS	(SD_DISKS + LAST_MAJOR_DISKS)
 
@@ -85,7 +87,7 @@ struct scsi_disk {
 static LIST_HEAD(sd_devlist);
 static spinlock_t sd_devlist_lock = SPIN_LOCK_UNLOCKED;
 
-static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
+static unsigned long sd_index_bits[TOTAL_SD_DISKS / BITS_PER_LONG];
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
~~~~~
If there's any chance that TOTAL_SD_DISKS is not a multiple of
BITS_PER_LONG, then the value above should better be

	(TOTAL_SD_DISKS + BITS_PER_LONG - 1) / BITS_PER_LONG


--
~Randy   ['tangent' is not a verb...unless you believe that
          "in English any noun can be verbed."]
