Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C566C7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 08:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbjEWIj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 04:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbjEWIij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 04:38:39 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7604ACD;
        Tue, 23 May 2023 01:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684831034; x=1716367034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KeGkm7il6YQ7QGgeDphuBAL1I7V9+dbIOLHWytBsTrI=;
  b=ju9E944UW+k3LrOd1tYh1OOTYN4Vbw7+V1BqximS4B+BQkEfJzVxgr+M
   6W+tB5I1s9mabL32tf+phQ6a1YB5O+OxclfvQ0RbhSGffFbfNclP8yNuI
   WXMO01r6gdAqKWBNOcCS5Z74R0LVHSi89XWQcMJR2S1SILDRI+Hwi49Ta
   +MyTyei3NPDCQ1Cqju6H/X/OeGoKj3ZEfUKfyWAExlviHiAtVdFTIL8Ql
   +HrFUmXUMkpDi8xOUDcUQBTCFIPgFCN2AT5mOm6YgpfaTLJiEysYT9Ebd
   cSl5eBom1XzRRQHE1ZCwImbysSulLnS/mcJ1+OKUVAUqg7aC6g7c/hvTu
   w==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681142400"; 
   d="scan'208";a="231444505"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 16:37:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK7rimSC4EmMKeM56lpaJTiykLPlagnxwAHQ3fKOo5OnYu+yqmFrDM7wOS8QYCN1PUPEc/u5dmbDAC0YmpePQ04XoQVdXnFSDWN7sq7KystHSe6EqI14nDxJI8KGJlX9hzrQLua2X00qmhQFEosQ4e5/flKNTQQ0PiV06J71/KcIVmVV7LYskPxem2U1KXDhcGzf1Yz4j5nIS5S33IGVEbF4ktwGgiKUVN/Vnc73XB4nX3+iS90Sw2dVvqfRVVPbkSkI2i+zN+1HferW9fkntCPYw0MdNiTuiEQ9mJ/UnsRQ598pxHK+HXn3sqLqo7oL3ls/HniXSBe44X7/pPky2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeGkm7il6YQ7QGgeDphuBAL1I7V9+dbIOLHWytBsTrI=;
 b=STsU4S5tqREypRh5FFa9NiBUVFnzQ5fHzMqNOvAB8Sm6hzTQLNuAbE5i45Wf9D9i75T1dpzQuBzgeu3UJ4ITRUWF9gUjByLMPl+20j1lj4XnPtF9MdVp4gU3DLH0ixnH8oW3ou2OPYojg+UOggvQowxGJGoBpZLKAeWQliYU4HCGrSbPWq6DDS6KVbrctmR8Pw7CeDmk56eWePj+Iup7uDF9SxOQ4IWS/kDEdrOE43gRYNQUarx0vR8R4TnYvS6gEb8qqc5gi2WYbiIRVUqOy/x4gDguEb0Rszldn9Ji+QifomdgRW7Uke1Dd2DQGXPR5uiAYxLpV3Lk8d88lHsR6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeGkm7il6YQ7QGgeDphuBAL1I7V9+dbIOLHWytBsTrI=;
 b=FCdYtcsOz+DjZmCd8YgDoh4PYCG8DXLj2l2FBu8JZ0g1dFfqcmcpQgMyWuXtMbNVfyIPJ2mhq3FJH4gsiUewtcEo9epcHDNl+cT7oJ0CwHawdSI4m952rS7lEI1HXQ938ouQZC5XJL1BX9kaMzSd6Z7W9c2ZjppJI2wDh7dEIOU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MW4PR04MB7411.namprd04.prod.outlook.com (2603:10b6:303:64::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 08:37:10 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 08:37:10 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH blktests v2 0/6] support built-in scsi_debug
Thread-Topic: [PATCH blktests v2 0/6] support built-in scsi_debug
Thread-Index: AQHZd2vQQzoZBNYBPEyILYGGeqMA7q9ntK6A
Date:   Tue, 23 May 2023 08:37:09 +0000
Message-ID: <noc5nw3j7h7nbrvhc6awa73ddjdbwfeyrttchtery2hfmnbzy2@qpeukug7e6fs>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
In-Reply-To: <20230425114745.376322-1-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MW4PR04MB7411:EE_
x-ms-office365-filtering-correlation-id: 82f11f38-6319-4df5-20f1-08db5b68e645
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xq55ysRStKlj20rf9Asec0W981EjCmxrSmgWpm0HMvwOSu5SDodlkyV6ZHykNwWOt3MfjWjgmIF6eoGS9Qkshriq6LEFFuKHYMrHEKAFh0bOJHAncb48dkQ0kKarf5TFL5KMPAUXF0fhn889seh1VZOctjON7UNlKc3QKbB3xBTm+CAJN9UGOiasvmtLIp2lkx5slw85o/H1XmWurMQXd4aFTSZPiQzwMBeL3OWDysEPp1SJd1c/Mq4ZfDj2JSoXwErqzPVyRqFVEM8trIy9z71TPOKNMWEM5pfddqkE5Tisbx/d0VPM3OlrkLa0brjKXK5ndqPtenH5Y7u+OPYIgAxoABPPQohCY8wrL/H+9gp+BgD61M8tamJCc9Q1V5LbV5LuXIMjXyKxL6Es1KBv4KHf06wlmkHdzGXY2sPn2ydC4v7MTEmnkPgawtYltYhVRiXEmO3hTGrdHRrDXAhxvw1f9yoqSyPn/yGCin1V2B0BA5c6i8MeQvGQUvbbM2Igi6pWb+W/h6v53xy1sASs4HOyE6ur5bP5yXAzQllqeg/NR6UX1nLg32TnqOr3IMA2DIGnz/ymWdj6MMhMH8dyGkZ/3gBbG6BC0BlQMPZ7DTo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199021)(5660300002)(8676002)(8936002)(86362001)(966005)(2906002)(9686003)(6506007)(26005)(6512007)(83380400001)(186003)(44832011)(54906003)(91956017)(64756008)(4326008)(6916009)(66446008)(76116006)(66946007)(66556008)(66476007)(71200400001)(316002)(478600001)(33716001)(122000001)(38070700005)(38100700002)(82960400001)(6486002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0CQ4dpotCv8drGnDhTilGnvczjzA85qPOkOWNA65lAifiPaXnZlC9hYFlYsO?=
 =?us-ascii?Q?SRECS163cE90EqwItrbLSiXfzqeQlJkAklAnWjh3XiFekki86kMA+2urgmpP?=
 =?us-ascii?Q?YttIPjQDtwKF05Fu28kGXJj17F1vWPBJ7Q3P+fsOYsz7j6P60wiMONklyEkg?=
 =?us-ascii?Q?QelIucUK6ac9Y3FoJMWzH1a45w4FdAYtZ1yQsJsvSVvBHpX/3x5ssXUulQGA?=
 =?us-ascii?Q?Yvu/o3YpFk8SFMJdV/BUG2bp3sMfO+IKzFh1gQgb6psXi26K8QkXhdpM/E6X?=
 =?us-ascii?Q?X3MlkASgDYtK3/VhcYl8cmt197wWkKv9ap4Vhbngpz137pq2CbVhbqljkSmD?=
 =?us-ascii?Q?6TH1SBdhSDpCOZZOXeT3tXFVk8Rp7jrFJV5eUnCY36aY3zg/uQ3C2BUSwBqW?=
 =?us-ascii?Q?a9D7KnYDWBZjiLxg/sejuff3oXtXcBde1UABhw2demkZQX1m+pahILsZCe0+?=
 =?us-ascii?Q?2aLLg/oNk/krATtaxllbByDyMvySg7BQ5sScwS0cz5bJfaQP/cVE+H7GLcg3?=
 =?us-ascii?Q?F/07w/2skxxKTGR82gB+XjPEeBwm/6UBez6LxsMg/ylpefzRLITL2kOEsmcG?=
 =?us-ascii?Q?MpGyqr9eNrJkc13HarLICU++blHvPCDpwXWZCS4BZ4ZKo6E9U2fXoV1vEeOZ?=
 =?us-ascii?Q?LKHscZj/1cs8TZnXauUSldkV1aCblzK8y59YBcHB+TiVFAboZYyQljwcRUIF?=
 =?us-ascii?Q?/muur/QmVy1mnO+UciNw7RoHxFbG0JeEvmy+vOazeMZj/uLmVXEqK3KVYMcy?=
 =?us-ascii?Q?WrPdUxpkL5/dA8f1jaGXaiG4bZxfSBvaDuSA8bOuj41bhRkxQ3mOPUFkODx/?=
 =?us-ascii?Q?GjU+kvIlsfs9TSwCXqvPdA3BexKD63/6efzO49a9AjhF2YOoWcZCADFKzIZk?=
 =?us-ascii?Q?5hohlFaABt/47rS7tcsz5dkphDdfLhrbBjhiytk1saKJdZ3k2zAmREOOTkB3?=
 =?us-ascii?Q?m9LTxU65AElqhYYyNs093Zjdo4fj9SNAwW1SaiFn1/Xn30ETQimUWtXPL8ye?=
 =?us-ascii?Q?Z9xN995AlVSreDX1M91RtbaP0CIblsFtDMbKTQs/MzSkSbMJRdTsW4drjz58?=
 =?us-ascii?Q?PGO6P2ogyL8MmDBOpB4JHcdazmBMtHiIHVzsIa7aDnyu4+8bwOqPWrj4Zwg0?=
 =?us-ascii?Q?sQFYUtGYl3TCJYkyS0FMxWR7PQvMDyRqE47AV0rnIy+RNrd1TLg2lFMwDDwW?=
 =?us-ascii?Q?VjelxSr363+BoR0eSwZfqpd2NsYjvOw59HD2HlXYboaE3VVcmXhr0gjBGoJI?=
 =?us-ascii?Q?Cvkj/4bTtV0MLLMsyxEK4C7wfwyoVsp8uM1DRQ5ZLua+KnBBZUJmz6cjE2KU?=
 =?us-ascii?Q?5+hx4kTe8trSIaVf5twqckUifvlRGd8k4FllF11bg5hfWrzvIrcRAuIcPaU1?=
 =?us-ascii?Q?8xVaq4m+JoUiqOwAMEoo0J+CYtK5/otPK/lRBBR7EfSK+/doo1LxRMezQG/T?=
 =?us-ascii?Q?k/YhcHjaITotYQ6Er9tfI2cTSCTh7kvhKRvmDP4Izea9eluApbawHo5bUG/f?=
 =?us-ascii?Q?z1/cap3wcsxTLtl57w7SBY7HHyTLinXDW+Qo7DbTY0Zl6k8rInQfS7pMEFnZ?=
 =?us-ascii?Q?N+mIiMy81y1i1KMsdk/5Au8cbpG4iCVm9Hx3zKreb+zGTp8IJI7ACiIkPlFt?=
 =?us-ascii?Q?BlrUUVgyJh7Lt2F443YrTl8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <463EC84B5436BC46BB45F0D4976E21C9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yqS/EFjBl7y5EKgVVx/y/MKM8V7Wr1x6vfIhtWev8CmJqPZi/zSBYqTb0ErGA0Y2FDubHP/Q+vofQWHOmK8q1pQP6vyPFPOwMsLRI5tfsEon0AbJ9HdgbFQI6yF5x+xqPv0KgNnOHAx34Zxkq2GoK39sMT4gIi2OCl86JjOWlrzb4cUGXvK866SEXovLGoXIw5WCmRYDPqPAgovn1r0FDW8i6lIOTKkOKMv/KJVmKi+hJtDpVoJwTlGYToAgi7JVx1wxSzIfTJbmglu8QQnhTg4NeGzi/m6tkKiOp9tcmS0rtP6wj31fiYy/iHLAboSJEjOUEzuJOKJImDoiU/V2LvvnCzBDn7OgHC44ekS2BLoM9gdqmkZj9H0jjq4Slz9F4xWDgEffeIKJImGAem73spzobDdgV+MUvtTQQq4HSWG6vVe+LmDcCK9exk6pgoOSAR0kVZaKULpWYP7V/2U3HxGPR7VfI48ofa+Y5HMSwjExZ+jFCxPhXtJq/xGdVaE/Xtmea2Z3jTpzrmzhv/q8t11JxOoycEq8a+scUprqEi7cUZg5/4zHVlMznOZaDJp01Pgz2g10lZ6wwte2wms6gt133XNq5NkJQo1ECBHMXEuLRd7Qeg+vydaQCFmU0EBjlg9gQ4Q+MDMNbRbMOIZbVhgNzTrhCF8NKI1O5EEhNTWm0lMkH86AA1VSQnBqqbEOJad4PaG6BQbLKx7GBqKVXBy7CbIha+Ge+43fMPYVpxtH9HD0eIX+0GJnpeago/esvuA28NKwWX4RhjP7VxQKwKSQ+lTdVhriw0iFqCPg4NB0YrBAB4ff7YtxjC/Y5YVKJAyTw1gl/Itpm0zHHW+Azg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f11f38-6319-4df5-20f1-08db5b68e645
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 08:37:10.1025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZN+PDnIbGf0bFRBJ+DWXFPaEhPhS5ntwbR5DFcOz+gUXU62GeocilwtLqnttBhDBDapxHr2gw41cZ3/LZMA5nIlgGaebalgtF0zoms9N4yQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7411
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Apr 25, 2023 / 20:47, Shin'ichiro Kawasaki wrote:
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>=20
> In the past, there was an issue related to scsi_debug module unload [1]. =
At that
> time, it was suggested to modify blktests not to rely on module load and =
unload.
> Based on that discussion, blktests was modified not to load or unload nul=
l_blk
> driver [2][3]. As of today, a number of test cases with null_blk can be r=
un with
> built-in null_blk.
>=20
> This series introduces similar support for built-in scsi_debug. This patc=
h adds
> a new helper function _configure_scsi_debug which can set up scsi_debug d=
evice
> without module load and unload. Also it enables 5 test cases to run with =
built-
> in scsi_debug.

FYI, I've applied this series with some more improvements in the 4th patch.

> Of note is that still srp test group and 9 test cases in other test group=
s are
> left to require loadable scsi_debug. The srp test group and 8 of the 9 te=
st
> cases can not be run with built-in scsi_debug because the parameters they=
 set
> are read-only on sysfs. The other one test case scsi/007 has other failur=
e
> symptom now, so I leave it untouched at this moment.

I plan to work further on the 9 left test cases.

>=20
> [1] https://lore.kernel.org/linux-block/bc0b2c10-10e6-a1d9-4139-ac93ad351=
2b2@interlog.com/
> [2] https://lore.kernel.org/linux-block/20220601064837.3473709-1-hch@lst.=
de/
> [3] https://lore.kernel.org/linux-block/20220607124739.1259977-1-hch@lst.=
de/=
