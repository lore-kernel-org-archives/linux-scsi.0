From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: Fix crash triggered by removing node ACL
Date: Mon, 07 Feb 2011 00:54:13 -0800
Message-ID: <1297068853.13752.181.camel@haakon2.linux-iscsi.org>
References: <AANLkTikJLdR58V-tvCPYYFc4pAxv_mzJ0LFZGMJ=BtKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51961 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1BGIyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 03:54:19 -0500
In-Reply-To: <AANLkTikJLdR58V-tvCPYYFc4pAxv_mzJ0LFZGMJ=BtKA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2011-02-06 at 20:52 +0100, Fubo Chen wrote:
> With tcm_mvsas creating tpg, creating acl, removing acl and removing
> tpg triggers kernel crash during removing tpg.
> With patch below crash disappears. Does patch make sense ?
> 
> Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
> 

Thanks for spotting this bug with the tcm_mod_builder.py generated
configfs skeleton!

My comments are below..

> ---
>  Documentation/target/tcm_mod_builder.py |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/target/tcm_mod_builder.py
> b/Documentation/target/tcm_mod_builder.py
> index 89af6c7..3925481 100755
> --- a/Documentation/target/tcm_mod_builder.py
> +++ b/Documentation/target/tcm_mod_builder.py
> @@ -57,6 +57,7 @@ def tcm_mod_build_FC_include(fabric_mod_dir_var,
> fabric_mod_name):
>  	buf += "	char nport_name[" + fabric_mod_name.upper() + "_NAMELEN];\n"
>  	buf += "	/* Returned by " + fabric_mod_name + "_make_nodeacl() */\n"
>  	buf += "	struct se_node_acl se_node_acl;\n"
> +	buf += "	struct se_portal_group *se_tpg;\n"
>  	buf += "};\n"
>  	buf += "\n"
>  	buf += "struct " + fabric_mod_name + "_tpg {\n"
> @@ -112,6 +113,7 @@ def tcm_mod_build_SAS_include(fabric_mod_dir_var,
> fabric_mod_name):
>  	buf += "	char iport_name[" + fabric_mod_name.upper() + "_NAMELEN];\n"
>  	buf += "	/* Returned by " + fabric_mod_name + "_make_nodeacl() */\n"
>  	buf += "	struct se_node_acl se_node_acl;\n"
> +	buf += "	struct se_portal_group *se_tpg;\n"
>  	buf += "};\n\n"
>  	buf += "struct " + fabric_mod_name + "_tpg {\n"
>  	buf += "	/* SAS port target portal group tag for TCM */\n"
> @@ -163,6 +165,7 @@ def
> tcm_mod_build_iSCSI_include(fabric_mod_dir_var, fabric_mod_name):
>  	buf += "	char iport_name[" + fabric_mod_name.upper() + "_NAMELEN];\n"
>  	buf += "	/* Returned by " + fabric_mod_name + "_make_nodeacl() */\n"
>  	buf += "	struct se_node_acl se_node_acl;\n"
> +	buf += "	struct se_portal_group *se_tpg;\n"
>  	buf += "};\n\n"
>  	buf += "struct " + fabric_mod_name + "_tpg {\n"
>  	buf += "	/* iSCSI target portal group tag for TCM */\n"
> @@ -278,6 +281,7 @@ def tcm_mod_build_configfs(proto_ident,
> fabric_mod_dir_var, fabric_mod_name):
>  	buf += "	 * Locate our struct " + fabric_mod_name + "_nacl and set
> the FC Nport WWPN\n"
>  	buf += "	 */\n"
>  	buf += "	nacl = container_of(se_nacl, struct " + fabric_mod_name +
> "_nacl, se_node_acl);\n"
> +	buf += "	nacl->se_tpg = se_tpg;\n"
> 
>  	if proto_ident == "FC" or proto_ident == "SAS":
>  		buf += "	nacl->" + fabric_mod_init_port + "_wwpn = wwpn;\n"
> @@ -289,6 +293,7 @@ def tcm_mod_build_configfs(proto_ident,
> fabric_mod_dir_var, fabric_mod_name):
>  	buf += "{\n"
>  	buf += "	struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
>  	buf += "				struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
> +	buf += "	core_tpg_del_initiator_node_acl(nacl->se_tpg, se_acl, 1);\n"
>  	buf += "	kfree(nacl);\n"
>  	buf += "}\n\n"
> 

Ok, calling core_tpg_del_initiator_node_acl() is the main bit that was
missing here, and so we can go ahead and just use:

	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);\n"

w/o the extra se_tpg member reference in the fabric dependent nacl
structure.

Here is the patch I am pushing into lio-core-2.6.git/linus-38-rc3.

Thanks Fubo!

--nab

>From 279abc85152ed82add01086871e29cf029ef1403 Mon Sep 17 00:00:00 2001
From: Fubo Chen <fubo.chen@gmail.com>
Date: Mon, 7 Feb 2011 01:13:54 -0800
Subject: [PATCH] target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py

This patch adds the missing core_tpg_del_initiator_node_acl() call required
by fabric modules for struct se_node_acl->acl_group context shutdown via

        target_core_fabric_configfs.c:target_fabric_nacl_base_release() ->

                struct target_core_fabric_ops->fabric_drop_nodeacl()

for tcm_mod_builder.py generated $FABRIC_MOD_configfs.c skeleton code.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 Documentation/target/tcm_mod_builder.py |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 89af6c7..7ef9b84 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -289,6 +289,7 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
        buf += "{\n"
        buf += "        struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
        buf += "                                struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
+       buf += "        core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);\n"
        buf += "        kfree(nacl);\n"
        buf += "}\n\n"

-- 
1.5.6.5


