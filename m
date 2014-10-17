From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/5] block: add function to issue compare and write
Date: Fri, 17 Oct 2014 19:38:37 -0400
Message-ID: <yq1egu62rnm.fsf@sermon.lab.mkp.net>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
	<1413437835-13778-3-git-send-email-michaelc@cs.wisc.edu>
	<20141017095555.GA360@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20141017095555.GA360@infradead.org> (Christoph Hellwig's message
	of "Fri, 17 Oct 2014 02:55:55 -0700")
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> We already have req->cmd_type which actually is a fairly good
Christoph> description of what we get except for REQ_TYPE_FS, which is a
Christoph> horrible overload using req->cmd_flags.

Christoph> Given that you're just one of many currently ongoing patches
Christoph> to add more flags here I think you need to byte the bullet
Christoph> and fix this up by replacing REQ_TYPE_FS with:

Christoph> REQ_TYPE_WRITE REQ_TYPE_READ REQ_TYPE_FLUSH REQ_TYPE_DISCARD
Christoph> REQ_TYPE_WRITE_SAME REQ_TYPE_CMP_AND_WRITE

The problem with this is that, as it stands, a bio has no type. And it
would suck if we couldn't keep bio rw and request flags in sync.

I wonder if it would make more sense to move the remaining rq types to
cmd_flags after I'm done with the 64-bit conversion?

-- 
Martin K. Petersen	Oracle Linux Engineering
