From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
 support
Date: Mon, 19 Nov 2012 23:19:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40294CCFA059@G9W0745.americas.hpqcorp.net>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
 <1352405238-23267-4-git-send-email-nab@linux-iscsi.org>
 <20121115110432.GD28956@infradead.org>
 <1353007786.4447.29.camel@haakon2.linux-iscsi.org>
 <20121115193235.GA5714@lst.de>
 <94D0CD8314A33A4D9D801C0FE68B40294CCF8D45@G9W0745.americas.hpqcorp.net>
 <50AA1A2A.2070504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:27612 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2KSXVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 18:21:11 -0500
In-Reply-To: <50AA1A2A.2070504@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>



> -----Original Message-----
> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo
> Bonzini
> Sent: Monday, 19 November, 2012 5:38 AM
> To: Elliott, Robert (Server Storage)
> Cc: Christoph Hellwig; Nicholas A. Bellinger; Christoph Hellwig; target-devel;
> linux-scsi; linux-kernel; Martin K. Petersen
> Subject: Re: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0
> emulation support
> 
> Il 15/11/2012 21:01, Elliott, Robert (Server Storage) ha scritto:
> > WRITE SAME always has a payload, regardless of the UNMAP bit value.
> >
> > For WRITE SAME with UNMAP=0, it's extremely important; that's how
> > what to write is specified.
> >
> > For WRITE SAME with UNMAP=1, the device server is required to check
> > that the payload matches the data that is returned for unmapped LBAs.
> > lf LBPRZ=1 (read zeros for unmapped LBAs), that means checking that
> > the payload has all zeros.  In sbc3r33, this rule is tucked away in
> > model section 4.7.3.4.3, not the command section 5.41.
> 
> Does that mean that LBPRZ=0, LPBWS=1 is practically an invalid
> combination?  Because there's no real way for the device server to
> perform the check successfully.
>

Yes; that would only be practical if the device server knows the pattern
(e.g., all ones) that it will return for reads of unmapped LBAs. It's not
very useful if the pattern is simply the last content and could differ
for every LBA.

For consumer SSDs, the data returned for unmapped (i.e. trimmed)
LBAs didn't really matter.

For SSDs to be used in RAID arrays, however:
a) non-deterministic data is unworkable (RAID parity would never be right);
b) deterministic data can be accommodated, but the RAID stack needs to read the
LBA after unmapping to see what pattern resulted and recalculate parity, hurting
performance; and
c) deterministic zeros are ideal (0 XOR n = n).



> Paolo
> 
> > I would like to change that rule (it's a nuisance and a performance
> > burden), but that's the current rule going into SBC-3 letter ballot.
> >
> > Changing WRITE SAME with UNMAP=1 to ignore the payload would
> provide
> > essentially the same functionality as changing the UNMAP command to
> > be mandatory, not just a hint; both approaches have been discussed.
