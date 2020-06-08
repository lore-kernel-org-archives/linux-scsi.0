Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BBEC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 12:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FECB2078C
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 12:07:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="iWvlXwSM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgFHMHR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 08:07:17 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.112]:16700 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgFHMHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 08:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1591618029; i=@ts.fujitsu.com;
        bh=IRiXXwEXs8vzVOxblq3Wttz9WYqYfv/xuAaw2PDuyHs=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=iWvlXwSM/2fFxJkjhqMeTOLmzzXJx9pkQESfVq3IDPiNtK//Ubv7GRuVoDIIaX32V
         sPKwMdv6mKMsXc+V6kcRp/VtSbpNlQtPwHQCk52WX+90duEiThL/nZQGbRNCTrWcjK
         6TFuIjDrsxCx3kjMueoNfRD+ml/OqT1WM8WLqh5j9b4MwJCzq2yp0I3RA2v6MqnCf9
         s96HnXxSUGRZiJjOZe1Jiph46KjYvPoZmesDf1+fJ+W5V7A+DiHPfPs5nGQ0FyG2Kb
         IgE88ijJGDMiOrQAMjkdYmab6lNL8R0R7SxCUePDKeoBdzLPs5a9O0mrs6zslc0Run
         vYHMKymdml1xQ==
Received: from [100.113.6.221] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-central-1.aws.symcld.net id C3/75-28513-CE92EDE5; Mon, 08 Jun 2020 12:07:08 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRWlGSWpSXmKPExsViZ8MRqvtG816
  cQeMDRYtpH34yWzQvXs9m0X19B5vF8uP/mCz+TrrBatG69C2TA5vH5SveHvvnrmH3+Pj0FovH
  501yASxRrJl5SfkVCawZB3sWshZcb2Ks+Pj9PVMD47fcLkYuDiGBSYwSD1ZeZ4Zw+hklXvfuB
  HI4OYQFnCQm/FnHDpIQEVjJKPF89kZ2kASzgLHEmfYDjBAd3YwS866tBEuwCRhIrJh0nwXE5h
  VwlHi4rAPMZhFQkWg4MI8NxBYVCJd4seUPK0SNoMTJmU/AajgFfCSa765ig1hgJjFv80NmCFt
  c4taT+UwQtrbEsoWvmScw8s9C0j4LScssJC2zkLQsYGRZxWiZVJSZnlGSm5iZo2toYKBraGis
  a6ZrZGKgl1ilm6SXWqqbnJpXUpQIlNVLLC/WK67MTc5J0ctLLdnECIyKlEK2DzsYp7z5oHeIU
  ZKDSUmUdyLvvTghvqT8lMqMxOKM+KLSnNTiQ4wyHBxKEry/NYBygkWp6akVaZk5wAiFSUtw8C
  iJ8G4HSfMWFyTmFmemQ6ROMepy3Hy/ZBGzEEtefl6qlDhvAjDehQRAijJK8+BGwJLFJUZZKWF
  eRgYGBiGegtSi3MwSVPlXjOIcjErCvDdAVvFk5pXAbXoFdAQT0BE/m26BHFGSiJCSamBK09Wv
  fnWPf6/c6XfBYS7vt+1XZvjBvnvGr3V/Zb1Xi7W+kn7gwTIhKqd5hUD689LIxi3d8sxOLhEbH
  4pv93LpWDr5/NqY/9bvTkw6p1afWb7rtZj6Jvnm2SmRfqr3Xdz2FE6eebn7ZkuN/A7vI5wRqQ
  uFxPewvbYws7paXP5k0lc+i6rkq5yTcozP1nDPUN67vG1X6hK+CJ32aRkChdPb/1xkquJ6/HR
  KXqwix8On92w7Qxker6o972ogU+YtkHg3VPfDqS9q7w69Xa/+zafDKcjf3vCfqcvDg146W02d
  rTdrPQ8o5Lfwvz7Tqmoif3mWmf7SU9ztvPv67sac59y5lP8Kd52EqnPVi0urNJRYijMSDbWYi
  4oTAZtRtV+RAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-12.tower-238.messagelabs.com!1591618027!1976212!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 8716 invoked from network); 8 Jun 2020 12:07:08 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-12.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 8 Jun 2020 12:07:08 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 058C6QR2013571;
        Mon, 8 Jun 2020 13:06:46 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id AAFBE20804;
        Mon,  8 Jun 2020 14:06:11 +0200 (CEST)
Subject: Re: [PATCH 11/17] target: add session sysfs class support
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <780d2db6-2a29-677d-8ee2-a731bb98fb0f@ts.fujitsu.com>
Date:   Mon, 8 Jun 2020 14:06:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/07/20 22:35, Mike Christie wrote:
> This patch adds a sysfs interface to export the target module's
> sessions using the driver module class structure. With this we
> now have a common way to export session info for all fabric modules
> and we can export info about all sessions not just the first one
> on a ACL like for iscsi. We can also export more info then PAGE_SIZE
> bytes for all sessions (looking at iscsi and qla2xxx and the
> dynamic_sessions file abuse).
>=20
> Here is a tree the new class dir scsi_target_session:
>=20
> session-1/
> =E2=94=9C=E2=94=80=E2=94=80 power
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 autosuspend_delay_ms
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 control
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 runtime_active_time
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 runtime_status
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 runtime_suspended_time
> =E2=94=9C=E2=94=80=E2=94=80 subsystem -> ../../../../class/scsi_target_=
session
> =E2=94=9C=E2=94=80=E2=94=80 tcm_endpoint
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 acl
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 fabric
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 target
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 tpg
> =E2=94=9C=E2=94=80=E2=94=80 transport_id
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 name
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 proto
> =E2=94=94=E2=94=80=E2=94=80 uevent
>=20
> The Documentation/ABI/testing/sysfs-scsi-target-session file in this
> patch describes the files and dirs.
>=20
> Userspace apps like tcmu-runner and targetcli, can either:
>=20
> 1. If they have the session ID, then directly look up the session's
> info like with tagetcli's session sid case.
>=20
> 2. If they have the target side's endpoint object name like the ACL
> or tpg, then they have to scan each session's tcm_endpoint dir. This
> should hopefully not be the normal case. For tcmu-runner we will
> normally scan sysfs, cache the info, then update the cache as we get
> events about sessions being added/removed.
>=20
> Note that to make it easier for Greg to review I am just including
> the sysfs parts in this patch. The next patch hooks into the target
> code and enables it.
>=20
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   .../ABI/testing/sysfs-scsi-target-session          |  71 ++++++
>   drivers/target/target_core_internal.h              |   5 +
>   drivers/target/target_core_sysfs.c                 | 265 ++++++++++++=
+++++++++
>   include/target/target_core_base.h                  |   8 +
>   include/target/target_core_fabric.h                |   6 +-
>   5 files changed, 354 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-scsi-target-sessio=
n
>   create mode 100644 drivers/target/target_core_sysfs.c
>=20
> diff --git a/Documentation/ABI/testing/sysfs-scsi-target-session b/Docu=
mentation/ABI/testing/sysfs-scsi-target-session
> new file mode 100644
> index 0000000..c8cefcc
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-scsi-target-session
> @@ -0,0 +1,71 @@
> +What:		/sys/class/scsi_target_session/session-N
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	The session dir contains a dir for each I_T Nexus. The na=
me of
> +		the dir is "session-" followed by an integer that is unique
> +		across all fabrics. The dir contains files that export info like
> +		the TPG/ACL the session is attached to, SCSI port values, and
> +		fabric and transport specific values.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	The tcm_endpoint dir indicates what target_core_mod objec=
t
> +		the session is attached to.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/acl
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the ACL that was used to validate log=
in or
> +		an empty string if no user created ACL was used.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/target
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the target the session is accessed th=
rough.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/fabric
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the fabric the session is accessed th=
rough.
> +
> +What:		/sys/class/scsi_target_session/session-N/tcm_endpoint/tpg
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the name of the tpg the session is accessed throu=
gh.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	The transport_id contains the SCSI TransportID values for=
 the
> +		initiator port as defined in SPC4r37.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id/proto
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the SCSI protocol identifier in hex defined in SP=
C4r37.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id/name
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	Returns the port name/address/id in the protocol specific
> +		TransportID format defined in SPC4r37's.
> +
> +What:		/sys/class/scsi_target_session/session-N/transport_id/session_i=
d
> +Date:		June 5, 2020
> +KernelVersion:	5.9
> +Contact:	linux-scsi@vger.kernel.org
> +Description:	If is proto=3D0x5 (iSCSI) and TPID FORMAT=3D1 this file w=
ill exist
> +		and will return the iSCSI Initiator Session ID in ASCII
> +		characters that are the hexadecimal digits converted from the
> +		binary iSCSI initiator session identifier value. If iSCSI and
> +		format=3D1 is not used by this session this file will not exist.

If I got it right, this is not how the code works.
AFAICS, the file will always exist, but reading it delivers data only if
proto=3D0x5 (iSCSI) and TPID FORMAT=3D1

Thank you,
Bodo

> diff --git a/drivers/target/target_core_internal.h b/drivers/target/tar=
get_core_internal.h
> index 8533444..93bf5fed 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -105,6 +105,11 @@ int	target_get_pr_transport_id(struct se_node_acl =
*nacl,
>   const char *target_parse_pr_out_transport_id(struct se_portal_group *=
tpg,
>   		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
>  =20
> +/* target_core_sysfs.c */
> +int	target_sysfs_init_session(struct se_session *sess);
> +void	target_sysfs_init(void);
> +void	target_sysfs_exit(void);
> +
>   /* target_core_hba.c */
>   struct se_hba *core_alloc_hba(const char *, u32, u32);
>   int	core_delete_hba(struct se_hba *);
> diff --git a/drivers/target/target_core_sysfs.c b/drivers/target/target=
_core_sysfs.c
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
> +	struct se_session *se_sess =3D dev_to_se_sess(dev);
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
> +	struct se_session *se_sess =3D dev_to_se_sess(dev);		\
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
> + * attrs needed to reference the session's tcm endpoint (acl or tpg) i=
n
> + * configfs
> + */
> +static struct attribute *target_endpoint_attrs[] =3D {
> +	&dev_attr_acl.attr,
> +	&dev_attr_tpg.attr,
> +	&dev_attr_target.attr,
> +	&dev_attr_fabric.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group target_endpoint_group =3D {
> +	.name =3D "tcm_endpoint",
> +	.attrs =3D target_endpoint_attrs,
> +};
> +
> +/* transportID attrs */
> +#define tpt_id_attr_show(name, fmt_str)					\
> +static ssize_t show_tpid_##name(struct device *dev,			\
> +				struct device_attribute *attr, char *buf) \
> +{									\
> +	struct se_session *se_sess =3D dev_to_se_sess(dev);		\
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
> +	struct se_session *se_sess =3D dev_to_se_sess(dev);
> +
> +	if (!se_sess->tpt_id->session_id)
> +		return 0;
> +
> +	return snprintf(buf, PAGE_SIZE, "0x%s", se_sess->tpt_id->session_id);
> +}
> +
> +static DEVICE_ATTR(session_id, S_IRUGO, session_id_show, NULL);
> +
> +static struct attribute *tpt_id_attrs[] =3D {
> +	&dev_attr_proto.attr,
> +	&dev_attr_name.attr,
> +	&dev_attr_session_id.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group tpt_id_group =3D {
> +	.name =3D "transport_id",
> +	.attrs =3D tpt_id_attrs,
> +};
> +
> +static const struct attribute_group *def_session_groups[] =3D {
> +	&tpt_id_group,
> +	&target_endpoint_group,
> +	NULL,
> +};
> +
> +static struct class session_class =3D {
> +	.owner		=3D THIS_MODULE,
> +	.name		=3D "scsi_target_session",
> +	.dev_release	=3D target_sysfs_session_release,
> +	.dev_groups	=3D def_session_groups,
> +};
> +
> +int target_sysfs_init_session(struct se_session *se_sess)
> +{
> +	int ret;
> +
> +	ret =3D ida_simple_get(&session_ida, 1, 0, GFP_KERNEL);
> +	if (ret < 0) {
> +		pr_err("Unable to allocate session index.\n");
> +		return ret;
> +	}
> +	se_sess->sid =3D ret;
> +
> +	device_initialize(&se_sess->dev);
> +	se_sess->dev.class =3D &session_class;
> +
> +	ret =3D dev_set_name(&se_sess->dev, "session-%d", se_sess->sid);
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
> +	 * to its target, and we also don't have to worry about mixing config=
fs
> +	 * refcounts with sysfs.
> +	 */
> +	if (!se_sess->se_node_acl->dynamic_node_acl) {
> +		se_sess->acl_name =3D kstrdup(se_sess->se_node_acl->initiatorname,
> +					    GFP_KERNEL);
> +		if (!se_sess->acl_name)
> +			return -ENOMEM;
> +	}
> +
> +	se_sess->target_name =3D kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_ite=
m.ci_name,
> +				       GFP_KERNEL);
> +	if (!se_sess->target_name)
> +		goto free_acl;
> +
> +	if (se_sess->tfo->fabric_alias)
> +		se_sess->fabric_name =3D kstrdup(se_sess->tfo->fabric_alias,
> +					       GFP_KERNEL);
> +	else
> +		se_sess->fabric_name =3D kstrdup(se_sess->tfo->fabric_name,
> +					       GFP_KERNEL);
> +	if (!se_sess->fabric_name)
> +		goto free_target;
> +
> +	se_sess->tpg_name =3D kstrdup(se_tpg->tpg_group.cg_item.ci_name,
> +				    GFP_KERNEL);
> +	if (!se_sess->tpg_name)
> +		goto free_fabric;
> +
> +	return 0;
> +
> +free_fabric:
> +	kfree(se_sess->fabric_name);
> +	se_sess->fabric_name =3D NULL;
> +free_target:
> +	kfree(se_sess->target_name);
> +	se_sess->target_name =3D NULL;
> +free_acl:
> +	kfree(se_sess->acl_name);
> +	se_sess->acl_name =3D NULL;
> +	return -ENOMEM;
> +}
> +
> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
> +			     struct se_session *se_sess)
> +{
> +	struct t10_transport_id *tpt_id =3D se_sess->tpt_id;
> +	int ret;
> +
> +	if (!try_module_get(se_sess->tfo->module))
> +		return -EINVAL;
> +
> +	ret =3D target_cp_endpoint_strs(se_tpg, se_sess);
> +	if (ret)
> +		goto put_mod;
> +
> +	se_sess->dev.groups =3D se_sess->tfo->session_attr_groups;
> +	ret =3D device_add(&se_sess->dev);
> +	if (ret) {
> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
> +		       se_sess->sid, ret);
> +		goto free_ep_strs;
> +	}
> +
> +	pr_info("TCM added session-%d from [fabric: %s, target: %s, tpg %s, a=
cl: %s] to [initiator port: %s%s%s]",
> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic"=
,
> +		tpt_id->name, tpt_id->session_id ? "," : "",
> +		tpt_id->session_id ? tpt_id->session_id : "");
> +
> +	se_sess->sysfs_added =3D true;
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
> +	struct t10_transport_id *tpt_id =3D se_sess->tpt_id;
> +
> +	/* discovery sessions are normally not added to sysfs */
> +	if (!se_sess->sysfs_added)
> +		return;
> +	se_sess->sysfs_added =3D false;
> +
> +	pr_info("TCM removed session-%d from [fabric: %s, target: %s, tpg %s,=
 acl: %s] to [initiator port: %s%s%s]",
> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic"=
,
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
> +}
> diff --git a/include/target/target_core_base.h b/include/target/target_=
core_base.h
> index 2e79cce..0d9916b 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -8,6 +8,7 @@
>   #include <linux/percpu-refcount.h>
>   #include <linux/semaphore.h>     /* struct semaphore */
>   #include <linux/completion.h>
> +#include <linux/device.h>
>  =20
>   #define TARGET_CORE_VERSION		"v5.0"
>  =20
> @@ -635,6 +636,13 @@ struct se_session {
>   	wait_queue_head_t	cmd_list_wq;
>   	void			*sess_cmd_map;
>   	struct sbitmap_queue	sess_tag_pool;
> +	struct device		dev;
> +	int			sid;
> +	bool			sysfs_added;
> +	char			*acl_name;
> +	char			*tpg_name;
> +	char			*target_name;
> +	char			*fabric_name;
>   };
>  =20
>   struct se_device;
> diff --git a/include/target/target_core_fabric.h b/include/target/targe=
t_core_fabric.h
> index ced377f..2a93daa 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -105,6 +105,8 @@ struct target_core_fabric_ops {
>   	struct configfs_attribute **tfc_tpg_nacl_auth_attrs;
>   	struct configfs_attribute **tfc_tpg_nacl_param_attrs;
>  =20
> +	const struct attribute_group **session_attr_groups;
> +
>   	/*
>   	 * Set this member variable to true if the SCSI transport protocol
>   	 * (e.g. iSCSI) requires that the Data-Out buffer is transferred in
> @@ -145,7 +147,9 @@ void	transport_register_session(struct se_portal_gr=
oup *,
>   void	target_put_nacl(struct se_node_acl *);
>   void	transport_deregister_session_configfs(struct se_session *);
>   void	transport_deregister_session(struct se_session *);
> -
> +void	target_sysfs_remove_session(struct se_session *se_sess);
> +int	target_sysfs_add_session(struct se_portal_group *se_tpg,
> +				 struct se_session *se_sess);
>  =20
>   void	transport_init_se_cmd(struct se_cmd *,
>   		const struct target_core_fabric_ops *,
>=20
