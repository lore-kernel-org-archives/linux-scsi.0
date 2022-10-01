Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB95FC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiJAJzP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJAJzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:55:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210273C17F
        for <linux-scsi@vger.kernel.org>; Sat,  1 Oct 2022 02:55:11 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2913wM9t007841;
        Sat, 1 Oct 2022 09:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=tEODBrX8F5SZCJ3xrLunqFMALVn4wWRI4BUuWTgfpCo=;
 b=2QO9FMJSLtBgt/a0meZWe+fsyrFp7SezlDmC0cfnlZJttfI1u49MGieZmHFTJ9GovCyt
 s9yLr+CQlR3tN/jGQdAv/0FInrTwZWdgMXwFgQfz8CNXI+xXv4DAcjOIw+/lK3ZMI7jz
 i83fLyBJqBY2uFxYbbB8kU5Sl2GAFiVMEYpJb/WrR+ZKSUCloa01PYeiaRGEPcG9Vc0m
 mPfyVXyCHNUdK480FxK/lMm0R097KIq3geQUWhQoPmrhI4kMI9LiotgCqs4rO33+hscO
 V2V7v6zdWOweqOv+mHB9DLgPj/9m7wdFl7C7xcSGj33WOSJIWkfW6i85Ke/UIAu+BhAQ mw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tgcy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:55:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29195srv034505;
        Sat, 1 Oct 2022 09:55:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc07xuyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITthJpVwPohucgrahHaRvBKRTZGFLF/uUx1l+WVjsT3NndUrGKigryxa5GdjYqTGdtGIwGO0xX/pJGgmwF1PG59LRWrM9MImiv4JOPA/TMoN7VkTU/jsfGMY5N4ESo4VU820RAhy4QQJiL3AU3rERYMh+s0dJ1MC9pM2PCy9tS+iAamqH1enxWYJFUlTkhgFDKHYJwqb8o3REUW4lYnQir/8KlH87UR069OpflsbpoKWzcKuEWEV5SjBtQnxZVukuLDBWROYbfXaUu7H9/BEtXYW4OaXiadwJDWM3h/s18nfu1aR4pHEGuaeTfn/yp9lk5CDLh9wtxekcPVJ2WRgmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEODBrX8F5SZCJ3xrLunqFMALVn4wWRI4BUuWTgfpCo=;
 b=BIf55MBIPm/04asZ0i9GuFtWrYo2F3MCmBueOJg2r1fG2E+kfzvDg5lCf9A8Ooah4qCLpw6k45T2hhifmL7cw0HTAk2gib0X6e5SZzkfz5PYTXZJNfk+cqwjkz6hw5oAk9rD4zE3FqkyU4c3R+5PbAwelaCStmzx9oek7u8sI7rvBOStzpmh8tNWQPnJXFFnx+FaJc23ICbQ/XiLbAXfZNNtIXa2YgMRk5y31qkGPJBCoH7v6ZvrrS+4X74pJRQporWiCjw/QjJBbxzoE0bYA+HycOVUn0lYnM9DZ1yjDfxyfYnI3Vm1Ap1tXHAp+Kv8a6WSBu5+7GyHmifNDCScyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEODBrX8F5SZCJ3xrLunqFMALVn4wWRI4BUuWTgfpCo=;
 b=bkCiEQZGGVGbRBIWomp8YeSaZJmCfrOwGMJ8dPfcyIwE/PfeS0osHTgVs8I0svrwhL7kWCvopj/l3VrBsaKQ8GUdEylhPm9Eff7cBoaFFavlrIpz8WV9ipurzFI8hrQuIqMt6UmpHgICxWcFKqwiJwubvOqs7MSX9zYNbMBwmD0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4197.namprd10.prod.outlook.com (2603:10b6:610:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Sat, 1 Oct
 2022 09:55:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:55:03 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>
Subject: Re: [PATCH] qla2xxx: Use transport defined speed mask for
 supported_speeds
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a66fkgwm.fsf@ca-mkp.ca.oracle.com>
References: <20220927115946.17559-1-njavali@marvell.com>
Date:   Sat, 01 Oct 2022 05:55:01 -0400
In-Reply-To: <20220927115946.17559-1-njavali@marvell.com> (Nilesh Javali's
        message of "Tue, 27 Sep 2022 04:59:46 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4197:EE_
X-MS-Office365-Filtering-Correlation-Id: a5a73445-8239-4eaf-405e-08daa393033c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WVVdhaW/o/k34HftRGXne5x60h4WnzMN6mkagcEVyc0A3sZoaCohV3IX62BIRHU0TNMcf3O6+SjYXMDmrsSnrseGnEFLS1mEjyYjmSlaUHc74h4otkrswNnfK08wk0O5RTYBhB1gQ48a1nR1w2aOnanglTv+AOCGtcdvAVUIaSRMVuWA04E10FOTlIUMHWm6XMwlsZGOU3etJVjcOKp3XhPRwDM/52FYgKrfs6+kpYWVL5zICgJA6Cr2Q9q+SC/9Lf2vQEY6SX/sJ14S+8wQhaJCojKZBw0yiNbmllp473ZRGaD7lyHAVSG1lPha4ktOV/xie3CFmyAsVOmRzf8gu9ykosL7fmAvZTt2WmMyyIXRVHhcbznpXmgOPjkPzzJqCtbaCJLMfDD682FT5L0Ui5pjeKHmVpOsAHfmi4kmlHZG4Perwr6VtbxUThF958B0LRH3q7sV6kpEh6UA+lY0Blo9AJCNLWrFZ7uyjz4HFrTQy1pXw9oXWLXCBGMT4J6+oiID1hK2qWymqTtxvASNK9rzaEp+8ISbrUlvPoKdNuCtsIG/WnoSd+f3azF4bYW9GsCUeQ0J1tFTA2xfJsflqAXvwZB/zFjsZJyCxd8/3bDuM62amRFBaLt0fZrj98Co97uqi6GI9m/Cy72tf+dCsQZzs2wzGMilQRlpH5sfg8Pb+N83rsCUbivNeV4cWrPJ8/ddrmoOcX1x62PpUFtUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199015)(6486002)(38100700002)(86362001)(316002)(4744005)(36916002)(5660300002)(186003)(6506007)(6916009)(478600001)(54906003)(6512007)(2906002)(41300700001)(26005)(8936002)(66946007)(66556008)(8676002)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ikNSXt6IkeGen1qskcztrG9JxHbX4YeFEzXSYiEzTYGnm9Ji26XdJ5LO1pjG?=
 =?us-ascii?Q?YWU7dguPmFSbKQ3AwQDbwot+dTUgXp835ya09Mta9DbDZ9c07lxnZM2dDxMs?=
 =?us-ascii?Q?e7N0U3LYMV9tcy4c++2powcGiNUXzDiTtax6RCcPCOx2qlIvcxwOx41fHVLj?=
 =?us-ascii?Q?X3kplIkr0VhGALAemlX6Detzp8A06e2VxRD0PfAvbuTPJWkN2dMKqfR5s/uN?=
 =?us-ascii?Q?KZ8Ux63JBMQMkKOYUpmxBUoLf9vh/OzvRdPUwLaW+CkHDBweoYcccFQabSwK?=
 =?us-ascii?Q?bbK0TVPzRlIY0lV2fy7f2DgbPQisetfqv2cNOENFn2rbcieefE0s5Ib+KqFi?=
 =?us-ascii?Q?YoqQXdG0xf/D0fJXNpU4iHzzyyc4JLKf+GW7ShVirBh+C2l+3Y7Ydz5CG8j3?=
 =?us-ascii?Q?EitmUUgnUGIRna8QFs5CEZgF73HBE820xWOGYvWfYOKH31lKveMxeTGHRuw8?=
 =?us-ascii?Q?ifRt43MjtsUvXGRKsoEjhFTHlAVGnDSOdoK8RbiLvK5dfLnRMK45z5Lk35gi?=
 =?us-ascii?Q?wBtXDiNEJ0R9F0c6HJWRBqwekFB9MXbms6y3nNhIHQCC0tJdEo7iBzutfkdg?=
 =?us-ascii?Q?H7Eo7jOqsZ1DzjFM5xv9v/I9eL5NRrTKJpQDuvJbIQPV/+h8I+P/9CUNGSAq?=
 =?us-ascii?Q?B186WYY/Cc1uawXLSAma1v1g5OjRtoM2BffRfEQyJ6FGIXegTBV2Zhzwb5dP?=
 =?us-ascii?Q?9UZG4xc2FrEHB5Qn6GflhN5EOT7ZshOXoKcpkvQDgzOWvLpZnqTE1yVlUAHB?=
 =?us-ascii?Q?roIEdJbv8FFtyTYHRcLarKNpnbfUj+4FLteYZzNJQRMLH3jL/zG1jTMJ3f7m?=
 =?us-ascii?Q?LSiLWafzZgIk4+UucYuXFEKUTj8XvTmkQ3xMXYIf0qWw1eiKITBvolY5tbEw?=
 =?us-ascii?Q?icHpdMDZRuJDa/YJu0NrqjcaZ+ebgRDNJwLAU3LNmc89siRKm4HihhIqYX0L?=
 =?us-ascii?Q?42sKXMM4aKlHrRPkCUE92rGSRbrQBtt19gjRQNXkzLpzSsEf9O+0WVOHhA3+?=
 =?us-ascii?Q?kMwhxEzdqWm1jBK1AbSzncSGNdgNb23ImRyZnavPMByLFwoMbrCrugHbNrfr?=
 =?us-ascii?Q?xD0mB+JtrGSDFrsJXoesRTUZ2UaVm09G1FcpVhm0a1wNaJvyGbkd6Uk6kQ3K?=
 =?us-ascii?Q?zayMCnWHntZQiaDzF/71X74jnzdgTXBgeIYimkhR3mZtuViClfBcjF+msQjP?=
 =?us-ascii?Q?9zy5fhdztIyPH5JY8ITpSg4BYN+sGzqEtLQNKtGeYqTcMdMyIofJU6F5JwN9?=
 =?us-ascii?Q?6ZnHUKZ6mXm9FGHWASs+1IvBOaYbJZRdULG3ImVN0h+VR+2+pNolo35YalYp?=
 =?us-ascii?Q?bwMXorOMMu9Gyn4liAPnFGAFnIFlDM+ISwEH/J7lZMRwPUGjkxC4URfPdi3U?=
 =?us-ascii?Q?KJXNdQHW8UB1Fetav/1UQe/3ChvbeCwga98fZkVoOx7n2b6j9NDa/Hzt+T/H?=
 =?us-ascii?Q?MNeHtjfELXbPzjB2HwMKBFU9lhoBzzXTHib1JY2OlTXiUPccSfM/70jzje1J?=
 =?us-ascii?Q?Ov/iHeXPNwptJ8CxaD/jWfPOW0mP8XnbFSt+JkSaBFjt67PYd/cwIS2+l7Q8?=
 =?us-ascii?Q?uueAQmubqkIMCVO4CHB26Fov2Np1czvFYF6AwR+4e3E8J8sJTj6xHPLrLi7U?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a73445-8239-4eaf-405e-08daa393033c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:55:03.7552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTqNoo1APxh8zXQulXWi2pSrXOpxOf8avf3N2QTntcfPUgzOYnjZe/EQT1L3a5Nxh/oPkhguHN4krEX/1ZnGfSWjYLKKqmALqirTIhf6GLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=776 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010062
X-Proofpoint-ORIG-GUID: XDK-fjvnFVnwwHRa65YJqNBK9o-hausk
X-Proofpoint-GUID: XDK-fjvnFVnwwHRa65YJqNBK9o-hausk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> One of the sysfs value reported for supported_speeds was not valid
> (20Gb/s reported instead of 64Gb/s).  Instead of driver internal speed
> mask definition, use speed mask defined in transport_fc for reporting
> host->supported_speeds.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
