Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B965C001DB
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 21:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjHDVpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 17:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjHDVpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 17:45:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EB3F0
        for <linux-scsi@vger.kernel.org>; Fri,  4 Aug 2023 14:45:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 374JCeGn003736;
        Fri, 4 Aug 2023 21:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dJvLJUkNqlJSSykUcIvrZgbdm6YLcY0mK/ghN5k8/kw=;
 b=ZaGsFYONw5ViCYNo2M37SMdhkGB6av6hr3FFFpOplcQTZ9BudI7B8T0fNTaGQhQdw8Xg
 6xAN9r6JUz2ICunVlH2ydRr+fzcQ9Bc42hkN99vb1gx27AuBw5XytEx+Zg3Zoj97sT8W
 ddcvvCD5Npet5a/yolrG2E3j28o0bWadrTmoz9ZCpjsmBCaAevoY8mcCTDSoKxZvEHaj
 9qIkLyeqMAczFT7BQDIM3F8IZnt0UGJPIBHWOLknNtAdXOMEJKOhQw5ivZ+98CHCY1+b
 YvVHJ/Txx30tFuGKuFPXU6gr2Pw7yN06KSJlie4olKEr6KRQl9I4wKuHbPv+JJBmP8jB Iw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4sc2ms23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Aug 2023 21:45:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 374LC6Ud029301;
        Fri, 4 Aug 2023 21:45:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s8m29qp06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Aug 2023 21:45:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S13+WxXtzmnDTylW3JU+rAGsY/NXjsrkD1Ac3ofq7DCd30K8ZSkFh0dNz2KgPm9NkpRvp1TUHGPvMPhkrkvR3bREwdeaiG7cj44Q6RJeoypqpqLpcPv780TDSGduVKR6yWFK9Ax1E0w1IqmXqcJ/LSYEp20miZou6sHRzgXPNysjAvrbao234/M3+PT2MpsQ2C7mBnR7zpJOMbdi0ZePEciSzv+1snE9dNncs1PjptsZoqVnMiUHVfRjbX/5uQUhtAD+/qO3Rx1ZvIr+2gu9yzRT1wfdcUhz6Ws4xzjaJHzCqIy+yH2dL8rdaJwqY+NgafONLgoIC+BXN1iCKBEzoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJvLJUkNqlJSSykUcIvrZgbdm6YLcY0mK/ghN5k8/kw=;
 b=N7JsvvXcABj7PZhh0tRwsBfGc7Ble7j8jvysYktpes8Zgg8CBvwrvhl6mRAgQzUhp8gsnPiO8D7XeCexbS8qMLKXZXwj+3t9r6PBwtumXgNcVm+nJM7NCqs81wqIgbVAholyiidwqjmSliWS3xNVysqGFmjaY3bfy8X/hfkYt/+Qv3COolFFcCziVB+msi4fDU9CzL3eRIpwKAgug/8IrDiZ0RSklUUPAjFbCkaiuh33J6Kt6djyhvNBeYmezg9d8Y3Lb8aacVcS5ULD4PdDR3qRSbPWJiOJeg7jf2vN40fIpclJE/58DFfVeS6AeSLLNeVHnnaMt1asr5qUkaVShw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJvLJUkNqlJSSykUcIvrZgbdm6YLcY0mK/ghN5k8/kw=;
 b=FZXwMySzHrYMYCH1cwI9hnuY9xTpw87FtmqnoVmWQ91MaZohO0eR79XnGHFwq+yHPPUhMZuYLpKCQXBc//tnCNNceiFuLxjFG8Rv4gtKDNSVPK3g+PMb+CvDy48RUSyxv+ZZtibiLLSTz5nLJhiXDZkKO9ZsZu2tJigBSI8fcJ4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB5375.namprd10.prod.outlook.com (2603:10b6:5:3ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 21:45:01 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5b75:8ae2:9b48:93d5]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5b75:8ae2:9b48:93d5%6]) with mapi id 15.20.6652.020; Fri, 4 Aug 2023
 21:45:01 +0000
Message-ID: <07be03f3-aec0-a4a6-f5e4-3714a5707ee6@oracle.com>
Date:   Fri, 4 Aug 2023 14:44:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] qla2xxx: Move resource to allow code reuse
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, loberman@redhat.com
References: <20230804071944.27214-1-njavali@marvell.com>
 <20230804071944.27214-2-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230804071944.27214-2-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0120.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::7) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|DS7PR10MB5375:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d8262ff-2334-40ba-9127-08db95340e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8yckCtgbyQgI/znMgHhNclboIw6fSqNgHTm+oUVO9163p8wzXxqV8Jozg47bHasMZwsdhEXe1vOaktxZoVXKyEGvDlF+Yz8DQ4wgN1ocwkIGfeqodul4rslwxePW17Ux2dDup9+lVtYlx8fljK7OzgRk7fWO4CT1NeK66CGVAGwW9Jdotbi6h95AA9oH28LCbS8s07dhsWbgRHUmnktj0PST7KcJt2aOx6N1ZRPy6vSWqb7fCj94Eb3lmNpzIhcNkMzm47PAZLp2akaXXC2ObnmhqzVdllbIj030o3KtcXlMhfk66XH7RODBgKRePu6a12iUXAVPxojnXm+z3t1t9wH7m2SokQtRgpBEORwPSTZMvaMaodYAkJcePhXvZRAgVfaLliu8/rwaawjJ3YteapA+mCOZJ0wcIIRJLm95cNx0qhUNR/780gB2ykhvzDf2Uhj5jpSMrDqbyWpL0zQtXZc2pKwXeL2NWXA5usT8RrbvS7hNgG9QNFvfun/e/Tokm2sfbUvQlrKoCk4dxqG6UgZ0JhrDQvdAtITKPgmhb7QiniCGiSejXn1fs9v/CmzgE5JCsEwfMf5e99MV+b2V1BvtJ0p5DW4c9uA7c5LUGPJyWF2h43ByWPceE5tGipp1ht0iVYYs6fP9k13t1mumDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(366004)(39860400002)(136003)(186006)(451199021)(1800799003)(5660300002)(44832011)(4326008)(6636002)(66946007)(2906002)(66476007)(66556008)(316002)(8676002)(8936002)(31686004)(41300700001)(478600001)(31696002)(86362001)(6666004)(6486002)(36916002)(6512007)(38100700002)(6506007)(2616005)(36756003)(53546011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3JmM0w1QkRWOXR0cHEreExSN2g0NHZNeFRocFJMeXRFQlA0aC9SK2dmUUc5?=
 =?utf-8?B?R2pWdHVKZmVMWjdhczdrT0tlWjh6MXRHTThuWnZHT2VkUExkaE43KzN0aGtz?=
 =?utf-8?B?TkduaEM0WDFiOXRndW5QZzlldTRpckV6Z0FnQnE4WmtyOFNrU2Q0MndyZEdo?=
 =?utf-8?B?bDVyd2VHUGVaNGJ4U1l3a1RQUWlNS29nUkFJTzlpT09VRHRMT1AzbkFkTTVn?=
 =?utf-8?B?dEpmTVZNTlp6UU94czN1bzU5OVhqeUMrb2ZvQ1dVUzVHaWNjc3ZaTzkydTlq?=
 =?utf-8?B?NEJWZTJKT1B3ZUtQcnlHYmNtNm5qVjJmRFUwZHhldWE3SlJtaEpWS3VNRlNU?=
 =?utf-8?B?ZTNxK0tXRCtnWmFFZVdFbVRWTzRJR0daL3RoUm10YWFmcGh4Y1R5TjRBZTY1?=
 =?utf-8?B?ODFIUDdBc1VUZmxwUW9wWXhYSjE1MjJCWFVWYVVueFRobHhaWUN3NGkwMERL?=
 =?utf-8?B?Y04zbE15bnFkTU1pU2MrUElaVllzVzNnMTJ4aTdVZm1BcEpGakt2V0JadE5F?=
 =?utf-8?B?UWNTcnF1NU1wb0NOekVuMmttdS9ZMzhxOWZwKzRNcHkwQXRuYnRtREtjcG5Y?=
 =?utf-8?B?ZWRMTHQ2YmlyeEZHbjdxUjVlRm41RXlJeUllaUVWbFRRWmg3dHZrYnc3STJD?=
 =?utf-8?B?Y3NudVVYN1FOOU0ydkhnNkF6T2p6YmVpVWNuUWZ0M2hFckVIWWNUcWpvNGRn?=
 =?utf-8?B?c3hBM3dpRTVaOXpOUURJbStOVnVTN1dlZEFyUlNLMW12VjFRQ3ZLeWJDZGl1?=
 =?utf-8?B?aGpwenErNUxrcDFUakV4NVo3NEswRk1iZUxKYVZCNTZ1TlpEL3ZwMjZXdmti?=
 =?utf-8?B?MTVvR2VRUWhaZ0hTb3hMWDRtd2xROUROL0lIa3NZbThVMXlNT3VuaVgyd1JD?=
 =?utf-8?B?QlFGMENiWFNWbVpaczE2SVMrWVhmN0YyR3A4a1lrTW54V0VHOXZXZnpiaFZp?=
 =?utf-8?B?WldyR3R0SnAzNnpDdHVkeXhkaHE4OUJGQXRYNUxEMzNNRFJRVUo5NE96OWN1?=
 =?utf-8?B?WGJ2Z2xNYjdSVjIrLy96Zjl3OElTdXo5ZEIzNjYzQkp4V0VkNkk5Ukh1MWVn?=
 =?utf-8?B?TEdNSXlFckJka255S1loWC9hdEVHVjJNNlRzcTVDay8vMTIxZ3FqUzJYeE96?=
 =?utf-8?B?NXFQd2R6RVFZTk1yY1BrYUlHVVByL0Vja1JkWk9WSkxlejhMUWt1VEpja1dv?=
 =?utf-8?B?aDd4bDRYV0NNdVZIb0h2a1huS1ZRc1VRRUI3OTFDT1crSmYzZk1QdElxSkxQ?=
 =?utf-8?B?emJvMlRSZGVnaVFZdUpKRksvYWs2aTlvck9tMEQzWm4wdHVJU05oYmNFQllm?=
 =?utf-8?B?aEVCOWg5R21kOXlkbkRGRVhodFNBdzZrUGZvNWxjaDdOYW5taUpnYlZCSHgv?=
 =?utf-8?B?WUlSKzUyVVNIM0x6bjFHeU9La0EwSzhvc2ZqeUN0NUpmOEVkbUJUeGhHVnNE?=
 =?utf-8?B?NXF0Vms0MGRkc2FnVHVlL2xLN2QrUVhlM0gwSWFtYTE3MC9rcjc2UWQ2R0Q1?=
 =?utf-8?B?Q1AvMGxPUmNUSXZ3WVdVRi9LUy9PYXJrZmZjdlp3MUM4NGpPWnhiMHhkRUhW?=
 =?utf-8?B?cnVUTEl1SVFUNm9SRkxzRUVpbENneVFjSkpiT3JkUUJTQmF3TTRtS2ZtYUQ5?=
 =?utf-8?B?WkFEZXlYdVg1cTI3V2NaOVBhVFNOcWV3N0RCdDNlNjFSNWgwcmpwYmxyQU5a?=
 =?utf-8?B?QXA4MFBONFFISWpmNm9QMmM0VHplZTR2U1hBRGJHNXd6YmNqUG95cW9Od2xi?=
 =?utf-8?B?SERlSzE5T3kvcjBoUUF1WjBHUXd6bVBJaXdmd1VlY1FqTm5ERkV1SmN0ZWZK?=
 =?utf-8?B?K1cxRmRQU2R3YUhXY2VDV091WnRFVDJzK3Vua2dueHdsNEMwbEpMMjFUdFRP?=
 =?utf-8?B?NFJmS0czdWRpNXRUdjZEY0dScDl1b3ErK2pNaFkzbGoxWnhsWGNOVmd1V2lr?=
 =?utf-8?B?cmFUN2o2TXd3T0ErZ2pZditQa1o5OVBKMEJGTTNGUm9ObHFKRC9XTzBpVlJC?=
 =?utf-8?B?R1E3bXFzTVdlNTNYWFZ1NE0zam5pVDU0VHEzbTFsTzBqQytkUTlLRURhTTFj?=
 =?utf-8?B?bWk2VWhRdzV1NW95aTJ3dFFvaG5oWU9iakNDUVhGaDVMRElkb1A4SHZzN1RO?=
 =?utf-8?B?QS9ISWRGSmNaZjR1WVB4QmxQYloveUFqcEhEaXFIdlV5cC9DT2hsc0F5emla?=
 =?utf-8?Q?FOkdakQyP6MhS5QIF8poJ+A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Xi3+/OsjcxZhC5A1O604um3w97cDC6ILWYjBXhfqiyiI+y/Znc9G2YOazwa5Ri01P+gY7MlYMy0/CwGuwp//MNzUxoI8z1BzIrAR4cHce6xWhBMFQgxydCYIFyJGYH1RItNcQWwkc/HL6zJbfFMII68wJrYQq0EwUlE0p0QSSmurU7hxwaDEzDbipxgWoi+YxIVRPxR3QjuVlJNU2s1Tz45sQKEOtkhXoGNf/8jIcEZ8/OBgQWDk0XsM5idXxY0WmKz2/RZiLiZcY8qOtEi87Vmmz6qUlby+OVAA9au5TmGPbudWr/O4oCq81Uk7W0Jufe4PjYBYqepab+NlKtNY+xbD5qNQoFRzFS6ESdr4rxGa0hEQcQl7CkgVxGmVV6ICFlhYa9JqVNASp1jHPBBhojkZTMj2ZHoNBlpU6GPl51ijBNrVxRDA3cWxMCgxFNASkRzHkVl0zD/aYqDjiPzKRun4LpbKkJjWADHDvlR8JTze0UdTq+dthiYQeq1n4bqh7zuAIr3nfbiBuEWuHiJxyA0uzfq3WAsmHbNCJv/e5E3hWfwO5S7uLzp4Gfm6gVE3VaitBItb/QMRGxBNoor4XUya0xf0NGQAU6UYpT64kS5hqOGvx/6IoCfEBwd7Tq+IHzcaag2aHsmXRxuREqkVQfCfkawMA5l0P81OChAeADSdhyiZTzO54muTHmyQjPCjdxNoBHOvX/8LXeewuRb4IqJzZMxVcS/Z5RXNCaacDGoc2HYX+VOyk0eQTdZswXOnLBNFwW7hHLJISfpQCmRfJibjgvMG4BtC4Jk3r5gN4r0x0dOy5u990++rza1Z1bOa
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8262ff-2334-40ba-9127-08db95340e3d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 21:45:01.5192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JtGlpdlJ9qtdCbqkTcNmp1r6NiUfzhilaykQ1f6r9SD3yVCJd6OcSqmlo6Bh/1qNgraVIMn413fRFMwr9F9V9d5wMQ2TyZWZwVRKI+ywYMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-04_21,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308040191
X-Proofpoint-ORIG-GUID: xZmyypAB0U2nFu3o0I2NYUiMbmf6RhTa
X-Proofpoint-GUID: xZmyypAB0U2nFu3o0I2NYUiMbmf6RhTa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/4/23 00:19, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> dsd_list contain a list of dsd buffer resource allocated
> during traffic time. It resides in the qla_hw_data location
> where some of the code is not re-useable.
> 
> Move this list to qpair to allow reuse by either single queue
> or multi queue adapter / code.
> 
> Cc: stable@vger.kernel.org
> Cc: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  | 11 +++++-----
>   drivers/scsi/qla2xxx/qla_init.c | 14 +++++++++++++
>   drivers/scsi/qla2xxx/qla_iocb.c | 20 +++++++++---------
>   drivers/scsi/qla2xxx/qla_os.c   | 36 ++++++++++++++++-----------------
>   4 files changed, 47 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index b5ec15bbce99..9ec39bcd41b5 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3825,6 +3825,12 @@ struct qla_qpair {
>   
>   	uint16_t id;			/* qp number used with FW */
>   	uint16_t vp_idx;		/* vport ID */
> +
> +	uint16_t dsd_inuse;
> +	uint16_t dsd_avail;
> +	struct list_head dsd_list;
> +#define NUM_DSD_CHAIN 4096
> +
>   	mempool_t *srb_mempool;
>   
>   	struct pci_dev  *pdev;
> @@ -4752,11 +4758,6 @@ struct qla_hw_data {
>   	struct fw_blob	*hablob;
>   	struct qla82xx_legacy_intr_set nx_legacy_intr;
>   
> -	uint16_t	gbl_dsd_inuse;
> -	uint16_t	gbl_dsd_avail;
> -	struct list_head gbl_dsd_list;
> -#define NUM_DSD_CHAIN 4096
> -
>   	uint8_t fw_type;
>   	uint32_t file_prd_off;	/* File firmware product offset */
>   
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index d4df07aaa0ab..82077edfda1f 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -9655,6 +9655,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
>   		qpair->vp_idx = vp_idx;
>   		qpair->fw_started = ha->flags.fw_started;
>   		INIT_LIST_HEAD(&qpair->hints_list);
> +		INIT_LIST_HEAD(&qpair->dsd_list);
>   		qpair->chip_reset = ha->base_qpair->chip_reset;
>   		qpair->enable_class_2 = ha->base_qpair->enable_class_2;
>   		qpair->enable_explicit_conf =
> @@ -9783,6 +9784,19 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
>   	if (ret != QLA_SUCCESS)
>   		goto fail;
>   
> +	if (!list_empty(&qpair->dsd_list)) {
> +		struct dsd_dma *dsd_ptr, *tdsd_ptr;
> +
> +		/* clean up allocated prev pool */
> +		list_for_each_entry_safe(dsd_ptr, tdsd_ptr,
> +					 &qpair->dsd_list, list) {
> +			dma_pool_free(ha->dl_dma_pool, dsd_ptr->dsd_addr,
> +				      dsd_ptr->dsd_list_dma);
> +			list_del(&dsd_ptr->list);
> +			kfree(dsd_ptr);
> +		}
> +	}
> +
>   	mutex_lock(&ha->mq_lock);
>   	ha->queue_pair_map[qpair->id] = NULL;
>   	clear_bit(qpair->id, ha->qpair_qid_map);
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 42b9206046af..0caa64a7df26 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -636,14 +636,13 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
>   		tot_dsds -= avail_dsds;
>   		dsd_list_len = (avail_dsds + 1) * QLA_DSD_SIZE;
>   
> -		dsd_ptr = list_first_entry(&ha->gbl_dsd_list,
> -		    struct dsd_dma, list);
> +		dsd_ptr = list_first_entry(&qpair->dsd_list, struct dsd_dma, list);
>   		next_dsd = dsd_ptr->dsd_addr;
>   		list_del(&dsd_ptr->list);
> -		ha->gbl_dsd_avail--;
> +		qpair->dsd_avail--;
>   		list_add_tail(&dsd_ptr->list, &ctx->dsd_list);
>   		ctx->dsd_use_cnt++;
> -		ha->gbl_dsd_inuse++;
> +		qpair->dsd_inuse++;
>   
>   		if (first_iocb) {
>   			first_iocb = 0;
> @@ -3367,6 +3366,7 @@ qla82xx_start_scsi(srb_t *sp)
>   	struct qla_hw_data *ha = vha->hw;
>   	struct req_que *req = NULL;
>   	struct rsp_que *rsp = NULL;
> +	struct qla_qpair *qpair = sp->qpair;
>   
>   	/* Setup device pointers. */
>   	reg = &ha->iobase->isp82;
> @@ -3415,18 +3415,18 @@ qla82xx_start_scsi(srb_t *sp)
>   		uint16_t i;
>   
>   		more_dsd_lists = qla24xx_calc_dsd_lists(tot_dsds);
> -		if ((more_dsd_lists + ha->gbl_dsd_inuse) >= NUM_DSD_CHAIN) {
> +		if ((more_dsd_lists + qpair->dsd_inuse) >= NUM_DSD_CHAIN) {
>   			ql_dbg(ql_dbg_io, vha, 0x300d,
>   			    "Num of DSD list %d is than %d for cmd=%p.\n",
> -			    more_dsd_lists + ha->gbl_dsd_inuse, NUM_DSD_CHAIN,
> +			    more_dsd_lists + qpair->dsd_inuse, NUM_DSD_CHAIN,
>   			    cmd);
>   			goto queuing_error;
>   		}
>   
> -		if (more_dsd_lists <= ha->gbl_dsd_avail)
> +		if (more_dsd_lists <= qpair->dsd_avail)
>   			goto sufficient_dsds;
>   		else
> -			more_dsd_lists -= ha->gbl_dsd_avail;
> +			more_dsd_lists -= qpair->dsd_avail;
>   
>   		for (i = 0; i < more_dsd_lists; i++) {
>   			dsd_ptr = kzalloc(sizeof(struct dsd_dma), GFP_ATOMIC);
> @@ -3446,8 +3446,8 @@ qla82xx_start_scsi(srb_t *sp)
>   				    "for cmd=%p.\n", cmd);
>   				goto queuing_error;
>   			}
> -			list_add_tail(&dsd_ptr->list, &ha->gbl_dsd_list);
> -			ha->gbl_dsd_avail++;
> +			list_add_tail(&dsd_ptr->list, &qpair->dsd_list);
> +			qpair->dsd_avail++;
>   		}
>   
>   sufficient_dsds:
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index b9f9d1bb2634..50db08265c51 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -433,6 +433,7 @@ static void qla_init_base_qpair(struct scsi_qla_host *vha, struct req_que *req,
>   	ha->base_qpair->msix = &ha->msix_entries[QLA_MSIX_RSP_Q];
>   	ha->base_qpair->srb_mempool = ha->srb_mempool;
>   	INIT_LIST_HEAD(&ha->base_qpair->hints_list);
> +	INIT_LIST_HEAD(&ha->base_qpair->dsd_list);
>   	ha->base_qpair->enable_class_2 = ql2xenableclass2;
>   	/* init qpair to this cpu. Will adjust at run time. */
>   	qla_cpu_update(rsp->qpair, raw_smp_processor_id());
> @@ -751,9 +752,9 @@ void qla2x00_sp_free_dma(srb_t *sp)
>   
>   		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
>   		    ctx1->fcp_cmnd_dma);
> -		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
> -		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
> -		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
> +		list_splice(&ctx1->dsd_list, &sp->qpair->dsd_list);
> +		sp->qpair->dsd_inuse -= ctx1->dsd_use_cnt;
> +		sp->qpair->dsd_avail += ctx1->dsd_use_cnt;
>   	}
>   
>   	if (sp->flags & SRB_GOT_BUF)
> @@ -837,9 +838,9 @@ void qla2xxx_qpair_sp_free_dma(srb_t *sp)
>   
>   		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
>   		    ctx1->fcp_cmnd_dma);
> -		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
> -		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
> -		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
> +		list_splice(&ctx1->dsd_list, &sp->qpair->dsd_list);
> +		sp->qpair->dsd_inuse -= ctx1->dsd_use_cnt;
> +		sp->qpair->dsd_avail += ctx1->dsd_use_cnt;
>   		sp->flags &= ~SRB_FCP_CMND_DMA_VALID;
>   	}
>   
> @@ -4407,7 +4408,6 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
>   			   "sf_init_cb=%p.\n", ha->sf_init_cb);
>   	}
>   
> -	INIT_LIST_HEAD(&ha->gbl_dsd_list);
>   
>   	/* Get consistent memory allocated for Async Port-Database. */
>   	if (!IS_FWI2_CAPABLE(ha)) {
> @@ -4953,18 +4953,16 @@ qla2x00_mem_free(struct qla_hw_data *ha)
>   	ha->gid_list = NULL;
>   	ha->gid_list_dma = 0;
>   
> -	if (IS_QLA82XX(ha)) {
> -		if (!list_empty(&ha->gbl_dsd_list)) {
> -			struct dsd_dma *dsd_ptr, *tdsd_ptr;
> -
> -			/* clean up allocated prev pool */
> -			list_for_each_entry_safe(dsd_ptr,
> -				tdsd_ptr, &ha->gbl_dsd_list, list) {
> -				dma_pool_free(ha->dl_dma_pool,
> -				dsd_ptr->dsd_addr, dsd_ptr->dsd_list_dma);
> -				list_del(&dsd_ptr->list);
> -				kfree(dsd_ptr);
> -			}
> +	if (!list_empty(&ha->base_qpair->dsd_list)) {
> +		struct dsd_dma *dsd_ptr, *tdsd_ptr;
> +
> +		/* clean up allocated prev pool */
> +		list_for_each_entry_safe(dsd_ptr, tdsd_ptr,
> +					 &ha->base_qpair->dsd_list, list) {
> +			dma_pool_free(ha->dl_dma_pool, dsd_ptr->dsd_addr,
> +				      dsd_ptr->dsd_list_dma);
> +			list_del(&dsd_ptr->list);
> +			kfree(dsd_ptr);
>   		}
>   	}
>   

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

