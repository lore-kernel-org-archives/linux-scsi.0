Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E427C678DC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 21:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355430AbjHQVsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 17:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355428AbjHQVsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 17:48:08 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2752F123;
        Thu, 17 Aug 2023 14:48:07 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HKjXWP008778;
        Thu, 17 Aug 2023 21:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=aiyqthPCZmbfbfAJ8roBzH7300hp+FwPmcUCnP9AKc8=;
 b=gO0JJZ+Gjc32KNmNFS5VAOPwOb3MLRsE52lqBpbDDBxZO/Pl2N+X8UmiXA1mnh1GXKO2
 DXIK2vtfpBAyh9ihhwvTimi1o9ozkZh+8wegzogROfCqI26W7pwQu4I82XrHjvXaTLvc
 O7IdTG5Itl2oeIdEST9cTgFgadNQgc0gU6M6FCgOlRm1E6yyrKNy2HZpiwYZ6EEQIzoU
 EHqWqEIbac9PpW+f3AuqnGQh0BPjG1NuCX3pqdDiQPjXX2sBVVMK58LuGQ0JaFqGnoEd
 +0uguu3HMXMTA3sS9KNWw/hry37LmcnWP5x6Cu0YRr8boeD4ivl7mO0ncZWKjbSpSJZ1 NA== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3shscrg9ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 21:47:39 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37HLlbOm019804
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Aug 2023 21:47:37 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 17 Aug
 2023 14:47:37 -0700
Message-ID: <97100392-0c17-e950-1dd4-c52b97aecbe8@quicinc.com>
Date:   Thu, 17 Aug 2023 14:47:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 17/17] scsi: ufs: Inform the block layer about write
 ordering
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Can Guo" <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Damien Le Moal" <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo" <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-18-bvanassche@acm.org>
 <666c6d78-d975-c9f9-4ad2-c9fa86497b47@quicinc.com>
 <4f332520-329c-6355-3aa3-cd5e29716a06@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <4f332520-329c-6355-3aa3-cd5e29716a06@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: L8mQZpcvwmscM0-6ijtrE_A3-2HfgETt
X-Proofpoint-ORIG-GUID: L8mQZpcvwmscM0-6ijtrE_A3-2HfgETt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_18,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308170193
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2023 12:34 PM, Bart Van Assche wrote:
> On 8/17/23 12:00, Bao D. Nguyen wrote:
>> In legacy SDB mode with auto-hibernation enabled, the default setting 
>> for the
>> driver_preserves_write_order = false.
>  >
>> Using the default setting, it may be missing this check that is part 
>> of the 
>> ufshcd_auto_hibern8_update()->ufshcd_update_preserves_write_order().
> 
> If auto-hibernation is enabled by the host driver, 
> driver_preserves_write_order
> is set by the following code in ufshcd_slave_configure():
> 
>      q->limits.driver_preserves_write_order =
>          !ufshcd_is_auto_hibern8_supported(hba) ||
>          FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
> 
> Does this answer your question?
Hi Bart,
My concern is that in the ufshcd_update_preserves_write_order() you have 
this logic:

	if (!preserves_write_order) {
		shost_for_each_device(sdev, hba->host) {
			struct request_queue *q = sdev->request_queue;
			/*...*/
			if (blk_queue_is_zoned(q) && !q->elevator)
				return -EPERM;
		}
	}

The above logic is only invoked when ufshcd_auto_hibern8_update() is 
called. During initialization, ufshcd_auto_hibern8_update() is not 
called. Therefore, you may have SDB mode with auto hibernate enabled -> 
preserves_write_order = false, and (blk_queue_is_zoned(q) && 
!q->elevator) is true. Is that a problem? If you called 
ufshcd_auto_hibern8_update() during ufs probe, you would have returned 
-EPERM and not enable auto-hibernation in that case.

Thanks,
Bao


> 
> Thanks,
> 
> Bart.

