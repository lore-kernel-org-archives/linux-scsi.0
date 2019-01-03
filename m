From: Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v2 1/1] scsi: Synchronize request queue PM status only
 on successful resume
Date: Thu, 3 Jan 2019 17:06:21 +0800
Message-ID: <1546506381.20657.15.camel@mtkswgap22>
References: <1546498395-4184-1-git-send-email-stanley.chu@mediatek.com>
         <1546498395-4184-3-git-send-email-stanley.chu@mediatek.com>
         <20190103082333.GL2469@lahna.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190103082333.GL2469@lahna.fi.intel.com>
Sender: stable-owner@vger.kernel.org
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, wsd_upstream@mediatek.com, kuohong.wang@mediatek.com, stable@vger.kernel.org, linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com, peter.wang@mediatek.com
List-Id: linux-scsi@vger.kernel.org

Hi Mika,

On Thu, 2019-01-03 at 10:23 +0200, Mika Westerberg wrote:
> Hi,
> 
> On Thu, Jan 03, 2019 at 02:53:15PM +0800, stanley.chu@mediatek.com wrote:
> > From: Stanley Chu <stanley.chu@mediatek.com>
> > 
> > The commit 356fd2663cff ("scsi: Set request queue runtime PM status
> > back to active on resume") fixed up the inconsistent RPM status between
> > request queue and device. However changing request queue RPM status
> > shall be done only on successful resume, otherwise status may be still
> > inconsistent as below,
> > 
> > Request queue: RPM_ACTIVE
> > Device: RPM_SUSPENDED
> > 
> > This ends up soft lockup because requests can be submitted to
> > underlying devices but those devices and their required resource
> > are not resumed.
> 
> It would be good to add some example of the soft lockup you are seeing
> here.

Thanks for remind, I will add below example in commit message in v3.

For example,

After above inconsistent status happens, IO request can be submitted
to UFS device driver but required resource (like clock) is not resumed
yet thus lead to warning as below call stack,

WARN_ON(hba->clk_gating.state != CLKS_ON);
ufshcd_queuecommand
scsi_dispatch_cmd
scsi_request_fn
__blk_run_queue
cfq_insert_request
__elv_add_request
blk_flush_plug_list
blk_finish_plug
jbd2_journal_commit_transaction
kjournald2

We may see all behind IO requests hang because of no response from
storage host or device and then soft lockup happens in system. In the
end, system may crash in many ways.

> 
> > Fixes: 356fd2663cff ("scsi: Set request queue runtime PM status
> > back to active on resume")
> 
> You don't need to wrap this.

OK! Will fix it.

> 
> The change itself looks fine.

Thanks.

Stanley

> 
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
