Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D2DC83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 13:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA525206B9
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 13:57:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JJxHOFQZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgD1N5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:57:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgD1N5d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 09:57:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SDtSTY177507;
        Tue, 28 Apr 2020 13:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=t9szbrynnuaWIUfa4RDgczEpwPZNZHbdMwwIAjrCsQE=;
 b=JJxHOFQZ18K3EvV11K9PLt7B5u1QBp1hqTc36lHJWyugg3smvw0dQzQsfLBxSUBYNCCg
 Eamcc+bTOoIn2Z2JncCs5fzvQQWbKZdxoN1XzXNFYCgWfuCiYKQYw9+RfeAD6WrukZNu
 bTKHw5902WGDZQKX8X6kxkQlbVajvBPxTzpq3Hi31tQULGsVg7LgGuzFxnpftIBwoPA2
 FxcmQin06gZkTXBwkxZa4/UT1rpDMUhJO0I3jckt9pheP52jUncl+iFB0r7+CyzuKeIh
 /lSxIuHsGaCWz3+HeonkwKQcKDHrrCAdwcY5n8SDroHXC8s1BvbjRDdeCtg9d1kFR7nx vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30p01npma4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 13:57:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SDqf4Y127767;
        Tue, 28 Apr 2020 13:55:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30mxpg1jp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 13:55:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03SDtFb1002635;
        Tue, 28 Apr 2020 13:55:15 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 06:55:15 -0700
Subject: Re: [PATCH v4 10/11] qla2xxx: Fix endianness annotations in header
 files
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-11-bvanassche@acm.org>
 <8ca5292e-88c6-ecb3-77b7-bd6735f5ccca@oracle.com>
 <alpine.LNX.2.22.394.2004281017310.12@nippy.intranet>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <8688f3a5-f9a8-8511-03ad-8bd897070375@oracle.com>
Date:   Tue, 28 Apr 2020 08:55:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2004281017310.12@nippy.intranet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1011
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280110
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/27/20 7:25 PM, Finn Thain wrote:
> On Mon, 27 Apr 2020, himanshu.madhani@oracle.com wrote:
> 
>>
>> This looks okay, but i would strongly suggest driver maintainer to
>> verify if this introduces any regression or not.
> 
> If the changes don't affect code generation, regression is impossible.
> 
> So, compilers (and cross-compilers) could answer your question, if they
> could achieve sufficient code coverage.

Agree if the code generation does not change then there should be no 
regression.

> 
> It would be nice if there was a tag that could be added to a patch so that
> CI services could check for compiler output invariance (.s or .i or both).
> 
This sounds like a good idea for CI service to check for compiler output 
and make sure patch does not break it.

>>
>> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
>>

-- 
Himanshu Madhani
Oracle Linux Engineering
