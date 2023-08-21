Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72846EE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 05:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbjHUFe7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 01:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjHUFe7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 01:34:59 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA389A3;
        Sun, 20 Aug 2023 22:34:57 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37L5LZ4m026495;
        Mon, 21 Aug 2023 05:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=VzlblGZEUdEq99f+mmQ+9c3/eMGhpytLjzqPsV2cxyc=;
 b=Gu66FOrSijYlkBMDVB/lYU7N1j1CUn99NClIPgLsjZWz5f+x6DimYG200lzRT8CgaD3o
 NjEayzZ9Q4WRfMLiQI0QPiGtwinKlpqXvvoOPCY6gWAAMZy47SO7mKETKVvxebE2PMYU
 s7lfccsUEpAh1EUFLwP0TXLi4eBCtofd5tfhkj1gqF4X3Kq1kCLQKcBdexXwbVN/iW6T
 3KztkZLdii/ySud/TYe8pgRrQGv636p2dQ0SyY18GZgOWbX9udy+DYpzDr5rMMe5o0zb
 U48MyHivRZ+h5YLa9WgYRGTz/TrNGPxBSfbgJcBmFYg/API+GO9bYfBFNxlYrDKayoie Kw== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sjmpxk0kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 05:34:30 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37L5YD1U005394
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 05:34:13 GMT
Received: from [10.253.34.146] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Sun, 20 Aug
 2023 22:34:09 -0700
Message-ID: <3d749e15-ccb9-fc9f-3ea3-64cf133a369c@quicinc.com>
Date:   Mon, 21 Aug 2023 13:34:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 15/18] scsi: ufs: Rename ufshcd_auto_hibern8_enable()
 and make it static
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-16-bvanassche@acm.org>
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20230818193546.2014874-16-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 7WK8w_Dj0sa1iA2YaxJT17-1eP6tTFrj
X-Proofpoint-ORIG-GUID: 7WK8w_Dj0sa1iA2YaxJT17-1eP6tTFrj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-20_15,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308210052
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/19/2023 3:34 AM, Bart Van Assche wrote:
> Rename ufshcd_auto_hibern8_enable() into ufshcd_configure_auto_hibern8()
> since this function can enable or disable auto-hibernation. Since
> ufshcd_auto_hibern8_enable() is only used inside the UFSHCI driver core,
> declare it static. Additionally, move the definition of this function to
> just before its first caller.
>
> Suggested-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 24 +++++++++++-------------
>   include/ufs/ufshcd.h      |  1 -
>   2 files changed, 11 insertions(+), 14 deletions(-)

Reviewed-by: Can Guo <quic_cang@quicinc.com>

