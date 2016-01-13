From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: 4.4 regression/bisected: error message due to "block/sd: Fix
 device-imposed transfer length limits"
Date: Wed, 13 Jan 2016 14:50:05 +0100
Message-ID: <5696560D.2010105@de.ibm.com>
References: <56964DE0.60407@de.ibm.com> <yq1ziw9vck7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:39642 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbcAMNuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 08:50:11 -0500
Received: from localhost
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <borntraeger@de.ibm.com>;
	Wed, 13 Jan 2016 13:50:09 -0000
In-Reply-To: <yq1ziw9vck7.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 01/13/2016 02:22 PM, Martin K. Petersen wrote:
>>>>>> "Christian" == Christian Borntraeger <borntraeger@de.ibm.com> writes:
> 
> Christian> device-mapper: table: 253:4: adding target device sdq caused
> Christian> an alignment inconsistency: physical_block_size=4096,
> Christian> logical_block_size=512, alignment_offset=0, start=0
> 
> Odd.
> 
> Please provide the output of:
> 
> # sg_readcap -l /dev/sdN
> # sg_vpd -p bl /dev/sdN
> 

>From a different system with a different disk, but the same storage server and the same error.

sg_vpd -p bl /dev/sdu
Block limits VPD page (SBC):
  Write same no zero (WSNZ): 1
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 128 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 1024 blocks
  Maximum prefetch length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks
sg_readcap -l /dev/sdu
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=4294967295 (0xffffffff), Number of logical blocks=4294967296
   Logical block length=512 bytes
   Logical blocks per physical block exponent=3
   Lowest aligned logical block address=0
Hence:
   Device size: 2199023255552 bytes, 2097152.0 MiB, 2199.02 GB

This is part of a big multipath setup, if that makes a difference.


