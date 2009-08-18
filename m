From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Bidirectional data transfers from SCSI layer
Date: Tue, 18 Aug 2009 14:46:43 +0300
Message-ID: <4A8A94A3.9010802@panasas.com>
References: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>	 <4A8A608D.9000909@panasas.com>	 <97a757510908180203h7c10c63fx19f436e72de25c5@mail.gmail.com>	 <4A8A7BB4.90102@panasas.com> <97a757510908180335u5c5f85b3r7d235440ba83c2cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:1859
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752110AbZHRLqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 07:46:45 -0400
In-Reply-To: <97a757510908180335u5c5f85b3r7d235440ba83c2cd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhavi Manchala <madhavi.lscsi@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 08/18/2009 01:35 PM, Madhavi Manchala wrote:
> On Tue, Aug 18, 2009 at 3:30 PM, Boaz Harrosh<bharrosh@panasas.com> wrote:
> 
> Dear Boaz,
> 
> Thanks a lot.
> 
>>> Do I need to modify the SCSI driver files to handle  the
>>> bi-directional comamnds or Is this already supported?
>>>
>>
>> Yes only very few drivers support bidi commands.
>> i.e. iscsi is the only one that supports them in general.
> 
> Currently, I am registering my driver to the SCSI layer. Now I
> understand, I need to register my driver to iscsi to get
> bi-directional commands. If this is the case, how can I register my
> driver to iscsi driver to get bi-directional commands, and will I get
> the same functionality from iscsi as I am currently getting from scsi.
> 

No!. You miss understood. iscsi is just a scsi LLD (Low Level Driver)
just as usb/storage/scsiglue.c is an LLD. You only register with scsi.

scsi-ml has full support for bidi. Only the LLDs do not. except two
LLDs: iscsi and scsi_debug.

>> (Tell me if you need example code for bsg use in user-mode).
> 
> Could you please send me the link to the user mode bsg initiator code
> which issues the bi-directional commands?
> 

Start here:
http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=blob;f=lib/bsgdev.c;h=f55a87879784f05950e7a2d88798605183cc660a;hb=ec34ca8bdef55a47c3b1f82b1021609570ccb283
and generally inspect this folder:
http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=tree;f=lib;h=5739f66f529c010755ab4bb05db4496d0ea4b229;hb=ec34ca8bdef55a47c3b1f82b1021609570ccb283

Above files are used to issue scsi-osd commands from user-mode, which can all be bidi.

>>> I found only one struct scsi_data_buffer pointer in scsi_cmnd
>>> structure. So, how do SCSI layer sends IN and OUT buffer pointers and
>>> their lengths to my class driver?
>>>
>>
>> Again:
>>        if (scsi_bidi_cmnd(cmnd)) {
>>                in_sdb = scsi_in(cmnd);
>>                out_sdb = scsi_out(cmnd);
>>        }
>> It works, look at the code.
> 
> Before using the above snippet in my class driver, do I need to fill
> in_req and out_req in SCSI layer or Is it already filled? If I use the
> iscsi driver, then there is no need to do any modifications to the
> in_req and out_req.
> 

Again: upper layers have full support. You only need the top most initiator
and a supporting LLD.

[ Initiator => block-layer => scsi-ml => LLD
  - initiators: bsg and osd support bidi. All other do not.
  - block-layer && scsi-ml fully support bidi.
  - LLDs: only iscsi currently supports bidi.
]

> Thanks and Regards,
> Madhavi M.

Boaz
