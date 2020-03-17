Return-Path: <SRS0=78fV=5C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F9AC18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 14:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E356D20735
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 14:16:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dNKMVCIO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgCQOQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Mar 2020 10:16:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgCQOQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2020 10:16:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HE8wB2177559;
        Tue, 17 Mar 2020 14:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YBBcGsHKwATGeB09V/r4M5lTU64MXSDwRiF/pSXo3EQ=;
 b=dNKMVCIOUPdQgXi6tANpkLd9HSHs6bFVkjkWsw79e6B/AAKXl7zS4UOxgWKDIWe1G5P9
 hG56IQyg4ZgCFhdVlAgDpK0yAQRgMzG2kFG8loYWOter9tZpMS24x+hDJTbaEqTWVC5o
 kityzqaWZ8f70t2CiWOz+OevcJXIf+x7F42Gd7QoUeI8mBG+FM0+hMP8Eq0ZUOUryg++
 Y/tNGS1Ql2g11UsrwCLUNi8mpHvUPQxBwz6Rj/skb48sB/KAxAlWfFF92ieuA3bOHcgr
 xnJAkQqjfigE3v6ATl5N1jNnSr3tIuH0ROzJzFwCX/I7VuMAnRQlE0F9ZIQUDZEmgo5S oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yrppr55df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 14:16:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HE6Zju096876;
        Tue, 17 Mar 2020 14:16:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ys8trvypu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 14:16:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02HEGMoR023539;
        Tue, 17 Mar 2020 14:16:22 GMT
Received: from [10.154.123.163] (/10.154.123.163)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Mar 2020 07:16:22 -0700
Subject: Re: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is
 being deleted.
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Nilesh Javali <njavali@marvell.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>, emilne@redhat.com,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200313085001.3781-1-njavali@marvell.com>
 <20200316183856.GB4312@SPB-NB-133.local>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <e702fd5f-e3e1-1c76-6c49-c0ccf0b2c7ee@oracle.com>
Date:   Tue, 17 Mar 2020 09:16:20 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200316183856.GB4312@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170061
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/2020 1:38 PM, Roman Bolshakov wrote:
> On Fri, Mar 13, 2020 at 01:50:01AM -0700, Nilesh Javali wrote:
>> From: Arun Easi <aeasi@marvell.com>
>>
>> I/Os could be passed down while the device FC SCSI device is being deleted.
>> This would result in unnecessary delay of I/O and driver messages (when
>> extended logging is set).
>>
>> Signed-off-by: Arun Easi <aeasi@marvell.com>
>> ---
>>   drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
> 
> Hi Nilesh, Arun,
> 
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> Thanks,
> Roman
> 

Thanks Arun. FWIW, I remember this change :)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu
