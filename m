From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Bypass block layer and Fill SCSI lower layer driver queue
Date: Wed, 18 Sep 2013 01:41:55 -0500
Message-ID: <CAB-428mCM-4c1hWaEJicB8Uz_4DCo7MsH-ZcXHrDkN=Wc5AhVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jerry Fredin <jerry.fredin@netapp.com>
List-Id: linux-scsi@vger.kernel.org

Hi

I am working on a high throughput and low latency application which
does not tolerate block layer overhead to send IO request directly to
fiber channel lower layer SCSI driver. I used to work with libaio but
currently I am looking for a way to by pass the block layer and send
SCSI commands from the application layer directly to the SCSI driver
using /dev/sgX device and ioctl() system call.

I have noticed that sending IO request through sg device even with
nonblocking and direct IO flags is quite slow and does not fill up
lower layer SCSI driver TCQ queue. i.e IO depth or
/sys/block/sdX/in_flight is always ZERO. Therefore the application
throughput is even lower that sending IO request through block layer
with libaio and io_submit() system call. In both cases I used only one
IO context (or fd) and single threaded.

I have noticed that some well known benchmarking tools like fio does
not support IO depth for sg devices as well. Therefore, I was
wondering if it is feasible to bypass block layer and achieve higher
throughput and lower latency (for sending IO request only).


Any comment on my issue is highly appreciated.


Thanks
Alireza
