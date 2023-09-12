Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD8ACA0ECA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 13:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbjILNnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 09:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjILNnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 09:43:18 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A168B10CE
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1694526194; x=1726062194;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=nTDDCeLLB3xhJK7LcCKSFTxCzeHbjkKYDUtoJ39/1Tc=;
  b=EtmsW7zA/+jjGyUjTU5YX1dDEU/17hgeJKF2Z3vw6XKfu7/1DYQFeb6b
   AD2DzCvwX/+LhHi0u3f3O82A4xbAkkP11hUswhZ/vgfxG2SXvhWGSSrcR
   zZcXuy+/Iy+qPTqPyH9PcGnLnYk5bTomNLK29ggkNWxAzQ56pBOCNQ5jC
   IkIevP4LotE+NXeAnYMI/mpwQqiagd4AgqFswIfOn15rwD9UR11Y9ae6B
   P3wQPmnLbMqLwPqrU7sK7KVi4ZSywvLLRcLTm/T2EjRWfBcy6f6E93eQz
   D0HmTSv+NXH1VdaaIby1BiF/yHIQB6J6JAnU+MzjsHaj3Spcm5sgsZFLV
   w==;
X-CSE-ConnectionGUID: M/Fy/kHCS5GNqw+44yck1A==
X-CSE-MsgGUID: 7Kb4grbvROe2cx5IHUefiw==
X-IronPort-AV: E=Sophos;i="6.02,139,1688400000"; 
   d="scan'208";a="248264544"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2023 21:43:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JavLRp6w15nLxFdOA6AGx8D/gAtc4F4wgPv8BieS3prws/l7zAxHzPmPqcD/P8MSkrrjtQawQ23Rku0ctlVXA/0RjJDmZQxQAEm2hFxRwtawOr5zjvsWe0FAygUZvBxFIsNBJzyJu338dqn3RWioGg2vkbz8xnLEsc1+yX0jDFZLSLj5HHPDmej0TIOPmwtWVsvL8LjnErz5PtmJh6jkUD53LytAeexoxjMwVY8shY0JJE1pbp8a+vSyjb2/OKDiBNZ9i+l/ni1G4+vjMMwTLg0U/y2don1OqHYeb3a8M1Zj5p0rdls+qs6Jygh08lf4LHcZYxx25S8ih/dpyXxMHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTDDCeLLB3xhJK7LcCKSFTxCzeHbjkKYDUtoJ39/1Tc=;
 b=AFDRJpxmXFsS+UwGrzJE7uf0ItzqIu2vm/lVFK2VKey3cUa1wB21akyryfsLzN6l+gCwVEpy+EH8CW5hUE4GcX+wBJojPYbtC0zwoysVep0kZqHWjyx46e3uQjP2RUqLYYRzP4s+CylSCsfVYZmFJK90V2UBKjwJrsXXSFFTBPbAl3aU6qdO/PA8CYMk3VL5uhBa8Edny0eGudBWc+YngpNVthpEb1euJ0++1dL8Y2XlN17y5z01VNJ8NJLtfAzTNb3Hg2IkaPYIWk9wkUspmAlg6J3JKh4EFDTxXQQcVUu1XhXWHWthOUymFVHEeGeC/cxVxHDZdPNw69bO9czhkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTDDCeLLB3xhJK7LcCKSFTxCzeHbjkKYDUtoJ39/1Tc=;
 b=B13ZKOhC4wJjVZhE0ZyCoGFxJoopdkz/Be89KOxszMBycOR43eq1zDuHTbadXzZ3ctWj5/Ejloy/H4oB1pYnW5SPjJz99peDnm+Eot1kQStL0i2ip6O2uFtEIFH3D1Jt57Vesx6l1FV8MOX3ZEx7VgmCAYtU5d77whXFjiq0xTo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY1PR04MB8608.namprd04.prod.outlook.com (2603:10b6:a03:534::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.14; Tue, 12 Sep
 2023 13:43:12 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f694:b5b5:8e42:b8f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f694:b5b5:8e42:b8f6%4]) with mapi id 15.20.6792.015; Tue, 12 Sep 2023
 13:43:12 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/3] Minor cleanups
Thread-Topic: [PATCH v2 0/3] Minor cleanups
Thread-Index: AQHZ5Vakc8+I0sb8sUq7ZkNNh9y0VbAXM3aA
Date:   Tue, 12 Sep 2023 13:43:12 +0000
Message-ID: <9bc71fff-cd72-423d-a98f-81d81e4c5292@wdc.com>
References: <20230912085338.434381-1-dlemoal@kernel.org>
In-Reply-To: <20230912085338.434381-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY1PR04MB8608:EE_
x-ms-office365-filtering-correlation-id: 97402fae-1f6c-455e-8306-08dbb3963532
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gzTNNCMB/QxrUskupadUAiDO0ch1BFk1YNjXszjk9+WBZQAjgdhdLW+TfJ0p8K+88YxfYqLRj4kYj5o5TiFDsXRXCAHijuZUWRYWVUevb5lrhX1q9846jjsHGB6jUNUd8JvVVnU7r0FCvGyFHb5hsjcGh4X5e3AaVFbp4Mol/MGgDqOPH5Vaj3SNQ4Kldeen3cOqh7PS7KPiYUsTwROsfhxZ6l4DhoG93m2YOwUyjlmdEFvREX+++4IHNbJIR4fQEzs+QXwAl65m+kgnV0ToUkv59rI+cQI+imVgJyhBEhsHlpUTblUVmIdb9TvvQkA6O8eMDrZ9WUU/coONFMuJ5IoeaRGdp7OWg3u5xFSGMfDyxgIl1iEjafVAmS6orLNdZNwrGhmcocKgcYGv0wDX2VzuI0FtT/8XMqEQT9HZsqFg+xXxOXjy+V/g5qL0WttT+vXFNqk+UUSY5m9B8kv0+konT1jX4QGWDLzHi/4hdbkJJo8f7LCvns+MaEstBUyd6g6L+UYVxvuEwWnJoecH47oT3Zxhcf/ubZMgR84b0BiSH7L0O+cStuHQ4MJPHNd2748WjAAQyGP+SGdIjS+HLhOmbGQQLzGhnDt0QubcwyedLs6OVp2wVspB/T8M6vLjbA1Y975bQV+gIp6DXS5vzMAzEy6wbujUAqYHCPpVbvxJ5Zx7NwigVNadcEj2fkRg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199024)(186009)(1800799009)(31686004)(5660300002)(8676002)(8936002)(41300700001)(66446008)(66946007)(66556008)(91956017)(64756008)(66476007)(76116006)(316002)(2906002)(110136005)(478600001)(6506007)(6486002)(6512007)(53546011)(36756003)(122000001)(26005)(2616005)(38100700002)(83380400001)(71200400001)(38070700005)(86362001)(82960400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SU9ERWZvdHZnakxEaDIyNjZvY0FYNkt3WCtGekloN2pST2ZuazUybmg3Q2VZ?=
 =?utf-8?B?Zjl2dW9lWXBiMEZQY2RzMUtQYVprQ3NHRGpDb2ltbUtZYjJvaE5mMnp2cTFn?=
 =?utf-8?B?SlZpR2dPL0xSQ2xBL3pLUEVlQWpRRjgwZ2I2N2xVcStUNG1jUWdjc0V3b0kx?=
 =?utf-8?B?aWYzaCtzWGtiTGtRT2lLN3BPK3Z5Qm90Y0JNVEFxQTgzTTNReWpLYVRZL0JF?=
 =?utf-8?B?VVU4ZUhtVys3M2R0dnN5ZDI4Q1hXaS82VjcvMTNueUpXdFZSM0VWN3ROUmpk?=
 =?utf-8?B?c0dYSkZJWkdXQ3hxTTczT2l3akh4SS9SUDdYWnMrZ0pZeDAyb0QwRnVMU3Qr?=
 =?utf-8?B?S1lSNkJJNjVpMWt5UUpkQTVGZ01NTVdaN0EvTUx0WHNxN1c5T0hTNUFlYmNa?=
 =?utf-8?B?MkpYRHNHWlRvQXlUMy92cjNmclJYSVJIZDc5bTJqaFlvTGFoSG85cmd4OVJi?=
 =?utf-8?B?NVFIOE1ack1yWHYzSWdCY1NNTXdtaGEyZUhITW9LT2ZsdGI3WFJ1L1g0MXBY?=
 =?utf-8?B?WE5PRDN0YVFYODNkRGJrOWNFRlRYN0lsdnRhTnZ4bGtFejNzRUtyOEwzTVBS?=
 =?utf-8?B?NnRnQitkTEhEOGN0bUUyRTdQK3lOQnRxZHdmQUdhb1JFMmxOQU51TGhSTktD?=
 =?utf-8?B?UVM3M081cVBXejc5ZzUzYXA5SzlZOFJ3L29Gb2JqZnRmRkYweGdCTkpUT3li?=
 =?utf-8?B?NWdhQ1NwNWl5TFFxUEp4UWpscDdwOWVRcW8veWR2VjlDd2tNRUNpdlcwVzRq?=
 =?utf-8?B?eFppMkkvYUlQWVpjaFFHYmJhZ3lIaUN1TzFRa0xaSmhiUDY4c1V3NDRhQzFr?=
 =?utf-8?B?NUY3Unp3NWRIR3lWYUZSTWs3a294Vm1oVTVnbGQ3dkh4TEJwQ2JEYkRQaC9B?=
 =?utf-8?B?VHV0WXlvMUpaU3UxaFVMaHBMVzhzTHR6MXk0N0pKQndGYUVKYnFia3B0eW1G?=
 =?utf-8?B?T09NbVFuN1llTUFOMW5WU1REVHVQeXhzd1dERlluakM3WkxNL1NIQkJ6Q3lk?=
 =?utf-8?B?c25TcERlYUt2M1Fna2pTVzJtemRwQU1hbnpHOE91QS9hSWZNTGl1MkFWMlM4?=
 =?utf-8?B?SW9TMmxRdHlaajQrUC9waHB2RWdQcWRhcXZZY2xadWd6QWZuRTFqTGg1WFpP?=
 =?utf-8?B?a0lWV2FoUEI2OXh3dHZxYlJ6b0VEcU56djV6RjlvL0FjdEg5RFdvcFBDb3pG?=
 =?utf-8?B?aFFXcUtIRnY0cTh4RzI5QlY4dlBCc01ZTWdDNVFMaU45eVNzRXRQMnE2N09u?=
 =?utf-8?B?bjZ3SCt2eEVXVE5hMFBOOEcxSkVQWU5JQnFrTGdKelE3cHhjMWJUYlM0TUcy?=
 =?utf-8?B?LzRNaWRnNzhyZTVRNG5WZEJVOUFlWDBrVUFtL1drZ2JWZFp0N2NJZThnT0hD?=
 =?utf-8?B?MDBlbGNDVHhEYzkwai8vY1JLKzlxWkdjekVKbzJTbWgrbmVPd0ZVWWNmUitm?=
 =?utf-8?B?aDJlWUFTWFNRNkhKamZKZjQ5UEVCWEtIMXUyU1FRSm1WcGVCdmJkYUpwRlkx?=
 =?utf-8?B?bDAxanF0OUtLVnVGNUZ2bkE5NHF0WlVMbTV1aXBkc29odUhOY3VOd3JKM2xh?=
 =?utf-8?B?R21zNGJZTzM1b21pcEZXMnl5YVBEeHBqLyt1UTJWOFc2ajdLdWl2WGU0RFlx?=
 =?utf-8?B?NlVoUkpEcUI5cWx6ZDJxR2FlSUFuSUVSRVp1eHh1TmE1MWNaSHdjd1BMMXBm?=
 =?utf-8?B?WllyTmU0aFpUWXZFdjM2Y2svcm5WWTlLekJ6N1MvN3Z6MEV2L1dLYmVKYm0z?=
 =?utf-8?B?Y2RvQTFZTUI1UWpzYUZsaFBkNmoxQUtleDRJaXVGZU10bjIzellGa1RsTzhH?=
 =?utf-8?B?SUgyRWV4amZNYmkwTXdLZEdvaG8rc3FhTngyYnMwckFGcnZqODNubi9DU1pv?=
 =?utf-8?B?YTdhMnlCY2QzUzNRMTZBQlR0S0tnWEJwMkMzb2VDcXlxeVJwLy93eEFIYTlI?=
 =?utf-8?B?RnZ5U1JyNysybzFhT0x4dE1sbjNnUXczQ2xJeE5MRGdYYTlSR3JJRlFtKzYr?=
 =?utf-8?B?emVkd0NHMHFCaXczdVRXNzQ3Ymw4VWxZTWo4eWNHYXd5UkdoR05xazRCbk5W?=
 =?utf-8?B?QUNZTlRrVklmb3dVS3IzVFpiL2JDK0hPK1JRVEhvVlFNK0xqb2h6K0J6OFRh?=
 =?utf-8?B?Q2p6SnNiNUxsN1Z4MXpjaVlmLzlxQzRxRHZyZDJteFhTZ3kwOTNUZVBXY0ZS?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <130B50FC4A55B144ADA6604F22205456@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dXiUWADiQiaUkwBq5WUGtnPNrkcf7suj71cU3bsCSlEC5/869bWqPDiq+LFSfki3kTSqEjpCMv8rRHE2V6NbCGJHz/FsOcnhHGRedHtt63eBE9X+yq92DTwKT7LtJ1HxTr4yK87HvNg5+LI0ToFuK5WTS6t7iH5Nv7ufdeMB225jLb4j2t68WFRON+fQg1UDgTM3g8Xt5y5+1rEfCVKlBlheNpq2Il2Q3qcpcgWIAkp+t7RlY3iPUSdoIpfb7+pAanyombdFeNuXUvrBltJMCj/JQjXmeLo/IjJN4wf21aNOLroRk04aUj8jTvBmJohBZ3ucNClIIwmGZQ0SjUuXHMtfPOEVo8NlCdVkspn5YnRKRsWq0Fy0Ur5I0S/feYB0yLQaNZ8xZZvh6uQnKk9W57y2sNTOmlY/In1fshAvaukMSUITCHhMFZ1SmVq6+Mz7noFkMfoTT2zsigfFLGmWMFbIls9WbkORn+zCPLSFI4bBjUG6HwJIR06hAgzU4scDAqKUIZkbrrtiCfC9wJz5r4yRdJZJCzMchXXJyhzkLQ0qHdHwk+3aVu+pntQ1kjiw+2c/J2juS7Ex44uxTIFr5DzRuvJhlEjhP42DkTHYSlmKsfA1R3L906AftQP7AN2McTub9N87mYbieg6snQpwMOXiK5CyWVtWFF1YVIIiKjqMtTLqp92Ugk+GN3D0AHbLsiOVtvWoAwjw+gYZydWa6Uq8ByUaiZx7wg88zGpjC8S+bQmyGwIyquiAHmqOQqMgZU9jTtMypq6Z1OJQ48en8tIwczVgzx4pQoUrMNTseTa1lpweOzqpdkuTl7DX6yz5fJqbVz1yjeXG9y8c25po1Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97402fae-1f6c-455e-8306-08dbb3963532
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2023 13:43:12.1535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XXeTjDV7dgXqM/Vf05gXga0+lxDfNPEkkOG5BjA9XF/OLNNX4J2pkmEvJ4CqBnLAevA9LFgNVws+JHQRoI3yCdwFyPjqWw9+yDbhOL2r2fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB8608
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTIuMDkuMjMgMTA6NTMsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiAzIHBhdGNoZXMgdG8g
Y2xlYW51cCBsaWJzYXMgZnVuY3Rpb25zIGRlY2xhcmF0aW9ucy4gTm8gZnVuY3Rpb25hbA0KPiBj
aGFuZ2VzLg0KPiANCj4gQ2hhbmdlcyBmcm9tIHYxOg0KPiAgICogQWRkZWQgc2FzX2luaXRfZGV2
KCkgZGVjbGFyYXRpb24gY2hhbmdlIHRvIHBhdGNoIDENCj4gICAqIEFkZGVkIEpvaG4ncyByZXZp
ZXcgdGFnDQo+IA0KPiBEYW1pZW4gTGUgTW9hbCAoMyk6DQo+ICAgIHNjc2k6IGxpYnNhczogTW92
ZSBsb2NhbCBmdW5jdGlvbnMgZGVjbGFyYXRpb25zIHRvIHNhc19pbnRlcm5hbC5oDQo+ICAgIHNj
c2k6IGxpYnNhczogRGVjbGFyZSBzYXNfc2V0X3BoeV9zcGVlZCgpIHN0YXRpYw0KPiAgICBzY3Np
OiBsaWJzYXM6IERlY2xhcmUgc2FzX2Rpc2NvdmVyX2VuZF9kZXYoKSBzdGF0aWMNCj4gDQo+ICAg
ZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZGlzY292ZXIuYyB8ICAyICstDQo+ICAgZHJpdmVycy9z
Y3NpL2xpYnNhcy9zYXNfaW5pdC5jICAgICB8ICA0ICsrLS0NCj4gICBkcml2ZXJzL3Njc2kvbGli
c2FzL3Nhc19pbnRlcm5hbC5oIHwgMTIgKysrKysrKysrKysrDQo+ICAgaW5jbHVkZS9zY3NpL2xp
YnNhcy5oICAgICAgICAgICAgICB8IDE3IC0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgNCBmaWxlcyBj
aGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4gDQoNCldoZW4gYXBw
bHlpbmcgdGhlIHBhdGNoZXMgY2hlY2twYXRjaC5wbCBzcGl0cyBvdXQgdGhpcyB3YXJuaW5nOg0K
DQpBcHBseWluZzogc2NzaTogbGlic2FzOiBNb3ZlIGxvY2FsIGZ1bmN0aW9ucyBkZWNsYXJhdGlv
bnMgdG8gc2FzX2ludGVybmFsLmgNCldBUk5JTkc6RlVOQ1RJT05fQVJHVU1FTlRTOiBmdW5jdGlv
biBkZWZpbml0aW9uIGFyZ3VtZW50ICdzdHJ1Y3QgDQphc2Rfc2FzX3BvcnQgKicgc2hvdWxkIGFs
c28gaGF2ZSBhbiBpZGVudGlmaWVyIG5hbWUNCiMxNjogRklMRTogZHJpdmVycy9zY3NpL2xpYnNh
cy9zYXNfaW50ZXJuYWwuaDo0OToNCit2b2lkIHNhc19kaXNjb3Zlcl9ldmVudChzdHJ1Y3QgYXNk
X3Nhc19wb3J0ICosIGVudW0gZGlzY292ZXJfZXZlbnQgZXYpOw0KDQp0b3RhbDogMCBlcnJvcnMs
IDEgd2FybmluZ3MsIDQ2IGxpbmVzIGNoZWNrZWQNCg0KT3RoZXIgdGhhbiB0aGUgYWJvdmUgbml0
Og0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdk
Yy5jb20+DQo=
