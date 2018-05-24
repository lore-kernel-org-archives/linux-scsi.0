From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Thu, 24 May 2018 00:36:54 -0700
Message-ID: <20180524073654.GA32083@infradead.org>
References: <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk>
 <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
 <9A0BC289-4203-4C77-A012-AAB07F42061F@kernel.dk>
 <CAGXu5jJsGWDsZNDJvUUqncSaAcvond_B_J7=BbvVW0X3r6Sxww@mail.gmail.com>
 <aa150272-ffeb-fb8f-7303-0d9502cf9a71@kernel.dk>
 <20180523142545.GA16248@infradead.org>
 <24d36869-e037-042d-cb16-20a81b34eb76@kernel.dk>
 <CAGXu5jJn=1Rz=D8VUwv_VoaGoLtaD=+tcPZxQxntweZoZwFa5Q@mail.gmail.com>
 <yq1o9h684lh.fsf@oracle.com>
 <CAGXu5jLzNNejH1MEH3ct0hSyOtG1zk8=gE4Qpd2yDvQTSahL+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLzNNejH1MEH3ct0hSyOtG1zk8=gE4Qpd2yDvQTSahL+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2018 at 02:17:14PM -0700, Kees Cook wrote:
> 
> True, though I'm finding other robustness issues in the CDROM code.
> They're probably all insane corner cases, but it seems like it'd be
> nice to just fix them:
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 3522d2cae1b6..7726c8618c30 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -2222,9 +2223,12 @@ static int cdrom_read_cdda_bpc(struct
> cdrom_device_info *cdi, __u8 __user *ubuf,
> 
>                 blk_execute_rq(q, cdi->disk, rq, 0);
>                 if (scsi_req(rq)->result) {
> -                       struct request_sense *s = req->sense;
> +                       struct scsi_sense_hdr sshdr;
> +
>                         ret = -EIO;
> -                       cdi->last_sense = s->sense_key;
> +                       scsi_normalize_sense(req->sense, req->sense_len,
> +                                            &sshdr);
> +                       cdi->last_sense = sshdr.sense_key;
>                 }
> 
>                 if (blk_rq_unmap_user(bio))

The proper fix here is to rewrite this function to use the the
->generic_packet cdrom_device_ops method.  Is is the only caller
going straight to the scsi passthrough requests, which is a layering
violation.
