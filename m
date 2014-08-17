From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Re: [Xen-devel] [PATCH V4 3/4] Introduce XEN scsiback module
Date: Sat, 16 Aug 2014 19:33:00 -0700
Message-ID: <1408242780.30653.176.camel@haakon3.risingtidesystems.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>
	 <1407484194-31876-4-git-send-email-jgross@suse.com>
	 <1407878022.27925.33.camel@haakon3.risingtidesystems.com>
	 <53EB0D9E.6050408@suse.com> <53EC3C67.60009@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43851 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaHQCdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Aug 2014 22:33:03 -0400
In-Reply-To: <53EC3C67.60009@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com

On Thu, 2014-08-14 at 06:34 +0200, Juergen Gross wrote:
> On 08/13/2014 09:02 AM, Juergen Gross wrote:
> > On 08/12/2014 11:13 PM, Nicholas A. Bellinger wrote:
> >> Hi Juergen & Co,
> >>
> >> Finally had a chance to review this code.  Comments are inline below..
> 
> >>> +static struct se_node_acl *
> >>> +scsiback_alloc_fabric_acl(struct se_portal_group *se_tpg)
> >>> +{
> >>> +    struct scsiback_nacl *nacl;
> >>> +
> >>> +    nacl = kzalloc(sizeof(struct scsiback_nacl), GFP_KERNEL);
> >>> +    if (!nacl) {
> >>> +        pr_err("Unable to allocate struct scsiback_nacl\n");
> >>> +        return NULL;
> >>> +    }
> >>> +
> >>> +    return &nacl->se_node_acl;
> >>> +}
> >>> +
> >>> +static void
> >>> +scsiback_release_fabric_acl(struct se_portal_group *se_tpg,
> >>> +                 struct se_node_acl *se_nacl)
> >>> +{
> >>> +    struct scsiback_nacl *nacl = container_of(se_nacl,
> >>> +            struct scsiback_nacl, se_node_acl);
> >>> +    kfree(nacl);
> >>> +}
> >>> +
> >>> +static u32 scsiback_tpg_get_inst_index(struct se_portal_group *se_tpg)
> >>> +{
> >>> +    return 1;
> >>> +}
> >>> +
> >>> +static struct se_node_acl *
> >>> +scsiback_make_nodeacl(struct se_portal_group *se_tpg,
> >>> +               struct config_group *group,
> >>> +               const char *name)
> >>> +{
> >>> +    struct se_node_acl *se_nacl, *se_nacl_new;
> >>> +    struct scsiback_nacl *nacl;
> >>> +    u64 wwpn = 0;
> >>> +    u32 nexus_depth;
> >>> +
> >>> +    se_nacl_new = scsiback_alloc_fabric_acl(se_tpg);
> >>> +    if (!se_nacl_new)
> >>> +        return ERR_PTR(-ENOMEM);
> >>> +
> >>> +    nexus_depth = 1;
> >>> +    /*
> >>> +     * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
> >>> +     * when converting a NodeACL from demo mode -> explict
> >>> +     */
> >>> +    se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
> >>> +                name, nexus_depth);
> >>> +    if (IS_ERR(se_nacl)) {
> >>> +        scsiback_release_fabric_acl(se_tpg, se_nacl_new);
> >>> +        return se_nacl;
> >>> +    }
> >>> +    /*
> >>> +     * Locate our struct scsiback_nacl and set the FC Nport WWPN
> >>> +     */
> >>> +    nacl = container_of(se_nacl, struct scsiback_nacl, se_node_acl);
> >>> +    nacl->iport_wwpn = wwpn;
> >>> +
> >>> +    return se_nacl;
> >>> +}
> >>> +
> >>> +static void scsiback_drop_nodeacl(struct se_node_acl *se_acl)
> >>> +{
> >>> +    struct scsiback_nacl *nacl = container_of(se_acl,
> >>> +                struct scsiback_nacl, se_node_acl);
> >>> +    core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
> >>> +    kfree(nacl);
> >>> +}
> >>> +
> >>
> >> As mentioned above, the NodeACL use is unnecessary for this driver so
> >> you can safely drop scsiback_make_node_acl() +
> >> scsiback_alloc_fabric_acl() + scsiback_drop_nodeacl() +
> >> scsiback_release_fabric_acl().
> >
> > Deleted.
> 
> target_fabric_tf_ops_check() complains about missing
> tpg_alloc_fabric_acl and tpg_release_fabric_acl.
> 

Sorry, yes, you still need a struct scsiback_nacl that contains struct
se_node_acl, along with these two callbacks for allocating + releasing
the associated scsiback_nacl memory.

This is required because TFO->tpg_alloc_fabric_acl() is called to
allocate struct scsiback_nacl at core_tpg_add_initiator_node_acl() time
when TFO->check_demo_mode() == 1 has been set.

Normal fabric NodeACLs (eg: ones not generated in the kernel by
demo-mode) hang off configfs, so the TFO->tpg_*_fabric_acl() call is
driven from TFO->fabric_make_nodeacl(), which is the part that can
safely be dropped here.

--nab

