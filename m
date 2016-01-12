From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 4/4] target: Obtain se_node_acl->acl_kref during
	get_initiator_node_acl
Date: Tue, 12 Jan 2016 16:09:41 +0100
Message-ID: <20160112150941.GC2058@lst.de>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com> <1452457724-10629-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452457724-10629-5-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> +++ b/drivers/target/target_core_tpg.c
> @@ -75,9 +75,16 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
>  	unsigned char *initiatorname)
>  {
>  	struct se_node_acl *acl;
> -
> +	/*
> +	 * Obtain the acl_kref now, which will be dropped upon the
> +	 * release of se_sess memory within transport_free_session().
> +	 */

As said before this is incorrect, or rather shold be incorrect.  I
think it should be removed, but if you want to keep it should be
in core_tpg_check_initiator_node_acl and not here.

The call of core_tpg_get_initiator_node_acl in
iscsit_build_sendtargets_response needs a put to balance out the
get of this kref while we're at it.
