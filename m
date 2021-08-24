Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1A6C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7B6261262
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhHXEEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 00:04:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25506 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229604AbhHXEEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 00:04:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O100Dt031076;
        Tue, 24 Aug 2021 04:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8VpMhyGEwDmD1BSfdODmxmI1+MvxBJnljMpmrcJwgZs=;
 b=DVidIj1WzFpIK4zZQAZkPGODx9DhiyK8QmyNzbtzOlhhNP1w/Y3FufFQYVURHhvn+bbT
 LL+xU1msJ2rnX08U8/3pwSaYC/ib7mLi1GXLO2jWPFZo8mjkLXGje9wjI5jyo54jqTDz
 Plj6dTUzUSm9EawPpiUoQvh5qZCRHdI08dgw1I6ZooWJcmuLsYV69OncQtL+k8C+9cxP
 OAXZnyN2occjzVGhgPAq5ZboBnyRF9n2J8fmFv2QhZfp5h23lTckZWMtv7dpaqFaav6p
 cWY+brBQWG465PIDYBrVWwTjksMplBZCvbcmEeFhxMr8a03b2HzhxSJ4UfjyPxY5a3Gq fw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8VpMhyGEwDmD1BSfdODmxmI1+MvxBJnljMpmrcJwgZs=;
 b=aBiIB0RE+RlgVrxcPHNKSK0LtUt4ODztZ/l3J3HHDdVem0KKXgS/9hMu4bA+U3ypxHCd
 WPOB30N4SpvxRRncRtv7iiVXXq9ykd7BEPDSdBGPOI5mGDP8d588zHwB8myIdkleIKJ4
 1DbpSmLpBhs1lywr8JIAkYwe3ifNtAyg/0fk65v8CNthWxnVAmMvB5Oa7rZIuWrfczS9
 sooqYQ0Cf8uQuVk1PoqMOwJtl7SJ6gk6PyLHvsCv+KjmXd9L5fnAKoqnHBy6YakkLRfd
 1ArU2oA3fhPHgwBVtj6k+w0iJHDudtBwzMKEml4t7CFXKoqaqibzQN2ezEEW+RwRWwZ1 DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aktrtub5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O41X5X070148;
        Tue, 24 Aug 2021 04:03:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3ajpkwge4s-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNrrbP976StOh9f2ioKjt+03s0NqRb6dJckkt8UDAhdQ4JPZX92qzllWW9ghQ0mHJ4JHZkMamJkXxNFOSxnSO3eabV28X1V9ApetKoBLact/KzeZLNXmYbpvEBV+bXKLfIbZZFT9O6yfnFp10rdCn3ft2zlSzSNdKQvSSBoKl4GN2RSjotrFK70M9gG5iBbAAxfFswkLM7F9RDWUOpOjZkCqfzp9vUY6GcS2ze0MIKR0slbfWel7QD67xUibrfl4Kwja9kloiXjsp6rEzHai+FFNstPGA56J3ICCBtrVF4bNN7HzxytvLOeNvb/RJ1jP0P9LNtRAXmXExGrg1qKQTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VpMhyGEwDmD1BSfdODmxmI1+MvxBJnljMpmrcJwgZs=;
 b=IiEVw4DbXl+FGrIYIT/x44mogo1ePVoCdFJzaFPATHSN/Tl2x6+wmigf7bVh3KfxrdyBBax6o0EWgYzK4lnvNQf5cpAPgkqQv6Zh9L2jsE0XyhtzTbEwZUbtYqEs8xLLo3gtBX1gyZMUwZrOxCT1S8s/YMMzjHGmZm04341/VdIaDoG4FEf+el19ubarAGR8K7Ja2H/TYCY9lZIdvTSMRRVZudUekjgOBys+/hQo1T1O2f5gZQIdr2QJ/7zHuNWEVLa54PkG244H0aAGJ8hPukt+d3Nmz4kFDpvNG4LEyzr/xAFmAMDSBe6tn9awvm3EkS2s5pPqUunFGzHeNatFTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VpMhyGEwDmD1BSfdODmxmI1+MvxBJnljMpmrcJwgZs=;
 b=fNOi6ozioGZcqvPqmDXxRUGV0XQDMGk3HQLl7v5faifDbt5SfVF2KVv0VOBnDqDODkQpWro1yhTKWLDwdKaz8S6+kMLVkKVsK924EXZ3xfzs/3+X8XmCqiCRnjWhwDBC/rl/6cJB7xjUJ6WZxZs7ab5dRLERQ8n9pC43F2nEJ4g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 04:03:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 04:03:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, bvanassche@acm.org, ddiss@suse.de,
        michael.christie@oracle.com,
        Sergey Samoylenko <s.samoylenko@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux@yadro.com, linux-scsi@vger.kernel.org
Subject: Re: [v3 0/2] scsi: target: fix sense key for invalid XCOPY request
Date:   Tue, 24 Aug 2021 00:03:03 -0400
Message-Id: <162977310550.31461.15478143015222238417.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210803145410.80147-1-s.samoylenko@yadro.com>
References: <20210803145410.80147-1-s.samoylenko@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 04:03:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0d2d6af-d011-4f06-e5b9-08d966b419f0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5529EDC58008E0B65727FE1C8EC59@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zLeRxl/skuiV9yQ3uYrtAWdiiJ8wwSw7YIlkd93rDSO2xce/tTy6zllkOkCBGQmuONV9EBAzZAHW9U5Ma8HXSxcRoAIEIl/K6vdN6W5Wa0HbLVJ7Aed1J2W9jU/luFK4/xaV/ENI/PN1w2/melehSuh2p66STl2TPfWzEIod7Wx9GWHwhovAak57t/gwtKzjlisG1aRstSQjoF7yuCzgBv2yn5zpi3adp19EZulXDqVfUcvfk5J/KZlhsWkoWXDg1NzdJGwZ5hpAoWReInianpB4xiY3K/mGPVhyLt7Zv0bhQ7gbVaq5W9ba9rIrDCqvpZEysOztzbKjAHfU/imiBNbzWU6WC1lGvk4z2dlomVdSnmTgtN/W57erql97fpWmulBTX0NRUYMdKJYMzMObIu/LEgxdsFmeuhb2xNBITgo4p1e5/zT+QwdGML4qR8S1A1/hadjgAnFyLrH7u1kuWYezCwsYngtVPkkFYiNO7hJCikIBTaPUgG0cp7Q8FDvGTek2tO42chjfKGJy/WXqTTSYI9RYQdzEx004CN5p2K8dk4ew8lcECtDmmj8KAh5ciA1cLq/j6QW3R3xL6o4an3bH+HdtelbJ8fLMNKY4ze/wttnFdIMmAR4oIn46SPR3XRCXVy/b6nPd11t2PJ48+1LauPd6Gzbpx+GSXYw0dtjmym0KncsFuTQ2j2Au+RBB8mX7XfA+IFOy7ZI6urFguJ2VCHROB5sXjM4CU+T0RwXlaRbBwviasU2907KvGkOxpFsOvb4Uxl0ETrHnhE4Fc+qNv+Z5iZNgsiTQxUVjuOfS7u2ZGVmki/20sj0bSQp+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(26005)(5660300002)(4744005)(186003)(8936002)(966005)(38100700002)(6666004)(6486002)(7696005)(83380400001)(478600001)(4326008)(2616005)(956004)(66476007)(66946007)(52116002)(2906002)(66556008)(38350700002)(36756003)(86362001)(8676002)(6916009)(316002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnR6bzdYSXZxZ1BpTlA0Q1BjUDBCM244bElIb2JsbmRIdklZTFJNTTNkeXd3?=
 =?utf-8?B?Z29wY0pnNHZQeGZIenBoTHllUVpXRU1GdHpRSmVFeTltcDBwOGN6cVdXWDV5?=
 =?utf-8?B?TFBUb21CNEJmZEZ5YldubFQwWTNVMGxGdUlvMVNVbzduUUhwOGI4L2JuaXpn?=
 =?utf-8?B?QlBvUUY1MjN0YWFDWWhFV3c1aTVrZ1lCeDd3MWd5Zm5INDJ1S2ZHaU1uSkJK?=
 =?utf-8?B?RnVqSTZsaFRyL2VTYVhJSFNhUXUwOTl5WlF2UTlsbVE2bEJVL3FydE1CeFBx?=
 =?utf-8?B?RXhNcStOc3lDUzd6eHJKZXBRcGdXaGlsTmJmUG5KalRKN1VTTG03SUU0WEVK?=
 =?utf-8?B?WjFRYXI2Tlk1V0Z5OHZyZERrWWp6NFJqLzNab1VmNnJ3ZUdlNXFnWVVPTUM2?=
 =?utf-8?B?aUk4WWlzYUkxRGd5YlJvUmUvc3FndmxSdGliaVRXTDQ0OEl6TVpJaGJVemZJ?=
 =?utf-8?B?dk5HSE14c1Z4ZWxFcmlNSHhVbWhoTWJ4ZnpWTGZBTG9FVEp4VEk0eXk2YU9Q?=
 =?utf-8?B?V0lrRmYwTUFMZk5wcnZ3L2w5d1UrbTNySlVKV2V0NkZIaHpMQ2VPZWFSUXJY?=
 =?utf-8?B?MHlEZk9MenNzT0xnc0QzUlRlTlY4TTU3OVE1d0lTdk9BTi9ESS9EdkQwV0xX?=
 =?utf-8?B?elg3TzgwNjRZeVkzWHQrSjV1b2V6Qy9ubEhlMkovcjFMQ2N2NEVmR1h0d1dz?=
 =?utf-8?B?OXdRbXRGMTVNNklyM0IwU1FBMHpGMFpaTFZJTnVIcyt3ZERUeWVmZkxSUXRN?=
 =?utf-8?B?ZzF6NnNsSmY1c0RITkVTZXRZMURGamdnekZMWCtEcUNPclJiSitqWFd1V1FK?=
 =?utf-8?B?eDRMdVBJalBUTld5bjJlZWdVNEZNb2ZoZzh2bVlXT2V4MERyM1psNzJwV3RE?=
 =?utf-8?B?OVVaYU5leHVWY3ErQ1NYNlA1TmpmNWRhVXdNa3lUNEMyM2FYQlZJVjlLd0FY?=
 =?utf-8?B?eE9HRnJMdjcvTkF3SmRNdnk5c1ZQVUFmdkJjRytMYUQ2QmNITlk2OFJENms5?=
 =?utf-8?B?SFNVR3JaK1BHSUMwaW56Wm9wYndtNHJvUGtDb0JRT3NEUlJwdlorM3gxS3d5?=
 =?utf-8?B?Vzg4Wm1hMFFJd2JkbnRnbUEydUtHZWlxMGxCTm1tVzUrN2ZwVUtsLzdEMDYz?=
 =?utf-8?B?OXUxOW1QWXZtZlFpZUNCM1puVlBxQXZjSGNSZ0g3VENwekszQ0hNaDFVOHhw?=
 =?utf-8?B?N3l6citocjNQQUVuN09nYnpVQm56THNFTXFLOGNmT0lBWkxKclJ6UDh0cEVj?=
 =?utf-8?B?ZnpFby9uVnJ4MVJOdm5OblZCcEw4NGxDT28zM3BIZ3JsNVVZdHU3eG91eU13?=
 =?utf-8?B?Nk5nNTdYTnRPNnZYUFFCMzU5WklNTnpONTNZeHU5czFyd2tsUHpsc2ZoRjBj?=
 =?utf-8?B?Z3NGL0VNZUdENER1SWJmRTdiRVJQK1cwL3JqWmM1bVBVb1hLU1JvNWV1TWU0?=
 =?utf-8?B?UDE0YWxremt3d1V2bjNzdFU3T285NVRHQy9qL0tZSUdRY01mS2NGQXBhNk5W?=
 =?utf-8?B?TUVzajZUM3RvbFlQQ3VZS3pFRjBJdFhJTVBSbnBIcEN5cS9WbEk4UzhEYmJi?=
 =?utf-8?B?T3RUWlc0dkxMcUV5VjBTS1V4VHRGRFBFbk9EM0dlV2trdE1rayt5YlJLTGtO?=
 =?utf-8?B?YWR6TUp0Y0tnRVE5UEovK1BCZW1VRWhtRUk3SHJZMFluaUd6eVBxY2Q5dXNQ?=
 =?utf-8?B?bnRiYTBIVjF2ZFVMY0FlTjJEczE1bGJUOTYvN3J3aEhsa1BUMkVyQktpd0Yx?=
 =?utf-8?Q?uDW0j1SwXJdDTYzUuRMT48PvVmkcSVH2+W9m+OE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d2d6af-d011-4f06-e5b9-08d966b419f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 04:03:16.7090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1Tm4yTcnZuR3QtfbRtnIr8pP3P2lrxp/PmIEeS+Wf/+RZdBXPojyemoyehuwlXV9TRSAznkHxps2ALaq/rkvuKLr+2JDXcYgTnMNgegujw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=634 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240024
X-Proofpoint-GUID: UcWSt8345EinevkEG_7oValCqAtnYW0k
X-Proofpoint-ORIG-GUID: UcWSt8345EinevkEG_7oValCqAtnYW0k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 3 Aug 2021 17:54:08 +0300, Sergey Samoylenko wrote:

> EXTENDED COPY tests in libiscsi [1] show that TCM doesn't
> follow SPC4 when detects invalid parameters in a XCOPY
> command or IO errors. The replies from TCM contain wrong sense
> key or ASCQ for incorrect request.
> 
> The series fixes the following tests from libiscsi:
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/2] scsi: target: allows backend drivers to fail with specific sense codes
      https://git.kernel.org/mkp/scsi/c/44678553ad7e
[2/2] scsi: target: fix sense key for invalid XCOPY request
      https://git.kernel.org/mkp/scsi/c/0394b5048efd

-- 
Martin K. Petersen	Oracle Linux Engineering
