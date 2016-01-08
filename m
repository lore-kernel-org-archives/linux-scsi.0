From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] target: Obtain se_node_acl->acl_kref during
	get_initiator_node_acl
Date: Fri, 8 Jan 2016 09:14:12 +0100
Message-ID: <20160108081412.GA32138@lst.de>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com> <1452237348-2277-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50200 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbcAHIOP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jan 2016 03:14:15 -0500
Content-Disposition: inline
In-Reply-To: <1452237348-2277-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

>  	mutex_lock(&tpg->acl_node_mutex);
>  	acl =3D __core_tpg_get_initiator_node_acl(tpg, initiatorname);
> +	/*
> +	 * Obtain the acl_kref now, which will be dropped upon the
> +	 * release of se_sess memory within transport_free_session().
> +	 */
> +	if (acl)
> +		kref_get(&acl->acl_kref);

=D0=86 think the comment is highly confusing as it's about one of the
callers, while the function has many.

I'd suggest you move it to core_tpg_check_initiator_node_acl instead.

Also I think iscsit_build_sendtargets_response will need a put on
the nacl, otherwise you'll leak references.

While we're at it - is there any god reason to keep acl_pr_ref_count
as a separate entity from acl_kref?

>  void transport_free_session(struct se_session *se_sess)
>  {
> +	struct se_node_acl *se_nacl =3D se_sess->se_node_acl;
> +	/*
> +	 * Drop the se_node_acl->nacl_kref obtained from within
> +	 * core_tpg_get_initiator_node_acl().
> +	 */
> +	if (se_nacl) {
> +		se_sess->se_node_acl =3D NULL;

Whats the point of zeroing se_node_acl just before freeing se_sess?

>  	/*
>  	 * If last kref is dropping now for an explicit NodeACL, awake slee=
ping
>  	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
> -	 * removal context.
> +	 * removal context from within transport_free_session() code.
>  	 */

The comment neds to move to transport_free_session.  Or maybe just remo=
ved
given that it's obvious from the code flow.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
