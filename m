Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F7BCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 12:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E37D21D71
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 12:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440210AbfJYMUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 08:20:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440207AbfJYMUZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 08:20:25 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PCH1ob171113
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 08:20:24 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vux7xnx31-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 08:20:23 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Fri, 25 Oct 2019 13:20:22 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 13:20:18 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PCKHF250921546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 12:20:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A21D8A405C;
        Fri, 25 Oct 2019 12:20:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73ABCA405B;
        Fri, 25 Oct 2019 12:20:17 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.96.98])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Oct 2019 12:20:17 +0000 (GMT)
Subject: Re: [PATCH 03/32] elx: libefc_sli: Data structures and defines for
 mbox commands
To:     Daniel Wagner <dwagner@suse.de>, James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-4-jsmart2021@gmail.com>
 <20191025111944.hdgfnslk57njngfi@beryllium.lan>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Fri, 25 Oct 2019 14:20:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025111944.hdgfnslk57njngfi@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19102512-0028-0000-0000-000003AF6F51
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102512-0029-0000-0000-00002471A561
Message-Id: <aac32b49-663f-2803-94f2-8240a01714a5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250117
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/19 1:19 PM, Daniel Wagner wrote:
> On Wed, Oct 23, 2019 at 02:55:28PM -0700, James Smart wrote:
>> This patch continues the libefc_sli SLI-4 library population.
>>
>> This patch adds definitions for SLI-4 mailbox commands
>> and responses.
>>
>> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
>> Signed-off-by: James Smart <jsmart2021@gmail.com>
>> ---
>>   drivers/scsi/elx/libefc_sli/sli4.h | 1996 ++++++++++++++++++++++++++++++++++++
>>   1 file changed, 1996 insertions(+)

>> +#define SLI_ROUND_PAGE(b)	(((b) + SLI_SUB_PAGE_MASK) & ~SLI_SUB_PAGE_MASK)


>> +/**
>> + * @brief COMMON_GET_SLI4_PARAMETERS
>> + */
>> +
>> +#define GET_Q_CNT_METHOD(val)\
>> +	((val & RSP_GET_PARAM_Q_CNT_MTHD_MASK)\
>> +	>> RSP_GET_PARAM_Q_CNT_MTHD_SHFT)
>> +#define GET_Q_CREATE_VERSION(val)\
>> +	((val & RSP_GET_PARAM_QV_MASK)\
>> +	>> RSP_GET_PARAM_QV_SHIFT)
> 
> This time there is no space in front of '\'. Does the expresssion not
> fit on one line? Would be easier to read:
> 
> #define GET_Q_CREATE_VERSION(val) \
> 	((val & RSP_GET_PARAM_QV_MASK) >> RSP_GET_PARAM_QV_SHIFT)

Protect the macro argument in the expansion with parentheses to prevent 
unintended operator precedence during evaluation?
As with (b) of SLI_ROUND_PAGE(b) above.

(((val) &  ... ))



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

