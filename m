From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 0/4] scsi: 64-bit LUN support
Date: Tue, 9 Apr 2013 14:27:30 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950DDBBF2@G9W0745.americas.hpqcorp.net>
References: <1361261883-41467-1-git-send-email-hare@suse.de>
 <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org>
 <5152A19C.7010500@suse.de> <5155C235.40807@redhat.com>
 <515718A3.1080302@suse.de> <51587619.1060208@redhat.com>
 <515D533C.1070809@suse.de>
 <e585e906-5ada-4fe6-a21d-b735c42a51c1@CMEXHTCAS1.ad.emulex.com>
 <5162E426.40202@redhat.com> <5163C55C.3020909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18651 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab3DIO2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Apr 2013 10:28:18 -0400
In-Reply-To: <5163C55C.3020909@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Tomas Henzl <thenzl@redhat.com>
Cc: "James.Smart@emulex.com" <James.Smart@emulex.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Bart Van Assche <bvanassche@acm.org>, Bud Brown <bubrown@redhat.com>


> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, 09 April, 2013 2:38 AM
> To: Tomas Henzl
> Cc: James.Smart@emulex.com; Chad Dupuis; linux-scsi@vger.kernel.org; James
> Bottomley; Jeremy Linton; Elliott, Robert (Server Storage); Bart Van Assche;
> Bud Brown
> Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
> 
> On 04/08/2013 05:37 PM, Tomas Henzl wrote:
> > On 04/05/2013 05:24 PM, James Smart wrote:
> >>
> >> On 4/4/2013 6:17 AM, Hannes Reinecke wrote:
> >>> On 03/31/2013 07:44 PM, Tomas Henzl wrote:
> >
> You are right in the sense that 'max_lun' actually has a double meaning.
> 
> First it's being used as the upper limit for sequential scan, where
> is has a strictly sequential meaning. So any internal LUN structure
> doesn't come into play here are we're just 'counting'.
> 
> Secondly it's being used as a simple validation for any LUN numbers
> reported via REPORT LUNS.
> Here it the max_lun value actually refers to the amount of _bits_ in
> a LUN number the HBA can transfer. Again, the internal LUN structure
> doesn't come into play here; this is purely a hardware limitation on
> the HBA. Whether a LUN is valid or not is none of our concern; if
> the target accepts the LUN is has to be valid. If it doesn't then we
> don't care whether the LUN structure is valid or not; there is no
> device to be had anyway.
> 
> However, after consulting SAM it is true that a plain 'max_lun' is
> incorrect for any LUN value higher than 255.
> LUN values higher than 255 should be represented with the 'flat
> space addressing' model, ie bit 6 should be set.
> Sadly, the various SAM revisions differ on how LUNs lower than
> 255 should be treated; they might or might not have set the flat
> space addressing model.

If you treat the LUN as an 8-byte single big-endian value, then 
every LUN using an address method other than the peripheral
device addressing method (00b) is greater than 255; in fact,
they're all greater than 4,611,686,018,427,387,904
(0x4000_0000_0000_0000).

One "LUN value" is not represented by different addressing models.
For example, these are four different LUNs, not multiple ways to 
express the same "LUN 0":
a) LUN 0x0000_0000_0000_0000 
	address method 00b
	target or lun = 0000_0000b
b) LUN 0x4000_0000_0000_0000 
	address method 01b
	flat space lun = 00_0000_0000_0000b
c) LUN 0xD200_0000_0000_0000 
	address method 11b
	length 01b
	extended address method 0x2
	extended flat space lun = 0x00_0000
d) LUN 0xE200_0000_0000_0000 
	address method 11b
	length 10b
	extended address method 0x2
	long extended flat space lun = 0x00_00000000

Sequential scanning should be an exception for very old devices
that don't support REPORT LUNS; a small maximum scan value
would be safer than scanning to max_luns, which could be huge.

Three plausible lower scan limits:
a) address method 00b with TARGET OR LUN set to 0..7: the 
number of LUNs supported by SCSI-1, which had a 3-bit LUN field 
in the CDBs themselves (long since obsolete)

b) address method 00b with TARGET OR LUN set to 0..255: the 
number of LUNs supported by devices that only support address 
method 00b; the 8-bit TARGET OR LUN field portion of the first two 
bytes of the LUN.

c) first two bytes set to 0..65535: the possible LUNs supported by 
devices with protocols with 2-byte LUN fields.  I think scanning this 
many would take too long, though, and might trigger bugs in 
devices that don't decode the LUN correctly.


