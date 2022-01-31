Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6A0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiAaKE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:04:26 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:5422 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348360AbiAaKEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:04:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643623462; x=1675159462;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=ikAyjOriOCy30G+8ctO8lGMv71pzuaHjJqGUlErevZ72njfcwQ4f62IJ
   XuQoRqqN+kGOWa8nTVHvZSIalTQFylQqahDaX4PIEB1u9bYoJxKCjQ1AK
   GMbNTrvkVDTld1AyMZy6W5vk1B5n2HtGLAWuS/+a3imejAzG/3PcheQmo
   srjXfgBGzPm9In2Civq51U6vJJEyNdUBThIdXbhmu9hthpVvIcaUpOMkq
   4vUCv8KBjUABLl2H34hEqrgXJZLoiju3bWV225V3x/pT3IDpIaj2Wt6jD
   pDQBAG5cS7zMxU+SheVmjWMLb77FX90eJUebV4mUgmJ+Hb22Mv5+G3ok6
   w==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="190741772"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:04:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gkutf1f02QVabIpIkvPhUdCXR/yan60F9AbAgGFVhaR3l8cHNf2ifYbkh2tHtQiN9IJzbd9KWFL5LcWaReWdT1MAOKpYUz+SnFqXpPcsZ0YAS4gkloyxE1vVB7QeUbyO3JxuFHbG6jcJuxWqEZ6++3ek1f9EzTpXzd/WU1VS2yZLGWW+R07UIoEaIK/D0EHAM++dQ5gwtL8vdqLjwmXdvdd9er9oInNn8AUyBY4pYYh4ojQF0EBoOG9i5ciCVGNNR0WlqxMcfqB2fBbM/naPtZTJAyXP1x4XTzm4M+fPGOBFlk1pS8/Q4cVJcZ+shSljoQkNQNWxGOzTafMxWgh1Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=UVR3pgZ4klqjHZ2Suvw6BvXrHGc+bisOUWA55WjpEzkABcutvgtHlskqVP88gQcfa3x9dWlXmA3vS6aDR1Fsa1nf70U9TXw+63wnLMoUnv3zSiZ7ORidCBjvLc3mVOqWW/1t21iLG6TOoeZd+UIK1wLpS61c7gUcH4qwwMDzRO36oQe4teXntoGAjup7E5Fg0MDJOroX55JXt3SWARck3OHUMjQ3K0CDbRMjGKydWjPE+iEPnrXmhNYQO3vvGnttNb7dZIdSkykFRfbuQsjH4LPRxJZ3IaUjYX4Q1OXbUp9hkfVE6r/kYaGYGM0rgscArqQgxTRd7yJFDBuvfl5opQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=MHG+04hCgm80bspYm5qeGYHX+fse69Ufna95tSa2GwovWOb1coku2nVWXE/YuVp+f77FCJ3tpR5H0UxC8o2T/StxIwAhYn5VxmlZNhP+wV9TPWHH6BLdPX1nRFBcTPx4oH4BjYkBFPTbhvtlAUebOmy1VJ8apkPCmgkIOiBAM4w=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by DM6PR04MB4794.namprd04.prod.outlook.com (2603:10b6:5:29::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 10:04:18 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340%7]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 10:04:18 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "schmitzmic@gmail.com" <schmitzmic@gmail.com>,
        "linux@rainbow-software.org" <linux@rainbow-software.org>,
        "hare@suse.com" <hare@suse.com>,
        "fthain@telegraphics.com.au" <fthain@telegraphics.com.au>,
        "fthain@linux-m68k.org" <fthain@linux-m68k.org>
Subject: Re: [PATCH 05/44] NCR5380: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH 05/44] NCR5380: Move the SCSI pointer to private command
 data
Thread-Index: AQHYFJVRerYEQxSZREGGBYW3mpCLB6x86qWA
Date:   Mon, 31 Jan 2022 10:04:18 +0000
Message-ID: <a04198a8cb02b3bf9bb25c7f365dfde01f6ed728.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-6-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cadb70e5-5655-48ac-fb81-08d9e4a10bbd
x-ms-traffictypediagnostic: DM6PR04MB4794:EE_
x-microsoft-antispam-prvs: <DM6PR04MB479423F7B00A6A023A1F55BC9B259@DM6PR04MB4794.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yi4rz9fr8COJEmxj5aDAOhfqHqL94UYxk4lTBTXa2HKIAvSalJ1LYX0zTItUKRRSPVz/CNUcb2Kf4g/BMRLB0/gnVNCcN3ZQoA1e6Qei+LS59SaXUCXHIffNgzLLy/hTjYBCmwmNhwcBFwVamuOH3W8nFQ2hQJylLPLApyY7krApj+V9L+PxBnWOKN/wU47mgbmjiujV2C9cEhHlNIBUEOMI+uRSIO+V5SMgypPKTw5wc/G7mjG9r395G5jF2FOwFf/kTswPcYJjzRbOmB5spFEJBLGnsDednJbLuaBktMh8DbwGZ3RB3aIospP5gRTCUOaQ09o9tSxk+wOOpiGqyPTTzj7w+rPjDaxDHf14Aq1QTWjFmAQN6iBDR14pT9a6P4gdu6iUfSkpTtPT0hIhhkvy2MhwiSmK4n3Elm9Umz9CD2lSRcaydbV5QP1oO3rYtzv2yTTw33GRbUWS+Oa9hSR1WbfXHSnTktmUfDuILPGDMvHThYx5zd3SAyi054CFftp7vpKNKmxtOo8YDvLI/nmsAEzCTMLZYkljGbAxlhQf1+OABJYNrks21N9jvXpyhv+MiKa4Jy7469qk99zlUJIEveEL/C3b5df6QBs3xmaT2E5RWfoHIbUMS4e1Z8/2M7uwZIS5cw+Q43vMA1OPSPCmlEpNXlDkefCdDZ0V3Lh7l6h11LHx59gCQnKsxwIcAEtoVdw48sSVmC9n4L291Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4270600006)(8936002)(8676002)(38100700002)(36756003)(82960400001)(122000001)(6512007)(19618925003)(316002)(38070700005)(6486002)(2616005)(2906002)(508600001)(558084003)(91956017)(71200400001)(76116006)(4326008)(110136005)(64756008)(66946007)(54906003)(66476007)(66446008)(66556008)(5660300002)(86362001)(6506007)(26005)(186003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emFhelhVeW9Sa3IwbXlaM1VWV1p1Qm85TkpUVlkyVlRoS3VTRFlIL1pPYWNi?=
 =?utf-8?B?YnUrZUovY3dHQXBoNWl4alpKS0JwZHZjUEE4ZFptc3haNUc5d29XcE1qSUQ0?=
 =?utf-8?B?cTBTSlgxakN6YUhVTWRmWHB2cHhPK01OWERjZGNiOGxHbnNMaXlQUERHd1NX?=
 =?utf-8?B?RnM0T3NsUkYyL25ERC9jRG1FcXU3c2lBeEhTbzFKY3AvazVuUFl1eVpkZEZY?=
 =?utf-8?B?bjJ5MzNqME5yRnhoM3pzc0VMbGlXN0FLcGxpbzVXSjJySjlOUERYRGhSZTl6?=
 =?utf-8?B?UFhraVZFT2dHQTVXMjVrUlRsazBHNEZqOUxSY1phV2l5bEFjWFl0dHlTQ0hu?=
 =?utf-8?B?cnhzY2FRRDk4VzY5cWo3RnRPeUt6RVkwcmYzbUtkUS83NHBOWnZ2b3loVEhT?=
 =?utf-8?B?aDJJVkkyOGNieTBtRjZ4dFBxYlROZ3pEZUdWSzdySnEyYjNHZGk3OXBISWtl?=
 =?utf-8?B?OGdMdTJjU3hPcnZTVGZrbkdEZXJCTjRpTkludXlNR3gvaVRpOHA4dkZ2bTdR?=
 =?utf-8?B?OVBUb1dhRWlseFo4UzJQSVpwSXFIbjJ6VFZOaDhGZmNnVHNvYW80Yjd1SE9v?=
 =?utf-8?B?eUxIRmpGeUZOeGx5L0Y3RGRUZDNPQWtSNGduTFVYbTNxN2c1L2dTMnNZWkVX?=
 =?utf-8?B?MEFTNXJYWVVRbEFkNmQ5U1g0QkZWRzBsay9vQkd6SFRhN1dhOEdLbEF2ajFM?=
 =?utf-8?B?aExTOU8xb0krM1orM2tLQmJKa1NyZnBmdjUxRlpwbGsvMzIvOFBxNDd3OE9E?=
 =?utf-8?B?aFQ2Tmtud29SUGwzMVVzemtpZjdHdWd5L3g1ZkNNM0I0ajBEdG9ySVR4RDlj?=
 =?utf-8?B?YXAzTm1Qa3lMNUp2dGhTNG5NU2duOVd2VVBBdkhvTTROdmZGcEtYU1ZIY2tn?=
 =?utf-8?B?MjVoMVNXVnQrcHpKYkZXckl0Y2lnTzJmaldsblNKM2FEckN5N28wNk5uem5N?=
 =?utf-8?B?aTlMTDBISkY4b2UvVDVYbHpJNC9UNm04d29qaGlRQlVXM3FrRWorN0JTanZ6?=
 =?utf-8?B?enpxeWZQYjdzYmU4dXVlVFRPYTB0ZG41YzM5R2xxVGZON0lCeHBISWtsTXdz?=
 =?utf-8?B?aE1YR3Y1bGovSi9heGZ2dXNYNVh2RDQ0eGxvK2ZFbEpJb2t5R1haaHlObk1n?=
 =?utf-8?B?TG1zK3ZxRVlzbHlGVGVQU1Fuc3BPdVB0ZFlHNzNxa0c4L0c3Q0RteDExbW9l?=
 =?utf-8?B?WXJQVERHcU56UE0wUDdac29FemFFdHlpRnRxVmNQR01CUm1vOHJyamlHQzYw?=
 =?utf-8?B?S3lSWjA1SEVYallFQkFyR0J3bFN4S2EzSEl1YUMvaVFxYzZaWHRyMTZiREJx?=
 =?utf-8?B?YmhsbEYvMVJUcnErMHF2Rm5UMXBRQ3RRZkJhTnpQWENZbUkyczY3SVRFbFQy?=
 =?utf-8?B?aW1QN2J4Ym12NVBYbkpqby83R2o5ZWNCMFlFWHBRVDVWbGVFS3A0cit5b01O?=
 =?utf-8?B?azRpZFl1cHRrT2pGU0VDVm5ENmM4WFJKcUU5WTBQQUtQS1M5MmRkcVIvQWti?=
 =?utf-8?B?cnlYQ0Z3eGpLV3krcFN5ZWlqNUE5WTlPMndxamNueUxPWWV6RnJveEEza1N3?=
 =?utf-8?B?ZHJzK00xd1VEWjVhN3pwUUhjVjNqdWlrQThtaDI0azdQYkl5RVNrbEtjUWgz?=
 =?utf-8?B?dk5zQ2drUlhxY1hTSkJqU3ZGc2tiY3Zva1FmblA5eHJYb0M1NmRCeEFSQkVM?=
 =?utf-8?B?R0R5d0ZOWW1lRjNJck1aNzV0blpXNWtvbHNOQmx3LzNoRzJCNjBvMlBaMUFO?=
 =?utf-8?B?SkNiR3o4ZlZUZ2dCaHd0NE9ua3hoNzRVb0JoVlhJV0phSFYrV1FabWNGSDZo?=
 =?utf-8?B?bDM2Q3NET0YxVFZ4TlpFblA0YXJLZFQ1aUU2SjlGVHdubXIyb1g1dmlENGlq?=
 =?utf-8?B?NzU2TWwyQTdZblREdGtUekZHUGZuakovWDRIZ3pkQU9GMXJ6b3lsdFNLQnFQ?=
 =?utf-8?B?ZnRlR25iNUdrdndOM3hWZ3h1dXEybW5vWU1TdUVOSjhhSkZXZ1h5U0l1cm1y?=
 =?utf-8?B?NmlSK0dwRXZiL3kzL3ErQVJJVnBveStDTkNwanh0SkFzZlpUckpZdE16dHpi?=
 =?utf-8?B?aXM1SUhFb2t6YWc4L2draERRenZGTTlVY3BMWmx1NXFhV2Fpc0dXZmc5WUpa?=
 =?utf-8?B?K0g4T0YrZE5maWx3ZzgzSXcwbC94TWU2WlRvN09FYmtKT3hDQThIK3NzcWVz?=
 =?utf-8?B?ZmxHUWdmaHYrcnduNVR5ZHFKWjY0ajUxZzF3RVN4OFJvMjJJUlBhbSsvR1pj?=
 =?utf-8?Q?AzKKvM6EkAttNVlo2kWaVhFPEcT4lKKtZdVFszGXGs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64D250489A8A3C4DA06A0323F64D3E09@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cadb70e5-5655-48ac-fb81-08d9e4a10bbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:04:18.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sZV0G/jalNb42vTa2eyBjTOkCkZFw6eMw+FlqM0jjxMscrkOovwW8Z6gEb1HTYNqLUNkIjCPol4bVUE6dDKCGINKMdL+pynXI4AMEcHDoew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4794
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
