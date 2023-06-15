Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67834EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbjFOAf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbjFOAfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:35:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90942690
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:35:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJngJi015550;
        Thu, 15 Jun 2023 00:35:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=HQ41nrfdZTZyFZEOGLnkCk79AT817mhl7TLxBE+dzDU=;
 b=F4gSuXnGRtfVB/d4YhjdvPByiAwjO7wvUa8UKL3ARaMYlK5UU+qkq5g3PnaS/N712mqL
 QZWI25uRitOwFzVkUBBDlY5QEPHY/gD+BxELKAvMg9ANAxn/u/oR/GfqEZPQFSJzZ4MV
 CCIvlKZzPeZFsZty9Y2vE4idxBLyjDuFF/XDw424bQ77t5uQRbJ6UXnoFpyCBcqEywt3
 n6AZtj1/8L19sMuzfeN1lT8YalE2RI2WD4WlerqDAuqyeUStGx9C4oIx+St63p6H76vX
 ois+dZqJ2CjH3mQjc/O9A1PSo42Nftg1xlVCyKF7rXEygOEgMskS1a+QsyqOU/9Uaj9Y Jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2arsf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:35:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35F0CaHX016284;
        Thu, 15 Jun 2023 00:35:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm69peq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:35:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8vXUcXRlaH0APfl0bG8J2wb4sQvW99k45EyISA+cDdbNz5vYgLWLe7eQC2JPO/FO7SvyZkUdHb/huosTMpF+4mg06d93N7UCfUC+4ABQP0OlK+a8Z6iiJExvbyK6hzkXZZX489zOhWiwzujE3dTJ8qfP6JwyfL5JJWu309MJGjrh2dP9n3f7PF1MB4PfNXyQA0gRKS83x/RloKJ0EygCNfQGyEoPV8nNX3MgEU7joA3uEi6JUsuvdtZ8eYEgVyqbqLy5+J+NMqAg0dTtjtNHgQf6qmwDMRDq/aYcW1fDj8HZR8+lai+t+izW13zpF28vcp0yzP59vv4Sl9V3BFy7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQ41nrfdZTZyFZEOGLnkCk79AT817mhl7TLxBE+dzDU=;
 b=RrnN692vSe/xzXS4PZz6R+HvG1ZnJUnpjyUTFr2T5rXXaux+GlW53UJFy3MXJKnKELineST31JrsaLyerTQQfRGqKkCoDKWlsFey/IFUA8R1tVMIXeSquIxr8FB8Gs3NcxchKDlQD2nyll0pUM9LD/vrjdNN64xr1qc9TIxKiiScBEFs6JMfP5X14fYY2xmlwzcjXKPwG2VmVZ16XlnFxeFK5jWvqAXmjnfFjdm1pr6TPKjQbA5LlxygyZkE06+yEGzuUlONVQ3MUjCHHutGEiTtkEvjAdRLreMHbu47mnUs1knAykzWf+cWhvspJPw5bympd7/kY8SeAaVWzXD3oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQ41nrfdZTZyFZEOGLnkCk79AT817mhl7TLxBE+dzDU=;
 b=s4H+Cpe1VPifKmg0yo03l+j2LmSMWsynf0zfX7hAmRepifkktORZVkfsaVS8DSazIU8IGPo6zTqg7/ss5XUCAFLgSQXPzbt46WKjT/NMxHym0NECOd6YoEjOOVTzxPEVjwwdUslHs1C//cWcex0Y9BiSDOduG05NItisg6XGeDg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:35:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:35:48 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 3/8] qla2xxx: klocwork - avoid fcport pointer
 dereference
Thread-Topic: [PATCH v2 3/8] qla2xxx: klocwork - avoid fcport pointer
 dereference
Thread-Index: AQHZmTSrv24qwmgd60SXjDbVERMK96+LEDcA
Date:   Thu, 15 Jun 2023 00:35:48 +0000
Message-ID: <AC8684D3-950D-44C8-A6B7-B2B0C2935EFE@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-4-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: 65e937c3-d3bc-48d8-24b8-08db6d38772f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQluXiI93DuUj9BKF3lOY+cXTKwANE5OXiy5wBjxlmNISSFQkYLwREjT6xR15s8fjx0+Lkr4CKOPJ7Oik4ROytxfxiFs4X1JdIvgan0x+4Wvg7LVSKctJgAIw7J3gcX/RfLFhoy9Q4WsbHpYgcQngoCTNmKxmIvWZWPHXJAKz/Z2K4Vk83fON/NNS7dBGOr7mP8pLIEVIZJsJWMowr7QqUeCZak+iRXGe2r1XzT2uYJJTpKAvAiha1smrjsBoC5NhBbiYhCd5bOZS//17H2R41WtLSdfniI3UAtOr2AlFtbvzOgObWv1SaFsWCdlrb6rTLVjxkcUlpviKsmtPeHgb7vENxo+WwLnwq+liDNtAX+ZTsVmG3nnIsZV347sluP9T7R+ll46oAcE/FJDJKwdmjtS1Vy3P1OD4cM0PWQ+hy5LB/euklRkdxiqCl4oEnYyMwmD1xKzgHaDuvy72UYsuvolqM6+o4+38AS3CDXHNPsGF455LFMW0fAWNT7bM1UwqO3PSgYSr/fSsxAcaQIINre1YigFuSGi7d663nBS3FLSoEcljuwBsx2vnpjwbcFFtdAoLeUPv1dPNXTk3tKmb+jMmVbuburL+gol+PXrfVIILxfHSi5pBx/p9l1vQUPNBrKDhYHuK6iG/nPmFpUWUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bPm+KThT0u3BSHjlwviik1bVBKLQrJ6vUrq/tgR+Jwc0t22V18B/DckEFsEx?=
 =?us-ascii?Q?kYyzgDy4v4vdSefwqyTfyn+AP2uD6tvCkjwsmOoRovZc+4MEp1xjFqDaVKs/?=
 =?us-ascii?Q?AqkbWBBoBV9m1YcgaaQCqUYCm5t+jyh84IzpFKcwXt8pfdu0eQkXCw6nN9c1?=
 =?us-ascii?Q?x7eg3/mlVxqdUyj/xYJ+zfLuTG0sOY2x93SbLeNJM7KgH3Tz448FG/hn1XDC?=
 =?us-ascii?Q?Sac9ayeF+nBRclp4VnSB/ozwBTufaDnJp/NftVrC/2blqxYCbmVBZ5X6obI6?=
 =?us-ascii?Q?8qh5gDQI9kaz0/ldg1nlH5HW3VL/dpYZksW/I5nmQRU1+G8H7qAymKUiBHkW?=
 =?us-ascii?Q?0WBPugL1HlMPZZoz0nmb33FNFUhUDD5C1nmHkUKWORZYUifgoN77rJeeMOq/?=
 =?us-ascii?Q?G1UdTovmCkevJ311Mp7ocwVvnxWhfvFEx+ptBBuQtEcqhSadJ2lmec+lPq2x?=
 =?us-ascii?Q?zNrIO5hS7qwZdqT9A8/jjmGXTAHC/s2ZHUGnfPO9O97dBkBqvf/xIE2DEXCk?=
 =?us-ascii?Q?lGhKc8wvtqFgSNl6fDNISFgQrFptSSErSR0JuegN3l35ZLbNaB448QUkGrJY?=
 =?us-ascii?Q?r2PfX8GfbAV+4J7J+Oq0ZOWiVdoy1ElIODZYEg+K2px4F7AD7dKhiywUcT3U?=
 =?us-ascii?Q?0BIjtIIyNPCCEc/gHbey4S//h05EPKL9DQolyZXXaIcDQkGV6oiHiNVAR9nP?=
 =?us-ascii?Q?TwW+SV4tWis74xiMWb3U/cL95Wr/Cp/sJVt1offw2vFUCe1Im5mRxqLAUe+O?=
 =?us-ascii?Q?fJ9crdGDy7Bj18cRsPYuy4AQGPMPsJ7yDVj1wL6ZqohF93w0OcA28UM/taw/?=
 =?us-ascii?Q?mlbTpplnvWiZF5rR9U6zV7Oxf3YmjBcMa9hvdHgrMF4uM1n91/mPH4fqBMvn?=
 =?us-ascii?Q?Bmc+7IhNPCq7gDEm3iXD4did3U/Hku3N88lRo3wwMSSr8DbHKqdyj8+poUaA?=
 =?us-ascii?Q?RR/EgHrfR5st6a4irjGBg80na1GpyAQOKzOCyw3cRwo0OsJMfwu1Z3a4/ne2?=
 =?us-ascii?Q?Xg6Ekl4f8SzLpzTo8kWSg0hCc+mEdtOaivMY8DCTcRo/N+Zxy3yZQeh+aus2?=
 =?us-ascii?Q?CFEvYSc4nv/XgqY4nBCbBKLE5LX0jMsMmPzMqVzuOKiENDg61LS/70HTHxcX?=
 =?us-ascii?Q?bhHzBjz3omWLup+9yXjkYWTgrW0gSYoz14aGMMT9zNpeD+QnQaAPa1KazRQ7?=
 =?us-ascii?Q?nmKPfXEB6w56TCf9bw5sp2AH4VUkwXkCt9DChCCmPC+im+cpj3YsBUxhrdMg?=
 =?us-ascii?Q?3kBrruzFRFd+mDMzUxz5K8A7UNbIgvZHR9+go1TZYyowk57bblCxGnG5mPJp?=
 =?us-ascii?Q?nYSxXSNA5FjynbkvU4M8e7EAeMzi9dKL0lK1QFf1ZgItFs+O3EUG3Zi+PJr9?=
 =?us-ascii?Q?0GSo3Q9jLKOLp3L0HpTox7CI72MSaTCHzM0bcagc7FbnXnC3P+DNs31uyn7B?=
 =?us-ascii?Q?QjaveI1T+hDDhXxwqjCjkrxc3OMx1fs9QrPBYlGNxXX8ejWgAmFocCtX68x6?=
 =?us-ascii?Q?kHzRpyZnlJWCq4djJrkKqmUeTFANqBv399IK/n3k4GvEaFA+LxVlEwhKEcLu?=
 =?us-ascii?Q?9m6Ed89Q462tPBWXO6XdgCVpw/AUC0VNnQFlOFM2jdFL+R0YL7if3FXsSbbU?=
 =?us-ascii?Q?fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D3080E6DD0D5F4FADAEA34BB63B9061@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jY48LiD7YVbwAsIkWwvH1FFTyXw1dEZHKCFBxUhXV0VGNbcjq+f1yVg9fppdlhdhLKMpkrIjmrJuHTBvznemkKzo9ZBos/cY/MOiV4MpqYHLFOPQBMnazSyX5cUjjvYk2Qp3nVCZt9rF9+ej+U4UNc54RO3JNB1PyGwJ1jcUOWGN+W5UY8n6rpqDxiqY8YiXuZAvHXVZGNKj3cspwFSRarGJf8w56y/j5TZMovGFeni/CFgZRA1LLWqS9amUM//QIWxBncGsIXtbk8Lc2XGOjwPxfK0vldOKEPQuGpu4IfOPu8WY4SGUg/ExoN5pfH8YMn3s3V3ISVxCeu4GHP+ebP+wFTLLjNyF7V6xZNalLMU2IBvnc9bcsIJ64uuQz8DSfcL6LRU9PrmPjqCURtyN+K5jHNcvR610yd9trseGwd+tnmwSxgOR/vqH14r7OAkrPNq/1Updkl4aYqlUNuS5aFpg3aD8STJeIVbVNjWiIW+0x+HhTHM6NHX2y1WQk3b+hCvcDSqu2wxDtFSchq59qJnNJNIaf12YfN8N7jo0ezGncr+o8OQyJzYZ1ajyJ4sMic/1M9pv/ZFQBOxAi7PfhYihHQ0txEZbA4iUNiac6N0MURAmGLxLFR/NEcwc4vf3wkeaOBCplHut47htkYCdl9QGLSz3Q0rHe98zexIRNGc2/Gm+IQqHxX19BKkR5lffi5IJbis8dTJpORWlYxikpZOsVOf3fDwkC/rRZh0LWlytD1VmERhHFp91uVDdt+Qcjr1Lt1NnYmzE+gf22il9c9MpRCHRmVTBwGpe5VrWoLU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e937c3-d3bc-48d8-24b8-08db6d38772f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:35:48.7980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kilinWuVnDQvgi5jZUzTxwHFEAa42K4qTylGLtMo7yoWcMC5dNyeTYxXHE207XKWIH5e2iZTaA+Zcx34C0JaNoPEAJvSpbTxCoCUCRXsIGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150002
X-Proofpoint-ORIG-GUID: jjSZ3rJ-PW0nu9HojNXe45jw-LcKDMXl
X-Proofpoint-GUID: jjSZ3rJ-PW0nu9HojNXe45jw-LcKDMXl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Klocwork reported warning of null pointer may be dereferenced.
> The routine exits when sa_ctl is NULL and fcport is allocated after
> the exit call thus causing NULL fcport pointer to dereference at the
> time of exit.
>=20
> To avoid fcport pointer dereference, exit the routine when
> sa_ctl is NULL.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> v2:
> - Exit the routine if sa_ctl is NULL.
>=20
> drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index ec0e20255bd3..26e6b3e3af43 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2361,8 +2361,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha,=
 struct qla_work_evt *e)
> if (!sa_ctl) {
> ql_dbg(ql_dbg_edif, vha, 0x70e6,
>    "sa_ctl allocation failed\n");
> - rval =3D  -ENOMEM;
> - goto done;
> + rval =3D -ENOMEM;
> + return rval;
> }
>=20
> fcport =3D sa_ctl->fcport;
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

