From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND RFC PATCH 00/32] separate operations from flags in the
 bio/request structs
Date: Sat, 7 Nov 2015 02:10:23 -0800
Message-ID: <20151107101023.GA12117@infradead.org>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchristi@redhat.com
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 04, 2015 at 04:07:57PM -0600, mchristi@redhat.com wrote:
> Known issues:
> - REQ_FLUSH is still a flag, but should probably be a operation.
>  For lower level drivers like SCSI where we only get a flush, it makes
> more sense to be a operation. However, upper layers like filesystems
> can send down flushes with writes, so it is more of a flag for them.
> I am still working on this.

Actually it should be both.  REQ_OP_FLUSH for a real flush operation,
and a REQ_PREFLUSH bio flag that the request layer will sequence into
an actual write an a flush operation.
