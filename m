From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Fri, 11 Apr 2003 08:12:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304110912.35610.pbadari@us.ibm.com>
References: <UTC200304102353.h3ANrXv10792.aeb@smtp.cwi.nl> <200304101809.55311.pbadari@us.ibm.com> <3E96945E.8080900@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:38029 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263020AbTDKQFR convert rfc822-to-8bit (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2003 12:05:17 -0400
In-Reply-To: <3E96945E.8080900@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Andries.Brouwer@cwi.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Friday 11 April 2003 03:09 am, Douglas Gilbert wrote:
> Badari Pulavarty wrote:
> > Here is my problem..
> >
> > #insmod ips.o
> >   < found 10 disks>
> > #insmod qla2300.o
> >   < found 10 disks>
> > #rmmod ips.o
> >    <removed 10 disks>
> > #insmod ips.o
> >   <found 10 disks - but new names>
>
> Badari,
> In 2.5 lets assume the /dev/sd[a-z][a-z][a-z]
> device addressing is left as is (more or less). To
> identify lots of disks the Vital Product Data page 0x83
> (failing that, the disk serial number) should be used.
>
> This information is available via sysfs (thanks to
> Patrick Mansfield and Mike Anderson).
>
> # cd /sys/bus/scsi/devices
> # find . -follow -name 'name' -exec cat {} \; -print
> SIBM     DNES-309170W            AJF98887
> ./1:0:4:0/name
> SFUJITSU MAM3184MP       UKS0P2300CK0
> ./0:0:1:0/name
>
> It is relatively easy to write user space tools to show
> this information:
> # lsscsi -n
> [0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
>    name: SFUJITSU MAM3184MP       UKS0P2300CK0
> [1:0:4:0]    disk    IBM      DNES-309170W     SA30  /dev/sdb
>    name: SIBM     DNES-309170W            AJF98887
>
> Each pair of lines links the transient topological and device
> node name ("0:0:1:0" and "dev/sda" respectively) with a
> (hopefully) invariant "name" for that device.
>
> So if that name was hashed there would be a reasonable mapping
> from that name to the current Linux scsi disk device node name
> (e.g. /dev/sda). So user space tools could work out the mapping
> and provide the "memory" from one boot to the next (and across
> the deletion and re-addition of HBA modules).
>
> Doug Gilbert

Doug,

I completly agree with what you said. One can write a user-space 
tool to create/re-create/update device node and try to keep device
names consistent. I am sure people (Greg KH) are working on this.

All I am trying to do is, come out with a plan to do this for 2.6.
We can do all the user-space stuff and make generic dynamic
<major, minor> assignment and some how make the /dev/ nodes
magically everytime rmmod/insmod or re-boot. There are lots
of dependencies and players here. All these going to happen for 2.6 ?
I would love to see this happen. But please, don't leave it in
the middle. (leaving the device node mapping to user/admin).
And also, how do we deal with booting/running 2.4 ?

If not, my patch is a fallback solution.

Thanks,
Badari


Thanks,
Badari
