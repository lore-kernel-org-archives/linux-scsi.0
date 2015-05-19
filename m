From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 03/10] scsi: ufs: provide a quirk to disable the LCC
Date: Tue, 19 May 2015 23:26:58 +0900
Message-ID: <CAC5umyhByqXLUNfivzduKcYOzDV3Jquy4qZetpj5-cHnW+aWVQ@mail.gmail.com>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
	<1431878106-30579-4-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-4-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, dovl@codeaurora.org, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-05-18 0:54 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> LCC (Line Control Command) are being used for communication between
> UFS host and UFS device.
> New commercial UFS devices don't have the issues with LCC processing
> but UFS host controller might still have the issue with LCC processing,
> hence, added a routine to disable TX LCC on the device.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |  8 ++++++++
>  drivers/scsi/ufs/ufshci.h |  3 +++
>  3 files changed, 53 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9641bcb..3e57cca 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2640,6 +2640,42 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
>         return 0;
>  }
>
> +static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
> +{
> +       int tx_lanes, i, err = 0;
> +
> +       if (!peer)
> +               ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
> +                              &tx_lanes);
> +       else
> +               ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
> +                                   &tx_lanes);
> +       for (i = 0; i < tx_lanes; i++) {
> +               if (!peer)
> +                       err = ufshcd_dme_set(hba,
> +                               UIC_ARG_MIB_SEL(TX_LCC_ENABLE,
> +                                       UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +                                       0);
> +               else
> +                       err = ufshcd_dme_peer_set(hba,
> +                               UIC_ARG_MIB_SEL(TX_LCC_ENABLE,
> +                                       UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +                                       0);

You can reduce duplication by:

        err = ufshcd_dme_set_attr(hba, UIC_ARG_MIB_SEL(TX_LCC_ENABLE,
                                        UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
                                ATTR_SET_NOR, 0, peer ? DME_PEER : DME_LOCAL);

> +               if (err) {
> +                       dev_err(hba->dev, "%s: TX LCC Disable failed, peer = %d, lane = %d, err = %d",
> +                               __func__, peer, i, err);

'\n' is missing in format string.
