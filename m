Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A475EE4993
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 07:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbjHUHNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 03:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjHUHNZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 03:13:25 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF375A8;
        Mon, 21 Aug 2023 00:13:23 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37L67nNn021132;
        Mon, 21 Aug 2023 07:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=/lmb1FNI0MH6NcGL5KcSF8c1B/tlwk69ZMQJhNn2pkk=;
 b=h+I78vDuXZmPwCpXnEVam0da2ckvrQvidRDqHKwr/PtNVOPDuS+UsuZ1py3Udshgubts
 NWV8bZ1I00xkno1AF16Wl0S/Adzs9ksQ7bv7VtxEgIiOZ3upLCngDxcc64fQi3J4EnGQ
 iasKJJNdPphRKOraXmiodMhIGMG8t43F+ETP8N+k3EoxceFvv0KLOBKZvOgIiYxLBq6s
 sVVV6cXc/P8KGxLcCygt+cFuyiybWzVnQjDEp3XP5DBhqQapEx2Gsu8I9QigqLt74vdt
 BRTqSP/scPlYpRmMmopMzqdU6uEoadYksrfuCm5SM/JR+lQIWFHj3wZBFZNMiUMelTBx 4Q== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sjnu12ucp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 07:13:13 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37L7DC9Z005547
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 07:13:12 GMT
Received: from [10.253.34.146] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Mon, 21 Aug
 2023 00:13:08 -0700
Message-ID: <1bc8c982-8c2c-5047-05d0-a0d4a195ba60@quicinc.com>
Date:   Mon, 21 Aug 2023 15:13:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 17/18] scsi: ufs: Forbid auto-hibernation without I/O
 scheduler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-18-bvanassche@acm.org>
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20230818193546.2014874-18-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: EUvGSZ27v9SbxmSQix-iM3eIjDmFRShh
X-Proofpoint-GUID: EUvGSZ27v9SbxmSQix-iM3eIjDmFRShh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-20_15,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2308210065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/19/2023 3:34 AM, Bart Van Assche wrote:
> UFSHCI 3.0 controllers do not preserve the write order if auto-hibernation
> is enabled. If the write order is not preserved, an I/O scheduler is
> required to serialize zoned writes. Hence do not allow auto-hibernation
> to be enabled without I/O scheduler if a zoned logical unit is present
> and if the controller is operating in legacy mode. This patch has been
> tested with the following shell script:
>
>      show_ah8() {
>          echo -n "auto_hibern8: "
>          adb shell "cat /sys/devices/platform/13200000.ufs/auto_hibern8"
>      }
>
>      set_ah8() {
>          local rc
>          adb shell "echo $1 > /sys/devices/platform/13200000.ufs/auto_hibern8"
>          rc=$?
>          show_ah8
>          return $rc
>      }
>
>      set_iosched() {
>          adb shell "echo $1 >/sys/class/block/$zoned_bdev/queue/scheduler &&
>      	           echo -n 'I/O scheduler: ' &&
> 	           cat /sys/class/block/sde/queue/scheduler"
>      }
>
>      adb root
>      zoned_bdev=$(adb shell grep -lvw 0 /sys/class/block/sd*/queue/chunk_sectors |&
> 	         sed 's|/sys/class/block/||g;s|/queue/chunk_sectors||g')
>      [ -n "$zoned_bdev" ]
>      show_ah8
>      set_ah8 0
>      set_iosched none
>      if set_ah8 150000; then
>          echo "Error: enabled AH8 without I/O scheduler"
>      fi
>      set_iosched mq-deadline
>      set_ah8 150000
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 58 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 58 insertions(+)
>
Reviewed-by: Can Guo <quic_cang@quicinc.com>

