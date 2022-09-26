Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C5FC32771
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 18:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIZS41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 14:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiIZS4Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 14:56:25 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE6561DBC
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 11:56:24 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QIc0TX029109;
        Mon, 26 Sep 2022 18:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=bvdXHN6vP4kNBt6JcBzJk7vmEspEQD7GvxU0iOUauTk=;
 b=JlhX7g7k7d4uXvEArOUecEzUqebw31Sa/UXcr7v9avZfvGo/PE4nROYWE0b4g/RfhWyl
 4GpmKGfwQRVwVR+6Uw0xV5K+FbMn+JkR88CCK6vEb3VyI54scCk+wMdiUpuf7/8Ud+Df
 b1jJ2FRwhwM+B2KMTd01qkp+ztCAIiPlxr1jFH0qIYgJO9LCYIGSlAQgnbUBuZaolXxe
 a/Nxcj9FGxENcWndV0hdIQIUxAdSiUjAt85g8cdWHSFVMlFUtBXDZaxLTZKI8JnOxzwK
 ogLy/A0Vz20liBc4cdc2F04a4MFh+P102yzXPOUADklmJCK/1gbKF48FUQVBfLmxmTO9 sQ== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jue008p5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 18:55:58 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28QItvdr007229
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 18:55:57 GMT
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 26 Sep 2022 11:55:57 -0700
Date:   Mon, 26 Sep 2022 11:55:29 -0700
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Manivannan Sadhasivam <mani@kernel.org>
CC:     <quic_nguyenb@quicinc.com>, <quic_xiaosenh@quicinc.com>,
        <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>,
        <quic_rampraka@quicinc.com>, <quic_richardp@quicinc.com>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <bvanassche@acm.org>, <avri.altman@wdc.com>, <beanhuo@micron.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1 00/16] Add Multi Circular Queue Support
Message-ID: <20220926185529.GA15228@asutoshd-linux1.qualcomm.com>
References: <cover.1663894792.git.quic_asutoshd@quicinc.com>
 <20220926134942.GB101994@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20220926134942.GB101994@thinkpad>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: kktRfshA7eazCiLO_cRa7J83I4G7Y9pa
X-Proofpoint-ORIG-GUID: kktRfshA7eazCiLO_cRa7J83I4G7Y9pa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_09,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=941 suspectscore=0 spamscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209260117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Mani,
Thanks for taking a look at the series.

On Mon, Sep 26 2022 at 06:50 -0700, Manivannan Sadhasivam wrote:
>On Thu, Sep 22, 2022 at 06:05:07PM -0700, Asutosh Das wrote:
>>
>> UFS Multi-Circular Queue (MCQ) has been added in UFSHCI v4.0 to improve storage performance.
>> This patch series is a RFC implementation of this.
>
>This is no more an RFC series. Also, it would be good if you can provide a
>summary on how the implementation has been done.
>

Sure, I will add it.
I shall wait for more comments from others for some more time before pushing the
next version.

-asd
