From: "Freels, James D." <freelsjd@ornl.gov>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 16:00:22 -0400
Message-ID: <1185480022.14419.58.camel@fea.ornl.gov>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
 <1185329683.3488.46.camel@localhost.localdomain>
 <1185461780.14419.17.camel@fea.ornl.gov>
 <1185462341.3501.62.camel@localhost.localdomain>
Reply-To: freelsjd@ornl.gov
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emroute2.ornl.gov ([160.91.86.17]:36586 "EHLO emroute2.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936095AbXGZUAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 16:00:32 -0400
Received: from emroute2.ornl.gov ([127.0.0.1])
 by emroute2.ornl.gov (PMDF V6.3-x11 #31501)
 with ESMTP id <0JLS00F8HY8SMH@emroute2.ornl.gov> for
 linux-scsi@vger.kernel.org; Thu, 26 Jul 2007 16:00:29 -0400 (EDT)
In-reply-to: <1185462341.3501.62.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Sorry for the previous HTML-formatted e-mails.  This is now corrected.

The first thing to realize is that this system only has three devices on
the actual scsi bus to this adapter:

7 - adapter card
3 - Exabyte 1x10 autoloader
6 - Exabyte VXA-2 tape drive

I only need 20 Mbps since the maximum speed of the VXA-2 tape drive is 6
Mbps uncomressed or 12 Mbps compressed (estimated since depends on
compressibility).  Looking at the backup reports I am getting very close
to 6 Mbps performance.

I looked at the bios settings for this device and it appears to be set
as near as possible to a narrow device:

1) The bios is entered by typing ctrl-A during the Adaptec bios output
console while booting.  All 15 scsi IDs show up on the console. Each
device can be set separately.

2) The entries were initially set as follows:

sync transfer 20 Mbps, scsi IDs 0-7
a-sync transfer, scsi IDs 8-15

initiate wide negotiation - NO - 0-15

enable auto-disconnect  - YES 0-15

send start to unit  -  YES 0-7, NO 8-15

enable write back cache - YES 0-7, NO 8-15

bios multiple LUN - NO - 0-15

include in bios scan - YES 0-7, NO 8-15

3) I also tried one change to these same entries (which is where it is
now):

sync transfer 20 Mbps, scsi IDs 0-15

enable auto-disconnect  - NO 0-7, YES 8-15

4) I also tried booting with all devices in async mode, and it also
failed to find the media changer.

5) The narrow bus can be verified by the maximum sync transfer available
is 160 Mbps in wide setting and only 40 Mbps in the narrow setting.

6) A separate screen shows two entries 

LVD/SE connector  automatic
Fast/Ultra-SE connector  automatic

These could be changed to enable or disable, but I left as automatic.

7) The bios version is 3.10.0 which is the latest available from Adaptec
and dated 30-May-2001.

8) I booted up under 2.6.18.8 and the old aic7xxx driver which is
working, and the 2.6.22.1 and the new aic7xxx driver which is not
working.

9) the output from the commands you asked for are shown below for the
2.6.22.1 kernel.  They indicate parity errors on the changer at scsi
id=3.  Also, when booting up under 2.6.18.8, the linux media changer
scsi device works and initializes; when booting up under 2.6.22.1, it
does not; probably because of the same parity errors ?

 target0:0:3: Beginning Domain Validation
 target0:0:3: asynchronous
 target0:0:3: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 32)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
SCSIRATE(0x95)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x95)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x95)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x95)
 target0:0:3: Domain Validation detected failure, dropping back
 target0:0:3: FAST-20 WIDE SCSI 33.4 MB/s ST (60 ns, offset 32)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
SCSIRATE(0x96)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x96)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
SCSIRATE(0x96)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x96)
 target0:0:3: Domain Validation detected failure, dropping back
 target0:0:3: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 32)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
SCSIRATE(0x98)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x98)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
SCSIRATE(0x98)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x98)
 target0:0:3: Domain Validation detected failure, dropping back
 target0:0:3: FAST-10 WIDE SCSI 13.6 MB/s ST (148 ns, offset 32)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
SCSIRATE(0x9a)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x9a)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a6)
SCSIRATE(0x9a)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x9a)
 target0:0:3: Domain Validation detected failure, dropping back
 target0:0:3: wide asynchronous
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x69)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x6b)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x85)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x85)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x85)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x85)
SCSIRATE(0x80)
 target0:0:3: Domain Validation detected failure, dropping back
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x69)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x6b)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x54)
SCSIRATE(0x80)
 target0:0:3: Domain Validation detected failure, dropping back
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x69)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x6b)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
 target0:0:3: Domain Validation detected failure, dropping back
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x69)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x83)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
(scsi0:A:3:0): parity error detected in Command phase. SEQADDR(0x1a7)
SCSIRATE(0x80)
 target0:0:3: Domain Validation Failure, dropping back to Asynchronous
 target0:0:3: Domain Validation skipping write tests
 target0:0:3: Ending Domain Validation


