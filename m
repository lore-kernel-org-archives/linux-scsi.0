From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] SCSI: Fix NULL pointer dereference in runtime PM
Date: Thu, 3 Dec 2015 11:39:25 -0700
Message-ID: <56608C5D.9080709@kernel.dk>
References: <1448952346.3603.18.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448952346.3603.18.camel@kxue-X58A-UD3R>
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Xue <ken.xue@amd.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Xiangliang.Yu@amd.com, stern@rowland.harvard.edu, JBottomley@Odin.com, SPG_Linux_Kernel@amd.com, michael.terry@canonical.com
List-Id: linux-scsi@vger.kernel.org

On 11/30/2015 11:45 PM, Ken Xue wrote:
> The routines in scsi_pm.c assume that if a runtime-PM callback is
> invoked for a SCSI device, it can only mean that the device's driver
> has asked the block layer to handle the runtime power management (by
> calling blk_pm_runtime_init(), which among other things sets q->dev).
>
> However, this assumption turns out to be wrong for things like the ses
> driver.  Normally ses devices are not allowed to do runtime PM, but
> userspace can override this setting.  If this happens, the kernel gets
> a NULL pointer dereference when blk_post_runtime_resume() tries to use
> the uninitialized q->dev pointer.
>
> This patch fixes the problem by checking q->dev in block layer before
> handle runtime PM. Since ses doesn't define any PM callbacks and call
> blk_pm_runtime_init(), the crash won't occur.
>
> This fixes Bugzilla #101371.
> https://bugzilla.kernel.org/show_bug.cgi?id=101371
>
> More discussion can be found from below link.
> http://marc.info/?l=linux-scsi&m=144163730531875&w=2
>

Added for 4.4, thanks.

-- 
Jens Axboe
