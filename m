Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E25C43460
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EA13613BE
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbhDFExo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:53:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44200 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242527AbhDFExn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:53:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364o5BS161661;
        Tue, 6 Apr 2021 04:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=22LmNhD22ctRNYyYpeMQO3PFdJ/qL+yU567ZCCT72SQ=;
 b=C6gXObRbgtqN8i1VifsKRBsfR6v9jHTKzGG/96yor9j07zKAUhlQy1mDnJl8RbZYXxNJ
 ynbKbG2b625KBnBQrZvuSyrdWeImC0DIqSpR+84naJgkwQQuKj0N2PLRp7wn0GAyYkBl
 tm/wZSFbtsNoJUYfd7Njz6nFk/LBT8pm3i+E8cX1NXO6RwrKeTeBQ5xlEuK5XS/bd6IV
 Qyc0iQwoueWuR0IodjveJQHeZtyx+gxmPwbyAldIO1olCqJ80VbUUJj9ipLQubcxFGlf
 mUd5fb8hPD2+c9uqqzBlh8+KgtHk9Fbbkm/rGujc47mtpTLkzwkME2EUDtCnBo6xv3W1 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37q3bwm197-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364ox0W070460;
        Tue, 6 Apr 2021 04:53:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 37q2ptrhk3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnZ6GUZWR6lp1muvDyGwy8UNOIPAadmOY9sR65LejqhuAGKjWK/WSo1QG+2TVb6VXsxBrHPZsDZS9g/rsQ0CSAYJCsmhlK1WLF5vs4cjX9nRVbS0P3BdmhCgbhtGR4Sf7KVEVJJ+cg5hBNF1GazaD1hfW6loKYXyEbTxkXQl+wUXL+uROgdxvV4RGGWpbW76I9ZehBk1LG92KlwngltNKZ8iD0R/XfgIWiZlJAHCiyuZlc+TKwGuHPQbDQbggc6199OhudnU9uxHpxP7c0nDxgFO6c2ouP1f0AHahv+OBlXhbvwBrCJpCo0G2ZW3n9+5zPzi5B+uFiNZQkwvMPMSjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22LmNhD22ctRNYyYpeMQO3PFdJ/qL+yU567ZCCT72SQ=;
 b=kyP74ymA9ELBm+9J/A1DSbqSUKSG0xM5iyROjUIg5Ti+ZST5GKZRS8fM5F5MLTC05md/xVl3XBvtFPs5ZP2a0PFoiJcDmLX/hftc4gHEjpHeC0KjQPdwlc2rqeDZAbQwfam6uklrZn7HIrjnP/0IbIlA8IuyPLMSDTqzRAdTeCecxsFJwkMAv6K2JIdqFhIrKv0TA+aVUJ2JQAxr/rk04FzDEPIWtz5rHyPi84d+Ao6YVyLrefG1H2Gs3Vz4YSd80DsLz76NUcjPRAJUAxgmzJUb1CUAXXDOrGAKGZFYfeCrTC0kUWyKUcsdBmaoP3ucCT+vZZFcOJJTe+1RIbFRYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22LmNhD22ctRNYyYpeMQO3PFdJ/qL+yU567ZCCT72SQ=;
 b=CrzFanrS354KKgxhmBmLsImewSvrZfs/dQhCmrF0n7oQjtuk7tfGQIXFbgccrtFZg8KBkfEwPvxA5TyTkyxyGR/nAb+J0HTCtEqQsPGlH9IQ2N3PfBIX1xdxK6/EE7wG8IC4FReCYFpDPGP5HNYuDb8v0ir3Cimrl4GnvgZ58jc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:53:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:53:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mvsas: avoid -Wempty-body warning
Date:   Tue,  6 Apr 2021 00:53:19 -0400
Message-Id: <161768454091.32082.16582764474328607991.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322103316.620694-1-arnd@kernel.org>
References: <20210322103316.620694-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0193.namprd04.prod.outlook.com
 (2603:10b6:806:126::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0193.namprd04.prod.outlook.com (2603:10b6:806:126::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 04:53:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0db5aee-600e-4230-75db-08d8f8b7eb80
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4407828FDC422773AC8D76408E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4i/yofCh9qlcM8Z2qUsSl6vgi88ztHGM0YoHP13Ut+CYcY/rb4+eHuJDqGzA6xjIcD9/iUspTWCwL0YojLp3t1M3NxD5J7BBceKA1Y4/LqddQdtWLPzzWYMpZZVreI7Lky8eGnzWOZ55DMU/couJ7Tcz0Pn98iK4WfGSRe2qdP33Xo/x+WfYksUZ5uz3jeq/KGURvb0f7Dq+3LobUs7FXD/7tvd/q77nS06cR4NLUzqfuUW1//rpiH4ZCrgfZFsiErHCw0maluosfnk39+7wMFtnwNyXLiXwpkjo2OuZL9c6qfpNTNETfsZFeuMeaxDgJVSJGjqopFDnXVNlAzzZTbvGMhgdBnu7D4YSjy+SJeCJumEsiC6xRUHNP6wf9mj5vmNI8Ib2sTn4dCZxVEzWudoIHlnOWxEWpm3FY+CESfGd89ydA8ZbUPEvvjTHH7d1m0SfodZkCu9KzV0XIhgcuhRXosJZZHTvNVHz1iCNx/MvoD616h/W+dnpP8FtfcqBu35pSZ64/V+BGcAnXDJh5A/m9RUIZQc52i2jfRgEibOhGzJR2w/TP8f308cYUCjx0cxR8ujWOZpj/LK79mzr9m27Y2K1WkYSpwrBsLz39XdzM4Hs3CQtSMhVng3Jsj6Iuzqpy7NPAxoKTaXJPqiC5RHUayd5bXXupGvIQsZkulNTO389h0r6DgkIm5UD8QMSd727bRNwVn7Eo7tmIDEcKKVTXK6aXsp3uI5s4UsaNOC4nwv08ecTH2ctSBkDKGAD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(36756003)(110136005)(316002)(2906002)(38100700001)(103116003)(54906003)(5660300002)(83380400001)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cW1RcU9BS0xlUGo5MFZrTEpCaW5ZYkZ3ZC96YVVCYmlSTGh6QVZzdnFtQnRz?=
 =?utf-8?B?dlhHaGVLSGxnTEtabk95dVhtQjIvNjBCajlabUFveVJ4VFQ0YmllN3NrUHRv?=
 =?utf-8?B?VW5TK2o1UXRrc3MxNmpreHpIY3dvSGFoNy9IRVVQQmZyWjBjTkxXR0hCN2FD?=
 =?utf-8?B?aUFWS2JZNU1SL1JCbWJ0Q1VZQjZ2ZXQyS2tXU2d6NEpTUVdTMkt1SmZhcGVZ?=
 =?utf-8?B?MUFxRytmQ1Zsd1hPRFBzdmFvRDcwcjNZTHhnS1I5MW5kWDlkNTFaUk1RMGtL?=
 =?utf-8?B?Y3lTeE81aVE2WHV0ZWcwL0cvTXRHdU1LYllpbERhYjlOV2I2TWtnanIrODAz?=
 =?utf-8?B?ajN0SnlXWS9jd2tMU3haeDM5YXIrNy9jOG15N3lPRmhGbVYycmZpc0RRSU1I?=
 =?utf-8?B?S2ZvMEFxZzBxR0pmcnpJNzk5Tlpub3ZSc1lsUDlzdFN1WmFvSkhtdm9rWXV6?=
 =?utf-8?B?Y2EwZ2FHRFh6OVNRZ2NvYjE4VWo1SUpNK3AvQjFYZW12Rms1d2EzNEx6RW1G?=
 =?utf-8?B?OVkwN1RkeU5naUpMYjFiWCtRM2tzTFJmRzFoR0lQZnBYRkdPVGhLRkhNNHJi?=
 =?utf-8?B?QTUwQ2ZDVXk2UnJNcklxWHkwRTBwNW50VUMxaDB1U2YyUzhLNlpIN0JXQWFU?=
 =?utf-8?B?WUtIak41MnR4TzBOZlh1ZEtCTmJ4MGh1STNwaFc3b3ZQa0U1aTF2UkNiSUpr?=
 =?utf-8?B?ZVVlU2FMWXluOUg0YWdiTDZ1eDVaRVJpWGUrcWFsUmVDcGl2cXY5eFJXMjdk?=
 =?utf-8?B?U2dQdnpORFZNOXNZVU1vMXNrcTJHR1lWcHpqTXdwaXA3VkY0Vy9sWGZmeldN?=
 =?utf-8?B?TUk0anlsYVY1bjJLWHBTZWQxRkR1T3d3YkZDWHpQUWZpWnZZQlU2d3JUaStv?=
 =?utf-8?B?RC91KzNHOWQrdXp3c3BldUNzZkV3aWtreHFxdVpVWTY0aXR0OXo2ZmlERVdO?=
 =?utf-8?B?dUZSUDloeWdzc1pOR3kyMGVmQk1qejR6RXlyaDJkK3pYc3N5VVJnSjFDYkVy?=
 =?utf-8?B?Zzh5V2xVVHBYbHljaWNJNmdvVXc0ZmVDbTJUVVVlTTQrMzFaYjAvbUVzU0s4?=
 =?utf-8?B?ZE9OQUlBc2tWbjgxSGlaWHEwcUlxckU2cG13b0gwa0ZmbGRpNHNDVDBYNzhn?=
 =?utf-8?B?UkhSRVZCV3o3elVYc3QzbmJaZm9Ia1I4YlN6aFgycXhpRjNOanJ2Q3g4bjk3?=
 =?utf-8?B?ZUVXQ2prVEVFT2pMcXh3Z2NUM2k2bzhHaGUzM1lnZXBDUjZYRld2TlBsTTdy?=
 =?utf-8?B?NU9mMkp5S25jRDVDeWViejVEWkpkeEFnanZEbEZxbVpVMXFmVTlaNVN0U08y?=
 =?utf-8?B?UHBML2ZZeTFQL0xTYk9tbWRpOTBlVWlnM0gwWTRxQzVUVVdDUXFUcmwwUzBn?=
 =?utf-8?B?ZEtxaitlcUVDTDBvWnRNMUlML21OWlQ1NXc4a24zWHMzY2J5VlBpRkYxZzIw?=
 =?utf-8?B?VkloQTR0Rm9QcHIwWk0xUmduWk5ac2p2VUpneHN3TmJMeTJxaG5yd2pFR2dN?=
 =?utf-8?B?RnlUZ2RsdG9YYjVZRDZ5VUxLWU1BR01lekdnSUplMUpNalpYZ2FPKzRCY1Vl?=
 =?utf-8?B?ZUptc0VGOXg5SnFwTXM3UVFHWkN2bVFxVnIrZmN3L09lclhKTVVXVzhQSmxY?=
 =?utf-8?B?bG96Vml5M1A5VFhjRnBEZk5VM2JrVnRhNkt2OEwyNzV3ODlsTEdXVVFRT1dD?=
 =?utf-8?B?SkJGRlpFd3VqN2hqUFp3UlY2UWJBN2szWlVaemVYNVpLUWhJdjc0VVNBbUt5?=
 =?utf-8?Q?/ZO1V05/Dr0NtAUk2KUqOC/kwZoXvBiNDhHXfDn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0db5aee-600e-4230-75db-08d8f8b7eb80
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:53:28.8405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkPEq/tXf0I+POyOO4JjW4oFZjJYYFhfl/c2nwD9Ejyh84Ozn6UzuuErZot1wXmNg46hraIhNvSASgOoqZlpWh/0lPt7WdFfpSufkRnoDb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: vLTiFs8aeeFyCewG172US12cnPHUY7BP
X-Proofpoint-ORIG-GUID: vLTiFs8aeeFyCewG172US12cnPHUY7BP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 11:33:09 +0100, Arnd Bergmann wrote:

> Building with 'make W=1' shows a few harmless -Wempty-body warning for
> the mvsas driver:
> 
> drivers/scsi/mvsas/mv_94xx.c: In function 'mvs_94xx_phy_reset':
> drivers/scsi/mvsas/mv_94xx.c:278:63: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>   278 |                         mv_dprintk("phy hard reset failed.\n");
>       |                                                               ^
> drivers/scsi/mvsas/mv_sas.c: In function 'mvs_task_prep':
> drivers/scsi/mvsas/mv_sas.c:723:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
>   723 |                                 SAS_ADDR(dev->sas_addr));
>       |                                                         ^
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] mvsas: avoid -Wempty-body warning
      https://git.kernel.org/mkp/scsi/c/ae3645d29d4e

-- 
Martin K. Petersen	Oracle Linux Engineering
