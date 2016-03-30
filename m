From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RESEND] [PATCH v11 3/6] added support for DesignWare Controller
Date: Wed, 30 Mar 2016 10:54:17 +0100
Message-ID: <56FBA249.2070801@synopsys.com>
References: <cover.1457111366.git.jpinto@synopsys.com>
 <a2f0601b03aad273819e7a8da2a65664759e2889.1457111366.git.jpinto@synopsys.com>
 <5B8DA87D05A7694D9FA63FD143655C1B541CD517@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B541CD517-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "mark.rutland-5wv7dgnIgG8@public.gmane.org" <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Hi Thomas,

On 3/29/2016 1:15 PM, Winkler, Tomas wrote:
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index 2570d94..8b0cdf0 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -262,6 +262,7 @@ struct ufs_pwr_mode_info {
>   * @suspend: called during host controller PM callback
>   * @resume: called during host controller PM callback
>   * @dbg_register_dump: used to dump controller debug information
> + * @custom_phy_initialization: used to initialize phys in DWC Cores
>   */
>  struct ufs_hba_variant_ops {
>  	const char *name;
> @@ -283,6 +284,7 @@ struct ufs_hba_variant_ops {
>  	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);

[snip]...

>  /*
>   * PHY Adpater attributes
>   */
> @@ -110,6 +144,11 @@
>  #define PA_STALLNOCONFIGTIME	0x15A3
>  #define PA_SAVECONFIGTIME	0x15A4
>  
> +/*Other attributes*/
> +#define VS_MPHYCFGUPDT		0xD085
> +#define VS_DEBUGOMC		0xD09E
> +#define VS_POWERSTATE		0xD083
> +
>  /* PA power modes */
>  enum {
>  	FAST_MODE	= 1,
> --
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I am planning to start working today in the v12 of the patch-set. Did you have
opportunity to check the other patches (4, 5 and 6)?

Thanks,
Joao
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
