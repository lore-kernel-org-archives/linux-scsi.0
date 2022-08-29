Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2D2ECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiH2QKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiH2QKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:10:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4273B1EACC
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:10:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TE21i7027718;
        Mon, 29 Aug 2022 16:10:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=hHdszUGEmwkM/KFUJrufabx3Q3VIxdjaClnkq56+t60=;
 b=iFCUXuNetFJUvyNIxLDsk6l+sU9ibXJmZmUhRLPOmxflL/tTVUSH7k4u7scyZxyrHFa3
 9O9QWAj7fm7phzf0fDcjHIwmyaFkhiCWkEuzKgmN3fsnAus9LhTblGCwk++9ISNDprY5
 vTr33McUaDcgK8FuGytwwmKw4JNc6XndrGdu7G5HklP6P+gdg/kT3DkUmsaPwhFxA0+Q
 YKwzkqR70DnFAPch2/nzK2lG2SizXralv8WC+sgVrPR7IuqjQSilztHVDNQOJ1DKyp0i
 wFAOj3AlmUXEHuJDuBhP+JbkmfGalN2gzX9NQ2NA8TU+013hi4aVnwlITMnSxunsz3PK KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b59usv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:10:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TElXAQ002937;
        Mon, 29 Aug 2022 16:10:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2uas4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 16:10:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gM62BrkeZHs2cGzXIvqjR3RGO8RaCGajeoGiQcLDOJp+uEqAvctKSPXxs1sxNwCeaSf2ZKPHZaRoYkWrw3pD2V5vrlc2M8S3FP0B+Fnhis8EQcLgoGI1H35QhJgGvXkM0WGc0qMNrU9y2S6nX7fjgGiBL0hEJFgvUB5cp52iKdnqQ8SbC4ywRZa62RAQeFuxGZHiK6CsPg0NXEY3XpXN8dr0GuyOiMa+16hePlimjLlsqRXH/gpW1E5OBCBVtmhf8TFmcann7P+J/W+gia9T/CB220UQntzI2/4yKBoxXWoIZ9KhFCjMC4bRUuQF/kCwQ+M6zmuT1elnmFxsOvJXHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHdszUGEmwkM/KFUJrufabx3Q3VIxdjaClnkq56+t60=;
 b=nVhUdHcNLzQXQJSxJHu0IHz7+i+4KZDGNqOyu7D/1ECFsX3V/4jnX9tKuXHwXVEM0ulio2EoG0jElZzlXlINySOP7h+XeDPpy8r/FAToR3r9wuXfWQXyz9EDETZ34MsYJk0TttT4+j/8r+fC46XbOooVTxNSA7bkaoenM0Ge60kfLyos+aCum1yAVsWAOlhkFunZA9AA7GfRUPhMnPjkbDZJtufMdNlfTN24m/d0m+nFzcC4476vOMf86C5ciX8WwWW20L8Gp0nE1cOfrF9oP1GelxbOjSkaIYVeg6ufY3cL4qhpct7vCIoHlFe4Q4TbL7xU8Lq5xDUvk+IArJLBTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHdszUGEmwkM/KFUJrufabx3Q3VIxdjaClnkq56+t60=;
 b=ehBaXfAPkfcbwvTEQjgLj9ndYwoFZucGE1Dbm9hjbSv3qMb0px04ki28l/eJCoOYMWZOoc4KzWzSUugSX874qSqXaCGLfjRF3BdE0u+5ZWJCTgMv1mXZS4V12eiOXrkMi58svBFCXGjUtNlCixKdVKGoUJmxQlnDbqpwUtDvYPs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5255.namprd10.prod.outlook.com (2603:10b6:408:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 16:10:23 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 16:10:22 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 2/7] qla2xxx: Fix response queue handler reading stale
 packets
Thread-Topic: [PATCH v2 2/7] qla2xxx: Fix response queue handler reading stale
 packets
Thread-Index: AQHYuTZSM2A66is3p0W/leW3UH40Xq3GEUCA
Date:   Mon, 29 Aug 2022 16:10:22 +0000
Message-ID: <F97B836D-9F7F-454A-9388-8CC602145888@oracle.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-3-njavali@marvell.com>
In-Reply-To: <20220826102559.17474-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d81476e6-c9aa-41af-757b-08da89d8f9aa
x-ms-traffictypediagnostic: BN0PR10MB5255:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GLRUHHCdzqO5ylhHOlRg0vlImusPCs6zV9fGzXTh2ymhCmf/muYtz3mQtr80HOjSJttdnbwSEHP87FywCOP6dV7qI/IAqcOM4VuV28p9wsPy12AHMXJVTHnLAuNuJV1vUWj/AA4gDqyj52rXmIClkS2Mp3NsjzQUhqaECSDBFHCgPe9rBOX63tjNNbCXaHxPoZjt9TOSYjm+y2jLYnTHmlcZtKloZNJMN2u+kNjSH82JqLXdswnkD2KgdYz1p11FCSu4u3lK5XTnVKPefrLe3q2pz6rZfPcYeWmea1+zQe6dPAZigIPvAMEIAXQei0CLeuxdjz3tde2J5BdqT55wNvQcDmIoDv7e1EuJ66slJR3b5IqtbMKtRrdnbXGBUYLc6RhqR6u2jXKvvFTBDIN79THLNoNe6EQ2XQBbWk9LmGi4nu2xqXm3FNc8eLgQehX75X5JwnogOfz74d0pU7aYcy+CbPtVekBLnNreMZ3FulokSpyLqxpzv4PAl4OWNX9OnNllICBZy42+33eceMiCL6SGQqKZYpTX6uYILIibAlj6fAploGFhcbXP3TmwBio91W4XGkK3hOg9mha2Nat8LyOfTL3AnEiUhrFLDwiotFIvKK43cy3dgiVtDIPJLCeL42OD4D52wmlSdF8xu9VxMyIE/GEhuzRfk/URhOT+CpVm3AdTCvSi2paSExAj5ElBJz5UfNNG1WgyVeRN4kVxUBh8uEWCafUOZ9UqaGYuTFF2KN/4gGs8/Ad36fH4MQhrGRCgZCkUxwqqWjFt4aL5W10s+s5DG8TjRSrj8ztsjfs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(136003)(39860400002)(376002)(2906002)(6512007)(38100700002)(26005)(44832011)(122000001)(53546011)(6506007)(2616005)(33656002)(186003)(83380400001)(6916009)(71200400001)(8676002)(66946007)(54906003)(4326008)(66446008)(66476007)(66556008)(64756008)(6486002)(76116006)(91956017)(316002)(38070700005)(41300700001)(36756003)(8936002)(5660300002)(86362001)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gQHb81plTe1GE3+crqFjcPvizj+UlVpJIna0v7ZDUSljDzmgZpmaJutI5E0r?=
 =?us-ascii?Q?SFNyi2RwJdi/MB0Zq+nosKkWLK5MkalhGQDqu8YNTkbWFRtvAcw6uAUCfNK8?=
 =?us-ascii?Q?j3oqvVLxEoRuJxV/ESmJKi2qLpKMuYgzZ6qapBYFqOkvvee4lPReIMcxVWQY?=
 =?us-ascii?Q?EsMmvyT0hMu/Zziqn4c8m7zFx0bmHtoHnF5JmF54AVd0PprT/EL5sxq4YMI2?=
 =?us-ascii?Q?fj/bPjbU1/160uimR5gOsBTWJfkvvorzf1hj/Aar9M/jfxS+497/IW+pJT/p?=
 =?us-ascii?Q?GxSZssnL94Pc/SbOCwb+XhFeJUyvkgHrq9SLCBOMsIi3ttbpl9S07OEXe7Uv?=
 =?us-ascii?Q?Bqs8IqAsSADZqc1fKPP43dYvAUUKVTakkyq1KOHFRI67BoF6MPbA6jerSdjo?=
 =?us-ascii?Q?3M0oT8/Xt9kdCF5yIHZpapFhLhZvot46l1URmZiZEogt/kiKSDGmyQ6Rs7Kq?=
 =?us-ascii?Q?vjfYranAIYs7T66ldUZwFtMHOeEUtgd/HPvfK4JGd/rOK/kN6f5U/bWh3jL+?=
 =?us-ascii?Q?tisXdciK7ORLJ4f4uoSork7NZlNOxKv9F64BDssvBkYIK1UG28H47rFYMCmu?=
 =?us-ascii?Q?2v142Z2yoPeY5S8+IX0Wf9mMSMyla1sPMx7PB/4PpMQSK3MCX7tdm6hx9bBA?=
 =?us-ascii?Q?ZNc8TBd1LFQB6mhAmK5LTIhNavxZENfjbcg26KGegEfZGDtMFCKkQyRWFpwT?=
 =?us-ascii?Q?vTTwLh/kCBm85motYw7zOO8tDDbxfMrJm1sPwzcSKexK556BvfUdz1TjbnVc?=
 =?us-ascii?Q?453ffzNElAbw0NCTnPOo0iEfKNymPiGAbkHGL0IgQsmPIhUF06iE7G+edzf7?=
 =?us-ascii?Q?AaIc32e2kjnujXe2HIBJ5OLOYowZ0GJn2GDrBU/XNFSRNUJiPNQTcARup1fC?=
 =?us-ascii?Q?Rde8D4zj0Gps5WTRM876g+YmDuhI1wl+liS3/P35MiO1J6rrNtCE8u2cG0ek?=
 =?us-ascii?Q?AMTxbTATgN9gVGLfwXrTKe5fB+soWfiDjrMw8k11MLcWoQLJu9rrNgxRVrnQ?=
 =?us-ascii?Q?RtpUrZsHsBbZ3E+0gNj0pwa6y2GH6aDobJwQwmpXJIVEsai/ijwlF47BHYqX?=
 =?us-ascii?Q?pxHlf0SxsXil0G5IcDAxpmmvLgad0CNFN0Bjk3Dxwc5mP0IHYnydRJOgD1YQ?=
 =?us-ascii?Q?dG1hSYm8bMlpx3CtjPfXJpzPBisKp7CifXWt8vFz9DQW7dbXLpyRyo2RIzl9?=
 =?us-ascii?Q?a8g22d/9GBVJIRPD2mM0qDxl2k3qHLMyCSef3U7jAoypmL69Vl/a7EmgrS4s?=
 =?us-ascii?Q?wdB/fl0KCkTuVkdJHqSYOcIQw1oMasbZslCM378npTPtjHBLjkjq/NkgRJp5?=
 =?us-ascii?Q?2mBezvEIE51QmQjK5Z5mvUrFR7OjEddNFnZ5I5bhoO4VFQMc8XCv56ApzNhC?=
 =?us-ascii?Q?FLkMfuJL8i2TK9t+IzmM+Xwd6QykZ+K7NYljXELTOkFbYMvJttQFGbTjJFzT?=
 =?us-ascii?Q?F9R6Hn0NH4m6B7ljre0Kj7WzqvEgFh+RTDj3uCDUXVhdVSGkltLwyK36j1DB?=
 =?us-ascii?Q?BU1ygKR3SFgBkqy7bjNnwcZ37VGMYNlZruvRo0pzTyZiMKLavhvpj2t7aLGE?=
 =?us-ascii?Q?nbR8afaMHWVj41XuGOMTuvYfRZSAR69CnWy+AJ+86D8xnDlQ4tWZQWZPDLuV?=
 =?us-ascii?Q?jA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <850A2469E782B3418D7CBA24B9311829@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d81476e6-c9aa-41af-757b-08da89d8f9aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 16:10:22.0673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NGSUdJaok7zRy9hm9fkCsJLs8KCdQfz0ANvi85B1yKifB95PqwEWaNxaLXC4zg+pnFFzj3iCDp/0yjSlbcjs2s8ZloF+uCr79UQJsQNY0eQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290075
X-Proofpoint-ORIG-GUID: 8cHngYyPLvg9oajdVpTai7tp4QEhWgyy
X-Proofpoint-GUID: 8cHngYyPLvg9oajdVpTai7tp4QEhWgyy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> On some platforms, the current logic of relying on finding new packet
> solely based on signature pattern can lead to driver reading stale
> packets. Though this is a bug in those platforms, reduce such exposures b=
y
> limiting reading packets until the IN pointer.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 17 +++++++++++++++--
> 1 file changed, 15 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index ede76357ccb6..e19fde304e5c 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3763,7 +3763,8 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
> 	struct qla_hw_data *ha =3D vha->hw;
> 	struct purex_entry_24xx *purex_entry;
> 	struct purex_item *pure_item;
> -	u16 cur_ring_index;
> +	u16 rsp_in =3D 0, cur_ring_index;
> +	int is_shadow_hba;
>=20
> 	if (!ha->flags.fw_started)
> 		return;
> @@ -3773,7 +3774,18 @@ void qla24xx_process_response_queue(struct scsi_ql=
a_host *vha,
> 		qla_cpu_update(rsp->qpair, smp_processor_id());
> 	}
>=20
> -	while (rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {
> +#define __update_rsp_in(_is_shadow_hba, _rsp, _rsp_in)			\
> +	do {								\
> +		_rsp_in =3D _is_shadow_hba ? *(_rsp)->in_ptr :		\
> +				rd_reg_dword_relaxed((_rsp)->rsp_q_in);	\
> +	} while (0)
> +
> +	is_shadow_hba =3D IS_SHADOW_REG_CAPABLE(ha);
> +
> +	__update_rsp_in(is_shadow_hba, rsp, rsp_in);
> +
> +	while (rsp->ring_index !=3D rsp_in &&
> +		       rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {
> 		pkt =3D (struct sts_entry_24xx *)rsp->ring_ptr;
> 		cur_ring_index =3D rsp->ring_index;
>=20
> @@ -3887,6 +3899,7 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
> 				}
> 				pure_item =3D qla27xx_copy_fpin_pkt(vha,
> 							  (void **)&pkt, &rsp);
> +				__update_rsp_in(is_shadow_hba, rsp, rsp_in);
> 				if (!pure_item)
> 					break;
> 				qla24xx_queue_purex_item(vha, pure_item,
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

