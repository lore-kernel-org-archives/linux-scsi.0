Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19EDC77B75
	for <linux-scsi@archiver.kernel.org>; Sun,  7 May 2023 05:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjEGFVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 May 2023 01:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjEGFVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 May 2023 01:21:07 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9B16598
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 22:21:05 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3475KhHL023660;
        Sun, 7 May 2023 05:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=6z5eUb021/qrNQ2FZxdoUyFPN+ckl76fQu9V3YARwIk=;
 b=QXcEUPImg8/WTiwOnM2AInHU0vT0fHPnhQcQ/N/6maQOCDvsDQ1KgSUr6WonHYBSUNmb
 9iktNN0iygwTozxQIZ7LxX5ye8vy2S91/M/0xmwE5omhjqzL6s/rsdxp7urzaUEzEz7y
 P33mzOy/HpmCSUreukAB7WL9VVXOnjFpkWH9R4hQMA3+/13e184bjm/kMgsYasZ/14IV
 7FoVGWLMWtdKvEmcyJ3dQiOSJrUxSn3Yg12FukCq2+OakORBEmsT+nK/3zklyNyiq60I
 wSYtpxgiYphqWPLEtPE0SjyOIhqtHnJsxhr0VCiFxM6ihCOsfRr5zIpmSD3N9P+7nycF Lw== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qdf041fqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 07 May 2023 05:20:43 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3475Kgaw005696
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 7 May 2023 05:20:42 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Sat, 6 May 2023
 22:20:41 -0700
Message-ID: <16bb90f4-9abb-a225-c194-a72982eda739@quicinc.com>
Date:   Sat, 6 May 2023 22:20:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 4/5] scsi: ufs: core: Unexport ufshcd_hold() and
 ufshcd_release()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Can Guo" <quic_cang@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230504235052.4423-1-bvanassche@acm.org>
 <20230504235052.4423-5-bvanassche@acm.org>
 <990e73a9-b42f-6d13-59a4-ac84edadd602@quicinc.com>
 <01d01fa0-9a11-bdad-af82-b1ad9b07ad7b@acm.org>
Content-Language: en-US
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <01d01fa0-9a11-bdad-af82-b1ad9b07ad7b@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: WZs2sd_Il1d_q0p0Osy1koMcwF9hF_V2
X-Proofpoint-ORIG-GUID: WZs2sd_Il1d_q0p0Osy1koMcwF9hF_V2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-07_02,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=834 suspectscore=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305070041
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/5/2023 12:00 PM, Bart Van Assche wrote:
> On 5/5/23 11:40, Bao D. Nguyen wrote:
>> On 5/4/2023 4:50 PM, Bart Van Assche wrote:
>>> Unexport these functions since these are only used by the UFS core.
>>
>> Qualcomm uses these ufshcd_hold() and ufshcd_release() functions in 
>> ufs-qcom.c. I am going to post Qualcomm's change soon.
> 
> Hi Bao,
> 
> I will drop this patch.
> 
> Does the code that you plan to post pass 'false' or 'true' as second
> argument to ufshcd_hold()?
Thanks Bart. We are using ufshcd_hold(hba, false);

Thanks,
Bao

> 
> Thanks,
> 
> Bart.

