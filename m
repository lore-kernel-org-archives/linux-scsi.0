Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3993AC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 14:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E812074B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 14:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CcPbgDti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgFHOv4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 10:51:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgFHOv4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 10:51:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058EkiAq076879;
        Mon, 8 Jun 2020 14:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iiIf1n7bzIdMeJpBt6nv384yD8ZLlK5ejwAD+p+yJME=;
 b=CcPbgDtiwSmmg6qNUM6Cp6xLDV1WtMMD3Yrk3W6hMM0ExRUG+p8FpGf2GeazpMu/d/PZ
 J3e5Sl2WcJlEiZ1B3Ul6eg9y7mPpLbaZ0bH3CBNdoTtZ9T6PEnrMMFa3Zgk8g8HJOCjn
 m8spcvEhmS4u0EGp4Mf9OCTjpfmE0ZRGwC8d27bo0wDBT22cavizofM4f4ck1cUlYmsm
 QKPjydGt3hR/s365eJwQcx9rRHEa3E4swgLdLiHKYdPB51H+j2I9tohht/JBmUht85d7
 Y+7vWfn3vU0JtR9xQGl4kkCAe/Lz5xd279DcHIZhKamDusZqUKAw0XAx01ELMP4w1mb3 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31g33ky9r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 14:51:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058EiMwb123529;
        Mon, 8 Jun 2020 14:49:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31gmwq1mc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 14:49:47 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058Enket017325;
        Mon, 8 Jun 2020 14:49:47 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 07:49:46 -0700
Subject: Re: [PATCH 11/17] target: add session sysfs class support
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <780d2db6-2a29-677d-8ee2-a731bb98fb0f@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <dcfb5e78-79b1-9e69-0097-a07db488397e@oracle.com>
Date:   Mon, 8 Jun 2020 09:49:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <780d2db6-2a29-677d-8ee2-a731bb98fb0f@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080110
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/8/20 7:06 AM, Bodo Stroesser wrote:
>> +What:        
>> /sys/class/scsi_target_session/session-N/transport_id/session_id
>> +Date:        June 5, 2020
>> +KernelVersion:    5.9
>> +Contact: linux-scsi@vger.kernel.org
>> +Description:    If is proto=0x5 (iSCSI) and TPID FORMAT=1 this file 
>> will exist
>> +        and will return the iSCSI Initiator Session ID in ASCII
>> +        characters that are the hexadecimal digits converted from the
>> +        binary iSCSI initiator session identifier value. If iSCSI and
>> +        format=1 is not used by this session this file will not exist.
> 
> If I got it right, this is not how the code works.
> AFAICS, the file will always exist, but reading it delivers data only if
> proto=0x5 (iSCSI) and TPID FORMAT=1
> 

I forgot to update the description when I changed the code. Will update. 
Thanks.
