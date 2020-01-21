Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3A2C33CAA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 05:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F39D22314
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 05:10:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZDRK2upH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgAUFKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 00:10:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgAUFKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2020 00:10:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L59NPa076912;
        Tue, 21 Jan 2020 05:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=H4ax6pVLl+9F5mMt4z87BEtzxjnNqm1y06vBmvIrx00=;
 b=ZDRK2upHmfJg+R+Ost89cC118LKbBEMaDbvPQs/TGDhE40Getk4RtaIctBuyLwfrZ5pv
 wKmfPNHptgmWfSjC476leh3Ymu+++h2wAd16/wDCTWlxvJUdxIgymZcHTOwpsUyIB2Kr
 QZo8baD5wRq/rvU7gOF7uTMErqJvx1I8mezjDV5IL1eB6qzAy1iueqa3noTAULp9wvNi
 aatqJ7KsVi7JkIargAEvb32M73yQTBxOarrvCeIBUyg/sk1RN0B/VTz66EgtQoda71i6
 QQ6Fv/JpW6TbF2+N/qqor0rjrG8YrnnofdFsMW4U73H9hsyfCQpLHReDl85kZxZKAMGn DQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyq2gfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 05:10:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L59OHJ054859;
        Tue, 21 Jan 2020 05:10:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xnsj3u9fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 05:10:47 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00L5AkK4025895;
        Tue, 21 Jan 2020 05:10:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 21:10:46 -0800
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, abdhalee@linux.vnet.ibm.com
Subject: Re: [PATCH] mpt3sas: don't change the dma coherent mask after allocations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200117134506.633586-1-hch@lst.de>
Date:   Tue, 21 Jan 2020 00:10:43 -0500
In-Reply-To: <20200117134506.633586-1-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 17 Jan 2020 14:45:06 +0100")
Message-ID: <yq1h80piecs.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=606
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=684 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210045
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


[Adding Sreekanth]

> The DMA layer does not allow changing the DMA coherent mask after
> there are outstanding allocations.  Stop doing that and always
> use a 32-bit coherent DMA mask in mpt3sas.

Broadcom: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
