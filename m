Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEAAC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5876B6161C
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhEKD1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:27:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhEKD06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:26:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Eekl149554;
        Tue, 11 May 2021 03:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mcAidMM/6LTBHUpz0YlHOJD6oxnl0v3J7hTiSmu4x0A=;
 b=ryS7I72WXAgXyXklbXFLnGgaVSq/JIIxIvf1zNwcw9NFz33V5FX/WitIKsIWaNm5fCRp
 r7bn4oOX9ax9D6SRNMtQasOdc+pzSBa1k3hUa0saWPKgoqxw26Kg27hpGPlvBGLC9XRm
 GZK2dDBqrJqJ+kpgy6j9D2y7RAFIUgEj2PD6PcsMyuQGRvKCouilragpmztR0PpakffB
 SDpfQlIkEP+2g3/47+fAeAHKaRLljhDxzh2JHPP2+DGnuzsn/kg8XytH6aTROOA72jtC
 FmRmixTWj1YAosVHas9/doV2QgynU3KQ5IHXEHk1ZZ5hba/824ZqX0CNxteuQT8VvtqH vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38dk9nd7c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3FoGQ103196;
        Tue, 11 May 2021 03:25:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3030.oracle.com with ESMTP id 38e5pwfpat-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVWo0Y6FLzkuvqGDs8k3dWieM3LkGS4ZSJNG5MzMwSRlNMCDh7PKuBRyisZHENyZcyCWeKkeWI0yDs2T+zLbmKCj8sf04PU192L5S/FNGpakXu9GMb1cctuYtCSD3yTr3oqMg8s5agYrLk/q5R+DtW7UYA9a5QbrEtxbIdrMeU4sz16xGTyPpNRJDiG+SJ3bZLpZ/47b3G/BnkgjtiG5Zog+vKEw0mMUCE5TTGRjW3SrmPoScNSoD3bK3yRpdZahb4QS3ubrZtK4dlejLn5vM+HNRKww/s9bdgaycAt2FUR47THpJcShvV4TRgBRrVv3xcBMBTDpxh6mAKH27PGPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcAidMM/6LTBHUpz0YlHOJD6oxnl0v3J7hTiSmu4x0A=;
 b=UliJZf1gjfUWeuyjvUHXATIcIqZxBeUANVVJ6eyVqWJjN93fgvmqBceyZk+Svnl5SmXUCO8Mtxj3X4yb6Btv25XAq2v9FbhJjLEBXuwxz2O+ty8Cp3Cz1P0ocRqC1ytP+0cCckl9kY1ezhf4gFgNYh6q3WETDYqElsQqkppVWfWTm9JizGLDGXdVjsGYJiT8kWjavU2qcwl6yH78spXA0ejGYtHaN9GekCraFoUtsFdIcLoYFJeLUje2OTg4CFV1TqvRfh5Eas2/HlCfAG+thO6AkXDHGwzMmUzn8JYcXroyR51rN/kpnI8haqLMVLRf1F7pnanLj3UxkH6V3jFN8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcAidMM/6LTBHUpz0YlHOJD6oxnl0v3J7hTiSmu4x0A=;
 b=mGsJKPSP2+DIq0YM3RIUExVhS3U5dWXSPsCc9M0i2QyK52z4Y/6+jE+EAhhvfFQIbX241bOdyusl83QjPe7DFM6ZWekgHpqtLfo7dhFlRGoqf8vrfjtUippykTGoRyk//ywwrPuFpsvFn7EYOtcbkuChqOhsKUQ41UtcLN1FUIs=
Authentication-Results: microsemi.com; dkim=none (message not signed)
 header.d=none;microsemi.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with flexible-array member
Date:   Mon, 10 May 2021 23:25:28 -0400
Message-Id: <162070348784.27567.4297596089347883095.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421185611.GA105224@embeddedor>
References: <20210421185611.GA105224@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79f9fa30-9c03-4503-ad69-08d9142c75fa
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44086EE001D288931B80B26F8E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RV31sgEpNaqf1VqeKG/z8HM1p578KXhrLUxCJ6DKSaqXO0RH+MZXH5Lg+G0uZyHL5G/RVfWaQkWl7HAuzZhO+AsbI8+/7X3NIRcZP8tivdTOhnlkJmOX2jKVLzXosO0yWs3DT0V5RRcK/rsRI3hyJvgs0gInjG/5vaTI397bB6zfBw1S7MhrkKXlNezjI/Rw5AfVB/JcX/J68g8GLJDKgKGZa5f6PrfAmEutgSi/8QwTvg76oUIhnMvlbZJ4aOfWzSDkJVLCNRMhL7U2k3bdhh8YRKnQmueoCeL7k8JG8+lW/+joWmkt3zzmvicm8SdHtfDh/k3Rw5lhVrRE637aLWs+UtgLN0sE6rycMsFDC4Q3uM6sv+HcFkk+k/y61t3xv4Qy47xpJmXnrHpCktL4kd0ihCcjsq/JRfAYBJl7BoG+DBRVVqpTdvaHGceBrt6Qxgrx6RQU4wJvbkBf9bagnQfXaV1eB5PNOI4kAsDKsGNAFDdLRor984RKxnColM2JTm28jeax95wQi/XLNRznJkzhJXM3Y1iMccllgEipDo7bGyqCG9pNQt4gSbtCUz9sqrCb5RawtbOLPW6uiY/dlTSDeo9lLsVAC8ZW4p4ADOgqb0/jDtKPW/Wtz+LHKIbkcnNh3j8INR3k3IuV3eRqpqGfaXCHbHejTxD2cLVeV4rJTtw6XD0BHj1cPBNdJGKGkdZ4xbT9+9aDGP7Mi3nT8siZofaR366gvkqIHMIw2jM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(110136005)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(54906003)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VFZDZG0wRjFZWjUvT29kREoxYkw4TnorYXdCdkhRUjNiU09nc3duSmRXcmY3?=
 =?utf-8?B?MVFmNFNELzdPRkFna3NFRU8yaDJpVUdmcDg0M09kTDRKZ0hqQWUrKzl5SUdP?=
 =?utf-8?B?SmlOT0R3dExGSjNOcTBLdjgyNWdieFl0QXM4QWxrd3hrQmdQdjJFeFR4U2dw?=
 =?utf-8?B?N1N3M2J1c1NaSi9qMWh4QUVGcDc1Z3pYWGFiejNPVm8zcnMrYjgvMXQ1cVdK?=
 =?utf-8?B?QnhhbGxNenlqR01MKzViaC9UR240MElQY1NLOE1NU1lsK2RMbGtCQ3NQK1ho?=
 =?utf-8?B?azhBVlBGVjVCRXRtZGJtRWFlRU5UMmJIQUFTWVJUNGRJMk8xNTI3TENXYUdZ?=
 =?utf-8?B?WTlvU0tRSXcxOXNpZkxqVGlzRlpOOXVwMHgyTDlQK0FBMEpNZ3VmdEhkQ1JJ?=
 =?utf-8?B?OUJpMHVqNFlxQlhwbTlUOEpRaDlFRDBGL1VJbFA4OUl2UW1sSXhOSGdNT0FJ?=
 =?utf-8?B?NzY4VUNlQ1plUDFpMmxKbktwQTMrR3NMR3FVMWlWdVVxWEhQazB4YWZpdVpt?=
 =?utf-8?B?MTZ4aWhLYmRzQk4yeC8vN0JDWnJsN3l5TS9TbnlXRWxpWC93NHJ0QVBYakJ0?=
 =?utf-8?B?cnJKSU1DRWh2N0lMeUp3dnJIKzB3VE9Jek9HUGZMbjUyMnhVemVGRmgzL2hY?=
 =?utf-8?B?RGh5WnprL1JxcHQ3U0ppeGlZV2MxTjU4d3ZCamc1WDdsS0tUNXhDTTZtcWxt?=
 =?utf-8?B?LzV4Q1ZGSVUyRzQ3c0ZyZjFqbmRKWHF0YUM3dXhxbWR4SzRYTm56bUR0Wkpy?=
 =?utf-8?B?MjlWZ2YwSC9Oc1RLR2J5MnNmSEpLbEdURWtEQkthVm5FeFRldmJEVVhFNy9R?=
 =?utf-8?B?dHVPR3dCMjA4TDNMZEpFOVV4NXl1UVIvUFIrYkNJMXpUN3ZIZmVGbG1jdVlu?=
 =?utf-8?B?bWtjbm9XMEJONUQzK1RlVFpyYjUwemszdkw4MjNiRVh4ckpOUTZJMytwTEx2?=
 =?utf-8?B?QjhRQ2x1S2NTQ3ZBclZPbmhhVEV1WHptTkMzaGRQWHkzK1BQQVR3VWJtMFlx?=
 =?utf-8?B?SEtQcHVucE9kMGdJcGV6dXdWZUtyVHI0ZFdOamg5eW82WS9naDY4M080MWVx?=
 =?utf-8?B?TTdaZnFIeG5RcUNxSXpka2xqN09wSldjWHZ1c2NiRGdkbHFnTEJwOHpnNSs2?=
 =?utf-8?B?OEpKcnlXcU55b3RxbFM2V01nUk9LbVRSUEYwVnNUZVkyOWNUMEttcnZmdU11?=
 =?utf-8?B?a3lwRGw1azVMSHRIZjFvNXVONjBkRFB3S281OUo4Z1phTmpuSEZQTXI4QkRy?=
 =?utf-8?B?dGpRZWo0SFdWQVIwTHJJVDNQZytoZlBNNmM1dlhSd2VTc0ErMitqTWJOa1M5?=
 =?utf-8?B?eWFndkZJdWs0VitQNXl1QlRVM1hyV3cyV0hKZ3N3MlZEdERFNUQ0SjdhTVIv?=
 =?utf-8?B?Z1ovNXZXNWlEOGJWaUxEWlJEdG8xR1FOc2JPN3A4YTNoMm9LT1N1c040OFMz?=
 =?utf-8?B?SkplUGYrZ3V1Z2lSR0JxcndJNXZwWUZMMUgxdFN2NkRLd0l1b3VJcG9vZ1ZO?=
 =?utf-8?B?SkNqOERHbEZCSG12eDY5b2hoM2NRWTRnM1hYVktHU05SM3ozazliaUc3amZL?=
 =?utf-8?B?K1U3QWdzRFVHdmJ0S1N0SWM2ZVVvNkVQU05hcTBYT2xNZEpGN1VXYVVyTTFj?=
 =?utf-8?B?Si83Y1lPVGVhbnJTdmlUMzJibmJQcTE0SEozRjl1U1ZQU2lnSFNuTnlVU2pp?=
 =?utf-8?B?L3UvejMrc1B2QVVCcjh3WStzV0t6d0tzVitQYUFZa1EwZmx6MUk3bnFzMTdr?=
 =?utf-8?Q?+HG0T6gBEHEy4UbfXygVpQ0F8vt+6WSYXaFGBbT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f9fa30-9c03-4503-ad69-08d9142c75fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:44.3798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djioFcvgYhM5aXIbWE023mYZDt0F3YHcW1SIOCrVec1Kr+6Pvmb4zLXhQrkZxPVPu5t3Pwpomr3fj0DBO3rupBKT3zdL5oENwUdvmcKJMY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=786 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-ORIG-GUID: D8O1i1CYyk0YVgxU1xWYJwoK8iKBjARU
X-Proofpoint-GUID: D8O1i1CYyk0YVgxU1xWYJwoK8iKBjARU
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=964 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021 13:56:11 -0500, Gustavo A. R. Silva wrote:

> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in
> struct aac_raw_io2 instead of one-element array, and use the
> struct_size() helper.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: aacraid: Replace one-element array with flexible-array member
      https://git.kernel.org/mkp/scsi/c/39107e8577ad

-- 
Martin K. Petersen	Oracle Linux Engineering
