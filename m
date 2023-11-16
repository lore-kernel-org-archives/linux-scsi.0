Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB95C197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 12:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345142AbjKPMNr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 07:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345138AbjKPMNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 07:13:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FF79C
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 04:13:43 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGAsCxj025952;
        Thu, 16 Nov 2023 12:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=VpWW/ReTyPTNXZgU57ZBRMQoAerLqvbMfVq+MbGJpfw=;
 b=iKLfo7zPKh97Wn5aSRqnrSDpbTh0cTBRoeyPu3IuIfnkU2Q1YRBO+6RcXgOtTJ9MO4gL
 X+zsmLGBY0OFiR3J5z978r7V/atVaKJ9yPPd5OkYvql7qBZIy5+XLyJLNHJNhlV3bJDu
 JQKW3VhA+OFvZ/G2vlsQTSqh8OspSyoNHsJUvwbUDti3RzP165PpsKipJuGwWjrxItKp
 doFNbm5/W5bQkGjkWqeEI7PanfIMNFEOjGG6k6PBTjbM8R20EGpHfqD/lXmGdhbDayKG
 ou8TAIJ3jwmqb6FGpqTCSr0RU7tV38nzb/lAWlo1ypl+H0uGvY1l0vLnz39txJSzvxoS dw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qjtwj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 12:13:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGBoN2o031556;
        Thu, 16 Nov 2023 12:13:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh4ry96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 12:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IR9LbqbBI0WhHSuL5SwA4V6gUuYtrWreinRWz0TDMRDvnxebWGh4A971ia07YkZ+xR+kb0TPlJquMECYYD2Js5rX/7n9uPkJqrlLEXEA+eyTmuyBTB4hfPEcOASgpKsoW57BtOQbxYwb66H43vcR6RALfGOY1TNKu5tr0kotsby94tZD4oDXA+4qGq7B+Abml6XHLrPR8UHFhn3+aLF7ewyrVmuhg0ExFgsTDGnfA/1fDZ/XEtaSzc44xuWvakUKDn+2YQrvISoDdN7ER0Uxf6hUVF+rLh2AHMZH14+pbtpVxtuk13HxRBjlAPIaCA5a9f+V7qrowrVNPxE5CjNrYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VpWW/ReTyPTNXZgU57ZBRMQoAerLqvbMfVq+MbGJpfw=;
 b=iSjc63bxLwL3i7+ZYpp9PLL8Hiohv6b5W2Zd9fY0u2yDpU/NL8pGMSr82KhB7Ct1LxGvtf4ZZe6Gc5Qpv1toya6u3L4yO3YLmp0viLWMyOKFI2ZdAK7GSIFJM3lvBYt9juuc4NDv0G2TKI2dUBqbZ0em3XI/xA+Ynh0bPK7DajUp1T8D6mcv2DRvQzfNri39rDbnJiZxcWyf81MmNL9ggOinOVdSvDZuHSliqsrc0Hjt6ppUj4QhtLZtpif7QCJUFsYqPsSfT2zA6Q+YDdkx/iK9mmzWPPYc+Yu0qgc7lLash7jFHCRbKxMuwwGM4jr53t9KlQyhN76X23awjlVzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpWW/ReTyPTNXZgU57ZBRMQoAerLqvbMfVq+MbGJpfw=;
 b=D/R0EFUzyfXcaRqnP9do4UJe8Chj0ArtKObkLcvkEItGHwhHiqK1oEuMx/RR6LJuu0S5Up2CeCYzeggch4iW4AlEbd4+rQL1GCQaUBaFXob0t9pQZsbSsTpUc8TzdLwur3OmMW52Jgise3Na5LB/74RhfkLKJNkLGK2U2WYQJKk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Thu, 16 Nov
 2023 12:13:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187%4]) with mapi id 15.20.7002.021; Thu, 16 Nov 2023
 12:13:15 +0000
Message-ID: <063ff49f-82ef-4ca8-a384-3a7815d2273e@oracle.com>
Date:   Thu, 16 Nov 2023 12:13:12 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/20] scsi: Have scsi-ml retry sd_spinup_disk errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-7-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231114013750.76609-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0075.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 57dc364e-b4d7-4e9a-fb31-08dbe69d6973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9jKO+/NWSrJTiHyWzdY3yxy5aVPU6lhOF0OLS/5B976YAXtRi1c912KMoDBWpGwXqWQNVNK0CuyFbaeQPVdN66I4MmAOdQ/ZRf6kMN5QtBp78Hhw1ZZt4UNa6t9RDeJiZ5zBLDeRvWbQc64besq7eWKdHBfhdsnEnR1D+APyRRe896qDhFZJQ6tDC4JD+XBUQxaZhJp5/oZOLGuBT7RFNIoy8/EOh7JBDyx04eHoFrK+z8wc1T8raY1GUOCeD/sod9us4ZePVUF2BglFtYpFAPn2LeOIwWGTiBa0VMGl5eRkGRB4CPBSH3MnsCEYfZN3iMs6Vba2AW6QRfA4trKgUd0pYkKF5QZZHjh/Od7rICE1abdXIjFwSXx5gt2VL+0Hax0SEMZPJUbLRf/zle75eEVp71N314Bbmywt7yS+g/iaUZiTa42g+nKQu6hDL9MVHeyx5hltFgrvpKQMaJ5Q9tImjY9TBY6qycMrqSnvXfkyoJ7pSrrz/WtQTIQy/8PxP+eF6o+kFZZ/a9Thwh+gxL3dGNeKTWEyvxuhHZW5HIlNdeefRI1F0dT+bW3SXtleZhmX85QZk9WRN0rQzKhhgWxt5CNuoQ/ZHziY2doQ7Sg/yqGkpcHKuBp5QRci37WTsfqPXACS0XKQKUEyjf7YA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39860400002)(396003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(6512007)(53546011)(6506007)(6666004)(36916002)(26005)(2616005)(8936002)(8676002)(316002)(5660300002)(2906002)(6486002)(31696002)(86362001)(478600001)(66556008)(66476007)(66946007)(83380400001)(38100700002)(31686004)(41300700001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2pueGdYZ3phSWRsbGxGM2lNenVERDllSEM2N0d4bm5PNityeU9EQ1ZldW8r?=
 =?utf-8?B?dXc5RkdOb1grc0NtdHJKWmIzMWI0elJJQmx5VG9uTjI5a0k4NUVPc1ZpdkE3?=
 =?utf-8?B?SXR5bFdaTXlrczZHS0lXQ3JCa0dsR0wzVFE2VUFVczR4OUgvQlZhWXg5TXJk?=
 =?utf-8?B?QkNwL01qWkxacGdBSXRHdFB5S1F0ZlRzZWhtaXhqSHBnMjNmeGRKOG9zeTVZ?=
 =?utf-8?B?WmY0THprd2VRT0FWSGE1cXBXYXhjSnpLUHZCVGJ0OUF6TnJvNTRkUzdTM3pz?=
 =?utf-8?B?TlZnaDQrTW9oZWJENlY5blhETG1zZC96cDRUUGV3clB0RnBEczZvbjd1dWlq?=
 =?utf-8?B?ZmxBaXhOS2k3R0tidkd3d1lTcEpxN3l0eExyVHJDMTIzUWwwSzAzSm16Qjlj?=
 =?utf-8?B?eWhGTzFsaUNwS2p3MlFDSTJMU0x5eE1vd3FXbXRlNW5LSDRlYy9pUTRHUWlt?=
 =?utf-8?B?NndhV3ZieGtMQkJ2ckRTWjNnU3ZOR1UwSldzdm9EeUJ1TGtLZCsyRzFWcHps?=
 =?utf-8?B?K2RBSFoxdFdCWng3RFhBREVGZzJYZkJiQzRkd29QUko3WnN2RmxSeUpjcU5w?=
 =?utf-8?B?ZEtsM042eUpmL2g0SWNVWFU0SXJ5bkdITVFTWEtpMTQ3WmJGc0JMSCtac2p5?=
 =?utf-8?B?dTJwMHhYQW55Z2tMWWNYNWMxOStkcXg3NERUUHhpT0ZZVm1WL1JjeHE2b0Fx?=
 =?utf-8?B?dUdzdDB4dHU3MkNlNVg4eEYzdWtDRzQweEo2L3RJUlJ4RkdkOEt6aXdidVho?=
 =?utf-8?B?OGlYRDc3WUcvVkp6bFVuVnZDanpUOGl3S2JuSkF0L1A3OGpyT2QxY3ZNU1FP?=
 =?utf-8?B?STdINXpKZlB3aXhXR3VBV2dsaFQwYnozQnRYTTNwbE0yT2trdWRjNm93WkIz?=
 =?utf-8?B?ejJkSFFKYW1zRkxJRTAvNWNCeTdsYW8zQnExZEx6RlltYStnZi9CZXorVi9u?=
 =?utf-8?B?dWt3OFNOUEx4V2JEVFZhbUpTUk9Dc3cyc1ZHUkVKMVVoVWZ3Nkc1RnlmQjJS?=
 =?utf-8?B?VFF4aSt3My82SldJVHZBSkVrRTBPcmtXaWs3bm5tS20reEVuei96Z2xpdFZ0?=
 =?utf-8?B?bHNJanE5Tmg1Z0F1dzRRb0NtT1N6SENBMVhEQUJvV3ZmeXVUNXpweVN3d2Za?=
 =?utf-8?B?emVrYlJzOU95NXdmcEtodkh5bTEvOG1oSFkwZm1tRnlXdzFISm80SjRvQTBz?=
 =?utf-8?B?Z1N1d3RnNSttbW1GWkJPd0U0SmpnNEJ2eGVCYnJYNVFPcjdyc1hnd2s0VGNs?=
 =?utf-8?B?enVmMzJpWkJFLzdDTk5LazFBZVJKSXZqK1VsWkxmNzNuUjUzWnQ1YVZwdVc0?=
 =?utf-8?B?cXpzMndhaUpkUDl4TUw2SWUwRlJXVlRtUlhsNEVvVnlKWUVHbzlBS0FjcWhp?=
 =?utf-8?B?WE5XUlhsNE11K0FzZUIvWThlVHRNbzltOVRGbzE4MHhjeVhSZE5vS2hBRXNi?=
 =?utf-8?B?Y3loTXY5RkdrTUJSd3h1VGZ5UHpka2p4MU82ZDFzekgrK2FDTklCOHFFTzRo?=
 =?utf-8?B?c3FhRGU1WlE2aEpyM3dEN0FKbGtPRUNpdW1VL2ZzVFFDdmJudlR5eEdmVnV6?=
 =?utf-8?B?cDQ5YzhpQnFId2lORElXa1FteWlSMlhGVElteVp0QWhCN0xBSUZQY1loWlpF?=
 =?utf-8?B?VWhBbFNiVkEyRjVWRDdDVlN6RmxkcWV2YUh5ODl5MlZHT1I5OVFxTlpTaVFD?=
 =?utf-8?B?bUZPdDJQM3E1d2x3ZC9HMTFTN1BpUnZJd0kvTTZib3A4MHlMNHVaWG9ydlc5?=
 =?utf-8?B?Zm1MdzVEL3ZNS0F6UGd0Sit3REhEVlNDdzRRbnV0dHFxR1hEUkU2aWJFMWUx?=
 =?utf-8?B?M2RhcXZKNnQ1YmZqbU9uN2ZSdHFHYXhtbjV4MnluM3N5em80TnJkL0R5K1Qx?=
 =?utf-8?B?Smo4WXRRZ3R4U3h1WDFNQzJRcmJBUEpXZitkQWRBYkN5NHZyMjBqKzhZanAw?=
 =?utf-8?B?VU83RU5yeWdBMm4xMlJQc0RnUXVWOG1GRDljMWgybTNodmhNcVZOeFF3STE2?=
 =?utf-8?B?LzJ6dXhBbE03bFN4eU9ZWHpzUVhuTWgwN2EyWTFiVGVWQ0RYUWxmckF6V1Qw?=
 =?utf-8?B?cU1COXBXenZ2UEtzQzhuUWhKRTI3ZWpjOVJOK01GY0lzZEdIZ0tKa0NmcEhY?=
 =?utf-8?Q?MrawqzLsHUWgsW+skfMBEJGAA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vDtYHYoBf4Wf3axTAAS3OoDOuvkxHaleAyVeVkR87y1zY1lyeuHbltsUaTIlyyRVRYOEIy55EQmVYyZmfRx3OYmg3p+8K756/tFBT9pH9IqY9Xt++xc4VwcBFpgHoA5qNWfwqp/LKLuI/VDc3uCzAq3fdn/hDrp0+LDUxgzsSYpoYGtnmgMMfdYadcay1Qz3Se/qDcEOCp3oIFeVlFb+RljLv0Qk/yj7SoNoCEEankIdq+GAzsxGVDcR2i59EBIIo08BBoy98ybi87mg6UMffR08qHLElbF9hOkSLLjkfRqBicsle9z7JiID3fdhV7hW//1Nd8YWJuswTQ7I/nGB8edNxcWikZs3Se+6FdaDUyxV4B8giQ2D5M0xvKoaV7NU8dmEJ7RLo3UhuwzV4/5cqOZocDS2yAX+zmurzOHLsUvMssWMjkMABeDK70hsy8ce8T2hySRuV0bMNRckPmoKUJomHgEtwXwaS/LYYHX+rfEa9wnYc34OpR9HoW736LDlaVPgXRrc1T/Q/SyObmJHeqgRPm7YVd1RHIUUtZcld//LjrVPihpvIA0G5VFJrEmBYuaUjzdNDgMdfXmGHRIEHy8ozPfIcmrolZPzcRDbf7k0tM5JFW4wca+aLnT8BjmReThOt0k0MwjV3M6wf24Ym9ROFPlLfSBfDJmWw8cMkM0VRrFvnpYLy48EJkK9YlhgosxC45d78W4tIouDLN8Rac+DBDAKOedobyzSQQ8NUfVYPq3lqfmChzV+gn/6ochjmO+srP83vI2s0+Ymk16kNaPNzCrk8f3w/G9AuNzHdPQu6FceHZ1LQ81vmvI5/ZO3DQ19Tv2dfbTE8ZKiCxTfPvjd1vU9G+ok+GQCCmXuqrSNSDgleHYNc9EdutBQOEGvLzYA7y+PFaneiGawJWsc7Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57dc364e-b4d7-4e9a-fb31-08dbe69d6973
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 12:13:15.8695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdisSZ/nRC9v1m+r8lQdexl+n5dhXsbSEfsgy11M/d7aK3dICly5KdH8QCf3cN8VqpCMiI8OdmDdAbYoCVnG6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_09,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311160098
X-Proofpoint-GUID: NgHlQ1XnJFwvv6cUiAmlJuB_m1e18A3T
X-Proofpoint-ORIG-GUID: NgHlQ1XnJFwvv6cUiAmlJuB_m1e18A3T
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/11/2023 01:37, Mike Christie wrote:

Hi Mike,

> This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
> we retried specifically on a UA and also if scsi_status_is_good returned
> failed which would happen for all check conditions. In this patch we use
> SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
> when scsi_status_is_good returns false and there is status. This will
> cover all CCs including UAs so there is no explicit failures arrary entry

/s/arrary/array/

> for UAs.

But the first failure_defs member is for UNIT_ATTENTION, below, right?

Thanks,
John

> 
> There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs the block layer waits/retries for us. For possible memory
> allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
> will probably not help.
> 
> We do not handle the outside loop's retries because we want to sleep
> between tries and we don't support that yet.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> ---
>   drivers/scsi/sd.c | 77 +++++++++++++++++++++++++++--------------------
>   1 file changed, 45 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 641f9c9c0674..cda0d029ab7f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2235,55 +2235,68 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>   static void
>   sd_spinup_disk(struct scsi_disk *sdkp)
>   {
> -	unsigned char cmd[10];
> +	static const u8 cmd[10] = { TEST_UNIT_READY };
>   	unsigned long spintime_expire = 0;
> -	int retries, spintime;
> +	int spintime, sense_valid = 0;
>   	unsigned int the_result;
>   	struct scsi_sense_hdr sshdr;
> +	struct scsi_failure failure_defs[] = {
> +		/* Do not retry Medium Not Present */
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x3A,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = NOT_READY,
> +			.asc = 0x3A,
> +			.ascq = SCMD_FAILURE_ASCQ_ANY,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		/* Retry when scsi_status_is_good would return false 3 times */
> +		{
> +			.result = SCMD_FAILURE_STAT_ANY,
> +			.allowed = 3,
> +		},
> +		{}

