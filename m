From: Matt_Domsch@Dell.com
Subject: RE: Megaraid driver on 2.5.45 problem with large devices
 enabled.
Date: Fri, 1 Nov 2002 11:21:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20BF5713E14D5B48AA289F72BD372D68C1EAD5@AUSXMPC122.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: shemminger@osdl.org
Cc: linux-megraid-devel@dell.com, linux-scsi@vger.kernel.org

> 		cyls = capacity/(heads * sectors);
> 
> which causes gcc to call the helper function which the kernel doesn't
> pull in.  Probably this can be fixed by casting (if device 
> can't support huge disks) or changing the math.

Good catch, thanks.  Right, capacity should be cast to (unsigned long) just
as is done in megaraid_biosparam().  These are only used to determine BIOS
CHS translations, which aren't defined for disks as big as would overflow a
32-bit long anyhow, so I think we're safe for the next few years.  Just
don't try booting an x86 box off a >2TB disk. :-)

I've committed this to my BK trees at
http://mdomsch.bkbits.net/linux-2.5-megaraid and linux-2.5-megaraid2, but my
test machine is apart for upgrades today, and I haven't gotten 2.5.45 to
boot on anything yet anyhow - panic dealing with the initrd that has been
reported on l-k recently.

Thanks,
Matt

--
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

