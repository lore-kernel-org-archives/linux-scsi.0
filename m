From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDDreentrancy
Date: Mon, 26 Aug 2002 17:33:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6A9EC7.11815196@splentec.com>
References: <OF7CB8B7A6.7888F8DC-ONC1256C21.005CA55A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g7QLXuH08520
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 17:33:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Aron Zeh wrote:
> 
> I currently don't know of a way that SCSI devices (LUNs) generate hotplug
> notifications by. (FC sends RSCNs and other nasty stuff for ports, which
> are one level higher up. I don't think reconfiguring the LUNs behind a port
> would generate any message, would it?)

Unit Attention condition should be generated.

Some (all?) transports allow for the target sending an asynchronous
message to the initiator, but in SAM-3, an initiator being
a real such and a target being a real target, the target is the passive
device and the initiator is the active one, thus Unit Attention
condition is generated (SAM-3, 5.8.5).

> Even of messages are generated, they'd probably differ according to the
> underlying hardware. Would HBA drivers have to catch them and use more
> generic callbacks to tell the SCSI stack?

Forget about HBAs. In order to get anything working it has to be
at SAM-3 level.

It's ok when we plug into the PCI bus, but what happens
when SAN box number XXXX comes up and you're connected to
the farm over with iSCSI. How are you to know?...

That is, we cannot assume that it's an HBA there anymore,
just as we stopped assuming that the HBA is SPI, some time ago.
(It could be FCP, iSCSI, etc.)

-- 
Luben
