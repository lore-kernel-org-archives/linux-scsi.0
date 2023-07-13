Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32CCC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 18:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjGMSzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 14:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjGMSzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 14:55:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF97D30C3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 11:54:36 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIjutm015475;
        Thu, 13 Jul 2023 18:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=99h+3eelMrigBN/5q1sNT/ukQnnbqCLZx1gKRo0WHYE=;
 b=kJ7IRP1uKU/BhX0qPmykbzlczmOqPHxmMwQjnPgYM0jcEKiMtwQ49eX2uw9L9k2sZmRW
 UIalxBty/BDVnvLutUg4l++W8H67susnmPVU+50R7IBkQ1D5Mo52/hq/y/s4POj8YxT1
 gpveshB0ta4mega0444ZBBiJdMkJRkqqTmF3PgKdO6lZFZHtdBccv2V5QyqeCNIbYcyL
 NIG3p06RDwSvfwRerzbmtxxHKHn48XoJr0NQITAYH4CXeZRFwxh9qiVvM9lRYxXFM+wf
 Av8XqIE4LfH7vLnwtftv50xWR+lQsfE+eOLzZd/P7uWggFdeKv0dlzDIbVxRqQ3XCzf9 2A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpth00fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:54:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIn2Hk027660;
        Thu, 13 Jul 2023 18:54:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvq07b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 18:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IT5SbrvQNrakoVRFEkBVUnzQltcKxFArVbacfNot0vXVwme4EdXKLK6UCIaZJADiYGODrX6aHOMzraQWaJxQg1A5Fj9KRk3RmzubcvqDIZinFFTruvvoYeVp6uRY18DPtBbeQtN622tmH5M8bg2ee0AFuYAdE6crO9qHh3xOLFFHgzbWsmRXf9JHZqYIE2YgmjWW057U0+nT3qmav/GlpBKCNCzhQeHL4cvzTaNYDNsOqQ1mTcmGX8k109se9mrHtc3ghib0tSUb3K3MK4mzv5yAgLkZG8INAA+MKoHeqcAhRMrpaw4j58cQTZvNdFou7aGTYtzZvPFTkBYfS6zr4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99h+3eelMrigBN/5q1sNT/ukQnnbqCLZx1gKRo0WHYE=;
 b=EMvYAh4g0+NMF5LPadfExv78plitdCtPxsZYKWqSYM4ivZtL7jzC37E+smI9XU/ThWKEr+kr7BYv+eXLjQo5xaKrns+FWaicg3JFf5D2HRdthiLdYw8YDWS1vH3bYpOpbTeessfpbjcHZlCsWNsxkcIktK7bybzptG2mQqsJBwdsSCOF7Nt1Pn3uC5njJ/uD6TpEHW9ISpGcMgK/ALaX2QWdthUrLV9/tphZ9PQiZRVe8aZvc4kGE/tGeIDeV0j4p7dG4FJLsWNSQOAND94GViaN/+1PDc0xHVWy6hgt7CWChzCnr8WSsa8mYM4/9Cy1wKgTnjJkd/7XsuPul5ytnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99h+3eelMrigBN/5q1sNT/ukQnnbqCLZx1gKRo0WHYE=;
 b=UQ51R7LGrmDHWSMrTIxZYFKobH3/NJGbgtMS+94fSulrbM8BVbFCVfiPWwlQScoBWYjgBdAraqv1AYbtFEp7biAvajpSisDe20/0r1jDnZMRYFgmQ44+9cWY82On2r5JWGQUkkhXzYlhB56b0VVqEgJh7ELsUEtE5zyAWbK+bHQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB7034.namprd10.prod.outlook.com (2603:10b6:510:278::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 18:54:06 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 18:54:06 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 03/10] qla2xxx: Limit TMF to 8 per function
Thread-Topic: [PATCH 03/10] qla2xxx: Limit TMF to 8 per function
Thread-Index: AQHZtKBOHCerI1NfXUGm0qN5ZxXUTa+4DX8A
Date:   Thu, 13 Jul 2023 18:54:06 +0000
Message-ID: <5B570699-D651-4F3D-92EB-0416C006EEDF@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-4-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|PH7PR10MB7034:EE_
x-ms-office365-filtering-correlation-id: 4e58deca-e4f8-48ca-dbbf-08db83d288e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9DPtCoRBuECrcG1pWjj5Qm1vemBazVNVf/fsdXtFfjw1Ci0WqkNq9tkf7WojUh2T38AntuybvfLlsFxT0Uft7qaMtZ/u3uXFPdgJm/RHixrEIqP5Jamee2ZzKTSdgv28rtgNjGGEALtmnSlU5imbkBlnEMcw9x34H9d/kO/Y6EqAax1mBevIiQ0+3ZC7TtWAzGDWgs9KBsFQqv48C+AD00Vq1Gkvhpu/7o3PcbMMs2KXtpFrwbqg02rgquKpS+xxDPMwZX0B8+B9vPT1LHHMVLthHoC3UZqpz61yEmG8fbtX6JeZHnt/qu4FkIOiqMn0sF+Ra3jX+07LhlJIQYNlU0DXXyOBICVfmajlpKsURX8JmIci2iQbZUnIKWvZ4hMetQG0X4RrXEU7ZLH2QnDMK51ScJ/MnLxi+/cUzso7iJkmOXwUGMpuNE0TBsQCbfJJWC4YumqYg+MfXJ8zT0m9+GXuuCU9ge/TPXyn7T3UHbk519gFsUKPf0KcVfdI1I8uecAZ/0vSIiinYANFTITrHkunc1zlBlMhs8ZJjDCK4BXGHwVNtIS6Z2yE1LLwkXwYO5y7qc91bxcbNWBtRqSdtka4F5AuMYlWiqTCnnfOsIGXVqRyiOD9UDAjsZdZHDCqBHgPYPGg0s3JW1U4MmKilQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199021)(6506007)(4326008)(91956017)(478600001)(76116006)(71200400001)(54906003)(2616005)(83380400001)(33656002)(38070700005)(86362001)(36756003)(6512007)(38100700002)(186003)(53546011)(2906002)(6486002)(26005)(8676002)(66946007)(316002)(8936002)(66556008)(44832011)(6916009)(41300700001)(122000001)(66446008)(64756008)(5660300002)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kTNL8U7TO5IlSDOb63+vx7jLkzSoAu/ufeHkF190mBSTHaTgf0iLWR6hOuUZ?=
 =?us-ascii?Q?MqyG0j6sGL79RzqFdb942DaWaEj9E+D/pr0is+JhJpN4H+LVmGDmbqrFW8cQ?=
 =?us-ascii?Q?fra5OhLlwWiVIcArVZVIK4N2IcxyFzvXzz89z9aU6WciUOhfixAoIbMpioNs?=
 =?us-ascii?Q?h6J9ErFmUbo17uH8odt1HQ1f8AdMj3p2SiefxU8/A62GoZ1/9Hea+ApTfZSW?=
 =?us-ascii?Q?hEFM1OfVqJ/+ElTbIc7lOA2TDQzCuy70hyyLjobBdDw2dBt3ptuTIoARsXAg?=
 =?us-ascii?Q?j1bTpDqbaVA+cy9BD/N7blCLuPF5IIvRe8R8TKgnRiu8qqD/BUWYM7j71tNm?=
 =?us-ascii?Q?1qjVW7cn5qEZOe7Psa4LmT+iZhLzqUrpXOW+k5vHsZzYiA/Xc4PZRp9I0IAc?=
 =?us-ascii?Q?DS7kIsj0EzlvMdz9b6tvrI6nmxZW83wJgWzw8aR/ShB0Pv4MauR5KVkxQK6o?=
 =?us-ascii?Q?y+luNbajYyZFnEWvf4a2gkPKX1ijAWPRGWQSKlyjSpT3Rrx/tRloZ3uFRhA8?=
 =?us-ascii?Q?NTpki9MisR4LA1lcNeNB6dNEkKJkafGAqLFKjsctjXADDDu8vbbVcwYGn/zL?=
 =?us-ascii?Q?dOXzXlmvqm90CvJ+Mnw+Pe+XphcPQXYdaVwtIuS8gSFqdpUM+F7Xsz2yTwfQ?=
 =?us-ascii?Q?XwbSZSO5JLaMKQjcIkcNAIRzWZZ805F0OJQo3HVTL17wdO8//DsxZZwq6oA3?=
 =?us-ascii?Q?rBbaHo97e+HGWznBCZZRpm3s4U9rYPH/zMvR+Bu8vL3ap/FDMXMAFDtK4HIG?=
 =?us-ascii?Q?2kNgrKXsO/sIDb7dVX9jHrju6SNcmk2A2F30k3toBmVorXOpIkkywYPYCHpj?=
 =?us-ascii?Q?prTkvWWz1zI/NWSnZZDNdpZ7Z2MoJwEbItd3rRvETNrTJ+E8WC6IQZ97KUsa?=
 =?us-ascii?Q?AjV0CAV+t6lBQqprs7NPP5Xaxx1yCG85BoVoYymz2BRv4MORwglT6q5cZqwX?=
 =?us-ascii?Q?upWyPnYgLtDwSJgQnup5Yfs962tZOT/LHbbwFbRQiTRkhxw+j84xVJxeX+F3?=
 =?us-ascii?Q?I7RZxiUNUmV9FXh93FKxlV98RAUgTgWO0YmAG4hDmEX98uOnTtavoO/O+UW7?=
 =?us-ascii?Q?HUfzj7TvCAecz7Tabc0loGyHEncYtenJLBAPN6D0Jvcp/Yg809uGcJLpt5GF?=
 =?us-ascii?Q?cvLaIG/1uSAfBIPqcjLAyG7CP0X5KAMpgpaDX2aLJlzUKLjxXSf15jlNjqnw?=
 =?us-ascii?Q?q4js/rohauYtCwryUJZCqjsLSRwk6l4Y60O8XH8vmHOJooKevIJKxyTT7FZa?=
 =?us-ascii?Q?yjo/5mELpZV74DqYHB6lFcOU8yB9MqD8L1rjqWwmlwpt4o9rDRtgKR9lJdJq?=
 =?us-ascii?Q?3eN8E7atHWa6Jj4w5Lt4vswB97PI5NWyH4w/zUg69L2lc395kdMQR2+KBdXD?=
 =?us-ascii?Q?75rWDOxrlfy+s0fEmkB8zAHRXttHlkwL3VGvABtAsyzNoT+kIMq2aa6LPsRS?=
 =?us-ascii?Q?zL92HykLr9NotB8GEOmvfDSDokmSOBRk/Ylu1ncdoow4uBzoo/hjgfUoDnOC?=
 =?us-ascii?Q?iew/qbdYbFCwmKB95hHil6VGmKPtJgxwM7qU0j5uJoSmqH7chE/eioDNXcDb?=
 =?us-ascii?Q?Ko+39iOvo/GlWr1kMxQ7G7wj+qgcBs1ghKE50lafVW80hYYGiOsmutEsvBEU?=
 =?us-ascii?Q?z30UDqjSD1anbLwTaw4clt4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <03EF17B34AEEC841B727EAF9CA19127D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ur7xU398+UU4ka6zio2l44fPWz82QF+7YweQSROR+0wDetfaYQZm9n6S1WhvScAV4D1CTmcTJfQnOJpI8IldVRm5vLrMWbDFOh5lR3Q+fSQXK1glV9dO4uNauS0JuEiN4wymOYVug0gUa6+XANszfnWyH3WkAPQBePNOKwsr7K1AUB6vQS9HAEXr+y6MR9xaVg3G6aLojJy10316p4yJr+HCuW58vG1jI/KQna++17zNeYYw8BNF3dgEZJzhly+Em5TKYqvfK99fEH11DF341g7Zbl3nW6QAg4Atxy04oLLbr1J+2f4jlYqCoAO1EMCg/sGUHDWFct58ojWSaA3nxR/G4pjaHtJzrLvlVJf/HldD8WmCJU5vUlGHTyJHA3FPeFKhw/L/eOACU7Fn3XMAyvrzLiNuGlzkE9qGFUiawI2RR9NV9brarJ5Txbn9oK+QO7kunizJxpO6TAYwe+QJVLKdi1pJ9AiF8mz9Tb6hxhwQE4a0apZsPGuNM/WySmLO/Vcq00pDJvWrSPIck0gVEqqYq+EAqMogvEGpWZ46vOM3fS0pMgbVMfodT7f+z2USsFET3/pvi6mj8clFDsZh112jht6AvY4ZbfIfnNo0pj0Tlv+dnKfTDonPyt4KXMcJ+jzFWi/LulncIj1CtYDErd/eLvmiNIsPtsHy+BaO/yuQmJPLnmBkThd+Sc0+y9hvpOadkEgeIar/S22yoKF+U32doddLr6G4cyqx7nceLr9YWQu9hIpmEnm1kPmk1if7oMwR4CesJ+iGNcou30akrAeXxCQLYm9euyvgZsF7oyk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e58deca-e4f8-48ca-dbbf-08db83d288e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 18:54:06.5736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EY3W1JjpHbAi9O3CQFYckWn2ZDzOpvB+aKn3Vs9r1ZXzWUqdrimYZRDfBJTAuK+fVobgzgpd6lttNl37Ks/cdPmx0vSsCVGB8QPyBVqVOQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_07,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307130168
X-Proofpoint-GUID: R5r5Kp96adejdXyNQPsj9HFasmyqIHLc
X-Proofpoint-ORIG-GUID: R5r5Kp96adejdXyNQPsj9HFasmyqIHLc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2023, at 2:05 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Per FW recommendation, 8 TMF's can be outstanding for each
> function. Previously, it allowed 8 per target.
>=20
> Limit TMF to 8 per function.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 6a87679626b5 ("scsi: qla2xxx: Fix task management cmd fail due to =
unavailable resource")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |  9 +++---
> drivers/scsi/qla2xxx/qla_init.c | 55 ++++++++++++++++++++-------------
> drivers/scsi/qla2xxx/qla_os.c   |  2 ++
> 3 files changed, 41 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 95a12b4e0484..03d94e024bdd 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -466,6 +466,7 @@ static inline be_id_t port_id_to_be_id(port_id_t port=
_id)
> }
>=20
> struct tmf_arg {
> + struct list_head tmf_elem;
> struct qla_qpair *qpair;
> struct fc_port *fcport;
> struct scsi_qla_host *vha;
> @@ -2541,7 +2542,6 @@ enum rscn_addr_format {
> typedef struct fc_port {
> struct list_head list;
> struct scsi_qla_host *vha;
> - struct list_head tmf_pending;
>=20
> unsigned int conf_compl_supported:1;
> unsigned int deleted:2;
> @@ -2562,9 +2562,6 @@ typedef struct fc_port {
> unsigned int do_prli_nvme:1;
>=20
> uint8_t nvme_flag;
> - uint8_t active_tmf;
> -#define MAX_ACTIVE_TMF 8
> -
> uint8_t node_name[WWN_SIZE];
> uint8_t port_name[WWN_SIZE];
> port_id_t d_id;
> @@ -4656,6 +4653,8 @@ struct qla_hw_data {
> uint32_t flt_region_aux_img_status_sec;
> };
> uint8_t         active_image;
> + uint8_t active_tmf;
> +#define MAX_ACTIVE_TMF 8
>=20
> /* Needed for BEACON */
> uint16_t        beacon_blink_led;
> @@ -4670,6 +4669,8 @@ struct qla_hw_data {
>=20
> struct qla_msix_entry *msix_entries;
>=20
> + struct list_head tmf_pending;
> + struct list_head tmf_active;
> struct list_head        vp_list;        /* list of VP */
> unsigned long   vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) /
> sizeof(unsigned long)];
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 60dd0e415351..5ec6f01ca635 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2192,30 +2192,42 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
> return rval;
> }
>=20
> -static void qla_put_tmf(fc_port_t *fcport)
> +static void qla_put_tmf(struct tmf_arg *arg)
> {
> - struct scsi_qla_host *vha =3D fcport->vha;
> + struct scsi_qla_host *vha =3D arg->vha;
> struct qla_hw_data *ha =3D vha->hw;
> unsigned long flags;
>=20
> spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> - fcport->active_tmf--;
> + ha->active_tmf--;
> + list_del(&arg->tmf_elem);
> spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> }
>=20
> static
> -int qla_get_tmf(fc_port_t *fcport)
> +int qla_get_tmf(struct tmf_arg *arg)
> {
> - struct scsi_qla_host *vha =3D fcport->vha;
> + struct scsi_qla_host *vha =3D arg->vha;
> struct qla_hw_data *ha =3D vha->hw;
> unsigned long flags;
> + fc_port_t *fcport =3D arg->fcport;
> int rc =3D 0;
> - LIST_HEAD(tmf_elem);
> + struct tmf_arg *t;
>=20
> spin_lock_irqsave(&ha->tgt.sess_lock, flags);
> - list_add_tail(&tmf_elem, &fcport->tmf_pending);
> + list_for_each_entry(t, &ha->tmf_active, tmf_elem) {
> + if (t->fcport =3D=3D arg->fcport && t->lun =3D=3D arg->lun) {
> + /* reject duplicate TMF */
> + ql_log(ql_log_warn, vha, 0x802c,
> +       "found duplicate TMF.  Nexus=3D%ld:%06x:%llu.\n",
> +       vha->host_no, fcport->d_id.b24, arg->lun);
> + spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
> + return -EINVAL;
> + }
> + }
>=20
> - while (fcport->active_tmf >=3D MAX_ACTIVE_TMF) {
> + list_add_tail(&arg->tmf_elem, &ha->tmf_pending);
> + while (ha->active_tmf >=3D MAX_ACTIVE_TMF) {
> spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
>=20
> msleep(1);
> @@ -2227,15 +2239,17 @@ int qla_get_tmf(fc_port_t *fcport)
> rc =3D EIO;
> break;
> }
> - if (fcport->active_tmf < MAX_ACTIVE_TMF &&
> -    list_is_first(&tmf_elem, &fcport->tmf_pending))
> + if (ha->active_tmf < MAX_ACTIVE_TMF &&
> +    list_is_first(&arg->tmf_elem, &ha->tmf_pending))
> break;
> }
>=20
> - list_del(&tmf_elem);
> + list_del(&arg->tmf_elem);
>=20
> - if (!rc)
> - fcport->active_tmf++;
> + if (!rc) {
> + ha->active_tmf++;
> + list_add_tail(&arg->tmf_elem, &ha->tmf_active);
> + }
>=20
> spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
>=20
> @@ -2257,15 +2271,18 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t =
flags, uint64_t lun,
> a.vha =3D fcport->vha;
> a.fcport =3D fcport;
> a.lun =3D lun;
> + a.flags =3D flags;
> + INIT_LIST_HEAD(&a.tmf_elem);
> +
> if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET|TCF_CLEAR_TASK_SET|TCF_CLEA=
R_ACA)) {
> a.modifier =3D MK_SYNC_ID_LUN;
> -
> - if (qla_get_tmf(fcport))
> - return QLA_FUNCTION_FAILED;
> } else {
> a.modifier =3D MK_SYNC_ID;
> }
>=20
> + if (qla_get_tmf(&a))
> + return QLA_FUNCTION_FAILED;
> +
> if (vha->hw->mqenable) {
> for (i =3D 0; i < vha->hw->num_qpairs; i++) {
> qpair =3D vha->hw->queue_pair_map[i];
> @@ -2291,13 +2308,10 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t =
flags, uint64_t lun,
> goto bailout;
>=20
> a.qpair =3D vha->hw->base_qpair;
> - a.flags =3D flags;
> rval =3D __qla2x00_async_tm_cmd(&a);
>=20
> bailout:
> - if (a.modifier =3D=3D MK_SYNC_ID_LUN)
> - qla_put_tmf(fcport);
> -
> + qla_put_tmf(&a);
> return rval;
> }
>=20
> @@ -5526,7 +5540,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t fl=
ags)
> INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
> INIT_LIST_HEAD(&fcport->gnl_entry);
> INIT_LIST_HEAD(&fcport->list);
> - INIT_LIST_HEAD(&fcport->tmf_pending);
>=20
> INIT_LIST_HEAD(&fcport->sess_cmd_list);
> spin_lock_init(&fcport->sess_cmd_lock);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 877e4f446709..47bbc8b321f8 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3009,6 +3009,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
> atomic_set(&ha->num_pend_mbx_stage3, 0);
> atomic_set(&ha->zio_threshold, DEFAULT_ZIO_THRESHOLD);
> ha->last_zio_threshold =3D DEFAULT_ZIO_THRESHOLD;
> + INIT_LIST_HEAD(&ha->tmf_pending);
> + INIT_LIST_HEAD(&ha->tmf_active);
>=20
> /* Assign ISP specific operations. */
> if (IS_QLA2100(ha)) {
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

