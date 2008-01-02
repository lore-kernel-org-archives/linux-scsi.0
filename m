From: Bernd Schubert <bs@q-leap.de>
Subject: Re: reproducible DV to the wrong device (fusion)
Date: Wed, 2 Jan 2008 20:49:26 +0100
Message-ID: <200801022049.27160.bs@q-leap.de>
References: <664A4EBB07F29743873A87CF62C26D70C0E5D0@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:37676 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbYABTt3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2008 14:49:29 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70C0E5D0@NAMAIL4.ad.lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On Wednesday 02 January 2008 20:07:51 Moore, Eric wrote:
> On  Wednesday, January 02, 2008 11:54 AM, Bernd Schubert wrote:
> > I complained about this before, but always got ignored.
> > Please not this time.
>
> Sorry, I didn't see your email before today.
>
> > On IOC0 there is 2:0:4:0 and on IOC1 there is 3:0:13:0 and 3:0:14:0.
> >
> > pfs1n14-m:~# /tmp/scsiadd -a 2 0 4 0
> >
> >
> > [ 2595.405276] scsi 2:0:4:0: Activating scsi error recovery
> > [ 2595.405711] mptbase: ioc0: LogInfo(0x11010400): F/W: bug!
> > MID not found
>
> MID = means the firmware was unable to locate the proper "message id"
> associated to some request when completing some command.   Apparently
> the command never completed back to driver, and eh threads were woken.
> The MID might be fixed by a firmware upgrade.   Do you know which
> version you have?  It will be provided in the banner when the driver
> loads.

Sure, 

[  100.094458] scsi2 : ioc0: LSI53C1030, FwRev=01033010h, Ports=1, MaxQ=222, IRQ=16

Some months ago you also did sent me an even more recent version (1.03.35), 
but this version also sometimes did show these "F/W: bug!" messages and 
also caused problems with with the Linux version  lsiutil (e.g. bios 
upgrade/downgrade and firmware downgrade didn't work anymore). So we 
explicitely flashed all 62 cards of this project with 01033010h.

>
> > I already tried "echo -1 >/proc/sys/dev/scsi/logging_level",
> > but this doesn't
> > reveal anything.
> >
> >
> > Please, we really need to fix this, as this is really troublesome in
> > production situation. Some hints for further debugging should
> > be suffienct
> > for now.
>
> If your using a linux kernel that was released since last summer, I now
> provide logging support in the driver which can be enabled/disabled via
> sysfs attributes and command line option.  I will send you documentation
> in seperate private email.   Some info of this provided in mptdebug.h in
> the source code. For domain validation, you need to enable the
> MPT_DEBUG_DV bits.   Also CONFIG_FUSION_LOGGING needs to be enabled in
> the kernel config, and set your kernel logging level for klogd to 7 (or
> KERN_DEBUG).
>
> Example
>
> insmod mptbase.ko mpt_debug_level=0x200
>
> or
>
> echo 0x200 > /sys/class/scsi_host/host0/debug_level

Sorry, I think (from reading the sources) this went in with 2.6.23. 
Unfortunately we have to use for some reason 2.6.22. Do you have 
single patches or do you know the git commits for this? I could 
(actually would like) to add this to our 2.6.22 release. Before 
Xmas I already tried to to apply a fusion diff between 2.6.22 and 
2.6.23, but there was quite some 2.6.23 generic scsi-device specific stuff and eventually I considered this as too experimental.

But I think in 2.6.22 debugging can be enabled via Makefile flags and this is what I did now.

Please see http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/scsi/dmesg.log

This starts on 4742.378588, this is the time when I did the scsiadd command (this time ioc0 is target8 and ioc1 is target9, since I simply rmmod'ed and modprobed the new fusion modules with debug information). This nicely does show that for some reason something goes on on ioc1. Any ideas why?

[ 4756.122899] mptbase: ioc0: Calling alt-ioc1 setup reset handler #15

[ 4756.242546] mptbase: ioc0: Calling alt-ioc1 setup reset handler #14

[ 4756.255542] mptscsih: ioc1: WARNING - Setup-Diag Reset

[...]
[ 4801.648267]  target9:0:12: Beginning Domain Validation
[ 4801.653692] mptspi: ioc1: id=12 Requested = 0x20000887 ( Wide  factor = 0x08 @ offset = 0x00 IU DT QAS PCOMP )
[ 4801.664223] mptbase: ioc1: mpt_get_msg_frame(15,1), got mf=ffff810121386580
[ 4801.671277] mptbase: ioc1: Sending Config request type 4, page 1 and action 2
[ 4801.678800] mptbase: ioc1: About to Put msg frame @ ffff810121386580:



Thanks a lot,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
