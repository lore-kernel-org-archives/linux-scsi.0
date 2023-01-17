Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2565FC54E76
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 19:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbjAQTv2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 14:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbjAQTrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 14:47:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0B83CE28;
        Tue, 17 Jan 2023 10:46:11 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HGUJ5U018525;
        Tue, 17 Jan 2023 18:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=4Q/6/7Ci1Ak0kT87dVAaLoUPRxZayfQae2ce4TuV0Ac=;
 b=BnaMxUUoIV5bMg7zKMXxYXTEPYFqX2Ca18IW+er71SQHwLS4oMOQ/Q1GJd7HNuk8/7oX
 7aFAIC3aXNBrDRKmcUmebDsAi5PBk62FvDD9Vn2ZJCT3w4e0qPyS1rl6xUKF0y2HbNgV
 fmUqhWEFgZBGAO6uM4XAqBRvEMLS2pbRqQvjpJDQjkUT3qKlEs4isOctUn7sG3GyPp4T
 ZokaOCj8fAR+Kmy+3U8cM87J3dyWO6v1b6IHU2xEyyFSKYgOEwnZ+ssoWBDwboPsiKhl
 lt4Dupyg6CiumwKolSQKGzxTUhG/7EjVz/GvM4vtcWnUsmplUuSEYRLiuX2g+akfwoR5 mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n40mdd2hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 18:46:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30HHaCvk020527;
        Tue, 17 Jan 2023 18:46:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n4rq47nc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 18:46:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6JIkH9U8SbD+AQYiJLecPgMMCs/zQXujuOXqDAu8TBe/j3pSqt8CcvK8Hh1AlAABMGWVz/CUmyG57Dt4yBmEx1sx5aluygAH+EKezIBBTOLSF0Mr81Yu51FMg47M49pbsgISqnkiuRiGh84GlB4it4tUCyffwfPB1x5WvL9LnN6DJVFEXbGPQAqjSjzXUz1x+9aZslfnCI2bV8b8kFE0ZhE+FYTcHkcnuC7hWgZluqvoGYk8Cfb4NR9m9Fi8oMj243ZCAvN5FU6rJAicV1BjK/jAmG39Sfs1lMo4EnHDiPvYOe7HwdmuYf9+ATSnAkolTSycgECo3j6rhqBBFo2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Q/6/7Ci1Ak0kT87dVAaLoUPRxZayfQae2ce4TuV0Ac=;
 b=BLhNMfi5LkzEG7hDMZg6/rhLNnaxb7zyCK95BmJ0XKIDK6m4pWuM4qY1yyr+TihxIZFUcyTX1X4/bhNkUfBE/C+hrkOLMS7Xzzj1J1mnryS3VRhdIa/95JGJqeDlbAxzFZrfnk75beCH5RmaPl8fpuSU2UbrYXUexD3X/ugaqmU7IJgeFYGmS8EwQ6r9TCGfUXLxRCeK3CPRR3H4ddPGFJY9c5es/E/FSG7XVBQqfr9GW0awX5MavhrElFjpNSD3azGsAELPsxjBgJdMd0sNMxJ7mFVTIyi+D6FmeRtCtMZQPoNQYkn3+4smR/rXrDfRWcK1QaDxImAfniHHRfflaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q/6/7Ci1Ak0kT87dVAaLoUPRxZayfQae2ce4TuV0Ac=;
 b=SUE/5Ws8jjC9UP49c/Ps/tEjZoeB4A0yIl/JhI3UnsRViFDeYPeerMWE+HWef/g/0VvyTDUpW2YI+Brl2x7py10YitWByKHehCmFZ2lhcM5UJtrwKZoeLyX4ea0jMMDix3NoiWO4lvKn3Yhbnp4H04FY6FgJnl22+8GATxbz7To=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB6698.namprd10.prod.outlook.com (2603:10b6:208:442::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11; Tue, 17 Jan 2023 18:45:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Tue, 17 Jan 2023
 18:45:58 +0000
Message-ID: <5574fcc5-49ea-0cb4-bb95-cb011f21fc8c@oracle.com>
Date:   Tue, 17 Jan 2023 12:45:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 11/13] scsi: target: Treat CMD_T_FABRIC_STOP like
 CMD_T_STOP
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <20230112030832.110143-12-michael.christie@oracle.com>
 <20230113141512.GB31614@yadro.com> <20230117115257.GC31614@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230117115257.GC31614@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0391.namprd03.prod.outlook.com
 (2603:10b6:610:11b::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c1babff-1377-4caf-042c-08daf8bb1257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1+fCPZoNQFjyuprrZ5ImzMQcE5dyY/crFJ8JFKZBsycU7zWEwJ8DahjTSCPjOHqyLe49ZNmQlajrtpzvYQeQpsOnIZsiKdaggBJvbANG7bAF0h/SsCTgMfR9CySPhxGs2H7U/yGs8iDgyziLKeY3T+1T7Vh4UcgRdkKZGdxspnJMt2LTQGzMA2bxrlZiT8g4qkEQQVRcZILyMSoEaJlLVPN1ToIxXTTJme9Wcr1ftHle70HBxxMiPnnu6wiR3NGivtX2wZDetM5+lJT8JvQGL7cGwBu1q2GXZClFHGD6b401kJ+fmN7w0Q0PZjLqxbCt5/DZr3/XESUkNHmdMMVu7K+XD1uEPOZAEKsiGIFg5Y5zQzEhpoHqgeTU/7l0ZtVHnHBHTQ9PhmzGnZe1YSbB9hPoGQyV9tkI5uhRZc9PO03IFYjGjzw/lcsPTkqpWom7cPPJxp4zgqDtknhuueNMHvAxPiAWnpOwAlmB7exNHMQjaEeL+1vKEs5iOWawI7vPk5jvfIsaldZ5tYisptgwhSYb7BgCwRpBKGArp9XoIGWZwL46fD6CTv6J83bEOtqaRgl3HPbFrNjrONFZa7ou9Lzcip2V7PmAe21c1qJ78/d4WDZv/no60Sk+d7pozf1XFKs1M9Ai1RI9Mh7fT3TGB6WyS3/cybEQ1kzCO7NgPk5/Tu50Zq8WAHnRUZcN7J8EAxML+V9GFapiM02XnGOvR4OMQxxE8EhDeA96Kj87Rsg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(83380400001)(31686004)(6486002)(478600001)(6512007)(31696002)(36756003)(186003)(38100700002)(2616005)(2906002)(6506007)(41300700001)(26005)(8676002)(4326008)(66476007)(6916009)(53546011)(66946007)(8936002)(86362001)(66556008)(5660300002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2NQTkhnYWNzZDh1NldLdDZUMHpBb3c5cG5hTzdJWHZvSitOZVd3eUtINTJ2?=
 =?utf-8?B?aUQ1TUVmR0NTRVI3UE13WHBkd1c3YlVZWHRZTXUzTmZJUHFJVWhKSUovdFFP?=
 =?utf-8?B?T2FmMGIwUVlTUDNDZWEvVnVuME85RXgrdmF5MU9WSzIwcnBOSEdBZWoyayta?=
 =?utf-8?B?dW5NUENCallrK2ZYaHFEa3E0eXVPdno5RkNGdzdONk1yOVcrREh2dU9CN1dD?=
 =?utf-8?B?NFdicWRZQnVTUUlGQjFGU3hKLzRVdlFPS2FzWUpUelBwSUp4YjFxQURxVUMv?=
 =?utf-8?B?SXlEaUdjOG1GMmtGbUZDd21FTDNqOWJFcS9qRFJXeXdLMVc4OVg2NEQ3bGRO?=
 =?utf-8?B?SnhoanZJa29HNHRULzRweDdyRVlkSGxZWmltNjNJS0xibHZOMDBrWWgxL1d6?=
 =?utf-8?B?eVl2N3J2YkUxKzlIRjFMR3JhSmtVanZ2MEpJZk9nUjVVKzY4ZXZIN3o3WDBx?=
 =?utf-8?B?YmdEc1pLaFpLL0V4cHp1N2hlWXY1SmJKOWxxTXpCSUZyU1JGZkZtY0VhdE5q?=
 =?utf-8?B?MHZBU0V6eEpDUFpVU3Q2S2kwZFNjYzFpWStGT3RZSXplWWNGdnQ0N0JLUnRY?=
 =?utf-8?B?ZWp3Y1dvYVJkUWNyQ3ZEVUlEZjJwVlFob1ZTUlBlUDJCNFNTazVjUUJtYjBi?=
 =?utf-8?B?bnVTb0ZMZVdFQlk2Z1VhdkkrcHJVVUt6Y3lacFlJMHpxd1hqOHVmM2Z4TWov?=
 =?utf-8?B?Tk1teHk4V3U5TmN2dS92dC9TVVhJMFo1Wkh5aVMyeUpPdGljUlM3enV6N1Vv?=
 =?utf-8?B?WU1sQlRTNVVJTlVRRVdqT2JZa3JIdE9BaEtGc2U3TkZJd251dXBlNzdjaVEy?=
 =?utf-8?B?Q29iRW16ZzlZdkFSRnAxbUFZTytudkR2NFJoR20rOXEySHNPamtEbHZveXJ2?=
 =?utf-8?B?RDZJSkRoRW1vcFhpUnZ0d1pIQzl3S1NDMXpHVk1TQmU2dUFYUG1wZWVrMWdw?=
 =?utf-8?B?cyszNjgwNHZXWGgxWXIxYTBESUpLTDVGbVVqK1E0SXBFZFh1bDBaQ29vQjIv?=
 =?utf-8?B?bS82UWFlWDRZRDJhWW92SHg2UkkvSnlnckdrNmkzZXBIVkNPRlVkd3NVeEls?=
 =?utf-8?B?TFFWQVRaTTgrbk5PWUsxMjRmcy9vUlVqNUtULzgzamMrSnM4cHJSSlJCOHpW?=
 =?utf-8?B?VmNLOW4yaHh6aGNLU1Z3bGY5SmNhczRKYUdoQ0IwL2I2WW9CbW0wcGdDUEZW?=
 =?utf-8?B?L3Fkb01tQ0F2Y3JRZXBKSTdvMVJMSk0weW9yRFkvOGFUd3Y4ZHRHQWZvVlpm?=
 =?utf-8?B?ZU43cWlLSE9kWVRFeSsxdzRLN1A2UUxpMlZNakN3OTlmalRzeEdrYzBCQWFn?=
 =?utf-8?B?ZGtSQXZZRnhHOEdsNkRYWkhGa3NuWE9iUnZOVVVCSHZES29UR0gzV3dSYVVk?=
 =?utf-8?B?WWVlSHJMQm4vRW5mQVYrQkthR0RRalRUbHA3YzZWOUdlZlAxTFBUM0RDL0Ri?=
 =?utf-8?B?SnBGUVZBbU5TZUo0WWVlK2ZxR3FzRnQvL005cWJac2VGV2RGcXNwL2E2NnJy?=
 =?utf-8?B?d0VhOHFMSElRQ1NWVXlndzVjYTRqM1FmdFk2cWZYWWl5dWNCN3JwSEM3VjlH?=
 =?utf-8?B?enNrTkQ1dlU1Z1pqTmcwM09OUUF3U0N1by9rSDduV2xOQ0QyRHNtT21Rd1Bu?=
 =?utf-8?B?NEMzejQ4WE15L2toYnpTT0NvN1VnU2FNRGlkUDZCV1JETnhVOFM3d3VuUkF1?=
 =?utf-8?B?QkZ2MHJCK2xjaWJmS2Y3VCtxbHBQeWdDT2hZS0NEWUxXN3FBQytUaWlzcyt0?=
 =?utf-8?B?OTV1QWFEZWVaMVZLVWlYSmVIREgwdmZhbU5mOFVzd0R3VVVFNDhmRHVJL25x?=
 =?utf-8?B?NTd4UFBGL2lzV0sxUGNJOW9Nb3Zya2kzUEVsZGhpTnJhK2luY0RCMDUwdmRu?=
 =?utf-8?B?R3JiUElhdy9LdFBTOXJxaU5ZVWtvTjQyOWJUQnFKdTZIWUs3MWRRTTJLdUpj?=
 =?utf-8?B?K2VORHJPbnc5N202ckpHWFNpYStWcVRjNHNKOHRXc0FFNmFTNnB0T3RKMEdv?=
 =?utf-8?B?aVVzWjczZmdBWGltaWRLWnlORy9wRDB4SUhrS0x5QjJrby9EakhPNWwwSG9G?=
 =?utf-8?B?ZWZzeHR6MnZWeGVpZkwvM2t2SDRRSXlyMm4xZkFWczg3ZnYranZncUNrN1Er?=
 =?utf-8?B?QzhSWUVObWF0UnViN3ppdFo5bjUwcU9lUElqeWFVQzlROWV2Z3FVM1NKdXBO?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UsVO0IH169MAYlwJn2O5X0D+L1QEgCOpz2fAT8bJ7YtXfwtyc56bhqUFfDnBkP8FujzCfogmbrd5xZCqkcmH5ekIowUjU8lcs95PqLdVI+APANZOnazHn80rLLXo2K6CcCeQrqq4L5JP3EckOipQAiemqaCaOi36fPt71TfRZ4O9qbLQJq1rs1V3fJuCSoXmS75EgudaWwW26xtQgujKCvmI71v/NZFZyrrCIYSSgAdM+vLGAyNNUtPf5xl5AekCybkJtUklvyGTJxsnSNwBeYz+uLI2o4u+9N5CDk0ZAMlTrl5+3xZ6lx0xv597wtS0jeTZlD3nFBoHrNyrRx6BAIf8H2Tj/Ci15nLn81kbj477xw2q5LsBcIcZQhRMLDRv6X7ZoM2b/HJoMJwNgqcUxpKvXePb8/VnRopc0zKaJAuxb2dMxC26VPAnH/VqNV/MvW9S3F6pnMnbnZC0BWMKw195ZTTIrc792gTtAQ2V4d5PTqDKk/I2+Y0px6S7mRji9ocYL9bsfcRJupCB4IODGCZM1uTvbWCWpwuj3a5bSnDHKtvgi/cpjZrQpT/Vh1260c0ojOHuFu9V+y+rh1YCc4j/Q2zTpVsNqX2jaBQ4nrCk7cryMKAsma+kE4DQM+rw5HTp4wloqN1SxVagJ0OH8Jy2g52IdMlME2vrLZ1pXoAw8hqLLdhCDByCUuOZYd9UW4NGLzbPpntjlGXAbt7yfduyJ9f3Eu0v3i2jtpdZXgvFjcTVdsqvIGX17QCh10x3IAfzsDb18jOqUHjb6cIOb7hIZT8okrKzHlF+MT2qNoOTRk05DlOzN/EWLDevrn+GeSD9WkENAvFuF9sG968mjAOBlPTDgf3wKy+WPOjzIsL/ddj5cLY7sPXL8GDcc3ib
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1babff-1377-4caf-042c-08daf8bb1257
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 18:45:57.9111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6y8THJd0ACYPFtEnOZbnn9WX5wqQkNNFZVTF6aObtjBFyjmbeMcYonrQ1QihVKT0sa3IJ778p1FzQzOkVoK1dW77kDrWx0iOU2Ao5VcSQvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_10,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170149
X-Proofpoint-ORIG-GUID: LGi_og119YIoqNOyR5FA9B3hhX6SAnvG
X-Proofpoint-GUID: LGi_og119YIoqNOyR5FA9B3hhX6SAnvG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 05:52, Dmitry Bogdanov wrote:
> On Fri, Jan 13, 2023 at 05:15:12PM +0300, Dmitry Bogdanov wrote:
>> On Wed, Jan 11, 2023 at 09:08:30PM -0600, Mike Christie wrote:
>>>
>>> iscsit will set CMD_T_FABRIC_STOP on running commands when its transport
>>> connection is down and it can't send/recv IO (tx/rx threads are killed
>>> or the cleanup thread is run from the one thats up). It will then loop
>>> over running commands and wait for LIO core to complete them or clean
>>> them up if they were on an internal queue waiting to be sent or ackd.
>>>
>>> Currently, CMD_T_FABRIC_STOP only stops TMRs from operating on the
>>> command but for isert we need to prevent LIO core from calling into
>>> iscsit callouts when the connection is being brought down. If LIO core
>>> queues commands to iscsit and it ends up adding to an internal queue
>>> instead of passing back to the driver then we can end up hanging waiting
>>> on command completion that never occurs because it's stuck on the internal
>>> list (the tx thread is stopped at this time, so it will never loop over
>>> the response list and call into isert). We also want to sync up on a
>>> point where we no longer call into isert so it can cleanup it's structs.
>>>
>>> This has LIO core treat CMD_T_FABRIC_STOP like CMD_T_STOP during
>>> command execution and also fixes the locking around the
>>> target_cmd_interrupted calls so we don't have a case where a command
>>> is marked CMD_T_COMPLETE and CMD_T_STOP|CMD_T_FABRIC_STOP at the same
>>> time.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>  drivers/target/target_core_sbc.c       |  2 +-
>>>  drivers/target/target_core_transport.c | 27 +++++++++++++++-----------
>>>  2 files changed, 17 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
>>> index 7536ca797606..56136613767f 100644
>>> --- a/drivers/target/target_core_sbc.c
>>> +++ b/drivers/target/target_core_sbc.c
>>> @@ -459,7 +459,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>>>                  * we don't have to perform the write operation.
>>>                  */
>>>                 WARN_ON(!(cmd->transport_state &
>>> -                       (CMD_T_ABORTED | CMD_T_STOP)));
>>> +                       (CMD_T_ABORTED | CMD_T_STOP | CMD_T_FABRIC_STOP)));
>>>                 goto out;
>>>         }
>>>         /*
>>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>>> index cb3fdc81ba3b..02a9476945dc 100644
>>> --- a/drivers/target/target_core_transport.c
>>> +++ b/drivers/target/target_core_transport.c
>>> @@ -737,8 +737,8 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
>>>          * Determine if frontend context caller is requesting the stopping of
>>>          * this command for frontend exceptions.
>>>          */
>>> -       if (cmd->transport_state & CMD_T_STOP) {
>>> -               pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
>>> +       if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
>>> +               pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOP for ITT: 0x%08llx\n",
>>>                         __func__, __LINE__, cmd->tag);
>>>
>>>                 spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>>> @@ -889,7 +889,7 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
>>>                 INIT_WORK(&cmd->work, target_abort_work);
>>>                 queue_work(target_completion_wq, &cmd->work);
>>>                 return true;
>>> -       } else if (cmd->transport_state & CMD_T_STOP) {
>>> +       } else if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
>>>                 if (cmd->transport_complete_callback)
>>>                         cmd->transport_complete_callback(cmd, false, &post_ret);
>>>                 complete_all(&cmd->t_transport_stop_comp);
>>> @@ -907,13 +907,15 @@ void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
>>>         int success, cpu;
>>>         unsigned long flags;
>>>
>>> -       if (target_cmd_interrupted(cmd))
>>> +       spin_lock_irqsave(&cmd->t_state_lock, flags);
>>
>> That leads to a hardlock because
>> target_cmd_interrupted() => cmd->transport_complete_callback() also tooks
>> cmd->t_state_lock.

We shouldn't lock up because for the failure cases the transport_complete_callback
functions don't take the lock. They just cleanup and return.

> But the taking the lock for read+write of cmd->t*_state is absolutelly right!
> It would be great if you manage to move transport_complete_callback()
> into other thread/job.

I'm not sure why we want to do that since none of the transport_complete_callback
sleep on failure. It seems to just add more complexity and we only have the 2
transport_complete_callback uses now, so it seems overkill.



