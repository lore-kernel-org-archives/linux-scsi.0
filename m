Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A98C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 03:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiKHDix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 22:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiKHDiw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 22:38:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED265615F
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 19:38:51 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80NwAe023024;
        Tue, 8 Nov 2022 03:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9ZxhIRolLRjv2f1kKvqFsTSlsQP9OczfLqSaw8KH4FU=;
 b=tXspOe/PLq6aM0xOp7Py3rPULPesXGnQR0NHOXZkzhYn0a8CScNS8TqonahKEivxYh04
 T0GwWWSstHu5moMDCj6j7pypP1iG6GRbGPXRqbvDvTXY2LBNDr19tgPHOAyIj4l5tAQ7
 baxS+BoMa6QXdT/MQpgKiQhivWd7gxS8zRgNmdc1e6ogVRaNLTRKvGW1z5wLod7TscLH
 BnvXDlcRkOr8ApLbTgDxkzGzJsLTr7hh35LrbyPGyoo/ZyarXfUA+GBfmeWJxGwYPFH1
 BIOxvY1iQLHVY3r3OpTeWAXLUSYviwRuXXg3bEbeS04bMdJGxoFOgUIvVyj7Ksloce0p oA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw6006-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 03:38:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A81U909010731;
        Tue, 8 Nov 2022 03:38:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcyn9bbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 03:38:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7u7q68D0qga5uOEimadWjT3md70cPWEXLkMpCLeO+BRdSleCa0It9m1Es81Ag3Bebxpe64nqk2d9FTPy2Lkmt50JY2U3b31RuZfCnw8mXT2pdhpDu2kctwkDIC1xPqUd1boifXjLltn+0Z8KWOBS5nub8IWonuNQ2Bh7Tt1fYUvDCcPmN0IcneA4D6NEEIW032y4trGAAeixiPaCZd+oKQfZdC51fTQlGzrPg3SARtYbmW3eqt2VwUNHYBRRokGPQoErg+9WnvRyl2WXJ+7O6V9cQNpoIovzUpZu17PsDTNCB6gJ3HdhhyutKMtEfKDbpTVs0K4WMysn5A7zGuNkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZxhIRolLRjv2f1kKvqFsTSlsQP9OczfLqSaw8KH4FU=;
 b=knQ1ckXF1Eg7zh3BgMoGiil4cXO0D34nTqIF6Nnh7D1rI35rVtOD2K5q91F1znUQZlaftRNoBCbFont5ou5LGfvCQeTK6A3kqKV2YF4dVW+3ArRS/kOlNk9IeN/O2qaPMll7YLhmfLJ2hOpqEQCUY3al3FYxFn6I64hgBo+s2FPaToZ77uamZGpC9/Py8JchpkSrlV3PH6PwmftHfyv8orpzS3ucfhGfJgwb6iGfcrTUC/uXJuLKsAz6vRBDXu2RMeJylFKFdfnDs/bXntZuUfmn4R4+nOnGJHIuPPLmkx22DZecJG58aCV+ui5Op5wSUqqxAjdrniyMvP+JWmnzfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZxhIRolLRjv2f1kKvqFsTSlsQP9OczfLqSaw8KH4FU=;
 b=bjNUY5EcRlZurslXDSQoMNgiIwmr/PAFUmFT8PdO4HWdvO3B6DcQ7ZQSWc8lLJ7PZaHx7bCv6GXM5Xux0l26c1gyuOhh0uVDNa+t1EcOgbISLz0CnEr7R6IBzNUvq4FmjjradS3xKCupap6MfbWztQRYVJkkokmkOkrLDGDBdw4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6139.namprd10.prod.outlook.com (2603:10b6:208:3ba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 8 Nov
 2022 03:38:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f77e:1a1a:38b3:8ff1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f77e:1a1a:38b3:8ff1%9]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 03:38:46 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix set-but-not-used variable warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a652jeth.fsf@ca-mkp.ca.oracle.com>
References: <20221031224818.2607882-1-bvanassche@acm.org>
Date:   Mon, 07 Nov 2022 22:38:44 -0500
In-Reply-To: <20221031224818.2607882-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 31 Oct 2022 15:48:18 -0700")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DS7PR03CA0323.namprd03.prod.outlook.com
 (2603:10b6:8:2b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 499a7859-aea5-4612-f46e-08dac13abdba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MxMOnMM1h1F3Iw0kMZFeWR3z8OUAt7Gj+oVrKs5tG8VvN7zajA23BsKfIqfx9UNLlaXwvF4gxyy7K1K55LSB++X48fncsG8pii8Sq3lzq1meJg5klIfOGPaR/WKEJpkY7dExpvfJv0iflGAqd8b6BI+y4RLJL67kw3QYccqWlkTCA9ZEygViuYPHODGLos5NRp9KJEhWLWas0weQBlBgDoQhxhj895vTnnexqIcov5AU8zwzwn0DVJYKrJ4MTOXG2EBNlofs56w/wC4UXlnSdqBwEI3FDPqgmt13W69DvvlwFGDJYpjsmTTP+dWCZHyugUaJoIbrVrR4DtZvAJdqOiKGZLoPcJ5eNpmLeRlFNaLFgd5gLPKqzQbXgAkvKgwv1IFmDMuSM+hbHFV2Akt7ZmstmDSDUFPKkgoEYm9bB3F93eeT73vlcH8F34RxZ9U6VbTxBnP9nQy98cawaiwJHOOYx3BG8SqZeUvCtwMhZkwydyBQ4KRDrJxpyS5BYqFJzRdELAobRafteCXcv3KbQluKfO2S7DpaxHtjsx72ItL4KaC+9+0hFmHvHgEFnr9a0Hz/s+h+rt3pj9MCG66kgAQfs6XOKNwoqFPhb+5PMr7scGGqyEoo58NZyFPoAZoKVwoaIzOHBrm2LFXh+zKL34dpMXD9TVwP+gEZDvDcWvHfpQsUBjGtM693jMURzn634XT0p/jwXTqyZvwE6iWeJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199015)(54906003)(66946007)(66476007)(4326008)(8676002)(66556008)(8936002)(41300700001)(38100700002)(6916009)(316002)(4744005)(36916002)(6506007)(26005)(478600001)(83380400001)(6512007)(6486002)(2906002)(186003)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUhhUndGUGhLSWlJRDY0SVJHcjdIV3FqTkFSaE9uM05Jd29kYVhzVmtZTXA3?=
 =?utf-8?B?MU5wZisxdkRjMGRTeUxnODRoWldOL1cvOEdrUkZIbVp0V2NOWHhYZTBkc0Yv?=
 =?utf-8?B?VWxRcFFwbkEwVXpmLzhFbnV4Rnk2NTU1bkI4MENZRHJYa1YyeHRwTHlqeFZa?=
 =?utf-8?B?QnMyQktOZGVwWkJMRVlSSW4rTXFKYnZxNFpMMG04K2lFYWtmU1h5WjhkaHc0?=
 =?utf-8?B?S0JHNFU2N01vd0NiaTRpYisrTEIvTHU3ZVo4ZTVVNGtwUFNaYjhUKy9XRG1I?=
 =?utf-8?B?NmFxaVhUek5LUDdZSEJaa0ZSN0hkU0JkTEoxOGpXUmJQaHNWSUxML1VFY3dG?=
 =?utf-8?B?RTJ6Z1Z2cEdGYTFQOHhMTHRGNHZXdEZYV0NSSVJqUll0Vy9tbk8waFlIZFo5?=
 =?utf-8?B?Yk9vSjVDaC92dVRWd2d4RWQwWUVhRkRwQ0EyNTg4ZVl5RUM3TzFwVDdsdE9n?=
 =?utf-8?B?dTFQMzh6UjE0eUdTWWZucG56alV3RVpBTERLblRCU2x1dG1MUG42VnZaRHJO?=
 =?utf-8?B?VDc0YzRjbDFkRDVnWGVUbEVsZFpzRk9QYkRTYXdHdGRwcmx3NVFnclF5SzRx?=
 =?utf-8?B?cXdGM2JJZDNwby9hTFp3bk9BRWZycitjUzkySzhISTBHVTU4VFVCUGtvYW45?=
 =?utf-8?B?TDZTRTB1anYzMFEwdmNaTStIZGxHUVBWRThEbmIyaFNCN3l5eWtsZzhMZWFa?=
 =?utf-8?B?d3JteSs5ZENyMFI5bTUzQ2hXb1pQVWhOekdCdTFRRjJ6eVkzd20zNlJBb1cx?=
 =?utf-8?B?dm54UWhYMkJrL3lSRE9QbUdYZEhCdTgzWDdZdVdNSk15bFUvanNDSmphY1I5?=
 =?utf-8?B?Q3NoYWtPTS92TDE1R3BONVh0OE4rZnZsR2hsWDZxS1psZSs1NlIxWVZqWEEx?=
 =?utf-8?B?bmFXc3Q3ZjgzOFY1MzEyWkgrM0lwNGdJQ2RvdVRpQ2g5b0c0SmxMVlVTaGg3?=
 =?utf-8?B?b1lZaXpSNFFPNmdmQkoxZkhwMXdvUUhIYlRrc01CNzNOUjdTa3pvMlhrUnRK?=
 =?utf-8?B?K1doSmVMWGNjVUJyU0QxdHpUZzAycEFObDhpTFhrbGh1RHBYMWx0ZC9lR3FR?=
 =?utf-8?B?ZHdkR1VoelZBWnVhdWwvS0s4ODdGcmNqamFkK09kSnErOGdxdDlEK2d0ZkJ0?=
 =?utf-8?B?R2Ruc2MzS2RnVlJ5c1k3SkpCcUF2WkN2SCt5b3c2SW03T1paekcydG9sM1ZZ?=
 =?utf-8?B?eUEzeHFZWEMvRHZzbTFTVVZPT05qeHR1azRaYkNiK2JJeThGNjVlWDh6cXJy?=
 =?utf-8?B?UEkrQjN5aStRUUROYTRuSjZxYzMzUEdzeWNlck1HVUdnSTRHUFlWc1dabWhL?=
 =?utf-8?B?b3kxbFUrbU1KSDRmeHpaTmhtYWZxdTM3NGJPYjQxcm51Z0EyN0hHWnJ0NTNS?=
 =?utf-8?B?dXRtUitoWmZGRGRocTB0UGZiRHZVMXNGTTQxbW9yNDJRTnFJajBEcTVTNEVV?=
 =?utf-8?B?czN2YTlYK1Jja3gyL3d2OTRYdVJBTG5WTmVvK1lrdy9NMzFXZVZ0Z2g1Y210?=
 =?utf-8?B?em5PMFJIVGZVNjZZZzhxbUkvNWxFZGJuRzRkd0ZtYVpBNm1wN2Q1RFFremZX?=
 =?utf-8?B?REpIMTlCWEt2NkxUSk0yK25jenFvY3FqQmN1alV6dHdES0VOa2hyY3YzSnEw?=
 =?utf-8?B?WXE3a2RiRnJtbEtxTGlqeGIvY1plUU1FbmxYdXlHaW5OZ0ZtVXdPU2RNOHNW?=
 =?utf-8?B?cGw3TGhRaFRhaHlSeEVTZ08wR0IwcTZsa3E5WStmY1FQa00vUE9WQ0QxakVD?=
 =?utf-8?B?Z0lUWmhpcTAvYVFzSUgxRWZJdGZKSnIvM3VBclNGZjJyMFc5S2x4UEdmVzh3?=
 =?utf-8?B?UHNkSHZZczlUem1FTjJCSUxKVUg1ZGZJbCtDYTBUUmpDWWJoV3J1NllkQy9S?=
 =?utf-8?B?VkVPWlkycmRSMkZ1dzJROWc4dG9RdEpTWXBta0xsdlRINGhrUEM1aUhqUExH?=
 =?utf-8?B?cnpvTkV5b05tdGpvTnp6RURySmJQdllaM2xrenlaMm0xcUhsQ0lERDh1SVFR?=
 =?utf-8?B?YTNibDlKU0lQMDFHdldCTXRlS2dLdEY2V1hkZi9aT1BBbHpSM1VZZW9rRHBR?=
 =?utf-8?B?NVBPelhMZ2FXcHZYWGhzTzN0UjdoR3ZNb25uMEtFbklzMDk0QTF5U29HUlFi?=
 =?utf-8?B?T0ZsVXl1TVlCRFJIM2NiSmVoN0lLbEF0bVhGNXI0dDVMVVJkMGpKeDMzMm5C?=
 =?utf-8?B?Nmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499a7859-aea5-4612-f46e-08dac13abdba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 03:38:46.3006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Acn1dNrUkmQJFuDnSGuqX4vkKuUpHEls6hScAuor5kCCE+OpHL2oruUqPtpkQoWOUluHBMIvhs+BIV6PgjboEoSbZAcuH4WGqVaA4W1qz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=988 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080018
X-Proofpoint-GUID: _18q6mh9ZJ79ddywY7QhH5s5ohVM1ZGw
X-Proofpoint-ORIG-GUID: _18q6mh9ZJ79ddywY7QhH5s5ohVM1ZGw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Fix the following two compiler warnings:
>
> drivers/scsi/qla2xxx/qla_init.c: In function =E2=80=98qla24xx_async_abort=
_cmd=E2=80=99:
> drivers/scsi/qla2xxx/qla_init.c:171:17: warning: variable =E2=80=98bail=
=E2=80=99 set but not used [-Wunused-but-set-variable]
>   171 |         uint8_t bail;
>       |                 ^~~~
> drivers/scsi/qla2xxx/qla_init.c: In function =E2=80=98qla2x00_async_tm_cm=
d=E2=80=99:
> drivers/scsi/qla2xxx/qla_init.c:2023:17: warning: variable =E2=80=98bail=
=E2=80=99 set but not used [-Wunused-but-set-variable]
>  2023 |         uint8_t bail;
>       |                 ^~~~

Applied to 6.2/scsi-staging, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
