Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12D9C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC1620720
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="tdXVjhDi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgEKSkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 14:40:23 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.67]:23768 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729768AbgEKSkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 14:40:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589222419; i=@ts.fujitsu.com;
        bh=WnJVErCFN3qUdYpRLqLJN/kf6RynwdAgactAl9+ftj0=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=tdXVjhDiO0DnYeVV6vCgoIk8n8FifOXvAqAhhJjW1kJkomKw1V83zAcQxN5edcU2D
         IFjKd9mMQGUP8kfVcBjDpXgnAOwd3nG3fccHpV7oXnvFKffvBRGdJTp/cAqSTt72GG
         2EaQkH5g9FF8m2sr8YrSWe78+3DBQAL7gvpYpqArrKsQsI2bazbnMCOXmc3UCStt89
         dBorJqg2QquG/PfySxdgvryfqY7gDxJS/8ZAYgMkIL0FLQEiCPMRzRu1YAJQEVLKgO
         TfNyMzqM0YiozjmCf5Tb/pI/U7UXtIrchmq80zrIN5yW8BzFtIezOrCylCdPxub+mU
         dLMG/ftXr6DJA==
Received: from [100.112.199.17] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-west-1.aws.symcld.net id 40/02-40520-21C99BE5; Mon, 11 May 2020 18:40:18 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRWlGSWpSXmKPExsViZ8MxVVdozs4
  4gwkz2C2mffjJbNG8eD2bRff1HWwWy4//Y7JYf2QDo0Xr0rdMDmwel694e+yfu4bd4+PTWywe
  7/ddZfP4vEkugDWKNTMvKb8igTVj9raTrAVNJhU7Zu9jbGC8rd3FyMUhJDCLUeLTuUb2LkZOD
  mEBV4n7686xgiREBBYySlzecYoZJMEsYCxxpv0AI4gtJJAusffqJbAGNgEDiRWT7rOA2LwCjh
  Kb/71mA7FZBFQl5q1oAKsXFQiXeLHlDytEjaDEyZlPwOo5BawkzjZsYYSYbyYxb/NDqF3iEre
  ezGeCsOUltr+dwzyBkW8WkvZZSFpmIWmZhaRlASPLKkaLpKLM9IyS3MTMHF1DAwNdQ0MjXUNL
  S11DE1O9xCrdJL3UUt3y1OISXUO9xPJiveLK3OScFL281JJNjMDwTyk4PnEH45q17/UOMUpyM
  CmJ8upN3RknxJeUn1KZkVicEV9UmpNafIhRhoNDSYJ320ygnGBRanpqRVpmDjAWYdISHDxKIr
  z2s4DSvMUFibnFmekQqVOMilLivDtBEgIgiYzSPLg2WPxfYpSVEuZlZGBgEOIpSC3KzSxBlX/
  FKM7BqARUATKFJzOvBG76K6DFTECLHz7fBrK4JBEhJdXAxJ3GFF31Y8fhI2abZDZHanFbh5hd
  SzxcmXTVyZhhzceT2/kaSuY///lb7eW8urA31WdN09YuvLRm6QV77f3rhE/fchNRWLDxWun8s
  ndMEyplvrSmN6SdZg2/7y5tvF8/cqrn0zXPlz3Lcpc7llz39ofI6+8t2T1619coO+4NtTl6W1
  x+vnVy1Rlr379Rt5uPqTTp3NwgzO7z/fDVzd5qzIYLz12bZNleOl9WXMb26eMFG/gerBLxnTT
  v+/nYSodFdR9f+SfPETO+9/9zQf53Jt7/+dr31tR/P/6/M3bdzSvcNhJvvNpLYyofC/5wFNwT
  cnD10+41t1ez7l9lPF9qe5OgctOdT7W/izYaWa1a3qfEUpyRaKjFXFScCAAVuI2gegMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-17.tower-287.messagelabs.com!1589222415!287191!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18371 invoked from network); 11 May 2020 18:40:17 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-17.tower-287.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 11 May 2020 18:40:17 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 04BIdPB9018567;
        Mon, 11 May 2020 19:39:43 +0100
Subject: Re: [PATCH 12/15] target: add sysfs session helper functions
To:     Mike Christie <mchristi@redhat.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-13-mchristi@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
Date:   Mon, 11 May 2020 20:39:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200510215744.21999-13-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/10/20 23:57, Mike Christie wrote:
> This patch adds helpers to add/remove a dir per session. There is only 2
> files/dirs initially.
> 

...

> +
> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
> +			     struct se_session *se_sess)
> +{
> +	int ret;
> +
> +	/*
> +	 * Copy ACL name so we don't have to worry about mixing configfs
> +	 * and sysfs refcounts.
> +	 */
> +	if (!se_sess->se_node_acl->dynamic_node_acl) {
> +		se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
> +					    GFP_KERNEL);
> +		if (!se_sess->acl_name)
> +			return -ENOMEM;
> +	}
> +
> +	ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
> +			  se_sess->tpt_id->name, se_sess->sid);
> +	if (ret) {
> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
> +		       se_sess->sid, ret);
> +		goto free_acl_name;
> +	}
> +
> +	ret = add_transport_id_attrs(se_sess);
> +	if (ret)
> +		goto del_kobj;
> +
> +	if (se_sess->tfo->session_attrs) {
> +		ret = sysfs_create_group(&se_sess->kobj,
> +					 se_sess->tfo->session_attrs);
> +		if (ret)
> +			goto rm_tpt_id_grps;
> +	}
> +
> +	ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
> +				se_sess->kobj.name);

I would prefer to have links named "session-%d" or "%d" only, of course
with se_sess->sid as the value for '%d'.

If userspace knows the session-id only, such names make it easier to
find the corresponding link.

> +	if (ret)
> +		goto rm_fabric_grps;
> +
> +	se_sess->sysfs_added = true;
> +	return 0;
> +
> +rm_fabric_grps:
> +	if (se_sess->tfo->session_attrs)
> +		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
> +rm_tpt_id_grps:
> +	remove_transport_id_attrs(se_sess);
> +del_kobj:
> +	kobject_del(&se_sess->kobj);
> +free_acl_name:
> +	kfree(se_sess->acl_name);
> +	se_sess->acl_name = NULL;
> +	return ret;
> +}
> +EXPORT_SYMBOL(target_sysfs_add_session);
> +
> +void target_sysfs_remove_session(struct se_session *se_sess)
> +{
> +	/* discovery sessions are normally not added to sysfs */
> +	if (!se_sess->sysfs_added)
> +		return;
> +
> +	sysfs_remove_link(tcm_core_sessions_kobj, se_sess->kobj.name);
> +	if (se_sess->tfo->session_attrs)
> +		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
> +	remove_transport_id_attrs(se_sess);
> +	kobject_del(&se_sess->kobj);
> +}
> +EXPORT_SYMBOL(target_sysfs_remove_session);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index fdf84db..04cb042 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -42,6 +42,7 @@
>   
>   static struct workqueue_struct *target_completion_wq;
>   static struct kmem_cache *se_sess_cache;
> +static DEFINE_IDA(se_sess_ida);
>   struct kmem_cache *se_ua_cache;
>   struct kmem_cache *t10_pr_reg_cache;
>   struct kmem_cache *t10_alua_lu_gp_cache;
> @@ -251,14 +252,27 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
>   				" se_sess_cache\n");
>   		return ERR_PTR(-ENOMEM);
>   	}
> -	ret = transport_init_session(se_sess);
> +
> +	ret = ida_simple_get(&se_sess_ida, 1, 0, GFP_KERNEL);
>   	if (ret < 0) {
> -		kmem_cache_free(se_sess_cache, se_sess);
> -		return ERR_PTR(ret);
> +		pr_err("Unable to allocate session index.\n");
> +		goto free_sess;
>   	}
> -	se_sess->sup_prot_ops = sup_prot_ops;
> +	se_sess->sid = ret;
> +
> +	ret = transport_init_session(se_sess);
> +	if (ret < 0)
> +		goto free_sid;
>   
> +	se_sess->sup_prot_ops = sup_prot_ops;
> +	target_sysfs_init_session(se_sess);
>   	return se_sess;
> +
> +free_sid:
> +	ida_simple_remove(&se_sess_ida, se_sess->sid);
> +free_sess:
> +	kmem_cache_free(se_sess_cache, se_sess);
> +	return ERR_PTR(ret);
>   }
>   EXPORT_SYMBOL(transport_alloc_session);
>   
> @@ -597,12 +611,21 @@ void transport_free_session(struct se_session *se_sess)
>   		sbitmap_queue_free(&se_sess->sess_tag_pool);
>   		kvfree(se_sess->sess_cmd_map);
>   	}
> -	target_free_transport_id(se_sess->tpt_id);
>   	percpu_ref_exit(&se_sess->cmd_count);
> -	kmem_cache_free(se_sess_cache, se_sess);
> +	kobject_put(&se_sess->kobj);
>   }
>   EXPORT_SYMBOL(transport_free_session);
>   
> +void __target_free_session(struct se_session *se_sess)
> +{
> +	kfree(se_sess->acl_name);
> +	target_free_transport_id(se_sess->tpt_id);
> +
> +	ida_simple_remove(&se_sess_ida, se_sess->sid);
> +
> +	kmem_cache_free(se_sess_cache, se_sess);
> +}
> +
>   static int target_release_res(struct se_device *dev, void *data)
>   {
>   	struct se_session *sess = data;
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index b7f7e02..34d89cb 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -9,6 +9,7 @@
>   #include <linux/semaphore.h>     /* struct semaphore */
>   #include <linux/completion.h>
>   #include <linux/kobject.h>
> +#include <linux/idr.h>
>   
>   #define TARGET_CORE_VERSION		"v5.0"
>   
> @@ -626,6 +627,7 @@ struct se_session {
>   	enum target_prot_op	sup_prot_ops;
>   	enum target_prot_type	sess_prot_type;
>   	struct se_node_acl	*se_node_acl;
> +	char			*acl_name;
>   	struct se_portal_group *se_tpg;
>   	void			*fabric_sess_ptr;
>   	struct percpu_ref	cmd_count;
> @@ -636,6 +638,10 @@ struct se_session {
>   	wait_queue_head_t	cmd_list_wq;
>   	void			*sess_cmd_map;
>   	struct sbitmap_queue	sess_tag_pool;
> +	struct kobject		kobj;
> +	int			sid;
> +	bool			sysfs_added;
> +	const struct target_core_fabric_ops *tfo;
>   };
>   
>   struct se_device;
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index ced377f..f876a05 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -74,6 +74,10 @@ struct target_core_fabric_ops {
>   	int (*queue_status)(struct se_cmd *);
>   	void (*queue_tm_rsp)(struct se_cmd *);
>   	void (*aborted_task)(struct se_cmd *);
> +
> +	/* Optional session management and sysfs callouts */
> +	const struct attribute_group *session_attrs;
> +
>   	/*
>   	 * fabric module calls for target_core_fabric_configfs.c
>   	 */
> @@ -145,7 +149,9 @@ void	transport_register_session(struct se_portal_group *,
>   void	target_put_nacl(struct se_node_acl *);
>   void	transport_deregister_session_configfs(struct se_session *);
>   void	transport_deregister_session(struct se_session *);
> -
> +void	target_sysfs_remove_session(struct se_session *se_sess);
> +int	target_sysfs_add_session(struct se_portal_group *se_tpg,
> +				 struct se_session *se_sess);
>   
>   void	transport_init_se_cmd(struct se_cmd *,
>   		const struct target_core_fabric_ops *,
> 
