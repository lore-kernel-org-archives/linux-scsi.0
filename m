Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76979EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 18:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjGQSae (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjGQSac (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 14:30:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5816C138
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 11:30:01 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HF0U8e029374;
        Mon, 17 Jul 2023 18:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=U/6c6cozZZpqMtQz/Of8WB2Ppk7aMNU1A1GxBNWSSUg=;
 b=qb5zwtx+3w67V3aZCAgw2ryxZtpbOIOI8KFRU6K2hCxjUoQzBvfbMMBTSc1YCkFdJQ8z
 T3owbiOUUWULatxw6f1eTRoz7/ktpXakqAK2locJv13A3fET3gueOMgKxgk2RZn/HZIc
 +HAgQu+lxRXlTKd8dITMhHTaYTQtGRUUtn/uVeA2T9jCnfPNFKjJRyAJAQhfybSK0UBE
 j0hfUOYSO98ePmV+lL3wJAps2t6ujuR35r7PI9PS8VUPNPXk5uiZSwet8cjik73hYYPW
 uOj9Vn8EbWvJly6LGKfAAlWwn18SU2QMqPWJ89pFqtFbHGGfjgDnnElNwCx7HOh0g1Qx NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run89ue4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 18:29:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HH6OC1007860;
        Mon, 17 Jul 2023 18:29:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw3t4bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 18:29:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdOG65gSfxatYvwdV0KuA+R1EMamPgnO2BIbjrX8Z6EKS+8GW2MfU9LtRFchag2K6NJeBBSpprosMcAMY78/BxTO2yJ2K4x1Foud+p/GGUy0MgJAdemZst6riCX9Cwb5VdjmRnRNt6Z6/ag02L70+zWpjCBbBjtJMShF76kLgGYv3XUgJxTWTSZfmcsrqxCfB4VLkP8Bci4twdhg/Tkqz3IXT/9atsDxF/vnUGJh9bvJsU6evteOtqomPzFAyGC5KGPNplv46cFMLFLjTs/26hwke0KZLazESqVwzjxUwE+yukB13omujhg4AdiP6hldVTnBQZCiMjkFTHupHgNM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/6c6cozZZpqMtQz/Of8WB2Ppk7aMNU1A1GxBNWSSUg=;
 b=iawRiHI4v0cXyIVsjUndquwAdZbyLwCnfkSD5sMYyk/7a6NhbmR9dADwLiPbSkOm71UsgSYtefXIkNJeFLWoDYLuB6kQqOi3J9j87HDMHJYfC5j4tgKB0iCq5oWH9IrDqDI6m7ihshpHPvRWpgi6y6XUow+HBSbSl2Ow9M9lqMFuotjXm7lY23riNjg5AhgvmYyrHsLuRMdvq5CH2HYRSLh6uyI+4iwVjWOFfEkJmV0dChTW656z8c4LCfjMeYGWP0Z/GMMCIvP+wgeVKG38HlEbeJ73mdKB4TwuKGPpRgVNI27AWe/uw6D5b0TgCis2MIYvG+B1jrULRS6yK6tBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/6c6cozZZpqMtQz/Of8WB2Ppk7aMNU1A1GxBNWSSUg=;
 b=BE/T83m17Kuxe18XaOfOF92WSL/P6UglHUX+ZnIo+2FQDNH4Fucm8Py3xFGwTWLG/dd67NLXOb6FViR0D5/0v+Bd0R4y/j+rH48j+srKwrUxxQsWTdKBhSz6mdY2TJh73xI+oZa/v3+5I6xHZG9I29XmtbWLTOJBBuxfD8StAY8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA2PR10MB4489.namprd10.prod.outlook.com (2603:10b6:806:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Mon, 17 Jul
 2023 18:29:49 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 18:29:48 +0000
Message-ID: <b624c3a1-84bd-a567-025a-dbfc533f621b@oracle.com>
Date:   Mon, 17 Jul 2023 13:29:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 28/33] scsi: ufs: Have scsi-ml retry start stop errors
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, john.g.garry@oracle.com,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-29-michael.christie@oracle.com>
 <38793488-3785-3685-7919-814a338158a5@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <38793488-3785-3685-7919-814a338158a5@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::48) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA2PR10MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d24218-49bd-4b0c-aabf-08db86f3cd97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: plc8vSFnKLqA5e9ASUigcMneVSXfuTzp52dQnWmaQJxQQm5q4EEd1sOI34E90MdUShCnpD/mN8GLVslc9Fnnbv1jiqHRCO5zyb+V9FUzxkP2gAr5DiIZRSLc4ByZAB87Zn2p7QJaw3TCCjjTTdYAwt9XfkSxI7pu5w13Rp0/LP8qCQK23lmDoYs6mhkanqFfCq+i0LSLMr6f5T2qS9Ks1e7Som3TZJmd57NqKKoc9dQhsLri04y7dbTrFJeREdjOE19SZrFVNAvhfPJZ5spzYuydu+khZRO6srkPqOwra2iLukja9CX/ffERpWKx9lLeIezhIyOm/kOI+onbaXR2wpWk2PvdAR9EEKA4B/1pl0idI1CO6K/G1L/6ABFLY+SmYsslxXdKpvSRQySEv4LmRVQFB7qEukGyJuWcLJutpJ+KPqS+AcRsUyDFziQwwhtin6dxGw/3mqqyknvtVxeLbPeBtuJSUDGLvIdIigShoXBKptByLK4L1jWaZQG0SUT9vc+xkbziEbTwlc9g2wBsWgSB42dq2p14zzruoDs04Z5t5BTG/LMvoRtrfJY/JiRUlxGUOK0TtisT0eEw4fpXtFjDive10bVojQQ7z9ipDGJRgiTkn83f4HrW79Las/u0hZWs+ljkNda5eUbvdpWB1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199021)(478600001)(6486002)(186003)(53546011)(6506007)(6512007)(2906002)(26005)(316002)(66946007)(66556008)(41300700001)(66476007)(5660300002)(8936002)(8676002)(38100700002)(86362001)(36756003)(31696002)(2616005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlA3SzhRZmcycmJkNDRXcjdveGRqNHNXZ3NHTzNlZ0w5Rzl4RVZ4Uk85UGpV?=
 =?utf-8?B?ZXRISEZ6R2p6UXRuTEh4VE10UUdnR2VtV09neElPMTRzUWJIU1piZ3Vwd0RX?=
 =?utf-8?B?NkdnZkpmaDNSU2E4NG1FYnNidTNTbmQzVEk1OFQxaXRiR20zNnFmU0g3dDFW?=
 =?utf-8?B?bGZPd1dUSEpmZDJrOVpPOFNyMVZZM1JMc2Q3SHhzUW1RNTh4NHh4VzRyaHJS?=
 =?utf-8?B?VTFOSTJPYStYS2hxRGF5cjJoM05Rb2FHdE9FN1RkNVpKN1V3RFZQQXVGTEYr?=
 =?utf-8?B?WFUzMy83RjVaUjBiNkVqSlJPa3FjNGRTQjZJb1lHb2FvMDJyOHp2QSszSjU4?=
 =?utf-8?B?RlBtVUp4c1h0N005NkgyNWhJc25wTEVDNzUxMmpjcDBCZnJudGJlREk4KzNx?=
 =?utf-8?B?SExHUithSVpDM0V3amd4S2pEMzdqMUpwajd1WUNrT1FFajI0clk2NENhNHQ2?=
 =?utf-8?B?QlJ6a0FYakhaZVlOWHZ5bW1CeTI5anp2clZtaTBBOFJjaVQ3TzdWNWdIeUtV?=
 =?utf-8?B?V2J0VDF1czd1L1hoejJwZHF5a1lLbnFIbWpvV3BYd1N0RTVxS2xWaXpwSTZo?=
 =?utf-8?B?L1liQWZyQm9XakhyYUg1clNING8yZ2VQZDFaS3FiVW9JcytpOEV0ejBjR240?=
 =?utf-8?B?UHA1WmhSMDJ4Sm5Kejc0ZnJpZ3FKaENaeXZpMWtxSnhVYkU3V0hBZ09DZWow?=
 =?utf-8?B?Q01GNzZwbzU0WU5mU21FZFhzdVhDc3pMeld6MEhmR2lka2QzL2pzTmF0dlgv?=
 =?utf-8?B?ZGpTbHBmV2JPTWw2Y2tCSlg5amVFYjVSbWR5cFNLWDB3OFBFbm1hR0htRFJz?=
 =?utf-8?B?bzRacWZGNEhrUHZYQytJcWFNMHVsRTZGUUh0c1BWUGxQR0xOQWppaXd3NVdZ?=
 =?utf-8?B?QjZuV1dlYjd6RHRsckxWRnhNMkg1RENIamNQbnJuc2tNSXRyVmJBKzlUMUwv?=
 =?utf-8?B?WERZQlp2TGlYd285YW5sblFEZkliK090ekFLR3cra3pDTGhjcFVXZmE2Q1B1?=
 =?utf-8?B?VzByOC9EWElyKzVhNzIwZThJVmFUNExxUzhIZTJ4N2hzdzN3a3F6eUk5eHdY?=
 =?utf-8?B?YmZtWk9IU2ptbUUyVm1DYk1Yc3JGRXpFVTFLMkxnYmRnM0hDeVZ3OFAyNlFr?=
 =?utf-8?B?TVBVMEhqYmMwMkUxRUxNU3dYdk9IbmY5S2FwUzRGMHF5WldnOEpKU2VCOVBp?=
 =?utf-8?B?SnlRZkxENkpnYStGbXQyWlQvV3lnRHVLL2duQUxqVWFRWTJzdTgwcDBFNlBQ?=
 =?utf-8?B?ck1zckRjQU5KSFJxK3g0UWVXNEpHRDR6MFVFeE1WQ3NKZXlGOXl5bmRSSlU2?=
 =?utf-8?B?dEQ4UWJnM1l6SHE3NTFlbk5obUo5TXQ3YW9lNW9WVS9KL2V3cStiSmxEOFlm?=
 =?utf-8?B?OExRdU91SHp0UXNhWWxiS3UrR3cxc1BsWU1hcFRuU0o4TUVGdzNmcGNIOGY1?=
 =?utf-8?B?VmtTZUtTd3dhT2tVazNhTTE2RDFxVDBxbVVDcnR3eUZTY3BPcjlkWk9GdkVn?=
 =?utf-8?B?dHMrcTlZaXdiZ09NVGFaVDVNL3F5NHZEL09uYTZ5L3J3d2JUMkYzRmFBWXdw?=
 =?utf-8?B?ZXFLZlk4TjdHeWU4aGhHbG45R3V3aFNFT2pud0I1ZFFEcXg4MTZURUpWZHQr?=
 =?utf-8?B?bTd0M2U4QVlDcmZRV1hTaFA1TVRhU0dqREt3UGIzemczVW9uVlRmYTUwbTB1?=
 =?utf-8?B?ZENjSG81ZGs5WEl5aUREaVlLWWhMUkoxaDZUQWNVYkxSUW80TFFIM0lsL1Yv?=
 =?utf-8?B?MVZmeVY5a3VObXRkdXpNMTRsM2tvaC9vYjZIaFpDcUhnSEpvWitBb1RhL0lO?=
 =?utf-8?B?blJtR1VJblQ1aDNXTEdseTVhSyt3bHZ2UWM0SjFWQmo0NkVXYVRSL25vcVJZ?=
 =?utf-8?B?N2tSLzRBRTFSemF3RnR2SVgvUU1YZDNuNXdWb3hnaVBzaDAxaDdUaW9yZk5E?=
 =?utf-8?B?TmkvaWk0TXc2T2xybEVMNzFnWGF3N2tpS1Qvb25pdGY1SmxuNjJFQ2xMNXdY?=
 =?utf-8?B?bnlXVlJQS2ttM2JPZk1VeDJQMVhZMEJRNjZRbVV6MExXTE80WnA3SXV2YUVS?=
 =?utf-8?B?c0Y4WFRpbm9QZmJldVgzZ1BmWXkzZ0E3WDB3NnNlcnhaZmFpM2k5cDUzYXFP?=
 =?utf-8?B?a0lDNmFBRFM5NXIrbFFZM25Bblg1VlB0NnFpMndmbXo4MnRVWmRlbDFlcXlB?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SjjVZDgn7J0QfXodK7LBsPfgt5/WA5LM7XFTEuUyQIe6octK9aI8yrhB6cGs+UmqZpDInzUd3y50BE2wB1/DaBTppu8o3pspo3Qv4U4CWoFifEWMoA9ac6vun9OkGj1savHCA0B7qIQOGXvIZPancsTOqhkqD6xmS3gdh2uAiCanDYPHGLwV7CDfhe2Aux014d/zEueeWTdumaMqDa+7Bygkp2V5h1qwqPpmszU2nTybeg7R5jubidpZyv1dbIHkAwT2WrmJA1npnQ9WiQ713JcHpoAjyJGH6BIeFzoQqX1Eln5TqV4e6ExHuRLNP2bVq9iK0gRySahNwoOF6YinSIL7wSOrgUzmtLRnYhKFXhfHYkLa7cDSZWyNswfSvjmSiy/jfATabkBnr4HSEr3IG769WAMXMue4bamChYkOeamJOL/GSH6nbsMVI811OZtNERplgZi1/5JHQR6cVwuo16Ulu/TKpygiAKsOlrP00m6M9WAOBwTGzTbiOU8befkQyxVn2GLzKx5zOuibdX1s3Iu+vMJLXB8Dmbvi02SE3SYFQTl4PbgNb8jZDOpIhtxp78KHPmVstjwuVt1HJSjnb6zd+vTvW/i0GzmgWWVR8GTb58bbuiTYLbv9046/xIlngvINocyUlZEjUE4KXQ4IFy/wMX1/H37VyY1b0bZREYqhv+Yt8TB5vdwcFSyCE7Co0VBH0HOZZDU1KT64ZBqU+GXQfdXmaQlCkP5M3jbSnQWvCGkKOlixorQDbHcs1tqtinkC7Bo+KzTTWPZwrf13GXvOugkNOemCkS/LqPR1wfCHvVTe7lW210f7fW3WTNIrlOfvkMxt9AfBcoIfcylK/9lmOmalMT5NNSQVisU44Ts9X6pJ/RWyjTByh8+g+Zse
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d24218-49bd-4b0c-aabf-08db86f3cd97
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 18:29:48.9227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8MuRfOOzZV7YT4BtDrddB8Fgjcfh1r/i9L9UCYc2rtMucirI9UKYmbAFQB1vMR73kJDgvXGCPk99b4xeFzz4N12KbKVVqcFn0lw/cLnXiUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_13,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307170169
X-Proofpoint-ORIG-GUID: Gml9WGHdd7bQR1eSL5dNz1G11AxIOcTP
X-Proofpoint-GUID: Gml9WGHdd7bQR1eSL5dNz1G11AxIOcTP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/23 12:05 PM, Bart Van Assche wrote:
> On 7/14/23 14:34, Mike Christie wrote:
>> This has scsi-ml retry errors instead of driving them itself.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/ufs/core/ufshcd.c | 19 +++++++++----------
>>   1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 983fae84d9e8..267c24c57396 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -9291,7 +9291,14 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>>                        struct scsi_sense_hdr *sshdr)
>>   {
>>       const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
>> +    struct scsi_failure failures[] = {
>> +        {
>> +            .allowed = 2,
>> +            .result = SCMD_FAILURE_RESULT_ANY,
>> +        },
>> +    };
>>       const struct scsi_exec_args args = {
>> +        .failures = failures,
>>           .sshdr = sshdr,
>>           .req_flags = BLK_MQ_REQ_PM,
>>           .scmd_flags = SCMD_FAIL_IF_RECOVERING,
>> @@ -9317,7 +9324,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>>       struct scsi_sense_hdr sshdr;
>>       struct scsi_device *sdp;
>>       unsigned long flags;
>> -    int ret, retries;
>> +    int ret;
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>>       sdp = hba->ufs_device_wlun;
>> @@ -9343,15 +9350,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>>        * callbacks hence set the RQF_PM flag so that it doesn't resume the
>>        * already suspended childs.
>>        */
>> -    for (retries = 3; retries > 0; --retries) {
>> -        ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
>> -        /*
>> -         * scsi_execute() only returns a negative value if the request
>> -         * queue is dying.
>> -         */
>> -        if (ret <= 0)
>> -            break;
>> -    }
>> +    ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
>>       if (ret) {
>>           sdev_printk(KERN_WARNING, sdp,
>>                   "START_STOP failed for power mode: %d, result %x\n",
> 
> The original code only retries if ->result > 0. Is my understanding correct that the new code retries SCSI command execution whether ->result is < 0 or > 0? If so, I think this patch introduces an unintended behavior change.

The new code does not retry when result is < 0.

SCMD_FAILURE_RESULT_ANY is for cases where result > 0.


