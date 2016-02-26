From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] sd: add missing scenario for sd_config_write_same
Date: Fri, 26 Feb 2016 17:12:36 -0500
Message-ID: <yq1ziunf7e3.fsf@sermon.lab.mkp.net>
References: <56d0c09d.5a46620a.e4c6.0855@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18671 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbcBZWMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 17:12:51 -0500
In-Reply-To: <56d0c09d.5a46620a.e4c6.0855@mx.google.com> (tom's message of
	"Sat, 27 Feb 2016 05:16:06 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: linux-scsi@vger.kernel.org

>>>>> "tom" == tom ty89 <tom.ty89@gmail.com> writes:

Tom,

tom> [root@localhost ~]# sg_opcodes /dev/sdb > /dev/null Report
tom> supported operation codes: Illegal request, invalid opcode

tom> [root@localhost ~]# sg_vpd -p bl /dev/sdb | grep 'write same'
tom> Maximum write same length: 0x0 blocks

"A MAXIMUM WRITE SAME LENGTH field set to zero indicates that the device
server does not report a limit on the number of logical blocks that it
allows to be unmapped or written in a single WRITE SAME command."

I.e. that parameter says nothing about whether WRITE SAME is supported
or not.

tom> [root@localhost ~]# cat /sys/block/sdb/queue/write_same_max_bytes
tom> 33553920

That's correct behavior. Unless otherwise noted we default to issuing 32
MB WRITE SAME commands and will subsequently turn it off if the drive
returns a failure.

WRITE SAME support on storage devices predates RSOC, most of the common
VPD pages, etc. So there is no reliable value we can key off of to
determine whether a drive supports the command. And because a block
count of 0 is interpreted as "the entire device" we can't issue a
non-destructive WRITE SAME to determine whether device supports it or
not. Consequently we are stuck with assuming it works unless RSOC is
supported or the device sits behind a SATL.

Do you have a particular drive that is causing problems? We could quirk
it or add additional heuristics in addition to the ATA Information VPD.

-- 
Martin K. Petersen	Oracle Linux Engineering
