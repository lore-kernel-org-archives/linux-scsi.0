Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D85C83F14
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbjHaBsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjHaBsk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:48:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596669C;
        Wed, 30 Aug 2023 18:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693446517; x=1724982517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hr//aLTCeyUNeWXsnU7POjwVfQfArjKS09hjvou5+vI=;
  b=k2Cct9K4GqpH1RgKWLLcp0cyEhZzbumZOnXmeCs1xLxNODV6NgFl2+CY
   3rIX6176hj5qV2sDlriYmvHTolcZAXMmoNaMFXnCH98KxXwaOotQouCF6
   aEShYvN3koqf4WgCxpQpyvydaO1OfZROcUfsR4/V4qcwz4hXenw8p+g/m
   Zl9VFypcsa2sb4cyfBQHME+4dYhF1MggJITkHxJ10jKkk+5Hr8WWIZS45
   J/S+4n6DBRdjYtIngr6ZUhJ8NnnU0ugZJ+oypQF7O7DcBIdwLVEPh7XZi
   YJvyAzE+eP/V4Xt1X5VyBUBc39zNaOAz7WO8BeYBnmO1AUSlMga97TkJV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="462167821"
X-IronPort-AV: E=Sophos;i="6.02,215,1688454000"; 
   d="scan'208";a="462167821"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 18:48:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="768616576"
X-IronPort-AV: E=Sophos;i="6.02,215,1688454000"; 
   d="scan'208";a="768616576"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 30 Aug 2023 18:48:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 18:48:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 30 Aug 2023 18:48:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 30 Aug 2023 18:48:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 30 Aug 2023 18:48:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jcg0KEU7XAvwPOUDgMQN1063RcyD9yfEUHOhC9Jwlg8yzv9LFNg1qT9emewOM+OC3VkBma92OeMV8icIphhFqAJoBcE65CQ0KNubg+dGgdJJsn0myRkPziqYz3eBmqa7/VXozeh2o7bplQqH0D9iAXLkwQDUJ3H67QBWAtSYIgSoVZBIvfpwrypEGMcqqXw1lWV3KaepcDiwQIp74V1Xyjsxzm72mlmGwJxMPEe3UZWq457BYh03uE+CXTeGaBuA36LNpJ10NR2U6PYckREu8+RMu5qMzLzE6hoHrCLYC4UDruPMsd/NfSaPbOSsMCO8h0sl1pUEYhbIpzqlmYjtew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hr//aLTCeyUNeWXsnU7POjwVfQfArjKS09hjvou5+vI=;
 b=S/CELMTJnzWXarm6iPImDbi5PK6ZCk8b34z0M+/j/v5UMA3DxVMbPmvtRoiifP2wYy3BBA/HlSa6j9yX+oX2WvA9BXEsaUBdCSQ938ArW8IOPCaYcOBlQ4WUgy7Px6EqNFZF9aDowpdtT3yxMeJeo24EGMHAi8LfhFrTm5gaoljixBLNpNC82gmWMCjtDK76A/AI9KnkcSGTAJp2ndyM5fTPSMVaG5TF6+RXfuziqNGKds19r1doJVfru9oLDaVcAsxgN2VS2jnjjbMTJLCfJuQwr8eZSLI2nWjtOcdCAUcX5loJKmPP9WaZ/C6qF6YXbziK4f2GP7YY2esqJKISmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by CH3PR11MB8237.namprd11.prod.outlook.com (2603:10b6:610:154::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.18; Thu, 31 Aug
 2023 01:48:32 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7f94:b6c4:1ce2:294]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7f94:b6c4:1ce2:294%5]) with mapi id 15.20.6745.020; Thu, 31 Aug 2023
 01:48:32 +0000
From:   "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
To:     "dlemoal@kernel.org" <dlemoal@kernel.org>
CC:     "regressions@leemhuis.info" <regressions@leemhuis.info>,
        "dalzot@gmail.com" <dalzot@gmail.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "paula@soe.ucsc.edu" <paula@soe.ucsc.edu>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Thread-Topic: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Thread-Index: AQHZ249d6fY5RDzH5U+34z2A7OKoarADjiKAgAAVOoA=
Date:   Thu, 31 Aug 2023 01:48:31 +0000
Message-ID: <9e09411348ae7469b4a9a7d076a8c42f84d12823.camel@intel.com>
References: <20230731003956.572414-1-dlemoal@kernel.org>
         <ZOehTysWO+U3mVvK@rdvivi-mobl4>
         <40adc06d-0835-2786-0bfb-83239f546d92@kernel.org>
         <ZOjgJl4nlieu3+kL@rdvivi-mobl4>
         <ccf3d87c-6517-6f01-a32a-4c98b841c7d4@kernel.org>
         <ZO+/Rz4Q5+qvj5Bs@intel.com>
         <289a94c6-a437-626f-c7c4-f0d3aa8c2b79@kernel.org>
In-Reply-To: <289a94c6-a437-626f-c7c4-f0d3aa8c2b79@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6059:EE_|CH3PR11MB8237:EE_
x-ms-office365-filtering-correlation-id: 5a760224-b851-4572-4c81-08dba9c4619e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GBuiDyN5m8wKWj29+olGatIqd4XdX6/cMxVXlQ9Qxi8/uYKVSby9MPcWgHqz6LeM6YGXyw4Cp/AuEDeXnw5vpW+0v1BKs0PPbgFrXmwjgIwJMvsbWRDuS2M0qT+7L1rTffbb72ajPfugc+6GHrpxFNIBdN+/5V6jcz5CKp0h0IjxcCsJajVXxUtwmjIVVxR9R9Gxm1pCcydRTwgy1L4DFqxj8Ar6Uyh6J4E0ICIKyaDLimo1ZjGbNfBLffht14mzVAmtMzFPI7CBV1ajRl7m/cPUKP6bKX6EwXGeUWVrjjvvbgeZV+nUes3QSO71TvRN2Z703tHcGCF5r225tuenuxLzXdrPtvf7nT+NW8/VgTc3slO8BM9Hj5aEn5GsocROhEYWECe4jp2wL0WuZa9Bx4gMMNciSJWo3mSnT+5C8SEphNAx86xYUEkph0nbHpLOtzhRKUQwseA4FUo/3ZWnSNgVc0b8RD8k9TJt7Bhqdp+DYUPE8PmE1gd4/azwceGqFrZ8xgscaKXyEmFl+niLz4t+Dz4bjUuPZNpLdqwt4JEvZ3g+7RRzLV7/vtk2481mZLVa6I0Zh2GAVgjcfIMtETykERm8B6g8YlyEMIb3anox1MT7Rlb0e6tC6SjR3etH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(396003)(366004)(39860400002)(1800799009)(186009)(451199024)(8936002)(91956017)(53546011)(478600001)(76116006)(122000001)(66556008)(66946007)(6506007)(64756008)(71200400001)(6486002)(66476007)(966005)(54906003)(66446008)(38070700005)(316002)(38100700002)(41300700001)(82960400001)(6512007)(8676002)(26005)(83380400001)(5660300002)(36756003)(2616005)(2906002)(86362001)(6916009)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1FnTU1KNWpMOFhScWM0bUs5a05INmtyMDdjUkZLcFNRU1RFc3RmSGl5WEhO?=
 =?utf-8?B?R0V2eGVvSjVBeFhBb3hsWG00YmlINzBRT3VGUThCSGFvSndUWGM2Zk9acG5S?=
 =?utf-8?B?Y0JVazh3Zk0yZlQrVGhpcUtzK00yekU4YU9EVnNQR3l1UGU1RnRkaXdZRWxZ?=
 =?utf-8?B?OGV2SFZHMHY5TjlsTDdZbG9TL1E2cmlTbWhqSGQ5QVcvNTFsM2VpQUFuQkNU?=
 =?utf-8?B?SHdWaFdMSlB5dGlnNm9FbXZZUkJtTGpYbWx4SkMyWGcxOGY5SlZaL2NGazhJ?=
 =?utf-8?B?VzN0dy8xRy85RHIyS3pGZUk1cXhRQzRDWGV4WENQVVgrYk1vOTUxRHlObUUw?=
 =?utf-8?B?WDVoZnp5NkY3OE9iVi9tZnFTWlBjRDFNWmwrVGltbUxaeUlkY3RUUi81Y2ty?=
 =?utf-8?B?MjZrTzB3VFhocmdlV1ZRZ1I3MGIwZkNBNUFlWXUyZHI5WmdNSVE1ZWNralh6?=
 =?utf-8?B?Q2NNZnQzeXBXdi9QdWgvMWFWRFpPeThrcWJFbkY4Y043TEVBSDVaMWVBdjRq?=
 =?utf-8?B?cTc4QnFRcTZSQ05mcGp1OWpibCs5Ung1ZFFlSTNoMUZWNE85dkNSQXVvVGNN?=
 =?utf-8?B?MDVZa29WWUQvTHh4em8zc25weTFsT0c2TUpkenpvTkw4NE9uMnltMHZBYkpM?=
 =?utf-8?B?bVFXRlU1WmY2TXFSUWJyTHpiRUJCeFd4QzJhS0dEaktuYXljMHhScVRjQ0dw?=
 =?utf-8?B?YVNVdWNTR2F6SStaam1NdjRCbExWdVd4Y0h6QTNSamZPQkF6ZmxBWC8wUklW?=
 =?utf-8?B?UjEyTk9tUk9ZaWpLc3JGSjZIK1BpKyt4SUJWOEtDOUl3MlFybEI5Ymc3a0w1?=
 =?utf-8?B?eEhSYlZrYWF3ZEo3eXhuMUdqLzYxSDBnWEIwWVIwNS8xbWRPL3RBUzM2OXBW?=
 =?utf-8?B?MmF2RVBCbE5EU1pBbjdldkpITTMwb0NLWGwvSU0rSFpDZ09qdFY1dU96NTJk?=
 =?utf-8?B?UkJYa2lKa1h5cmNWS1pLeWlRY0Z5RS82YS9jdkF5NCs1K05NZnJRSFNhZll3?=
 =?utf-8?B?MG5ITng5Q0t1clNMRGJIZG56MDN2SUFISVpWeWpsZFdzM0MxVS93MVN0b3JH?=
 =?utf-8?B?QlJIcW8wR0hBTnZGYmJacVRCQzZKblRlVHJlWWwzazNWaXhtRmdLcnhBZ3Fh?=
 =?utf-8?B?d0haNldhZGs1cWVkYTljbGIyK1BkVW1JS2dRbWdmZHJKaWw0VmJhcXRKS01B?=
 =?utf-8?B?Nkt5RDR1NUV4ZUcrMkJBbUVrVmZkTGFCZ09tSXJpQjNjM2VudEVKUHRBVFds?=
 =?utf-8?B?SFlhNDdKMzlwUlh4Ull5d1c2azdlMHROSDR2ZzFzOSsxaGJCU0dsdUgva1FG?=
 =?utf-8?B?WEJqMUw2VUdlbDQ1VEhLQkJ6cGUwRFAvUG1UUGlrcDVLSlFkS29RbkhBcVBH?=
 =?utf-8?B?cHlBUTRVZXlkK3RNb3NZdVJTLzFxYmZaTjArM280bFRyeUR5MlQybC9LcUhv?=
 =?utf-8?B?SE5WWEhuYndGZi9uKzQyY1FDM1JRWmZnNFI2L24vQXZISldXQXcxVnpUVWVu?=
 =?utf-8?B?ZFZkeC9XS28vUjh1VGE5Sk1ha0xRV00xVUpLMWcxdkEvTEdkVXBzVXRHaEd5?=
 =?utf-8?B?WHovMXZqdzRUR0hqMys0UStvbzdLcndRUGR0bGJ5K0U1Sjd3UGlsOHp0R3Fn?=
 =?utf-8?B?K01kdmxzeVNKSDZ5anZIUG40YkVIVEFIZCsrdGlhbFAwQ0w5Rkt2UE9WQjdU?=
 =?utf-8?B?SitOaG53b09saFNCWmlTYWlPM01WblROaUFsL0FvQjFFOElGbER1bnh5S2Fv?=
 =?utf-8?B?WVdjbTIxbWxvSFQ0WXlib0hUdG1uMUhOczNRUWRVaUdrVXVkNFNJREp4NkpB?=
 =?utf-8?B?RUVtSnBtdkw1V3hPeFhvTmxuWWVlcUNrRnlrV0N6U1hoRjVVcXJieE9sb1RN?=
 =?utf-8?B?ZzNXTUx1YTg2RHNjTlB1MDRrRmpacWRzVFRKaFZqVGUzT0JnM0poU01uK0Fo?=
 =?utf-8?B?cjlrd3FqbExYWERGTmpqMnNtZ093YjArby8vSU12ZzA3UkYxbXdIT0xZNkcx?=
 =?utf-8?B?VVBBcVVSY3M3VGFKTWlZRUJpQmJScGhtdnMrVDZyQm1ZSWJ1b1R4WlBEenBx?=
 =?utf-8?B?aThRSkkzMm9HWTdhRW9seTdOc256WmcwR09lUG9uZml0RmRGd0tpRUFGMGNR?=
 =?utf-8?B?UUF0YzA1eW5kbUkxTVgxVXdYMy9kOTZNME12VzRJcHgzd0w4ZFVUN1llNlZn?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB4551353A2E224DB1A1EA5DFD301068@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a760224-b851-4572-4c81-08dba9c4619e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2023 01:48:31.9364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sKkP5xiZ7jT2uyub03FGGYvdoqqxqIdMkrSnDUR0kJ2NAOf+vfJWapjVWS9K7yptVtBhUQzWeAqYhYcJho672w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8237
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIzLTA4LTMxIGF0IDA5OjMyICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gT24gOC8zMS8yMyAwNzoxNCwgUm9kcmlnbyBWaXZpIHdyb3RlOg0KPiA+IE9uIFR1ZSwgQXVn
IDI5LCAyMDIzIGF0IDAzOjE3OjM4UE0gKzA5MDAsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiA+
ID4gT24gOC8yNi8yMyAwMjowOSwgUm9kcmlnbyBWaXZpIHdyb3RlOg0KPiA+ID4gPiA+ID4gU28s
IG1heWJlIHdlIGhhdmUgc29tZSBraW5kIG9mIGRpc2tzL2NvbmZpZ3VyYXRpb24gb3V0DQo+ID4g
PiA+ID4gPiB0aGVyZSB3aGVyZSB0aGlzDQo+ID4gPiA+ID4gPiBzdGFydCB1cG9uIHJlc3VtZSBp
cyBuZWVkZWQ/IE1heWJlIGl0IGlzIGp1c3QgYSBtYXR0ZXIgb2YNCj4gPiA+ID4gPiA+IHRpbW1p
bmcgdG8NCj4gPiA+ID4gPiA+IGVuc3VyZSBzb21lIGZpcm13YXJlIHVuZGVybmVhdGggaXMgdXAg
YW5kIGJhY2sgdG8gbGlmZT8NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJIGRvIG5vdCB0aGluayBz
by4gU3VzcGVuZCB3aWxsIGlzc3VlIGEgc3RhcnQgc3RvcCB1bml0DQo+ID4gPiA+ID4gY29tbWFu
ZCB0byBwdXQgdGhlIGRyaXZlDQo+ID4gPiA+ID4gdG8gc2xlZXAgYW5kIHJlc3VtZSB3aWxsIHJl
c2V0IHRoZSBwb3J0ICh3aGljaCBzaG91bGQgd2FrZSB1cA0KPiA+ID4gPiA+IHRoZSBkcml2ZSkg
YW5kDQo+ID4gPiA+ID4gdGhlbiBpc3N1ZSBhbiBJREVOVElGWSBjb21tYW5kICh3aGljaCB3aWxs
IGFsc28gd2FrZSB1cCB0aGUNCj4gPiA+ID4gPiBkcml2ZSkgYW5kIG90aGVyDQo+ID4gPiA+ID4g
cmVhZCBsb2dzIGV0YyB0byByZXNjYW4gdGhlIGRyaXZlLg0KPiA+ID4gPiA+IEluIGJvdGggY2Fz
ZXMsIGlmIHRoZSBjb21tYW5kcyBkbyBub3QgY29tcGxldGUsIHdlIHdvdWxkIHNlZQ0KPiA+ID4g
PiA+IGVycm9ycy90aW1lb3V0IGFuZA0KPiA+ID4gPiA+IGxpa2VseSBwb3J0IHJlc2V0L2RyaXZl
IGdvbmUgZXZlbnRzLiBTbyBJIHRoaW5rIHRoaXMgaXMNCj4gPiA+ID4gPiBsaWtlbHkgYW5vdGhl
ciBzdWJ0bGUNCj4gPiA+ID4gPiByYWNlIGJldHdlZW4gc2NzaSBzdXNwZW5kIGFuZCBhdGEgc3Vz
cGVuZCB0aGF0IGlzIGNhdXNpbmcgYQ0KPiA+ID4gPiA+IGRlYWRsb2NrLg0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IFRoZSBtYWluIGlzc3VlIEkgdGhpbmsgaXMgdGhhdCB0aGVyZSBpcyBubyBkaXJl
Y3QgYW5jZXN0cnkNCj4gPiA+ID4gPiBiZXR3ZWVuIHRoZSBhdGEgcG9ydA0KPiA+ID4gPiA+IChk
ZXZpY2UpIGFuZCBzY3NpIGRldmljZSwgc28gdGhlIGNoYW5nZSB0byBzY3NpIGFzeW5jIHBtIG9w
cw0KPiA+ID4gPiA+IG1hZGUgYSBtZXNzIG9mIHRoZQ0KPiA+ID4gPiA+IHN1c3BlbmQvcmVzdW1l
IG9wZXJhdGlvbnMgb3JkZXJpbmcuIEZvciBzdXNwZW5kLCBzY3NpIGRldmljZQ0KPiA+ID4gPiA+
IChjaGlsZCBvZiBhdGEgcG9ydCkNCj4gPiA+ID4gPiBzaG91bGQgYmUgZmlyc3QsIHRoZW4gYXRh
IHBvcnQgZGV2aWNlIChwYXJlbnQpLiBGb3IgcmVzdW1lLA0KPiA+ID4gPiA+IHRoZSByZXZlcnNl
IG9yZGVyIGlzDQo+ID4gPiA+ID4gbmVlZGVkLiBQTSBub3JtYWxseSBlbnN1cmVzIHRoYXQgcGFy
ZW50L2NoaWxkIG9yZGVyaW5nLCBidXQNCj4gPiA+ID4gPiB3ZSBsYWNrIHRoYXQNCj4gPiA+ID4g
PiBwYXJlbnQvY2hpbGQgcmVsYXRpb25zaGlwLiBJIGFtIHdvcmtpbmcgb24gZml4aW5nIHRoYXQg
YnV0IGl0DQo+ID4gPiA+ID4gaXMgdmVyeSBzbG93DQo+ID4gPiA+ID4gcHJvZ3Jlc3MgYmVjYXVz
ZSBJIGhhdmUgYmVlbiBzbyBmYXIgZW5hYmxlIHRvIHJlY3JlYXRlIGFueSBvZg0KPiA+ID4gPiA+
IHRoZSBpc3N1ZXMgdGhhdA0KPiA+ID4gPiA+IGhhdmUgYmVlbiByZXBvcnRlZC4gSSBhbSBwYXRj
aGluZyAiYmxpbmQiLi4uDQo+ID4gPiA+IA0KPiA+ID4gPiBJIGJlbGlldmUgeW91ciBzdXNwaWNp
b3VzIG1ha2VzIHNlbnNlLiBBbmQgb24gdGhlc2UgbGluZXMsIHRoYXQNCj4gPiA+ID4gcGF0Y2gg
eW91DQo+ID4gPiA+IGF0dGFjaGVkIGVhcmxpZXIgd291bGQgZml4IHRoYXQuIEhvd2V2ZXIgbXkg
aW5pdGlhbCB0cmllcyBvZg0KPiA+ID4gPiB0aGF0IGRpZG4ndA0KPiA+ID4gPiBoZWxwLiBJJ20g
Z29pbmcgdG8gcnVuIG1vcmUgdGVzdHMgYW5kIGdldCBiYWNrIHRvIHlvdS4NCj4gPiA+IA0KPiA+
ID4gUm9kcmlnbywNCj4gPiA+IA0KPiA+ID4gSSBwdXNoZWQgdGhlIHJlc3VtZS12MiBicmFuY2gg
dG8gbGliYXRhIHRyZWU6DQo+ID4gPiANCj4gPiA+IGdpdEBnaXRvbGl0ZS5rZXJuZWwub3JnOnB1
Yi9zY20vbGludXgva2VybmVsL2dpdC9kbGVtb2FsL2xpYmF0YQ0KPiA+ID4gKG9yDQo+ID4gPiBo
dHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kbGVtb2FsL2xp
YmF0YS5naQ0KPiA+ID4gdCkNCj4gPiA+IA0KPiA+ID4gVGhpcyBicmFuY2ggYWRkcyAxMyBwYXRj
aGVzIG9uIHRvcCBvZiA2LjUuMCB0byBjbGVhbnVwIGxpYmF0YQ0KPiA+ID4gc3VzcGVuZC9yZXN1
bWUgYW5kDQo+ID4gPiBvdGhlciBkZXZpY2Ugc2h1dGRvd24gaXNzdWVzLiBUaGUgZmlyc3QgNCBw
YXRjaGVzIGFyZSB0aGUgbWFpbg0KPiA+ID4gb25lcyB0byBmaXgNCj4gPiA+IHN1c3BlbmQgcmVz
dW1lLiBJIHRlc3RlZCB0aGF0IG9uIDIgZGlmZmVyZW50IG1hY2hpbmVzIHdpdGgNCj4gPiA+IGRp
ZmZlcmVudCBkcml2ZXMgYW5kDQo+ID4gPiB3aXRoIHFlbXUuIEFsbCBzZWVtcyBmaW5lLg0KPiA+
ID4gDQo+ID4gPiBDb3VsZCB5b3UgdHJ5IHRvIHJ1biB0aGlzIHRocm91Z2ggeW91ciBDSSA/IEkg
YW0gdmVyeSBpbnRlcmVzdGVkDQo+ID4gPiBpbiBzZWVpbmcgaWYgaXQNCj4gPiA+IHN1cnZpdmVz
IHlvdXIgc3VzcGVuZC9yZXN1bWUgdGVzdHMuDQo+ID4gDQo+ID4gd2VsbCwgaW4gdGhlIGVuZCB0
aGlzIGRpZG4ndCBhZmZlY3QgdGhlIENJIG1hY2hpbmVyeSBhcyBJIHdhcw0KPiA+IGFmcmFpZC4N
Cj4gPiBpdCBpcyBvbmx5IGluIG15IGxvY2FsIERHMi4NCj4gPiANCj4gPiBodHRwczovL2ludGVs
LWdmeC1jaS4wMS5vcmcvdHJlZS9pbnRlbC14ZS9iYXQtDQo+ID4gYWxsLmh0bWw/dGVzdGZpbHRl
cj1zdXNwZW5kDQo+ID4gKGJhdC1kZzItb2VtMiBvbmUpDQo+ID4gDQo+ID4gSSBqdXN0IGdvdCB0
aGVzZSAxMyBwYXRjaGVzIGFuZCBhcHBsaWVkIHRvIG15IGJyYW5jaCBhbmQgdGVzdGVkIGl0DQo+
ID4gYWdhaW4NCj4gPiBhbmQgaXQgc3RpbGwgKmZhaWxzKiBmb3IgbWUuDQo+IA0KPiBUaGF0IGlz
IGFubm95aW5nLi4uIEJ1dCBJIHRoaW5rIHRoZSBtZXNzYWdlcyBnaXZlIHVzIGEgaGludCBhcyB0
bw0KPiB3aGF0IGlzIGdvaW5nDQo+IG9uLiBTZWUgYmVsb3cuDQo+IA0KPiA+IA0KPiA+IFvCoMKg
IDc5LjY0ODMyOF0gW0lHVF0ga21zX3BpcGVfY3JjX2Jhc2ljOiBmaW5pc2hlZCBzdWJ0ZXN0IHBp
cGUtQS0NCj4gPiBEUC0yLCBTVUNDRVNTDQo+ID4gW8KgwqAgNzkuNjU3MzUzXSBbSUdUXSBrbXNf
cGlwZV9jcmNfYmFzaWM6IHN0YXJ0aW5nIGR5bmFtaWMgc3VidGVzdA0KPiA+IHBpcGUtQi1EUC0y
DQo+ID4gW8KgwqAgODAuMzc1MDQyXSBQTTogc3VzcGVuZCBlbnRyeSAoZGVlcCkNCj4gPiBbwqDC
oCA4MC4zODA3OTldIEZpbGVzeXN0ZW1zIHN5bmM6IDAuMDAyIHNlY29uZHMNCj4gPiBbwqDCoCA4
MC4zODY0NzZdIEZyZWV6aW5nIHVzZXIgc3BhY2UgcHJvY2Vzc2VzDQo+ID4gW8KgwqAgODAuMzky
Mjg2XSBGcmVlemluZyB1c2VyIHNwYWNlIHByb2Nlc3NlcyBjb21wbGV0ZWQgKGVsYXBzZWQNCj4g
PiAwLjAwMSBzZWNvbmRzKQ0KPiA+IFvCoMKgIDgwLjM5OTI5NF0gT09NIGtpbGxlciBkaXNhYmxl
ZC4NCj4gPiBbwqDCoCA4MC40MDI1MzZdIEZyZWV6aW5nIHJlbWFpbmluZyBmcmVlemFibGUgdGFz
a3MNCj4gPiBbwqDCoCA4MC40MDgzMzVdIEZyZWV6aW5nIHJlbWFpbmluZyBmcmVlemFibGUgdGFz
a3MgY29tcGxldGVkDQo+ID4gKGVsYXBzZWQgMC4wMDEgc2Vjb25kcykNCj4gPiBbwqDCoCA4MC40
MzkzNzJdIHNkIDU6MDowOjA6IFtzZGJdIFN5bmNocm9uaXppbmcgU0NTSSBjYWNoZQ0KPiA+IFvC
oMKgIDgwLjQzOTcxNl0gc2VyaWFsIDAwOjAxOiBkaXNhYmxlZA0KPiA+IFvCoMKgIDgwLjQ0ODAx
MV0gc2QgNDowOjA6MDogW3NkYV0gU3luY2hyb25pemluZyBTQ1NJIGNhY2hlDQo+ID4gW8KgwqAg
ODAuNDQ4MDE0XSBzZCA3OjA6MDowOiBbc2RjXSBTeW5jaHJvbml6aW5nIFNDU0kgY2FjaGUNCj4g
PiBbwqDCoCA4MC40NTM2MDBdIGF0YTYuMDA6IEVudGVyaW5nIHN0YW5kYnkgcG93ZXIgbW9kZQ0K
PiANCj4gVGhpcyBpcyBzZCA1OjA6MDowLiBBbGwgZ29vZCwgb3JkZXJlZCBwcm9wZXJseSB3aXRo
IHRoZQ0KPiAiU3luY2hyb25pemluZyBTQ1NJIGNhY2hlIi4NCj4gDQo+ID4gW8KgwqAgODAuNDY0
MjE3XSBhdGE1LjAwOiBFbnRlcmluZyBzdGFuZGJ5IHBvd2VyIG1vZGUNCj4gDQo+IFNhbWUgaGVy
ZSBmb3Igc2QgNDowOjA6MC4NCj4gDQo+ID4gW8KgwqAgODAuODEyMjk0XSBhdGE4OiBTQVRBIGxp
bmsgdXAgNi4wIEdicHMgKFNTdGF0dXMgMTMzIFNDb250cm9sDQo+ID4gMzAwKQ0KPiA+IFvCoMKg
IDgwLjgxODUyMF0gYXRhOC4wMDogRW50ZXJpbmcgYWN0aXZlIHBvd2VyIG1vZGUNCj4gPiBbwqDC
oCA4MC44NDI5ODldIGF0YTguMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMzDQo+IA0KPiBBcmcg
ISBzZCA3OjA6MDowIGlzIHJlc3VtaW5nICEgQnV0IHRoZSBhYm92ZSAiU3luY2hyb25pemluZyBT
Q1NJDQo+IGNhY2hlIiB0ZWxscw0KPiB1cyB0aGF0IGl0IHdhcyBzdXNwZW5kaW5nIGFuZCBsaWJh
dGEgRUggZGlkIG5vdCB5ZXQgcHV0IHRoYXQgZHJpdmUgdG8NCj4gc3RhbmRieS4uLg0KPiANCj4g
PiBbwqDCoCA4MC44NDc2NjBdIGF0YTguMDA6IEVudGVyaW5nIHN0YW5kYnkgcG93ZXIgbW9kZQ0K
PiANCj4gLi4uIHdoaWNoIGhhcHBlbnMgaGVyZS4gU28gaXQgbG9va3MgbGlrZSBsaWJhdGEgRUgg
aGFkIGJvdGggdGhlDQo+IHN1c3BlbmQgYW5kDQo+IHJlc3VtZSByZXF1ZXN0cyBhdCB0aGUgc2Ft
ZSB0aW1lLCB3aGljaCBpcyB0b3RhbGx5IHdlaXJkLg0KDQphbHRob3VnaCBpdCBsb29rcyB3ZWly
ZCwgaXQgdG90YWxseSBtYXRjaGVzIHRoZSAndXNlIGNhc2UnLg0KSSBtZWFuLCBpZiBJIHN1c3Bl
bmQsIHJlc3VtZSwgYW5kIHdhaXQgYSBiaXQgYmVmb3JlIHN1c3BlbmQgYW5kIHJlc3VtZQ0KYWdh
aW4sIGl0IHdpbGwgd29yayAxMDAlIG9mIHRoZSB0aW1lLg0KVGhlIGlzc3VlIGlzIHJlYWxseSBv
bmx5IHdoZW4gYW5vdGhlciBzdXNwZW5kIGNvbWVzIHJpZ2h0IGFmdGVyIHRoZQ0KcmVzdW1lLCBp
biBhIGxvb3Agd2l0aG91dCBhbnkgd2FpdC4NCg0KPiANCj4gPiBbwqDCoCA4MS4xMTk0MjZdIHhl
IDAwMDA6MDM6MDAuMDogW2RybV0gR1QwOiBzdXNwZW5kZWQNCj4gPiBbwqDCoCA4MS44MDA1MDhd
IFBNOiBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUgYWZ0ZXIgMTM2Ny44MjkgbXNlY3MNCj4g
PiBbwqDCoCA4MS44MDY2NjFdIFBNOiBzdGFydCBzdXNwZW5kIG9mIGRldmljZXMgY29tcGxldGUg
YWZ0ZXIgMTM5MC44NTkNCj4gPiBtc2Vjcw0KPiA+IFvCoMKgIDgxLjgxMzI0NF0gUE06IHN1c3Bl
bmQgZGV2aWNlcyB0b29rIDEuMzk4IHNlY29uZHMNCj4gPiBbwqDCoCA4MS44MjAxMDFdIFBNOiBs
YXRlIHN1c3BlbmQgb2YgZGV2aWNlcyBjb21wbGV0ZSBhZnRlciAyLjAzNg0KPiA+IG1zZWNzDQo+
IA0KPiAuLi5hbmQgUE0gc3VzcGVuZCBjb21wbGV0ZXMgaGVyZS4gUmVzdW1lICJzdGFydHMiIG5v
dyAoYnV0IGNsZWFybHkgaXQNCj4gc3RhcnRlZA0KPiBlYXJsaWVyIGFscmVhZHkgZ2l2ZW4gdGhh
dCBzZCA3OjA6MDowIHdhcyByZWFjdGl2YXRlZC4NCg0KdGhhdCBpcyB3ZWlyZC4NCg0KPiANCj4g
PiDvv71bwqDCoCA4Mi40MDM4NTddIHNlcmlhbCAwMDowMTogYWN0aXZhdGVkDQo+ID4gW8KgwqAg
ODIuNDg5NjEyXSBudm1lIG52bWUwOiAxNi8wLzAgZGVmYXVsdC9yZWFkL3BvbGwgcXVldWVzDQo+
ID4gW8KgwqAgODIuNTYzMzE4XSByODE2OSAwMDAwOjA3OjAwLjAgZW5wN3MwOiBMaW5rIGlzIERv
d24NCj4gPiBbwqDCoCA4Mi41ODE0NDRdIHhlIFJFR1sweDIyM2E4LTB4MjIzYWZdOiBhbGxvdyBy
ZWFkIGFjY2Vzcw0KPiA+IFvCoMKgIDgyLjU4NjcwNF0geGUgUkVHWzB4MWMwM2E4LTB4MWMwM2Fm
XTogYWxsb3cgcmVhZCBhY2Nlc3MNCj4gPiBbwqDCoCA4Mi41OTIwNzFdIHhlIFJFR1sweDFkMDNh
OC0weDFkMDNhZl06IGFsbG93IHJlYWQgYWNjZXNzDQo+ID4gW8KgwqAgODIuNTk3NDIzXSB4ZSBS
RUdbMHgxYzgzYTgtMHgxYzgzYWZdOiBhbGxvdyByZWFkIGFjY2Vzcw0KPiA+IFvCoMKgIDgyLjYw
Mjc2NV0geGUgUkVHWzB4MWQ4M2E4LTB4MWQ4M2FmXTogYWxsb3cgcmVhZCBhY2Nlc3MNCj4gPiBb
wqDCoCA4Mi42MDgxMTNdIHhlIFJFR1sweDFhM2E4LTB4MWEzYWZdOiBhbGxvdyByZWFkIGFjY2Vz
cw0KPiA+IFvCoMKgIDgyLjYxMzI4MV0geGUgUkVHWzB4MWMzYTgtMHgxYzNhZl06IGFsbG93IHJl
YWQgYWNjZXNzDQo+ID4gW8KgwqAgODIuNjE4NDU0XSB4ZSBSRUdbMHgxZTNhOC0weDFlM2FmXTog
YWxsb3cgcmVhZCBhY2Nlc3MNCj4gPiBbwqDCoCA4Mi42MjM2MzRdIHhlIFJFR1sweDI2M2E4LTB4
MjYzYWZdOiBhbGxvdyByZWFkIGFjY2Vzcw0KPiA+IFvCoMKgIDgyLjYyODgxNl0geGUgMDAwMDow
MzowMC4wOiBbZHJtXSBHVDA6IHJlc3VtZWQNCj4gPiBbwqDCoCA4Mi43MjgwMDVdIGF0YTc6IFNB
VEEgbGluayBkb3duIChTU3RhdHVzIDQgU0NvbnRyb2wgMzAwKQ0KPiA+IFvCoMKgIDgyLjczMzUz
MV0gYXRhNTogU0FUQSBsaW5rIHVwIDYuMCBHYnBzIChTU3RhdHVzIDEzMyBTQ29udHJvbA0KPiA+
IDMwMCkNCj4gPiBbwqDCoCA4Mi43Mzk3NzNdIGF0YTUuMDA6IEVudGVyaW5nIGFjdGl2ZSBwb3dl
ciBtb2RlDQo+ID4gW8KgwqAgODIuNzQ0Mzk4XSBhdGE2OiBTQVRBIGxpbmsgdXAgNi4wIEdicHMg
KFNTdGF0dXMgMTMzIFNDb250cm9sDQo+ID4gMzAwKQ0KPiA+IFvCoMKgIDgyLjc1MDYxOF0gYXRh
Ni4wMDogRW50ZXJpbmcgYWN0aXZlIHBvd2VyIG1vZGUNCj4gPiBbwqDCoCA4Mi43NTU5NjFdIGF0
YTUuMDA6IGNvbmZpZ3VyZWQgZm9yIFVETUEvMTMzDQo+ID4gW8KgwqAgODIuNzYwNDc5XSBhdGE1
LjAwOiBFbmFibGluZyBkaXNjYXJkX3plcm9lc19kYXRhDQo+ID4gW8KgwqAgODIuODM2MjY2XSBh
dGE2LjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEzMw0KPiA+IFvCoMKgIDg0LjQ2MDA4MV0gYXRh
ODogU0FUQSBsaW5rIHVwIDYuMCBHYnBzIChTU3RhdHVzIDEzMyBTQ29udHJvbA0KPiA+IDMwMCkN
Cj4gPiBbwqDCoCA4NC40NjYzNTRdIGF0YTguMDA6IEVudGVyaW5nIGFjdGl2ZSBwb3dlciBtb2Rl
DQo+ID4gW8KgwqAgODQuNDk3MjU2XSBhdGE4LjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEzMw0K
PiA+IC4uLg0KPiANCj4gQW5kIHRoaXMgbG9va3MgYWxsIG5vcm1hbCwgdGhlIGRyaXZlcyBoYXZl
IGFsbCBiZWVuIHRyYW5zaXRpb25lZCB0bw0KPiBhY3RpdmUNCj4gcG93ZXIgbW9kZSBhcyBleHBl
Y3RlZC4gQW5kIHlldCwgeW91ciBzeXN0ZW0gaXMgc3R1Y2sgYWZ0ZXIgdGhpcywNCj4gcmlnaHQg
Pw0KDQp5ZXMNCg0KPiBDYW4geW91IHRyeSB0byBib290IHdpdGggInN5c3JxX2Fsd2F5c19lbmFi
bGVkIiBhbmQgdHJ5IHRvIHNlZSBpZg0KPiBzZW5kaW5nDQo+ICJjdHJsLXN5c3JxLXQiIGtleXMg
Y2FuIGdpdmUgeW91IGEgc3RhY2sgYmFja3RyYWNlIG9mIHRoZSB0YXNrcyB0bw0KPiBzZWUgd2hl
cmUNCj4gdGhleSBhcmUgc3R1Y2sgPw0KDQpJIHdpbGwgdHJ5IHRvbW9ycm93Lg0KDQo+IA0KPiBJ
IGFtIGdvaW5nIHRvIHRyeSBzb21ldGhpbmcgbGlrZSB5b3UgZG8gd2l0aCB2ZXJ5IHNob3J0IHJl
c3VtZSBydGMNCj4gdGltZXIgYW5kDQo+IG11bHRpcGxlIGRpc2tzIHRvIHNlZSBpZiBJIGNhbiBy
ZXByb2R1Y2UuIEJ1dCBpdCBpcyBzdGFydGluZyB0byBsb29rDQo+IGxpa2UgUE0gaXMNCj4gc3Rh
cnRpbmcgcmVzdW1pbmcgYmVmb3JlIHN1c3BlbmQgY29tcGxldGVzLi4uDQoNCnllcywgdGhpcyBp
cyB3aGF0IGl0IGxvb2tzIGxpa2UuDQoNCj4gIE5vdCBzdXJlIHRoYXQgaXMgY29ycmVjdC4gQnV0
IHRoZQ0KPiBlbmQgcmVzdWx0IG1heSBiZSB0aGF0IGxpYmF0YSBFSCBlbmR1cCBnZXR0aW5nIHN0
dWNrLiBMZXQgbWUgZGlnDQo+IGZ1cnRoZXIuDQoNClRoYW5rIHlvdSBzbyBtdWNoIGZvciB0aGUg
aGFyZCB3b3JrIG9uIHRoaXMhDQoNCg==
