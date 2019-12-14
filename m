Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EFAC43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 04:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17F93206DA
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 04:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FeyU4OLO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfLNE3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 23:29:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfLNE3g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 23:29:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE4T1Zg181825;
        Sat, 14 Dec 2019 04:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KjgBjEiIi9MVL1bnPhiBy3+wluKQdQn3q4PuVYYr8Vg=;
 b=FeyU4OLOoj+kBZe2qOrXyDYIoR6VB890xEYqim0HvbSi+CKQWvqK6XpzkHCtyH6gC/de
 qobTbppK+wcU6eWnWSS+ZNTkEaHFo+mhdPc7ohwDvkjxi9aPX9UTOqliLiFpQ6viqcKO
 kxrq9GzIlOAI3EJm1t7YAnMwdootzLaYDK7x9CN78knztXWT6Q+fut4UFfPTJCdxk4nY
 F76slaK0QHtZggFN76N90+sK6uavbIVyI3UYUtzZpNHpHmEcfbs9nf9bAdiFGq/3lFT9
 rjrp86ibu6k2kcAqhNQPY6z3ZKZoCMK1TbRCXK89AbrmJcaxjmCRVE5Wi3egxxqrJFF7 vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wvqppr3vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 04:29:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE4SKbP039686;
        Sat, 14 Dec 2019 04:29:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wvnsxm5j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 04:29:00 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBE4SuD7020830;
        Sat, 14 Dec 2019 04:28:56 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 20:28:55 -0800
Date:   Sat, 14 Dec 2019 07:28:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: ufs: Simplify a condition
Message-ID: <20191214042846.GA19868@kadam>
References: <20191213104935.wgpq2epaz6zh5zus@kili.mountain>
 <b08b7848-c0da-4438-258c-19ce18fa798c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b08b7848-c0da-4438-258c-19ce18fa798c@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=944
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 13, 2019 at 01:05:55PM -0700, Bart Van Assche wrote:
> On 12/13/19 5:49 AM, Dan Carpenter wrote:
> > We know that "check_for_bkops" is non-zero on this side of the ||
> > because it was checked on the other side.
> 
> How about also removing the superfluous parentheses? Anyway:
> 

Around "(req_link_state == UIC_LINK_OFF_STATE)"?  I considered it but
some people like them...

regards,
dan carpenter
