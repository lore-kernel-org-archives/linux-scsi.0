From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Sat, 11 Feb 2006 11:34:19 +0100
Message-ID: <20060211103419.GA10956@suse.de>
References: <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de> <43ED1FE0.1000805@us.ibm.com> <20060210232935.GA27760@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:9120 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751411AbWBKKec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2006 05:34:32 -0500
Content-Disposition: inline
In-Reply-To: <20060210232935.GA27760@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

 On Sat, Feb 11, Olaf Hering wrote:

>  On Fri, Feb 10, Brian King wrote:
> 
> > >    release = 0xd0000000002190c0}, reap_ref = 0, channel = 255, id = 100, 
> > >    create = 0, scsi_level = 0 '\0', hostdata = 0x0, starget_data = 
> > >    0x1ffffffec60}
> >                                                    ^^^^^^^^^^^^^
> > 
> > This is interesting.. This means that it is on ipr's logical scsi bus 
> > (255). Assuming this is
> > happening at boot time and not due to a user initiated scan through sysfs, 
> > this
> > means we are going through the scsi_add_device path, rather than the 
> > scsi_scan_host
> > path...
> 
> I forgot to attach my notes from the crash, it contains parts of the bootlog.

poking around a bit further (after reboot and another crash):

cpu0 idle
cpu1 idle
cpu2 udevd runs, starts to do lstat on 
2:mon> d 00000000ffdd3560 123
00000000ffdd3560 2f7379732f646576 696365732f706369  |/sys/devices/pci|
00000000ffdd3570 303030303a303000 303030303a30303a  |0000:00.0000:00:|
00000000ffdd3580 30322e3000303030 303a63303a30312e  |02.0.0000:c0:01.|
00000000ffdd3590 3000686f73743000 746172676574303a  |0.host0.target0:|
00000000ffdd35a0 303a3300303a303a 333a3000f800f018  |0:3.0:0:3:0.....|

cpu3 udevd runs, starts to open 
3:mon> d 00000000ffdd3aa8 123
00000000ffdd3aa8 2f6465762f2e7564 65762f64622f626c  |/dev/.udev/db/bl|
00000000ffdd3ab8 6f636b4073646100 ffdd3ad01000a608  |ock@sda...:.....|

cpu4 vol_id runs, about to compat_sys_execve /sbin/vol_id
cpu5 crashed in events/5
cpu6 idle
cpu7 vol_id runs, starts to open /lib/libc.so.6

-- 
short story of a lazy sysadmin:
 alias appserv=wotan
