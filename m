From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: standards revisions
Date: Sun, 07 Oct 2012 09:16:13 +0100
Message-ID: <1349597773.2541.12.camel@dabdike.int.hansenpartnership.com>
References: <20121007014900.GA30316@infradead.org>
	 <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2012-10-06 at 23:11 -0700, Nicholas A. Bellinger wrote:
> On Sat, 2012-10-06 at 21:49 -0400, Christoph Hellwig wrote:
> > Currenly all non-pscsi bakcneds report their standards version as
> > SPC 2 via ->get_device_rev.
> 
> No, the proper on-the-wire bits to signal SPC-3 compliance are already
> being returned by virtual backend drivers within standard INQUIRY
> payload data.  
> 
> Notice the comment:
> 
> root@tifa:/usr/src/target-pending.git# grep SCSI_SPC_2 drivers/target/*.c
> drivers/target/target_core_file.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
> drivers/target/target_core_iblock.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
> drivers/target/target_core_rd.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */

That's causing confusion, I think!

> >  In addition to putting it into the
> > inquirty data in spc_emulate_inquiry_std we also use it in two
> > places to check on the version of the persistent reservation and
> > alua support.  What is the benefit of supporting the old-style SCSI 2
> > reservations and ALUA support when they can't be used at all with
> > the virtual backends, and can only be used in the corner case emulated
> > ALUA/PR support for pscsi?
> > 
> 
> It's the include/scsi/scsi.h SCSI_3 + SCSI_SPC_* version definition
> names that are incorrect:
> 
> #define SCSI_UNKNOWN    0
> #define SCSI_1          1
> #define SCSI_1_CCS      2
> #define SCSI_2          3
> #define SCSI_3          4        /* SPC */
> #define SCSI_SPC_2      5
> #define SCSI_SPC_3      6
> 
> from spc4r30 section 6.4.2 Standard INQUIRY data, Table 142 -- Version:
> 
>    00h     The device server does not claim conformance to any standard.
> 01h to 02h Obsolete
>    03h     The device server complies to ANSI INCITS 301-1997 (a withdrawn standard).
>    04h     The device server complies to ANSI INCITS 351-2001 (SPC-2).
>    05h     The device server complies to ANSI INCITS 408-2005 (SPC-3).
>    06h     The device server complies to this standard.
> 
> How about the following patch to fix the long-standing incorrect name
> usage of these three scsi.h defines..?

Because it's not incorrect.  Your confusion is that the SCSI_ constants
should match the inquiry data ... they shouldn't.  Look where we set
scsi_level in scsi_scan.c:708-713.  We have to fit an extra identifier
for SCSI_1_CCS so the scsi_level doesn't actually match the inquiry
data; it's incremented by 1 for SCSI_3 and above.  SCSI_3 does exist, by
the way, it was defined in the first version of SPC and there are some
devices which conform to it.

James
