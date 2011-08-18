From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Thu, 18 Aug 2011 18:11:19 +0900
Message-ID: <4E4CD737.4020402@ce.jp.nec.com>
References: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org> <4E4A53F0.9040104@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E4A53F0.9040104@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, jaxboe@fusionio.com, roland@purestorage.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

On 08/16/11 20:26, Jun'ichi Nomura wrote:
> The commit log of 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
> ("[SCSI] put stricter guards on queue dead checks") does not
> explain about the move of scsi_free_queue().
> 
> But according to the discussion below, it seems
> the move was motivated to solve the following self-deadlock:
> https://lkml.org/lkml/2011/4/12/9
> 
>   [in the context of kblockd_workqueue]
>   blk_delay_work
>     __blk_run_queue
>       scsi_request_fn
>         put_device
>           (puts final sdev refcount)
>              scsi_device_dev_release
>                execute_in_process_context(scsi_device_dev_release_usercontext)
>                  [execute immediately because it's in process context]
>                     scsi_device_dev_release_usercontext
>                       scsi_free_queue
>                         blk_cleanup_queue
>                           blk_sync_queue
>                             (wait for blk_delay_work to complete...)
> 
> James, is my understanding correct?
> 
> If so, isn't it possible to move the scsi_free_queue back to
> the original place and solve the deadlock instead by
> avoiding the wait in the same context?

Actually, Tejun has posted a patch to replace
execute_in_process_context() with queue_work()
and asking your review:

  [PATCH RESEND] scsi: don't use execute_in_process_context()
  https://lkml.org/lkml/2011/4/30/87

Do you think you can take the patch and revert the move
of scsi_free_queue()?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
