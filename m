Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91339C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 12:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E922076A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 12:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591618686;
	bh=JlOromIFN4hdNFx0P6qRo0UGBrTs8BqJhYcUYMKX9k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=u6sOe5Ev1+jZds9u/cIfnO+UMrQGzeozq895dKgX4Xcmgv4CRKVXp1kl5cEj4rkvV
	 Mo9mGpag4c5Am9V4MrX5+6dmGILTKv0vq9YYkSP9OTHTlDvlZU5BVux1Az1EQ50Zmx
	 da504NwOecTwvP2k0Cxjf32SiIGUkO9nxe62/ikc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgFHMSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 08:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729310AbgFHMSF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jun 2020 08:18:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F610206C3;
        Mon,  8 Jun 2020 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591618684;
        bh=JlOromIFN4hdNFx0P6qRo0UGBrTs8BqJhYcUYMKX9k4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sI9GmvpZg4UXFqZ/Zgk0mHBxNzp3cp7+IaTFdKEw23uXA0Ots2omyPJdMKDCbzlN5
         X4GEhWtCuemYEfIRysfupd9Bg+JUBEwe87f8W3Y0QX+JCRqj20Dd1bNvzaabrK/R0U
         aM8YTGPctg+MBHRfiQmVq+22kDSOyQleriYN0RMo=
Date:   Mon, 8 Jun 2020 14:18:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-ID: <20200608121802.GB306451@kroah.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 07, 2020 at 03:35:58PM -0500, Mike Christie wrote:
> +#define target_attr_show(field)						\
> +static ssize_t show_target_##field(struct device *dev,			\
> +				   struct device_attribute *attr, char *buf) \
> +{									\
> +	struct se_session *se_sess = dev_to_se_sess(dev);		\
> +									\
> +	if (!se_sess->field##_name)					\
> +		return 0;						\
> +									\
> +	return snprintf(buf, PAGE_SIZE, "%s", se_sess->field##_name);	\

Nit, you do not need to call snprintf() as you "know" your buffer is big
enough, right?  Please just use sprintf() for sysfs show functions to
enforce that.

> +/* transportID attrs */
> +#define tpt_id_attr_show(name, fmt_str)					\
> +static ssize_t show_tpid_##name(struct device *dev,			\
> +				struct device_attribute *attr, char *buf) \
> +{									\
> +	struct se_session *se_sess = dev_to_se_sess(dev);		\
> +	return snprintf(buf, PAGE_SIZE, fmt_str, se_sess->tpt_id->name); \

sprintf() as above.  Same for all of the other show calls in this file.

thanks,

greg k-h


> +}
> +
> +#define tpt_id_attr(name, fmt_str)		\
> +	tpt_id_attr_show(name, fmt_str)		\
> +static DEVICE_ATTR(name, S_IRUGO, show_tpid_##name, NULL)
> +
> +tpt_id_attr(proto, "0x%x");
> +tpt_id_attr(name, "%s");
> +
> +static ssize_t session_id_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct se_session *se_sess = dev_to_se_sess(dev);
> +
> +	if (!se_sess->tpt_id->session_id)
> +		return 0;
> +
> +	return snprintf(buf, PAGE_SIZE, "0x%s", se_sess->tpt_id->session_id);
> +}
> +
> +static DEVICE_ATTR(session_id, S_IRUGO, session_id_show, NULL);

DEVICE_ATTR_RO().

> +
> +static struct attribute *tpt_id_attrs[] = {
> +	&dev_attr_proto.attr,
> +	&dev_attr_name.attr,
> +	&dev_attr_session_id.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group tpt_id_group = {
> +	.name = "transport_id",
> +	.attrs = tpt_id_attrs,
> +};
> +
> +static const struct attribute_group *def_session_groups[] = {
> +	&tpt_id_group,
> +	&target_endpoint_group,
> +	NULL,
> +};
> +
> +static struct class session_class = {
> +	.owner		= THIS_MODULE,
> +	.name		= "scsi_target_session",
> +	.dev_release	= target_sysfs_session_release,
> +	.dev_groups	= def_session_groups,
> +};
> +
> +int target_sysfs_init_session(struct se_session *se_sess)
> +{
> +	int ret;
> +
> +	ret = ida_simple_get(&session_ida, 1, 0, GFP_KERNEL);
> +	if (ret < 0) {
> +		pr_err("Unable to allocate session index.\n");
> +		return ret;
> +	}
> +	se_sess->sid = ret;
> +
> +	device_initialize(&se_sess->dev);
> +	se_sess->dev.class = &session_class;
> +
> +	ret = dev_set_name(&se_sess->dev, "session-%d", se_sess->sid);
> +	if (ret)
> +		goto put_dev;
> +
> +	return 0;
> +
> +put_dev:
> +	put_device(&se_sess->dev);
> +	return ret;
> +}
> +
> +static int target_cp_endpoint_strs(struct se_portal_group *se_tpg,
> +				   struct se_session *se_sess)
> +{
> +	/*
> +	 * Copy configfs dir/object names so userspace can match the session
> +	 * to its target, and we also don't have to worry about mixing configfs
> +	 * refcounts with sysfs.
> +	 */
> +	if (!se_sess->se_node_acl->dynamic_node_acl) {
> +		se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
> +					    GFP_KERNEL);
> +		if (!se_sess->acl_name)
> +			return -ENOMEM;
> +	}
> +
> +	se_sess->target_name = kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
> +				       GFP_KERNEL);
> +	if (!se_sess->target_name)
> +		goto free_acl;
> +
> +	if (se_sess->tfo->fabric_alias)
> +		se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_alias,
> +					       GFP_KERNEL);
> +	else
> +		se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_name,
> +					       GFP_KERNEL);
> +	if (!se_sess->fabric_name)
> +		goto free_target;
> +
> +	se_sess->tpg_name = kstrdup(se_tpg->tpg_group.cg_item.ci_name,
> +				    GFP_KERNEL);
> +	if (!se_sess->tpg_name)
> +		goto free_fabric;
> +
> +	return 0;
> +
> +free_fabric:
> +	kfree(se_sess->fabric_name);
> +	se_sess->fabric_name = NULL;
> +free_target:
> +	kfree(se_sess->target_name);
> +	se_sess->target_name = NULL;
> +free_acl:
> +	kfree(se_sess->acl_name);
> +	se_sess->acl_name = NULL;
> +	return -ENOMEM;
> +}
> +
> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
> +			     struct se_session *se_sess)
> +{
> +	struct t10_transport_id *tpt_id = se_sess->tpt_id;
> +	int ret;
> +
> +	if (!try_module_get(se_sess->tfo->module))
> +		return -EINVAL;
> +
> +	ret = target_cp_endpoint_strs(se_tpg, se_sess);
> +	if (ret)
> +		goto put_mod;
> +
> +	se_sess->dev.groups = se_sess->tfo->session_attr_groups;
> +	ret = device_add(&se_sess->dev);
> +	if (ret) {
> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
> +		       se_sess->sid, ret);
> +		goto free_ep_strs;
> +	}
> +
> +	pr_info("TCM added session-%d from [fabric: %s, target: %s, tpg %s, acl: %s] to [initiator port: %s%s%s]",
> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic",
> +		tpt_id->name, tpt_id->session_id ? "," : "",
> +		tpt_id->session_id ? tpt_id->session_id : "");
> +
> +	se_sess->sysfs_added = true;
> +	return 0;
> +
> +free_ep_strs:
> +	target_free_endpoint_strs(se_sess);
> +put_mod:
> +	module_put(se_sess->tfo->module);
> +	return ret;
> +}
> +EXPORT_SYMBOL(target_sysfs_add_session);
> +
> +void target_sysfs_remove_session(struct se_session *se_sess)
> +{
> +	struct t10_transport_id *tpt_id = se_sess->tpt_id;
> +
> +	/* discovery sessions are normally not added to sysfs */
> +	if (!se_sess->sysfs_added)
> +		return;
> +	se_sess->sysfs_added = false;
> +
> +	pr_info("TCM removed session-%d from [fabric: %s, target: %s, tpg %s, acl: %s] to [initiator port: %s%s%s]",
> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic",
> +		tpt_id->name, tpt_id->session_id ? "," : "",
> +		tpt_id->session_id ? tpt_id->session_id : "");
> +
> +	device_del(&se_sess->dev);
> +}
> +EXPORT_SYMBOL(target_sysfs_remove_session);
> +
> +void target_sysfs_init(void)
> +{
> +	class_register(&session_class);
> +}
> +
> +void target_sysfs_exit(void)
> +{
> +	class_unregister(&session_class);

I think you forgot to cleanup your ida structure here, right?

thanks,

greg k-h
