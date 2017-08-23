From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sg: recheck MMAP_IO request length with lock held
Date: Tue, 22 Aug 2017 21:46:43 -0400
Message-ID: <yq1pobnawe4.fsf@oracle.com>
References: <20170816044843.96697-1-toddpoynor@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170816044843.96697-1-toddpoynor@google.com> (Todd Poynor's
        message of "Tue, 15 Aug 2017 21:48:43 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Todd Poynor <toddpoynor@google.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org


Todd,

> Commit 1bc0eb044615 ("scsi: sg: protect accesses to 'reserved' page
> array") adds needed concurrency protection for the "reserve" buffer.
> Some checks that are initially made outside the lock are replicated once
> the lock is taken to ensure the checks and resulting decisions are made
> using consistent state.
>
> The check that a request with flag SG_FLAG_MMAP_IO set fits in the
> reserve buffer also needs to be performed again under the lock to
> ensure the reserve buffer length compared against matches the value in
> effect when the request is linked to the reserve buffer.  An -ENOMEM
> should be returned in this case, instead of switching over to an
> indirect buffer as for non-MMAP_IO requests.

Applied to 4.14/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
