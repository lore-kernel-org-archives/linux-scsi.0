From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: Some interesting results in the aic7xxx slowdown problem
Date: Tue, 30 Aug 2005 10:19:56 +0530
Message-ID: <20050830044956.GA4187@in.ibm.com>
References: <1123119347.5019.78.camel@mulgrave> <20050804061809.GA4158@in.ibm.com> <1123166928.5026.8.camel@mulgrave> <20050819095428.GA9130@in.ibm.com> <1124457765.5130.13.camel@mulgrave> <20050825103943.GA7421@in.ibm.com> <1125328875.5089.37.camel@mulgrave>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:18847 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S932122AbVH3ElD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 00:41:03 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7U4erot187334
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 00:40:53 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7U4erLB447208
	for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 22:40:53 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7U4erXn005991
	for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 22:40:53 -0600
Content-Disposition: inline
In-Reply-To: <1125328875.5089.37.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 29, 2005 at 10:21:15AM -0500, James Bottomley wrote:
> ailer: Evolution 2.0.4 (2.0.4-6) 
> Content-Transfer-Encoding: 7bit
> X-Virus-Scanned: amavisd-new at linux.ibm.com
> Status: RO
> Content-Length: 1065
> Lines: 28
> 
> On Thu, 2005-08-25 at 16:09 +0530, Suparna Bhattacharya wrote:
> > On Fri, Aug 19, 2005 at 09:22:45AM -0400, James Bottomley wrote:
> > > On Fri, 2005-08-19 at 15:24 +0530, Suparna Bhattacharya wrote:
> > > >  sda:
> > > 
> > > Well, this line is identifying the root cause.  It says that the
> > > partition code came up with no partitions for this device.  Do any of
> > > your other devices come up with paritions? (as in could this be a simple
> > > device node transposition issue?)
> > 
> > Yes, it looks like that. The ordering now seems to be id 9, 10, ... 14, 0,
> > 1, 2, instead of the default of id 0, 1, 2 ...  Did you expect a change
> > in probe ordering ? 
> > 
> > When I switch back to the old AIC driver the ordering goes back to
> > default.
> 
> Er, boggle!
> 
> I know of no change to the new driver that could affect the target
> scanning order (this is target, not lun, right?).  Target scan should be
> handled sequentially in 

Here is what the log looks like:

ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 17 (level, low) -> IRQ 17
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7896/97 Ultra2 SCSI adapter>
        aic7896/97: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs

 target0:0:9: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:9:0: Tagged Queuing enabled.  Depth 32
 target0:0:9: Beginning Domain Validation
 target0:0:9: wide asynchronous.
 target0:0:9: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target0:0:9: Ending Domain Validation
 target0:0:10: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:10:0: Tagged Queuing enabled.  Depth 32
 target0:0:10: Beginning Domain Validation
 target0:0:10: wide asynchronous.
 target0:0:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target0:0:10: Ending Domain Validation
 target0:0:11: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:11:0: Tagged Queuing enabled.  Depth 32
 target0:0:11: Beginning Domain Validation
 target0:0:11: wide asynchronous.
 target0:0:11: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target0:0:11: Ending Domain Validation
 target0:0:12: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:12:0: Tagged Queuing enabled.  Depth 32
 target0:0:12: Beginning Domain Validation
 target0:0:12: wide asynchronous.
 target0:0:12: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target0:0:12: Ending Domain Validation
 target0:0:13: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:13:0: Tagged Queuing enabled.  Depth 32
 target0:0:13: Beginning Domain Validation
 target0:0:13: wide asynchronous.
 target0:0:13: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target0:0:13: Ending Domain Validation
 target0:0:14: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi0:A:14:0: Tagged Queuing enabled.  Depth 32
 target0:0:14: Beginning Domain Validation
 target0:0:14: wide asynchronous.
 target0:0:14: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target0:0:14: Ending Domain Validation
  Vendor: IBM       Model: EXP300   S160     Rev: D014
  Type:   Processor                          ANSI SCSI revision: 03
 target0:0:15: asynchronous.
 target0:0:15: Beginning Domain Validation
 target0:0:15: Domain Validation skipping write tests
(scsi0:A:15:0): refuses synchronous negotiation. Using asynchronous transfers
 target0:0:15: Ending Domain Validation
ACPI: PCI Interrupt 0000:00:01.1[A] -> GSI 17 (level, low) -> IRQ 17
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7896/97 Ultra2 SCSI adapter>
        aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs

 target1:0:0: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
 target1:0:0: Beginning Domain Validation
 target1:0:0: wide asynchronous.
 target1:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target1:0:0: Ending Domain Validation
 target1:0:1: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
 target1:0:1: Beginning Domain Validation
 target1:0:1: wide asynchronous.
 target1:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target1:0:1: Ending Domain Validation
 target1:0:2: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:2:0: Tagged Queuing enabled.  Depth 32
 target1:0:2: Beginning Domain Validation
 target1:0:2: wide asynchronous.
 target1:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target1:0:2: Ending Domain Validation
  Vendor: IBM-ESXS  Model: DTN018C1UCDY10F   Rev: S25J
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target1:0:3: asynchronous.
scsi1:A:3:0: Tagged Queuing enabled.  Depth 32
 target1:0:3: Beginning Domain Validation
 target1:0:3: wide asynchronous.
 target1:0:3: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
 target1:0:3: Ending Domain Validation
  Vendor: IBM       Model: AuSaV1S2          Rev: 0   
  Type:   Processor                          ANSI SCSI revision: 02
 target1:0:8: asynchronous.
 target1:0:8: Beginning Domain Validation
 target1:0:8: Ending Domain Validation
SCSI device sda: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sda: drive cache: write through
SCSI device sda: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sda: drive cache: write through
 sda:
Attached scsi disk sda at scsi0, channel 0, id 9, lun 0
SCSI device sdb: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdb: drive cache: write through
SCSI device sdb: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdb: drive cache: write through
 sdb: unknown partition table
Attached scsi disk sdb at scsi0, channel 0, id 10, lun 0
SCSI device sdc: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdc: drive cache: write through
SCSI device sdc: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdc: drive cache: write through
 sdc: sdc1
Attached scsi disk sdc at scsi0, channel 0, id 11, lun 0
SCSI device sdd: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdd: drive cache: write through
SCSI device sdd: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdd: drive cache: write through
 sdd: sdd1
Attached scsi disk sdd at scsi0, channel 0, id 12, lun 0
SCSI device sde: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sde: drive cache: write through
SCSI device sde: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sde: drive cache: write through
 sde: sde1 sde2 sde3 sde4
Attached scsi disk sde at scsi0, channel 0, id 13, lun 0
SCSI device sdf: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdf: drive cache: write through
SCSI device sdf: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdf: drive cache: write through
 sdf: sdf1
Attached scsi disk sdf at scsi0, channel 0, id 14, lun 0
SCSI device sdg: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdg: drive cache: write through
SCSI device sdg: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdg: drive cache: write through
 sdg: sdg1 sdg2 sdg3 sdg4 < sdg5 sdg6 >
Attached scsi disk sdg at scsi1, channel 0, id 0, lun 0
SCSI device sdh: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdh: drive cache: write through
SCSI device sdh: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdh: drive cache: write through
 sdh: sdh1 sdh2 sdh3 sdh4 < sdh5 >
Attached scsi disk sdh at scsi1, channel 0, id 1, lun 0
SCSI device sdi: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdi: drive cache: write through
SCSI device sdi: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdi: drive cache: write through
 sdi: sdi1
Attached scsi disk sdi at scsi1, channel 0, id 2, lun 0
SCSI device sdj: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdj: drive cache: write through
SCSI device sdj: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sdj: drive cache: write through
 sdj: sdj1
Attached scsi disk sdj at scsi1, channel 0, id 3, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 9, lun 0,  type 0
Attached scsi generic sg1 at scsi0, channel 0, id 10, lun 0,  type 0
Attached scsi generic sg2 at scsi0, channel 0, id 11, lun 0,  type 0
Attached scsi generic sg3 at scsi0, channel 0, id 12, lun 0,  type 0
Attached scsi generic sg4 at scsi0, channel 0, id 13, lun 0,  type 0
Attached scsi generic sg5 at scsi0, channel 0, id 14, lun 0,  type 0
Attached scsi generic sg6 at scsi0, channel 0, id 15, lun 0,  type 3
Attached scsi generic sg7 at scsi1, channel 0, id 0, lun 0,  type 0
Attached scsi generic sg8 at scsi1, channel 0, id 1, lun 0,  type 0
Attached scsi generic sg9 at scsi1, channel 0, id 2, lun 0,  type 0
Attached scsi generic sg10 at scsi1, channel 0, id 3, lun 0,  type 0
Attached scsi generic sg11 at scsi1, channel 0, id 8, lun 0,  type 3
ieee1394: raw1394: /dev/raw1394 device initialized

Regards
Suparna

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

