From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 11:00:38 -0500
Message-ID: <yq1r65na5ll.fsf@sermon.lab.mkp.net>
References: <4913028B.6010405@redhat.com>
	<1225984628.4703.80.camel@localhost.localdomain>
	<Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	<20081107120534.GO21867@kernel.dk>
	<1226072970.15281.46.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1226072970.15281.46.camel@think.oraclecorp.com> (Chris Mason's message of "Fri\, 07 Nov 2008 10\:49\:30 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:

Chris> Hmmm, it's surprising to me that arrays who tell us please use
Chris> the noop elevator suddenly want us to merge discard requests.
Chris> The array really needs to be able to deal with this internally.

Let's also not forget that we're talking about merging discard
requests for the purpose making internal array housekeeping efficient.
That involves merging discards up to the internal array block sizes
which may be on the order of 512/768/1024 KB.

If we were talking about merging discards up to a 4/8/16 KB boundary
that might be something we'd have a chance to do within a reasonable
amount of time (bigger than normal read/write I/O but not hours).

But keeping discard state around for long enough to attempt to
aggregate 768KB (and 768KB-aligned) chunks is icky.

-- 
Martin K. Petersen	Oracle Linux Engineering
