Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6B8C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 08:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22583205C9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 08:08:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VVoB/inl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfHNIIx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:08:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51958 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbfHNIIx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 04:08:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7E88lKd165896;
        Wed, 14 Aug 2019 08:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=jrPcOifHUOUhayzLxc1G1x8+nhLUdUnAVA7EfqZI4zI=;
 b=VVoB/inlnzSMm+Cveqqbpy5m5Zz16s5QuS4oW8VxwAfLtNyKfsZzKGArD00HCxMSq3Lr
 fyP1u3GqysMwvz2V7CYXZG7x9U4/ScBSYvMGmMND2rhfqKXzWiTbfa6QwuWfGRwp+boP
 cbErqv5DX1L1AdrBcSn1W1JkEs4X4Bvpv4HyejGZlW/BCfdNagJmnf/MAbAhqGEtilfb
 nL1uKPDaRXn0JzvG5Gmg7xb6vriYDITflQCJCfgELmWUbgb3J/RNBpEc7oq46wEHJWBr
 cUviqERZBrOAIWySKIY+pmKy/GPAIcYCIov4ZLOdDVF4gkwXpk5jE0A1fi0rMuA+iTBg qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqk2qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 08:08:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7E88gJ1111333;
        Wed, 14 Aug 2019 08:08:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ubwrgyuu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 08:08:42 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7E88CKx019282;
        Wed, 14 Aug 2019 08:08:12 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 01:08:01 -0700
Date:   Wed, 14 Aug 2019 11:07:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jianyun Li <jyli@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvumi: fix 32 bit shift of a u32 value
Message-ID: <20190814080754.GT1974@kadam>
References: <20190813180113.14245-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813180113.14245-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908140080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908140080
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2019 at 07:01:13PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the top 32 bits of a 64 bit address is being calculated
> by shifting a u32 twice by 16 bits and then being cast into a 64
> bit address.  Shifting a u32 twice by 16 bits always ends up with
> a zero.  Fix this by casting the u32 to a 64 bit address first
> and then shifting it 32 bits.
> 
> Addresses-Coverity: ("Operands don't affect result")
> Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/mvumi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 8906aceda4c4..62df69f1e71e 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -296,7 +296,7 @@ static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
>  			sgd_getsz(mhba, m_sg, size);
>  
>  			phy_addr = (dma_addr_t) m_sg->baseaddr_l |
> -				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
> +				   (dma_addr_t) m_sg->baseaddr_h << 32;

Colin, you've sent this patch before on Feb 16, 2019.  If you shift by
32 then it's undefined behavior on 32 bit systems.  The correct fix is
to move the cast which was what your original patch did actually.

			(((dma_addr_t)m_sg->baseaddr_h << 16) << 16);

My suggestion back then was to introduce a macro:

/*
 * The dma_addr_t type can be either 32 or 64 bit.  Left shifting a 32
 * bit number is undefined so this do two 16 bit left shifts.
 *
 */
#define DMA_LSHIFT_32(val) (((dma_addr_t)(val) << 16) << 16)

regards,
dan carpenter

