From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH] qla2xxx: rewrite code to avoid hitting gcc bug 70646
Date: Fri, 15 Apr 2016 23:09:56 +0200
Message-ID: <571158A4.8020500@redhat.com>
References: <1460716583-15673-1-git-send-email-dvlasenk@redhat.com>	 <1460731203.2331.7.camel@HansenPartnership.com>	 <57113959.8050103@redhat.com> <1460747126.2331.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460747126.2331.28.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: qla2xxx-upstream@qlogic.com, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/15/2016 09:05 PM, James Bottomley wrote:
> On Fri, 2016-04-15 at 20:56 +0200, Denys Vlasenko wrote:
>> On 04/15/2016 04:40 PM, James Bottomley wrote:
>>> On Fri, 2016-04-15 at 12:36 +0200, Denys Vlasenko wrote:
>>>> More info here:
>>>> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
>>>
>>> This bug is under investigation, so I'd rather not alter code for a
>>> gcc
>>> bug until we know if we can supply options to fix it rather than
>>> changing code.
>>
>>
>> Background. The bug exists in gcc for 2 years, but it is rather
>> hard to trigger, so nobody noticed.
> 
> We know this ... linux-scsi is on the cc for the other thread on this.
> 
>> Unfortunately for kernel, these two commits landed in Linus tree
>> in March 16 and 17:
>>
>>
>> On 04/13/2016 05:36 AM, Josh Poimboeuf wrote:
>>> It occurs with the combination of the following two recent commits:
>>>
>>> - bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining
>>> of some byteswap operations")
>>> - ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")
>>
>>
>> and now *many* users of qla2x00 and new-ish gcc are going to
>> very much notice it, as their kernels will start crashing reliably.
>>
>> The commits can be reverted, sure, but they per se do not contain
>> anything unusual. They, together with not very typical construct
>> in qla2x00_get_host_fabric_name, one
>> which boils down to "swab64p(constant_array_of_8_bytes)",
>> just happen to nudge gcc in a right way to finally trigger the bug.
>>
>> So I came with another idea how to forestall the imminent deluge of
>> qla2x00 oops reports - this patch.
> 
> There are actually a raft of checkers that run the upstream code which
> aren't seeing any problem; likely because the code is harder to trigger
> than you think.  So, lets wait until the resolution of the other thread
> before we panic, especially since we're only at -rc3.

I'm not panicking, James.

By sending a workaround, I just want to make sure that *other people*
won't be forced to fix up a problem which surfaced because of *my* patch.


I'm afraid "harder to trigger than you think" is not true.
It is nearly trivial to trigger it now.
I just tried the following on a freshly installed Fedora 21 machine:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
$ cd linux
$ make defconfig
$ sed '/SCSI_FC_ATTRS/d;/SCSI_LOWLEVEL/d' -i .config
$ make oldconfig    # answer "yes" to everything
$ nice make -j22
$ objdump -dr drivers/scsi/qla2xxx/qla_attr.o | grep -A10 qla2x00_get_host_fabric_name

0000000000001540 <qla2x00_get_host_fabric_name>:
    1540:	55                   	push   %rbp
    1541:	48 89 e5             	mov    %rsp,%rbp
    1544:	66 66 66 2e 0f 1f 84 	data32 data32 nopw %cs:0x0(%rax,%rax,1)
    154b:	00 00 00 00 00

0000000000001550 <qla2x00_fw_state_show>:
    1550:	55                   	push   %rbp
    1551:	48 89 e5             	mov    %rsp,%rbp
    1554:	53                   	push   %rbx
    1555:	48 89 d3             	mov    %rdx,%rbx

See?
I'm sure Fedora 22, 23 and 24 will also do that.
