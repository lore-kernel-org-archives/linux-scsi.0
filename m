From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH] qla2xxx: rewrite code to avoid hitting gcc bug 70646
Date: Fri, 15 Apr 2016 20:56:25 +0200
Message-ID: <57113959.8050103@redhat.com>
References: <1460716583-15673-1-git-send-email-dvlasenk@redhat.com> <1460731203.2331.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460731203.2331.7.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: qla2xxx-upstream@qlogic.com, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/15/2016 04:40 PM, James Bottomley wrote:
> On Fri, 2016-04-15 at 12:36 +0200, Denys Vlasenko wrote:
>> More info here:
>> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
> 
> This bug is under investigation, so I'd rather not alter code for a gcc
> bug until we know if we can supply options to fix it rather than
> changing code.


Background. The bug exists in gcc for 2 years, but it is rather
hard to trigger, so nobody noticed.

Unfortunately for kernel, these two commits landed in Linus tree
in March 16 and 17:


On 04/13/2016 05:36 AM, Josh Poimboeuf wrote:
> It occurs with the combination of the following two recent commits:
>
> - bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some byteswap operations")
> - ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")


and now *many* users of qla2x00 and new-ish gcc are going to
very much notice it, as their kernels will start crashing reliably.

The commits can be reverted, sure, but they per se do not contain
anything unusual. They, together with not very typical construct
in qla2x00_get_host_fabric_name, one
which boils down to "swab64p(constant_array_of_8_bytes)",
just happen to nudge gcc in a right way to finally trigger the bug.

So I came with another idea how to forestall the imminent deluge of
qla2x00 oops reports - this patch.
