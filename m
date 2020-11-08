Return-Path: <SRS0=09q6=EO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390C2C55ABD
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Nov 2020 21:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94F3206ED
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Nov 2020 21:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgKHVKk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Nov 2020 16:10:40 -0500
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:33438 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727570AbgKHVKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2020 16:10:39 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id DF649837F24F;
        Sun,  8 Nov 2020 21:10:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: farm15_05178bf272e6
X-Filterd-Recvd-Size: 33534
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Sun,  8 Nov 2020 21:10:35 +0000 (UTC)
Message-ID: <0c4a15921d3093fbeba1bcc1a7e1dd9f26220e11.camel@perches.com>
Subject: Re: [PATCH] scsi: core: fix -Wformat
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Sun, 08 Nov 2020 13:10:33 -0800
In-Reply-To: <20201107081132.2629071-1-ndesaulniers@google.com>
References: <20201107081132.2629071-1-ndesaulniers@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-11-07 at 00:11 -0800, Nick Desaulniers wrote:
> Clang is more aggressive about -Wformat warnings when the format flag
> specifies a type smaller than the parameter. Turns out, struct
> Scsi_Host's member can_queue is actually an int. Fixes:
> 
> warning: format specifies type 'short' but the argument has type 'int'
> [-Wformat]
> shost_rd_attr(can_queue, "%hd\n");
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                           %d
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d6e344fa33ad..b6378c8ca783 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -370,7 +370,7 @@ static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store
>  
> 
>  shost_rd_attr(unique_id, "%u\n");
>  shost_rd_attr(cmd_per_lun, "%hd\n");
> -shost_rd_attr(can_queue, "%hd\n");
> +shost_rd_attr(can_queue, "%d\n");
>  shost_rd_attr(sg_tablesize, "%hu\n");
>  shost_rd_attr(sg_prot_tablesize, "%hu\n");
>  shost_rd_attr(unchecked_isa_dma, "%d\n");

Another option might be to reconfigure the whole sysfs output bits of
this file.

This is an unintended to be applied patch that likely could be a series:

o use sysfs_emit and not the sprintf family
o rename all the show/store macros and functions to move the show/store to
  the end of the name
o move the format strings used in macro definitions and uses before the
  type to be more similar to printf format then arg
o Convert all the S_<FOO> macros to octal
o Neatens whitespace

Perhaps:
---
 drivers/scsi/scsi_sysfs.c | 363 ++++++++++++++++++++++------------------------
 1 file changed, 177 insertions(+), 186 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6e344fa33ad..c08ce59ad4d0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -153,35 +153,34 @@ static int scsi_scan(struct Scsi_Host *shost, const char *str)
 }
 
 /*
- * shost_show_function: macro to create an attr function that can be used to
+ * shost_function_show: macro to create an attr function that can be used to
  * show a non-bit field.
  */
-#define shost_show_function(name, field, format_string)			\
+#define shost_function_show(name, format, field)			\
 static ssize_t								\
-show_##name (struct device *dev, struct device_attribute *attr, 	\
-	     char *buf)							\
+name##_show(struct device *dev, struct device_attribute *attr, char *buf) \
 {									\
 	struct Scsi_Host *shost = class_to_shost(dev);			\
-	return snprintf (buf, 20, format_string, shost->field);		\
+	return sysfs_emit(buf, format "\n", shost->field);		\
 }
 
 /*
  * shost_rd_attr: macro to create a function and attribute variable for a
  * read only field.
  */
-#define shost_rd_attr2(name, field, format_string)			\
-	shost_show_function(name, field, format_string)			\
-static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL);
+#define shost_rd_attr2(name, format, field)				\
+	shost_function_show(name, format, field)			\
+static DEVICE_ATTR(name, 0444, name##_show, NULL);
 
-#define shost_rd_attr(field, format_string) \
-shost_rd_attr2(field, field, format_string)
+#define shost_rd_attr(format, field)					\
+	shost_rd_attr2(field, format, field)
 
 /*
  * Create the actual show/store functions and data structures.
  */
 
 static ssize_t
-store_scan(struct device *dev, struct device_attribute *attr,
+scan_store(struct device *dev, struct device_attribute *attr,
 	   const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
@@ -192,10 +191,10 @@ store_scan(struct device *dev, struct device_attribute *attr,
 		res = count;
 	return res;
 };
-static DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
+static DEVICE_ATTR(scan, 0200, NULL, scan_store);
 
 static ssize_t
-store_shost_state(struct device *dev, struct device_attribute *attr,
+shost_state_store(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
 	int i;
@@ -219,7 +218,7 @@ store_shost_state(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
+shost_state_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	const char *name = scsi_host_state_name(shost->shost_state);
@@ -227,31 +226,31 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 	if (!name)
 		return -EINVAL;
 
-	return snprintf(buf, 20, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
 static struct device_attribute dev_attr_hstate =
-	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
+	__ATTR(state, 0644, shost_state_show, shost_state_store);
 
 static ssize_t
-show_shost_mode(unsigned int mode, char *buf)
+shost_mode_show(unsigned int mode, char *buf)
 {
-	ssize_t len = 0;
+	int len = 0;
 
 	if (mode & MODE_INITIATOR)
-		len = sprintf(buf, "%s", "Initiator");
+		len += sysfs_emit_at(buf, len, "Initiator");
 
 	if (mode & MODE_TARGET)
-		len += sprintf(buf + len, "%s%s", len ? ", " : "", "Target");
+		len += sysfs_emit_at(buf, len, "%sTarget", len ? ", " : "");
 
-	len += sprintf(buf + len, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 
 	return len;
 }
 
 static ssize_t
-show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
+shost_supported_mode_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
@@ -261,24 +260,24 @@ show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
 		/* by default this should be initiator */
 		supported_mode = MODE_INITIATOR;
 
-	return show_shost_mode(supported_mode, buf);
+	return shost_mode_show(supported_mode, buf);
 }
 
-static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
+static DEVICE_ATTR(supported_mode, 0644, shost_supported_mode_show, NULL);
 
 static ssize_t
-show_shost_active_mode(struct device *dev,
-		       struct device_attribute *attr, char *buf)
+shost_active_mode_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	if (shost->active_mode == MODE_UNKNOWN)
-		return snprintf(buf, 20, "unknown\n");
-	else
-		return show_shost_mode(shost->active_mode, buf);
+		return sysfs_emit(buf, "unknown\n");
+
+	return shost_mode_show(shost->active_mode, buf);
 }
 
-static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
+static DEVICE_ATTR(active_mode, 0644, shost_active_mode_show, NULL);
 
 static int check_reset_type(const char *str)
 {
@@ -291,8 +290,8 @@ static int check_reset_type(const char *str)
 }
 
 static ssize_t
-store_host_reset(struct device *dev, struct device_attribute *attr,
-		const char *buf, size_t count)
+host_reset_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct scsi_host_template *sht = shost->hostt;
@@ -301,35 +300,35 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
 
 	type = check_reset_type(buf);
 	if (!type)
-		goto exit_store_host_reset;
+		goto exit_host_reset_store;
 
 	if (sht->host_reset)
 		ret = sht->host_reset(shost, type);
 	else
 		ret = -EOPNOTSUPP;
 
-exit_store_host_reset:
+exit_host_reset_store:
 	if (ret == 0)
 		ret = count;
 	return ret;
 }
 
-static DEVICE_ATTR(host_reset, S_IWUSR, NULL, store_host_reset);
+static DEVICE_ATTR(host_reset, 0200, NULL, host_reset_store);
 
 static ssize_t
-show_shost_eh_deadline(struct device *dev,
-		      struct device_attribute *attr, char *buf)
+shost_eh_deadline_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	if (shost->eh_deadline == -1)
-		return snprintf(buf, strlen("off") + 2, "off\n");
-	return sprintf(buf, "%u\n", shost->eh_deadline / HZ);
+		return sysfs_emit(buf, "off\n");
+	return sysfs_emit(buf, "%u\n", shost->eh_deadline / HZ);
 }
 
 static ssize_t
-store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
-		const char *buf, size_t count)
+shost_eh_deadline_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	int ret = -EINVAL;
@@ -366,42 +365,42 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 	return ret;
 }
 
-static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store_shost_eh_deadline);
+static DEVICE_ATTR(eh_deadline, 0644, shost_eh_deadline_show, shost_eh_deadline_store);
 
-shost_rd_attr(unique_id, "%u\n");
-shost_rd_attr(cmd_per_lun, "%hd\n");
-shost_rd_attr(can_queue, "%hd\n");
-shost_rd_attr(sg_tablesize, "%hu\n");
-shost_rd_attr(sg_prot_tablesize, "%hu\n");
-shost_rd_attr(unchecked_isa_dma, "%d\n");
-shost_rd_attr(prot_capabilities, "%u\n");
-shost_rd_attr(prot_guard_type, "%hd\n");
-shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
+shost_rd_attr("%u", unique_id);
+shost_rd_attr("%hd", cmd_per_lun);
+shost_rd_attr("%d", can_queue);
+shost_rd_attr("%hu", sg_tablesize);
+shost_rd_attr("%hu", sg_prot_tablesize);
+shost_rd_attr("%d", unchecked_isa_dma);
+shost_rd_attr("%u", prot_capabilities);
+shost_rd_attr("%hd", prot_guard_type);
+shost_rd_attr2(proc_name, "%s", hostt->proc_name);
 
 static ssize_t
-show_host_busy(struct device *dev, struct device_attribute *attr, char *buf)
+host_busy_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
-	return snprintf(buf, 20, "%d\n", scsi_host_busy(shost));
+	return sysfs_emit(buf, "%d\n", scsi_host_busy(shost));
 }
-static DEVICE_ATTR(host_busy, S_IRUGO, show_host_busy, NULL);
+static DEVICE_ATTR(host_busy, 0444, host_busy_show, NULL);
 
 static ssize_t
-show_use_blk_mq(struct device *dev, struct device_attribute *attr, char *buf)
+use_blk_mq_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "1\n");
+	return sysfs_emit(buf, "1\n");
 }
-static DEVICE_ATTR(use_blk_mq, S_IRUGO, show_use_blk_mq, NULL);
+static DEVICE_ATTR(use_blk_mq, 0444, use_blk_mq_show, NULL);
 
 static ssize_t
-show_nr_hw_queues(struct device *dev, struct device_attribute *attr, char *buf)
+nr_hw_queues_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct blk_mq_tag_set *tag_set = &shost->tag_set;
 
-	return snprintf(buf, 20, "%d\n", tag_set->nr_hw_queues);
+	return sysfs_emit(buf, "%d\n", tag_set->nr_hw_queues);
 }
-static DEVICE_ATTR(nr_hw_queues, S_IRUGO, show_nr_hw_queues, NULL);
+static DEVICE_ATTR(nr_hw_queues, 0444, nr_hw_queues_show, NULL);
 
 static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_use_blk_mq.attr,
@@ -573,59 +572,58 @@ void scsi_sysfs_unregister(void)
 }
 
 /*
- * sdev_show_function: macro to create an attr function that can be used to
+ * sdev_function_show: macro to create an attr function that can be used to
  * show a non-bit field.
  */
-#define sdev_show_function(field, format_string)				\
+#define sdev_function_show(format, field)				\
 static ssize_t								\
-sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
-		   char *buf)						\
+sdev_##field##_show(struct device *dev, struct device_attribute *attr,	\
+		    char *buf)						\
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	return snprintf (buf, 20, format_string, sdev->field);		\
+	return sysfs_emit(buf, format "\n", sdev->field);		\
 }									\
 
 /*
  * sdev_rd_attr: macro to create a function and attribute variable for a
  * read only field.
  */
-#define sdev_rd_attr(field, format_string)				\
-	sdev_show_function(field, format_string)			\
-static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
-
+#define sdev_rd_attr(format, field)					\
+	sdev_function_show(format, field)				\
+static DEVICE_ATTR(field, 0444, sdev_##field##_show, NULL)
 
 /*
  * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
-#define sdev_rw_attr(field, format_string)				\
-	sdev_show_function(field, format_string)				\
+#define sdev_rw_attr(format, field)					\
+	sdev_function_show(format, field)				\
 									\
 static ssize_t								\
-sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
-		    const char *buf, size_t count)			\
+sdev_##field##_store(struct device *dev, struct device_attribute *attr, \
+		     const char *buf, size_t count)			\
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	sscanf (buf, format_string, &sdev->field);			\
+	sscanf(buf, format, &sdev->field);				\
 	return count;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
+static DEVICE_ATTR(field, 0644, sdev_##field##_show, sdev_##field##_store);
 
 /* Currently we don't export bit fields, but we might in future,
  * so leave this code in */
 #if 0
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rd_attr_bit: create a function and attribute variable for a
  * read/write bit field.
  */
 #define sdev_rw_attr_bit(field)						\
-	sdev_show_function(field, "%d\n")					\
+	sdev_function_show("%d", field)					\
 									\
 static ssize_t								\
-sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
-		    const char *buf, size_t count)			\
+sdev_##field##_store(struct device *dev, struct device_attribute *attr, \
+		     const char *buf, size_t count)			\
 {									\
 	int ret;							\
 	struct scsi_device *sdev;					\
@@ -637,7 +635,7 @@ sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
 	}								\
 	return ret;							\
 }									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
+static DEVICE_ATTR(field, 0644, sdev_##field##_show, sdev_##field##_store)
 
 /*
  * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "1",
@@ -650,7 +648,7 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 			return 1;
 		else if (buf[0] == '0')
 			return 0;
-		else 
+		else
 			return -EINVAL;
 	} else
 		return -EINVAL;
@@ -659,65 +657,66 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 /*
  * Create the actual show/store functions and data structures.
  */
-sdev_rd_attr (type, "%d\n");
-sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (vendor, "%.8s\n");
-sdev_rd_attr (model, "%.16s\n");
-sdev_rd_attr (rev, "%.4s\n");
+sdev_rd_attr("%d", type);
+sdev_rd_attr("%d", scsi_level);
+sdev_rd_attr("%.8s", vendor);
+sdev_rd_attr("%.16s", model);
+sdev_rd_attr("%.4s", rev);
 
 static ssize_t
-sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
-		char *buf)
+sdev_device_busy_show(struct device *dev, struct device_attribute *attr,
+		      char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_busy));
+	return sysfs_emit(buf, "%d\n", atomic_read(&sdev->device_busy));
 }
-static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
+static DEVICE_ATTR(device_busy, 0444, sdev_device_busy_show, NULL);
 
 static ssize_t
-sdev_show_device_blocked(struct device *dev, struct device_attribute *attr,
-		char *buf)
+sdev_device_blocked_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_blocked));
+	return sysfs_emit(buf, "%d\n", atomic_read(&sdev->device_blocked));
 }
-static DEVICE_ATTR(device_blocked, S_IRUGO, sdev_show_device_blocked, NULL);
+static DEVICE_ATTR(device_blocked, 0444, sdev_device_blocked_show, NULL);
 
 /*
  * TODO: can we make these symlinks to the block layer ones?
  */
 static ssize_t
-sdev_show_timeout (struct device *dev, struct device_attribute *attr, char *buf)
+sdev_timeout_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", sdev->request_queue->rq_timeout / HZ);
+	return sysfs_emit(buf, "%d\n", sdev->request_queue->rq_timeout / HZ);
 }
 
 static ssize_t
-sdev_store_timeout (struct device *dev, struct device_attribute *attr,
-		    const char *buf, size_t count)
+sdev_timeout_store(struct device *dev, struct device_attribute *attr,
+		   const char *buf, size_t count)
 {
 	struct scsi_device *sdev;
 	int timeout;
 	sdev = to_scsi_device(dev);
-	sscanf (buf, "%d\n", &timeout);
+	sscanf(buf, "%d\n", &timeout);
 	blk_queue_rq_timeout(sdev->request_queue, timeout * HZ);
 	return count;
 }
-static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
+static DEVICE_ATTR(timeout, 0644, sdev_timeout_show, sdev_timeout_store);
 
 static ssize_t
-sdev_show_eh_timeout(struct device *dev, struct device_attribute *attr, char *buf)
+sdev_eh_timeout_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%u\n", sdev->eh_timeout / HZ);
+	return sysfs_emit(buf, "%u\n", sdev->eh_timeout / HZ);
 }
 
 static ssize_t
-sdev_store_eh_timeout(struct device *dev, struct device_attribute *attr,
-		    const char *buf, size_t count)
+sdev_eh_timeout_store(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
 {
 	struct scsi_device *sdev;
 	unsigned int eh_timeout;
@@ -734,19 +733,19 @@ sdev_store_eh_timeout(struct device *dev, struct device_attribute *attr,
 
 	return count;
 }
-static DEVICE_ATTR(eh_timeout, S_IRUGO | S_IWUSR, sdev_show_eh_timeout, sdev_store_eh_timeout);
+static DEVICE_ATTR(eh_timeout, 0644, sdev_eh_timeout_show, sdev_eh_timeout_store);
 
 static ssize_t
-store_rescan_field (struct device *dev, struct device_attribute *attr,
-		    const char *buf, size_t count)
+rescan_field_store(struct device *dev, struct device_attribute *attr,
+		   const char *buf, size_t count)
 {
 	scsi_rescan_device(dev);
 	return count;
 }
-static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
+static DEVICE_ATTR(rescan, 0200, NULL, rescan_field_store);
 
 static ssize_t
-sdev_store_delete(struct device *dev, struct device_attribute *attr,
+sdev_delete_store(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
 	struct kernfs_node *kn;
@@ -778,7 +777,7 @@ sdev_store_delete(struct device *dev, struct device_attribute *attr,
 	scsi_device_put(sdev);
 	return count;
 };
-static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
+static DEVICE_ATTR(delete, 0200, NULL, sdev_delete_store);
 
 static ssize_t
 store_state_field(struct device *dev, struct device_attribute *attr,
@@ -818,7 +817,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
-show_state_field(struct device *dev, struct device_attribute *attr, char *buf)
+state_field_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	const char *name = scsi_device_state_name(sdev->sdev_state);
@@ -826,13 +825,13 @@ show_state_field(struct device *dev, struct device_attribute *attr, char *buf)
 	if (!name)
 		return -EINVAL;
 
-	return snprintf(buf, 20, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
-static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_state_field, store_state_field);
+static DEVICE_ATTR(state, 0644, state_field_show, store_state_field);
 
 static ssize_t
-show_queue_type_field(struct device *dev, struct device_attribute *attr,
+queue_type_field_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -841,7 +840,7 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 	if (sdev->simple_tags)
 		name = "simple";
 
-	return snprintf(buf, 20, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 
 static ssize_t
@@ -852,13 +851,13 @@ store_queue_type_field(struct device *dev, struct device_attribute *attr,
 
 	if (!sdev->tagged_supported)
 		return -EINVAL;
-		
+
 	sdev_printk(KERN_INFO, sdev,
 		    "ignoring write to deprecated queue_type attribute");
 	return count;
 }
 
-static DEVICE_ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
+static DEVICE_ATTR(queue_type, 0644, queue_type_field_show,
 		   store_queue_type_field);
 
 #define sdev_vpd_pg_attr(_page)						\
@@ -880,8 +879,8 @@ show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
 	rcu_read_unlock();						\
 	return ret;							\
 }									\
-static struct bin_attribute dev_attr_vpd_##_page = {		\
-	.attr =	{.name = __stringify(vpd_##_page), .mode = S_IRUGO },	\
+static struct bin_attribute dev_attr_vpd_##_page = {			\
+	.attr =	{.name = __stringify(vpd_##_page), .mode = 0444 },	\
 	.size = 0,							\
 	.read = show_vpd_##_page,					\
 };
@@ -908,59 +907,59 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 static struct bin_attribute dev_attr_inquiry = {
 	.attr = {
 		.name = "inquiry",
-		.mode = S_IRUGO,
+		.mode = 0444,
 	},
 	.size = 0,
 	.read = show_inquiry,
 };
 
 static ssize_t
-show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
+iostat_counterbits_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
+	return sysfs_emit(buf, "%zu\n", sizeof(atomic_t) * 8);
 }
 
-static DEVICE_ATTR(iocounterbits, S_IRUGO, show_iostat_counterbits, NULL);
+static DEVICE_ATTR(iocounterbits, 0444, iostat_counterbits_show, NULL);
 
-#define show_sdev_iostat(field)						\
+#define sdev_iostat_show(field)						\
 static ssize_t								\
-show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
-		    char *buf)						\
+iostat_##field##_show(struct device *dev, struct device_attribute *attr, \
+		      char *buf)					\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	unsigned long long count = atomic_read(&sdev->field);		\
-	return snprintf(buf, 20, "0x%llx\n", count);			\
+	return sysfs_emit(buf, "0x%llx\n", count);			\
 }									\
-static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
+static DEVICE_ATTR(field, 0444, iostat_##field##_show, NULL)
 
-show_sdev_iostat(iorequest_cnt);
-show_sdev_iostat(iodone_cnt);
-show_sdev_iostat(ioerr_cnt);
+sdev_iostat_show(iorequest_cnt);
+sdev_iostat_show(iodone_cnt);
+sdev_iostat_show(ioerr_cnt);
 
 static ssize_t
-sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
+sdev_modalias_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf (buf, 20, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
+	return sysfs_emit(buf, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
 }
-static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
+static DEVICE_ATTR(modalias, 0444, sdev_modalias_show, NULL);
 
 #define DECLARE_EVT_SHOW(name, Cap_name)				\
 static ssize_t								\
-sdev_show_evt_##name(struct device *dev, struct device_attribute *attr,	\
-		     char *buf)						\
+sdev_evt_##name##_show(struct device *dev, struct device_attribute *attr, \
+		       char *buf)					\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	int val = test_bit(SDEV_EVT_##Cap_name, sdev->supported_events);\
-	return snprintf(buf, 20, "%d\n", val);				\
+	return sysfs_emit(buf, "%d\n", val);				\
 }
 
 #define DECLARE_EVT_STORE(name, Cap_name)				\
 static ssize_t								\
-sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
-		      const char *buf, size_t count)			\
+sdev_evt_##name##_store(struct device *dev, struct device_attribute *attr, \
+			const char *buf, size_t count)			\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	int val = simple_strtoul(buf, NULL, 0);				\
@@ -976,8 +975,8 @@ sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
 #define DECLARE_EVT(name, Cap_name)					\
 	DECLARE_EVT_SHOW(name, Cap_name)				\
 	DECLARE_EVT_STORE(name, Cap_name)				\
-	static DEVICE_ATTR(evt_##name, S_IRUGO, sdev_show_evt_##name,	\
-			   sdev_store_evt_##name);
+	static DEVICE_ATTR(evt_##name, 0444, sdev_evt_##name##_show,	\
+			   sdev_evt_##name##_store);
 #define REF_EVT(name) &dev_attr_evt_##name.attr
 
 DECLARE_EVT(media_change, MEDIA_CHANGE)
@@ -988,7 +987,7 @@ DECLARE_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORTED)
 DECLARE_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
 
 static ssize_t
-sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
+sdev_queue_depth_store(struct device *dev, struct device_attribute *attr,
 		       const char *buf, size_t count)
 {
 	int depth, retval;
@@ -1011,14 +1010,14 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 
 	return count;
 }
-sdev_show_function(queue_depth, "%d\n");
 
-static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
-		   sdev_store_queue_depth);
+sdev_function_show("%d", queue_depth);
+
+static DEVICE_ATTR(queue_depth, 0644, sdev_queue_depth_show,
+		   sdev_queue_depth_store);
 
 static ssize_t
-sdev_show_wwid(struct device *dev, struct device_attribute *attr,
-		    char *buf)
+sdev_wwid_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	ssize_t count;
@@ -1030,7 +1029,7 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
 	}
 	return count;
 }
-static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
+static DEVICE_ATTR(wwid, 0444, sdev_wwid_show, NULL);
 
 #define BLIST_FLAG_NAME(name)					\
 	[const_ilog2((__force __u64)BLIST_##name)] = #name
@@ -1040,12 +1039,12 @@ static const char *const sdev_bflags_name[] = {
 #undef BLIST_FLAG_NAME
 
 static ssize_t
-sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
+sdev_blacklist_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	int i;
-	ssize_t len = 0;
+	int len = 0;
 
 	for (i = 0; i < sizeof(sdev->sdev_bflags) * BITS_PER_BYTE; i++) {
 		const char *name = NULL;
@@ -1056,33 +1055,32 @@ sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
 			name = sdev_bflags_name[i];
 
 		if (name)
-			len += scnprintf(buf + len, PAGE_SIZE - len,
-					 "%s%s", len ? " " : "", name);
+			len += sysfs_emit_at(buf, len, "%s%s",
+					     len ? " " : "", name);
 		else
-			len += scnprintf(buf + len, PAGE_SIZE - len,
-					 "%sINVALID_BIT(%d)", len ? " " : "", i);
+			len += sysfs_emit_at(buf, len, "%sINVALID_BIT(%d)",
+					     len ? " " : "", i);
 	}
-	if (len)
-		len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 	return len;
 }
-static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
+static DEVICE_ATTR(blacklist, 0444, sdev_blacklist_show, NULL);
 
 #ifdef CONFIG_SCSI_DH
 static ssize_t
-sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
+sdev_dh_state_show(struct device *dev, struct device_attribute *attr,
 		   char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
 	if (!sdev->handler)
-		return snprintf(buf, 20, "detached\n");
+		return sysfs_emit(buf, "detached\n");
 
-	return snprintf(buf, 20, "%s\n", sdev->handler->name);
+	return sysfs_emit(buf, "%s\n", sdev->handler->name);
 }
 
 static ssize_t
-sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
+sdev_dh_state_store(struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -1118,12 +1116,10 @@ sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
 	return err < 0 ? err : count;
 }
 
-static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
-		   sdev_store_dh_state);
+static DEVICE_ATTR(dh_state, 0644, sdev_dh_state_show, sdev_dh_state_store);
 
 static ssize_t
-sdev_show_access_state(struct device *dev,
-		       struct device_attribute *attr,
+sdev_access_state_show(struct device *dev, struct device_attribute *attr,
 		       char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -1136,14 +1132,12 @@ sdev_show_access_state(struct device *dev,
 	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
 	access_state_name = scsi_access_state_name(access_state);
 
-	return sprintf(buf, "%s\n",
-		       access_state_name ? access_state_name : "unknown");
+	return sysfs_emit(buf, "%s\n", access_state_name ?: "unknown");
 }
-static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
+static DEVICE_ATTR(access_state, 0444, sdev_access_state_show, NULL);
 
 static ssize_t
-sdev_show_preferred_path(struct device *dev,
-			 struct device_attribute *attr,
+sdev_preferred_path_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -1151,27 +1145,24 @@ sdev_show_preferred_path(struct device *dev,
 	if (!sdev->handler)
 		return -EINVAL;
 
-	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
-		return sprintf(buf, "1\n");
-	else
-		return sprintf(buf, "0\n");
+	return sysfs_emit(buf, "%d\n",
+			  !!(sdev->access_state & SCSI_ACCESS_STATE_PREFERRED));
 }
-static DEVICE_ATTR(preferred_path, S_IRUGO, sdev_show_preferred_path, NULL);
+static DEVICE_ATTR(preferred_path, 0444, sdev_preferred_path_show, NULL);
 #endif
 
 static ssize_t
-sdev_show_queue_ramp_up_period(struct device *dev,
-			       struct device_attribute *attr,
-			       char *buf)
+sdev_queue_ramp_up_period_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
 	sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%u\n",
-			jiffies_to_msecs(sdev->queue_ramp_up_period));
+	return sysfs_emit(buf, "%u\n",
+			  jiffies_to_msecs(sdev->queue_ramp_up_period));
 }
 
 static ssize_t
-sdev_store_queue_ramp_up_period(struct device *dev,
+sdev_queue_ramp_up_period_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
@@ -1185,9 +1176,9 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
-		   sdev_show_queue_ramp_up_period,
-		   sdev_store_queue_ramp_up_period);
+static DEVICE_ATTR(queue_ramp_up_period, 0644,
+		   sdev_queue_ramp_up_period_show,
+		   sdev_queue_ramp_up_period_store);
 
 static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
@@ -1198,7 +1189,7 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 
 	if (attr == &dev_attr_queue_depth.attr &&
 	    !sdev->host->hostt->change_queue_depth)
-		return S_IRUGO;
+		return 0444;
 
 	if (attr == &dev_attr_queue_ramp_up_period.attr &&
 	    !sdev->host->hostt->change_queue_depth)
@@ -1234,7 +1225,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	if (attr == &dev_attr_vpd_pg89 && !sdev->vpd_pg89)
 		return 0;
 
-	return S_IRUGO;
+	return 0444;
 }
 
 /* Default template for device attributes.  May NOT be modified */


