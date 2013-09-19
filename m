From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: Bypass block layer and Fill SCSI lower layer driver queue
Date: Wed, 18 Sep 2013 21:05:36 -0500
Message-ID: <CAB-428kveDOQ3UMryNEp6Y8H0MDObP2=g4TPRZc+9dX3HS3GXQ@mail.gmail.com>
References: <CAB-428mCM-4c1hWaEJicB8Uz_4DCo7MsH-ZcXHrDkN=Wc5AhVA@mail.gmail.com>
 <1379538044.32763.651.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1379538044.32763.651.camel@haakon3.risingtidesystems.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, Jerry Fredin <jerry.fredin@netapp.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 18, 2013 at 4:00 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Wed, 2013-09-18 at 01:41 -0500, Alireza Haghdoost wrote:
>> Hi
>>
>> I am working on a high throughput and low latency application which
>> does not tolerate block layer overhead to send IO request directly to
>> fiber channel lower layer SCSI driver. I used to work with libaio but
>> currently I am looking for a way to by pass the block layer and send
>> SCSI commands from the application layer directly to the SCSI driver
>> using /dev/sgX device and ioctl() system call.
>>
>> I have noticed that sending IO request through sg device even with
>> nonblocking and direct IO flags is quite slow and does not fill up
>> lower layer SCSI driver TCQ queue. i.e IO depth or
>> /sys/block/sdX/in_flight is always ZERO. Therefore the application
>> throughput is even lower that sending IO request through block layer
>> with libaio and io_submit() system call. In both cases I used only one
>> IO context (or fd) and single threaded.
>>
>> I have noticed that some well known benchmarking tools like fio does
>> not support IO depth for sg devices as well. Therefore, I was
>> wondering if it is feasible to bypass block layer and achieve higher
>> throughput and lower latency (for sending IO request only).
>>
>>
>> Any comment on my issue is highly appreciated.
>>
>>

Hi Nicholas,

Thanks for your reply sharing your thought with us. Please find my
comments below:

> FYI, you've got things backward as to where the real overhead is being
> introduced.

As far as I understand, you are talking about the overhead of making
SCSI request in this case moves from kernel to the application layer.
That is true. However, our application does not require to create SCSI
commands online. i.e It can prepare bunch of SCSI commands off-line
(during warm-up phase) and then send all of them to the device drives
when it goes online. Therefore, the overhead of creating SCSI commands
has been moved to app layer but excluded from critical time of
application. In the critical time of application we have to send IO
request as fast as possible to the driver and we don't want spend time
to creat SCSI commands at that time. That is the whole motivation of
NOT using libaio and raw device.

>
> The block layer / aio overhead is minimal compared to the overhead
> introduced by the existing scsi_request_fn() logic, and extreme locking
> contention between request_queue->queue_lock and scsi_host->host_lock
> that are accessed/released multiple times per struct scsi_cmnd dispatch.

That means even if we send SCSI commands directly to sg device, it
still suffer from the overhead of scsi_request_fn() ? I was thinking
it would bypass scsi_request_fn() since the scsi commands are built
inside this function. (i.e. scsi_prep_fn() called by scsi_request_fn()
). However, In my situation, SCSI commands are built in app layer and
logically there would be no reason to suffer from the overhead of
scsi_request_fn()

Ok, here is a below is a trace of function calls I collected using
ftrace while running our app sending IO request directly to raw device
(/dev/sdX) using libaio. I am gonna describe my view of overhead in
this example.

The whole io_submit() system call in this case take about 42us to
finish (please note there is some measurement error caused by dynamic
instrumentation but we can ignore that in relative comparison)
libaio consume 22us to prepare and run iocb in aio_run_iocb() which is
equal to half of the whole system call time. While scsi_request_fn()
only consume 13us to create scsi commands and submit the command in
low level drive queue. SCSI low level driver takes less than 3us in
qla2xxx_queuecommand() to queue the scsi command.

To me spending 22us in libaio is a big deal for millions of IO
request. It is more than 50% overhead. That is why I am not in favor
of  libaio. Moreover, preparing SCSI commands inside scsi_request_fn()
takes almost 10us if we exclude submission time to low-level driver.
That is like 10% overhead. That is why I am interested to do this job
offline inside the application layer. The greedy approach which I am
looking for is to  spend around 3us running low-level driver queuing
scsi command (in my case qla2xxx_queuecommand() ) and bypass
everything else.   How ever I am wondering if it is possible or not ?


  2)                        |  sys_io_submit() {
  2)                        |    do_io_submit() {
  2)                        |      aio_run_iocb() {
  2)                        |          blkdev_aio_write() {
  2)                        |            __generic_file_aio_write()
  2)                        |              generic_file_direct_write() {
  2)                        |                blkdev_direct_IO() {
  2)                        |                    submit_bio() {
  2)                        |                      generic_make_request() {
  2)                        |                        blk_queue_bio() {
  2)   0.035 us      |                          blk_queue_bounce();
  2) + 21.351 us   |          }
  2) + 21.580 us   |        }
  2) + 22.070 us   |      }
  2)                         |      blk_finish_plug() {
  2)                         |          queue_unplugged() {
  2)                         |            scsi_request_fn() {
  2)                         |              blk_peek_request(){
  2)                         |                sd_prep_fn() {
  2)                         |                  scsi_setup_fs_cmnd() {
  2)                         |                    scsi_get_cmd_from_req()
  2)                         |                    scsi_init_io()
  2)   4.735 us       |                  }
  2)   0.033 us       |                  scsi_prep_return();
  2)   5.234 us       |                }
  2)   5.969 us       |              }
  2)                         |              blk_queue_start_tag() {
  2)                         |                blk_start_request() {
  2)   0.044 us       |                  blk_dequeue_request();
  2)   1.364 us       |              }
  2)                         |              scsi_dispatch_cmd() {
  2)                         |                qla2xxx_queuecommand() {
  2)                         |                  qla24xx_dif_start_scsi()
  2)   3.235 us       |                }
  2)   3.706 us       |              }
  2) + 13.792 us   |            } // end of scsi_request_fn()
  2) + 14.021 us   |          }
  2) + 15.239 us   |        }
  2) + 15.463 us   |      }
  2) + 42.282 us   |    }
  2) + 42.519 us   |  }

>
> This locking contention and other memory allocations currently limit per
> struct scsi_device performance with small block random IOPs to ~250K vs.
> ~1M with raw block drivers providing their own make_request() function.
>
> FYI, there is an early alpha scsi-mq prototype that bypasses the
> scsi_request_fn() junk all together, that is able to reach small block
> IOPs + latency that is comparable to raw block drivers.
>
> Only a handful of LLDs have been converted to run with full scsi-mq
> pre-allocation thus far, and the code is considered early, early
> alpha.
>
> It's the only real option for SCSI to get anywhere near raw block driver
> performance + latency, but is still quite a ways off mainline.
>
> --nab
>
