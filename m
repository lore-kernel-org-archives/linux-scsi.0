From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Tue, 04 Dec 2012 16:00:51 -0600
Message-ID: <50BE7293.8060200@genband.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>	<50B67230.4080602@genband.com> <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com> <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com> <50BD0F44.7010808@genband.com> <50BD1127.6090304@redhat.com> <50BD14B1.7000203@genband.com> <50BD1F45.1040802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:58727 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2LDWBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2012 17:01:53 -0500
In-Reply-To: <50BD1F45.1040802@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 12/03/2012 03:53 PM, Ric Wheeler wrote:
> On 12/03/2012 04:08 PM, Chris Friesen wrote:
>> On 12/03/2012 02:52 PM, Ric Wheeler wrote:
>>
>>> I jumped into this thread late - can you repost detail on the specific
>>> drive and HBA used here? In any case, it sounds like this is a better
>>> topic for the linux-scsi or linux-ide list where most of the low level
>>> storage people lurk :)
>> Okay, expanding the receiver list. :)
>>
>> To recap:
>>
>> I'm running 2.6.27 with LVM over software RAID 1 over a pair of SAS 
>> disks.
>> Disks are WD9001BKHG, controller is Intel C600.
>>
>> Recently we started seeing messages of the following pattern, and we
>> don't know what's causing them:
>>
>> Nov 28 08:57:10 kernel: end_request: I/O error, dev sda, sector 
>> 1758169523
>> Nov 28 08:57:10 kernel: md: super_written gets error=-5, uptodate=0
>> Nov 28 08:57:10 kernel: raid1: Disk failure on sda2, disabling device.
>> Nov 28 08:57:10 kernel: raid1: Operation continuing on 1 devices.
>>
>> We've been assuming it's a software issue since it's reproducible on
>> multiple systems, although so far we've only seen the problem with
>> these particular disks.
>>
>> We've seen the problems with disk write cache enabled and disabled.
> 
> Hi Chris,
> 
> Are there any earlier IO errors or sda related errors in the log?

Nope, at least not nearby.  On one system for instance we boot up and
get into steady-state, then there are no kernel logs for about half an
hour then out of the blue we see:

Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: end_request: I/O error, dev sda, sector 1758169523
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: md: super_written gets error=-5, uptodate=0
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: raid1: Disk failure on sda2, disabling device.
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: raid1: Operation continuing on 1 devices.
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: end_request: I/O error, dev sdb, sector 1758169523
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: md: super_written gets error=-5, uptodate=0
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: RAID1 conf printout:
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: --- wd:1 rd:2
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: disk 0, wo:1, o:0, dev:sda2
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: RAID1 conf printout:
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: --- wd:1 rd:2
Nov 27 14:58:13 base0-0-0-13-0-11-1 kernel: disk 1, wo:0, o:1, dev:sdb2


As another data point, it looks like we may be doing a SEND DIAGNOSTIC
command specifying the default self-test in addition to the background
short self-test.  This seems a bit risky and excessive to me, but
apparently the guy that wrote it is no longer with the company.

What is the recommended method for monitoring disks on a system that
is likely to go a long time between boots?  Do we avoid any in-service
testing and just monitor the SMART data and only test it if something
actually goes wrong?  Or should we intentionally drop a disk out of the
array and test it?  (The downside of that is that we lose
redundancy since we only have 2 disks.)

Chris
