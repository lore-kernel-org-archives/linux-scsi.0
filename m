From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: 4.4 regression/bisected: error message due to "block/sd: Fix
 device-imposed transfer length limits"
Date: Fri, 15 Jan 2016 15:48:21 +0100
Message-ID: <569906B5.3040103@de.ibm.com>
References: <56964DE0.60407@de.ibm.com> <yq1ziw9vck7.fsf@sermon.lab.mkp.net>
 <5696560D.2010105@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp08.uk.ibm.com ([195.75.94.104]:48601 "EHLO
	e06smtp08.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbcAOOs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2016 09:48:28 -0500
Received: from localhost
	by e06smtp08.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <borntraeger@de.ibm.com>;
	Fri, 15 Jan 2016 14:48:26 -0000
In-Reply-To: <5696560D.2010105@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Steffen Maier <maier@linux.vnet.ibm.com>

On 01/13/2016 02:50 PM, Christian Borntraeger wrote:
> On 01/13/2016 02:22 PM, Martin K. Petersen wrote:
>>>>>>> "Christian" == Christian Borntraeger <borntraeger@de.ibm.com> writes:

Martin,

does the data make any sense to you?

>>
>> Christian> device-mapper: table: 253:4: adding target device sdq caused
>> Christian> an alignment inconsistency: physical_block_size=4096,
>> Christian> logical_block_size=512, alignment_offset=0, start=0
>>
>> Odd.
>>
>> Please provide the output of:
>>
>> # sg_readcap -l /dev/sdN
>> # sg_vpd -p bl /dev/sdN
>>
> 
> From a different system with a different disk, but the same storage server and the same error.
> 
> sg_vpd -p bl /dev/sdu
> Block limits VPD page (SBC):
>   Write same no zero (WSNZ): 1
>   Maximum compare and write length: 0 blocks
>   Optimal transfer length granularity: 128 blocks
>   Maximum transfer length: 0 blocks
>   Optimal transfer length: 1024 blocks
>   Maximum prefetch length: 0 blocks
>   Maximum unmap LBA count: 0
>   Maximum unmap block descriptor count: 0
>   Optimal unmap granularity: 0
>   Unmap granularity alignment valid: 0
>   Unmap granularity alignment: 0
>   Maximum write same length: 0x0 blocks
> sg_readcap -l /dev/sdu
> Read Capacity results:
>    Protection: prot_en=0, p_type=0, p_i_exponent=0
>    Logical block provisioning: lbpme=0, lbprz=0
>    Last logical block address=4294967295 (0xffffffff), Number of logical blocks=4294967296
>    Logical block length=512 bytes
>    Logical blocks per physical block exponent=3
>    Lowest aligned logical block address=0
> Hence:
>    Device size: 2199023255552 bytes, 2097152.0 MiB, 2199.02 GB
> 
> This is part of a big multipath setup, if that makes a difference.
> 
> 

