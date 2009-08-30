From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Date: Sat, 29 Aug 2009 22:48:45 -0400
Message-ID: <20090830024845.GA8095@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org> <4A99CB2F.9000000@interlog.com> <20090830010500.GA24395@infradead.org> <4A99E760.1060302@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A99E760.1060302@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2009 at 10:43:44PM -0400, Douglas Gilbert wrote:
>> Filesystems do not care if these blocks are in a defined state, as
>> they must never return the content of uninitilized blocks to userspace.
>> Now if we do want to support discard through raid arrays we might start
>> to care, and will have check the TPRZ bit.
>
> Another reason to note the TPRZ bit is that if it is 1 then
> the data given to WRITE SAME (16 and 32) must be a logical
> block of zeros for the UNMAP bit to be honoured (sbc3r19.pdf
> section 4.6.3.2 last paragraph).

Ah, good hint.  I did in fact send down ZERO_PAGE(0) in an earlier
version, but the bio completion handler wasn't too happy with that
anymore after adding Willy's patch to free the page there.  I'll
either need to tweak it to make that conditional or zero the page
we allocated.
