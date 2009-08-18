From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Bidirectional data transfers from SCSI layer
Date: Tue, 18 Aug 2009 13:00:20 +0300
Message-ID: <4A8A7BB4.90102@panasas.com>
References: <97a757510908172322y7a42df80n5bf7f21fbca16e13@mail.gmail.com>	 <4A8A608D.9000909@panasas.com> <97a757510908180203h7c10c63fx19f436e72de25c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:30772
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753447AbZHRKAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 06:00:21 -0400
In-Reply-To: <97a757510908180203h7c10c63fx19f436e72de25c5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Madhavi Manchala <madhavi.lscsi@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 08/18/2009 12:03 PM, Madhavi Manchala wrote:
> On Tue, Aug 18, 2009 at 1:34 PM, Boaz Harrosh<bharrosh@panasas.com> wrote:
> 
> Dear Boaz,
> 
> Thanks for the information.
> 
>> drivers/scsi/osd/osd_initiator.c
> 
> I did not find this file in my 2.6.28 sources.
> 

If you are developing new code for Linux it is best
to base the work on latest git tree. Either Linus's or the
maintainer tree that will receive your work. See here:
http://git.kernel.org/

The file above you can see here:
http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=tree;f=drivers/scsi/osd;h=803721b1c52bcd52822976b515de817a8b765969;hb=ec34ca8bdef55a47c3b1f82b1021609570ccb283
Only 2.6.30 and up have osd support

>> On the scsi-driver side you do:
>>
>>        if (scsi_bidi_cmnd(cmnd)) {
>>                in_sgl = scsi_in(cmnd)->table.sgl;
>>                in_nents = scsi_in(cmnd)->table.nents;
>>                in_bytes = scsi_in(cmnd)->length;
>>
>>                /* Same thing for out */
>>                out_sgl = scsi_out(cmnd)->table.sgl;
>>                ...
>>        }
> 
> Do I need to modify the SCSI driver files to handle  the
> bi-directional comamnds or Is this already supported?
> 

Yes only very few drivers support bidi commands.
i.e. iscsi is the only one that supports them in general.

>> What type of scsi-device are you using?
> 
> I am working for USB Attached SCSI (UAS) device which supports
> bi-directional commands. I'm modifying USB Mass storage driver
> according to UAS requirements. 

Yes, Current "USB Mass storage driver" does not support bidi as well
as many other standard scsi things like NCQ.

> Whenever there is command to process,
> SCSI layer sends scsi_cmnd structure pointer to UAS class driver (my
> driver - modified mass storage driver). But I did not find two data
> pointers and two data length variables (one IN and one OUT) in this
> structure to handle bi-directional data.
> 

As I said use scsi_in() and scsi_out() at driver. But you need an initiator
to issue these type of commands. The Kernel does not use these type of commands
for normal I/O. Only osd initiator with osd-scsi targets does.

You can also use bsg driver to issue bidi commands from user mode. You will
need that your driver set the bidi queue-bit on initialization. (See iscsi_tcp)

(Tell me if you need example code for bsg use in user-mode).

> I found only one struct scsi_data_buffer pointer in scsi_cmnd
> structure. So, how do SCSI layer sends IN and OUT buffer pointers and
> their lengths to my class driver?
> 

Again: 
	if (scsi_bidi_cmnd(cmnd)) {
		in_sdb = scsi_in(cmnd);
		out_sdb = scsi_out(cmnd);
	}
It works, look at the code.

>> what bidi commands?
> 
> I did not understand this. Could you please elaborate it? Are there
> any bidi commands like READ_10 or WRITE_10 which are specific to any
> device?
> 

There is the XOR_10 I think and others. But I'm not sure. You'll have to look
it up yourself at the different T10 scsi standards. Also scsi_debug.c as some emulation
for a command or two. I only use scsi-osd type commands which are all potentially bidi
capable.

> Thanks and Regards,
> Madhavi M.

Boaz
