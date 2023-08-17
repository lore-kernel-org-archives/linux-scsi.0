Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6EDC64EDA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 21:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355432AbjHQVtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 17:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355442AbjHQVtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 17:49:04 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B8010F8;
        Thu, 17 Aug 2023 14:49:03 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HL6aa1004220;
        Thu, 17 Aug 2023 21:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=nymky/+dGQUNi1ge6y41/EdkWw3ZBk0DowemsESyPE4=;
 b=k8Nxjwanee3YDZFjLsp8uP4U2EeFBw4L4GGTe6tsITFESUaTk/bH0/vQ+Dv+4iyb2STT
 nzOOxxhBLe87V+u0oAktKiXDOcsb5Ew8J7znlrftqdYIDWNSffRJpPeGndtVpkXLHKNK
 EFNBykEUCUVbdW2MOi5vPFzL3aWH4p5DZ5ZPBj/7ZSYDO9ajYddCGK4RcBVfTf0oF3ar
 PE1b7hySsQWdheSQR5i+6R6vO1Vn1k1R4MP1AHphm4zvcxz2xomSZBt77/aPs1TGF9Z8
 GwnT0sASdeiI+5J9SaPluvM8dAQgsimr+tJk8ih8o9DYfrCEIpC0/rBh+PkS9z6XvstK VA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sh3xxb3cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 21:48:35 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37HLmY0k007967
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 21:48:34 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 17 Aug
 2023 14:48:34 -0700
Message-ID: <0b061a9b-786d-e978-756c-d570783ff87c@quicinc.com>
Date:   Thu, 17 Aug 2023 14:48:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 14/17] scsi: ufs: Rename ufshcd_auto_hibern8_enable()
 and make it static
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-15-bvanassche@acm.org>
 <40508869-7cda-77f6-de98-6e41fce82c6a@quicinc.com>
 <aba05e63-2023-c081-fbb7-07cadb0101ad@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <aba05e63-2023-c081-fbb7-07cadb0101ad@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ENBE7aMc3qWcHqZi50TSZu7upUfmqCkr
X-Proofpoint-ORIG-GUID: ENBE7aMc3qWcHqZi50TSZu7upUfmqCkr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_18,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=775 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170193
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2023 12:16 PM, Bart Van Assche wrote:
> On 8/17/23 11:49, Bao D. Nguyen wrote:
>> On 8/16/2023 12:53 PM, Bart Van Assche wrote:
>>> -    /* Enable Auto-Hibernate if configured */
>>> -    ufshcd_auto_hibern8_enable(hba);
>>> +    ufshcd_configure_auto_hibern8(hba);
>>
>> Is it possible to have a race between sysfs and syspend/resume trying 
>> to update the auto_hibern8?
> 
> Only user-space software should write into sysfs. Kernel code should
> not do this. User-space code is paused before the block driver suspend
> callbacks are invoked and resuming block devices completes before
> user space software is resumed. I don't think that sysfs writes can
> race with suspend or resume callbacks.
>Thank you for the explanation.

Thanks
Bao
> Thanks,
> 
> Bart.
> 

