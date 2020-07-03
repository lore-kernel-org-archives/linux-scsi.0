Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC21C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 12:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3AB20BED
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 12:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="tmkUFkEY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgGCMvq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 08:51:46 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.84]:55788 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbgGCMvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 08:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593780700; i=@ts.fujitsu.com;
        bh=FAfGTosAhjzI3wC/6xPaGqAtXFcRGqpVkXGdebLDrFU=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=tmkUFkEYgJjqJxRHeWL3rLpEt3S2hkvEVdYfLrWytjs95bWmyaTVxF7tdBZ8hA3hk
         cukUc8p5cHVPirnW2sRbzjKvX0mJXIrdIwE7RaWdpo3MpgTx73CbZj8XpgiUjFpFeg
         o1DhTfnYwsbTqLqkpdT62QX3aegKAfszKT5h0IX1d2ZmXcEwl7VN1+HRY28zmHRdye
         VQY3kBUW4cuzZuwr2Ge8RK4esg0ARDD0MC7uFw7sWzkbFKzFF1CLIRaS6YxRa8pG/r
         3HUSwyA2AOxzyJCAFEUQQH7M7VfWF9tbTsheeJlgpXJRsWtRWB0Q0N3GMUsYkmInvT
         nR8KsV5KNtV7w==
Received: from [100.112.197.196] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-west-1.aws.symcld.net id 37/F8-16187-CD92FFE5; Fri, 03 Jul 2020 12:51:40 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRWlGSWpSXmKPExsViZ8MRontb83+
  cwYe1xhbTPvxkttizaBKTRff1HWwWy4//Y7L4O+kGq0Xr0rdMDmwel694e3x8eovFY/Ppao/P
  m+QCWKJYM/OS8isSWDP65k9kLXhRWNE36QFjA+OruC5GLg4hgUmMEl8OXmKBcPoZJe5fuAvkc
  HIICzhLXLqylREkISKwnVFi/qPfUFW9jBJP2rcxg1SxCRhIrJh0H6yDV8BR4vqPD2BxFgEVid
  Odz5m6GDk4RAXCJZ6t8IcoEZQ4OfMJC0iYU8BXYs62IJAws4CZxLzND5khbHGJW0/mM0HY2hL
  LFr5mnsDINwtJ9ywkLbOQtMxC0rKAkWUVo3lSUWZ6RkluYmaOrqGBga6hoZGuoaWZrpmJXmKV
  bpJeaqlueWpxia6hXmJ5sV5xZW5yTopeXmrJJkZgwKcUHHHYwXj/9Qe9Q4ySHExKorxzRP/HC
  fEl5adUZiQWZ8QXleakFh9ilOHgUJLgPaUBlBMsSk1PrUjLzAFGH0xagoNHSYQ3EhiBQrzFBY
  m5xZnpEKlTjMYcve0LFzFz3N6wZBGzEEtefl6qlDivC0ipAEhpRmke3CBYUrjEKCslzMvIwMA
  gxFOQWpSbWYIq/4pRnINRSZg3HGQKT2ZeCdy+V0CnMAGd4iX/D+SUkkSElFQD05pGYQs5j+tH
  fvOstxSc7M3Hl/lKRbR1+8LlO7m0RMrri269ZGW99oild/5+Bi1JVcdLFjZHtzWH3Hyj2Gpwu
  Z291nr5yWOWPdO1fnC99Wp0jK59MPH5k8rJ9z3D/gXderI09ZoV//ScMoavxjMNzz6TKLmQIy
  19ffonWSve3MLpj7rzCs+d8ymefG+j2uOJQa+qVXgNzk5993daFlta1z/zrWs1opZGzDgYpKy
  uz1Htent9q/fLSr3z96vZWNmqXsw8MW21iuIExQ6WGobMkgN/0x46TJh0OS7IkyH30iKB+1O5
  zOSPCC41sZkhqrZROsL0oY3mvBlznfMWRZgt5imSL7ZkCP2pmnNUSHWXEktxRqKhFnNRcSIAT
  Pl6G4UDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-20.tower-285.messagelabs.com!1593780699!115631!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30814 invoked from network); 3 Jul 2020 12:51:39 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-20.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 3 Jul 2020 12:51:39 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 063CpWB8015811;
        Fri, 3 Jul 2020 13:51:35 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id E7BA520468;
        Fri,  3 Jul 2020 14:51:28 +0200 (CEST)
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
To:     Mike Christie <michael.christie@oracle.com>, hare@suse.de,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
Date:   Fri, 3 Jul 2020 14:51:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-27 06:35, Mike Christie wrote:
> This patch exports the LIO sessions via configfs. If userspace makes
> a "sessions" dir on the ACL or TPG dir to indicate to the kernel it
> supports the new interface on that TPG, then the kernel will make a
> dir per session in the tpg/sessions or tpg/acls/alc/sessions dir

I someone creates a new ACL on a running tpg, can it happen that a
session already is created before user can create the sessions folder?

> It works similar to how some targets export their session info today
> where if it's dynamic session then it goes in the tpg dir and if
> there is an ACL then it goes in the acl's sessions dir. The name of
> the dir is "session-$sid".
>=20
> qla2xxx example:
>=20
> For ACL based sessions:
>=20
> =E2=94=9C=E2=94=80=E2=94=80 21:00:00:24:ff:46:b8:88
> =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 fabric_statistics
> =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 tpgt_1
> =E2=94=82=C2=A0=C2=A0     =E2=94=9C=E2=94=80=E2=94=80 acls
> =E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=
=80 21:00:00:24:ff:46:b8:8a
> =E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=
=94=80 sessions
> =E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0         =E2=94=94=E2=94=
=80=E2=94=80 session-1
>=20
>=20
> or for a dynamic session it would be in the tpg dir
> .....
>=20
> =E2=94=82=C2=A0=C2=A0     =E2=94=9C=E2=94=80=E2=94=80 param
> =E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=94=80 sessions
> =E2=94=82=C2=A0=C2=A0         =E2=94=94=E2=94=80=E2=94=80 session-1
>=20
>=20
>=20
> There is currently nothing in the session-$sid dir. To make the RFC
> easier to read I did not post the transport id patches or the iscsi
> conversion one, but on the final send I'll include them.
>=20
> Note/Warning:
>=20
> The interface has 2 quirks:
>=20
> 1. It works similar to the loop/vhost/usb/xen nexus file interface
> where instead of a rmdir to delete the session you write to some specia=
l
> file. For this new interface we have:
>=20
> /fabric/target/tpgt/sessions/remove_session
>=20
> 2. Because the kernel is making the session, there is no mkdir/rmdir
> support for each session like other objects like LUN, tpg, target, np,
> etc. But, before we remove the parent tpg, we have to remove the
> children sessions still. This gives configfs the behavior it expects
> where parents can't be removed before children and we will not hit
> issues like we hit before.

If I got it right, before user can remove a tpg from sysFS, he first
has to remove all existing sessions by writing the SIDs to the new
remove_sessions file.

But how do you prevent initiator side from quickly creating a new
session e.g. in case of FC? Can we end up in a loop of session removal
and re-creation, especially in case of multiple session an the same tpg?

>=20
> To signal that this new requirement is supported, userspace must do
> mkdir "sessions" on the tpg/acl to create the root sessions dir that
> will contain the individual sessions. See this rtslib patch:
>=20
> https://github.com/mikechristie/rtslib-fb/commit/4af906d2955b739c0585d8=
1b4b1a0d498cc2f663
>=20
> If userspace does not do a mkdir "sessions" on the tpg, then the old
> behavior is supported (we just don't register the session in configfs)
> for that tpg.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_fabric_configfs.c | 187 ++++++++++++++++++=
+++++++--
>   drivers/target/target_core_transport.c       |   5 +
>   include/target/target_core_base.h            |   4 +
>   include/target/target_core_fabric.h          |   4 +-
>   4 files changed, 189 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/tar=
get/target_core_fabric_configfs.c
> index 2b70bdf..3c1288b 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -322,15 +322,45 @@ static struct config_group *target_fabric_make_ma=
ppedlun(
>   	return ERR_PTR(ret);
>   }
>  =20
> -static void target_fabric_drop_mappedlun(
> -	struct config_group *group,
> -	struct config_item *item)
> +static struct config_item_type target_nacl_sess_type =3D {
> +	.ct_owner	=3D THIS_MODULE,
> +};
> +
> +static struct config_group *
> +target_make_nacl_sess_group(struct config_group *group)
>   {
> -	struct se_lun_acl *lacl =3D container_of(to_config_group(item),
> -			struct se_lun_acl, se_lun_group);
> +	struct se_node_acl *se_nacl =3D container_of(group, struct se_node_ac=
l,
> +						   acl_group);
> +	struct se_portal_group *se_tpg =3D se_nacl->se_tpg;
> +
> +	config_group_init_type_name(&se_nacl->acl_sess_group, "sessions",
> +				    &target_nacl_sess_type);
> +	se_tpg->cfgfs_sess_supp =3D true;
> +
> +	return &se_nacl->acl_sess_group;
> +}
> +
> +static struct config_group *target_make_nacl_group(struct config_group=
 *group,
> +						   const char *name)
> +{
> +	if (!strcmp(name, "sessions")) {
> +		return target_make_nacl_sess_group(group);
> +	} else {
> +		return target_fabric_make_mappedlun(group, name);
> +	}
> +}
>  =20
> -	configfs_remove_default_groups(&lacl->ml_stat_grps.stat_group);
> -	configfs_remove_default_groups(&lacl->se_lun_group);
> +static void target_drop_nacl_group(struct config_group *group,
> +				   struct config_item *item)
> +{
> +	struct se_lun_acl *lacl;
> +
> +	if (strstr(config_item_name(item), "lun_")) {
> +		lacl =3D container_of(to_config_group(item), struct se_lun_acl,
> +				    se_lun_group);
> +		configfs_remove_default_groups(&lacl->ml_stat_grps.stat_group);
> +		configfs_remove_default_groups(&lacl->se_lun_group);
> +	}
>  =20
>   	config_item_put(item);
>   }
> @@ -349,8 +379,8 @@ static void target_fabric_nacl_base_release(struct =
config_item *item)
>   };
>  =20
>   static struct configfs_group_operations target_fabric_nacl_base_group=
_ops =3D {
> -	.make_group		=3D target_fabric_make_mappedlun,
> -	.drop_item		=3D target_fabric_drop_mappedlun,
> +	.make_group		=3D target_make_nacl_group,
> +	.drop_item		=3D target_drop_nacl_group,
>   };
>  =20
>   TF_CIT_SETUP_DRV(tpg_nacl_base, &target_fabric_nacl_base_item_ops,
> @@ -799,6 +829,8 @@ static void target_fabric_drop_lun(
>   TF_CIT_SETUP_DRV(tpg_auth, NULL, NULL);
>   TF_CIT_SETUP_DRV(tpg_param, NULL, NULL);
>  =20
> +/* Start of tfc_tpg_session_cit */
> +
>   static void target_cfgfs_sess_release(struct config_item *item)
>   {
>   	struct se_session *se_sess =3D container_of(to_config_group(item),
> @@ -832,6 +864,82 @@ int target_cfgfs_init_session(struct se_session *s=
e_sess)
>   	return 0;
>   }
>  =20
> +int target_cfgfs_register_session(struct se_portal_group *se_tpg,
> +				  struct se_session *se_sess)
> +{
> +	struct se_node_acl *se_nacl;
> +	int ret;
> +
> +	/*
> +	 * If the fabric doesn't support close_session, there's no way for
> +	 * userspace to clean up the session during nacl/tpg deletion.
> +	 */
> +	if (!se_tpg->cfgfs_sess_supp || !se_tpg->se_tpg_tfo->close_session)
> +		return 0;

Why is the cfgfs_sess_supp flag per tpg? It seems to be set if either
tpg/sessions or any acl/sessions folder is created.
So what will happen here if e.g session for an acl is created while
only tpg/sessions exists?
Do we need an similar flag per acl also?
And if we have a per acl and the tpg flag I think they should be removed
when user removes an empty sessions folder.

> +
> +	se_nacl =3D se_sess->se_node_acl;
> +	if (se_nacl->dynamic_node_acl) {
> +		ret =3D configfs_register_group(&se_tpg->tpg_sess_group,
> +					      &se_sess->group);
> +	} else {
> +		ret =3D configfs_register_group(&se_nacl->acl_sess_group,
> +					      &se_sess->group);
> +	}
> +	if (ret)
> +		goto fail;

Do we have a possible race here? I think it would be better to first
call target_depend_item() and then register the new session's group.

> +
> +	/*
> +	 * The session is not created via a mkdir like other objects. A
> +	 * transport event like a login or userspace used the nexus file to
> +	 * initiate creation. However, we want the same behavior as other
> +	 * objects where we must remove the children before removing the
> +	 * parent dir, so do a depend on the parent that is released when the
> +	 * session is removed.
> +	 */
> +	if (se_nacl->dynamic_node_acl) {
> +		ret =3D target_depend_item(&se_tpg->tpg_sess_group.cg_item);
> +	} else {
> +		ret =3D target_depend_item(&se_nacl->acl_sess_group.cg_item);
> +	}
> +	if (ret)
> +		goto unreg_cfgfs;
> +
> +	se_sess->added_to_cfgfs =3D true;
> +	return 0;
> +
> +unreg_cfgfs:
> +	configfs_unregister_group(&se_sess->group);
> +fail:
> +	pr_err("Could not register session dir %d. Error %d.\n", se_sess->sid=
,
> +	       ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(target_cfgfs_register_session);
> +
> +void target_cfgfs_unregister_session(struct se_session *se_sess)
> +{
> +	struct se_node_acl *se_nacl;
> +
> +	/*
> +	 * The session attr interface may not be enabled and discovery
> +	 * sessions are not registered.
> +	 */
> +	if (!se_sess->added_to_cfgfs)
> +		return;
> +
> +	configfs_unregister_group(&se_sess->group);
> +
> +	se_nacl =3D se_sess->se_node_acl;
> +	if (se_nacl->dynamic_node_acl) {
> +		target_undepend_item(&se_sess->se_tpg->tpg_sess_group.cg_item);
> +	} else {
> +		target_undepend_item(&se_nacl->acl_sess_group.cg_item);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(target_cfgfs_unregister_session);
> +
> +/* End of tfc_tpg_session_cit */
> +
>   /* Start of tfc_tpg_base_cit */
>  =20
>   static void target_fabric_tpg_release(struct config_item *item)
> @@ -848,7 +956,66 @@ static void target_fabric_tpg_release(struct confi=
g_item *item)
>   	.release		=3D target_fabric_tpg_release,
>   };
>  =20
> -TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops, NULL);
> +static ssize_t target_tpg_remove_session_store(struct config_item *ite=
m,
> +					       const char *page, size_t count)
> +{
> +	struct se_portal_group *se_tpg =3D container_of(to_config_group(item)=
,
> +						      struct se_portal_group,
> +						      tpg_sess_group);
> +	int ret, sid;
> +
> +	ret =3D kstrtoint(page, 10, &sid);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D target_close_session_sync(se_tpg, sid);
> +	if (ret < 0)
> +		return ret;
> +
> +	return count;
> +}
> +CONFIGFS_ATTR_WO(target_tpg_, remove_session);
> +
> +static struct configfs_attribute *target_tpg_sess_attrs[] =3D {
> +	&target_tpg_attr_remove_session,
> +	NULL,
> +};
> +
> +static struct config_item_type target_tpg_sess_type =3D {
> +	.ct_owner	=3D THIS_MODULE,
> +	.ct_attrs	=3D target_tpg_sess_attrs,
> +};
> +
> +static struct config_group *
> +target_make_tpg_sess_group(struct config_group *group, const char *nam=
e)
> +{
> +	struct se_portal_group *se_tpg =3D container_of(group,
> +						      struct se_portal_group,
> +						      tpg_group);
> +
> +	if (strcmp(name, "sessions"))
> +		return ERR_PTR(-EINVAL);
> +
> +	config_group_init_type_name(&se_tpg->tpg_sess_group, name,
> +				    &target_tpg_sess_type);
> +	se_tpg->cfgfs_sess_supp =3D true;
> +
> +	return &se_tpg->tpg_sess_group;
> +}
> +
> +static void target_drop_tpg_sess_group(struct config_group *group,
> +				       struct config_item *item)
> +{
> +	config_item_put(item);
> +}
> +
> +static struct configfs_group_operations target_tpg_sess_group_ops =3D =
{
> +	.make_group	=3D target_make_tpg_sess_group,
> +	.drop_item	=3D target_drop_tpg_sess_group,
> +};
> +
> +TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops,
> +		 &target_tpg_sess_group_ops);
>  =20
>   /* End of tfc_tpg_base_cit */
>  =20
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/ta=
rget_core_transport.c
> index 942b0c5..87aac76 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -480,6 +480,10 @@ struct se_session *
>   		rc =3D -EACCES;
>   		goto free_session;
>   	}
> +
> +	rc =3D target_cfgfs_register_session(tpg, sess);
> +	if (rc)
> +		goto free_session;
>   	/*
>   	 * Go ahead and perform any remaining fabric setup that is
>   	 * required before transport_register_session().
> @@ -775,6 +779,7 @@ void target_remove_session(struct se_session *se_se=
ss)
>   	se_sess->sess_remove_running =3D 1;
>   	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
>  =20
> +	target_cfgfs_unregister_session(se_sess);
>   	transport_deregister_session_configfs(se_sess);
>   	transport_deregister_session(se_sess);
>   }
> diff --git a/include/target/target_core_base.h b/include/target/target_=
core_base.h
> index 690fff2..f78c1f4 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -571,6 +571,7 @@ struct se_node_acl {
>   	struct config_group	acl_auth_group;
>   	struct config_group	acl_param_group;
>   	struct config_group	acl_fabric_stat_group;
> +	struct config_group	acl_sess_group;
>   	struct list_head	acl_list;
>   	struct list_head	acl_sess_list;
>   	struct completion	acl_free_comp;
> @@ -626,6 +627,7 @@ struct se_session {
>   	void			*sess_cmd_map;
>   	struct sbitmap_queue	sess_tag_pool;
>   	int			sid;
> +	bool			added_to_cfgfs;
>   	struct config_group	group;
>   	const struct target_core_fabric_ops *tfo;
>   };
> @@ -887,6 +889,7 @@ struct se_portal_group {
>   	/* Spinlock for adding/removing sessions */
>   	spinlock_t		session_lock;
>   	struct mutex		tpg_lun_mutex;
> +	bool			cfgfs_sess_supp;
>   	/* linked list for initiator ACL list */
>   	struct list_head	acl_node_list;
>   	struct hlist_head	tpg_lun_hlist;
> @@ -903,6 +906,7 @@ struct se_portal_group {
>   	struct config_group	tpg_attrib_group;
>   	struct config_group	tpg_auth_group;
>   	struct config_group	tpg_param_group;
> +	struct config_group	tpg_sess_group;
>   };
>  =20
>   static inline struct se_portal_group *to_tpg(struct config_item *item=
)
> diff --git a/include/target/target_core_fabric.h b/include/target/targe=
t_core_fabric.h
> index e200faa..1582455 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -154,7 +154,9 @@ void	transport_register_session(struct se_portal_gr=
oup *,
>   void	target_put_nacl(struct se_node_acl *);
>   void	transport_deregister_session_configfs(struct se_session *);
>   void	transport_deregister_session(struct se_session *);
> -
> +int	target_cfgfs_register_session(struct se_portal_group *,
> +				      struct se_session *);
> +void	target_cfgfs_unregister_session(struct se_session *);
>  =20
>   void	transport_init_se_cmd(struct se_cmd *,
>   		const struct target_core_fabric_ops *,
>=20
