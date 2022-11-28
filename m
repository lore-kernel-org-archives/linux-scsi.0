Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5D5C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 08:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiK1Iyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 03:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiK1Iyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 03:54:53 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BEDD2D1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 00:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669625692; x=1701161692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6NDuMi6EaOW5jndwSPTCMA2QwP1hlPw9383KSeEaGFk=;
  b=kN9PDxRM6fnodE+nSD42iVHVL6NjeXJpIo1OgQN+dKou2nDdKm54FRUR
   ox5hQS8INJw+u9EvAUXTwY5zgCAcwMbqycunkq+GQdBu7FnbBmr0wN3eO
   zCkgwQw2Dd2KWNUCsoHxac7O4h/WCBgAPEaHGhMwKTip27/iyitdquFQg
   vrocHPi2AldVJ+7+GhpxRAnnO+xEkNz8EqAyhfTT1+D6k3PEBXO3Irs3Y
   o9rO6ZUiHFieKJ0J6wJzAX7y0+6o0SSW5SMHldW0DnwxI83fH6Z1ZCNiW
   dbUmCk2mLjF0KVTbkJty658yKijVKPg///AeLvEtUwz1qw42xwqMXOWVm
   w==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665417600"; 
   d="scan'208";a="217325829"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 28 Nov 2022 16:54:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfatGNELToUt6QVSps8dryJ1Al3VxIVxnqgppeb8BlgT/JyH6qywx0toC0dfwt+aUfQ7MOxVc0l/c2F/if3Nlbi8eAk51XcekutCifV/X4R4BrSQWBfGAmTCxv62bNYpxYOcF1uld/vwrSoA1/dHgl6yxeNCdtcmL8Id+GQoAytXi/aspnpXlG0GsP9pWiy3ajlPFOMY2u9SQgv6KLUeuS00AFWcuR7yYXNBU+r5gbvO94zAV3GZ/2Q8joiwwsTJ8QOLxaIvJbr87KNIVrF2MMBbPnm0epsapj0H4qUzjolxZghKFrFZfROKMizosURkdEgOAojLWWaxbFK3padBwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NDuMi6EaOW5jndwSPTCMA2QwP1hlPw9383KSeEaGFk=;
 b=dHFB+yQDwQNvnxir4zuMlUFuulJKmR89FQqveHIMdwCx6fb7xA3Or9SBKCcOV38zzGcl7ESyNdA/hwMnAb/zOrl0VboWoiqw+EGtQgu+Imgq8I3AnC5XehThKMTH/JkbMFH1U3w5ES2ZPdJJse1+1lZejyZ4rTxhmAyU9SZJFWy7edl7JKoxAhOcoUt/EeCBecWZb/3MJbDleji3WiXFp2TG/7F9u6SgLR+WxhD8SxOBNRNNHC5KREh39jGOMxG00iMYp9esc62zXirpekI2EaGRKs9VXtAbzXvnIhwiQ+0fthq8nyOh6sbjZiI3uMoD0kGGtz6KzNUWhg6JwAa6eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NDuMi6EaOW5jndwSPTCMA2QwP1hlPw9383KSeEaGFk=;
 b=mFg1tOFbi7KHU9LqyG7Gj/RV2rUSavQUiO4MH6ZWmLk93zW3fqSD5LvG8JVREhVlGOWu0h7+vaCjvNtMip6dCP7YnhWte54CTSGfO8Z/KRKoSAWtGLCk8FqVdTtfaDLQ3r4flj24+A+CcLVDfCKbojbR4GBOndeqEDZz3LCGLss=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM8PR04MB7896.namprd04.prod.outlook.com (2603:10b6:8:3f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 08:54:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f4cd:7c80:5642:bf1a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f4cd:7c80:5642:bf1a%7]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:54:17 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     kernel test robot <lkp@intel.com>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHY+CDXCOC0I4eZpUuWZjylU2pizK4/dVyAgATqrICADCqsdYAABJMAgAOOdAA=
Date:   Mon, 28 Nov 2022 08:54:17 +0000
Message-ID: <185d6f59-fd60-1332-29fc-456b9606e77c@wdc.com>
References: <6a21e78a188e5a0d630acd771afee11c7d45d183.1668427228.git.johannes.thumshirn@wdc.com>
 <202211151344.VGP4HoGU-lkp@intel.com>
 <7c758dc6-692c-3aeb-a0de-05e4134f839f@wdc.com>
 <yq1h6ymo3wp.fsf@ca-mkp.ca.oracle.com>
 <969cf476-d732-9566-63e4-01fb23fa74fe@opensource.wdc.com>
In-Reply-To: <969cf476-d732-9566-63e4-01fb23fa74fe@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM8PR04MB7896:EE_
x-ms-office365-filtering-correlation-id: d2171ff9-c127-49f5-ef0d-08dad11e21bf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RfXDOOF+V3Zb0UlyzCoelFkIIp1MhQb8w6/abVIHJkBKYA4N7N7HldwDtGi4XDt9moaYekjuppG2cElKe+JWYLKHOPwhCiizTCpkJO33+Lh4HYBm7tmh0ixSLnVc3p2pWWm9UxAsd80Xg8auWQMpPX5eLgGiusrZMas6KkkO5qFIEzhC3Dm+5tgEm9O3j3kXkTKGh9OQnNIapcaXT2o0HUqveduhbZb7b9LIS/Run+Ww5M4YZKHTrRLglqkGPh1OxfeuwwuqoTFIQ+1u/ObzU1FOqshSH4SFvFePFbwtBkkv23ac6WHMLY5DpAAbNOFVSuhXZgH7PNygLnI/SEeRRcyKw+xiHZPpV1H7XlxN5gj4J2BavtENrcJXCQaZOUdjCy2vTEz6zK+pZr7MOEKyZAZ9onP1VfTmJcB8PDK+V8UTok1/G2Xi7XIPpTEgxqRhCS/XSFPJqbhXUekWIXOXcMYLjTiX250/dcFbLGibkBHF1HYOEBYsrBUhitxiU258vfBK4HVUokmYffX4G8jA9QOYe6cyAfdYuC20ojml7Cxc+WsPbVjngRDfTrO7lkoxwtL/J96RqsrED4eLqTc8kYekTu63/ysmTOrz6RUnTXu6NIUKOTwRbmaz0aW4XI0tO6bJWpJbWhh/FC2uA5SCTJxhgDrLRWcxKA2T7mUtXnFfEsgvv91nP8nhXnGIPRnw7DJ4Y+437eXZnwU1+TWk1JEJae+nv6ty8ikjatYqGK8+j4iHj5vNJ74pACU/8gfkl1IjmCARv5Zt0bwP+8/phQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199015)(31686004)(36756003)(186003)(76116006)(66946007)(41300700001)(8936002)(53546011)(64756008)(66446008)(91956017)(66556008)(66476007)(6512007)(8676002)(71200400001)(478600001)(2616005)(6486002)(6506007)(4326008)(38070700005)(31696002)(86362001)(83380400001)(2906002)(316002)(110136005)(54906003)(38100700002)(5660300002)(82960400001)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkpXeE9uamZjaGU0L0VXNmNZOG80dlN4VnNDamRrallQYnBqUjJKT01rd05Q?=
 =?utf-8?B?VHVSU0c3ZGg3WEV6WU9NMUtvelpxalZqZ2FHSmNyUWtkWTBadGZ0bjFCd0JZ?=
 =?utf-8?B?QjBqbSt5RHdqbGY3bDZwb1lnL1NjZVMwalh5NDQ2UGlIckJubFRxSURiYzdG?=
 =?utf-8?B?c1d0NFpZQjJ2MEdEc2FaM2pDOFpEd3FCY2NGd2tNMmhua29mNXJpb3IrcmhY?=
 =?utf-8?B?MWc0T1p3Y1E0L0hvOG80aEhoM1F1R01SS0Y2U2F0ei9TMCtkMVBYWHFFUW8y?=
 =?utf-8?B?dFZKYnB4UjRRNkRjYlgza3dSeVhIcjVGbHV3dE10YUxsb1pneGMvSGFqZW9N?=
 =?utf-8?B?bTc2TkNST3ptNXRuWm1qUEMyWldIdCt5UmFIWmNVazVTelFqc1R0QXAwclNU?=
 =?utf-8?B?dXR4ZGVjRVMwMDdBdFpJc2k2L08rSEh3YlA5K25URnd6cmNxMlMwRDZFd3ds?=
 =?utf-8?B?UWVrTTRTUVlrRVhhMkc1cVpYVTFUaVRUanFDSFMxc1U3MkQxUXc1bTkzRHZp?=
 =?utf-8?B?b2xhWVZmUkFBdVhlcUsrcVJwOUVSTFFnLzB1YUlKY2RRNlVSMmJ4OHBNWXZa?=
 =?utf-8?B?ZzlBNm00VHNRWHpIam5hKzV6SjFnUkp3WVVOUmd6aVpHV05EY2ZzdGZGaUlN?=
 =?utf-8?B?blZSQ3FkRGdRZmpYdmtPZWNPeUYvekQ4UEN1T1ZHUkQxK3Jmb0FzbmF5aGpJ?=
 =?utf-8?B?WmdEbXMwbExMMU9BSkdRNGFPN292WWw0V1djYUFqMXh5L0IwVWVhM2xuTzNK?=
 =?utf-8?B?alE1ZFhXV3hrZGNIa3V2cTRJdUxuajZXQWRoN3lQUEJVSEUwRHRBVk8vWXpO?=
 =?utf-8?B?RzRCZlRNS2lvNGRkTWoxbDl4MGo2eTR4aXFiSU81c3ZLYlBXV3c2MWhIMGox?=
 =?utf-8?B?aWl3N2FWNWcyR0NJczYwL3VML2E2aUJEMTJCRjFaWXZDTysrSitNSWswKzBC?=
 =?utf-8?B?VXkvc0dMb3M2cTFSbUtkcFNqTnJpYXBkTDRVK0M4empHbVRxOE1Na0NhYURk?=
 =?utf-8?B?d1RYazEyelZleGQ5ellBTlA4c0RWOXNTVWd4T1h6dDhadkF0Vjlrb1hQNjVV?=
 =?utf-8?B?ZnQvTlRxMEpzbzJWNHJIT2ZrMTA0dGlwWGlhcERvWUoyYnNnRmQ3d2RRUUFo?=
 =?utf-8?B?ZGkyd3Q4dWV0RzhPQkR3RkFCK1M1SStvaExGYVJWOWh6N29sdERkNUhBNEJI?=
 =?utf-8?B?U3JGQTZlN1ZCTUtiSnB4WXdnZHhPWGtXUXF0TmtERGY0amJBOEpVdnB1VGR6?=
 =?utf-8?B?N1llWVNhWk5XWkNta3NwNnRWTHc0czY4UmptbDlOZW5Mcm9rVEhtYy8vNU1M?=
 =?utf-8?B?L0hJa2RqbTFwdmFLUWV6eDYvTXJpYlphUGpaejV0aENpNDZTOFNzK2w5eVpt?=
 =?utf-8?B?TFlDeW1IaWZIN1dObVIzU0t5QWVEai83OTVxK2Y5MUNrS0ptZ09WNmlGZllP?=
 =?utf-8?B?M2liN1JPdkhKNlYzZG1keWVBU080T0l5WXZiYXU1STVsSEk1UGNEU0c2a093?=
 =?utf-8?B?TDVuOUs3ZEw5Tzc5YzhyMVN2ZVFic3JZYnpWZnVSRDlDV0V5dzZZM1ZJSlZ2?=
 =?utf-8?B?ajIzMTFDNVlTSDJaY0tnVG9lQjlIZ1pKRExMellKRkswQ0VMSzA5aHVHTGZH?=
 =?utf-8?B?ZnBCWm43N29pMVdrRmJ5OXlPcnI0TDFWaHd5SXNLNWhyaXFoNVUzSnpuVUh3?=
 =?utf-8?B?TVVwTEZ3MW0wdExQbldYSzlCLzF0bStJQkR6bStwZlJBRHgxSGcxVUkxVnNq?=
 =?utf-8?B?UE1YVTdRQWpiMW1LUkVxazhMSE5qZWxxYXROZGF3NnBCbWtRZUlxbHNqeXl6?=
 =?utf-8?B?a0YyTUVSK0ZOVGU5SE82RDRNeW1LOVkrcTFRbGlMV0ZiUkYvSGZsd24yOENs?=
 =?utf-8?B?ZG04enJhaG1VWFNVb1c2dlJwckQ3ZmlFOTd4cUdyWmRnK3JIeGZuTTVHbENZ?=
 =?utf-8?B?RGQwSHB2a3VwcHBLNit3aUswZDcxOEJXZVVyQnVHdVExc1dlKzNPRmVRMXJz?=
 =?utf-8?B?NzdweFpvYzRzdVZZaDViU0JiWFVJdmczZWRUUzJ6b28wdGh3QmthdmhuelB4?=
 =?utf-8?B?UEMwL1FJMitPZEJPREViVTdscHhyVDkyMkRkSDdHdFBUbTV3UjFPZDFYa2RC?=
 =?utf-8?B?OGw4MTBmcVB1ZGtYZkJWZWxCT1FuMnlGaHd4TUQxc2tvcks3OWZWa3JZZG12?=
 =?utf-8?B?ZG0wcWpIQ3NOUTRXRlFqZUtPTXNKMkUwZFN0VGtrOVEyMzhvajBJL20rSm1E?=
 =?utf-8?Q?zlaSK6TqO6giH4wNf0z//d/bkvYi/wbwAbQINsmO+s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9E8D6F0868CAB4C9D7A4DDAAF1BFD0C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FBtD0X3+9Se+xDy9JWFU5VDuQ7M6uvfzgeWQq5n5337r3F5Pw4UlaGhN01QywbO4D05CxrVskTrDqnlBVjHbo2os+1wPhBPCp9qCfseWi8u/O8r4AW2HDWrwNAWcrVMyZjeBYENlSfHIqFXUQWyZX5bio/K0L7ube2AeAdX2uYA3ZySLARinvunq6rU7B2NM44Tq08uY7x5q/6aWAGPp4qycNmIUAjEgpcKH8NOCq+ER30j1Qol9fEUyas0u9Nkyb1LegEp3ODj2CJYxkI11tNg2l7A3cuOXr5OZ64RHElCbVIyWS+ir4QCFyxeJhD0x/T1T16LFZBRyIVptY2zKNfplsE3sPmMeyV/DvsYw1sFyg4yD/8McbdUYSWhiiYnt7Ftv4++TfJiuz6iov+PJ84PMwTHA0XsZowo9nColOljW6wCkBl2RSq/3O6ExvvNdp9fdfXRFoRQKQxERh5ALCfugOdf4qpK2B4aj6Nm6Z9m7utyVtwQVHeLm+mwHTlbB4HVSAMOB5nl0nekVzj7Pgq8eOmRZcuu1rBjCMbZyimk7Pjn7yjz1GVfeR5o/jxB02B9IRrtg8I2LRAaZiVhLu3hYUmKdvHyftDsXHjVb8iX7K8WP4TrFqUlxrUsdITbCqoVJqFEMB6d9+9o3ohNAjhZlFHhdfecJpTg4RNGTIEEnF5mqZLZQ2yPqiPSga6oYzEqZfjSftS4a/bCdTcr0K55d6+xzxTkMTltN8VYdtoAsmJQi7Tn3HpGWDOU5Q8v7r17vWIAKEYv7vKuk6R/qACn5W77oj9fVVwfB6XwODsM+N5Yjvitrzb9lkgTQjZCADIZpqPmiNEwQrI1KuuN19flUFbB134uXaYSSdFvSZKH5KTp0QUQYYE2dTTT87YnjFogqVn2DeTscTr/b8BLPDQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2171ff9-c127-49f5-ef0d-08dad11e21bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:54:17.1641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 88iug/WnAMudVFpaEeTXxqDUdfZexb1/0rvqarnY2iH4X/Ke7OUh5FHFiXyV/c9lSrPlrFmxvWsPc13wFvWVvggUZQBJ+SkhMfnqd7demJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7896
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMjYuMTEuMjIgMDM6MzUsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBPbiAxMS8yNi8yMiAx
MToxOCwgTWFydGluIEsuIFBldGVyc2VuIHdyb3RlOg0KPj4NCj4+IEpvaGFubmVzLA0KPj4NCj4+
Pj4+PiBFUlJPUjogbW9kcG9zdDogIl9fdHJhY2Vwb2ludF9zY3NpX3ByZXBhcmVfem9uZV9hcHBl
bmQiIFtkcml2ZXJzL3Njc2kvc2RfbW9kLmtvXSB1bmRlZmluZWQhDQo+Pj4+Pj4gRVJST1I6IG1v
ZHBvc3Q6ICJfX1NDS19fdHBfZnVuY19zY3NpX3ByZXBhcmVfem9uZV9hcHBlbmQiIFtkcml2ZXJz
L3Njc2kvc2RfbW9kLmtvXSB1bmRlZmluZWQhDQo+Pj4+Pj4gRVJST1I6IG1vZHBvc3Q6ICJfX1ND
S19fdHBfZnVuY19zY3NpX3pvbmVfd3BfdXBkYXRlIiBbZHJpdmVycy9zY3NpL3NkX21vZC5rb10g
dW5kZWZpbmVkIQ0KPj4+Pj4+IEVSUk9SOiBtb2Rwb3N0OiAiX19TQ1RfX3RwX2Z1bmNfc2NzaV96
b25lX3dwX3VwZGF0ZSIgW2RyaXZlcnMvc2NzaS9zZF9tb2Qua29dIHVuZGVmaW5lZCENCj4+Pj4+
PiBFUlJPUjogbW9kcG9zdDogIl9fdHJhY2Vwb2ludF9zY3NpX3pvbmVfd3BfdXBkYXRlIiBbZHJp
dmVycy9zY3NpL3NkX21vZC5rb10gdW5kZWZpbmVkIQ0KPj4+Pj4+IEVSUk9SOiBtb2Rwb3N0OiAi
X19TQ1RfX3RwX2Z1bmNfc2NzaV9wcmVwYXJlX3pvbmVfYXBwZW5kIiBbZHJpdmVycy9zY3NpL3Nk
X21vZC5rb10gdW5kZWZpbmVkIQ0KPj4+Pg0KPj4+DQo+Pj4gSSBoYXZlIG5vIGNsdWUgd2hhdCBt
b2Rwb3N0IGlzIHRyeWluZyB0byB0ZWxsIG1lIGhlcmUuIFRoZXNlIHRyYWNlcG9pbnRzIGFyZW4n
dA0KPj4+IGluIGFueSB3YXkgZGlmZmVyZW50IHRvIHRoZSBvdGhlciB0cmFjZXBvaW50cyBpbiBT
Q1NJLg0KPj4NCj4+IEhhdmVuJ3QgaW52ZXN0aWdhdGVkLiBCdXQgSSBnZXQgdGhlIHNhbWUgZXJy
b3JzIGJ1aWxkaW5nIHNjc2ktc3RhZ2luZw0KPj4gd2l0aCB5b3VyIHBhdGNoIGFwcGxpZWQuIEJ1
aWxkcyBmaW5lIHdpdGhvdXQgaXQuIGdjYyAxMi4xLg0KPj4NCj4gDQo+IFRoaXMgaXMgbWlzc2lu
ZzoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV90cmFjZS5jIGIvZHJpdmVy
cy9zY3NpL3Njc2lfdHJhY2UuYw0KPiBpbmRleCA0MWE5NTAwNzU5MTMuLjIyNGIzOGMwZmIwZiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhY2UuYw0KPiArKysgYi9kcml2ZXJz
L3Njc2kvc2NzaV90cmFjZS5jDQo+IEBAIC0zODksMyArMzg5LDQgQEAgc2NzaV90cmFjZV9wYXJz
ZV9jZGIoc3RydWN0IHRyYWNlX3NlcSAqcCwgdW5zaWduZWQNCj4gY2hhciAqY2RiLCBpbnQgbGVu
KQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHNjc2lfdHJhY2VfbWlzYyhwLCBjZGIsIGxlbik7
DQo+ICAgICAgICAgfQ0KPiAgfQ0KPiArRVhQT1JUX1NZTUJPTChzY3NpX3RyYWNlX3BhcnNlX2Nk
Yik7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2RfemJjLmMgYi9kcml2ZXJzL3Njc2kv
c2RfemJjLmMNCj4gaW5kZXggOTU2ZDE5ODJjNTFiLi5lN2EwZTFhY2U2ZDAgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvc2NzaS9zZF96YmMuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvc2RfemJjLmMN
Cj4gQEAgLTE4LDYgKzE4LDcgQEANCj4gICNpbmNsdWRlIDxzY3NpL3Njc2kuaD4NCj4gICNpbmNs
dWRlIDxzY3NpL3Njc2lfY21uZC5oPg0KPiANCj4gKyNkZWZpbmUgQ1JFQVRFX1RSQUNFX1BPSU5U
Uw0KPiAgI2luY2x1ZGUgPHRyYWNlL2V2ZW50cy9zY3NpLmg+DQo+IA0KPiAgI2luY2x1ZGUgInNk
LmgiDQo+IA0KPiBXaXRoIHRoYXQsIGl0IGNvbXBpbGVzIGZpbmUuDQo+IA0KDQpUaGFua3MsIGJ1
dCBmb3IgbWUgaXQgZG9lc24ndCB3aGVuIEkgaGF2ZSBzY3NpX21vZCBidWlsdGluLA0Kb25seSBh
cyBhIG1vZHVsZSA6KA0KSWYgSSByZW1vdmUgdGhlIENSRUFURV9UUkFDRV9QT0lOVFMgaHVuayBp
dCBjb21waWxlcyBhZ2FpbiBhcw0KYnVpbHRpbiBidXQgYnJlYWtzIGFzIG1vZHVsZSA6KA0KDQo=
