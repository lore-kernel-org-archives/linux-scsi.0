From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: standards revisions
Date: Tue, 09 Oct 2012 12:57:22 -0700
Message-ID: <1349812642.3776.87.camel@haakon2.linux-iscsi.org>
References: <20121007014900.GA30316@infradead.org>
	 <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
	 <1349597773.2541.12.camel@dabdike.int.hansenpartnership.com>
	 <1349633507.13843.47.camel@haakon2.linux-iscsi.org>
	 <1349682320.2615.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349682320.2615.6.camel@dabdike.int.hansenpartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-10-08 at 08:45 +0100, James Bottomley wrote:
> On Sun, 2012-10-07 at 11:11 -0700, Nicholas A. Bellinger wrote:
> > On Sun, 2012-10-07 at 09:16 +0100, James Bottomley wrote:
> > > On Sat, 2012-10-06 at 23:11 -0700, Nicholas A. Bellinger wrote:
> > > > On Sat, 2012-10-06 at 21:49 -0400, Christoph Hellwig wrote:
> > > > > Currenly all non-pscsi bakcneds report their standards version as
> > > > > SPC 2 via ->get_device_rev.
> > > > 
> > > > No, the proper on-the-wire bits to signal SPC-3 compliance are already
> > > > being returned by virtual backend drivers within standard INQUIRY
> > > > payload data.  
> > > > 
> > > > Notice the comment:
> > > > 
> > > > root@tifa:/usr/src/target-pending.git# grep SCSI_SPC_2 drivers/target/*.c
> > > > drivers/target/target_core_file.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
> > > > drivers/target/target_core_iblock.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
> > > > drivers/target/target_core_rd.c:	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
> > > 
> > > That's causing confusion, I think!
> > > 
> > > > >  In addition to putting it into the
> > > > > inquirty data in spc_emulate_inquiry_std we also use it in two
> > > > > places to check on the version of the persistent reservation and
> > > > > alua support.  What is the benefit of supporting the old-style SCSI 2
> > > > > reservations and ALUA support when they can't be used at all with
> > > > > the virtual backends, and can only be used in the corner case emulated
> > > > > ALUA/PR support for pscsi?
> > > > > 
> > > > 
> > > > It's the include/scsi/scsi.h SCSI_3 + SCSI_SPC_* version definition
> > > > names that are incorrect:
> > > > 
> > > > #define SCSI_UNKNOWN    0
> > > > #define SCSI_1          1
> > > > #define SCSI_1_CCS      2
> > > > #define SCSI_2          3
> > > > #define SCSI_3          4        /* SPC */
> > > > #define SCSI_SPC_2      5
> > > > #define SCSI_SPC_3      6
> > > > 
> > > > from spc4r30 section 6.4.2 Standard INQUIRY data, Table 142 -- Version:
> > > > 
> > > >    00h     The device server does not claim conformance to any standard.
> > > > 01h to 02h Obsolete
> > > >    03h     The device server complies to ANSI INCITS 301-1997 (a withdrawn standard).
> > > >    04h     The device server complies to ANSI INCITS 351-2001 (SPC-2).
> > > >    05h     The device server complies to ANSI INCITS 408-2005 (SPC-3).
> > > >    06h     The device server complies to this standard.
> > > > 
> > > > How about the following patch to fix the long-standing incorrect name
> > > > usage of these three scsi.h defines..?
> > > 
> > > Because it's not incorrect.  Your confusion is that the SCSI_ constants
> > > should match the inquiry data ... they shouldn't.
> > 
> > No, my current confusion is stemming from why it's OK for SCSI_SPC_[2,3]
> > constant names+values to not match what is actually defined in SPC-4
> > drafts for what target INQUIRY emulation bits end up going 'over the
> > wire'.
> 
> OK, I don't understand what you didn't get about the explanation below.
> But the gist is it's not a constant representing inquiry[2]&7; it's an
> ordered set of enumerations representing gross capabilities abstracted
> into sdev->scsi_level.
> 

Yes, there is no confusion on how scsi-core is working here..

> > > SCSI_3 does exist, by
> > > the way, it was defined in the first version of SPC and there are some
> > > devices which conform to it.
> > > 
> > 
> > Regardless, SCSI_SPC_[2,3] -> SCSI_SPC[3,4] constants for target-core +
> > scsi-core should still be re-named to avoid the extra confusion this
> > introduces for folks reading code.
> 
> I'm not convinced there is confusion; this use of enumerated levelling
> goes back to 2.2 and no-one else has had a problem with it.  You're the
> only one whose had an issue and it does seem to be because you didn't
> bother reading the comment above their definitions in the header file
> which does explain what's going on.
> 

The point is that it would be nice to have constants representing
on-the-wire values in scsi.h that both scsi-core and target-core can
use.

What about just defining the proper 'on-the-wire' that target-core needs
instead..?

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..13ee02b 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -541,6 +541,13 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define SCSI_SPC_3      6
 
 /*
+ * ANSI INCITS Standard INQUIRY resp[2] version bits
+ */
+#define SCSI_ANSIVER_SPC2      0x04    /* ANSI INCITS 351-2001 (SPC-2) */
+#define SCSI_ANSIVER_SPC3      0x05    /* ANSI INCITS 408-2005 (SPC-3) */
+#define SCSI_ANSIVER_SPC4      0x06    /* SPC-4 standard draft */
+
+/*
  * INQ PERIPHERAL QUALIFIERS
  */
 #define SCSI_INQ_PQ_CON         0x00
