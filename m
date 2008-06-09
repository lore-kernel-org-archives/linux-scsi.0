From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Reallocating sd device
Date: Mon, 09 Jun 2008 14:54:43 -0500
Message-ID: <1213041283.3508.66.camel@localhost.localdomain>
References: <484D8935.70905@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53538 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604AbYFITyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 15:54:46 -0400
In-Reply-To: <484D8935.70905@sauce.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-06-10 at 07:49 +1200, Richard Scobie wrote:
> Testing a 16 SATA drive (/dev/sd[c-r]1), md RAID, with drives installed
> in a hotswap SAS/SATA enclosure.
> 
> Failed out /dev/sdd1, ejected the drive from the enclosure, reinserted
> it and the system added it back as /dev/sds:
> 
> Jun  9 11:24:37 flash2 kernel: mptsas: ioc0: removing sata device,
> channel 0, id 30, phy 5
> Jun  9 11:24:37 flash2 kernel: sd 4:0:1:0: [sdd] Synchronizing SCSI cache
> 
> Jun  9 11:24:37 flash2 kernel: sd 4:0:1:0: [sdd] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> 
> Jun  9 11:26:38 flash2 kernel: mptsas: ioc0: attaching sata device,
> channel 0, id 30, phy 5
> 
> Jun  9 11:26:38 flash2 kernel: scsi 4:0:17:0: Direct-Access     ATA
>   WDC WD7500AYYS-0 4G30 PQ: 0 ANSI: 5
> 
> Jun  9 11:26:38 flash2 kernel: sd 4:0:17:0: [sds] 1465149168 512-byte
> hardware sectors (750156 MB)
> 
> Rebooting shows the offline drive back as /dev/sdd.
> 
> Is there a safe, (OK to do on a mounted, active array), way of changing
> the sds back to sdd, prior to adding it back into the array, without
> having to reboot?

Not really ... relying on a specific sdX name has been deprecated for a
while.  To ensure absolute ordering, you should be using the device by
id or by label.

James

