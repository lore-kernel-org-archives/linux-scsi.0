From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 3/3] add support for DWC UFS Host Controller
Date: Sat, 13 Feb 2016 22:27:24 +0900
Message-ID: <CAC5umyh6VGfsD+CzuimiMCum=E4UrA0rGj7pgPaRLO_aVen-gQ@mail.gmail.com>
References: <cover.1455192008.git.jpinto@synopsys.com>
	<ee97e9b0ece0d819debe403c752d233c6267e02e.1455192008.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ee97e9b0ece0d819debe403c752d233c6267e02e.1455192008.git.jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinayak holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Julian Calaby <julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:OPEN FIRMWARE AND..." <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Joao,

2016-02-11 21:13 GMT+09:00 Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>:
> +static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
> +{
> +       int ret = 0;
> +
> +       /* Local side Configuration */
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
> +       if (ret)
> +               goto out;
> +
> +
> +       /* Peer side Configuration */
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
> +       if (ret)
> +               goto out;
> +
> +out:
> +       return ret;
> +}

This looks a bit redundant.  The most part of the functions in this file is
doing ufshcd_dme_set() or ufshcd_dme_peer_set(), so should we
introduce ufshcd_dme_set_attrs() like below?  It will also increase
readability.

struct ufshcd_dme_attr_val {
        u32 attr_sel;
        u32 mib_val;
        u8 peer;
};

int ufshcd_dme_set_attrs(struct ufs_hba *hba,
                        const struct ufshcd_dme_attr_val *v, int n)
{
        for (i = 0; i < n; i++) {
                int ret = ufshcd_dme_set_attr(hba, v[i].attr_sel, ...);

                if (ret)
                        return ret;
        }
        return 0;
}

static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
{
        const struct ufshcd_dme_attr setup_attrs[] = {
                { UIC_ARG_MIB(T_CONNECTIONSTATE), 0, DME_LOCAL },
                { UIC_ARG_MIB(T_DEVICEID), 0, DME_LOCAL },
                ...
        };

        return ufshcd_dme_set_attrs(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
}

> +static int ufshcd_dwc_setup_tc(struct ufs_hba *hba)
> +{
> +       int ret = 0;
> +
> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
> +       dev_info(hba->dev, "Configuring Test Chip 40-bit RMMI");
> +       ret = ufshcd_dwc_setup_40bit_rmmi(hba);
> +       if (ret) {
> +               dev_err(hba->dev, "Configuration failed");

Please add \n in the end of message.
(and there are same issues in this file)

> +
> +/* Clock Divider Values: Hex equivalent of frequency in MHz */
> +enum clk_div_values {
> +       UFSHCD_CLK_DIV_62_5     = 0x3e,
> +       UFSHCD_CLK_DIV_125      = 0x7d,
> +       UFSHCD_CLK_DIV_200      = 0xc8,
> +};

This is used as register value for DWC_UFS_REG_HCLKDIV.  So should they
have similar prefix (DWC_UFS_REG_HCLKDIV_*)?

> diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h

...

> +/*Other attributes*/
> +#define VS_MPHYCFGUPDT         0xD085
> +#define VS_DEBUGOMC            0xD09E
> +#define VS_POWERSTATE          0xD083

Are these vendor specific attributes?  If so, please move them to
ufshci-dwc.h.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
