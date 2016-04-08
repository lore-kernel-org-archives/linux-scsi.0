From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Fri, 08 Apr 2016 08:39:52 -0400
Message-ID: <1460119192.25335.40.camel@localhost.localdomain>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com>
	 <yq137qw6bzz.fsf@sermon.lab.mkp.net>
	 <888890380.28014192.1460104289837.JavaMail.zimbra@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbcDHMjy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 08:39:54 -0400
In-Reply-To: <888890380.28014192.1460104289837.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org

The version of RHEL you are using does not have:

commit ca369d51b3e1649be4a72addd6d6a168cfb3f537
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Fri Nov 13 16:46:48 2015 -0500

    block/sd: Fix device-imposed transfer length limits

(which will be added during the next update).

In the upstream kernel queue_max_sectors_store() does not
permit you to set a value larger than the device-imposed
limit.  This value, stored in q->limits.max_dev_sectors,
is not visible via the block queue sysfs interface.

The code that sets q->limits.max_sectors and q->limits.io_opt
in sd.c does not take the device limit into account, but
the sysfs code to change max_sectors ("max_sectors_kb") does.

So there are a couple of problems here, one is that RHEL
is not clamping to the device limit, and the other one is
that neither RHEL nor upstream kernels take the device limit
into account when setting q->limits.io_opt.  This only seems
to be a problem for you because your target is reporting
an optimal I/O size in VPD page B0 that is *smaller* than
the reported maximum I/O size.

The target is clearly reporting inconsistent data, the
question is whether we should change the code to clamp the
optimal I/O size, or whether we should assume the value
the target is reporting is wrong.

So the question is:  does the target actually process
requests that are larger than the VPD page B0 reported
maximum size?  If so, maybe we should just issue a warning
message rather than reducing the optimal I/O size.

-Ewan


On Fri, 2016-04-08 at 04:31 -0400, Laurence Oberman wrote:
> Hello Martin
> 
> Yes, Ewan also noticed that.
> 
> This started out as me testing the SRP stack on RHEL 7.2 and baselining against upstream.
> We have a customer that requires 4MB I/O.
> I bumped into a number of SRP issues including sg_map failures so started reviewing upstream changes to the SRP code and patches.
> 
> The RHEL kernel is ignoring this so perhaps we have an issue on our side (RHEL kernel) and upstream is behaving as it should.
> 
> What is intersting is that I cannot change the max_sectors_kb at all on the upstream for the SRP LUNS.
> 
> Here is an HP SmartArray LUN
> 
> [root@srptest ~]#  sg_inq --p 0xb0 /dev/sda
> VPD INQUIRY: page=0xb0
>     inquiry: field in cdb illegal (page not supported)   **** Known that its not supported
> 
> However
> 
> /sys/block/sda/queue
> 
> [root@srptest queue]# cat max_hw_sectors_kb max_sectors_kb
> 4096
> 1280
> [root@srptest queue]# echo 4096 > max_sectors_kb
> [root@srptest queue]# cat max_hw_sectors_kb max_sectors_kb
> 4096
> 4096
> 
> On the SRP LUNS I am unable to change to a lower value than  max_sectors_kb unless I change it to 128
> So perhaps the size on the array is the issue here as Nicholas said and the RHEL kernel has a bug and ignores it.
> 
> /sys/block/sdc/queue
> 
> [root@srptest queue]# cat max_hw_sectors_kb max_sectors_kb
> 4096
> 1280
> 
> [root@srptest queue]# echo 512 > max_sectors_kb
> -bash: echo: write error: Invalid argument
> 
> [root@srptest queue]# echo 256 > max_sectors_kb
> -bash: echo: write error: Invalid argument
> 
> 128 works
> [root@srptest queue]# echo 128 > max_sectors_kb
> 
> 
> 
> 
> Laurence Oberman
> Principal Software Maintenance Engineer
> Red Hat Global Support Services
> 
> ----- Original Message -----
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "linux-scsi" <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org
> Sent: Thursday, April 7, 2016 11:00:16 PM
> Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
> 
> >>>>> "Laurence" == Laurence Oberman <loberman@redhat.com> writes:
> 
> Laurence,
> 
> The target is reporting inconsistent values here:
> 
> > [root@srptest queue]# sg_inq --p 0xb0 /dev/sdb
> > VPD INQUIRY: Block limits page (SBC)
> >   Maximum compare and write length: 1 blocks
> >   Optimal transfer length granularity: 256 blocks
> >   Maximum transfer length: 256 blocks
> >   Optimal transfer length: 768 blocks
> 
> OPTIMAL TRANSFER LENGTH GRANULARITY roughly translates to physical block
> size or RAID chunk size. It's the smallest I/O unit that does not
> require read-modify-write. It would typically be either 1 or 8 blocks
> for a drive and maybe 64, 128 or 256 for a RAID5 array. io_min in
> queue_limits.
> 
> OPTIMAL TRANSFER LENGTH indicates the stripe width and is a multiple of
> OPTIMAL TRANSFER LENGTH GRANULARITY. io_opt in queue_limits.
> 
> MAXIMUM TRANSFER LENGTH indicates the biggest READ/WRITE command the
> device can handle in a single command. In this case 256 blocks so that's
> 128K. max_dev_sectors in queue_limits.
> 
> From SBC:
> 
> "A MAXIMUM TRANSFER LENGTH field set to a non-zero value indicates the
> maximum transfer length in logical blocks that the device server accepts
> for a single command shown in table 250. If a device server receives one
> of these commands with a transfer size greater than this value, then the
> device server shall terminate the command with CHECK CONDITION status
> [...]"
> 
> So those reported values are off.
> 
>    logical block size <= physical block size <= OTLG <= OTL <= MTL
> 
> Or in terms of queue_limits:
> 
>    lbs <= pbs <= io_min <= io_opt <=
>        min_not_zero(max_dev_sectors, max_hw_sectors, max_sectors)
> 


