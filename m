From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: fix scsi_error_handler vs. scsi_host_dev_release
 race
Date: Fri, 28 Aug 2015 07:56:13 -0700
Message-ID: <1440773773.2202.9.camel@HansenPartnership.com>
References: <1440699420-30499-1-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440699420-30499-1-git-send-email-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mhocko@kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 20:16 +0200, mhocko@kernel.org wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> b9d5c6b7ef57 ("[SCSI] cleanup setting task state in

Heh, it's tempting to revert that.  The reason is we always need to be
interruptible state before we check the flag to avoid missing wakeups.

> scsi_error_handler()") has introduced a race between scsi_error_handler
> and scsi_host_dev_release resulting in the hang when the device goes
> away because scsi_error_handler might miss a wake up:
> 
> CPU0					CPU1
> scsi_error_handler			scsi_host_dev_release
>   					  kthread_stop()
>   kthread_should_stop()
>     test_bit(KTHREAD_SHOULD_STOP)
> 					    set_bit(KTHREAD_SHOULD_STOP)
> 					    wake_up_process()
> 					    wait_for_completion()
> 
>   set_current_state(TASK_INTERRUPTIBLE)
>   schedule()
> 
> The most straightforward solution seems to be to invert the ordering of
> the set_current_state and kthread_should_stop.
> 
> The issue has been noticed during reboot test on a 3.0 based kernel but
> the current code seems to be affected in the same way.
> 
> Cc: stable # 3.6+
> Reported-and-Debugged-by: Mike Mayer <Mike.Meyer@teradata.com>
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---
>  drivers/scsi/scsi_error.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 6457a8a0db9c..2c0a817d5dbe 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2169,8 +2169,11 @@ int scsi_error_handler(void *data)
>  	 * We never actually get interrupted because kthread_run
>  	 * disables signal delivery for the created thread.
>  	 */
> -	while (!kthread_should_stop()) {
> +	while (true) {

Comment here, I think, please to avoid any other erroneous tidying
attempts.  How about

/* 
 * The sequence in kthread_stop() sets the stop flag first then 
 * wakes the process.  To avoid missed wakeups, the task should always
 * be in a non running state before the stop flag is checked
 */

Otherwise this looks fine.

James

>  		set_current_state(TASK_INTERRUPTIBLE);
> +		if (kthread_should_stop())
> +			break;
> +
>  		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
>  		    shost->host_failed != atomic_read(&shost->host_busy)) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
