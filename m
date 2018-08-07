From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH] scsi: ufs: Check workqueue exists before destroying it
Date: Tue, 7 Aug 2018 10:09:39 -0700
Message-ID: <CAE=gft5JaQZEvujP68mhe9ANzLThBLRtr+mCrNWFRxkSDZYLmA@mail.gmail.com>
References: <20180802001435.116963-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802001435.116963-1-mka@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mka@chromium.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>, sboyd@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 1, 2018 at 5:14 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> In ufshcd_hba_exit() the clock gating workqueue is always destroyed
> when clock gating is supported. However the workqueue pointer is NULL
> when ufshcd_init() fails before the workqueue is created. Only destroy
> the workqueue if it exists.
>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 397081d320b1..401f7dbe2981 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7190,7 +7190,8 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>                 if (ufshcd_is_clkscaling_supported(hba)) {
>                         if (hba->devfreq)
>                                 ufshcd_suspend_clkscaling(hba);
> -                       destroy_workqueue(hba->clk_scaling.workq);
> +                       if (hba->clk_scaling.workq)
> +                               destroy_workqueue(hba->clk_scaling.workq);
>                         ufshcd_devfreq_remove(hba);
>                 }
>                 ufshcd_setup_clocks(hba, false);
> --
> 2.18.0.597.ga71716f1ad-goog
>

Reviewed-by: Evan Green <evgreen@chromium.org>
