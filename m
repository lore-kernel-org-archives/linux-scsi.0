Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48713C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0856723AFE
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbhAOEJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51286 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbhAOEJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43wiu055358;
        Fri, 15 Jan 2021 04:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Dcbl9r2aS/bW/TyxIctTcMZ346zMRv79d6Sv6nNN5Ns=;
 b=PGua/Srphx4bA5bZVFZTrJAKb2tj3roFI5pz+2IAT+Sy5x0ubCVIlpOM8U7W6/X3Iwte
 GfgcUrnKEtCWHAJ1Q2+maPjHlf29/Rtg7QvobN1SeJ1IlKJWQmfm5yhbTh6zW3QYPHg/
 bBIQUc4R/Lw7ipTHHanA7nUj2yxkw8EHL+P34/Z6Ay1EKXaUHVC0nsKoxKQ2Y+5O/GWW
 T/jfaTN9yPnFVYImEbrW+ykGKzpeEM3FkiQjjH+b+idZ6sCaAyiV8EUT2tR5G44YzLx+
 Z0dsz0TeOeOfpFxkh73e2eXJziV8jqIzcugqW7Mej9Kfe/Jv0+E5nCNqXkgF1Ij3lugE Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 360kd037vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F45nJe019169;
        Fri, 15 Jan 2021 04:08:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3020.oracle.com with ESMTP id 360keaqqh9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmdFSzBqF7BtY4UhJ2+V8Ken696Pvfwf2pfZEjahCXzCufghKEvGAtWuIZ6ya/Tve5uZUgwW/bFru9mT4FX5QCakX7rGadpehRB2PL4jzhAUc2mGep9m1/lNQ8qKUrc2gIA7JrLneP/zsS6RgJPzVJFgqBsrhmF6Odb9DNIkyM9IBDxJxB5ZF7SQNe349Rka49jB58QHksUMfcboziFtD/a99HPIoty+0/k+KfWUQi7SCRKZn624UsnqF8bes+gFCGHc+5FkoFmHXJ36VXTuTHZwi5eYPI0JfKkV9WrJ3wnP0vVHKw67E2EZoQRfSP4qwQk02HwEOyNtOLf0wMWBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dcbl9r2aS/bW/TyxIctTcMZ346zMRv79d6Sv6nNN5Ns=;
 b=WQcBINAMRgm+TIxyw5WA8YsSc6F04b1M/k/7Xd6p/hztpJvYc369NPP22jfK1D1G0QJhb3j0TFI3ofhqpcTYKDmAWbjOGT8SnzYBNLEYqnn4ufBRjE4c+AfIO6nZQQ6DCeh86mJohV4CDXf1Lx1uQJWSsYFWsRttFzpzNfZW9awPGvB83K9AFD+Qmx0sWfk/jJETA1A9tjTLekdeXPwnWPYLaSNzSi6MVL8/+GS8tH0/qt5TJHifnb7bWeMh+1reVKuJsYMXea3DQ4Wvzh5neINn0tPEJAJYOipifxFqPY/GXDj+UcGBzh3Oe6+9UfVwL0FeGWftquyOLSAaeWvlAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dcbl9r2aS/bW/TyxIctTcMZ346zMRv79d6Sv6nNN5Ns=;
 b=x4oG6/v1tUr8oMX4cIECZmDzujhuU48NjE5NoklhORv5jrnzCbGD3RGc4B9eC07GWz3uv8rnqDS8csyb4iw8gZw7TNp2uFpnDiGVBZJxXC/utUUsjjJPGvACGcZDsRetky+g+rkDTZclSpZCR76V2/HVzed279g9/cUkJFzua7g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] scsi: target: tcmu: Fix use-after-free of se_cmd->priv
Date:   Thu, 14 Jan 2021 23:08:09 -0500
Message-Id: <161068343563.2956.1853300232107470407.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113024508.1264992-1-shinichiro.kawasaki@wdc.com>
References: <20210113024508.1264992-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR13CA0212.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR13CA0212.namprd13.prod.outlook.com (2603:10b6:a03:2c1::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.4 via Frontend Transport; Fri, 15 Jan 2021 04:08:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1713838-9be3-41dc-fd0c-08d8b90b2ddc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568C05032411141F5E6FA088EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /q2caWR2d4VrgP9FQpyqBqHVLlL9ExNNMjKMe5Qvn15mBVTR6FZwN1Ze77savA260BTGlLQfmpm31Pg0v2G0nMX/iHKugNP9wUloujXbyaJuUZ0X1R4i8aKjYsWv/DU25wWpbyUlXe9c3RfK3VhMfF3OeDIxcqILd9GS987ORnQdXqQAwxOqiFEhL7X0OmjTAoPEzkarcUicY6ew7Fn1g3n8YMq307HHc88RLytRue4l8JptOyhekUljCdw2OobbFBxKjZYpyn6PRoXPU/vxXRvDZ5TfU/e0AsvM5xq+IP5zqdTVLc7hvNhs+KPHIBMvby1f2zEbjZOE9NZ48lM+gE18H/zzBeZ2v6sGSApAoWrankon8l8BUTIGYz6apyfbOt3FZ3cdj4w9NmEekiRlssDkNQP7A83fXheNoixFwtaPxICRmpKoI3MyRkkgyoB4+mC+fERwzYPT8EOpTzEwJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(54906003)(36756003)(6666004)(316002)(4326008)(6486002)(8936002)(2906002)(86362001)(110136005)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TDlSZlRoa0xkUVdEZzVNZG5acDdBbHpFNFNYZWphUzZHek1GN2ZCOThYWHdh?=
 =?utf-8?B?VjEzQXFGRTh4NmZzMEFQOFdwdjAyZDVtRHBiV1grQ3l4cE1Cd2pFa250Sm9n?=
 =?utf-8?B?TjBrMGM2NmVkNnhQQ2hXdEJ2QTRCeVZwOVlBcnhiYVZGdDVDTWV0czY2ODE1?=
 =?utf-8?B?WllMZ3lWUkhkUnFVS0lJdHJPZmp4eDUvdFM0ZkkrN1ZuSXdQRE9TTHB2Z1Yy?=
 =?utf-8?B?Qk9icHZ4dENlWVFYTW8rdTVRVWtUdVlDdTZwQzFiZGZEdDgvNUZvUmxCRGlW?=
 =?utf-8?B?eS9rUE9KdCtodWhVQ3poc1VwaE1qakFnL1dWcFNYd3J5a3NCMDNGRThiVW50?=
 =?utf-8?B?aS9icnU0OWR6VTdMSzVBZ3dicmtzUGpDRml1UGxNL2J1MnJ4NnhlRkdxbGIx?=
 =?utf-8?B?U2U1WHpkdXFZc0tHL0xtZEJma0FrcEZSc3h0Z2N4eEhLRGI1MmN4M0FjdVZK?=
 =?utf-8?B?UEJYeGpkSHQzS2dkVHdIVWx0RHpoWjVlZXdvTUVqbURGWUR2cm00QjQvWTBN?=
 =?utf-8?B?MHpSTjg0bDhaWTNQWlFvc1lWUUlieWtudGdtUnI1NHp1QTR1THhsTkYxM05C?=
 =?utf-8?B?RWdLUmlXc2pmbzNDTzVtZXJwcklDaWJjY3RvdkJNTkNPamE5clVtUUwzcUow?=
 =?utf-8?B?WkptdVlzbkpVTXB2Uk1jaWpOd00xM3BXeTR0Y0UyNTVJRG50L0w1MmlHTzA0?=
 =?utf-8?B?d0hkN0JwMjUwcU9wS1ZMaXk0eFpNWGJLK2lIMVh2WFdNbW1nNUVaYjFwOW1L?=
 =?utf-8?B?NVJWVjBjcXE1SzYwKzUrMjR1a2daVXBHemlBVlNocnNrNngrRXBEWlo1RjZ1?=
 =?utf-8?B?TDBSN1pCenZOdnFwYVUwZnl4M1R4NXRGYmdEM2VCL3dzT0x0bGQyYmUwWEp2?=
 =?utf-8?B?TGpRSzhyZXV4NEgzdFlNWmEyVFhZb2w1bVhZclJyL2NFM3owLzl1QkhzN1NH?=
 =?utf-8?B?Mjl0c1RNa29TaDdWYW9jUDkvTHMyQXA4VUVidFErRjdyMHk3WHVWWVZFUG11?=
 =?utf-8?B?VkYxNkUvSVJSbkFkNVJWZFZ1Q0NmOUFQTjN0ZXVjaU9pRExndjdhSWY4a0xp?=
 =?utf-8?B?dkNvUWlkM1hPNFQ0RFRLVGtIc1NaUXd5RVhhWDhEUFNTOEZ5aWl1L2w1VVFP?=
 =?utf-8?B?dlRCUWVuOXhHUkZZN09ZZ2t1WlowS3RSb0dDTUV5M2ZUSDdYZnlJcWc3Zm03?=
 =?utf-8?B?Q0RNZDZRaFhkZ0dDb0FZR21mYVVhTkZ3WUIvNVVCWmM5VXZnRzFPeDRxQ2VE?=
 =?utf-8?B?NlA3aytONW16bVMzbWNxTktnT3NGRWNycUsySHVNeDZDUk5zWm1INVV6MHo0?=
 =?utf-8?Q?YDXcl3SGWKpJc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1713838-9be3-41dc-fd0c-08d8b90b2ddc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:13.9993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3IZOnshgI8RMpQR7G+ea7MeKTM5mZuLCz61c0SCYYJhVzBaivqa+isR25AodCPPEAmDR0QjCt//JhLWdIbgxG3t9OwgLyx2tbIyq2LbG44Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=941 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Jan 2021 11:45:08 +0900, Shin'ichiro Kawasaki wrote:

> Commit a35129024e88 ("scsi: target: tcmu: Use priv pointer in se_cmd")
> modified tcmu_free_cmd() to set NULL to priv pointer in se_cmd. However,
> se_cmd can be already freed by work queue triggered in
> target_complete_cmd(). This caused BUG KASAN use-after-free [1].
> 
> To fix the bug, do not touch priv pointer in tcmu_free_cmd(). Instead,
> set NULL to priv pointer before target_complete_cmd() calls. Also, to
> avoid unnecessary priv pointer change in tcmu_queue_cmd(), modify priv
> pointer in the function only when tcmu_free_cmd() is not called.
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: target: tcmu: Fix use-after-free of se_cmd->priv
      https://git.kernel.org/mkp/scsi/c/780e1384687d

-- 
Martin K. Petersen	Oracle Linux Engineering
