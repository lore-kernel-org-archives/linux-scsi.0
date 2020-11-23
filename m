Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB49C56201
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDFD32137B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgKWDCE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Nov 2020 22:02:04 -0500
Received: from netrider.rowland.org ([192.131.102.5]:50693 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726903AbgKWDCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2020 22:02:04 -0500
Received: (qmail 695174 invoked by uid 1000); 22 Nov 2020 22:02:02 -0500
Date:   Sun, 22 Nov 2020 22:02:02 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH RFC v2 1/1] scsi: pm: Leave runtime PM status alone
 during system resume/thaw/restore
Message-ID: <20201123030202.GA694907@rowland.harvard.edu>
References: <1605861443-11459-1-git-send-email-cang@codeaurora.org>
 <20201120163524.GB619708@rowland.harvard.edu>
 <ff2975f88cc452d134b8bf24c55bec09@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2975f88cc452d134b8bf24c55bec09@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 23, 2020 at 09:23:53AM +0800, Can Guo wrote:
> Hi Alan,
> 
> On 2020-11-21 00:35, Alan Stern wrote:
> > On Fri, Nov 20, 2020 at 12:37:22AM -0800, Can Guo wrote:
> > > Runtime resume is handled by runtime PM framework, no need to forcibly
> > > set runtime PM status to RPM_ACTIVE during system resume/thaw/restore.
> > 
> > Sorry, I don't understand this explanation at all.
> > 
> > Sure, runtime resume is handled by the runtime PM framework.  But this
> > patch changes the code for system resume, which is completely different.
> > 
> > Following a system resume, the hardware will be at full power.  We don't
> > want the kernel to think that the device is still in runtime suspend;
> > otherwise is would never put the device back into low-power mode.
> 
> How about adding below lines to the patch?
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index 908f27f..7ebe582 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -75,9 +75,11 @@ static int scsi_dev_type_resume(struct device *dev,
>         const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>         int err = 0;
> 
> -       err = cb(dev, pm);
> -       scsi_device_resume(to_scsi_device(dev));
> -       dev_dbg(dev, "scsi resume: %d\n", err);
> +       if (pm_runtime_active(dev)) {
> +               err = cb(dev, pm);
> +               scsi_device_resume(to_scsi_device(dev));
> +               dev_dbg(dev, "scsi resume: %d\n", err);
> +       }
> 
>         return err;
>  }
> 
> Whenever a device is accessed, the issuer or somewhere in the path
> should do something like pm_runtime_get_sync (e.g. in sg_open()) or
> pm_runtime_resume() (e.g. in blk_queue_enter()), in either sync or
> async way. After the job (read/write/ioctl or whatever) is done,
> either a pm_runtime_put_sync() or auto runtime suspend puts the device
> back into runtime suspended/low-power mode. Since the func
> scsi_bus_suspend_common() does nothing if device is already in runtime
> suspended mode, scsi_dev_type_resume() should only resume the device
> if it is runtime active.

You're starting to think along the right lines, but you are ignoring all 
the other work that people have already done for handling these cases.

Please read Documentation/driver-api/pm/devices.rst very carefully, 
especially the parts about returning a positive value from the ->prepare 
callback (also known as "direct-complete" and related to the 
DPM_FLAG_NO_DIRECT_COMPLETE and DPM_FLAG_SMART_PREPARE flags) and the 
parts about the DPM_FLAG_SMART_SUSPEND and DPM_FLAG_MAY_SKIP_RESUME 
flags.  Then think about what you want to accomplish and write a patch 
that takes all this information into account.

Key point: At no time should any part of the kernel think that the 
device is in a low-power state when it is actually in a high-power 
state, or vice versa.

Alan Stern
