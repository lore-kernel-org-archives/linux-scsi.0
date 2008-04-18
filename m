From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] results of endianness review of qla2xxx
Date: Fri, 18 Apr 2008 20:06:58 +0100
Message-ID: <20080418190658.GI27459@ZenIV.linux.org.uk>
References: <20080416055458.GC27459@ZenIV.linux.org.uk> <20080418181758.GJ22973@plap4.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:33756 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131AbYDRTG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2008 15:06:59 -0400
Content-Disposition: inline
In-Reply-To: <20080418181758.GJ22973@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Seokmann Ju <seokmann.ju@qlogic.com>

On Fri, Apr 18, 2008 at 11:17:58AM -0700, Andrew Vasquez wrote:
> > 7) qla2x00_async_event():
> > 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> > 		...
> > 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> > 		handles[1] = le32_to_cpu(
> > 		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
> > and then those values are passed to qla2x00_process_completed_request() which
> > expects a host-endian (and uses it as index in array, among other things).
> 
> THis is correct (though a bit confuscated), each of the two 16bit
> mailbox-registers makes-up a 32bit LE value, which is converted to
> cpu-endian and passed to qla2x00_process_completed_request().

Um, no.  First of all, other branches in that switch clearly assume
that mb[] is already host-endian.  But leaving that aside, what you
are doing here will _not_ work even if mb[1] and mb[2] are l-e in
this case.

Look what happens:
* l-e host:
	handles[0] = (mb[2] << 16) | mb[1], which is equal to
(le16_to_cpu(mb[2]) << 16) | le16_to_cpu(mb[1])
* on b-e host:
	handles[0] = swab32((mb[2] << 16) | mb[1]), which is equal to
(swab16(mb[1]) << 16) | swab16(mb[2]), which is equal to
(le16_to_cpu(mb[1]) << 16) | le16_to_cpu(mb[2])

IOW, resulting host-endian value will be different with the same contents
in mb[].  Put it another way, suppose you have mb[1] == 0, mb[2] == 0x101.
Then on l-e you'll get handles[0] == 0x10100 and on b-e - 0x101.  The latter
will pass the check for index being too high, the former will fail...

BTW, RD_MAILBOX_REG() boils down to readw(), which is definitely host-endian.
And we have
                        mb[0] = MBA_SCSI_COMPLETION;
                        mb[1] = MSW(stat);
                        mb[2] = RD_MAILBOX_REG(ha, reg, 2);
                        qla2x00_async_event(ha, mb);
so there's at least one path reaching qla2x00_async_event() with mb[0]
equal to MBA_SCSI_COMPLETION and mb[2] containing host-endian...  Looking
at the contents of stat and the things we do to it (switch (stat & 0xff) right
outside that code), mb[1] is host-endian as well...  AFAICS, the same holds
for all codepaths - contents of mb[] is host-endian.

> > 9) qla2x00_clear_nvram_protection():
> >         wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
> > 	stat = qla2x00_write_nvram_word_tmo(ha, ha->nvram_base,
> > 		    __constant_cpu_to_le16(0x1234), 100000);
> > 	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
> > 	if (stat != QLA_SUCCESS || wprot != 0x1234) {
> > Odd, since qla2x00_get_nvram_word() returns a host-endian and 
> > qla2x00_write_nvram_word_tmo() expects one (this stuff is bit-banging
> > 16bit values through).
> 
> Odd, yes.  I was never happy with this endianess intermixing, but
> after numerous cycles within our qual-testing, this code works in both
> big and little-endian systems...

It looks like check that location is writable; what happens if you replace
the first instance with 0x1234 and the second (in wprot == ...) with
cpu_to_le16(0x1234)?  One "we won't find it there by accident, must've been
successful write" value seems to be as good as other, unless something else
is going on...
