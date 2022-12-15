Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD53C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 17:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiLORiA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLORh6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 12:37:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E85442E0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 09:37:57 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn0GS004442;
        Thu, 15 Dec 2022 17:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=DffaRNy2oRRHsQcdLkJzrS1rW/KCcW9eV+nZjUI7eno=;
 b=rO288xGrx3PiqnvvUdipHK3H0NiIsxKtWfvYTF+0QjqUvswI2vGvMakhI0IOO6OGKX8L
 mYqETtfBiHAODfBwOf1VfIrfg7fMQYhw47jTyP1Mcbvqs4JUczixvLfRFmUHdB7iBl1R
 WKf4EyMjLQ86II9oQtdk0Wwwn1jtKMegiJhunyxm3TOfZq/QSe1QvtxhPwM5tdIdT65L
 +wTPpFVCXgUc4BgMHXp7NiNSmKIYgKl6N3RP3TZkkoLzBewSmBzwzMkpEbWhTeJYH/80
 2ZIyYePU7pGjQIrAcCs167pJ+L1GDvLY20/4es93DFM6UgWjc/2h0Kgdnvu5yP+q5HGk FA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeudqwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:37:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFHJg5s011010;
        Thu, 15 Dec 2022 17:37:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerv9c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:37:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gg8teg0/PnTymJZK22X0TSvRvxcjKRzQXm/a+pUIgyAvey35RziPkt0Rflg+TdLpY4nWPWOQifi/o7GdYrbVru0TYwCwh5XZPwBFuyy8ELL/Nzjoru/rXLfi7mLbs0yfuTL81GDWDus8sgAvaIcBFRqSClObe1C///nLnJUif8D4XL5t1c4k5qcsYFFgj+DboI60wBee6Lxr2P+IwF82GjVY85w6MWFo+FRVnV1EGxQFrW83+YytakMTQK7Xwgf6/LCR1x86TncVf9QwP4d/VCS5ikdYx93p082lWcxCfFWd/G3a13kpNEB0YSwdMgp83k+i9je5KG+sbMaCPLa3hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DffaRNy2oRRHsQcdLkJzrS1rW/KCcW9eV+nZjUI7eno=;
 b=ggqx8dlDbOjBRIszRuURjZ33mxk23gz4e4y47KXuC64uSxWe7n+n9006VpC9LoeBRnSK4kB7a1SUeX4fTQTsnEkGqXDVNMP+zeeg1PlfS2oFb2Z4v5r3NuhgDwQc7brztQBjGWBY8mlODvLnVSGsnnClXUmGHDItWZP4bmHuuKwJVjdyOnM3yaPgAIkmKDvgJEkeBL2HrzzXYgmHiN0rRMJeevI2/c1m3qlwdVTc6EMhLGFxjk5//fgrSHJcyEvwkw75RdogWgXQvnDKdzovIhC5wcZ4KpMOS2B9z49ipfKkp8pH4UUe4mLh4cgC16igmXDhKEj1vmABnbfP7WJe0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DffaRNy2oRRHsQcdLkJzrS1rW/KCcW9eV+nZjUI7eno=;
 b=Sm/q5veFo8m47J0H9upYk/TBzv+aMlnIh1+XpTOcr/uT5X/gTXA+PCGQCD9nGxmD/+gbajW9zh+A7J5MtXl66DlGzg2+l8/IZP+rXXv0DMYiIDPj+Cqc6Ncd29K1FDwGA91ywYAnhvEjmBquZ9iusWY4ddx1C5k86fD+JtyLmJU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH0PR10MB5257.namprd10.prod.outlook.com (2603:10b6:610:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 17:37:52 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:37:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 06/10] qla2xxx: Fix stalled login
Thread-Topic: [PATCH 06/10] qla2xxx: Fix stalled login
Thread-Index: AQHZD3eiH3cv6HmsiEGd0JWqvB8Fxa5vOPmA
Date:   Thu, 15 Dec 2022 17:37:52 +0000
Message-ID: <AC30131D-A0F8-4593-899D-BE6432F410B7@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-7-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CH0PR10MB5257:EE_
x-ms-office365-filtering-correlation-id: 4ece7b9f-dd16-4566-80cf-08dadec317dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jrCvFplELyUSjp9O27rT0lza/hXS05a8IWCCEU0K9lTTdbzUAOObqqIFIeyzt/vso+Wy/wRNN7ur5fKkAIg055iMWA7Oh+5ysHx0c9HJWymicM2ACts0yn7CE9TJepjrVr9spQTjp60MqZJfxTkYYmjtB1ORHgzfc9Y6P/Zie5uUTkBDPUuanEyVzbWLcp0B0+drMKIbOVNf8nHRXQ5Juy1CGulsaZuontxDNZp05IT+TB5kB148Q0cHP6aipQHMNc+F2W3SA43NPlihJKyiaE/tbHGbf0J0+Jx0AWiJDn5hO0hENfeegc0OAAHor+7s3pGeQEn1WVU8RNt4tDZ0mEODk6MFwzOCeFmWai3rs/PjjXQp33INOUx4Idxy/YJ4hOboBn7pY5OSZ3gdGvoGLZsqaUVheRqwDT6Vb/IggTAFus//o0toHUWdnoQEjGAXni7mYSjpX9gBRpxbb0Z8rbEF9TntBT7ggry6kNzX610ibK8xxkmKpeRiV1TW0A4F7yAGeUctagA5RWzS4FLyo4as1kSsyGMVJ/VilSFfzs9wpjQGzoSM0h3m+M2CuuSVcUOzhVQ/3Lkafm4WicP9lVad+PKpkz7P1VkDs/fr37pLGZZYBUyG/3lEIIkOOGbH+mtEDLUdOt7cdHhANyBBpUvv08h1i0IKOQquVSX4beehvH3xtdWrpxihtlHENaW78WBs5lB7SThcL3wzmpBtkLvBge//92yObr5zv5gDdI8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(53546011)(478600001)(6506007)(41300700001)(44832011)(316002)(6486002)(66556008)(6512007)(76116006)(186003)(66446008)(4326008)(64756008)(66946007)(66476007)(71200400001)(38100700002)(83380400001)(86362001)(36756003)(8676002)(2616005)(54906003)(8936002)(5660300002)(38070700005)(33656002)(122000001)(6916009)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5+9ZroE2o/mePlUaf8KU5r3NS24q3FhqUm6rMlQjaEwkzr8s28q8uYqOLAg5?=
 =?us-ascii?Q?O/7nEYb/fBLbv1w0uGSRNPCc5KA15xx4eif3xj6JNrUNFzUbCP3RYeL71tah?=
 =?us-ascii?Q?ucBsev9RrWV+ys5nv2rcoXp1xTziuWR63ybxQiZT75QSI2w29S7vyasrigyj?=
 =?us-ascii?Q?4KG17TFE6dsXVDYLkXbjRPOToReCGKdFLIU1xtVYmhyVOm7QuU2deN8alwkt?=
 =?us-ascii?Q?7bLi9hkz48uVfLOxADtoyNoabKsTi8o9F0IYny0gj8ExBIIq7VnTW5QsUn4d?=
 =?us-ascii?Q?ydFs7JTRsgoDFqrwyfBtVX61LqcRxpAoRO/Awon2+8PKyNyYFhbhZq+JcLBt?=
 =?us-ascii?Q?6QzWJZu64UuWUkPd9/7wBTlJ6sOEV0CaNlRNCjtPTIUjXOTDR48g7a9QGn4G?=
 =?us-ascii?Q?6xeVEfxculZ0g8LSzXR20+taacc2DKXZS6rPaYzeJfKzdbNxkxz0/T/k2UxA?=
 =?us-ascii?Q?JxHxjXIWf8+qCad3GpBTTHr2hkLS1/MvUJZAkDN7k/33+QV54cxUPf5jfsbi?=
 =?us-ascii?Q?6qzXviSxMLTFyQKpt0ximEW13zToQUTdm4+sMtUpEWcTKbiE0UlnQk9Yw/KB?=
 =?us-ascii?Q?Yk48z5hbucYnc3Ec/BciXzx7ntelt64nIQ1O+N7JTeXJBe1pTpjk98Ngrw4D?=
 =?us-ascii?Q?AQGe5AN+WZ9AWEzSFOrPwckBC3Uvc2TN19yq6mz0em9dfKuVWuLNeUVy/+5s?=
 =?us-ascii?Q?mY0wuPQP8NYT8K63JfveWLTTkaL1P8M1AyNx1k+VJmr+s3qpkGaTskfmWv/K?=
 =?us-ascii?Q?yKkLETgV8RJkoAtvudrzWindtLLWoasIYilsmCt1iiH6TlaTW+URdaGwSu6O?=
 =?us-ascii?Q?73+VLpui/pYC6Alqgd3xmh81IpO9loWzXo1K5SXQuBlum1t3GRyzOGY53Cuv?=
 =?us-ascii?Q?1aqEyaVbSGrN9QdQ43QJRfeyyN8LDN+Pj3+8C1vvxqGw4+aDfES1Ldeuuw84?=
 =?us-ascii?Q?HLWM22II5Q904mXZuKatyOAA+WmD7FCCUoH0JyDLtDw/7vPvTJe79az84oD4?=
 =?us-ascii?Q?KWk8KrKDoySIl0zKPmqwJ8qfpKPLP6Xck1/1Jf821zUDDzpv/RXyjk1dJn64?=
 =?us-ascii?Q?1NLfTKkMQRhXpoZ6ty8DxLUSJgfmPBSixtRzoaJUK45PfiT8xTFVquVK4z5c?=
 =?us-ascii?Q?IWNFOle9Eayzt8c12j36lrFCWkbNn4aCzGE6VZc9bDHHeVLD27UUy+UE4NJA?=
 =?us-ascii?Q?qJQjeroFMYNfEzg2WsCsSu+O4cn+2rij31mrsPgXk2wJV22YT2vYJYj/KoIA?=
 =?us-ascii?Q?nJJFxWNz7OSs6s2ynoNlYq9hkpEMOuElL6FJYlgRQJaT8Ktp01VipvOFGGPB?=
 =?us-ascii?Q?ZQuUNMGLnPip7uJ2n3wp0Avt+HEYszbnRubiAvyTGOLRo+wswfHP0YqsRiHc?=
 =?us-ascii?Q?si2MrXkqg7IHnheCVgFupWAfQrpm1wELGjUMa9CFEpNN/8sKhJTP+lJP3zdn?=
 =?us-ascii?Q?QtWABDYTWU0EVa5Bgvg2w2Q1lvCG5gKfA+W3LmrS0AEhCOcTHPAb8Euu+Jxy?=
 =?us-ascii?Q?NSnIpsyAMu7EeG5vx2c0dri8vTkLfmcQJPt0xbFbI3jOS3nmEy5yojkPu1q6?=
 =?us-ascii?Q?F4dW5oQ68ZtOcsY/YyV7m47FMItfmgVJZavbRwLQ7Wnw49FbZHxYtUrouECn?=
 =?us-ascii?Q?0Zpl2MoS0ybx05Hc2mn5qaaSqH47SZVB6wFKrSCAhM84?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89702F9F3596F845AEF8939611E52C29@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ece7b9f-dd16-4566-80cf-08dadec317dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:37:52.6349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ADd8ANgpPYbpuO/y/zu4PxQSYwPEqVR+7m23wseuDVv+svHydxPLInI21zDmhi/5DQUKA4tios+UEpP4Fu2YB3srf+hRtJ6HWM36GkyR4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150145
X-Proofpoint-ORIG-GUID: iB4_PU5C2oAbef5I-UlemG6UKjRmEczd
X-Proofpoint-GUID: iB4_PU5C2oAbef5I-UlemG6UKjRmEczd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> If a login failed due to low FW resource, the session can stall
> from being connected. Reset session state to allow relogin
> logic to re-drive the connection.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index fd27fb511479..745fee298d56 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -390,6 +390,12 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_po=
rt_t *fcport,
> 	fcport->flags &=3D ~FCF_ASYNC_SENT;
> done:
> 	fcport->flags &=3D ~FCF_ASYNC_ACTIVE;
> +
> +	/*
> +	 * async login failed. Could be due to iocb/exchange resource
> +	 * being low. Set state DELETED for re-login process to start again.
> +	 */
> +	qla2x00_set_fcport_disc_state(fcport, DSC_DELETED);
> 	return rval;
> }
>=20
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

