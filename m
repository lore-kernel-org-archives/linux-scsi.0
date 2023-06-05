Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223C5C77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 12:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbjFEMk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 08:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbjFEMkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 08:40:24 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EA890;
        Mon,  5 Jun 2023 05:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685968823; x=1717504823;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=pa6RxqfYHpdxdqVzscbWMTCNn93iAnLzhHs4rQyTjDbeTB23nR46gXz0
   olc7vQkuXWR+FeQhwJphJWcZyWNYIcSTiP8SZW6W5rqEOJa81fO+9arhP
   T2puDvsIISaWKQDHHG0NN/QA9p90hButXtwOgHA/fnufEh7OiuRNqkDnK
   EXbVSrFnTP/lltDs61wwrH8UZQKiRjCx1KUrExK7v5kGdRwfVjB/Qsv6O
   Kfa132XD46fpl9oRbPVmcmFRfn8RUHijEST/54QV6DdatGGIn5VtUVz3T
   zq4tjFlAcMQ+6kiu+cwYMRlGV25S8eKwcfxeMCm9QiQfc60wMjUFj6swS
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681142400"; 
   d="scan'208";a="337044775"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2023 20:40:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBF6jpejIhQV2AHqGGrF7kQ7z2FutuKLuvGzc3lHOIki7jIaCKzpW3YJ0PnoOzlwAXJVn4XHecRm+mz6+2CC6cALXSrwqRGfos8O9iIY+1PXBkiyDEHt1MbfoDxdwRQNKcQ6aS3XheXNSAP6T0GKhrAM0GBpD6FpoB+Z4pr5JejuCcmCVi/vjafXRMBDceLAnU3i0L5tqLWS7yvZS4afQW9PW1e5BPj9avbcK9NwvoR+hfPUWUwJkg+VaKWWXhtFr+2Ex0II9MdrnaxX3fEFv8OLE9F/qIhw4+Vv0e2PG2Wa/gJWs8KCRvhrQyuTdkI0QbsQfIxoP8B/cDPMCiwQYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=TdEDiNAOZTnJAWcTRN1ww2EpO6bnS11Wn8FTJnq1O9Ruiu+3TXdpB4krEaxXMGcaneGVzc5lhWKYJdb2uyja79iMYUrXijrZPels3yUYLKcOuRc2TEA823QO9Pk/FjOKbITGXR24D7veUnMaIiDXLd5soJvf8SwiWpuZyIAI5hqDBXSZPP6G4St1dmVG5jaq1VS8vwKFqC/k5eC9NAGot820sNdbZNcRD1g4TwKSZJj/Mf9nwVB347CU+07ODSviyEYssZU8Yw14y1uolVlcwgqBlg/21vGMXln02uQCDDnma/IvhUvSsd5YvvW++Bv65PSJoGw75iJanVn6QyOg4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=LmdPLBs5bu2rtqZQ8/qHyC2xqZCQreftUOJYQWRkVGI6WkTPyoeUz6BXGNw8WIVrkiJskUDDCVLDttHxQVVDSpFNKti9BqyvVDLWs4tCAo6T34h2l2kUwoFmxxFX9EjwD7LB5fezox58bp/KlqUose/VD45l0eKZAIU145vILVI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6474.namprd04.prod.outlook.com (2603:10b6:5:1e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 12:40:19 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:40:19 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v2 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
Thread-Topic: [PATCH v2 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
Thread-Index: AQHZl5vs20rOacw7KkKKDiaOeh5rbK98CqSAgAAb6YA=
Date:   Mon, 5 Jun 2023 12:40:19 +0000
Message-ID: <5b443c3c-5c5b-92ce-a86e-5aea41eb4168@wdc.com>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
 <20230605105244.1045490-4-dlemoal@kernel.org>
 <275763b9-b9f2-b5c1-4866-4f5378c2361c@wdc.com>
In-Reply-To: <275763b9-b9f2-b5c1-4866-4f5378c2361c@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6474:EE_
x-ms-office365-filtering-correlation-id: 3d135d84-38e2-4d3c-4170-08db65c20590
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tsAmWU6VRSCUxPlSgt0t9KGqE1S58Q4NwXULY+ZEdDzYuY1hlDuxvAKAzLKnCf6eitcMH6egr/SFiiPLylD95INiDZyKW9/LGO/f9LR81xhdCHNW545Jie8RQae1Gj3h7C9lTEXRgHtchpx2yTQ2mqLevWtKdZ4Bhoeoue5A5lIGgXqyPAE2LDUYwfc2rXFTnTAn+BMZ/P7qacA61/HZtNyUE9qfMT/jwxZ5hOmn4ilOHQ9zV2xZbW3ldg+d0BLYcETxZu6xISRer4pbMAD662vzdR1ahZPgwycRlPPRJF3eb2G8KmQOiLv2M4lJ3aQTyZbwOYUo9SrCju9gO79yXqRFX/KZYzvnQLx8t1PWIDCayBMJyQzmhCHwXvA6ic+kXFGjv9mRwj5lUi1PU9b39A3CoSSFakTk92qJFXF0N3iNKXDqAO0Xt9GX+dwAKN5IqzgWt301cdNCOgkDz3Uyh7Wss5QvAJhHjjqLx2AFvuujHL3vvMnu0ew75WHF/UmVZ1rKK/iZ+PTNbor1PHmXyuWjV3BFk/8+/pdufkNiaY1TitJdEo6JiLtmr7Jj9xxoOn9BCFLns6pRDM7z5iZV+XVDVzZrdriNaVheia6O4f+PIDZyurQF+2QHBGUnuKfTfQT6pxS9IQM6dh/JFg6D73CdF4z2JYUKBAe4GkZpPqSuExElXZ7wlmnP2PWuRGH6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199021)(110136005)(54906003)(478600001)(91956017)(82960400001)(8936002)(8676002)(4326008)(76116006)(66946007)(66556008)(66476007)(64756008)(122000001)(316002)(38100700002)(66446008)(41300700001)(2616005)(186003)(4270600006)(71200400001)(6486002)(6512007)(26005)(6506007)(558084003)(31696002)(86362001)(19618925003)(5660300002)(38070700005)(2906002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVpOb25WVkZ0dVB6bGYvZGpmc2tTMEg3dEgzcmpac0FnWGFwTUl3NForbmZI?=
 =?utf-8?B?RWdVaWFwcnhzY3YzVUlLMXNyVEZiZEVmZmFiUkl4MTFsUnFPR1NZZ0JNTXhi?=
 =?utf-8?B?bVkzc1p4b09lZFZRaWp6cnJvV1ZlL0lzbTBnNVlZTE1XVUFIOFNpT3Avbmhl?=
 =?utf-8?B?WVVvNisxVGZqTVlqYTlFb0FUYUlWeXRuRjVvakkyN1ZRRHBCQ3ZSemx1TXBk?=
 =?utf-8?B?Q2R6MHNVbkt6b0tqcmVrWFpLdmZ6OHh0a3phNFFOUlZKWXZJakdBOW5lOWJG?=
 =?utf-8?B?R1J6L25sM2g3bHlyZjljTXpjaVRrdEV5TkhLOVBLUWtKWjBJLzRYVEZaeVQ3?=
 =?utf-8?B?YkpOYUdGM1BRS0I2bndHVjdhdTVSTUN3ek5CZno5YWI1bi9zRmxWZTYxNWdQ?=
 =?utf-8?B?MHM0NUJGbWtGc29lY3EyeHhWem16SGczc3NDakRkamhoU01LRWI2VUVURmRo?=
 =?utf-8?B?LzlqMTJPc2grVGtSWFAwQVRRL0tURGsrR21iam05b1BaQmhTVDRONkU1MmlB?=
 =?utf-8?B?My9saER3cFdpVzBCd1BjcCt1b0RmMldQZ2pwdGlqUng4Y3NPVWxrYUQrMVU0?=
 =?utf-8?B?VnFIUUV5VXVuQ2JLVEpTdHBBdkQvQVRUb25rQkhHSWMwcmZzN01jWlkwZnhv?=
 =?utf-8?B?WXZZK3dJMUNybWx0VGt3ZlhuWWVNWHpWU2IzSy80bTExdHNMbDBTSkI3ZXgv?=
 =?utf-8?B?czBmanNkaGNVcERaWnZMazFVWEp5OHRub2NKUHN6cXlLdkpQUGV0Q1gwU0N3?=
 =?utf-8?B?MmVKN2p2ZkllWElndUJSakpvQWVFQVZnY2hsWnl0YlVFejhPT3hVOVA4cXJv?=
 =?utf-8?B?K2hPTDVoTFM2ZzVMUDMyc016U0U5MmV6czJBbWpjdDkxajl6Z3Q2cW45eU9s?=
 =?utf-8?B?Q05QWXM2N1RBV1ZGdlRlZjBYUW9Fc1pCRThkakNVWW82RTdWaG93N25NS2pZ?=
 =?utf-8?B?STRUd3NQdzFwc0hNY3ZrbE1vUVRHNVZqMFFCeTU5VVA1OUExVkF3TDhxbUw1?=
 =?utf-8?B?OFFkS1FWdUFUZW1weTA4QUU2TWlvazRVY282S1d1N1VTaDFVQUZTdm9CblYx?=
 =?utf-8?B?S0YzNUo2TXFaaVBxbWdNVVVOZDlIaHFsMm9sWmJpdThaT1pTQkVaZnpHaEs1?=
 =?utf-8?B?Y3B5dlg4QlZacmlhbWJ3MmRVZWJGamlmcktpRFpLYVl2blF2cG96RCsxdkZR?=
 =?utf-8?B?dzhNOVNDVWkzUnVHU3JnZVhvaWdXeHA4aGVyVE05ckFKVGFJd3FDYnhoRzht?=
 =?utf-8?B?dk51bmsrZ0dGUjhadUw1SnJCYmw1SDRkUFRZbjlKWUUzOFVNVWJzU09GL1Ax?=
 =?utf-8?B?N2NxaFJZbGYxQWNSVXMxeU5Ra2hjbGEvQmFCODdqRjBCNHpvOTdOU2ZjTDlX?=
 =?utf-8?B?OWNlZmZWVHJXTEljL1R1TjVnSTVYdkF5MWZveFFPd2kzL09KeENJMWI2Tmpk?=
 =?utf-8?B?NHVmV0VqYStRekIyMlkraVVubUFBK3plUjg0cW41dDZZZTdadUxZMHZ1TDJN?=
 =?utf-8?B?U2taRkJiYWE4M2cwc09yRDEyQUVhbVM0OUVmRS8xa29IR1FQRkFya1NjQ3E1?=
 =?utf-8?B?eEUvZGVLYjdEamdCQlRSQ1NDU0tVU3ArNmYzdzlPSEpqTmdBejEwb245alh5?=
 =?utf-8?B?YWZ4NUUyeTNZOXVKKzFwZy90ekFvNUhObHpPR1p1YlFZWUk1QzE3ajFtanhq?=
 =?utf-8?B?elIyNWZFSHd0aHFxN0ZWUnhGZC9VUDZnYzRKbGdvYTMwUGhRNEdSUTBCay9S?=
 =?utf-8?B?ZWljMnFVbFlleGkzK2dtT0FBbERyRGN3MmdIaTd4ejNVRHkyT3dXRnNPclNH?=
 =?utf-8?B?Wk5yOGRQZ1AzMHNONjVBVTBmaWNzaVVuWG1kakxYSnBXZkVtK3dWQ0w0dis3?=
 =?utf-8?B?WWpxZWhnQUI4azZuVCtqMUliY0hRZzJGbUpqSmNnTnRzTVp4TUYxbkZzT0lq?=
 =?utf-8?B?enFaVDd3a3Q1b1l0dW9aN1VlRGJLZzZNN01ub1Ryd2lONzFDcDlqa0pBNzEx?=
 =?utf-8?B?RnE4ZndTMW1EWWlJeEI1TkxyRjlvTUxJaHpBeUh4TDk2bUsyQnF2SFpxRHla?=
 =?utf-8?B?Z09seFJZcnRHRHNTb1ZOSzQ0NkJJTVhSb3Q0VUEzQkVmTDVheEhQeFVUZFJN?=
 =?utf-8?B?bXBGOHBCbnY3ZkpVc2pVSjhNdU5QMVBzMEpJdjVsQ0djQXgxdzFHbnlBZjU4?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D521130067F0024DB13ECD078CBF8F72@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aySWT5S3hBg4HALLMhcTHF6eWV5y4NqFECt5NmvlJH0TuJ08RnfS50f5JTH4P0tEfxu2vLAFaP2qCFYu5ZmXXaOKXnu4mn888oEfWeNOpOHeMsJLr2Lnfh6MPKIaIawMCYAGasB+tr45SVxdrCbCAn+5mhJwt6V+mfXyvW8Ez4eB+vtmG0QeQ9Zv3EUjKLswObwc3/qeNw24X5/v4TAmP7vDCQEOn6K2IDj91/rslg6PtGmcnKqEwqZtMy8FmakM1aexgTIuswNWc0GlIzvpvf+Ol7SD4os/IQnYQ4JIU4eoy13WuDEmo1STNuOy15c3ykEUVJlyKHp9rhHyzNu2kq4PLzLHvKDpaQuVXUocRxfoe1DDecKimz0Q/ixpj8AEJToErfZj4Y+a8D1yn19klIuRUd3fLPzyd5qHqu3xECeUYc5heqzwgzctR6yxgVNBtZ0tw54MS+UUDJqtt4/2wiEQmOYH1Y8/H//8EUg9dfnV8Mkit8fl9R4tLJm9w96j4RN4l6lqdZLHDUmHiQKRpiCKmUatJOZZz6qOi3irxWYHoQTvGCjpg+aZyBbR5s4tc/4Pjzy+PSJVLEXkdQ/Sus72RRBgb2uvafaJC19GoOoLzD50Mxk+NHd91FR29soSWuXLoZXkOOBOjjq81GyHIg0f2TG07XdZPmAXuTgz5NBoZX3okrb9s5T/oLjfC3+YSMx5yKBmIg0ScmCcVG19ARE+JG0Yp/jlEZgqdUsjAFaGDKgWGEEVse1hfp/yazY35c3ALXvk/CadAx0vQrmsHWQb42ZH4t6vsg57czcnNCbhAbFnwM6LuvXMqjKeU6p1MqDH2veknvaNjr+QFHn/fgHnW2vIAu6YsXoA6uToG5EZwke1DCyG99h2ytNZslhM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d135d84-38e2-4d3c-4170-08db65c20590
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 12:40:19.3879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sy/MRwtUeHlpP5g6cCAwFNWqqGuSCrVzSZx4rDhVzavLrj7U2oqCbAkMvbt/4lVMZMQPa2I0xgcYMfIfXaj3HOAdEDr8wBydfi2Zgd7Tcng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6474
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
