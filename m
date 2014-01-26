From: Caizhiyong <caizhiyong@hisilicon.com>
Subject: patch "[SCSI] Fix out of spec CD-ROM problem with media change"
 will cause usb  disk resume fail.
Date: Sun, 26 Jan 2014 08:03:09 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E49B33@SZXEMA512-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>, James Bottomley <JBottomley@Parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Wanglin (Albert)" <albert.wanglin@hisilicon.com>, "Liuhui (B)" <liuhui88.liuhui@hisilicon.com>, "Ouyangshiting (Tim)" <tim.ouyang@hisilicon.com>, Wanting <wanting@hisilicon.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>    [SCSI] Fix out of spec CD-ROM problem with media change
>
>    Some CD-ROMs fail to report a media change correctly.  The specific
>    one for this patch simply fails to respond to commands, then gives a
>    UNIT ATTENTION after being reset which returns ASC/ASCQ 28/00.  This
>    is out of spec behaviour, but add a check in the eat CC/UA on reset
>    path to catch this case so the CD-ROM will function somewhat properly.
>
>    [jejb: fixed up white space and accepted without signoff]
>    Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>
>diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>index a4b9cdb..dc6131e 100644
>--- a/drivers/scsi/scsi_error.c
>+++ b/drivers/scsi/scsi_error.c
>@@ -293,8 +293,16 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>                 * so that we can deal with it there.
>                 */
>                if (scmd->device->expecting_cc_ua) {
>-                       scmd->device->expecting_cc_ua = 0;
>-                       return NEEDS_RETRY;
>+                       /*
>+                        * Because some device does not queue unit
>+                        * attentions correctly, we carefully check
>+                        * additional sense code and qualifier so as
>+                        * not to squash media change unit attention.
>+                        */
>+                       if (sshdr.asc != 0x28 || sshdr.ascq != 0x00) {
>+                               scmd->device->expecting_cc_ua = 0;
>+                               return NEEDS_RETRY;
>+                       }
>                }

Consider this scene:

1. Insert usb disk.
2. System suspend, usb controller power off.
3. System resume, usb controller power on, reset the usb disk. When read/write usb disk, it will pass up "media changed" status to scsi layer.
   this time need NEEDS_RETRY cmd，but this patch filter NEEDS_RETRY cmd, block layer report "IO ERRROR".


Looking forward to your feedback.
Best regards.
Cai Zhiyong.
http://www.huawei.com
