From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Wed, 23 May 2018 08:31:19 -0600
Message-ID: <24d36869-e037-042d-cb16-20a81b34eb76@kernel.dk>
References: <20180522183613.GA3784@infradead.org> <yq1efi3bk3g.fsf@oracle.com>
 <CAGXu5jJ0Sice+fdpWgzBhQR=NGz-DT9qmYVdV1GeH73_q9pbmw@mail.gmail.com>
 <732f4249-5681-4a54-ec21-4ecc3d3a74e5@kernel.dk>
 <20180522191309.GA23615@infradead.org>
 <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk>
 <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
 <9A0BC289-4203-4C77-A012-AAB07F42061F@kernel.dk>
 <CAGXu5jJsGWDsZNDJvUUqncSaAcvond_B_J7=BbvVW0X3r6Sxww@mail.gmail.com>
 <aa150272-ffeb-fb8f-7303-0d9502cf9a71@kernel.dk>
 <20180523142545.GA16248@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523142545.GA16248@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 5/23/18 8:25 AM, Christoph Hellwig wrote:
> On Wed, May 23, 2018 at 08:13:56AM -0600, Jens Axboe wrote:
>>> Should I move to code to a new drivers/scsi/scsi_sense.c and add it to
>>> drivers/scsi/Makefile as:
>>>
>>> obj-$(CONFIG_BLK_SCSI_REQUEST)    += scsi_sense.o
>>>
>>> Every place I want to use the code is already covered by
>>> CONFIG_BLK_SCSI_REQUEST, so it seems like I just need to know where to
>>> put the .c file. :P
>>
>> I think this is so much saner than a SCSI select or dependency, so I'll
>> have to disagree with Martin and Christoph. Just put it in drivers/scsi,
>> if it's the location they care about.
> 
> I actually plan to remove CONFIG_BLK_SCSI_REQUEST in a merge window
> or two.  The only users are scsi and the ide layer, (virtio_blk
> support has already been accidentally disabled for a while), and getting
> rid of it allows to to shrink and simply the scsi data structures.
> 
> But if you want this for now lets keep scsi_sense.c in drivers/scsi
> but depend on CONFIG_BLK_SCSI_REQUEST, that is easy enough to fix up.

It could be a stand-alone dependency, doesn't have to be BLK_SCSI_REQUEST.
BLA_SCSI_SENSE or something would do. I don't care too much about that,
mostly getting rid of the entire stack dependency.

-- 
Jens Axboe
