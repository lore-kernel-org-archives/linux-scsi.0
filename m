From: Avri Altman <Avri.Altman-Sjgp3cTcYWE@public.gmane.org>
Subject: RE: [PATCH v1 2/2] scsi: ufs-mediatek: Add UFS support for Mediatek
 SoC chips
Date: Fri, 22 Feb 2019 10:29:00 +0000
Message-ID: <SN6PR04MB4925CDAF80047DBCED9E2836FC7F0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1550742637-12385-1-git-send-email-stanley.chu@mediatek.com>
 <1550742637-12385-4-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1550742637-12385-4-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: "stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

> +
> +struct ufs_mtk_dev_params {
> +	u32 pwm_rx_gear;        /* pwm rx gear to work in */
> +	u32 pwm_tx_gear;        /* pwm tx gear to work in */
> +	u32 hs_rx_gear;         /* hs rx gear to work in */
> +	u32 hs_tx_gear;         /* hs tx gear to work in */
> +	u32 rx_lanes;           /* number of rx lanes */
> +	u32 tx_lanes;           /* number of tx lanes */
> +	u32 rx_pwr_pwm;         /* rx pwm working pwr */
> +	u32 tx_pwr_pwm;         /* tx pwm working pwr */
> +	u32 rx_pwr_hs;          /* rx hs working pwr */
> +	u32 tx_pwr_hs;          /* tx hs working pwr */
> +	u32 hs_rate;            /* rate A/B to work in HS */
> +	u32 desired_working_mode;
> +};
As this is essentially identical to ufs_qcom_dev_params and ufs_hisi_dev_params etc.,
Maybe move it to ufshcd-platform.h in a short preparatory patch, so it can be reused?

Also, the vast majority of the code in these platform-dependent modules is pretty much the same.
I wonder if it can be shape to fit some standard form?
But this is out of scope of your series.


> +/*
> + * PHY Adpater attributes
> + */
> +#define PA_LOCALTXLCCENABLE         0x155E
Already in unipro.h

Thanks,
Avri
