From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH 1/1] scsi/ufshcd: Fix NULL pointer dereference for in ufshcd_init
Date: Tue, 28 Aug 2018 12:41:38 -0700
Message-ID: <CAE=gft5ONyVQ6qkP41G_vx-Djo0MqHhXZ6pjTOZjTDpPgwukZQ@mail.gmail.com>
References: <20180807174739.23379-1-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807174739.23379-1-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vivek.gautam@codeaurora.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, subhashj@codeaurora.org, mka@chromium.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 7, 2018 at 10:48 AM Vivek Gautam
<vivek.gautam@codeaurora.org> wrote:
>
> Error paths in ufshcd_init() ufshcd_hba_exit() killed clk_scaling
> workqueue when the workqueue is actually created quite late in
> ufshcd_init().
> So, we end up getting NULL pointer dereference in such error paths.
> Fix this by moving clk_scaling initialization and kill codes to
> two separate methods, and call them at required places.
>
> Fixes: 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during clock
> gating")
>
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>
> Bjorn, Subhash,
> I am not certain of some of these devfreq, and clk_scaling bits
> that are moved as part of this patch. Please help in reviewing the
> change in the light of these features, and related sequence should
> be followed.
> Thanks.
>

You're right, there is a lot of logic moving around here. I think this
looks okay to me.

Reviewed-by: Evan Green <evgreen@chromium.org>
