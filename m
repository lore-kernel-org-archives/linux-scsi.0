Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B94C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA906109D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344697AbhDMFtc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344707AbhDMFs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kcUE010509;
        Tue, 13 Apr 2021 05:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iVeqdItdieCU7hUu11FNGr6AokHyxrpn5HI9S3L80ls=;
 b=zA/7sJnYQ68wubtiTD2O2K72Alw382wErUz0T9neSD9lWebvjK1oH+7vZAyMaH4/T7S8
 bxyb0iljtUhwpJNVNp/vas2icjZzcP+CHBsfiNk6WubKZYZmtpv80LNCniaV4JCHHqPB
 bfXWCEA2flJ0cogLVNRobj4ZgQ2gZlQde97intiOEV3CZoGf86fmThkxPgPfVs3xPtAG
 lB69q/xJ8jHaMOiXXhuxc74psZoHxbUPZ6kCdDu/d/9psShH72A0OxmzEHZZTeuZksCB
 +cLhWp+n+SsblsSQbGNkO1Y3vq8Cd0Z6rR9PQXBcu7H8TQ12bwAFCQ4JXHFiQTWDcmCf DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbdxhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jcTU125410;
        Tue, 13 Apr 2021 05:48:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3020.oracle.com with ESMTP id 37unwybxpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1tOVHK/Bfr6ndvpSZeFTENGgROqyGNOidfcKB9cPLo6ujg0hi3ttZMD2a6E5qRjuFA8M0NUnmc1hNHgSP5Jeo8aJCrNQAETjzDAZnEhctytyAYa62aLAc+t/pYfa5IJmPuePuRgvLmPeLN/x2MiFVlCA490D2vR5KgpSR3vFIFpcwzt3Vbhtjto6j4PfYCG9wjE3fmN8byu7hvWHd8uqJn1Nyt+qNZxZbiplUL8kGVBUfEm2acxAcR06XqJrV6xhv2XJV7raTuY99/4DhB0TjFaNMtvt2YJKZoA0Lzp8Xgg26Rco7SxRw+lzrre1R5RkKqTw62OQkC9m8o2gVI3Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVeqdItdieCU7hUu11FNGr6AokHyxrpn5HI9S3L80ls=;
 b=WwR5b/basjFWpUUjo4UhQg6DLQCMAUw+ZeqwyccKKZlVY3nRoCo0++ZdvPxUzH+5j1oqz6ZxjiUp6VDnbYWcF/k2a1Fv+pXjoZ8r2Q0oAbh81cMu4C402kHoBz8oR4wQGZKuPp68v7t6eHQpNThRDhqMNZskc5q22ItGRIurAlmo4f+/DiolvG7QTF8S3BOx+swrBj/I+8y7UbhjIDrzD1adQITseGQO414jiULsSHUrHIcxjNrgE2lCMYlHybxwL7toPbkenKhst5gkp8jDxPj/6V/6QoJZLuMzg67dnKP2mgxHbkzzTq+Nt2cRjS4ofPQRkG+/cogSSP7ZBzlZrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVeqdItdieCU7hUu11FNGr6AokHyxrpn5HI9S3L80ls=;
 b=YhCthLT35KxGz8s/ZfXjodMONba4gSB6nnoOOJQ1ll4rpziKnN+b1ym9qSLDsuTEPMDs6SjilGoNLSsd9jD++EHoD5fQIzYM6AWOdhY6ABnO7mTg4e9HryNkLf3XfZPDtR3MvbNxaQr65JGDNFD686gNIi5eOA/NYT69tB3QqnE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        zhouchuangao <zhouchuangao@vivo.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] message/fusion: Use BUG_ON instead of if condition followed by BUG.
Date:   Tue, 13 Apr 2021 01:48:21 -0400
Message-Id: <161828336218.27813.4188751217575211524.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1617108361-6870-1-git-send-email-zhouchuangao@vivo.com>
References: <1617108361-6870-1-git-send-email-zhouchuangao@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21abddfb-e848-4348-4b06-08d8fe3fc841
X-MS-TrafficTypeDiagnostic: PH0PR10MB4727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4727AF981E72FE35C9B613DA8E4F9@PH0PR10MB4727.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNMk8XmqRr/A8FEtQr8BkJa7CEcmvCz2VLfqHIsdVq3wwdjRyZOPKEpO5N6AgQvMXUNJCyucLMVfO++ltXNSWBsObSuYEPtB29EvzN83oZOVyj/OPsEodJNCnfXmUM/RBi7NvDdotmfJqT5ANeckX/0h4wxAFgXfa1Ib8YzDOKGlNIO8sIG2FTlKfgJ7ZDURohyQjXQruSMzGHg8UwUdKVfejmJI5aNm63Tu3x7q2ZXSGILH/irP8dntnWeJfCa5EdMVhkY7z63kicLwvwy4VeLFVel2RcE8wfUN/2B7uGIMV8kyKOWyGgvWmjnwGD01tncS7ip0gZs0Zq3Avi9F94Xf5Z3DtVDzcd4e+fLNUGyG28lBG13hhK4bO5wVSNIMAA1lc+AXnSeGdp/AdCXxD2P7PzRRd6mdKfPjMu2Wl2GzysEkJLvrLStb09aCnEc1TBdUIO5Wtu8GVnJrmx1lXTORZtVSvBC9dF8yT0c2mjuc96uabOZw2E3f8M2Mu8o+P/aZrOHd9F8xtkNp+EB+a5KwZxWp+kngAASpsCo1E+Io32DVZxzz2/Pftpyb9cpljRyLGTvORO8Ud3pTlM8qSBiGscEvo5YFZfYGYL9paLTICNozlbxOqej9IXDLanz/hycv67CPm4krefjUhkCYzAZLytMSR9jg5zILCvZNPw68KliXKGfEg5gXOfEAFKupqk9eGsjhX6lXLiqAcoPfnpQlJcS6yJQvyNFgY4CxoZY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(136003)(376002)(2906002)(4744005)(26005)(2616005)(186003)(4326008)(36756003)(38100700002)(66946007)(38350700002)(478600001)(6486002)(956004)(5660300002)(966005)(8676002)(86362001)(8936002)(66476007)(107886003)(6666004)(316002)(66556008)(110136005)(103116003)(52116002)(7696005)(83380400001)(16526019)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M0Z1NHg1SU0wTG1tRU0wYWE0YWVMb0xLU05JbXRvTW9BYXBVR24vbnUxeTBq?=
 =?utf-8?B?bkxQenlsa212NUU4eFBHWTBwRmFsZTczSjgweWJXZGw3dzAzR2JZS2Q3eEMv?=
 =?utf-8?B?cWZ1dys0WlJkUjZjaWNXamo0VWxNOEgrcDlRbS9hWGJISUpBQTU4T1M1cnpH?=
 =?utf-8?B?eW11TW53dDQwVXNkMXhJVHY0NWJjanFuQVRSM3pIb1BMemlqaTA5bTFBcnpY?=
 =?utf-8?B?ODg5RXhmSWovb2RRT2dJYUFlU2lCZWJacFZ3b2U1d3QrZFk4eXk2Unpna2Ix?=
 =?utf-8?B?UHJNbkhQSzJ4NE4yOC9MM0NidklYLy9Md2h2NWtvK1FsK3NFSGZ3dXFRVFly?=
 =?utf-8?B?dnNsVzdOL002QVBEWHBNR0EwL1VYZU9DZVBLVmc0OUpzWDhhTTE5SVNzWnBM?=
 =?utf-8?B?R3ErUk5FR2x1ZW9zYWxHWDl4OU5PMW1RRGg4M3lxQVdHaVFFTVQrbDRTa1Ns?=
 =?utf-8?B?UUxzNXNjQkQrU3ZQWnZDUzF1cXEydHovNHJmVGZFdzU4Wlp4akFla2V1NkJQ?=
 =?utf-8?B?Mkt3WDdIN1BjaHlxOU16MVpIT2J3RFZSUGVBOGg0L2Q4dzVXUmN3YjVkY1FQ?=
 =?utf-8?B?d1Nvd1orOW40UkNYZHVjTTN0bnl5dWdtYnVTaWY3TGZycnRSalRzbXM1TXo1?=
 =?utf-8?B?ZEtqWCtoU1I3Vm9sRm40QmZJekVDN3FBdU1PNHVacnVyd2FyQXgxY09oY3RJ?=
 =?utf-8?B?QnUzMDlqeENWT0wveElKZTdTVUNlSmdybFVueGZoMVZqTy9POEtBMys3Slkw?=
 =?utf-8?B?WEJWNG9nS2VpbjBXSlFHMjkwa05ENUcyellydWF0T1d5RkUwWUpqUlEvRU53?=
 =?utf-8?B?U3BPVzM5eG1OTkhqaDY0NnFyRi95aDBQa3lZWjBidkdSeHZDV3JITExhQUxo?=
 =?utf-8?B?WElDV1VkRkdxWEtROGJPTVVON2tpQmhueGhUQmF2K0duQThKc0l2MEpqNjYy?=
 =?utf-8?B?SStlQUdiR2VpN090WnJrY2J4Uk1LY1hQRk9yUXdncTcwbFlsQkx6VmR4dlkv?=
 =?utf-8?B?cVQ2a0hrQ1VzaHlKbzlDSTdYWGFueWN0TkFoSHpzT2MwMTZaUUVhdnNMRmdI?=
 =?utf-8?B?ak5WZEsxNzc2YVdaL3Zsb2dITUw5dWhQYTA5aHZvMXBSbDlUWTNTNlpqWHJv?=
 =?utf-8?B?eE92cEtmM2M3QjJsUXU5cW9KUWwxbjM2RkQybTA1N2VMZTRnekY2QytObGlS?=
 =?utf-8?B?emJoM2twTFV6Mnpaem5ISTBUN2NSenR2eTAvVDBPY0RiaFN1a3hodlFNR3I1?=
 =?utf-8?B?ZldTV1pLMTloQU0vVnV4emoveVVseUVtODEva1VUYWl1RTFNSjZIL2F4Zmdp?=
 =?utf-8?B?SitSckpHb2Z1Ylp1Vy9McEhYcXh6US90ZDdObXBMOWZsM2NpWXRPTSsxOGo3?=
 =?utf-8?B?Q0RDdDhkUWZSZTZnQnJKSlpTN2xiYlh6K2laeGJJWXJYUTNCWUJuM1ZRek0y?=
 =?utf-8?B?VGREQ1A4SGRTMnR5VUQrYlk0aW05UDdxN0ZBSkdIYTVwRExhcDVmdE9HcTNh?=
 =?utf-8?B?OEMrUUNLWlRNUzQvRmUxM2wzZFZTT0N0S2lZT2FIVG0xaGFQQTg2dWx5QnZV?=
 =?utf-8?B?RW1aamQ2ZFRlN3U3c1Y1MkpvcWxlZjIzVS9QMkQ2MzdaVFAwNktMdmRzNTM2?=
 =?utf-8?B?L3RVV1NKRlhwT0xOaEJVVk00OC9Eb3RUemJ0aWZWaGF2TGdmRmpjM3BpcUpH?=
 =?utf-8?B?L3ptVHJwbWdnUWVRYzRpbTRNWmlKaER1cjExTDFvaUF2ekZiZTBIdDljRnla?=
 =?utf-8?Q?+5rj4UB4llX/YFSn+FvVe0Qemeziz/h7yIxJUqR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21abddfb-e848-4348-4b06-08d8fe3fc841
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:37.0824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSGubJHuy+CoOmrVOo+nibiIGWO2gj3xf+L5GEKMX2qNZv5YdU6d/CCFELFlWYIXigFmciAV3hPiNyYcRiTgLGgLM10ZuT6zGM5inO4Yy8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-GUID: SKQm4AVF3oqsdCHOjr8DiV79XVwgsBoB
X-Proofpoint-ORIG-GUID: SKQm4AVF3oqsdCHOjr8DiV79XVwgsBoB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Mar 2021 05:46:01 -0700, zhouchuangao wrote:

> BUG_ON() uses unlikely in if(), which can be optimized at compile time.

Applied to 5.13/scsi-queue, thanks!

[1/1] message/fusion: Use BUG_ON instead of if condition followed by BUG.
      https://git.kernel.org/mkp/scsi/c/4dec8004de29

-- 
Martin K. Petersen	Oracle Linux Engineering
