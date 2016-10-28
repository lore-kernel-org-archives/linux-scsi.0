From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Fri, 28 Oct 2016 15:53:33 +0200
Message-ID: <132d8dc4-e8d0-6eba-9ae2-4a7e2c9a589b@linux.vnet.ibm.com>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
 <2ea07f3f-88eb-b795-fa37-a223bf80e581@linux.vnet.ibm.com>
 <20161013162405.aoxy3bdkc4bqtwsk@linux-x5ow.site>
 <4b411836-e76f-b67a-3d49-ad3d51b8f216@linux.vnet.ibm.com>
 <d9a73963-1ade-2b6f-77bd-044e19675fd8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d9a73963-1ade-2b6f-77bd-044e19675fd8@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, Andreas Krebbel <Andreas.Krebbel@de.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, supporter:QLOGIC QLA2XXX FC-SCSI DRIVER
List-Id: linux-scsi@vger.kernel.org



On 10/28/2016 01:31 PM, Hannes Reinecke wrote:
> On 10/28/2016 11:53 AM, Steffen Maier wrote:
>> On 10/13/2016 06:24 PM, Johannes Thumshirn wrote:
>>> On Thu, Oct 13, 2016 at 05:15:25PM +0200, Steffen Maier wrote:
>>>> I'm puzzled.
>>>>
>>>> $ git bisect start fc_bsg master
>>
>>>>> 3087864ce3d7282f59021245d8a5f83ef1caef18 is the first bad commit
>>>>> commit 3087864ce3d7282f59021245d8a5f83ef1caef18
>>>>> Author: Johannes Thumshirn <jthumshirn@suse.de>
>>>>> Date:   Wed Oct 12 15:06:28 2016 +0200
>>>>>
>>>>>     scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>>>>>
>>>>>     Don't use fc_bsg_job::request and fc_bsg_job::reply directly,
>>>>> but use
>>>>>     helper variables bsg_request and bsg_reply. This will be
>>>>> helpfull  when
>>>>>     transitioning to bsg-lib.
>>>>>
>>>>>     Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>>>>>
>>>>> :040000 040000 140c4b6829d5cfaec4079716e0795f63f8bc3bd2
>>>>> 0d9fe225615679550be91fbd9f84c09ab1e280fc M    drivers
>>>>
>>>> From there (on the reverse bisect path) I get the following Oops,
>>>> except for the full patch set having another stack trace as in my
>>>> previous
>>>> mail (dying in zfcp code).
>>>
>>> [...]
>>>
>>>>> @@ -3937,6 +3944,7 @@ fc_bsg_request_handler(struct request_queue
>>>>> *q, struct Scsi_Host *shost,
>>>>>      struct request *req;
>>>>>      struct fc_bsg_job *job;
>>>>>      enum fc_dispatch_result ret;
>>>>> +    struct fc_bsg_reply *bsg_reply;
>>>>>
>>>>>      if (!get_device(dev))
>>>>>          return;
>>>>> @@ -3973,8 +3981,9 @@ fc_bsg_request_handler(struct request_queue
>>>>> *q, struct Scsi_Host *shost,
>>>>>          /* check if we have the msgcode value at least */
>>>>>          if (job->request_len < sizeof(uint32_t)) {
>>>>>              BUG_ON(job->reply_len < sizeof(uint32_t));
>>>>> -            job->reply->reply_payload_rcv_len = 0;
>>>>> -            job->reply->result = -ENOMSG;
>>>>> +            bsg_reply = job->reply;
>>>>> +            bsg_reply->reply_payload_rcv_len = 0;
>>>>> +            bsg_reply->result = -ENOMSG;
>>
>> Compiler optimization re-ordered above two lines and the first pointer
>> derefence is bsg_reply->result [field offset 0] where bsg_reply is NULL.
>> The assignment tries to write to memory at address NULL causing the
>> kernel page fault.
>>
> I spoke to our compiler people, and they strongly believed this not to
> be the case. Or, put it the other way round, if such a thing would
> happen it would be a compiler issue.
>
> Have you checked the compiler output?

I just mentioned the compiler optimization to explain why the assembler 
code visible in the panic dies at bsg_reply->result = -ENOMSG and not at 
bsg_reply->reply_payload_rcv_len = 0. I don't think it makes a 
difference regarding the issue, which remains a NULL pointer dereference 
with bsg_reply either way, which I doubt is caused by compiler output. 
But then again, see further down below.

> [   46.942560] Krnl PSW : 0704e00180000000 00000000007c91ec[   46.942574]  (fc_bsg_request_handler+0x404/0x4b0)
> [   46.942579]
> [   46.942583]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:000:
> [   46.942598]  RI:0 EA:3
> [   46.942601]
> [   46.942601] Krnl GPRS: 0000000000000000 00000000ffffffcb 0000000000000000 0000000080000001
> [   46.942603]            00000000007c8fe8 0000000064398c68 0000000069f967e8 000000006a3d8008
> [   46.942605]            000000006a5e02c8 00000000698b5490 0000000000000000 0000000000000000

 
        %r11 is NULL

> [   46.942607]            000000006a9ef5f8 0000000000a36840 00000000007c8fe8 000000005d2efa00
> [   46.942619] Krnl Code: 00000000007c91de: e55dc08c0003        clfhsi  140(%r12),3[   46.942622]
> [   46.942622]            00000000007c91e4: a7240004            brc     2,7c91ec
>                          #00000000007c91e8: a7f40001           brc     15,7c91ea[   46.942629]
> [   46.942629]           >00000000007c91ec: 5010b000            st      %r1,0(%r11)
>                           00000000007c91f0: e54cb0040000       mvhi    4(%r11),0[   46.942635]
> [   46.942635]            00000000007c91f6: e54cc08c0004        mvhi    140(%r12),4
>                           00000000007c91fc: b904002c           lgr     %r2,%r12[   46.942643]
> [   46.942643]            00000000007c9200: c0e5ffffe2c0        brasl   %r14,7c5780
> [   46.942646]
> [   46.942647] Call Trace:
> [   46.942650] ([<00000000007c8fe8>] fc_bsg_request_handler+0x200/0x4b0)
> [   46.942656] ([<00000000006b8e0a>] __blk_run_queue+0x52/0x68)
> [   46.942661] ([<00000000006c549a>] blk_execute_rq_nowait+0xf2/0x110)
> [   46.942664] ([<00000000006c557a>] blk_execute_rq+0xa2/0x110)
> [   46.942668] ([<00000000006de0ee>] bsg_ioctl+0x1f6/0x268)
> [   46.942675] ([<000000000036ca20>] do_vfs_ioctl+0x680/0x6d8)
> [   46.942677] ([<000000000036caf4>] SyS_ioctl+0x7c/0xb0)
> [   46.942685] ([<00000000009a541e>] system_call+0xd6/0x270)
> [   46.942687] INFO: lockdep is turned off.
> [   46.942688] Last Breaking-Event-Address:
> [   46.942692]  [<00000000007c91e4>] fc_bsg_request_handler+0x3fc/0x4b0
> [   46.942696]  [   46.942698] Kernel panic - not syncing: Fatal exception: panic_on_oops

all the following was written from bottom to top:

> crash> dis -l fc_bsg_request_handler
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3943

static void
fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
		       struct fc_rport *rport, struct device *dev)
{

> 0x7c8de8 <fc_bsg_request_handler>:      brcl    0,0x7c8de8 <fc_bsg_request_handler>
> 0x7c8dee <fc_bsg_request_handler+0x6>:  stmg    %r6,%r15,72(%r15)
> 0x7c8df4 <fc_bsg_request_handler+0xc>:  larl    %r13,0xa36840
> 0x7c8dfa <fc_bsg_request_handler+0x12>: tmll    %r15,16256
> 0x7c8dfe <fc_bsg_request_handler+0x16>: lgr     %r14,%r15
> 0x7c8e02 <fc_bsg_request_handler+0x1a>: je      0x7c8e04 <fc_bsg_request_handler+0x1c>
> 0x7c8e06 <fc_bsg_request_handler+0x1e>: lay     %r15,-112(%r15)
> 0x7c8e0c <fc_bsg_request_handler+0x24>: stg     %r14,152(%r15)
> 0x7c8e12 <fc_bsg_request_handler+0x2a>: lgr     %r9,%r2
> 0x7c8e16 <fc_bsg_request_handler+0x2e>: stg     %r5,176(%r15)
> 0x7c8e1c <fc_bsg_request_handler+0x34>: lgr     %r2,%r5
> 0x7c8e20 <fc_bsg_request_handler+0x38>: lgr     %r6,%r3
> 0x7c8e24 <fc_bsg_request_handler+0x3c>: lgr     %r10,%r4
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3949
> 0x7c8e28 <fc_bsg_request_handler+0x40>: brasl   %r14,0x787968 <get_device>
> 0x7c8e2e <fc_bsg_request_handler+0x46>: cgij    %r2,0,8,0x7c9288 <fc_bsg_request_handler+0x4a0>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3751

there is some confusing inlining of part of fc_req_to_bsgjob

> 0x7c8e34 <fc_bsg_request_handler+0x4c>: la      %r1,960(%r6)
> 0x7c8e38 <fc_bsg_request_handler+0x50>: stg     %r1,168(%r15)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3749
> 0x7c8e3e <fc_bsg_request_handler+0x56>: la      %r1,96(%r10)
> 0x7c8e42 <fc_bsg_request_handler+0x5a>: stg     %r1,160(%r15)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3953
> 0x7c8e48 <fc_bsg_request_handler+0x60>: cgij    %r10,0,8,0x7c9270 <fc_bsg_request_handler+0x488>
> 0x7c8e4e <fc_bsg_request_handler+0x66>: clc     4(4,%r13),40(%r10)
> 0x7c8e54 <fc_bsg_request_handler+0x6c>: jne     0x7c9258 <fc_bsg_request_handler+0x470>
> 0x7c8e58 <fc_bsg_request_handler+0x70>: tm      72(%r10),4
> 0x7c8e5c <fc_bsg_request_handler+0x74>: jne     0x7c9258 <fc_bsg_request_handler+0x470>
> 0x7c8e60 <fc_bsg_request_handler+0x78>: j       0x7c920a <fc_bsg_request_handler+0x422>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3961
> 0x7c8e64 <fc_bsg_request_handler+0x7c>: clc     0(4,%r13),40(%r10)
> 0x7c8e6a <fc_bsg_request_handler+0x82>: je      0x7c8e9e <fc_bsg_request_handler+0xb6>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3962

fc_bsg_request_handler()
                         req->errors = -ENXIO;

> 0x7c8e6e <fc_bsg_request_handler+0x86>: mvhi    260(%r12),-6

crash> struct -od request.errors
struct request {
   [260] int errors;
}

********************************************************************

BUT this seems the first time %r12 is used in fc_bsg_request_handler(),
especially I seem to miss %r12 being initalized with anything.
But then again I'm not at all well versed in disassembly.
Maybe fc_bsg_request_handler() is itself in turn inlined and I would 
need to start disassembling even earlier to get to %r12 init?
s390x ELF ABI says %r12:
usage: Local variable, commonly used as GOT pointer;
call effect: saved.
Even if it wasn't initialized and remained NULL below why did it not 
already page fault at above instruction? Silly me, we did not execute 
this instruction as it's "if" conditional. This makes me wonder even 
more where the content of %r12 comes from.

Ulli, Andreas, could you please shed some light on this?

********************************************************************

> /home/maier/kernel/linux-vanilla/./include/linux/spinlock.h: 357
> 0x7c8e74 <fc_bsg_request_handler+0x8c>: lg      %r2,2600(%r9)
> 0x7c8e7a <fc_bsg_request_handler+0x92>: brasl   %r14,0x9a46d0 <_raw_spin_unlock_irq>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3964
> 0x7c8e80 <fc_bsg_request_handler+0x98>: lgr     %r2,%r12
> 0x7c8e84 <fc_bsg_request_handler+0x9c>: lghi    %r3,-6
> 0x7c8e88 <fc_bsg_request_handler+0xa0>: brasl   %r14,0x6be2f0 <blk_end_request_all>
> /home/maier/kernel/linux-vanilla/./include/linux/spinlock.h: 332
> 0x7c8e8e <fc_bsg_request_handler+0xa6>: lg      %r2,2600(%r9)
> 0x7c8e94 <fc_bsg_request_handler+0xac>: brasl   %r14,0x9a4280 <_raw_spin_lock_irq>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3966
> 0x7c8e9a <fc_bsg_request_handler+0xb2>: j       0x7c8e48 <fc_bsg_request_handler+0x60>
> /home/maier/kernel/linux-vanilla/./include/linux/spinlock.h: 357
> 0x7c8e9e <fc_bsg_request_handler+0xb6>: lg      %r2,2600(%r9)
> 0x7c8ea4 <fc_bsg_request_handler+0xbc>: brasl   %r14,0x9a46d0 <_raw_spin_unlock_irq>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3709
> 0x7c8eaa <fc_bsg_request_handler+0xc2>: ltg     %r1,248(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3702
> 0x7c8eb0 <fc_bsg_request_handler+0xc8>: lg      %r7,512(%r6)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3703
> 0x7c8eb6 <fc_bsg_request_handler+0xce>: lg      %r8,360(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3709
> 0x7c8ebc <fc_bsg_request_handler+0xd4>: je      0x7c8ec4 <fc_bsg_request_handler+0xdc>
> 0x7c8ec0 <fc_bsg_request_handler+0xd8>: j       0x7c8ec2 <fc_bsg_request_handler+0xda>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3711
> 0x7c8ec4 <fc_bsg_request_handler+0xdc>: lg      %r1,568(%r7)
> 0x7c8eca <fc_bsg_request_handler+0xe2>: llgf    %r1,216(%r1)
> /home/maier/kernel/linux-vanilla/./include/linux/slab.h: 495
> 0x7c8ed0 <fc_bsg_request_handler+0xe8>: lgfi    %r3,37781696
> 0x7c8ed6 <fc_bsg_request_handler+0xee>: la      %r2,184(%r1)
> 0x7c8eda <fc_bsg_request_handler+0xf2>: brasl   %r14,0x325e38 <__kmalloc>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3713
> 0x7c8ee0 <fc_bsg_request_handler+0xf8>: lgr     %r11,%r2
> 0x7c8ee4 <fc_bsg_request_handler+0xfc>: cgij    %r2,0,8,0x7c9234 <fc_bsg_request_handler+0x44c>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3725

fc_req_to_bsgjob()
         req->special = job;

> 0x7c8eea <fc_bsg_request_handler+0x102>:        stg     %r2,248(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3726
> 0x7c8ef0 <fc_bsg_request_handler+0x108>:        stg     %r6,0(%r2)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3727
> 0x7c8ef6 <fc_bsg_request_handler+0x10e>:        stg     %r10,8(%r2)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3728

fc_req_to_bsgjob()
         job->req = req;

> 0x7c8efc <fc_bsg_request_handler+0x114>:        stg     %r12,24(%r2)

> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3729
> 0x7c8f02 <fc_bsg_request_handler+0x11a>:        lg      %r1,568(%r7)
> 0x7c8f08 <fc_bsg_request_handler+0x120>:        lt      %r1,216(%r1)
> 0x7c8f0e <fc_bsg_request_handler+0x126>:        je      0x7c8f1c <fc_bsg_request_handler+0x134>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3730
> 0x7c8f12 <fc_bsg_request_handler+0x12a>:        la      %r1,184(%r2)
> 0x7c8f16 <fc_bsg_request_handler+0x12e>:        stg     %r1,176(%r2)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3731
> 0x7c8f1c <fc_bsg_request_handler+0x134>:        larl    %r4,0x2054808 <proc_scsi+0x48>
> 0x7c8f22 <fc_bsg_request_handler+0x13a>:        larl    %r3,0xbddbd8
> 0x7c8f28 <fc_bsg_request_handler+0x140>:        la      %r2,32(%r11)
> 0x7c8f2c <fc_bsg_request_handler+0x144>:        brasl   %r14,0x1b7ac8 <__raw_spin_lock_init>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3733
> 0x7c8f32 <fc_bsg_request_handler+0x14a>:        llh     %r1,288(%r12)
> 0x7c8f38 <fc_bsg_request_handler+0x150>:        st      %r1,136(%r11)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3735
> 0x7c8f3c <fc_bsg_request_handler+0x154>:        mvhi    140(%r11),96
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3737
> 0x7c8f42 <fc_bsg_request_handler+0x15a>:        ltg     %r1,104(%r12)
> 0x7c8f48 <fc_bsg_request_handler+0x160>:        jne     0x7c8f56 <fc_bsg_request_handler+0x16e>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3742
> 0x7c8f4c <fc_bsg_request_handler+0x164>:        cgij    %r8,0,6,0x7c8f84 <fc_bsg_request_handler+0x19c>
> 0x7c8f52 <fc_bsg_request_handler+0x16a>:        j       0x7c8f6e <fc_bsg_request_handler+0x186>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3738
> 0x7c8f56 <fc_bsg_request_handler+0x16e>:        lgr     %r3,%r12
> 0x7c8f5a <fc_bsg_request_handler+0x172>:        la      %r2,144(%r11)
> 0x7c8f5e <fc_bsg_request_handler+0x176>:        brasl   %r14,0x7c56c8 <fc_bsg_map_buffer>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3739
> 0x7c8f64 <fc_bsg_request_handler+0x17c>:        cij     %r2,0,8,0x7c8f4c <fc_bsg_request_handler+0x164>
> 0x7c8f6a <fc_bsg_request_handler+0x182>:        j       0x7c900e <fc_bsg_request_handler+0x226>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3747
> 0x7c8f6e <fc_bsg_request_handler+0x186>:        larl    %r1,0x7c5780 <fc_bsg_jobdone>
> 0x7c8f74 <fc_bsg_request_handler+0x18c>:        stg     %r1,112(%r11)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3748
> 0x7c8f7a <fc_bsg_request_handler+0x192>:        cgij    %r10,0,6,0x7c8fa6 <fc_bsg_request_handler+0x1be>
> 0x7c8f80 <fc_bsg_request_handler+0x198>:        j       0x7c8fd2 <fc_bsg_request_handler+0x1ea>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3742
> 0x7c8f84 <fc_bsg_request_handler+0x19c>:        ltg     %r1,104(%r8)
> 0x7c8f8a <fc_bsg_request_handler+0x1a2>:        je      0x7c8f6e <fc_bsg_request_handler+0x186>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3743
> 0x7c8f8e <fc_bsg_request_handler+0x1a6>:        lgr     %r3,%r8
> 0x7c8f92 <fc_bsg_request_handler+0x1aa>:        la      %r2,160(%r11)
> 0x7c8f96 <fc_bsg_request_handler+0x1ae>:        brasl   %r14,0x7c56c8 <fc_bsg_map_buffer>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3744
> 0x7c8f9c <fc_bsg_request_handler+0x1b4>:        cij     %r2,0,8,0x7c8f6e <fc_bsg_request_handler+0x186>
> 0x7c8fa2 <fc_bsg_request_handler+0x1ba>:        j       0x7c9002 <fc_bsg_request_handler+0x21a>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3749
> 0x7c8fa6 <fc_bsg_request_handler+0x1be>:        lg      %r2,160(%r15)
> 0x7c8fac <fc_bsg_request_handler+0x1c4>:        stg     %r2,16(%r11)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3752
> 0x7c8fb2 <fc_bsg_request_handler+0x1ca>:        brasl   %r14,0x787968 <get_device>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3754
> 0x7c8fb8 <fc_bsg_request_handler+0x1d0>:        mvhi    108(%r11),1
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3979

      fc_bsg_request_handler()
            job = req->special;

> 0x7c8fbe <fc_bsg_request_handler+0x1d6>:        lg      %r12,248(%r12)

crash> struct -od request.special
struct request {
   [248] void *special;
}

********************************************************************

so above %r12 did contain req, below it contains job.
since we could deref req further up it must have been non-NULL and 
pointing to a mapped page, but req->special is NULL here?
well, req could even have been NULL and we read from address 248 in low 
core here which does not trigger a page fault (only on write to low core).

crash> x/g 248
0xf8 <_text+248>:       0x0

********************************************************************

> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3982
> 0x7c8fc4 <fc_bsg_request_handler+0x1dc>:        l       %r1,136(%r12)
> 0x7c8fc8 <fc_bsg_request_handler+0x1e0>:        clij    %r1,3,12,0x7c901c <fc_bsg_request_handler+0x234>
> 0x7c8fce <fc_bsg_request_handler+0x1e6>:        j       0x7c905c <fc_bsg_request_handler+0x274>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3751
> 0x7c8fd2 <fc_bsg_request_handler+0x1ea>:        lg      %r1,168(%r15)
> 0x7c8fd8 <fc_bsg_request_handler+0x1f0>:        stg     %r1,16(%r11)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3752
> 0x7c8fde <fc_bsg_request_handler+0x1f6>:        lgr     %r2,%r1
> 0x7c8fe2 <fc_bsg_request_handler+0x1fa>:        brasl   %r14,0x787968 <get_device>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3754
> 0x7c8fe8 <fc_bsg_request_handler+0x200>:        mvhi    108(%r11),1
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3979
> 0x7c8fee <fc_bsg_request_handler+0x206>:        lg      %r12,248(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3982
> 0x7c8ff4 <fc_bsg_request_handler+0x20c>:        l       %r1,136(%r12)
> 0x7c8ff8 <fc_bsg_request_handler+0x210>:        clij    %r1,3,12,0x7c901c <fc_bsg_request_handler+0x234>
> 0x7c8ffe <fc_bsg_request_handler+0x216>:        j       0x7c90f4 <fc_bsg_request_handler+0x30c>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3760
> 0x7c9002 <fc_bsg_request_handler+0x21a>:        lg      %r2,152(%r11)
> 0x7c9008 <fc_bsg_request_handler+0x220>:        brasl   %r14,0x328ff0 <kfree>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3762
> 0x7c900e <fc_bsg_request_handler+0x226>:        lgr     %r2,%r11
> 0x7c9012 <fc_bsg_request_handler+0x22a>:        brasl   %r14,0x328ff0 <kfree>
> 0x7c9018 <fc_bsg_request_handler+0x230>:        j       0x7c9234 <fc_bsg_request_handler+0x44c>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3983
> 0x7c901c <fc_bsg_request_handler+0x234>:        clfhsi  140(%r12),3
> 0x7c9022 <fc_bsg_request_handler+0x23a>:        jh      0x7c902a <fc_bsg_request_handler+0x242>
> 0x7c9026 <fc_bsg_request_handler+0x23e>:        j       0x7c9028 <fc_bsg_request_handler+0x240>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3984
> 0x7c902a <fc_bsg_request_handler+0x242>:        lg      %r1,128(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3985
> 0x7c9030 <fc_bsg_request_handler+0x248>:        mvhi    4(%r1),0
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3986
> 0x7c9036 <fc_bsg_request_handler+0x24e>:        mvhi    0(%r1),-42
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3988
> 0x7c903c <fc_bsg_request_handler+0x254>:        lgr     %r2,%r12
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3987
> 0x7c9040 <fc_bsg_request_handler+0x258>:        mvhi    140(%r12),4
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3988
> 0x7c9046 <fc_bsg_request_handler+0x25e>:        brasl   %r14,0x7c5780 <fc_bsg_jobdone>
> /home/maier/kernel/linux-vanilla/./include/linux/spinlock.h: 332
> 0x7c904c <fc_bsg_request_handler+0x264>:        lg      %r2,2600(%r9)
> 0x7c9052 <fc_bsg_request_handler+0x26a>:        brasl   %r14,0x9a4280 <_raw_spin_lock_irq>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3990
> 0x7c9058 <fc_bsg_request_handler+0x270>:        j       0x7c8e48 <fc_bsg_request_handler+0x60>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3892
> 0x7c905c <fc_bsg_request_handler+0x274>:        lg      %r2,120(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3887
> 0x7c9062 <fc_bsg_request_handler+0x27a>:        lg      %r11,128(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3892
> 0x7c9068 <fc_bsg_request_handler+0x280>:        l       %r2,0(%r2)
> 0x7c906c <fc_bsg_request_handler+0x284>:        iilf    %r3,1073741825
> 0x7c9072 <fc_bsg_request_handler+0x28a>:        crj     %r2,%r3,8,0x7c9088 <fc_bsg_request_handler+0x2a0>
> 0x7c9078 <fc_bsg_request_handler+0x290>:        iilf    %r3,1073741826
> 0x7c907e <fc_bsg_request_handler+0x296>:        crj     %r2,%r3,8,0x7c9090 <fc_bsg_request_handler+0x2a8>
> 0x7c9084 <fc_bsg_request_handler+0x29c>:        j       0x7c90d2 <fc_bsg_request_handler+0x2ea>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3894
> 0x7c9088 <fc_bsg_request_handler+0x2a0>:        lhi     %r2,5
> 0x7c908c <fc_bsg_request_handler+0x2a4>:        j       0x7c9094 <fc_bsg_request_handler+0x2ac>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3898
> 0x7c9090 <fc_bsg_request_handler+0x2a8>:        lhi     %r2,16
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3901
> 0x7c9094 <fc_bsg_request_handler+0x2ac>:        lt      %r3,144(%r12)
> 0x7c909a <fc_bsg_request_handler+0x2b2>:        je      0x7c90da <fc_bsg_request_handler+0x2f2>
> 0x7c909e <fc_bsg_request_handler+0x2b6>:        lt      %r3,160(%r12)
> 0x7c90a4 <fc_bsg_request_handler+0x2bc>:        je      0x7c90da <fc_bsg_request_handler+0x2f2>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3913
> 0x7c90a8 <fc_bsg_request_handler+0x2c0>:        clrj    %r2,%r1,2,0x7c90e2 <fc_bsg_request_handler+0x2fa>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3918
> 0x7c90ae <fc_bsg_request_handler+0x2c6>:        lg      %r1,512(%r6)
> 0x7c90b4 <fc_bsg_request_handler+0x2cc>:        lg      %r1,568(%r1)
> 0x7c90ba <fc_bsg_request_handler+0x2d2>:        lg      %r1,192(%r1)
> 0x7c90c0 <fc_bsg_request_handler+0x2d8>:        lgr     %r2,%r12
> 0x7c90c4 <fc_bsg_request_handler+0x2dc>:        basr    %r14,%r1
> 0x7c90c6 <fc_bsg_request_handler+0x2de>:        lr      %r1,%r2
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3919
> 0x7c90c8 <fc_bsg_request_handler+0x2e0>:        cij     %r2,0,6,0x7c90e6 <fc_bsg_request_handler+0x2fe>
> 0x7c90ce <fc_bsg_request_handler+0x2e6>:        j       0x7c9248 <fc_bsg_request_handler+0x460>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3908
> 0x7c90d2 <fc_bsg_request_handler+0x2ea>:        lhi     %r1,-53
> 0x7c90d6 <fc_bsg_request_handler+0x2ee>:        j       0x7c90e6 <fc_bsg_request_handler+0x2fe>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3903
> 0x7c90da <fc_bsg_request_handler+0x2f2>:        lhi     %r1,-22
> 0x7c90de <fc_bsg_request_handler+0x2f6>:        j       0x7c90e6 <fc_bsg_request_handler+0x2fe>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3914
> 0x7c90e2 <fc_bsg_request_handler+0x2fa>:        lhi     %r1,-42
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3924
> 0x7c90e6 <fc_bsg_request_handler+0x2fe>:        clfhsi  140(%r12),3
> 0x7c90ec <fc_bsg_request_handler+0x304>:        jh      0x7c91ec <fc_bsg_request_handler+0x404>
> 0x7c90f0 <fc_bsg_request_handler+0x308>:        j       0x7c90f2 <fc_bsg_request_handler+0x30a>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3785

fc_bsg_host_dispatch()
	struct fc_bsg_request *bsg_request = job->request;

> 0x7c90f4 <fc_bsg_request_handler+0x30c>:        lg      %r3,120(%r12)
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3786

fc_bsg_host_dispatch()
	struct fc_bsg_reply *bsg_reply = job->reply;

> 0x7c90fa <fc_bsg_request_handler+0x312>:        lg      %r11,128(%r12)

load content of address in %r12 with displacement 128 into %r11.
so presumably job->reply is NULL.
due to funny inlining incl. fc_bsg_host_dispatch(), it's tricky to 
backtrack where job in %r12 came from and what happened to it on the way.
%r11 is not clobbered until used below where the page fault happens.
displacement is consistent:
crash> struct -od fc_bsg_job
struct fc_bsg_job {
     [0] struct Scsi_Host *shost;
     [8] struct fc_rport *rport;
    [16] struct device *dev;
    [24] struct request *req;
    [32] spinlock_t job_lock;
   [104] unsigned int state_flags;
   [108] unsigned int ref_cnt;
   [112] void (*job_done)(struct fc_bsg_job *);
   [120] struct fc_bsg_request *request;
   [128] struct fc_bsg_reply *reply;
   [136] unsigned int request_len;
   [140] unsigned int reply_len;
   [144] struct bsg_buffer request_payload;
   [160] struct bsg_buffer reply_payload;
   [176] void *dd_data;
}
SIZE: 184

> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3791
> 0x7c9100 <fc_bsg_request_handler+0x318>:        l       %r2,0(%r3)
> 0x7c9104 <fc_bsg_request_handler+0x31c>:        clfi    %r2,2147483651
> 0x7c910a <fc_bsg_request_handler+0x322>:        je      0x7c913e <fc_bsg_request_handler+0x356>
> 0x7c910e <fc_bsg_request_handler+0x326>:        jh      0x7c9122 <fc_bsg_request_handler+0x33a>
> 0x7c9112 <fc_bsg_request_handler+0x32a>:        iilf    %r3,2147483649
> 0x7c9118 <fc_bsg_request_handler+0x330>:        clrj    %r2,%r3,10,0x7c9194 <fc_bsg_request_handler+0x3ac>
> 0x7c911e <fc_bsg_request_handler+0x336>:        j       0x7c91c2 <fc_bsg_request_handler+0x3da>
> 0x7c9122 <fc_bsg_request_handler+0x33a>:        iilf    %r4,2147483652
> 0x7c9128 <fc_bsg_request_handler+0x340>:        crj     %r2,%r4,8,0x7c9156 <fc_bsg_request_handler+0x36e>
> 0x7c912e <fc_bsg_request_handler+0x346>:        iilf    %r4,2147483903
> 0x7c9134 <fc_bsg_request_handler+0x34c>:        crj     %r2,%r4,8,0x7c9172 <fc_bsg_request_handler+0x38a>
> 0x7c913a <fc_bsg_request_handler+0x352>:        j       0x7c91c2 <fc_bsg_request_handler+0x3da>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3803
> 0x7c913e <fc_bsg_request_handler+0x356>:        lt      %r2,144(%r12)
> 0x7c9144 <fc_bsg_request_handler+0x35c>:        je      0x7c91ca <fc_bsg_request_handler+0x3e2>
> 0x7c9148 <fc_bsg_request_handler+0x360>:        lt      %r2,160(%r12)
> 0x7c914e <fc_bsg_request_handler+0x366>:        je      0x7c91ca <fc_bsg_request_handler+0x3e2>
> 0x7c9152 <fc_bsg_request_handler+0x36a>:        j       0x7c9194 <fc_bsg_request_handler+0x3ac>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3813
> 0x7c9156 <fc_bsg_request_handler+0x36e>:        lt      %r2,144(%r12)
> 0x7c915c <fc_bsg_request_handler+0x374>:        je      0x7c91ca <fc_bsg_request_handler+0x3e2>
> 0x7c9160 <fc_bsg_request_handler+0x378>:        lt      %r2,160(%r12)
> 0x7c9166 <fc_bsg_request_handler+0x37e>:        je      0x7c91ca <fc_bsg_request_handler+0x3e2>
> 0x7c916a <fc_bsg_request_handler+0x382>:        lhi     %r2,20
> 0x7c916e <fc_bsg_request_handler+0x386>:        j       0x7c9198 <fc_bsg_request_handler+0x3b0>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3822
> 0x7c9172 <fc_bsg_request_handler+0x38a>:        lg      %r2,504(%r6)
> 0x7c9178 <fc_bsg_request_handler+0x390>:        ltg     %r2,304(%r2)
> 0x7c917e <fc_bsg_request_handler+0x396>:        je      0x7c91d2 <fc_bsg_request_handler+0x3ea>
> 0x7c9182 <fc_bsg_request_handler+0x39a>:        cg      %r2,4(%r3)
> 0x7c9188 <fc_bsg_request_handler+0x3a0>:        jne     0x7c91d2 <fc_bsg_request_handler+0x3ea>
> 0x7c918c <fc_bsg_request_handler+0x3a4>:        lhi     %r2,12
> 0x7c9190 <fc_bsg_request_handler+0x3a8>:        j       0x7c9198 <fc_bsg_request_handler+0x3b0>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3791
> 0x7c9194 <fc_bsg_request_handler+0x3ac>:        lhi     %r2,8
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3836
> 0x7c9198 <fc_bsg_request_handler+0x3b0>:        clrj    %r2,%r1,2,0x7c91da <fc_bsg_request_handler+0x3f2>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3841
> 0x7c919e <fc_bsg_request_handler+0x3b6>:        lg      %r1,512(%r6)
> 0x7c91a4 <fc_bsg_request_handler+0x3bc>:        lg      %r1,568(%r1)
> 0x7c91aa <fc_bsg_request_handler+0x3c2>:        lg      %r1,192(%r1)
> 0x7c91b0 <fc_bsg_request_handler+0x3c8>:        lgr     %r2,%r12
> 0x7c91b4 <fc_bsg_request_handler+0x3cc>:        basr    %r14,%r1
> 0x7c91b6 <fc_bsg_request_handler+0x3ce>:        lr      %r1,%r2
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3842
> 0x7c91b8 <fc_bsg_request_handler+0x3d0>:        cij     %r2,0,6,0x7c91de <fc_bsg_request_handler+0x3f6>
> 0x7c91be <fc_bsg_request_handler+0x3d6>:        j       0x7c9248 <fc_bsg_request_handler+0x460>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3831
> 0x7c91c2 <fc_bsg_request_handler+0x3da>:        lhi     %r1,-53
> 0x7c91c6 <fc_bsg_request_handler+0x3de>:        j       0x7c91de <fc_bsg_request_handler+0x3f6>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3805
> 0x7c91ca <fc_bsg_request_handler+0x3e2>:        lhi     %r1,-22
> 0x7c91ce <fc_bsg_request_handler+0x3e6>:        j       0x7c91de <fc_bsg_request_handler+0x3f6>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3825
> 0x7c91d2 <fc_bsg_request_handler+0x3ea>:        lhi     %r1,-3
> 0x7c91d6 <fc_bsg_request_handler+0x3ee>:        j       0x7c91de <fc_bsg_request_handler+0x3f6>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3837
> 0x7c91da <fc_bsg_request_handler+0x3f2>:        lhi     %r1,-42
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3847

fc_bsg_host_dispatch()

fail_host_msg:
	/* return the errno failure code as the only status */
	BUG_ON(job->reply_len < sizeof(uint32_t));

> 0x7c91de <fc_bsg_request_handler+0x3f6>:        clfhsi  140(%r12),3
> 0x7c91e4 <fc_bsg_request_handler+0x3fc>:        jh      0x7c91ec <fc_bsg_request_handler+0x404>
> 0x7c91e8 <fc_bsg_request_handler+0x400>:        j       0x7c91ea <fc_bsg_request_handler+0x402>
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3849

	bsg_reply->result = ret;

> 0x7c91ec <fc_bsg_request_handler+0x404>:        st      %r1,0(%r11)

that store causes the kernel page fault because %r11 is NULL and with 
displacement 0 it still is NULL.

> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3848

	bsg_reply->reply_payload_rcv_len = 0;

> 0x7c91f0 <fc_bsg_request_handler+0x408>:        mvhi    4(%r11),0

if we would have gotten this far:
16-bit signed immediate 0 is extended to 4-bytes and stored to where 
%r11 with displacement 4 points to.
displacements nicely match structure fields:
crash> struct -od fc_bsg_reply
struct fc_bsg_reply {
    [0] uint32_t result;
    [4] uint32_t reply_payload_rcv_len;
        union {
            struct fc_bsg_host_vendor_reply vendor_reply;
            struct fc_bsg_ctels_reply ctels_reply;
    [8] } reply_data;
}
SIZE: 16

> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3850

	job->reply_len = sizeof(uint32_t);

> 0x7c91f6 <fc_bsg_request_handler+0x40e>:        mvhi    140(%r12),4
> /home/maier/kernel/linux-vanilla/drivers/scsi/scsi_transport_fc.c: 3851
> 0x7c91fc <fc_bsg_request_handler+0x414>:        lgr     %r2,%r12
> 0x7c9200 <fc_bsg_request_handler+0x418>:        brasl   %r14,0x7c5780 <fc_bsg_jobdone>

source code is based on
> $ git log --graph --oneline
> * 271c1723d9c8 scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
> * a3c95a6c69e4 scsi: Get rid of struct fc_bsg_buffer
> *   1573d2caf713 Merge branch 'parisc-4.9-2' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux




-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
