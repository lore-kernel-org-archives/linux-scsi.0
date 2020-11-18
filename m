Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BCEC63777
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 16:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3F2247E7
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 16:21:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WylzMcyt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgKRQVG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 11:21:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60254 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgKRQVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 11:21:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AIGKo6r031505;
        Wed, 18 Nov 2020 16:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ag3zZ7/uPY94UxMfyu/a5u0oAqIuzswiwfEQTZVrwFI=;
 b=WylzMcytK8AYj4iuPM+Y1ne+zb9k4tUb2w/UnTNtPFBfrjiTfwKOP/F5+5VOFkhLCGmm
 Z53+QvLP+/S7sWuFjJMvcNCbzIbX9cn6Bqy6AOt5TJU6eODzutFz8We74fLQG/kiRRVY
 rM/vNn3uu3BcRNusoW2/KTMV0V7oNFcHGJbZNxxMPYt7Tm9ctaXZs3Td8GXddsl7IqoY
 nAb+wGwUgRu6OCm6OAAUMnmxn0nv39FSacZMytBg0d5DhGZ9bVA7gnYBuky6MkUuVyy6
 HwFbfpy++QavrBHk1Ws83rNVBaw4BtHilyu41LenXZXd8QdhSnXie40zsdNoFPXxvsmv Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76m0vuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 16:21:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AIG1XQ9024445;
        Wed, 18 Nov 2020 16:19:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34ts0sg3ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 16:19:00 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AIGIxHX006451;
        Wed, 18 Nov 2020 16:18:59 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Nov 2020 08:18:59 -0800
Subject: Re: [PATCH 1/1] vhost scsi: fix lun reset completion handling
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1605680660-3671-1-git-send-email-michael.christie@oracle.com>
 <20201118035452-mutt-send-email-mst@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <57a25e88-e94f-02e6-031c-cbe5ef086229@oracle.com>
Date:   Wed, 18 Nov 2020 10:18:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201118035452-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/20 2:56 AM, Michael S. Tsirkin wrote:
> On Wed, Nov 18, 2020 at 12:24:20AM -0600, Mike Christie wrote:
>> vhost scsi owns the scsi se_cmd but lio frees the se_cmd->se_tmr
>> before calling release_cmd, so while with normal cmd completion we
>> can access the se_cmd from the vhost work, we can't do the same with
>> se_cmd->se_tmr. This has us copy the tmf response in
>> vhost_scsi_queue_tm_rsp to our internal vhost-scsi tmf struct for
>> when it gets sent to the guest from our worker thread.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> Is this a fix for
>     vhost scsi: Add support for LUN resets.
> 
> If so pls add a Fixes: tag.
> 

It is. Ok, will resend.
