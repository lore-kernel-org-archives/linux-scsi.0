From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer
 dereference
Date: Tue, 11 Mar 2008 18:16:16 +0200
Message-ID: <47D6B050.7070803@panasas.com>
References: <867igc3w8r.fsf@deprecated.bitebene.org>	 <47D551B8.9080807@panasas.com> <1205183577.2941.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36955 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYCKQRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 12:17:20 -0400
In-Reply-To: <1205183577.2941.38.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Mar 10 2008 at 23:12 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-03-10 at 17:20 +0200, Boaz Harrosh wrote:
>> On Sun, Mar 09 2008 at 14:41 +0200, Sven Schnelle <svens@stackframe.org> wrote:
>>> Hi,
>>>
>>> i'm facing the following kernel oops with the latest git:
>>>
>>> --------------------------------------8<--------------------------------------
>>> Stopping MD arrays...failed (no MD subsystem loaded).
>>> Mounting root filesystem read-only...done.
>>> Will now restart.
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>>> IP: [<ffffffff8051a97e>] __gdth_interrupt+0x96e/0xb7f
>>> PGD 7e51e067 PUD 7e6a1067 PMD 0 
>>> Oops: 0002 [1] PREEMPT SMP 
>>> CPU 3 
>>> Modules linked in: nvidia(P) lm85 hwmon_vid hwmon [last unloaded: nvidia]
>>> Pid: 0, comm: swapper Tainted: P         2.6.25-rc4-smp-00134-g84c6f60 #11 
>>> RIP: 0010:[<ffffffff8051a97e>]  [<ffffffff8051a97e>] __gdth_interrupt+0x96e/0xb7f
>>> RSP: 0018:ffff81007fbefed8  EFLAGS: 00010086
>>> RAX: 0000000000000000 RBX: ffff81007e0dda68 RCX: 0000000000000002
>>> RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffc20000330000
>>> RBP: ffff81007fbeff08 R08: 0000000000000000 R09: ffff81007f01de70
>>> R10: 0000000000000000 R11: 0000000000000050 R12: ffff810000b10480
>>> R13: ffff810000b104ff R14: ffff81007e214200 R15: 0000000000000009
>>> FS:  0000000000000000(0000) GS:ffff81007f802c80(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>>> CR2: 0000000000000000 CR3: 000000007e643000 CR4: 00000000000006e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process swapper (pid: 0, threadinfo ffff81007fbe6000, task ffff81007fbe4000)
>>> Stack:  0000000000000046 ffff81007e8a93c0 0000000000000000 0000000000000000
>>>  0000000000000018 0000000000000003 ffff81007fbeff18 ffffffff8051ab9f
>>>  ffff81007fbeff48 ffffffff80258cc2 ffffffff8092e300 ffff81007e8a93c0
>>> Call Trace:
>>>  <IRQ>  [<ffffffff8051ab9f>] gdth_interrupt+0x10/0x12
>>>  [<ffffffff80258cc2>] handle_IRQ_event+0x27/0x57
>>>  [<ffffffff8025a055>] handle_fasteoi_irq+0x9c/0xdc
>>>  [<ffffffff8020def0>] do_IRQ+0x88/0xfc
>>>  [<ffffffff80209ffe>] ? default_idle+0x0/0x5f
>>>  [<ffffffff8020b851>] ret_from_intr+0x0/0xa
>>>  <EOI>  [<ffffffff8020a037>] ? default_idle+0x39/0x5f
>>>  [<ffffffff8020a032>] ? default_idle+0x34/0x5f
>>>  [<ffffffff80209ffe>] ? default_idle+0x0/0x5f
>>>  [<ffffffff8020a11c>] ? cpu_idle+0xbf/0xf5
>>>  [<ffffffff806cd973>] ? start_secondary+0x3e0/0x3ef
>>>
>>>
>>> Code: 00 04 eb 15 3c 17 75 11 41 0f b6 c5 48 c1 e0 05 41 80 a4 04 92 02 00 00 fb 41 c7 86 18 01 00 00 00 00 00 00 49 8b 86 c0 00 00 00 <c6> 00 00 e9 92 01 00 00 66 89 43 24 41 8b 84 24 68 02 00 00 89 
>>> RIP  [<ffffffff8051a97e>] __gdth_interrupt+0x96e/0xb7f
>>>  RSP <ffff81007fbefed8>
>>> CR2: 0000000000000000
>>> ---[ end trace e81e561a458e8791 ]---
>>> Kernel panic - not syncing: Aiee, killing interrupt handler!
>>> Rebooting in 5 seconds..
>>> --------------------------------------8<--------------------------------------
>>>
>>> From 2dc63f9f8e61fd1c89f8b4d9b2d174be1c3bfbe2 Mon Sep 17 00:00:00 2001
>>> From: root <root@apollo.bitebene.org>
>>> Date: Sun, 9 Mar 2008 13:25:07 +0100
>>> Subject: 
>>>
>>> This fixes a NULL pointer dereference during execution of Internal commands,
>>> where gdth only allocates scp, but not scp->sense_buffer. The rest of
>>> the code assumes that sense_buffer is allocated, which leads to a kernel
>>> oops e.g. on reboot (during cache flush).
>>>
>>> So we have two choices here:
>>>
>>> a) Allocate the sense_buffer
>>> b) surrounding all accesses to sense_buffer with some if (!internal_command)
>>>
>>> I'm using solution a, as this keeps code simpler.
>>>
>>> Signed-off-by: Sven Schnelle <svens@stackframe.org>
>>> ---
>>>  drivers/scsi/gdth.c |    7 +++++++
>>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
>>> index 27ebd33..0b2080d 100644
>>> --- a/drivers/scsi/gdth.c
>>> +++ b/drivers/scsi/gdth.c
>>> @@ -493,6 +493,12 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
>>>      if (!scp)
>>>          return -ENOMEM;
>>>  
>>> +    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
>>> +    if (!scp->sense_buffer) {
>>> +	kfree(scp);
>>> +	return -ENOMEM;
>>> +    }
>>> +
>>>      scp->device = sdev;
>>>      memset(&cmndinfo, 0, sizeof(cmndinfo));
>>>  
>>> @@ -513,6 +519,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
>>>      rval = cmndinfo.status;
>>>      if (info)
>>>          *info = cmndinfo.info;
>>> +    kfree(scp->sense_buffer);
>>>      kfree(scp);
>>>      return rval;
>>>  }
>> James and linux-scsi CCed.
> 
> Looks fine .. could someone send the patch in an applyable form (i.e.
> not quoted).
> 
>> James it looks reasonable. It's a fallout from the sense_buffer separation patches.
>> Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
>>
>> I will submit solution b) above as part of my sense handling patchset.
> 
> Um, that looks like it will be a bit nasty, so the simpler fix is
> probably the better one (even if the sense buffer simply gets ignored).
> 
> The best long term fix for GDTH is probably to make it behave more like
> a standard raid driver, so it includes a translation layer from scsi
> commands to gdth commands and then the __gdth_execute() can be
> reformulated as gdth command injection and we don't have to muck about
> with upper layer objects like SCSI commands.
> 
> James
> 
> 

James Hi
There is one more such bug in USB's isd200 driver. Below is a patch for 
rc-fixes.

Alen && Matthew Dharm hi. (If I missed someone please send it his way)

I would like to fix this better by calling scsi_get/put_command but there is 
something fundamental that bothers me with isd200 driver. I can see that 
an isd200_info struct is allocated and put on a struct us_data->extra. But 
as I understand the code, the struct us_data is associated with a scsi_host 
not a scsi_device. Are we guarantied that we have only one scsi_device 
per host at all times?

If not than the resources in isd200_info that are related to a request_queue 
and are used from a .queuecommand code-path are not thread safe. (Like the
srb member)

If Yes, then where in the code initialization sequence is the earliest place I
can get to a scsi_device. I could do that on first call to .queuecommand but
I would rather do it in a place that I could use GFP_KERNEL for allocation
of the extra command? (Same question on the tear down of the scsi_device)

(And one more stupid question. Why does isd200_init_info allocates the info 
structure but the isd200_free_info_ptrs does not free it, it kind of
limits the way it can be allocated, no?)

Please advise.

Here is the patch
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 11 Mar 2008 17:23:06 +0200
Subject: [PATCH] isd200: Allocate sense_buffer for hacked up scsi_cmnd

Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
own struct scsi_cmnd like here isd200, must also take care of their own
sense_buffer.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 2ae1e86..9eb2cdf 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -294,6 +294,7 @@ struct isd200_info {
 	unsigned char MaxLUNs;
 	struct scsi_cmnd srb;
 	struct scatterlist sg;
+	u8*	sense_buffer;
 };
 
 
@@ -1469,6 +1470,7 @@ static void isd200_free_info_ptrs(void *info_)
 	if (info) {
 		kfree(info->id);
 		kfree(info->RegsBuf);
+		kfree(info->sense_buffer);
 	}
 }
 
@@ -1494,11 +1496,14 @@ static int isd200_init_info(struct us_data *us)
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
-		if (!info->id || !info->RegsBuf) {
+		info->sense_buffer = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		if (!info->id || !info->RegsBuf || !info->sense_buffer) {
 			isd200_free_info_ptrs(info);
 			kfree(info);
 			retStatus = ISD200_ERROR;
 		}
+		else
+			info->srb.sense_buffer = info->sense_buffer;
 	}
 
 	if (retStatus == ISD200_GOOD) {
-- 
1.5.3.3



