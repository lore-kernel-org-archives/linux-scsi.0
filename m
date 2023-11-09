Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF42DC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Nov 2023 02:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjKICqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 21:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjKICqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 21:46:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE3F26A9;
        Wed,  8 Nov 2023 18:46:40 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A91i2Qc019225;
        Thu, 9 Nov 2023 02:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=f4Ok5G2kJEcvqdE/d1EcJ+8oVRiDmOCRsWT9Q75d/iU=;
 b=ch/vC4603/LhCdmlIayN/WD9qoFCwbY3K3YyGXz/fwHLPmvrpFHWLYKm5dF7osQLC9o7
 yyHwrp5gOtSCxvTZh2VnPZqVnyKOD943iAqsfY/yOdAgDYFDy0kFeNboDrNQdn6+uk6o
 E1f+s45//51DiwBVOYMKCIhKI6vpxFAEYWR8NELwaJqfmIQeiylPf5kcemyCdXVLuosO
 kXwYHi5LUHPnlOv8++QAMlFzVntfAwH65WPgiea6sbQ67I6byE4jpdc0bWH7z6vP30bC
 ufN9sVEXOGq7bK351gqwx/dE7bw5gTPRy8At0MwsjRtJ90SNWnhrWMU7F1OxyVEgI1V+ +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w2131d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:41:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A92Z4Wg023973;
        Thu, 9 Nov 2023 02:41:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w260qcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILziOGqK21PHWLqFgJ8LG6hjIoz2JHmsnDf57oowXUEUvoZ3LrcuxbRQL6UHUYkUGUhw/ZHKFeQytBMY3vOWpY+VyYIzPCphdvxcK59JqnjMPgDnOLjbuY1UA2ZO8TJt3po6sSd48BGnEPRBlNwzKrZXSCtqot3xXcQVSOkbI7I7pNUI1jrTdKHrGFGVfFifS53DexwIPXHhNJDOq32ZM4rV+9eksi2b5DXZ82sGwVNj6GRh//GMHZ6yhHmZujMUGPgMMkj8OlW1gdV042pdII0ZYbRMMwUExf2ZMLaXWRU5mvcafGiMUc8yy0GL5B59uQGmfVytmfEUWpyJCtneVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4Ok5G2kJEcvqdE/d1EcJ+8oVRiDmOCRsWT9Q75d/iU=;
 b=oQFri9JEpruURNaW0+sV7Fd7vNWFbRTwHAgeGDe/eO+hi31gjg7RNO7tbJJ73ylCKRC079QMm/Sz+VGodVYvel/7t5PpuuYZ+qOU+W+eO86pYev/m0TU+MmpIcWbgHylrcR39snbMo04LfK4qhS/wYeR/c4OUFWsxWdVPEFhqd53JuZQY4OILJOnkWDcHysE9NFIXeOXJCrzUaD681Gh3nOueufS8MJwu5gUu9NHfH64aELk2H1qBGWH1uZi+KlNi4oMGTkcn7rkijYapZ3QoX968r6BmlwVuGfeUCXjoF6Pf51ieSsAJPK8plzwatB2ngys3sjJ9ZTNn1BVVSE7Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4Ok5G2kJEcvqdE/d1EcJ+8oVRiDmOCRsWT9Q75d/iU=;
 b=a/RAL3OX7LKrX6/abREO6jQjYbOppzbRYuQrqExzdo7V3GFt3lG6EiompiLnDDamkiDh+lqieZ/KjUEwPN22hJQuNAUpzOsjn9PnJsYll+AXWSF2gH6LTrxEy0i1uy8cwwTpY90cWh5UOnvSsyKPrgnB3bt2oVyPM1gjdSIXRqM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5179.namprd10.prod.outlook.com (2603:10b6:610:c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Thu, 9 Nov
 2023 02:41:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.6977.018; Thu, 9 Nov 2023
 02:41:00 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ufs: core: fix racing issue between ufshcd_mcq_abort
 and ISR
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkc36441.fsf@ca-mkp.ca.oracle.com>
References: <20231106075117.8995-1-peter.wang@mediatek.com>
Date:   Wed, 08 Nov 2023 21:40:57 -0500
In-Reply-To: <20231106075117.8995-1-peter.wang@mediatek.com> (peter wang's
        message of "Mon, 6 Nov 2023 15:51:17 +0800")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:208:23c::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5179:EE_
X-MS-Office365-Filtering-Correlation-Id: d71d81bb-e9f7-4de8-c00d-08dbe0cd4ee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZYetbGmdcDhLuJe+sh7yCEWpTZdgM50ESOnC4JP0mP8gbefLLexwNvXrYXAk6RniYUMqQsoJQrIK/JEkCUSgb2EkV3anISocfCmz5hwM0QNw/0EtbJo89cm/9cEp+osvI9860UsaE1CqT1NEoe0xiZBsZU6fFEiaKEn31fPQh6r5GPs/7XMI6A7nc5SY9iija6IgfIseSECA4y8Y6NIytFvkmARDEUri5vDRGOMwKyEs/nRHf3Rd84ZNmayt3LhJDqEeR5+ZI7zHoSzozbxD2K5oFhRGysK+qMcblclK8cpoILLzNLF69hX5oK+Yzy+uYElQnj3qrwiOKD0BspTw5NZKIM+ybrO9t6ReHUU+Zqtl7eXWGaH558sNz0uroO/SMqgYWnx+zQtyg9QrlgAgvkBDJgloa+SiRL3vGI3ExJKncHlAeI7SvL3coqSjuGPqO9chSNKIfs5bRutRdUc4avDnUl7ubakDKp46eDZoKPS208QVQA6dXw/xr/NQiTaK1XZcuw86+oSiRxO1jqgdz8UhqzLvLmrckVRN10pVtoTW339mGXlm/tBWMxA57xU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6512007)(41300700001)(36916002)(6666004)(6506007)(558084003)(38100700002)(86362001)(26005)(7416002)(316002)(54906003)(6916009)(66946007)(66476007)(66556008)(5660300002)(8676002)(6486002)(8936002)(2906002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2/CUXNyq3Skgwor+ZEcxpjORNcy77oZ8+LuAm2SmWlpFAYURMcSRBgROBw9o?=
 =?us-ascii?Q?3vjB7UqTLgZYITdkjCS/mSi2DUdj8M0hg/NBQrnto39PKPJWIoCAamIJS8Dj?=
 =?us-ascii?Q?LLFySu2/bzFfNbhiOQaDTGPldjX8N1M0OWjvHv7/c5Ol7qQi5euiFk0AZiDA?=
 =?us-ascii?Q?ULKOV0RSpkfgjz8T0tcQWFFQbxjomBDJSXZ3L0gFIzAEw7gcS66SziIrLmtW?=
 =?us-ascii?Q?1FQVbJVZtsiZKuzWQmwIls8b2ed9xFaB1styeuHC0c0pZMJ5cYjMkDZ7qOzl?=
 =?us-ascii?Q?FTI8JrrS6Gf3DgHHs3oumlJfHMpIVepSNF3NfJ93KY8euxbr4OPmz2YkVaEq?=
 =?us-ascii?Q?cj3rh4NN8ZHFER5LNonCzHNlzIFYB274vaL5wqFpr6d7LwgrX9fOOfKaI3PU?=
 =?us-ascii?Q?UYg7bjJTHdzUoRHQJg1TcWhvQl5xPiXK49gp4xUf0jlT1DUfXQxXyvLzfE4H?=
 =?us-ascii?Q?tJ4ID4JQ67/t1wtKY3oGO3Gl+IsOuE5eAsQ1KcNDIruuwgqO3HwmE/cNvAvK?=
 =?us-ascii?Q?Z7y/R1Ga5S0eJnF1sfkWU8xaWiuv5Ix1L8gLquM9teIvBSkmMtg8b2Cjb0HP?=
 =?us-ascii?Q?4mrfP3qTDW4LtQo1fawZE6uuASYZAwQoBE5dwO+DK9CENWmjNbf18hoLIqen?=
 =?us-ascii?Q?+akUHkhY0CbmBSjMm6aFYFsg5ZWhnebKtNPiw83/8eyzpYSbvjaf2KjRRz39?=
 =?us-ascii?Q?UDCgevtSBx8STrVkG877eAKixSsogdNDCZEZOKGHS+py7zY2yJTzP5lsxRJw?=
 =?us-ascii?Q?lSLO4dTCTAeDD+6AGBDNTgGjqjmV/3enzBTDFK6TvY8owl6Oit7eP/0rjviw?=
 =?us-ascii?Q?2rP6QVNpvf81eHk+5oYZkX5pe+V0Toou9tlyLmdTEmRMzv9N5wWsIZuX/FDO?=
 =?us-ascii?Q?Wbo7dkIJU/KjoPubHjrc5T3NMAElvLRwBkq/ScN6kWoA5VQ1JFJJVPUYDkll?=
 =?us-ascii?Q?3EapSXy54N5GcwycTIbSvcgu9hFhrHTUwnFbdevI89K+Eu/OYJWwngn6pfNj?=
 =?us-ascii?Q?mFwSHCr8hitcqufHa/Sya8vzfmaFwqnUIoFKMLWkMgyWw39n7bRnhgi3eNTT?=
 =?us-ascii?Q?z/pPfCLmZgen0QMtBs0Z5P//l4WDWJUW0SuDttVN5s1BScYaDbitmi+Pkp8K?=
 =?us-ascii?Q?yT4neAsjidiE5XHmsdVBT9Y7Qzzauqx2Raqee8C7bfrH3x3gzZdE7Eg+4sPn?=
 =?us-ascii?Q?B3b5/wVakgVB5Lm0GeiU3D0GiaXXqcdgPY2JLGYgl1ucaZHjejAL5YoLuns5?=
 =?us-ascii?Q?gw60MS+99ZxNnBUxYANp/scoG0NCQ9WO8PpEUMyjDII4t2WIB07roMwFYinE?=
 =?us-ascii?Q?FOr5BzCpQ+1FBJcAX9iJsVOjAs/SAoxLk25iluk2zzyMnvYs9EXuwr49x9A+?=
 =?us-ascii?Q?oc/q/eanv6JOHBLI0KsFdRpmt5OuM/TH5Ke1RLueif5xO+n2yNMnDUeUSf+P?=
 =?us-ascii?Q?bhbBNJQvtdnjdvPhs0mxfQxzKsm1U5T8OpDwNbipHJMWIX1x0MKPkHPDB2gm?=
 =?us-ascii?Q?Fqd7+C7VarAtb4bfiESZ08vlrpSlACqqh+8ccS38b3NHvHMlFWNICFvpivXV?=
 =?us-ascii?Q?IjKfNv2Bo8XJS4ra8sIIhQeWzSkgw7qKCvM3pw697KzGj1rImh9ZBWRq0nzM?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?eRdV5p3Z/+VOzAIWWISrqlwW84jSzrP3dtyWeIiZPm2Hb7ddLiObrkxsNBOr?=
 =?us-ascii?Q?ByelaoZO2tAa9RJ3M2YeQ7gw5gkkIrexS184yleBA10Ga6WxiscJI4Ze8kTq?=
 =?us-ascii?Q?EwZfRg6pt0HGtzrPR/qgQoKARz4w8O6IhQ5zzJAqYTC1WL/UnUO+JMwLEsA3?=
 =?us-ascii?Q?5RkBCuZM/TQ4p+oPgpZgVlpf8WmVxOcp1pglFaEo7X5Oak5nTNLMCFHN8+xN?=
 =?us-ascii?Q?bZUw4FWOK49BL9uOF97N0pasybgNi0mzTkwZeRvT2hy79mV9B2he524QJy2t?=
 =?us-ascii?Q?7882J09TVqfJMzJKrjmi7MgBNiZPgWe8Gd0nU+T+S6HgUNcqwwo1Mi4856k8?=
 =?us-ascii?Q?6jZqZzJ1eYjbfl423KAd/9hCAyreatBAazxw7e1JVx69k/rFu9mwz2R7lbbU?=
 =?us-ascii?Q?jAaKbRnkAgJ/SAwWrkYUXCPJqruU3xKX1GgIt/Rc4d4BHz3Um8ZRin8yJtn8?=
 =?us-ascii?Q?GxXce5T1jNmZR11rOwNV2XwhNvkkJ8o5FMk2oZKX3M4/+/ylckZ+r7E+JN4S?=
 =?us-ascii?Q?Qd5k4k3p+8hBVrDu+3trr+7tkZeIMfYmzM1J09x7/BnHU3XYSGHV6YjXxcNe?=
 =?us-ascii?Q?zoSjz8xDOWadxxNUVyntguRoU24OYje8VPuuaZuw2MIQ14vJQt/o4vtnzDc3?=
 =?us-ascii?Q?0Mvu1Im5mZ0eqWvw1MN7HmTIEimt38cFUfcW56mO5xjIEXdLW60ffui/AbZm?=
 =?us-ascii?Q?77aHRVYgb6KXUBERmWt8W4+gi/QK/4TFXeu2ZeLTxZjkb0+lLuLnWqq5OzGK?=
 =?us-ascii?Q?UBsHgGyM7qwEd4rh3R5gsgd8dzM8mCcWOzhw1SecGu2qaMmxQsYLKZ0FD6PU?=
 =?us-ascii?Q?vW/1Ovg/YDDJqxvLOQuX4RN8gf8AfAqeWRc72Kh8OagP+tQCHM1rflR84pFt?=
 =?us-ascii?Q?1zyI3h3QIZeOSLUR776veJEdHfA87LUfG4MVbKZoDihzVC8MqH39dKlgD1l1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71d81bb-e9f7-4de8-c00d-08dbe0cd4ee7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 02:41:00.2121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sjEqHnwZUCv2L7rPTKlzcCBlS56OQwUQuiND0/YteB8TQ3uwY6amZNUG5FtBlGr44YSUUDzh7wuGKalCzvrh0qb25vzpHPifvRCzr+Q0YU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=688 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090019
X-Proofpoint-GUID: Umr9jpGMdKDEJ2nUvnnOr5VlTpiIWmdV
X-Proofpoint-ORIG-GUID: Umr9jpGMdKDEJ2nUvnnOr5VlTpiIWmdV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> If command timeout happen and cq complete irq raise at the same time,
> ufshcd_mcq_abort null the lprb->cmd and NULL poiner KE in ISR. Below
> is error log.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
