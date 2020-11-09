Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF44EC2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 20:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BB36206E3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 20:30:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQN6XSKJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgKIUao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 15:30:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgKIUao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 15:30:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9KTQf1005512;
        Mon, 9 Nov 2020 20:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=r6pwOXiValnAdmzoF552K1ppLt6etb6UcNTvKqIczvg=;
 b=SQN6XSKJOavsg5QjYVARQdIwZRf8k/QdfsHAWcRVFC23TBNPEGHfTOqfXSYTdlEh3g3k
 9be+YkVLG+1H2KN04y07yAxzLJoRW5ek535CfzBNB3renohYyJ7kdztJH3Fl1L4Ea2k0
 BMSFpDehg/E7yleJ+WbRKoBZ9V+hjFff6AHGc/g0ifbhb7S0mJX1zph8zhgzXImNO53a
 DLgORVloqMXaMoyqSJdziIrdOMAb06UHszhvf6lfwNbMGxAWjwOT8uSRaB0mPZILPAlH
 GU8OnWNeW1xP/UzTET9Invg3gbRbMpOCT0OuS2a6zLt0tbaPSKKnZuf5GSM/0A2rFiVt Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72eeabb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 20:30:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9KLA6W017347;
        Mon, 9 Nov 2020 20:30:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55me9qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 20:30:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A9KUceU002368;
        Mon, 9 Nov 2020 20:30:38 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 12:30:38 -0800
Subject: Re: [PATCH 06/11] vhost: support delayed vq creation
From:   Mike Christie <michael.christie@oracle.com>
To:     Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
 <1604528804-2878-7-git-send-email-michael.christie@oracle.com>
 <56056e8d-d6ff-9a6e-2a7e-1ea1737b1d27@redhat.com>
 <54285b79-637e-3dcd-382f-ddeff44f6019@oracle.com>
Message-ID: <fc22b679-08c1-85bb-515a-8f63de7148a2@oracle.com>
Date:   Mon, 9 Nov 2020 14:30:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <54285b79-637e-3dcd-382f-ddeff44f6019@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090137
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 12:41 PM, Mike Christie wrote:
> 
> If you want to pair this patchset down to it's bare bug fixes that 
> prevent users from getting IO errors, I would do ring.addr check only 
> approach for this bug fix patchset.

Oh yeah, just so we don't have to burn an extra day, above I'm proposing 
I repost the original patchset:

https://lore.kernel.org/linux-scsi/1600712588-9514-1-git-send-email-michael.christie@oracle.com/t/

for the bug fix only patches. It will have the compile error fixed and 
Bart's comment handled.

To even trim it down more I can also drop the last 2 patches:

0007-vhost-remove-work-arg-from-vhost_work_flush.patch
0008-vhost-scsi-remove-extra-flushes.patch

and send separately in a cleanups patchset since the extra flushes it 
kills don't really hurt.
