Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D01C54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1B59206A1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 16:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="j0JkRrDq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgDUQJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 12:09:06 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:48797 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgDUQJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 12:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1587485339; i=@ts.fujitsu.com;
        bh=usR/gH7TFSJTm0YxK4wPd0iel7XFOpSuyMdEUI3t1QM=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=j0JkRrDquygPd+iInow+R0JrQoAdqJhSJoWjunVypb6lLhm9RYBR5ojH7/P7FAoKX
         VjHwUB30mGtvmkE2fAvopAStvgpMpOZi+ovvBWK+zJUQGpEWXqT5c6ast0wuPVUkwR
         WA2exIRcjIoJ+0YL8dSMkku6wCEqrTV2n8GOazScfjBV8gJrBzjiIKHOFpmxHCzLyV
         oedx9fF2+6kO0hi0bB7wadKsGT0Ylm4nX24B82hUXpobxQQNq990oDlUryaYHfpasC
         gMOJqOZ4V45T0vDkW6QEYx+k7JcxidHstJ0aRZpuaMqu6xB7Ou+/WbrQ7MCde2FnBZ
         4A+cSgD2xeElQ==
Received: from [100.113.7.166] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id 9A/3E-35964-B9A1F9E5; Tue, 21 Apr 2020 16:08:59 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRWlGSWpSXmKPExsViZ8MxVXe21Pw
  4g7WPxCymffjJbLFiwXtGi+7rO9gslh//x2Sx/sgGRovWpW+ZHNg8Ll/x9tg56y67x8ent1g8
  3u+7yubxeZNcAGsUa2ZeUn5FAmvG2++1BfPaGCu+TZzN1MC4pKCLkYtDSGAWo8Tky//Yuhg5O
  YQFPCVWLXzBDJIQEdjOKPF38T5WkISQQJrE7s3/wYrYBAwkVky6zwJi8wo4Ssy/8B7MZhFQlW
  h6epQRxBYVCJd4seUPK0SNoMTJmU/AajgFLCUaX69iArGZBcwk5m1+yAxhi0vcejIfKi4v0bx
  1NvMERt5ZSNpnIWmZhaRlFpKWBYwsqxgtk4oy0zNKchMzc3QNDQx0DQ2Ndc11jQzM9BKrdJP0
  Ukt1k1PzSooSgbJ6ieXFesWVuck5KXp5qSWbGIGBnlLIfm4H48a17/UOMUpyMCmJ8hpJzo8T4
  kvKT6nMSCzOiC8qzUktPsQow8GhJMFrLQGUEyxKTU+tSMvMAUYdTFqCg0dJhPcJSJq3uCAxtz
  gzHSJ1ilFRSpy3ASQhAJLIKM2Da4NF+iVGWSlhXkYGBgYhnoLUotzMElT5V4ziHIxKwrxeIFN
  4MvNK4Ka/AlrMBLQ433Q2yOKSRISUVAPTUsHfDF3N0sGzznrP3LafN1mOt5b/W1ZhjsU0TW+X
  Ap4/Sve/T7446bGVbkfx75y46H3Zzc82ip+u+9urwmwevPzqjozV31/IzA39YltruP3G8ccHH
  7BPk1RZ+/ZpRw7frLdzvudcdE3e/O930v713b9c/aWu+pUsCuayklx+0tfx0PKq8MUSoqIzL1
  x3Za0Wi3ugG/p954ntukH7djMFLVUKyd+4ot1+xq67x38yRNse2f9QV/ea7RFhRoc1C/7s+3v
  gv4HAHBszpZLZa6f/10s9zqvw89EhhqemN6ZNXB2+dFXn80fblzaUJBRYefyIk7u6oU3F33JS
  0BOzOdIbGZl3uixz7JvzkVMt5IzJbiWW4oxEQy3mouJEALHzOLdvAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-22.tower-238.messagelabs.com!1587485338!808466!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 11129 invoked from network); 21 Apr 2020 16:08:59 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-22.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 21 Apr 2020 16:08:59 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 03LG80F3002056;
        Tue, 21 Apr 2020 17:08:18 +0100
Subject: Re: [RFC PATCH 08/12] target: add sysfs session helper functions
To:     Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200420191426.17055-1-mchristi@redhat.com>
 <20200420191426.17055-9-mchristi@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <0bb53ad7-1909-8513-41b1-55792501a4d9@ts.fujitsu.com>
Date:   Tue, 21 Apr 2020 18:07:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <20200420191426.17055-9-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To generate the new, globally unique session ids, idr_alloc_cyclic()
is used. Is there real need for the _cyclic?
Otherwise ida_alloc / ida_free would be sufficient, which saves space,
avoids the se_sess_idr_mutex and shortens the names of the session
folders in sysfs, since low numbers are reused if possible.

On 04/20/20 21:14, Mike Christie wrote:
> This patch adds helpers to add/remove a dir per session. There is
> only 2 files/dirs.
> 
> acl - name of acl session is accessed through.
> transport_id - Contains fabric module specific transportID values.
> 
> iSCSI example:
> 
> scsi_target/
> ├── iscsi
> │   └── iqn.1999-09.com.tcmu:alua
> │       ├── tpgt_1
> │       │   └── sessions
> │       │       └── session-1
> │       │           ├── acl
> │       │           └── transport_id
> │       │               ├── format
> │       │               ├── iscsi_name
> │       │               ├── iscsi_session_id
> │       │               └── proto
> │       └── tpgt_2
> │           └── sessions
> .....
> 
> Fabric drivers like iscsi or elx can add pass in an attribute_group
> to add driver specific attrs via the target_core_fabric_ops
> session_attrs field.
> 
> Note that this adds back the global sid allocator instead of the per tpg
> one because in the future we will want to tag target_core_user commands
> with the session id. This will be needed when tcmu devices are mapped
> to multiple fabric modules or tpgs and they userspace needs to track
> the different session to command mappings for commands like PRs.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
> V2:
> - Fix extra newline
> - Copy data that's exported to sysfs so we do not have to worry about
> configfs and sysfs refcounts.
> 
>   drivers/target/Makefile                |   1 +
>   drivers/target/target_core_internal.h  |   4 +
>   drivers/target/target_core_sysfs.c     | 296 +++++++++++++++++++++++++++++++++
>   drivers/target/target_core_transport.c |  43 ++++-
>   include/target/target_core_base.h      |   6 +
>   include/target/target_core_fabric.h    |   8 +-
>   6 files changed, 351 insertions(+), 7 deletions(-)
>   create mode 100644 drivers/target/target_core_sysfs.c
> 
> diff --git a/drivers/target/Makefile b/drivers/target/Makefile
> index 4563474..4a7246e 100644
> --- a/drivers/target/Makefile
> +++ b/drivers/target/Makefile
> @@ -1,6 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
>   
>   target_core_mod-y		:= target_core_configfs.o \
> +				   target_core_sysfs.o \
>   				   target_core_device.o \
>   				   target_core_fabric_configfs.o \
>   				   target_core_fabric_lib.o \
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index d242a97..c85eb30 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -108,6 +108,9 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
>   void target_free_transport_id(struct t10_transport_id *tpid);
>   char *transport_id_get_sid(struct t10_transport_id *tpid);
>   
> +/* target_core_sysfs.c */
> +void	target_sysfs_init_session(struct se_session *sess);
> +
>   /* target_core_hba.c */
>   struct se_hba *core_alloc_hba(const char *, u32, u32);
>   int	core_delete_hba(struct se_hba *);
> @@ -155,6 +158,7 @@ void	transport_dump_dev_info(struct se_device *, struct se_lun *,
>   bool	target_check_wce(struct se_device *dev);
>   bool	target_check_fua(struct se_device *dev);
>   void	__target_execute_cmd(struct se_cmd *, bool);
> +void	__target_free_session(struct se_session *);
>   
>   /* target_core_stat.c */
>   void	target_stat_setup_dev_default_groups(struct se_device *);
> diff --git a/drivers/target/target_core_sysfs.c b/drivers/target/target_core_sysfs.c
> new file mode 100644
> index 0000000..d8f2c1e
> --- /dev/null
> +++ b/drivers/target/target_core_sysfs.c
> @@ -0,0 +1,296 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/kobject.h>
> +#include <linux/idr.h>
> +
> +#include <scsi/scsi_proto.h>
> +
> +#include <target/target_core_base.h>
> +#include <target/target_core_fabric.h>
> +#include "target_core_internal.h"
> +
> +static void target_sysfs_session_release(struct kobject *kobj)
> +{
> +	struct se_session *se_sess = container_of(kobj, struct se_session, kobj);
> +
> +	__target_free_session(se_sess);
> +}
> +
> +struct session_attr {
> +	struct attribute attr;
> +	ssize_t (*show)(struct se_session *, char *);
> +	ssize_t (*store)(struct se_session *, const char *, size_t);
> +};
> +
> +#define to_session(atr) container_of((atr), struct session_attr, attr)
> +
> +static ssize_t session_acl_show(struct se_session *se_sess, char *page)
> +{
> +	return snprintf(page, PAGE_SIZE, "%s\n", se_sess->acl_name ?
> +			se_sess->acl_name : "");
> +}
> +
> +static struct session_attr session_acl_attr = {
> +	.attr = { .name = "acl", .mode = S_IRUGO },
> +	.show = session_acl_show,
> +};
> +
> +/* Default attrs common to all fabric modules */
> +static struct attribute *session_attrs[] = {
> +	&session_acl_attr.attr,
> +	NULL
> +};
> +ATTRIBUTE_GROUPS(session);
> +
> +/* transportID attrs */
> +#define transport_id_def_attr_show(name, fmt_str)		\
> +static ssize_t def_show_##name(struct se_session *se_sess, char *page) \
> +{									\
> +	return snprintf(page, PAGE_SIZE, fmt_str, se_sess->tpid->name); \
> +}
> +
> +#define transport_id_def_attr(name, fmt_str)		\
> +	transport_id_def_attr_show(name, fmt_str)		\
> +static struct session_attr transport_id_def_##name##_attr =	\
> +	__ATTR(name, S_IRUGO, def_show_##name, NULL)
> +
> +#define transport_id_attr_show(pref, name, fmt_str)			\
> +static ssize_t show_##pref##_##name(struct se_session *se_sess, char *page) \
> +{									\
> +	return snprintf(page, PAGE_SIZE, fmt_str, se_sess->tpid->pref.name); \
> +}
> +
> +#define transport_id_attr(pref, name, fmt_str)				\
> +	transport_id_attr_show(pref, name, fmt_str)			\
> +static struct session_attr transport_id_##pref##_##name##_attr =	\
> +	__ATTR(name, S_IRUGO, show_##pref##_##name, NULL)
> +
> +transport_id_def_attr(proto, "%u\n");
> +transport_id_def_attr(format, "%u\n");
> +transport_id_attr(fcp, port_name, "%s\n");
> +transport_id_attr(sbp, name, "%s\n");
> +transport_id_attr(srp, port_id, "%s\n");
> +transport_id_attr(sas, addr, "%s\n");
> +transport_id_attr(iscsi, name, "%s\n");
> +transport_id_attr(iscsi, session_id, "%s\n");
> +
> +static struct attribute *transport_id_fcp_attrs[] = {
> +	&transport_id_def_proto_attr.attr,
> +	&transport_id_def_format_attr.attr,
> +	&transport_id_fcp_port_name_attr.attr,
> +	NULL
> +};
> +
> +static struct attribute *transport_id_sbp_attrs[] = {
> +	&transport_id_def_proto_attr.attr,
> +	&transport_id_def_format_attr.attr,
> +	&transport_id_sbp_name_attr.attr,
> +	NULL
> +};
> +
> +static struct attribute *transport_id_srp_attrs[] = {
> +	&transport_id_def_proto_attr.attr,
> +	&transport_id_def_format_attr.attr,
> +	&transport_id_srp_port_id_attr.attr,
> +	NULL
> +};
> +
> +static struct attribute *transport_id_sas_attrs[] = {
> +	&transport_id_def_proto_attr.attr,
> +	&transport_id_def_format_attr.attr,
> +	&transport_id_sas_addr_attr.attr,
> +	NULL
> +};
> +
> +static struct attribute *transport_id_iscsi_attrs[] = {
> +	&transport_id_def_proto_attr.attr,
> +	&transport_id_def_format_attr.attr,
> +	&transport_id_iscsi_name_attr.attr,
> +	&transport_id_iscsi_session_id_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group transport_id_fcp_attr_group = {
> +	.name = "transport_id",
> +	.attrs = transport_id_fcp_attrs,
> +};
> +
> +static const struct attribute_group transport_id_sbp_attr_group = {
> +	.name = "transport_id",
> +	.attrs = transport_id_sbp_attrs,
> +};
> +
> +static const struct attribute_group transport_id_srp_attr_group = {
> +	.name = "transport_id",
> +	.attrs = transport_id_srp_attrs,
> +};
> +
> +static const struct attribute_group transport_id_sas_attr_group = {
> +	.name = "transport_id",
> +	.attrs = transport_id_sas_attrs,
> +};
> +
> +static const struct attribute_group transport_id_iscsi_attr_group = {
> +	.name = "transport_id",
> +	.attrs = transport_id_iscsi_attrs,
> +};
> +
> +static ssize_t
> +session_attr_store(struct kobject *kobj, struct attribute *attr,
> +		   const char *page, size_t length)
> +{
> +	struct se_session *se_sess = container_of(kobj, struct se_session, kobj);
> +	struct session_attr *sess_attr = to_session(attr);
> +
> +	if (!sess_attr->store)
> +		return -ENOSYS;
> +
> +	return sess_attr->store(se_sess, page, length);
> +}
> +
> +static ssize_t
> +session_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
> +{
> +	struct se_session *se_sess = container_of(kobj, struct se_session, kobj);
> +	struct session_attr *sess_attr = to_session(attr);
> +
> +	if (!sess_attr->show)
> +		return -ENOSYS;
> +
> +	return sess_attr->show(se_sess, page);
> +}
> +
> +static const struct sysfs_ops session_sysfs_ops = {
> +	.show	= session_attr_show,
> +	.store	= session_attr_store,
> +};
> +
> +static struct kobj_type session_ktype = {
> +	.sysfs_ops	= &session_sysfs_ops,
> +	.release	= target_sysfs_session_release,
> +	.default_groups	= session_groups,
> +};
> +
> +void target_sysfs_init_session(struct se_session *se_sess)
> +{
> +	kobject_init(&se_sess->kobj, &session_ktype);
> +}
> +
> +static int add_transport_id_attrs(struct se_session *se_sess)
> +{
> +	int ret = 0;
> +
> +	switch (se_sess->tpid->proto) {
> +
> +	case SCSI_PROTOCOL_FCP:
> +		ret = sysfs_create_group(&se_sess->kobj,
> +					 &transport_id_fcp_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_SBP:
> +		ret = sysfs_create_group(&se_sess->kobj,
> +					 &transport_id_sbp_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_SRP:
> +		ret = sysfs_create_group(&se_sess->kobj,
> +					 &transport_id_srp_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_SAS:
> +		ret = sysfs_create_group(&se_sess->kobj,
> +					 &transport_id_sas_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_ISCSI:
> +		ret = sysfs_create_group(&se_sess->kobj,
> +					 &transport_id_iscsi_attr_group);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static void remove_transport_id_attrs(struct se_session *se_sess)
> +{
> +	switch (se_sess->tpid->proto) {
> +	case SCSI_PROTOCOL_FCP:
> +		sysfs_remove_group(&se_sess->kobj,
> +				   &transport_id_fcp_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_SBP:
> +		sysfs_remove_group(&se_sess->kobj,
> +				   &transport_id_sbp_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_SRP:
> +		sysfs_remove_group(&se_sess->kobj,
> +				   &transport_id_srp_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_SAS:
> +		sysfs_remove_group(&se_sess->kobj,
> +				   &transport_id_sas_attr_group);
> +		break;
> +	case SCSI_PROTOCOL_ISCSI:
> +		sysfs_remove_group(&se_sess->kobj,
> +				   &transport_id_iscsi_attr_group);
> +		break;
> +	}
> +}
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
> +	ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "session-%d",
> +			  se_sess->sid);
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
> +			goto rm_tpid_grps;
> +	}
> +	se_sess->sysfs_added = true;
> +
> +	return 0;
> +
> +rm_tpid_grps:
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
> +	remove_transport_id_attrs(se_sess);
> +
> +	if (se_sess->tfo->session_attrs)
> +		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
> +	kobject_del(&se_sess->kobj);
> +}
> +EXPORT_SYMBOL(target_sysfs_remove_session);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 66f0af1..d3248d4 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -42,6 +42,8 @@
>   
>   static struct workqueue_struct *target_completion_wq;
>   static struct kmem_cache *se_sess_cache;
> +static DEFINE_MUTEX(se_sess_idr_mutex);
> +static DEFINE_IDR(se_sess_idr);
>   struct kmem_cache *se_ua_cache;
>   struct kmem_cache *t10_pr_reg_cache;
>   struct kmem_cache *t10_alua_lu_gp_cache;
> @@ -251,14 +253,32 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
>   				" se_sess_cache\n");
>   		return ERR_PTR(-ENOMEM);
>   	}
> -	ret = transport_init_session(se_sess);
> +
> +	mutex_lock(&se_sess_idr_mutex);
> +	ret = idr_alloc_cyclic(&se_sess_idr, NULL, 1, 0, GFP_KERNEL);
> +	if (ret >= 0)
> +		se_sess->sid = ret;
> +	mutex_unlock(&se_sess_idr_mutex);
>   	if (ret < 0) {
> -		kmem_cache_free(se_sess_cache, se_sess);
> -		return ERR_PTR(ret);
> +		pr_err("Unable to allocate session index.\n");
> +		goto free_sess;
>   	}
> -	se_sess->sup_prot_ops = sup_prot_ops;
>   
> +	ret = transport_init_session(se_sess);
> +	if (ret < 0)
> +		goto free_sid;
> +
> +	se_sess->sup_prot_ops = sup_prot_ops;
> +	target_sysfs_init_session(se_sess);
>   	return se_sess;
> +
> +free_sid:
> +	mutex_lock(&se_sess_idr_mutex);
> +	idr_remove(&se_sess_idr, se_sess->sid);
> +	mutex_unlock(&se_sess_idr_mutex);
> +free_sess:
> +	kmem_cache_free(se_sess_cache, se_sess);
> +	return ERR_PTR(ret);
>   }
>   EXPORT_SYMBOL(transport_alloc_session);
>   
> @@ -585,12 +605,23 @@ void transport_free_session(struct se_session *se_sess)
>   		sbitmap_queue_free(&se_sess->sess_tag_pool);
>   		kvfree(se_sess->sess_cmd_map);
>   	}
> -	target_free_transport_id(se_sess->tpid);
>   	percpu_ref_exit(&se_sess->cmd_count);
> -	kmem_cache_free(se_sess_cache, se_sess);
> +	kobject_put(&se_sess->kobj);
>   }
>   EXPORT_SYMBOL(transport_free_session);
>   
> +void __target_free_session(struct se_session *se_sess)
> +{
> +	kfree(se_sess->acl_name);
> +	target_free_transport_id(se_sess->tpid);
> +
> +	mutex_lock(&se_sess_idr_mutex);
> +	idr_remove(&se_sess_idr, se_sess->sid);
> +	mutex_unlock(&se_sess_idr_mutex);
> +
> +	kmem_cache_free(se_sess_cache, se_sess);
> +}
> +
>   static int target_release_res(struct se_device *dev, void *data)
>   {
>   	struct se_session *sess = data;
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index b48f8cf..61115b7 100644
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
> @@ -633,6 +634,7 @@ struct se_session {
>   	enum target_prot_op	sup_prot_ops;
>   	enum target_prot_type	sess_prot_type;
>   	struct se_node_acl	*se_node_acl;
> +	char			*acl_name;
>   	struct se_portal_group *se_tpg;
>   	void			*fabric_sess_ptr;
>   	struct percpu_ref	cmd_count;
> @@ -643,6 +645,10 @@ struct se_session {
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
> index 0c1720d..be43180 100644
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
> @@ -141,7 +145,9 @@ void	transport_register_session(struct se_portal_group *,
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
