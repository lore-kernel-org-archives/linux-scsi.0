Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E4BC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 01:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12792177B
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 01:44:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qtt/NZfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHGBoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 21:44:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHGBoO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 21:44:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0771dQ48067439;
        Fri, 7 Aug 2020 01:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=CKmKekFHX8OlbwYKdzSliZVNkk5aUoha/tvPqjH8QSM=;
 b=Qtt/NZfdN4bTazpJTbEl4b7cERgEafOenfDJWRXpzte7cM6l+s/G6jKjOr2s2mRGJhzJ
 WulgR3oagZQrN9e15XaFLVQ7i2t01IcAJs5wcZ0w5czgqbdbYpT5lKRRw6xY/Tk0SIdU
 bHLKzm2wV0cTct0izxdBoLNl9lDFtMvszS8+54tT4O4r9LOY9V/30x4UkakJ/JD3UjbG
 99fK17w+rVKX/6mGDbHgkL3I13u+b99AwtKhgMZMo2w/AghTq+oNCwsQn613guRqSRY2
 fZAYbva6Z9EghJxeW3YyQenK09DIqItYGVA12J3tnB2r8wmzH8HMScQoPHxdp6i+rI5+ BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32r6fxp3a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 07 Aug 2020 01:44:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0771buFk054019;
        Fri, 7 Aug 2020 01:42:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32r6cwj4j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Aug 2020 01:42:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0771g8U0029525;
        Fri, 7 Aug 2020 01:42:08 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 18:42:08 -0700
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
From:   Mike Christie <michael.christie@oracle.com>
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
 <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
 <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
 <90048ea8-3b8f-cc06-7869-dca645cd68f2@oracle.com>
 <7c2d8052-fb5e-0a3b-a894-df8bfab44f21@ts.fujitsu.com>
 <b8fc90b9-7038-b202-e7ef-bc4da56816f0@oracle.com>
Message-ID: <61420558-b077-13ca-b5e3-6269fb419233@oracle.com>
Date:   Thu, 6 Aug 2020 20:42:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b8fc90b9-7038-b202-e7ef-bc4da56816f0@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008070010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008070010
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/20 1:13 PM, Mike Christie wrote:
> I would really like to figure out if #2 is a regression and understand what happened so we don't make the same mistake again and also fix iscsi. The problem with iscsi though is every couple kernels has a bug in this code path so git bisect is being a pain.

Sorry for the delay. I was able to track down the hang part of this. It turns out loop did work at some point. It worked a couple times over the years, but every X kernels we would break it again.

The last time we didn't have the hang was because we executed TMFs one at a time. We would end up always calling queue_tm_rsp since the LUN reset was always going to execute after the abort. So to fix the wake up / hang part of the bug for everyone we could revert:

commit db5b21a24e01d35495014076700efa02d6dcbb68
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Tue Nov 27 15:51:59 2018 -0800

    scsi: target/core: Use system workqueues for TMF

It's not clear how much processing TMFs for the same device in parallel helps. If it doesn't help, this would be an easy fix for everyone.

One other thing that is not clear to me is if aborted_task was always meant to be used for task management requests. I think when it was first added, it was only called for normal cmds. I couldn't tell exactly when we meant (vs it snuck in by accident) to start calling it for all commands.

If the async TMF feature helps, then I'm ok with with your fix for loop where we say the aborted_task callout was meant for all commands and go from there. We then have to do something similar in xen, and check that the other drivers didn't expect the old behavior. I think for that qla2xxx bug you mentioned, tcm_qla2xxx_aborted_task didn't expect a qla_tgt_mgmt_cmd to be passed into aborted_task so it crashed trying to access it as a qla_tgt_cmd.

What do you think?
