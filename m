Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF317C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA350613B3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhD0DIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 23:08:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36728 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhD0DIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 23:08:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R3760P071510;
        Tue, 27 Apr 2021 03:07:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4dkNZNDIyD91sJZdK6vtPVnEhSgfgCzj3H6Sk0b8qJo=;
 b=Z6Rhzha5lPd/sQrsRMaf+WcolCfGBTJ0MQM4Y92jRgAKj0fICfHTDss7WqlbWGvMePAg
 SxlGXzikuJJCLG0kq844UWGZs2APwXB5HiJF9/QYJKuLDMXtsRiBVzgRLb9byEOla++t
 ZJUTeDcSPomEIM/y7zU4n7KyE4VYlEVjoTsbLCWRaBMlvxOCIQHTsNAjdHLuqMU09XLp
 L+ZoDsk/664hln6wRm6lr+WDRPoZ2LXTafsUwl4z63t2bIlAZqHWlj2aTLorKZeD9STh
 n7147a5yGtA0hbmx0wLr4WudfnlQ8dg8n1RWlUr7SzH2IAIz/7v+nlkcYNrMFEqGT18D MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 385afsv002-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 03:07:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R35hYD147009;
        Tue, 27 Apr 2021 03:07:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 384b55r9nh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 03:07:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nt/a0lKITQyMu4nsWCd0adfIGjYP0JwB05oYH/Umh6MXAhatfaKkg3Nx5OwXzmW7VrtnKelp372UwlvZ0hwykuI0Eob+uhQblXOhzJBlHBkxu4WbIdTnxdBDt0q9yC909OhlvVYmXWzVHkZq/PdbNUhQkJDVfpt1Xe9Q48qC6abS22Ci2Sh4wKbeGEYAIpjPZcioIGAgWEBdP0A/C5G48Z882iJcRTYHWIaEcI4peYQIreD4xfWkjtPdNNdYuLRrCOAZcC5zbL9hisNWjwsXYpUnQzJ0fJS3y3qmJzSHYViQXZGckQ3bEoAnaGG4wOeatMxXpxc1XSRUrBF5XXysYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dkNZNDIyD91sJZdK6vtPVnEhSgfgCzj3H6Sk0b8qJo=;
 b=bauhzCDFsPK9nWmg38RamhRoesXqPrZlso0ahYu9jvtPXc4Uadt4Ldl8xHBvhDkORfK/wtcY33kxkCl/YTNW2lQx/RPVNl3fLOPPChxp/JS2bx61HiFj5yKj8euoz75GHBIu9ZuWS/7rYcnF6gGAfXQFCcYUX0+v7CWffr8N/Zv41M5M0ZzktKTHN300GQxeo5LhRgDqDvJU/q8yqlJaaZ6rPIi82IV4naV3z4C2QEombYYxO3lBQJ8J+rcF+Kzu7vJMqwcjoWakrwi7R7mM1F2UyhJemZMT8267g+iZu/d4H4stRVtjVzLA/rAjDJ4p9zDqx9Gj264sXP+LxZ0aWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dkNZNDIyD91sJZdK6vtPVnEhSgfgCzj3H6Sk0b8qJo=;
 b=mbd989tEE0rLHU3NunRkavmrjVNbWjAReHjbgmGdaPpv+Zgw7cV08R4PquP1Az7P8WU3tLpMdgUMd9rE4vrm4jxGq+WqakqlHiJ8vAen8qVqQpGF2iurjjhVaP5PyJNWngwxLdbKbspvU1U6GxdJdFh8rdBGld9z/MxjNj6Djlo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 03:07:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 03:07:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH][REPOST] lpfc: Fix illegal memory access on Abort IOCBs
Date:   Mon, 26 Apr 2021 23:07:25 -0400
Message-Id: <161949269497.28290.17130201015168196478.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421234433.102079-1-jsmart2021@gmail.com>
References: <20210421234433.102079-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:806:120::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0043.namprd04.prod.outlook.com (2603:10b6:806:120::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Tue, 27 Apr 2021 03:07:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30390edd-66d9-4379-4993-08d909299848
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4501B3EF41DDB47385041D3A8E419@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDdYVhs1bfGvt7A/fdUyCjUt8Dv10m3eh2iiHGZIvXn0Rof2Y1od5ow1fZkrQtxWElaZcMCvBG39OzO7HkNCnDip64zyey+skuaiwDXL7oyR8vf3/MYDdTZUvyxPvQfu8utPbg+9JEMg2r9s0yf/o7cPAWKmHS5OibeKT8P0qIRZZ/ToOjPSWXxI46wBycHh6XcLI8Qdb7R2uE+ouS+D9vhy5yzpiFyNdyDgpSlF6TpB0UzeaQX+o/bMByreYKTdaLd5i5/ifsC2nxVVfF05fk75FVJux39cUsUabRAxXZ7hRkTFJjc8xwXQ/GEAhjTwd3LcgCHE1q6Fk6ni8+RlgXeNhkf5SdvOnetdEr1E0jEKiSg2wa8eLmVw11jSVUdAn3prOZw27H+F577aZSDA2+Ym5CL6suv72RQ3ToHZpWtF2yBgK4E2svWzXbHwLz7qWjh22M8nXiR8RGIPwsoeMgqjwI+q/qLaaZSzcjMzgZabBmHjPUNlziUZaUFUd0aXKr8UhR8l6urfkusY95vCUzkInVu5t2m7Nyolk4FtimcAXoU8EZXuFJh/w7S8oP/ab+E3aGQ/4JyjdR3e6Ql5O+myRgn5SnnsRmsbphmcvnzHFO9zzxGPoghskyAjv/c5p5rj81F4O7FExjwx4B0PzWBocKmEbyFclfehKjKJg3hHt2KlM6FpahDvWVPHamR1fw+pOoNbu953gKypDaKKTgmxqzPTWNQ4Eje+i3gz0Ec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(103116003)(36756003)(6666004)(6486002)(26005)(4326008)(966005)(6916009)(478600001)(54906003)(956004)(4744005)(186003)(83380400001)(16526019)(66946007)(7696005)(86362001)(66556008)(8676002)(52116002)(66476007)(38100700002)(38350700002)(316002)(8936002)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cXhCUDE0TEZJVEMrRnFZNmZydEl3TFlVajFQK1hvQ25RTzdWNjRISGlqWnZI?=
 =?utf-8?B?TnUwaWU1Mm1jMVZCU05iaVNvOVR4SFZIYk1tY1Y1ZUtMamFmdXVYRE1BOWtE?=
 =?utf-8?B?Ky9mamNVdk9GWG82dnJWdEoyZXdJY0RNZ0lPeCswd0NrMExKYk13dnloR004?=
 =?utf-8?B?Y2hvaThERExNMmV0VkVNTUtwVGtvWHUyaUZZOGZyZDQ1Q3JSNHdlV2lYL0pE?=
 =?utf-8?B?ZG1yTjlJNXBIc3F0TFNyTEN6a25aSUV3dEZlWG5tVzZWMG1zdTVWYzFveUph?=
 =?utf-8?B?RkFlN1pZQitHdkV0RXFMWEtqVzQ0OE1GZTAxUU44Z0JNRzJrK3p2N3FEa0ZG?=
 =?utf-8?B?eFhMV29wVU9iUXBnTlVTSmtKR2JyZUFKVnM0NkVyc0NTTjRMZEFWZkRkL1pp?=
 =?utf-8?B?OGFBczV5MWtRVThweDlLWjdNakE2cmtUb0o4SkM3ZkF1aUF3MGNrWUdWdW1T?=
 =?utf-8?B?bDRxTXNnYU1GdWJCOEZrdjQrU3hzWFZRQkg3b0Z1SWVhdjZXTFJjMHZoS1BW?=
 =?utf-8?B?eE9ZUTllYTIyNFJoMUNLcHhYMUh4eWRWdDhDQVVnYUlPeVJ0OFRndjF4MnVr?=
 =?utf-8?B?TW1TdXN1dDg1MTlQMG10c3l3aGtBTUdwWDJVcUlpb1RMeFZ3R3QvUjhFdys4?=
 =?utf-8?B?RWs0NkVJcFljUkdDaVYyN2gwdUtiZkUyWTR6Q0dVYXFWUHF5Qk9IQ05VMjY2?=
 =?utf-8?B?UUJzek10WE1rd2RYUjFiRmtPK3BRZFdZTk1SKzFrZnl6ZkVSRjdZUUJIdzRL?=
 =?utf-8?B?MGMzUm8yNW9aRG9Ud3IyUnFRdTZITFVRTEVJSy8xWnVpSnR0Y1pYcjdXR3JG?=
 =?utf-8?B?Z0tGaEV6aGU4Qnk0d25lZXdvUy9za2M0MXozY0pjN2JEbTR3NXh5djYybUVC?=
 =?utf-8?B?NFZQTDRLVzNsVS9GNW5xNWZvSnVVSUNXY3pUb01SWlF4SGZPMlBLSDMyUXdq?=
 =?utf-8?B?OTA2emR4Y3VZaW12Yk5lZFZ2am1vMmRCUFRZR0dCOS9rMVBKaTNtZHBvOENR?=
 =?utf-8?B?bjU4Z1ZwbGU5TS9IYmVBVUVYd3dDWS9kbjY3WHVxK1JmRTkyK1Y5Zlc3UENr?=
 =?utf-8?B?R2ZIMlp6cGZwOFI5VmRqL0JETitZWGxFc1pwbHZ3NERpcVVXby9zYUdqY0FV?=
 =?utf-8?B?L21UVkRRS1lkMU85R1QraEI3aUNDalNxaEIzNUpEUVN4SUZ1aEZWalJIdmIz?=
 =?utf-8?B?eVB0MGwrR2dkTk0vZkFNYld4bktNVThaRHgrNENDSkFDVlB6U1VaQ3dzdXh4?=
 =?utf-8?B?NEZtSGdCU25Pc2dBa0krME1XSnVsM0lMdmVvMTZSbG5kSlJCaHc3Q2c4Smp3?=
 =?utf-8?B?RXdXckNvZ2swdmJ3Mkc5WGlzRlF0c0ZVT2JYdmRHSS9sTllJN1BQNXFhOUlx?=
 =?utf-8?B?L1Y3NndWbEd2bFA4QkVUcXZSamxRc0VyT2JhNEs5SjlKSGtwOWxQKzZmY3NJ?=
 =?utf-8?B?dzV6U2tzQitHaGFTTGY3akR3N1V0SDdQemRIZ2lETG4xdGlOSUNiUHg2SktZ?=
 =?utf-8?B?NWNKR0d3K0JQL3EwUGZZb3MzTkJucTR5R1k2c2hOOGwxZDJhb25odGJ3UjJO?=
 =?utf-8?B?SzhqaTVRZy84ZFpKSGN1amRsSVpxVVpwRFJVZWlSM1pJbVFsUDVpMDVlaU9k?=
 =?utf-8?B?WTZWUnBkd2ZiQUpNUVV0YmZIbUhsNWM4TTZjU3JhVWM0ZmY1blpkZkxDRzV5?=
 =?utf-8?B?ZWc1VHI4SEx6NE84MlNISHVoUU4yS3FqUTMwQzZpem5ZNTYxSFZtSlF4YWFR?=
 =?utf-8?Q?3dzqmLHEt2gwPgMlGnQiOFEtHeGj5dinvoIdJ3t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30390edd-66d9-4379-4993-08d909299848
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 03:07:30.4611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhJs4fRhPxCPRNjMhjvuZNcyMMBmEnAykIrpaVkHVjQOhX7/VfHFTW/PL59QtXBUSYugr2Qn7Err0ItlgW8l4ZwI4faROe9bOt3I1MR8rjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=943 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270020
X-Proofpoint-GUID: 6qA7bc49nOpphdK_qiX7TcHnHIYLnnoh
X-Proofpoint-ORIG-GUID: 6qA7bc49nOpphdK_qiX7TcHnHIYLnnoh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021 16:44:33 -0700, James Smart wrote:

> In devloss timer handler and in backend calls to terminate remote port
> io, there is logic to walk through all active IOCBs and validate them
> to potentially trigger an abort request. This logic is causing illegal
> memory accesses which leads to a crash. Abort IOCBs, which may be on
> the list, do not have an associated lpfc_io_buf struct. The driver is
> trying to map an lpfc_io_buf struct on the iocb and which results in a
> bogus address thus the issue.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] lpfc: Fix illegal memory access on Abort IOCBs
      https://git.kernel.org/mkp/scsi/c/e1364711359f

-- 
Martin K. Petersen	Oracle Linux Engineering
