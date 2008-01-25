From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: sd incorrectly reports write cache disabled on cache-capable
	drives/controllers
Date: Fri, 25 Jan 2008 15:15:20 -0600
Message-ID: <1201295720.3119.51.camel@localhost.localdomain>
References: <200801252159.20858.yallaone@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56187 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602AbYAYVPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 16:15:25 -0500
In-Reply-To: <200801252159.20858.yallaone@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Halim Issa <yallaone@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-01-25 at 21:59 +0100, Halim Issa wrote:
> This is my first post to any of the vger lists. I have tried to comply with 
> the list recommendations and be specific while to the point. If anything is 
> missing, kindly let me know.
> 
> I am having trouble getting the scsi-subsystem on an IBM x336 eServer with LSI 
> Logic53c1030 SCSI RAID controller to recognize the write cache on my 
> harddrives/controller. It reports:
> 
> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support 
> DPO or FUA.

This statement is really simply reporting what the INQUIRY data of the
device is telling it ... we don't actually massage the data in any way.

However ... The INQUIRY strings for this device are:

scsi 0:0:0:0: Direct-Access     LSILOGIC 1030 IM          1000 PQ: 0 ANSI: 2

So it's basically a RAID-1 volume manufactured by the LSI, not your
actual device.  The INQUIRY strings returned by such RAID volumes
usually bear no relation to the underlying devices.

The "cache" hear would be referring to the RAID controller cache, not
the disk cache.  Likewise DPO and FUA refer to what the RAID controller
can support, not the disk.

James


