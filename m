Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6968BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 16:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 456C920890
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 16:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TTE3RrSX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731855AbgFRQEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 12:04:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59830 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731848AbgFRQEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 12:04:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IG35IL132328;
        Thu, 18 Jun 2020 16:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iv4kM4lUGQMzesOM7WoaIA5/Zj/qrv6/THfOyLNV9X8=;
 b=TTE3RrSXvRn7rZ8fmQlwvqtkvVQ835qKna9LAyEkC7sHjGZVDCakpfTQUGhBQTHWb/SX
 7wYIAy44bz9TJahRzGFd+MwCnH62PYhVNeaXhI0vOojJl+l4p5ORb88B5eRttkB7miR5
 usqoMNsuOW5h34J13RG3liHT8ILxBzMG8E6H6MFFzFuZJUmlSfMWU1keMioKc/gWv81e
 WdMUTdhdhcDpaRnpWsVBRxs1M5/aDnDoRrjpsGKIdEMcI1OqeSrpmY/OosoLD+BIYtcX
 MU1tEy/O46dVu8JO0twuJFsCgWx6FYs3ydF0czs5ELO5NJy1yW7cP+dmgbM7vhkMUwDT fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31qecm0n95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 16:04:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05IG4RRn001862;
        Thu, 18 Jun 2020 16:04:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31q66b5t4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 16:04:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05IG4HWk012153;
        Thu, 18 Jun 2020 16:04:17 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 16:04:16 +0000
Subject: Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <97507025-12ac-d58d-6929-20ba6599451b@oracle.com>
Date:   Thu, 18 Jun 2020 11:04:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 malwarescore=0
 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006180120
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/18/20 8:16 AM, Bodo Stroesser wrote:
> This small series of patches consists of:
>     [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
>     [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
> 
> Together with commit
>     8c4e0f212398 scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
> these patches fix crashes in tcmu on ARM.
> 
> The first patch of this series already was sent some weeks ago
> as "PATCH RFC", since it was untested at that time.
> 
> Meanwhile I added patch 2 of the series to fix the crash reported in:
>     https://urldefense.com/v3/__https://github.com/open-iscsi/tcmu-runner/issues/627__;!!GqivPVa7Brio!Nzsi6AfJJQIssE3tLed42r5EKmR0PmlYozji6dVy16oPnVKLMTCsE87jNrIgx6hasnfy$
>     https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=208045__;!!GqivPVa7Brio!Nzsi6AfJJQIssE3tLed42r5EKmR0PmlYozji6dVy16oPnVKLMTCsE87jNrIgx9cTxaSo$
> 
> All three patches together were tested on ARM with kernel
> 4.19.118 and 5.7.2 (see github issue and bugzilla).
> 
> ---
> v2: sent with a valid subject line.
> 

Acked-by: Mike Christie <michael.christie@oracle.com>
