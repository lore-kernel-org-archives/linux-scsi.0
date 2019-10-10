Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE90EC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92AF3208C3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZcAYEvYJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732616AbfJJDN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 23:13:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfJJDN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 23:13:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A39Uw7073497;
        Thu, 10 Oct 2019 03:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=LFDMM3J6QEJFq/fghSdIP2pAVj19GYWZHJkwDpggT8w=;
 b=ZcAYEvYJXQeDNnNGxBGjG7p3MN39yvkXwCLT7+scj+BzuWjRbSJGstNntGyMOaa5Yy8j
 B4hC2+MBK4z1wHfL7ZdQMJzjKsIU9ImZEk1gHIAXKhEZXnZXzdBZQkjlMU/Ru8pptqVy
 b3YJWenjIRRPOWItyqGWLeBFKYQDsjtB5IPVDq8dIHcNgdSYg2MstXEXrr/uxqxgDBZb
 sn3tvhk+fCl69opcaLZxAqMH8V9mhDd27CLN8KqhZTE4jnNjOtkZ56EycDBbgWtWaNRK
 M0/zf0wAlbwS+uKKQ67XkJGPYZDXRG9MEIssgk+4/wsy2nPK4aOhj3JN0KWNuqhq9+Pt Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4qraem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:13:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A38BgS104985;
        Thu, 10 Oct 2019 03:13:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vhrxcmcrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:13:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9A3DD1H029077;
        Thu, 10 Oct 2019 03:13:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 20:13:12 -0700
To:     Don Brace <don.brace@microsemi.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/10] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <157048745695.11757.6602264644727193780.stgit@brunhilda>
Date:   Wed, 09 Oct 2019 23:13:09 -0400
In-Reply-To: <157048745695.11757.6602264644727193780.stgit@brunhilda> (Don
        Brace's message of "Mon, 7 Oct 2019 17:31:17 -0500")
Message-ID: <yq1tv8hi98a.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=862
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=965 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> These patches are based on Linus's tree

Applied to 5.5/scsi-queue. There was some fuzz but I think I figured it
out.

-- 
Martin K. Petersen	Oracle Linux Engineering
