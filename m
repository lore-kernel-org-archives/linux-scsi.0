From: Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 4/4] scsi: ufs: Add history of fatal events
Date: Wed, 10 Jul 2019 17:28:56 +0800
Message-ID: <1562750936.7235.3.camel@mtkswgap22>
References: <1562736017-29461-1-git-send-email-stanley.chu@mediatek.com>
 <1562736017-29461-5-git-send-email-stanley.chu@mediatek.com>
 <SN6PR04MB4925D29D16757A57B25DE369FCF00@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <SN6PR04MB4925D29D16757A57B25DE369FCF00@SN6PR04MB4925.namprd04.prod.outlook.com>
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
Cc: "sthumma@codeaurora.org" <sthumma@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "ygardi@codeaurora.org" <ygardi@codeaurora.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel>
List-Id: linux-scsi@vger.kernel.org

Hi Avri,

On Wed, 2019-07-10 at 08:04 +0000, Avri Altman wrote:
> Hi Stanley,
> 
> > +					       (u32)ret);
> >  			goto out;
> > +		}
> >  	} while (ret && retries--);
> > 
> >  	if (ret)
> Here also link startup fails...

Thanks! Will track this place as well in next version.

> >   * ufshcd_update_uic_error - check and set fatal UIC error flags.
> >   * @hba: per-adapter instance
> > @@ -6043,6 +6056,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
> >  	 */
> >  	scsi_print_command(hba->lrb[tag].cmd);
> >  	if (!hba->req_abort_count) {
> > +		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort_err,
> > 0);
> Here you are collecting abort events statistics, not abort errors.
> If this is what you meant, then it's not task_abort_err, but task_abort.
> And if indeed you are tracking task aborts, maybe add lun resets as well?

Good suggestion! I would add history of lun reset and host reset as well
in next version.

> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index c6ec5c749ceb..f9f109da7f18 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -438,6 +438,10 @@ struct ufs_err_reg_hist {
> >   * @dme_err: tracks dme errors
> >   * @fatal_err: tracks fatal errors
> >   * @auto_hibern8_err: tracks auto-hibernate errors
> > + * @tsk_abort_err: tracks task abort events
> > + * @linkup_err: tracks link-startup fail events
> > + * @suspend_err: tracks suspend fail events
> > + * @resume_err: tracks resume fail events
> >   */
> >  struct ufs_stats {
> >  	u32 hibern8_exit_cnt;
> > @@ -453,6 +457,12 @@ struct ufs_stats {
> >  	/* fatal errors */
> >  	struct ufs_err_reg_hist fatal_err;
> >  	struct ufs_err_reg_hist auto_hibern8_err;
> > +
> > +	/* fatal events */
> Maybe move here fatal_err as well?

OK! these could be classified as fatal errors as well.
Will fix them in next version.

> 
> > +	struct ufs_err_reg_hist task_abort_err;
> > +	struct ufs_err_reg_hist link_startup_err;
> > +	struct ufs_err_reg_hist suspend_err;
> > +	struct ufs_err_reg_hist resume_err;
> >  };
> > 
> >  /**
> > --
> > 2.18.0
> 
> 
> Thanks,
> Avri
> 

Thanks,
Stanley
