Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B60C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 05:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379928AbiFQFTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jun 2022 01:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379708AbiFQFTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2022 01:19:06 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817906541D
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 22:19:05 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H3v4Mh006661;
        Thu, 16 Jun 2022 22:18:58 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3grj5h88g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 22:18:58 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25H5C0dl029233;
        Thu, 16 Jun 2022 22:18:58 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3grj5h88g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 22:18:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwrqAMBJcJ/lcStDNAxDFeSlxW4PKFevUtI5GOYDORcXCpenp2KkJoUa0b8yGMQ4OQEOyEw7vzpefRpE1pavg2Rekwjh++RNis1awUDH0SN+Bvp2g/FVVQ3OS99ItZ6bqsB+oa+yh4Qe7aBkL7ckmTnj1OkQWPjP6lg82ZkCMol1AmMU1sxGKW2ENr+VOqBXGjsWNO8ETJqSJOoP0dFItcQFM8E0LBxis4hTloc84ghKMOyNWs52pEi1ig983MsbKs6Ub7WyKD/+1gb0heJ+32hm45vcDWkw8rR0yvrPGK/a358XL9zb3dWmMX+gf+fhRD6i0yOn6h5BLsSmtMi2eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlaZV6xfLhuHdTnrPmAvGQwnGQIG9iJaV19KL1sls3s=;
 b=AgYcDDKgoJUoBKFuqUmnrV8qakxJvmCoRTtyMUqXMj2kZbLVBkgTpWKZ+KQAMBZkSs0TSgw3+Hm9mch3l1HTup0GghfcAf5sATCaM4DU2r8RIJ/eMKIP/SN30LhwXLG2+G473qOvbyI7ijTlBQ8Zn2e0GSIvERIupOVYF32Z6KG+Nqfzz/PyM5RSQsG/dIMK1Cd888tzexK+1t31tAIzFGeYuH9+hjD2clKDJdsOl31kiLqB5h+DY6jnuFzn2JMx8cEizREYodt2nSYOn8SlbzrmsVzZBh96YrYOciPtgZFwkHJerectsQCt7RDTGVzJ1BxsmBcYEL8Kwil13qepsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlaZV6xfLhuHdTnrPmAvGQwnGQIG9iJaV19KL1sls3s=;
 b=lJIxc8e0uRF/vOhwoJXkRheyDP4W4vKGZR4PThp/C7eTGneNN5wtruyHPwWOPxP3CR3bF8C2TNxIT/Yr3/LsuYYYix0kegY8uk0IY18idMrzC3ME80Xv3x/x4t6CrReZDNbLWsyoE/T5/8KevCMz/P5KHJR8TIqYOdRka5QFut8=
Received: from SJ0PR18MB4509.namprd18.prod.outlook.com (2603:10b6:a03:3ab::21)
 by CY4PR18MB1480.namprd18.prod.outlook.com (2603:10b6:903:10b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 05:18:55 +0000
Received: from SJ0PR18MB4509.namprd18.prod.outlook.com
 ([fe80::dc06:a841:d77:949]) by SJ0PR18MB4509.namprd18.prod.outlook.com
 ([fe80::dc06:a841:d77:949%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 05:18:55 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 0/6] iscsi fixes for 5.19 or 5.20
Thread-Topic: [EXT] [PATCH 0/6] iscsi fixes for 5.19 or 5.20
Thread-Index: AQHYgdBT2XXQOKZXe0S0TZfHv477Uq1TDzOA
Date:   Fri, 17 Jun 2022 05:18:55 +0000
Message-ID: <SJ0PR18MB4509B202FB7395B4F2E2D3A0AFAF9@SJ0PR18MB4509.namprd18.prod.outlook.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d0f821d-f3ac-407c-6442-08da5020e02f
x-ms-traffictypediagnostic: CY4PR18MB1480:EE_
x-microsoft-antispam-prvs: <CY4PR18MB1480CA909A3669A4E766D933AFAF9@CY4PR18MB1480.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: olorT/gwMtfByxygo43sN/ltSAZbUmjL9a/ux1uSnLL1fFkB/xL6vX04kI7JFYDngT/XoT3gir/U66XqtohEnuAUcyr7MfvGwGR7pRYmCc4pq5FeRQRHcNb443DrTjlPQElQVo1YTgOL/s6k7s+hsR87mzet4ICtUeP2Og7IcUi36n0UYIdRumcNK+QzUf/7SXxgkWBWJ4NK1/Pt1B3Tnv6Mxai72qnS5LqPS3RAC1kHxa1qEq3siJhUZtFWqf4iIJ2uTcIgfCo2XBkvNLw4OJuNevjGF0r01v3zPFdbMbAca+nLNLgCXGiCt/slTGGXjnvENX2Uk8YPxIQ9JQUCThUAY04S7eCruUbInlvMXje5tVciOY1oto4pumOcyJWTaT/yqVBNMIzYMEMEvWzLL/8kYXPphct6NPYU1118C2H1XPcQG+fx0TnIID2RkAxBddvS+Y4vLh1rEfTd3X2fZ/JwzumEnKewH8G6EFDxQHPos7lIRb4ZrAGU4iiTCsmioWFrdL3RVtM+QPxpZ4PV1MPnqjq0cTg0kYWIKazearXnl8PXDI71bjIFuleBI147f+YkyPoFywdUL4A7o43sKjxEszEVXBevGtvTflixmXyibnbsWfuxu94DbsJ8PA8EwuI5UbJwlTWWrCFjJjfsdW+SjPTksJTx37kC8+KeQD0KC7XZCc+wNS/oa1/Em5gHPQxgf9wLQ/kky/M8tVqZNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4509.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(9686003)(6506007)(53546011)(26005)(110136005)(7696005)(316002)(66556008)(66476007)(64756008)(76116006)(55016003)(66446008)(66946007)(86362001)(71200400001)(33656002)(8676002)(83380400001)(508600001)(122000001)(52536014)(38100700002)(5660300002)(8936002)(186003)(2906002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SY3pPZu6yYgwoWrgQXmD+HFLZ6HLG9QjmANLV5iITVvVVP4MtOD9qpjNOt1G?=
 =?us-ascii?Q?wMv/TNOas00VMlDwb0EmIkkuJMcOZtSdzU5VAqjJ+O0Y4dD4tEJ2uSQ3w2nq?=
 =?us-ascii?Q?Q6M5UviViEolubSvGuDDQ5zLhITch5s9ckagVthleMKeG0l4XB2HZuI+dMj2?=
 =?us-ascii?Q?yd//zprFzdP5AI1byVxeFoINaVCh7VvOK98RcjoXyVdh03Y9JrT3OkI4MmWk?=
 =?us-ascii?Q?g0cisC9NS6rNl3ipEb5ggzg/Qix1n12MRJK27v0O4f7cXUBRVo3dsbczGB88?=
 =?us-ascii?Q?yNMhO4cVirk8Nrc9jZwZ4E/qdfPp68udagWagIlZzIRlTfInBL0nkg/iwamq?=
 =?us-ascii?Q?gSFrKLzfyhkrwWW8oj0VFhChmkCmEAxx+uVpCtKDP13xoB+Wj3guuQyMv2ZF?=
 =?us-ascii?Q?9X0uHtkKVm+UAtAPQxVM/5zKDbGHlfF4Av3zWRxuPleXOuLY4cLZAP+icnOL?=
 =?us-ascii?Q?CupB3Q6R0OZk5PCljWUWuv9pvx9tR0g4oeNHQSsmzaTfDBCdSUtFD0EVryMd?=
 =?us-ascii?Q?zcKvikKD92Kxq77C+bz3MajkxviHl18ld/Q3DNPgGOA4E7WyIY9cOW3zt0oJ?=
 =?us-ascii?Q?N9KXKrUoy/ilesgDk13CWee1R4QdFGblCm6FGQR16cTlCZxPoYlKNXIhLgDS?=
 =?us-ascii?Q?YM5Cs0UtT6eljmI/Os41/RxETjSjH8oBWCKSYWsioC65hcGVs3/DueZ2uRy/?=
 =?us-ascii?Q?qQIr+QAFy6VMRVu+eXIBiDI9O7yyF/HcPx25a9qN98sEc4G6Q7Ymt9Z52L59?=
 =?us-ascii?Q?oILjcTr8jhUWXrBelPhuInw2dcZr3OETF82Y7+9jhJYUHvDeXcamGu1kclvw?=
 =?us-ascii?Q?RZpSNG7p26ARuAdCHTCVKV5Ee+HvVzd31VIYt09wIIrygPZB8aaVuq9RSsd5?=
 =?us-ascii?Q?mNIC8PsSRHGByN70QIFWFQN4d7+VWqWVe/ot6F7BPreWC6bKmQ3kAYzTHo78?=
 =?us-ascii?Q?23f+42QFEaxFOoSbyqNGxvPBY/9sUClFh5zLq5AQ64BwGs82hcKcfK4ZfFiu?=
 =?us-ascii?Q?tx7NELF6Ebay0WUugLRQEzoahM1w5aYU/R4mFJQ3EJpLf8tHbXkIXniHNS5y?=
 =?us-ascii?Q?iDLZHWDlkcLrb+O936zSvbWq60nTil1gP81XvANxyI0D21ZoOg/2eOm1iiSz?=
 =?us-ascii?Q?2Tlm9Z2rr0aof5DtU/p22BMDqVWPdQbzkGgRAZWuX5+VnX9sU6+Dq+Bhahwx?=
 =?us-ascii?Q?8o+Nn5hhjZU+e/1QGGBc8qc9FvZ3Lr/Ss7h0nt8HrxOVgiDaGqrO72fNG4yW?=
 =?us-ascii?Q?ygSOSd4v90NAobdQueiqkhtczzDRtUy7NvhbXHYspfl+0n0Jknv2TjastsDA?=
 =?us-ascii?Q?5DwzMGolE39RD4ru5is3UP4Uq0R5Kz+3mX155HiwrIsqBZZ9vvpkBJudf20t?=
 =?us-ascii?Q?YOOeraH8vg2chWJISp8qR/DZZGZWmw9OM/Ff78M2ub+M4W4MyXaMhNpnupWe?=
 =?us-ascii?Q?Pmtv9eK/6Fg1CdiyfmpgX+/SZJlSufam2wczvwZPy52QCS4AHHZvThgpU7Qg?=
 =?us-ascii?Q?b5bW1PSiGjvgiJ+8dB5CXYBk0vmg3CkGEeSL93Le6+RSGJuZvr38/Pj3WsuH?=
 =?us-ascii?Q?IoZ5JGPyCwiu+Oiv7BaaSUUi6Ah0nWCEuoj8tISA1OibBzoFenRSRY4zHaf7?=
 =?us-ascii?Q?PXs3Vvky+avvYQlkfFmrqtdpOrkoqwMpqA0GfwwG1XRroT5ymstlbonfvXMb?=
 =?us-ascii?Q?clBgkC4vg3Bgr9utHYGG5LoZIfPnf5k3osqNlVydrBi8HdPEg93OMLNCwYk4?=
 =?us-ascii?Q?AEyytEjFeA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4509.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0f821d-f3ac-407c-6442-08da5020e02f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2022 05:18:55.6255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QZ4SIXXMGuIEiCfO0wdqE6L17WgyEeQlIxEpmSk16ehtFgLGAnWyJQOe5pCFc+uI/f8ZhBvzZcmctTvGj1LCBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1480
X-Proofpoint-GUID: CqFVG9HYgIHETzySRWLj6ePuhVLafTF_
X-Proofpoint-ORIG-GUID: UDPD1ILMzmO6mPHlFxl7rFkSVS0nGwYz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_03,2022-06-16_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Friday, June 17, 2022 3:58 AM
> To: lduncan@suse.com; cleech@redhat.com; Nilesh Javali
> <njavali@marvell.com>; Manish Rangankar <mrangankar@marvell.com>;
> GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; jejb@linux.ibm.com
> Subject: [EXT] [PATCH 0/6] iscsi fixes for 5.19 or 5.20
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The following patches are some fixes for qla4xxx and qedi. They were buil=
t
> over linus's tree, but apply over Martin's staging and queueing branches.
> They do not have conflicts with the other iscsi patches that I've ackd on
> the list, so they can be applied before or after those patches.
>=20
> The first patch is trivial and fixes a bug that can only be triggered wit=
h
> qla4xxx which should be rare. Patches 2 - 6 are more invassive and fix a
> regression in qedi where shutdown hangs when you are using that driver fo=
r
> iscsi boot. I was not sure if this was too much of an edge case and the
> pathes were too invassive for 5.19 so the patches do apply over either
> of your 5.19 or 5.20 branches.
>=20

Thanks for the patches.
The series looks good.

Reviewed-by: Nilesh Javali <njavali@marvell.com>
Tested-by: Nilesh Javali <njavali@marvell.com>
