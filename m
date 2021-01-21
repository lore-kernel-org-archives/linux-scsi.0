Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E01EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B9A2389A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbhAUD5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:57:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbhAUDij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:38:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3Uvwh194984;
        Thu, 21 Jan 2021 03:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wVrmPwI6jofqkGOpExPp4HDcByZIl0WRa3zT8XkVcXk=;
 b=IIElr2rI1eRuXrF41RIMf/VRRhnuUiov3ls0WRivILwO/Az01J/vZ3V5bIzTc0AKKxch
 Q+stvrp/373mGjdAgGqhk56j4foFeccMdJVANzHOLfJF0/NgPxny84e5nPSzjw+2TiuT
 hSlaOCCwOU/GXFxpB/kJaX5Faih79QJXhu05rax7zhwlzwiWTMBoAGw8/lE52dyZLEQ0
 UHXefgnZsbicW79JAS5RLUgpDijadkA6UA1FYOg/rgqQ4jRAy+a5GadfMprkw4bMxtqG
 SR1nlrDrRcVwyfOAxF577KMNAoq2Yhz849byGQo+yOPVLdXa//8KHsR7vpElyUMREQCz MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3668qmwcrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:37:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3Tq8P024405;
        Thu, 21 Jan 2021 03:35:12 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2053.outbound.protection.outlook.com [104.47.38.53])
        by aserp3020.oracle.com with ESMTP id 3668rf125p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:35:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYOGyNLeI3DF6R9KxBI3ffBvnEbChUySTpUDdInh9L0Xvt7lHbxY+p20EUEI6Bk+MxkKecnbiSp65rHmAVzi2bYVwyCgznyXD41ylFywMjomoxr99WnxXe1RHthaRrQvz4B40/7ZeCBgzEvb0qZlo9GLnHRP3qrXxsNuuda/TrKbOYWiwSp3Rns9ViQVMRD6LDDgl74UeLoE8h9LqUBGqbp/xeIbUcW4GptQsySnnVaOyWcPtwdwORZyaS9NVhvzdY08xqEZUNk7mVQCutmbJoaVK+UHsI5QPRSggh20YOT1i9gwGWomkDbi3axJLS1DO8yEB5yRyWXozySJ9+wVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVrmPwI6jofqkGOpExPp4HDcByZIl0WRa3zT8XkVcXk=;
 b=EPcorQenEpnXg9QZIsdVFfga+d3GjIfotwn7BAvngrRbetM7gb2OKE6/emWePAndFLedYP2u3tDQ37g4Bx9Vp5/mNuSruDRlB2YyxPSBRivftpksRUyhbbxIJeILMKEDrGGaLxP+7SgNzLz+8aT0axEgHmP2nZo3oNt9FJQbHvPD+VK9+yDNJLpvHK/vQ//5/CbZsthfesesoEFNltGWUwupMJkfjSBbdn0DqtlEXY5HMyU+MxYd6qME9CeaiEvjR5rF3GcexYq30ZB3kerePJPMi7DzVeTe0fLHudZ7HJfhAe6KXkaycI1H1Vcs8KYcsQd+B7pbY9BOqQTSS6fi4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVrmPwI6jofqkGOpExPp4HDcByZIl0WRa3zT8XkVcXk=;
 b=m18p83nxMjfXACsy+t6ylTlAvdUUZ1bzUXhAGfXNhh5ddQZfwAAcZ/OwNzAMklO+pJu0Zc7qEgK0nkdfcKefBla6EXRUg8x2Ixj4ZZRt1sYDFfP4+185r043DxMq0zVg0Hce/JbGRWKspP5bOIzKqRxkgEV6oRdspPsVlquYyqM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4679.namprd10.prod.outlook.com (2603:10b6:510:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 03:35:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 03:35:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Enzo Matsumiya <ematsumiya@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH] scsi: qla2xxx: fix description for parameter ql2xenforce_iocb_limit
Date:   Wed, 20 Jan 2021 22:35:04 -0500
Message-Id: <161120009454.28770.10594713353353961556.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118184922.23793-1-ematsumiya@suse.de>
References: <20210118184922.23793-1-ematsumiya@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM6PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:5:333::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM6PR03CA0076.namprd03.prod.outlook.com (2603:10b6:5:333::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 03:35:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65b18038-c045-4f7d-bc3d-08d8bdbd8e04
X-MS-TrafficTypeDiagnostic: PH0PR10MB4679:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4679312E9BBE2EBECF86DB748EA19@PH0PR10MB4679.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPhJuOQ0V7vbIMOoM+p/08dm5sUnbyIVofG/TihDp8rrwNVTFPbVBWTencKi/cSvNOmGzk+pOoOFDz3RoyrYmyk/37DnKPuayzDUSc3zvGtdr8AMTg79t5fpAae71pbt+e99fsdqteB2+6ZcMAoCao9hUN2eBsva7J5yAaAZnRYcXY3/5Er2tFyYIoHgw4fPClryz9EFHG97OMMp1UAJ+lwhMBj7cOMe8y+p05oM5BPOOx3F+qo+U9CeIG9xbGP32pN7Vo7nGu1zLB5j/FuUNqQQFrQmzXhNomzgl4jzZ+/b+LxAaUJIsRJ1+hFtGCa2lrdwmlT07zEVpdG6RdVpk7HMqRoI+BNS4VLKfIVG6dk0q3ZtPmJ5z+5XOqSPz8Ien4UjmKOn652oburOLWixKOsZPyDj6T5R5SQgXgFHXgUNP2sK9HJm0DTktFo9GTdGiOD8WwojYr1TEQevQJl4wA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(966005)(2616005)(186003)(83380400001)(4744005)(16526019)(6916009)(956004)(36756003)(8936002)(2906002)(7696005)(52116002)(5660300002)(6486002)(6666004)(66476007)(66556008)(54906003)(316002)(66946007)(103116003)(26005)(4326008)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VjRaRk8zVmZuVHg4OStKMUwrb3FCK3BEVEhkSUlqWVhuYldXbzA3a2s2VVJx?=
 =?utf-8?B?R0JIeWVxYlZ6eWpKTTE0TGFCVUUzRUZRSWJFa29Gd1grTXlKTDNKRHVZVU8r?=
 =?utf-8?B?V29OQkFTOHJxaEQrTTduU2tmTkxFU3JVOG1Ubk0raDRMeHpoNVQ4Rk1RYVhH?=
 =?utf-8?B?QVVGNU8xMWNGNFlVQldUUDNhSEk2LzZKOWtnK3RaQlo3WkN6dVdiT1FEVVh5?=
 =?utf-8?B?REM2VHNLU25peW44YkQ5eU85TmhHU1prQ1gwb1ZRU25NZ3paNENGc3BZNTUr?=
 =?utf-8?B?Z3VhWk5IOENCeDVXTlRlcHE4cTFpVU1YNGQ0eVVXWXdVOFFoNW1vdmh2Nzhu?=
 =?utf-8?B?ci85emVQZXhWSnFOeDJ0TDdNWFc1N3FWdVFpUmNLVzRKTnp3Vk1Id3BxTmlV?=
 =?utf-8?B?Nm1CK1E5cWY0TkMwcjNrczlwRjJ2dldKa3hFWWJEdDFjZ1d3bFVEYW9adGNx?=
 =?utf-8?B?MGdBL3A3akRvZUxqeXZjcWN5dFNqR3I3TFZPM1dweHF4NktldVB6cEFIa3hH?=
 =?utf-8?B?MGo2aEhTZ1pORlgwUVhlb2hHZTBRNW5HSi81OTFGbFVnY1d1WGdxQ0QyL09i?=
 =?utf-8?B?cmZ3ekRtdUFCTGlySUNKWUorZ0RHTUNhdWNiT3Y2cUczRHNudFN4a2dpQjlr?=
 =?utf-8?B?WTYwTXdKTjZvcFJiQk1abVBGQkczTGtBZTJmWG1JYW9naTRYcWtJSE9tcVRT?=
 =?utf-8?B?SHl0Vm80d1M4a2ZLYVh4bXNEdGV4c2NpM2VwMi9RQTdtYk1STG1qTFR5bThC?=
 =?utf-8?B?L3JsQzJCd2FFTnMyNE9EZlJkMzQzQ3pTZlRYeXZHVWwvM3huWUpqSm5WOFkv?=
 =?utf-8?B?NmJ4R3F1YUxoWjlielpWeGVscjRQS1JhVFVGZjJvenB0aE9wR05lSy9QR1Z6?=
 =?utf-8?B?TFhWOW0vdUVsdTVDZTNoQmtVTGNJc2V0VTliSHZlbWRuK3dBZEsvS08yYm0z?=
 =?utf-8?B?bHZVNWl0dGNMcnhTcVZQZDFON2J2TmtVbzhpekpKZko5UHQzdmtndHBxL1d1?=
 =?utf-8?B?bk9zS1ZTVDJZY2x0OU4ycmlSTjFheVNXMXFkVk9EQm8yUUNEdjVJUVFFV3g0?=
 =?utf-8?B?UnZYbUNaa0c5VGhFQUZiZDZ0dEFGR05zVVBpS2R0RUt1Wjlsd29UcGJJSTFJ?=
 =?utf-8?B?c2pQalEwaUgyVHVNNm1iT0tYa1lnem9GL3QxeXFwazJwQVp1dGNlTlJpeHBZ?=
 =?utf-8?B?U0d4b3BHMXZmaE9WRStqQnpuY0RkR1lzR0J5TEdjaTl1cEpxUVJVVk90T3Rx?=
 =?utf-8?B?MjNkbU9McllqYVpFNHo3ZElZNGJVRUxucE94VHNEN2xQSWljeGVpNGQzcFkx?=
 =?utf-8?Q?xiUvExqwjcEYE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b18038-c045-4f7d-bc3d-08d8bdbd8e04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:35:10.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dk+CtSa1cCJT12iiy1SqdnxqHEWDQMpcyuVCVvXnpfzIDnFjF7AYG6NaZnUfddZeNcnbo5tnCIkbt6pFEc7T5XbpWn+nUk9yKez6IlXpcd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4679
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Jan 2021 15:49:22 -0300, Enzo Matsumiya wrote:

> Parameter ql2xenforce_iocb_limit is enabled by default.

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: fix description for parameter ql2xenforce_iocb_limit
      https://git.kernel.org/mkp/scsi/c/aa2c24e7f415

-- 
Martin K. Petersen	Oracle Linux Engineering
