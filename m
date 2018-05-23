From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Wed, 23 May 2018 14:17:14 -0700
Message-ID: <CAGXu5jLzNNejH1MEH3ct0hSyOtG1zk8=gE4Qpd2yDvQTSahL+w@mail.gmail.com>
References: <20180522183613.GA3784@infradead.org> <yq1efi3bk3g.fsf@oracle.com>
 <CAGXu5jJ0Sice+fdpWgzBhQR=NGz-DT9qmYVdV1GeH73_q9pbmw@mail.gmail.com>
 <732f4249-5681-4a54-ec21-4ecc3d3a74e5@kernel.dk> <20180522191309.GA23615@infradead.org>
 <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk> <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
 <9A0BC289-4203-4C77-A012-AAB07F42061F@kernel.dk> <CAGXu5jJsGWDsZNDJvUUqncSaAcvond_B_J7=BbvVW0X3r6Sxww@mail.gmail.com>
 <aa150272-ffeb-fb8f-7303-0d9502cf9a71@kernel.dk> <20180523142545.GA16248@infradead.org>
 <24d36869-e037-042d-cb16-20a81b34eb76@kernel.dk> <CAGXu5jJn=1Rz=D8VUwv_VoaGoLtaD=+tcPZxQxntweZoZwFa5Q@mail.gmail.com>
 <yq1o9h684lh.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1o9h684lh.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2018 at 2:06 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Kees,
>
>> obj-$(CONFIG_SCSI)              += scsi/
>>
>> So: this needs to live in block/ just like CONFIG_BLK_SCSI_REQUEST's
>> scsi_ioctl.c. I will split it into CONFIG_BLK_SCSI_SENSE, but I'll
>> still need to move the code from drivers/scsi/ to block/. Is this
>> okay?
>
> The reason this sucks is that scsi_normalize_sense() is an inherent core
> feature in the SCSI layer. Dealing with sense data for ioctls is just a
> fringe use case.

True, though I'm finding other robustness issues in the CDROM code.
They're probably all insane corner cases, but it seems like it'd be
nice to just fix them:

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 3522d2cae1b6..7726c8618c30 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2222,9 +2223,12 @@ static int cdrom_read_cdda_bpc(struct
cdrom_device_info *cdi, __u8 __user *ubuf,

                blk_execute_rq(q, cdi->disk, rq, 0);
                if (scsi_req(rq)->result) {
-                       struct request_sense *s = req->sense;
+                       struct scsi_sense_hdr sshdr;
+
                        ret = -EIO;
-                       cdi->last_sense = s->sense_key;
+                       scsi_normalize_sense(req->sense, req->sense_len,
+                                            &sshdr);
+                       cdi->last_sense = sshdr.sense_key;
                }

                if (blk_rq_unmap_user(bio))

This code wasn't checking req->sense_len, for example. It'll just get
stale data at worst case, but it's still ugly, especially since we
have a solution to do it right.

> I don't want to get too hung up on what goes where. But architecturally
> it really irks me to move a core piece of SCSI state machine
> functionality out of the subsystem to accommodate ioctl handling.

It looks like there is more in block/scsi_ioctl.c than just ioctl
handling, which is why I put the function in there originally.
Honestly, it's almost so small I could make it a static inline. :P

> I'm traveling today so I probably won't get a chance to look closely
> until tomorrow morning.

No worries; thanks for looking at it!

-Kees

-- 
Kees Cook
Pixel Security
