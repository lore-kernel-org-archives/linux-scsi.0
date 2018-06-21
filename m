From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Thu, 21 Jun 2018 16:22:22 +0800
Message-ID: <a68ad043-26a1-d3d8-2009-504ba4230e0f@oracle.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180620181601.GA24145@localhost.localdomain>
 <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
 <20180621081900.GA5183@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621081900.GA5183@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>, axboe@kernel.dk, martin.petersen@oracle.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Christoph

Thanks for your kindly response.

On 06/21/2018 04:19 PM, Christoph Hellwig wrote:
> On Thu, Jun 21, 2018 at 09:43:26AM +0800, jianchao.wang wrote:
>> So we have to preserve the ability of block layer that it could prevent
>> IO completion path from entering a timeout request.
>>
>> With scsi-debug module, I tried to simulate a scenario where timeout and IO
>> completion path could occur concurrently, the system ran into crash easily.
> 
> Trace, please.  With the latest kernel.  I'm not saying that there
> is nothing to fix, but the mode of never completing once timeout
> requests as currently done is SCSI is clearly broken.
> 

I didn't find the existing method to simulate this.
So I modified the scsi-debug as following patch as install it as following:
modprobe scsi-debug delay=-1 ndelay=-1
Both 4.17-rc1 and 4.18-rc1 with this patch set could survive from the test.

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 24d7496..f278e6c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4323,6 +4323,8 @@ static void setup_inject(struct sdebug_queue *sqp,
        sqcp->inj_host_busy = !!(SDEBUG_OPT_HOST_BUSY & sdebug_opts);
 }
 
+static atomic_t g_abort_counter;
+
 /* Complete the processing of the thread that queued a SCSI command to this
  * driver. It either completes the command by calling cmnd_done() or
  * schedules a hr timer or work queue then returns 0. Returns
@@ -4459,6 +4461,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
                        sd_dp->issuing_cpu = raw_smp_processor_id();
                sd_dp->defer_t = SDEB_DEFER_WQ;
                schedule_work(&sd_dp->ew.work);
+               atomic_inc(&g_abort_counter);
+               if (atomic_read(&g_abort_counter)%2000 == 0) {
+                       blk_abort_request(cmnd->request);
+                       trace_printk("abort request tag %d\n", cmnd->request->tag);
+               }
        }
        if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
                     (scsi_result == device_qfull_result)))
@@ -5844,6 +5851,7 @@ static int sdebug_driver_probe(struct device *dev)
        struct Scsi_Host *hpnt;
        int hprot;
 
+       atomic_set(&g_abort_counter, 0);
        sdbg_host = to_sdebug_host(dev);
 
        sdebug_driver_template.can_queue = sdebug_max_queue;
