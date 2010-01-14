From: scameron@beardog.cce.hp.com
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Thu, 14 Jan 2010 14:07:15 -0600
Message-ID: <20100114200715.GB13413@beardog.cce.hp.com>
References: <20100114165602.GY13413@beardog.cce.hp.com> <4B4F617B.5050609@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:18489 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab0ANUFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 15:05:47 -0500
Content-Disposition: inline
In-Reply-To: <4B4F617B.5050609@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, dab@hp.com, hch@infradead.org, axboe@kernel.dk, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Jan 14, 2010 at 01:24:59PM -0500, Douglas Gilbert wrote:
> scameron@beardog.cce.hp.com wrote:
> >I'm seeing a problem which I think is a problem in the SCSI mid layer.
> >
> >Check this out:
> >
> >I can rmmod and insmod hpsa (a modified version from 
> >what's currently in the mainline tree, but I don't think
> >that matters.)
> >
> >I have one logical drive present
> >
> >[root@slicer ~]# rmmod hpsa
> >[root@slicer ~]# insmod /usr/src/linux-2.6.27.42/drivers/scsi/hpsa.ko
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi1 Channel: 00 Id: 00 Lun: 00
> >  Vendor: HP       Model: 1210m            Rev: 0150
> >  Type:   RAID                             ANSI  SCSI revision: 05
> >Host: scsi1 Channel: 00 Id: 00 Lun: 01
> >  Vendor: HP       Model: 1210m VOLUME     Rev: 0150
> >  Type:   Direct-Access                    ANSI  SCSI revision: 05
> >[root@slicer ~]# rmmod hpsa
> >[root@slicer ~]# insmod /usr/src/linux-2.6.27.42/drivers/scsi/hpsa.ko
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi2 Channel: 00 Id: 00 Lun: 00
> >  Vendor: HP       Model: 1210m            Rev: 0150
> >  Type:   RAID                             ANSI  SCSI revision: 05
> >Host: scsi2 Channel: 00 Id: 00 Lun: 01
> >  Vendor: HP       Model: 1210m VOLUME     Rev: 0150
> >  Type:   Direct-Access                    ANSI  SCSI revision: 05
> >[root@slicer ~]# lsscsi -g
> >[2:0:0:0]    storage HP       1210m            0150  -         /dev/sg0
> >[2:0:0:1]    disk    HP       1210m VOLUME     0150  /dev/sda  /dev/sg1
> >
> >So far, so good.
> >
> >Now, watch this.  Remove the device while something has it open:
> >
> >[root@slicer ~]# sleep 10 < /dev/sg1 & ( sleep 1 && echo scsi 
> >remove-single-device 2 0 0 1 > /proc/scsi/scsi )
> >[1] 6077
> >[root@slicer ~]# 
> >[1]+  Done                    sleep 10 < /dev/sg1
> >[root@slicer ~]# lsof /dev/sg1
> >lsof: status error on /dev/sg1: No such file or directory
> >lsof 4.78
> > latest revision: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/
> > latest FAQ: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/FAQ
> > latest man page: ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_man
> > usage: [-?abhlnNoOPRstUvVX] [+|-c c] [+|-d s] [+D D] [+|-f]
> > [-F [f]] [-g [s]] [-i [i]] [+|-L [l]] [+m [m]] [+|-M] [-o [o]]
> > [-p s] [+|-r [t]] [-S [t]] [-T [t]] [-u s] [+|-w] [-x [fl]] [-Z [Z]] [--] 
> > [names]
> >Use the ``-h'' option to get more help information.
> >[root@slicer ~]# rmmod hpsa
> >ERROR: Module hpsa is in use
> >[root@slicer ~]#
> >
> >Hmm, that's not cool.
> 
> Steve,
> That 'sleep 10 < /dev/sg1' worries me. The purpose of a
> read() on a sg device is to fetch the response of a SCSI
> command sent by a preceding write(). So with nothing to
> read and a blocking sg device file descriptor the read()
> probably hangs. IMO the valid use of the sg driver should
> not have a read() hanging for a SCSI command that was
> never sent. While that is happening you remove the
> device.
> 
> That may be a valid torture test for the sg driver but
> isn't something that should be encouraged from the
> user space.
> 
> On a Ubuntu kernel 2.6.31-17-generic using a virtual
> device owned by the scsi_debug driver and the same
> torture test, I don't have a problem with 'rmmod scsi_debug'
> 
> IMO the usb-storage driver is not a good yardstick.

I tried it with mptsas with the same results:

mptlinuxtest:~ # cat /proc/scsi/scsi
mptlinuxtest:~ # modprobe mptsas
mptlinuxtest:~ # cat /proc/scsi/scsi
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: HP       Model: DG072A9BB7       Rev: HPD0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 01 Lun: 00
  Vendor: HP       Model: DG072A8B54       Rev: HPD4
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 01 Id: 03 Lun: 00
  Vendor: LSILOGIC Model: Logical Volume   Rev: 3000
  Type:   Direct-Access                    ANSI  SCSI revision: 02
mptlinuxtest:~ # rmmod mptsas
mptlinuxtest:~ # modprobe mptsas
mptlinuxtest:~ # cat /proc/scsi/scsi
Attached devices:
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: HP       Model: DG072A9BB7       Rev: HPD0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 01 Lun: 00
  Vendor: HP       Model: DG072A8B54       Rev: HPD4
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 01 Id: 03 Lun: 00
  Vendor: LSILOGIC Model: Logical Volume   Rev: 3000
  Type:   Direct-Access                    ANSI  SCSI revision: 02
mptlinuxtest:~ # lsscsi -g
[3:0:0:0]    disk    HP       DG072A9BB7       HPD0  -         /dev/sg0
[3:0:1:0]    disk    HP       DG072A8B54       HPD4  -         /dev/sg1
[3:1:3:0]    disk    LSILOGIC Logical Volume   3000  /dev/sda  /dev/sg2
mptlinuxtest:~ # sleep 10 < /dev/sg2 & ( sleep 1 && echo scsi remove-single-device 3 1 3 0 > /proc/scsi/scsi )
[1] 797
mptlinuxtest:~ # 
[1]+  Done                    sleep 10 < /dev/sg2
mptlinuxtest:~ # echo $?
0
mptlinuxtest:~ # rmmod mptsas
ERROR: Module mptsas is in use
mptlinuxtest:~ #


Also I tried using a C program rather than the sleep command, to remove
the possibility of a read from stdin by sleep command (even though
I think it doesn't, according to strace.)

[root@slicer ~]# cat sleeptest.c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

int main(int argc, char *argv[])
{
	int fd;
	
	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;	
	}
	sleep(10);
	return 0;
}

Using that, used in place of the "sleep < /dev/sg1", made no difference.

-- steve


> 
> Doug Gilbert
> 
> 
> >Maybe it's my driver.  Let me try with USB.
> >
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi1 Channel: 00 Id: 00 Lun: 00
> >  Vendor: USB      Model: DISK 2.0         Rev: 0403
> >  Type:   Direct-Access                    ANSI  SCSI revision: 00
> >[root@slicer ~]# lsmod | grep sd
> >sd_mod                 59592  0 
> >scsi_mod              189304  9 
> >usb_storage,ib_iser,iscsi_tcp,libiscsi,scsi_transport_iscsi,scsi_dh,sg,cciss,sd_mod
> >[root@slicer ~]# rmmod usb_storage
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >[root@slicer ~]# modprobe usb_storage
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >[root@slicer ~]# echo scsi add-single-device 1 0 0 0 > /proc/scsi/scsi
> >-bash: echo: write error: No such device or address
> >
> >Oh yeah, the host number increments, forgot about that...
> >
> >[root@slicer ~]# echo scsi add-single-device 2 0 0 0 > /proc/scsi/scsi
> >[root@slicer ~]# cat /proc/scsi/scsi
> >Attached devices:
> >Host: scsi2 Channel: 00 Id: 00 Lun: 00
> >  Vendor: USB      Model: DISK 2.0         Rev: 0403
> >  Type:   Direct-Access                    ANSI  SCSI revision: 00
> >[root@slicer ~]# lsscsi -g
> >[2:0:0:0]    disk    USB      DISK 2.0         0403  /dev/sda  /dev/sg0
> >[root@slicer ~]# sleep 10 < /dev/sg0 & ( sleep 1 && echo scsi 
> >remove-single-device 2 0 0 0 > /proc/scsi/scsi )
> >[1] 6073
> >[root@slicer ~]# 
> >[root@slicer ~]# 
> >[1]+  Done                    sleep 10 < /dev/sg0
> >[root@slicer ~]# rmmod usb_storage
> >ERROR: Module usb_storage is in use
> >[root@slicer ~]#
> >
> >Hmm, same thing.
> >
> >Any thoughts?  (other than "don't do that."  Our array configuration
> >utility for smart arrays is causing similar trouble, as it rapidly creates
> >and deletes logical drives, etc. so it would be nice if this didn't 
> >happen.)
