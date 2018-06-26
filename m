From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] sg: mitigate read/write abuse
Date: Tue, 26 Jun 2018 13:11:56 -0400
Message-ID: <yq1bmbx321v.fsf@oracle.com>
References: <20180625142544.182673-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-hardening-return-13681-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180625142544.182673-1-jannh@google.com> (Jann Horn's message
	of "Mon, 25 Jun 2018 16:25:44 +0200")
To: Jann Horn <jannh@google.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, kernel-hardening@lists.openwall.com, security@kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Jann,

> As Al Viro noted in commit 128394eff343 ("sg_write()/bsg_write() is
> not fit to be called under KERNEL_DS"), sg improperly accesses
> userspace memory outside the provided buffer, permitting kernel memory
> corruption via splice().  But it doesn't just do it on ->write(), also
> on ->read().
>
> As a band-aid, make sure that the ->read() and ->write() handlers can
> not be called in weird contexts (kernel context or credentials
> different from file opener), like for ib_safe_file_access().

Applied to 4.18/scsi-fixes with the naming fix pointed out by Doug.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
