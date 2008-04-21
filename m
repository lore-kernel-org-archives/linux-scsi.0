From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] results of endianness review of qla2xxx
Date: Mon, 21 Apr 2008 10:26:46 -0700
Message-ID: <20080421172646.GC45789@plap4.qlogic.org>
References: <20080416055458.GC27459@ZenIV.linux.org.uk> <20080418181758.GJ22973@plap4.local> <20080418190658.GI27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8307 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbYDUR0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 13:26:47 -0400
Content-Disposition: inline
In-Reply-To: <20080418190658.GI27459@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, Seokmann Ju <seokmann.ju@qlogic.com>

On Fri, 18 Apr 2008, Al Viro wrote:

> On Fri, Apr 18, 2008 at 11:17:58AM -0700, Andrew Vasquez wrote:
> > > 7) qla2x00_async_event():
> > > 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> > > 		...
> > > 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
> > > 		handles[1] = le32_to_cpu(
> > > 		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
> > > and then those values are passed to qla2x00_process_completed_request() which
> > > expects a host-endian (and uses it as index in array, among other things).
> > 
> > THis is correct (though a bit confuscated), each of the two 16bit
> > mailbox-registers makes-up a 32bit LE value, which is converted to
> > cpu-endian and passed to qla2x00_process_completed_request().
> 
> Um, no.  First of all, other branches in that switch clearly assume
> that mb[] is already host-endian.  But leaving that aside, what you
> are doing here will _not_ work even if mb[1] and mb[2] are l-e in
> this case.
> 
> Look what happens:
> * l-e host:
> 	handles[0] = (mb[2] << 16) | mb[1], which is equal to
> (le16_to_cpu(mb[2]) << 16) | le16_to_cpu(mb[1])
> * on b-e host:
> 	handles[0] = swab32((mb[2] << 16) | mb[1]), which is equal to
> (swab16(mb[1]) << 16) | swab16(mb[2]), which is equal to
> (le16_to_cpu(mb[1]) << 16) | le16_to_cpu(mb[2])
> 
> IOW, resulting host-endian value will be different with the same contents
> in mb[].  Put it another way, suppose you have mb[1] == 0, mb[2] == 0x101.
> Then on l-e you'll get handles[0] == 0x10100 and on b-e - 0x101.  The latter
> will pass the check for index being too high, the former will fail...
> 
> BTW, RD_MAILBOX_REG() boils down to readw(), which is definitely host-endian.
> And we have
>                         mb[0] = MBA_SCSI_COMPLETION;
>                         mb[1] = MSW(stat);
>                         mb[2] = RD_MAILBOX_REG(ha, reg, 2);
>                         qla2x00_async_event(ha, mb);
> so there's at least one path reaching qla2x00_async_event() with mb[0]
> equal to MBA_SCSI_COMPLETION and mb[2] containing host-endian...  Looking
> at the contents of stat and the things we do to it (switch (stat & 0xff) right
> outside that code), mb[1] is host-endian as well...  AFAICS, the same holds
> for all codepaths - contents of mb[] is host-endian.

Yes, all mb[] "values" are going to be in host-endian format.

But, what's missing here is an understanding of what mb[2] and mb[1]
are representing during MBA_SCSI_COMPLETION and MBA_CMPLT_2_32BIT
handling.  Upon command submission, a 32bit handle (cookie) is
associated with each IOCB:

	...
	cmd_pkt = (cmd_entry_t *)ha->request_ring_ptr;
	cmd_pkt->handle = handle;
	/* Zero out remaining portion of packet. */
	clr_ptr = (uint32_t *)cmd_pkt + 2;
	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);

	/* Set target ID and LUN number*/
	SET_TARGET_ID(ha, cmd_pkt->target, sp->fcport->loop_id);
	cmd_pkt->lun = cpu_to_le16(sp->cmd->device->lun);
	...

Notice that the 'handle'-value is assigned to the command-IOCB
structure in host-endian format and *not* the typical little-endian
form used to fill-in the other non-byte-sized members of the
structure.  So, for example, start with a hypothetical 'handle' value
of 0x12345678.  On an BE machine, the layout in memory of the value
written to the structure will be:

	mem[0]	mem[1]	mem[2]	mem[3]
	------	------	-----	------
	12	34	56	78

On an LE machine:

	mem[0]	mem[1]	mem[2]	mem[3]
	------	------	-----	------
	78	56	34	12

'handle' sent as a host-endian value is done for a reason, as
typically, firmware reports IOCB completion via a structure called the
status-IOCB [2]:

	#define STATUS_TYPE     0x03            /* Status entry. */
	typedef struct {
		uint8_t entry_type;             /* Entry type. */
		uint8_t entry_count;            /* Entry count. */
		uint8_t sys_define;             /* System defined. */
		uint8_t entry_status;           /* Entry Status. */
		uint32_t handle;                /* System handle. */
		uint16_t scsi_status;           /* SCSI status. */
		...

where, during creation of the status-IOCB by firmware, the
'handle'-value (at offset 0x4) is copied from the 'handle' specified
from the command-IOCB.  Since this 'handle' is a a simple index (in
host-endian format) into the outstanding_cmds array of the HBA,
there's really no reason to convert the value to little-endian format
at submission time, then convert from little-endian to host-endian
form during status-IOCB handling within the driver [3]:

	...
	/* Fast path completion. */
	if (comp_status == CS_COMPLETE && scsi_status == 0) {
		qla2x00_process_completed_request(ha, sts->handle);

		return;
	}

So, getting back to MBA_SCSI_COMPLETION and MBA_CMPLT_2_32BIT
completions, the "value" of the mailbox registers returned by firmware
are:

	mb[1]: mem[1] << 8 | mem[0]
	mb[2]: mem[3] << 8 | mem[2]

which on an LE machine result in:

	mb[1]: 0x5678
	mb[2]: 0x1234

	handle[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
	handle[0] = (0x1234 << 16) | 0x5678)
	handle[0] = 0x12345678

and on an BE machine the values are:

	mb[1]: 0x3412
	mb[2]: 0x7856

	handle[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
	handle[0] = swab32((0x7856 << 16) | 0x3412)
	handle[0] = swab32(0x78563412)
	handle[0] = 0x12345678

> > > 9) qla2x00_clear_nvram_protection():
> > >         wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
> > > 	stat = qla2x00_write_nvram_word_tmo(ha, ha->nvram_base,
> > > 		    __constant_cpu_to_le16(0x1234), 100000);
> > > 	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
> > > 	if (stat != QLA_SUCCESS || wprot != 0x1234) {
> > > Odd, since qla2x00_get_nvram_word() returns a host-endian and 
> > > qla2x00_write_nvram_word_tmo() expects one (this stuff is bit-banging
> > > 16bit values through).
> > 
> > Odd, yes.  I was never happy with this endianess intermixing, but
> > after numerous cycles within our qual-testing, this code works in both
> > big and little-endian systems...
> 
> It looks like check that location is writable; what happens if you replace
> the first instance with 0x1234 and the second (in wprot == ...) with
> cpu_to_le16(0x1234)?  One "we won't find it there by accident, must've been
> successful write" value seems to be as good as other, unless something else
> is going on...

One would hope so, yes...

Anyway, hope that helped...

--
av

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/scsi/qla2xxx/qla_iocb.c;h=5489d5024673a326b5345f5545151a7dab37a533;hb=HEAD#l346

[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/scsi/qla2xxx/qla_def.h;h=094d95f0764c6027cb421e4d3e5da9bf17012dfd;hb=HEAD#l1259

[3] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/scsi/qla2xxx/qla_isr.c;h=285479b62d8f02084ad0daebc12ab249f16348c0;hb=HEAD#l944
