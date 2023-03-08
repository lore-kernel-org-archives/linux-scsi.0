Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACD7C678D5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 23:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjCHXxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Mar 2023 18:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCHXxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2023 18:53:16 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7A736FF6;
        Wed,  8 Mar 2023 15:53:13 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328FppNB025718;
        Wed, 8 Mar 2023 23:52:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=TPWApUJjiZsp0t81yZwSYM8lY/FccY+yZ8CQprOPKIg=;
 b=bX5q+hz/ozA8WcFYF/+asPGFVj5Q+QOar5UfEiJ1uKesH8Goj7v8XarfUhYWOTm2ppPm
 qSagC1Aoql3SdtOZrYHi9TtAjc4iG7latID/6T5ybK5xyZ/ET0gqpWAF1K11fE6cwrPO
 IkV+mM8APcHKXdV6+KiP4W+2AYLg8WmD3pr7uC+TefaWw+TRUQsWRYT32MkVSaTgFP49
 zLnekG6LFeKda9KeMNq0mdOqXFKb5mP8tbH8cMTHfoESjn/56iMkX0J34yA3UyUmWrTL
 toBJmCahA6fn5rwFcXDVp9sh5ct8IN5L4sAFQsznMOs1FcS+C6QbtR9Ka9SiS8fmZigD WA== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3p6wcmh321-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 23:52:56 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 328NquVp011054
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 8 Mar 2023 23:52:56 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 8 Mar 2023
 15:52:54 -0800
Message-ID: <08524801-bc9d-5878-d8cc-2a5231c71284@quicinc.com>
Date:   Wed, 8 Mar 2023 15:52:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH v1 2/4] ufs: mcq: Add supporting functions for mcq
 abort
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, <quic_asutoshd@quicinc.com>,
        <quic_cang@quicinc.com>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1678247309.git.quic_nguyenb@quicinc.com>
 <b84abc7ea5bddc78ab3c70e9a7b5108a5bc9448f.1678247309.git.quic_nguyenb@quicinc.com>
 <fa4bfc9e-2e75-2e00-2b64-816f4bc26eda@acm.org>
 <f4f5eef5-c0d4-0de6-71df-c70f0ce4064a@quicinc.com>
 <e2f1dea7-7f34-127b-ddcb-b21737f26498@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <e2f1dea7-7f34-127b-ddcb-b21737f26498@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: dAqM2SfQekIaKCqzM6fok4AFn1uT2yCq
X-Proofpoint-ORIG-GUID: dAqM2SfQekIaKCqzM6fok4AFn1uT2yCq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxlogscore=987 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080200
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/8/2023 3:23 PM, Bart Van Assche wrote:
> On 3/8/23 14:27, Bao D. Nguyen wrote:
>> This is to give us the flexibility to override this parameter in the 
>> downstream driver if needed.
>
> Please do not introduce functionality before it is needed. See also 
> https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it.
I will remove it. Thanks.
>
> Thanks,
>
> Bart.
>

