From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v7 0/2] tcmu: Dynamic growing data area support
Date: Mon, 01 May 2017 22:56:25 -0700
Message-ID: <1493704585.23202.66.camel@haakon3.risingtidesystems.com>
References: <1493696286-2988-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1493696286-2988-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-05-02 at 11:38 +0800, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> Changed for V7:
> - #1 fix two issues.
> - #2 fix kbuild warning and some issues.
> 
> Changed for V6:
> - Remove the tcmu_vma_close(). Since the unmap thread will do the same for it 
> - The unmap thread will skip the busy devices.
> - Using and testing the V5 version 3 weeks and the V6 for about 1 week, all in a higher IOPS environment:
>   * using fio and dd commands
>   * using about 4 targets based user:rbd/user:file backend
>   * set the global pool size to 512 * 1024 blocks * block_size, for 4K page size, the size is 2G.
>   * each target here needs more than 1100 blocks.
>   * fio: -iodepth 16 -thread -rw=[read write] -bs=[1M] -size=20G -numjobs=10 -runtime=1000  ...
>   * restart the tcmu-runner at any time.
> 
> Changed for V5:
> - Rebase to the newest target-pending repository.
> - Add as many comments as possbile to make the patch more readable.
> - Move tcmu_handle_completions() in timeout handler to unmap thread
>   and then replace the spin lock with mutex lock(because the unmap_*
>   or zap_* may goto sleep) to simplify the patch and the code.
> - Thanks very much for Mike's tips and suggestions.
> - Tested this for more than 3 days by:
>   * using fio and dd commands
>   * using about 1~5 targets
>   * set the global pool size to [512 1024 2048 512 * 1024] blocks * block_size
>   * each target here needs more than 450 blocks when running in my environments.
>   * fio: -iodepth [1 2 4 8 16] -thread -rw=[read write] -bs=[1K 2K 3K 5K 7K 16K 64K 1M] -size=20G -numjobs=10 -runtime=1000  ...
>   * in the tcmu-runner, try to touch blocks out of tcmu_cmds' iov[] manually
>   * restart the tcmu-runner at any time.
>   * in my environment for the low IOPS case: the read throughput goes from about 5200KB/s to 6700KB/s; the write throughput goes from about 3000KB/s to 3700KB/s.
> 
> Xiubo Li (2):
>   tcmu: Add dynamic growing data area feature support
>   tcmu: Add global data block pool support
> 
>  drivers/target/target_core_user.c | 602 ++++++++++++++++++++++++++++++--------
>  1 file changed, 473 insertions(+), 129 deletions(-)
> 

Ah, just missed the v7.  ;)

Applied.

Thanks 
