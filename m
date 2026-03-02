Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BA429DB6E
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 02:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772420074; cv=none; b=OYnmMDDD76uM/wz/XsYnO24i8+JUGstoyNn1cC/VdMPB+nEVKa3EtGNfNOm/iixfZ8rTkbIoMhku4vAdh6mbeOWuuKrgU0tlJuIdfFlKymyPfAaJbTXxA9PDTr1LBPHrm4OaF2KGhpXrCpY3HYG+uZqBVclLF2dblMjX2dUdwvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772420074; c=relaxed/simple;
	bh=QIBOPpDdx+fCrd3vSXwVMSGaBeOjFAF/rLFx2MA7lEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pOKFOw0ymJSfvsEvoS8DzYm5x+0ivSZtgrZCPC7wcDkLdaVtdDfjt2Y3nn8NoACfNnXCqJ7SPJD1PBNMGkeLufJnHoZEckTjxl8aWemgmgRU4zf6vY29jQ8hj3ulYstgsraKBkA4dMPNHqe/Rfnmki1fL4Xu34eQNFwEOGX7jlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HqzmwF8J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HqzmwF8J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772420072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cRmafe0jH0R0Nafxr/7KHV9xhqMWn925hHllToiFxFs=;
	b=HqzmwF8JTo9Y2lpWKdc4gZdc+aRwgV5aMmdp95t7X7tBlXqtUs4CuhF02utiW4A8pcIh1A
	5o7Wo2NxSOkSNdqJZkMDkNY4Nj9VWGC1nkFpaWlxwvgx1M+idIJ9xVJynQvL7/Gv4I60ey
	/clGdc7DQGjzzGH7HC2GKtCELDaDu6E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-NnOysptOPRWinXNChCc4XQ-1; Sun,
 01 Mar 2026 21:54:29 -0500
X-MC-Unique: NnOysptOPRWinXNChCc4XQ-1
X-Mimecast-MFC-AGG-ID: NnOysptOPRWinXNChCc4XQ_1772420067
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C74B21800451;
	Mon,  2 Mar 2026 02:54:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77D691800576;
	Mon,  2 Mar 2026 02:54:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6222sPId1830117
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 1 Mar 2026 21:54:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6222sPsI1830116;
	Sun, 1 Mar 2026 21:54:25 -0500
Date: Sun, 1 Mar 2026 21:54:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/24] scsi-multipath: introduce scsi_mpath_device_class
Message-ID: <aaT74XadDrQb22Cf@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153627.1032500-5-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Feb 25, 2026 at 03:36:07PM +0000, John Garry wrote:
> Introduce a new class for multipathed devices, scsi_mpath_device_class.
> 
> The purpose of this class is for managing the scsi_mpath_head.dev member.
> 
> The naming for the scsi_device structure is in form H:C:I:L,
> where H is host, C is channel, I is ID, and L is lun.
> 
> However, for a multipathed scsi_device, all the naming members may be
> different between member scsi_device's. As such, just use a simple
> single-number naming index for each scsi_mpath_head.
> 
> The sysfs device folder will have links to the scsi_device's so, it will
> be possible to lookup the member scsi_device's.
> 
> An example sysfs entry is as follows:
> # ls -l /sys/class/scsi_mpath_device/0/
> total 0
> drwxr-xr-x    2 root     root             0 Feb 24 11:56 power
> lrwxrwxrwx    1 root     root             0 Feb 24 11:56 subsystem -> ../../../../class/scsi_mpath_device
> -rw-r--r--    1 root     root          4096 Feb 24 11:55 uevent
> -r--r--r--    1 root     root          4096 Feb 24 11:56 wwid
> # cat /sys/class/scsi_mpath_device/0/wwid
> naa.600140505200a986f0043c9afa1fd077
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_multipath.c | 67 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 49316269fad8e..05af178921cb4 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -85,6 +85,69 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
>  	return 0;
>  }
>  
> +static void scsi_mpath_delete_head(struct scsi_mpath_head *scsi_mpath_head)
> +{
> +	mutex_lock(&scsi_mpath_heads_lock);
> +	list_del_init(&scsi_mpath_head->entry);
> +	mutex_unlock(&scsi_mpath_heads_lock);
> +}
> +
> +static void scsi_mpath_head_release(struct device *dev)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =
> +		container_of(dev, struct scsi_mpath_head, dev);
> +	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
> +
> +	scsi_mpath_delete_head(scsi_mpath_head);
> +	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
> +	mpath_put_head(mpath_head);
> +	kfree(scsi_mpath_head);
> +}
> +
> +static ssize_t scsi_mpath_device_wwid_show(struct device *dev,
> +			struct device_attribute *attr,
> +			char *buf)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =
> +		container_of(dev, struct scsi_mpath_head, dev);
> +
> +	return sysfs_emit(buf, "%s\n", scsi_mpath_head->wwid);
> +}
> +
> +static DEVICE_ATTR(wwid, S_IRUGO, scsi_mpath_device_wwid_show, NULL);
> +
> +static struct attribute *scsi_mpath_device_attrs[] = {
> +	&dev_attr_wwid.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group scsi_mpath_device_attrs_group = {
> +	.attrs = scsi_mpath_device_attrs,
> +};
> +
> +static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
> +{
> +	return true;
> +}
> +
> +static bool scsi_multipath_sysfs_attr_visible(struct kobject *kobj,
> +		struct attribute *attr, int n)

The return for this is actually a umode_t.

> +{
> +	return false;
> +}
> +DEFINE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)

Nitpick again: This could just use DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE()
Also, this code would make more sense in the next patch.

-Ben

> +
> +const struct attribute_group *scsi_mpath_device_groups[] = {
> +	&scsi_mpath_device_attrs_group,
> +	NULL
> +};
> +
> +static const struct class scsi_mpath_device_class = {
> +	.name = "scsi_mpath_device",
> +	.dev_groups = scsi_mpath_device_groups,
> +	.dev_release = scsi_mpath_head_release,
> +};
> +
>  static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>  {
>  	struct Scsi_Host *shost = sdev->host;
> @@ -129,6 +192,7 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>  		goto out_put_head;
>  
>  	device_initialize(&scsi_mpath_head->dev);
> +	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
>  	ret = dev_set_name(&scsi_mpath_head->dev, "%d", scsi_mpath_head->index);
>  	if (ret) {
>  		put_device(&scsi_mpath_head->dev);
> @@ -294,11 +358,12 @@ EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
>  
>  int __init scsi_multipath_init(void)
>  {
> -	return 0;
> +	return class_register(&scsi_mpath_device_class);
>  }
>  
>  void __exit scsi_multipath_exit(void)
>  {
> +	class_unregister(&scsi_mpath_device_class);
>  }
>  
>  MODULE_LICENSE("GPL");
> -- 
> 2.43.5

