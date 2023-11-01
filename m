Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133DFC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Nov 2023 12:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344070AbjKAMiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Nov 2023 08:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344037AbjKAMh7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2023 08:37:59 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D18DE4;
        Wed,  1 Nov 2023 05:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698842275; x=1730378275;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hdT3IEAD8HcDjqfBcV2paH91HQ/1gr1Meoc10AQ+pW0=;
  b=rkO16Ppc9MIu1xazkJ1vIdmT8DE2/junDR1ZvS7vx4FA+mLWPdi9dR4f
   gfOQlzr7U4a+djD++0hp9oNuQd4CAIv+klE0YhdK5H3Xi7vUiLm99BsGm
   5kbrSCxXRDvqWFOqoxgeZKcBZJ4HnaO80cVYjbSiHZwt09yD8w3m5UY/V
   /imG4PVS+HRqZ68UFX0FwNjfM01FWM92cA6kAzLw0pi5wfHfB8lLXysBi
   wohYvw391kK0oDIEofJU9ZmeG9lOdZ+t1bBQFb559uuSDFGubnTuWfEA3
   ZJmfFylDwsuiBr0zwwqPjtvs7Uz92l6nfU1dEx45MriGO/2rreBSxb/7G
   A==;
X-CSE-ConnectionGUID: s0/MmhCcSCmLXHOFRKnKwg==
X-CSE-MsgGUID: aSd3TW7IRrCNqFzFZDJMUw==
X-IronPort-AV: E=Sophos;i="6.03,268,1694707200"; 
   d="scan'208";a="1203528"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 01 Nov 2023 20:37:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oS1ItWba167sEFNkorm1yjPzpXhxOSOiO14i+rLRKBDm8D5sD4c7ZDD17HAP2NnAyRYhPq6GgzDbHsKyxIVXoMJiYSxHgrAK3GvL8nbIMGs/Th7QiVKsC3xCZEzPdQwPH7JinJIg8xoLjmsVx3aADIOh6r9dwXgOVu7dcdrppFw8wnPVh4eThVYPfxQjTrbqR55PVTDt5eeSW0BepIzKqHbT49PUa5RDSJ/tLJx359ZPX21Iy++NOkYUBID6U8BnUltZN91yCWXXlPiEsF3NhCAa66b73oyCagEaP/1p0pgA+ZkIx0iUSU9yXZp5/IhP1Hqzf4grN5d2H9QDmGmcfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W33rWysEIXWd1xryiFotbQwE7+Oi3WGLT2/jfa1Idn8=;
 b=k4SQPfUw78oYsMBgYiYdz25Y0N07YlepDAuHxgaazBx6R2UO94ISCOTwNigSlH/Q0D9IiMUD5j1Kr9xWOWjSl8Dq2PrkUEGuQ+HZJEWAd1XiKJVQJwtea1IwTzlqd8lIEFyFDnPv3+h9nrhKzYo9zKBWa2TjXe/70Arxnuc1V/+hRU+YzJFJC+x9OhX3JDnjxocizZbQ5WeHc0JSdQubih11LfiAnTb4plTGDEiWPgM3eM/lmop0eppnaL92LVLyVarU1JW4epvAZTGfCKRNpZvMSUu2Vj9XWN0ts9HG00YPRxHAPK6uz+hT97E68a8dbIwXuxBTn/hdAP6bqIW8Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W33rWysEIXWd1xryiFotbQwE7+Oi3WGLT2/jfa1Idn8=;
 b=TxBTna4bh6V/8hDTL96yfwS84p5hCqZCnVnvwqvVp/MdJTbBnStq1fZprcha4LUIRMx0INcTNTTxnXj7l0EtEArgG8U3SeXhXdBpQExCJntu+A7yPkyu823zc9gT0UrsdwEqDJk4O2jXd2lecC7ksqjYY159RSPicDYVNZjdCsI=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH7PR04MB8588.namprd04.prod.outlook.com (2603:10b6:510:243::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.26; Wed, 1 Nov 2023 12:37:51 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e%3]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 12:37:51 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v6.6
Thread-Topic: blktests failures with v6.6
Thread-Index: AQHaDHk7/Y1dbpXpUkmaEvYMjkxaW7BlRKkAgAAi1QA=
Date:   Wed, 1 Nov 2023 12:37:51 +0000
Message-ID: <xllt2ceb67yumezan7623rqqabq3xklq7l5wcui2zzz2eeopkj@7lj3p726mac3>
References: <6qycihftrxsdvuvpsvmkbe2swy5u2isrtu6jiyf3khzusdzilc@34kda7iutwdq>
 <d1d179ea-ae0f-497a-a2af-f1c60cf90362@suse.de>
In-Reply-To: <d1d179ea-ae0f-497a-a2af-f1c60cf90362@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH7PR04MB8588:EE_
x-ms-office365-filtering-correlation-id: f521a1a2-57c3-44f4-02a1-08dbdad75cea
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E1jpJQ8sMlYG9cB5YkCSEdcliLrUmqySuFp8/4zlEeqiJAOSGxvQP3sXi76xp+T/kjnzeoORjJV7Zpz8aKqU409vaGKcJhrFPomoTYjBC2mmio6Fod3SjpZXyfFnBi9V1kaDE1xPuHYlHVIBHoL8ZaK/mGEG1Qx2cTc+Zay4Jq4snZw64ypsssp7gQs4pa8vwhk5AZGKyLpCDtJJ82XGwkOC4U+k/AbHiMpJAaS6LqQbG/Fptb09pmVC+xYI1kNxoPrRZ/fvm/uzKhe/bLmbcE6wyWol8zFzNDC/hAGnHLOhz6eWuxumVsNXvwmscvgQAOZnvOBzN+ccickuwZVIYEpXqAahTUh1O9A/qI0OlkZXYvvR6Q0JytlG5xBVxoLSOMHasyvvdMeLwT7V37IQHzBIpNQLzb088HT0+HUC1paxQ0BPkpBaOVau84/4VkkDgmhl1sQnnhigj0fCF46WkMAYz3CIAC7SssLe6QnZT48G89CjaK9hhQngOHT2cEcf9tGzWWfBPcXqMywdFSIKfwxwrBZtVtNp617J2gV7GWunkV89d8wu77rrH0HpBBPjSXqf+Kt0TV7o3icJZA9fypmNqIzARWjfLodqTX22wDuXiOehNxPtoiCFpU2qFu22gm53qeuvBef0ZZ+CdOsMB5mFEaKdqyLmDbEL4l8ZA36Ws8Ta0sBq5eIBd/sLKMb+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(346002)(136003)(396003)(376002)(366004)(230273577357003)(230922051799003)(230173577357003)(451199024)(1800799009)(186009)(64100799003)(33716001)(5660300002)(6486002)(9686003)(6916009)(66556008)(966005)(76116006)(2906002)(66946007)(6512007)(83380400001)(478600001)(8936002)(64756008)(4326008)(38100700002)(6506007)(41300700001)(8676002)(4744005)(44832011)(66446008)(91956017)(86362001)(316002)(82960400001)(66476007)(71200400001)(122000001)(54906003)(53546011)(26005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0bKYbaEUbsj8p6EWDtKuYYDDbW4LxxjOLG9gid/7nzDMAaDUBaXiFge9omEq?=
 =?us-ascii?Q?QlQux1zcye1lNP8ocTXjvS1gHX5VlUWB8uazN4A4blyfi+WLHa+/h/lZQGyN?=
 =?us-ascii?Q?j9PR63crzc6Qs9UHb1SJy2etboPunyZPcs415mzQNAh3hJSAaRr+ZOPyq0RN?=
 =?us-ascii?Q?jD9yFLPa9/Y0puzkCD/E/El0oFgBJR2Kmf8czL9ewcHfodPAQrmRk8Jn+ddJ?=
 =?us-ascii?Q?/ME8Tb6mKu0aUagY5A70oLC3Hx8Yxss9/ImwP0xx5tbtdSeXyfXVnX/+H/WT?=
 =?us-ascii?Q?xZjKibSjo9pp2wAPcy9Vgzx/f1BKvQ0FYuz1r029aA042xVfuj+HAiZFIih6?=
 =?us-ascii?Q?u+iVgi5uGkAyYhscWbcfCZx8N66KPdGkcP3aTMYKP5EwSjLzFmIjX6LTBk/H?=
 =?us-ascii?Q?JwK8xGkmZWUxIsiPD/sY7ZxZsGiMj3V7Zd+mT28MIIrWTlDxdYrMgci5jRxC?=
 =?us-ascii?Q?oT3gSeE0VZwvWd40EzIIcaMBzA42E+K6LKELrtOboOnnulWq909DF0Kc2Gd6?=
 =?us-ascii?Q?suLGXzJvHPcb803ELe2guM4ZgG8IOHJy1p3c6VUteXkzSSG+QiRvs0WWBd/h?=
 =?us-ascii?Q?TSo1FPgixwApRWHjWC8osjoGo9VogD72lLAH4/KwDLYn0TX4GxCwgtKrY3RV?=
 =?us-ascii?Q?OzXK/gqgJ3M/c1mTPXvv+/PL4hWgaQpDTIlogDQNveUsyzGn6TP5zMZx+UIZ?=
 =?us-ascii?Q?viUFMZgZ7Mmgvozbr6upvLQkBJ9kezMsBJl9mC5uGQyfK4UdduczBKZ3T6Zc?=
 =?us-ascii?Q?8m0Wxy6F1KUYZFANBNojpl+sWt/kGvU+O9k2Cb3eolDgZ1AJ6sGoO65Z2Ub+?=
 =?us-ascii?Q?OBbSi/NJdR9RtxG92XxbPTEuv+XckK0GUYqrJZxOqXTQKRmnnXmZEROgxpXw?=
 =?us-ascii?Q?PmWO8+muyv8rjrAZPNW9BlEhOqzKmtnUVJku1s6/5WGRuTogMgEWP3i4tawS?=
 =?us-ascii?Q?EiZSqD+Fokz9bXSWY8qD4q24FiEADL1nYg5s7G/IZlaiGS0vgl6mVkWv0GiJ?=
 =?us-ascii?Q?ENwRwuPmf3K0VilA8XYeh9F1WDdYmCAxLCoXq41M0a1wTSHkIqnwyV2BFoPa?=
 =?us-ascii?Q?rYQQacMyytVWpZqfpszyMpHZCnsk1K9lF3StlI+S1G/ZggUtp/oGbM0hEJpQ?=
 =?us-ascii?Q?tMDZeU4nzT8BW8ZT+e5XUvhQg/6oWDQOahUbOZC+k/Yp6UoLLBxMVKKsLL9W?=
 =?us-ascii?Q?VvpFvpUl7vKNX7wyHTSlLfKbVYnTV6S6uSAwnveuT2JDxIK7lLtb4k7iXYP3?=
 =?us-ascii?Q?CeSFW9E3HOk+nwikoMPZfpK8d7ssIDioURNxBu+e7P4iBK2eRg/KO/KcCJmZ?=
 =?us-ascii?Q?gAd/fmjE7aLsXqXM58rNS3bYgQD4iwDpG++kOFYdq0S+v6CXe5qW5NDJ1HuX?=
 =?us-ascii?Q?8rJUiYgNj67foq0kibVjVrQDzolrcZE8dV+4LG7zZp+SeSzrQnuGDCNgtKSj?=
 =?us-ascii?Q?WwzAnBiVpCqrh6FaxQdwPJT6wurXTAyrMYc6pmhh6sz/zWtulNgjKXYm2zW7?=
 =?us-ascii?Q?CrloNbM5GUz5Ety/t4E191TXuRmjIw3357nwPnPzSYU+xKxzwfjMGFrAg5w1?=
 =?us-ascii?Q?QZbQ/XSOa//v3zWvbccIXDbU5zLXDDoPCZjTbRcTJeqAP4zO9JoM5UFVYdJ0?=
 =?us-ascii?Q?FGWN8Hy35yTsOy0cmkb+oRQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2323BBB7D4E05C4CBFEF9FDF2ECB8F9A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: I4EHWtNP45+OuQVBijSwFORi2d44ZBYBHUYLsce/fdzzHs7rczq8C3YU1xnultwoEO57/mYx1NxjG/tQchm7w3hx13kfZCoJNf69By90iKYSIsa7wYWG9xL4pE/khxujHlS8FBTcigPuWAgTN95QiKBCdsM4XU1tabngyzo4m0d/MMOhQUOPmqGW9GXhp1J5tIAh2XsmE0XI6dS2L4tIJ23b7qreCZLoRRcBLdRR1P8PTL33aNMGEAnJNb1mdnlCukZraxRnl2s/lAUdQgg7bOKUpQioex4OHtJE6zkZvs2XKgLuUi6S34eOx+k5+oQUtV/T1XHl3w/lrLf6ETzRYVqvhfrg1C51RrI5xsWRHGrvSJvjA1xFZlVP9V041bv58GmQGyKd5fWedI1qa+/ayo6Byp49y5xqt0fdd3yL5p8Z8Li0zcF7hnszGTJ8+nHyYOKXRAzGTIQNxML2001ZdoPEExQV+p+VQlktPe0yGjbc5uC9Rmw3+NluZuBE/KhkxlfFxhxHqdVwcwzLgyMFs4dGEGTj/4trVn3m6Y6VU5jMgWN0speRPdFcc+erUrPkO/Ehi6Xn2loD7P5K+tvERCXGEqTA8ZCh/KXpS0czKTy3oyhRW+5Yg2rYfYMSvXdYhSu8OdRsHGa7Css0QqRZ07V0yJamUYXL8yA7wtrD4yvTA5XSqvQZhpofiTvl+LUD8a2Ez1b5KE+qoyLqP1jgB2HTXaYyew0Gm2dsUvVhi5x75S0wrO1ww8lZrCzRUC8crNowUtq6psg3EMzT1gXzoYBuz1Iz8agNKzt7wQSKYnmNCySUGLspcM2ocCNqnvCzGRPOdHPSTty5iaWxVwtgewWu+ZU+jV5XEzwElfGXdoQ=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f521a1a2-57c3-44f4-02a1-08dbdad75cea
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2023 12:37:51.4215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F+qx4f6QMIuda7J+A5CCacJ0cNWQQF3afaarPderABFn+EM7Ti2ODXG7/AdszeSKW37Tq05uc+vswdjN2LJY3IpEMUzd/YnFYmJNLoK/7SQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8588
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Nov 01, 2023 / 11:33, Hannes Reinecke wrote:
> On 11/1/23 05:09, Shinichiro Kawasaki wrote:
[...]
> > #2: nvme/003 (fabrics transport)
> >=20
> >     When nvme test group is run with trtype=3Drdma or tcp, the test cas=
e fails
> >     due to lockdep WARNING "possible circular locking dependency detect=
ed".
> >     Reported in May/2023. Fix discussions were held [4][5].
> >=20
> >     [4] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvan=
assche@acm.org/
> >     [5] https://lore.kernel.org/linux-nvme/5cb63b10-72ab-4b7c-7574-4858=
3ea8ffd1@grimberg.me/
> >=20
> Just send a patchset which should resolve these issues.
> Can you test with them?

Hannes, thank you very much! This failure magically disappeared with your p=
atch
set. I confirmed it both trtype=3Drdma and tcp :)=
