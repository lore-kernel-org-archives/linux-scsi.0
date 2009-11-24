From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 3/4] libata: Report zeroed read after Trim and max	discard
 size
Date: Tue, 24 Nov 2009 10:20:28 -0500
Message-ID: <4B0BF9BC.3080006@teksavvy.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-4-git-send-email-martin.petersen@oracle.com> <20091121104923.GB30153@infradead.org> <yq11vjrskfu.fsf@sermon.lab.mkp.net> <20091124143508.GB21629@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20091124143508.GB21629@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Nov 21, 2009 at 03:16:05PM -0500, Martin K. Petersen wrote:
>> I was trying to help Eric figure out why his drive pooped on big Trim
>> requests.  For WRITE SAME the limit is inherent in the arguments,
>> whereas our SATL implementation is limited by the 512-byte WRITE SAME
>> payload.  So I needed a way to convey this up the stack.
>>
>> Since you already return a B0 VPD page I thought it would be a
>> convenient place to communicate the max without having to tweak the
>> queue limits directly from within libata.
>>
>> You are right that I'm relying on fuzziness in SBC which requires both
>> the max LBA count and the descriptor count to be specified for UNMAP.
> 
> I think the better way is to make sure we can support any TRIM that
> can be sent down.  Given that TRIM is not NCQ-capable we can just
> allocate one buffer for the TRIM ranges per TRIM capable device.
..

Good approach.

I suppose that buffer would be only 512 bytes long, per device?
That might be a bit restrictive, as TRIM can handle much larger
requests, and some drives (Indinlinx-based at least) prefer large
TRIM lists at present.

On the other hand, the Marvell chipsets cannot handle more than a
single sector of data without first fixing the driver to work around
chipset bugs.  That's probably unique to sata_mv, though.

Cheers

Mark Lord

