From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 09:30:59 -0700
Message-ID: <CAGXu5jJK3JuwLBGLbS1i6hBdyg_mkbVibbu6irfsnTOE1QhtfA@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name> <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
 <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com> <1523959328.3250.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1523959328.3250.11.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@wdc.com>, Paolo Valente <paolo.valente@linaro.org>, David Windsor <dave@nullcore.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 17, 2018 at 3:02 AM, James Bottomley
<jejb@linux.vnet.ibm.com> wrote:
> On Mon, 2018-04-16 at 20:12 -0700, Kees Cook wrote:
>> I still haven't figured this out, though... any have a moment to look
>> at this?
>
> Just to let you know you're not alone ... but I can't make any sense of
> this either.  The bfdq is the elevator_data, which is initialised when
> the scheduler is attached, so it shouldn't change.  Is it possible to
> set a data break point on elevator_data after it's initialised and see
> if it got changed by something?

Yeah, it seems like some pointer chain is getting overwritten outside
of a lock or rcu or ?. I don't know this code well enough to guess at
where to check, though. What I find so strange is that the structure
offsets are different between bfpd's rq_in_driver field and
scsi_request's sense field, so even THAT doesn't look to be clear-cut
either:

struct bfq_data {
        struct request_queue *     queue;                /*     0     8 */
        struct list_head           dispatch;             /*     8    16 */
        struct bfq_group *         root_group;           /*    24     8 */
        struct rb_root             queue_weights_tree;   /*    32     8 */
        struct rb_root             group_weights_tree;   /*    40     8 */
        int                        busy_queues;          /*    48     4 */
        int                        wr_busy_queues;       /*    52     4 */
        int                        queued;               /*    56     4 */
        int                        rq_in_driver;         /*    60     4 */
...

struct scsi_request {
        unsigned char              __cmd[16];            /*     0    16 */
        unsigned char *            cmd;                  /*    16     8 */
        short unsigned int         cmd_len;              /*    24     2 */

        /* XXX 2 bytes hole, try to pack */

        int                        result;               /*    28     4 */
        unsigned int               sense_len;            /*    32     4 */
        unsigned int               resid_len;            /*    36     4 */
        int                        retries;              /*    40     4 */

        /* XXX 4 bytes hole, try to pack */

        void *                     sense;                /*    48     8 */
...

This is _so_ weird. :P

-Kees

-- 
Kees Cook
Pixel Security
