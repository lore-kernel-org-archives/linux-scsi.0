From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v2] UFS: Date Segment only need for WRITE DESCRIPTOR
Date: Wed, 28 Sep 2016 14:36:49 +0900
Message-ID: <007b01d2194a$4f3567a0$eda036e0$@samsung.com>
References: <20160825093919.5936-1-zangleigang@hisilicon.com>
 <9e470819d1cfcead5966e37c00f53967@codeaurora.org>
 <CGME20160928051454epcas2p3ad585ef9c23a18aacfdaabea15afbf6e@epcas2p3.samsung.com>
 <yq1intgy5at.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45587 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbcI1Fgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 01:36:52 -0400
In-reply-to: <yq1intgy5at.fsf@sermon.lab.mkp.net>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Martin K. Petersen'" <martin.petersen@oracle.com>, subhashj@codeaurora.org
Cc: 'Zang Leigang' <zangleigang@hisilicon.com>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Hi, Martin.

I think that the patch is correct.
UFS spec says "The Data Segment area is empty" for Read Descriptor.
I have been using similar code with it and it works.
That have been already applied in Android kernel.

Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>

Regards.

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Wednesday, September 28, 2016 2:14 PM
> To: subhashj@codeaurora.org
> Cc: Zang Leigang; vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-scsi-owner@vger.kernel.org
> Subject: Re: [PATCH v2] UFS: Date Segment only need for WRITE DESCRIPTOR
> 
> >>>>> "Subhash" == subhashj  <subhashj@codeaurora.org> writes:
> 
> Subhash> Looks good to me.
> 
> > -	/* Data segment length */
> > -	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
> > -			0, 0, len >> 8, (u8)len);
> > +	/* Data segment length only need for WRITE_DESC */
> > +	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
> > +		ucd_req_ptr->header.dword_2 =
> > +			UPIU_HEADER_DWORD(0, 0, (len >> 8), (u8)len);
> > +	else
> > +		ucd_req_ptr->header.dword_2 = 0;
> 
> What about READ_DESC?
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


