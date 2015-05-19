From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 10/10] scsi: ufs-qcom: enable UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION
Date: Tue, 19 May 2015 23:41:33 +0900
Message-ID: <CAC5umyji=HHpTD_sG=k8Z5s05pDviX6m4CYOWYDJqcmX8F9c4A@mail.gmail.com>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
	<1431878106-30579-11-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-11-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, dovl@codeaurora.org, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, chuanxiao.dong@intel.com
List-Id: linux-scsi@vger.kernel.org

2015-05-18 0:55 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> Newer revisions of QUALCOMM Technologies UFS host controller may not
> advertise the correct version information in UFS HCI VER register.
> To handle this, enable UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION to let
> UFS standard host controller driver call into vendor specific
> operation to get right UFS HCI VER register value.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index de9cfb0..4cdffa4 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -694,6 +694,16 @@ out:
>         return ret;
>  }
>
> +static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba *hba)
> +{
> +       struct ufs_qcom_host *host = hba->priv;
> +
> +       if (host->hw_ver.major == 0x1)
> +               return UFSHCI_VERSION_11;
> +       else
> +               return UFSHCI_VERSION_20;

Btw, UFS driver currently lacks UFSHCI 2.0 support.  Shouldn't we also
need a change like the patch submitted by Chuanxiao Dong:

http://marc.info/?l=linux-scsi&m=140688020815020&w=2
