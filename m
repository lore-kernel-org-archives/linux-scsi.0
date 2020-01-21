Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D70C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 00:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9DA924650
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 00:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WZgROZlg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgAUAB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 19:01:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAUAB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 19:01:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KNwBrd093243;
        Tue, 21 Jan 2020 00:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=JpiRhhRFWZo07unr8mhwqnhva0iXjqJMdLqY10bv9Zc=;
 b=WZgROZlge422YupLn2dsZa+p1HZuWCajRWfP8chQrQdrePlkxtD092JpQMHxyjBuljxb
 ZdDvMNeQFq7gUSNTapPKjBVmZgHAxcJS4ZPYhSxD4P03aZAlU63sJ3bVCCK5Tany8PEb
 mQJAHIC81Zv3wmZWKHpksHxzsXtJzvvBcdXfsMpoyvDimYuPUS46rkesChVEWcFB4HZS
 t9aPt2oL/kRLglLY1hLLKbzgEcfqhIjwA8adtJHfiodvD3f+Dxki2lBPnrawbkavQYXK
 TAYOE+K/n+Iedwo/3pb4xJJg0TVOUZNFGn6GZrTDS1BxmIUVX+b2aM6cMCxTFke1Oz/F /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr1pr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 00:01:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KNwb0G073951;
        Tue, 21 Jan 2020 00:01:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xmbj4wms4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 00:01:14 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00L01DSH011129;
        Tue, 21 Jan 2020 00:01:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 16:01:13 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     AlexChen <alex.chen@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        zhengchuan@huawei.com, jiangyiwen@huawei.com, robin.yb@huawei.com
Subject: Re: [PATCH] scsi: sd: provide a new module parameter to set whether SCSI disks support WRITE_SAME_16 by default
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <5E246413.8010408@huawei.com>
        <c3c8c949-b557-1e34-5143-7a0b348a609e@acm.org>
Date:   Mon, 20 Jan 2020 19:01:06 -0500
In-Reply-To: <c3c8c949-b557-1e34-5143-7a0b348a609e@acm.org> (Bart Van Assche's
        message of "Sun, 19 Jan 2020 11:36:17 -0800")
Message-ID: <yq1ftg9k799.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200203
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

>> +	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1 ||
>> +			sd_default_support_ws16)
>>  		sdkp->ws16 = 1;
>> 
>>  	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
>
> Should this be fixed using the quirk mechanism instead of introducing a
> new kernel module parameter? Kernel module parameters apply to all SCSI
> disk devices irrespective of their vendor and model. The quirk mechanism
> can be used to introduce special behavior for certain disk models and
> types.

Yes, this should definitely be a blacklist option. Although I'd
obviously encourage the vendor to implement RSOC instead of working
around this in the kernel.

-- 
Martin K. Petersen	Oracle Linux Engineering
