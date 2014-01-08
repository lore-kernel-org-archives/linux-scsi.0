From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: status of block-integrity
Date: Wed, 08 Jan 2014 10:43:11 -0500
Message-ID: <yq1ha9ev5rk.fsf@sermon.lab.mkp.net>
References: <20131222192128.GA28532@infradead.org>
	<yq11u134rmt.fsf@sermon.lab.mkp.net> <52CBBABD.50902@gmail.com>
	<52CC0216.5060900@suse.de> <20140107233410.GA1263@parisc-linux.org>
	<1389139510.2064.22.camel@dabdike.pnp.gw>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1389139510.2064.22.camel@dabdike.pnp.gw> (James Bottomley's
	message of "Wed, 08 Jan 2014 08:05:10 +0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.de>, Ric Wheeler <ricwheeler@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> No, I think you're confusing algorithms with protocols.  DIF and
James> DIX are two names for protection envelopes.  DIF verifies
James> integrity from the HBA to the device surface.  DIX verifies
James> integrity from an application to the HBA. 

Actually, DIX is a data integrity-aware HBA programming interface. We
have an implementation of that interface in the SCSI layer and in some
of the initiator drivers (lpfc, qla2xxx, mptNsas).

There is no single name for stuff above DIX. Other than "block layer
data integrity goo", "page cache black magic" and "let's add a few
fields to struct iocb".

James> So, the question is do we need to bother with DIX at all?  No
James> filesystem uses it 

...explicitly. Every filesystem uses it implicitly. There are only two
reasons for filesystems to want to be explicitly "block layer data
integrity goo"-aware:

     1. To be able to use the application tag space for back pointers or
        other metadata without requiring disk format changes.

     2. To facilitate passthrough of protection information submitted
        via the $TBD application programming interface.

I was hoping the extN folks would be interested in (1) but there were no
takers. (2) is hard but not forgotten. In any case the status quo is
that there is no point in filesystems manually generating protection
information when the block layer is going to do it for them when the bio
is submitted.

-- 
Martin K. Petersen	Oracle Linux Engineering
