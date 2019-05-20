From: Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 1/3] scsi: ufs: Do not overwrite Auto-Hibernate timer
Date: Mon, 20 May 2019 13:50:44 +0800
Message-ID: <1558331444.660.3.camel@mtkswgap22>
References: <1557912988-26758-1-git-send-email-stanley.chu@mediatek.com>
 <CGME20190515093640epcas2p17e4c3e4545ce5e4e4b59ed7b9a954741@epcas2p1.samsung.com>
 <1557912988-26758-2-git-send-email-stanley.chu@mediatek.com>
 <15a271c6-88c8-b9d5-68a8-dc142afdf224@samsung.com>
 <SN6PR04MB4925D68D8D8EF2E16FD6525AFC060@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <SN6PR04MB4925D68D8D8EF2E16FD6525AFC060@SN6PR04MB4925.namprd04.prod.outlook.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Avri Altman <Avri.Altman@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "beanhuo@micron.com" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org

Hi Avri,

On Mon, 2019-05-20 at 05:47 +0000, Avri Altman wrote:
> > 
> > Hello Stanley,
> > 
> > On 5/15/19 3:06 PM, Stanley Chu wrote:
> > > Some vendor-specific initialization flow may set its own
> > > auto-hibernate timer. In this case, do not overwrite timer value
> > > as "default value" in ufshcd_init().
> > >
> > > Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> > > ---
> > >   drivers/scsi/ufs/ufshcd.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > index e040f9dd9ff3..1665820c22fd 100644
> > > --- a/drivers/scsi/ufs/ufshcd.c
> > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > @@ -8309,7 +8309,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> > *mmio_base, unsigned int irq)
> > >   						UIC_LINK_HIBERN8_STATE);
> > >
> > >   	/* Set the default auto-hiberate idle timer value to 150 ms */
> > > -	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) {
> > > +	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT & !hba->ahit) {
> A typo?

Yes! Thanks for remind this.
Will fix it in next version.

> 
> 
> > >   		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK,
> > 150) |
> > >   			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
> > >   	}
> > >
> > Looks good to me,
> > Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks.
Stanley
