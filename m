Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A458C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ECE623A3C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbhAOEJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbhAOEJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43Un5144065;
        Fri, 15 Jan 2021 04:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VZD4SsGdAEZNivPeXFjUW+D7DSfD9NrNyOaIeGtgHy0=;
 b=ga4mlnSfopud88PsJGeBOuYiI+JsL0qEMMiK+wWGvo+AbjjkkSuapXtIeififsBUP0RA
 PBTQvEhMZGsHawcQcpBjiYNVmJyTpLFftn+SJ1okXtiggRC0P+u5RojzEKbiwAU0rPfV
 Dv6dCsJPUN1+m9l09QUZglKIeVTq2KZUAFFVT1eoZj36IbMVEZczO+UkgWE73oNzezvY
 qfx2sm5lDFHxnqvNX+OLnFfL7Ta9/oLbzLaL8g4xrHoV/rNU85Nbu6AuuFGcMHkkRTgJ
 Crc0z4HlDg3QMPyRqWh/gNBzPG71pK7EnFzOnzEauLhjHB4T974jHWZHWqFYMba7ksCh 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 360kvkb6mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46eX6094901;
        Fri, 15 Jan 2021 04:08:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 360kfagp6r-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgEQuHzqMwQuz+9MQxGISJ+5V3IEJH/5FkSEtjlB9eRaft5Tt8grqq8v54Is9I0XJ7phwYp21rLDJir9uqS0f07yuBXGOAZMHFrNSIqe+2lBWPTfr97liU08sO7cYOjf4UB6BVIDybdIC9iVAc4JpMWw+KUx9zbJoU34IEiVcPCXqDyUhAAt5XOraKHzfnnFbLz2xhUO+BJraGjc0G1N22aVRAEHnxg+Fx1xkQIPg7tAdE4rejuCK2XSsw+g37yvYhA5tf7LR5fmtKZv53f1ShGXG7rG2q9kC3aAdq47v9UBY2fAHbUycrjv3ZgZQLz4eH6Tx0y0VX54C5S+bml8uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZD4SsGdAEZNivPeXFjUW+D7DSfD9NrNyOaIeGtgHy0=;
 b=KxcpGIRFHQ6LqPD/FhgTUaa6GWmmxLON+EFaEsyKMfjDk05C2WWiLZoU7IU0iT5YcOnuvrapHHU+QlEmJIe2QAnfMy8xvjW5Yfe8FIpbuxFeOctMyX7qkvokxBlBh+swudpEA6/EuzGPqfElDGi+ZUaXMPgoJOk0pmB3TU+/tOo7pJ1PD71SfbXzj2ZfjBbk+pe9h8+pwv7HDoZ3/MFEEXwb8EHUh7J0D7/WGLt9B0oe/uAetnKrZ4uyDWnHNcCeVEB7A2f98W/yA9paGgwMq2yccwjfRxW1KCJO+KFid8f0rU5EpdxsX/NMLRn1qb7kzpmbxyE5dz2s458/csyJtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZD4SsGdAEZNivPeXFjUW+D7DSfD9NrNyOaIeGtgHy0=;
 b=MMHB3TIUYErrTbNne415HWXxUs4Ao0Xhzum9vwdg1k+A5030K0ComjqZE1luHwF8TMKCxTebw5iSg/PYr621pH/IMD4UDdjlyH73ng/iNgyeIgAth24U+qR6/HENr3hIhFEl863Z7tnJzq4Slu/BNGGlNsNwJBRbuLTB+e9uHVc=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] scsi: ufs: A tad optimization in query upiu trace
Date:   Thu, 14 Jan 2021 23:08:23 -0500
Message-Id: <161068333184.18181.9389991012697180579.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110084618.189371-1-avri.altman@wdc.com>
References: <20210110084618.189371-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48c35932-17c7-4085-b4c2-08d8b90b3edc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568EB5EC54274D8508ADF638EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMPGDIDNJsSwD3vJTcYpngZ+qFUM2E0qAK2Dlb509Yix0/DXoDEaPWvfVyVC23Tx3wCJddFsutWEIir3fZD8sYpaQyAZu0Ioaa8Apr2Cps0+W6Z8wZRiqWD2johh0U/YfCuJq7PGtB55YULu88PTv9bKjgvHUIzONARipNq3x57GsgiPdHWR/r50t0JiUpxpIbMoVnCRIZmYvfkIkVvePXtys44508hk+mp45WJ2rB8rKXkPJ2ZKbQjjBc80K/z5s83qtNXo7faoBNCMxlniWA5IsUMrvCtI0AyTeehUt2S8q4XjHADq8ZnAzxspMq7Lg2xQUaP25+DGFQ6tfY7NQqvrgL3d+9c9RtnkWkwCZRXXA908z92s4PHqiJdO0OB0oDxwAVwJDiL4ykH0JjmwMOVSvQOfu9l/f6AVjQWA3FnfJdqEnQQ7lsnM57nVYzpUC5xAuV+TIVylkzTbQN3qow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(54906003)(36756003)(6666004)(316002)(4326008)(6486002)(8936002)(2906002)(86362001)(110136005)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NE9WanUzMUNNSG0vblRUUUN1enRGTGF3WU5JYitkSXVpbWtpZ0paRThPMWVC?=
 =?utf-8?B?Vks5dVl2MXcvd1hIVnIzdU9UQnJaMEtBeFIxTHZpZ2g5amo2SEdlSGxwY0ZD?=
 =?utf-8?B?ZkJQdFpVNjRLYUhQSTVwNWJsSDlKM2w0ZFZzWWl3TFFQczVCdTBMVE9YbldX?=
 =?utf-8?B?UStzWldoOVlRU2Q0Q1FJSWZ4YlRXMzkvSFFoVVdKRnFSZTdWaXYzdjNOZzM5?=
 =?utf-8?B?Z1VOUlhSR2pjenJoYmE4akpzakhuMVg4aWlBVVVYZTduUG8rbDJvUTRoRjRI?=
 =?utf-8?B?ODY4dEZDUXNmcytxMFd1b1VlZ0NET3JwUVdxRm83QWlqamp6aFllTlRBRHRa?=
 =?utf-8?B?aWt6ajRPQU02NGh3QVBkbmNNTTlKbDdwU0ZWZ0toNGtxUHJJMHhnelhOKzFX?=
 =?utf-8?B?Uk42QWwyUzdCc2hMUkE5VWFoeVplMWRCNExuMzY2dFZJR3NtVldyZVFCYmVU?=
 =?utf-8?B?OHFIdmpSSXg4YWlEd0RDTUs2VTdtYW9hWEQ2Q1UzeThqTU45OXZUcjAvcW5C?=
 =?utf-8?B?NXc0c0NjZ2NPa3JFckdKeXAzTVB0ZEYrbmUvbkRSeGduWUdlWUlSNTVlSjQy?=
 =?utf-8?B?VHdUL0NuR1g4TkxEa2FLR2U3SW96OENEMVJxOFNCL00rK0dmSkdPVlFUM1cx?=
 =?utf-8?B?OVM1SWs5TzlvUldLakF5NWJtbmI5TWVyVmJZakhhL09YdTRCeCs5Y2RzRS9y?=
 =?utf-8?B?RUprM2hpRytneDVsa0phWVlMQWNpMkV4UTNiK1IxVDladXJ6YmplaWZzUWJj?=
 =?utf-8?B?MFcxSHMrRlJ4REdkcHhnTFhaaUUxbExjOHJ1c2UyL0thWEs5T2JpcXlzcndx?=
 =?utf-8?B?Z1htbkNGYzBBRkFyUTN0LzdUMy9aZTVLdlRTU2J5bHhmUExrSDMrNHVpWXU1?=
 =?utf-8?B?WkxIQ2x5V1dpK3hOWnpNeTZzaktCcnVjV2Z3eVFZS0xPVDJNakJHa2dsOElD?=
 =?utf-8?B?NmEvUUVXZllOcnN1akM2NEpITTR6eDdaOFUwUnR5RkVOU1pnZ1Rtbk5rWnhx?=
 =?utf-8?B?dWhNYlo1ckZSRmUxbmxaZjBJY1dZUTJ0ZVRQOHNYVlMyUTZTcFBJeUpnMnMz?=
 =?utf-8?B?MVV5MXJaVWhZeU83T0pSekd2b1BJQmZIekxsL2t3WURMN3MwbE54M01rMXhU?=
 =?utf-8?B?Vnp6aElDUWZVLzFQd0dIV2FhcC9xOWtFWGNWZ0hJS0hIN1Bsc0xJaGNybFc1?=
 =?utf-8?B?ZEoya1hsQzNSM0FJUFE1Nml2Nlp2MjJKc05SeUt3S2lKMzgxNWMrN2F3U043?=
 =?utf-8?B?UkZscTRMTFZQK1ZaU3ZWSEFKbDF4MUg5YTdRL2FrZ3Q3SjZMTlhJUXVRVWJD?=
 =?utf-8?Q?IU55o+aYutkGQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c35932-17c7-4085-b4c2-08d8b90b3edc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:42.5804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxJSVj1nZHW7UfRKUc+bBN38Aa7LcY5tWvz4scrk2DsTEzJB8ANonUkzTio6k887F7SjHSf9EjfVi5nrKNojs8m/LjjRP9I+YL7JjAAofDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=919 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 10 Jan 2021 10:46:18 +0200, Avri Altman wrote:

> Remove a redundant if clause in ufshcd_add_query_upiu_trace.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs: A tad optimization in query upiu trace
      https://git.kernel.org/mkp/scsi/c/fb475b74d663

-- 
Martin K. Petersen	Oracle Linux Engineering
