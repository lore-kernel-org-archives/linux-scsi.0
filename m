From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: disable volume status check for older controller
Date: Fri, 4 Aug 2017 18:36:59 +0200
Message-ID: <5be60e11-a3e7-14d1-0a67-db4fe909f004@suse.de>
References: <1501686356-56888-1-git-send-email-hare@suse.de>
 <alpine.LRH.2.20.1708041923430.29380@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34217 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752225AbdHDQhB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 12:37:01 -0400
In-Reply-To: <alpine.LRH.2.20.1708041923430.29380@math.ut.ee>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/04/2017 06:26 PM, Meelis Roos wrote:
>> Older Controller might not support volume status, so disable
>> it if 'hpsa_allow_any' is present.
> 
> It makes my DL380G4 boot with hpsa.hpsa_allow_any=1 and it seems to 
> work. Howevere, there are multiole verbose dmesg entries about failing 
> things:
> 
Hehe. How cool is that?

>     0.267224] HP HPSA Driver (v 3.4.18-0)
> [    0.267351] hpsa 0000:04:03.0: unsupported board ID: 0x40910e11
> [    0.267494] hpsa 0000:04:03.0: unsupported board ID: 0x40910e11
> [    0.267695] hpsa 0000:04:03.0: PCI IRQ 51 -> rerouted to legacy IRQ 19
> [    0.267889] hpsa 0000:04:03.0: Physical aborts not supported
> [    0.268036] hpsa 0000:04:03.0: Logical aborts not supported
> [    0.268163] hpsa 0000:04:03.0: HP SSD Smart Path aborts not supported
> [    0.448240] scsi host0: hpsa
> [    0.452228] hpsa 0000:04:03.0: report luns requested format 2, got 0
> [    0.453950] hpsa 0000:04:03.0: hpsa0: hpsa_update_device_info: can't get device id for host 0:C0:T0:L0       Direct-Access           MAN3735MC       
> [    0.454312] hpsa 0000:04:03.0: SCSI status: LUN:0000000000000000 CDB:26000000000015000801000000000000
> [    0.454525] hpsa 0000:04:03.0: SCSI Status = 02, Sense key = 0x05, ASC = 0x3a, ASCQ = 0x00
Curious. CDB 26 is a vendor specific command, and the controller
responds with 'Medium not present'.
Will be checking what's happening here.

> Among these, the following show up red in dmesg:
> 
> report luns requested format 2, got 0
> hpsa0: hpsa_update_device_info: can't get device id for host 0:C0:T0:L0       Direct-Access           MAN3735MC
> hpsa0: hpsa_update_device_info: can't get device id for host 0:C0:T-1:L-1     Direct-Access           MAP3735NC
> report luns requested format 2, got 0
> 
Hmm. Looking into it.

But thanks for testing!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
