Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C9CC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D8F20756
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RHuDkMqT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgIOUWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:22:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgIOUTl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 16:19:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKJZpv054060;
        Tue, 15 Sep 2020 20:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=10Z/Dazbhyj4+cY8Xwz/MMNcwg0uB3IZDMh5DCktmK8=;
 b=RHuDkMqTF610Lqaq4swAzjaSbuvc/DgIxwwt7Fr9/ClVACUb9ztyypAY6UMiWI/8d25e
 uUaozpo3y+oWyQGg8tGYFMI38dPA01EaNk5JL8wsSsCy5Zqp18zso8A75kqrIMtZ3eEM
 qoillimo4coRE4wFSpqYW6BT0vHe7Gj9NnSu+pU/R7uADEhSNuehUBOa9Jik/509RzYe
 iVCkqANPUMTt28ZIuCdD7C8uqEkEcRTjTWhmDaPjFL8yoxhwMtAJs9jEjcia+8l/9y4m
 Ntp4k1XoTk++6JmMFu+LSWBvb4UBLNB72GO02O5yiZEShVy9kY/F5gk9JMCc5/kuyayg kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33gnrqyefj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:19:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKEhbX181308;
        Tue, 15 Sep 2020 20:19:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33h88yybbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:19:29 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FKJSho017289;
        Tue, 15 Sep 2020 20:19:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:19:28 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1363i7q0b.fsf@ca-mkp.ca.oracle.com>
References: <20200827072030.24655-1-adrian.hunter@intel.com>
Date:   Tue, 15 Sep 2020 16:19:26 -0400
In-Reply-To: <20200827072030.24655-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Thu, 27 Aug 2020 10:20:30 +0300")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150158
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Intel host controllers support the setting of latency tolerance.
> Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
> raw register values are also exposed via debugfs.

Applied to 5.10/scsi-staging. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
