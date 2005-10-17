From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Adaptec SAS integration notes
Date: Mon, 17 Oct 2005 08:35:08 +0200
Message-ID: <4353461C.3090505@s5r6.in-berlin.de>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com> <43510FEA.6070109@s5r6.in-berlin.de> <4351A743.3040105@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57506 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751345AbVJQGh6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 02:37:58 -0400
In-Reply-To: <4351A743.3040105@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net, ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org

Douglas Gilbert wrote:
> Stefan Richter wrote:
>>usb-storage and sbp2 already implement the leanest possible HCIL mapping
>>(1 logical unit to 1 H).
> 
> Stefan,
> Here is a counter example from a USB multicard reader:
[...]
> That is 4 logical units to 1 host. [Since I'm often
> critical of USB mass storage device SCSI support, in
> this case it is good to see some thought went into the
> INQUIRY string namings.]

Indeed. Thanks for the correction. It is 1 target = 1 H then. BTW I 
prefer to call it "H" or "scsi_host", not "host". :-)

Sbp2 currently transforms the logical unit number into scsi core's "L" 
too but allocates a separate H for each logical unit anyway AFAICS. That 
is certainly not very logical. But on the other hand, real target names 
and logical unit numbers are not exposed directly to userspace yet (or 
is there a direct, transport-independent way?), so why bother with more 
refined mapping for now.

> There is an argument for the SCSI subsystem to keep
> at least the "l" part of the maligned <h:c:i:l> tuple
> because the "l" part really is SCSI (and should be u8[8]).
> SATA-II is beginning to struggle along that path as well
> with port multipliers of up to 15 devices. SCSI luns
> can easily cope with that.

Absolutely. There should be "logical units" (with proper LUNs) which 
belong to "targets" (with proper target names exposed to userspace).

The concepts of "host adapter" and "channel" may exist at the level of 
transport/ interconnect drivers, but they may be absent on any higher level.
-- 
Stefan Richter
-=====-=-=-= =-=- =---=
http://arcgraph.de/sr/
