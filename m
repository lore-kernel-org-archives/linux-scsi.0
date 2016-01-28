From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re: st driver doesn't seem to grok LTO partitioning
Date: Thu, 28 Jan 2016 19:31:10 +0200
Message-ID: <29BBF79F-C32C-479C-9ED1-31E647B98A9E@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr> <20160104124626.3112e8c0@harpe.intellique.com> <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net> <20160122125045.0a432e53@harpe.intellique.com> <DDB9C85B850785449757F9914A034FCB44520BDB@G9W0
 766.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:44889 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbcA1RbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 12:31:16 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44520BDB@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On 27.1.2016, at 1.35, Seymour, Shane M <shane.seymour@hpe.com> wrote:
> 
> Hi Emmanuel,
> 
>> Hmm in fact if we keep using MB we'll be stuck when tapes reach ~2 PB
>> which leaves some time to think about it, until LTO-15 circa 2036 :)
> 
> There will be other issues to solve before then (by LTO-9 2 with compression
> or LTO-10 without compression and we're at LTO-7 now). Take tar format
> archives with a standard block size of 10k can take this much data to get
> to 2^32 blocks and cause the current 32bit block number to wrap:
> 
> 43,980,465,111,040 (2^32 * 10240)
> 
This is a somewhat theoretic example. In the 1990s no reasonable person used
block size below 32 kB. Now the limit is probably higher. But, eventually we have
to enlarge the block position and count variables.

> After that much data has been written the SCSI-2 command READ POSITION
> will not be able to show the current position correctly (which is what the st
> driver uses to determine the position for an MTIOCPOS). It may be less
> than that since some drives include file marks in the logical block number if
> the program that produced the tape writes them out.
> 
> That means switching to the extended block id form of READ POSITION
> so we have 64bit counts for those values, see page 150:
> 
> https://docs.oracle.com/cd/E21419_04/en/LTO5_Vol3_E5b/LTO5_Vol3_E5b.pdf
> 
> That's going to require new ioctls like MTIOCPOS64 and other changes within
> the driver to support larger types for holding some values. That will also raise
> all sorts of fun compatibility questions as well (should MTIOCPOS work at all
> for such a tape drive or should it work until something overflows and return
> what data it can and give an errno of -EOVERFLOW etc).
> 
I think we should support MTIOCPOS as far as we can. There is no point to
make existing software unusable for people who happen to buy a modern
drive. Note also that the block number given to MTIOCPOS is long, i.e.,
64 bits in the important architectures ;-) (The argument to MTSEEK is
int, though.)

> That's probably the correct time to also look at adding support for more
> partitions. Not sure when the extended block id form of READ POSITION
> got added but it may mean only supporting the wider values only with tape
> drives that support REPORT SUPPORTED OPCODES (if that can indicate that
> it supports READ POSITION with extended block ids and anything else
> required to support block numbers larger than 2^32).
> 
The current driver supports using up to ST_NBR_PARTITIONS (in the source set
to 4). Support for using partitions must be in the driver. I am still not sure if
partitioning the tape should be in the driver.

> The 0x91 version of SPACE needs to be used as well (the 32bit version 0x11
> Is currently used) to allow tape movement with counts >2^32. That requires
> a new ioctl call. I haven't looked at what else may need to change but there's
> likely to be more. The alternate version of SPACE is from page 220 of the
> above HP LTO5 tape reference.
> 
The first step is to make the internal counters 64 bits. Then the code should be
changed so that it can handle the large addresses. Note that this is necessary
for handling partition changes even if no positioning commands are exposed
to the user. The last step is to introduce the new positioning methods.

The new positioning methods should perhaps be defined so that both the partition
number and the block number are specified together. A proper tape address needs
both.

But I think we should first fix the existing partitioning command so that it works
for current drives.

Kai

