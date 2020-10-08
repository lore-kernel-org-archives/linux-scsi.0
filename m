Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EE0C4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A85092145D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HWhLP4Ln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgJHCps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:45:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgJHCps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:45:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982iYt3028576;
        Thu, 8 Oct 2020 02:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=xicZbT4oZuZBz0LXKZAvNVURnXr0lB1RvmDLIr1UKMI=;
 b=HWhLP4LnZPyjJ6YuyxnszAnTYv650Sk6TxqtiECj04uZ/dBUErJCItWvtg7CwFcFIYei
 UGob8qKLBF8oj8FJ+gXebgnWnYD3sTazfXNmyNl7eUpZKmKkei5oUK7lAExMDq/lvdJe
 7ReHAvMtDoIdcIWBEFrPCY330U/nmEQOmNLodfY6whhBswJ+KjmQ14npDvuTVfwieiJo
 S0vT39qJRTRYpt0VaOAgpdFaYyagIiOl8MYyOiwor79nC6XyYq0AlD4D6aTpcTILapf0
 NqIux1xaEz980P6rUxj/xvELHk6ovHRxDYoJwhEFNxDRfA1izL0d3W/nvSUkjXdBRP05 JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetb5bmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:45:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982esxD008144;
        Thu, 8 Oct 2020 02:45:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3410k0dhkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:45:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0982jWEx000746;
        Thu, 8 Oct 2020 02:45:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:45:32 -0700
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <emilne@redhat.com>, <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: bfa: fix error return in bfad_pci_init()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eem9xwos.fsf@ca-mkp.ca.oracle.com>
References: <20200925062423.161504-1-jingxiangfeng@huawei.com>
Date:   Wed, 07 Oct 2020 22:45:30 -0400
In-Reply-To: <20200925062423.161504-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Fri, 25 Sep 2020 14:24:23 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> Fix to return error code -ENODEV from the error handling case instead
> of 0.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
