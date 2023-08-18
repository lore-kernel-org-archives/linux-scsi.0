Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A80C3DA66
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 01:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356782AbjHRBIP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 21:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356771AbjHRBIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 21:08:14 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39F32135
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 18:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1692320892; x=1723856892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0XYu5Z9qCbJLhrbubXUhT9MruoMUOS1olbHo7MLrouA=;
  b=arT+CKOStJRsdGcsWqh062FP0rbOBbJ+WjnBm7KhzTn7TcZxYJkv+Myr
   /PXKoYnesPrDg6tUn6JnYQP3h9LQ8GrfeRRTFynlFMITSC+xpjemORFkb
   VN48UCn9BtaUaNTtUK24rGSH8dtqFKZQ4esY4MAZKCiPGYKRidb/sPAkB
   pFSpp2XP3Vb7wGtKz+iWgSLqqmBU+nsqSfxwzkP0bKU4HYqlswYsQISIU
   898woYQ3z0g20XENnb29kk8lQV0H+bE7SqMnxDG2/sHLIR53sVLmkjCTC
   kSp9E8hfOUKNWpD1XohNYRA+bcaotF/1utP7YmcuQMZACY22ZDdgpDVs/
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,181,1684771200"; 
   d="scan'208";a="346623560"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2023 09:08:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hc9pzPr5+OhbcnylLuuPIF2tQT3E1tVMyskg6rsCzV96Xf0Bmzh8mazUQAJiDCxtkOhQIe/8tWlaA3Hgndk7m2fw9w3Ho6D/rIa4G30WdTrNaP3b7uYvm+LBCJbBCZBielDxJgSQTUWi3htd48QNVdvKGrUq0xmAtYF0VvHUMF2L6rds2bIrH6Lr6+OoACwfNNzdcA2ClL1tLKD75A6BK80Tc9gt0IplQnNzuR08UbYTP4KPELF16e5V7tozCHs2z4InwxuxPwnQXSJoOhfFcLAkN5qo4abr465SkmigS8ORvD8OKUEGMZE/er8PT1lNk0huE78L4PLaJ4FvEnQMTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZ+LbYz7DTkXqLCa16uZwCsVudoa0ZOjR/Y5zI6T9es=;
 b=gH5AUCB+ZgZYUQt1BaN/9Xa+iJ7SRPMmW5MZDscyX9l4aYzWliB5PA/kdaJkhq1VDIPVsuupqNhIt0C9AQbOl39VNgZoSrPxESyJjA/Xd5G3qLaIeh0sGwIagoUE57ovNcAWAxEEWpGbbcT6xLiUKOTK3BFZ6BaEMlyokzXpdL1qpUCVt/bJH9q241bNY5V2PRCfavSWAFlZ1kmczlF4sA4SB/kih8wgVOnV7NwQzbQHU2g8frWhyNT6TW8f28zzNgpkoEghc3EENWbTbMZc+vzfQXXr9h74hbMuGiLA55n+i1UeINOWhZfHu7hI8R47aspJc/UuN3MV+PawI4ylow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZ+LbYz7DTkXqLCa16uZwCsVudoa0ZOjR/Y5zI6T9es=;
 b=RRJqf1sdnGavJxUiyzINHTuvico0CFuIb1EZboaWxRQ3mllhS82PxAu2RmODYKYRQP5mh8IPBsSNbhiQrCgT79H5f2cwop9uVC/3gHwhmuMOXGoHkpd0t2qujncWMhXY26kDTRMZa7xnz075/f2f3rSSt0DDS+8WW68bxdDwXxQ=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB8408.namprd04.prod.outlook.com (2603:10b6:a03:3e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Fri, 18 Aug
 2023 01:08:08 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6678.031; Fri, 18 Aug 2023
 01:08:07 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Igor Pylypiv <ipylypiv@google.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Topic: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Index: AQHZ0VO0fxFCEX0RQUu2CJj+KjRNT6/vJK+AgAAZiYA=
Date:   Fri, 18 Aug 2023 01:08:07 +0000
Message-ID: <ZN7D5BPK8eiXPEt2@x1-carbon>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com> <ZN6vB0COt0eJU93A@x1-carbon>
In-Reply-To: <ZN6vB0COt0eJU93A@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB8408:EE_
x-ms-office365-filtering-correlation-id: ac8c522d-76d7-48c0-7518-08db9f879522
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4daOChBsHFNmWChbIqc8FY3qoy30ZUYwbVum7pjycmNwStLgtEf42I6ZmyQbu1QZWAwVnO7NtmTzyx46sKdvLg+kK95vVzhcKfu1IEd4D0vqIO5CKOIZcgFOMi1AQcOm5g7UGnKukxOlkXH74BbRnG0/yDd65qc9Fp4w+3jfswNa8cqOfhFNmmW9ZSKbO8tvzepsu/rNKT9y7IcgUf2hPNVbUwyDdL1CkdFsBDoQL77a5zLYGr3cz5idq3epcfLnhLA+50IqIzX8LZm7rHm5zQgZWqmX+YaSbKCY559lrP6a8oMIft+piPba06wLHKur+FsRAO05KbVaHfQj9snRBg6nAGMfqV7AQj2/D8v+Og1kmlHFLzriffA++E4KRWi51hfDPzwop4A0/BtDRbsqQstc2YCzMqoPsqqXoVItlx8sSW8A7wj36zevyGHk0u27iSls3GzBxYf36vgloSzUNwaDRgtEI0YcEjHeCBFgCZLqm4oXbFxiVM6sQshJCHyKjcGTJMi2W+x8JCYjnPGVTFXdp8gSPmewmQuu0187aTXD0ubbuFIhw7PK03dH5eTHtCHlA80MXwh3oDMRwdgJYCGNCRMOtfCYb5NY2Aq8raA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(136003)(346002)(396003)(376002)(366004)(1800799009)(451199024)(186009)(83380400001)(66476007)(82960400001)(66556008)(66446008)(38070700005)(54906003)(66946007)(316002)(6916009)(91956017)(38100700002)(64756008)(122000001)(478600001)(76116006)(966005)(2906002)(41300700001)(5660300002)(8676002)(4326008)(8936002)(9686003)(6512007)(6486002)(6506007)(71200400001)(26005)(86362001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HmrC+IJOzj5h6CSTK0eD7u3QdWLcTCZO427Uw8j26fmIk8F8KvUUzJjWUGJn?=
 =?us-ascii?Q?pRhTHcDg0UMdlHQ3jFOllQJDxTPb9lypZPc1+zJTax64LTg/zX14RIhfHAdx?=
 =?us-ascii?Q?Q+NhNtE/Qj9YaGiZwWCFpF3wEH7ajdO60JMO84EQrPUiF99znMQktNrSqKie?=
 =?us-ascii?Q?5tCPiUUqiIEiuPRvtPWRHSw8a/nQadbei09zATW6eltwL1X1OqdBXsY+NOLq?=
 =?us-ascii?Q?14+5NcT8sIPwYoXxRzSYUA/PZE1qvENkoGaOS1Q5T4h3+7GpUuJQX/n/l+hr?=
 =?us-ascii?Q?BPUStJh01vUtHLAdxsF2dyAjtty8QJXKZsgxrfUdhG3W+bgWucnpWovYhRkO?=
 =?us-ascii?Q?IHnuoLfJy19Dv16/DG6fk3DgdD6aeh+iDgmOeh4LBedyaULZwZvMKVPWrT/1?=
 =?us-ascii?Q?LVQCuR6x+ITfcEUK6bwWOTA7cnEW+KOYnMKQgRYbQ/VsqR5lcNdB1I/SEAgw?=
 =?us-ascii?Q?ODcg+R/ytyAo7a0qVSPO+r14XDqOOERoS1iM7l+X9GkrkCV/NlqgjJEvoNvt?=
 =?us-ascii?Q?v9IE4BZKP0L5MX+gbEtf0CVNRum/GG3cKUdiuUV2r7DASwtQI0Nx0imyHOVP?=
 =?us-ascii?Q?TZOAS3zbSwxM0CsalSXeTJXEaP8ud8Rdw5Q9qgCr5pmRzp2064E/2kwh99az?=
 =?us-ascii?Q?SHcwWztcYV09xOzKqS0zHmSAi5JsMLao+5kIspJhEcPSx7iIqDiyGJYz78T9?=
 =?us-ascii?Q?RXI7HUrrXrNMUFpq6G+r0hVK2Kkpx+hO3XAMd0QrC/DyZlzcjJSKdCfOk3Ue?=
 =?us-ascii?Q?3ddM7G94uTGxgksyZce0uePs+hfg6qmlFt9FnysDxsWRjmUwIXcCiALVzM6D?=
 =?us-ascii?Q?jd1oFnQgyd1EUQETXWLZO+P8FwnaVsltkU4bxq4oZrafDapjf1I+IAD/ZiXO?=
 =?us-ascii?Q?LsistMCiq9QC/yzSRnteT1rlqNLvuCa1SzMrizDrQ+Q7yqyjTKTMuF2sf8kn?=
 =?us-ascii?Q?rnH03UwY604fPWEpiWpV2kOkO/IhSw/ObTtBPUoshYZWjJP23KnIZ1zYjcRC?=
 =?us-ascii?Q?+WgMKJsZ1c3Y9znlIIetvti6ekXYtRY+hfOmFb0nzAGJ9uaOFxH6j3OHjwda?=
 =?us-ascii?Q?PIGp8k8vi0VD0OkxOSs+zTwwmtFeLQ4Kz4dq/2MpPStsPrG2rtPCTCCmh1wJ?=
 =?us-ascii?Q?hU/W5w2F70dhFAw9BJHzy2mdVxz0Au4k9StOe1KmSX8PzHvw4gVLuDiDmrBX?=
 =?us-ascii?Q?X8OReYFhfnBGuFZ7ZRr8XjkLu5RvN22mP8sCyQ5RF72CkE2JA8R0nIFpR+Kz?=
 =?us-ascii?Q?Ti3AcdJRqLXDjPWXNRWwFp67FjxzS+XGlREOtVrGoAnUtytxHuTz8rj21MKj?=
 =?us-ascii?Q?etfDtrJzlt5uQfltxYq9hBEpHAROnlL9L5L6kGSDNZnHvie6MrnBA+YLTfbK?=
 =?us-ascii?Q?BqE6YqGvRNvXE2khCVrw3C+/vm1eTvrR0hr9ApMJWGm37/nJUMrazGsVGbXm?=
 =?us-ascii?Q?dFroTvE0/FavTwMzU3EB3aKP1I4SfGm1co2BBqVi9JglLxsXrvZj5970uPVb?=
 =?us-ascii?Q?x6SagfCIvaTiQFOMxU9xLi+k4KXt6c+NOyHanso2rJA4NzLnbVgojYWRvXph?=
 =?us-ascii?Q?W1PzmrCj4Tkt3qiHX+MbfZdBcaiOkeMFFkD4Qy6E5peAInzFVVE5OZ7tCPTE?=
 =?us-ascii?Q?iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6881F23519B77B439F65E01E51734009@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?LFizUilBFC9mCFDJt+ih1F8W4t9v9wA0aVv1oy+8jzFHnOX1uFYIrJrnWGep?=
 =?us-ascii?Q?FH2HmuuVWiETLTOq0rqUJ8h0csWZO8zydjIV1FFXRalTWFwZ/o/JLi1So0Ap?=
 =?us-ascii?Q?wTMwrSjAaq7KSoR5YRgk92muae63u0fVa95vfPv8i/HgA6FztG2sydcMzj0m?=
 =?us-ascii?Q?YLN1d7uFy9weMY8woRwwb0XZ822rpOou0rHNa2P66rGTEdE+KFkUtfiIUrtB?=
 =?us-ascii?Q?qFdVwRcM5h5gH4pDbkPizKYWo+mRCiA4xZ8j6it8QPEfq8gMyO5aOBhgocNM?=
 =?us-ascii?Q?UeM6Xsjcn4kXIyjAtGAK6We3sFrIuBq/1GQKwvl7ETx+BD5rAF7eULS2d9LZ?=
 =?us-ascii?Q?NRmC6HL/Aya4E6oNNUwsHzRn6xtwoeBMy0w7oE6vv2hwmWIzC+ZVUhfZI2v0?=
 =?us-ascii?Q?EEKWG2KiGmimQ6RI7a3Mh1nNBhRWt9QPR+hLRqVDfuS68QAQ0EglGBrwnxh+?=
 =?us-ascii?Q?/3uasUn+umxmlFuF8OOIBVxBwXYmHXbrvhqurNIoypnTos0vxPsMF6ybQHRE?=
 =?us-ascii?Q?2QeeSs9sxBYwv5gN/HQEHnZZizuMpfwEU6dmDZRXQhlfKGaTO4VDZ+GMfUxW?=
 =?us-ascii?Q?JaW/z/Terjw3R6r7XM1xznkrBDa913Z4KmVrg1d0T+SXUQpOX6dNOyOmEN6D?=
 =?us-ascii?Q?Gh0tbBq+SydGvyLtWFlsbmDMEuZMzOaf70r2qp/bGMGMnVggokcWSGh48fd/?=
 =?us-ascii?Q?8f/FK0qacQO3LUfP4qMC8YMVqWbPqx+BAI6SyYsjuSY2BGu12HhRztTKzBkU?=
 =?us-ascii?Q?GyBGdb/Wgy7iiM4EZxhzUI/C8Ar5PPLRjA0VDdZkDNobyq7+Z4+kZUakDDc/?=
 =?us-ascii?Q?Ey084wxRqMNy9Z9AFkxxOSaqrcCP4ven54uAV5a5Ju+DCs3fNQk7MbGLiblm?=
 =?us-ascii?Q?DdnSbNRtjzGBikRAS2pmgbA2g/P8yHYjuweNQa60bOKY6+mApGLkBGffWcfG?=
 =?us-ascii?Q?LXGA1rKN23zVsISpriHM00dxxqsfYJVlcrOoqmmQ1mE=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8c522d-76d7-48c0-7518-08db9f879522
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2023 01:08:07.4412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EpSC87iOm8nzfjgMUh0gPgltwtyDWUHmVtu77f5kTNUlcAP8Fd1L4Br0HbtEXCQr+piZONO4C7Fa+9zA+C/8mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8408
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2023 at 01:36:39AM +0200, Niklas Cassel wrote:
> On Thu, Aug 17, 2023 at 02:41:36PM -0700, Igor Pylypiv wrote:

(snip)

> Considering that libsas return value is defined like this:
> https://github.com/torvalds/linux/blob/v6.5-rc6/include/scsi/libsas.h#L50=
7
>=20
> Basically, if you returned a FIS in resp->ending_fis, you should return
> SAS_PROTO_RESPONSE. If you didn't return a FIS for your command, then
> you return SAS_SAM_STAT_GOOD (or if it is an error, a SAS_ error code
> that is not SAS_PROTO_RESPONSE, as you didn't return a FIS).
>=20
> Since you have implemented this only for pm80xx, how about adding somethi=
ng
> like this to sas_ata_task_done:
>=20
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
> index 77714a495cbb..e1c56c2c00a5 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -114,6 +114,15 @@ static void sas_ata_task_done(struct sas_task *task)
>                 }
>         }
> =20
> +       /*
> +        * If a FIS was requested for a good command, and the lldd return=
ed
> +        * SAS_SAM_STAT_GOOD instead of SAS_PROTO_RESPONSE, then the lldd
> +        * has not implemented support for sas_ata_task.return_fis_on_suc=
cess
> +        * Warn about this once. If we don't return FIS on success, then =
we
> +        * won't be able to return an up to date TF.status and TF.error.
> +        */
> +       WARN_ON_ONCE(ata_qc_wants_result(qc) && stat->stat =3D=3D SAS_SAM=
_STAT_GOOD);
> +
>         if (stat->stat =3D=3D SAS_PROTO_RESPONSE ||
>             stat->stat =3D=3D SAS_SAM_STAT_GOOD ||
>             (stat->stat =3D=3D SAS_SAM_STAT_CHECK_CONDITION &&
>=20

Note that some drivers, e.g. aic94xx, already seem to:
always copy to ending_fis, and sets SAS_PROTO_RESPONSE,
both for successful and error commands. So it would already work.

Other drivers like isci, hisi, and mvsas seem to always copy
to ending_fis, but incorrectly sets status to SAS_PROTO_RESPONSE
only when there was an error.
They should probably also set status to SAS_PROTO_RESPONSE in the
success case, since they did copy the FIS also in the success case.


Kind regards,
Niklas=
