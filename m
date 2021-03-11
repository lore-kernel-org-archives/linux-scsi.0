Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B3DC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A1364FF3
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhCKPyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:54:35 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:51079 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbhCKPyI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 10:54:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615478048; x=1647014048;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SZOP2aH73tUtsChRi4pDbQAb9DhLB0Kio1vATpzzRSs=;
  b=iWOwMbirEjZXZ6AEyuUYNU33uTWiOvrADfEVszHQnFDGBpkjKdRJhaYs
   iTs9WIHcxaF688zIWXzal2kQFgAifAY7f1/pznnOTPYpAY/L1lM7+sQNF
   cbrnWgwkVLJbSTD5vtTfhRMdp+EsNahFZl32pRFqWYD56RQSNUkTzx4MJ
   FcvK4Vx9AsTzGdQ7J5qeNffGixRSZnYsEckpQRArd2lBX10seixx1NZgw
   Z+okCbQINvimabkxd9KYv0r5oapLKDbwxcpdGWnO96kedEDMZxOk46b1N
   K0vKPwRm/0V+2ZJ/zrzw0Cxbl+Ok4kuM2aaE3JChDTxaAJIdlpcw0hHQI
   g==;
IronPort-SDR: JNlwNy+e7foVrOB6myNbh5YZsy5DGuVIELwGsOOLS2psSZAzKOZb6yGj4bm0WDorst/LeqQHxu
 eri6m1BjWCZgHoWJ84nAIZeeX2RGWCPoZc9/PZNw2Q3v1et66RLVjeviApFtGMUS0bgstHYlIs
 jEX2wmHydyXM+30inWwN7PoWZ9zn0TLJg+zfCRXjfzreemXqXWqHFEzIg+xYNFZIFi+2PVodRK
 UX3DEHuTVE3O4ldgHFzvjUwMIo171UjhrW6eK2gs4a2h6vjrIFnFW23vZ1jUaJI1hbP62tNCB/
 UZU=
X-IronPort-AV: E=Sophos;i="5.81,241,1610380800"; 
   d="scan'208";a="161914184"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 23:54:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXMrMlWKjfk9CUb636XcYM/bYCyvcPZVpAuRu71RiYhUExd3QBndh8dp/1Hbfmo1ABHq5nIbNspbeB/k+bCpBDsxy+wDx/959joubuq3SZBefrq9vmGIhXO4YA7JIrRP0qhRU0BHedymUfXm6BLLhlPGndQaCr4zEdHiQBFZwoEi9YAxAPeobhNvpyFEkdU1z2eKS2vQybY3j5xQwM4xgs90R46TnmsS9WXzr3n/J3WxIRM5C5XB0FImNSWM7mqfix4AcjzRT7luXRbi28B4p/pEeDkWdLBxl9wFEZprNZSdHz301tiHPuQD731uWGIopY4Uf4mJzMgbaXrM4B/8yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZOP2aH73tUtsChRi4pDbQAb9DhLB0Kio1vATpzzRSs=;
 b=A8RirS2ec8+JQhQ6hWM8qi966JURnWeaOfeYRBWW9icD0ap/xGeoFhwP3qFw+fNvygv44lGyfc5H9854i05AHLWRh+nhFMS/4qnrYe8L+Ai6T1puPl5mgInwMfpHAN4ByRG/jlDDorzTXJOhtjuwhbqU+iPT9N2GraSCwg1FWdYLryymEUwcpVINOJ33aIxHzzbP14QIb84jFVr8IdFfcl0KLZJKqBSC4ehnBol2R7GOZAHBCBCWK8fms1HtjS3F9cqrwkKOwDik5IJkZJDaGsi+64u1QwEPRkg8gHBq7XMBCN13u415QCQdQLiZEDjBjeo8Xi4nbCsXrlbdqo2nuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZOP2aH73tUtsChRi4pDbQAb9DhLB0Kio1vATpzzRSs=;
 b=PIdXJ0YovAahhK/DvcueCPS6x4INRvTyCb7/RnLcpr09sI2L7EXS310mV7vi1SCWtMkGYJE1lozoiosEPM9Fe7RpbpBBzyxIFJL1OvRg/leyDhD6HgKAM8K7yzlQGL2dn8XdzHCrIY7VGSd/H6sfTTj/c4Lofn35NdM9T0sRvE4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7318.namprd04.prod.outlook.com (2603:10b6:510:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Thu, 11 Mar
 2021 15:54:06 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 15:54:06 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Thu, 11 Mar 2021 15:54:06 +0000
Message-ID: <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:d87b:bccb:ca15:1ed8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a7388675-5859-422c-3dd6-08d8e4a5e6d9
x-ms-traffictypediagnostic: PH0PR04MB7318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7318B0D6458C1BC0ADB5AE819B909@PH0PR04MB7318.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7yv6zOc88r6W7/9qmV1wfFWgQRbyljoh4qF4iXGSgeECFXatni5z3jgTvv1o6+ZEFBVvCrY54yiVNkWFoyfGIdQtGSNo9s+Ms3qvfVFZxLChnvGC0U9caNZGnLyBzMopUXZNTB6S8XzSVhHOFTq4vGXrLl9UkXeSYNqIwXsNYnTKEx4lsRB8zQKcIcR333303coDUSl3IgCIgb6VDpN6f2USn9or1XT0Bi5Yl/F3q0R72iZapiVtgejSrllPdCvYNhPwzyD+jesp8iXFJLVWS0jTQv4lig9nKkp97ZgiuDcnipIM07wQVfQQbmSXD1fPL2ZdeSt7mtLI6QLxMWCRD+rVCI97Wwe8KLIXLmQsIinxVbmnR8BG4mbcbf8pzym/YCdlcunbLp6UW9+216yDhonPJwQnKMaKqC+8lOBSPHZMZzMbsBDaDbNbxpw04jBf4Dg/jX6itBbasgyefatewKtWASGhQ/m+kbyjU+XB2HS/1iZqk0SvHb/bUG5153UMTXaZYQ6VDiWkNGCRtS6uHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(5660300002)(110136005)(54906003)(2906002)(6506007)(53546011)(478600001)(316002)(4744005)(186003)(7696005)(4326008)(71200400001)(55016002)(76116006)(91956017)(66946007)(66446008)(66556008)(8676002)(9686003)(52536014)(86362001)(8936002)(33656002)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9khoxvXHX692BdUmJ65AH/1VT6B1milhKt9typFoSoKT8p2ioCHJVq/vndUq?=
 =?us-ascii?Q?aq7hXqxhOTXE27FpP7KbW8Qwy6riy4CrgOVbesfL4hwsv5Dx4yuY5fmnlKod?=
 =?us-ascii?Q?3GqH3wiiC93MYmwIuRffIVsZgJx/is92qpTdtXAqzCMOu2+CcxOR1JP2lIU2?=
 =?us-ascii?Q?fRp0jHWoZPPUiBjrpknKR8NSboLOi2CgVdgcN28ZPOuYUBXF8sTG2dYOw0lG?=
 =?us-ascii?Q?glZ7zCFSdxsL5uKxDpmiLv7N9gVGgOKWz6jbQWwNh3NAbEbSsaMy9DV3gnPF?=
 =?us-ascii?Q?0IoVYumgLlPFSkwQGMc2/iZkviOFo+YQzmNcJSUobrjqiHGAz9pvy2453NrC?=
 =?us-ascii?Q?PeLzLuc8VUu+Qg4Beqqa5/LjU2bMKHAPMy5PBcAOUtDzVHnL94u2dfhhxFK/?=
 =?us-ascii?Q?4B7TcMhJ/cg6rdwaEalBGCuUf4zBE9pAmpzeFvY3O8KXAJA1ZkSJT39rr4Pc?=
 =?us-ascii?Q?QKUnNJopjUxzoIEdpslvkHoiDVWS/8pqFmPPzbtg2kADNyKapneS3xQuhua4?=
 =?us-ascii?Q?4oxJA9UtLbb2sWpiR9ggRiGhWCS6jg8oVX/8QfG5O19RAyQ0AUIgb9lIScmB?=
 =?us-ascii?Q?F26QG4tjW07dmPL495voM65hu26oB6+dEKDgcDBRtYsEc/oNDbyCHHTdJqHn?=
 =?us-ascii?Q?P+9zRe+rH5GdZrZGfT+wqNXWy67HyHlRbDhJB3O4RA1Q6gzkD5AmAJ9sLKo1?=
 =?us-ascii?Q?bPrXwzM4I8GJmb6AO3RvJ7Ncd0zsXyIp9Me1P42gJqoW4Vk02lg9FYiOUgX3?=
 =?us-ascii?Q?xUbvErJVnYS0+0wKErNUVsHJhJ03a2GcmzI5doFMpewSEFc6zBMeI9AnVRg4?=
 =?us-ascii?Q?IRa5rWlIPZ1Lgn6C7eh5FTzrbcOnOqISoy+q56xl7x+MD1jL/Zj/54yHAc1R?=
 =?us-ascii?Q?2eEEbC5S3m04RBMmHB07I1Vzxd8Feci3R0lvX8HnjJOMnGqst2NyQekMzVKz?=
 =?us-ascii?Q?fEebMhsf1ymnBdJz4mbx/zEjCPexPo4SXb4mWl0i3tqX7dZg16rOjSIO73hA?=
 =?us-ascii?Q?FJN7/GKx3B1VAXhQ0RILXXS5YHvEmqawccJpA33t9yZdOa2ZO8QDdUHT4ljj?=
 =?us-ascii?Q?3O4AYz+K5/mksE5YG7ASy9o1OtVgT+clydCgRb8RY+0Y/WriPqkdW6f0A+GO?=
 =?us-ascii?Q?v3/TSayXAJaUgRimfrFzzKv9KqxJpz6ms+1RCE7/LjYjlNtK3Z0eLU62Ka/O?=
 =?us-ascii?Q?676guYaNFeFzhfOIJGUP3C+mJLCulqHc7OAzaz9en7J0EJVdTfs6vPEuTVyx?=
 =?us-ascii?Q?KEV6gRM4620dmDnT4ejscoLN7+e0TIrmr8Y2xYC5U0XXiYchUcTA29cOzidW?=
 =?us-ascii?Q?UXWmZuOKDsf+VGGDIqT5GKxmSl0ZHblhWoF+MO1lTZbS7vZuAalkPbp5EVQt?=
 =?us-ascii?Q?6vy7WH28bWeVApqoCcR7fbVqnHxKMGvtoVGkVgHZCd0kXuubJA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7388675-5859-422c-3dd6-08d8e4a5e6d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 15:54:06.5454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4whsflUDcVOSFc/ysrSgXKWDm1UPq/OdM/eROCj53c7SdbptTmzubzYnsWCasnxjVNY/jgbgfcdZx3LIekhA5YQViHa2IYBbqPhiYDAUiPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/03/2021 16:48, Bart Van Assche wrote:=0A=
> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:=0A=
>> On 11/03/2021 16:13, Bart Van Assche wrote:=0A=
>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:=0A=
>>>> Recent changes [ ... ]=0A=
>>>=0A=
>>> Please add Fixes: and/or Cc: stable tags as appropriate.=0A=
>>=0A=
>> I couldn't pin down the offending commit and I can't reproduce it locall=
y=0A=
>> as well, so I opted out of this. But it must be something between v5.11 =
and v5.12-rc2.=0A=
> =0A=
> That's weird. Did Shinichiro use a HBA? Could this be the result of a=0A=
> behavior change in the HBA driver?=0A=
=0A=
Yes I've looked at the commits in mpt3sas, but can't really pinpoint the =
=0A=
offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for shared =
=0A=
host tagset for CPU hotplug") is the only one that /looks/ as if it could=
=0A=
be causing it, but I don't know mpt3sas well enough.=0A=
=0A=
FWIW added Sreekanth=0A=
