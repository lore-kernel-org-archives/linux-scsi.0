From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v1 14/15] scsi: ufs: commit descriptors before setting the doorbell
Date: Sun, 23 Aug 2015 16:10:56 -0500
Message-ID: <CAL_JsqJELy5jKpkN6GRJqAEVK-rvRxttUg4aLQhFjjkhPxxo8g@mail.gmail.com>
References: <1440194989-28835-1-git-send-email-ygardi@codeaurora.org> <1440194989-28835-15-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1440194989-28835-15-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, linux-scsi-owner@vger.kernel.org, Jej B <James.Bottomley@hansenpartnership.com>, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, hch@infradead.org, Paul Bolle <pebolle@tiscali.nl>, "James E.J. Bottomley" <JBottomley@odin.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Aug 21, 2015 3:10 PM, "Yaniv Gardi" <ygardi@codeaurora.org> wrote:
>
> Add a write memory barrier to make sure descriptors prepared are actually
> written to memory before ringing the doorbell. We have also added the
> write memory barrier after ringing the doorbell register so that
> controller sees the new request immediately.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fef0660..876148b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -833,6 +833,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>         ufshcd_clk_scaling_start_busy(hba);
>         __set_bit(task_tag, &hba->outstanding_reqs);
>         ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +       /* Make sure that doorbell is committed immediately */
> +       wmb();

Is this really necessary? Is there a measurable difference?

>  }
>
>  /**
> @@ -1418,6 +1420,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>                 goto out;
>         }
>
> +       /* Make sure descriptors are ready before ringing the doorbell */
> +       wmb();

The writel for the doorbell will do a barrier first. (I didn't check
what exactly ufshcd_writel does, but that is why I don't like these
private access wrappers.)

>         /* issue command to the controller */
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         ufshcd_send_command(hba, tag);
> @@ -1627,6 +1631,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>
>         hba->dev_cmd.complete = &wait;
>
> +       /* Make sure descriptors are ready before ringing the doorbell */
> +       wmb();
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         ufshcd_send_command(hba, tag);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
