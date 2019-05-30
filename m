From: Gen Zhang <blackgod016574@gmail.com>
Subject: [PATCH] mpt3sas_ctl: fix double-fetch bug in _ctl_ioctl_main()
Date: Thu, 30 May 2019 09:10:30 +0800
Message-ID: <20190530011030.GA6314@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In _ctl_ioctl_main(), 'ioctl_header' is fetched the first time from 
userspace. 'ioctl_header.ioc_number' is then checked. The legal result 
is saved to 'ioc'. Then, in condition MPT3COMMAND, the whole struct is
fetched again from the userspace. Then _ctl_do_mpt_command() is called,
'ioc' and 'karg' as inputs.

However, a malicious user can change the 'ioc_number' between the two 
fetches, which will cause a potential security issues.  Moreover, a 
malicious user can provide a valid 'ioc_number' to pass the check in 
first fetch, and then modify it in the second fetch.

To fix this, we need to recheck the 'ioc_number' in the second fetch.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Ack-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index b2bb47c..5181c03 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2319,6 +2319,10 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 			break;
 		}
 
+		if (karg.hdr.ioc_number != ioctl_header.ioc_number) {
+			ret = -EINVAL;
+			break;
+		}
 		if (_IOC_SIZE(cmd) == sizeof(struct mpt3_ioctl_command)) {
 			uarg = arg;
 			ret = _ctl_do_mpt_command(ioc, karg, &uarg->mf);
