From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: Use re-factored Auto-Hibernate function
Date: Mon, 20 May 2019 11:11:18 +0530
Message-ID: <434c1d39-943d-a05b-5366-dddf3064f180@samsung.com>
References: <1557912988-26758-1-git-send-email-stanley.chu@mediatek.com>
 <CGME20190515093949epcas1p12036c690c89a9396545f4776dcf42e69@epcas1p1.samsung.com>
 <1557912988-26758-4-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1557912988-26758-4-git-send-email-stanley.chu@mediatek.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com
Cc: marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org



On 5/15/19 3:06 PM, Stanley Chu wrote:
> Use re-factored ufshcd_is_auto_hibern8_supported() function
> in ufshcd_init() instead to make code more cleaner.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e6a86223a0d4..17af157c2cc1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8340,7 +8340,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   						UIC_LINK_HIBERN8_STATE);
>   
>   	/* Set the default auto-hiberate idle timer value to 150 ms */
> -	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT & !hba->ahit) {
> +	if (ufshcd_is_auto_hibern8_supported(hba) & !hba->ahit) {
After fixing the typo in above line (as pointed by Avri in patch 1), 
feel free to add
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
>   		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, 150) |
>   			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
>   	}
> 
