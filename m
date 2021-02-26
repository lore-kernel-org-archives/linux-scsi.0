Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726EEC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 363D864F17
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhBZCX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhBZCXW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2KFkj151562;
        Fri, 26 Feb 2021 02:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uhD+JwIorxiUvPItTQK1jSlMUAMl7RqxYzx34l4ojUw=;
 b=A3sP+HDyFUrl7f1jwqhVV2xR5myGrZ68e2t6OjBJvjt4AIuCSf1NM4r0L24JZ+UW5mLF
 5sgYyfOxNNlMbcQfMY7HqB4Huz+Zw2CKLfeypGzhVoHRccXIFufXAqtkq6vCeOTm8Tin
 mayuzYIAdGgS1Q09rkfBgKwRS5QTMxkVaZ6btQwNl3cXIuQciAnfjYoDlSYrt/vOGl5j
 rSQAQdsR8o525pPXtm78sL0YOZCQ/hIDFW57kUlmXnRBkwt7rFTlUVH8IVHGJ9an8D2Z
 S7WuW2xKzhjqwoI6ykmb6FyKV5oDHsmElhXezJfqvdCFSr+bBsi0ZET9FhzDXOti412I Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36xqkf81h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2KgK9094713;
        Fri, 26 Feb 2021 02:22:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3030.oracle.com with ESMTP id 36v9m82exp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBCKzBtrOMgRrwMyJSq9y/hJ/hvVzcK6FFime7/ErDLexeBfDvONFvPgNBtWPUvCuN+BSXCBJpUF5JxqGrUa1zaIjVAEw65SMLkhPuYfbKhhw+xaQmEPlg/Ryf0/NudDxBZ4cORCpWcavId/hPfn1PtKI/aiG2kTWZhosr4UTk3CzJC4A7CcS2pZQqbFDAYpBsQeYp1F4meeJXEgytBsFlZY4j2qTa+XW2sedGgPcCTUhhnD1oM40mMfhD89kPdpDQAgpF8J/WvYgQhkIQTRQ/y70Ggw7McMLMBqGG3hAp0UE1jGxdD2V7bVib4sGP+hTcFD4MpMKybF8Un9oljRqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhD+JwIorxiUvPItTQK1jSlMUAMl7RqxYzx34l4ojUw=;
 b=n79LGfjbYmFPd2WXzp5hDhieR+P3kA/9Um/4LW5ewwNnwApS4LcuS87vHOrLNI6o76euj560eUudLDd8Bi2WLvuyythTSq/wKtv9AWkao6RxTJWhJfERoK6ki9ZueojjYyJiajdFjdaAuRhK07c4BVzIi1Ezoa9lTxsvFYlUXVPJEazHVGtBkglXipDG/6bMZWhNuNxRbR8741+RBNnY5pZtXUZ5DrSOaVPglPXZa7rVnasQjcsX9aeuhlsZmjOag8B1C+YEii1e7fLh1XT/2LS0cZM7p0QvrQI6VX3SQFFHZHVyu1XWd1SRNYCUZPiZaK30cakFgupqpCwVcFUFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhD+JwIorxiUvPItTQK1jSlMUAMl7RqxYzx34l4ojUw=;
 b=nkndjurv7iOVK7m0xi0AzcktgATh8UblxnHBL2hlgDW1POj9Ti1ZfUPKYp01aHrr5svYvzwIxbe9uWo9KbIfCpePwN6h77arGJXEZadTQHMjZf9zyjRcjpEtz+42QvI2t87vJoZKlVIFY+2LtXbAb8Rmd9185Lxcb9h1mg+OldI=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 02:22:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        kernel test robot <lkp@intel.com>,
        Javed Hasan <jhasan@marvell.com>
Subject: Re: [PATCH] SCSI: bnx2fc: fix Kconfig warning & CNIC build errors
Date:   Thu, 25 Feb 2021 21:22:11 -0500
Message-Id: <161430583251.29974.14350823697551788215.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210213192428.22537-1-rdunlap@infradead.org>
References: <20210213192428.22537-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 047774e5-aa93-4774-bc6c-08d8d9fd5cbe
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696DBEF3366971E9B55F3BF8E9D9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yiNNnQ6D7f4cI0t6lQtCoW5evy7mQjQIBwGPu2snym0J9UkR1uRhPnUklB5OhTpV1UlMM5SV/7yeNdQmxmpNFsnXx87VpqziX/lON5/MN6+8A0VD1FArAAe297RtH2ApMuyErb8AJgvCba4UNSFwcSPHQsbjGPhhXoFDR4QrY6Tx00irUSXX9scUUpJpOQmSykpg7fFoIlf7Kag/OJVaDuJYhJ7hD4+g4H81PtWLZutGEezS1VE8Aos+Mg9/Y+n+QLCiu8MoUWPOEmis2VV7nvcxLgX/3I8WGa2dvRDYbdNcQeDgyZ31E+8fSg1lJ6zj1LdkJZr/Vy+fNTtVNxfnpEd5GpSDTE805ggwDie4vAPxUGENKN1kdq3PeF0fOk6FpjcL7Gc+W4aTsJ3MuSbO03axJh9HuokCfS3Lzh7tgW66ztQadUwLZWnGa6tF3YpBGSyWz9gY48bZ6S4dUppbTAijXmbLlFIvqqAmMdbB/UrIvDuV4AygvRH6K0pfeolw0gB4ipaYOvqKFypwDlF8fKYu0kIUcTct7kpJJCgNu6sgIO9oMea6iXDiovWZ1YPFA+Ipji33CSBEKr0hBlne8OvzvtVni6yyTCmuL4sW0N8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(4744005)(8676002)(2906002)(7696005)(52116002)(2616005)(956004)(966005)(103116003)(8936002)(478600001)(26005)(316002)(6666004)(5660300002)(66556008)(66476007)(66946007)(54906003)(4326008)(86362001)(186003)(16526019)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NkxteURDRTJ5UG55MGhILzUvbVZ1bHYwMkFBaEkxaXlOK0xibkpJV2dvYXda?=
 =?utf-8?B?WmJDSVpIS0JqR0JhMDRDeFdUZlpiNmhxSnNUR25pVFJySWU0TmlOWW9JSzRD?=
 =?utf-8?B?czRvYnBWVTFGeEdKOFNpZ3lmenB1MHdLemUwOVRieTJCd2h4ZUIvdWlFV25U?=
 =?utf-8?B?ZE5vRElQQjFOMDA5bVFOc1c4a3FOckZ1RVV6OEl0M0VRbVdJVzU2aHpmTWdM?=
 =?utf-8?B?dFlVdXdOelVncUhCdnFHNFhVMHBydVU3S21aQTJRWFEyQWRhV1BmdXlnVFhT?=
 =?utf-8?B?UVFsaFg0R0lBSzJtNVNvYzBNNllRTWlUQWhkbCt3NkdUZ042QllDY1Q0WGpB?=
 =?utf-8?B?MFFZaHBvamtnZzJjTHViQjVUUnZ2MWhSZldpQ2RFVEZhWklrYUQxLzhHYnFB?=
 =?utf-8?B?QkMrNEE5dWxybnRMMXhIZ3o4TUErOVJYSFpBSmVZdGpHLzZJcjJLNVgwQTZK?=
 =?utf-8?B?U3NIOGxrTFVkL0FMNkpiSjIzUUxmR0U4REw3NGRZWGpEUW9QaC9UMWF5d0lH?=
 =?utf-8?B?T3AzVHR4Qm51akx2bnFNaC8rMElVVEpZSHlmU3Q2dnFLeVQvMWFwNFNTZjJH?=
 =?utf-8?B?blV6MmlUbmtDSnNMUGQ5WjFOeWFDc2RIN0ZFM3lMMXNPVndReWJxQjFQZlBu?=
 =?utf-8?B?cndWbnRHMDY4Q2tjaEZkNU5hNWQzeml2UHhTc2g5dm95Qi9zZ0tRd0duMTRC?=
 =?utf-8?B?ZGFGU1dibHJJcTlVYVh3d29JOWt4ZVdKRkY2Q0VwTTZPUTBBcjNpTElCT2Zx?=
 =?utf-8?B?QXpBRmhWTFk2ZFc3WGFCTVIyNS93akZOYW1PVnpCNUFrTU5vZmd6U0dpZnpi?=
 =?utf-8?B?TDlSK1Bsam1Jc3hDbWNWRkY2ZHNuV1RneWsyMGh3ZEw5cGpTYmxueEVTYmMw?=
 =?utf-8?B?TTh4L2pXWXF3UU9NSmZDdytyamc4UklKWVFXZk5kY3VZdFI2ejVEVnVWZTU5?=
 =?utf-8?B?Yi9FTjVNdStvbmhqemlOOWVXb0FTTnhHM3Jka3F3ZUFna2FGYmVMOHoxNW5W?=
 =?utf-8?B?K1Fqb3E3a2IwNG9XcGxRM004RC80MldRRjJjSncvcXJTMWlWTXpzcWlzMVNL?=
 =?utf-8?B?TURCVXNxdHBkR3hvRU5maWtOTGtENGJ2bmxBYjVYSG1TSGNlY1RkM01UUGEw?=
 =?utf-8?B?UXRKS3F0ZDRSM2xJa3piUjBlK25tQTZjMGd1clRVcmJETXl0cjNtU2JmOHRX?=
 =?utf-8?B?ZE9DeGNsOVYyeGJMT3dWdE1rS21CUWRGb2RMcEJIYzAxYmU2K043bTJGNlk5?=
 =?utf-8?B?UCs2ZEhiMmdwc09YTWdIU3hJSU9TcEJvWG9DbXZBV2ZlV2ZNdUdHMk9aUi9H?=
 =?utf-8?B?ME5EQVBrdGFUVlQ3bDgxK2VueXlkNkpyOXhhZVgzQ2hmQnZndDh5TEVkbU5K?=
 =?utf-8?B?WEFpOVpGMkg3cnh2K3lOb3JKYjZxNm1XQ3BTamJuNlMwWGNpa3Mrb2xqdHoz?=
 =?utf-8?B?ZHZ2b2M5RldLUGtwMENEeUhvbFduYlFZZnJOSjhNY3RqTmU5U0RpSHorZzNL?=
 =?utf-8?B?V1ArQUN0eDNjcWdGWnVrTVZhbWRoTUhXWk5OWGdPSWRuL2xpYVZRbjFuOTdh?=
 =?utf-8?B?TkpkRWc3L0tjVkJwRmpGOE1kOEt1R3hvNHBPMy90NWlpYW04d2dCYVRmbHN0?=
 =?utf-8?B?MU1ETFBONllMK2d5VG9SM1FoNU5PbzJLSElQc3VTREsxaC94bW53Z1BwQlAz?=
 =?utf-8?B?MlVRVGgzY1g0RXluSnlJUXJ5MVg5QmFXcElkZ1lYd0FhWTh2Y244MnFKcitD?=
 =?utf-8?Q?npXwjpG4KVInJPT/MKlCgmOBPTZGuRc0FlMKuGK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047774e5-aa93-4774-bc6c-08d8d9fd5cbe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:28.0843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhqU09HcmOW0jmLl1b4ZS14BocbfyNMsgeLmrsXDEz2bJW+7ONtWI/BOt9ie9/UXA1d+U/JUc9mxhAFuiE34zQwV98aW0lAZsiXe/TZ+o1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 13 Feb 2021 11:24:28 -0800, Randy Dunlap wrote:

> CNIC depends on MMU, but since 'select' does not follow any
> dependency chains, SCSI_BNX2X_FCOE also needs to depend on MMU,
> so that erroneous configs are not generated, which cause build
> errors in cnic.
> 
> WARNING: unmet direct dependencies detected for CNIC
>   Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=n] || IPV6 [=n]=n) && MMU [=n]
>   Selected by [y]:
>   - SCSI_BNX2X_FCOE [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI [=y] && (IPV6 [=n] || IPV6 [=n]=n) && LIBFC [=y] && LIBFCOE [=y]
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/1] SCSI: bnx2fc: fix Kconfig warning & CNIC build errors
      https://git.kernel.org/mkp/scsi/c/eefb816acb01

-- 
Martin K. Petersen	Oracle Linux Engineering
