From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Date: Sat, 29 Aug 2009 22:43:44 -0400
Message-ID: <4A99E760.1060302@interlog.com>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org> <4A99CB2F.9000000@interlog.com> <20090830010500.GA24395@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090830010500.GA24395@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Aug 29, 2009 at 08:43:27PM -0400, Douglas Gilbert wrote:
>>>  +	if (buffer[14] & 0x80)
>>> +		sdkp->thin_provisioning = 1;
>>> +
>> So you are checking the TPE bit (Thin Provisioning Enabled) but
>> not the TPRZ bit (Thin Provisioning Read Zeros). Shouldn't
>> there also be a sdkp->thin_provisioning_read_zeros bit defined
>> in struct scsi_disk?
>>
>> Is your application well defined when TPRZ==0 ?
> 
> Filesystems do not care if these blocks are in a defined state, as
> they must never return the content of uninitilized blocks to userspace.
> Now if we do want to support discard through raid arrays we might start
> to care, and will have check the TPRZ bit.

Another reason to note the TPRZ bit is that if it is 1 then
the data given to WRITE SAME (16 and 32) must be a logical
block of zeros for the UNMAP bit to be honoured (sbc3r19.pdf
section 4.6.3.2 last paragraph).
