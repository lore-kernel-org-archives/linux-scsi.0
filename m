From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Very slow writes with mptsas
Date: Wed, 20 Jun 2007 13:30:39 -0400
Message-ID: <4679643F.3010309@torque.net>
References: <20070605161620.GB6519@bloch.config> <20070612141511.GB4347@bloch.config>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38877 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbXFTRav (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2007 13:30:51 -0400
In-Reply-To: <20070612141511.GB4347@bloch.config>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bloch@verdurin.com
Cc: linux-scsi@vger.kernel.org, linux-precision@dell.com

bloch@verdurin.com wrote:
> On Tue, 05 Jun 2007, bloch@verdurin.com wrote:
> 
>> Hello
>>
>> I'm seeing very slow writes on a Dell Precision 690 with the Dell SAS5
>> adapter, serving a RAID1 array of SATA-II disks.
>>
>> It's very similar to the problem in FreeBSD, described here:
>>
>> http://unix.derkeiler.com/Mailing-Lists/FreeBSD/stable/2007-03/msg00756.html
>>
>> I'm running FC6 with the latest kernel.
>>
>> Reads are quite fast, writes terribly slow.
>>
> 
> Thanks to all who replied to this query, especially the very detailed
> response from Eric Moore at LSI.
> 
> The first important facet is that we need to operate on the two hidden
> physical disks, not the RAID device.  lsscsi differentiates them:
> 
> # lsscsi
> [0:0:0:0]    disk    ATA      WDC WD5000KS-75M 2E08  -       
> [0:0:1:0]    disk    ATA      HDS725050KLA360  AB5A  -       
> [0:1:0:0]    disk    Dell     VIRTUAL DISK     1028  /dev/sda
> 
> sg_map gives the generic device numbers:

Using 'lsscsi -g' would also give you the generic device
numbers.

It is interesting that the above "ATA" disks do not have
corresponding /dev/sd* device names.

> # sg_map -i -x
> /dev/sg0  0 0 0 0  0  ATA       WDC WD5000KS-75M  2E08
> /dev/sg1  0 0 1 0  0  ATA       HDS725050KLA360   AB5A
> 
> The write cache can then be enabled using sdparm:
> 
> sdparm -s WCE=1 -S /dev/sg0
> 
> and the result checked with
> 
> # sdparm -g WCE /dev/sg1
> /dev/sg1: ATA       HDS725050KLA360   AB5A
> WCE         1  [cha: y]
> 
> This seems to make the write performance much better.

Good.

> The question for Dell is why their version of the BIOS doesn't set the
> write cache in the first place or allow it to be altered by the user.

The mechanism for doing this was only formalized recently
with the SAT standard, so it may take a while for BIOSes
and other infrastructure to catch up.

Doug Gilbert


