From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [PATCH I2O] memory leak in i2o_exec_lct_modified
Date: Sun, 05 Mar 2006 23:18:14 +0100
Message-ID: <440B63A6.7060100@shadowconnect.com>
References: <44094F5F.9080900@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070609080804010500030205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0006.shadowconnect.net ([213.202.216.60]:58511 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S1751880AbWCEWQU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Mar 2006 17:16:20 -0500
In-Reply-To: <44094F5F.9080900@sw.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: linux-scsi@vger.kernel.org, devel@openvz.org, Kirill Korotaev <dev@sw.ru>

This is a multi-part message in MIME format.
--------------070609080804010500030205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Vasily Averin wrote:
> i2o_exec_lct_modified() does not release memory allocated for work_struct.
> Signed-off-by: Vasily Averin <vvs@sw.ru>
> ------------------------------------------------------------------------
> 
> --- ./drivers/message/i2o/exec-osm.c.i2ml	2006-03-04 11:09:45.000000000 +0300
> +++ ./drivers/message/i2o/exec-osm.c	2006-03-04 11:09:03.000000000 +0300
> @@ -57,6 +57,11 @@ struct i2o_exec_wait {
>  	struct list_head list;	/* node in global wait list */
>  };
>  
> +struct i2o_workqueue {
> +	struct work_struct work;
> +	struct i2o_controller *c;
> +};
> +
>  /* Exec OSM class handling definition */
>  static struct i2o_class_id i2o_exec_class_id[] = {
>  	{I2O_CLASS_EXECUTIVE},
> @@ -355,16 +360,19 @@ static int i2o_exec_remove(struct device
>   *	new LCT and if the buffer for the LCT was to small sends a LCT NOTIFY
>   *	again, otherwise send LCT NOTIFY to get informed on next LCT change.
>   */
> -static void i2o_exec_lct_modified(struct i2o_controller *c)
> +static void i2o_exec_lct_modified(void *data)
>  {
>  	u32 change_ind = 0;
> +	struct i2o_workqueue *cp;
>  
> -	if (i2o_device_parse_lct(c) != -EAGAIN)
> -		change_ind = c->lct->change_ind + 1;
> +	cp = (struct i2o_workqueue *)data;
> +	if (i2o_device_parse_lct(cp->c) != -EAGAIN)
> +		change_ind = cp->c->lct->change_ind + 1;
>  
>  #ifdef CONFIG_I2O_LCT_NOTIFY_ON_CHANGES
> -	i2o_exec_lct_notify(c, change_ind);
> +	i2o_exec_lct_notify(cp->c, change_ind);
>  #endif
> +	kfree(cp);
>  };
>  
>  /**
> @@ -410,16 +418,22 @@ static int i2o_exec_reply(struct i2o_con
>  		return i2o_msg_post_wait_complete(c, m, msg, context);
>  
>  	if ((le32_to_cpu(msg->u.head[1]) >> 24) == I2O_CMD_LCT_NOTIFY) {
> -		struct work_struct *work;
> +		struct i2o_workqueue *cp;
>  
>  		pr_debug("%s: LCT notify received\n", c->name);
>  
> -		work = kmalloc(sizeof(*work), GFP_ATOMIC);
> -		if (!work)
> +		cp = kmalloc(sizeof(struct i2o_workqueue), GFP_ATOMIC);
> +		if (!cp)
>  			return -ENOMEM;
>  
> -		INIT_WORK(work, (void (*)(void *))i2o_exec_lct_modified, c);
> -		queue_work(i2o_exec_driver.event_queue, work);
> +		cp->c = c;
> +		INIT_WORK(&cp->work, i2o_exec_lct_modified, cp);
> +		if (!queue_work(i2o_exec_driver.event_queue, &cp->work)) {
> +			printk(KERN_DEBUG "i2o_exec_reply:"
> +				" call to queue_work() failed.\n");
> +			kfree(cp);
> +			return -EIO;
> +		}
>  		return 1;
>  	}
>  

Although your patch is the same, i've rewritten it a little bit for 
naming consistency in the I2O driver.

Thank you very much for your help!


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

--------------070609080804010500030205
Content-Type: text/x-patch;
 name="i2o_exec_lct_modified-memoryleak-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i2o_exec_lct_modified-memoryleak-fix.patch"

Index: drivers/message/i2o/exec-osm.c
===================================================================
--- drivers/message/i2o/exec-osm.c	(revision 330)
+++ drivers/message/i2o/exec-osm.c	(working copy)
@@ -57,6 +57,13 @@
 	struct list_head list;	/* node in global wait list */
 };
 
+/* Work struct needed to handle LCT NOTIFY replies */
+struct i2o_exec_lct_notify_work {
+	struct work_struct work;	/* work struct */
+	struct i2o_controller *c;	/* controller on which the LCT NOTIFY
+					   was received */
+};
+
 /* Exec OSM class handling definition */
 static struct i2o_class_id i2o_exec_class_id[] = {
 	{I2O_CLASS_EXECUTIVE},
@@ -355,10 +362,13 @@
  *	new LCT and if the buffer for the LCT was to small sends a LCT NOTIFY
  *	again, otherwise send LCT NOTIFY to get informed on next LCT change.
  */
-static void i2o_exec_lct_modified(struct i2o_controller *c)
+static void i2o_exec_lct_modified(struct i2o_exec_lct_notify_work *work)
 {
 	u32 change_ind = 0;
+	struct i2o_controller *c = work->c;
 
+	kfree(work);
+
 	if (i2o_device_parse_lct(c) != -EAGAIN)
 		change_ind = c->lct->change_ind + 1;
 
@@ -410,7 +420,7 @@
 		return i2o_msg_post_wait_complete(c, m, msg, context);
 
 	if ((le32_to_cpu(msg->u.head[1]) >> 24) == I2O_CMD_LCT_NOTIFY) {
-		struct work_struct *work;
+		struct i2o_exec_lct_notify_work *work;
 
 		pr_debug("%s: LCT notify received\n", c->name);
 
@@ -418,8 +428,11 @@
 		if (!work)
 			return -ENOMEM;
 
-		INIT_WORK(work, (void (*)(void *))i2o_exec_lct_modified, c);
-		queue_work(i2o_exec_driver.event_queue, work);
+		work->c = c;
+
+		INIT_WORK(&work->work, (void (*)(void *))i2o_exec_lct_modified,
+			  work);
+		queue_work(i2o_exec_driver.event_queue, &work->work);
 		return 1;
 	}
 

--------------070609080804010500030205--
