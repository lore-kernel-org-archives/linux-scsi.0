From: Michael Reed <mdr@sgi.com>
Subject: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency problem
Date: Mon, 12 Dec 2005 15:00:59 -0600
Message-ID: <439DE50B.90007@sgi.com>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:26074 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1751277AbVLLVBG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 16:01:06 -0500
In-Reply-To: <439A17BE.5000904@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Joosten <michael.joosten@c-lab.de>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi@vger.kernel.org

(The subject of this email isn't quite accurate.  It's not
a pci coherency problem, it's a pio write ordering problem.)

I've been asked to pass along the suggestion that "mmiowb"
should be implemented for the platform.

Given that I've been unable to unearth the chipset documentation
for the Vis WS, I can only hope that you've got some good ideas
on how this might be accomplished.

I agree that replacing the pio read which flushed the preceeding
pio write with mmiowb() is what has likely broken the driver.  If you
restore them,  please make it either mmiowb or pio read, but not both.

Perhaps something like this?  It's not the most elegant solution....

--- old/drivers/scsi/qla1280.c        2005-12-05 12:39:36.000000000 -0600
+++ new/drivers/scsi/qla1280.c      2005-12-12 14:42:11.146215122 -0600
@@ -401,6 +401,10 @@
 #include "ql1280_fw.h"
 #include "ql1040_fw.h"

+#ifdef CONFIG_X86_VISWS
+  #undef mmiowb
+  #define mmiowb() RD_REG_WORD(&ha->iobase->id_l)
+#endif

 /*
  * Missing PCI ID's



It compiles but I have no platform against which to test it.

If I come up with any doc, I'll pass it along.  Don't hold your breath.


Mike


Michael Reed wrote:
> FWIW, SGI uses the 1280 driver with the 12160 it ships standard
> on its IA64 Altix platforms.  While there are deficiencies in
> the driver (most drivers, for that matter), it's good enough.
> 
> I'm asking around to see if anyone remembers the issues with the
> VISW.
> 
> (Realized I didn't reply to list, only to Mr. Joosten.)
> 
> Mike
> 
> 
> Michael Joosten wrote:
>>Hello,
>>since last week I'm trying to bring the current version of 2.6.12+ in
>>working order on that almost abandoned SGI 320 Visual Workstation. This
>>beastlet also used have a QLA1080 as SCSI controller, which is actually
>>the only supported one to boot from.
>>I'm not sure if this is just a SGI320 problem (there seems to be two bus
>>bridges in use: PCI: Lithium bridge A bus: 1, bridge B (PIIX4) bus: 0)
>>or now a general problem for all platforms not implementing a mmiowb()
>>write barrier operation, but since 2.6.11 the qla1280.c driver gets
>>severly stuck after a few minutes of heavy use:
>>
>>zapp kernel: qla1280: ISP invalid handle
>>
>>and then usually the kernel hangs hard or the SCSI subsystem is
>>inoperable.
>>Last year Jesse Barnes published a patch introducing I/O space write
>>barrier instructions especially for IA64 and MIPS multiprocessors. In
>>that patch some PCI posted write flushs were replaced by mmiowb()
>>(platform specific write barrier instruction), and at least for
>>the SGI VisWS, this was one replacement too much.... I'm aware that the
>>Visws PCI controller (at least the Lithium chip resp. for PCI 64 bus)
>>reused
>>parts from the O2 and sufferes the same problem of lacking cache
>>coherency, but
>>I wonder now if the qla1280.c is actually stable anymore in kernels
>>after 2.6.10 (last version with the PCI write flushes in
>>qla1280_64/32bit_start_scsi() ) and non-x86 platforms.
>>
>>I've just tried qla1280.[ch] from a more recent version than 2.6.12.4,
>>namely 2.6.14.3, and have the same problem again (only worse, but there
>>has been some patches in qla1280.c regarding error recovery recently,
>>and now the kernel just hangs...), unless I add the one/two RD_REG_WORD()
>>lines again.
>>To repeat: Has there been any notion of problems with qla1280.c recently,
>>last known good version in 2.6.10 is from Xmas last year.
>>
>>I can run tests also on a Intel dual PII server board with that QLA1080
>>HBA, but not now.
>>
>>Regards, Michael
>>
>>
>>------------------------------------------------------------------------
>>
>>--- ../linux-2.6.14.3/drivers/scsi/qla1280.c-	2005-11-24 23:10:21.000000000 +0100
>>+++ ../linux-2.6.14.3/drivers/scsi/qla1280.c	2005-12-07 21:27:42.000000000 +0100
>>@@ -3236,6 +3236,7 @@
>> 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
>> 	/* Enforce mmio write ordering; see comment in qla1280_isp_cmd(). */
>> 	mmiowb();
>>+	RD_REG_WORD(&reg->mailbox4);
>> 
>>  out:
>> 	if (status)
>>@@ -3504,6 +3505,7 @@
>> 	WRT_REG_WORD(&reg->mailbox4, ha->req_ring_index);
>> 	/* Enforce mmio write ordering; see comment in qla1280_isp_cmd(). */
>> 	mmiowb();
>>+	RD_REG_WORD(&reg->mailbox4);
>> 
>> out:
>> 	if (status)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
