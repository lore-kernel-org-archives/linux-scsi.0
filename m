From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Wed, 13 Sep 2006 09:11:11 -0500
Message-ID: <1158156671.3462.7.camel@mulgrave.il.steeleye.com>
References: <20060909210856.GC21263@stat.unipd.it>
	 <20060910135631.GD29775@parisc-linux.org>
	 <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net>
	 <20060911064008.GA26293@stat.unipd.it>
	 <1157994026.3470.3.camel@mulgrave.il.steeleye.com>
	 <20060912064514.GA28121@stat.unipd.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:53154 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750850AbWIMOLR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 10:11:17 -0400
In-Reply-To: <20060912064514.GA28121@stat.unipd.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alberto Cammozzo <mmzz@stat.unipd.it>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-09-12 at 08:45 +0200, Alberto Cammozzo wrote:
> novantatre:~# dmesg
> [...]
> st 0:0:5:0: Attached scsi generic sg0 type 1
> ch 0:0:5:1: Attached scsi generic sg1 type 8
> sd 1:0:0:0: Attached scsi generic sg2 type 0
> scsi 1:0:15:0: Attached scsi generic sg3 type 3
> scsi 1:1:9:0: Attached scsi generic sg4 type 3
> scsi 1:2:8:0: Attached scsi generic sg5 type 3
> scsi 2:0:0:0: Attached scsi generic sg6 type 0
> scsi 2:0:1:0: Attached scsi generic sg7 type 0
> scsi 2:0:2:0: Attached scsi generic sg8 type 0
> scsi 2:0:3:0: Attached scsi generic sg9 type 0

This shows it found LUNS 0 1 2 3

> sd 3:0:0:0: Attached scsi generic sg10 type 0
> 
> novantatre:~# sg_luns -v sg6
> sg_luns: open error: sg6: No such file or directory
> novantatre:~# sg_luns -v /dev/sg6
>     report luns cdb: a0 00 00 00 00 00 00 00 04 00 00 00 
>     report luns: requested 1024 bytes but got 32 bytes
> Lun list length = 24 which imples 3 lun entries
> 
> Output response in hex
>  00     00 00 00 18 00 00 00 00  00 01 00 00 00 00 00 00                    
>  10     00 03 00 00 00 00 00 00  00 04 00 00 00 00 00 00                    
> Report luns [select_report=0]:
>     0001000000000000
>     0003000000000000
>     0004000000000000

This says the system only has three luns: 1 3 4 (i.e. no 2)

So something really strange is going on here ... The linux code should
have executed a probe and add luns for the contents of report lun, which
should have found the correct set, unless something went wrong during
the reporting.

Can you post the full dmesg from the time the Emulex is detected to the
time sg attaches?  report luns is supposed to issue a failure message if
something goes wrong (additionally, using the latest -mm would be
helpful since that prints enhanced inquiry information from scsi-misc).

James


