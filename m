From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: sd: Contribute to randomness when running
 rotational device
Date: Thu, 06 Sep 2018 15:27:53 -0700
Message-ID: <1536272873.26747.11.camel@acm.org>
References: <20180906203719.209399-1-xueweiz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906203719.209399-1-xueweiz@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xuewei Zhang <xueweiz@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aditya Kali <adityakali@google.com>, tytso@mit.edu, Guenter Roeck <groeck@chromium.org>, maze@google.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-09-06 at 13:37 -0700, Xuewei Zhang wrote:
+AD4 Currently a scsi device won't contribute to kernel randomness when it
+AD4 uses blk-mq. Since we commonly use scsi on rotational device with
+AD4 blk-mq, it make sense to keep contributing to kernel randomness in these
+AD4 cases. This is especially important for virtual machines.
+AD4 
+AD4 commit b5b6e8c8d3b4 (+ACI-scsi: virtio+AF8-scsi: fix IO hang caused by automatic
+AD4 irq vector affinity+ACI) made all virtio-scsi device to use blk-mq, which
+AD4 does not contribute to randomness today. So for a virtual machine only
+AD4 having virtio-scsi disk (which is common), it will simple stop getting
+AD4 randomness from its disks in today's implementation.
+AD4 
+AD4 With this patch, if the above VM has rotational virtio-scsi device, then
+AD4 it can still benefit from the entropy generated from the disk.
+AD4 
+AD4 Reported-by: Xuewei Zhang +ADw-xueweiz+AEA-google.com+AD4
+AD4 Signed-off-by: Xuewei Zhang +ADw-xueweiz+AEA-google.com+AD4
+AD4 ---
+AD4  drivers/scsi/sd.c +AHw 3 +-+-+-
+AD4  1 file changed, 3 insertions(+-)
+AD4 
+AD4 diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
+AD4 index b79b366a94f7..5e4f10d28065 100644
+AD4 --- a/drivers/scsi/sd.c
+AD4 +-+-+- b/drivers/scsi/sd.c
+AD4 +AEAAQA -2959,6 +-2959,9 +AEAAQA static void sd+AF8-read+AF8-block+AF8-characteristics(struct
+AD4 scsi+AF8-disk +ACo-sdkp)
+AD4  	if (rot +AD0APQ 1) +AHs
+AD4  		blk+AF8-queue+AF8-flag+AF8-set(QUEUE+AF8-FLAG+AF8-NONROT, q)+ADs
+AD4  		blk+AF8-queue+AF8-flag+AF8-clear(QUEUE+AF8-FLAG+AF8-ADD+AF8-RANDOM, q)+ADs
+AD4 +-	+AH0 else +AHs
+AD4 +-		blk+AF8-queue+AF8-flag+AF8-clear(QUEUE+AF8-FLAG+AF8-NONROT, q)+ADs
+AD4 +-		blk+AF8-queue+AF8-flag+AF8-set(QUEUE+AF8-FLAG+AF8-ADD+AF8-RANDOM, q)+ADs
+AD4  	+AH0
+AD4  
+AD4  	if (sdkp-+AD4-device-+AD4-type +AD0APQ TYPE+AF8-ZBC) +AHs

Although this patch looks fine to me, seeing this patch makes me wonder
whether the default should be changed (QUEUE+AF8-FLAG+AF8-MQ+AF8-DEFAULT) instead of
modifying the sd driver. Can anyone remind me why QUEUE+AF8-FLAG+AF8-MQ+AF8-DEFAULT does
not include QUEUE+AF8-FLAG+AF8-ADD+AF8-RANDOM?

Thanks,

Bart.
