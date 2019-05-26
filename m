From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] drivers/scsi: fix warning PTR_ERR_OR_ZERO can be used
Date: Sun, 26 May 2019 08:37:16 -0700
Message-ID: <2f7f51f7-e2a1-6667-3fed-642157437ea2@acm.org>
References: <20190525094205.GA21778@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190525094205.GA21778@hari-Inspiron-1545>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Wei Li <liwei213@huawei.com>, Geng Jianfeng <gengjianfeng@hisilicon.com>, Zang Leigang <zangleigang@hisilicon.com>, Stanley Chu <stanley.chu@mediatek.com>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Kangjie Lu <kjlu@umn.edu>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/25/19 2:42 AM, Hariprasad Kelam wrote:
> fix below warnig reported by coccicheck
> 
> /drivers/scsi/ufs/ufs-hisi.c:459:1-3: WARNING: PTR_ERR_OR_ZERO can be
> used
> ./drivers/scsi/qla2xxx/tcm_qla2xxx.c:1477:1-3: WARNING: PTR_ERR_OR_ZERO
> can be used
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 +---
>  drivers/scsi/ufs/ufs-hisi.c        | 4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index ec9f199..4357b34 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1474,10 +1474,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>  				       sizeof(struct qla_tgt_cmd),
>  				       TARGET_PROT_ALL, port_name,
>  				       qlat_sess, tcm_qla2xxx_session_cb);
> -	if (IS_ERR(se_sess))
> -		return PTR_ERR(se_sess);
>  
> -	return 0;
> +	return PTR_ERR_OR_ZERO(se_sess);
>  }
>  
>  static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
> diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
> index 7aed0a1..f506044 100644
> --- a/drivers/scsi/ufs/ufs-hisi.c
> +++ b/drivers/scsi/ufs/ufs-hisi.c
> @@ -456,10 +456,8 @@ static int ufs_hisi_get_resource(struct ufs_hisi_host *host)
>  	/* get resource of ufs sys ctrl */
>  	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>  	host->ufs_sys_ctrl = devm_ioremap_resource(dev, mem_res);
> -	if (IS_ERR(host->ufs_sys_ctrl))
> -		return PTR_ERR(host->ufs_sys_ctrl);
>  
> -	return 0;
> +	return PTR_ERR_OR_ZERO(host->ufs_sys_ctrl);
>  }

Although I'm not sure this patch improves readability of the source code:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
