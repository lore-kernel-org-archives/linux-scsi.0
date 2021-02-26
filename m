Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91313C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2E564EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBZCXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhBZCXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2JWak105513;
        Fri, 26 Feb 2021 02:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1sJLARM+aFzD4lpx2qemgKNRwZYuU2DbOEj1nZ+SCfw=;
 b=acWAxvJrCW+K77Ca2e8R10fbrt1qrcn8N2IN7Zi5t8T5ZDILt9Iw6vu9yfY8FSar7WhQ
 RJ6lNB25Kz19830JXF+MRS8O7oiP5Bs7JFrDXwcysMdDYPcbl9ErwS/PAcMzR9+fztQV
 m3zjhMBVaJtiOq6HJlE5ebDVg0pQAl9MZbRzf75UYLLcgQ2N5yOxR8WtwMMUmUCPWC/C
 nmTbdymJ3mx6aYvQ9CkWWbTvFNYyC0EcaITomK5HjkJfLjVZrrElRC7pYe6XhzCroEuZ
 aqqZ5DLmufd6mxhR0NsPNyVQ9PEzFqE61M+2K+rZjgoVjQYm14qgnahYf2J2rt/fc120 yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36ugq3qd3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2Kg8k107075;
        Fri, 26 Feb 2021 02:22:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 36ucc21p52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F52FlKC9cwy88mJjWVFbByxH7EEkbue8FeIRCzaKUjZR7PZaF0ZCWjG9bWKVjNELq+6IjrQQ2f3I3ovRUYj8F1eWYLMFH+XWoClGSzcKVU87HD8PRC0pIpSOWUov9Bb7WL6c2JcZg72x8byg8R5tzHAVe5mIR1tbIvOSXHk/5ZFZilwc4ELfUS9jr5S32cjjnyVDyDFEadjD33bSJkgYP6LFDCgUFaox53TNd7yVPmgMCwMpQ3Qa00jLoVAoBPLqbukH3dO8CS719STqdzXJIfxh+9FKo2Z0gEoClHIp2kcendazjkEQb9cA2Ewu+NBL5Ue6NNXCNhfO9E7SZqKwHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sJLARM+aFzD4lpx2qemgKNRwZYuU2DbOEj1nZ+SCfw=;
 b=L6dsUkNM502eXN3+R7/P8LJvCqR8RKsVALb4JVepySt798CDi5pQAt3SW7ypkBXSuKP95xLzINkSesdtsZOPhpQx5x2NiEIeSLf+QEQzSKpdaauxOTcC/Xz1aHOO4P6cTcYQVrOPQsu9D/Ox0DQ9KZZ/XsRiZuYa8b+o1kSet22gKptigeQDpdGSFT81G+V+LETICiBosaAMLh4mHfau6csga9TeAEtEgx8xnL/oV9dB7I3/wSStBsAzky4Uuj/OYsCRlViLmkaRYRK4TpPggz4m9sOaSNM6Wo3E1lTFWfoFzQ6nZhUWcjan1H4TgyE2Rhg8NAHYyA1IgdcLt+wWVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sJLARM+aFzD4lpx2qemgKNRwZYuU2DbOEj1nZ+SCfw=;
 b=CsKTKKgoO6r8L3jRqWyDgxuw2fnlvfTIKNrKsZvg9hCZcJMKuGWuhW/SAJnQYiClvBMuQh0SmUi2/h/14vbW+L2zc9YaT8WKeMupi1iY7JDwnPcYZwjS+d3kuqpY1nwm7TbKd3eTX9MMedGr01m9xw1yi+l4xL4kkJ7qxe2z7wo=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4661.namprd10.prod.outlook.com (2603:10b6:510:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Fri, 26 Feb
 2021 02:22:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com
Subject: Re: [PATCH] scsi: ufs: Fix a duplicate dev quirk number
Date:   Thu, 25 Feb 2021 21:22:05 -0500
Message-Id: <161430583250.29974.14036258868456322198.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210211104638.292499-1-avri.altman@wdc.com>
References: <20210211104638.292499-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7dd9881-8627-412c-59e7-08d8d9fd56a8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4661:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466163B183FF7A5CC7C48E2B8E9D9@PH0PR10MB4661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tipl1IphbbnPGJwsZ8eGiPWSdEvqGb6DjIf/eab3rkXwRWU7vQTlaGkP/mjFsbwkrfNNZJcHXd53qq77V86k+g0fUOzixkIh6vcI8KsQgO2OTbHFodmaytidnymhQWGeGFuiIrVPRqh1oAjo+hREKU4mdWnGr2N0IG01L4nVaY5gewvLH48hIits+5K3PSVn6iYRJmkp65akbepBNi3FPxz42rES8U7sGahqRtiAFMer5et0P+/XhTKhM7xPvPJv+lO9XV+Ms7IDydlihNlDBtBiENPiSPQ9j0t80muEEPmbDauXcqm5rnSOucllH1zWVAihm1smJedlYqLajr+qUAIJDZmvHG3VPAPhufMXlgqGHTVJG48XuKP4HXqVeXD2L6Fjm0SqGfVpHAvRpd3xNh0s2+PmTkAEyNGzLv2i8GrBIB9+n+1RnA3VKo08SlGCgfikC0eG3bXV/qtrDsdwggNPiPc+9HOH3tLnGND+tlaRwcUnyHhlQJGUa3iVuyVawVzeDM2FSr5kCB6IFuglK8fyDHxlxf8pcaCwC7eEhICOck9r34/05oWSpI7x1VQIUtxw6N/i9GqEdiJcLL+T3a1o3afC8+rwJOJyUA0QD2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(39860400002)(396003)(4326008)(2906002)(6666004)(2616005)(956004)(86362001)(5660300002)(36756003)(110136005)(7696005)(16526019)(966005)(26005)(8936002)(103116003)(66946007)(66476007)(186003)(66556008)(8676002)(52116002)(558084003)(6486002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RzI2WEdxYVRJdmszZ3d6ck12NmFqeHpIUVNCbHJSVnZhUU1Nak9xcW1ubi9W?=
 =?utf-8?B?ZHd4MlRWcG5EYm03YXZFR0t0VnhEeTBSZ1dyZ2p0QVFUS2p5WVUzU0pCbEoy?=
 =?utf-8?B?RlBCYW5nd00wM0J1YVU2QmE4M3lYK3F0RDNyKzFyR1NGbGxrNHVvOU1TdCtW?=
 =?utf-8?B?NDcyUSsydGtXREI5VzRlNGlDaEhWN2VIWWtIdXRpK1IvaXFlY0h2MmZqNHNr?=
 =?utf-8?B?SVE5KzF3VXhsbk1uTHcrYmpmS2FDeVlJdmF6ZFdQV05CYXoxYmFXZ1ZNM0RL?=
 =?utf-8?B?emZobUlXOGZjVWhhOWRPa1ArUVUyTS9RSnI1bGlyaXluNEJ3cFA5N2FrdlFX?=
 =?utf-8?B?M3phOWQrZGc3RXBrN0lkR0ZWd2t6Tm9HSGRSTHV0dDlrS0dYM0p4cHZicFNI?=
 =?utf-8?B?VFk0UHJYYmRVOUpXZ0FCOUZBajJUL3Y3M0FpQTZ1R0RDRzhPMzlkTzcwV1hi?=
 =?utf-8?B?ZXVXZW9QQUdvTWJLSTFnSThPMUxraVhCQnBOWXNJOHQzZHduVWVmRG5VMDJt?=
 =?utf-8?B?VEJleWdBbFRpaHMyVFdFM0tPL2lBb01Zc1BmbGlOM1pEOWJuWWtPbFFzSWZ2?=
 =?utf-8?B?V2dsY08xNjlkYVNOckhNa0cweVljUDM2QnNBNHJXWndJVVpZUmN4bVM3OFFD?=
 =?utf-8?B?MlFSck53aGNvOCttUVM3Ni8yNC9QZnZPK09VR2l3Z3dHNElPSkpGOGdGbW91?=
 =?utf-8?B?K0JUSEdTTXY4blNXMkVLSksyQnQ2a1N3Y05BTDZsbmEvbmxudGIwdWFkWmF3?=
 =?utf-8?B?VWExSWpvUXliT1I5VVZwb2NITUV1dEsvNjRmcjhvUG9ONkF0SS9uRHU0dTds?=
 =?utf-8?B?cnBLU21qREhoUXVTWkpuaVJ4OVF1NENxbVJ4c2s4cFBUMTBSbmVZNHdQdkov?=
 =?utf-8?B?Rkt4dEMzRHdrbnVkRUVDUEF3YWNoZGo4TXl0U2F2QVJRL1RDUnJNdDV6OGdE?=
 =?utf-8?B?YlRzYnZHUTM1d3dqUmtzVXp5SUxHeW45VDd1TVJzbW9odGNaTFRrSHlmeWdF?=
 =?utf-8?B?YVlvZ3hNaWpHUjhhd1hNaUVsQ3cxK3M4VEVmT3NIOXB0WFV4SFpnU1VJa1Qx?=
 =?utf-8?B?UUhDY1BoRjR4ZTVLZ0IyMDRiWmFqbFpPcVVGT1RxOXRoSXo4RnF4SVRMdEEv?=
 =?utf-8?B?alZDamI1V3hIUUZ5ZTErMVo4QjRrZVdBZFp0WFhIK3IxNzB6d3A2UTBrQ3pM?=
 =?utf-8?B?VlUyeWhGcTNQcHBTTWV5emZCeWxlSkE5YjdsWVQ0WVR3Q0QvclVieUFIbWFO?=
 =?utf-8?B?MXphRGh2T0FSZ01GSDNTb28xbUZ5cEhraFQ1ZkxkQjEyOGtEMzZsbGVCN1I2?=
 =?utf-8?B?TWh5ZnBqdkZYS0IyaEVvcXNDMWhyNXhmNkpPZzFTNG4rcFV6RUVhSnlFRGp4?=
 =?utf-8?B?QUU1dTFEK2REQlhPU1hZcVV5U25lQzNkdTdLR1poMllqMXFpT29OdWtHaXRq?=
 =?utf-8?B?QTVLbUxhUFBCOC9uU3lPOG5IeStiODZjZGJDOTRYZkF2bFVrdkxrYkVKaGs5?=
 =?utf-8?B?T3hLblRqd1kvZmxIbklhRHUyVEMxUitZWWRpUHZ2b1UvQmhSelA2TVI5TTFs?=
 =?utf-8?B?dEFWZlJOTE9GQnhQczRCTjNnSHpJQkxRN0x2eUcxNmsxNlBOTm1hUDdDMWZ3?=
 =?utf-8?B?cU50N0xpZ0NwYVFUVDRWV3NCYUM4byt0NXJIUDZtcFQ3dU9ESGlmcklrbVlX?=
 =?utf-8?B?bjVGWm4rNysxbkxiTmo3ekM1YXRPSzhEV1lyVTY5WUFieUorZ3hXbHpRZGJi?=
 =?utf-8?Q?Jq7odzGaa9WkTPNlE7Rp3HPXbPY3RdlE5s9UDKN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7dd9881-8627-412c-59e7-08d8d9fd56a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:18.0127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htkk6UeGPuf/cnXnyocng8tkzqeqVhjCG2gm32LPOaND27fvU+XUm/TCt3/1stZqnAdYmoidjRiMPOigz7BPv+Lpq93LsE7pAT8RJK8xJuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4661
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=904 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 11 Feb 2021 12:46:38 +0200, Avri Altman wrote:

> 


Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs: Fix a duplicate dev quirk number
      https://git.kernel.org/mkp/scsi/c/9599a1cf2333

-- 
Martin K. Petersen	Oracle Linux Engineering
