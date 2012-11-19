From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
 support
Date: Mon, 19 Nov 2012 12:38:18 +0100
Message-ID: <50AA1A2A.2070504@redhat.com>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org> <1352405238-23267-4-git-send-email-nab@linux-iscsi.org> <20121115110432.GD28956@infradead.org> <1353007786.4447.29.camel@haakon2.linux-iscsi.org> <20121115193235.GA5714@lst.de> <94D0CD8314A33A4D9D801C0FE68B40294CCF8D45@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40294CCF8D45@G9W0745.americas.hpqcorp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Il 15/11/2012 21:01, Elliott, Robert (Server Storage) ha scritto:
> WRITE SAME always has a payload, regardless of the UNMAP bit value.
> 
> For WRITE SAME with UNMAP=0, it's extremely important; that's how
> what to write is specified.
> 
> For WRITE SAME with UNMAP=1, the device server is required to check
> that the payload matches the data that is returned for unmapped LBAs.
> lf LBPRZ=1 (read zeros for unmapped LBAs), that means checking that
> the payload has all zeros.  In sbc3r33, this rule is tucked away in
> model section 4.7.3.4.3, not the command section 5.41.

Does that mean that LBPRZ=0, LPBWS=1 is practically an invalid
combination?  Because there's no real way for the device server to
perform the check successfully.

Paolo

> I would like to change that rule (it's a nuisance and a performance
> burden), but that's the current rule going into SBC-3 letter ballot.
> 
> Changing WRITE SAME with UNMAP=1 to ignore the payload would provide
> essentially the same functionality as changing the UNMAP command to
> be mandatory, not just a hint; both approaches have been discussed.
