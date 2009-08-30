From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Date: Sat, 29 Aug 2009 21:05:00 -0400
Message-ID: <20090830010500.GA24395@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org> <4A99CB2F.9000000@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A99CB2F.9000000@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2009 at 08:43:27PM -0400, Douglas Gilbert wrote:
>>  +	if (buffer[14] & 0x80)
>> +		sdkp->thin_provisioning = 1;
>> +
>
> So you are checking the TPE bit (Thin Provisioning Enabled) but
> not the TPRZ bit (Thin Provisioning Read Zeros). Shouldn't
> there also be a sdkp->thin_provisioning_read_zeros bit defined
> in struct scsi_disk?
>
> Is your application well defined when TPRZ==0 ?

Filesystems do not care if these blocks are in a defined state, as
they must never return the content of uninitilized blocks to userspace.
Now if we do want to support discard through raid arrays we might start
to care, and will have check the TPRZ bit.

