Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE99C7112B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 00:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbjHRAU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 20:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356767AbjHRAUZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 20:20:25 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEA6E40;
        Thu, 17 Aug 2023 17:20:21 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HNvdlr003288;
        Fri, 18 Aug 2023 00:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=yXOZciuPqV7chtvYkLfAMYNoC63CULRatWttkUl5tWY=;
 b=Nm54F/gCtM+O+1+Z/Px54IYW9Y9yfu5fXIAg+d2xEWbvAp6Z3/Z5l5DWPG6h6FaOVhUq
 iUf44tcyS6B+kh3ysgm7d9CCvQ5EB/cWTei4ygGjE/dXGgXcZRAOwywMM+7RY6YgDw/D
 L6m5T4MECfent9OWj7vLA7/ri1u9HuaP3egxioY4dTUJjcEwJMJtC1Q7p0TUTWEde7U5
 7fJ+683Gs72pNS+CNYLkzwtICyK0VWPLdRRBc5bZ7k2UVGjOg88upR4lxEB1qxGx0FPo
 tvOL0eo/YyZKwO0KsBWVIXAtFJqKAJqNTP/115PRfBp+RWeSk45iJfLNsvJ/G4u1GShi Bg== 
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3shbc0thwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 00:20:00 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37I0JxhC007832
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 00:19:59 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Thu, 17 Aug
 2023 17:19:58 -0700
Message-ID: <8299025e-e895-8fdb-c62d-80f1d4c9b64c@quicinc.com>
Date:   Thu, 17 Aug 2023 17:19:58 -0700
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
 <97100392-0c17-e950-1dd4-c52b97aecbe8@quicinc.com>
 <5d8e90b9-34c8-5cab-2653-6f28e68eda94@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <5d8e90b9-34c8-5cab-2653-6f28e68eda94@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Ji8X2EJjH3Rg1o2phHdFnSpCmpXcyD7N
X-Proofpoint-GUID: Ji8X2EJjH3Rg1o2phHdFnSpCmpXcyD7N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_18,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2023 3:05 PM, Bart Van Assche wrote:
> On 8/17/23 14:47, Bao D. Nguyen wrote:
>> During initialization, ufshcd_auto_hibern8_update() is not called. 
>> Therefore,
>> you may have SDB mode with auto hibernate enabled -> 
>> preserves_write_order = false, [ ... ]
> 
> Hi Bao,
> 
> ufshcd_slave_configure() is called before any SCSI commands are 
> submitted to a
> logical unit. ufshcd_slave_configure() sets 'preserves_write_order' 
> depending on
> the value of hba->ahit. Does this answer your question?

Sorry Bart. Not yet :-) Please let me try to explain myself again.

For example, in SDB mode, after the probe and you want to enable 
auto-hibern8, you would call ufshcd_auto_hibern8_update() which then calls
ufshcd_update_preserves_write_order(). Before auto-hibern8 is enabled, 
you would check this condition:
	if (blk_queue_is_zoned(q) && !q->elevator)

In other words, auto-hibern8 is enabled only if the above condition false.

However, the during a normal operation, the ufshcd_auto_hibern8_update() 
may not get called at all, and auto-hibern8 can be enabled in SDB mode 
as part of ufs init. Would that be a problem to have auto-hibern8 
enabled without checking whether the above condition is false?

Thanks
Bao

> 
> Thanks,
> 
> Bart.

