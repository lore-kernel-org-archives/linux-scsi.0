Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACABC17440
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6F8215EA
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 02:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Es3AFkTe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfKICjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 21:39:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbfKICjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 21:39:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA92cvQJ178667;
        Sat, 9 Nov 2019 02:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=bPdMPT+5AvQNplQLHAmC9Jg0oZ0tGgKen81HBkBH9qE=;
 b=Es3AFkTe4jxid9RipMChCroCFiQyPJqQEBY7exrRxxbAZmZPBJ+HSysKdVy2HONxgsMA
 tIlv1/zCo7KCNbRxD9vnVnA1gM1pxYije7BvUgfL7fnxHz0XBZwbPzXHf1OUjXwpi8kn
 GdN37Ilnr1FU1pFraXbn5InoHbzaZqDpEij376gB+7k8+VIpWS9zjBzWovRtOKS+FUew
 YyD/wCdoJW36XjtXNJlLTEjPB4JZsoKD94ZbSNVvNvuBd3YYn7nsgrACb7dHLBCiW8L7
 QxVQ+QomXC2Y2R1z1PVliQXbhaYlvOA8wO3ArF3HgnWqtOn2YiYcffqkMIdmRQolk4TE bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5hgv8ckx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Nov 2019 02:39:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA92dPwf175073;
        Sat, 9 Nov 2019 02:39:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w5jkcsb03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Nov 2019 02:39:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA92csJ2028678;
        Sat, 9 Nov 2019 02:38:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 18:38:54 -0800
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "target-devel\@vger.kernel.org" <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
        <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
        <BYAPR04MB5816047492FC58019387A33CE77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
Date:   Fri, 08 Nov 2019 21:38:52 -0500
In-Reply-To: <BYAPR04MB5816047492FC58019387A33CE77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Sat, 9 Nov 2019 02:18:43 +0000")
Message-ID: <yq1y2wpu62r.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=742
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911090025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=828 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911090025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Please let me know if you want me to resend with a fixed header (and
> what that header should be).

I fixed it up. Applied to 5.5/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
