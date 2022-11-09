Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599DEC43217
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 17:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiKIRWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 12:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiKIRWc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 12:22:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E4025C8;
        Wed,  9 Nov 2022 09:22:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9HIgUk008239;
        Wed, 9 Nov 2022 17:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=t13amQ4xpcW8GcdWEDj7T74hMXgBaOyucmkSE8zjCRY=;
 b=VAffuFgg3Ad9Js9yuBg/83x6aAFAhD4tmpX+Kjt9Nzs7pc58M8EsskLhewOGxASNTuH3
 j+/+sy7mpwULJ/64+uo27ncBOeb9Ld2qBUexAsX6Va/KRWvDItmvifhcsizaKIuQJddS
 R38rOzy+V82QPbljjE5DzzF7E86Ru6D6MdNWep3fgHGFrrXi7rvJt9DSo9m8Lr8MEQbv
 m61vR/hlaDV4pAQL8zCOcPfyUVu9ZrmuUiGWvut3zKXevuyYXpB6uCK549xM5rqkTpGE
 OeuCMe3yiuMnbKeqH0VQUymt2NQobXhpOFhuNvEuA2mfZkxsAAOqI7X/oq7gtViey1Rm 6g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krg9wr131-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 17:22:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9G20av004294;
        Wed, 9 Nov 2022 17:20:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq3pm1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 17:20:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSCvDIjFvkaYL+mNa50bFUcgDkm45TjPRDEqCOBVoJuqF4i27w21MthGSJuW5A2A/2NPxK129k9vQnyILZy6vwo6lmdHDEBK/K5pjKuqPznsdNtbs8R2uIJIqOLBHsiwD4YSrZqiX+a2T+/U5F1UTfSCZK7QAL2pnrv+GaJpCRrbQtFD63hgmA/oY8VAX6AzPOlRAY8907NcK4JsIThnMa2lZ/ZbPjfBVXp0RY9GIfzV/VouvBg5PPbi6UpGY5oWpKPWzuBpDo0P99cIxSPFhpgDH8C5RHeKSKdNFRie1rzfv0kTdZ33/trKLKtKaYPNkjDfE4ziE5vlTRBmFDcwpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t13amQ4xpcW8GcdWEDj7T74hMXgBaOyucmkSE8zjCRY=;
 b=Xof1ytgRjtAG+68A/Sd4Cfqbr3038Z1/7DV5TsiVLMP/Q5yfGox4KdlWfMFjpMGT9dO8MpmdcSHCQfTW0v0nGhB5BwPk1D51IwabFIglivYdw/0qlo7ACXPPZNSd9eLBnKZrOqUIJ6vuwhCsyYHRtkMBpHGkvz0RT8/PnIjezvWZQJ5jMQzJqA4FNwQfNFGinYchj/J0y2tsgYp69eQqJ5bsWV3zwM6Q4ZXWPFnujpaa624jG40JWzVzcNy3WSSsJ3R/FA/boGKbQmVW/fYTJVWy9eAYM7XSInEnk7SqCPMQXUjcvPTGHRZjWkAZr/zjio8+wuofTu91VaunHyjLIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t13amQ4xpcW8GcdWEDj7T74hMXgBaOyucmkSE8zjCRY=;
 b=wVef8LJgKifdNyzB/y5voB1UMTDus2Uyz8e5+TNtaQJjujyuCuC8VE44BhDOL+ISPgEb87WkpRNDjDtfoJ1gkcTGTmZp9U0Tt6T9DOh8OFzIDeRQrHguuLpWBJ2LpbXdovGGIm44Nc+syt+uldahacAlylmPucpVRQEl+mLLnw8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6668.namprd10.prod.outlook.com (2603:10b6:806:29a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 17:20:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 17:20:10 +0000
Message-ID: <8adcb890-ec08-cc75-6e1a-2b8dabdcd640@oracle.com>
Date:   Wed, 9 Nov 2022 11:20:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     kbusch@kernel.org, axboe@fb.com, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
References: <20221109031106.201324-1-michael.christie@oracle.com>
 <20221109031106.201324-4-michael.christie@oracle.com>
 <20221109065338.GC11097@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221109065338.GC11097@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:610:33::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: ad1c6c2f-6585-4d09-bbbb-08dac276a782
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /QEO5+8MWOAKNbMdHKrJUWVCrILdSxEuQ4SuvFUJiTC2INDprh5cWW7qYUQr23ZnIwHLdlFZF83T9i5Z5EUZXeiqHSS5XcpXi0wJjwU7XRRlzOw7a4x3vxkIgtD2FHespEOj7l0V4JN/UtvWyikjsmQnJyrJkqMe+5Qu0B52tTPNjJWVqJXqE/Fbb32j5p8pZEfsxIIm5zTtW9V3s1V+Y1foWS0f6XUfxwuLQWjAzlOyrccKo8gjjZIhAJvDXP1pTjJawgFw69J5xrPt2MdBfVxrQKxudtqv/pZBXGaTZ5k3bTQgPW/jmBvE/yRJXVgjdWn3qMp2rb6x31aaiSkaoeBA6SgJqZvUy2D+8FYL7BbWtdB+oNx0v7KSfULdSnfJ9tdlsM9fdd/+gYNc9qwsDHEE+LO9VxxoVmJ4qB4FqMimS3IWBCxBLtOFWYxfN/+hzJo5OpQD3MtSlcO3DIZEf6VEWgDD468C6SDufWrJHb/6Dbhcep+h6AxK4wCQCz/Chw4z1Xaa6uHv5sMGfbVg97mwYeFKRx4vSPwByzzMBjfOjEBxbRdmF08Nnr09z5aZ3ifioQ27eEixvOIUlE7F1DBemZLS1cNvg9G+H8JzcD3E/oMCS4NC41kJTQb4HHUi04w+ykEJcvLh64Lzm0WpRQ12Gmj7EyBQ0lEwTiMviGMk0p5PdQuSUq8trI2KLe5H/fmVIR5OIDzjAJpvdZ408yABw1oyoGqHGEq6UUrzXwT57cTZofBakkTClmHcwF2c+/KhEH+Lmn8dHt4ugZmu7IfxCZ2kIppTIh/KfDCMNdg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199015)(4326008)(8936002)(66476007)(66556008)(41300700001)(66946007)(31696002)(6486002)(8676002)(86362001)(316002)(6916009)(478600001)(31686004)(36756003)(2906002)(38100700002)(5660300002)(186003)(26005)(53546011)(6512007)(6506007)(6666004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWtvem9QckVFSys3UWZuWXkrRTVPWTNOSHpzQlNiVTZ2b1AvRWttQnB6L2ZM?=
 =?utf-8?B?VlRWUnI3b3pkRUo4bkJnSXovNzFMRlVGcGxRREdydFNpM2d2V2c2SWtwVmlW?=
 =?utf-8?B?R1JtTTBSTTJKaVFaNHdoNVZmVjQvQTcxS3RGSUZxYkR5NHAvVUdKTUhZZzFT?=
 =?utf-8?B?aUc4REtNMDlNa2xlNHJodmtJdXZKZW5QcldJWVJlYVVCZStQNTYvVitBNDZj?=
 =?utf-8?B?clJicHBUcVdpdkJCb1ZIZjIvL2VoZjUrTmtBRk5NVzFvcDQyQ0NDaXNCamtZ?=
 =?utf-8?B?WFJsYkhWTW1aeUJMWTVNNSs0cFpydDM5QWoyMmg2Vmp2NFFQUGFQdVgzQ05U?=
 =?utf-8?B?NTJlQmxhYThsZ0xrQ2dWeGw2ZDhSZXpIb2d5NTdGbnFWRHJubFZibDdWWnFn?=
 =?utf-8?B?K3ZDV1o0cFhDY1Vua3JMeDIwN2p2emh6OExpbHYxR1dxRTIvZVpTUUgwN2lQ?=
 =?utf-8?B?ZEFvQytzV1FFV3N4djFvL1dpUnQyTUhZT2YwTlV4ZmF1UDJoMUtnUThreEJp?=
 =?utf-8?B?Q2M2SkNkMGdWbG9wbHVIRDZwSXkva2sxSzhEWERUWGlWV3k2dUk1dUxlR2pw?=
 =?utf-8?B?TjdkaUl6SVFicjlvaElHT05MT0lSK1p1VUF6bDVWbnpPVTJ1dDR3YkM4K2Nz?=
 =?utf-8?B?K2RkWlRFNGFTU2NWdWxCM0N2UGpkMXNpVHVKTVJ0aGh1VXZoaTJZWVVqQ3Fj?=
 =?utf-8?B?NklGVjVHeGFUenBQOGV6MjRsVFFteHIxYzBPRXJKL28xY1NNNVBnT2NGVTRv?=
 =?utf-8?B?Mm11dW9VK2VWNkdpbVFXVGdxN0dITUl3eG0yWlNhVVZ0Sk8va1VWc2h1WlNj?=
 =?utf-8?B?bVFZeVBxQ3JSUFNMVDhWdHd6TFBBRHVzZ2s2Vy9DT29ZcHlTN0ltQ0d6R3F0?=
 =?utf-8?B?dUhQcFJENEk5S2QwOXpuTFZybzVIcmE5TlNyRmNqamRxdUtjSHdqbk9kZjZ2?=
 =?utf-8?B?TlZMNGtpd1puVmlpM2pmME9nTUEwTVgycC9UdXFMUUQ3Q2IxS2xYeXRpQjQx?=
 =?utf-8?B?R2hoa1NYcEtucS83bi8ybDh6Q1VvRnVGVzhCeGZSZTBaRjRiZ3hudnFYNlpK?=
 =?utf-8?B?ZmpNM2NFRUtYVktsUmVqQ1J0VVl2ejhJSWlKMEdJZ1lTYndWLzhIK3c5Z0dJ?=
 =?utf-8?B?SDN5RnVWMW1SSVJaeTM0R29GaUYrU09DQTd4bVQ2eDJlT3NmbnRYdFhhTGlu?=
 =?utf-8?B?OS94V2RLaDFkdk5GT25QWUpJTmorRnZaa2lVYld4YW9SelpZY0k5Mzk0b1BR?=
 =?utf-8?B?VHE4b0IvSE00QjRJNndDTjRGZmpmMzluNjJDQnpDaG5DSnREUFBpeVl5N2hC?=
 =?utf-8?B?SWV4VlhXK1dOamd0YVptRlJ4ejdMc2VGaUNRNnJDUExocGtkWURkempZTXRH?=
 =?utf-8?B?bHJWUWtQbGlsRVM0UGw1UkU5b2thUi9nalpoRnpReWx3b2hCRlJ6Y2ZJalIw?=
 =?utf-8?B?d0VNKzVzTUpONjZvVXdtbERkbXZpV1RMa0JYYThuMDE2ZU1aNVBBRDdQTG5W?=
 =?utf-8?B?MDRVYWx2dThtcGN3NW5kVzRZbjlscTZ1dkJFRWd4S2pORE1EMko5Nk0vRXdX?=
 =?utf-8?B?U0t3V0NqTHlDR1dTeEhFWVEzV2diTDE3WWM2MjhCVUwyMWFsUklmQ3JnNGdi?=
 =?utf-8?B?cEJySWhjWDVTY3J2OEcxUFFtOFZMWHRUN05IdEZhSUdkRVdkY0FsRU9yaER6?=
 =?utf-8?B?UFZQck12eDV6OVlZa3dTbWZha3JvOVU4Zi9FWGtpaExEa0V0NzlGdlRTaWFX?=
 =?utf-8?B?Ylh5MURCMUZ1OWk4dmJIMi9rTWxpV2ZiSUhyZkhWcm5YSVZ4TUExMXFTWmx5?=
 =?utf-8?B?dlUwR1pHSlNLNFdrOXNMTzdyV2NhMjIvTWxESEwrZGRsSnlJVXh4ZktrK3M5?=
 =?utf-8?B?aEJNSHR3d1VhQkZMVVdjdEF4aVJQcCtHM1BKWWFoSGxpRTkzbDRLRkZuRGta?=
 =?utf-8?B?bmh6Tk9LV21UTHNXNEI4eHEwbGRvdW84L1ljcjUrMWdFSnBiV1A3bHQ4Mmo2?=
 =?utf-8?B?ZWJCTHc3U1N0TE9nS2lxS1FPMjdxeWlGTElUU2FmQ2VoR2I5KzlMWWRFWWZv?=
 =?utf-8?B?RW04cG5lSnZ1aDNYK2xRNFpUWGlabHZsZElPTVpVT1RRSWZVWURqV2tKQWts?=
 =?utf-8?B?MDdXVUVDS2FYcmpWWHkxL2p4MmtQOERMd3RoNlJDK1Axd1pUM3hTVnRlbFF4?=
 =?utf-8?B?cXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1c6c2f-6585-4d09-bbbb-08dac276a782
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 17:20:10.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GnlCxOOOgOS/Ft4M4+pzhp626rn1zGdy84Su+apYr7B/c3+3SzhAhVrnNrtBNbFmeBpL4qK94Aq1esPIYIfAKhKxnt2kna7MCleS9vRf2QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090131
X-Proofpoint-GUID: Qy3uJUo3yxY9KS42op7JmfqSXpODzUzg
X-Proofpoint-ORIG-GUID: Qy3uJUo3yxY9KS42op7JmfqSXpODzUzg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 12:53 AM, Christoph Hellwig wrote:
> On Tue, Nov 08, 2022 at 09:11:06PM -0600, Mike Christie wrote:
>> +	case NVME_SC_ONCS_NOT_SUPPORTED:
>> +		sts = PR_STS_OP_NOT_SUPP;
>> +		break;
>> +	case NVME_SC_BAD_ATTRIBUTES:
>> +	case NVME_SC_INVALID_OPCODE:
>> +	case NVME_SC_INVALID_FIELD:
>> +	case NVME_SC_INVALID_NS:
>> +		sts = PR_STS_OP_INVALID;
>> +		break;
> 
> Second thoughts on these: shouldn't we just return negative Linux
> errnos here?

I wasn't sure. I might have over thought it.

I added the PR_STS error codes for those cases so a user could
distinguish if the command was sent to the device and it
reported it didn't support the command or the device determined it
had an invalid field set.

-EINVAL/-EOPNOTSUP would continue to work like it does now where
we can get those errors if the drivers determined it didn't support
a operation or field or it thought we had an invalid setting.

There is no specific error case I was hitting. I was just thinking
it's nice for userspace to be able to do a PR op and if it got
-EOPNOTSUP the driver didn't support the command and if it got
PR_STS_OP_NOT_SUPP then the device didn't support it.

