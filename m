From: "vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] scsi: fix Wunused-but-set-variable
 buildwarning
Date: Thu, 14 May 2015 15:39:47 -0700
Message-ID: <1431643187.4358.2.camel@lin-nd1-054.jf.intel.com>
References: <1431627166-12729-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1431627166-12729-1-git-send-email-hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, "James E.J.
 Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-05-14 at 20:12 +0200, Nicholas Mc Guire wrote:
> commit "[SCSI] libfc: remove tgt_flags from fc_fcp_pkt struct"
> removed the last usage of rpriv (rpriv->flags) but forgot to remove
> the unused rpriv struct resulting in:
>   drivers/scsi/libfc/fc_fcp.c: In function 'fc_queuecommand':
>   drivers/scsi/libfc/fc_fcp.c:1795:30: warning: variable 'rpriv' set 
>   but not used [-Wunused-but-set-variable]
> so simply drop its declaration and setting.
> 
> Patch was compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y,
> CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m
> 
> Patch is against 4.1-rc3 (localversion-next is -next-20150514)
> 
> Signed-off-by: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
> ---
> 
>  drivers/scsi/libfc/fc_fcp.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index c438b81..fee6928 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -1792,7 +1792,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
>  	struct fc_lport *lport = shost_priv(shost);
>  	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
>  	struct fc_fcp_pkt *fsp;
> -	struct fc_rport_libfc_priv *rpriv;
>  	int rval;
>  	int rc = 0;
>  	struct fc_stats *stats;
> @@ -1814,8 +1813,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
>  		goto out;
>  	}
>  
> -	rpriv = rport->dd_data;
> -
>  	if (!fc_fcp_lport_queue_ready(lport)) {
>  		if (lport->qfull)
>  			fc_fcp_can_queue_ramp_down(lport);

Looks good, Thx

Acked-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
