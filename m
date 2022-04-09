Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB61C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiDIBmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 21:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240445AbiDIBmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 21:42:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 620CABF7A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649468429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=heXKNptWSHpGiFSOdFs/wZDuoub54NEee2sADwILeMc=;
        b=Ss02LMV8cqsa7k8jbEV2rfGO0J9C1OLEAhzgepi8h6FRDIin2i//M1TOl3L0SGPCcQtRtl
        tlcOdh4osdx9S0yHOmyOBY+v6XJ+CPA/litMDGcvNeJKi4zEbKpnPn7sTF6erauxQlVF7y
        kIawCMluLw4cEqSE7zpc5Q5cD/JO9Dc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-_z50LmHxMdW65OShZ8sVUA-1; Fri, 08 Apr 2022 21:40:26 -0400
X-MC-Unique: _z50LmHxMdW65OShZ8sVUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F94C101AA42;
        Sat,  9 Apr 2022 01:40:26 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FFA8C44AE2;
        Sat,  9 Apr 2022 01:40:25 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:40:23 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 03/10] scsi: iscsi: Release endpoint ID when its freed.
Message-ID: <YlDkB4+O77xyxUj6@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-4-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-4-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:07PM -0500, Mike Christie wrote:
> We can't release the endpoint ID until all references to the endpoint have
> been dropped or it could be allocated while in use. This has us use an idr
> instead of looping over all conns to find a free ID and then free the ID
> when all references have been dropped instead of when the device is only
> deleted.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 71 ++++++++++++++---------------
>  include/scsi/scsi_transport_iscsi.h |  2 +-
>  2 files changed, 36 insertions(+), 37 deletions(-)
 
Reviewed-by: Chris Leech <cleech@redhat.com>

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index bf39fb5569b6..1fc7c6bfbd67 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -86,6 +86,9 @@ struct iscsi_internal {
>  	struct transport_container session_cont;
>  };
>  
> +static DEFINE_IDR(iscsi_ep_idr);
> +static DEFINE_MUTEX(iscsi_ep_idr_mutex);
> +
>  static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
>  
>  static struct workqueue_struct *iscsi_conn_cleanup_workq;
> @@ -168,6 +171,11 @@ struct device_attribute dev_attr_##_prefix##_##_name =	\
>  static void iscsi_endpoint_release(struct device *dev)
>  {
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
>  {
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
> -static int iscsi_match_epid(struct device *dev, const void *data)
> -{
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
>  struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
>  {
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
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 38e4a67f5922..fdd486047404 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -295,7 +295,7 @@ extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
>  struct iscsi_endpoint {
>  	void *dd_data;			/* LLD private data */
>  	struct device dev;
> -	uint64_t id;
> +	int id;
>  	struct iscsi_cls_conn *conn;
>  };
>  
> -- 
> 2.25.1
> 

