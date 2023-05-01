Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1856DC77B61
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 15:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjEAPNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 11:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjEAPNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 11:13:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37231FCD
        for <linux-scsi@vger.kernel.org>; Mon,  1 May 2023 08:12:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EJjNN026748;
        Mon, 1 May 2023 15:11:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=d3cFidsTVgirr3w0SAI69AiKCXCle4iFwlH3mAWxSUI=;
 b=GtstOdeKGrXBnIcOG8MXKX47r220ng50wWY+MW0l/hTyp45RMt/chiA1HTEVts/9h1w5
 sMwngpc1aDzS5NoMLKgBlqXLR9kusqJb4wNfO8IxbBEUmSd1/Dtr3+bM62EBnWoUcLGl
 +sWE54kWUms9g4JsX5SwcDGEeM5zHFkNDwWIz0OltVnwqRJC9AgIHUNgOTs8hmbiWK/9
 R2h0Pog8vZerAaYlWUH/hg9bPWJFo6stdvMdb2HAg9kBR47Ny05Wl3UjW+97yHOAUmze
 gyFsyeaTTDk3VEkohRjOUuUVBgSaRFdcklelxejF9ZBxDJ6tH1ZlqPT679CgT6I0jFFd tA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8usuthca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:11:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341E0OKb002437;
        Mon, 1 May 2023 15:11:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spatcym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:11:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKtchg4Ba4ypKLHdvH0eRZEPZnchMKMjZTLOoQ0/QHStVvROoc+OGyxK72q3CEo/e8btUROQq5qDBVMcXrP1JrbMXrM/tW14xpe3vCM6W3F+1htsyw89K3jFLpsfsJqN55crK2LS7h6ExgsHPI3/7tZYDExLYrDbZtK2+/+66Efj7oD5KqXTzzRKHT6IZRD/+JjPJmoqstIHxnERTYB657AFy3CWg7CrlzkfiHaca7cqzWDrCW34iWl5jNrftZ2De0c507N1wUVJXFmID8WCeS0bnS7QpJrc3rWLmrx+OQIAGwIR04cAF/JFU3a3J9YLRYMWw6KjnESP3l2lQO8nmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3cFidsTVgirr3w0SAI69AiKCXCle4iFwlH3mAWxSUI=;
 b=fsddJApnbEfhaATmHkzxcqE0YuKUIZnt3Qmiyi1IRZ4XRq4fY54N7vTh3NdoG/ntSy9kw69cGpEY945+zWVCJpBg+RiIg4mvz03SrnXl609BixwnWbwI3WMSzrqy/lva5+w9U5kBgHci+CtFYspP6mprLLVVJh+P2ZN7EbNwI08vyC46BTX+DnBFvfZKnn0/z+oGXURrt8TeobvCUfzUvp03r3KZiZxaJ6TRe2g8Ig2VTUi1sIPihIAm5bbDzMQQCLn3ANN/Qn+JCCXitczu67as6WY7SlI4O9ZL3aF9moFjccX4r/485CqzJgLgA+CBhmejhts4Z10vqQhiXw2bhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3cFidsTVgirr3w0SAI69AiKCXCle4iFwlH3mAWxSUI=;
 b=sjnQmBqDDt+JDt4un6GmreEUsCOT7qMyOT1ch5KT+eFUnffL8YkZpTON2ImLEkfvXZ1jpmqM0Q+7V04WmZO7ZdfMqjhgutoqkFczdCHi/hxnMjpg/f+ZI+K89Q8b6UdGi49wusCIdgfwpR/94YezQBVrCT5CimmvieyDdt8rHFg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO6PR10MB5633.namprd10.prod.outlook.com (2603:10b6:303:148::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.29; Mon, 1 May
 2023 15:11:33 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:11:33 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 7/7] qla2xxx: Update version to 10.02.08.300-k
Thread-Topic: [PATCH v2 7/7] qla2xxx: Update version to 10.02.08.300-k
Thread-Index: AQHZeaavQ3UkJq+k/UuFYncM8nto/K9FixMA
Date:   Mon, 1 May 2023 15:11:32 +0000
Message-ID: <623D2749-5B0F-4CCA-8807-08C8CECDF7A9@oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
 <20230428075339.32551-8-njavali@marvell.com>
In-Reply-To: <20230428075339.32551-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CO6PR10MB5633:EE_
x-ms-office365-filtering-correlation-id: 3707911a-f713-49f2-a3b4-08db4a565959
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oCghESiJ/BetA1upMXsGpnbYwBj6G/xXp8U2XcTWKw0Ki712oFFY6vrmuEfcr2IccHqvqVpJAmSomVo9uYUFM+aR/CoIZ7WHwI0PEtaKrupFi0TQS76H0VStSQ4fPe3WmO3bJq31i/JsiyDbqf3qYTPReVC+guMzwI/6tIvEzDvEiIZuS+z573wQN/52SOAbjj7PQdHk5a+AwrbqiN1qU47IoFO5XOPwqjnpjexFliCCEndCI8zyKvgFFRwbppRzJdANJ6ZNPzXP9kQGeZFkUKFjv5sc4+G14jEfl4Hc9UJO9b6Z6dr3EMctgk54o1fpewci2ychx2db2GBcSWhbDRFbf+UwVYhqgqs/2H7k8JN/4f+rsbxB6er3cIQxXn+nJAsdODeQiJsVeQTR8RBQsqhSDuWEA4z5XCuiTYPyD+v5hgMBZ98LJB3hVpI1RHQITer7NSlI594kxo9oUPf86MVzt1p/1tdpHNik0Rtx83qrwwjrFG+C84XBnBQTp7uc3qhSg2yJKYBFzYd3fT7NmYW0+QpWSR0YkPSCPbZxDWXbHzG/Gh/mirTay80ebzeCaldSsxTpY7iwAVvUTJeD9BxKhLFNfZErQamKo+/LPQCzASlsAWeJ3pIi+5m83LO3cIr0JSU6aQkZyYollX8tAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199021)(38070700005)(8936002)(8676002)(26005)(53546011)(2616005)(38100700002)(6506007)(6512007)(33656002)(44832011)(478600001)(186003)(5660300002)(36756003)(4744005)(316002)(2906002)(71200400001)(54906003)(6486002)(86362001)(83380400001)(66476007)(66556008)(64756008)(66446008)(76116006)(6916009)(4326008)(66946007)(41300700001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CEIjVMvZgrXMDpOt/PRYo4X+aTgKkA0QyCnef5538+1+EpqL2JQOYxwpE8+S?=
 =?us-ascii?Q?Sh1Zvfp+VVZhFAJJjEIEEeslN1NjQiBy3o2TKDfH/clGaKD6SWjrbRy20//t?=
 =?us-ascii?Q?I2iMXIurAXy89UFOzs9aqxZWCyaZ8SBv5seD5eIB06NWMoEeuaPs9Lwnak4w?=
 =?us-ascii?Q?C0ALsWIvqLXgFRQmE0EC4y9ONvehqqZOzTe3I9wbjkzdyPLwbRGjDyrLlBZ0?=
 =?us-ascii?Q?DgnlZYtr+9kiIXID9/nNq1/+Jesy2MV7wNmWgce4S4QQbTPqnOopKNY1Vokz?=
 =?us-ascii?Q?v3DpMzKZr97K6/zcHXGNN0CEkjw2jZJMC76uwbzR7/llEHBjveDappoPxU2/?=
 =?us-ascii?Q?vcqoIXn4ENuHuXh0v85BVNTagHOTqyGLokzvGUE2ojGHHLBQeyMvl0ObyAke?=
 =?us-ascii?Q?1/oJsgA2IBeTozQrzDnLvJ2xWCnXjUZ8zNm3QbB9IkwlQ0y0kY5uSRyzEZlI?=
 =?us-ascii?Q?a+9p1AETtiYbyYsbCdyNr1zmDNSbMZyiaS08+kHJfYFMdVLJxYtD1OjdH1H1?=
 =?us-ascii?Q?RZMA21bTBo1xSJuk9W00JWDObcFUhg6wLn8IC4xC+hjwExDufIYYlSVoIOsD?=
 =?us-ascii?Q?1Xr0w6/cD1ScHICznOWZztc+1C6zBtSNw/MMjAiY9t4Dc4wc5kApst1GoSCH?=
 =?us-ascii?Q?qh+jvc3i6H5HlwdPItRg0F1SFjazUbqEQlzjtMp8uByzDMYAKJ0UwkTIBbND?=
 =?us-ascii?Q?WOewvFrciH5stPAgrwrgalAAlQc10matH0AT7vRBvPzlpPSJoqaa1bO86TNZ?=
 =?us-ascii?Q?O+1A7zf057s4P7G53BdsSzy1NMqD0PK997OkpzNnSLNk8LdsMWVtOpA0oL4B?=
 =?us-ascii?Q?99ERV9i8AkZK7mv0GTCFtzyzHtXVqWCpAgKQtWetZsD9KU1n7QHesF9D9KLh?=
 =?us-ascii?Q?Vqvq6r2h9bMLzBpnw25BasBjYXLO7quP9x90IWKC7DEgt7xyr1+puck42ZU4?=
 =?us-ascii?Q?62roBJSRq5ogo44KoiSqM1PG7rTxupD9zqh1uRrdZqI+KEGHJI/t56kIzMxd?=
 =?us-ascii?Q?DrSwLv6Dr2GKBgS/Ct5BxHppdNN9rZwZxmRDl6cFfsD8aYtgZH5f0IWIh0WB?=
 =?us-ascii?Q?OGviKpWlUM7GN7TRsR8upLgqmxXXUApHnEsu91xxweD/VncDSCLFjKBtJd9g?=
 =?us-ascii?Q?EBURgtaGepHrm9OQPgnaG+7vfILDriIu41z0dlfarkygm+b7rqTZc/2cct7c?=
 =?us-ascii?Q?SBrtfzHviFJ5KPi2xPcQdW+utvQ9YxzYqHjF/+zdx48qArdtbENfof/yF1d+?=
 =?us-ascii?Q?TIWmpdb2NUgyV00Z1GkZtwlVBOYwYk6mk71TYXxsyUQHlLerQJCdo58i+AH2?=
 =?us-ascii?Q?OlC3Xqg/LEgv2M6KFRTMEHUVV+cQpRpjg/GK/BCgENxd1uWCc+e+njQiNlci?=
 =?us-ascii?Q?NoTlBW+gv+auBGmRE+usWdClAnZJeo1tEtn4qMvOfJUCTd9UfHzGr22h1A8T?=
 =?us-ascii?Q?7nzHWbMQXqOwp/fgn9dE+MZo9uQcJ/yE2UfKHySvHrsmMm2We/lDay3Y47CC?=
 =?us-ascii?Q?c0IrDrZevq4Q7R6HYbG7mGCYN13OTFmCeJOOqjxgjSxIcHE7b3okYdNkBWB1?=
 =?us-ascii?Q?z19+xS8IXykjrLbQnqBmmJyWE+FzETbax9xjuDjvx4Hb6LVLnuGPMqa5CbLR?=
 =?us-ascii?Q?nA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F0B9ACD5442C3840A40151F730CA19F1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HEOA1EX4Cvj7FrgcGoC4SmKBTGilH7rwlBWrkiMCuD5gOH90JZRym1PzRkNgv4AGKVHW2MyNlX7SV7E/UOy9uJyTxbGszM1Nbw0DcwUOVulo0WTXOX/g0MFPAw+3GKoJ8PTJF+dXW9gJseZF6s466E5UVB6ko3hJ8HX9/5RwlqmtOW6fU8fxPHrdiINlmtlAJu2/azZZMEI/fB6PMxWPOUN4yuxF+57ixtB9chRU5OGw+W09Q7ypD/7J4EvBpGqZizOCwWFRqBYr4hg/7YET7IUpI/pzpzSiUiZRROWVzENoMB5t3F2DzRQeOII7xEINIySccRO43i8aJm8a6/+yPsqo8OoI72IK2pgt69S+I6m1MPK7SCD041osAsNMwQkeTBV/Le7wCenujcn/2ceFpYlAI9h9jqpbBQM60/UPjvOiA8wGYi3M/lFR9Y3qXeqbNPmoU5vRIfRb2DbvBIG8ftgEjjM1lfYWAiqalcq+4PYypPtHaUxoMXrI78z1DAZ5ct/LwxQJy1i4Wii9U4sCEqq9lovEoxuRUHpnCw0FU4GdEZ3GocDQCzyfozwl5yIzsB2+t/SC03ntL8exNJNdaU0ZqA0YeY5QGybbPEqoSoAtavv17t1CwhqejYdpjCGb/G925SaHehqbOc3peVWoKM6qflcHdJRFCK9sZaQj68COBYno5/g41RL7zhpqcHWFyF3LvhI6NjGSbXG2rS5Q316hPX0a0wsM9bTRF8LTcFl7N62E95KRg67PtqmuhZEiMmbX713Y8cMlwRmpRQdsaWzVqUBgyFvhwDhcoLn72hM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3707911a-f713-49f2-a3b4-08db4a565959
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 15:11:32.9723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GJzEeZHLhVKQjHw3KogABw+o0cdj0mgFAjAbuRixTabIiYZwSR0+qa3AXQ10E7BhOwa+MngCW5ufL9rIHAZfSs/U3Ikw4pVKpeQxOeFGj1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305010122
X-Proofpoint-ORIG-GUID: Jt6VVCNtFleKS1Ul7lH7d65peep2sDTw
X-Proofpoint-GUID: Jt6VVCNtFleKS1Ul7lH7d65peep2sDTw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 28, 2023, at 12:53 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 42d69d89834f..4d6f06fb156b 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.08.200-k"
> +#define QLA2XXX_VERSION      "10.02.08.300-k"
>=20
> #define QLA_DRIVER_MAJOR_VER 10
> #define QLA_DRIVER_MINOR_VER 2
> #define QLA_DRIVER_PATCH_VER 8
> -#define QLA_DRIVER_BETA_VER 200
> +#define QLA_DRIVER_BETA_VER 300
> --=20
> 2.23.1
>=20
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

