From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/7] scsi: bfa: use 64-bit times in bfa_aen_entry_s ABI
Date: Fri, 10 Nov 2017 16:37:15 +0100
Message-ID: <20171110153715.1929456-8-arnd@arndb.de>
References: <20171110153715.1929456-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51544 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753264AbdKJPhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Nov 2017 10:37:51 -0500
In-Reply-To: <20171110153715.1929456-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, hch@lst.de, hare@suse.com, jthumshirn@suse.de, Arnd Bergmann <arnd@arndb.de>

bfa_aen_entry_s is passed through a netlink socket that can be read
by either 32-bit or 64-bit processes, but the data format is different
between the two on current implementations.

Originally, this was using a 'struct timeval', which also suffers from
getting redefined with a new libc implementation.

With this patch, the layout gets fixed to having two 64-bit members
for the time, making it the same on 32-bit kernels and 64-bit kernels
running either compat or native user space including x32.

Provided that the new header file gets used to recompile any 32-bit
application binaries, this will fix running those on a 64-bit kernel
(with or without this patch) e.g. in a container environment,
and it will make binaries work that will be built against a future
32-bit glibc that uses a 64-bit time_t, and avoid the y2038
overflow there.

However, this also breaks compatibility with any existing 32-bit
binary running on a native 32-bit kernel, those must be recompiled
against the new header, which in turn makes them incompatible with
older kernels unless the same change gets applied there.

Obviously this patch should only be applied when the benefits
outweigh the possible breakage. I'm posting it under the assumption
that there are no open-source tools using the netlink interface,
and that users of the binaries provided by qlogic for SLES10/11
and RHEL5/6 are not actually being used on new future systems
with 32-bit x86 kernels.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
---
 drivers/scsi/bfa/bfa_defs_svc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index df1e874015c4..3d0c96a5c873 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -1455,8 +1455,8 @@ struct bfa_aen_entry_s {
 	enum bfa_aen_category   aen_category;
 	u32                     aen_type;
 	union bfa_aen_data_u    aen_data;
-	unsigned long		aen_tv_sec;
-	unsigned long		aen_tv_usec;
+	u64			aen_tv_sec;
+	u64			aen_tv_usec;
 	u32                     seq_num;
 	u32                     bfad_num;
 };
-- 
2.9.0
