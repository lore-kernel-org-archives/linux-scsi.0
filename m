From: Douglas Gilbert <dougg@torque.net>
Subject: Re: improve sg_luns output for iscsi
Date: Tue, 06 Mar 2007 14:27:33 -0500
Message-ID: <45EDC0A5.804@torque.net>
References: <20070306180428.GA16826@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51086 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbXCFT21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2007 14:28:27 -0500
In-Reply-To: <20070306180428.GA16826@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org

Olaf Hering wrote:
> Upcoming IBM pSeries firmware can boot from iscsi. To configure the
> openfirmware boot-device string, we need to construct a correct
> devicepath. This path includes the lun. Its currently not 100% clear
> how exactly this lun value has to look like.
> 
> sg_luns may be the tool to get the value. But its current output is not
> parseable by scripts. It even gives the same output for two different
> scsi devices:
> 
> girgendwas:~ # lsscsi
> [0:0:0:0]    disk    DGC      RAID 5           0219  /dev/sda
> [0:0:0:1]    disk    DGC      RAID 5           0219  /dev/sdb
> [0:0:0:2]    disk    DGC      RAID 5           0219  /dev/sdc
> [0:0:0:3]    disk    DGC      RAID 5           0219  /dev/sdd
> girgendwas:~ # sg_luns -V
> sg_luns: version: 1.05 20060127
> girgendwas:~ # sg_luns /dev/sdd
> Lun list length = 32 which imples 4 lun entries
> Report luns [select_report=0]:
>     0000000000000000
>     0001000000000000
>     0002000000000000
>     0003000000000000
> girgendwas:~ # sg_luns /dev/sdc
> Lun list length = 32 which imples 4 lun entries
> Report luns [select_report=0]:
>     0000000000000000
>     0001000000000000
>     0002000000000000
>     0003000000000000
> 
> Is it possible to print the lun only for the requested scsi device?

Olaf,
sg_luns is an application client driving the SCSI
REPORT LUNS command. It is a "trick" SCSI command
since even though it addresses a logical unit, it
is really the target that replies (as it is the target
that knows about the sibling logical units) ***.
The REPORT LUNS response gives no indication which
(if any) 64 bit lun was addressed.

Now I would not want to break the link between sg_luns
and the SCSI REPORT LUNS command. Adding an extra
parameter to try and find the lun associated with the
file descriptor has a few problems (from my point
of view):
   - it would be OS specific (sg_luns isn't currently)
   - within Linux there are different mechanisms in
     the 2.4 and 2.6 series kernels.

In your example above a combination of lsscsi and sg_luns
gives the answer ("0003000000000000") but lsscsi is
linux 2.6 series specific. sg_scan would probably work
as a replacement for lsscsi (and sg_scan also works in the
lk 2.4 series (and Windows)).


To address the parsability of sg_luns output, I recently
added a '--quiet' option to suppress the extraneous
output.


In summary sg_luns is probably not what you want!
What about the lu _name_? For iSCSI the lu should
yield a world wide unique "SCSI name" designator
in the device identification VPD page (see SPC-4
and SAM-4 Annex A; the iSCSI standard woffles in
this area).


*** a better way to get a target to report its active
luns is to use the REPORT LUNS well known logical
unit but hardly anyone implements that.

Doug Gilbert


