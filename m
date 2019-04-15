From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH 1/1] scsi: ufs: Print real incorrect request response code
Date: Mon, 15 Apr 2019 13:58:47 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B9DAF18B2@hasmsx108.ger.corp.intel.com>
References: <1555331018-32734-1-git-send-email-stanley.chu@mediatek.com>
 <5a19f590-776b-ca88-8746-c332b02c3628@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5a19f590-776b-ca88-8746-c332b02c3628@acm.org>
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
To: Bart Van Assche <bvanassche@acm.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
Cc: "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "beanhuo@micron.com" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org


> On 4/15/19 5:23 AM, Stanley Chu wrote:
> > If UFS device responds an unknown request response code, we can not
> > know what it was via logs because the code is replaced by "DID_ERROR
> > << 16" before log printing.
> >
> > Fix this to provide precise request response code information for
> > easier issue breakdown.
> >
> > Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index e040f9dd9ff3..fbe1e88eec55 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -4704,10 +4704,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
> >  				"Reject UPIU not fully implemented\n");
> >  			break;
> >  		default:
> > -			result = DID_ERROR << 16;
> >  			dev_err(hba->dev,
> >  				"Unexpected request response code = %x\n",
> >  				result);
> > +			result = DID_ERROR << 16;
> >  			break;
> >  		}
> >  		break;
> >
> 
> Should "Fixes:" and "Cc: stable" tags be added to this patch?

Doesn't  look like a regression or a critical issue. 

The patch looks good to me.

Thanks
Tomas
