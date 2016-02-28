From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 2/3] PM / sleep: try to runtime suspend for direct complete
Date: Sun, 28 Feb 2016 02:31:11 +0100
Message-ID: <3183435.BG93qPHVgS@vostro.rjw.lan>
References: <1456359748-22838-1-git-send-email-dbasehore@chromium.org> <1456359748-22838-2-git-send-email-dbasehore@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1456359748-22838-2-git-send-email-dbasehore@chromium.org>
Sender: linux-pm-owner@vger.kernel.org
To: Derek Basehore <dbasehore@chromium.org>
Cc: linux-pm@vger.kernel.org, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday, February 24, 2016 04:22:27 PM Derek Basehore wrote:
> This tries to runtime suspend devices that are still active for direct
> complete. This is for cases such as autosuspend delays which leaves
> devices able to runtime suspend but still active. It's beneficial in
> this case to runtime suspend the device to take advantage of direct
> complete when possible.
> 
> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
> ---
>  drivers/base/power/main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index e0017d9..9693032 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -1380,7 +1380,12 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  		goto Complete;
>  
>  	if (dev->power.direct_complete) {
> -		if (pm_runtime_status_suspended(dev)) {
> +		/*
> +		 * Check if we're runtime suspended. If not, try to runtime
> +		 * suspend for autosuspend cases.
> +		 */
> +		if (pm_runtime_status_suspended(dev) ||
> +		    !pm_runtime_suspend(dev)) {
>  			pm_runtime_disable(dev);
>  			if (pm_runtime_status_suspended(dev))
>  				goto Complete;
> 

This can be done somewhat simpler, because pm_runtime_suspend() will check
if the device has already been suspended:

	ret = pm_runtime_suspend(dev);
	if (ret >= 0) {

and you don't need the extra pm_runtime_status_suspended(dev) check.

Thanks,
Rafael

