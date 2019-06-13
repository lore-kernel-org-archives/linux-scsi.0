From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v2] scsi: ufs: Avoid runtime suspend possibly being
 blocked forever
Date: Thu, 13 Jun 2019 08:09:45 +0000
Message-ID: <SN6PR04MB49255AE8236AAA9E41A046BFFCEF0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1560352745-24681-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1560352745-24681-1-git-send-email-stanley.chu@mediatek.com>
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
To: Stanley Chu <stanley.chu@mediatek.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
Cc: "sthumma@codeaurora.org" <sthumma@codeaurora.org>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "ygardi@codeaurora.org" <ygardi@codeaurora.org>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "beanhuo@micron.com" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org

> 
> UFS runtime suspend can be triggered after pm_runtime_enable()
> is invoked in ufshcd_pltfrm_init(). However if the first runtime
> suspend is triggered before binding ufs_hba structure to ufs
> device structure via platform_set_drvdata(), then UFS runtime
> suspend will be no longer triggered in the future because its
> dev->power.runtime_error was set in the first triggering and does
> not have any chance to be cleared.
> 
> To be more clear, dev->power.runtime_error is set if hba is NULL
> in ufshcd_runtime_suspend() which returns -EINVAL to rpm_callback()
> where dev->power.runtime_error is set as -EINVAL. In this case, any
> future rpm_suspend() for UFS device fails because
> rpm_check_suspend_allowed() fails due to non-zero
> dev->power.runtime_error.
> 
> To resolve this issue, make sure the first UFS runtime suspend
> get valid "hba" in ufshcd_runtime_suspend(): Enable UFS runtime PM
> only after hba is successfully bound to UFS device structure.
> 
> Fixes: 62694735ca95 ([SCSI] ufs: Add runtime PM support for UFS host
> controller driver)
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
