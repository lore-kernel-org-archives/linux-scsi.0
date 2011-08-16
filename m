From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
Date: Tue, 16 Aug 2011 20:26:40 +0900
Message-ID: <4E4A53F0.9040104@ce.jp.nec.com>
References: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, roland@purestorage.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 08/12/11 00:16, Alan Stern wrote:
> On Thu, 11 Aug 2011, James Bottomley wrote:
>> However, much as I'd like to accept this rosy view, the original oops
>> that started all of this in 2.6.38 was someone caught something with a
>> reference to a SCSI queue after the device release function had been
>> called.
> 
> Not according to your commit log.  You wrote that the reference was
> taken after scsi_remove_device() had been called -- but the device
> release function is scsi_device_dev_release_usercontext().

The commit log of 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
("[SCSI] put stricter guards on queue dead checks") does not
explain about the move of scsi_free_queue().

But according to the discussion below, it seems
the move was motivated to solve the following self-deadlock:
https://lkml.org/lkml/2011/4/12/9

  [in the context of kblockd_workqueue]
  blk_delay_work
    __blk_run_queue
      scsi_request_fn
        put_device
          (puts final sdev refcount)
             scsi_device_dev_release
               execute_in_process_context(scsi_device_dev_release_usercontext)
                 [execute immediately because it's in process context]
                    scsi_device_dev_release_usercontext
                      scsi_free_queue
                        blk_cleanup_queue
                          blk_sync_queue
                            (wait for blk_delay_work to complete...)

James, is my understanding correct?

If so, isn't it possible to move the scsi_free_queue back to
the original place and solve the deadlock instead by
avoiding the wait in the same context?

@@ -338,8 +339,8 @@ static void scsi_device_dev_release_user
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
+	INIT_WORK(&sdp->ew.work, scsi_device_dev_release_usercontext);
+	schedule_work(&sdp->ew.work);
 }
 
 static struct class sdev_class = {

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
