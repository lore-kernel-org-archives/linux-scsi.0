Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAF4C77B75
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 01:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjERBaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 21:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjERBaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 21:30:18 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9910F3599;
        Wed, 17 May 2023 18:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684373417; x=1715909417;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=5naS+Xa/IK5bA/OjcGnr/nXmzcFIuI4ozCHiPfvli/Y=;
  b=rOzT/ntwBtssfRPvopSwz2C3oJ2mkT1eCh2QJ4dEbfv0QZ1mBfJaDXMq
   epIUl4piNzIVpOAKRKBlaT2MI7Fyy0FGSIgwK0jnwfAI6gtWnLtT/CKIm
   Q0Ave0w3h18elp0FUEySUKYSOFgML/cvVPx0LtDccLXUj8EMDo9BvN73C
   lEEv3OPqe7gXYfVsGQobov8BmA/52kj93w8RoQg+MNkCjIB8yTh2InInl
   GaSOlq85w7Dd3J81N+XPVxOHVq+5P4JnL1pL/HjAvCcysadq3HuHgb/AQ
   N7mTcJmr1QM/cQHnyNqpkX+CtjJey3p0BxZeoUkMvwfWcCgPbF/2+jAOA
   A==;
X-IronPort-AV: E=Sophos;i="5.99,283,1677513600"; 
   d="scan'208";a="231075221"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2023 09:30:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aG0eEgDfjfxvajhqxF9cN13UIw7bWx5+g1wHD0jztlAtdsn8X53hnWASZCshB4yh6uRDkIgdTASRA9EouZt4UkLOx8jLcKjPsRS64fN3yJZlj06VHIRhHpJyjYspKfRVY83udeExOdLo1m5u1UfSkR3Yl0T/rFcBqZcyyv3phsiQ8NmtXFyLVMgsnLL4PRnXGQPWAYjpDczYQUXpzko98sre8K4qkiIsTXu///04eqhmWY9HbXNgnwa+9ELQ8bl+t4BVhEqnxiE3sBIZwR5gOzeHy6fJZi/F6B9BVJrmiWBrWe+nNlDXLMIyrxXbU7/YrJJp0pWYLQ+Af+bIvYK8Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5naS+Xa/IK5bA/OjcGnr/nXmzcFIuI4ozCHiPfvli/Y=;
 b=dtem3ItEX6SHlN56YEZN3xE5dZJEdNJClq2sSI8Tabu72giN3cqm9EF7O1CSRDTcEKBFRrrYUZKrkjprh6NmIly5NGvnv6xuvKYvlEWzsEAVrXpzA33f7z6jAs41P+lsXPOJIS2xeaR7OYJbKtz5EOZ9vRURwapd1topBp6OEaZkSS4N32BOP7pz0Pt+RSSzj4urJzhz1OSnOKwaNnnPbvtC3lDQRN66FR5vTBSIU7iQX5SIKjF9emyHxtpfZM5THdMXvOnVb2V93eBSdeaENTXbbWFcqHV4g2pXfBtEvmA/KlZt2JMFdhOC+9JxisHlv5tehj57rw1354wzt9DxEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5naS+Xa/IK5bA/OjcGnr/nXmzcFIuI4ozCHiPfvli/Y=;
 b=WKNgZ/5sVTkst9bDmuDSrLLDcuIcYKUXxTOr37c/EMsjZLcJj3kLl/1rAhxDzoc7o3jCstiIj6KtFvmNs9frCnLy0w5pqMIAXI1kWAMQpXssIvYun++ey6o7A2PNhh2lkdifOM+LQHqBNhI0j2BDP0p18VmUJDiQoijiW3YGSg0=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MW6PR04MB8869.namprd04.prod.outlook.com (2603:10b6:303:23f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 01:30:13 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%7]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 01:30:13 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.4-rc2
Thread-Topic: blktests failures with v6.4-rc2
Thread-Index: AQHZiShK4gVuc55n/Uu2qng0d+t/9Q==
Date:   Thu, 18 May 2023 01:30:13 +0000
Message-ID: <7i5r76osy6aqb3w3nzpx2x5h2dqoajar6dqipjx6sok4jccjs5@zt5sf6itan36>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MW6PR04MB8869:EE_
x-ms-office365-filtering-correlation-id: 3bec1373-7a91-4d0e-2c29-08db573f6d68
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G6P/0PXWWo2sacOhamn+TUVVolZAovUt/T9CNPA+crjBlP+QHN4Sx6fff6pYbke2u3eGN9Hw5F+AtGefhm0nSEKYkeUBpuUDusdTEs/wf1qpp6C1rYPLHQzlJBJfOlKml/3FOtQp8Lbvj54iHtG/Repawo3btAMdydGazk2zU7T+c+lshfT2M/9I7uTqvKY8xnb/nb5U6C4ARTTAppOB1YI6HRcZaRX8VGCF8A2oVV5lt8xAwtCeyzveeMF6RIq9oxzuavBDlSFrgPcceVypdJE19k12boZYIyZa7iCXJDxTLip8v3V8toXKxcbxBAoFCDCwP8YcVTTL7hiRKJESKl2M107nxHF8nG1ns0oh/PidCvAjqLWvS+C5zoWfojUwkbgrKIVp1umSl2ASlpTNxoxwONAmEh3Tl+9NGUbBcP8cp904EBdkN01xD7VtJEX5rB6exrfeKBCHsHCQ48dlBMe9vRwxspXxpw9ew+sNOwyMDeCKKQXiM332ton82jnbPIPC4Pdj+xc11gBPlpo3qRl3es24m53xRQZO97Qgusjz1bgq0YpBHpOZk6YigizjiflMaq9u0PGjKB0b7qmjpNHVrjmzdWDIQEq8c1ulrG9vxfAjt879oyMGlvmoGhN0HeDBYuB9i/i1BpQimSDycA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(5660300002)(71200400001)(41300700001)(2906002)(83380400001)(86362001)(122000001)(82960400001)(38070700005)(38100700002)(33716001)(8676002)(186003)(26005)(6512007)(44832011)(8936002)(6506007)(9686003)(91956017)(66476007)(66556008)(66446008)(66946007)(64756008)(478600001)(966005)(6486002)(316002)(76116006)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uvnvQJm6cTRlgRq3F07BNsNzG8CjKT9H1eGTsiF0ksvt3mGTrdu906f0rmy2?=
 =?us-ascii?Q?VhI7fT7pmHTslxXJ0wlhOoIEvPm682nbFjHQa1M96vPxKLwsGeAAheeqF3nq?=
 =?us-ascii?Q?kWibPJkp6OIm/zm4pL7yboPL9sa45i3getxJ4qjuqGDBF2Q73Z77Jt3oHSPq?=
 =?us-ascii?Q?RaeMrKoNqfRjzqBnABRC731JwvzCrbQiaxGTVH2pFuvHIXL30VXkCE/qRhhJ?=
 =?us-ascii?Q?F6DqFCrvGF5manT5ACrF86qrzhvLY2t9uOXr6jjYNa5eYTU/81glAiYyLq9g?=
 =?us-ascii?Q?jP3DFNVeYBpJRLmHTuoeH8uvLNHjy1MKDp2bqSvcAshv6fjiM7zKGKt7vSgd?=
 =?us-ascii?Q?QwKkyxGpeggwZdzyctJIaLE+uHTnfDdbiyegFO0BsMr7wIXUQPPgie5LAzlB?=
 =?us-ascii?Q?R8RAkYfOGlpPMtoefxMnRm4CUoBLJPjQa31Es684tav/bWJA64sjZm1EKKjl?=
 =?us-ascii?Q?Shf45arsXsDNAX9lsV+61qkcHNA6zR+m3431q0C3p948VFalkmJuuMznG49B?=
 =?us-ascii?Q?VNVZJ3mdoDa/IQWBpFNc3R4ZycpCOMLdWoo2HXdEK89lHrHU7mFJ2CSi58bA?=
 =?us-ascii?Q?yg6ZHuFNW449PxQppLx1emM/4954V/7HDhsiAScWrA99ITrRS6n6qXEWozSF?=
 =?us-ascii?Q?u+Ov/rK+ZWC5gHnlGspjYHX0gZ6sVKhTWZF+qNQYLJ+vO2J6+rnSBAMmJ6nr?=
 =?us-ascii?Q?IMWW59WXVfSlkQdG6CNH0eXipXS2+l1ZjsGrenwaHMcFdV5ilvuxw9VfI7uc?=
 =?us-ascii?Q?Ok1bhpWLwTi/LBN/zjIVbid6k/MH6L6gQVyHfIQ82JDbL/QLpEvUyG65Icyx?=
 =?us-ascii?Q?1nfNjfEq9TSXqM/wlVquNMf9MiwzGbDSIWbXB8tfX74YEjAb1XVRVoZNYuCo?=
 =?us-ascii?Q?DDVPrw/GuFB+fP3ORMw7TeNK6Ep93dpJL+Da1RlzHLtJxRZ8JiMSkxu+vS6r?=
 =?us-ascii?Q?X3nNrdxTu7KvywML7FmrsZTknwDOxaERvHauF7azoZjOcEI35Eyn4UcaECA+?=
 =?us-ascii?Q?LEDJtR14MFkKBWHs0WOi17DRBxWW0B7Z1c6/AcIKIPXmz5aL2GWee/gazwg7?=
 =?us-ascii?Q?fOCtTK/e2vYUSksKBbp102TDayqD+n/0dhjxrs14xyUIshT+a3vhXlc6/ql3?=
 =?us-ascii?Q?GKmYLwIDfyKZFMTZIM5erSgxf1MM8SZTjYdfK40d0fWjV72sXltPnxPmzJ4j?=
 =?us-ascii?Q?0Sf9DndvQzhzXX54QnUk/t9nHVNXvUpD/B7PjJp3dfCC/9krai17wOPmqz30?=
 =?us-ascii?Q?Ql2GDlLtvHMsKQXaEP/9RlQ3grS2Gyyvldai/BfvGNNmrzq83CJr9kMnvKpk?=
 =?us-ascii?Q?Yvx7DMhXzbGbc7VOoJJBS9L27OjiDSbyNNyAQgb6EIhOgYrcBPDhtgwaw69V?=
 =?us-ascii?Q?WkGlDee5/pSlARVdDPw2zWNhBb3s2GV7RXhMLSRLOu8abHaMWmXYakn4sOYk?=
 =?us-ascii?Q?pB74aiVdqRFGYC/GKXu3XG7Fl9d+epy67DesOPfruGqQte7PVqq2ebsUXiBA?=
 =?us-ascii?Q?n3Zxg1idjBkvAZseIkxRtvnJzuMCr3+yz3Y6PuyPwb3/CoLZ+8D+gPIziPWx?=
 =?us-ascii?Q?DtliW1vY3tda3qFFkOjpjMfHqnm9+dEbQvFmcBgk+3VygF1fEcGtBeLq1QH3?=
 =?us-ascii?Q?CcAXTf7dsOMzNIeWNWuv+ho=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A407312A0CB13E4797475883B3964EF7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0ZqbllExSkJ+K0BvvqLmZQC9er6KFhl8VgBRQE+0AqoKAE5xjLYZ8O+Obh+FwtsCzRm4XVpHLsFwoCUpysq+M4ybrDxQHSbUAfUiJOThRLHxHr8MOf2cdMY8YaSj3l6Aorm596cL+oci8t5P3gTer7HLQO1bJ5exqfWxrg9RQ8HALs0WogC7hxdyqrIr6EYzmsif5a3KLJTnlNYIce2e7MMBJ5f8Rv3cJLYrlsC2MExc16tmvx+LYf/TaAndkqc9UshDcRvT9//udunygCXxc1MZIQhUjl/jqWAW2JLcqDALZLK7wQcutQ51TrgSnZs2sVSfqLuYcBDM8ML0pSXWrwHz/+0KWb91hCPPjExT7wFsd5OBKnCdvvitiW6VS/z8mLhHaVxm3JlqT/EolcfZQfsPdCP4VKq6G4/0VEJ9RmrBy3hvhlB3OWOQI4L0DLi7jxmTxSv22iQ0WJAicdWpTIyuKvv2n327jp4+6r/fJRNRTIiwAPsbBnTdN02ofhJISOJ6vmNAXUfAGipRPHJ2VP6QTs1ey6tsMbS6gIXaftrjAChySGXP4Ltn/P2TJlseNFADz6121qXQGwL0Xadv7GkAldHASV+whgK5a09wlhUmV5po8gCw2BobxtPkeCPscGVNiMX7RgmwORu7GvHliLW8zJ4Jozlc7vWycngILM2YLEgXr5kqkkCwh1hly9qm4qyqEJHc/1ndRMIo3pOHw9LOmpFX0uM7sDJ5SXMCAQI4s5SQYYNmbWR0FakTAe2KSbcFN0gS/ozY+G6O1r1IP0PFNV5rRixMeh36gRmNZgN9A2Ub5c/KEN8lbPVRXT9pePyey01CEWuYcadqxphQAQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bec1373-7a91-4d0e-2c29-08db573f6d68
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 01:30:13.2554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZ2nolCOyX6qMp6BLnA3ILHWftzSXZ5AX6wPFcsUIlRzuE7kqHhMf7vuBjAkRPc9+70VQM0Ogw2qmfdWp0y19EVfeiJochsZWzFpHOWLjUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR04MB8869
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

In the blktests discussion at LSF 2023, it was suggested to share test resu=
lts
with rc1 kernel releases. At this moment, v6.4-rc2 was already released, so=
 here
I report the results of v6.4-rc2 instead of v6.4-rc1.

In short, the result is almost same as that with v6.3 [1]. One new issue wa=
s
observed with nvme/033 and nvme/034 with nvme_trtype=3Drdma condition, but =
a fix
is already available [2].

Here I share the list of failures with v6.3 and v6.4-rc2 again. As for the
failure #3, fix discussion has started [3] (Thanks!). Please refer [1] for =
the
detail of the failures.

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: block/024
#3: nvme/003 (fabrics transport)
#4: nvme/030 or nvme/031 (rdma transport with siw)
#5: nvme/* (fc transport)

[1] https://lore.kernel.org/linux-block/rsmmxrchy6voi5qhl4irss5sprna3f5owkq=
tvybxglcv2pnylm@xmrnpfu3tfpe/
[2] https://lore.kernel.org/linux-rdma/20230510035056.881196-1-guoqing.jian=
g@linux.dev/
[3] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassche@a=
cm.org/=
