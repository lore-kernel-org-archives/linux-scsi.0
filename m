Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA879C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C2364EBC
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBICUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:20:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBICUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 21:20:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1192ExN7178691;
        Tue, 9 Feb 2021 02:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pJznzUWbCUW68ngkM9p1UTOb736lkGBNb6mqZcw/r4w=;
 b=XXDGO+iIN7PdP3Zkil1W2/b0aVYdI06yXYRg+EbchX4nmfNbLrMxGA4UqI7h4pwmCSNJ
 yVrbha7nXto7Kztt7kYlAG+7bm/TQL264PtjV2hrQ7Zd4oZdnos7GDNH4UKwMH6yHYSY
 q4I35r6vkxFJDfwX8YapSPdqgroGxNIO450Z9mUgh41ExlqoIZOeQAe/ok+yymyOWGM2
 QxcBvwit4kXdbafU78hpK4lcqBn57iZQSkoS2nQhFrVe10CwrnhkoXdVwSw+iiEllNgv
 t1gpzB6ysTLsP5ODjVJloSuy3YG+NNC/MOWa89AE8icAx2aXLlheXxfrCe6bzxjtWm2l bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrmwxty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:19:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191LBom196203;
        Tue, 9 Feb 2021 02:19:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 36j51vdxyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBcpeaYKbCWmRkit0XLloTrT7UYegxgF/fy8UNW36uDB9byk1rDCfC6EB+pZCBWCwnjnqADUAIdsnVVu5YWxW+c4Atp7oJDllstVzAkSGMhrP2ttLHTrTrrjn2CgVV6Ki0+PVKt88kDnUd0e1GgOEv+ohgOja44NNDQ78AgtleZlDwNnHJLq7X66MOyOLfp8EOXjeeToG9DJ9rAzpk8dP6P9lixJKUVeBAmnTllYBUFdestkQaiOMD5rTrJFGSTo3dGkQ4Ww6hYkrqDASKQd3x9OBBckkc1lHeBwl+nhh6hyTnZ/WLqX/sW/JVhl4nmMxPeGjIrJAmV4h98zNMh47A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJznzUWbCUW68ngkM9p1UTOb736lkGBNb6mqZcw/r4w=;
 b=ZbmSN9aspmZCDBsoqbouIHRDupKdUEYpEnhGj9A/Ll/gHAdqqUN4oUUYi2sqtZ3fNJXKRlOk9she92ixfTXTKfCcTiYPExQu+tnV56+qZij7WVpOWP3NgIObvA54XRKWnlGHNGCgTZTCzEW4eVpoH6wmu6xcbdE89BHHeJAeNMJNVZJzDf7jGQGRKIbxLOvX7UBuQE1gCbkV9Qp15HBDTrSwo/ASGb9smEkktcO5x6B56dAw/nrOaeGSWGdqaxa+1JfW53MGnqPTndN87H1viK8WBrTv7TYTFk4ff1to6sEJq63Qomh1/uKa8X/UwX0rNU/TjxPz7o6wLQrctxCW+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJznzUWbCUW68ngkM9p1UTOb736lkGBNb6mqZcw/r4w=;
 b=wGOBcDsFYh7PRqz1xNZin6D+IkEiRUz6NY4psB8FoGiBPdmto27DxYcQv5dnHiK3xT8bs4PUA7VI3qYuFvyPCkEO3Wz/e3w2OMhjnwHO8oC7Zv9rmJ3h4d1RkfNQJ+pGU9c3wXTbuTmgHwrWrBCyiNDQecDfi9VaupKKeRS6uvo=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 9 Feb
 2021 02:19:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 02:19:52 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: warn if unsupported ZBC device is probed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135y6t22q.fsf@ca-mkp.ca.oracle.com>
References: <20210128055658.530133-1-damien.lemoal@wdc.com>
Date:   Mon, 08 Feb 2021 21:19:48 -0500
In-Reply-To: <20210128055658.530133-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Thu, 28 Jan 2021 14:56:58 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:806:f2::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0021.namprd04.prod.outlook.com (2603:10b6:806:f2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 9 Feb 2021 02:19:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51586ec9-aa76-4a33-2bdd-08d8cca12eff
X-MS-TrafficTypeDiagnostic: PH0PR10MB4678:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46785206E6FE7CB44AB519568E8E9@PH0PR10MB4678.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ECQodDGMBr2A5UltWlzjdaxtdlDtj7tQzFfla8YRp2Nl2VWt4jW/BuEtn3z2Xo0Lwo5Skg2or7TYwL7MMj+H4ZvyGuhcPdooP8wQAsqsHtIbLzjtQ4I5TQI5v5a94/+NNVat0lq6y2k79gEtF7GkT9xaA6CCB28Gxk1GGwtbkQxvPA66NTnnW2KRcmWbgJCTO+X0CyGbdnljTD4FV/FWwIM3Xc8iGCx+QQsklKjigiLkM1HP/tYJS4KhoRfx197OSSPLie6MMzYzgMYcMTvtGvYshas48HzJRggahrKgAwgn7XiJixmPwOs421ao4iL/gis6Q2vlXOaX6gH1mWoJnyuyfvGGEWCgrFLGaX2xizr6OMC4dZxcH7loKaEgcXHoCTUUpEAQaFmXFMrutQiIa7VrCb3AIAxllkQ8J9WBf1gdlte18vN8g8seaotbsFHWxEOTha73T3bNXbNGQcbJkt04r7h21Rt+Oti2jCpJdE/749FOAYoRmKMCWVPjIsOKXs2ywGCgWLS40tzTtyqHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(86362001)(5660300002)(55016002)(8936002)(6666004)(478600001)(107886003)(16526019)(26005)(6916009)(956004)(66476007)(4326008)(316002)(66556008)(36916002)(66946007)(52116002)(2906002)(83380400001)(186003)(7696005)(8676002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SZyBSOSxC+UpYHkyHcgfn6sypXwyWw6uYxGrLsa2ZPPsN2ll5b1HJyeaG9t4?=
 =?us-ascii?Q?/6xFhfxjkkQPkT3XV2gEkRIzHphApSL6hK+HFBJeyPB/7GRVHVudQi/TLfl5?=
 =?us-ascii?Q?TNpaYD24Ly6KXVGzcqDgxK/ZdTSHfU/+np5S8yEv5LOpQCCO2mUH6pogdGRq?=
 =?us-ascii?Q?kYj6WV3yYx2fgYfFvZC3a3gbTNU/1PZjvkKvJX9z+BWe9mM56cEywXHe0e9d?=
 =?us-ascii?Q?MISbAoetLR5r3529OAiDZLGXcFY9tT8egNQ/u9ZAXePVB4wllC/DL5ivYr6l?=
 =?us-ascii?Q?iFqWFsRor6w7Cuh5YFpE/cWXyddJ4Z09OJubSwpVYjJX+dRATDZKotAHOsPp?=
 =?us-ascii?Q?YE2sH9MLL70Crj8NL5lp6N+jq7J9p9lxPljTZBd3r5ibxNXxE9Z/Wu71qNRh?=
 =?us-ascii?Q?/GBEiq/8uciz3816yVShXkX5nikNv1/POICMCDIZbeMAdLtBYMoHUeLvGp38?=
 =?us-ascii?Q?VCWhhGprsbsQv8sVeOaqKGv/urIepwQK1od27F3cDIl8EIuGSbAsLKYQ1vgb?=
 =?us-ascii?Q?0rc0JtkOfUnr5QJxhWuVJCDzCu7ePIMkAW05Yd5JCFMxSVctbAViqZrUkmCj?=
 =?us-ascii?Q?87LjrCcc0H4f4ekF070M9hGRIwuTBsjkNAKN2l949wDoSxlVroNhymbZyAYv?=
 =?us-ascii?Q?Lh0n2qNLO+XTdgB8urk2flZ9IDoCIxGpP5SG5RGpwjRVr8mB5C9gTJCk/h2l?=
 =?us-ascii?Q?MZPveQmrsh0Ft6caX047pRezTvJq2Kml9WYQc1dpFpGAHpWSz5Bg/yByHoD7?=
 =?us-ascii?Q?vHSL8YpEXXzjQWzuqQw9sjMx64A3Wqd9bimisNLZi3k6JtcqJj9o6TUmd/pC?=
 =?us-ascii?Q?sOXaBQgdsjmoZsv0hkR+HiG3n2XNzyoDGCaRyfsg7hKCNIfABh8yG3fAyurr?=
 =?us-ascii?Q?xGj0o385kKRZIhHG9HMhtxWwm39SikupXroRzQP+Qsm3Lc9whKi4swAwkXXp?=
 =?us-ascii?Q?j9F8CdUSLadEGC+c/2f4MF5661ILK472DQR42Eww69mpCLoWztK6pZUrZYnI?=
 =?us-ascii?Q?0l/homVuYqFVfq8NNYXIfdpvWiHqUtVrz9xmP+Pvt/4DyOVOSkzDbKqF4Uvk?=
 =?us-ascii?Q?ymhUSfm2vYhfYLnVjx6jakKIO4ZOxTzZSwbNmikgigKTXMVNkppfYb2zCV/+?=
 =?us-ascii?Q?K0ElBfZX2Ps3Y330eYFpFeUC0ZvW49fxHt2MKMz6BnxL808aH/f/qMqG/Deg?=
 =?us-ascii?Q?Iz2Kfv8QHRDAz6vVbUGTmEIkJ/KxRL+MKLynQnb2AJLgiqxdeVaCdynI+P3w?=
 =?us-ascii?Q?2HdIJ7mVkeMN/Nq08pX/FKLfkPRDzszwdxqtus5dSfEfb2AX39Bdz7bG05CQ?=
 =?us-ascii?Q?lU3lCSu2c4PdTrN/eR73JjaZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51586ec9-aa76-4a33-2bdd-08d8cca12eff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 02:19:52.4146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: du7uqJVCnVjUHegqenJew+44RZkogsKKPlLdz55eZnV7IGPO/sJQWVhUrhSErMVkKy7xkyk673icsZeIyH5XSPhLtU9imLm/Q+2AoV9HLWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> In sd_probe(), print a warning if CONFIG_BLK_DEV_ZONED is disabled and
> a TYPE_ZBC device is found. While at it, use IS_ENABLED() to test if
> CONFIG_BLK_DEV_ZONED is enabled instead using of a #ifdef.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
