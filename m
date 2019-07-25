From: Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 0/3] scsi: ufs: fix broken hba->outstanding_tasks
Date: Thu, 25 Jul 2019 16:52:17 +0800
Message-ID: <1564044737.7235.9.camel@mtkswgap22>
References: <1563947418-16394-1-git-send-email-stanley.chu@mediatek.com>
 <MN2PR04MB69914824302B84E144137869FCC10@MN2PR04MB6991.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <MN2PR04MB69914824302B84E144137869FCC10@MN2PR04MB6991.namprd04.prod.outlook.com>
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

On Thu, 2019-07-25 at 07:54 +0000, Avri Altman wrote:
> Stanly,
> 
> > 
> > Currently bits in hba->outstanding_tasks are cleared only after their
> > corresponding task management commands are successfully done by
> > __ufshcd_issue_tm_cmd().
> > 
> > If timeout happens in a task management command, its corresponding
> > bit in hba->outstanding_tasks will not be cleared until next task
> > management command with the same tag used successfully finishes.
> I'm sorry - I still don't understand why you just can't release the tag either way,
> Just like we do in device management queries tags,
> Instead of adding all this unnecessary code.
> 
> I will not object to your series -
> just step down and let other people review you patches.


Sorry to not describe the failed scenario clearly.

Simpliy focus on outstanding bits cleanup in failed (timeout) case:
- For device command, if timeout happens, its tag can be cleared in
ufshcd_wait_for_dev_cmd() which specifically uses
ufshcd_outstanding_req_clear() to clear failed bit in outstanding_reqs
mask.
- For task management command, if timeout happens, current driver will
not clear failed bit in outstanding_tasks mask:
	- __ufshcd_issue_tm_cmd() will not clear it,
	- ufshcd_tmc_handler() will not clear it either during reset flow.

> Thanks,
> Avri

Thanks,
Stanley

> 
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
