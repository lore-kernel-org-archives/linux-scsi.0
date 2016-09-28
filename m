From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] UFS: Date Segment only need for WRITE DESCRIPTOR
Date: Wed, 28 Sep 2016 01:14:18 -0400
Message-ID: <yq1intgy5at.fsf@sermon.lab.mkp.net>
References: <20160825093919.5936-1-zangleigang@hisilicon.com>
        <9e470819d1cfcead5966e37c00f53967@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19275 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbcI1FOh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 01:14:37 -0400
In-Reply-To: <9e470819d1cfcead5966e37c00f53967@codeaurora.org>
        (subhashj@codeaurora.org's message of "Tue, 27 Sep 2016 15:30:22
        -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subhashj@codeaurora.org
Cc: Zang Leigang <zangleigang@hisilicon.com>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org

>>>>> "Subhash" == subhashj  <subhashj@codeaurora.org> writes:

Subhash> Looks good to me.

> -	/* Data segment length */
> -	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
> -			0, 0, len >> 8, (u8)len);
> +	/* Data segment length only need for WRITE_DESC */
> +	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
> +		ucd_req_ptr->header.dword_2 =
> +			UPIU_HEADER_DWORD(0, 0, (len >> 8), (u8)len);
> +	else
> +		ucd_req_ptr->header.dword_2 = 0;

What about READ_DESC?

-- 
Martin K. Petersen	Oracle Linux Engineering
