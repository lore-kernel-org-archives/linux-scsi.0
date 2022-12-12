Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FBCC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 12:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiLLMBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 07:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiLLMBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 07:01:17 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79452C35
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 04:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670846474; x=1702382474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EPth9fDKw+A7amKITLo2gXNfemsjLNNwkmQLxA/gFIA=;
  b=ZXEYeRX5iGnq9ZgApntiJueMTjH75Rfax2ezCo2oNsv2JaPzi17iuDW6
   AGOZCrwu7ZbQFbJAtSd8Uy3ZJqo6GxxHexgoGteTGwxyppE3oXO8BsnJe
   4+6K58jv05aRIf9wUWdaAcLtLvh+mwoeF9VcVuw0p1BkJxqQTiv9WGaTV
   3rFTB5TRAj1kIYEH94ScLEoWnDkR+e8pOvt8c5K2cqrApJT0Qwc/n/NZb
   7SDGdlkLKKcS/k6+fs0RpJ4ElkygHIFdtxdS648PpFviD4/FH/0G2sDtD
   58ewWBDSxi0ZYipzGspiQOcqhJ9onnNobenAe99hpWcMfXzrMGX4G7wPz
   w==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665417600"; 
   d="scan'208";a="218438122"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 20:01:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYyiNrElukCN96A+cQRXpg4LfAZwWDNynIqZFdRMwTu1NQBXm9uEc4TPdGBq+sXlvBZIKo/6gZiWrsTZevwwxVqUIJz0jfE6v7BM8GnFIxLHPyxs9+wlxDFrPTJcj79yFeLY5JjR5KNNhZK/rVe206SIimJnERO+WdXkojneixjpgP3DUg4HTDWl8l+285/POP8AFembgdgEOtZTrMOOqibaMLaOtiuzS1dlnFJQiB8m6IZVGowlwK911jJLrz+AzGWydGfaeTcids84mW2MMBqfe3a3BzXJfU4o3mUx4xmnpF8MWqGmfIu50Su/4/4Dk96wcrDxuxP6I+2haF8DGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0q1r8Ieke35FMHSgdM9VfAYyDv9F3/XYBvuBJNxoK1Q=;
 b=GS7QlnGSAoCkcQ3YZvn41+xlg9Vu8ROgz1GJsuPrnM/QQmMGwMBs5Br5b7NUNFIfbYV0NijqOyuFan3TyB8qc964PW3epFdDtJta+tUUVm4a/P7nXT19LuNkVTbjxtWRpWC48K+1CiQX8LIq1E01ycfmDMzVgP37wdgbBHlEe35hJVv0UdPaVJoKVP2eFFZuHYZNg+flMZL2XeNUWaq3SjZCpBMRXKGC26i50oCORwY0Ph2V7l6bXYvg4oG2sLWxfaoUY+1T2slf4inAdd9Q3gLTsUwQ4/DBBy3N2Xi06TUmb49ZwaEphA1ckhE0jg9I0gXhsCstC+1dwaQ4fhBn3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0q1r8Ieke35FMHSgdM9VfAYyDv9F3/XYBvuBJNxoK1Q=;
 b=bumPVyx/M3F6p9u1Ip+NyLuBAUpe880NgMAs823ShmT/6OCogmz0kcDNyMe+eiWtG3HCAJrn/QBnFIzohQrgVLkxzay0R+1E7Of9ICRs3/Gtsyn2N2wWDqphhK3BYu8cnESBHNTuTNpp++q7YB7UYAOU+ZuskZ7OzZPY75ODCVU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MWHPR04MB0497.namprd04.prod.outlook.com (2603:10b6:300:70::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Mon, 12 Dec 2022 12:01:09 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 12:01:09 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi: mpi3mr: fix alltgt_info copy size in
 mpi3mr_get_all_tgt_info
Thread-Topic: [PATCH 1/3] scsi: mpi3mr: fix alltgt_info copy size in
 mpi3mr_get_all_tgt_info
Thread-Index: AQHZDepkkV2HQSUdiUCxLokagnbnnq5qJwCA
Date:   Mon, 12 Dec 2022 12:01:09 +0000
Message-ID: <20221212120107.4msejx7osnx573t6@shindev>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
 <20221212015706.2609544-2-shinichiro.kawasaki@wdc.com>
 <9768526f-5f14-6851-1d93-81d4a0fc8565@opensource.wdc.com>
In-Reply-To: <9768526f-5f14-6851-1d93-81d4a0fc8565@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MWHPR04MB0497:EE_
x-ms-office365-filtering-correlation-id: a559da7b-58e5-46f4-f00f-08dadc388e94
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vC18xibmjUAmTo5LXKlGSmaX+7MKty+JyUEiP5q/FIr0Ut2UM3tqqvqcCvGznMNS4VgaWuihT05vInqwbCmkIbkHF5fiRxydg9eZkQj+ZDFX9WSxcqk0Fm6QuLylpu2I1i2JDzePKUvaM1GLqvsTPwc5JIAvCedq/XdFhpHyctVw3aJLK/wpahQqkjLLVXtFVk3olcGccEVLbNyASXcmJ6JesKSdyR6clRnIOkkjTn9VAN9M+0UU3rBcFaVAHZn3FVztLSU8oC4/Eeqi5ppA1d9PjJc1xwAKLzKh3DN9uwQORUVWhpmIis3IqV7LVuS3+JQLiLsb55OovoA+fEn4zn32QR+WnoVL1x6gQZF3bUjNUMhOE85YAiQuRy1InZqGXNwEMkkXIln7L06cFSVxA3J7wDbp0qBmcE0a6xhZMYd0/9wHWFUiKmBZsgbNsJT054wu9nbhXU8jphpnvwkTbEtTv30pUMRVAtWHusTrjWCDYd60zAfjW0ZI4irNQ9QvneCxITWxNYubOVCxos8B9ICXKkP+9Y76m+yc32166LMVQ/ROv1qLF9UKIscrAHnzyj+cY52aONhAVd7IjAeCx7pN8X6Q343frpmahiaOimlQ7UKFoj9x+ueqQ4JWG9HiTMvingbGaJVQgjBjktwjRSH2HNtKLjX6s2CUN2q7eFoYcsFyarwAV9SVOLC1WxeRsEXsv/SjIk4Qu3Y7MI8o9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(451199015)(9686003)(6512007)(26005)(122000001)(186003)(478600001)(6486002)(71200400001)(53546011)(6506007)(82960400001)(83380400001)(1076003)(38100700002)(91956017)(66476007)(64756008)(66556008)(33716001)(8676002)(66446008)(41300700001)(54906003)(76116006)(44832011)(4326008)(316002)(2906002)(8936002)(6862004)(5660300002)(66946007)(86362001)(38070700005)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aj8BTyLHIhXg7BrzaU++fJXdErO1z7s5Nv84UhhxT8LEQFdePP6mjAYG4WET?=
 =?us-ascii?Q?vS065+zyL/MElI/1npJBc/IS+z9O2HEHMdRKMmK2zhoDQ4iqBU3yPco3myJo?=
 =?us-ascii?Q?DRaSr9RjiK+vPbv++cTDRD9hzLMq4F8uqrMJGpzotEJM8dSnFrLVu+mfsohL?=
 =?us-ascii?Q?VaXzKeWSlemuxDbjZOGQjKSOSXEQ8X2jYDsHDmeoyNEdlcxWpH3yMtUmPZ7P?=
 =?us-ascii?Q?wfRPP2H2uLG8a9y5HlMF5d7kLmdKnRbdSpxjAyCAT4oHL/G7DtEwbUX9Rq3H?=
 =?us-ascii?Q?PlbuIG8L4BpG7OwNICYj7IESxw2fkbCDlNsy2UP2ZRYxckpGVr+XGyBOQI4T?=
 =?us-ascii?Q?MMy6X3zYB/QcMEOKhyHq7SNxBYPmLl5wxJUc58iPS/W51KQVnkOg+wult9vO?=
 =?us-ascii?Q?PiyGzzZb/iwjAtg4H5dlPZx0suChsfcaTFbmg/+8yh6lkcHTSjiPmiR16IDM?=
 =?us-ascii?Q?DXzxlN8DR9o3065lubyU41WwWLkye0WEhhm6RhG6uXXsbv/ei+zwTKo2toGn?=
 =?us-ascii?Q?ucBG40aFmL2cNWNmfV8FinxNYmaJhRtwIMj/aPdJOZhIlP5oUmbPw5mGwyZL?=
 =?us-ascii?Q?sYPs3G1KVKgGg82zD3QUZfe/yHHHhr8d4YCL4tLJDMaBxEwVBUvQT86nA/fh?=
 =?us-ascii?Q?bo2yLv0O3Lacs6VtL7M8cHfVKSu3PyXR1HcLBRq24+wmDlGnZe+xxLAZj7Iq?=
 =?us-ascii?Q?3YuzJjQovKGtFSDBqxpRB3m9f9QHM22HhZhxAYhOcqZEJlqPAbNYdW6T6/ga?=
 =?us-ascii?Q?IBFMzL/ibWNhiK9/l8h1yBEMwWYLyHD7tMcT5t2zBqozx0RfcBMGuf8rLmrd?=
 =?us-ascii?Q?9Nd9+Q7qoTxwW39BV+wDYnmHAYhlo358uEVtQbktxmSYzd1nH9pZdB81yBNk?=
 =?us-ascii?Q?Jew4BmhOjbdldxdFnB2/qqiuO9wFYtc5DbZrUle6aQq7B57yaqaVkEYlEcHU?=
 =?us-ascii?Q?o9knO4hoBFgSyj9Gd5X6ylyTbgG0FCSolfOufvb6Sbhqhlskgl2Y1fV0q13Y?=
 =?us-ascii?Q?hXGuJr+V0cRmWv/S+oGmsgnQieAnWBerF7DCr/7C4x3lyTA5B0CiB/766LIu?=
 =?us-ascii?Q?o1X6QnXqhKdQyYjdKTgDEiU6MDkk+Zs5X4jdpc4T+tj/FwNIeCMNHSUfdagi?=
 =?us-ascii?Q?NpsGCZRNgwBCSQkOd4N+M/KHrRkR8UiEyQbz6HI0DFg9ssG37qL70YteSwNL?=
 =?us-ascii?Q?ItweXcKhUkOozoN0zywqMJNizxKm+itLTs3okxiizsKc8rnJNxWO6O8Gr9Nb?=
 =?us-ascii?Q?Xkoue7929F6S+PmXIydXWld176Eg/e8j7Fq8ItQAvN8Q+7ZeYEVXVTQR4ahV?=
 =?us-ascii?Q?oJMJ6OCs0bnkMfRJCAmyb8H2fd2EXcxcvp72lD9Kuow+lDU6Shms0BAkW2Qu?=
 =?us-ascii?Q?FezlZYmXvaJqitjt6ApiSFEoW0OzZYb6lxFBYjhVzmYbFJqYIaxdM1cCgfpc?=
 =?us-ascii?Q?TUFUTfcVWAoqDGxp7ik8jkS2tfXZRtN9jSw8ilR7fIU5edbK17uHDLoN1OXm?=
 =?us-ascii?Q?SX7dhUeVNlEAlH8LNHRJiJo/bZZAyX4HS7MnzipJqVd9dTfcRfNkgtTwgQ6P?=
 =?us-ascii?Q?VAXHEpy1Z/t8my3VDMW3vMD4zCyx1YB0BcR5EIWgmoeBBWYmPQmrL4a+bBAm?=
 =?us-ascii?Q?9aeMy92Er41pm3lYZX+yGiI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0CCC9A9BC6499D49926ECA78868EF7DC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a559da7b-58e5-46f4-f00f-08dadc388e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 12:01:09.4438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sNjoeHEz3s3jOUpp8S/4OTpHszplFdBThdzZzbbuLgAsTYqDuV9UqUNbYp7tYXOER/tyucgARaVc9v7hpfvcQ7s3QFX8GeDan3YqMp7Jdts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0497
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Dec 12, 2022 / 14:27, Damien Le Moal wrote:
> On 12/12/22 10:57, Shin'ichiro Kawasaki wrote:
> > The function mpi3mr_get_all_tgt_info calculates size of alltgt_info and
> > allocate memory for it. After preparing valid data in alltgt_info, it
> > calls sg_copy_from_buffer to copy alltgt_info to job->request_payload,
> > specifying length of the payload as copy length. This length is larger
> > than the calculated alltgt_info size. It causes memory access to invali=
d
> > address and results in "BUG: KASAN: slab-out-of-bounds". The BUG was
> > observed during boot using systems with eHBA-9600. By updating the HBA
> > firmware to latest version 8.3.1.0 the BUG was not observed during boot=
,
> > but still observed when command "storcli2 /c0 show" is executed.
> >=20
> > Fix the BUG by specifying the calculated alltgt_info size as copy
> > length. Also check that the copy destination payload length is larger
> > than the copy length.
> >=20
> > Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr_app.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi=
3mr_app.c
> > index 9baac224b213..f14556d50832 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > @@ -322,6 +322,13 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_=
ioc *mrioc,
> > =20
> >  	kern_entrylen =3D (num_devices - 1) * sizeof(*devmap_info);
> >  	size =3D sizeof(*alltgt_info) + kern_entrylen;
> > +
> > +	if (size > job->request_payload.payload_len) {
> > +		dprint_bsg_err(mrioc, "%s: too small payload length\n",
>=20
> "%s: payload length is too small\n" maybe ?

Thanks. Will refelect to v2.

>=20
> > +			       __func__);
> > +		return rval;
> > +	}
> > +
> >  	alltgt_info =3D kzalloc(size, GFP_KERNEL);
> >  	if (!alltgt_info)
> >  		return -ENOMEM;
> > @@ -358,7 +365,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_i=
oc *mrioc,
> > =20
> >  	sg_copy_from_buffer(job->request_payload.sg_list,
> >  			    job->request_payload.sg_cnt,
> > -			    alltgt_info, job->request_payload.payload_len);
> > +			    alltgt_info, size);
> >  	rval =3D 0;
> >  out:
> >  	kfree(alltgt_info);
>=20
> Otherwise, looks OK to me.
>=20
> Reviewed-by: Damien Le Moal
>=20
> --=20
> Damien Le Moal
> Western Digital Research
>=20

--=20
Shin'ichiro Kawasaki=
