From: subhashj@codeaurora.org
Subject: Re: [PATCH v2] UFS: Date Segment only need for WRITE DESCRIPTOR
Date: Wed, 28 Sep 2016 15:42:18 -0700
Message-ID: <4c55deca663895cd8b8843ef51b2ec73@codeaurora.org>
References: <20160825093919.5936-1-zangleigang@hisilicon.com>
 <9e470819d1cfcead5966e37c00f53967@codeaurora.org>
 <yq1intgy5at.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbcI1WmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 18:42:20 -0400
In-Reply-To: <yq1intgy5at.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Zang Leigang <zangleigang@hisilicon.com>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-09-27 22:14, Martin K. Petersen wrote:
>>>>>> "Subhash" == subhashj  <subhashj@codeaurora.org> writes:
> 
> Subhash> Looks good to me.
> 
>> -	/* Data segment length */
>> -	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
>> -			0, 0, len >> 8, (u8)len);
>> +	/* Data segment length only need for WRITE_DESC */
>> +	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
>> +		ucd_req_ptr->header.dword_2 =
>> +			UPIU_HEADER_DWORD(0, 0, (len >> 8), (u8)len);
>> +	else
>> +		ucd_req_ptr->header.dword_2 = 0;
> 
> What about READ_DESC?

This patch is changing the value written to "Data Segment Length" field 
in the Basic header section of Query Request UPIU. This is description 
of "Data Segment Length" from UFS device v2.1 spec (JESD220C, 
line#1429-1430): "The Data Segment Length field contains the number of 
valid bytes within the Data Segment of the UPIU". Because we will not be 
sending any data segment in the request UPIU itself for the read 
descriptor hence this field can be zeroed out for descriptor read.
Read length for the "read descriptor" transaction needs to be specified 
(in ) in "LENGTH" of transaction specific fields of query request UPIU.

Thanks,
Subhash
