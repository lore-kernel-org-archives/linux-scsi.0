From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4] libata: Report zeroed read after Trim and max discard size
Date: Sat, 21 Nov 2009 15:16:05 -0500
Message-ID: <yq11vjrskfu.fsf@sermon.lab.mkp.net>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
	<1258771524-26673-4-git-send-email-martin.petersen@oracle.com>
	<20091121104923.GB30153@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:17267 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZKUUR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 15:17:57 -0500
In-Reply-To: <20091121104923.GB30153@infradead.org> (Christoph Hellwig's
	message of "Sat, 21 Nov 2009 05:49:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Fri, Nov 20, 2009 at 09:45:23PM -0500, Martin K. Petersen wrote:
>> * with the unmap bit set.
>> */
>> - if (ata_id_has_trim(args->id))
>> + if (ata_id_has_trim(args->id)) {
>> + put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
>> put_unaligned_be32(1, &rbuf[28]);

Christoph> My reading of SPC is that the max unmap size only makes sense
Christoph> for devices supporting UNMAP, while the SATL for now only
Christoph> supports WRITE SAME with the unmap bit.

I was trying to help Eric figure out why his drive pooped on big Trim
requests.  For WRITE SAME the limit is inherent in the arguments,
whereas our SATL implementation is limited by the 512-byte WRITE SAME
payload.  So I needed a way to convey this up the stack.

Since you already return a B0 VPD page I thought it would be a
convenient place to communicate the max without having to tweak the
queue limits directly from within libata.

You are right that I'm relying on fuzziness in SBC which requires both
the max LBA count and the descriptor count to be specified for UNMAP.

So what I can do is this:

                if (lba_count) {
                        q->limits.max_discard_sectors =
                                lba_count * sector_sz >> 9;

                        if (desc_count)
                                sdkp->unmap = 1;
                }

That way we don't impose limits on "normal" WRITE SAME devices.

-- 
Martin K. Petersen	Oracle Linux Engineering
