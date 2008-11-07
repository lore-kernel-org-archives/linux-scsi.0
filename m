From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 15:19:13 -0500
Message-ID: <20081107201913.GI29717@mit.edu>
References: <yq1r65na5ll.fsf@sermon.lab.mkp.net> <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu> <yq1iqqz9uqt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1iqqz9uqt.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2008 at 02:55:06PM -0500, Martin K. Petersen wrote:
> 
> The current UNMAP proposal in SCSI doesn't have requirements either.
> 
> Array vendors, suddenly realizing all the work they have to do to
> support this, are now talking about imposing additional constraints
> (orthogonal to the UNMAP command set) because of limitations in their
> existing firmware architectures.

Let's be just a *little* bit fair here.  Suppose we wanted to
implement thin-provisioned disks using devicemapper and LVM; consider
that LVM uses a default PE size of 4M for some very good reasons.
Asking filesystems to be a little smarter about allocation policies so
that we allocate in existing 4M chunks before going onto the next, and
asking the block layer to pool trim requests to 4M chunks is not
totally unreasonable.

Array vendors use chunk sizes > than typical filesystem chunk sizes
for the same reason that LVM does.  So to say that this is due to
purely a "broken firmware architecture" is a little unfair.

Regards,

							- Ted
