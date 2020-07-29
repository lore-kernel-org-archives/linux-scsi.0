Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE29C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 02:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99A3D2076E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 02:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uVB76GCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731094AbgG2C5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 22:57:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgG2C5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 22:57:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T2pdck042038;
        Wed, 29 Jul 2020 02:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=l2kXAdb76YJBg92wlJCFLdCdhunbu3WRu16ip+b7LWw=;
 b=uVB76GCzhO3iWLrtPlYzUMfAGpZ9VODk2VnTcEE4b05D8u30EKTUjLv5hjkdzppZNT52
 MzTOdhy/XWl3pS+6wd8ho9t5H3s99bXKJUNTDH/mpXvnoCIZza06HQ3kit4Ke9/ITKU9
 /dLhWS10CikhZvm/mEOMhNtbOGG2iX8ZjPrKQqnTfKsKqj1h1Vyol8dEnNn4iy/w4fUO
 hfhF2JgqH/DwOWmRFf0AjJYBwvcIG3fuWs1RN/LsHY6aNx+GG8qgERNMuYC2023JlKGn
 +453ZI6shrrlFCPmBjoZMD7DLTjw4RiF/fUwRma+O6kOZ7xiX8aygAnUiUAVibthlj2/ 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32hu1jayst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 02:56:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T2ma1K002337;
        Wed, 29 Jul 2020 02:54:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32hu5ty3xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 02:54:36 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T2sWif025344;
        Wed, 29 Jul 2020 02:54:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 19:54:32 -0700
To:     Don Brace <don.brace@microsemi.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V3 0/4] hpsa updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mu3j829w.fsf@ca-mkp.ca.oracle.com>
References: <159587987792.28270.15427178888235104199.stgit@brunhilda>
Date:   Tue, 28 Jul 2020 22:54:29 -0400
In-Reply-To: <159587987792.28270.15427178888235104199.stgit@brunhilda> (Don
        Brace's message of "Mon, 27 Jul 2020 14:58:22 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> These patches are based on Linus's tree

... and therefore they don't apply. Mainly because I already merged an
earlier version of these.

 - Always submit your patches against my queue branch

 - If there are changes in v3 compared to what I have already merged,
   please submit incremental patches

 - Please work on your commit messages. See section 2 in
   Documentation/process/submitting-patches.rst.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
