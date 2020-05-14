Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732E3C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C01F206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bjRJxL9V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgENRDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 13:03:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgENRDx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 13:03:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EH39Ni183132;
        Thu, 14 May 2020 17:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tSUQbySv6F5d2VUXp2pvndiUT4VUVCM/HtZSrr45/r4=;
 b=bjRJxL9VypcgN+NffT73ksTtn5RntAnF7IEP2h/roURG14hwO83RI09k0SIj1wJDewCK
 0l0tsITyo5KKAflo0zs41pY1xiGtBzgc4czEqVd5dzYj16d3OXmuXfzOjP0KSZCuwuij
 dr/M88IWN92Sx0J+kPBc3jF2N4CCWtYmcSaXwebtMLDKoZtCP0FsfeMj0HnQ9eeVKw4v
 U5UfqfwwPmk29Cnf934zc4E4Oee35cmumluDt6ViV+2N7PX3SUubioi2FLoPrnGkPETB
 7/QVky8lxn7a6BGaR+52IPYuoBdCuluY1fsAYNjJ2t2rR7L85xVKAMvR6zObUL2gJUre 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3100xwut47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 17:03:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EH2ffO192267;
        Thu, 14 May 2020 17:03:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 310vjt9gnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 17:03:48 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EH3moq028381;
        Thu, 14 May 2020 17:03:48 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 10:03:48 -0700
Subject: Re: [PATCH 1/3] qla2xxx: Change in PUREX to handle FPIN ELS requests.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-2-njavali@marvell.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <64bb098f-59ac-49bf-132a-79fb44e63de4@oracle.com>
Date:   Thu, 14 May 2020 12:03:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514101026.10040-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=962 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=989 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140151
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/14/20 5:10 AM, Nilesh Javali wrote:
> SAN Congestion Management generates ELS pkts whose size
> can vary, and be > 64 bytes. Change the purex
> handling code to support non standard ELS pkt size.


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
