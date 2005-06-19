From: "David S. Miller" <davem@davemloft.net>
Subject: more 2.6.x scsi fallout
Date: Sat, 18 Jun 2005 23:47:04 -0700 (PDT)
Message-ID: <20050618.234704.45869166.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:6354
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S262071AbVFSGrf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 02:47:35 -0400
Received: from localhost ([127.0.0.1] ident=davem)
	by sunset.davemloft.net with esmtp (Exim 4.50)
	id 1DjtaC-0002h5-6j
	for linux-scsi@vger.kernel.org; Sat, 18 Jun 2005 23:47:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The drivers/scsi/ch.c code calls functions which do not exist.

drivers/scsi/ch.c:945: warning: implicit declaration of function `class_device_create'
drivers/scsi/ch.c:975: warning: implicit declaration of function `class_device_destroy'
drivers/scsi/ch.c:989: warning: implicit declaration of function `class_create'
drivers/scsi/ch.c:989: warning: assignment makes pointer from integer without a cast
drivers/scsi/ch.c:1008: warning: implicit declaration of function `class_destroy'

bash$ find . -type f -name "*.[ch]" | xargs egrep class_destroy
./drivers/scsi/ch.c:	class_destroy(ch_sysfs_class);
./drivers/scsi/ch.c:	class_destroy(ch_sysfs_class);
./security/selinux/ss/policydb.c:static int class_destroy(void *key, void *datum, void *p)
./security/selinux/ss/policydb.c:	class_destroy,
./security/selinux/ss/policydb.c:	class_destroy(key, cladatum, NULL);
