Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49118C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 10:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbjGYK24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 06:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbjGYK2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 06:28:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C431FDB
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 03:28:26 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oeht017276;
        Tue, 25 Jul 2023 10:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=QYpjpbslJ77IOGwvExw2LgD1EAbhjoazX7zt2ZjLRDc=;
 b=11dxFG6bu6p8RbmBR8JUjfFQrO4nbTSU3H+3CarCBTpCXaKddQRMG1jxhN5k6GeDJYdI
 b1KH+ZRZXNmra80hJEjltP/xvlUYn2Gmdm67psGsfEhoRWCyI2zmn74xXR26/Bv2gRG4
 92+3TH4OAnIQiiIVWdTEN8CugnSAbYb5vSqGwHzrPtWdHz4SOE4eS4eXPb4yvGSKRP1i
 YQbfjDqZzDagn9w4uKFXUlAJ6xvdFGIrPbAJTCMve8szf47YHtYUXGkM84UruNfDlK4l
 oyoFlfxwBRRUDhvi/ZWCH4zAErLMbuxVVm96ewwLpy9IXjJUYSNc/7tM0XJaIYMc14Qk tw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c4t35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:27:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA917B032687;
        Tue, 25 Jul 2023 10:27:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j4tjgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 10:27:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvBEGKDlgwRS0j87Oom2NJnd7W6QkWOU8KISDx0wTQOM3nNABOk6iEaeltDVoH7azcU5lkZY8kA71GgtKiFXFDvPCK8wKsQvclhk1brJzfTczrVqcbriexEgyNp5KbCI5CI2SNJo16KR95+Spmz7oIyr93LCzx7Ku+5u28vRe2XTWkwUInm0cJj+nLW7vDEkrbThgVJTcdd7w4ynpjfSj30w8CWuICnZ+cr5URGYvqRWUAfF5cJvBzM6ufZz4cHqz0XNgDvnt99PQ5NpzcnyXOgIX0wxEG5ajNLK8/CgK1CDXBsps3rtkjTxi6Bk59syHVI6dNmBFzjXM99ij9uK1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYpjpbslJ77IOGwvExw2LgD1EAbhjoazX7zt2ZjLRDc=;
 b=SegXWYWUdrP/onJ4uvMRorhevhqwNiFMRluDewPG545QrE9khQmMOHBAACi6sznv5XB9c75Cjr9JCvfQhEAlEqMvoEA+CgcjdYnsfxuou9c4TJd2UscjLl/HzgwqZ3pc3FoUjXJxoMYd14jcNBUgHPS2G4gPwNjOWtxO4+7s5eyhF1yN3OhWHyi49P6pkxltixxi9dlFa3uVFg0FAKA3m54n6DvHl+3IhaW3uCSCmE4AeEVhPjfPQpFO4+MHnLZuyCppF89ylzrToSEaJz82zAmjdHw8DvXzC71skaCcILkwvhaxnj7Nv6EArd0LkScdZ/+baXS40hLA1DdNPoNHPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYpjpbslJ77IOGwvExw2LgD1EAbhjoazX7zt2ZjLRDc=;
 b=AN8Cqo470WutnZgR/3mL2v7PvAu2Ib4bboy7449cLUVm5SmlnvrPi7NZ5ZLHPQu69T0G1dwVyF/CvtMWCeTvbA1nJ8GSVxOweieOwMvg/3qieA4Qv1bI1HiWC3ClPELlKSu5Ktd7CuSHbjPUCPmuKvyOfPc9kyoGZJ+Sc6MjYUM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7643.namprd10.prod.outlook.com (2603:10b6:208:48a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 10:27:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 10:27:52 +0000
Message-ID: <d3179790-51d8-a557-76a2-ec6af9559057@oracle.com>
Date:   Tue, 25 Jul 2023 11:27:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 18/33] scsi: sd: Have scsi-ml retry sd_sync_cache
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-19-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-19-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: 034d62f0-0bbb-40cd-f4db-08db8cf9cd07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgxEuvkbGHGXsJTV6jqFlGRCyTnJLFu6vRyS+iAYyQuHO99/2r6rqn3CSIkALtZwADQquTjQYk/VVVfjm3x4OElBTroVmqqQd60OEbiGmDRrIA6HqTd3jHYi87uuzbuhqp1T5hBDGiVOsuhkLuAQJ1I+I1UoWpQbSSGPDQnk7YAd3eDnp9gu6cn+wAfk5bC763JSvijgDGdtxZpNLABBvKGeGSdE2+UJiE9rtU/GubZQtf55N3uvT2NA5/u5dgjK2hW8kWDCp64SdMD3jhXt+pbr5lfV/Wxc0pIhL4L/Id/eXQ49Ahb+OpWNYuR5GTUa4eO768bZPoo+BUT6hCXXSEOz6eKBU78QDwPMfqxeueeVXRFooMygKMs4Ip4/CjcVHraiSoyE7uz5kbRdDqeE9ILt4llX+fBvwmQA8kivbzPNTUWwWRpTWeO0zeo9eUBJ/U0GIyo5ea3LaPzlU7Y8wRNBOHPdnvPgNRkVERPWzjS4LjCOCWOPg3BX51sljXFWxsZP8jD1oH75jOYqHqt2ypMxXQldDN9XbsBRndmvasm1Q+FUxR3pBKerwF5cdDB9tlxUKiC1dIgQKhrbWeKVcVFVMC1E1ZS7ghydy9f0zCi+JqZvnA8szNOYh2l6u/QhFGYU5rJe086yfrMnEVXKgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199021)(6512007)(38100700002)(83380400001)(53546011)(2616005)(186003)(26005)(4744005)(8676002)(5660300002)(41300700001)(8936002)(2906002)(6506007)(6486002)(66556008)(36756003)(36916002)(66946007)(66476007)(31696002)(478600001)(86362001)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZSswTFl3R2dZMWp3QW4ycHJrMytORjlkbFVBcDJvb3RMa2wya1VEc1FYRjBF?=
 =?utf-8?B?YkY2Yko2akFRQmRnblZHdjRWUGVvYWlIcitnaWQxVVd5bk9tNTU1TytLTDZU?=
 =?utf-8?B?RjhrOEQ2VndRUnl5UU5LWUd3TmRIQS9HRHpaeUlXaVZPTExPNUdBSFl5eTRl?=
 =?utf-8?B?cCtmZDMvdUYyNFZVTlB6WWtaWm5EWHVVSlpDOGc5MUdZUEdjMXpURzdpR0Jz?=
 =?utf-8?B?bmRsK3hRbUZKVDVZcEhxYjlaek52M0JiK2QzY1g0aU5URVdzcFc1QTR6czN5?=
 =?utf-8?B?WGhaak5KWThHRGVVTFFBbE9EOFVvOWlJeVY2UHpheUw0WUhYN2VxYnpRL05n?=
 =?utf-8?B?R1lCUXJ0Z1kxNWdyVmgvdG5oVXNDb0dkeTk0VGNNdDBtZGNMTlpHTFB3MUk5?=
 =?utf-8?B?UmZkU0cwZ0F0NElmVDdNeGpVY0F4Y2xhd2tHQk81N3JwL0NqbHF0Y2ZDdUZY?=
 =?utf-8?B?MmhCNHJKOGNPUHcyVG9zUkMvTVhSaGszNFd5cGl6ZnJiV3ZIemZqcDE5Y1Z4?=
 =?utf-8?B?YXRsS1BUaE1kUE5wQkZhcnZ4Mkk3aVllQlRLNGgyUWRLUTN3MVliMHlGWEF0?=
 =?utf-8?B?QlpDbUJaYm1NMGZKUUlOOXZIVGdRalI0WWNiU2NqWityTkRFMk9WUjFiN0ps?=
 =?utf-8?B?SzN3SWlCOHAydWg3N3NqS1JGTVc3elB3Vmx0dG1mb0N6OUt6RDhRcVp0SGVM?=
 =?utf-8?B?eEFFZTlvaDR5ZHZmTnJZMkF3RXd1QlRmVlZZS1VkdmI2VHVDVlo4VCt5Vnlk?=
 =?utf-8?B?ZHcxYnp0NHh6RFNwTUFPQWpvTktkNmFDUmVoTkp5SDQ3UmFDeTBOM2RFeXVC?=
 =?utf-8?B?VUp6blQvbW8vcG5DbmE4dGhtVHBQclVWUjBXWlpwUmZyYXJVaFpLd0MzSlUx?=
 =?utf-8?B?cWkzTVJ3N1dYeFNuQ3NIK2FGanl0bnpNU0o1cktTOWxiL28zUVRVeXkxWGtv?=
 =?utf-8?B?cS9WdXNGeWtiZkx4SUJETkpRNmRNQ0lTMTVkdkoweXVKR0lZdEJWaXlSc3RY?=
 =?utf-8?B?Nm1QV3o5NlpZK1pVVXlYNUloZFQ4a1VhelM0L0lORnV4TFUwcnR3QjVpTGI2?=
 =?utf-8?B?bTNLN1U3d3VTQ1VUT0VvR3grMnQyNTF0dmFNNW9uaVpCK0NCcURLNlFNYnR2?=
 =?utf-8?B?TTY5MFNhOUNSM09lYk54UWJ2ZGprZ3RoUmwzbDZCS3NoUzBCZ1hHTG4wSDh4?=
 =?utf-8?B?dkJGM1ZrL2JkR3lvdUlLeUk5VklWN0hQWXFTNlNtQ1I0Q1RWZkEzOXZiakRV?=
 =?utf-8?B?NE8wNk53bytUQm9MTVNMRk9YdFZaK0Z4TVJ0ZlhsaHVPWnFIRXJkcWN3VW5O?=
 =?utf-8?B?WW9ySHRpNDRIa2xxenE1QmFjcVBGenYxWWt4WCthb0tFaDZTS1FIUVJXM0g2?=
 =?utf-8?B?VStSUnJsVDMrQ2FuQUF4N3NkNGNlUDVsaHhLa0pST29NWEJ5ZzYwUjg0Rmkx?=
 =?utf-8?B?MHdGNHFJa2dzN2g0WFd6R2NpVW9VcFc3eVVCam1DUVB5aExMU1dkSDNkV0ZI?=
 =?utf-8?B?TlJwOFQ3SHJuTmgrVktUY0RwNUZQai9zVTBtZUowQm1qL0huZFJ1VWhWYVhP?=
 =?utf-8?B?bWJYbFJsWjF5SmgzVThmWEF5aTczQjhEdGFkZytDRFFLZkFLM1hpMG9xNngw?=
 =?utf-8?B?VkRKUjY2QVF3azQyRVVQaFpVYm0zU3FUNXJEbzJpQzhPSjNmUmlpd1dVN3dU?=
 =?utf-8?B?bWhody8ycGFDQnJzRTZzUDNFZzAxMTE4cUtMT2ljR2hoL3VUZzdvb25lWHY5?=
 =?utf-8?B?ZGpEampQMUh3SFVKWlBhc3ZCeXlTb0dBbHdQSHUvU3NqMFZ5M3lzT0k0Y3l6?=
 =?utf-8?B?eGZpYXNncDArM01NQVhDWnpQNjdNQWx0d2pIUExBRURiZnN6cnNGVXNHbjh3?=
 =?utf-8?B?bnEwbXZVOVhnNTRDUS9FRXlJc2V6dUkyaGpxZDBvSDRHWmo2cS94dTdtbDcw?=
 =?utf-8?B?TG80Rk1uTGhsSU5iR2d5dDVmRjZCYWN1aStwamRwcTRmOThjMXZRL3VDUVFX?=
 =?utf-8?B?NnpkZGlqQm5EczdSWVBrMjVLOXpERmY4ZWpnalZkcS9JUjIrNEdoWnhhUTFn?=
 =?utf-8?B?UHlBU0h0SEpuRU9Nei9qWnpCMTdvWEk5dEoyR0ladkFHeE9YalVXYy9qTXFF?=
 =?utf-8?B?MTVaUGM5RS9uMkt6TTBxaXYxbDVNRVdrSTlzTmNkZEdibmhXVDNKbk9kSS9u?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IRT5Mt14RnBXry8VB0GE6HeV2ubuhrobKr7sXq/qZhPjdHCf1BcR8Ar8XSTwGHlXFc6Cu+zXRbdjMOkt6UkA2H6e0MO/HusnKg5wKFP0crqlalaCMbOzNjSK+ZHtwAzjeSrlOH63/MfpHN4fPOMGBI3DF856cK0hT6126yiRhje8Eptv1KmkA8bmGkXmuLmmGNa9GCY+gfl4C+20lb2rQBw+6RfNMoI+FClL2rCw0RC13V4Bt9UGSeOQVw2o6cez7GUuiFiS+Od1/ekiC8+ucNDZVPVtJw0Vt5gq2OKwVDIKPm34qoMO33IlJDB5RgkZMkfC/Q34hosdyFnQUkEpfdxaJhmNCoF/jkItoSPDo6rFbZuwqo7byUXjg9X2zm47VyhyZLIIcV8ABhSs5Y7mltuvXe+f9iSzgXlwUy+bF/XxMxbSL6tpiQ7ZLe1EXxYIBTZrBsdR+ysLcJK/CssbZ9iMdQgpUskp3Go4t+WqZNXmwFBxrE5rx+s7/emMlnx8zfgIWTtRy+PtA1aHAKgp3qq0Sl10lFObW4D6mkFg05mniZPrNLBtJtHfd3Sf6UfGlBkZ0HnVg20egYggD6dyJETrgft6nU0CvLumBaAX38y/fSfbVS+0idhn1VJ7rQOJZbREGXoKdkS/4AolmcuhTujzZ32KrSaOKQ0pwmPnEutZG/oLn00NNTIgWGnGZu97MqNy1HFI0ATu2J0ipfIPTMbPaQrNKJ5EKoeENn+y1cu2E6YZxXTjfyWlZFvBEzf1eEIN0IZkbwDdA0qld9BRG8XYji3ZTObFV3CgTACRQjvY3vofjnY4aoU6I7dfbIj8SHIyK94w9/sr1ElvN/EqEfNonkkBPd/ylzNsjcDgUrSfB7J6Gnt+Erj47PlAFj2+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034d62f0-0bbb-40cd-f4db-08db8cf9cd07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 10:27:51.9744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ef1nf5r6Ccscv88OhioFOhid+pVY1A5SN03978All0bXJtvTGkMXINP0hAXVYJQgGiC9GCpnf/DgUmQtha7hGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_05,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250090
X-Proofpoint-ORIG-GUID: qLaaXGk2KgkIPs9WFSSTkyKbE94CTiac
X-Proofpoint-GUID: qLaaXGk2KgkIPs9WFSSTkyKbE94CTiac
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:34, Mike Christie wrote:
> This has sd_sync_cache have scsi-ml retry errors instead of driving them
> itself.
> 
> There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
> for failures like the queue being removed, and for the case where there
> are no tags/reqs the block layer waits/retries for us. For possible memory
> allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
> will probably not help.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
