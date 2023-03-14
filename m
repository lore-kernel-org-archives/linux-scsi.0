Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264C9C6FD19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 01:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCNBB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 21:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCNBBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 21:01:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218AE92262
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 18:01:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E0EsLu005648;
        Tue, 14 Mar 2023 01:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eSTQdY9+qCyTlVSaenYFrED9iVM3rtyOScrc0+MS7eg=;
 b=UtK/BrWR7omm+eAdU0bZa1QGlJLloOVUkd8Gl95zjKK96FipewnJYIWbjq00EEyjWDFa
 +2nXZWOSh3jHa+v1WONVYuS8fdMU8PoePkZhmgDlmYBm+4BWtwqGyBji4Rfdslkjgxi5
 q5nGi/XMTpzR8p2BCuv/aq4omVNb7QybAFFQ14KqN2+LWnLuBobpldQ26wPh6caGGAGj
 k8RaZ9rgSqHEEkqm2cDMZsmPE2u19qc644ble7xl5bDNa4dqSYu2hslrP9FTGGjRrGoV
 EJntDPDt2EKji8YeHHLt7XN439uhM3+tBCjzv1jeZoNOODrmlLZu5fjOU2XkLwuSw1Ca yg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8ge2w7cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 01:01:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32DMUine025056;
        Tue, 14 Mar 2023 01:01:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g35dygx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 01:01:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSmA1LgQR2VptUbY3WYw8X8E2KyhRaI0v/UhLjKuiWJiBD0Y40XW0B+hPkBQcqoe/d/DDQW3M1uFVEuBE9k+WOenfhVbDQRTODHUlZRPQgWCWN6IxAPRHhEbGcUi9gKKHzk9wkrZW9ZkdCzILipvxB2YZtLxJKKHVWDRs4+NgpUp5gmI3vKXrfyNWvikmyqSr1Wg0GKJH87cWFtMnHlY6mTAgCXsD1abbYm1WZE897yjNWKyEwL3u9Wqlofj8jh1bO+vk6PVtLAYf/jS3Pn3AMHR85PZINtKZhl8LuUyYa6In3KNbT0u29WWMwv381lpIu9o/E8I/N8pdMLCjqBwEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSTQdY9+qCyTlVSaenYFrED9iVM3rtyOScrc0+MS7eg=;
 b=FeFEdidl1fg6vfmcKAYK4I9Vu1/59j8TxNJk26bkxpd1eSAyGyb9In7gTK9jpCIQZx4wXkiG+9TyWKuOmD8/6lPitWl8Gw5rOyLvipoArgfRuBpTWpmkEolTsaaHkdlFmvfwXhB6uzZfomZvyHIyHgwXsjMImaspRgT3S3uE8Xpb8zVcnLPk86tKH4W/bHD4ZsVvHKo9O4f2bUkaACN+aKJ5IDDFLAnve0DtM7t05froi7Mz1r0zGIBkaR74zLaRclEMiv07bULSFgSjWvaqPYZGZJYp/K6EU29v03pbfMVXRiiq127fhACkCsx08J/zwU1laWbrLosYEIczFCHHEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSTQdY9+qCyTlVSaenYFrED9iVM3rtyOScrc0+MS7eg=;
 b=STsXlUxi66JQHIdlGoUnRayua6CLPl55B11VzvSrAXIha8CxKxBnrvOyFmVtfaj3QpRVPSEioNbqrI0v2i++JhZL+Rz/xtq38fOs1VuDSIgFciUxZCtZBVtEBJPVnS6NkOoe/0S6t6bF86O5h9qgZ+/r7CWWk6F+QdSftlxsRrU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SJ0PR10MB5599.namprd10.prod.outlook.com (2603:10b6:a03:3dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 01:01:44 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::3c4d:2182:8a44:31b4]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::3c4d:2182:8a44:31b4%7]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 01:01:44 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH 2/2] qla2xxx: synchronize the iocb count to be in order
Thread-Topic: [PATCH 2/2] qla2xxx: synchronize the iocb count to be in order
Thread-Index: AQHZVWWLj+jvAnOTKU6D3PsYOm7I3q75djoA
Date:   Tue, 14 Mar 2023 01:01:44 +0000
Message-ID: <A1BAF4C0-5C10-4C3A-B4E4-5254F2ADDD2A@oracle.com>
References: <20230313043711.13500-1-njavali@marvell.com>
 <20230313043711.13500-3-njavali@marvell.com>
In-Reply-To: <20230313043711.13500-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|SJ0PR10MB5599:EE_
x-ms-office365-filtering-correlation-id: 38919f06-9d7c-4ec1-37e7-08db2427ae17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aszGt5/q8PCFRyMhBEVhSRhZFCAZaqosGLamaRyrf+bBEhiDvgI13dvA7T60Q1ONEcTCO0AnnDlGM4mR3aVXoxSOyZpejXle/IoRAz3eqgfWcWg7GOWpVFajPQihxfFQEa//K/SYQfQuq7yAYb3F0atx4rgD9IB2sXx98yQjVYehg9ZZB0iFqKeRykyoQzVgDErsxlbqb1GdH/Fcr28dIJuz9erUbmQril1rZBN5HYQt6hunylz3BwzGRekAS9FonII38CF/1KKdyYGvJeI05JUXku3KhS+vcxf9lPwhsxMTksHA3xdWpyHFcbkCbTWHehCBy2TU+GJUBvF0t5jJFgo9wdoYxdshSR10uS82m9uSB3ho+C34ivlVAeZd8dbmx4h3DTADZbY0pC4/zwopbjDmcaRsTwf9VxaS5t5VrWWQlMIII9pnoRCHob2NM+IzcsOmeOFX9tYuvjXOcSgCMhAyXJaqvkoTqWpzs7EdH600iP2Ew9eWm4Er5hLiffZ6+rUCuTxxkoi8cetyUumMMurbnfjuAnQuZXj9xEu2uPtTIzxAq0ADTiahOBRxzo9iXG2iHMXfp7D7QhEBzofbi+qrTUUTqZcHlIng6Q14DJ024k92Nc6Lmb42Tr4Et8Hp0OMI8f0jWcACfe4rdSZc3wtPBdSPXVwCYQTkcpfhDAALzqDvezuxGZjobEI0dagW67JGSo9gm6B3iCexlqI+VvFXeBZw5p1NUGE5PlxL01c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199018)(36756003)(86362001)(33656002)(6512007)(41300700001)(186003)(26005)(53546011)(6506007)(4326008)(5660300002)(2616005)(6916009)(8936002)(54906003)(316002)(71200400001)(478600001)(66946007)(66556008)(8676002)(91956017)(64756008)(66476007)(76116006)(6486002)(66446008)(122000001)(38100700002)(38070700005)(83380400001)(44832011)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UBq4PGANvrtCoug2rXOb1rOV3VmnEfNbomaBz2MebuRIRD/I31DfXnoSjvtD?=
 =?us-ascii?Q?XxOLcSd5qcOb4ZGyAcGw1J2eZv9mmxc1srPvSIu+Ez7uQyqd35q8YY+Tcewt?=
 =?us-ascii?Q?6wtyuzrpBl2uTAzWZ8GQ9GWI9oOuJRUujb739bm8I7rUZeufIAXlqTn4DODG?=
 =?us-ascii?Q?oJol4TxLkAh8HyjnbXOrrm438yAvO+F+c0VRU6F214bLed94H+/zP4ktA2LG?=
 =?us-ascii?Q?+h/hnUib2O1rJaMFmIp4NkHYXJD1XeDclq24ZSth9gZ2rsRFzSY8YBRR7mQf?=
 =?us-ascii?Q?D7a6WPeEgqyakPnw5yvK/tyHDB75zlCVW/TANxBAKZEVy3Pt/DgDAQC+XJwM?=
 =?us-ascii?Q?FpLywTpGk6gKc5Q7DQ80k1cCxAS+MIEC5T1plEkeVbKNPPuJpj39ExzMU4vT?=
 =?us-ascii?Q?TPaSB3J3oiuR9xINw4mxS+iAEeCG7ZVzdTW/Jr6uwnDc4K3syeWt/hcXtFQS?=
 =?us-ascii?Q?Y5wrP2eOV6Mo+8A/jLVpWBPo+meUUfSa/9DETC3z+AsTO7+wR/w57AgEYhmD?=
 =?us-ascii?Q?FfPqrUPxhduqka9MAv/vI50Zp/jGbHNHrxmYgHZYIQQzv94Ns638rh8QBFoV?=
 =?us-ascii?Q?wEMBCLvrV+x4NdvxSk4Nv0NACT2XpvIGQ51sJcD4GFEgAYp1HGQVM4JrjvTI?=
 =?us-ascii?Q?zYdZJBMY6IJomkaAc+V326KPhRjRH4AJLf+xrBIES7ptjr/rBn+iktvwxKXs?=
 =?us-ascii?Q?XRNhJUJY8xQgZt/tbKeuQtDtfsKGiTrdYcmfnvgdc9oiNRRVX4rGktVaTCRz?=
 =?us-ascii?Q?LUgWCf7EelM72zfBu/iw50OhhXZEeGZ8rdYueS+C3iD7yniAKYTnB9S3l5v9?=
 =?us-ascii?Q?oZegffa1bPJ/rkiN60IEwkzDfxHREiUMfCbxhWE92LOd4z2p73kVNUArDHXw?=
 =?us-ascii?Q?DK6jRIfZXOGAYOhpILBK6ASxsce9OmsdnaVqhI7/3W8u0Dww5sEpnF0qGlTb?=
 =?us-ascii?Q?5jkCOdm/Ez6T0+y63JZNAMkOcKHk98wFNiujGEDS5FlXIXkM7q4IDD7fJT2S?=
 =?us-ascii?Q?MggQhnXBQeNpPOWXGVIkLroRVzrsoXNbu7BAf+Kbr+DP3ug7FxnLUg8ptmox?=
 =?us-ascii?Q?dSOFJAjZifeME4zZpSpTN7e8+tgIIM0HdGjCFM0DujGTWiFRcUgb/OgIajQ8?=
 =?us-ascii?Q?OnuaOoMyviCv7wbw2ilVT6yxlrdAaADIhHQAqIcVhF/M6zJxYpbTn9AqCalE?=
 =?us-ascii?Q?GkFPVTPqDIutFByDFPlvP8uiJTIfFFihNYqWqsDVWUn5rU6hvdoeSpNoGPcC?=
 =?us-ascii?Q?o1X84SR0zWGWpS80QT0y+inojLeYwBy6NUEi7yqmbmSecwVbq0RdiRPCS7xK?=
 =?us-ascii?Q?jPyMWtNBtgzO/b223Ehb+jDgq5JbOW3fFja0twZmmcs3HMBB6zEvhU1vXeKT?=
 =?us-ascii?Q?54oBdxBmyWqoVPBJNPTKefZnxVwJjNrXN1dSk/jW85M77/gsFhdjtJ/xqlvH?=
 =?us-ascii?Q?nnB2J1zAu09YBhL7v/9n++/VbRl/EBLCos76dFrn2hzYpMSAPnJBY8DbhlGX?=
 =?us-ascii?Q?v3HIJQ5wGeXU+fNPlJbknPpzZS6+scWBjMguAUk2qvPfdvgIWJ2GlEgbBIg0?=
 =?us-ascii?Q?pvSTErAkHX29i905B/7VoUwPD8XB8rXPAvFqWRdBzlkDCmWqAPUwwbu9Gmx6?=
 =?us-ascii?Q?ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8094B6AC440B74FB3FA6C45B48D7FAC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JLJYQPQGN7PAm8LvEtj6pHUxicLkvscYUFhyifw3DTUtRNHafM/MY7WWXoCzNeFzp/oI0dNWXi2ZrMb8pBfEhFttmrjFoFD0zYlJ6xJiMT2ixUhuOZUqbFmAYAOi3P7mmmtq/2AtaDBNV2vGxJR6WOdBduz6iWDcZhZTb+hPNTodI/1PmXYXY9RT/Hf6oP8hqsrLCjPp8mOyxhK4QKJ2HG+mY6E50GVzry0l7w7rgDkXbKva6kqfAaCLpFZZRmiVkpODwjQZOI6xm9QmOwSPboBSdk7ZnRAazHdLPqQdeaOYk+ga4h1j7JanI4LLSrn4Hmwzpl97iIOJiXGKy/mDtASNtpzn1uPQxO3RKXZFY/yy0sIFirUtqgZizg16xWqF1z7/C6Dnv1hBpcXH+ghA21k5wLrpETpHDuPm1hwUdn9/xtY+rhOB2XqirbR0rAItUTAPf+yAm294m26AsNZZJtzMzzox9+NTVJiarHxm4qnk7kU3iSMN9tfcxNJT9jzXuMqMk/sy/Sh/O47toXkAEhTlDyRK/tdVIqycdSYhTdeHwuMV+xCSFEZpiCGtuFF8aHhNjxCXz2ryaNpsIHPJ6CB20sD4QB8ADxwkcik6NbfT7YOcu/oh+oEPJV9CznJvGuej+Huq1v0MVKOs9yZmEvtVG8JPJFSRxEpFa5MSHFXtO54CaPrefS0OYFD2EGfT4E4aiVViA38QQGONYAelx1SaqDB60QVaDZeVfx0qugZ0UP3HbCXFDny2hMCmBsFXKjFr3k3bKRQWeCPOKjuikV73/XIqwp8h3sFjtpqEyrI2DLUML26wKJeYxId4pZUR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38919f06-9d7c-4ec1-37e7-08db2427ae17
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 01:01:44.5670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4qu/nHsBUExE0UPEuTYqrDFErqzAqcypErYlvYazCWSExx3O6QAWNizJO1x07c0UewJiui8q3/kD10RG5xKWm9q38hZO1nTyf5cl9YY3y34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5599
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140007
X-Proofpoint-GUID: tJKafCRKLNDuF-v6oGCes2K-knVm7mN6
X-Proofpoint-ORIG-GUID: tJKafCRKLNDuF-v6oGCes2K-knVm7mN6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20230314010144.O9XT2FFL3FZvCcjAY7L3l-RuFiNu06-SgUrQVekc9m8@z>



> On Mar 12, 2023, at 9:37 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> The system hang observed with below call trace,
>=20
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 15 PID: 86747 Comm: nvme Kdump: loaded Not tainted 6.2.0+ #1
> Hardware name: Dell Inc. PowerEdge R6515/04F3CJ, BIOS 2.7.3 03/31/2022
> RIP: 0010:__wake_up_common+0x55/0x190
> Code: 41 f6 01 04 0f 85 b2 00 00 00 48 8b 43 08 4c 8d
>      40 e8 48 8d 43 08 48 89 04 24 48 89 c6\
>      49 8d 40 18 48 39 c6 0f 84 e9 00 00 00 <49> 8b 40 18 89 6c 24 14 31
>      ed 4c 8d 60 e8 41 8b 18 f6 c3 04 75 5d
> RSP: 0018:ffffb05a82afbba0 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: ffff8f9b83a00018 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffff8f9b83a00020 RDI: ffff8f9b83a00018
> RBP: 0000000000000001 R08: ffffffffffffffe8 R09: ffffb05a82afbbf8
> R10: 70735f7472617473 R11: 5f30307832616c71 R12: 0000000000000001
> R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f815cf4c740(0000) GS:ffff8f9eeed80000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010633a000 CR4: 0000000000350ee0
> Call Trace:
>    <TASK>
>    __wake_up_common_lock+0x83/0xd0
>    qla_nvme_ls_req+0x21b/0x2b0 [qla2xxx]
>    __nvme_fc_send_ls_req+0x1b5/0x350 [nvme_fc]
>    nvme_fc_xmt_disconnect_assoc+0xca/0x110 [nvme_fc]
>    nvme_fc_delete_association+0x1bf/0x220 [nvme_fc]
>    ? nvme_remove_namespaces+0x9f/0x140 [nvme_core]
>    nvme_do_delete_ctrl+0x5b/0xa0 [nvme_core]
>    nvme_sysfs_delete+0x5f/0x70 [nvme_core]
>    kernfs_fop_write_iter+0x12b/0x1c0
>    vfs_write+0x2a3/0x3b0
>    ksys_write+0x5f/0xe0
>    do_syscall_64+0x5c/0x90
>    ? syscall_exit_work+0x103/0x130
>    ? syscall_exit_to_user_mode+0x12/0x30
>    ? do_syscall_64+0x69/0x90
>    ? exit_to_user_mode_loop+0xd0/0x130
>    ? exit_to_user_mode_prepare+0xec/0x100
>    ? syscall_exit_to_user_mode+0x12/0x30
>    ? do_syscall_64+0x69/0x90
>    ? syscall_exit_to_user_mode+0x12/0x30
>    ? do_syscall_64+0x69/0x90
>    entry_SYSCALL_64_after_hwframe+0x72/0xdc
>    RIP: 0033:0x7f815cd3eb97
>=20
> The iocb counts are out of order that would block any commands from
> going out and hang the system. Synchronize the iocb count to be in
> correct order.
>=20
> Fixes: 5f63a163ed2f ("scsi: qla2xxx: Fix exchange oversubscription for ma=
nagement commands")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 030625ebb4e6..71feda2cdb63 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1900,6 +1900,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, co=
nst char *func,
> }
>=20
> req->outstanding_cmds[index] =3D NULL;
> +
> + qla_put_fw_resources(sp->qpair, &sp->iores);
> return sp;
> }
>=20
> @@ -3112,7 +3114,6 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *=
vha, void *pkt,
> }
> bsg_reply->reply_payload_rcv_len =3D 0;
>=20
> - qla_put_fw_resources(sp->qpair, &sp->iores);
> done:
> /* Return the vendor specific reply to API */
> bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D rval;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

