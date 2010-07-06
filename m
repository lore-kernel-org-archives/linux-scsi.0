From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Tue, 06 Jul 2010 19:40:15 -0400
Message-ID: <4C33BEDF.7050602@interlog.com>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp> <20100706213136.GA21246@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44062 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0GFXk0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 19:40:26 -0400
In-Reply-To: <20100706213136.GA21246@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On 10-07-06 05:31 PM, Mike Snitzer wrote:
> On Tue, Jul 06 2010 at  3:01am -0400,
> FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>  wrote:
>
>> I confirmed that mkfs.xfs worked with Intel X25-M (trim) and
>> scsi_debug (write same and unmap).
>>
>> REQ_TYPE_FS should give the same scsi_cmnd struct as REQ_TYPE_BLOCK_PC.
>>
>> This can be applied to block's for-2.6.36.
>>
>> The git tree is also available:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-discard
>>
>> =
>> From: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
>> Subject: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
>>
>> The block layer (file systems) sends discard requests as REQ_TYPE_FS
>> (the role of REQ_TYPE_FS is that setting up commands and interpreting
>> the results). But SCSI-ml treats discard requests as
>> REQ_TYPE_BLOCK_PC.
>>
>> scsi-ml can handle discard requests as REQ_TYPE_FS
>> easily. scsi_setup_discard_cmnd() sets up struct request and the bio
>> nicely. Only remaining issue is that discard requests can't be
>> completed partially so we need to modify sd_done.
>>
>> This conversion also fixes the problem that discard requests aren't
>> retried when possible (e.g. UNIT ATTENTION).
>>
>> Signed-off-by: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
>
> Unfortunately this patch causes 'mkfs.ext4 -F /dev/sda' to fail against
> a device whose discard support is implemented using WRITE SAME 16 w/
> discard bit set.  This is with recent e2fsprogs that issues BLKDISCARD
> ioctl at start of mkfs:
>
> sd 2:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 2:0:0:0: [sda] Sense Key : Illegal Request [current]
> Info fld=0x0
> sd 2:0:0:0: [sda] Add. Sense: Parameter value invalid
> sd 2:0:0:0: [sda] CDB: Write same(16): 93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00
> end_request: I/O error, dev sda, sector 0

That is 0x7fffff (over 8 million) blocks (4 GB) being unmapped
in one operation! That may exceed the "maximum unmap lba
count" field in the Block Limits VPD page.
The latest SBC draft (sbc3r22.pdf) says that field applies to
the SCSI UNMAP command and does not mention the WRITE SAME (16)
command but that is probably an oversight.

One also wonders how long that would take if permitted and what
is an appropriate command timeout.

Also the additional sense of "Parameter value invalid" (26h,2h)
is not mentioned in the latest drafts of SPC or SBC, apart from
being defined. So it might be a good one for an implementer to
pull out of the bag for special occasions. And the SBC draft
does say what is the correct additional sense in this case.


On a slightly related matter, when the target device is ATA
(e.g. a SSD with an SATA interface) then the SAT used can
influence whether WRITE SAME (16) gets translated into DATA
SET MANAGEMENT with the TRIM bit set. libata does it in recent
kernels but the LSI SAS controller that I use has its own SAT
which does not translate WRITE SAME. [It might with more
recent firmware.]

Doug Gilbert


