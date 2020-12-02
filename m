Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DDAC64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 01:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1D402220B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 01:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgLBB22 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 20:28:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgLBB21 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 20:28:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B21FLk4131372;
        Wed, 2 Dec 2020 01:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=QJX6NbSUHuTgPPmfscje/NZrHfHr/t9Wh9k6mOXbdDQ=;
 b=swauHQvlyk1TSbRZyF/zWqg8s3bSHvSxa1mqZDefF8HsQ7HNbYZB0w1+EI6+v4ETYzzL
 F53rN2vJAQL37OayqT+23PkI/eZeC3VQpR5lR7GIdXhyW+hCMrQnY3QlZ+FCZzO7GPgS
 si7ZuAP/0SruwDpVrLkSnUnzm670YB0hyhkqPfMDXqjYfwsML77kGIYf71d5SzXejc3U
 toEGD/eX6BMbpK1CCBpECBZ94hXcX/YPONE5ssM0mLBitV1+m6j2V/SN6pkq6ndB9MpN
 ICcipdgji9piUeCNvS6sF8rLpU536zEggViR7iaszOaRGNG4BY3CFRCNlLbl19O2nk+T sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egknkn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 01:27:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B21K71Q067416;
        Wed, 2 Dec 2020 01:27:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540eyqkq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 01:27:29 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B21RRis028372;
        Wed, 2 Dec 2020 01:27:27 GMT
Received: from [20.15.0.5] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 17:27:27 -0800
Subject: Re: [PATCH 15/15] libiscsi: convert ping_task to refcount handler
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
 <1606858196-5421-16-git-send-email-michael.christie@oracle.com>
Message-ID: <82d6b446-a489-43ed-d017-f2a7a950b2a8@oracle.com>
Date:   Tue, 1 Dec 2020 19:27:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606858196-5421-16-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/20 3:29 PM, Mike Christie wrote:
> The conn_send_pdu API is evil in that it returns a pointer to a
> iscsi_task, but that task might have been freed already. This
> would happen with the ping_task code. To fix up the API so the
> caller can access the task if it needs to like in the ping_task
> case, this has conn_send_pdu grab a ref to the task for the
> caller. We then move the ping_task clearing to when all the
> refcounts are dropped, so we know the caller and a completion
> do not race.
> 

Ignore this patch. It's wrong, because it doesn't handle the check for 
if the nop is from userspace or kernel.
