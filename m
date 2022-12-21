Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0323C10F1B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 11:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiLULtI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 06:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiLULtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 06:49:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A9E1DDD4;
        Wed, 21 Dec 2022 03:49:05 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL83wcl008407;
        Wed, 21 Dec 2022 11:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=G7GzAzFPvW7E/1nb1ev7goR44mQF8XDE/1dfACEKxOc=;
 b=a4athEuS3diKeqzvEetBMTv4KdynYiNquuhgRIFkjgk+P8qzAFrzmy8FG/p2lZHsgqFt
 b3rZKVDHGUfHPh6ATCKsJtGism1HBnxhCCs+BGc+tOPQOUa5mi8DLFSWZbMKWTdPrtEv
 3t3LvWuP3WzhXcHVLjNhtApOCrauTHvYSGkL9lTXOsoBoiyW96dJVLSp6lWin4sxqVlO
 ZDTqZKOo3yiLGthfM9J18x+SqGQxOP0KcrtAxekMzAzaQdKLKt6KbCK+gcqXPSPJfXCd
 ruyrBv96C9NZVY4ptGZQw8uS2hHzuqNV6WlSrzP2EAj/5G6NcNSJfRmIYwTzKe6R1avU uQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tprtc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 11:48:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BLAb2bj008037;
        Wed, 21 Dec 2022 11:48:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47dhcmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 11:48:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nObrBL1QoXHpSqvLnnpOR5Bwr1HOU6fc4QEbZkSygY+n0MtZTdrgwwrz3vtlFSuQKABsNXt+PtawiyckhEv+qp+6FFYgM7jFMHiNEgjRPnDkLEVcNm6e2r/P5Vy8rXKAcbB5EiZ0vMjg9VE9CKXleNP3+/lVCApdqUPXxaCXnluKLgKu47lO4sXBvPEyzy7nk0BC43dvpeSgTyI8PWcTDjnrJlbxUdAGjLNGEXO6cC12W/DndYUzDM0ab4DcEbmCgsCohYqhvu3whL4KHmxcCNRp6DCXM7dxc/ZIJql2kQrYs/jXmL7KsuATrIYx3ykQk9SHKEiD4Dd151HyJSHNmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7GzAzFPvW7E/1nb1ev7goR44mQF8XDE/1dfACEKxOc=;
 b=QbKx9QatKZf39wqLyT8QskE9N76JkNa3UtSwJ4HbC26xARl1TKizWitB8FpPdkDU6F/9UOJNw+Ipmke2Pjcc7ut/n0s+ExUX14HTtr93471/FLn8Rp5NwSRtZ72JvYq3tx0XnpXJA/BCx5OHSyG1bPv2/fOAFrznRyPs6q6np61DkpH4FHLvQRtBv3EZwW8/uA1zIRH8nqMze6FhnG1+WIQp3krntBUSA5o7gc8notZ7o5uQaoEJuY0TmnhuzXf3Hj+TaNwuHKq7wzdXfOeKp12ziHKPr00Q2/FcBtP8OuMDGHewz8aP+nISgo0uLJCBKfxFJynPqRUwbANVyazWHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7GzAzFPvW7E/1nb1ev7goR44mQF8XDE/1dfACEKxOc=;
 b=sv1PW6Hhsnjo3yxtzF3pcKyV6Q12QYvFxaAEJA9gnuoQkOaCQs69MDr2geqr5j8R5nEyv8LLfmAk1yX6aFH/XHYuMwoepcB6KRuz42bJR5HDcLWW/zrICSQYIL+8UJpsfUlXRCIPeg9UrrJzWh9gHH6lzhwRr5JWdT+TI7b2kgk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7270.namprd10.prod.outlook.com (2603:10b6:8:f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 11:48:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 11:48:56 +0000
Message-ID: <9c9a6054-052d-2b21-4c10-2d24d70d55a1@oracle.com>
Date:   Wed, 21 Dec 2022 11:48:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 03/25] ata: libata: simplify qc_fill_rtf port operation
 interface
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-4-niklas.cassel@wdc.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221208105947.2399894-4-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7270:EE_
X-MS-Office365-Filtering-Correlation-Id: afeae33c-ea5e-4dda-2c89-08dae3495713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TdkvaKcNVbS612dFEY9qPv/GKd96fmsmW7C+QmQeuVzOzEAXg3IlqQ0zmxXl0H+1LBWNXxan1qBg38SQDWOZZHgRlkINSKgZhXOp1ulU4v99qrRNnfjeK7Ept99eHC+OQRRG7ewHn7eLq9CFp4h32OjOB9KDwWv2pssW3tzhtOzeO9TRNkopOY5KYNBZZwpv6d/MnhhBLCyqJkUVFjBFJ84m6AR4sC17Ap6kWzngTFmXzLvfB2EJA161osAxK1P/VzBkI+0HcFGUf9X4O3UwfMpmqcHakHHwjnh2zk6kgsZ04eYRoghks/5LGBdfDcU2SjMxoihu/ejS/zgPe3FSr1d6fUSKBUQXUMi49uV8F807Kx0e3pn3yTK0QcAGtehhgjo4282bVaasG8rmcKiQCu3UftAaysOxNIYDZp1A8RerzuH1dAuMJ5SIvtO3Yz56QKTeY4LULtHeFK1mBSaxhkrAqxnt7ngyF3lpn2LxXYDf1jUoU0SKREebAh+P7ydOAgJQv5j77wQ5Xwb69jVzKuYYXtf34H7oyaLrcpdJqx0xYfPILBCmfmAmsIxLKsQEeL7NWdd0kkj9ppMgmcksd90XFveZMG6x0Fd8oLG2wIDI23HpVdAKv4r+XpUglA5rLnjhRi6kJKh1jyZT+xDVmmsiwY7pd2vo8SIjm92xqnAWJjM/JSMYlHh7i+ZkvHfey+TNfbYY8zSnQIQbpTaUgdheArg2VmzC3n6IjLjGwXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199015)(38100700002)(2906002)(31696002)(31686004)(36756003)(41300700001)(186003)(86362001)(26005)(53546011)(66476007)(5660300002)(66946007)(4326008)(110136005)(6512007)(8676002)(83380400001)(6486002)(316002)(66556008)(2616005)(478600001)(8936002)(6666004)(4744005)(6636002)(36916002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTZaS3IvYTBSV2N0R0NLZUQySUI1QjBrMlRpQW9haHl5UVhlbTR3V0UvTGZB?=
 =?utf-8?B?Rkh2dkprQjFkVGdWYkgzSm1Qd21EQjRRYlo4cEVrVFp6TmtIMFowME9XdkRZ?=
 =?utf-8?B?Mk5HVHBSV0lSa0NvWU81cldTMzJJcWFZRDl4Vm8vS0NtUDRSblZzK0lpbEJp?=
 =?utf-8?B?RUQ3ZDYzb3BFNTZMcFpkZWdyWVhvUTdldk03aS91dVJ2WjJLQXNibm80TXV4?=
 =?utf-8?B?K2FZaUk3V0tlRU5vbGdNQzVGTnN4UkxrMVRiTjFDeEh0VXRUVXlNWS9XSEF3?=
 =?utf-8?B?ZGFkQlJUUHltYTcwTDgvRklMUDdhTWd5N0l6WDVyS25MQXVUOUZwNXRGMVFx?=
 =?utf-8?B?SFZzMmtZR3BkeWtWUVo4cWR2REJpZUNiNGhaYm5GRmo1ajdrd3l0bjRUbldk?=
 =?utf-8?B?ZjRhRWZmVWNFNjdSMnNiczIwV29rbEIrZ3RFVEJRWHpOUU4wS3lNc2xHMUNI?=
 =?utf-8?B?S1dxclE1ZFpqRjIzYXMweUVjTnJjejVhK1VCZXJnNjlZYi9FU2dtK2VoNmdG?=
 =?utf-8?B?Qm1sVXI5dCs1a0RJOEJKb0QvbmpKOTU2eHgrbEJHTmc5dlZUMU5zakNVYTNs?=
 =?utf-8?B?bnhFZWpxZGU3SUJ0c0I0bVV2bGsxZmtKcElYM0xWSkFWN0VmaVMwSzh1aUR5?=
 =?utf-8?B?ekhhR29DR0RIVWlvQ0E0NWZ2MnYwekM2a2ZhMHNxQ29ZTVd4eXpCUzVCRTdw?=
 =?utf-8?B?NmNJZ29vNkllaW5DaEp3UEZ1aURFL0FIMDJFbkhtbHg0azc3V1lkekExSytE?=
 =?utf-8?B?V2ZiRE96RUE1STNEZWFMai9QMStSYW9leFJpa1czeHNRZEtXVTdIRUFZRGdC?=
 =?utf-8?B?ektRN1Z0ZGJTM0VGMzdvTm53Q0x3bG1GWEIxcDduNlZpb0ZyTzVuTDlYTzl6?=
 =?utf-8?B?SlplUzhWSDdPSjJMUkhkUFFZQ3M1UkVVVnVVRUJnYTdlWE1FV1RaT1g3OTU5?=
 =?utf-8?B?Tld2cFJ1VG54YVdIYlpWdzBnRndLb2wxTGZnbllTWTBnNENiV0tBdWpSbGJD?=
 =?utf-8?B?TkkxcHorSXY3WWVJVWFMVzIwUFkzUlpUSVdWcTFSeVduOHZRUzlDcFMxOEYv?=
 =?utf-8?B?UGRWMHd6ZUgyaWdOWGRvYm5Qd1VlNktLam1TQU1uT3psT25NR2dPN3QvVjU3?=
 =?utf-8?B?Ly9pc1JJN2MzR1JxRkFuZ0EydEIxZVFOOFBHNTIvTmZ2WEI2RDJOaVZGSkh6?=
 =?utf-8?B?M2R4VzFZUm5LNk5xS0V3b2M1bmtYbE1nVXF1bGpJS2FlUGg2ZVdNM2wyWDdX?=
 =?utf-8?B?Q2dqTDViK0ZOMlgzRUlzUHVoZnR6bmZRRnE4K2tMWTNuZHlDSC8xY3lNbUQ5?=
 =?utf-8?B?M2tCSGZvTGZzNGFmT3E0eFZaVkpaaXJGWXI4R0xNTlJVMTloWklkUU5VRnlO?=
 =?utf-8?B?NDNFSURiRXVzMVJnWUc4aEoxLzMrY0lvTHJnVm8yRW52bmxOcTRLdG5aL1Yy?=
 =?utf-8?B?STkrbWpIdjNkTXo0RjBRMW5iR3F4cXNyN2dINU1tdFI3dnpNd1hrR1hJSUo2?=
 =?utf-8?B?ak5Mc1F4bHRkMXd3MkRPTFhXalhPM3ZGNk15VjYwaVJOMUNZa3QxdkFQRE5h?=
 =?utf-8?B?R1hNeFV3SStveTI4dVArdXA4OVZRYXhSS3FyVVNZbUFKeGYrRVdvQVJjbzFi?=
 =?utf-8?B?NXZ0bVlhYUQzZDhtUS9TRkNYRk9BZ0VBanVoUGtpL0p6K25nSXZHcHJrUlVT?=
 =?utf-8?B?dVhTclNueXFEaXBrQmNISEh3TkloNy9PaHRKclIxSkV3anBvbFFKc0MrMmxL?=
 =?utf-8?B?aktHWVVrc1FVMjVIM09IcG43YUpFeGJST1EzeWdsbTRabUtWdUxwdktObGxV?=
 =?utf-8?B?cWFpQnFlQzROaFlnWXZjblU2dWYrMVMyTHVGbmNJSU9vZVRzWlVqamhQL1ZY?=
 =?utf-8?B?ZmM3YWVKbHNDaXBLYThuMXBoTFB0bDdEZmUrLzRxdFo3citsU2VLb3NVandD?=
 =?utf-8?B?TVNKZkRFNnZmSTVtZnU0QlJCOVlkWjhZMjY4OXJuWUlvZGdPQ2NOMFdzQjBo?=
 =?utf-8?B?S0wyNUo2ME44QjVtUnllVzlGaTdPd3ZUNDFjNmN1YTAxVFJyQ01VUkcwSWpy?=
 =?utf-8?B?NVo0Mm1kUHlQdjJ0NXhRZnYyQXNuME84YVY3TW15QkZvQkNLUmxON2dtMlFh?=
 =?utf-8?Q?jAPJ1oX9uF+JlxfSAfE9qc6QN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afeae33c-ea5e-4dda-2c89-08dae3495713
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 11:48:56.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyt5XDIErzToRaBQKobCUqxjKm48pqryt5vh/Pxu/rMcyGe4OYvka8K+yAsgz0a/ZDfhUfMoGB6tsmBVRsXrPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_05,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212210097
X-Proofpoint-ORIG-GUID: cLmeTl44vnakUqaMyNq0SjApORZ6kENy
X-Proofpoint-GUID: cLmeTl44vnakUqaMyNq0SjApORZ6kENy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/12/2022 10:59, Niklas Cassel wrote:
> From: Damien Le Moal<damien.lemoal@opensource.wdc.com>
> 
> The boolean return value of the qc_fill_rtf operation is used nowhere.
> Simplify this operation interface by making it a void function. All
> drivers defining this operation are also updated.
> 
> Signed-off-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>

No 2nd sign off.

Anyway,

Reviewed-by: John Garry <john.g.garry@oracle.com>
