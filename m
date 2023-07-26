Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4B4C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 10:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbjGZKz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 06:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjGZKz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 06:55:58 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AC52685
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 03:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690368956; x=1721904956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OB7pjOnf+Ud4n0dU5FPtzUj8zHxzx+N7ggmOdIxcW7c=;
  b=ETloAwa/3V/NieMaZ0M6NK88XxQgNmuZRnOareKrhT7DrIKkD6qWDtgK
   dxIyz1jJ10uLhs8tnKzS0N/YI6UETScngPfWwzdJzKsxR6G+sdcMPen6J
   JqqsxGz5GwDad0b2cIiBnFbrkI802owDyfe4grkeBUvwwKkFxy26lC7mH
   B+Rjd9zPcXvYFYZNHdci402JCXFEMVPptj8m1P3K1qN8F8xeq4t83NV7B
   XNsM1aJ0bqUw108G3xEk4g3k1ErplysvavEfSDe8WmN4hiik1BK0aoUE4
   DKWfKPx8cUFrYEtyjxyUSGImi9MQP1WTeKGfesFXwbLHejnDfSzkc3hF2
   g==;
X-IronPort-AV: E=Sophos;i="6.01,231,1684771200"; 
   d="scan'208";a="238942433"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2023 18:55:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knOvI2JStaKrYznppwmy3CYq6QfgOvNH/BExvqHGq82ivcR1NahF36gtUUdg8cibFik1BMcinGNctppqFAOC+AqUfHgw4+hP19Ak0P3vQ8a/SMs+xUiJBWCOvqkiiJjwNKSTzhnj+VxOiusOSGEhP2fTMpsAD6TgJc/1QlRyJp5BgSFa/Hakfkjl7EHtCBZlSUvSZb3H03+XD0FIk4mpCdXdy2L4HBkMSl7SOBiuROHcMiUv+UlNn/gQ5KrFHTtB9SlbG9pdVXq//NJqo3v17QUsFPjEaDSefR6CxRfJKK/Cq4p/fidRtE+SStuCCKwSyCE3xQXz7LOiFe9YYCpbjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OB7pjOnf+Ud4n0dU5FPtzUj8zHxzx+N7ggmOdIxcW7c=;
 b=S153QSIdp8ZkAd8lEbhPxkeNGNWATII85lkyqBsfT5OZ/DG46hi7T5Z3NGG25dQsyoqBZiCHBDkUbsG5u9wBVw+ffPzIcp5B/jTHae+klvC1xjo80k6hhQ2mnB+q6MSSxICM02vVxJlsNwIrsyby/9KtU1Ww3DyFuBxjyE8oByaK0qKkNpw8RK0gZV8oXGYCzmzq3n8KQmsZQpwNwWYpk7gWGON7CbyWuI18jKPhfrg+uD1CN2gVVXtPhs6ofdsKoyM0U7OIGaVcHXo1UwvuPNLgeHJQtSdtAuRKB5esjICvm7iRlLSftKS4IeH5mc/Ti5Nda/MWnogD4UnWql073w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OB7pjOnf+Ud4n0dU5FPtzUj8zHxzx+N7ggmOdIxcW7c=;
 b=yW1bhO8gbxwRk3sIMrG2Rpaai17FtDl9hhagnpXtJAHMZo8Ko0f5FRBlYJHrbquPztxUmpIIagPPtk/EVCfiTIdpphSEJdFRdNqhMp5d8G3b4oqrqurY+eZjL5vIiQ/RZLDLs8ASfH7DQMLkdhqAlFNTEYckVagDQa2+j1qcC0M=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7678.namprd04.prod.outlook.com (2603:10b6:a03:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 10:55:53 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::64cc:161:b43c:a656]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::64cc:161:b43c:a656%3]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 10:55:53 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Saurav Kashyap <skashyap@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] qedf: Changed string copy method for "stop_io_on_error"
 from sprintf to put_user
Thread-Topic: [PATCH] qedf: Changed string copy method for "stop_io_on_error"
 from sprintf to put_user
Thread-Index: AQHZv6m/eEiBnzXRwEucHLWJ1XK9Qa/L4CkA
Date:   Wed, 26 Jul 2023 10:55:52 +0000
Message-ID: <182fcf92-913f-81dc-6017-01435821bf80@wdc.com>
References: <20230726101236.11922-1-skashyap@marvell.com>
In-Reply-To: <20230726101236.11922-1-skashyap@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7678:EE_
x-ms-office365-filtering-correlation-id: 95304653-d9a1-4502-c7ce-08db8dc6e18a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QcTC0KAAOlsl+sLQsnP1O3nMqPeYhevsevS1PQFsDGKkKwFOYjwFQpdYyLYdWzsug0MyC8HEhV4K1+L1Wt1SqLVKdOOGYHovOrN7PYVuBDDa9XupTkPDs1+OngVEAbR392bTeuWT1A6vIZ7oGsmfLyGp0YXo1n5f7z19uzRHxe3D4LfYIRt87Gi2QgFPYe4C3fSA2p3bPbbOCOMXEIbymya+kpW/Tp5knnBupnuBhdZH3ldYTFyi9f3EDxUg4wExUu4LsRg7sganhiwocLNxotAXk9y5dY8psDzch3wPTBOU2zbrEzxqqFZhLBV4IM+V4s7YOvgz5xTVaGG6SI0w6QdY3Y3qtxsGFJKkUMz/2397TcDKnstJIcJuIftbe5py+4N45cWtJ2OcBTQ8rg/7pYGIfSTcBk69SA6VQFzVpadq7DgwCmQsdYp1uO07vO82aXsjNSddPfaGwLGYQ+UVehSUAGE/zkzFV2Sl0JQ69Gq/NsPG9ONMYotF+Od52Ijs5bWsXrY4EX8zv4SaGXKLsck6o6N7WalG17gLbzu0xkf0ElxWfhaQ1AXHRC/4HnPfirrXSGwvKa3JT3sP+tofs9PJBu4gE2lm8t0RUo/gKlZLgHvzk3YPbKc99Oq62Wci4uUFqst8uCpzUcutes0CzYQkMrdqISujLsUoA+Ildx4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199021)(31696002)(86362001)(186003)(6506007)(26005)(76116006)(38070700005)(4326008)(91956017)(66946007)(53546011)(64756008)(66446008)(66476007)(66556008)(6512007)(966005)(2616005)(558084003)(31686004)(36756003)(2906002)(122000001)(6486002)(478600001)(82960400001)(110136005)(71200400001)(41300700001)(38100700002)(316002)(8676002)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFlNbW1jU2kyOUdVaUVCWTh6SG5kNzc1T1BWUTdxd0EyZklCUEpkdGdwN3ZT?=
 =?utf-8?B?ZHB1bVpRMDRFdlI0Yy9VNGs0TjRuMDJ2T200MitlV2YwQmIwMUlnNmo4bW9M?=
 =?utf-8?B?VjNaVFZMTU1GSURKQVZob0M1aVFyTVZkMEptbW5yVWpYUEs0a2c1d3lUMW96?=
 =?utf-8?B?OHNzcnR4NnVjSEVqK2k4ek10akN1aTkvQms3VHV3ak1ENWkzSFNRU05PVzhZ?=
 =?utf-8?B?YmtFQmYyT1N6MkFZOVpFaFRXVmdkNnBTQldoNENuTk1GNTh2N1VWZEVSN0U5?=
 =?utf-8?B?QkJ6SGxWaS9jWjZPQkMwWmVPMEd6T1F0YVVZTGVuVzl3dmwrS2J2RmZMakYx?=
 =?utf-8?B?THlTZnNjMm9KUFB6UzB3N3BlNEN2V0hObWYrYmo1YWVJVUpMU05veS9ET2Q4?=
 =?utf-8?B?YTV5UHltaEVER3kra1hTVkZlNFNVcEdjMUpBZEovMEF0STFwVGdONlJNWTJG?=
 =?utf-8?B?cCtKUExFUnN5VGt0VVg0WTVhcWxWUDlOaGxzNFVDMmVMR3B2enBxM1FGL3h3?=
 =?utf-8?B?cU5IbWU3OTZwNStrVnNWQW9uSUllR1VQczI2QmZUSW5jdlFqdklyaUpSL2lH?=
 =?utf-8?B?Z2dGY25iT0FRZ1RYL1lFaXliSmlQdmc1UFR0VXlMNUVpUXpxM0o2cVdxYm1v?=
 =?utf-8?B?MEwyMTBLNWc4bmRobU40UGFWVTQ4L25NZXVybkZtSjQzc3p1RW16RTJZekpF?=
 =?utf-8?B?c0ZxU0twKzE4RlRhNHRtVTRlK1dGVUtVcWJOanRzRVFyQ1BRSVBvTHJpbTZq?=
 =?utf-8?B?QkpvWHNlV3N6VEVLQUk3enBlZ0Q1Z0ZheFVqNjJkOHdwbnFNMER5U3FTNThk?=
 =?utf-8?B?bkd5RU0xRW1BRW04UnpZMVBIUnBycUNSY0hNR0hoN0E5MlJVRXpHVklVNmRE?=
 =?utf-8?B?MmJtaUdKWHFFbU12Z0gwUVhVYkpnczErWHVMT0Z5ZXFiSWppVTFpVDEzemFn?=
 =?utf-8?B?TEdMY1V6ZmNlYmtVNG9PUDI3VjVybGNjK3NvaTc0NXJHV0VxeThETk03QlZV?=
 =?utf-8?B?WWMvZjU4VUlheFhrWnQya0pycnNsbTUxNzVvYWk2b2tpMmJGdUJ6aHJtUEFv?=
 =?utf-8?B?QnY1eTg1VW9aY0xYRHpPOXZwV3R6UnFmSkIxb0dUaU9sVWdrN2gzRytwcEk1?=
 =?utf-8?B?STVVaFh0YklHYWtYQUtLd0tOQXdvaUk3bUhMeHd6VWFzakhhZzJPdFJ1NWwx?=
 =?utf-8?B?bDdndG9BZFQ4SnNHMWF6Q3FWWjNqRTFtcGh2K2pKMlNSdkpHdkh2U0ZGVXBy?=
 =?utf-8?B?d3NYc1NvaDhXTWVzL0dLTmlXVGFYWXBDVkZHbHdXcTByWm1tOE9FS25FRHdO?=
 =?utf-8?B?S2FMeGEzZGtzNGZ1djFCN0xHTXhWRTk1UmQ0U0NsSVdYdWZwanNvbkJYemRs?=
 =?utf-8?B?dHlIUUt2emhZNkNqUXRzNXZKT2ZWOHdhOWdjU2gwYTF1SEtYbFBPQnpnYjdq?=
 =?utf-8?B?MTlkQkRieE51eCttbWJHbDZVZmFuNE9LMDJnbkl4cElHcHBvcFcyd3FEZXJO?=
 =?utf-8?B?MnJNNTJmd1NJQkxqRjdncEk1YVVON0Z0b1MwSHpzMjlvZG1FWDdUblRJdFVz?=
 =?utf-8?B?M0JrMlFEQVNsaHprL2NIaEh4LzBtakpjMlZJSVRRTVB6WWFyZXoxeVF6R2tz?=
 =?utf-8?B?Wkw2SjhGdVdkU2VjT3dSQXpKMHlHQ0wxa2QxL0lxQ09SZWZ6WHlRekNXZXZs?=
 =?utf-8?B?RjM0OW5iWFlCQjVONGI3Q2xBY2lwWG9Td2VvU1Q4VWxaNEE2Vi8zZGtwVTlL?=
 =?utf-8?B?ZHFjQVhOM3BlMno2b1d1N25lWEl0RUZvamdWbldyaXRSK0VsblVZSVdKMUtG?=
 =?utf-8?B?cVBpVU00bVA1T0RqUmlyblBQZnhMMlJ2citEUXN6RVVnRWhRTzlLSjdTcUM5?=
 =?utf-8?B?OXlNTys4NFFaUkd5Y2pUMWdHVmR0ekQzK1RlaXQ3V0pqQmlKbExCSThOSXlv?=
 =?utf-8?B?MmFic0dRMmpHRUx4RllJRWM0S21BODhSeUMvaGlyQnpIZ0x4RjFUOFZjencr?=
 =?utf-8?B?aFp4eXYrSWowQ1krWGFQRnQ1Ym1Ca3J0WGw5OFVxMUdEbllWS0VEKytoL0kw?=
 =?utf-8?B?VURwNFlicXRZditsZ1gxc1ZGWkFGMmpkRkhGZmV5bytuRXY5NW40N29YY2gr?=
 =?utf-8?B?U0FGYi9MeVUxRUJQWnFCTEtUTElWU0lBaXhIMTRpdVU4SUdIMitiaEpFRXI2?=
 =?utf-8?B?Rnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A540A795DD07A49A87E3699EAC847A3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PBfhR8v9s2zVirxtAEHJcZ6G2MOqw2CZjoRrR+/UVZ3KuSURWWRBJQl9yYpSoinNABKu6xM5oapoyHBJzGJf0qsPAyRXDHa9jbA0lxVpoAQF8l2xifcWgi5k+ZQB2HYdESI8CWApMqBmq2zBxJutEAyq0TDusxOgImK0xppcSrQ6/rzVKrsoaCBjucEHj6zddhpBE7rRj2X8zVeJWsKEOD3ZvaBrIFn0w9iM2vEuf3emiCOHtI6tyDsR6AT0n9QZn6nIE1+NXhieU0v6c5DN2cUVtub8i+BVt+4xjeiVDkVdQiOfhNJ2w5f90lEZNABvlypvy23tyBL+srhhnmmV9SH6TnsfMx5wIU3PtEO73IBYEhIrKXh4abC/Bwd9IttluFfFu7qGCqho8HhH4J/xneT5WyHT6pgjnQbIuPccRBpX0nENWhoSjjvic1oSXZcVkJHeO+LleaBfLduiJZfoWaq21hdYZR2x30q25Jp2VvjTAyTs+73+6BnkYpWYTChqqZXupc1GTuFCvT5UZMxbT9mCcN10pZDqXjGGsS+IyiCMiF7bi/46k1lXhnROHilXx+AO8neJKSQ9QmC/btGxAobsSpheQ15wtauCOi658dhrY6Uzzx26E0eZWAz/FzWwce5gdjKfXpd6B/X1BvljAI32ch350hhtcEMtaFtq/YSz4wJeHbb9kBkLMvBrGJITWN9hMw03Lw+0Ss44mUl7eMAmcNhad6Jfqu/V6c0RBW/qP/Ybk9EgvcUy/7xpfJj0ge6lz7QiKe1ZEkuS5GtZD44hf3q0Y22xMo7fFFIdCGVYaRSgd9+/VGlYE3SgXvcNIsBgOJsw1uYOgbfw2Z9kgw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95304653-d9a1-4502-c7ce-08db8dc6e18a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2023 10:55:52.9680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0JISW8KGEakHbuGmEKj5KnyldcL1diA+qI5Rf4HaiAH4vEdbwVHlDHkE7+ipzp/MgpHo3rOGW3BuGAchtr6792FvPQgN4qzSUq0ph4yZ3ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7678
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMjYuMDcuMjMgMTI6MTIsIFNhdXJhdiBLYXNoeWFwIHdyb3RlOg0KDQpUaGF0IG9uZSBzZWVt
cyB0byBiZSBhIGR1cGxpY2F0ZSBvZjoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
c2NzaS8yMDIzMDcyNDEyMDI0MS40MDQ5NS0yLW9sZWtzYW5kckByZWRoYXQuY29tLw0KDQpXaGlj
aCBsb29rcyBJTUhPIHdheSBuaWNlciB0aGFuIHRoZSBwdXRfdXNlcigpIGNhbGxzLg0KDQpSZWdh
cmRzLA0KDQogwqDCoMKgIEpvaGFubmVzDQoNCg==
