Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C990C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiACAkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:40:00 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49052 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbiACAj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:39:59 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 202994Er000474;
        Mon, 3 Jan 2022 00:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DmV5IVwyFCsGtigPymnFivdORmjy9+28W4cBvAkvhac=;
 b=kTzjydHQPFxJoAQGzQTtV8MkFgJyeDRri0aOVancVcroynK/CCbxgbxEOOAxvYu6g9/O
 KiKTl2i6N1/c7jGF/PkOctl9DX8VL7UwFKkZEDtAZnj8yG3YCgUc5cM8vR/VNztbQErw
 1AiSJ7vNo8Oiyg0t9AFGHAdq5JWBMZe1tZrFH04l4pjTe671y/ulxTn+mqvcYU94uN3S
 bBdRpN5K+fiucLSjl72uJixMXpVZSBM9b5Fd5Qsm34iyPvl3nUgtU4PKeYsu+4m1b274
 GNCqyidCdn0TC41cGw31N8iVuT4v8byMhLCAhOk+lP11hxSTiR4rtNBRT15TTOT4aIw1 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daejshpw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:39:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030b8i4166613;
        Mon, 3 Jan 2022 00:39:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3020.oracle.com with ESMTP id 3dagdjufbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:39:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKJi8FR4OotTgMcv6OitL3hH63stW0Nakx0PR5A/5IpZU3wfmI4BTXKTlnBtPt8V2FeE+M+W5Tg7JMYQtGxWhM0Y13AvU90QbkLNLGXDdwSF9PhqNwH0nfVSS1l3+D41h7Pu66+iAlchCD4igeplhPe+RtWDhtGjrSwQztezNz93qf3JBUZNfRm40SuRzk3XmVP4wpHdQBjC95GImj2CxgZWet87ARl94DnDHi/hW0Avn2uNDR87lA6wNf5g4zW5QnUq2DUU9bi11G3fo/AUdJMs8A1wYrg5W8XXSmzmuYGVCqDmS/Pgh7AbyjhI2azzWhMEw+kGlqJjsPCK/cewKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmV5IVwyFCsGtigPymnFivdORmjy9+28W4cBvAkvhac=;
 b=aS6I2HzZ2uY0vBMje/AEvZvNjsjQmB5kBRXZg7cRVBIhaUJDGVBk8PqVIMNqAMA5ugIC/iFypC3a1OrUf3TP9hm/6I7P88Z+BtUl9JSpXRdkICZyP4qSY/mYGvwOpTUWjJiMPgC/NbP4iieQtwrhS3iaD4O4NOZzBQBWpgt6mcyrmne/ehaaBt9aOwrmffhOeAqTkMJtiiPvQhUid1xTlLL1sD23bSD7PIhs25xxGdM0hePIasJrsWHOGw3HRPRUuZA+2MGRq0OWWwvMhMHR8IROUa5uoeKgfYj1y3GgAZDtr9vrQ8PuFZC552mj84Lj7jCfbV+lOk+VP6goWreDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmV5IVwyFCsGtigPymnFivdORmjy9+28W4cBvAkvhac=;
 b=aBSyN8KMFgQRXVhDVGkqtH71pyHQgDy0olSmby7zIUefu4BbaWqKoSRewftII6C2Hb0TPd66FyDBO9UCDW8ZjfAWz+CUmzWvlxneKvbhW2FmYmTDiqXPHRqQ9LoqBHUxkaHvxMXXEomAe6HH1pasePiXo/s+HsHWr7SxlAGccOs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 3 Jan
 2022 00:39:54 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:39:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 05/16] qla2xxx: Fix premature hw access after pci error
Thread-Topic: [PATCH 05/16] qla2xxx: Fix premature hw access after pci error
Thread-Index: AQHX+JT//nuygI3tUkCbQH7ezsPHRaxQg66A
Date:   Mon, 3 Jan 2022 00:39:54 +0000
Message-ID: <E6DAFE93-693C-4549-B1FD-FEC9D5ED28DA@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-6-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5d68a7e-99c0-4bf5-4983-08d9ce518f56
x-ms-traffictypediagnostic: SA2PR10MB4537:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4537B97D1BDFC2B6FB2C8731E6499@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h/XHy8OjeCeJXT2x9v0tFb1VYB3E5y88ty5BayQbQqaudy684NOTARlcJpgRDtCN1ReWD9BhyWTTEqADVwtJLp78CdPdmW6xkn8kDA6mDCOyRp46nNFL3rKqQjtM6dNW3q9X2MDkQdqbOJyiAEtqdWAxxVJXp0exQSAan/w9FGv4WCUxSyQCpjW4Omuq5BeQYb+LR/XH/kQU+s3UYDzKgDTb0prZ97Ds6otDTAq4MmozzSKtdv/0Cxdk2yURbvhdnU/ESyMqehGrYgBFnqIpN3FbBdgNSqDpIaZkbjrQpEa641dEA9td84yZM3OZx71ieJKWPsD9BgZDrY+9PAyae79hKdjPVkYhr0xIghFW3deUIPcyYWvzuo2fn2+bx8Bq2o+OC6ZWpNhq2W/TjMWK2e1f1Imc6JAOnq/uRcS2bVJtuAJYUyrWPl76IepWS31Iy6fKAiYXj7/NjeFhYJhregaH/sG+TlZ76XcrEJfv68Q/W+F8lxGhXzbtH2fRWqivhTyAf9iF9DsHzxF/mPZkdwQVbt0nBF2D5Stww4lBZfkVgSv+DUxH5clynueokodni1sn1PesQUOVBoSFVfWCoEqQN6hhn6yFcJwF/kdGoMGC03tt7xGvE8hQCKpa3TpwDdOB7aaGmcVij5DxMF/47q7wIbDUsLTkius3eujZS2konD1ohMM9kAT/QjCr1lx54aj18T4soYJbIVww7MHD3LaekBdIyZblhypTmXoCrs0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(8936002)(6916009)(66946007)(2906002)(76116006)(6486002)(86362001)(36756003)(83380400001)(26005)(508600001)(316002)(33656002)(4326008)(71200400001)(38100700002)(186003)(122000001)(54906003)(8676002)(44832011)(6506007)(2616005)(6512007)(53546011)(5660300002)(64756008)(66446008)(66556008)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m7wxRwOjfghCB9uvuTOfC7LQbJUtiySjojzxPIgbyGfjk+KTarcWIODETyuk?=
 =?us-ascii?Q?tjwXbzC9OPc11cgM2REpqaJQxAGOaOJJN7zd9Wyzm17qvY22SrUaLD2xsUAG?=
 =?us-ascii?Q?KDYPYzyv4m65EW8R7MhCUVYfs5RvuxPosL6eF/GlDXJCwTqWrUR+z93TvPty?=
 =?us-ascii?Q?xy5NA/VaA2BTUn2petiMdxXOjptSZ2FyqE1M/pdvJFYTtn44LxicNJcTC6Ni?=
 =?us-ascii?Q?f1BZw37no3SQkr+EbNsEYHbZdxbtQoY0/ClGh6gtqGjsoQjgA7CIIdJSAEXE?=
 =?us-ascii?Q?6m1SufEFg9d5Ad4eAvd1Se8c2XE+e0jxLm3LE4EyJuUk3fCVkTtJ1Z8AvtWi?=
 =?us-ascii?Q?XVxw5w1rtceDSnK9aqopP7nEUorAWLPQvJ6L12WidU6ywiq7zZMZT0oxyUtQ?=
 =?us-ascii?Q?/4DzHF/yAmQSmae5UganVErKCH7yUP0HY1QShfaC/Pv5pXXo2e4gBW7qs+U1?=
 =?us-ascii?Q?h1zA7A0puWTfy1o2fAT7b0f/pZoiLGX2CqyvSOTw5pkayIzBNN0FkvmmaJUs?=
 =?us-ascii?Q?EYZQIGu7YEv7pwr4ToHCpOmxNGP4JE0mUUBw9C4cYCQ1AkPvWuK1Rd0JAHCg?=
 =?us-ascii?Q?eyN1rn2+J9HfyRBuYH6xzokmGsVGH1ZO5U0QPDTyIVBG8x4D/Pc6TvzmfIQb?=
 =?us-ascii?Q?rEBI/Pq2YRNcFLECHATYDPC0dWoGf8S6tU2bmXFUgVOPmLOMrr0ji+Q+1wAI?=
 =?us-ascii?Q?kw5Essw/nR5gsoK5IAvKmcXybG2EOIjcWZSY/kOJiKE8UgQ1j8M6E00sxaSk?=
 =?us-ascii?Q?/Zhx5DfGnGC2yyU/6Q7TaWODDkjJtdMUq6lNT/bR56nOB/5Q9V0E6Cwjt1xJ?=
 =?us-ascii?Q?IUHB6KpBb3TsVYaFsMjZa0pk5oBUsFqsaDsEPIVZrewrYhcpubWGkGiDgmec?=
 =?us-ascii?Q?G/M5q7tn0AW6USZcAxJ3naHqygc8TvJ9PUWvr9+lGHhY/CNs40S1HzVooPHO?=
 =?us-ascii?Q?cBsYZn5Xy6kgu917KjyT5wg0hwl3pwHjSU6V/NbWpRruCcCkD+Hutg8GAuUX?=
 =?us-ascii?Q?e6Ze49EiIINcjN9J79Eskxmqom63AWiuCZ3FxYWE+MMBimdGHrs8M0I/BKBm?=
 =?us-ascii?Q?IqsKrQMhDPfTf4LK5Au6rbczEHMQFwEPl8Os6+kGk+okz5r+pUIjEyMNo5Ph?=
 =?us-ascii?Q?JRui/qSQpecmPblR1pFqH1Q2OxglLNH40om3y4vjCseAfkaScnUwH5BdMT8i?=
 =?us-ascii?Q?RSup18EDnD1DusVXw/qUic8gfS8BfPMjRG3u5bsDVpg7L5yHjCj0o+AO8gS5?=
 =?us-ascii?Q?kJUot1KIBjPATB3UtkwM6TwMEr5imO5yQLov62wSDZYolOsu+rprDXjektG9?=
 =?us-ascii?Q?aX3d24LO6ioTs0U0nXcKLcAO3UMktxLNLND2A+IxDcwR9KXpnWlAla9MTZ2c?=
 =?us-ascii?Q?SXWL7E6vTloi8tG8UH+LzPLy0T7shR8WlYRXzABFGjFWglTUMKwdDlGXOGPH?=
 =?us-ascii?Q?A08DBfmgkglQuedtD9krtkQzoTBBvOs6PRh68JEPaPnoZ2GxEunsLzyM6Ewd?=
 =?us-ascii?Q?t47ns83ypl6fqVkaoDm+BKuDZTGm3xd7kHWmGcLrRwXIqA3qgVbW/1HrmSjR?=
 =?us-ascii?Q?mTLtWakW0GpVoXzHMgbNCWxkcjwX7nLU5RMc8GBEEh4TGye24Ao2Y9fIIzI9?=
 =?us-ascii?Q?tfq1h2adJ9PGYixs7e9UmXM3Ga6KeDPEz79Zervl9lAd4jGUueEFdvsNmwuf?=
 =?us-ascii?Q?zrR0AHYu3+WJYP9plyvSj4zsERY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6C144EC38E88643B31CF204505CF787@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d68a7e-99c0-4bf5-4983-08d9ce518f56
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:39:54.1636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sMCKNxOP/CtY9UIdhtnO1VdOhw5lhzI4e0XvEMM351f0mngR9htBJwwhc51NNw3nPsEYhwUkElXzqg1YA+tMdw2qS9EM5sG+sJVf/BqFTF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030003
X-Proofpoint-ORIG-GUID: cMxTSX14qoEnbDj6qIaPs1DkaXcOgzmZ
X-Proofpoint-GUID: cMxTSX14qoEnbDj6qIaPs1DkaXcOgzmZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Fix premature hw access after pci error.
> After a recoverable PCI error has been detected and recovered, qla driver
> needs to check to see if the error condition still persist and/or wait un=
til
> the OS to give the resume signal.
>=20
> Sep  8 22:26:03 localhost kernel: WARNING: CPU: 9 PID: 124606 at qla_tmpl=
.c:440
> qla27xx_fwdt_entry_t266+0x55/0x60 [qla2xxx]
> Sep  8 22:26:03 localhost kernel: RIP: 0010:qla27xx_fwdt_entry_t266+0x55/=
0x60
> [qla2xxx]
> Sep  8 22:26:03 localhost kernel: Call Trace:
> Sep  8 22:26:03 localhost kernel: ? qla27xx_walk_template+0xb1/0x1b0 [qla=
2xxx]
> Sep  8 22:26:03 localhost kernel: ? qla27xx_execute_fwdt_template+0x12a/0=
x160
> [qla2xxx]
> Sep  8 22:26:03 localhost kernel: ? qla27xx_fwdump+0xa0/0x1c0 [qla2xxx]
> Sep  8 22:26:03 localhost kernel: ? qla2xxx_pci_mmio_enabled+0xfb/0x120
> [qla2xxx]
> Sep  8 22:26:03 localhost kernel: ? report_mmio_enabled+0x44/0x80
> Sep  8 22:26:03 localhost kernel: ? report_slot_reset+0x80/0x80
> Sep  8 22:26:03 localhost kernel: ? pci_walk_bus+0x70/0x90
> Sep  8 22:26:03 localhost kernel: ? aer_dev_correctable_show+0xc0/0xc0
> Sep  8 22:26:03 localhost kernel: ? pcie_do_recovery+0x1bb/0x240
> Sep  8 22:26:03 localhost kernel: ? aer_recover_work_func+0xaa/0xd0
> Sep  8 22:26:03 localhost kernel: ? process_one_work+0x1a7/0x360
> ..
> Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-8041:22: detecte=
d PCI
> disconnect.
> Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-107ff:22:
> qla27xx_fwdt_entry_t262: dump ram MB failed. Area 5h start 198013h end 19=
8013h
> Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-107ff:22: Unable=
 to
> capture FW dump
> Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-1015:22: cmd=3D0=
x0,
> waited 5221 msecs
> Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-680d:22: mmio
> enabled returning.
> Sep  8 22:26:03 localhost kernel: qla2xxx [0000:42:00.2]-d04c:22: MBX
> Command timeout for cmd 0, iocontrol=3Dffffffff jiffies=3D10140f2e5
> mb[0-3]=3D[0xffff 0xffff 0xffff 0xffff]
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c   | 10 +++++++++-
> drivers/scsi/qla2xxx/qla_tmpl.c |  9 +++++++--
> 2 files changed, 16 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 0a7b00d165c7..c4b4b4496399 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7639,7 +7639,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pc=
i_channel_state_t state)
>=20
> 	switch (state) {
> 	case pci_channel_io_normal:
> -		ha->flags.eeh_busy =3D 0;
> +		qla_pci_set_eeh_busy(vha);
> 		if (ql2xmqsupport || ql2xnvmeenable) {
> 			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
> 			qla2xxx_wake_dpc(vha);
> @@ -7680,9 +7680,16 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
> 	       "mmio enabled\n");
>=20
> 	ha->pci_error_state =3D QLA_PCI_MMIO_ENABLED;
> +
> 	if (IS_QLA82XX(ha))
> 		return PCI_ERS_RESULT_RECOVERED;
>=20
> +	if (qla2x00_isp_reg_stat(ha)) {
> +		ql_log(ql_log_info, base_vha, 0x803f,
> +		    "During mmio enabled, PCI/Register disconnect still detected.\n");
> +		goto out;
> +	}
> +
> 	spin_lock_irqsave(&ha->hardware_lock, flags);
> 	if (IS_QLA2100(ha) || IS_QLA2200(ha)){
> 		stat =3D rd_reg_word(&reg->hccr);
> @@ -7704,6 +7711,7 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
> 		    "RISC paused -- mmio_enabled, Dumping firmware.\n");
> 		qla2xxx_dump_fw(base_vha);
> 	}
> +out:
> 	/* set PCI_ERS_RESULT_NEED_RESET to trigger call to qla2xxx_pci_slot_res=
et */
> 	ql_dbg(ql_dbg_aer, base_vha, 0x600d,
> 	       "mmio enabled returning.\n");
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_t=
mpl.c
> index 26c13a953b97..b0a74b036cf4 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -435,8 +435,13 @@ qla27xx_fwdt_entry_t266(struct scsi_qla_host *vha,
> {
> 	ql_dbg(ql_dbg_misc, vha, 0xd20a,
> 	    "%s: reset risc [%lx]\n", __func__, *len);
> -	if (buf)
> -		WARN_ON_ONCE(qla24xx_soft_reset(vha->hw) !=3D QLA_SUCCESS);
> +	if (buf) {
> +		if (qla24xx_soft_reset(vha->hw) !=3D QLA_SUCCESS) {
> +			ql_dbg(ql_dbg_async, vha, 0x5001,
> +			    "%s: unable to soft reset\n", __func__);
> +			return INVALID_ENTRY;
> +		}
> +	}
>=20
> 	return qla27xx_next_entry(ent);
> }
> --=20
> 2.23.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

