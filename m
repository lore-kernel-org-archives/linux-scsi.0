Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C965C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 01:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIPBs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 21:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiIPBsz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 21:48:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE207D1E6;
        Thu, 15 Sep 2022 18:48:55 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FNnFAt009627;
        Fri, 16 Sep 2022 01:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=W9r+Ifd1CAkgm+F4sjk9AB4H5gCIvZ6/xjZhnPHA6fo=;
 b=kRghXnnw1SnidRwDXgkOCltjZ2RVcLMzCfQj+fHUw4w9c2c6L0w9JRTl4hbddMuSg81i
 j63Nvl+Z0+/6tjo2PwHp1N1d/FYtWBfn1VndF2OQkdYJev9rNxxqYFE++aH08uD3XBX2
 K+ZWPE6QnHmdy3nkRbSRGi/wxtoWscjisTHdP6Cj4gVHMgQEza9rNCyvyrGpgAdC2pJo
 NPm+3agc0csSDe1oDmDKq5VEjXdjCPCJF2ELABWyZ9v20eA/OwgjQubu6ybLCJFAioob
 6ATEvh4S77xaAxs/H7NKh2ARIx/iLRTfuIR3BlDqNKzxfy5L0JcOXRSn7wQ+Kt16dPdV XA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8x8s0x8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:48:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G0M8qP004121;
        Fri, 16 Sep 2022 01:48:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8xenghb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:48:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTjiBANgmhyuToCZuiayEXG93pEO1XS38zcE+Ft+dRlrUfMBTWjXF4ONboj1EEIKzfK/C0fHTHTCKIjK5Pm1bDEPi0nItpa9iTIluvscYuDvUwelzcjNGFT9ZaMPnEbQW0FJY/WeG/zdomczHXQQ6rIrqAuw7o78FqO6PCpX2UqPnMdDxJfO/5D4KDo+mgOlzmBIK0v/Hj/+v6HpPsMBZdSCkEobC3dhl2acJT88+IQxHJIchWtxq+5CIz6B0E6lBd60ICtPm/EjkPNEYgpCASakbJmAtOIzHPP/d6HZRpaXjcDIfi2kGaYHaNS1KcA1nKlU6r8d1Pxwh49jW5bEfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9r+Ifd1CAkgm+F4sjk9AB4H5gCIvZ6/xjZhnPHA6fo=;
 b=GCNPkkx6BtP0qKh8pVn/N2NkIdsOEcaHjoiPkn4521Nwg9FTPirVbPhC9mu31bopQNJXKztyzVVH2qjSH33Fvz/Vt7X31yrI9mkqnJ7gJWeaHI5gfaTf+UFymyR+4pwP7zpIbAfmthGlEPDrVI4cSJbFtHeZpTEutZ+SvKFaxCVoMHPl/ykry39i/SUgHc7OPPJD8tpORxLnJqch04AnZu8cyHpzXqPEeZHQ5Fw8/Xfh0GZhiHHClZB8Nbs7sslmzKC9TTAsP92E6y6rcNvOG0LcXjfNEpb4T4zD7nZukjCOCOlO63xI8WUk/mqKksaWzDUvvFrJhZrS1jTmjmKhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9r+Ifd1CAkgm+F4sjk9AB4H5gCIvZ6/xjZhnPHA6fo=;
 b=qCbobspqdHrtVN8HH2H+Uom/+uz28l4f2I5fe5uLH0Je4mmQTHL6nbebxoKVeES1NO8EvlkJkON8puA9ZIXKHZEN3FgO9mq37raJXRgAMG6oWUR8BKkhdx/aYG960AGmFPnoYOPQ4SBiSTd20r25mXpVQ1W094fo/DutYRVJACA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 01:48:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 01:48:27 +0000
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <andrew.vasquez@qlogic.com>, <James.Bottomley@SteelEye.com>,
        <giridhar.malavali@qlogic.com>, <James.Bottomley@suse.de>,
        <James.Bottomley@HansenPartnership.com>, <quinn.tran@cavium.com>,
        <himanshu.madhani@cavium.com>, <bart.vanassche@sandisk.com>,
        <nab@linux-iscsi.org>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Remove unused declarations for scsi
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1illo2iov.fsf@ca-mkp.ca.oracle.com>
References: <20220913023722.547249-1-cuigaosheng1@huawei.com>
Date:   Thu, 15 Sep 2022 21:48:23 -0400
In-Reply-To: <20220913023722.547249-1-cuigaosheng1@huawei.com> (Gaosheng Cui's
        message of "Tue, 13 Sep 2022 10:37:20 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0049.namprd13.prod.outlook.com
 (2603:10b6:5:134::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 7afe5940-3f0d-4ec3-a167-08da97858c42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R1kdb/kk91L2yJmW/MfVlwVOu17FaXhlZT2G7ak5b/bXkmm8S4DrE/L+5Uz+HtkvAwJm1OxwNED2gHL7z8GNFdvv+Da0o+rBl5M3+hU12h4neuTDT4tWlMzPlsgWSd3Q/ZXMVWLBjBlo2dc2TBB6vsqvcEL2B4CQb8caGfNqrX/+aSzOOSVw1a1bcUKM3Cmiy20Ui0EyOxes/WSy0mLPpMpsu40WgoUbG1VHZkGZkTMjVd9U8NpuVc4eY1UFdvxM0RiZIq9kODGKKwGiRWX+Sx8Xg7utfE9ZPw4UKOAyjL0JtBjqEg1FLd4nVS/Y4QihY+VFo2WxLWqTohcsn4jfKzFBncL1CEErxa6qNZzzLSLzTpweuvqdWL36XYd+lPXCO8MBpHZ8tnlA33TVl0bAN5r4Xe/M1dj/MEo/MrNuralT86aly2KNS/YCTjwuK5A/JPCFp8fIRkYpl0JgQFZ1zcZLrRp43uEato2ZeLOAa2blGAQxVUvy2Z28MKtg58KXhwQ1y2llsFDEJ5x0uPZMDpvYmtq0ZgoV99swwMOVG3anSc4hFuekvPbpJ9zaQRIFqr0gW+ALCz8xOuegxIpydBCYtGixINXz/aoqp1EXR9hiwC4AIZ6OY6W1asAFTLm+4RH/Y3gpP93x0uuRkVF3jV5BmslpfbRjuNafdEdEg3/VVAhQGHbLvpCz37z0ecPolGT9fNfsiz24wM+EbxBHgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(6916009)(36916002)(26005)(86362001)(38100700002)(66476007)(2906002)(6666004)(66946007)(66556008)(478600001)(4326008)(41300700001)(5660300002)(316002)(558084003)(54906003)(186003)(6486002)(6506007)(6512007)(8676002)(7416002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kSMaCJrvNlWyhL/k4rf8wsTBAMJU0FadfaJFlGksuu/y2ZwZ0VwiWQP5XGrC?=
 =?us-ascii?Q?fRkTkUp7l5sHyZngvWwU3qa8g/UfNy5BVuEUml8LSWOwHwb5mo8Qnw8FZJxi?=
 =?us-ascii?Q?U3TH4NkYElGHEuV4T4MzaOFz44tRlmUXOV5kg8syOnSeziKMhAe8xnmIrDen?=
 =?us-ascii?Q?tmLWYicVWXTBSWd3FjUTGxyKnXxnYzoM81VVayQnKqSVX4LIgqooJCVXTceg?=
 =?us-ascii?Q?qcSVPTAp80GsH4tr+JhZaFhJX6FUc//nvS4CiWvE0XyAz4f0yYl5m1rL5AAZ?=
 =?us-ascii?Q?v0IQ7ZQAmX4mHCC+sgrb5Mdy5egZbpXQOEHPsKSpovVp63vnO50xSojaxb79?=
 =?us-ascii?Q?RY600VluDPK2Ue26srnsQljYKVfKBtDxIzZSkEij0pUlbNYmH1k+lG+6Uyx4?=
 =?us-ascii?Q?wHPA736lkVI5jhj7GMX0yr2ev6RzuqZ9/icZVm+XfID7LxLKtnHHwXGDUXui?=
 =?us-ascii?Q?lxlvPccZsSllHwKi5TbCpT7nyrlphcbhQbwBVlKnDyM2STxZJpZCPDHopAlH?=
 =?us-ascii?Q?3AoXFv7EC5FqiNWyuFu0HfrpB8hbvG/7Kh6AR2+d1dfHjk5M+bNrhQPBz8rR?=
 =?us-ascii?Q?A4+bafu7sk+ayx72548MlqJC906jAHBHh9hU44ozKkk3XL3i7xFCBTvYgv+H?=
 =?us-ascii?Q?beWefwGmpo0l5l/RIOihT2Kf2A+RPK1igP7gnZHob6C4GdazCYENFSiU0rnu?=
 =?us-ascii?Q?qgZsMqniHXfSpRltUlE0FiHhl4JnsGUaQdXBXeRj/8Ydi2hJFLh5LFh60cnW?=
 =?us-ascii?Q?Pf2sC+Cx9/u6Rhws3guApA5p/uPH26ZTTVlxMVXYmRk0c2GY+RvxKcUPChYb?=
 =?us-ascii?Q?3AxRpUOEHF1d/OVG1xoFvBgtakv7ZAq4+MDZf1K+NEIMglfrsI0r2laJP9qL?=
 =?us-ascii?Q?r7J3fR4yEMEZtgBH7/j8YxhPqZChps3ts1lwUU7ecA4ySkZV7V0C5L2/+ZDA?=
 =?us-ascii?Q?c1rw2xRj3pE/0Wv0lZKeg7aqXF4rZTyimDRyQeTUxs7ZVkRTxQ3vBC0dGUpr?=
 =?us-ascii?Q?vdZUXdurLpA77PiLkRu32uTqn8Y78nwCwj/YefXiFrRbPcwqGWckeimqY4yI?=
 =?us-ascii?Q?zbA+YIxuSbMEtE/8qDS9QQ/rq0FrNKKbiyf8gvwaw/zkaRI+eGci7z1DPMNo?=
 =?us-ascii?Q?ZIRQr+tlsiDCckjsBGY3z/jbyscXj/8nI/dXK0SAQa3IzaAv4VoiMWKCQ99C?=
 =?us-ascii?Q?vNAF1P8zvv6WPc4yCJinEyVXN93ke7lHQOzNRVfKuQqbDNe4SBhGWiAVrxs/?=
 =?us-ascii?Q?qJiJtgBDnJsaBZzubpgv0+FSTm6kJIzRsRRD2khwPDbGrohYXq+8J7kyZPuE?=
 =?us-ascii?Q?Jzpsg6GvU6ML+qp/Z6HULIvba7uKVzP42Owv9NlaNcOEA+Kf4GhCsNzmv4Na?=
 =?us-ascii?Q?3qashaW3OLLpkxu3IKZUz3GHHKHtHZHM8dAByZYpck8xsnT86ttf/2IAS0wl?=
 =?us-ascii?Q?74Rvqi/rdidMf9QNVSkiHxf30swVL4r16vlpjFR3VM1I3Jajeo9q/Sbk8TkM?=
 =?us-ascii?Q?Ics78ddFGw7hWIwimxFqlB9yUlaB8CzDOGOOTTrZhgF9XW72FrOqZECii62t?=
 =?us-ascii?Q?ft3PQbHfAYunzESXt/AXtur535xKGgWmoR1bqPEizIYtWQpetOEs2/gio2rz?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afe5940-3f0d-4ec3-a167-08da97858c42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 01:48:27.3479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hI21Ur+DzYPWYrkRmrWMoJ3wUl7qUWLY4O2QbK4MoSDr/+rKPWYXcDHDWvxgXgghM3NPtR5B25Z8Pfic1pRhX+3KOG/hOivjrFxpMmtyhz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=767 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209160011
X-Proofpoint-GUID: ylQu-i4d9-uFJYWxtYvHbVsT6hH47j4k
X-Proofpoint-ORIG-GUID: ylQu-i4d9-uFJYWxtYvHbVsT6hH47j4k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gaosheng,

> This series contains a few cleanup patches, to remove unused
> declarations which have been removed. Thanks!

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
