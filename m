From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] scsi: mpt3sas: fix a missing-check bug
Date: Sat,  5 May 2018 01:31:35 -0500
Message-ID: <1525501896-8235-1-git-send-email-wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:LSILOGIC MPT FUSION DRIVERS
        FC/SAS/SPI" <MPT-FusionLinux.pdl@broadcom.com>, "open list:LSILOGIC MPT FUSION DRIVERS
        FC/SAS/SPI" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In _ctl_ioctl_main(), 'ioctl_header' is first copied from the userspace
pointer 'arg'. 'ioctl_header.ioc_number' is then verified by
_ctl_verify_adapter(). If the verification is failed, an error code -ENODEV
is returned. Otherwise, the verification result, i.e., the MPT3SAS adapter
that matches with the 'ioctl_header.ioc_number', is saved to 'ioc'. Later
on, if the 'cmd' is MPT3COMMAND, the whole ioctl command struct is copied
again from the userspace pointer 'arg' and saved to 'karg'. Then the
function _ctl_do_mpt_command() is invoked to execute the command with the
adapter 'ioc' and 'karg' as inputs.

Given that the pointer 'arg' resides in userspace, a malicious userspace
process can race to change the 'ioc_number' between the two copies, which
will cause inconsistency issues, potentially security issues since an
inconsistent adapter could be used with the command struct 'karg' as inputs
of _ctl_do_mpt_command(). Moreover, the user can potentially provide a
valid 'ioc_number' to pass the verification, and then modify it to an
invalid 'ioc_number'. That means, an invalid 'ioc_number' can potentially
bypass the verification check.

To fix this issue, we need to recheck the 'ioc_number' copied after the
second copy to make sure it is not changed since the first copy.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d3cb387..0c140c7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2388,6 +2388,11 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 			break;
 		}
 
+		if (karg.hdr.ioc_number != ioctl_header.ioc_number) {
+			ret = -EINVAL;
+			break;
+		}
+
 		if (_IOC_SIZE(cmd) == sizeof(struct mpt3_ioctl_command)) {
 			uarg = arg;
 			ret = _ctl_do_mpt_command(ioc, karg, &uarg->mf);
-- 
2.7.4
