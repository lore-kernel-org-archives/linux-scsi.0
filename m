Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C4EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6ED2078A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bl0FBDhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgF3Bf5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 21:35:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgF3Bf4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 21:35:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05U1WBlo153474;
        Tue, 30 Jun 2020 01:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=OUNGZwr+OmzhqOUgJ6oGRD8TLp0+pcY4v95Lq0350pI=;
 b=Bl0FBDhhzL3I57zT5O88Xoc77lEtECkASCiRMzuvpbBi5Oisa6qdjxZ06rF5tvmfKqzH
 LSKKsRbMjKKVHouel51ib72ByZbewYFkfhu86CEoiCxmJdA3HJO3nW72LgPOE8pAxDJG
 5ZKuLgPm1lF90i3ZqdZrK8/9vC9Oig0TzMwZV4zjLhzUtt9gthPY7+FQIPBQJR3ZpZHa
 rJPkNWvb14Cag97xS9fXDAKmbW9HNvBqr3IpPeDPIbR48kLZ9kDiYAUZT/yBKRbq9LvL
 0rB730eeOZBVQzJvJV16XonjQDasPXkRUCsF/G6t63LkDG/eiOe5EpyH97EHPSMhx1JG Bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1dpau4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 01:35:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05U1YWAR016444;
        Tue, 30 Jun 2020 01:35:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31y52h663r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 01:35:21 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05U1Z7Ki008590;
        Tue, 30 Jun 2020 01:35:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 01:35:07 +0000
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Pavel Machek <pavel@ucw.cz>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH (v2)] scsi: sd: add parameter to stop disks before reboot
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bll1fi9u.fsf@ca-mkp.ca.oracle.com>
References: <e726ffd8-8897-4a79-c3d6-6271eda8aebb@0882a8b5-c6c3-11e9-b005-00805fc181fe>
        <20200629080947.GA28551@infradead.org>
Date:   Mon, 29 Jun 2020 21:35:04 -0400
In-Reply-To: <20200629080947.GA28551@infradead.org> (Christoph Hellwig's
        message of "Mon, 29 Jun 2020 09:09:47 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> What happened to the suggestion to treat reboot=p like a poweroff
> instead?  That seems to be fundamentally the right thing to do.

I agree!

-- 
Martin K. Petersen	Oracle Linux Engineering
