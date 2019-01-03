From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v1 1/1] scsi: Synchronize request queue PM status only
 on successful resume
Date: Thu, 03 Jan 2019 15:15:43 -0800
Message-ID: <1546557343.163063.21.camel@acm.org>
References: <1546410308-13486-1-git-send-email-stanley.chu@mediatek.com>
 <1546410308-13486-3-git-send-email-stanley.chu@mediatek.com>
 <1546445745.163063.4.camel@acm.org> <1546497527.20657.12.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1546497527.20657.12.camel@mtkswgap22>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wsdupstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-01-03 at 14:38 +0800, Stanley Chu wrote:
> We found NULL sdev->request_queue->dev may be dereferenced during below
> system resume flow,
> 
> scsi_bus_resume_common()
>  => async_schedule_domain(async_sdev_resume)
> 
> And then async_sdev_resume() is invoked asynchronously,
>  
> async_sdev_resume()
>  => scsi_dev_type_resume(dev, do_scsi_resume)
>   => blk_set_runtime_active(sdev->request_queue)
> 
> If a SCSI device does not have upper layer driver (like SCSI disk), it
> may not be applied blk_pm_runtime_init() invoked by sd_probe() while
> this SCSI device is added.
> 
> For example, some SCSI devices (like UFS Boot W-LUN) are added
> explicitly in __scsi_add_device() by ufshcd_scsi_add_wlus() first and
> thus sd_probe() for them is skipped because they are already visible.
> 
> For those SCSI devices, null sdev->request_queue->dev will be
> dereferenced in blk_set_runtime_active() during above system resume
> flow, therefore we add a null pointer checking for this case.
> 
> The same issue also happens on those SCSI devices before this patch as
> below system resume flow while devices are already runtime-suspended.
> 
> scsi_bus_resume_common()
>  => blk_set_runtime_active(to_scsi_device(dev)->request_queue)

Hi Stanley,

Thanks, this is helpful information. If you would have to repost your
patch please add a comment that refers to the __scsi_add_device() calls
in the UFS driver.

Bart.
