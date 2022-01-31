Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B958CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 09:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbiAaJxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 04:53:19 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19965 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiAaJxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 04:53:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643622795; x=1675158795;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=oAJzdQ3FftJlhpt4rK9b3tPhikdhiX9GDd1xvjgsnMQeqnnQ1NZA1AYp
   murRiacu7p+mkb924uGJsIUYpF5RXVOHZl8qf7SJ2pPCzunG7MjhlDFm7
   qlBVA80XFquNrXG4m/3sxZ4HUt7xiy7n2bmbl8dm/6q0SoEPkWg5mLKzZ
   OB0lNc2HsjPT0m+2jbj2mcRrvd54zKkIhrEAyZssc/TkemsgMDKfuuYf6
   obPSGw89FV3Cta9iEx4nctf3pj6EELPgKH96dGZyImP4wyqsUn1WkPgfr
   Iy+c4ubrXOj/+BAtzJYIJbEaBigOzDSxwEPd9JX/CYMWWzqVQkSVGCNsT
   g==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="196589845"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 17:53:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZWV1EDWb0xYpaDLI6OticM0d8u+Kflu+9osfTfJt1iiZYS+I6fTGoN9+lF3XescOoVz7Br0VpdhESxuPUUW4y07RxOCwUwT6+4l6XYkJG22p5f/KdQDTs98YsgpwP3NxJ+VMiO96pIg5SdOeRUK4vos/xadAZSAok0tcAZafGBgLbHkTCrM4dJGzxQdsBVdGGF0QF7lXqiickEq4gkCylvGvC5gAz5ygOCTpU1Ho5RIdgQX5yuy4g5eXwRSrwGB2dA1wV/AaEkgglhBoNBptV6U20aZImlVxyHlF9N59bVdeDOpcFpQeDQBvcnxqVeuT5K9WmmLiFou5C+H1x3DmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=O685faFyrGpNiyMQCqHahLcRuiokXs2tbzDXRwFNFdHlKdJhD1sbBjmTOPnG2GKvU+tsjW6Asw3pfi3cDcgWJ10qxWQ7aJG/Va8D90JNNFycytnhhXF04a2RsRnpEHZ4R5Tj+PbyBQkCEiNou1D82eo7KNW8yfGHuXcamzPebjPHg/rgUGIc7G2BY2gaWCoAfuWFZtYvJk1mffg7PyCgnUj+OaPb8PAc6dzwLyxPmTv0ZOGqWZJeI0SAm8n01qBcOpYKgYPOyyU47TtCcD1Qlw6TasOtLAQ7mo4ILfvM+XDvQw3Ifub7KC5T+GtNtwYqZd161wU3RjyP65kkZypUVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=AXQmV3cxW0vBqp6rDTDQK65q6L9Bf8GvkmuPdTJTuHt77whJJozLw7vSdXZoCUoglluiSfjMOOdqSzk+v4j2Z9tKCd7p+ECcXnGIfoJqPjqHu6CTxF5So9APbJ2zM79QhpllGv3nEL/JQd8/MUP16cSn/wjGX2Xfdb7vj9E1Jfk=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by CO6PR04MB8378.namprd04.prod.outlook.com (2603:10b6:303:141::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 09:53:14 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340%7]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 09:53:14 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "aacraid@microsemi.com" <aacraid@microsemi.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 01/44] ips: Use true and false instead of TRUE and FALSE
Thread-Topic: [PATCH 01/44] ips: Use true and false instead of TRUE and FALSE
Thread-Index: AQHYFJVJ02ma1LGW4EqwHIKuHaHcpax8546A
Date:   Mon, 31 Jan 2022 09:53:14 +0000
Message-ID: <73e0bbc5550c432acf27606b73c886198d98c275.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-2-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1364d541-c0bc-46b6-f937-08d9e49f7fad
x-ms-traffictypediagnostic: CO6PR04MB8378:EE_
x-microsoft-antispam-prvs: <CO6PR04MB83787F0BEB253534F9E6E2189B259@CO6PR04MB8378.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4xkB8T6bjRPZ2cc58RUQJOrf3ZvO/7giy76FL0OgekjfC6wD7EyWAySEhA0uOm4FDz2BJU062plN5Br4m/TV9212s9iyrS5Z7TECgrQVCjvXopIGazqxHGQ5NUShPi5NAmgvAiVM6ki1YydavV8o+31rTmfrwPmkHXRgSdVaBH1vbEYYld1KM0h/Dicn6FhDhBhhM45ExPn8gCAAuobgzlj3t0KId74rXDnTxOPA8OZo67Gn2v/Hrj4W5KbVBLe5g02puDeiVb7JBk5MT/OZpAtnjFsPp4/SOpe8XAFJPQWqEFactGqIZ6fDRSOOPRXCssq/qZ4QEvLp35jZLDPy/Oxdjo7ReAktnAa6nMQEiyDLXQLot8cqymz4ggfSFVPWD+aeh9kNjLSHZlRuVwG9tKcYS/YO72qcTXq4LcD/FvxIO9EGgODkIjgLmys3p82+YNzze+sCfzme2nOeF4jTWrxljFO+c4OuMGaYYSdt8Mg6ZTbUzHMQ8dGVZD9s/57pTD4UgxlBfQLQZm+A7UjlV9/tXwhlPU7Uz//VwW4WgR6qh3I1A2Hg7aCKLpqzQXF6ZAKdqGQW/DG++V5qmzKZt2hyr913bAd93zie0QDmzvDbEvlHJjQcV4VvpxDCWeU85QWi5+2SR3d899JKuVpa1LjfQ2OqdxcflgwUA8q8/HvHDupc+5s78MandBXHJF/QP7VV/yDdYiGOgUSogmLPtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(6512007)(26005)(186003)(19618925003)(4270600006)(558084003)(2906002)(2616005)(122000001)(66476007)(8936002)(38070700005)(86362001)(316002)(91956017)(38100700002)(6486002)(54906003)(110136005)(71200400001)(82960400001)(508600001)(4326008)(64756008)(36756003)(66946007)(76116006)(8676002)(66556008)(66446008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2x1dGFqWFBkNmhpU29lY0E1R3VoWEs2VUtWVnN1bnQ1SkU0a0ZoMHBEMmll?=
 =?utf-8?B?d3d1SW5vM2krQkJucUNLc0s2d2NNcEYyT2VtR1Vpb2JaeWt3SjV5eTR2WnZj?=
 =?utf-8?B?RngzUndTd1NBZnI3L0xJNnluMHVIVUQ0OGhzZENLWFhqc3ZyNENid0dzTGJl?=
 =?utf-8?B?bmhuYjNTWDR0YnhyMXJEUHBRQjBVMnNzTXFHNWJLZlI3eXhhMmlXbXRtOTdQ?=
 =?utf-8?B?ZW91OUJrKzk3b2haMWJxb0JhYU5DQ1phUWNHeFRJS1Jabkp2aDJGaXBnMXNH?=
 =?utf-8?B?RmhqVUYyMFR5MGNWaTlkUERaUUpMYjZ4NUVPMWczNkJDR0I2V3JweVBUK3ho?=
 =?utf-8?B?WHRBZTVJZmQ4S2dhQVk4dG5BYmV3OGVTU0NvU0ladFhGUEQ3VFVCQjR4cldS?=
 =?utf-8?B?NXVMYnpNcStadnFNazR6Q1ltTEZxamJuVEpYSUYvajVGRjZGNVA1Rk9nS0Np?=
 =?utf-8?B?MWFRWW1KUjdCSWpmYkdqUXNtejhENG9LUGQvaVRYK2ovelR2VzcrNWVzR0gy?=
 =?utf-8?B?L1IxQmNwL1d5S2Q5ZjB4R0tOaHVQK2tyQjdIRmVkRDVudGV6SnJoUWpCRUVl?=
 =?utf-8?B?T016d0UvK08wRnllSXZ0Y0J1L0FVaU5vSm5pYTJKam0xTFA4Qnc3TU96eU9K?=
 =?utf-8?B?OEdDd3pBMkZPcjJjK0dPM2dvdTJvQ284d01XbHhaQ0s2bjZOKzNwbHBQV2Ir?=
 =?utf-8?B?aDZtaHVNWXJWRUFzMVArRjNGbXkyMEFMSlo4UFB6TFJGQlQ5WTBtMWRwVmN2?=
 =?utf-8?B?MHFXWlVxc3JtNzVjWFJjSUtXNFFaZ2cwUUxibnBKNFF0b3k0WjZOT2pya1F3?=
 =?utf-8?B?R3RycFBqRzhQQW1qTVljSGV1R2pCUXRrbjFDUTJjbS9GamFVMEFUaUNHTTgr?=
 =?utf-8?B?MTBrY1l5U1F1RWR6aDJiRW9VcnJaYm1Pd09PcDE1M1RwL1c4Z0tEOUpaU0w1?=
 =?utf-8?B?V2o1ck42cXB0UWUrMTZpaU8rZ0t3YnY3dkJRRjUyb3dwRDRkUGZEazdkQmR1?=
 =?utf-8?B?Q3Z3L09kL0p5YXpMVVUyNHREUTRtODRpcURqc2ZmYktlSGNtUkg5eTlWRHZo?=
 =?utf-8?B?VDdIRUptVXBLaWhQQlRvWVFPTW0xdWIrZWk2OGZYN2FpcUl4aG00T0grWkN4?=
 =?utf-8?B?Qm9ZTjNBV2V0QW5SSjQ0TnFPa2RLNGhUMTkvd3FMWmw0WnRrRXJxTmIydGNE?=
 =?utf-8?B?UUtxQzhDcmtRZEZ1bC9icjYvQi9sbDVoMS9XazBubmZUTkxRa00vUDRPcVZt?=
 =?utf-8?B?NTdNVll0bGxvYUZnNGorWFBHbjdNZVlwQ3NDb1l3azZHTnJzY2dHbkJoTE1p?=
 =?utf-8?B?a0QxTUVpM240UzlzVG5DR2h1ZytEWHpFbE05R1BVcDBUOG14ZlF3YkppSzds?=
 =?utf-8?B?YzhTMURXQmcwRHVENkRyMWhvck43WEM3Q21iUjRBRmliNHJicWFCblMvcE1F?=
 =?utf-8?B?SFpTVFdZbFdXNllGMUg1VDhYVkZ2U2NVbENoUXBlZ3gyalZzM1h0OFROUUR3?=
 =?utf-8?B?R1J5N3VBZ2wzdmNXVUNubURwcW44TDFmcnJDTnQxVlFuZWt2alpTQWliMTkw?=
 =?utf-8?B?WTAvaDRiYTk3WGRwdjBNaFNPVDNzaXlpZWdGZzVCRnk1MFR0UDA2TVZOUUhE?=
 =?utf-8?B?blNrUk9ZbWV3ZFdhTDZ1Z3BUSUw2eEhFcVF6WjdUVlY1ZjJjdVJTVCtzSnY3?=
 =?utf-8?B?Rkg1Sk9YYTF6VUYwWFprRE13aGhHL3BWWStDVjR3Q0p5YkY3eDFEeFJsOHhK?=
 =?utf-8?B?ZVZFWHNvK1c2dmlkUHY3d3JxVFJHUGRCQ1ZCL2ZtWDZSMWpDMGZhcVFXU2Nl?=
 =?utf-8?B?UmFFU1J3OXhZNTNHNVRnTkptTkJIRjlQNXVQYy9oRFJHU3gzNFczTUVwdVpV?=
 =?utf-8?B?NmFBQ052c3hVejhOQWtBcWs2bHNpT0VNOFFSY1U0NElXQlJYUXU3UEdMajQw?=
 =?utf-8?B?USsvdlJ0YWE3d2RZZkl4QVNTa3BQWEd4WHAvRGhlc2VORkJoMjdOUnV0ZEZ3?=
 =?utf-8?B?Z0lFaFYrUjFTZVdnNFFpMTBRbE4xNmxNQ29YNlZmc2R0c3FwbXB1QTg2VkZt?=
 =?utf-8?B?VGRXaGg1QXF6dXFBODJXdDBSSytzWUZENnprcFR0MmIwenY4TWExNXdQY2xS?=
 =?utf-8?B?R09BanNDbk85TWhkRkU1RmRtRTdFY1pxajRtak00WWsya1hOekxnejg5MEVM?=
 =?utf-8?B?aHBOSFo2WldsVE1DYVBidlBkOXUxRDFyUzA3Qk1HVDFuRFoxQ2hkY21WTXVa?=
 =?utf-8?Q?oPOySsEkSvEv0IV6063Ps8kNnTpeCOkos/Rx/YipG4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62300B15A402B049841F93E1A9473EAB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1364d541-c0bc-46b6-f937-08d9e49f7fad
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 09:53:14.1271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 16dOCs7751eHTL2dt2/Qvx4lwEmAjE2tzrogVOoXsIvdEFDJyo0hYnVTZDx+ARmlVlI3/rSI5zv5MQxdyr+5Az7UXpr8geai3bwQFfNV2zU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8378
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
