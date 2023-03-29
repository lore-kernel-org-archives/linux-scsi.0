Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31313C74A5B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 20:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjC2Uyc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjC2Uyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 16:54:31 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC351994
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:54:29 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TJBNSq004324;
        Wed, 29 Mar 2023 20:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=9mdJdojmna1d/ccvNnKtpCb20xUwCUUChW1l9PNx+QY=;
 b=opLe1o5YlguGW3YEjK/+JUj2L1d0n+QkhDzME6cSsub0kUv41mQC6Q0n80ZSiuitJ1I1
 V47As1uEYtjXMTvHjzlpGqJDyH0UKMG+aF1ULdAVsQ8EbPZCFl+DVQkILFBAAJ8BNiQX
 2oW4kuAByWRbjZsxds4A1rGqqrnTDCk9VNotODJEzEyuF633SJYkWBU7O4zF/WyYxh0P
 A+rOmAO7V3fM86u0hqwiuBfSYSTcHUCK9yj1oyivsYjKbilIKyPJs6BOutEvBQs1iupR
 dt5BIIvI89vespUkjD0M3biwgMVIvfN3EFrEruuoCS6mwuzDjhDGFJq978VKkh9acDlX 9w== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pmb8h2qje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 20:53:42 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32TKrgvu018931
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 20:53:42 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 29 Mar
 2023 13:53:41 -0700
Message-ID: <b705741b-d9e8-4b33-a608-cf610c5c52f4@quicinc.com>
Date:   Wed, 29 Mar 2023 13:53:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 0/5] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, <quic_asutoshd@quicinc.com>,
        <quic_cang@quicinc.com>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
References: <cover.1680083571.git.quic_nguyenb@quicinc.com>
 <16c79431-0a04-6d07-9965-b3af400b8329@acm.org>
 <8dae9795-3d81-ce0c-bc6f-2751d8309ff5@quicinc.com>
 <577ea430-32eb-5bf8-8ff9-35b54626bf6d@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <577ea430-32eb-5bf8-8ff9-35b54626bf6d@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: LriCA7xxBEZVvQz4Ix7C8BMQ18uFCNes
X-Proofpoint-GUID: LriCA7xxBEZVvQz4Ix7C8BMQ18uFCNes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_14,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303290158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/2023 1:51 PM, Bart Van Assche wrote:
> The change history is missing. This could have been made clear in the 
> change history. Anyway, I will take a closer look at these patches.
>
> Bart. 

Got it. I will add the change history back in the next revision.

Thanks,
Bao

