Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC1DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiBISdQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiBISdN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:33:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBCAC0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:33:16 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219H9p9s008865;
        Wed, 9 Feb 2022 18:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vW+r2CtxEIpnWBdiMwfema5AVqGRyfXYZyAzmzXnHc0=;
 b=aw092vHsjJzKs7QAElpb3Wi8JK6wtb7hJ7qQrNb2LmyyOjHH7eAjbPXXWXFJhVw4ezhI
 1PU0YYCCKaV2oQLNaHf6AgTG6LRifq19mkS2Uu6krjHDSv/9Rv0sTzylYVB/XAwFrxgl
 gx6D2VPIBOxgnHvMD6ZLM/8PNZ8ToMj/iRehqN5r4xVAQotD33hslPFuM0eauX7xxV3J
 UacXysCn8FCVI/0Aigjuzl0YtF7Hh4ISSY9t+x0ivT5rzKkcJJnfenAg63nDg91HWtm7
 8QvZkHBMtBhoTfn8H4EjoMRt7uXA7iCJEGoulyIgosjgxdhZlRy1sCnc8yTuxvRQFAji bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgnm1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:33:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IPcno008470;
        Wed, 9 Feb 2022 18:33:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 3e1h28s52x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:33:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8pWmPPvKEieUjV4itYBZAn2UawVtK3A5vT/n3ZA67iVTFD9f5WuPt5BkFYVcBgYyOsU9f3ACVJObk/C8ujrYwHw2eeOBniha6b0cvNhw5Sap6HMsbi9j+3RDJ6pm+1OSZ8Ie8xUoNtwPppD4UloTAbMJwgoFzoPj6cwEmz7fbrP8JRjqFu8k5BQhwYRKVpTnO1NohslnMTY5Kyjd2k+gD3IxNqhqd84rxUdDtwBsClvsQRdX7ijMECdVCdps6214iivDWes/gw4Xv7Ciddxb5Jut5pRqokY76xpAOmHO8RUMj2o7LvZvW3M/JRK6iROqZBjCoJ2RIZz59nCkMN+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vW+r2CtxEIpnWBdiMwfema5AVqGRyfXYZyAzmzXnHc0=;
 b=ldTIinHwLmSgmShCnszMM3Of4zvIqrYnWP0C7/WVLoQwdJKv1QKKbpXioFDzMS3Ezj/vF2cSUmCAVAhb6iVaMmquRL2oMKhUOKRMsoC+eWyiQ+FrwJc0ifqCthROCBriToG61SRcm7VPy5CVnZ/lF9cFQTbUXZkIOnMsSHoe9VhGxyVT52sWAR6+uwJhcoXFrnlHpHsXpDhjYOFncNR+PYehMbdlwiGKptmzhemMYl6H2wbdI798aUDbaQbfJ5BggVFB/wTuVG13eaBr1MZpc7jsIS7Xp89cHZNz6o2jp1FNhHzAY6l4HnI7M20+EArRSxPCo8xPu+j1lizbQ0XSfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vW+r2CtxEIpnWBdiMwfema5AVqGRyfXYZyAzmzXnHc0=;
 b=GLknRR/h/Kku5bNgImwL3ZNN30BpjfGioMvitAp3XBzS4FsY8m7CsiUXv8YcZeJEqIuQSQMtDAzRpgPSWYhcYPuLinfCfW/Npx7ONtiIdGq1hH3kcSw7FpxuBcHN/Bzim/6jcBfJfysJHIIg/WHAizwjb/aWpq3X3rYfZWNXdCY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY4PR1001MB2136.namprd10.prod.outlook.com (2603:10b6:910:44::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 9 Feb
 2022 18:33:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:33:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 25/44] mac53c94: Fix a set-but-not-used compiler
 warning
Thread-Topic: [PATCH v2 25/44] mac53c94: Fix a set-but-not-used compiler
 warning
Thread-Index: AQHYHREoVd7afapsgUe6nLQ4OrAzp6yLjNSA
Date:   Wed, 9 Feb 2022 18:33:08 +0000
Message-ID: <C78DAB29-C6C2-4545-899C-3530B1D30537@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-26-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-26-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7758da1d-4cc3-43ef-a35a-08d9ebfa9e88
x-ms-traffictypediagnostic: CY4PR1001MB2136:EE_
x-microsoft-antispam-prvs: <CY4PR1001MB2136B03593EEA3F0AC94C3F8E62E9@CY4PR1001MB2136.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ASH65qSLOwD4R16sH/vpJyJi+pF4HeYsjUUdv8mncROc7oSrNwraG7O6O5Y5kCyTe8T+wOOO69zEBynfpbWJSdc34VMNjkkrn0f15O2i6HapmB16bykau24vRPrVwJLFhdSgNX4kJF97qikBuZYw5S/voduIsKbCcBLMGepIACOHcwVlyXdI8hZGYJNUnDZaXt/OVr+DQpZqJBpcRCsSuihGHr550j0LrohoQcTHHYuLnniNncJQqqd47z4byj/BFW9Lrj6dPJuCDf921++DUIah0CbjrnjYMHH9LoA8LA8yydNkIZkjoDwnPQfDhP3LCG3QfU+/9GskQxhm21158KN/Feb7GsrBp3gHanUdedfxQjsKmWL+/RGhX9s5cossyztfOdM4dBwwVQY9le17g7LyCWO5Bj0jEDeO7/IF3gcde939qhqPLUH4bPblEZ9vKjzqPF64UmWYwmNVSf38id48Q276gOGmumRZDVYy/Re0rM3oLzI1mAmaR6FiW9Ld2OGcFjfn9v1T0piInx719IhuNp8iymth+MsO7dANaqX6S033sW4HBDiB1Qk3/cv+hDS8mK/qEYTrJfl9Ijq+v5TLx2F7/xqaMAyNoH+qHCjjFmKQcrW7UHgDGSVT8MyNqeW/YqyY/tbHk+JbuPEu/y8M3l6Q0kBzp6H4qFA0S6tXZTV7teB4sLoxnA0RB5SMF4DWb9qMao2H5L4eiaWHnmkHmrjKPLCTLduKgGkv6F1sZqhYlEGg3Ek8KxP8r8qt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(6916009)(76116006)(8676002)(186003)(4326008)(71200400001)(83380400001)(122000001)(8936002)(2616005)(2906002)(6486002)(316002)(36756003)(6512007)(6506007)(53546011)(5660300002)(38100700002)(508600001)(86362001)(44832011)(66476007)(54906003)(66556008)(66446008)(38070700005)(64756008)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HeAfDJyfcGzF4YiWhjsAg/k+u7S9F1mxTk/bFsP4nfg0r9wpnD38d66hnrhj?=
 =?us-ascii?Q?5BCDfLfuGNkhaukLjLm8aHT4U4VRFaPgp3z3oekm0q6BTQUG55JpZVamqF8t?=
 =?us-ascii?Q?tRN5KXbXi9SwuXqn7tlen90Ub2ayAndGO1F1lswWoOmJRx/LUUMYggNSSHzs?=
 =?us-ascii?Q?pM4EVJgyqd4mCUegUdLKKp+pll4A8LsT3/iaxeJtRJL7IHcGhKOY/qTmJapX?=
 =?us-ascii?Q?mYVYNZLgrfbpIs0MiEg13XUoTqsPneddq9tcOSn0GBPkaI9XrYJnFQ5qGWWI?=
 =?us-ascii?Q?dji+b8MadGUi8t/uWGqoHZoLyTFfqwxGC08IN4DudiCP0/CeC+wcREE6HQk/?=
 =?us-ascii?Q?T+Wod7vMlCQ0UQlFzRsum/I9iOb6PxvCWERPyGXtRa8jAusz2ZxOKy1XoK8z?=
 =?us-ascii?Q?6x11kwxyE8u90j2EBkLuRRfLOTInSxN9i8eyKrIEq8m3koUtGlFCFPAk6QU6?=
 =?us-ascii?Q?PYgQEZBh7S4wdRXIuownt8pVjxwFNH+zrJdL804BeNxA6I7BjeXWwUlqzk5/?=
 =?us-ascii?Q?c2aVFpDZ31eYddIG2Q3bVO9nXtYD9WdoK7HQgmwum8c71dUPLY1+8cfFm+J8?=
 =?us-ascii?Q?VxOO42EMX9WLyQk2JWkITQqEAiZCB35aZNHGQYiYNRKLYoylstG8PGWtRtiI?=
 =?us-ascii?Q?UPefCxvHdU8KoFGvuD/wBVxsw03+isUpQeYhyZCJfJxbgomRtPC7Ec8XlUk9?=
 =?us-ascii?Q?zbRtxSwkd4Ue4BEp4qvuOBPUTIbcE8N7bkNJ5MMLbEVjq2+zOoM55QTYeL6p?=
 =?us-ascii?Q?JAms+SSm8T1k2HpsBNgKwtUSgbEmkR3WbCIAjDMWQA4UkqT4NterIFbjVCq8?=
 =?us-ascii?Q?VM8+ILFfydSdJZxgAPKdaZd2USpeXDAdmYEq7tN9mNXua6UZwd37cLLmK04X?=
 =?us-ascii?Q?A7rl1GxWgxFrNGAd1rH47AUrkX+UOOu3225FBHYPQ3hdEbwW8FU04NEgyDnv?=
 =?us-ascii?Q?KojGLF3Kqp2KH2rGapQeQhKJhBee0nah0uEeFSQbTUKsqKyCLbyNF0qR6E3E?=
 =?us-ascii?Q?1t8yX+ejuftBktdPSSZpu3hIqbhAqHOZ+F6nc/38p/fUoUJiz3Y0X1j9bMHY?=
 =?us-ascii?Q?y9vUFU9agFMMCSMYdSijTFucT1j+eFJFDiYG9arspWQl7265icNnUutgm8MC?=
 =?us-ascii?Q?eTbG6Zl3fh6/lywfEc5+I3LSlmu5/ox/nw70B3yququ/nygTUKkOyS/NE1Rp?=
 =?us-ascii?Q?UCP7JhP94IDmlx7pnuuvpuDiroMVQUFZLhupiBAroHjxXxrwJtA/IGdzUKxK?=
 =?us-ascii?Q?hB3nFVDH459g1ylygElJsRjc7Ao+7IrvctoMepSiE/eSGAwaVphjoI8yJAsm?=
 =?us-ascii?Q?dQoFFiXb9lL0X/q+f5ul3/GQkwz93Pb46a21D2NZ1pKjVti0xJSSrzvhCwEI?=
 =?us-ascii?Q?7yQj0ZeN5YOTbnrWyOXtBlNISjengxBFcHiZCW0SpYz6DdqCqHGakEeNT2bM?=
 =?us-ascii?Q?1OFAhwQiaD+PtJ582bd/3wh34V+or5CYtowDnm4cUS8Pns9pqvPHftWx0LBf?=
 =?us-ascii?Q?wZvCDEXDP18c6zC5b50Ah2TKelIhvd1crdWVhASu9UTzWyJDUAUALOiMm9h5?=
 =?us-ascii?Q?GH+qz4gdMSqiMT/YL4v9iGxgKdEoWXpMVrioHI+NrkDsyYa6uQLqzSxNxv9r?=
 =?us-ascii?Q?Vcm0ueXlqP5liknSHFvXGQ6TYgT7N13zFQICT/0fIVzteZXAsNz1T7LJI3ol?=
 =?us-ascii?Q?JGLS7ifB+Uggzfp67tpz7Zo6FTlEOsnN64SsWhmf/1YxPv+Z?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FF021A8944E6944A2B633600964C088@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7758da1d-4cc3-43ef-a35a-08d9ebfa9e88
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:33:08.3117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+Cb5oERXek4jYaOjPswu5g3va7i8nfHqhUjKAgWMeTQmqumtKf+Qf4EFUKpKdWntFW8kcumKcowMKwQDIb+TD+dRGLn4xN5HSEXysypUlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2136
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-GUID: IyQ0iHSXJ-r2FFK3PwQQC54syqYfCtqE
X-Proofpoint-ORIG-GUID: IyQ0iHSXJ-r2FFK3PwQQC54syqYfCtqE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Fix the following compiler warning:
>=20
>   drivers/scsi/mac53c94.c: In function 'mac53c94_init':
>   drivers/scsi/mac53c94.c:128:13: warning: variable 'x' set but not used =
[-Wunused-but-set-variable]
>     128 |         int x;
>=20
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/mac53c94.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
> index 3976a18f6333..afa08309de36 100644
> --- a/drivers/scsi/mac53c94.c
> +++ b/drivers/scsi/mac53c94.c
> @@ -125,7 +125,6 @@ static void mac53c94_init(struct fsc_state *state)
> {
> 	struct mac53c94_regs __iomem *regs =3D state->regs;
> 	struct dbdma_regs __iomem *dma =3D state->dma;
> -	int x;
>=20
> 	writeb(state->host->this_id | CF1_PAR_ENABLE, &regs->config1);
> 	writeb(TIMO_VAL(250), &regs->sel_timeout);	/* 250ms */
> @@ -134,7 +133,7 @@ static void mac53c94_init(struct fsc_state *state)
> 	writeb(0, &regs->config3);
> 	writeb(0, &regs->sync_period);
> 	writeb(0, &regs->sync_offset);
> -	x =3D readb(&regs->interrupt);
> +	(void)readb(&regs->interrupt);
> 	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
> }
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

