From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Mon, 06 Jan 2014 13:06:20 +0530
Message-ID: <52CA5CF4.2080708@codeaurora.org>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CA1191.8060804@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/6/2014 7:44 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> On 12/16/2013 06:30 PM, Phillip Susi wrote:
>> For some reason, the system hangs on resume if I issue the REQUEST
>> SENSE command after blk_pre_runtime_suspend.  My understanding is
>> that the REQ_PM flag should make the command process even though
>> the queue is RPM_SUSPENDING, but it doesn't seem to work.  Anyone
>> have any idea why?
>
> So I found the problem but I'm confused by it.  I thought that the
> REQ_PM flag was supposed to make sure the request was dispatched even
> though the device was still suspended ( or suspending ).  It seems
> that this is not the case, and only requests with the type set to
> REQ_TYPE_PM_RESUME are dispatched during suspend/resume.  The
> following patch fixes the hang, but I'm not sure why it is needed or
> if it is generally appropriate:
>

Adding Aaron Lu, author of block layer runtime PM.
I have seen similar issue and fixed it by relaxing the rpm_status check
to allow processing of requests while suspended -

diff --git a/block/blk-core.c b/block/blk-core.c
index 6853ef6..f99165b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2140,8 +2140,7 @@ static void blk_account_io_done(struct request *req)
  static struct request *blk_pm_peek_request(struct request_queue *q,
  					   struct request *rq)
  {
-	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
-	    (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM))))
+	if (q->dev && q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM))
  		return NULL;
  	else
  		return rq;


> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7bd7f0d..c5ce50d 100644
> - --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -227,7 +227,9 @@ int scsi_execute(struct scsi_device *sdev, const
> unsigned char *cmd,
>          req->sense_len = 0;
>          req->retries = retries;
>          req->timeout = timeout;
> - -       req->cmd_type = REQ_TYPE_BLOCK_PC;
> +       if (flags & REQ_PM)
> +               req->cmd_type = REQ_TYPE_PM_RESUME;
> +       else req->cmd_type = REQ_TYPE_BLOCK_PC;
>          req->cmd_flags |= flags | REQ_QUIET | REQ_PREEMPT;
>
>          /*
>
>

-- 
Regards,
Sujit
