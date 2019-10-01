Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9162FC388F3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 01:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 696E52087F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 01:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NvC/iXBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfJAByN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 21:54:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfJAByN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 21:54:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x911nVBc036692;
        Tue, 1 Oct 2019 01:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=4k2uGXye/BjhzSgVMI1K16vPqlYtUAnVQrfMtQxbxbo=;
 b=NvC/iXBe4G7x8PMGKBVGomJMys4bzrheUqcZUGnPMsUD6fnBq7aOYfkR33utl1FLuLiD
 rR3k1mEWxu2VIiRq/gBYULlh2x7AVdXB3R5qKcfWpQny7f0YhcBFLqeesDUEU8IbAq8j
 WNWshem1QOR03Rc+6fl9Q+3E6ENrgF7nlj6062m6FFqxjW9e7rzcfD+KW2MKMWMsVa5r
 RCWKSu8vEW5TXrTlZGi7ivMZ6RSWtBH291yE6zs/GCl2iWawHE9YVndT+aREnRNMMauN
 Si3K65VA2njWWctpHGo6NtyrEtpF5Dm59kncDEUoInE3B/RR+jjln6zuJajfz5SbHPiU Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v9yfq2q6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 01:54:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x911s2WG005865;
        Tue, 1 Oct 2019 01:54:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vbqcyypd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 01:54:06 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x911riJA000706;
        Tue, 1 Oct 2019 01:53:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 18:53:44 -0700
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrey Melnikov <temnota.am@gmail.com>,
        Zhong Li <lizhongfs@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [RFC,v2] scsi: scan: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com>
        <8A2392BA-EDD4-4F66-9F76-B43C8F6EA4FB@gmail.com>
        <CA+PODjpG7NLTH8wp9qw08ACj4=8sUusmkZv6X7QWHtdbNJ1S0Q@mail.gmail.com>
        <yq1h84y1vxh.fsf@oracle.com>
        <aa9016ff-af17-f18b-abf8-ffb73438c394@suse.de>
Date:   Mon, 30 Sep 2019 21:53:42 -0400
In-Reply-To: <aa9016ff-af17-f18b-abf8-ffb73438c394@suse.de> (Hannes Reinecke's
        message of "Fri, 27 Sep 2019 16:16:42 +0200")
Message-ID: <yq14l0t1ba1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=619
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=706 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> 1) all underlying devices are exported to the OS; of course they have
> to be properly masked etc to avoid udev to latch on those devices. I
> also was under the impression that the 'no_uld_attach' should be
> sufficient here, but then that only avoids the 'sd' driver to become
> attached to it. The actual SCSI device is still visible, so one
> _might_ be tempted to use the 'sg' device and export it to things like
> qemu. Which of course should be avoided.

Well, yes. But in this case the bug report was that sg devices were no
longer available for smartmontools to monitor.

-- 
Martin K. Petersen	Oracle Linux Engineering
