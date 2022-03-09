Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB01C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbiCITHb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiCITHa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:07:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0092101F04
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 11:06:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229J69LH030944;
        Wed, 9 Mar 2022 19:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hAyF+FzDLuEALr4RwkIdYJRznamJePV8K560ZyLucvY=;
 b=sUxYeIlWISBAvHH2lV0lmx4r7sVkCvEW4uU793Y5GBxQIltd6TirR97YJK3GuzolJmUG
 bM8Xxi5LZ7L7XDNWQEUY2zwV9XvqpfCG9IMXQEJzD58BwhLDwMu2cZ2ULRo652w2NUEb
 2+iHKojxK1DXWAET2MWxDA5wkd8Zn64J6pqCaX+tmKsCogzet3GSduPd0t+P3UWmZzOG
 Wcc7XLQNn23Q+4rP4wfO6vm2V8ouVUM0kK0YkpRRPJzt+W8Vg+KX5JZPreYWG4gjBMjc
 DiUXr9Kd8ECTLFiISzMLdn88KMkfNlWiXxf2MFgxBKEjstad2AfM1mb9F7ayxeXmCaZR JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyratnkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:06:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229J0Plk127272;
        Wed, 9 Mar 2022 19:06:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 3ekvyw3fq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:06:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8hMeEzwBbQyn9GObHpC2p5+7deiDn9LXJjhaW0Sr63jmyW1uX4F31m4JXBiVLMhKD5Rxf8jpPVVefvCFGRI6wGMLG6C+C5Ra82OR1g5882NskllmHx5Kp7GofQ6mBZdPkJJlHb+rwH1QY+xbpv5VwoigcdWaDmI5DLJcFFoutlXNEFYsI5eCSmpcZkW/uG6fOy4zeutZE6fZ5aXPAm5H8xlCXMXWk311UZfVLplg1/eKkFuK8FzoxZnXIB9D3CJ0VypWS6YsUhpLsAQh4rF6siKLZT9eBtj2mEBoAUhdLJE4C8SVjgVTh5FyuAu7CIQHqO2T3x8t1o99Ecj9KV5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAyF+FzDLuEALr4RwkIdYJRznamJePV8K560ZyLucvY=;
 b=YGnA5tUF76s5RqsYZY+vaqj/1/nlDaTd7rVFYa9F7Ky0ANIegOhlIvac8yjKWcXBFvODReP47qun0neSgwf1yOuFQw8Jkf92X5lpLsp6cTDrv49B72eV7k1jLJR5gj34D60DbQVjpx4Yiojcw6pycU9wADvwxWseLosQLIx+bYJlp8ZQhU7QipmJu0H1zwQRQSaxYi5T77Md6NMsAPJlQ1fVSheiwxZ0x1BaeCaAcTgBPXw5CPwA3r8bpQGflcllgzEBfKiQ7OVGoc9aJe8TYJYih0zIAQoMfcgvUniQcEHakYZiF36try+0BsDinEhRScQRsixOQusMksTy5AjPZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAyF+FzDLuEALr4RwkIdYJRznamJePV8K560ZyLucvY=;
 b=QFT4Sj2Y8w79Y/jODmsKsk6xPhe0yfDWsow4VPr4IEAFIz3x8DjW788qH4D2aICkfv4thxjJFH0H5UiFrF4h3zYA6v8xqd3/EPPQOPq0rYS7ip3BPly5wVyV6xUeS97JFA/LBQKg9U79kVY3W/zQ30zgRIETbJ+7JhIaBgjaD4w=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3370.namprd10.prod.outlook.com (2603:10b6:5:1aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 19:06:26 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:06:26 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 09/13] qla2xxx: reduce false trigger to login
Thread-Topic: [PATCH 09/13] qla2xxx: reduce false trigger to login
Thread-Index: AQHYMsWD/xgoTPrYmk60STiyqj5U8Ky3bACA
Date:   Wed, 9 Mar 2022 19:06:26 +0000
Message-ID: <95446DF4-1441-462F-83D1-D75C759BADC2@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-10-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 308db852-220c-4df4-198c-08da01ffe8fb
x-ms-traffictypediagnostic: DM6PR10MB3370:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3370F2C631420C795A534D21E60A9@DM6PR10MB3370.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /WAjAFF4pGVV0i2adV8LpS361jazAnCwHTmnFtBLL2UjsgI9kL+Tiu5tlLPPIaAa4OUv3NL6pEdP+2wYpThX2FOdob6BP177IzdA1ym/1VFxTboGKC2CQ1OokWhZD/C0+h5E7HLxKtP9xf0ziLXXleUPRmUKu/GkE7GxfWGRPl7MfsDdXwjqbAFWUjGNW7IuWvDKkLAZHe/yp0t2fSyOHbbEtlVZXDyfdxqu8i82DgurgsvoXu3W241yU74J3SNWnWxIYAZyI4TAxVokeZtLJT8uTe7fTILsxtjh2XOgsAxYB5t/NHwoXvnw8yrcNRI1aeITv61wfXd2rC4Di7OpdVfLG1lrwymOilDK+pwlck9188RhXjy7r9ZFCjpTw/sjo47eu1K9uEf0xVn892MG+PNDSU6F1EX25279NcP4widLEjL0ZcxWEdEmD9a5WO+8HXPw5KnsMou2HKxXr5JJuFyxo6hvX4UBUiTHIY3yzMBRPYhAHSZp+n33NKXynvnm/5Yvw8IoVwSs8FpadVpjDhPJwH9iSZRzMP6/zmEHp3BN1sALflJykiFQXC/UoS3zjK5AvXopFE2OCrFxt0aQXu7sE6Py+DWlGuaBsVWPdW31kEuUCLWnISXQe7PdcYNNmphLf300bihJBxsRWvj1vukusdDNvF8zCj2s7KW5MmX7H8h1N2TQmPb+FkqqGWXk4Vvu3uo6hkTcluL1H5qvWPNZV5GVRFWcncDAuv9JIukbJui2iI7I3zPxq9Y/LFEW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6486002)(38070700005)(6512007)(71200400001)(38100700002)(54906003)(6916009)(316002)(6506007)(4326008)(66556008)(64756008)(8676002)(86362001)(66446008)(53546011)(66476007)(66946007)(8936002)(508600001)(122000001)(91956017)(76116006)(36756003)(26005)(186003)(33656002)(2906002)(44832011)(2616005)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aXtlhjEozqiuiO3RN00HhX++/QxxnXoXx4ZuBZXBGQ6Z7O9OnHEXWH/42CN+?=
 =?us-ascii?Q?JZvBPb4hB2aDpqe2oc0QmXZ9ewGEc6MEg/8XfQ9Rcga3Bkmbo3fA6jQOFs74?=
 =?us-ascii?Q?qYkuocAYizEVjqHlPAzCNYdnSIHFIoQeZGtaV/emv9Wx7cXJPfaGjKHPdTPo?=
 =?us-ascii?Q?oqftDlAfilddDn1nAW87bXWHzz0LjxjDGHX/fLfgWGDb9emgdsP4+5Gat9PK?=
 =?us-ascii?Q?zKNTxuxmGB84h7C6/+bqJe7zvnUdUPARjd2en/u3vbc90N7O5DyIHZRVWRJk?=
 =?us-ascii?Q?57ZA5w+umRursZa/Cg6FjH/TMH24AoZEXZkGtxJAf+gbpKR+Jf5iBHwFB1nF?=
 =?us-ascii?Q?b0CJPAXDgEbiXzJGJnNXYdsJmiTx4pX6HHUY/6oZoet29Ygno1ZzIfzqVaOX?=
 =?us-ascii?Q?02ZMk+nh57cn0BBJeV+Fd9cXCQAu+aM/ZvzGlYZnNpZ8uulpP8QKD8gMQ880?=
 =?us-ascii?Q?tKBfd1QD5+c4FtaxsDk7TBNg0f6VXyLBsSIodz5URW9MOoLpIHgjzrm4R/35?=
 =?us-ascii?Q?AVYmDSonru61D7kw+Uhrwcvz+lLa6OBnGJTIH8wNlcSdUy29Smw94FBjbOvI?=
 =?us-ascii?Q?KtJrlxga4RX5IRhTXC7PDH+9WeH27q8wIeEZ3G8TFSA5evTa7PTi1TOb4U79?=
 =?us-ascii?Q?ut1xhv3XG9sUiqWi0eUTReeQ4BxMztMFjgv4oH9+xfT8XfltHxkwSf/9nq+E?=
 =?us-ascii?Q?3yyxJJOu/VSR1MTHemG56Qmz3KvIQ7/ZgbE3tsI8oyvBFjHMpU/jPl8Bvup0?=
 =?us-ascii?Q?7kRnqx20y7ogqSwcqP+HiuRsHd1EsfdtJ7qh2GYx8rx+XqpG4puIeMFez2YN?=
 =?us-ascii?Q?UbywX5JsjtBbtWg1ZSYEhDWjfxhUxedCRVFX65yGRiLMi0hhJ2JbIQi6Wo7R?=
 =?us-ascii?Q?sbNklKVwqCfH3/mvRUjbZQlpFHuj1VTFQ77uHHzBr59b9N0RKcitkD40FwQi?=
 =?us-ascii?Q?dUYu5nY4QHAktaX40S9rR2GmFT/sjf/Y/M5vwEGD2qZJ69vFtEMV0GmriQ0g?=
 =?us-ascii?Q?vbW5rZG7r4LQCEPRIcznSAG/D1rye0WNZ3eqX7Lq6vRjb8R6SCch6/LGrl5F?=
 =?us-ascii?Q?CJWTneF04MZCzSDFUT1WmMYsZF7sMc3rHOZ1oU171WLQ2WOnDeIbmEzHKNR/?=
 =?us-ascii?Q?m5jxkoP/bINBh8f2hjY+qIx54JwLbXnXZr9jiX2HgbXTKOGHFiyuxJOxid/w?=
 =?us-ascii?Q?k6jHWur/WnyKj2zUYveZDghuk+nQMtG9RsWNXroPuOQemb9auPWcQT2qQUVA?=
 =?us-ascii?Q?sgXCKLcta9qlO4y2jjda7gclMa2XgS1+oKcDqBAbM3mT8nxo/k275mnO/Drs?=
 =?us-ascii?Q?+hmoH3+YfoQ8n3Ddq12GaiG4YrENpTIu/yZK23UaNOZ6gt/NqxRKEBZhsK2b?=
 =?us-ascii?Q?Kei14o+HBiLzm3vHpuhB16x1+0/NNIXHqPHpWst/FgV4q6PtETgFFhUbhHKW?=
 =?us-ascii?Q?HqLCL5lSYJ0KNVJl+qRhklA7cd9JOwDRWZV0SP2BikpfX7MqRnfuAJuEzPNt?=
 =?us-ascii?Q?9QmH/u0NY1q71aVW/wH/NQeF6yX2Q6MaSMXEmyx8kdMpsd5bjrO+DXruHYkM?=
 =?us-ascii?Q?uSTcoOKEDmkXjaWHLA1BkWYF3Iy128fxyXelt6NKM6GmMRqARUXziZfPTJmc?=
 =?us-ascii?Q?XFNd0pbH8tdVNrCqm6obfELuYQx2BLVoGBPtfBfR4SgfXOBGmglSe2piuEH+?=
 =?us-ascii?Q?/n6Yfd9Zhxxlsz1v3nARPj+xdno=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75AC336950C743478887F6EA48DA784F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308db852-220c-4df4-198c-08da01ffe8fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 19:06:26.2311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y8Q90+ZKvT+S9PR4I1ixWNLoe9wliVTsopNKZNzkVUeoAQrH3+83P71HMCIovoEZTdFNP3IT3PxaZ0SfJ75FSu3FOnFybXjBkG6ODHd2M1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3370
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090103
X-Proofpoint-GUID: utovtzzAU1oNlW9bNB6pt4AoSRZl1Y7v
X-Proofpoint-ORIG-GUID: utovtzzAU1oNlW9bNB6pt4AoSRZl1Y7v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> While a session is in the middle of a relogin,
> a late RSCN can be delivered from switch. RSCN trigger fabric
> scan where the scan logic can trigger another session login
> while a login is in progress.
> This patch reduce the extra trigger to prevent multiple login
> to the same session.
>=20
> Cc: stable@vger.kernel.org
> Fixes: bee8b84686c4 ("scsi: qla2xxx: Reduce redundant ADISC command for R=
SCNs")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 3c58a2911937..a53894444460 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1644,7 +1644,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_hos=
t *vha, fc_port_t *fcport)
> 	    fcport->login_gen, fcport->loop_id, fcport->scan_state,
> 	    fcport->fc4_type);
>=20
> -	if (fcport->scan_state !=3D QLA_FCPORT_FOUND)
> +	if (fcport->scan_state !=3D QLA_FCPORT_FOUND ||
> +	    fcport->disc_state =3D=3D DSC_DELETE_PEND)
> 		return 0;
>=20
> 	if ((fcport->loop_id !=3D FC_NO_LOOP_ID) &&
> @@ -1665,7 +1666,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_hos=
t *vha, fc_port_t *fcport)
> 	if (vha->host->active_mode =3D=3D MODE_TARGET && !N2N_TOPO(vha->hw))
> 		return 0;
>=20
> -	if (fcport->flags & FCF_ASYNC_SENT) {
> +	if (fcport->flags & (FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE)) {
> 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> 		return 0;
> 	}
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

