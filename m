Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DBDC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348380AbiAaLDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:03:20 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:65400 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358802AbiAaLBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643626900; x=1675162900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=UrwVRLO46Qh2T6FFQ40NAabP9HI83G0Rx8QQlDXvjKGSXArfNGmgzjG8
   MoT9rhXUErCLgtwijbbGq7PEIUh0G6RcpjV20PQf0/PnYICaSGC0p+ZHH
   uDKm8RXS3VIe3jVQZ+JoH7pTKr9mo7+DHGpABaf4futBPSLs/afAk6Xn8
   ApKhvVon8qxMFZnJZsmhBwjPbdYBPRlQWSNGvT1s4oO8d2uEUNvQlxVG0
   ES+80ssrIBKk8ZuSEMtbSwbDrV7bxsRhPYUebemSLSk2Xp6s90RSoPGUS
   hBe7EU2lG8x9ByOU7+cVqi3ufc8a1OBcuBUzgWx3l+0sGpE4M7uUPUrKb
   A==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192787412"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:01:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=is7ijgZa8/elZNJ1H3M3QautcUJQGUWF2AG5OD/RvSbWvhBzEZCMX0pEpCnlWrhdFIXLXQNNCLQuTKl8W47GNM9Vnkq5NL8iqah57vgooyOZgkopKn5ISaO9TXYxx4uDxafu+kqMzuipr3U4XfFI1zZ5yui3nkaVlnaQ5kpUG0yPaD2QRqvaEMxWWGdeUckHeJZrcuX4kf4Scc7eb8H/B6bJk/NOA7/BiWo+rGZTV7i3W4cm3W8r9NSQvSIXY6fUG0jj/9YGTabFkQZUihcx9sCS1qQ8qq8dRdCqWxJBXXTLJ9M1jNVAyQZzCJ2eJwoJRPA/g6NqzTITjiXRHXPLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=ghjz+MUCfssHiuzDlx3XHsh8yRZ4sjQ3N4JGOP9fmNVt0P1fFAISBMAqYH6DXtVvnFEfPuNrt/8vsQEp6tCUbfO7UDucqjeTKFg43xlFiR4/JEJmFGFhSbYG5e3Cul6iLBT5Sjk6dMI+buZ+riYz+mbL71+g7NbfMw1awI6BOENRF9VnYJqwYdkmzeTQNW4Jgs/6f8Ll0tsN71eIR7SvCnHgzXwr2ujwOVAWIRTf8rpoJpTNx1QZhw0OoNhICtPqKUXkX0oYNs9YEUdFAwgM6XLHDzH5fe02QP9q8WdplczXwnwcvAMS86r/S/3dwoR7YTrBUqQdfSed2URykDVWIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=RKb0y1JB09AbH6WVeQe9VI/1mzQavpdYqekCHxMAjbvj5SFFgC0k1HcGJwvVXOd9jGTUeqDqP/wczQ6TYGkrTYqKLcJmKXCuX8R99Kl54G/+DMxVV40RDTmB4WRaymF5iOEchqUGdWNcNOqBlybKH6jdJ+UOibZ60CKO+mI6LDs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB5833.namprd04.prod.outlook.com (2603:10b6:5:16d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:01:34 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:01:33 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kartilak@cisco.com" <kartilak@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "satishkh@cisco.com" <satishkh@cisco.com>,
        "sebaddel@cisco.com" <sebaddel@cisco.com>
Subject: Re: [PATCH 19/44] fnic: Stop using the SCSI pointer
Thread-Topic: [PATCH 19/44] fnic: Stop using the SCSI pointer
Thread-Index: AQHYFJVpeSZxGZPAVU+4akV+MlCELqx8+qQA
Date:   Mon, 31 Jan 2022 11:01:33 +0000
Message-ID: <579500888abd4a31f680b144e0e570c002d6622a.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-20-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-20-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fc08e3d-6965-46f9-4183-08d9e4a90b13
x-ms-traffictypediagnostic: DM6PR04MB5833:EE_
x-microsoft-antispam-prvs: <DM6PR04MB58333EB8AAE282F74C207AF59B259@DM6PR04MB5833.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CiwUY44dwkWSL4jS9wUuHAV3mCTftEIy7oWIBgBOs5ahHafOi4+6lslmNOIvCmmsppZ5+Q610OdjwXwjZrm0/4AFUPoZTF4uxki/X7EVB0lK2w4GGoGdafHUAIw09KZrKKjB5f+mwUQrUHx96kaK970ID1rSDA8zGJDhAvGikBsVFNSjCMVUW7RIh9qC45WjnWC61S8MGHXirGFyxSL7pQ9GAfdW/zvxtkGWPl2dnRfYgsTWSl5/Jycsc8SfsAj+TT5cw9ZgqJadG+Fl1pEHK9JBSi2hoVhVNaJReKz1jk7/+coueVgiM06JJ8I6tUOV9gRMv00DOKeNMKEEa+XSlxvEC4tPxaXO98wn8wlElxTQfGQXn0EPQuny6FRFR1ltODZN8HM8f0wmTpFA4GgQcnNfmlNwoe/9aTQQODB6557pkFZKOuPSxb+eeSnAo1IBpTjs6SSEYE8GurznePcOQU2c/ifErtcITVqlVK65PwTWwZk+aig2POQsf+Gn+5+bFy0Ierla7oH5v4agRGDGWtnOvWddncYPdVn8ENJu0mNpCUVUAIR5wbCAAHlL22qmtk3fWx8uWFVhAuAbFUmxnHy7LDHjFqQFUObedTn5pXynVk+OU0EQjWUxB2cSgY17VmrDK4C3vm6gmK9DuJak4SSH9K/0APqvlcOpD9gBOGcZZnOgpBH7sGseLpRpHXZeQ8Q6Y7GHNcYFoL9hbjw+aQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6512007)(5660300002)(110136005)(558084003)(38100700002)(6486002)(122000001)(19618925003)(71200400001)(82960400001)(26005)(4270600006)(186003)(508600001)(8676002)(8936002)(64756008)(66446008)(76116006)(6506007)(91956017)(2906002)(36756003)(66946007)(38070700005)(316002)(86362001)(4326008)(2616005)(66476007)(66556008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHRLZEM0b3IrUjNnaW1PRlpYd2JDZUZXc1FWUFpmMmJya2g4NlM0ZFlnQjRt?=
 =?utf-8?B?aWpzeVFtSzI2TGxKNW5jNTJuSjRNR1Q2dzhxVGJEeXBrRDFIODNabWtUeFdm?=
 =?utf-8?B?NlBQQlhpWVAvcHdPbnplQS85Uk9mOE5Fcmx0OGIzMng1UkJOenk0cHVSM0M2?=
 =?utf-8?B?MWo0OWpTM01CaW5BWWNUT3E0aGthVjJwODllTWNaTm1UclhWcHN3ZkV6NmFa?=
 =?utf-8?B?VHFseldiL2tseUNmLy9qK3JsWkxCRmtwMU9JL0RsZ0dJSDJ2empKNHR6L3ZI?=
 =?utf-8?B?WktHanl4UStndnA2R1RDUGwvQTVRcFUyZzBFVnNWMXdKSWowNEQrYnNQem10?=
 =?utf-8?B?Y0RpQjBBUW01WE4veGkyM1NOejM2aTBsQ3EyTUNjMUhGWlAwdTREUmk2bTlR?=
 =?utf-8?B?NDRYdmlQWGRtNkxPN3JhbGx3VElrMExNRDF3QWNEUmpwcTlSSkFZV1JXbFZG?=
 =?utf-8?B?WSt2YVJoSkczN1FGYkNZZXA3ZFZNQ0lHbE9nbnFMSVp0TGUrMXVUaXUva0ww?=
 =?utf-8?B?TlNvSHRGblhQSm04Y3ljSXNIS2VRYytyekR4SEkyMHpvRnNTMVBEU0E3akJG?=
 =?utf-8?B?YjJ0RHZtM1NEblhBc09NZXhtVDBlcjM1K2RUckx1QnRNL240YWduT2JPaUFW?=
 =?utf-8?B?Q0dXeS9DRzM3WFJYYzEzSHlLME11emEwZ3g1ZTd5UXU1TjBNamVEZXlEYnZP?=
 =?utf-8?B?T2dUeWJpVEVxM1pkWFNjbjNraVFNTmtBQVVwNk00NzBHRXpWeWdrblIwK1BM?=
 =?utf-8?B?MGV2YzREaGUvUURpdDUwOUZla2phbG1qbGdpOFk5MExOaUpFMVQyR1BtUUYz?=
 =?utf-8?B?dHlMdGJPWE5lZWpoZTFVSE1sMDBJVEkzUDBCOW10MHlyNDVzTzU2c25aeDB5?=
 =?utf-8?B?bGQ4TUVyVmpVTkxwT2pENC8rSXFoVXE2OVpKdDFHdXNMVytsZnpsd3Rnc055?=
 =?utf-8?B?TGl2K3pmMk9YU3pJU2lON0lveG4zd1JaeTBUdFg0c0dUUTlvR0hwRURLVFlF?=
 =?utf-8?B?V3VUcjFkaWdZaTc3b1FYMmgvMlJqM0JsTWFRVHo0dmFBUXNpc0JqMWxmYTZk?=
 =?utf-8?B?dlRyK0ttR1lzUDU1RmNDNkNXTkxZNHRnd0ZHS245WWVETE9WL0tCU1dVM2tp?=
 =?utf-8?B?cVVlUFRpMWhhdkZjbnl5Z1pQL2dNTFVNVXViYzhwREZpM2ZFTWdHN3BKN3Vp?=
 =?utf-8?B?N3l4MGtHbUMwV3J4c1luanhXSnBPUXFDdnJYUGs5K082Q3I0RStBaGtRUDdX?=
 =?utf-8?B?Vk9KSzhxMExqL3pSMk1kWHRtTFBQN3FFUkc5aFhackVMSjc2WnFINVMxYThm?=
 =?utf-8?B?a1I3QzduL3JIRE5CUlRkYjN1TkhsYWFQbXpwcUV6dTNhQThJQTJHM2ZqNVo3?=
 =?utf-8?B?MGFMaktrTGFzQTAxa2VOUXI3aW1UbmxIc21CSVRlZkVVUDVnR1g0QjVNV2I5?=
 =?utf-8?B?WFZiQU9wYnloV2FhaTJZN09HZmpOUmtZb3BxU2E3OHFRM0lKalRHUnEzd2t2?=
 =?utf-8?B?UVRER2F6RXpGSEg5MUhyQW9mN1NWN1VTNHltYlg3U2NrYXh4STVRRGZ5WXA4?=
 =?utf-8?B?WVVlaGRqL3p0QnNyWVJ6RDBESjZOUkVhUW0rdmRhNXFQNm5Cbk5kclMyTTNI?=
 =?utf-8?B?UzdxN2thR1dCZFU0Z2g3RURrREZEWjUyYnpFVXM2QlBDTVBOT1BMV0ZjM0R1?=
 =?utf-8?B?RW5VNnpYeDF5N211R1owMjd2c2t6QWthV0MwMC94RGJUaFcyVkVRaVBucmQy?=
 =?utf-8?B?dngrK0V1a2gvTVo1ejY0NzNJMWY3VG9tLzhUaHlpTWwyakQzeFJyT1FVM01p?=
 =?utf-8?B?THFWTWR3U1ErajRiUVVNQmVMdkg1VWhWcWtjOEcrYUVObUFmMVBPMWJXaTVo?=
 =?utf-8?B?a09HQlpmclo1eEx1SUVZQmhQNlRMekpPRU4vTU1NQTl2bzA3Uy9JU0t1T3Fh?=
 =?utf-8?B?ZHNGZ1o5RkE4K1Z5MWJVMytRYkZTdU9sYXJZeWlEd0JWWUtXMGU1dXNuc2w3?=
 =?utf-8?B?V3NTN1F3anhZcHF0UkRBeE5EbldNQ1FKVG9pZ01QMnUyUnIzRTRRcjUrMXdr?=
 =?utf-8?B?Y2xpMlQzWDM0RXdMcE5qR3lXcHNtTUM3eEcya2tReWcvSVM0Wk5HUCtLeWZX?=
 =?utf-8?B?NkFvUTV3TXBPa0tSeTcvZld4Mm96UXM0RVovbmVpeVBLTlBZU3RLQmwzYkp1?=
 =?utf-8?B?SDc3ZkVhZnBIbXNUS0hCYm1BRTZwcm8ydjJyY3o0eTFKQzhvYndDOVJlbWk5?=
 =?utf-8?Q?r2AH2FSL/VQr7big/zrnLHLy+eAznSNReC3UW5iws0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BAFB2BC130FD343A979D5FA8B1D554D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc08e3d-6965-46f9-4183-08d9e4a90b13
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:01:33.4334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eT0ov6LLnsj29xFjXbgoDpPnO9A9jyOwIJcyZtjFiJnkpuipWudtrQ6Oi4Cto4L3etgZK4en+oT+EFswKmX+QtG/gQlVZHg7r4aoOUljByk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5833
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
