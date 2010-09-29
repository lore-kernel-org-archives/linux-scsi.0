From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] tcm/fileio: Add UNMAP / Block DISCARD support
Date: Wed, 29 Sep 2010 10:57:56 +0200
Message-ID: <4CA2FF94.8020800@panasas.com>
References: <1285627910-6492-1-git-send-email-nab@linux-iscsi.org>	 <4CA18F28.3070608@panasas.com> <1285747739.18417.49.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:35506 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600Ab0I2I6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 04:58:00 -0400
In-Reply-To: <1285747739.18417.49.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Richard Sharpe <realrichardsharpe@gmail.com>

On 09/29/2010 10:08 AM, Nicholas A. Bellinger wrote:
> On Tue, 2010-09-28 at 08:46 +0200, Boaz Harrosh wrote:
>>> +			printk(KERN_WARNING "Ignoring UNMAP for non BD"
>>> +					" backend for struct file\n");
>>
>> TODO: Lots of extent based filesystems could enjoy if you punch an hole
>>       in the file. (Which will also send a proper discard).
>>       So how to punch an hole in a file via vfs?
> 
> Good question, as all of the current block discard support assumes a
> struct block_device * pointer currently.
> 
> I know that hch has mentioned that accesing a struct block_device from
> struct file is very dangerous, but I am assuming for the TCM/FILEIO case
> that this code will be protected by igrab() and iput().
> 
> hch and jaxboe, any comments here..?
> 

No you did not understand. FILEIO (working on a filesystem's real file),
should *never* attempt a discard on the blocks even if it was
to read the file's map and figure out these blocks. It should always
call a filesystem specific API that puntches-an-hole in the file.
Fore stupid filesystem that means fill with zero's. For a smart
extent-based file system it means splitting up the extents the range
belongs to and freeing up the block that where allocated for that
range. But it is an heavy meta-data operation that only the filesystem
can do. With really smart FS like xfs the unallocated blocks also
get discarded, for when working with SANs with over provisioning.

> Thanks!
> 
> --nab

Boaz
