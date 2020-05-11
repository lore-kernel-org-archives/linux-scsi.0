Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6875DC47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1C3208DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589178607;
	bh=+02isNE/B33WS0XSuXMjBKNuW6NwbeYUBTXM59Mi0NA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uFjwRNH5YSB9qqzDypw1JAzbxgfzF5FptWEruDEg6SVeuJV0BiGROBPFP8Q+W8NjR
	 sEdZoWeuoEVM7/XI97gNTSbJ9589GHuPXd6UvzhkqmKmhnCzSC2XncmJigyCGgyaEW
	 BMkQ5y1/HjOBPlLv8RpIw/ONXyHQpAyf2wXbj/M8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgEKGaG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 02:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgEKGaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 02:30:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F329207DD;
        Mon, 11 May 2020 06:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589178604;
        bh=+02isNE/B33WS0XSuXMjBKNuW6NwbeYUBTXM59Mi0NA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1I0Yc65gseEOBrSNYx7iamLGdxKRyqtjb1NJU2MqEWyZMxWQaXVdccy3cBHSc8nq
         rxAQXsbufWOB09ryARgpKs43DaFSn+SXhmn/ks/bQkR2fbpwVtAsP2CNfCuO5iw7HK
         I1FgAp8zmObpmod483mDnJNFnBZcJ/x0nhCAH9XI=
Date:   Mon, 11 May 2020 08:30:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Christie <mchristi@redhat.com>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 11/15] target: add sysfs support
Message-ID: <20200511063002.GA1260895@kroah.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-12-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510215744.21999-12-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 10, 2020 at 04:57:40PM -0500, Mike Christie wrote:
> These next two patches add a sysfs interface that reports the target
> layer's I_T nexuses/sessions. For the non-SCSI people cc'd, this just means
> we are reporting a server's connections to remote clients.
> 
> This patch adds the upper level dirs which shows/organizes our local port
> (tpgts below) and the connection (session below). The next patch will then
> add the dirs/files for each connection/session which exports info like
> ACL/permissions and SCSI port values.
> 
> Here is the general layout:
> 
> [sys]# tree scsi_target/
> scsi_target/
> |-- fabric/target module
> |   `-- target name
> |       `-- tpgt_$target_port_group_number
> |           `-- sessions
> |               `-- initiator name - session ID number
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> 
> Here is an example with the scsi target layer's iSCSI driver:
> 
> scsi_target/
> |-- iscsi
> |   `-- iqn.1999-09.com.tcmu:minna
> |       `-- tpgt_1
> |           `-- sessions
> |               `-- iqn.2005-03.com.ceph:ini1-1
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> |-- fc
> |-- loopback
> |-- qla2xxx_tcm
> 
> 
> Note/Question for Greg:
> 
> We are not exporting info in the upper level dirs like "fabric/target
> module", "target name", tpgt, etc and just need those dirs to be able to
> organize/view the endpoints of the session. So, in this patch I made a new
> top level dir scsi_target and made the other dirs with
> kobject_create_and_add. It looks like we could also add device structs in
> the target related structs, use classes, and build the tree/hierarchy that
> way too. It was not clear to me when to use one or the other.

Never use kobject calls in a driver subsystem like you have here, as
those objects will not be seen by userspace tools that get uevents.
Just use real 'struct devices' if you really really need a deep
directory tree.

But I would push back here, why do you feel you want such a deep tree?
What are you getting from this?  Why do you need that "sessions"
directory at all?

Try doing this with just attributes and if you really really need it,
child devices.

> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
> 
> V3:
> - delay tpg deletion to allow fabric modules time to remove their
>   sessions.
> - Added root sessions dir for easier lookup if userspace has the
>   session id.
> 
> V2:
> - rename top level dir to scsi_target
> 
>  drivers/target/target_core_configfs.c        | 30 +++++++++++++++++++++
>  drivers/target/target_core_fabric_configfs.c | 40 ++++++++++++++++++++++++++++
>  drivers/target/target_core_internal.h        |  1 +
>  include/target/target_core_base.h            |  4 +++
>  4 files changed, 75 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index ff82b21f..3eb2566 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -63,6 +63,9 @@
>  	pr_debug("Setup generic %s\n", __stringify(_name));		\
>  }
>  
> +static struct kobject *tcm_core_kobj;
> +static struct kobject *tcm_core_sessions_kobj;

Static kobjects for multiple devices?

> +
>  extern struct t10_alua_lu_gp *default_lu_gp;
>  
>  static LIST_HEAD(g_tf_list);
> @@ -245,6 +248,11 @@ static struct config_group *target_core_register_fabric(
>  	}
>  	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
>  			" %s\n", tf->tf_ops->fabric_name);
> +
> +	tf->kobj = kobject_create_and_add(name, tcm_core_kobj);
> +	if (!tf->kobj)
> +		goto dec_tf;

You just created a kobject here that did not send any information to
userspace :(

What are you using this kobject for?


> +
>  	/*
>  	 * On a successful target_core_get_fabric() look, the returned
>  	 * struct target_fabric_configfs *tf will contain a usage reference.
> @@ -261,6 +269,10 @@ static struct config_group *target_core_register_fabric(
>  	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
>  		 config_item_name(&tf->tf_group.cg_item));
>  	return &tf->tf_group;
> +
> +dec_tf:
> +	atomic_dec(&tf->tf_access_cnt);
> +	return ERR_PTR(-EINVAL);
>  }
>  
>  /*
> @@ -283,6 +295,9 @@ static void target_core_deregister_fabric(
>  	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
>  			" %s\n", config_item_name(item));
>  
> +	kobject_del(tf->kobj);
> +	kobject_put(tf->kobj);
> +
>  	configfs_remove_default_groups(&tf->tf_group);
>  	config_item_put(item);
>  }
> @@ -3538,6 +3553,15 @@ static int __init target_core_init_configfs(void)
>  
>  	target_init_dbroot();
>  
> +	tcm_core_kobj = kobject_create_and_add("scsi_target", NULL);
> +	if (!tcm_core_kobj)
> +		goto out;

A brand new sysfs root directory?  No, please do not do that at all.
Why can't you use your driver's directory?  Or your bus's directory,
what is wrong with that?

> +
> +	tcm_core_sessions_kobj = kobject_create_and_add("sessions",
> +							tcm_core_kobj);

And a subdir under that for no reason as well?  Again, no, please do not
do that.

For this reason alone I do not like this patch, no new root directories
in sysfs please unless you can really justify it.  A "mere" driver
subsystem does not pass that test at all, sorry.

thanks,

greg k-h
