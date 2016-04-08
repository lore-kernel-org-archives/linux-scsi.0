From: Laurence Oberman <loberman@redhat.com>
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Fri, 8 Apr 2016 04:31:29 -0400 (EDT)
Message-ID: <888890380.28014192.1460104289837.JavaMail.zimbra@redhat.com>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com> <yq137qw6bzz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:47120 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbcDHIbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 04:31:33 -0400
In-Reply-To: <yq137qw6bzz.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org

Hello Martin

Yes, Ewan also noticed that.

This started out as me testing the SRP stack on RHEL 7.2 and baselining against upstream.
We have a customer that requires 4MB I/O.
I bumped into a number of SRP issues including sg_map failures so started reviewing upstream changes to the SRP code and patches.

The RHEL kernel is ignoring this so perhaps we have an issue on our side (RHEL kernel) and upstream is behaving as it should.

What is intersting is that I cannot change the max_sectors_kb at all on the upstream for the SRP LUNS.

Here is an HP SmartArray LUN

[root@srptest ~]#  sg_inq --p 0xb0 /dev/sda
VPD INQUIRY: page=0xb0
    inquiry: field in cdb illegal (page not supported)   **** Known that its not supported

However

/sys/block/sda/queue

[root@srptest queue]# cat max_hw_sectors_kb max_sectors_kb
4096
1280
[root@srptest queue]# echo 4096 > max_sectors_kb
[root@srptest queue]# cat max_hw_sectors_kb max_sectors_kb
4096
4096

On the SRP LUNS I am unable to change to a lower value than  max_sectors_kb unless I change it to 128
So perhaps the size on the array is the issue here as Nicholas said and the RHEL kernel has a bug and ignores it.

/sys/block/sdc/queue

[root@srptest queue]# cat max_hw_sectors_kb max_sectors_kb
4096
1280

[root@srptest queue]# echo 512 > max_sectors_kb
-bash: echo: write error: Invalid argument

[root@srptest queue]# echo 256 > max_sectors_kb
-bash: echo: write error: Invalid argument

128 works
[root@srptest queue]# echo 128 > max_sectors_kb




Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "linux-scsi" <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org
Sent: Thursday, April 7, 2016 11:00:16 PM
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target

>>>>> "Laurence" == Laurence Oberman <loberman@redhat.com> writes:

Laurence,

The target is reporting inconsistent values here:

> [root@srptest queue]# sg_inq --p 0xb0 /dev/sdb
> VPD INQUIRY: Block limits page (SBC)
>   Maximum compare and write length: 1 blocks
>   Optimal transfer length granularity: 256 blocks
>   Maximum transfer length: 256 blocks
>   Optimal transfer length: 768 blocks

OPTIMAL TRANSFER LENGTH GRANULARITY roughly translates to physical block
size or RAID chunk size. It's the smallest I/O unit that does not
require read-modify-write. It would typically be either 1 or 8 blocks
for a drive and maybe 64, 128 or 256 for a RAID5 array. io_min in
queue_limits.

OPTIMAL TRANSFER LENGTH indicates the stripe width and is a multiple of
OPTIMAL TRANSFER LENGTH GRANULARITY. io_opt in queue_limits.

MAXIMUM TRANSFER LENGTH indicates the biggest READ/WRITE command the
device can handle in a single command. In this case 256 blocks so that's
128K. max_dev_sectors in queue_limits.

>From SBC:

"A MAXIMUM TRANSFER LENGTH field set to a non-zero value indicates the
maximum transfer length in logical blocks that the device server accepts
for a single command shown in table 250. If a device server receives one
of these commands with a transfer size greater than this value, then the
device server shall terminate the command with CHECK CONDITION status
[...]"

So those reported values are off.

   logical block size <= physical block size <= OTLG <= OTL <= MTL

Or in terms of queue_limits:

   lbs <= pbs <= io_min <= io_opt <=
       min_not_zero(max_dev_sectors, max_hw_sectors, max_sectors)

-- 
Martin K. Petersen	Oracle Linux Engineering
