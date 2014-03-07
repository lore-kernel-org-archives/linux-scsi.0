From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] target: Change core_dev_del_lun to take a se_lun
 instead of unpacked_lun
Date: Fri, 7 Mar 2014 02:35:34 -0800
Message-ID: <20140307103534.GB14195@infradead.org>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
 <1394144131-31499-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1394144131-31499-4-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 06, 2014 at 02:15:28PM -0800, Andy Grover wrote:
> +void core_dev_del_lun(
>  	struct se_portal_group *tpg,
> +	struct se_lun *lun)
>  {
> +	pr_debug("%s_TPG[%u]_LUN[%u] - Deactivating %s Logical Unit from"
>  		" device object\n", tpg->se_tpg_tfo->get_fabric_name(),
> +		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
>  		tpg->se_tpg_tfo->get_fabric_name());
>  
> +	core_tpg_post_dellun(tpg, lun);

Seems like core_tpg_post_dellun should be folded into core_dev_del_lun?

Also would be nice to get some sane names for all the functions in this
area..
