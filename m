From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [LSF/MM ATTEND] Online Logical Head Depop and SMR disks chunked
 writepages
Date: Mon, 22 Feb 2016 19:56:40 -0800
Message-ID: <56CBD878.4070600@sandisk.com>
References: <05353ADC-601C-412D-80E2-1F1972324A37@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0081.outbound.protection.outlook.com ([65.55.169.81]:17201
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756890AbcBWD5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 22:57:05 -0500
In-Reply-To: <05353ADC-601C-412D-80E2-1F1972324A37@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>, "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matias Bjorling <m@bjorling.me>

On 02/22/16 18:56, Damien Le Moal wrote:
> 2) Write back of dirty pages to SMR block devices:
>
> Dirty pages of a block device inode are currently processed using the
> generic_writepages function, which can be executed simultaneously
> by multiple contexts (e.g sync, fsync, msync, sync_file_range, etc).
> Mutual exclusion of the dirty page processing being achieved only at
> the page level (page lock & page writeback flag), multiple processes
> executing a "sync" of overlapping block ranges over the same zone of
> an SMR disk can cause an out-of-LBA-order sequence of write requests
> being sent to the underlying device. On a host managed SMR disk, where
> sequential write to disk zones is mandatory, this result in errors and
> the impossibility for an application using raw sequential disk write
> accesses to be guaranteed successful completion of its write or fsync
> requests.
>
> Using the zone information attached to the SMR block device queue
> (introduced by Hannes), calls to the generic_writepages function can
> be made mutually exclusive on a per zone basis by locking the zones.
> This guarantees sequential request generation for each zone and avoid
> write errors without any modification to the generic code implementing
> generic_writepages.
>
> This is but one possible solution for supporting SMR host-managed
> devices without any major rewrite of page cache management and
> write-back processing. The opinion of the audience regarding this
> solution and discussing other potential solutions would be greatly
> appreciated.

Hello Damien,

Is it sufficient to support filesystems like BTRFS on top of SMR drives 
or would you also like to see that filesystems like ext4 can use SMR 
drives ? In the latter case: the behavior of SMR drives differs so 
significantly from that of other block devices that I'm not sure that we 
should try to support these directly from infrastructure like the page 
cache. If we look e.g. at NAND SSDs then we see that the characteristics 
of NAND do not match what filesystems expect (e.g. large erase blocks). 
That is why every SSD vendor provides an FTL (Flash Translation Layer), 
either inside the SSD or as a separate software driver. An FTL 
implements a so-called LFS (log-structured filesystem). With what I know 
about SMR this technology looks also suitable for implementation of a 
LFS. Has it already been considered to implement an LFS driver for SMR 
drives ? That would make it possible for any filesystem to access an SMR 
drive as any other block device. I'm not sure of this but maybe it will 
be possible to share some infrastructure with the LightNVM driver 
(directory drivers/lightnvm in the Linux kernel tree). This driver 
namely implements an FTL.

Bart.
