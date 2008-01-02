From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: reproducible DV to the wrong device (fusion)
Date: Wed, 2 Jan 2008 12:07:51 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70C0E5D0@NAMAIL4.ad.lsil.com>
References: <200801021954.10073.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42578 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbYABTID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2008 14:08:03 -0500
Content-class: urn:content-classes:message
In-Reply-To: <200801021954.10073.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>, linux-scsi@vger.kernel.org, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On  Wednesday, January 02, 2008 11:54 AM, Bernd Schubert wrote:
> I complained about this before, but always got ignored. 
> Please not this time. 

Sorry, I didn't see your email before today.

> 
> On IOC0 there is 2:0:4:0 and on IOC1 there is 3:0:13:0 and 3:0:14:0.
> 
> pfs1n14-m:~# /tmp/scsiadd -a 2 0 4 0
> 
> 
> [ 2595.405276] scsi 2:0:4:0: Activating scsi error recovery
> [ 2595.405711] mptbase: ioc0: LogInfo(0x11010400): F/W: bug! 
> MID not found


MID = means the firmware was unable to locate the proper "message id"
associated to some request when completing some command.   Apparently
the command never completed back to driver, and eh threads were woken.
The MID might be fixed by a firmware upgrade.   Do you know which
version you have?  It will be provided in the banner when the driver
loads.

> 
> I already tried "echo -1 >/proc/sys/dev/scsi/logging_level", 
> but this doesn't 
> reveal anything.
> 
> 
> Please, we really need to fix this, as this is really troublesome in 
> production situation. Some hints for further debugging should 
> be suffienct 
> for now.


If your using a linux kernel that was released since last summer, I now
provide logging support in the driver which can be enabled/disabled via
sysfs attributes and command line option.  I will send you documentation
in seperate private email.   Some info of this provided in mptdebug.h in
the source code. For domain validation, you need to enable the
MPT_DEBUG_DV bits.   Also CONFIG_FUSION_LOGGING needs to be enabled in
the kernel config, and set your kernel logging level for klogd to 7 (or
KERN_DEBUG).

Example

insmod mptbase.ko mpt_debug_level=0x200

or

echo 0x200 > /sys/class/scsi_host/host0/debug_level





