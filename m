From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] tcm_fc: Convert acl lookup to modern
	get_initiator_node_acl usage
Date: Fri, 8 Jan 2016 09:21:15 +0100
Message-ID: <20160108082114.GC32138@lst.de>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com> <1452237348-2277-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452237348-2277-4-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 07:15:47AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch does a simple conversion of tcm_fc code to use
> proper modern core_tpg_get_initiator_node_acl() lookup using
> se_node_acl->acl_kref, and drops the legacy list walk from
> ft_acl_get().
> 
> Note the original lookup also took node_name into account,
> but since ft_init_nodeacl() only ever sets port_name for
> se_node_acl->acl_group within configfs, this is purely
> a mechanical change.
> 
> Cc: Vasu Dev <vasu.dev@linux.intel.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Andy Grover <agrover@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/tcm_fc/tfc_conf.c | 26 ++++++++------------------
>  drivers/target/tcm_fc/tfc_sess.c | 18 +++++++++++-------
>  2 files changed, 19 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
> index 9cdb2ac..9389ba3 100644
> --- a/drivers/target/tcm_fc/tfc_conf.c
> +++ b/drivers/target/tcm_fc/tfc_conf.c
> @@ -222,27 +222,17 @@ static int ft_init_nodeacl(struct se_node_acl *nacl, const char *name)
>  
>  struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
>  {
>  	struct se_portal_group *se_tpg = &tpg->se_tpg;
>  	struct se_node_acl *se_acl;
> +	unsigned char initiatorname[TRANSPORT_IQN_LEN];
>  
> +	ft_format_wwn(&initiatorname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
> +
> +	se_acl = core_tpg_get_initiator_node_acl(se_tpg, &initiatorname[0]);
> +	if (!se_acl)
> +		return NULL;
> +
> +	return container_of(se_acl, struct ft_node_acl, se_node_acl);

I'd say kill this function and opencode it in ft_sess_create.  It
shouldn't be used elsewhere, and ft_sess_create really wants the
se_node_acl and not the ft_node_acl anyway.

Btw, who is dropping the reference we're acuiring through
core_tpg_get_initiator_node_acl?
