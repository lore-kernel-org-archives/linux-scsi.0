From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: associate bio write hint with WRITE CDB
Date: Thu, 03 Jan 2019 23:57:38 -0500
Message-ID: <yq1ef9t81fh.fsf@oracle.com>
References: <20181226041504.66283-1-huangrandall@google.com>
        <20190103075133.GA5141@infradead.org>
        <20190103094755.GA96532@google.com>
        <e5bc96cd-1b48-3b7e-706f-4cbbd1a040a4@interlog.com>
        <6152b478ea77dacf57eef6f758ba795f756cd3da.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6152b478ea77dacf57eef6f758ba795f756cd3da.camel@redhat.com> (Ewan
        D. Milne's message of "Thu, 03 Jan 2019 16:40:41 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: dgilbert@interlog.com, Randall Huang <ihhuang@abmail.org>, Christoph Hellwig <hch@infradead.org>, huangrandall@google.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ewan,

> SBC-5 says that support for the grouping function is indicated by the
> GROUP_SUP bit in the Extended Inquiry VPD page (86h).  I'm not sure
> how many devices actually support that page though.  Probably most
> don't.

Several devices support it, albeit for various different purposes. It's
one of these wonderful features whose interpretation was left outside
the scope of the spec for a long time.

So even though we absolutely and positively need to make setting GROUP
NUMBER conditional on GROUP_SUP being reported, we also need additional
information from the storage about how the field should be interpreted.

The official way to report hinting is for the device to implement the IO
Advice Hints Grouping mode page. I wrote some code to support that but
no vendors that I know of ended up actually shipping an implementation.
A few implemented my older I/O class proposal but didn't ship that
either despite really convincing performance results.

If Randall has access to a device which implements hinting, I'd love to
know more.

-- 
Martin K. Petersen	Oracle Linux Engineering
