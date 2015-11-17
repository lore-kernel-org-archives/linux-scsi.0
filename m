From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v5 06/11] scsi: ufs: add quirk to enable host controller without hce
Date: Tue, 17 Nov 2015 09:43:26 +0100
Message-ID: <3990904.siZhCs2Bgb@wuerfel>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com> <1447046787-480-7-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447046787-480-7-git-send-email-alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gautam.vivek-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Monday 09 November 2015 10:56:22 Alim Akhtar wrote:
> +static int ufshcd_hba_enable(struct ufs_hba *hba)
> +{
> +       int ret;
> +
> +       if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
> +               ufshcd_set_link_off(hba);
> +               ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
> +
> +               /* enable UIC related interrupts */
> +               ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
> +               ret = ufshcd_dme_reset(hba);
> +               if (!ret) {
> +                       ret = ufshcd_dme_enable(hba);
> +                       if (!ret)
> +                               ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
> +                       if (ret)
> +                               dev_err(hba->dev,
> +                                       "Host controller enable failed with non-hce\n");
> +               }
> +       } else {
> +               ret = ufshcd_hba_execute_hce(hba);
> +       }
> +
> +       return ret;

quirks are often not the best way to deal with host controller specific
differences. How about using a function pointer for ufshcd_hba_enable()
that can be one or the oither implementation?

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
