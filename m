Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E09DC54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 06:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjA0GRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 01:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjA0GRf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 01:17:35 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3315999A
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 22:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674800254; x=1706336254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=73Rxl6kOOHwZkhm3E2mwDavA8WVkJG9KYY02CX8+WsQ=;
  b=F07AM82E18j3UenZDIw2nY91f6HOUndLhM1v+zmDElswvUkpRZLNR05F
   hyJzC1HSEJeSloI9Noz5Qsui2z9iUn6/6/xQYPAdcYEjgGBrtbHKoyB3s
   7AQy/KmgfipswkZuwOgUpz04fK9atpuXN0EPkjwPK0C9I7EP96W6sU4Vd
   Dy+kNvUIT1VAOO1K4hXI/2Xixz/qjzoarYJMHfO6pVJa99FpDgcYUZn/V
   prh11m0BWVbTN9/jUD5qVhnK2QTmQva5CM0cTixWXGhlvRytpe96gzzR6
   ovcDre98ZvTldtq805m9bHzikrsCZ4rzGGJTYuIorN7nSQBeyXCkCQT6F
   A==;
X-IronPort-AV: E=Sophos;i="5.97,250,1669046400"; 
   d="scan'208";a="221680681"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2023 14:17:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRvOCw/F8fHgAq+kZQGvb8P5NUPJpwzqapeF35RqrWVXNsmBOlYtPGvsXf0CW7XBNhUTyM3Hc76tEqUrwa5/Y2BWOSGSOuXSZ0FdyB7ymxIdarpxVWHcS0rFDoujcFesHGHqbtqdxbBBuZiXWB9E7kMTUkOHfs9Vo7Dhtrrz+oBp4vFaQt+tfq0DyJFIfriXA2/HPYPiHulb3TLoj3frfmr/I3GPKHCZml5zlJ77OfKx6fGRzfeswo1P+eWtk9MNOOjocJTSPFcfqKdRV0/lyLCf6ZcO3wvBj3Ibhfl2vF3WcSaQkxbyE5RqjEWFFtPBY5XkAC8NvgM2HEu1aNJWiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOx5yOJqoziBGlhumIWzUwHOJL0zjroxWqv7eYa409Q=;
 b=Ffy0lIB4fceNkkyakNAIks16kgYhYlY1JHzqRDQP0z9fyHoZGL6NJjtP1pZtSIyxeUBix5EA0Qvz0Rnkj6WZRyWpd7O/07G8CXFm5y2L/OHhge3vIbH6MrF9bLGD0+6+w3bnQJAZz/Kx1eP3lHiymW4h5VuHNjaoskpHCMVI+JCTuZ6Trq1zfFmkluZq3nzf/A7xEvp90qmUgPoHja7O8cqO4z9EZJTghcwJzNBRcZ5F+MY7JPhVOFrIwfzxVST58fW8dRbP6YB2HLG3RRf6N/8IHHdAYbwdSIXFwYapQtd3EmiA8mx5Zf8r/Vevta2lUg614T/ba0V0La73PXp+mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOx5yOJqoziBGlhumIWzUwHOJL0zjroxWqv7eYa409Q=;
 b=FXraVAK1F3g/XzC/qaUJQ8l/Gk52d/CJbnVHXLopqQM6l1QWzall1XAZhXrlSPjpmx76QzbVVg5YSTdGDr4/YLzuKsiTXlxqZPFwcbBzueBEOVDy/FJzNZfa2mY1f1cgcxQnUl5AjNCCgsXFN136PIYkcwUZuwlPZ4cd1bBIl2c=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH8PR04MB8686.namprd04.prod.outlook.com (2603:10b6:510:253::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 06:17:29 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871%9]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 06:17:29 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     kernel test robot <lkp@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v3 1/5] scsi: mpi3mr: remove unnecessary memcpy
Thread-Topic: [PATCH v3 1/5] scsi: mpi3mr: remove unnecessary memcpy
Thread-Index: AQHZJJano+4fATD/i0q7yMzuT/L55a6XDnEAgBrWcQA=
Date:   Fri, 27 Jan 2023 06:17:29 +0000
Message-ID: <20230127061728.msjyh64svhfbosdt@shindev>
References: <20230110015538.201332-2-shinichiro.kawasaki@wdc.com>
 <202301101210.Wor01HkH-lkp@intel.com>
In-Reply-To: <202301101210.Wor01HkH-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH8PR04MB8686:EE_
x-ms-office365-filtering-correlation-id: 372fbb8d-f137-4701-8eac-08db002e2ae3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YHxTa5ZZ7uZ42Go+wFskk4pI1zX4lFEJR4/6LegZU7NtW8Hde1X9czKEdZ5te0Zys1H0wvjvkR+wBSXERb7ogSWwb5QLJ91ZqL8iEOAKQ4AVgO4EdIWiZckVxBrREebROBUDo87FK6WfFVHNCFx+Y5Tjv19+RRRaGN7CH2srvrHvs7f6m7QvG0301B2RmBAmaHQXPTzUqWGLcc3iLF+5zOVgDahVog7B2YtrIDvj7Pfc6ggJQyUabBoliamFFV2Vwg70twWwFBKh+mFV9EBA2S06NhaGCHyQIoRph5SD0d/eE4xP2Na04dkHJaSED8j8ZdspdA4AIYpCuYMrd5pAFJStseVxMp2hyA6/2cDYNI+iUAITTa+f75EoWqvlQyW+Aoy/R+kYFV02m/sJ7j2C/qd4dE2mQoJydQaaaAx/yzCa1CYRKsfgY1+HBdmEMYnfgEpX+54RFrZY0AIYWgH/r3P/l13nPYWoOsV0igmkqcf/Z5fCwICa+OkUN5Ql5b11f1UhL33NLZkRqOniwgOcmSCMCJmKIfeVx3YX8PXuX7uOKNugNoMDG4s1EUYx9kymOBQOPVLNYNGvZoPFdTvtf7e/6ntiLIR5UkyX2ux1VR3vQnVuh+O3UimcB+eTrZ5TowKIkXMcB073j/uajeZhihWt8k8WbrnLMa47OTrBjC3YLsuZg/IOO5d05ycElD0cDDh2CP8AsOkBSYN26lj+60izSI05PgdjZ5TazMtGrPwZaDKXBtMPxJFcwgjoAEvSrYeADkNXPcF9rWdQw9mP0zGWfLva83DJGxa6V3pGeYg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199018)(2906002)(5660300002)(41300700001)(44832011)(83380400001)(38070700005)(86362001)(122000001)(6506007)(38100700002)(71200400001)(66446008)(66476007)(66946007)(66556008)(478600001)(76116006)(966005)(1076003)(6916009)(6486002)(82960400001)(9686003)(186003)(6512007)(64756008)(316002)(91956017)(8936002)(4326008)(54906003)(8676002)(33716001)(26005)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BqRYmiAQMPwgIbevN8BzmH50pI1bwZy7KOn9z28lkh+Guy6LfeW1JHGpShue?=
 =?us-ascii?Q?rXk8ODBC6+E/5fpkQXWZ0RmL3DGkWcVSb7Kx7Ar6CLA88Z4M7xyYa385RiQ7?=
 =?us-ascii?Q?Yn44RXNWqEXUd8MkEEK/SzvDd6q+R97lKIiZDIL1keFGk51DWXvntIrPjc5Q?=
 =?us-ascii?Q?a2mxhbY/4V+YbJzj8S7wlNXhY4WggMmjnQLdm27vJG8sxAPg+iK1rIHQecxn?=
 =?us-ascii?Q?hkILDYuIrzpuHc7H1AFtIhHemoyCMHImr/TXIkrJ3Stz7YnIlle+9e6N0caY?=
 =?us-ascii?Q?Vn1RKapqQfsBbeKuv+cx/z3j27fz0iHSaTY1wmEeQSDCSP91GZQ0TRs4fCjo?=
 =?us-ascii?Q?XaF51ekwuo0ckuDMsQfEaYNvxiMJ74MFNjAIHs4okd4tgBRXWsX9bt4/mJ5F?=
 =?us-ascii?Q?P3npKC7AzIQDjaf7EJhX1XrBhHH1MKEdVwJZewpgWPadt3EQT5/R//FgcstO?=
 =?us-ascii?Q?TZ33ULGgD5f4/f/0O/voS6/LLixHYM8W0Kcxhgmbo3FMdjSvil9yeBPtwRD/?=
 =?us-ascii?Q?m6WyGb+4I923MidotiJ+d+N3gOQjk7P0HuqxTZRcFMZWrUmb4y0ried1oneT?=
 =?us-ascii?Q?Rl00NrkiCAWRtO6CpgEgTJ1wPO4vYHC4Or2PF9YMjSHUyS9zkDr85nxxdZ2+?=
 =?us-ascii?Q?K1tWawKp+AdhY2KeEWgAeAXGP1bUBdsij3WS3PJSgfNu/AfbvPie6NoRQ6V/?=
 =?us-ascii?Q?dM6DyTI02h+WfLtDCAQRG0QTnNegAftCd2pjSA/lr9mEQZgwBOQR5DRApFGl?=
 =?us-ascii?Q?eTX0qXTjYjZKqaBMVQxe6NDStKJ7qaV+LrTJzbLK3nUxOF8H+hcaJ0uVKp+N?=
 =?us-ascii?Q?3ZgD8vs489uDmjmIzRr1QEvlOzy0vTm5cdcFjnObV3QPBhilM9mKL++KF23X?=
 =?us-ascii?Q?4NDJItygvkDi2MeRvYzJWRMnX66eo1MyGhQdSfEVu6eUnCAhyHeRRbIZiibg?=
 =?us-ascii?Q?hRHyQ00S28I5CBRCQUTOGoNayG+wBTvYLGMqs6ij5Poae0LzzlCj26ol4wQJ?=
 =?us-ascii?Q?+nG+JwqoQ80JkCdMR+PSSIZ03Yq5irdP8ozbFEhmve1yUeBCvmkOQKXJ5v1H?=
 =?us-ascii?Q?WtEQTnJykAnsnB+DwcBCHF460gKWhLnUiiL2PnYLmE5+zxYF1Lul3dmgSjWj?=
 =?us-ascii?Q?pGTmawqYdBashPPBxpb7KeY04/NvKC22EDaWXKszENZTDPfuKjFOXOE6Xw8B?=
 =?us-ascii?Q?20TbiCJbIAgPt3tLf9xJBdx7YDXLcd4mbq6SkQsJeIp/98C+bCxJRfniEsJp?=
 =?us-ascii?Q?fsMhZp5LOuicf/RADPKmhMwLj137thqcwon+KNeZ/RmyLmE6D7IXHh+xz4wO?=
 =?us-ascii?Q?3MeTeXD+x+JCck+t2sFeLSiqnFlNqt7tUSTb6iS5wb7TY39atWz7fDbDGjDQ?=
 =?us-ascii?Q?VbE5+HMK8IeG9cbTHPTOxlIFJz7DTi+wR/RNq+uDSg+ruek/rmlIbmdcyJBr?=
 =?us-ascii?Q?CXLvV9xDQDkBtH8zkjqU7oytiSJ3ZlUMVbIyGmrqSutaAU6UemIQlMLTpZ7i?=
 =?us-ascii?Q?0LcyQ9v6kUnorEOyZR60FG4C0qQSwiJ+jlE4Lb2mbrlCpPMA7HXSrYZwGLJ+?=
 =?us-ascii?Q?tVEcRpO8bwhUoudSTe/i8fDh2qOhnbh6Z2sWHvUIWDH6RumTHFml6O/3duD5?=
 =?us-ascii?Q?t7nqaZO+y32i8/zhSvTJe4c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E157827F783B84BB5B7A9E276397650@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PjnOwSyReBWnWWwXE3ley2aDFnv4ARH8T0kGU3DPkkyocTKLBlD5xDE06CCaLnHCvcYhs0gP79WJMapG0vFDLp08bpOp9O3TRqK8WcbU1mqY9iR94hxvvQsdWSCaqhGcSHekz7x036MIzLUV9TXaikiQc88FyVyTpueUjJCvZRbs5Ov033pakuP04gZJ9g3qZcIuyDTf2dExdrO7J0SFAq3iebJZ407/ouNJI/mHmxZakBa0EH7GAJks5Uld0pJU+hKjup8/w3PJXqJmIkSGIL34RqRKOpoOIJKyD/KEKUsLMbcyyIIrJnB3CrXLlUnJ5ojg1rvF6uSzjp6VeAxYx9roy7CCYEE6xV1WXO6uUjoL4KBL0NOKiH1CgExWFNs5y/2bSrI9Avp1m/ON0S7CeRcCdXgewVM9pM3aUyH4q3K8+eGhIC/onmx3YT0uGwgPbf3DqI+BxivBv+NF3fU0kRszYyzQYRHXrIoiReaudJMhTo1SNSYSLrqkx4wICDylgOO+HcCgaUyZZ1zyVqLh8ywvblnuSj/+fvl9lceYVaYamoHszQO7RvfFi4ghXsLMhx7AySoyBs87SvM36gnuW+vedXeAdWf+VlpX5mJsVfmsSxg8wKpYEDnplbp0QZM2O/0S5ab4dCrQ058HW7pawDs17N5vLJ+uy3JLg/Jw7Jst+ub7fKwxJ+R3cfN+jLqFusabjZT0e7kRi/sCCBaWU+tud3jIUeMl8P+/pof999SbpIz6qCZ/ZvRVT1qp4mg08J99spnJ6UlVo6F90CbqY6nBOW2iv5+2p4romFgCAoJiYws2odZv0i9Or9yP8A/Br+nlk9I84iI8cnHxU2XC1+QWYLv8nkVRhdzlAimwKPSy99ThkTqhmhmtQi1dQ2EyrqQOdjS3bsscTeUAjz6xuTzWX2hEqSdLmwOWw+aE2rk=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372fbb8d-f137-4701-8eac-08db002e2ae3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2023 06:17:29.0795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: esTZmHi2deYGhXuru0s6akuQXfbw0SDp70GwjKrGROPrLNg83Ys/Yymq5FcED1eRsRMUIfeZjFNBEEEfV/ysf80Tl0DheWkgbXRgF3d/ovI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8686
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Jan 10, 2023 / 12:27, kernel test robot wrote:
> Hi Shin'ichiro,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on jejb-scsi/for-next]
> [also build test WARNING on mkp-scsi/for-next linus/master v6.2-rc3 next-=
20230109]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Shin-ichiro-Kawasa=
ki/scsi-mpi3mr-remove-unnecessary-memcpy/20230110-095717
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for=
-next
> patch link:    https://lore.kernel.org/r/20230110015538.201332-2-shinichi=
ro.kawasaki%40wdc.com
> patch subject: [PATCH v3 1/5] scsi: mpi3mr: remove unnecessary memcpy
> config: ia64-allyesconfig
> compiler: ia64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/fad43146fb864da81=
24537dd3a548f9c638cddd6
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x
>         git fetch --no-tags linux-review Shin-ichiro-Kawasaki/scsi-mpi3mr=
-remove-unnecessary-memcpy/20230110-095717
>         git checkout fad43146fb864da8124537dd3a548f9c638cddd6
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Dia64 olddefconfig
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Dia64 SHELL=3D/bin/bash drivers/scsi/mpi3mr/
>=20
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
>    drivers/scsi/mpi3mr/mpi3mr_app.c: In function 'mpi3mr_get_all_tgt_info=
':
> >> drivers/scsi/mpi3mr/mpi3mr_app.c:301:18: warning: variable 'min_entryl=
en' set but not used [-Wunused-but-set-variable]
>      301 |         uint32_t min_entrylen =3D 0, kern_entrylen =3D 0, usr_=
entrylen =3D 0;
>          |                  ^~~~~~~~~~~~

This patch removes the reference to min_entrylen, and the 3rd patch adds ba=
ck
the reference. So, this warning can be fixed by moving the 1st patch in the
series after the 3rd patch. Will do so in v4.

--=20
Shin'ichiro Kawasaki=
