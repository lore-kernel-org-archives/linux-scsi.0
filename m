From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support during
 the FW boot-up and fixed the 64 bit sense buff error.
Date: Sun, 20 Sep 2009 20:46:20 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C512407@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119D7@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33944 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbZIUCq3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Sep 2009 22:46:29 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5119D7@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Add the 3 mins support during the FW boot-up to the driver.  Also add the fix for the 64 bit sense buff error.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   36 ++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-09-15 05:01:51.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-09-15 05:23:28.000000000 -0400
@@ -1820,6 +1820,7 @@ megasas_transition_to_ready(struct megas
        u8 max_wait;
        u32 fw_state;
        u32 cur_state;
+       u32 abs_state, curr_abs_state;

        fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) & MFI_STATE_MASK;

@@ -1829,6 +1830,9 @@ megasas_transition_to_ready(struct megas

        while (fw_state != MFI_STATE_READY) {

+               abs_state =
+               instance->instancet->read_fw_status_reg(instance->reg_set);
+
                switch (fw_state) {

                case MFI_STATE_FAULT:
@@ -1854,7 +1858,7 @@ megasas_transition_to_ready(struct megas
                                        &instance->reg_set->inbound_doorbell);
                        }

-                       max_wait = 2;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_WAIT_HANDSHAKE;
                        break;

@@ -1869,7 +1873,7 @@ megasas_transition_to_ready(struct megas
                                writel(MFI_INIT_HOTPLUG,
                                        &instance->reg_set->inbound_doorbell);

-                       max_wait = 10;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_BOOT_MESSAGE_PENDING;
                        break;

@@ -1888,7 +1892,7 @@ megasas_transition_to_ready(struct megas
                                writel(MFI_RESET_FLAGS,
                                        &instance->reg_set->inbound_doorbell);

-                       max_wait = 60;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_OPERATIONAL;
                        break;

@@ -1896,32 +1900,32 @@ megasas_transition_to_ready(struct megas
                        /*
                         * This state should not last for more than 2 seconds
                         */
-                       max_wait = 2;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_UNDEFINED;
                        break;

                case MFI_STATE_BB_INIT:
-                       max_wait = 2;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_BB_INIT;
                        break;

                case MFI_STATE_FW_INIT:
-                       max_wait = 20;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_FW_INIT;
                        break;

                case MFI_STATE_FW_INIT_2:
-                       max_wait = 20;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_FW_INIT_2;
                        break;

                case MFI_STATE_DEVICE_SCAN:
-                       max_wait = 20;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_DEVICE_SCAN;
                        break;

                case MFI_STATE_FLUSH_CACHE:
-                       max_wait = 20;
+                       max_wait = MEGASAS_RESET_WAIT_TIME;
                        cur_state = MFI_STATE_FLUSH_CACHE;
                        break;

@@ -1937,8 +1941,10 @@ megasas_transition_to_ready(struct megas
                for (i = 0; i < (max_wait * 1000); i++) {
                        fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) &
                                        MFI_STATE_MASK ;
+               curr_abs_state =
+               instance->instancet->read_fw_status_reg(instance->reg_set);

-                       if (fw_state == cur_state) {
+                       if (abs_state == curr_abs_state) {
                                msleep(1);
                        } else
                                break;
@@ -1947,7 +1953,7 @@ megasas_transition_to_ready(struct megas
                /*
                 * Return error if fw_state hasn't changed after max_wait
                 */
-               if (fw_state == cur_state) {
+               if (curr_abs_state == abs_state) {
                        printk(KERN_DEBUG "FW state [%d] hasn't changed "
                               "in %d secs\n", fw_state, max_wait);
                        return -ENODEV;
@@ -3515,7 +3521,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
        int error = 0, i;
        void *sense = NULL;
        dma_addr_t sense_handle;
-       u32 *sense_ptr;
+       unsigned long *sense_ptr;

        memset(kbuff_arr, 0, sizeof(kbuff_arr));

@@ -3593,7 +3599,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
                }

                sense_ptr =
-                   (u32 *) ((unsigned long)cmd->frame + ioc->sense_off);
+               (unsigned long *) ((unsigned long)cmd->frame + ioc->sense_off);
                *sense_ptr = sense_handle;
        }

@@ -3624,8 +3630,8 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
                 * sense_ptr points to the location that has the user
                 * sense buffer address
                 */
-               sense_ptr = (u32 *) ((unsigned long)ioc->frame.raw +
-                                    ioc->sense_off);
+               sense_ptr = (unsigned long *) ((unsigned long)ioc->frame.raw +
+                               ioc->sense_off);

                if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
                                 sense, ioc->sense_len)) {

