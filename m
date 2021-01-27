Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708C5C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C672070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhA0FhM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:37:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37068 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbhA0E0U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:26:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4JpVP057864;
        Wed, 27 Jan 2021 04:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=n5uUGHpHydbmTrzht9dddo8ei+0oNrIAoX0dU9e7URs=;
 b=b17S9zgRqh2ITZviZ01R4ftlfpzmLLaXLhCu5ELmaQ/v0cBHq48+Yq68RRLwGoDiUwC7
 +T9tfVuQadQs4i06VeRvLul8tp/DFOTRksUN5kLBy9gwyttjbt6bMHA42LT1X/U/sNni
 Hdk2UVdJNXJhWYBlKLWUPk76blsHDzVHffLLuZBpECNN6j+AuJly4cEZWTIPwQ/ltg5g
 YUk7PT35KNGcM2s1wTnxU4ZAEW8dyc/KHqYa7D21l6t1o0iM3hieBRrN/NBBXrVCoupU
 ZCl557ysY3xtEIkNdqDm7xed7wRgkg0pZ/eQP2WT9YauknCCDUji0Edu5R1wtR75P09M Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7qw508-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:25:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4K8PJ010926;
        Wed, 27 Jan 2021 04:25:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 368wqxajk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:25:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoWx2DJLr+qqkpl4+9lT4bfb2XsdM0wipogj3zZhJ1ug6E3XImSQQeYJV7N53sWg0JCzHqBYqJQG2Zq69muSW767ZCRzF7RpxFsXRhpNVmyngMuSPp6MQP9yH1tKDdAtIqUE/EUT4e5SgZ7/Oph6G6rDcSiWGhzm1aNl3RmC4WinubNxlLznaGrC67AOgm+x+3PrRLgsybuQdNqFPDaw0SvHkIABooFjku0/7NH5M0IdRXvFEWAjurrS4w0fL8RAFWGqXljRWs9/H62sA6H1sRFKVLxM3tGUiiK3kGNSEyaLANukWM/w/EHbrUWNKX61FoEOSMqIPPeo1V9PEP9CwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5uUGHpHydbmTrzht9dddo8ei+0oNrIAoX0dU9e7URs=;
 b=CkI3UUyyylfbDYWmtr92tPOXk/PqQ2wn8V/wmhnVmXlTCkZa0ZehUNghL3U+Lj+dBAgIWKHmWIUf9xQ9UdOrjDQxooIgow05ZNcW4mQyl0JxsKXeOghS+nAzbJNSEANsxSmN8ievYtbdIHt7jM0qJ6ifdFjJPsc4WFBdZj9Zbc9nTBZMVJ4YuqebNjFXHdeJf80ErvCphAC2O7D0uTzgxW/VtVRQ3mpKA8dT6HxZXN769FivpJxhTVrtttYs7A+iBGkut3gKXuoKzdckQNBGDj29YYEftSAnR4Fkr0MzXWqPHw0G0Y+0BiJY4psTH9NB112Xh612EUXyimI5HHgZwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5uUGHpHydbmTrzht9dddo8ei+0oNrIAoX0dU9e7URs=;
 b=KOQGptOE6AbBJMyw0OdAekdBL2ytwGLnoY0175wlzFK6wrvhtTeVbpRGyG/K5h5wAeo8V45gBdmj5zEtanZ1P3/4iw3Fq3kGeHr3Rpddv3ujwjtTRHz4A+y+w0u+ae1dCQzq4/UAxICOz80/ehzCtrI5bgz6PZlZmBwseQuLfCY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 04:25:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:25:30 +0000
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] scsi: message: fusion: fix 'physical' typos
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfcfnh00.fsf@ca-mkp.ca.oracle.com>
References: <20210126210328.2918631-1-helgaas@kernel.org>
Date:   Tue, 26 Jan 2021 23:25:25 -0500
In-Reply-To: <20210126210328.2918631-1-helgaas@kernel.org> (Bjorn Helgaas's
        message of "Tue, 26 Jan 2021 15:03:28 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:610:74::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR04CA0071.namprd04.prod.outlook.com (2603:10b6:610:74::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Wed, 27 Jan 2021 04:25:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc6795e7-3e9f-4613-2121-08d8c27b948c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB461596DBC1207249A02C79AB8EBB9@PH0PR10MB4615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxpdM0Z/9Ty7SlWxri6L1nZoRViNPvbPLiU+Ke6+5pD4xIuyvUnuAEuNzwuDQO/R1btv0j10Gb7jv1H0NuKyzE2NfLPRowooldWG0AyyOnrIeWuVJY94Fguv1COop8zLlzjOqPtn0Kr6zraoAk6bNv9zQi4FVOTzvQdikf7eLurhah0X82uKKTesncfuMH/7BMvpoMluMB9Pn4saU7mpRD+HBmcfGry/Q5p1lQ7zVqJK9gzlE99lVgXdtN43Cprq5YBmQr5F14YgJlywKfci9ohVjk0ygBj9SsXLTWluMkLhqz0H1szb7Tjb6+7ROlfBstGGVwa5oC22FUi70dt7jIKKj8405xgJlKfC+z8r6KHauwp4smZbCfQeqGPQvWsRHucm/NW3Xgipt9kUXCsxq1AweznUHktlP7p4b36SnAi2FqetXV1jE3aC72pm88loA9NbkqXH322JhpLRFgWfzs5vnzAGs9EIUkBrkaXITtRfv1vZ1k6r4VlTrJHo52FncrhZ/U2EkG0bKMMOvsvQDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(366004)(346002)(6916009)(36916002)(86362001)(52116002)(6666004)(54906003)(66556008)(7696005)(66476007)(5660300002)(8936002)(4326008)(66946007)(558084003)(478600001)(8676002)(186003)(16526019)(2906002)(26005)(956004)(316002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4qyUfsg8Nt8N2LQAWjyz04A7jZpeFLNKK9n+fBITxZbCeXeyIrafCQH5cjwJ?=
 =?us-ascii?Q?O7iAtEupNbeywvsDSEUk9L3yxN3h76AOlJJqpRUD678d9eZZOYrSqdwLCyLe?=
 =?us-ascii?Q?Q0502q3nERcAVYAjAhcPFCbyoNiu+07ouzOHTneM7xRPjvSjON+FUdFjeRyZ?=
 =?us-ascii?Q?fSSNEC7jp6oFKa2sS3BzkIkqhAjZNg+qKpAXIhQzGCELRRXFL1T5VpPT8MaT?=
 =?us-ascii?Q?Ro5uJsfzRDxdSQHAWEDHdM+kdPYXYm2zBYac6wYFazNl2HIjMwwfvOEi10hJ?=
 =?us-ascii?Q?KB4Gts4Ih4YJ0+SJ9AXUiPVCMfBbtsn7yI5PLrMzN3Lkl3gk1/sTKcDMl9B9?=
 =?us-ascii?Q?7tNP+Y1tDZ8zI+oJmbYTjqE5hQWoS5iGKNZ4Mxe35xg3OJ0d4Q+Ns9Etya3J?=
 =?us-ascii?Q?Tdrbsi7TXCE5NiNXWPm2FJUM+8STjaPH4gajXKAKbpl80exU0AADy7kzqnM5?=
 =?us-ascii?Q?WLsQVrcQehVtEh/ncxA2i/qCxfL4kuqwsfv70JHm0HQj3hcDP8FOtGNPLkPE?=
 =?us-ascii?Q?Abh/PLdzJlnIzPWSQWItX24B/OlPW6WCnjFKHxKCZJP1CzMVuor3oYQLjq7Q?=
 =?us-ascii?Q?khIgH+D9jr0/py0CY18s0jJ93ZsUYIcBHSM9WwUQTTT1/M6dG7iLespT94K1?=
 =?us-ascii?Q?scFNL1wL6aEf+6C8agjJKfVJgU3uCYf3T0KdHLmPYEZI6aolhdvoDJH3bCuV?=
 =?us-ascii?Q?Zu/urOUvFH+UHztSZiqV7bsyG/Z2OuLm/eEMFrBNIwD7BBFzgo/FQqOVAWPv?=
 =?us-ascii?Q?Ty6kBZlRffGB1ECuCWDvQarQvGickfb+VkbfahT1isxkl8IjWG9lfY6aVEdq?=
 =?us-ascii?Q?bKR6NbPLLc4jXeQX262xV7cq24Os4EWnkkJqX3lXiZeJIf2gnLdnV4rttQno?=
 =?us-ascii?Q?hdfmmADX+zwLD6lOWLg3MoSfhZrmbTuLchSbVRaxAbJDDgpxD+Y90IxZjsjq?=
 =?us-ascii?Q?c1kcvm3O18Ko8vtd/bUAmaS+idoN/WZ370vgGGXAt9bKG6zItYqtePKb74wT?=
 =?us-ascii?Q?XW1rS8g8dyB4vMFEW6XIh71046OaVMXGPsTmln8hFoSrMhgg3H4tZg0YTkBU?=
 =?us-ascii?Q?mJfwrthl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6795e7-3e9f-4613-2121-08d8c27b948c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:25:30.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zr54tacBwJ0abBQhftRgUVjjZgEzAtLr/Kh6wpnDRt4ZoNxbEBUaxBl3YTBaSDW4LgfHSBnuyZCHq4atb6ziVSKkpwN+2aYYYiD1onMp3to=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bjorn,

> Fix misspellings of "physical".

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
