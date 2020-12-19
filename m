Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F82C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 22:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3AE023A53
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 22:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgLSWTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 17:19:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgLSWTx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 17:19:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BJMIi3N022404;
        Sat, 19 Dec 2020 22:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3fPt/fBo3U3rm46oNaGZwiyf38/I7lazJUPCuPY0F+E=;
 b=YD9oWz/gABW+u935Zm/bm8IlnKPrepdHziBYZfovX9DLGuUdNW7x1b1u3RURlBmGQ7V6
 oyj7RtlIn6Au6MCnAz1wlVyjBXn9GwQk8YlPwGf0qbrCvJGkZlnK+9y5Axu4cWoWv38w
 MSCc31zxJKIgJGy3a6k3z+08IWVBKzX9p8D/EVTS+j3TjrnKh4u9cU8U9Wimb1xzk09X
 mc4PjO3Tf5M9Vplz0sS+IdxRDVlUK3uAKSVHuZSW5bw2sHAA93pfELedmwfaeEJ5c/Mk
 u5vGacOUomL8HoZUHZxbjuZK9q4V5SDzUGYnZ/JUwsQ+FWO93so4Q93SCJAZPu5t939j nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35h8xqsdta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 19 Dec 2020 22:18:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BJMFXhD069669;
        Sat, 19 Dec 2020 22:18:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35h7j9hjaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Dec 2020 22:18:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BJMIbKr016248;
        Sat, 19 Dec 2020 22:18:40 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Dec 2020 14:18:37 -0800
Subject: Re: [PATCH 2/3] libiscsi: drop taskqueuelock
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608144943-4748-1-git-send-email-michael.christie@oracle.com>
 <1608144943-4748-3-git-send-email-michael.christie@oracle.com>
Message-ID: <568fe846-9b63-c9a0-8449-b401a93845ae@oracle.com>
Date:   Sat, 19 Dec 2020 16:18:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1608144943-4748-3-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012190167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012190167
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/16/20 12:55 PM, Mike Christie wrote:
> The purpose of the taskqueuelock was to handle the issue where a bad
> target decides to send a R2T and before it's data has been sent
> decides to send a cmd response to complete the cmd. The following
> patches fix up the frwd/back locks so they are taken from the
> queue/xmit (frwd) and completion (back) paths again. To get there
> this patch removes the taskqueuelock which for iscsi xmit wq based
> drivers was taken in the queue, xmit and completion paths.
> 
> Instead of the lock, we just make sure we have a ref to the task
> when we queue a R2T, and then we always remove the task from the
> requeue list in the xmit path or the forced cleanup paths.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

Lee,

There is a bug in this patch. I'll resend a new version with some
fixes for other bugs I hit while testing.
