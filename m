From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/4] megaraid_sas: remove poll_mode_io code
Date: Fri, 6 Jan 2012 17:02:40 -0800
Message-ID: <CAHtARFE5jacKLbMp_3mT02Oih4d8+3x0GEhMdyuiCfj108ayyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8f23443bdfef9404b5e5b8c0
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50517 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066Ab2AGBCl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2012 20:02:41 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm6so1444579wib.19
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2012 17:02:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--e89a8f23443bdfef9404b5e5b8c0
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas removes the poll_mode_io code.
This code has never worked correctly, doesn't disable interrupts when
set as a module parameter, doesn't disable interrupts when set after
driver load time in sysfs node, etc.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2012-01-06
15:04:03.818434869 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-01-06
15:12:43.814280428 -0800
@@ -59,14 +59,6 @@
 #include "megaraid_sas.h"

 /*
- * poll_mode_io:1- schedule complete completion from q cmd
- */
-static unsigned int poll_mode_io;
-module_param_named(poll_mode_io, poll_mode_io, int, 0);
-MODULE_PARM_DESC(poll_mode_io,
-	"Complete cmds from IO path, (default=0)");
-
-/*
  * Number of sectors per IO command
  * Will be set in megasas_init_mfi if user does not provide
  */
@@ -1439,11 +1431,6 @@

 	instance->instancet->fire_cmd(instance, cmd->frame_phys_addr,
 				cmd->frame_count-1, instance->reg_set);
-	/*
-	 * Check if we have pend cmds to be completed
-	 */
-	if (poll_mode_io && atomic_read(&instance->fw_outstanding))
-		tasklet_schedule(&instance->isr_tasklet);

 	return 0;
 out_return_cmd:
@@ -3370,47 +3357,6 @@
 	return -EINVAL;
 }

-/**
- * megasas_start_timer - Initializes a timer object
- * @instance:		Adapter soft state
- * @timer:		timer object to be initialized
- * @fn:			timer function
- * @interval:		time interval between timer function call
- */
-static inline void
-megasas_start_timer(struct megasas_instance *instance,
-			struct timer_list *timer,
-			void *fn, unsigned long interval)
-{
-	init_timer(timer);
-	timer->expires = jiffies + interval;
-	timer->data = (unsigned long)instance;
-	timer->function = fn;
-	add_timer(timer);
-}
-
-/**
- * megasas_io_completion_timer - Timer fn
- * @instance_addr:	Address of adapter soft state
- *
- * Schedules tasklet for cmd completion
- * if poll_mode_io is set
- */
-static void
-megasas_io_completion_timer(unsigned long instance_addr)
-{
-	struct megasas_instance *instance =
-			(struct megasas_instance *)instance_addr;
-
-	if (atomic_read(&instance->fw_outstanding))
-		tasklet_schedule(&instance->isr_tasklet);
-
-	/* Restart timer */
-	if (poll_mode_io)
-		mod_timer(&instance->io_completion_timer,
-			jiffies + MEGASAS_COMPLETION_TIMER_INTERVAL);
-}
-
 static u32
 megasas_init_adapter_mfi(struct megasas_instance *instance)
 {
@@ -3638,11 +3584,6 @@
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		(unsigned long)instance);

-	/* Initialize the cmd completion timer */
-	if (poll_mode_io)
-		megasas_start_timer(instance, &instance->io_completion_timer,
-				megasas_io_completion_timer,
-				MEGASAS_COMPLETION_TIMER_INTERVAL);
 	return 0;

 fail_init_adapter:
@@ -4369,9 +4310,6 @@
 	host = instance->host;
 	instance->unload = 1;

-	if (poll_mode_io)
-		del_timer_sync(&instance->io_completion_timer);
-
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);

@@ -4511,12 +4449,6 @@
 	}

 	instance->instancet->enable_intr(instance->reg_set);
-
-	/* Initialize the cmd completion timer */
-	if (poll_mode_io)
-		megasas_start_timer(instance, &instance->io_completion_timer,
-				megasas_io_completion_timer,
-				MEGASAS_COMPLETION_TIMER_INTERVAL);
 	instance->unload = 0;

 	/*
@@ -4570,9 +4502,6 @@
 	host = instance->host;
 	fusion = instance->ctrl_context;

-	if (poll_mode_io)
-		del_timer_sync(&instance->io_completion_timer);
-
 	scsi_remove_host(instance->host);
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
@@ -5221,60 +5150,6 @@
 static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUSR, megasas_sysfs_show_dbg_lvl,
 		megasas_sysfs_set_dbg_lvl);

-static ssize_t
-megasas_sysfs_show_poll_mode_io(struct device_driver *dd, char *buf)
-{
-	return sprintf(buf, "%u\n", poll_mode_io);
-}
-
-static ssize_t
-megasas_sysfs_set_poll_mode_io(struct device_driver *dd,
-				const char *buf, size_t count)
-{
-	int retval = count;
-	int tmp = poll_mode_io;
-	int i;
-	struct megasas_instance *instance;
-
-	if (sscanf(buf, "%u", &poll_mode_io) < 1) {
-		printk(KERN_ERR "megasas: could not set poll_mode_io\n");
-		retval = -EINVAL;
-	}
-
-	/*
-	 * Check if poll_mode_io is already set or is same as previous value
-	 */
-	if ((tmp && poll_mode_io) || (tmp == poll_mode_io))
-		goto out;
-
-	if (poll_mode_io) {
-		/*
-		 * Start timers for all adapters
-		 */
-		for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-			instance = megasas_mgmt_info.instance[i];
-			if (instance) {
-				megasas_start_timer(instance,
-					&instance->io_completion_timer,
-					megasas_io_completion_timer,
-					MEGASAS_COMPLETION_TIMER_INTERVAL);
-			}
-		}
-	} else {
-		/*
-		 * Delete timers for all adapters
-		 */
-		for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-			instance = megasas_mgmt_info.instance[i];
-			if (instance)
-				del_timer_sync(&instance->io_completion_timer);
-		}
-	}
-
-out:
-	return retval;
-}
-
 static void
 megasas_aen_polling(struct work_struct *work)
 {
@@ -5504,11 +5379,6 @@
 	kfree(ev);
 }

-
-static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
-		megasas_sysfs_show_poll_mode_io,
-		megasas_sysfs_set_poll_mode_io);
-
 /**
  * megasas_init - Driver load entry point
  */
@@ -5568,11 +5438,6 @@
 	if (rval)
 		goto err_dcf_dbg_lvl;
 	rval = driver_create_file(&megasas_pci_driver.driver,
-				  &driver_attr_poll_mode_io);
-	if (rval)
-		goto err_dcf_poll_mode_io;
-
-	rval = driver_create_file(&megasas_pci_driver.driver,
 				&driver_attr_support_device_change);
 	if (rval)
 		goto err_dcf_support_device_change;
@@ -5581,10 +5446,6 @@

 err_dcf_support_device_change:
 	driver_remove_file(&megasas_pci_driver.driver,
-		  &driver_attr_poll_mode_io);
-
-err_dcf_poll_mode_io:
-	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
 err_dcf_dbg_lvl:
 	driver_remove_file(&megasas_pci_driver.driver,
@@ -5609,8 +5470,6 @@
 static void __exit megasas_exit(void)
 {
 	driver_remove_file(&megasas_pci_driver.driver,
-			   &driver_attr_poll_mode_io);
-	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
 	driver_remove_file(&megasas_pci_driver.driver,
 			&driver_attr_support_poll_for_event);
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2012-02-06
12:50:20.000000000 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2012-01-06
15:13:13.723279643 -0800
@@ -773,7 +773,6 @@

 #define MFI_OB_INTR_STATUS_MASK			0x00000002
 #define MFI_POLL_TIMEOUT_SECS			60
-#define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)

 #define MFI_REPLY_1078_MESSAGE_INTERRUPT	0x80000000
 #define MFI_REPLY_GEN2_MESSAGE_INTERRUPT	0x00000001
@@ -1353,7 +1352,6 @@
 	u32 mfiStatus;
 	u32 last_seq_num;

-	struct timer_list io_completion_timer;
 	struct list_head internal_reset_pending_q;

 	/* Ptr to hba specific information */

--e89a8f23443bdfef9404b5e5b8c0
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3xe62s0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTItMDEtMDYgMTU6MDQ6MDMuODE4NDM0ODY5IC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDEyLTAxLTA2IDE1OjEyOjQzLjgxNDI4MDQyOCAtMDgwMApAQCAtNTksMTQgKzU5LDYgQEAK
ICNpbmNsdWRlICJtZWdhcmFpZF9zYXMuaCIKIAogLyoKLSAqIHBvbGxfbW9kZV9pbzoxLSBzY2hl
ZHVsZSBjb21wbGV0ZSBjb21wbGV0aW9uIGZyb20gcSBjbWQKLSAqLwotc3RhdGljIHVuc2lnbmVk
IGludCBwb2xsX21vZGVfaW87Ci1tb2R1bGVfcGFyYW1fbmFtZWQocG9sbF9tb2RlX2lvLCBwb2xs
X21vZGVfaW8sIGludCwgMCk7Ci1NT0RVTEVfUEFSTV9ERVNDKHBvbGxfbW9kZV9pbywKLQkiQ29t
cGxldGUgY21kcyBmcm9tIElPIHBhdGgsIChkZWZhdWx0PTApIik7Ci0KLS8qCiAgKiBOdW1iZXIg
b2Ygc2VjdG9ycyBwZXIgSU8gY29tbWFuZAogICogV2lsbCBiZSBzZXQgaW4gbWVnYXNhc19pbml0
X21maSBpZiB1c2VyIGRvZXMgbm90IHByb3ZpZGUKICAqLwpAQCAtMTQzOSwxMSArMTQzMSw2IEBA
CiAKIAlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0YW5jZSwgY21kLT5mcmFtZV9w
aHlzX2FkZHIsCiAJCQkJY21kLT5mcmFtZV9jb3VudC0xLCBpbnN0YW5jZS0+cmVnX3NldCk7Ci0J
LyoKLQkgKiBDaGVjayBpZiB3ZSBoYXZlIHBlbmQgY21kcyB0byBiZSBjb21wbGV0ZWQKLQkgKi8K
LQlpZiAocG9sbF9tb2RlX2lvICYmIGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRp
bmcpKQotCQl0YXNrbGV0X3NjaGVkdWxlKCZpbnN0YW5jZS0+aXNyX3Rhc2tsZXQpOwogCiAJcmV0
dXJuIDA7CiBvdXRfcmV0dXJuX2NtZDoKQEAgLTMzNzAsNDcgKzMzNTcsNiBAQAogCXJldHVybiAt
RUlOVkFMOwogfQogCi0vKioKLSAqIG1lZ2FzYXNfc3RhcnRfdGltZXIgLSBJbml0aWFsaXplcyBh
IHRpbWVyIG9iamVjdAotICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCi0gKiBAdGlt
ZXI6CQl0aW1lciBvYmplY3QgdG8gYmUgaW5pdGlhbGl6ZWQKLSAqIEBmbjoJCQl0aW1lciBmdW5j
dGlvbgotICogQGludGVydmFsOgkJdGltZSBpbnRlcnZhbCBiZXR3ZWVuIHRpbWVyIGZ1bmN0aW9u
IGNhbGwKLSAqLwotc3RhdGljIGlubGluZSB2b2lkCi1tZWdhc2FzX3N0YXJ0X3RpbWVyKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKLQkJCXN0cnVjdCB0aW1lcl9saXN0ICp0aW1l
ciwKLQkJCXZvaWQgKmZuLCB1bnNpZ25lZCBsb25nIGludGVydmFsKQotewotCWluaXRfdGltZXIo
dGltZXIpOwotCXRpbWVyLT5leHBpcmVzID0gamlmZmllcyArIGludGVydmFsOwotCXRpbWVyLT5k
YXRhID0gKHVuc2lnbmVkIGxvbmcpaW5zdGFuY2U7Ci0JdGltZXItPmZ1bmN0aW9uID0gZm47Ci0J
YWRkX3RpbWVyKHRpbWVyKTsKLX0KLQotLyoqCi0gKiBtZWdhc2FzX2lvX2NvbXBsZXRpb25fdGlt
ZXIgLSBUaW1lciBmbgotICogQGluc3RhbmNlX2FkZHI6CUFkZHJlc3Mgb2YgYWRhcHRlciBzb2Z0
IHN0YXRlCi0gKgotICogU2NoZWR1bGVzIHRhc2tsZXQgZm9yIGNtZCBjb21wbGV0aW9uCi0gKiBp
ZiBwb2xsX21vZGVfaW8gaXMgc2V0Ci0gKi8KLXN0YXRpYyB2b2lkCi1tZWdhc2FzX2lvX2NvbXBs
ZXRpb25fdGltZXIodW5zaWduZWQgbG9uZyBpbnN0YW5jZV9hZGRyKQotewotCXN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZSA9Ci0JCQkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKilp
bnN0YW5jZV9hZGRyOwotCi0JaWYgKGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRp
bmcpKQotCQl0YXNrbGV0X3NjaGVkdWxlKCZpbnN0YW5jZS0+aXNyX3Rhc2tsZXQpOwotCi0JLyog
UmVzdGFydCB0aW1lciAqLwotCWlmIChwb2xsX21vZGVfaW8pCi0JCW1vZF90aW1lcigmaW5zdGFu
Y2UtPmlvX2NvbXBsZXRpb25fdGltZXIsCi0JCQlqaWZmaWVzICsgTUVHQVNBU19DT01QTEVUSU9O
X1RJTUVSX0lOVEVSVkFMKTsKLX0KLQogc3RhdGljIHUzMgogbWVnYXNhc19pbml0X2FkYXB0ZXJf
bWZpKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKIHsKQEAgLTM2MzgsMTEgKzM1
ODQsNiBAQAogCXRhc2tsZXRfaW5pdCgmaW5zdGFuY2UtPmlzcl90YXNrbGV0LCBpbnN0YW5jZS0+
aW5zdGFuY2V0LT50YXNrbGV0LAogCQkodW5zaWduZWQgbG9uZylpbnN0YW5jZSk7CiAKLQkvKiBJ
bml0aWFsaXplIHRoZSBjbWQgY29tcGxldGlvbiB0aW1lciAqLwotCWlmIChwb2xsX21vZGVfaW8p
Ci0JCW1lZ2FzYXNfc3RhcnRfdGltZXIoaW5zdGFuY2UsICZpbnN0YW5jZS0+aW9fY29tcGxldGlv
bl90aW1lciwKLQkJCQltZWdhc2FzX2lvX2NvbXBsZXRpb25fdGltZXIsCi0JCQkJTUVHQVNBU19D
T01QTEVUSU9OX1RJTUVSX0lOVEVSVkFMKTsKIAlyZXR1cm4gMDsKIAogZmFpbF9pbml0X2FkYXB0
ZXI6CkBAIC00MzY5LDkgKzQzMTAsNiBAQAogCWhvc3QgPSBpbnN0YW5jZS0+aG9zdDsKIAlpbnN0
YW5jZS0+dW5sb2FkID0gMTsKIAotCWlmIChwb2xsX21vZGVfaW8pCi0JCWRlbF90aW1lcl9zeW5j
KCZpbnN0YW5jZS0+aW9fY29tcGxldGlvbl90aW1lcik7Ci0KIAltZWdhc2FzX2ZsdXNoX2NhY2hl
KGluc3RhbmNlKTsKIAltZWdhc2FzX3NodXRkb3duX2NvbnRyb2xsZXIoaW5zdGFuY2UsIE1SX0RD
TURfSElCRVJOQVRFX1NIVVRET1dOKTsKIApAQCAtNDUxMSwxMiArNDQ0OSw2IEBACiAJfQogCiAJ
aW5zdGFuY2UtPmluc3RhbmNldC0+ZW5hYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOwotCi0J
LyogSW5pdGlhbGl6ZSB0aGUgY21kIGNvbXBsZXRpb24gdGltZXIgKi8KLQlpZiAocG9sbF9tb2Rl
X2lvKQotCQltZWdhc2FzX3N0YXJ0X3RpbWVyKGluc3RhbmNlLCAmaW5zdGFuY2UtPmlvX2NvbXBs
ZXRpb25fdGltZXIsCi0JCQkJbWVnYXNhc19pb19jb21wbGV0aW9uX3RpbWVyLAotCQkJCU1FR0FT
QVNfQ09NUExFVElPTl9USU1FUl9JTlRFUlZBTCk7CiAJaW5zdGFuY2UtPnVubG9hZCA9IDA7CiAK
IAkvKgpAQCAtNDU3MCw5ICs0NTAyLDYgQEAKIAlob3N0ID0gaW5zdGFuY2UtPmhvc3Q7CiAJZnVz
aW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKIAotCWlmIChwb2xsX21vZGVfaW8pCi0JCWRl
bF90aW1lcl9zeW5jKCZpbnN0YW5jZS0+aW9fY29tcGxldGlvbl90aW1lcik7Ci0KIAlzY3NpX3Jl
bW92ZV9ob3N0KGluc3RhbmNlLT5ob3N0KTsKIAltZWdhc2FzX2ZsdXNoX2NhY2hlKGluc3RhbmNl
KTsKIAltZWdhc2FzX3NodXRkb3duX2NvbnRyb2xsZXIoaW5zdGFuY2UsIE1SX0RDTURfQ1RSTF9T
SFVURE9XTik7CkBAIC01MjIxLDYwICs1MTUwLDYgQEAKIHN0YXRpYyBEUklWRVJfQVRUUihkYmdf
bHZsLCBTX0lSVUdPfFNfSVdVU1IsIG1lZ2FzYXNfc3lzZnNfc2hvd19kYmdfbHZsLAogCQltZWdh
c2FzX3N5c2ZzX3NldF9kYmdfbHZsKTsKIAotc3RhdGljIHNzaXplX3QKLW1lZ2FzYXNfc3lzZnNf
c2hvd19wb2xsX21vZGVfaW8oc3RydWN0IGRldmljZV9kcml2ZXIgKmRkLCBjaGFyICpidWYpCi17
Ci0JcmV0dXJuIHNwcmludGYoYnVmLCAiJXVcbiIsIHBvbGxfbW9kZV9pbyk7Ci19Ci0KLXN0YXRp
YyBzc2l6ZV90Ci1tZWdhc2FzX3N5c2ZzX3NldF9wb2xsX21vZGVfaW8oc3RydWN0IGRldmljZV9k
cml2ZXIgKmRkLAotCQkJCWNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KQotewotCWludCBy
ZXR2YWwgPSBjb3VudDsKLQlpbnQgdG1wID0gcG9sbF9tb2RlX2lvOwotCWludCBpOwotCXN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKLQotCWlmIChzc2NhbmYoYnVmLCAiJXUiLCAm
cG9sbF9tb2RlX2lvKSA8IDEpIHsKLQkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBjb3VsZCBu
b3Qgc2V0IHBvbGxfbW9kZV9pb1xuIik7Ci0JCXJldHZhbCA9IC1FSU5WQUw7Ci0JfQotCi0JLyoK
LQkgKiBDaGVjayBpZiBwb2xsX21vZGVfaW8gaXMgYWxyZWFkeSBzZXQgb3IgaXMgc2FtZSBhcyBw
cmV2aW91cyB2YWx1ZQotCSAqLwotCWlmICgodG1wICYmIHBvbGxfbW9kZV9pbykgfHwgKHRtcCA9
PSBwb2xsX21vZGVfaW8pKQotCQlnb3RvIG91dDsKLQotCWlmIChwb2xsX21vZGVfaW8pIHsKLQkJ
LyoKLQkJICogU3RhcnQgdGltZXJzIGZvciBhbGwgYWRhcHRlcnMKLQkJICovCi0JCWZvciAoaSA9
IDA7IGkgPCBtZWdhc2FzX21nbXRfaW5mby5tYXhfaW5kZXg7IGkrKykgewotCQkJaW5zdGFuY2Ug
PSBtZWdhc2FzX21nbXRfaW5mby5pbnN0YW5jZVtpXTsKLQkJCWlmIChpbnN0YW5jZSkgewotCQkJ
CW1lZ2FzYXNfc3RhcnRfdGltZXIoaW5zdGFuY2UsCi0JCQkJCSZpbnN0YW5jZS0+aW9fY29tcGxl
dGlvbl90aW1lciwKLQkJCQkJbWVnYXNhc19pb19jb21wbGV0aW9uX3RpbWVyLAotCQkJCQlNRUdB
U0FTX0NPTVBMRVRJT05fVElNRVJfSU5URVJWQUwpOwotCQkJfQotCQl9Ci0JfSBlbHNlIHsKLQkJ
LyoKLQkJICogRGVsZXRlIHRpbWVycyBmb3IgYWxsIGFkYXB0ZXJzCi0JCSAqLwotCQlmb3IgKGkg
PSAwOyBpIDwgbWVnYXNhc19tZ210X2luZm8ubWF4X2luZGV4OyBpKyspIHsKLQkJCWluc3RhbmNl
ID0gbWVnYXNhc19tZ210X2luZm8uaW5zdGFuY2VbaV07Ci0JCQlpZiAoaW5zdGFuY2UpCi0JCQkJ
ZGVsX3RpbWVyX3N5bmMoJmluc3RhbmNlLT5pb19jb21wbGV0aW9uX3RpbWVyKTsKLQkJfQotCX0K
LQotb3V0OgotCXJldHVybiByZXR2YWw7Ci19Ci0KIHN0YXRpYyB2b2lkCiBtZWdhc2FzX2Flbl9w
b2xsaW5nKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIHsKQEAgLTU1MDQsMTEgKzUzNzksNiBA
QAogCWtmcmVlKGV2KTsKIH0KIAotCi1zdGF0aWMgRFJJVkVSX0FUVFIocG9sbF9tb2RlX2lvLCBT
X0lSVUdPfFNfSVdVU1IsCi0JCW1lZ2FzYXNfc3lzZnNfc2hvd19wb2xsX21vZGVfaW8sCi0JCW1l
Z2FzYXNfc3lzZnNfc2V0X3BvbGxfbW9kZV9pbyk7Ci0KIC8qKgogICogbWVnYXNhc19pbml0IC0g
RHJpdmVyIGxvYWQgZW50cnkgcG9pbnQKICAqLwpAQCAtNTU2OCwxMSArNTQzOCw2IEBACiAJaWYg
KHJ2YWwpCiAJCWdvdG8gZXJyX2RjZl9kYmdfbHZsOwogCXJ2YWwgPSBkcml2ZXJfY3JlYXRlX2Zp
bGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsCi0JCQkJICAmZHJpdmVyX2F0dHJfcG9sbF9t
b2RlX2lvKTsKLQlpZiAocnZhbCkKLQkJZ290byBlcnJfZGNmX3BvbGxfbW9kZV9pbzsKLQotCXJ2
YWwgPSBkcml2ZXJfY3JlYXRlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsCiAJCQkJ
JmRyaXZlcl9hdHRyX3N1cHBvcnRfZGV2aWNlX2NoYW5nZSk7CiAJaWYgKHJ2YWwpCiAJCWdvdG8g
ZXJyX2RjZl9zdXBwb3J0X2RldmljZV9jaGFuZ2U7CkBAIC01NTgxLDEwICs1NDQ2LDYgQEAKIAog
ZXJyX2RjZl9zdXBwb3J0X2RldmljZV9jaGFuZ2U6CiAJZHJpdmVyX3JlbW92ZV9maWxlKCZtZWdh
c2FzX3BjaV9kcml2ZXIuZHJpdmVyLAotCQkgICZkcml2ZXJfYXR0cl9wb2xsX21vZGVfaW8pOwot
Ci1lcnJfZGNmX3BvbGxfbW9kZV9pbzoKLQlkcml2ZXJfcmVtb3ZlX2ZpbGUoJm1lZ2FzYXNfcGNp
X2RyaXZlci5kcml2ZXIsCiAJCQkgICAmZHJpdmVyX2F0dHJfZGJnX2x2bCk7CiBlcnJfZGNmX2Ri
Z19sdmw6CiAJZHJpdmVyX3JlbW92ZV9maWxlKCZtZWdhc2FzX3BjaV9kcml2ZXIuZHJpdmVyLApA
QCAtNTYwOSw4ICs1NDcwLDYgQEAKIHN0YXRpYyB2b2lkIF9fZXhpdCBtZWdhc2FzX2V4aXQodm9p
ZCkKIHsKIAlkcml2ZXJfcmVtb3ZlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsCi0J
CQkgICAmZHJpdmVyX2F0dHJfcG9sbF9tb2RlX2lvKTsKLQlkcml2ZXJfcmVtb3ZlX2ZpbGUoJm1l
Z2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsCiAJCQkgICAmZHJpdmVyX2F0dHJfZGJnX2x2bCk7CiAJ
ZHJpdmVyX3JlbW92ZV9maWxlKCZtZWdhc2FzX3BjaV9kcml2ZXIuZHJpdmVyLAogCQkJJmRyaXZl
cl9hdHRyX3N1cHBvcnRfcG9sbF9mb3JfZXZlbnQpOwpkaWZmIC1OYXVyIHNjc2ktbWlzYy0yLjYv
ZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIHNjc2ktbWlzYy0yLjYubmV3L2Ry
aXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gc2NzaS1taXNjLTIuNi9kcml2
ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMi0wMi0wNiAxMjo1MDoyMC4wMDAw
MDAwMDAgLTA4MDAKKysrIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXMuaAkyMDEyLTAxLTA2IDE1OjEzOjEzLjcyMzI3OTY0MyAtMDgwMApAQCAtNzcz
LDcgKzc3Myw2IEBACiAKICNkZWZpbmUgTUZJX09CX0lOVFJfU1RBVFVTX01BU0sJCQkweDAwMDAw
MDAyCiAjZGVmaW5lIE1GSV9QT0xMX1RJTUVPVVRfU0VDUwkJCTYwCi0jZGVmaW5lIE1FR0FTQVNf
Q09NUExFVElPTl9USU1FUl9JTlRFUlZBTCAgICAgIChIWi8xMCkKIAogI2RlZmluZSBNRklfUkVQ
TFlfMTA3OF9NRVNTQUdFX0lOVEVSUlVQVAkweDgwMDAwMDAwCiAjZGVmaW5lIE1GSV9SRVBMWV9H
RU4yX01FU1NBR0VfSU5URVJSVVBUCTB4MDAwMDAwMDEKQEAgLTEzNTMsNyArMTM1Miw2IEBACiAJ
dTMyIG1maVN0YXR1czsKIAl1MzIgbGFzdF9zZXFfbnVtOwogCi0Jc3RydWN0IHRpbWVyX2xpc3Qg
aW9fY29tcGxldGlvbl90aW1lcjsKIAlzdHJ1Y3QgbGlzdF9oZWFkIGludGVybmFsX3Jlc2V0X3Bl
bmRpbmdfcTsKIAogCS8qIFB0ciB0byBoYmEgc3BlY2lmaWMgaW5mb3JtYXRpb24gKi8K
--e89a8f23443bdfef9404b5e5b8c0--
