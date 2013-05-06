From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: add put_device() after device_find_child()
Date: Mon, 06 May 2013 12:06:56 -0500
Message-ID: <5187E330.1030806@cs.wisc.edu>
References: <51879A29.7070900@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080800040906070005090705"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36744 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab3EFRHM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 13:07:12 -0400
In-Reply-To: <51879A29.7070900@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: JBottomley@parallels.com, ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080800040906070005090705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/06/2013 06:55 AM, Zhao Hongjiang wrote:
> The qla4xxx_sysfs_ddb_add() function uses device_find_child() but it does not drop
> the reference of the retrieved child.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index a47f999..b378d9e 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -5605,6 +5605,7 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
>  		ql4_printk(KERN_ERR, ha,
>  			   "%s: A non-persistent entry %s found\n",
>  			   __func__, dev->kobj.name);
> +		put_device(dev);
>  		goto exit_ddb_add;
>  	}
>  
> 

Thanks for catching this. I messed up when reviewing it. For some dumb
reason I thought it was not doing refcounting.

I think there are a couple bugs from other similar functions. What about
the attached patch? It is only compile tested. If it is ok, Vikas,
please test.


--------------080800040906070005090705
Content-Type: text/plain; charset=UTF-8;
 name="iscsi-fix-find-fn-use.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iscsi-fix-find-fn-use.patch"

iscsi class, qla4xxx: fix sess/conn refcounting when find fns are used

This fixes a bug where the iscsi class/driver did not do a put_device
when a sess/conn device was found. This also simplifies the interface
by not having to pass in some arguments that were duplicated and did
not need to be exported.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d777332..4d231c1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5605,6 +5605,7 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
 		ql4_printk(KERN_ERR, ha,
 			   "%s: A non-persistent entry %s found\n",
 			   __func__, dev->kobj.name);
+		put_device(dev);
 		goto exit_ddb_add;
 	}
 
@@ -6112,8 +6113,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 	int parent_type, parent_index = 0xffff;
 	int rc = 0;
 
-	dev = iscsi_find_flashnode_conn(fnode_sess, NULL,
-					iscsi_is_flashnode_conn_dev);
+	dev = iscsi_find_flashnode_conn(fnode_sess);
 	if (!dev)
 		return -EIO;
 
@@ -6347,6 +6347,8 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 		rc = -ENOSYS;
 		break;
 	}
+
+	put_device(dev);
 	return rc;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 475265a..133926b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1019,8 +1019,7 @@ exit_match_index:
 /**
  * iscsi_get_flashnode_by_index -finds flashnode session entry by index
  * @shost: pointer to host data
- * @data: pointer to data containing value to use for comparison
- * @fn: function pointer that does actual comparison
+ * @idx: index to match
  *
  * Finds the flashnode session object for the passed index
  *
@@ -1029,13 +1028,13 @@ exit_match_index:
  *  %NULL on failure
  */
 static struct iscsi_bus_flash_session *
-iscsi_get_flashnode_by_index(struct Scsi_Host *shost, void *data,
-			     int (*fn)(struct device *dev, void *data))
+iscsi_get_flashnode_by_index(struct Scsi_Host *shost, uint32_t idx)
 {
 	struct iscsi_bus_flash_session *fnode_sess = NULL;
 	struct device *dev;
 
-	dev = device_find_child(&shost->shost_gendev, data, fn);
+	dev = device_find_child(&shost->shost_gendev, &idx,
+				flashnode_match_index);
 	if (dev)
 		fnode_sess = iscsi_dev_to_flash_session(dev);
 
@@ -1059,18 +1058,13 @@ struct device *
 iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 			  int (*fn)(struct device *dev, void *data))
 {
-	struct device *dev;
-
-	dev = device_find_child(&shost->shost_gendev, data, fn);
-	return dev;
+	return device_find_child(&shost->shost_gendev, data, fn);
 }
 EXPORT_SYMBOL_GPL(iscsi_find_flashnode_sess);
 
 /**
  * iscsi_find_flashnode_conn - finds flashnode connection entry
  * @fnode_sess: pointer to parent flashnode session entry
- * @data: pointer to data containing value to use for comparison
- * @fn: function pointer that does actual comparison
  *
  * Finds the flashnode connection object comparing the data passed using logic
  * defined in passed function pointer
@@ -1080,14 +1074,10 @@ EXPORT_SYMBOL_GPL(iscsi_find_flashnode_sess);
  *  %NULL on failure
  */
 struct device *
-iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess,
-			  void *data,
-			  int (*fn)(struct device *dev, void *data))
+iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess)
 {
-	struct device *dev;
-
-	dev = device_find_child(&fnode_sess->dev, data, fn);
-	return dev;
+	return device_find_child(&fnode_sess->dev, NULL,
+				 iscsi_is_flashnode_conn_dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_find_flashnode_conn);
 
@@ -2808,7 +2798,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 	struct iscsi_bus_flash_session *fnode_sess;
 	struct iscsi_bus_flash_conn *fnode_conn;
 	struct device *dev;
-	uint32_t *idx;
+	uint32_t idx;
 	int err = 0;
 
 	if (!transport->set_flashnode_param) {
@@ -2824,25 +2814,27 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 		goto put_host;
 	}
 
-	idx = &ev->u.set_flashnode.flashnode_idx;
-	fnode_sess = iscsi_get_flashnode_by_index(shost, idx,
-						  flashnode_match_index);
+	idx = ev->u.set_flashnode.flashnode_idx;
+	fnode_sess = iscsi_get_flashnode_by_index(shost, idx);
 	if (!fnode_sess) {
 		pr_err("%s could not find flashnode %u for host no %u\n",
-		       __func__, *idx, ev->u.set_flashnode.host_no);
+		       __func__, idx, ev->u.set_flashnode.host_no);
 		err = -ENODEV;
 		goto put_host;
 	}
 
-	dev = iscsi_find_flashnode_conn(fnode_sess, NULL,
-					iscsi_is_flashnode_conn_dev);
+	dev = iscsi_find_flashnode_conn(fnode_sess);
 	if (!dev) {
 		err = -ENODEV;
-		goto put_host;
+		goto put_sess;
 	}
 
 	fnode_conn = iscsi_dev_to_flash_conn(dev);
 	err = transport->set_flashnode_param(fnode_sess, fnode_conn, data, len);
+	put_device(dev);
+
+put_sess:
+	put_device(&fnode_sess->dev);
 
 put_host:
 	scsi_host_put(shost);
@@ -2891,7 +2883,7 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 {
 	struct Scsi_Host *shost;
 	struct iscsi_bus_flash_session *fnode_sess;
-	uint32_t *idx;
+	uint32_t idx;
 	int err = 0;
 
 	if (!transport->del_flashnode) {
@@ -2907,17 +2899,17 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 		goto put_host;
 	}
 
-	idx = &ev->u.del_flashnode.flashnode_idx;
-	fnode_sess = iscsi_get_flashnode_by_index(shost, idx,
-						  flashnode_match_index);
+	idx = ev->u.del_flashnode.flashnode_idx;
+	fnode_sess = iscsi_get_flashnode_by_index(shost, idx);
 	if (!fnode_sess) {
 		pr_err("%s could not find flashnode %u for host no %u\n",
-		       __func__, *idx, ev->u.del_flashnode.host_no);
+		       __func__, idx, ev->u.del_flashnode.host_no);
 		err = -ENODEV;
 		goto put_host;
 	}
 
 	err = transport->del_flashnode(fnode_sess);
+	put_device(&fnode_sess->dev);
 
 put_host:
 	scsi_host_put(shost);
@@ -2933,7 +2925,7 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 	struct iscsi_bus_flash_session *fnode_sess;
 	struct iscsi_bus_flash_conn *fnode_conn;
 	struct device *dev;
-	uint32_t *idx;
+	uint32_t idx;
 	int err = 0;
 
 	if (!transport->login_flashnode) {
@@ -2949,25 +2941,27 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 		goto put_host;
 	}
 
-	idx = &ev->u.login_flashnode.flashnode_idx;
-	fnode_sess = iscsi_get_flashnode_by_index(shost, idx,
-						  flashnode_match_index);
+	idx = ev->u.login_flashnode.flashnode_idx;
+	fnode_sess = iscsi_get_flashnode_by_index(shost, idx);
 	if (!fnode_sess) {
 		pr_err("%s could not find flashnode %u for host no %u\n",
-		       __func__, *idx, ev->u.login_flashnode.host_no);
+		       __func__, idx, ev->u.login_flashnode.host_no);
 		err = -ENODEV;
 		goto put_host;
 	}
 
-	dev = iscsi_find_flashnode_conn(fnode_sess, NULL,
-					iscsi_is_flashnode_conn_dev);
+	dev = iscsi_find_flashnode_conn(fnode_sess);
 	if (!dev) {
 		err = -ENODEV;
-		goto put_host;
+		goto put_sess;
 	}
 
 	fnode_conn = iscsi_dev_to_flash_conn(dev);
 	err = transport->login_flashnode(fnode_sess, fnode_conn);
+	put_device(dev);
+
+put_sess:
+	put_device(&fnode_sess->dev);
 
 put_host:
 	scsi_host_put(shost);
@@ -2983,7 +2977,7 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 	struct iscsi_bus_flash_session *fnode_sess;
 	struct iscsi_bus_flash_conn *fnode_conn;
 	struct device *dev;
-	uint32_t *idx;
+	uint32_t idx;
 	int err = 0;
 
 	if (!transport->logout_flashnode) {
@@ -2999,26 +2993,28 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 		goto put_host;
 	}
 
-	idx = &ev->u.logout_flashnode.flashnode_idx;
-	fnode_sess = iscsi_get_flashnode_by_index(shost, idx,
-						  flashnode_match_index);
+	idx = ev->u.logout_flashnode.flashnode_idx;
+	fnode_sess = iscsi_get_flashnode_by_index(shost, idx);
 	if (!fnode_sess) {
 		pr_err("%s could not find flashnode %u for host no %u\n",
-		       __func__, *idx, ev->u.logout_flashnode.host_no);
+		       __func__, idx, ev->u.logout_flashnode.host_no);
 		err = -ENODEV;
 		goto put_host;
 	}
 
-	dev = iscsi_find_flashnode_conn(fnode_sess, NULL,
-					iscsi_is_flashnode_conn_dev);
+	dev = iscsi_find_flashnode_conn(fnode_sess);
 	if (!dev) {
 		err = -ENODEV;
-		goto put_host;
+		goto put_sess;
 	}
 
 	fnode_conn = iscsi_dev_to_flash_conn(dev);
 
 	err = transport->logout_flashnode(fnode_sess, fnode_conn);
+	put_device(dev);
+
+put_sess:
+	put_device(&fnode_sess->dev);
 
 put_host:
 	scsi_host_put(shost);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 4a58cca..d0f1602 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -471,14 +471,10 @@ iscsi_destroy_flashnode_sess(struct iscsi_bus_flash_session *fnode_sess);
 extern void iscsi_destroy_all_flashnode(struct Scsi_Host *shost);
 extern int iscsi_flashnode_bus_match(struct device *dev,
 				     struct device_driver *drv);
-extern int iscsi_is_flashnode_conn_dev(struct device *dev, void *data);
-
 extern struct device *
 iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 			  int (*fn)(struct device *dev, void *data));
-
 extern struct device *
-iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess,
-			  void *data,
-			  int (*fn)(struct device *dev, void *data));
+iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
+
 #endif

--------------080800040906070005090705--
