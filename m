From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/14] scsi: fix the {host,target,device}_blocked counter mess
Date: Fri, 25 Jul 2014 15:08:46 -0400
Message-ID: <yq1silpgssh.fsf@sermon.lab.mkp.net>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-10-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:08 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Seems like these counters are missing any sort of
Christoph> synchronization for updates, as a over 10 year old comment
Christoph> from me noted.  Fix this by using atomic counters, and while
Christoph> we're at it also make sure they are in the same cacheline as
Christoph> the _busy counters and not needlessly stored to in every I/O
Christoph> completion.

Christoph> With the new model the _busy counters can temporarily go
Christoph> negative, so all the readers are updated to check for > 0
Christoph> values.  Longer term every successful I/O completion will
Christoph> reset the counters to zero, so the temporarily negative
Christoph> values will not cause any harm.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
