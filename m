From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Tue, 22 Feb 2011 11:40:51 -0500
Message-ID: <yq1zkpof2ek.fsf@sermon.lab.mkp.net>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
	<180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <180713DB-114C-454B-A91E-063AB0116251@dilger.ca> (Andreas
	Dilger's message of "Tue, 22 Feb 2011 09:13:49 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: "djwong@us.ibm.com" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Andreas" == Andreas Dilger <adilger@dilger.ca> writes:

Andreas> I don't like adding a data copy in the IO path at all. 

No thanks!


Andreas> I'd definitely prefer that the filesystem be in charge of
Andreas> deciding whether this is needed or not. 

Absolutely. At the block layer we obviously have no idea whether the
filesystem is safe or not. So in my current tree the protection is only
generated if the relevant bio flag is set (unless the application
already added it, obviously).


Andreas> If the use of the data copy can be constrained to only the
Andreas> minimum required cases (e.g. if fs checks for rewrite on page
Andreas> that is marked as Writeback and either copies or blocks until
Andreas> writeback is complete, as a mount option) that would be
Andreas> better. At that point we can compare on different hardware
Andreas> whether copying or blocking should be the default.

Agreed.

As Chris mentioned we've got somebody on our team working through the
filesystem issues now. I'm hoping we can provide a status update at
LSF2011.

-- 
Martin K. Petersen	Oracle Linux Engineering
