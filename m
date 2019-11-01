Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9821CA9ECB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93BCB2067D
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oEoz9GRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfKACQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 22:16:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfKACQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 22:16:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12DpRj155802;
        Fri, 1 Nov 2019 02:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=4sAy9Vjw1MGexjEgSUWVlmKxPOKlUk2nu3K9MIAMz60=;
 b=oEoz9GRg1lA0jv5FOFigh1CdybnMSEtlLI8XZVZlgioYep4WuvLeEKle7hi/9/ARlpyj
 XJK5wm1EJ5vv2g1LIND/hHNaQqvhHv3kWI0RTjXYY4GLqfil7KNdIYiSyJPv3VE+7+vG
 bcoLpMdUktxfkURsVwqGsZrSJZagII/dFW1lbU6WD8yK32zbRVF+YqaNYsPxe/z60egT
 AeQV6dIhSQr6Tvk2YZxs2JwvCJYIjmFA9LK7g1M6V/AaYJvDr2AliBnXV/jeRiqEFNWx
 qC6W9JopDJRY98WulLZ4wkUMsXwI9/CT8L1x4AY1JCRSxPgT9vAnBL/viiABvrTz1kHo tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vxwhfq0f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:16:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12E2Sb161339;
        Fri, 1 Nov 2019 02:16:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vykw2fruh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:16:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA12GZv5006118;
        Fri, 1 Nov 2019 02:16:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Oct 2019 19:16:35 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 2/3] ufs: Use enum dev_cmd_type where appropriate
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191029230710.211926-1-bvanassche@acm.org>
        <20191029230710.211926-3-bvanassche@acm.org>
Date:   Thu, 31 Oct 2019 22:16:32 -0400
In-Reply-To: <20191029230710.211926-3-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 29 Oct 2019 16:07:09 -0700")
Message-ID: <yq1a79g5ojj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=899
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=986 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Declare all variables that hold dev_cmd_type values as an enum instead
> of as an int.

Applied to 5.5/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
