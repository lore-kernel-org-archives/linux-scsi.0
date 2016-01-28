From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re: st driver doesn't seem to grok LTO partitioning
Date: Thu, 28 Jan 2016 19:04:20 +0200
Message-ID: <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr> <20160104124626.3112e8c0@harpe.intellique.com> <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net> <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44
 522A7B@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs17.mail.saunalahti.fi ([62.142.117.198]:43750 "EHLO
	vs17.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161321AbcA1RE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 12:04:27 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On 28.1.2016, at 9.36, Seymour, Shane M <shane.seymour@hpe.com> wrote:
> 
> Hi Kai,
> 
> With the changes the I get a failure partitioning a HP DAT72 drive (DDS-5):
> 
> # ./mt -f /dev/st1 stsetoption debug
> # ./mt -f /dev/st1 stsetoption can-partitions
> # ./mt -f /dev/st1 mkpartition 1000
> /dev/st1: Input/output error
> 
...
> [ 3976.389605] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> [ 3976.389610] st 6:0:3:0: [st1] PP: max 1, add 0, xdp 0, psum 02, pofmetc 0, rec 03, units 00, sizes: 0 65535
> [ 3976.389614] st 6:0:3:0: [st1] MP: 11 08 01 00 10 03 00 00 00 00 ff ff
> [ 3976.389618] st 6:0:3:0: [st1] psd_cnt 2, max.parts 1, nbr_parts 0
                                                     ^^^^^^^^^
The problem is here

...
> Using a slightly older kernel to partition the DAT72 drive works (same 3 commands as above):
...
> [  351.584906] st 6:0:3:0: [st1] Partition page length is 10 bytes.
> [  351.584908] st 6:0:3:0: [st1] psd_cnt 1, max.parts 1, nbr_parts 0

The old driver computes the psd_cnt from the returned page length. The same applies
to the patched driver if the SCSI level of the device < SCSI_3. This works correctly with
my drive that reports SCSI_2. So, the question is: what SCSI level does your device
report?

Kai

