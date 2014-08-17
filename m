From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH V4 3/4] Introduce XEN scsiback module
Date: Sat, 16 Aug 2014 19:15:23 -0700
Message-ID: <1408241723.30653.162.camel@haakon3.risingtidesystems.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>
	 <1407484194-31876-4-git-send-email-jgross@suse.com>
	 <1407878022.27925.33.camel@haakon3.risingtidesystems.com>
	 <53EB0D9E.6050408@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53EB0D9E.6050408@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-08-13 at 09:02 +0200, Juergen Gross wrote:
> On 08/12/2014 11:13 PM, Nicholas A. Bellinger wrote:

<SNIP>

> >
> >> +
> >> +static int scsiback_port_link(struct se_portal_group *se_tpg,
> >> +			       struct se_lun *lun)
> >> +{
> >> +	struct scsiback_tpg *tpg = container_of(se_tpg,
> >> +				struct scsiback_tpg, se_tpg);
> >> +
> >> +	mutex_lock(&scsiback_mutex);
> >> +
> >> +	mutex_lock(&tpg->tv_tpg_mutex);
> >> +	tpg->tv_tpg_port_count++;
> >> +	mutex_unlock(&tpg->tv_tpg_mutex);
> >> +
> >> +	mutex_unlock(&scsiback_mutex);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >
> > AFAICT, no need to hold scsiback_mutex while incrementing
> > tpg->tv_tpg_port_count.
> 
> So there is a guarantee that port_link and port_unlink are never
> called in parallel?
> 

Correct.  configfs_symlink() only calls create_link() once
type->ct_item_ops->allow_link() -> target_fabric_port_link() ->
TFO->fabric_post_link() has successfully completed, effectively
preventing configfs_unlink() + subsequent TFO->fabric_pre_unlink()
execution until after configfs_symlink() completes.

--nab
