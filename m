Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA02C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 20:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjC2Uu5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjC2Uu4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 16:50:56 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDB64C20
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 13:50:52 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TH9agQ029513;
        Wed, 29 Mar 2023 20:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=M1LcwuJU7E8HNJUZs7WltYMe8BPH8qLRTA6EIglVB94=;
 b=o4/p4JEe/D5F5hos3bl6MWPkYZYuh45xIj5n2kngW8sot8umaofzCPf2ZqSMVE84ysIV
 xCBFZGzR4mo5RwZxXP771CVISDMoc+ljcjTpQehs4/uRZaKaDUOeRMd4yOevDp89I8Tb
 tokZZBs7GDC3yknRj4sFV2sOAFe9PYf6tEd2bCdVuVjktfyLW2SJtjfY6akM25VsPe4A
 T2/mlaJJ8yT1zTw3NgcNBQvPxhcAZ2S7ehRL0PWaE1OHewpKhd+eLjrtyF3rfMqVlPs8
 nBEC/enQurBqZvUsxBcWCgQ2//WWjXioDs+rvH7ItT/Gpb9oWSkz/eCupfXv64ZTd1Xi BA== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pm6k837c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 20:50:22 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32TKoLbF004000
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 20:50:21 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Wed, 29 Mar
 2023 13:50:20 -0700
Message-ID: <8dae9795-3d81-ce0c-bc6f-2751d8309ff5@quicinc.com>
Date:   Wed, 29 Mar 2023 13:50:20 -0700
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
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <16c79431-0a04-6d07-9965-b3af400b8329@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: D_-Fhf4lYpUq4VStBMlchxCIhzYBRI-p
X-Proofpoint-GUID: D_-Fhf4lYpUq4VStBMlchxCIhzYBRI-p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_14,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=806 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2303290158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/2023 1:47 PM, Bart Van Assche wrote:
> On 3/29/23 03:01, Bao D. Nguyen wrote:
>> This patch series enable support for ufshcd_abort() and error handler 
>> in MCQ mode.
>> The first 3 patches are for supporting ufshcd_abort().
>> The 4th and 5th patches are for supporting error handler.
>
> Is this perhaps a resend of v1? Last time this series was posted it 
> had version number 3.
>
Hi Bart, I am not sure if I did it correctly or not. The last time I 
posted, it was with RFC tag in the subject. I have made some minor 
changes to address the comments and some bug fixes. I am posting the 
patches again without "RFC" tag now.

Thanks,

Bao

> Thanks,
>
> Bart.


