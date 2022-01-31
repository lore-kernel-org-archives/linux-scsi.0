Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02166C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350840AbiAaLk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:40:28 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31495 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346374AbiAaLhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:37:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629060; x=1675165060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=du8SxZKjh8REh/5JYeNGUVAvcBhzplzCQ5rq1Azr1jv3sBfSqqj8bQqy
   fSbamUho0BLssHYALNmRF4WQVq9hxOG2rs7xHecQR5b4C+f6bNd0qU/KS
   dccnKXB4faUXqT1Ni3TloT4CULnA+N9VKYh5+jpUSuRa/lx39T0zfOn3d
   F4Bh8rQpeaxdMUhYw4ENVSAqENEJ5gglkLr1Rh1oGu8AQJ+4ULm1mqOAk
   wDEU72hGVOo/mY3p6bHO1HOW9XhnecNAwigiGr4BqU0Kd8/YUcwr+21oJ
   L+zCSG7Lj7EANkgD10mlPAjGcifxcp3kCHD0XIuU7wR9WGImNzYhODkHD
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192789821"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:37:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvoflYLZtquCLuFfQ9kXIyuSZQjkGeZOtNgPWkGZg6gO/au8jj4WkqbUJz5aKD7YOF///RUOvMdKHnmMcPmdgrpkfSDYy3PFiV/QHq3t9xTHFBxbvjzj7ofUfk337GDX5IH7fzPeX77BscYXLpFaCrFSg5Jp8zmTwHDBSsghe8sfOgQOtHEmE61R9slQ1IoxvmTvPuMJWBo/qxvLR7Bq/CNyZddefJqf1xBO9pOJwoCdXU83JnuB2Tmf8BLVYCF5BMvZLByotZdHKcH3UV359CdVhdkOmmD3vfT+vaN6/wcPZCIDnmvjHPapgthyxZskXBv/i5xhiLG8PP8F2RdLQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=fAGGwKitfDze6nVDUcaDKRciX1XrPFpgLk4rWekVMfXvNwGCM5oFCfNmw5ol2H476HGcHeemscVC3J/1gqB9ECUfHqyWkQbiY5uCzKrgFG9B6GZr0X0KFejD2Ag3yZUmWly+eH2YQmet7axpLGxHQFvtAk4fsw1ceek0l3CajK6HMNq5vOIgku4hNBraKzJB70DWyjWoV45EIrmIJxgNkiz4YUNx3JG4SBGW3KqAMj1AiUv+qU3v+FlL7fSw6kSbzLNYfij8JM+idyGHFreLAx45pEv1nE0m1NIX7oyLSx6kQIVkynbMMDvtLOBUe5TRPbZKWkbtRZ/0HVtiuHVsPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=UiFyDi9uDzDpNJoD866OkKn2q6NkESuv1GVkAjU7tNwjsKfcVCaWQ0FxTd3EC+6S8GAghyoW7ZM9/u4WusKoqX2ZronGYQo3zF8UKPGQn/QUv0O7gXvI6u59FTbEadBzTg6STABmMGDQmF/vci7/7EMw8CqM3EL/tmywL63zbUI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB5272.namprd04.prod.outlook.com (2603:10b6:a03:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 11:37:36 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:37:35 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 34/44] sym53c500_cs: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH 34/44] sym53c500_cs: Move the SCSI pointer to private
 command data
Thread-Index: AQHYFJWPdVfFKl3E2kSLNcrfrztqCKx9BLaA
Date:   Mon, 31 Jan 2022 11:37:35 +0000
Message-ID: <48887d48f1f5fc2fc34163ab53cf124229b94fb3.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-35-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-35-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04b318fa-d1af-423a-bf44-08d9e4ae13ee
x-ms-traffictypediagnostic: BYAPR04MB5272:EE_
x-microsoft-antispam-prvs: <BYAPR04MB52720C99FD69E662B85CAE209B259@BYAPR04MB5272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PT3xm5YVjh+IIkA2BszzjTcHUxLrkrNSBM6dqcpyxWSHVAWnyszEHtYqatpW7LwehNkxYoSkrXgMWs67JqdVyGhFa41I5cQQIZh6hBLac8SHtlWqZhbaU3XsyXZ0D+2Tx2CRpefVfVFGcC5sAj+MVal5qk8mXwT2cOdFBilqRgrzSwCbrBG2CusuRoK8iFuit0Lili9R+iI3zLjsIZT58Jw5QJ2vMn/QVRrLUOHnW4OHFZkR5WmeONTnZqT+YhodsMB6nvuODSRtHAfFtHUrlDwYYqoMjoG/e5fy3zgIGm3g5puQPvKw2aHaAEqrVybryM5u03XxdikQktK3Xti0EQWzoHqEvcLxVnvvNXgAK0qvniKYTvdQcu7to/KEjRzzOpr8NnWqoZkOcCryuqIymPDrTjtv6J5vmk1gohPhotBohYknJFgzViKrHnLsRNSO4Hrlt0QP+cCNuHCHxg5MTeNx2yiy6LJ5OgNvY4owkmDZ8nil+OJBvSvTdOSPBy2HmPqJ2YNp8Y4fAIsdH1RIOWRi1RdD1/8Tt60gr2GKUkx28lynL4b1cTMuzOpE5hKGehcfQ/dj7c9iPnJg36Gji8Vstgs+aBZFVsfCiq+DZipJKa/ty5wKMaHqUsTKUwAKoVqkwFFKkTnjdrZvlUDuBkAvm0PAxRjnP/hlhRCqOA5wOTyXeg7zkaGkWhhsDuA98E/g9qyTeTRkqvE8E4NFOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(110136005)(122000001)(36756003)(71200400001)(558084003)(26005)(508600001)(4270600006)(2616005)(86362001)(19618925003)(5660300002)(38070700005)(186003)(64756008)(76116006)(66446008)(66476007)(8936002)(4326008)(8676002)(82960400001)(6486002)(66946007)(38100700002)(6506007)(6512007)(91956017)(66556008)(2906002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zm05V0Y4aEdxRUh1RmU5d004cUN0bWpZbnhONmV3OGEyU3h4RHcvS1FielBU?=
 =?utf-8?B?UTlNMktHZFFHRm9jRUgrNzdUeXJsWk85RW01TDMzM3ptNDVzaWhjSFBMK1pF?=
 =?utf-8?B?QzZkdnliN3NkNGZ6dDNtSEdDSmFoOHVnUDlZN2ZUN3FRVDRBY3NteGIyclhn?=
 =?utf-8?B?cnZ1Mld6STFYZWFTamUyWk1uck5xYVdjNllDNGNINlBWeEZNZk4rQkdQeUFT?=
 =?utf-8?B?RFpOd25WeklxSjZBZFVYWEZsZS9UUjNXSXBSbVVLRWNKcHhWSy9uN3FtUFBJ?=
 =?utf-8?B?eHB4SXYxeXViWGpaRDZRRGtxSkJ2SWRtZGFxdTRSQjBpWVhCUFVRZTdtWFR4?=
 =?utf-8?B?bHMyR1AvS09iMzI0SVIySDh5WkQ4SGd6cnF4U3dsQ09ZbmVyTWt1ajk5SWlM?=
 =?utf-8?B?aTFKTFFTc3NQV1EyRDJHMzMyeWJOajY2WnlvNVI1anhtSkdNSmRYaUJOZjMz?=
 =?utf-8?B?aTMvOHVaMGU4KytMTy9CT3dINVBocVhwVlhuc0NrM2ZVUG9pUGhTVUZHNmxm?=
 =?utf-8?B?Zk40dkJzd1RrSlZSK0diOFllaXErVnlWYUhDVlFnTFZ3UWpCZ2UwR3lYbGxt?=
 =?utf-8?B?Mk9TQW5vTm9kR3kxQm5tZkx5WkVwWmZBbUJ4VUxyTEt5N2ZSYUJaOFlFTFFN?=
 =?utf-8?B?UHJMeForM2x2ZnJiTEFSekhvQW9xS0FCVVB0Yk5LSlFWUVcvNlVjVE15cDVC?=
 =?utf-8?B?TDhPYXhtYTlUdkRKcE9lOHlMbkNBSHlOVXpNa3BOK1J6bTRaY0pPVGd2ZlNz?=
 =?utf-8?B?Ky9sa3RZY1BSOGoxRkZ0TmZ6Q0tQRHRVOTgzL2RlVlpodEpoaWhJV3liRWhX?=
 =?utf-8?B?OUZXelpCeG82eDkweldHMDNkY1FBcHhIMzhOYUUxMXZjSHVBVlZ1ZG1HTVpj?=
 =?utf-8?B?MHZxTHdUNXpWYTdVM1M2MmhvRloyWXc5MGY5MHQxMnNUNU5sdW40eWhqZVRJ?=
 =?utf-8?B?b3QvUDZyOXNCNW1HRWRNVkk1S3kzQTZhUlJLQ0ZzK2Y0dXBUUGRHNG9LZTlT?=
 =?utf-8?B?RFZ3dHlLWU1NdUZKdTR3bXBKQzhWa2IvMXF3ZjMyZndsbnZ2aUhxK25LSHVX?=
 =?utf-8?B?d1N5bHV3YUhvd3dOQWRPNU5jY2NjcE5IdXhNNkNUdDBRclgveGJsZGNsWU5m?=
 =?utf-8?B?MHd5T1pHR1BQeXl1TlU3MEJ5dXI2KzNWSTVGNnNMdXVud1Fic0p0UTRZbkpW?=
 =?utf-8?B?aGs2OWZCTW9oWmJDQWJVV0J1d21RcjBWVWFZT3l4czdCeXFYY0VZMEJDVHJM?=
 =?utf-8?B?cHQ1V3Rhd3U1L2xpeGZnK0VVQkFSYUpGMlA5SERGa3V0ME42d0hRR0haVUdX?=
 =?utf-8?B?Y1JLcVNESmFoNmlBelBWdnN0Z3ozY2lXTFFXM2ozKzRNYWhYbUhQcDFMeTVF?=
 =?utf-8?B?YWZiYS9zQnhtNWNNUUpDN0RMUlIxL2tZOUd3SjNoRmRtamZZNnQzei9RRy94?=
 =?utf-8?B?QVVNWTJVNm9FMHpRMEp2Z2dTV3Zad1R2aktmNDZFZVhYaVFNN2tKOGoxNHQy?=
 =?utf-8?B?bEJ3dkQ3ZnBoZlE5Rks4V25ucjZJVkJadnYvVDQvT2I2VmRhUWtKMlRyYmI2?=
 =?utf-8?B?VjUvazJLeDRTUDhXRll5UHJISEVzc3Bvc2YvQkdGN2NkSnEvdTArSEpVTUN3?=
 =?utf-8?B?cjBIV0U4MHlKVGZuMktkejBVRERrWWJ6cDdwc2dCZ3czQS9idU5hOEhUV3p5?=
 =?utf-8?B?UDVRUFFVR3VnZ0RMWW52TXFDRm4xSzd5OW1ybjRNcFZNUlVZSWZFakdneHZQ?=
 =?utf-8?B?WUp3SFpuMXNKcW5nQlhKVWZKSXAvSTZoSkJ3WXlmTkxEbkFCMFJZSlc2MG5Z?=
 =?utf-8?B?Wis3dEtJVnIzbDJGRUYybUhlUnFiZXh2S05nT3NhOGIrcFBxY0ljbjVwYlpX?=
 =?utf-8?B?YjZndXJLVzJQd3ZrRllhVjFvd2Irait2Ynl2eC9Kd0JDbGVuSFJDbmNCYWV1?=
 =?utf-8?B?cHRaZXJUSFRxOS81bjJ0aWtEY2c1eHBTNkYyVm51L3ZOaEI5ZzZMY01pTVow?=
 =?utf-8?B?NjYvUFY2ZjRaMmlQeDRjbUxVa3phb05LWit2akhVVmlGUHc3Qjllcnd5ZDEx?=
 =?utf-8?B?dnhIdHZIY1o1L05XeVNNL0FlbkdpR3dFMFh5TVNmbnV3VEpGcm1kemFNRDll?=
 =?utf-8?B?bVltOG8xcXRTLzdBVkRkRVhFVzlLSTl1cjc3REV1WjBoTFpLSjNIb0NvK1JE?=
 =?utf-8?B?Q0c0L08wUk43T0lCM0MvcFFtTjc3aHEzSHY1S0hldDNzMHJSZjZTbHcweVA3?=
 =?utf-8?Q?hCod0oj4IwVntJ4eKWhdlnId98114E/WiY+0PqFTIw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFCBF8323C20FF409CC5EAF56E2DE812@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04b318fa-d1af-423a-bf44-08d9e4ae13ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:37:35.8242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /dL4jlCw3Rn3ZbBIeDCxbIMCo9fxdD3WqCFJnO7jgP6tSCJt4FfxC/Lq05u4+sRiHLIuOB07EVhaTN4Iuq41rB+Xeuk9Z/r+LQ9ixFOaDDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5272
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
