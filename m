Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DB2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbiAaKmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:42:10 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:38294 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358150AbiAaKmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643625727; x=1675161727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=C//4nLdY5ffWgqVIV3qoEIBoadVRqX+QyEWjLD1bL2uozWummZUQq6ar
   8WxkLni3B47by4DWDMN8vZG9ISPeBP9ZOhmaanNY2qxU6Q8K4NkQ64bkD
   CHohI74Gz4j5PlDq15phuN4nq7EUHdoAiaeip7BTLdcNAbEAmcM7LeLA7
   HCaTz3kPJo9x72zVPMto451m+f94CCDNpbuBN9B8yZCj5YwiJjba+4SHE
   Cawhvu8ug6MRv5G5KTw4HftZsyTGpSQ9GMPv9Db37+VD+8DI1FonRfLtL
   ir2/I3st00SE/CovCU95MSisUfmCv6e6rOrcXbfpmiANMhJU7dO4LQn6x
   g==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="196592121"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:42:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rfs1W3SvIVMPNrU1fX7z4Y2VO7okk9iv7B6il7+EWq4INbhl1/Xhpcn2TM3BRUikXJZj9aVk6oS/2AeztfkvKNgGm7AejTPUbmU7bpXXPLrSX7NxLfrtncRmcft53O5xnNeauEd4gMzT7p/ardMi1d7q7cxt63ItyuaJ8mIC0G4SJmsSDyLx66rZ5Wy+O93HMP8odPrbSHheHQXJ7aZU28Eh5adON2q5pLcWnxnTVI8atIojEMJQ5wVXEnKO0XhN4fksp/tSclXepPlgoinF1KP2KCqV/SWApX6wujCz14HIOl+5LhgETpVkQx2CunJ5vIG3WIwZ0yWgouhOCZ0lig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=AHeGMQUJYxUwXyor34vEgSDsAmKLrkwk1sCfKssLS7FZEruEjBlvJLqPeB4FwNVIf0WixX/Jf477NpTIljhxBk7cKnvIsSQI8wBoo1yEunZFxfUDJJkfS9zTMx7k6KpKve65T0KfpPjEq2n5XVbsIV0DrmWyIiTVt0mvNkRTn/d3Z0X129pmxQ0RgQYTkGFemcNxS6rpuELwNSkhz8XJj6Bl/SK5fvBsAYwK01V1SBWYsP1/ezfTQS5jWmDEsg1ROEPt6MxJh0z49anovMxy5RHVotfChpbiB3Es5QKKr7LcHZIga7IqcfX9CALEH3ZIPkMe4+dhviOqC5Fke/ZGiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=yLixr3WaKg/HQceiLPi2DphjoFA9tmP2YRmkI0G4Dfilx9HnDWw5G9hS3qDAyQFZHeK1fZDNZWTrwqnvG1Q1IgI5jrR5QZXqXkj+fmSG8a2+JDeKCkT6h6nESi0KY+tEekmovg8XrQxIL/W55fhcSJsWVgnxHF74SmhKmysUONU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MW4PR04MB7265.namprd04.prod.outlook.com (2603:10b6:303:7c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 10:42:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:42:04 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lenehan@twibble.org" <lenehan@twibble.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "oliver@neukum.org" <oliver@neukum.org>,
        "aliakc@web.de" <aliakc@web.de>
Subject: Re: [PATCH 15/44] dc395x: Stop using the SCSI pointer
Thread-Topic: [PATCH 15/44] dc395x: Stop using the SCSI pointer
Thread-Index: AQHYFJVhCYa7+uuOnUSv8N6Fxe8fB6x89TKA
Date:   Mon, 31 Jan 2022 10:42:04 +0000
Message-ID: <ef3569085071904554329de632d03d9a95d75f60.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-16-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-16-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 023c18bb-f139-4c28-32f0-08d9e4a65219
x-ms-traffictypediagnostic: MW4PR04MB7265:EE_
x-microsoft-antispam-prvs: <MW4PR04MB72650387518C3B71E66EB2739B259@MW4PR04MB7265.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBGguy/dlyOcuKvqzBHGmvI32O5Puh9yWzabIsXvQpD3x8w4ZTu0JQHO/oPXlU3YZl7kTGGKgrzRbSCITPJG7MbAy06dol0NyABnGgN7Ws+S5Ptodh52vGLWsSAcq3B3iRv9lhKSX7T1+DTlY7DLB+5HSJWHz5qWHR2Hwlu7XYF0ZD6kxy+o89wLH725SuA1yAT89fMae9q/ry71PbU3JCogR0leZOzRz249Jq4Q+FGQDgnJNZ2UHShC+7lCnlvbw3rhP+GtiphdlNSGdnUIHMAyIDICH3hkFNa4/AYiPIPtQtZkqBLGgmarqD2A4sedbEcsokJt2/a5qxDa+6WGjywrdJd06JkbPhUG5kNDE6KJzvC3XBf2SWxkAwA4j/1H1N5zSUHrmFaLDORmFxZOFx6briHyKnuDzd7X/2HMT+TooQnsCXagwELWkRVl0ecXPIewv7MSEDqToUN1bVbDl0CpSFNUbikeRs9s0HZgT5Om2Ea/ag+UlV0b+JwfTn/j2kiaEbbAwVQbnFLPPkF5ilD0kCOTJ+H5n6joK1bsgim8Or7LnCFhuYk80HoG6aair6awcAxuE/hEidVyhyB//E+iN2jkGRkYpY1XdIKVipGyV/l2ohnHO/iXIiI4SKh1d60tguHqW57g222byRbdqf5m2o8S63J5EeSVBfHW8V9Eo9ADDgCp+eaViL9F8Xicb6QVTIQSTxxNuz7MCOYZsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(19618925003)(82960400001)(38070700005)(2906002)(38100700002)(122000001)(6506007)(6512007)(316002)(71200400001)(6486002)(54906003)(508600001)(8676002)(110136005)(26005)(4326008)(8936002)(64756008)(4270600006)(2616005)(186003)(66946007)(76116006)(66556008)(66446008)(66476007)(91956017)(86362001)(36756003)(558084003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXFZUG1ESC9oWTd2N1FJeEIxWVNCSlV2cllpR2N6UjB2dnZsM0Yzbi9sWjBw?=
 =?utf-8?B?NVhqSjkweVJDWm1NcHdsL2FjSkd5OWxjSVErUlN6QkIrY05OblF3bXl5VXp0?=
 =?utf-8?B?MHA1bjEraXlyUk1xQnNNd096QVF2TWU4Z09kNFBBUDFzazQvVSs0SElUb1Jn?=
 =?utf-8?B?bGhISG00N3doZmhKNTM0QWxTQjFjYmxEd0Y0Umk2Q3lDeGNaenBpQjlPbFlz?=
 =?utf-8?B?SFNEZktLRnpud0RKY3BFQSs5YjZyMHgrTTIwd28xMDZyWm1zSy9maERKSUhz?=
 =?utf-8?B?ZGpKUVQvTDMxK0twMnVROGI2Vm1wK0dwNEtML0x6dlRBNHp6Qk5JL3FuVGFM?=
 =?utf-8?B?R3NOS1ZiMnhWZTRpdjhyVFpmR0syY3ZRbUd4cmhscFVPdXI3NndZTTBQeUYz?=
 =?utf-8?B?eEVmQS9BVXNnSUttNWpmYUV0b1VjSmtqc2l4SEExTDNQcnNYMjUzR3l5Kyty?=
 =?utf-8?B?Q1N3L2EvZU0zVDZ2SzBFQmZETXBFODVkTzJrUU9nakN6cGhIdEFNVjNtVXRK?=
 =?utf-8?B?eEJTUnQ0a3JPRk0vYU1KZkhOL1REbmc1Y29DdUpGWFJtNjBxMUdJQ0JTam10?=
 =?utf-8?B?Zmp6K2p5Rml6cFg1S09URnBqQTJaUEc4K3VNWG9GbzBhOC9tTStKTUpjNFNR?=
 =?utf-8?B?Mmh5WFFTRDBwRlQwSW9kb2ZPbXgzN3RTcGMvUHVCdWdRTHBkYTR5K3poZVN3?=
 =?utf-8?B?dmlrZVpMZEJPYllKSVlmNDRiQTFtbXR4NmdWVkt3SFZ3ZTBuNHdKdk5OVjhx?=
 =?utf-8?B?VUExTzR1MVJpM3FRdlE1VEoyM3NycS9ZanlGUXVpd1Y3ZXVUb2tBc0lyR0hl?=
 =?utf-8?B?L1JkUStUU2FmVjM0NXB4blNqYzR3QUtqTkIwRDluTFFiUE1mS1hoYUZkeEZR?=
 =?utf-8?B?TGpObUVoaEE2cmdWdWdkd1B1alYrbmtLRVNaMThEQ3c3UmdlcUJmWE5vVlVn?=
 =?utf-8?B?Uno0VGZmTjZrenNTSWh2Z1dXckJTZkVJLzZpQldlSGZ1YkwvUEFoZmZUdHVJ?=
 =?utf-8?B?bm83bytidzU1VVEycThnUjRobUpWM2wwRWF3OTVnODFiOWdqNFN0ZDJWSEFH?=
 =?utf-8?B?S1Z0OVBrQStoWEY5MjBSOC9rczBKWmtDY3NBTzgraTJNUThtQy80UjFEdHZx?=
 =?utf-8?B?OGhnbjk5Ympsd3hGRlFNSmRUSktURGVvSXZTNmE5Y2p1blgrcitpL1ZhS25V?=
 =?utf-8?B?WjNSbEVkTWY3aEZpWTg0WXF6Vkc0VUZQSVFVV3VuZ1E4Yk1RTWRlSjcrS3Iy?=
 =?utf-8?B?LzZXQzdwd1RSR0lqdFE3OVRhTk80cXRuZTYyMEsvZFZQcDI2VjQ4Z08zMmgv?=
 =?utf-8?B?NU9tRFlSZXRIMnVRUlNmR2NYSTJTUjF1NjJvb2VUZ0NmN0dJb2RId3h2UXRM?=
 =?utf-8?B?Ykg3TjFXVDJmV1NrK0g1R2kySEFESGlQKzc5YnhsQWNTbEM5bXJQWDNlc0w1?=
 =?utf-8?B?N2U2UXFxSnA0d1U3TThKTG9qb3ZRSEtNMVpwcXdHWUVvMytBdG1CMEFqZWx2?=
 =?utf-8?B?WWVIbFZRUW4xdklyeGQ4RGx6TUx5Tk9naGxSOXB6N1k4K3pPSHMrK05GQjlP?=
 =?utf-8?B?Z01ZQlROQUsrNldib1BGVStHNWdyekxpMmU0SmdPVUR4cmUyUkFNVEdBWnhQ?=
 =?utf-8?B?bjh1V2dSV1ZoVDVWVXFoVGI3N3cyM1VjelVuWjJaQmRMaHlkV3lZYXlsY0Js?=
 =?utf-8?B?MjlwNGJ0c0NiTVJ0WWtPN2pIUmJ3MnpzT2RZS0JUMWpwZWpWNy9yMWhoTjZ4?=
 =?utf-8?B?enhBcTJnc3lVbXZRMkpmS3lyRzBtbjZUejl5UzdtQXJrZWg3ZlBPbzgrWS9T?=
 =?utf-8?B?RWxOUjhSOGcxMDVOczRGb1dSRlRzN2RsUXljRS9KNFUzdjNpSS9EbUUrckFM?=
 =?utf-8?B?VjJvZFlweHg5cXNBcmo2c0ZacFk1YU9HbnhuQWpTS1JtdzBVbTBiRFBkbmU3?=
 =?utf-8?B?TG9uZXFwQWtjeEdNVlp2SEhreCs1dVhBQWFkMWFSWjlxOXliazhFZDRDYmpk?=
 =?utf-8?B?cURPRDMwRXVvMEpMMkJxOWhMMGV0UlFlUnd5aEpTVzJFekdFR3g4VjdBcTNw?=
 =?utf-8?B?clRUdTErMUdINi9oV2VLVnpTT3Y4M1ljcGxheVQvcnFFdEJIU096M1Z2cGg1?=
 =?utf-8?B?ekp4anMyK1VCbE9lejhCcUMyK2ZETDdqbTJPbm1KZXhsbWw2SEVIVkpsZVRK?=
 =?utf-8?B?Tm05b2N6azZVSEVSZDZaRDMrZ3dpOHpwdlBFWlVFY0tmUVBRR1ZnNWk3Zis5?=
 =?utf-8?Q?7olz35r8gNgRFcUrXCDBbdl19Ba9rW1p2taK7RCBR8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98475721208C244897599C9123614D24@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023c18bb-f139-4c28-32f0-08d9e4a65219
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:42:04.1629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5BaRjP1iUIZ7vDZJHBZcL6zpCBz7kOCMRNWIoBD/wJw9stCAX9NTBlOau0OZBIS31oITGQGfoZIL0FkZmoCfXBgL1orEV5ukmzWAQqxv5r8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7265
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
