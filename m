Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0E4C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKZAcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiKZAcN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:32:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934AF23BF7
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:32:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APNQ4BZ018651;
        Sat, 26 Nov 2022 00:32:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=YF09Gk4tWQT9AnDwRye6KuOg4Us7ypQkVmyEazH13Sc=;
 b=UMuAA4qwIRqMgX9p1q9qpK2Jg00LBHuc9cvns1BGAhZC9XWdjpkcfvZoSKbKyzzId2Nf
 I/rYiWEjylTgciblG15WsEkC8dxUmICv3PqFTVD0Nv4tupYh4DWPbJqK5pJ3F5NUH05C
 AOCYO4QRn4ja0+csnKJRqjMQ/xCbro41U7Y2j7uIWdgs9eg4hJBVbkny1lVozRHL7KAQ
 Iy/GtjR1adIFuuu0WJyEuBKCmvGNeLsI0Cyj12kvtKT3FZ+WOhKwwHlsff7mxYC/4GsC
 sqXr8IVLWwmBUm3sTc4J+xZR3bCjG4tKXsnDIKuvqcxwPVMGC4hBU+ZKOPlkbMj7PMqu vg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1nd8dh5m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:32:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APKR1Zg001510;
        Sat, 26 Nov 2022 00:20:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk9hu96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:20:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsCsAIVxCH3ibqtlL5cSJ+dsvpNm1OtuwbVSK5YGp9Aaui2dls78QKTGaZmrlVDkZ7oYCRAph0OWZxRXgkTRqYQuSnmH/lruR2HufsaAzexvsZLVBa1YnHaqdUMtCNU/WQA9Yq4RHXK2ujABcaIRspH6YIh+nP3Ipywn+IRKBpNkFHpo2EBFKMIkdvYjzMKbR8ONPQgtCO5jovhjAaWTCYbVZuoZh+5FFoYDojxrM1AGf9R2AF/8wbfCUEaEzEUD1dboZg9uLS6SKm+DEzCRMb7kQ+AnLS+c7C+yUma6/XirXmBX9XGC00JCwanyZZXKd7f5Afy8U46gRS07uPtVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YF09Gk4tWQT9AnDwRye6KuOg4Us7ypQkVmyEazH13Sc=;
 b=eTZSGBF7MZu0nio5e3kaPLXvra7CCrISAn7RaaIMOGUVYSZnbg/qaZiXpM/AcWy1isiHpml+15Z+6f9DZr8nZoV79EOBO1YVk5ckIcdU4RFaeXSnkoAmTGvP21D5uOZhaPUVnCGOppb5rIkdPhXelpVmJbAPtF2LnT1e2on/oekNCKAFBh3KOha0Ks1et8whgF9X7PjDh2nYJEX7nn6AU1g7H5BJMVSkS3xS+FzcXqVgDZjTGP7MY69OWaJfryi1ckJ+fJJjBieAN0ez+n7RLobnavQUqOa6ny/DRpHsmpUjL/iTk2MkFNin1mzvXjyBDvTetSbOw1BVLOeO4vPj4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YF09Gk4tWQT9AnDwRye6KuOg4Us7ypQkVmyEazH13Sc=;
 b=DoY3UPSxImyK+eZ0wZLaqYUYnZdreGpfrcW5yvYP8KwReJLV5cZUpoBHG+HwAZgvpq+qab8x8+B/Dg3f0r0zM4qTbMfjdrm9M7wEPQMzWGPaSIGN5AFgR71OfsNRO/FkGjnRTG7Vs9LcFHpDi0Q+0EJ4DXLMzyhrcUpD1oX9Les=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6282.namprd10.prod.outlook.com (2603:10b6:510:1a8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Sat, 26 Nov
 2022 00:20:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:20:37 +0000
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_debug: fix possible name leak in
 sdebug_add_host_helper()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135a6r2gj.fsf@ca-mkp.ca.oracle.com>
References: <20221112131010.3757845-1-yangyingliang@huawei.com>
Date:   Fri, 25 Nov 2022 19:20:34 -0500
In-Reply-To: <20221112131010.3757845-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Sat, 12 Nov 2022 21:10:10 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ea1114-5cb9-4fb3-9840-08dacf440aaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Cz1DeyLQAbZ9hoe9zoDYB+uZRmKVBEfB/T4bbBVIprxYU60LMtafb0Z7pvweqQ2Sc6Irzakr70A2C1snlO7x1MtkAOoWmtVR/I2Vwrs/tdrzQC6Qxjr+Votu0MGoZ2N95A4aR9ooDpKgJTGdBOm5irrLd82ebo+t1U4kFbJ6aCNaLscMWHKW3YIoCG1FkAUeZNL9nhCtEYJNfREpUCsWSjY2N1nnGnwA2Xq9ZQcxLHh4SPxNqG7dl3piGdyH+TATP1TUjmTdQRujXUhmUgqZPOUoI3T9/KgS4o9AaOmmcNykOkqsjnXZtbk416ZQfbovP0Pe8rulmfD80jGesZFbYOr2SNHaCckh/mlFdUfMkoRAmYJnf5jPzUT7KkaOBAxeSQtSyR6btN//Zvzh/t7V3XQ6nMi43+v56wGOcnibwMAUphHvgQKhQRNVson0OFgvsNDzLCz0l+I9CFPbNfn/qDqsZK4UmMRvImX1Akv6jo7zkBMhoZD1ypuHRVky7itCRm1YlzIeZbU21qwyswCw5peK7yehQQKtvak6amT8Z0dXZ1bbhrKaF2Nl3XY6koOP5G6gqCnqqXcITXP7hwU57hrI6uSI9RXRroPSaq/I3cAKHFOgmFJD2UDn8b+L5xpqeXABjBIjo1S5FwLH78PNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199015)(38100700002)(2906002)(6916009)(558084003)(86362001)(8936002)(5660300002)(186003)(26005)(6512007)(66556008)(478600001)(66476007)(66946007)(41300700001)(54906003)(316002)(107886003)(6666004)(36916002)(4326008)(6486002)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cPGImc1aijjcvBibLvLWPhoZN8mAcGhzXElfh36sZLBG8ltnDCtdwsRBBk8P?=
 =?us-ascii?Q?OYOUQiJ89qwHIk3OKqYuL3Kt4nmlaI7AldZ1Y7+3i+MQGpSR2qMQq8Zy1INU?=
 =?us-ascii?Q?kgeidGnGxXfW7hzYuCzHFyDHIqFtq3WvTqj78+kGSHL5NV7bvKear7WmUN8e?=
 =?us-ascii?Q?FnmoxgmVe5INDkcws2wtI65OF/5AfzHJ52W1pMuoySS0N9ImRoN93zP8pTfK?=
 =?us-ascii?Q?8pRO9bE7N2WFJEfHZHWW7D0ZKxA7mFXRSn59WrgWIn3dNzfAkwQCaq2OYkVp?=
 =?us-ascii?Q?8RDuOoEVITv+ipka0nOYo0Ztfy/8IJZSrCGLNxef3VS4xW4xzECDar/5JDOV?=
 =?us-ascii?Q?zIkR4YlpPYi2FDKSu6fetj/W8EXUaNF8n9Oc1+shOo9ad9yRC2SIdoWCmtCo?=
 =?us-ascii?Q?SlUGIEziZ4Ct13tWC+LH9HWPJhpGqFThjBwEPSEN0CMG5IoMvEdazIN70zke?=
 =?us-ascii?Q?1zKfrWrlcZ6CctJhUcHDDDJ1GLQDsDCn5btQjk2Zd9pUdeM5lWKqVmwgNkgw?=
 =?us-ascii?Q?IgTunY3Lsde/s/5cpI9ifvtQkHFLbDMZHIP8id3f3bDYW/n093uSoIXqy/Vq?=
 =?us-ascii?Q?E1/U7WTAlxptUy2c9ZtGz/htecApTppfm2JpPVtRRBBN74zVUMxhLJju5CuD?=
 =?us-ascii?Q?/pHwXQnAdROe7onhZIbaHnQdc8xpH9NiGDboM9YsMVlE16dulVItoJUBnKcr?=
 =?us-ascii?Q?p9xfN3sktkTFAKMgKAuNCp5zbUBBvBCLZO5xFEkLwb4tVBdV7D+WMRNdCMcV?=
 =?us-ascii?Q?yekcu8f1q7bwmLboM+6tegtYHVJl7JRyffeDazFGLFyK/2ON8/MBRS4qW+oA?=
 =?us-ascii?Q?aBQliKL0TRLqFKnyhTN3AZvJGfBXJzNg7fRs6NMe2SM/OJbNJb7hkaaPSDLl?=
 =?us-ascii?Q?oHSuZeVCZwyGMQosyVpWV/1/0FMGfWw26YqUBvd9koa0G2CYvbzY10yGbbb0?=
 =?us-ascii?Q?/vyt2vg2Vg80b3rNpaTvWCpc+8bfp/HTvPAolEDLgHn0Ahg/bXK8u7uf5BOt?=
 =?us-ascii?Q?Y/lVS5ULqRMERvztjWdIvsJsZM6kqVtEhSeTzfhCEHLjpRR2ITlvTn1QIFoE?=
 =?us-ascii?Q?jMLK49P8zwPSoKArYV2DX9MrhzmpK0I7MiTTCxn72rQ52KJStGRT2t3EDkDs?=
 =?us-ascii?Q?exdgjMQbDCyMEDtYrqqs0ZbfD+USsfjN02q+JQpEaSFwVv19R3d8X/GICCFi?=
 =?us-ascii?Q?FgunwctNklz3LoMuLlKDOqFRCp/xdmKOg8Xq87jr3JxEuXWeULVbLVREzpvL?=
 =?us-ascii?Q?5Cczwsk6CKJSR/H13T8FgW86KpruAbYR36rHy4joCj8tbYnKkLvC8lKBYQ62?=
 =?us-ascii?Q?RLY554OlGnZmDdfTN86GAPyaFxhrPxOk/NQa67wc/Np6keSDnFJ5VxK7uM9Z?=
 =?us-ascii?Q?wldF7kMm/Il20v0IqEMbRB0HIt2rWQsXpvHl9C/n5ARn+7JImpuPLHUsWgoQ?=
 =?us-ascii?Q?qCnoB8UPlkxkohpgTVV5I8j8WADp5plUr6DVV9+Pna81twaMqngSTq9dwNcA?=
 =?us-ascii?Q?c8VptmdJJCJbmkkkHM+Rl3SK/QRMTd8Gqwx62vsL2Jl7ZEH5c9sALRcBahCy?=
 =?us-ascii?Q?N5K9wX4/85hGwLJFY4vxKfV8TQOvwGCU3oPgic8pRYcGCUVcj5V2G13stTg+?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cz0dC1Kvd/SVqv22KYWbGp3dlym2PY1RREJLOYPkd7lO4N8NXtduOgaeYUt7dKqd/3OAfXmTEjWh7/zTxZVpSBHsdeyIXaowt+23awKLAY6kifRxrffDfloaxnVXXuluX07jA7PywsJRFogmpv+d9pxTm+E7rq0c2bOud7cvHVIHufTJckEYgtp1vnT1eafAqm4pctMsTTJqngZMPSH0qPeErFIVlQAVcWUKTGUdzT/6sBZEXVzVJyczDrgOK02fkFVcFBrNd92SVDRF2GDBhtjLi3r7HbVXGLC+dVlkTbJxfr1Hzb3D54KXT1mDJD1f0UCCS+DJy4TeJaI4EwYYb0c9kRBtLs7D7VjLhJmAdHjLThQReMesaLhzrWDYf7Ty5T/8QjfcTjgpVyV5EsExHhpUCn60nwrCp0qdk5kLUP1khIifC0Htl4LDGVGraVpqwSomHUgBgPOFzJLQD9kDgpt3HP3Div89YZvsvjeanlEe29muvx5aE68Xu4U7FiMFkgQCb8Yy++x6dbteM/t/uZFShkDuFFujm1Q+/W9pEx4UC7XSUw317c6rpEQ7o6nzT+HMQqNcKAEpF+SEETxQK7wiW+R6xbrzpaG3dOcWBNldBEc2wo2n0qJ3tIBUyWDAQ2fLoa3d+vsmdfbOtX4etkIm4gSjoJNVq1YWYab2XACWmtN1PF8DF3Awwrh0iY/Mw1q31cPtrGbqDxF3XnhVs9maSABoGWxAX+gOJJOE5rclUvBcOAq8BSx0H61iFoRB6hTLmUGonVgOnm1XNgHgr9lr2YSRRKLthbBgV+pky7MCjUKHKdMjAu4mc7vpFX1JENqUidCqi3A5GWdgYdeEYg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ea1114-5cb9-4fb3-9840-08dacf440aaf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:20:37.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/v7K7eNrfCslyQugaFlumfBOevaAEgVPpOTjTy6AQ1tdulSoRox2pcMMayY48gePkpejb5jvCiZQRJXzvmTUQKzmbrFanbQ7HXbZu4ZwzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6282
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211260000
X-Proofpoint-GUID: qLBhZmYUhW0ug-5EKCocn5bJC9JsB8T3
X-Proofpoint-ORIG-GUID: qLBhZmYUhW0ug-5EKCocn5bJC9JsB8T3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
> bus_id string array"), the name of device is allocated dynamically,
> it needs be freed, when device_register() returns error.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
