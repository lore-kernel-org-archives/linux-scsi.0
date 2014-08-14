From: Juergen Gross <jgross@suse.com>
Subject: Re: Re: [Xen-devel] [PATCH V4 3/4] Introduce XEN scsiback module
Date: Thu, 14 Aug 2014 06:34:47 +0200
Message-ID: <53EC3C67.60009@suse.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>		<1407484194-31876-4-git-send-email-jgross@suse.com>	<1407878022.27925.33.camel@haakon3.risingtidesystems.com> <53EB0D9E.6050408@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaHNEe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Aug 2014 00:34:56 -0400
In-Reply-To: <53EB0D9E.6050408@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com

On 08/13/2014 09:02 AM, Juergen Gross wrote:
> On 08/12/2014 11:13 PM, Nicholas A. Bellinger wrote:
>> Hi Juergen & Co,
>>
>> Finally had a chance to review this code.  Comments are inline below..

>>> +static struct se_node_acl *
>>> +scsiback_alloc_fabric_acl(struct se_portal_group *se_tpg)
>>> +{
>>> +    struct scsiback_nacl *nacl;
>>> +
>>> +    nacl = kzalloc(sizeof(struct scsiback_nacl), GFP_KERNEL);
>>> +    if (!nacl) {
>>> +        pr_err("Unable to allocate struct scsiback_nacl\n");
>>> +        return NULL;
>>> +    }
>>> +
>>> +    return &nacl->se_node_acl;
>>> +}
>>> +
>>> +static void
>>> +scsiback_release_fabric_acl(struct se_portal_group *se_tpg,
>>> +                 struct se_node_acl *se_nacl)
>>> +{
>>> +    struct scsiback_nacl *nacl = container_of(se_nacl,
>>> +            struct scsiback_nacl, se_node_acl);
>>> +    kfree(nacl);
>>> +}
>>> +
>>> +static u32 scsiback_tpg_get_inst_index(struct se_portal_group *se_tpg)
>>> +{
>>> +    return 1;
>>> +}
>>> +
>>> +static struct se_node_acl *
>>> +scsiback_make_nodeacl(struct se_portal_group *se_tpg,
>>> +               struct config_group *group,
>>> +               const char *name)
>>> +{
>>> +    struct se_node_acl *se_nacl, *se_nacl_new;
>>> +    struct scsiback_nacl *nacl;
>>> +    u64 wwpn = 0;
>>> +    u32 nexus_depth;
>>> +
>>> +    se_nacl_new = scsiback_alloc_fabric_acl(se_tpg);
>>> +    if (!se_nacl_new)
>>> +        return ERR_PTR(-ENOMEM);
>>> +
>>> +    nexus_depth = 1;
>>> +    /*
>>> +     * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
>>> +     * when converting a NodeACL from demo mode -> explict
>>> +     */
>>> +    se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
>>> +                name, nexus_depth);
>>> +    if (IS_ERR(se_nacl)) {
>>> +        scsiback_release_fabric_acl(se_tpg, se_nacl_new);
>>> +        return se_nacl;
>>> +    }
>>> +    /*
>>> +     * Locate our struct scsiback_nacl and set the FC Nport WWPN
>>> +     */
>>> +    nacl = container_of(se_nacl, struct scsiback_nacl, se_node_acl);
>>> +    nacl->iport_wwpn = wwpn;
>>> +
>>> +    return se_nacl;
>>> +}
>>> +
>>> +static void scsiback_drop_nodeacl(struct se_node_acl *se_acl)
>>> +{
>>> +    struct scsiback_nacl *nacl = container_of(se_acl,
>>> +                struct scsiback_nacl, se_node_acl);
>>> +    core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);
>>> +    kfree(nacl);
>>> +}
>>> +
>>
>> As mentioned above, the NodeACL use is unnecessary for this driver so
>> you can safely drop scsiback_make_node_acl() +
>> scsiback_alloc_fabric_acl() + scsiback_drop_nodeacl() +
>> scsiback_release_fabric_acl().
>
> Deleted.

target_fabric_tf_ops_check() complains about missing
tpg_alloc_fabric_acl and tpg_release_fabric_acl.


>>> +static void scsiback_set_default_node_attrs(struct se_node_acl *nacl)
>>> +{
>>> +}
>>> +
>>
>> Safe to drop this no-op too.
>
> Okay.

target_fabric_tf_ops_check() wants this to be set, too.


Juergen
