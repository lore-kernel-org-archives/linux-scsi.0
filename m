From: Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH v3 2/3] scsi: ufs: Add error-handling of Auto-Hibernate
Date: Mon, 20 May 2019 22:05:29 +0800
Message-ID: <1558361129.660.8.camel@mtkswgap22>
References: <1558341138-18043-1-git-send-email-stanley.chu@mediatek.com>
 <1558341138-18043-3-git-send-email-stanley.chu@mediatek.com>
 <SN6PR04MB4925DE7B66A63ED81EDD9444FC060@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <SN6PR04MB4925DE7B66A63ED81EDD9444FC060@SN6PR04MB4925.namprd04.prod.outlook.com>
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
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "beanhuo@micron.com" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org

Hi Avri,

On Mon, 2019-05-20 at 09:51 +0000, Avri Altman wrote:
> Aside from some nits - see below, looks fine.
> 
> Thanks,
> Avri
> 
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index ecfa898b9ccc..994d73d03207 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -740,6 +740,11 @@ return true;
> >  #endif
> >  }
> > 
> > +static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
> > +{
> > +	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT);
> > +}
> Maybe use it elsewhere in the driver, preferable in a preparatory patch,
> Instead of patch #3.
> 

OK. I will modify original patch #3 to a preparation patch which just
re-factors ufshcd_is_auto_hibern8_supported(), and change its order to
#2.
> 
> 
> > diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> > index 6fa889de5ee5..4bcb205f2077 100644
> > --- a/drivers/scsi/ufs/ufshci.h
> > +++ b/drivers/scsi/ufs/ufshci.h
> > @@ -148,6 +148,9 @@ enum {
> >  				UIC_HIBERNATE_EXIT |\
> >  				UIC_POWER_MODE)
> > 
> > +#define UFSHCD_UIC_AH8_ERROR_MASK	(UIC_HIBERNATE_ENTER |\
> > +					UIC_HIBERNATE_EXIT)
> So maybe update UFSHCD_UIC_PWR_MASK above

OK.
WIll make these definitions more elegant.

> 
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek

Thanks,
Stanley
