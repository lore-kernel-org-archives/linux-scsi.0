Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BB6C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Jan 2023 10:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbjADKMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Jan 2023 05:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbjADKMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2023 05:12:40 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26D01E3E0;
        Wed,  4 Jan 2023 02:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672827157; x=1704363157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G1brxrm47E+sizJ67bYVn5Xa0Mn3m1ABULMxOlLKZfM=;
  b=qUM88R+XRgs8uB05BWP51hyYmSq5QovAZCYJhB4z3ehw9XN7k+c4k+n1
   2kzBa8NPQtevToV6DF9b6EJkJ2KTri10VX0E2Waowu0hFxtsCZ9mCR+lQ
   0rk7bkFcsMh/zeCyjo+dKXbWgQxVsr0/disJSuknek3hIXNuknHjvaOA9
   16B6y8iS403eDyG1LLcyu42pVqPRdwQRbCGDxXJQVntJmJMYK+S98dyV0
   ze1xoHXK4D72Odd12g/YLYbb5OLJX1ozIG3ae8VNBtGjysSfpU7ckCENL
   TVPnGk5EOnpz70+u7QKApsBQniGMTQVOkExLsuDhyR9RTQ34CW5KFP2a7
   A==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665417600"; 
   d="scan'208";a="331999142"
Received: from mail-dm6nam04lp2049.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.49])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2023 18:12:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERSRfmzjw1oit1J0rdY8pcAnAavoCRxu6i8hT9HgCtsGGyhUb/4lqAfUUj3P3nOV45p4/lxcueGPVk0vryan1dR/QTdGX95Do3jSiG/VqhO/YvpuRQk2yqfFRJYOsSK25r7gPPYjG+eAwP4SgPoSA6y8cWdcSsghEi0T4ZOsK9EjzmMJYq/SnrTLB8Ilmld6c5DCY5nQhdnBTeanlDF+WGf5mKA7zeUwZnVJaChfDQzVLu0LnumxwidsiK60iiZxlFItvAZDJXWeqf60l2Rc23YvLW/VuaFb+m2N3Bs3gg7qLrdLAzHALvovdeRZB6PSIoE69I1/jtY24Gk+F7Qw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1brxrm47E+sizJ67bYVn5Xa0Mn3m1ABULMxOlLKZfM=;
 b=j4RdCSIxLDPvrKBZ6L4A9ayOzKL8RTjlBwVFpkwk1gTv7JbBMEBIxjXxV706GOrfoCERyCrdVbqGaqfcEyfn5CJjVnl39ByIMQ7Ns0+CeNIFl/d1mwQNVGXkH7WAPDEnbmHLaGnd3xEfvMsDm09xf8lwEzXjNS/o+lfwzOijsGaSFKNczD+fOREL7x8uDX009FWspxz5Vl9mbw3TL1sdcpQ4iwzMDj93gJuKv0Kq+56fooWNXzPahXY2FL4podGYaH7xaMVQF0GGeG716xfQLCYLNg2o5fe2nLEJa3Vb5EDPSIbSr9sgP6a9gclgKugLgXH0k7e6ONAb/CwRvBeTzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1brxrm47E+sizJ67bYVn5Xa0Mn3m1ABULMxOlLKZfM=;
 b=gz3EwAykGxoZ0CEMtDkHlDmVHqTBRtt4njOPNAp450y7lV7ECgkQKiSNYJGJbTpI4yVvZwvORrsbG93t+aQQkbzGYlW+HMLVbu1/zaMQUudRn7FQcObwHdBj3fh4Ow+sbFuSWFKZZeSholf8wLGVbA+p7Am3O4G6xYhcu/FM36k=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BN7PR04MB4241.namprd04.prod.outlook.com (2603:10b6:406:fe::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 10:12:31 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 10:12:31 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     Mikael Pettersson <mikpelinux@gmail.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] misc libata improvements
Thread-Topic: [PATCH v2 0/7] misc libata improvements
Thread-Index: AQHZG6cNSsG1SwXcq0SwZBLsVG1D6K6Ntv4AgABbzoA=
Date:   Wed, 4 Jan 2023 10:12:31 +0000
Message-ID: <Y7VRDQX4fvB2CyZ/@x1-carbon>
References: <20221229170005.49118-1-niklas.cassel@wdc.com>
 <49c92e50-5452-8c3e-1517-a0bb1e4e72a0@opensource.wdc.com>
In-Reply-To: <49c92e50-5452-8c3e-1517-a0bb1e4e72a0@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BN7PR04MB4241:EE_
x-ms-office365-filtering-correlation-id: 35885af2-670b-4294-6109-08daee3c30d2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p0vmQ9vtxZ1MeFo+EL12Jcqx6fNkSpL7QdgOPU66h961ivxpGPc7t2okmyhia2o4YCEt7W5C5ShWXcxFntNhJvRU/SwIvtbdLlgzMdZ0cLbpUY+aNjkgFKTBYtN5jSIDPCRDQbvsHFem82IpU6Kb5mw7TfoAUGM/2Wo0oYLh1QaJc+S6oZ/Puqg0GzsmozoJRvfmk40Zd7CiiVLo1mHDv4T6y9eDkLnWnY/ffA7Fn4VJc2ASvPNTeYt+REX9H3kxCJpMVSCQ5Xur5n4BpNP5BJMWsvK0SMr6Bp3VcndqLUt9wbezOgrX0+CAH5QdrdtqEgBvXufnBA7qQaamnkM+fg6A/wfwQmD82aHOlWiqL5nr1hznbPVFnwSt+7x12Oxxx8E3yMuvhAST2+lzgKEgcJodGOPZKFqTJ93axdA4aO/ejuvTPzcKSYWAI0odHZeK3oBe2ioKFCXWdO/2scitOegQ056W0s0WAKejoAWGLI5yIH/HZrwmopn/wUwSuJKMAr0MBq31mL6ozgqurTDmfTndqN8bLe2HiT/KzQSfqXXjd7dMDLJt76FwtFcB2N9BmCleXeVX1Rgvjg2HEc7rlmT/l1FFeK1g/csVHEQ5DJ721FPJU/+yoPKgfCdRnFqngFyhW+JjpuXWerfLuG+bj43CXalhGBj1/j/kAyc14pcMOfg+ryUlOHrYyaupW2hmMBpx+sguAr6l3qPsQvrgofaCEpmjU+YjMvN2ZocQZ0Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(53546011)(6506007)(966005)(33716001)(86362001)(82960400001)(122000001)(38070700005)(38100700002)(6512007)(9686003)(26005)(186003)(478600001)(83380400001)(8936002)(71200400001)(4326008)(64756008)(8676002)(6486002)(66476007)(91956017)(5660300002)(66946007)(76116006)(4744005)(66446008)(6862004)(66556008)(41300700001)(316002)(54906003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dhOV7guBe9E2QotPY4M2LYrAHXJQA49DLdOoFKCvnHvKYnRYPQ2YMSCvS9WO?=
 =?us-ascii?Q?TYjQn/gmic6KspKHmUL0MEeFd5jCiPdf8Jg01pFWYIM2+CcN1nK3dzCJNsBg?=
 =?us-ascii?Q?j8Oo1/DTwMKqeP64bufbr18Dw/wk5+SLaD31MYCdr8lORENpCaUdhfaK2rJw?=
 =?us-ascii?Q?Sz0wc6a+TIDo/pAYu1Kl5vysfUrxaX9jbIO6phQOTX4Q+TXoy7vW4bzED9D6?=
 =?us-ascii?Q?m2fbaRaJSf5CrPBFCSQZCsklbXO9Jh9byPS6nqFdiwlE2wvTUmipK+cJPeUR?=
 =?us-ascii?Q?UG8Bouz5QV+Zs30nucewkMTupIuA7jozq1o0j2b9RrXMNpcXPodL32MufGc5?=
 =?us-ascii?Q?tan2OSPuAMA7oy4Kamdpwudnxotc4bORV69JxTMZf1hCVkumi37AXQ51zvWB?=
 =?us-ascii?Q?P6dvsWSe/X4EX8aVUNGARziLH2Teohp0+0WmPFumjTvBwUQ5ZrmbQ1k829yQ?=
 =?us-ascii?Q?NKtXcG+tZLyb8RbR8ZC/2ev1pjYuegDkg7g9OEkFKArHNxpCMNvY4+3mCE46?=
 =?us-ascii?Q?+Gu+ssOxgQXhdgKpVgrnUZWR3GqyngrOe+N4X7AJMo58GBcRYX1PzBzDx2Uh?=
 =?us-ascii?Q?ay+XIxvvR11QNR2splNBQQdpjNOEW0xZacfEi0ZmoGvxCuxzDp7SEA7YnSVL?=
 =?us-ascii?Q?RvhzRMScpp3PjP6LtbVEX0+knpXcje74FFWlolzMT1p1wtbFZ4rHyM7Ci+bT?=
 =?us-ascii?Q?UTYsCLJVcy1D0fB1tcoR8wcpPmIrpjZMyrbo12X9uuPwsHdn8u4pAzMBCdta?=
 =?us-ascii?Q?S8SY7K8LyowjpnAusYF0R1VOfGBmB+70GtY0j5cj/ahzcneS/0Gc2AbhM0At?=
 =?us-ascii?Q?MMPez3Vot5KKc0qRN4BuaA6P0g0LiWQrKTMxjHmtNX36Yx0xMjLzLDs2ddaw?=
 =?us-ascii?Q?g42rWGAMsrJyAdV1BtuiYwlWIpd2dmBeRpg+JpZcw092Hz+jzX4kwth47owP?=
 =?us-ascii?Q?Nhd+0hmODcgiA2nPi4H8zJO+U0biRnB73rxyXAu6kzliMCmraYnGHHTxU/b1?=
 =?us-ascii?Q?OGNRDKcagOskPWKPM9j7xDCGQ1jM5uO5+d9FuD1/6ZqLiyNyqWy/HOlGUK+T?=
 =?us-ascii?Q?uTm9ijIDnBpKu3lLEcbmsVUyJ+zEEKgwvYvlAtoJZB9BtvMvK4PuArs7J0yj?=
 =?us-ascii?Q?z2Ak5ix/VAISo60UIKkLRHcwKMdkS6c6NYBPk/gBEoRPed+J3DC76befZVml?=
 =?us-ascii?Q?XHDeoJsqZ5woyn4TkmaZKeL970R17K37ytbSmBoSTjM9Q2UNPdeNXAwh5BCY?=
 =?us-ascii?Q?4yvM89nxQ5a1FT7uErm+pZ3tkTxAlv+HuI68WMyVGlq3KysMhDJurDIrvTMA?=
 =?us-ascii?Q?Oz1AaVstnmSKQCmdaL24rDJGucAxca04jMsSCqHvr5ZYZeV6AU/74gKD7p3S?=
 =?us-ascii?Q?132zG6rJ8m0FwBM0JMxtogZcnRcBchv+Byx5taEEHWaIBDlq+hQsFKadWN+b?=
 =?us-ascii?Q?Y5TGsK+5GJULzVSdVO5/DYaSe86cmv+GHNiLKX6KJlGEpaC68aYNFRZqdHFm?=
 =?us-ascii?Q?YMHhwA2LUHRcsS3XstCeBIH/aCG86ub5wML8CduM9HR2hjIhJHoFDZH6opQF?=
 =?us-ascii?Q?Xvu09oVh0N/vA3pGQfvJfAD8Uu/LzGuhSo8J1gVk1R9/CxIz0aBGmebcGptf?=
 =?us-ascii?Q?Sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <42024D5A6E13604DB4600CA087FBA900@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gOb2+jb+4IS+eAnNee2fKu5MVBK6S/AGTrP494GSljTMVvTmluU66HCBPdzt?=
 =?us-ascii?Q?VQTVFdw0kWjSUu3nlAGwt27DIW23dqdPLdYrDi0FxNk7LX6svyOheICLAm4z?=
 =?us-ascii?Q?AnH2j3OSd00UL2XuN0RppBMtOXIyL8+UnC4bSOpfLpZ/PQ3eeOWDsrinCk7w?=
 =?us-ascii?Q?/BSB+NPwBvsj4obcM6+1KztXjk6yEABGOOvIFTsW892FWjDAQ1/YP6F65k8G?=
 =?us-ascii?Q?nXF8ndc5GPE2Yh72M5jSNcGgCgk6mfTLT7nDTK5FP6IDc0tL637xgHRTp/OL?=
 =?us-ascii?Q?3y+nwn01DaevnCnB/b6ykXEg6UfCdkgH6MZeyFhowcqnkdHqBFYS09EBXs6/?=
 =?us-ascii?Q?7hGGYsP+h/qoran1GFizBjLBEWlKIVEPCLDct+ZikRSR+LdCIGh+0AfGNjCh?=
 =?us-ascii?Q?NzZZuNno4PZ9lnzO9BiNQV6nC+uDcnsxIVN/ysR0YBQMJNWCNE44NdK3UMYQ?=
 =?us-ascii?Q?PC6zKyDH6Ml4rmrjRxayHmlb1L+ecFHRZpF82xot/QA5dx37Sk4yU6tunHD/?=
 =?us-ascii?Q?0K1JC+rTOCjQxtewQA4Fcl2w895hIwC6hZvTolXDr8BmdQxoHUzUN+38iiRp?=
 =?us-ascii?Q?c4iQ4197AXAZDodnUKxdglL8TxA8KPtcK6h4SxS0Fqo8phFJhqDk3Njp74Cz?=
 =?us-ascii?Q?jnHJIb9d0C+hi74GbReyhPXXyE3EphqzYk3dv68zMj/SZr+JjTvWXPYITHEg?=
 =?us-ascii?Q?uAX7B0vl1Yw7vXljOfsyHR5uOcNBk+5a5e4HqoKGAm4sKYXhITZ7Eaufwjlv?=
 =?us-ascii?Q?uR/SFjPZEDxalKswpq1/h6NE7nA/BcZoxLRb2ftSIosbrOzki7wJu5z+uD1Y?=
 =?us-ascii?Q?AQrhyFdrwIP4dHUNGLSxDKejvd3XLh6sHfmwwe7KeKfWCANttvS2IySTGGA/?=
 =?us-ascii?Q?rPG5tNnN/hbUSiCQHd40gjgZmqGGxCwsPSh2qM4oAGYPEZ7D2uPCtYpicjat?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35885af2-670b-4294-6109-08daee3c30d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 10:12:31.0263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ymg6mIBlV/eswIqZMyTHIcprDqo25atBog5u5OiRM/DvgRkGsSNB1jHSCqDZ/35tIRcRWs7rS+QJEICld2ReIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4241
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 04, 2023 at 01:43:54PM +0900, Damien Le Moal wrote:
> On 12/30/22 01:59, Niklas Cassel wrote:
> > Hello there,
> >=20
> > This series contains misc libata improvements.
> >=20
> > These improvements were identified while developing support for Command
> > Duration Limits (CDL). All patches in this series (i.e. V1 of these
> > patches) were orignally sent out as part of the CDL series, found here:
> > https://lore.kernel.org/linux-scsi/510732e0-7962-cf54-c22c-f1d7066895f5=
@opensource.wdc.com/T/
> >=20
> > However, as these improvements are completely unrelated to CDL, they ca=
n
> > be merged independently, and should not need to wait for other patches.
>=20
> Applied the series to for-6.3. Patch 1 had a small conflict that I fixed
> up. Thanks !

I had a look at the SHA1 for this patch in your tree, and it looks good.

However, patches 2/7, 3/7, 4/7, 7/7 seem to miss your chain sign-off.


Kind regards,
Niklas=
