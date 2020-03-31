Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A346C2D0EE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 16:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4029212CC
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 16:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgCaQXN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 12:23:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730560AbgCaQXM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Mar 2020 12:23:12 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VG40AU077003
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 12:23:12 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3043g7c05y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 12:23:11 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 31 Mar 2020 17:22:57 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 17:22:54 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VGN5Vp55574590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 16:23:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F341FA4054;
        Tue, 31 Mar 2020 16:23:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86E80A405B;
        Tue, 31 Mar 2020 16:23:04 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.145.128.27])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Mar 2020 16:23:04 +0000 (GMT)
Subject: Re: [RFC PATCH v1 27/50] drivers/s390/scsi/zcsp_fc.c: Use
 prandom_u32_max() for backoff
To:     Benjamin Block <bblock@linux.ibm.com>,
        George Spelvin <lkml@sdf.org>
Cc:     linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <202003281643.02SGhHN7015213@sdf.org>
 <20200331161321.GB17507@t480-pf1aa2c2>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 31 Mar 2020 18:23:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200331161321.GB17507@t480-pf1aa2c2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20033116-4275-0000-0000-000003B706AB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033116-4276-0000-0000-000038CC5709
Message-Id: <bf41ae18-aba4-5315-e22b-67a6873eb459@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_05:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003310144
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/20 6:13 PM, Benjamin Block wrote:
> On Fri, Nov 29, 2019 at 03:39:41PM -0500, George Spelvin wrote:
>> We don't need crypto-grade random numbers for randomized backoffs.
>>
>> (We could skip the if() if we wanted to rely on the undocumented fact
>> that prandom_u32_max(0) always returns 0.  That would be a net time
>> saving it port_scan_backoff == 0 is rare; if it's common, the if()
>> is false often enough to pay for itself. Not sure which applies here.)
>>
>> Signed-off-by: George Spelvin <lkml@sdf.org>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: linux-s390@vger.kernel.org
>> ---
>>   drivers/s390/scsi/zfcp_fc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Hello George,
> 
> it would be nice, if you could address the mails to the
> driver-maintainers (`scripts/get_maintainer.pl drivers/s390/scsi/zfcp_fc.c`
> will tell you that this is me and Steffen); I'd certainly have noticed
> it earlier then :-).
> 
>>
>> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
>> index b018b61bd168e..d24cafe02708f 100644
>> --- a/drivers/s390/scsi/zfcp_fc.c
>> +++ b/drivers/s390/scsi/zfcp_fc.c
>> @@ -48,7 +48,7 @@ unsigned int zfcp_fc_port_scan_backoff(void)
>>   {
>>   	if (!port_scan_backoff)
>>   		return 0;
>> -	return get_random_int() % port_scan_backoff;
>> +	return prandom_u32_max(port_scan_backoff);

Reviewed-by: Steffen Maier <maier@linux.ibm.com>

> 
> I think the change is fine. You are right, we don't need a crypto nonce
> here.
> 
> I think I'd let the zero-check stand as is, because the internal
> behaviour of prandom_u32_max() is, as you say, undocumented. This is not
> a performance critical code-path for us anyway.

yes, let's keep the extra check as it's intentional and documented user 
interface for zfcp, so better be explicit

> 
>>   }
>>   
>>   static void zfcp_fc_port_scan_time(struct zfcp_adapter *adapter)
>> -- 
>> 2.26.0
>>
> 
> Steffen, do you have any objections? Otherwise I can queue this up -
> minus the somewhat mangled subject - for when we send something next time.
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

