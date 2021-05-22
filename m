Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E26C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9876D60E08
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhEVEnY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:43:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33266 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbhEVEnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:43:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4YuUj019852;
        Sat, 22 May 2021 04:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sJ/3nAj3Q2d7YCeeS0ksJqmHOfAPX8uhZss6OpRRKUU=;
 b=Fg3TIOdHJ7Tx1IsV89Az0Ww3bhhrRf1bg2gU61+S0RhSc2UJT+9igrouM67Tfrmbexek
 CJ8Dc2QvifV8/sT/BBkp9f3KLLhIfeTafcSBJyg/6rheFrturJukF47kmhS24pSGInUU
 kdRgx/Rq4Yi9ohv9nO3Vkzzj4oF97rOboNkVry9kLzMB8Wh0j4b3mOSoKJz+An3q9JxJ
 fQxc+E7aNlOF1k/gRJyKLXdhDkAueViDn9OmG4NyjvviNWJNnAlrPPZIVPwN8fSVrzi6
 zc+9AYB6s0UCxNAU+SsTSIznJwSEOz/jtPUfF8ilDRGYFhiS7ShNCKJvT/IxT2POOoEd Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfc8474-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Zjii168565;
        Sat, 22 May 2021 04:41:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 38ps9j33ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCYT/VbadbhRkL19nac2bfsLEc0EP3p5HWgtPuWpzVu9TbQxkLT8gb063xXAi09RixV92lUK/Zy2KYszzVQTTSpe5s4y0xY5ANr2WWw2jMI48nPFYNm/RM/1Aurg/wWmuikBuJuJX1jqBNKit2m9HlGO7F/TPKRz0TyFKGu4BPtTiTqVGqThkwj/nToFJs1b0/zNiVF/b+sP91nBuZSo+M9iDpdO/0Ljcy9zzZnZWLQcrCphxq4S/uBlCLev1tbpo/ruQ3U/jWyh3/rBkVZ9oRBsTibbRPt6K0Y/UAmDwXeI74pRF52Jvwmn9S2cdHGTu/DVWOKzS5kdgxlhsJTh0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ/3nAj3Q2d7YCeeS0ksJqmHOfAPX8uhZss6OpRRKUU=;
 b=Auz+vMRVOx6CP+l0xIWW6NA3UarkEgmfFj7D9wdDBTIH/y8I1FDRveBbT8/zBix4hSeFrWwweeaHM4NA9VhQROgg0TbTCqG7GLW249SrgnV9ncJGchq7j6uEPXRaWLhWqLEeuFldCKiBwUv/LA8vmJgC3bYmWTs9AwHGetHUzF5N/OdzqqdKAtO6jSbeMQsNEu1ZUtSKd/skQWm2Y+w1QAogKivlUPLOmNiviMhh1u7iSHUpdZBR0Kpj4vqBlR9FhMBhZCHk3dNsXXtMpTdWIEWtMp26G/Qt0gEUsjdNt4BZRTRvP89OC9SLvsUvzIGc0csbIIwT/DDuAdwayazbWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ/3nAj3Q2d7YCeeS0ksJqmHOfAPX8uhZss6OpRRKUU=;
 b=vdQgmmVW7wcJiKqgskmRjySprhvhNzz/k+Lxf3GqFZqrkllxBud6bCTXS0vXPELkZ8lViFaWNnRFE7CgnRGcDmXjy1J1UbgbTmLC2BPzAJ6cAQKnU75MDzBuSl3cpyjB9SnNqd3hekwe/9rJzwoxd25OyBavGMOFFlAwipJKojI=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:41:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:41:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] ufs: Remove usfhcd_is_*_pm() macros
Date:   Sat, 22 May 2021 00:41:30 -0400
Message-Id: <162165846771.5888.13080304364415477875.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513171229.7439-1-bvanassche@acm.org>
References: <20210513171229.7439-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Sat, 22 May 2021 04:41:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 089cc764-6f96-49d3-ee30-08d91cdbe382
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB548185F90D580181BB5E75B58E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:350;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x2bWvxlPSEdo9X/Qon2miRkoUTBiI87e1mDl6bgHNnrvDsa05heo7jFvljW7Img1jPtKPLylUuTevGLOdj2B3QoaA5AH/E1BAYpCFfPnCAy9OE3aw+YGkwGP64DrQy8SL0nUYH0B2rUbv8jLaq9V62M5l/pRNsVjSQvSFWXeeYIXs74r2TkzkAyL9SdeN4kKZMWazUT41sDmMTRU9HpDqYDDJ8eQOwNpUQ66hqCLX/WR5z63tRgs8O2sW1ACMr0uY8XY5DeG79S2Aw8NQ1HcdBBI3w3v8PWd1KZEdZ82bbTSryntDRQgh1ZCc/pMjhU0/24Pgolvw4XzqTcTSNUkE3ApH8YnOn+Ma38Chv7GALNSSVF9LoS+eWNHuAk6mW6Aq5xYaKfgzg5GoAh0zZiux9BbmE48Uch10H5E3xZ9THKhz/SgorTmBq2TXONwAPxvnqXkWkFrRVMw7XROhHscxN+ohwvGyF5JNdhpxIWhVgdDeO3dh4XKaBvMLbN4iTBDdlZdB6+TEWXKvqb814X0aRW85MjGP+njsJ7Q5p+H+60GLUJOsyV6ACu/P1kjPF1RcxUePp4FdnSiXjm8mphYNjyB8ehj0H1sE3RjBZ83AP5/5L0VUo2TC/yVerXy24CL/P7Z5P+BpDocoLNhwmvd8XLfGGtjI2bS6+pF7AMYZvxHYptZpqbA6kGOZtKei90Cu86V9LQW66/NBXf6orZoYEMtV8FFCnwWosHx6Mkrpj3W32+LYjY1O2/6Bt0kznVZAYOjlK6rx/PnoTU2mKZnQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(6916009)(38100700002)(38350700002)(66556008)(66946007)(8936002)(54906003)(5660300002)(2906002)(7416002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WERIQ0lDWWxKREJKNVNSZUtQUHdwaXlZdHczNnBFVjJZczRuRVh6dHZMWmRZ?=
 =?utf-8?B?bDhXZXBYWXd5TVloOEI0Tk9CQXV6OUlrdE1hZ2U3OVoxTlVHdnNJWmFIcFlT?=
 =?utf-8?B?OGhtTXFTVEtoSVVOL0pDMWEzV2JnZ1dFSmxDcGgwazhYLzJhMnJ4OWxTQXZp?=
 =?utf-8?B?UVFYQ0kvNXFBU2hLNHVUdDRXRkxWWE9QcXhyTlIyWjd1VExDQmJ4SkhJRHdq?=
 =?utf-8?B?VzF2azlhdE5CQ1hYMWZZTGYvVmJXOEhDQUpua1NnSms5dzVwUHFlWlJmUXVB?=
 =?utf-8?B?S1ZReEREN1RVMjdMYVNWUktpU1ZpZVUrV1lDY2NJQjgwRWQyOUl2RkcwZjEz?=
 =?utf-8?B?Q1hjU2Q1L2dnbDRoVE0xVGxGMGJIS3pEcU4vVkhuUUZRbkpCZmNRZDUzTSsz?=
 =?utf-8?B?SmhGUUhhZnRBRjkzVEh5b2txd0gwRG5MMDhIME5hWUtuOGE2Zlo5RGE5TUtj?=
 =?utf-8?B?RG4vYjEzT0hyTHlHN2NzRFVMTUNpZDRaOHRQQU9tVGhTWHk3aGdZcDNKVWV1?=
 =?utf-8?B?MGIyMjNoTGlnZWhzRlVDSFZxUTdCOFlMelRORjJrRkxIQmszTlZUeCsrOHcv?=
 =?utf-8?B?dUhpdDE3WWQ4TDcxUGlST2EyZXZlOWRMQVg4cUxrNitKZHc4SGZHdm1vSndp?=
 =?utf-8?B?K0gxaEhPeGtCZzZublRnZGVuejR2ajkzMmQwQ1plc3g1WlRPVnV4N09BaVRB?=
 =?utf-8?B?SFl1dndnNUp0R1VXSG9XMzlWRzdJS2Q2QWxIQjh4NEw1QnVLMTFBRnQ5bzNv?=
 =?utf-8?B?bUVib0FBaTUrR1NOY29BWUZod2w0TDZ3anVIb21xand6WjJjZndYQ3F5czRI?=
 =?utf-8?B?R1dwb1ZFMWpna2ZjOEsrNUhoOEJlOGZpRWRVMVVVSTZNbFRQc0Y1Tk9Gc0xC?=
 =?utf-8?B?Z2x5SGgycVpMQU9ZTkxXYWp2YlVhaElsVUlDdjFEMG1yb3U1YmFEK3VjVXMz?=
 =?utf-8?B?RFQ5RkxsWUpCNG5DQmNrLzZWMFhkcjgyaHpFNGUyZjA5RHEwSkt3c0c3Y3Vp?=
 =?utf-8?B?VEIxVGFwRWZLODVTYmUzWjRBMEJjODB1NXpaVXA2MytGMG9yTXpqRERWc0Jk?=
 =?utf-8?B?bmNrK3VHOUxsWlpabTZxU1dqRGcwcVhnWVpEMXdLVTdwTkkxc2JZWGJ1bkpB?=
 =?utf-8?B?UDhkVlpPT3ZBU3l1KzlMc0NSNzBMaHZLMVFqbHZ0dDdRK2V4M1dPQVlaS1RR?=
 =?utf-8?B?d0VlSEd3U2JOZnFpcHh0dDRNZXpDUXpXU3JNVU5YMVMya0VmcU1jb2phMU9W?=
 =?utf-8?B?SVd2ajNHUTJSWFpZNTBvUjNyMFc0aVc5YUxVYW1PM2NTMTdocUJzQjFYMk5N?=
 =?utf-8?B?OWpWd1ZWcVJSOG9sYkExTkxwVEpMZGNkS2xraXdhbWZHRXhNNnNBQU1NdDR6?=
 =?utf-8?B?eThMRFRHVDhoWS8raFdZT0haWnAzdjRkQURIVmhGK05zTUZSZFpPRUpTQm9Q?=
 =?utf-8?B?cHRseGNkSXBZOThFS3JuTlBaTEpTa2NJTkwxNUZGRmdTWmxJOFFYQ1ZPcW52?=
 =?utf-8?B?aFMyQTI2QUloaVg0cXBsbjNXUGsyeGVhaTBaWGtEaHFQaXNzcDRPUjdodnlB?=
 =?utf-8?B?MzJaVkpGVU5HQ3h6T082ZER1MkFhcUN5NnUweDN1NExwcEZEL3NrczBWYjBZ?=
 =?utf-8?B?c2sweEE2SWVrVDh5ZktNeWk1QWpKYVdmQlRSdjlxWWM4Nm4waVJ1WmdINVNi?=
 =?utf-8?B?ampZOWtPZVFwRkh2QTBBWG4yS0FVaThrc1ZJMS9mSHBaeFNyOERsTjdtVFVw?=
 =?utf-8?Q?5JZrWQjAKzElul0cXkLmHDESziCGIf2uOnQyeup?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 089cc764-6f96-49d3-ee30-08d91cdbe382
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:41:39.2439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJDfyNQ19FRK3O5v70rS+CAyQYBvOBBat7OyGJhXYYVdcnerD211I4M5CK0cJmboixWqRMppBX4kdmS5mlhiUNRsMQK4cEXZ8l9/bSWNujU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-ORIG-GUID: tPopAx5tvZHHKCmysFa5WB0SAdoC1eG7
X-Proofpoint-GUID: tPopAx5tvZHHKCmysFa5WB0SAdoC1eG7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 13 May 2021 10:12:29 -0700, Bart Van Assche wrote:

> Remove these macros to make the UFS driver source code easier to read.
> These macros were introduced by commit 57d104c153d3 ("ufs: add UFS power
> management support").

Applied to 5.14/scsi-queue, thanks!

[1/1] ufs: Remove usfhcd_is_*_pm() macros
      https://git.kernel.org/mkp/scsi/c/4c6cb9ed63df

-- 
Martin K. Petersen	Oracle Linux Engineering
