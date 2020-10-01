Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB262C47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 15:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D9120719
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 15:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tMtTlWKw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgJAPWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 11:22:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732342AbgJAPWl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 11:22:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FJ9iN003623;
        Thu, 1 Oct 2020 15:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=L4UHMPQWC6SFW4UWnRQupfHwPJeBxBa2ho9FeJxhMyU=;
 b=tMtTlWKwXWdY+qVIbEOzN4FwpPHGFHl54EJauzC7CTy8L3Y2MiJ3veX+iFs3sLQqXEn9
 2Nrc65bbUOCdi1cv462eNvMIvh9zcsSQJk04U3/mzKvxR0cMV/LjlXXctp2RyQYgomWG
 VICplsSRrYB+fEdDk6pyYUJzZy/8irCJgyAeU/9uyusjK0euycD00b833E+02BIr6Ezy
 9JmO8U3t3XvvXiGZAV/Pc30SU1sRdwFPfzWtLNa9vT+cFXrOWMW7PqCIMrrvd87XecaD
 5gMfEwCf4vuUSTHeLKQUz26jq3XuZlYsXICcA1X3ha0nxkEVaZSdZ0Zp5IvoAGdXTwQq 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9nekyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 15:22:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FKsIQ182730;
        Thu, 1 Oct 2020 15:22:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdw09rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 15:22:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 091FMVxr031860;
        Thu, 1 Oct 2020 15:22:33 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 08:22:31 -0700
Subject: Re: [PATCH 1/2] scsi: Add limitless cmd retry support
To:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <1601398908-28443-1-git-send-email-michael.christie@oracle.com>
 <1601398908-28443-2-git-send-email-michael.christie@oracle.com>
 <919c092a-ecf9-bf11-3422-9c4443e9918d@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <28ba5cdd-0303-633b-e7ca-b989c0b0105b@oracle.com>
Date:   Thu, 1 Oct 2020 10:22:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <919c092a-ecf9-bf11-3422-9c4443e9918d@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/20 9:52 PM, Bart Van Assche wrote:
> On 2020-09-29 10:01, Mike Christie wrote:
>> +static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
>> +{
>> +	if (cmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
>> +		return true;
>> +
>> +	return (++cmd->retries <= cmd->allowed);
>> +}
> 
> Did checkpatch complain about the parentheses in the above return statement?
> 

Ah sorry. It does not.

I dropped it like I mentioned in the 0/2 patch. It looks like when I re-edited my comments I accidentally used the first version of the patch and it snuck back in.

I'll resend. It's better to get it right now instead of wasting time having someone send a cleanup patch later.

> Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

