Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217EFC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF50208A9
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 16:01:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tiLITckG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIVQBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:01:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgIVQBK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 12:01:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFmlb5145728;
        Tue, 22 Sep 2020 16:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AbVpWpSgCjqdldCGTYZMT+++cq7rrkHGEvVR2CZoSLc=;
 b=tiLITckG4JNNGlXOd3XXcplKh9K/DmbdEZFGwt4O1uxC7z+MvnS3pvjTZu6EV3Eh0EaO
 bmYIDAIa0zNDaJ5LrPvzthCZYDYEdspl381VrhZb2GHohyqe4PfGum7THuS6KUW7pC+G
 EOI48C8ZzTdhzZMQKMlgbJJdWu44Zq7hvMC3lYdm1k+T0q8vaXxfCmh5gL/y6YcU9lDx
 /DlLXSlA6qmjzh9pwWHZ4govsq4Tkq8ZGTdfxuJM1K1+18edjuYHEz7hIBW6AEgcYH0z
 eU1vuBeNnKE97OtUYoQ206DU1LZhZ1dgICHkqobuMKE38WrMKt55TKuWwsU30ojxYPEm sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnudr6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:01:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFnseW004854;
        Tue, 22 Sep 2020 16:01:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33nuw49grh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:01:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08MG13SZ005697;
        Tue, 22 Sep 2020 16:01:03 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:01:03 -0700
Subject: Re: [PATCH 1/2] scsi: Add limitless cmd retry support
To:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <1600714109-6178-1-git-send-email-michael.christie@oracle.com>
 <1600714109-6178-2-git-send-email-michael.christie@oracle.com>
 <ff219013-96e6-ad3b-ca8a-76531441a076@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <95e4d315-57c3-491f-7cc3-2237ff7dee1b@oracle.com>
Date:   Tue, 22 Sep 2020 11:01:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ff219013-96e6-ad3b-ca8a-76531441a076@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/21/20 10:10 PM, Bart Van Assche wrote:
> On 2020-09-21 11:48, Mike Christie wrote:
>> +static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
>> +{
>> +	if (cmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
>> +		return true;
>> +
>> +	return (++cmd->retries <= cmd->allowed);
>> +}
> 
> Something minor: how about leaving out the parentheses from the above return
> statement?

Will do.

> 
>> @@ -1268,7 +1276,10 @@ int scsi_eh_get_sense(struct list_head *work_q,
>>  			 * finished with the sense data, so set
>>  			 * retries to the max allowed to ensure it
>>  			 * won't get reissued */
>> -			scmd->retries = scmd->allowed;
>> +			if (scmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
>> +				scmd->retries = scmd->allowed = 1;
>> +			else
>> +				scmd->retries = scmd->allowed;
> 
> Please make sure that the comment above the if-statement remains an accurate
> description of the code. The comment only explains why scmd->retries is
> modified but not why scmd->allowed is modified if scmd->allowed ==
> SCSI_CMD_RETRIES_NO_LIMIT.

Ok.
