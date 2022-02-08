Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BF8C4321E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 22:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386693AbiBHWW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386288AbiBHUAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 15:00:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCBAC0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 12:00:39 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218I4oCl012748;
        Tue, 8 Feb 2022 20:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6tMeL3b4CWwxclkSrdHW7tVDLLWONu8lgOjP5brX5lU=;
 b=nAM6+/eh0CnPjcoshJ9mzQi3s0drPM9nzXQCusxVyxUVmDgLIwyx54gznA5zCjVM1qzn
 REW5LJi+a6LVbuJLe7AlnhRJSzkcUeIrqhhCm4cd4LPcQaNixWjQGrFC8xaWS6YTibAH
 iDD85tTcqU2HjZ0L9u6NeMXItER1l7WPq2ZMSSweHIsQfquWatZ+iG22EWPIDTci8Xxx
 TXqDVAPrOR9wSGYQxZc4NHWAY/DeVaU5IGOzJ9zcnjqaTK1XkGGLGOu0t+BmHQYhDdQm
 du1sBtZz+GMLBV0ZalAihiz7ZGXN0wlKxekYds0IF2ZlIfztwFqPNiCji+Y/KfVu7kiG TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgjmtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 20:00:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218Ju72T154785;
        Tue, 8 Feb 2022 20:00:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3e1f9fxydn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 20:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYsSyNtpGdJs1ih6roQHFSXMWJSm0TfXuZC4MFViyqJOiXd5UJYX4AJxdTZJjILB5L+ChB5NZsv7zVyEnEit0EkQUxDlnu8mW6BGPox7C9r9nsgGUsIty8dHTE5erCY7h9XAN3suurALJwQKBmNEKiDy6wLuPYUR5mye73uqAuMnlZJDsZST3ImJt46j3kPxqBJs0p0C2x5zS3mPiTgh8g0spf4QEkW2b/SdiG1zMojBZj+KGwpIVuVhuHPatR6x+fubUDCldIY3MOGMnIK25R/IgGYc5Dopz8Vk5coBG4Qdjv+ucB4dHM02TjFhpe2O2rCXTAlFfMCl4Q8Oh+z94Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tMeL3b4CWwxclkSrdHW7tVDLLWONu8lgOjP5brX5lU=;
 b=RA60wahvUDWMRhLbiJQnkf/GqwNDVq2CO68kTefO6zk+Ig+dtIaGwBvkoGle6f6LFtoXHD9qVSoIMHhzRQDiAbZn9LA/YCzigna8/kdJEEg5bPDJ/IxwdvwwQc4zuerlwrvfwdA8++q/2v+Nk3shJ571n515iDJIzdhi7y9TaBzo7OIqIukPbGAjktqvuTR9Oym9thy7yBewvjPJvY1vUaZ4OZrt7fj4eg13MO+/3MxYoIwjkEShJ84xWvQLIxbTBR01BE06k49wUnZCjmii2syRpJn5oF1QLvBSi/Ze3Fqx5vtTnxASHPDRgwn0uEFIcVEQ3+TxWKswr2D/mDn0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tMeL3b4CWwxclkSrdHW7tVDLLWONu8lgOjP5brX5lU=;
 b=o1HRFUcA5j11WtHITA4rpPYyK4t97EQyX8xcfjHq7ePkI4tm2aAun0LH8jCAKDJlldyioJV60BtqCnC3rb4Wi8Nh+ahPB7sAmM5mTJuEM18exXuPcgu/77qyCGVWJat1ryuAHPPReXdFp2CQM9uc9N4msZeOd7oB94niRYDlCMY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB4973.namprd10.prod.outlook.com (2603:10b6:5:38d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 20:00:33 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 20:00:33 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 01/44] ips: Use true and false instead of TRUE and
 FALSE
Thread-Topic: [PATCH v2 01/44] ips: Use true and false instead of TRUE and
 FALSE
Thread-Index: AQHYHRENrNcPA6t350aJmr1E6Lchm6yKEuwA
Date:   Tue, 8 Feb 2022 20:00:33 +0000
Message-ID: <C87EFB2C-CCC2-4E59-A26D-5751E0706513@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-2-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80c34c88-ea8b-4823-fe24-08d9eb3daa7b
x-ms-traffictypediagnostic: DS7PR10MB4973:EE_
x-microsoft-antispam-prvs: <DS7PR10MB49732F15B5F80952FC6010BFE62D9@DS7PR10MB4973.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mvXr4kJz3N7SGg6XF2tB2IvDGk0RWMIjld1yTjY2hrt5XWZcipKqcgAqF0/2xZtLaFktPzfq98u4FgASxdYeoYNt411gN+fdweoOsbsmt5txMis6DCRe1e9hBuCyhwXznOQlXhklRg6WrnQK28IotQ4cXvJ6doHPDxp+Asw88T0MRqds/KtVD4OwIdm8L0PTIMXm7vG+ugwpMkPqKXGEPY0Nbqxpqh66sk8tHJ0KVLK2Xb/5+DECI2X3dUbruByxFtpGGpwm+85+ad4OHd7NWMkoVx+Dd11Zf5yw8KERyj7Gv11PhXX32jFJylRScjDrFsnJXAe4AvVdk0MtCM/FeulhPy0TcRkLzr9KhuybuEeUkagN/wlH0Ed9oQW8RMWPj/JtR7Vs7n8A6GHDpX5nDOtryR7Akz/wu1wIu39qmiSa/ElNdGVF1AyFHPArLv4BaTCWXN7yBRIefYU1Evwmvn++Um/7vdgqgyN0dz/cnPQwRyu3d9ECwyJR7H9jygoJf4JZie0j2N9fzQ/FBpkkjLcxjXv0C8dyeYzbKU/Rz50m959n3mbraRhMbPb2t1y6f19UBTp/N9F2JVdeaz06zv0t+T2LpsaLHL0Dax1/Z4PsDmkaM6Mj+qTUikaQ1Ea4dLd5y/fTh/JQe2C+BC+GagsGf//Cr/5bOuo2gDvb7CVBCc08v32TgX1sWaLTB/YGabxMlOcfigMSy/CvcK2tr7TFCXAjUJh1RxqAXHi/hTx/1FVKGdm94ufNUsFEiKWZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(83380400001)(33656002)(6916009)(54906003)(6506007)(6512007)(508600001)(53546011)(86362001)(4326008)(66946007)(6486002)(71200400001)(76116006)(91956017)(64756008)(8936002)(66556008)(8676002)(66446008)(66476007)(2906002)(186003)(2616005)(38100700002)(122000001)(26005)(38070700005)(5660300002)(36756003)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ygseJrcbqVXwe+Bl+Hsmrb89297srdsyD7BAD9jsNFnmKLpgTp+qStuzb+6/?=
 =?us-ascii?Q?q8OaGvC3SyT+Vc6gWS9nHiBBVRnif3RW93Z5WB5QMLx4cBfs/Z9qu200OBdw?=
 =?us-ascii?Q?PLakh5b8Kr5m3o4EXT+BeBaxoY8MB/MXNGCxTTnlu7wiGbGAvkrZzenhUKel?=
 =?us-ascii?Q?QfsqWghOzchpDFT/hbL69cGtykIVEoDvaFQWHDwp2Chrrim6513bMx7QtBbr?=
 =?us-ascii?Q?+pZ+DOtBEp+ZJ5tbR8mR/ckF/QOQ+HwiD3CGSeUq4nLkt6/TubKyzoMutLHP?=
 =?us-ascii?Q?Av0r6QcNOP/DwoPKX50eCM1CZHB40sbA0C5TAgXqE+QQ4e8NPrVab/5KXnNB?=
 =?us-ascii?Q?CLOTJDpf9ccplUPeSVEiYYbf0t/AA1C6kAVxAcOiLW9a6VHIiwigwnNtwp9Y?=
 =?us-ascii?Q?nNkhXhl++GPQ3nY35Pu6C4mu7mSNJ0qex727+F2OuWVjFyvAIGMKioGKEZSd?=
 =?us-ascii?Q?N8hLVyZBDopecx5u7ebPmVvcfEHuRNDbbz8tdH/yPo8y4gfvARLG9+tAkv8J?=
 =?us-ascii?Q?1pyz3GnDIZHWEKnM43I1MwT342kz/3SjRB8BZT6NGXvETawFn0lR02WwBEZz?=
 =?us-ascii?Q?tZUCgV2Ho9+vYsA/IGGIidqF5+gD6Szts+dZ2AjhwaZ5tOqq0+A55liCr0K+?=
 =?us-ascii?Q?497qY2lI6wnUh0zbJ1j0Rgw63kFwrYxo6PyDfUGdya1VKA47AZhOdA6q4oPc?=
 =?us-ascii?Q?TEE712GIdqwdq4wPWTY1/YMe32nspMoNEAhOMknVIXHDlAURLjD/moFmE+89?=
 =?us-ascii?Q?NKT8GIDe2HViuME9y/FLGUTHsrg6eWf/AKcnm2xT2SbcAhB0X4FDhFUGCn7B?=
 =?us-ascii?Q?uscwhuD+fKlDDE9p9MvnE3GyMUEtEneFWfSBkIIgge1G0CM3i2wezlZbmv8x?=
 =?us-ascii?Q?dKixYeh+Zt2uV954B3TUufdP6aSKDw0GzofcyLDBAWSpQEw9JrY1hGu+rpq+?=
 =?us-ascii?Q?yY3ZRrej17fJ6wyqgpAaBWwgDpc2HkwK89NQQa7AAfkcb1a8Osg/xlncPfjT?=
 =?us-ascii?Q?VPEjA1QSioSTmAC+j1TmkVvCNesVLYNfmnCWoZWLwA2+Qqrer58kobi7a+qf?=
 =?us-ascii?Q?v3wiAvT8SajyAfXU/gNP/uJEFHGFDZhokezCjc60VcB9ELrAuJOAojmnvC8V?=
 =?us-ascii?Q?9eoEPRcHl2Pw3517EEGFU4xBYlgkg54FJ5zwH2boX6zLHS6RKN10YDp+J4u6?=
 =?us-ascii?Q?uM4dzLW15HIeQc+QbMVVcLmC16E4WykPmnOu5pbUnvKYeMWTHykfK8xii/em?=
 =?us-ascii?Q?NTomR+k3oVNMY/kCDR0+hxUC8Afpy1jnKlCtNs8GhujETMNI1iGd8a3c7K85?=
 =?us-ascii?Q?Iuvp8L2hUDwT7ubqbIsLS7ibOc7VEzEOxv+Z20o1YhoLXtupP0lSK1yXkU9H?=
 =?us-ascii?Q?dNcCd0Pvw5XLKZ92kdfOgJ+z4VY5lex7feUldmBDKTR65OtxXAeD+fsStGqR?=
 =?us-ascii?Q?PxJf4TesubBWTTW9yr8g/S0nK2tkiHn5z1id1tllPzb2Ay1BbYDdl25NRCdO?=
 =?us-ascii?Q?8Qg+vOWcYlIB/U30T7MmVZfj2m8XGATVqJ2NKI422B4G1xyhde1PfQR9EAyB?=
 =?us-ascii?Q?6glafeww51fZWXj/94AdsXOuB9siP1jvgsA6Ylh1uX8HUbbUXUWevFc/ZNyX?=
 =?us-ascii?Q?UrQqjJW99fH/HABkDPvkpptzoxrg4tJM8zF4gJRQUKHFDBUagGEDk9F4TVna?=
 =?us-ascii?Q?e3MO2+/0/NhoPbYpScNc325oELk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F528E671F8FF0C42AFB4F9EEAFB29D04@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c34c88-ea8b-4823-fe24-08d9eb3daa7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 20:00:33.4639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PEKpU+8EHGM4sv0HNTQ2GI9t9QkJU8fc9vE6I6XkSnbjageB6xasjwtvjhxjnMmzCZfg+FgwHrKupDGmMXEmJqfy3k6yd7vya27n3zkG34M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4973
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080117
X-Proofpoint-GUID: qglwDmnYR8qmerGuDpm67zRU_I4MK7r4
X-Proofpoint-ORIG-GUID: qglwDmnYR8qmerGuDpm67zRU_I4MK7r4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This patch prepares for removal of the drivers/scsi/scsi.h header file.
> That header file defines the 'TRUE' and 'FALSE' constants.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/ips.c | 42 ++++++++++++++++++++----------------------
> 1 file changed, 20 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 498bf04499ce..b3532d290848 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -655,13 +655,13 @@ ips_release(struct Scsi_Host *sh)
> 		printk(KERN_WARNING
> 		       "(%s) release, invalid Scsi_Host pointer.\n", ips_name);
> 		BUG();
> -		return (FALSE);
> +		return false;
> 	}
>=20
> 	ha =3D IPS_HA(sh);
>=20
> 	if (!ha)
> -		return (FALSE);
> +		return false;
>=20
> 	/* flush the cache on the controller */
> 	scb =3D &ha->scbs[ha->max_cmds - 1];
> @@ -700,7 +700,7 @@ ips_release(struct Scsi_Host *sh)
>=20
> 	ips_released_controllers++;
>=20
> -	return (FALSE);
> +	return false;
> }
>=20
> /************************************************************************=
****/
> @@ -949,7 +949,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
> 			scsi_done(scsi_cmd);
> 		}
>=20
> -		ha->active =3D FALSE;
> +		ha->active =3D false;
> 		return (FAILED);
> 	}
>=20
> @@ -978,7 +978,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
> 			scsi_done(scsi_cmd);
> 		}
>=20
> -		ha->active =3D FALSE;
> +		ha->active =3D false;
> 		return (FAILED);
> 	}
>=20
> @@ -1291,7 +1291,7 @@ ips_intr_copperhead(ips_ha_t * ha)
> 		return 0;
> 	}
>=20
> -	while (TRUE) {
> +	while (true) {
> 		sp =3D &ha->sp;
>=20
> 		intrstatus =3D (*ha->func.isintr) (ha);
> @@ -1355,7 +1355,7 @@ ips_intr_morpheus(ips_ha_t * ha)
> 		return 0;
> 	}
>=20
> -	while (TRUE) {
> +	while (true) {
> 		sp =3D &ha->sp;
>=20
> 		intrstatus =3D (*ha->func.isintr) (ha);
> @@ -3090,8 +3090,8 @@ ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
> 	METHOD_TRACE("ipsintr_blocking", 2);
>=20
> 	ips_freescb(ha, scb);
> -	if ((ha->waitflag =3D=3D TRUE) && (ha->cmd_in_progress =3D=3D scb->cdb[=
0])) {
> -		ha->waitflag =3D FALSE;
> +	if (ha->waitflag && ha->cmd_in_progress =3D=3D scb->cdb[0]) {
> +		ha->waitflag =3D false;
>=20
> 		return;
> 	}
> @@ -3391,7 +3391,7 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int t=
imeout, int intr)
> 	METHOD_TRACE("ips_send_wait", 1);
>=20
> 	if (intr !=3D IPS_FFDC) {	/* Won't be Waiting if this is a Time Stamp */
> -		ha->waitflag =3D TRUE;
> +		ha->waitflag =3D true;
> 		ha->cmd_in_progress =3D scb->cdb[0];
> 	}
> 	scb->callback =3D ipsintr_blocking;
> @@ -3468,10 +3468,8 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
> 		if (scb->bus > 0) {
> 			/* Controller commands can't be issued */
> 			/* to real devices -- fail them        */
> -			if ((ha->waitflag =3D=3D TRUE) &&
> -			    (ha->cmd_in_progress =3D=3D scb->cdb[0])) {
> -				ha->waitflag =3D FALSE;
> -			}
> +			if (ha->waitflag && ha->cmd_in_progress =3D=3D scb->cdb[0])
> +				ha->waitflag =3D false;
>=20
> 			return (1);
> 		}
> @@ -4619,7 +4617,7 @@ ips_poll_for_flush_complete(ips_ha_t * ha)
> {
> 	IPS_STATUS cstatus;
>=20
> -	while (TRUE) {
> +	while (true) {
> 	    cstatus.value =3D (*ha->func.statupd) (ha);
>=20
> 	    if (cstatus.value =3D=3D 0xffffffff)      /* If No Interrupt to proc=
ess */
> @@ -5542,26 +5540,26 @@ ips_wait(ips_ha_t * ha, int time, int intr)
> 	METHOD_TRACE("ips_wait", 1);
>=20
> 	ret =3D IPS_FAILURE;
> -	done =3D FALSE;
> +	done =3D false;
>=20
> 	time *=3D IPS_ONE_SEC;	/* convert seconds */
>=20
> 	while ((time > 0) && (!done)) {
> 		if (intr =3D=3D IPS_INTR_ON) {
> -			if (ha->waitflag =3D=3D FALSE) {
> +			if (!ha->waitflag) {
> 				ret =3D IPS_SUCCESS;
> -				done =3D TRUE;
> +				done =3D true;
> 				break;
> 			}
> 		} else if (intr =3D=3D IPS_INTR_IORL) {
> -			if (ha->waitflag =3D=3D FALSE) {
> +			if (!ha->waitflag) {
> 				/*
> 				 * controller generated an interrupt to
> 				 * acknowledge completion of the command
> 				 * and ips_intr() has serviced the interrupt.
> 				 */
> 				ret =3D IPS_SUCCESS;
> -				done =3D TRUE;
> +				done =3D true;
> 				break;
> 			}
>=20
> @@ -5596,7 +5594,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
> {
> 	METHOD_TRACE("ips_write_driver_status", 1);
>=20
> -	if (!ips_readwrite_page5(ha, FALSE, intr)) {
> +	if (!ips_readwrite_page5(ha, false, intr)) {
> 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
> 			   "unable to read NVRAM page 5.\n");
>=20
> @@ -5634,7 +5632,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
> 	ha->nvram->versioning =3D 0;	/* Indicate the Driver Does Not Support Ver=
sioning */
>=20
> 	/* now update the page */
> -	if (!ips_readwrite_page5(ha, TRUE, intr)) {
> +	if (!ips_readwrite_page5(ha, true, intr)) {
> 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
> 			   "unable to write NVRAM page 5.\n");
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

