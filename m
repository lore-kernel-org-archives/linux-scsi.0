From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Adaptec 2200S with aacraid won't do 64-bit
Date: Tue, 22 Feb 2005 15:51:05 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BCDC69E@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:64430 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261239AbVBVUvI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 15:51:08 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Wesemann <timuel@voicenet.com>, linux-scsi@vger.kernel.org

Define 64-bit, and how do you making the declaration that it is not
supported.

64-bit data transfers are performed by Hardware and can not be
instrumented. Only a PCI trace will know.

64-bit dma addresses is supported, but the card's registers must reside
in the 32-bit space regardless (Memory at f0000000 32-bit prefetchable
is for the register set, not DMA). The driver does not turn on DAE until
there is more than 4G of memory in the system to use the more optimal 32
bit SG elements.

64-bit LBAs are not supported in currently released Firmware.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Tim Wesemann
Sent: Tuesday, February 22, 2005 3:27 PM
To: linux-scsi@vger.kernel.org
Subject: Adaptec 2200S with aacraid won't do 64-bit

I apologize in advance if I'm sending this to the wrong place, but I see

alot of people with adaptec cards and aacraid experience in the archives
and 
was also pointed here by the README in the adaptec aacraid-1.1.5
source...

I'm using aacraid for my adaptec 2200S with a RAID5 configuration, in a 
PCI-X slot and I've spent two full days now trying to get it to run in
64 
bit mode to no avail. I've tried 2.4.29 with stock aacraid as well as
2.6.9 
with stock aacraid and also adaptec's aacraid-1.1.5 with 2.6.9. I am
also 
running firmware version 7349 on the 2200S.

Here's my lspci output:

02:01.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
        Subsystem: Adaptec 2200S (Vulcan)
        Flags: bus master, 66Mhz, slow devsel, latency 32, IRQ 24
        Memory at f0000000 (32-bit, prefetchable) [size=64M]
        Expansion ROM at <unassigned> [disabled] [size=32K]
        Capabilities: [80] Power Management version 2

The on-board (non-raid) AIC-7902 controller on my SuperMicro P4SC8 
motherboard runs in 64-bit mode without a hitch but I really need to use

this 2200S...

Would anyone mind beating me with the clue stick or pointing me in the
right 
direction? I need throughput!

TIA.

--
Tim Wesemann 

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
