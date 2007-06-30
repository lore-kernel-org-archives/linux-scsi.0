From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Low-level reformat with different sector size: ?
Date: Fri, 29 Jun 2007 21:47:30 -0400
Message-ID: <4685B632.5030604@torque.net>
References: <f638pe$it6$1@sea.gmane.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45534 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXF3Br5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2007 21:47:57 -0400
In-Reply-To: <f638pe$it6$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-scsi@vger.kernel.org

Matthias Urlichs wrote:
> Hello,
> 
> Yesterday I managed to buy a couple of SCA disks with a sector size of ...
> *drumroll* ... 524.
> 
> What's the easiest way to re-format these to use 512 bytes?
> Preferably without screwing up anything else on these things?
> 
> I tried sformat, which reported some rather broken
> data:
> 
> # sformat
> sformat SCSI format/analysis/repair utilities
> Release 3.4, Copyright J. Schilling
> 
> scsibus0:
>         0,0,0     0) *
>         0,1,0     1) *
>         0,2,0     2) 'S330L  !' 'C0
>                                   P' '' Disk
>         0,3,0     3) *
>         0,4,0     4) 'S330L  !' 'C0' 'P?' Disk
>         0,5,0     5) 'S330L  !' 'C0`P#  ' '?' Disk
>         0,6,0     6) *
>         0,7,0     7) *
> Select target -1 (2 - 5)/<cr>:2
> scsibus0 target 2:
>         0,2,0     0) 'S330L  !' 'C0
>                                   P' '' Disk
>         0,2,1     1) *
>         0,2,2     2) *
>         0,2,3     3) *
>         0,2,4     4) *
>         0,2,5     5) *
>         0,2,6     6) *
>         0,2,7     7) *
> Select lun -1 (0 - 0)/<cr>:0
> scsibus0 target 2 lun 0
> Device type    : Disk
> Version        : 7
> Response Format: 1
> Vendor_info    : 'S330L  !'
> Identifikation : 'C0
>                    P'
> Revision       : ''
> Device seems to be: Generic CCS Disk.
> sformat: PANIC Sectorsize.
> #
> 
> ... Oops?
> 
> Kernel: 2.6.22 (Ubuntu development)

Matthias,
Have a look at sg_format in the sg3_utils package.

Assuming you want to reformat /dev/sdc to 512 byte sector
size the you could use:
    sg_format --format --size=512 /dev/sdc

See sg_format's man page for more information.

Doug Gilbert


