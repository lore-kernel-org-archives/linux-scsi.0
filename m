Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AF7C4363C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BF3620758
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y2DuS/ys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJBRB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 13:01:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgJBRB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 13:01:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092Grq90020201;
        Fri, 2 Oct 2020 17:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1DqX0WPvI2AqXcJwHW+71fJh5yhyCKZYutFIEXwHJ5M=;
 b=Y2DuS/ysCVf5t0MJsq2UVa+UwMleTL+NCrj66Ahc7BjzWSX4atfWoWHRecAQvWUQInYU
 6bJmYpO1hi6bR74P8uJkvJknIrj1PBFiK0ANtgX1JTJChPt52sEz1J0YYdUCMjcuxPsO
 /EgibS1HiFifbDx/SUxZa0RrbfFua+nLFQte/9VAFkTO6fjPQQRakyVQAcCxAYeSMei6
 /PlVcF2IIufCKyUc1YIHmvhL8VZsZEM84DsGFIYFyO4EexYEaREIHMcwldFJ308IC6an
 e6VvjUPFvrtfZ5zB+IX9VfSXj+LDpOz8RHRrrmWQZYw0AbfaINYj0Nkb4B/nRyoltG45 lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkmbxss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 17:01:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092Gt37M146447;
        Fri, 2 Oct 2020 17:01:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33uv2jjwa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 17:01:18 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 092H1HO0026809;
        Fri, 2 Oct 2020 17:01:17 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 10:01:16 -0700
Subject: Re: [PATCH v2 0/8] scsi: Support to handle Intermittent errors
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <4a2ed7c2-48a9-60d0-d751-d06af7fa6750@oracle.com>
Date:   Fri, 2 Oct 2020 12:01:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/20 11:50 PM, Muneendra wrote:
> This patch adds a support to prevent retries of all the pending/inflight
> io's after an abort succeeds on a particular device when transport
> connectivity to the device is encountering intermittent errors.
> 
> Intermittent connectivity is a condition that can be detected by transport
> fabric notifications. A service can monitor the ELS notifications and
> take action on all the outstanding io's of a scsi device at that instant.
> 

Is the service mentioned above a new daemon or is it integrated into
something like multipathd?

What does the part about monitoring ELS notifications mean? Is the
service just doing something like a ELS ECHO, or is it able to watch
the IO on the wire/card (like if you did tcpdump and watched iscsi/tcp
traffic) or is it something completely different?
