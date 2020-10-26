Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2899C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 22:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC6D20882
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 22:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aEOYwNJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394520AbgJZW3w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:29:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51932 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394447AbgJZW3v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 18:29:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMTAHl088023;
        Mon, 26 Oct 2020 22:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=XHun9CyXGySLkxbDbRXvyEC8cqSsVIKOIGlFJ9EM0vo=;
 b=aEOYwNJ3LIi/B4MGfNA8vndGz7Q6G0GMQo9OFsnMNKZB1nolWhqj3pIeeKMJEHG1/fkz
 uX+diiKeLi8CDNptOhef0L0JeB+UzKqRGyKNBIs3B+/ACAZTI8zJLBbrAuo/VQC/chxt
 PEOL5ZKm5Vv6F2VKHJJYks2SSDdSKe+0T7YpBjuGlcknlVv2I9v4EHkTG3KY48m7lksO
 99h+A3PyXHBCTtgaXeB6/vT5ZTgY35pPtDwUml/8BO1jmAsS4EzlVpQH8pgH63D3+hMC
 17AVa6oFd5YfpfwwXnyPIHtrW4uuzuue4jNlbxrLhTLoqiO90bduT/jELFkMlasJfaUn 5w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saq7na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 22:29:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMKN4t092688;
        Mon, 26 Oct 2020 22:29:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwukpxqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 22:29:49 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QMTnMV017434;
        Mon, 26 Oct 2020 22:29:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 15:29:48 -0700
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: tcmu: scatter_/gather_data_area rework
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eelk7hbp.fsf@ca-mkp.ca.oracle.com>
References: <20201019115118.11949-1-bostroesser@gmail.com>
Date:   Mon, 26 Oct 2020 18:29:45 -0400
In-Reply-To: <20201019115118.11949-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Mon, 19 Oct 2020 13:51:18 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=977 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> This is made on top of the scsi-staging tree plus my previous
> patch:
> "scsi: target: tcmu: add compat mode for 32bit userspace on 64bit
> kernel"

Make sure to put all commentary below ---. Otherwise the tooling gets
confused about what goes in the commit message.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
