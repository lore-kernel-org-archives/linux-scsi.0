From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: I2O enhancement for Adaptec management software
Date: Mon, 05 Apr 2004 11:43:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40712A47.4090903@shadowconnect.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000208050705050902060103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:32417 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261648AbUDEJmJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 05:42:09 -0400
Received: from pd95234f4.dip.t-dialin.net ([217.82.52.244] helo=shadowconnect.com)
	by mail.shadowconnect.com with asmtp (TLSv1:AES256-SHA:256)
	(Exim 4.21)
	id 1BAQcI-0001AQ-2U
	for linux-scsi@vger.kernel.org; Mon, 05 Apr 2004 11:42:06 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000208050705050902060103
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

This patch allows Adaptec's management software (raidutils) to work with 
the I2O subsystem with DPT RAID hardware.  The previous release of 
raidutils from Adaptec works only with the obsolete dpt_i2o driver in 
the 2.4.x kernel.  Adaptec has since released raidutils under the BSD 
license, and development of raidutils will proceed at the new I2O 
development homepage:

http://i2o.shadowconnect.com/

To achive this, there need to be an function in i2o_config, which passes 
the commands to the controller. At the moment the function is only 
copied over from dpt_i2o, but it works fine.  Future plans for raidutils 
is to make necessary changes to the kernel or utils to make it fully 
functional on x86-64.  Further details, patches, raidutils sources, and 
I2O development news will be maintained at the I2O homepage.

If you have any suggestions, please feel free to contact me.

Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com


--------------000208050705050902060103
Content-Type: text/plain;
 name="i2o-passthru.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="i2o-passthru.patch"

--- a/drivers/message/i2o/i2o_config.c	2004-02-18 04:59:26.000000000 +0100
+++ b/drivers/message/i2o/i2o_config.c	2004-03-03 17:14:38.035056342 +0100
@@ -5,21 +5,24 @@
  *	
  * Written by Alan Cox, Building Number Three Ltd
  *
- * Modified 04/20/1999 by Deepak Saxena
- *   - Added basic ioctl() support
- * Modified 06/07/1999 by Deepak Saxena
- *   - Added software download ioctl (still testing)
- * Modified 09/10/1999 by Auvo Häkkinen
- *   - Changes to i2o_cfg_reply(), ioctl_parms()
- *   - Added ioct_validate()
- * Modified 09/30/1999 by Taneli Vähäkangas
- *   - Fixed ioctl_swdl()
- * Modified 10/04/1999 by Taneli Vähäkangas
- *   - Changed ioctl_swdl(), implemented ioctl_swul() and ioctl_swdel()
- * Modified 11/18/1999 by Deepak Saxena
- *   - Added event managmenet support
- *
- * 2.4 rewrite ported to 2.5 - Alan Cox <alan@redhat.com>
+ * Fixes/additions:
+ *	Deepak Saxena (04/20/1999):
+ *		Added basic ioctl() support
+ *	Deepak Saxena (06/07/1999):
+ *		Added software download ioctl (still testing)
+ *	Auvo Häkkinen (09/10/1999):
+ *		Changes to i2o_cfg_reply(), ioctl_parms()
+ *		Added ioct_validate()
+ *	Taneli Vähäkangas (09/30/1999):
+ *		Fixed ioctl_swdl()
+ *	Taneli Vähäkangas (10/04/1999):
+ *		Changed ioctl_swdl(), implemented ioctl_swul() and ioctl_swdel()
+ *	Deepak Saxena (11/18/1999):
+ *		Added event managmenet support
+ *	Alan Cox <alan@redhat.com>:
+ *		2.4 rewrite ported to 2.5
+ *	Markus Lidel <Markus.Lidel@shadowconnect.com>:
+ *		Added pass-thru support for Adaptec's raidutils
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -75,6 +76,7 @@
 static int ioctl_validate(unsigned long); 
 static int ioctl_evt_reg(unsigned long, struct file *);
 static int ioctl_evt_get(unsigned long, struct file *);
+static int ioctl_passthru(unsigned long);
 static int cfg_fasync(int, struct file*, int);
 
 /*
@@ -256,6 +258,10 @@
 			ret = ioctl_evt_get(arg, fp);
 			break;
 
+		case I2OPASSTHRU:
+			ret = ioctl_passthru(arg);
+			break;
+
 		default:
 			ret = -EINVAL;
 	}
@@ -827,6 +833,170 @@
 	return 0;
 }
 
+static int ioctl_passthru(unsigned long arg)
+{
+	/* FIX: we have to move it to i2o.h, but don't know if it's already
+	 *      defined there. so we make it quick and dirty.
+	 */
+	#define MAX_MESSAGE_SIZE (128)
+	#define REPLY_FRAME_SIZE (17)
+	#define SG_TABLESIZE (30)
+
+	struct sg_simple_element {
+		u32  flag_count;
+		u32 addr_bus;
+	};
+
+	struct i2o_cmd_passthru *cmd = (struct i2o_cmd_passthru *) arg;
+	struct i2o_controller *c;
+	u32 msg[MAX_MESSAGE_SIZE];
+	u32 *user_msg = (u32*)cmd->msg;
+	u32 *reply = NULL;
+	u32 *user_reply = NULL;
+	u32 size = 0;
+	u32 reply_size = 0;
+	u32 rcode = 0;
+	ulong sg_list[SG_TABLESIZE];
+	u32 sg_offset = 0;
+	u32 sg_count = 0;
+	int sg_index = 0;
+	u32 i = 0;
+	ulong p = 0;
+
+        c=i2o_find_controller(cmd->iop);
+	if(c == NULL)
+                return -ENXIO;
+
+	memset(&msg, 0, MAX_MESSAGE_SIZE*4);
+	if(get_user(size, &user_msg[0]))
+		return -EFAULT;
+	size = size>>16;
+
+	user_reply = &user_msg[size];
+	if(size > MAX_MESSAGE_SIZE)
+		return -EFAULT;
+	size *= 4; // Convert to bytes
+                                              
+	/* Copy in the user's I2O command */
+	if(copy_from_user((void*)msg, (void*)user_msg, size))
+		return -EFAULT;
+	get_user(reply_size, &user_reply[0]);
+	reply_size = reply_size>>16;
+	reply = kmalloc(REPLY_FRAME_SIZE*4, GFP_KERNEL);
+	if(reply == NULL) {
+		printk(KERN_WARNING"%s: Could not allocate reply buffer\n",c->name);
+		return -ENOMEM;
+	}
+	memset(reply, 0, REPLY_FRAME_SIZE*4);
+	sg_offset = (msg[0]>>4)&0x0f;
+	msg[2] = (u32)i2o_cfg_context;
+	msg[3] = (u32)reply;
+
+	memset(sg_list,0, sizeof(sg_list[0])*SG_TABLESIZE);
+	if(sg_offset) {
+		
+		// TODO 64bit fix
+		struct sg_simple_element *sg =  (struct sg_simple_element*) (msg+sg_offset);
+		sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
+		if (sg_count > SG_TABLESIZE){
+			printk(KERN_DEBUG"%s:IOCTL SG List too large (%u)\n", c->name,sg_count);
+			kfree (reply);
+			return -EINVAL;
+		}
+
+		for(i = 0; i < sg_count; i++) {
+			int sg_size;
+			                                                                     
+			if (!(sg[i].flag_count & 0x10000000 /*I2O_SGL_FLAGS_SIMPLE_ADDRESS_ELEMENT*/)) {
+				printk(KERN_DEBUG"%s:Bad SG element %d - not simple (%x)\n",c->name,i,  sg[i].flag_count);
+				rcode = -EINVAL;
+				goto cleanup;
+			}
+			sg_size = sg[i].flag_count & 0xffffff;
+			/* Allocate memory for the transfer */
+			p = (ulong)kmalloc(sg_size, GFP_KERNEL);
+			if(p == 0) {
+				printk(KERN_DEBUG"%s: Could not allocate SG buffer - size = %d buffer number %d of %d\n", c->name,sg_size,i,sg_count);
+				rcode = -ENOMEM;
+				goto cleanup;
+			}
+			sg_list[sg_index++] = p; // sglist indexed with input frame, not our internal frame.
+			/* Copy in the user's SG buffer if necessary */
+			if(sg[i].flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR*/) {
+				// TODO 64bit fix
+			        if (copy_from_user((void*)p,(void*)sg[i].addr_bus, sg_size)) {
+					printk(KERN_DEBUG"%s: Could not copy SG buf %d FROM user\n",c->name,i);
+					rcode = -EFAULT;
+					goto cleanup;
+				}
+			}
+			//TODO 64bit fix
+			sg[i].addr_bus = (u32)virt_to_bus((void*)p);
+		}
+	}
+
+	rcode = i2o_post_wait(c, msg, size, 60);
+	if(rcode)
+		goto cleanup;
+
+	if(sg_offset) {
+		/* Copy back the Scatter Gather buffers back to user space */
+		u32 j;
+		// TODO 64bit fix
+		struct sg_simple_element* sg;
+		int sg_size;
+										                                                                                
+		// re-acquire the original message to handle correctly the sg copy operation
+		memset(&msg, 0, MAX_MESSAGE_SIZE*4);
+		// get user msg size in u32s
+		if(get_user(size, &user_msg[0])){
+			rcode = -EFAULT;
+			goto cleanup;
+		}
+		size = size>>16;
+		size *= 4;
+		/* Copy in the user's I2O command */
+		if (copy_from_user ((void*)msg, (void*)user_msg, size)) {
+			rcode = -EFAULT;
+			goto cleanup;
+		}
+		sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
+
+		 // TODO 64bit fix
+		sg = (struct sg_simple_element*)(msg + sg_offset);
+		for (j = 0; j < sg_count; j++) {
+			/* Copy out the SG list to user's buffer if necessary */
+			if(! (sg[j].flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR*/)) {
+				sg_size = sg[j].flag_count & 0xffffff;
+				// TODO 64bit fix
+				if (copy_to_user((void*)sg[j].addr_bus,(void*)sg_list[j], sg_size)) {
+					printk(KERN_WARNING"%s: Could not copy %lx TO user %x\n",c->name, sg_list[j], sg[j].addr_bus);
+					rcode = -EFAULT;
+					goto cleanup;
+				}
+			}
+		}
+	}
+	
+	/* Copy back the reply to user space */
+        if (reply_size) {
+		// we wrote our own values for context - now restore the user supplied ones
+		if(copy_from_user(reply+2, user_msg+2, sizeof(u32)*2)) {
+			printk(KERN_WARNING"%s: Could not copy message context FROM user\n",c->name);
+			rcode = -EFAULT;
+		}
+		if(copy_to_user(user_reply, reply, reply_size)) {
+			printk(KERN_WARNING"%s: Could not copy reply TO user\n",c->name);
+			rcode = -EFAULT;
+		}
+	}
+
+cleanup:
+	kfree(reply);
+	i2o_unlock_controller(c);
+	return rcode;
+}		
+
 static int cfg_open(struct inode *inode, struct file *file)
 {
 	struct i2o_cfg_info *tmp = 
--- a/include/linux/i2o-dev.h	2004-03-01 23:18:47.000000000 +0100
+++ b/include/linux/i2o-dev.h	2004-03-03 17:36:20.129361237 +0100
@@ -41,6 +41,14 @@
 #define I2OHTML 		_IOWR(I2O_MAGIC_NUMBER,9,struct i2o_html)
 #define I2OEVTREG		_IOW(I2O_MAGIC_NUMBER,10,struct i2o_evt_id)
 #define I2OEVTGET		_IOR(I2O_MAGIC_NUMBER,11,struct i2o_evt_info)
+#define I2OPASSTHRU		_IOR(I2O_MAGIC_NUMBER,12,struct i2o_cmd_passthru)
+
+struct i2o_cmd_passthru
+{
+	void *msg;		/* message */
+	int iop;		/* number of the I2O controller, to which the
+				   message should go to */
+};
 
 struct i2o_cmd_hrtlct
 {

--------------000208050705050902060103--
