From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [BUG] Fusion MPT 2.6.8 driver and multi LUN device
Date: Tue, 01 Mar 2005 20:47:41 +1000
Message-ID: <4224484D.5090900@torque.net>
References: <42243E15.5070502@guzu.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:13785 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261856AbVCAKqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 05:46:51 -0500
In-Reply-To: <42243E15.5070502@guzu.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@guzu.net
Cc: linux-scsi@vger.kernel.org

Manu wrote:
> 
> Under a fresh Mandrake 10.1 with a 2.6.8 kernel, the Fusion MPT driver 
> do recognize the HP tape autoloader. The autoloader is composed of tape 
> drive (on LUN 0) and the changer (on LUN 1).
> The message comes from scsi_scan.c :
>     printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
>            " than allowed by the host adapter\n",
>            devname, lun);
> 
> Playing a bit with printk it looks like the num_luns is well computed 
> (the value is 2), but the 2 LUN values seems to be miss-aligned.
> When displaying the 8 bytes raw buffer (through lunp) in the loop :
>  00 00 00 00 00 00 00 00
>  00 00 01 00 00 00 00 00
> 
> I think the second buffer should be :
>  00 01 00 00 00 00 00 00
> 
> Which, when computed, gives 1 instead of 16777216 (0x1000000).
> 
> The autoloader works like a charm under the 2.4.27 kernel provided with 
> the Mandrake 10.1.
> 
> - Emmanuel Varagnat
> 
> PS: the 2 harddrives in RAID1 are well working, even with the 2.6.8 kernel.

Perhaps you could try the sg_luns utility from the
sg3_utils package ( http://www.torque.net/sg )
with either the 2.4 or 2.6 kernel. It should be sent
to lun 0 (i.e. the tape drive), for example:
   sg_luns /dev/st0

[I'm not sure whether st devices support the SG_IO
ioctl in lk 2.6.8; they do now. If that fails use the
sg_map utility to find the corresponding sg device and
apply sg_luns to that sg device.]

If the sg_luns response shows an offset result for the
tape changer (lun 1), then you should be looking to see
if HP has new firmware for that tape autoloader.

The difference between lk 2.4 and lk 2.6 is that 2.6
uses the REPORT LUNS SCSI command whereas 2.4 just polled
the possible luns (with INQUIRY).

Doug Gilbert
