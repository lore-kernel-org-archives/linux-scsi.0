Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA558C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 07:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245311AbiDKHZB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 03:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbiDKHZA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 03:25:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE68638D91
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 00:22:46 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KcKyc1kqNzgYcG;
        Mon, 11 Apr 2022 15:20:56 +0800 (CST)
Received: from dggpeml100019.china.huawei.com (7.185.36.175) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Apr 2022 15:22:44 +0800
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml100019.china.huawei.com (7.185.36.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Apr 2022 15:22:44 +0800
Received: from dggpeml500019.china.huawei.com ([7.185.36.137]) by
 dggpeml500019.china.huawei.com ([7.185.36.137]) with mapi id 15.01.2375.024;
 Mon, 11 Apr 2022 15:22:44 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "skashyap@marvell.com" <skashyap@marvell.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "njavali@marvell.com" <njavali@marvell.com>,
        "mrangankar@marvell.com" <mrangankar@marvell.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [PATCH 03/10] scsi: iscsi: Release endpoint ID when its freed.
Thread-Topic: [PATCH 03/10] scsi: iscsi: Release endpoint ID when its freed.
Thread-Index: AQHYSt3HUF9IrgfrdEinHeLHS6dXzazqU/WQ
Date:   Mon, 11 Apr 2022 07:22:44 +0000
Message-ID: <4f3bca5bf7bb42118860fccbf745a480@huawei.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-4-michael.christie@oracle.com>
In-Reply-To: <20220408001314.5014-4-michael.christie@oracle.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.189]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Mike Christie [mailto:michael.christie@oracle.com]
> Sent: Friday, April 8, 2022 8:13 AM
> To: skashyap@marvell.com; lduncan@suse.com; cleech@redhat.com;
> njavali@marvell.com; mrangankar@marvell.com;
> GR-QLogic-Storage-Upstream@marvell.com; martin.petersen@oracle.com;
> linux-scsi@vger.kernel.org; jejb@linux.ibm.com
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [PATCH 03/10] scsi: iscsi: Release endpoint ID when its freed.
> 
> We can't release the endpoint ID until all references to the endpoint have been
> dropped or it could be allocated while in use. This has us use an idr instead of
> looping over all conns to find a free ID and then free the ID when all references
> have been dropped instead of when the device is only deleted.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 71 ++++++++++++++---------------
> include/scsi/scsi_transport_iscsi.h |  2 +-
>  2 files changed, 36 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index bf39fb5569b6..1fc7c6bfbd67 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -86,6 +86,9 @@ struct iscsi_internal {
>  	struct transport_container session_cont;  };
> 
> +static DEFINE_IDR(iscsi_ep_idr);
> +static DEFINE_MUTEX(iscsi_ep_idr_mutex);
> +
>  static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
> 
>  static struct workqueue_struct *iscsi_conn_cleanup_workq;
> @@ -168,6 +171,11 @@ struct device_attribute dev_attr_##_prefix##_##_name
> =	\
>  static void iscsi_endpoint_release(struct device *dev)  {
>  	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
> +
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	idr_remove(&iscsi_ep_idr, ep->id);
> +	mutex_unlock(&iscsi_ep_idr_mutex);
> +
>  	kfree(ep);
>  }
> 
> @@ -180,7 +188,7 @@ static ssize_t
>  show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
> {
>  	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
> -	return sysfs_emit(buf, "%llu\n", (unsigned long long) ep->id);
> +	return sysfs_emit(buf, "%d\n", ep->id);
>  }
>  static ISCSI_ATTR(ep, handle, S_IRUGO, show_ep_handle, NULL);
> 
> @@ -193,48 +201,32 @@ static struct attribute_group iscsi_endpoint_group = {
>  	.attrs = iscsi_endpoint_attrs,
>  };
> 
> -#define ISCSI_MAX_EPID -1
> -
> -static int iscsi_match_epid(struct device *dev, const void *data) -{
> -	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
> -	const uint64_t *epid = data;
> -
> -	return *epid == ep->id;
> -}
> -
>  struct iscsi_endpoint *
>  iscsi_create_endpoint(int dd_size)
>  {
> -	struct device *dev;
>  	struct iscsi_endpoint *ep;
> -	uint64_t id;
> -	int err;
> -
> -	for (id = 1; id < ISCSI_MAX_EPID; id++) {
> -		dev = class_find_device(&iscsi_endpoint_class, NULL, &id,
> -					iscsi_match_epid);
> -		if (!dev)
> -			break;
> -		else
> -			put_device(dev);
> -	}
> -	if (id == ISCSI_MAX_EPID) {
> -		printk(KERN_ERR "Too many connections. Max supported %u\n",
> -		       ISCSI_MAX_EPID - 1);
> -		return NULL;
> -	}
> +	int err, id;
> 
>  	ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
>  	if (!ep)
>  		return NULL;
> 
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
> +	if (id < 0) {
> +		mutex_unlock(&iscsi_ep_idr_mutex);
> +		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
> +		       id);
> +		goto free_ep;
> +	}
> +	mutex_unlock(&iscsi_ep_idr_mutex);
> +
>  	ep->id = id;
>  	ep->dev.class = &iscsi_endpoint_class;
> -	dev_set_name(&ep->dev, "ep-%llu", (unsigned long long) id);
> +	dev_set_name(&ep->dev, "ep-%d", id);
>  	err = device_register(&ep->dev);
>          if (err)
> -                goto free_ep;
> +		goto free_id;
> 
>  	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
>  	if (err)
> @@ -248,6 +240,10 @@ iscsi_create_endpoint(int dd_size)
>  	device_unregister(&ep->dev);
>  	return NULL;
> 
> +free_id:
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	idr_remove(&iscsi_ep_idr, id);
> +	mutex_unlock(&iscsi_ep_idr_mutex);
>  free_ep:
>  	kfree(ep);
>  	return NULL;
> @@ -275,14 +271,17 @@ EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
>   */
>  struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)  {
> -	struct device *dev;
> +	struct iscsi_endpoint *ep;
> 
> -	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
> -				iscsi_match_epid);
> -	if (!dev)
> -		return NULL;
> +	mutex_lock(&iscsi_ep_idr_mutex);
> +	ep = idr_find(&iscsi_ep_idr, handle);
> +	if (!ep)
> +		goto unlock;
> 
> -	return iscsi_dev_to_endpoint(dev);
> +	get_device(&ep->dev);
> +unlock:
> +	mutex_unlock(&iscsi_ep_idr_mutex);
> +	return ep;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
> 
> diff --git a/include/scsi/scsi_transport_iscsi.h
> b/include/scsi/scsi_transport_iscsi.h
> index 38e4a67f5922..fdd486047404 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -295,7 +295,7 @@ extern void iscsi_host_for_each_session(struct Scsi_Host
> *shost,  struct iscsi_endpoint {
>  	void *dd_data;			/* LLD private data */
>  	struct device dev;
> -	uint64_t id;
> +	int id;
>  	struct iscsi_cls_conn *conn;
>  };
> 
> --


Reviewed-by: Wu Bo <wubo40@huawei.com>
