From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: status of block-integrity
Date: Wed, 08 Jan 2014 10:23:51 -0500
Message-ID: <yq1lhyqv6ns.fsf@sermon.lab.mkp.net>
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>
	<yq1wqigzvc1.fsf@sermon.lab.mkp.net>
	<20140107013646.GB10297@birch.djwong.org> <52CBAA1B.7000509@suse.de>
	<yq1a9f7wjqr.fsf@sermon.lab.mkp.net> <52CCFADB.6080909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52CCFADB.6080909@suse.de> (Hannes Reinecke's message of "Wed, 08
	Jan 2014 08:14:35 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, chuck.lever@oracle.com, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes,

Hannes> As there is no user (apart from oracleasm) no-one can attach
Hannes> protection information to any data, so even the most dedicated
Hannes> admin cannot exercise this path, let alone find issues here.

That's not how it works!

If the filesystem has not attached protection information to a bio the
block layer will do it for you. The block layer generates protection
information for writes and verifies it for reads. That's how it's worked
since day one. The code is there, it is used by everyone with a
DIX-capable HBA. See Documentation/block/data-integrity.txt.

Normal applications do not want to have to deal with generating
protection information, using an async I/O model, keeping completion
state around for extended periods of time to figure out whether the I/O
actually completed or not and so on. So the kernel-to-platter protection
scheme we have in place now is good enough.

That doesn't mean that I'm not interested in augmenting libaio. I
am. Very. And I know of several applications that are keen to use
it. But getting page cache passthrough and filesystem interaction
working is non-trivial. That's what has inhibited progress, not
extending the libaio API.

Hannes> Doug Gilbert and I are currently discussing LID4 / ROD Token
Hannes> copy for sg3_utils and the block layer, so any patches would be
Hannes> very helpful here.

I'm only doing LID1 right now. Any particular reason you are exploring
LID4 and ROD?

I resumed my efforts before Christmas but I keep running into issues.
I'm guessing I'm a week or two from having something that is suitable
for consumption.

-- 
Martin K. Petersen	Oracle Linux Engineering
