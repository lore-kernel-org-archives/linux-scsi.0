From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: megaraid aborting problem (RHEL 3WS)
Date: Thu, 9 Sep 2004 07:49:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040909124934.GB30470@lists.us.dell.com>
References: <1094731822.27029.52.camel@whirl.lab7.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:45400 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S262418AbUIIMt4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2004 08:49:56 -0400
Content-Disposition: inline
In-Reply-To: <1094731822.27029.52.camel@whirl.lab7.lan>
List-Id: linux-scsi@vger.kernel.org
To: Stas Nikiforov <stas@itam.nsc.ru>
Cc: linux-scsi@vger.kernel.org

On Thu, Sep 09, 2004 at 07:10:22PM +0700, Stas Nikiforov wrote:
> Hi,
> I have a RHEL 3WS (RocksCluster) distribution
> (kernel 2.4.21-15ELsmp) with megaraid2 2.10.3 driver.
> The following is reported by dmesg.
> 
>     megaraid: v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
>     megaraid: [713G:G117] detected 1 logical drives.
>     scsi0 : LSI Logic MegaRAID 713G 254 commands 16 targs 4 chans 7 luns
>     blk: queue c3620e18, I/O limit 4294967295Mb (mask
> 0xffffffffffffffff)
>     scsi0: scanning scsi channel 0 for logical drives.
>     Vendor: MegaRAID  Model: LD 0 RAID5 1192G  Rev: 713G
>     Type:   Direct-Access                      ANSI SCSI revision: 02
> 
> Under heavy io I get the following messages reported by dmesg.
> Could somebody tell me what is going wrong and what should I do next?

The hardware controller firmwre took a long long time to respond to
the driver, if it responded at all.  The SCSI mid-layer started timing
out requests, and eventually tried to reset the controller (but it
can't really do that).

You may want to try the newer driver that's on ftp.lsil.com and merged
into kernel.org to see if that helps, and make sure your firmware is
completely up-to-date.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
