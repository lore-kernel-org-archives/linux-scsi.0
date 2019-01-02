From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v1 1/1] scsi: Synchronize request queue PM status only
 on successful resume
Date: Wed, 02 Jan 2019 08:15:45 -0800
Message-ID: <1546445745.163063.4.camel@acm.org>
References: <1546410308-13486-1-git-send-email-stanley.chu@mediatek.com>
 <1546410308-13486-3-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1546410308-13486-3-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: srv_wsdupstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-01-02 at 14:25 +0800, stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org wrote:
> From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> 
> The commit 356fd2663cff ("scsi: Set request queue runtime PM status
> back to active on resume") fixed up the inconsistent RPM status between
> request queue and device. However changing request queue RPM status
> shall be done only on successful resume, otherwise status may be still
> inconsistent as below,
> 
> Request queue: RPM_ACTIVE
> Device: RPM_SUSPENDED
> 
> This ends up soft lockup because requests can be submitted to
> underlying devices but those devices and their required resource
> are not resumed.
> 
> Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

Please add "Fixes:" and "Cc: stable" tags and also Cc the author of commit
356fd2663cff.


> ---
>  drivers/scsi/scsi_pm.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index a2b4179..eff3e59 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -82,6 +82,20 @@ static int scsi_dev_type_resume(struct device *dev,
>  		pm_runtime_disable(dev);
>  		pm_runtime_set_active(dev);
>  		pm_runtime_enable(dev);
> +
> +		/*
> +		 * Forcibly set runtime PM status of request queue to "active"
> +		 * to make sure we can again get requests from the queue
> +		 * (see also blk_pm_peek_request()).
> +		 *
> +		 * The resume hook will correct runtime PM status of the disk.
> +		 */
> +		if (!err && scsi_is_sdev_device(dev)) {
> +			struct scsi_device *sdev = to_scsi_device(dev);
> +
> +			if (sdev->request_queue->dev)
> +				blk_set_runtime_active(sdev->request_queue);
> +		}

What makes you think that the sdev->request_queue->dev test is necessary? The
scsi_dev_type_resume() function is only called after blk_pm_runtime_init() has
finished so I don't think that test is necessary.

Additionally, since the above code occurs inside a block controlled by an
"if (err == 0)" statement, I think the !err test is redundant and should be
left out.

Thanks,

Bart.
