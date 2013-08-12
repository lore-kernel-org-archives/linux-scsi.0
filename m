From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V5 0/4] scsi: ufs: Improve UFS error handling
Date: Mon, 12 Aug 2013 12:59:44 -0000
Message-ID: <8795839d30f1da042421765c6842119a.squirrel@www.codeaurora.org>
References: <1375163155-1473-1-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1375163155-1473-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

I tested the new set of patches (V5 1-4) and it works.

Thanks,
Dolev

> The first patch fixes many issues with current task management handling
> in UFSHCD driver. Others improve error handling in various scenarios.
>
> These patches are rebased on:
> [PATCH 9/9] drivers/scsi/ufs: don't check resource with
> devm_ioremap_resource
>
> Changes from v4:
> 	- Addressed comments from Seungwon Jeon on V3
> 	- Updated with proper locking while ufshcd state changes
> 	- Retained LUN reset instead of device reset with DME_END_POINT_RESET
> 	- Removed error handling decisions dependent on OCS value
> 	- Simplified fatal error handling to abort the requests first
> 	  and then carry out reset.
> Changes from v3:
> 	- Rebased.
> Changes from v2:
> 	- [PATCH V3 1/4]: Make the task management command task tag unique
> 	  across SCSI/NOP/QUERY request tags.
> 	- [PATCH V3 3/4]: While handling device/host reset, wait for
> 	  pending fatal handler to return if running.
> Changes from v1:
> 	- [PATCH V2 1/4]: Fix a race condition because of overloading
> 	  outstanding_tasks variable to lock the slots. A new variable
> 	  tm_slots_in_use will track which slots are in use by the driver.
> 	- [PATCH V2 2/4]: Commit text update to clarify the hardware race
> 	  with more details.
> 	- [PATCH V2 3/4]: Minor cleanup and rebase
> 	- [PATCH V2 4/4]: Fix a bug - sleeping in atomic context
>
> Sujit Reddy Thumma (4):
>   scsi: ufs: Fix broken task management command implementation
>   scsi: ufs: Fix hardware race conditions while aborting a command
>   scsi: ufs: Fix device and host reset methods
>   scsi: ufs: Improve UFS fatal error handling
>
>  drivers/scsi/ufs/ufshcd.c |  684
> ++++++++++++++++++++++++++++++++-------------
>  drivers/scsi/ufs/ufshcd.h |   20 +-
>  2 files changed, 501 insertions(+), 203 deletions(-)
>
> --
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
