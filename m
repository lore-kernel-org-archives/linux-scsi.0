Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5699C07E9A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 07:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA5FC613DD
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 07:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhGEHGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 03:06:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41308 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEHGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 03:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625468604; x=1657004604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vtIgRWcgl/2AVC7Z0vIH1aNSe+wYawbb4sB63RKbIH0=;
  b=f/Lez4ewA1BKASwNWF9yU7I4SCZKjFC1Yhl+tlPqEl4QLWbZLMlU1e2z
   N11g+6f0U8IW/Rs8zhQBGdRPqI1lV2rwAVAjMoNNmZysaEBLphtPQ/oBf
   0vF2gBvBZrUC4SSNhXWXlVEDLxbeQ6pVvKIqeRcfgr2K5n14qSdbooLG0
   Y6GDqbrnarqR476U/73OXUlx8cs5MeePLdYbiCU5V9ICFklfEQCHqJ/Q7
   i9skJOeKlc4pi7gvBKgcEUCE/dc8TQUR7I64CYM92jw8VyqXDBPqfHVnP
   P//Pj7sxGZzaIg7L0ZmFj8y9ct9vjUhVMaqxtUx6z1pyqycso6rVWrUjw
   w==;
IronPort-SDR: 6GMsyygqFLjaK0jyoO/3o2tucsql4z17Ip+mlc1SzwMwntFYeYjkcVoV6vxhZuPmXktHPLq5lQ
 sOEyaGCKNM/DYwchllrA2Id/AQXVm5CF4G5W9LRP9+oUfD5+uQdtr5Pyfr3Ajz1FYdZ4E8InOl
 kD53O5kCBn/bQgrpai1MIr3YnCDIUknf5f1EVAYwwzlAXrPLSCPTLRSWOcWiunt+maGvXNrlNC
 eNCRQEZrYuylVHmHHI4pGXqjBnGyUthFMvdAlLiG4x9Osu+i2aTSJpg5YU69YmT9sX587/IKWq
 2gw=
X-IronPort-AV: E=Sophos;i="5.83,325,1616428800"; 
   d="scan'208";a="172955133"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2021 15:03:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgsIXF7nHnAlO/GbpRzGGnvw++NBWh96vYm3n4yYHYg4oTT/w/PCrNvqqszH5L3G7ReI2Sbwf9wQjdIOqrNi8c8QHgMDPBBZHFTaP1pWupJNwV6E3O6wFco+53AeHX6Vl63/uk/kpvXdBLlhbpmjM2Gyg75gTcnteQOfKOeecJggw4l9U2LL/I6kLD5Q68/rWGWEn3iDQxXzpb4uAONYvhDZS9+rqUHNXUGnN+keXYm8AGMku278WBoCJ8Gsj3rhl/DrkWD82dhSCzEcniQ/Qz45IHRo2qdYqbcVMAk8WEnHhd9bhfLpp4K8Dgb/tOnS2LvPOH6ixGKqunL00h0v7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtIgRWcgl/2AVC7Z0vIH1aNSe+wYawbb4sB63RKbIH0=;
 b=I3wvnRXwW07jfgz2xp3/4GBnhxLWyB0tp6irhW6cwpL1Dmiu5h7OfdVmxjmXcBVRht0JHDGo9+Geux/TdGHhEZFTAVEULBdEXbxTDZQUmPN68vRYCanXxdB9P8f8Xb9U99pqInUsogI9V2ov3XdUtzPSYw3tBDJLJD7KVKkBeKdkVEfGk8Z8Ty/aflduyOWs7bv/LsuAa0f3luVIlGtImMvlZyCaGu+Dwv6+wkqvBpdTNHoFJB3E6QE4reCABwK6g+6Vg2jjnbTMG3EEkStPtMa/5SbdQtiboGmxkz4xeXm7zWiDttE3SnLiV+S8iQpj+DUKtxarqV1jYJStz93uzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtIgRWcgl/2AVC7Z0vIH1aNSe+wYawbb4sB63RKbIH0=;
 b=up+BM78rkJ+PXEo2kCVQo67V0uxw4Hhh0QZwn3S+O6J5krmZGBMCpG6an3vZGA+OGp+5UYG1QcuiD98Db3TExDoKPGmJljEy3qogxPFFLx4bGLbllYY1l6RLAPUoYv4JDlrLFqZwi5iEklPMnPfhJG69Zcc+RJ+bqagkjrGLfZs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5353.namprd04.prod.outlook.com (2603:10b6:5:109::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Mon, 5 Jul 2021 07:03:20 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 07:03:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH 14/21] ufs: Inline ufshcd_outstanding_req_clear()
Thread-Topic: [PATCH 14/21] ufs: Inline ufshcd_outstanding_req_clear()
Thread-Index: AQHXbr36INszmwqiB0GhBFtpX62486sz+gKA
Date:   Mon, 5 Jul 2021 07:03:19 +0000
Message-ID: <DM6PR04MB6575B0AB30385BAFBE977C97FC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-15-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-15-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21d6507a-db8d-46ad-5aea-08d93f82f8bc
x-ms-traffictypediagnostic: DM6PR04MB5353:
x-microsoft-antispam-prvs: <DM6PR04MB53534FEAB78A14772B1054F1FC1C9@DM6PR04MB5353.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:489;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C19OmWq/B7e6aPWCMbkRW9ZtwZ+7NG5HfiuwYnztInpyPsHWyl8dhH4phluS9wLJruAPbuewHRp7c91JLhpLnrgNVP2ralP0OXUGerCn3suw5Ci4wuIoHWccnFfviDfGyzpFwCSIdet/LvueJLxqJAnJ/mEHveo7Ygg5HR+OLrHRUJd3StPRG4F1ddBj3D7TlU3TaDiyiFfOg1b0egEkXi64brbIg5v6Mzl0/dG1bpgsg3wxVWltMYaS9xoeBP4ngXZF279MZvr+vf00vYOQVVUU8/JE36APaU0pstvmL/RtooiTgUTetkDOUgeakl2+Oss/uxpgiNS2TQzLg2GBny0vBTodx72zg5WG8yOOYQD+CsSRySVhKh4iwj7x9Fpboln1n6aNn8XUWluA03gCIXCTHnDKhcRYkRBE4RO43XPbp7GLQEwiw2N6d8qoCFb1OUGuBhbvaMrZC0NXDOAyHO5WQPEe+3bjtNWWSHZvH9uCeU1YuEj3uD2bW+yED9rUOZvkYr+URagzLH+eoBQsIId5AMAeizXnEAZa7GvpHVGPHg0C9KsGx2DIsDNaF/knYLrU5tQRq4FsiUaMMIfR0fV2OPuF5oGvcLhQ97D7fvSIbWuPYy5tyFmMzRoAlQ+CqYVh/gbA4Of2DlP0qB/S5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(55016002)(7416002)(33656002)(5660300002)(8936002)(6506007)(66946007)(64756008)(8676002)(86362001)(186003)(66446008)(66476007)(66556008)(478600001)(316002)(110136005)(26005)(122000001)(9686003)(38100700002)(558084003)(76116006)(2906002)(7696005)(71200400001)(52536014)(54906003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p4FVSM+qBxwowl08R8kQhIWtQWmcsRm/Sia4fXf4bf3n62fxZYAl1vX/S+y9?=
 =?us-ascii?Q?/+4X3Qht/vr0VYAeLqwUlnrWGGQmK2iF6qCExCMU/oDOhLRn/5ZlABJeMMrq?=
 =?us-ascii?Q?Yp014U6GUOF2u/gXzVFI/sdMniUk9r5GRnuNnX6irUGgMCslRgbeXYr8kVNc?=
 =?us-ascii?Q?dpi0bnjXScSUYOFlhlKUwZM4Hxm5rYXAVwkJ/cdYkSsNoZXAM5xh0G6ikQb9?=
 =?us-ascii?Q?Ws89lGdR6oi19yxIFduAFpSnY1CEMqkD6xaxpAWWmdwppgCPvER6oIxqf3Vb?=
 =?us-ascii?Q?cIU+v8T1aSzCNBFZ3EZqF+BPtFCj2jyqoJmO98wL3vCvREq06L9DgtedtJEQ?=
 =?us-ascii?Q?8ENAUjytKnpzRZpGOxpPXku9B7JVjyxz8QQRTC82OOZgMWy081QKshY/7DxH?=
 =?us-ascii?Q?2JP1cfSn+ecWiMirDAkAGDU34Tm4oegV6nrRBmrg4k2vAcny/bWgF1Dr9onD?=
 =?us-ascii?Q?zoIAThRSjYfF3IeSsa0raGH/u855rCRRI7diR5QmYo0wDGwWvEHtd1L3BLvw?=
 =?us-ascii?Q?kyhVVOmk8B/lEmjnT8xpqmhwppaPWq984pS2RpOEpv4YsePUSsDyyDZRtYL5?=
 =?us-ascii?Q?1GbWTpYQZw+kFIyumWrwJ+rYHGtjjtWuIEn4cbAW/ECezzOceO58uvCrfkz9?=
 =?us-ascii?Q?V0EaozcZweUW/vqNTE9QiLntspBxNxQrA2yM+/dydxhFltJzztU/wfRufjgb?=
 =?us-ascii?Q?KP0YPGmE/byAy5b7++TTMSItSfRR52hWXGUqdL9hw5hGdqZsnNcIBrTCZTin?=
 =?us-ascii?Q?Plwk4DtgRpFa6TgGsGPgks1yaq2uvTStbq54Wjmq2qsYD7LpZvoA25brTzlZ?=
 =?us-ascii?Q?9mk3jtmWE7pMOuaYwRR9S7DslMKO7N9RSMe4viVcWj/7DZpnjxHElYbcdvZW?=
 =?us-ascii?Q?Tiy8PEfKft8yOcw2zT3E/gjef2lRgFpnyQPaYsNwyHXSJfCVZxAKYXppfDsq?=
 =?us-ascii?Q?Ky5XdpaBqEd0kiFRo4/t1w7m1EZ7voWDulzBJLpVwHYHiUUKowLcwZisT73r?=
 =?us-ascii?Q?5ms3n4hrQUuFQmbPYGs6bmLHlOVZJKnPN2ct132/yoWUCTsrMCtxn8rcHld4?=
 =?us-ascii?Q?05Gkroi/wd+75f2FoElkRNu/Xuj1Ta1frkO36chNq3aaSWGbm1dxkq74oHir?=
 =?us-ascii?Q?djiUA4pww+QPh7k/9Ju/DT7LzMYkr5kG02dwDIAuG9r3lKibY5xyJgJisjf+?=
 =?us-ascii?Q?h6DmdlbJxfTCW9adVjZLvtUCSz7PJMuXIgUDEGf28wtlcztBipVBRJUESV2b?=
 =?us-ascii?Q?9uh81FqP5l5BdBsDjyx066h1+zoC60zci/misgUgU6VWHm6+k31d+pWhf5Lb?=
 =?us-ascii?Q?LuuBpHj6A2tZSADqF5TwPRsq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d6507a-db8d-46ad-5aea-08d93f82f8bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 07:03:19.9703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M2jhvxeYEiXi0g1KFf1a27HvvigU/WfB8EoxBRMpVgc/bRCt6xGNaHCimZ6lv0T7PTTOApkhXYi4BFYKquGNEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5353
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Inline ufshcd_outstanding_req_clear() since it only has one caller and
> since its body is only one line long.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

