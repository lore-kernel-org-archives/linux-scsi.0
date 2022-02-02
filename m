Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE58C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Feb 2022 17:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346326AbiBBRmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Feb 2022 12:42:36 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:58876 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346336AbiBBRme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2022 12:42:34 -0500
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 212HU3ux029312;
        Wed, 2 Feb 2022 17:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pps0720; bh=iumQa+m1V6HV+RTcGpb6HZfzkOUtowUfO3VbY8jBC1U=;
 b=cPtVFv2AhfzOpca+dEeTbWWPvD38Zh3c8cNfC9uvrNlHVZx8CxECW/F/luNQHerZvar6
 ZPzDSDcFmw8UQKw7MB+5rbMpBEBYfDgV0IKn0Y/IAldM4FA/ufXl4T9747FpGNSBs8CR
 2ka9MEdo0W1O7tflhvzDORuPgEnr5coD4UAmJZ3NQPWe4CkvYucRPSgt1EMcoEgcGr09
 SWrbYGk0Q1m0IDRleCQq7qd2Omm2+j253YuPDZJwcj/HPBf8HP1/mYKG2aAATfcMVneZ
 5uVA850ltTAFoBDjJY8zVSNNwfHateg6ZTMhAqYrNijbKWXLNFxwZaGyYgR29AeC3H7W fA== 
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3dyxd283ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Feb 2022 17:42:29 +0000
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com [16.193.72.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2352.austin.hpe.com (Postfix) with ESMTPS id 5D68E62;
        Wed,  2 Feb 2022 17:42:28 +0000 (UTC)
Received: from G9W8673.americas.hpqcorp.net (16.220.49.32) by
 G1W8106.americas.hpqcorp.net (16.193.72.61) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 2 Feb 2022 17:42:28 +0000
Received: from G1W8106.americas.hpqcorp.net (16.193.72.61) by
 G9W8673.americas.hpqcorp.net (16.220.49.32) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 2 Feb 2022 17:42:27 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (15.241.52.13) by
 G1W8106.americas.hpqcorp.net (16.193.72.61) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Wed, 2 Feb 2022 17:42:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpI9ZsS87CwCjHULC39ygz1A8JdOLwv5Wj/FuUrJHumZZnhVAbjMtQkGx3dksDYRFCqq4qQVE+ngTEacEsyZeLznjq4SF5aud/dM/PycIrgEbmxMx7XuVZryEm2NOxwybs25eHVYxJLbiiFX7L5f53ykLWpde1ZOs+PB8it6ZesaAFYeBIYimXavsf/eU2EJw+VJZL6aAEtVwggMhC35n6G2KhAXsZYrs+dM38IJ0zd9g62GSrjTe08Y0WooiLZb0mV6ALvlsdxtQiOqepq2oUUSY9EakFI8vEsMduuLnG9l5p05Oj88liXdVGIF/64e7XNblqgMDCjl7wPxX9E8lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iumQa+m1V6HV+RTcGpb6HZfzkOUtowUfO3VbY8jBC1U=;
 b=F1BpZvQxS0h6jYaWSCUe0mwaHvezRnUWPf/bcGFhyak6sVy44uqriMilkXs6oDwG9gUUWO1LLuyLgnomO+dEejecvGaW5zoukw9vjq7VIQNifEVYFKiWVu96Q22wl4KWY4t+LEE2qfnGwUzYylxvYjgg/CipjxR7cVv/At9s/baqp71bpfT4MBs1w3cDijGqj5gGFDYoSsIgWM4iTJQvGNt8pEdUkMcdd5ZBhruN8zXSwXVWlKwZ3WgCNhqeY3UcTC0sf224R+SlciAD1knhYruwyQ5YSmXwu4NwsA4arSw9EXY5PaQ8wG+qGkMXFJBZ+0Lk/F6hyRytuJRrkOEWJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:434::21)
 by PH0PR84MB2025.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:160::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 17:42:26 +0000
Received: from SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f8ec:1dee:fed5:f051]) by SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f8ec:1dee:fed5:f051%5]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 17:42:26 +0000
From:   "Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
Thread-Topic: Re: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AdgYRSLrdSj9Mg8MRSetEzqZiA4+tQ==
Date:   Wed, 2 Feb 2022 17:42:26 +0000
Message-ID: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25b00c06-3f11-46d2-5e9a-08d9e6736086
x-ms-traffictypediagnostic: PH0PR84MB2025:EE_
x-microsoft-antispam-prvs: <PH0PR84MB2025C0FDD3A6C6493BCDB55FC2279@PH0PR84MB2025.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tbQtzm5EP/HYfs6Im6iGi5DheDECwmc6t1l6/w30YKS71FX9o0k8AmgDuR9QgJvA2fXNP7cY3HlgUfbJ+IeRVH0N6W0NbY1hIAb7jggVFdyEXITYNKfZXj7OQYVezez0HYFZkSPa1U6dniwW6syymR3gA39vnUjQIeD4kVWaCUmIcb7qyuf7gsaBbbRYmCI/kjtp8A3f2qMbmD3GANNCxPoGca98dJjZJ4+efK3FbMXLQvzQgcWU6DD3ZtZjqR5wHLEg8BH/YWjZQHwqIV8bzHOPC9/3UL8mRXOQHIBZs8BQpTseUaXdSjk1VUwHoaa3W5LkGkmC55OUr3SP2movwMo400Qt8svMfP+rN8IxD3O7GNbEzE/MCtMdIENAW0m9HUm3IJkfanhkNYiF6WY1xPGcKR5BHF4qAKJUtthIHzE3NzdqgGaW8iFJ+iYM43WRV1iLUgmOUDJZ8hf68cw6Og90uwxC2SgaHWk3r3hw43PsW6o/2QK+TWUjHIIU31wsVl2SWK2sPwaA7zLb7qiBaV2+49VkYDZAWBJ+WBk3iurW551OGqVsTqaHB/OaytK9vHBSKPNtZ9WNm68xpEJh+6aGYw1R8dlJYDwglCWCf+TaXqv0GC11P51hw7AF1yoDaWrgtgU32JT0lgHBxec5vPawg4fDk4ovOpjpEv6zMGkwN0wu4vvrZbtbH9AtT93QdF8IsPYCcg4lADW7SSi9Gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(55016003)(26005)(53546011)(33656002)(7696005)(71200400001)(2906002)(122000001)(54906003)(6916009)(52536014)(4326008)(38070700005)(8936002)(82960400001)(8676002)(38100700002)(83380400001)(316002)(86362001)(5660300002)(66476007)(9686003)(508600001)(66556008)(66446008)(66946007)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fU9aZHSabrU+5LTgu76hdrYCnvkDJEZQg0mGsSydY4Ld6aUXFOjkRHdgsixv?=
 =?us-ascii?Q?t7ZchOiu46pd7fScPiyr2UsG/yjXHxxYB8p2YSO221Wy/23ZhlOkvesarA72?=
 =?us-ascii?Q?jR1bOPBxsRkqAiWYxKRIxqwpEi+YHua2W1XUqdSMI7JALWlpL0jTpBUiik2F?=
 =?us-ascii?Q?KZ0bIc8/zrmeYTm0CxDnsBqnUOcimlqtn0oRGKE6pqHW2kF7mlswamLl8EyS?=
 =?us-ascii?Q?rkLXRi+4kt1ZQVbsmZ2lRwJ1JqqqUzcN0RzMNNazb2cBIeKfdjPhGpKvs5sY?=
 =?us-ascii?Q?NdQf/0MpGuOrwJ54eOumF1TqsiGyEGOaV1yvafIaVNSrRbwgl0e+Ot1Ho85r?=
 =?us-ascii?Q?NbGibWRHiqtMVG+i2o0gYtbMyIWujNvQUDfRakl2keEySu7Bz7H5EBl5Fr2B?=
 =?us-ascii?Q?J2W5sPAZmaZsRhOHRUati5HH6R4L7JhVEEfdADy6FY7a0Te+D3r1lwvp3u/d?=
 =?us-ascii?Q?LHkFfbaJa8GtKf0zlwMyrIJhppW0j9lb/NV20QU3TUIl3PEtt6q+BQpyXNsS?=
 =?us-ascii?Q?itXYLQi22awtOJWcao1e+T39MX1UX34cDily9olLHonlc+BN9Tu5rgGMOaiI?=
 =?us-ascii?Q?E8ncUNFATt60b9BqiJfFxBR8RnNVHpj8lJ/xgf7RzSGwWRBFj9h4GSJR+cZQ?=
 =?us-ascii?Q?KbB3xU6yNFgg/3EKoqhM0msR5ZlUmVTCzL977g9iGneRr/HjSVOfijTnEDtJ?=
 =?us-ascii?Q?Q07X/Fv+rkCJIEIfpM+FvWNzLDX7mC0VRPy43wepLqiCfLQuqXH/YJw8JYNE?=
 =?us-ascii?Q?ttc0GWyv1MFDB/Wu1H+7+IRf6VxiEDhiyUyx5ZoLq9qHHIgPPccZzeMBVqci?=
 =?us-ascii?Q?vA7Bh+8wXnbZMCHWwftiSNf+UrRq/Lew2LoVVhi29e7EtrMBC+NBstEEHUQg?=
 =?us-ascii?Q?+QYi3T+zszpPxWjMOhmV4vnDwIpq5XveeGKyTSFctzEDM/o5bi0j8I+rXZgQ?=
 =?us-ascii?Q?1cdikFR866Lsi6aexv19PYoEDjJrJYIN3TIpULlNusQEu55GmlxasguaF1Cu?=
 =?us-ascii?Q?rXMr8Z9vdZEUk8OdFU+/9yj6UgRrumi2ZmQZXNDkMZziIAIT/129WmUg4j+a?=
 =?us-ascii?Q?eUy09NYHhFP6eH9qBBrFKDuDu1a7r8yhdmstXI5MA+GBKe4tQ3zf7OcMUL0o?=
 =?us-ascii?Q?lWzAWd7eONAl74jTtEDeUlgBYfcPobfsXtxL4f8WA26mcjEI22f/wBK7Bpw+?=
 =?us-ascii?Q?Js9x2V7oi8+3OL7/B/QrprVt+dIzj1s+6c837lwVy4LEnFgSBOsVJXOM0zK8?=
 =?us-ascii?Q?jSZ/bRp39lftNd+lW+NVCQuxTvRgH2VGgia2LZmCDMF//jzVvhCBu5IcFtb7?=
 =?us-ascii?Q?F2glj9AmIaTrI787LZQ6abmM1gvF+M31Ktt8JVSuAH7e4rAz+3mnxM2pJXV5?=
 =?us-ascii?Q?NcLEH3xlM9zL6iglhpYK+Tp971RObuyjvz+MV8RKK5ZlPoGe1yDOmjsNIc0c?=
 =?us-ascii?Q?AER9x6yHzhE763alsoyUDDxWjfbkcN2/iI935aW9TwrdOceVA5cPQgf+tHxb?=
 =?us-ascii?Q?sw/AjNf5Jb3lw/1TZp/Q21eFRfsQd2/5ana47GOiFl4S5qYkgoHmlpA2m2Ga?=
 =?us-ascii?Q?gcKDfpXhYIKlR7k9ZzU9bWX6h1Bdv1d9bFTPN9BJEu/GArK7IMeJXstqG/Lj?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b00c06-3f11-46d2-5e9a-08d9e6736086
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 17:42:26.2807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FKRK6uYewAdYEVfqBZHZ9zNT9e55FkCVMHU/tlvpltMmFB8NJZ8wkEjI27DQo2PVrBPdz4kbDy5iMIb305p2qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB2025
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: Tfny0x8Ur5OlK1lSA_59S6tzRbrkjEn0
X-Proofpoint-ORIG-GUID: Tfny0x8Ur5OlK1lSA_59S6tzRbrkjEn0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-02_08,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxlogscore=924 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202020098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/01/2022, 12:25 +0000, "Martin K. Petersen" <martin.petersen@xxxxxxxxx=
x> wrote:

> Can you please try the following patch?
>=20
> Martin K. Petersen	Oracle Linux Engineering
>=20
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index c0eb901315f9..fa5bc5b13c6a 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -387,7 +387,7 @@ void bio_integrity_advance(struct bio *bio, unsigned =
int bytes_done)
> 	struct blk_integrity *bi =3D blk_get_integrity(bio->bi_disk);
> 	unsigned bytes =3D bio_integrity_bytes(bi, bytes_done >> 9);
>=20
> -	bip->bip_iter.bi_sector +=3D bytes_done >> 9;
> +	bip->bip_iter.bi_sector +=3D bio_integrity_intervals(bi, bytes_done >> =
9);
> 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
> }

I encountered the same issue as Alexey did when writing to DPS Type 2 forma=
tted, 8 bytes metadata NVME device(s) from a stacked driver if bio was spli=
t in md layer.
Virtual ref_tags were improperly converted to ref_tags by the block integri=
ty prepare_fn().
The Martin's patch has resolved this issue.

Martin, could you please advance with this patch?

My only concern is dm_crypt target which operates on bip_iter directly with=
 the code copy-pasted from bio_integrity_advance:

static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *=
bio)
{
	struct bio_integrity_payload *bip;
	unsigned int tag_len;
	int ret;

	if (!bio_sectors(bio) || !io->cc->on_disk_tag_size)
		return 0;

	bip =3D bio_integrity_alloc(bio, GFP_NOIO, 1);
	if (IS_ERR(bip))
		return PTR_ERR(bip);

	tag_len =3D io->cc->on_disk_tag_size * (bio_sectors(bio) >> io->cc->sector=
_shift);

	bip->bip_iter.bi_size =3D tag_len;
	bip->bip_iter.bi_sector =3D io->cc->start + io->sector;
               ^^^

	ret =3D bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
				     tag_len, offset_in_page(io->integrity_metadata));
...
}
Not sure if there is another place in drivers where bip iterator is advance=
d explicitly, i.e. without calling bio_integrity_advance/bio_advance.

--
Dmitry Ivanov
Hewlett Packard Enterprise - HPC AI Labs
