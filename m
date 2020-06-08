Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2F2C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C082E2074B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgFHGOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 02:14:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:60768 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHGOb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jun 2020 02:14:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ED05CAD78;
        Mon,  8 Jun 2020 06:14:32 +0000 (UTC)
Subject: Re: [PATCH 11/17] target: add session sysfs class support
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
Date:   Mon, 8 Jun 2020 08:14:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/20 10:35 PM, Mike Christie wrote:
> This patch adds a sysfs interface to export the target module's
> sessions using the driver module class structure. With this we
> now have a common way to export session info for all fabric modules
> and we can export info about all sessions not just the first one
> on a ACL like for iscsi. We can also export more info then PAGE_SIZE
> bytes for all sessions (looking at iscsi and qla2xxx and the
> dynamic_sessions file abuse).
> 
> Here is a tree the new class dir scsi_target_session:
> 
> session-1/
> ├── power
> │   ├── autosuspend_delay_ms
> │   ├── control
> │   ├── runtime_active_time
> │   ├── runtime_status
> │   └── runtime_suspended_time
> ├── subsystem -> ../../../../class/scsi_target_session
> ├── tcm_endpoint
> │   ├── acl
> │   ├── fabric
> │   ├── target
> │   └── tpg
> ├── transport_id
> │   ├── name
> │   └── proto
> └── uevent
> 
> The Documentation/ABI/testing/sysfs-scsi-target-session file in this
> patch describes the files and dirs.
> 
> Userspace apps like tcmu-runner and targetcli, can either:
> 
> 1. If they have the session ID, then directly look up the session's
> info like with tagetcli's session sid case.
> 
> 2. If they have the target side's endpoint object name like the ACL
> or tpg, then they have to scan each session's tcm_endpoint dir. This
> should hopefully not be the normal case. For tcmu-runner we will
> normally scan sysfs, cache the info, then update the cache as we get
> events about sessions being added/removed.
> 
> Note that to make it easier for Greg to review I am just including
> the sysfs parts in this patch. The next patch hooks into the target
> code and enables it.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   .../ABI/testing/sysfs-scsi-target-session          |  71 ++++++
>   drivers/target/target_core_internal.h              |   5 +
>   drivers/target/target_core_sysfs.c                 | 265 +++++++++++++++++++++
>   include/target/target_core_base.h                  |   8 +
>   include/target/target_core_fabric.h                |   6 +-
>   5 files changed, 354 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-scsi-target-session
>   create mode 100644 drivers/target/target_core_sysfs.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-scsi-target-session b/Documentation/ABI/testing/sysfs-scsi-target-session
> new file mode 100644
> index 0000000..c8cefcc
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-scsi-target-session
> @@ -0,0 +1,71 @@
> +What:		/sys/class/scsi_target_session/session-N
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	The session dir contains a dir for each I_T Nexus. The name of
> +		the dir is "session-" followed by an integer that is unique
> +		across all fabrics. The dir contains files that export info like
> +		the TPG/ACL the session is attached to, SCSI port values, and
> +		fabric and transport specific values.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	The tcm_endpoint dir indicates what target_core_mod object
> +		the session is attached to.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/acl
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the ACL that was used to validate login or
> +		an empty string if no user created ACL was used.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/target
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the target the session is accessed through.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/fabric
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the fabric the session is accessed through.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/tpg
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the tpg the session is accessed through.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	The transport_id contains the SCSI TransportID values for the
> +		initiator port as defined in SPC4r37.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id/proto
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the SCSI protocol identifier in hex defined in SPC4r37.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id/name
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the port name/address/id in the protocol specific
> +		TransportID format defined in SPC4r37's.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id/session_id
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	If is proto=0x5 (iSCSI) and TPID FORMAT=1 this file will exist
> +		and will return the iSCSI Initiator Session ID in ASCII
> +		characters that are the hexadecimal digits converted from the
> +		binary iSCSI initiator session identifier value. If iSCSI and
> +		format=1 is not used by this session this file will not exist.
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 8533444..93bf5fed 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -105,6 +105,11 @@ int	target_get_pr_transport_id(struct se_node_acl *nacl,
>   const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
>   		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
>   
> +/* target_core_sysfs.c */
> +int	target_sysfs_init_session(struct se_session *sess);
> +void	target_sysfs_init(void);
> +void	target_sysfs_exit(void);
> +
>   /* target_core_hba.c */
>   struct se_hba *core_alloc_hba(const char *, u32, u32);
>   int	core_delete_hba(struct se_hba *);
> diff --git a/drivers/target/target_core_sysfs.c b/drivers/target/target_core_sysfs.c
> new file mode 100644
> index 0000000..b29a6f2
> --- /dev/null
> +++ b/drivers/target/target_core_sysfs.c
> @@ -0,0 +1,265 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/device.h>
> +#include <linux/idr.h>
> +#include <linux/module.h>
> +
> +#include <scsi/scsi_proto.h>
> +
> +#include <target/target_core_base.h>
> +#include <target/target_core_fabric.h>
> +#include "target_core_internal.h"
> +
> +static DEFINE_IDA(session_ida);
> +
> +#define dev_to_se_sess(_dev) \
> +	container_of(dev, struct se_session, dev)
> +
> +static void target_free_endpoint_strs(struct se_session *se_sess)
> +{
> +	kfree(se_sess->tpg_name);
> +	kfree(se_sess->fabric_name);
> +	kfree(se_sess->target_name);
> +	kfree(se_sess->acl_name);
> +}
> +
> +static void target_sysfs_session_release(struct device *dev)
> +{
> +	struct se_session *se_sess = dev_to_se_sess(dev);
> +
> +	target_free_endpoint_strs(se_sess);
> +	ida_simple_remove(&session_ida, se_sess->sid);
> +
> +	__target_free_session(se_sess);
> +}
> +
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
> +}
> +
> +#define target_attr_str(field)		\
> +	target_attr_show(field)		\
> +static DEVICE_ATTR(field, S_IRUGO, show_target_##field, NULL)
> +
> +target_attr_str(acl);
> +target_attr_str(tpg);
> +target_attr_str(target);
> +target_attr_str(fabric);
> +
> +/*
> + * attrs needed to reference the session's tcm endpoint (acl or tpg) in
> + * configfs
> + */
> +static struct attribute *target_endpoint_attrs[] = {
> +	&dev_attr_acl.attr,
> +	&dev_attr_tpg.attr,
> +	&dev_attr_target.attr,
> +	&dev_attr_fabric.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group target_endpoint_group = {
> +	.name = "tcm_endpoint",
> +	.attrs = target_endpoint_attrs,
> +};
> +
> +/* transportID attrs */
> +#define tpt_id_attr_show(name, fmt_str)					\
> +static ssize_t show_tpid_##name(struct device *dev,			\
> +				struct device_attribute *attr, char *buf) \
> +{									\
> +	struct se_session *se_sess = dev_to_se_sess(dev);		\
> +	return snprintf(buf, PAGE_SIZE, fmt_str, se_sess->tpt_id->name); \
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

I wonder if we need to copy these variables.
Why can't we display them directly, returning an error if the respective
link is not available?
If one is worried about the sysfs/configfs reference counting we can get 
the reference in the _show() functions; wouldn't that be a better solution?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
