From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Mon, 11 Apr 2016 10:57:43 -0400 (EDT)
Message-ID: <2075228612.28286127.1460386663699.JavaMail.zimbra@redhat.com>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com> <yq137qw6bzz.fsf@sermon.lab.mkp.net> <888890380.28014192.1460104289837.JavaMail.zimbra@redhat.com> <1460119192.25335.40.camel@localhost.localdomain> <1975890115.28041373.1460121079252.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1975890115.28041373.1460121079252.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

As a follow up to this issue.

I looked at modifying the LIO target code to allow a larger max_sectors_kb exported to the initiator for the nvme devices but had some issues.
In the end I created 15 fileio devices using 200GB of ramdisk and exported those so I could test 4MB I/O from the initiator.

These allow the 4MB setting on the upstream kernel.

[root@srptest ~]# sg_inq -p 0xb0 /dev/sdk
VPD INQUIRY: Block limits page (SBC)
  Maximum compare and write length: 1 blocks
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 16384 blocks
  Optimal transfer length: 16384 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks

The sg_map issues I am having on the RHEL kernel are likely due to the "proper" max sector size being ignored.
I am testing latest upstream now 4.5.0 with all the sg related patches to see if that's stable.

Thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-scsi" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Friday, April 8, 2016 9:11:19 AM
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target

Hi Ewan, 

OK, that makes sense.
I suspected after everybody's responses that RHEL was somehow ignoring the array imposed limit here.
I actually got lucky because I needed to be able to issue 4MB IO'S to reproduce the failures seen
at the customer on the initiator side.

Looking at the target-LIO array now its clamped to 1MB I/O sizes which makes sense.
I really was not focusing on the array at the time expecting it may chop the I/O up as many do.

Knowing what's up now I can continue to test and figure out what patches I need to pull in to SRP on RHEL to make progress.

Thank you to all that responded.

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Ewan D. Milne" <emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-scsi" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Friday, April 8, 2016 8:39:52 AM
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target

The version of RHEL you are using does not have:

commit ca369d51b3e1649be4a72addd6d6a168cfb3f537
Author: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
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
> From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "linux-scsi" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Thursday, April 7, 2016 11:00:16 PM
> Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
> 
> >>>>> "Laurence" == Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
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


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
