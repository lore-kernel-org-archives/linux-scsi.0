Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA833C64ED6
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 17:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjB0RLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 12:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjB0RLT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 12:11:19 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CBD206B2
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 09:11:13 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RE3X9u025424;
        Mon, 27 Feb 2023 17:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=U5D0aFG4uhOW2jz83lGG0JY9dVVnzStBuYIBq9r2D7Q=;
 b=g10H65RxMMvMToSPhxqC9/nNXq4MeBzoCuf6KfgGu0bCf6YSSbanzfspiPEN/yaC2oWT
 oe8EcOAWwS/LlnMMUEtFtlrr6bq5XGRl3TWOBvTv5mxct2TS4ldK/ju9MwDgStLON0h5
 dcSbSggZE1dcy3B2pPaQdYKpgM8AsOGqWvW9KR9VebLCiDH/rIwiBPJnoJaOUrO7XfSu
 byDekZnLOa3uRFyn6J+qbllQaAbN6Pb2ff+mSwEWr180f/jJkVHye4V1RlfIIhozD7gg
 C2t/rNEoYWwyWiyut5S8jKBFpwAz3DrgaF0SfQvV6AaIqFmNDWW3TzfUTkF/rZW5pCYJ VQ== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ny9a0wpmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 17:11:11 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31RHBAjo016412
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 17:11:10 GMT
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 27 Feb 2023 09:11:10 -0800
Date:   Mon, 27 Feb 2023 09:11:01 -0800
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Dan Carpenter <error27@gmail.com>
CC:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [bug report] scsi: ufs: core: mcq: Configure resource regions
Message-ID: <20230227171101.GA10301@asutoshd-linux1.qualcomm.com>
References: <Y/xmx5xpbjUJlNxy@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/xmx5xpbjUJlNxy@kili>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: rU4hcwbBNVWCdIlNvqP5tnzS2HDl72yQ
X-Proofpoint-GUID: rU4hcwbBNVWCdIlNvqP5tnzS2HDl72yQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_13,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 27 2023 at 00:16 -0800, Dan Carpenter wrote:
>Hello Asutosh Das,
>
>The patch c263b4ef737e: "scsi: ufs: core: mcq: Configure resource
>regions" from Jan 13, 2023, leads to the following Smatch static
>checker warning:
>
>drivers/ufs/host/ufs-qcom.c:1455 ufs_qcom_mcq_config_resource() warn: passing zero to 'PTR_ERR'
>drivers/ufs/host/ufs-qcom.c:1469 ufs_qcom_mcq_config_resource() info: returning a literal zero is cleaner
>

Hello Dan
Thanks for reporting this. I will fix and push a change sometime this week.

-Asd

>drivers/ufs/host/ufs-qcom.c
>    1425 static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
>    1426 {
>    1427         struct platform_device *pdev = to_platform_device(hba->dev);
>    1428         struct ufshcd_res_info *res;
>    1429         struct resource *res_mem, *res_mcq;
>    1430         int i, ret = 0;
>    1431
>    1432         memcpy(hba->res, ufs_res_info, sizeof(ufs_res_info));
>    1433
>    1434         for (i = 0; i < RES_MAX; i++) {
>    1435                 res = &hba->res[i];
>    1436                 res->resource = platform_get_resource_byname(pdev,
>    1437                                                              IORESOURCE_MEM,
>    1438                                                              res->name);
>    1439                 if (!res->resource) {
>    1440                         dev_info(hba->dev, "Resource %s not provided\n", res->name);
>    1441                         if (i == RES_UFS)
>    1442                                 return -ENOMEM;
>    1443                         continue;
>    1444                 } else if (i == RES_UFS) {
>    1445                         res_mem = res->resource;
>    1446                         res->base = hba->mmio_base;
>    1447                         continue;
>    1448                 }
>    1449
>    1450                 res->base = devm_ioremap_resource(hba->dev, res->resource);
>    1451                 if (IS_ERR(res->base)) {
>    1452                         dev_err(hba->dev, "Failed to map res %s, err=%d\n",
>    1453                                          res->name, (int)PTR_ERR(res->base));
>    1454                         res->base = NULL;
>                                 ^^^^^^^^^^^^^^^^
>
>--> 1455                         ret = PTR_ERR(res->base);
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^
>Need to preserve the error code beforse setting this to NULL.
>
>    1456                         return ret;
>    1457                 }
>    1458         }
>    1459
>    1460         /* MCQ resource provided in DT */
>    1461         res = &hba->res[RES_MCQ];
>    1462         /* Bail if MCQ resource is provided */
>    1463         if (res->base)
>    1464                 goto out;
>    1465
>    1466         /* Explicitly allocate MCQ resource from ufs_mem */
>    1467         res_mcq = devm_kzalloc(hba->dev, sizeof(*res_mcq), GFP_KERNEL);
>    1468         if (!res_mcq)
>    1469                 return ret;
>
>Return -ENOMEM;
>
>    1470
>    1471         res_mcq->start = res_mem->start +
>    1472                          MCQ_SQATTR_OFFSET(hba->mcq_capabilities);
>    1473         res_mcq->end = res_mcq->start + hba->nr_hw_queues * MCQ_QCFG_SIZE - 1;
>    1474         res_mcq->flags = res_mem->flags;
>    1475         res_mcq->name = "mcq";
>    1476
>    1477         ret = insert_resource(&iomem_resource, res_mcq);
>    1478         if (ret) {
>    1479                 dev_err(hba->dev, "Failed to insert MCQ resource, err=%d\n",
>    1480                         ret);
>    1481                 goto insert_res_err;
>    1482         }
>    1483
>    1484         res->base = devm_ioremap_resource(hba->dev, res_mcq);
>    1485         if (IS_ERR(res->base)) {
>    1486                 dev_err(hba->dev, "MCQ registers mapping failed, err=%d\n",
>    1487                         (int)PTR_ERR(res->base));
>    1488                 ret = PTR_ERR(res->base);
>    1489                 goto ioremap_err;
>    1490         }
>    1491
>    1492 out:
>    1493         hba->mcq_base = res->base;
>    1494         return 0;
>    1495 ioremap_err:
>    1496         res->base = NULL;
>    1497         remove_resource(res_mcq);
>    1498 insert_res_err:
>    1499         devm_kfree(hba->dev, res_mcq);
>
>No need to call devm_kfree().  The whole point of devm_ is that it's
>automatic.
>
>    1500         return ret;
>    1501 }
>
>regards,
>dan carpenter
