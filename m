Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FD5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358140AbiAaKXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:23:14 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40739 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358126AbiAaKXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:23:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643624593; x=1675160593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=iVtT0fHaj5kablnIBVdcbEr0H2pP9lMRRda+fszeRRV1MbZBCar1Jxs1
   KFnFoLAJoLax0wGo5yYFkwPk1A2B3Q0oYavfweMIrvK1AP+PYD09cG9Rg
   F2mFiTpXpgdpwVtAlREuNT7ainIkbNC4ZVuhinVDsvIBNqEc7zV1Tn0w9
   GgWsSGT6ro11V61+F1X+6pMms5fNf3u/CqXLQp8onj6XK5Iuab0TbULJV
   fM4naPe8tUwKy63kkFhYthhpgQko6IwQuDMGTMxTCVIRxCvZNKK3P5eA5
   tZbGVAJcI75XGjidxbjj+qo9MbDghow1S1epJV68zrRNnr2wx81I4V1jm
   g==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="295876524"
Received: from mail-dm6nam08lp2040.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.40])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:23:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKre8Finb8ciSue5QW7uvZ/d22sXkHhjmYsfglSOAmJr/tE7QqY/+ogkBTfw7lLCw0ZzQNmjlVIgQf/UBMpp6sAd6jOGulsM4J6oWsdpPH8GglcaHivbFfxAmEESUSxtrQc2XVC8zF4HuM6QXgqefv+Od6Y+goatvaHwXheuRO0O19bD8rehUB7x2F6dFOE7D98VsQPDDbIbFyjY7yGY8H+rEGlNdwdCex1YERmyD1mCdPmfY1stxHBEjV84c88oR0lBfhOY7xQrfxJwKdT6BsPo+uaakMNp25sP0OW92vF5ENUUHseSxgMSPgvqHY3Pc7veuZoOwkOuAnbgvQO9OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=DVal0iZuoBZQqf1MD6l971Fh3kUM9gnRMGciTjohG6PRIiP20K3iAdoBtmMNwipWoT0ePXgoBQptayTekXZIGmhhdroVY/vIwpKzHGAtjDloK0m41ClkKh2OHgLiLULRLhtinG0QrRGIPJF6OAhtpH0PSBsX08x2VF6FtQw79hdwOOuTwzkY7OPvC8xeRg1/1C47o1G6ZS7fvpCUkrCQiOJShWTCcyrfdbfws5sATjETMwTVnuCzfbk1SbfGtZfSbQSxtRBuZ1HG3myxybtOFYfFvlPkUJkARHdih+tsOfUHuiPEdUqMUyaVaOEb9GWIple358ptFZKr+15Qu3P06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=UfUfOLYabIYTHRF7sGl5xQWhsUd7aoCrCI1e3kH2sDF0wwqsl1btNIL9tsmVdeMDjTQQ2kabA2yZ3BNWnVy4q6MAqA8fSsm9HAUdhUDrxZhmfAAri17bLfz5idaQvIhfPImNe9e/zPSNld3GfZ4K44sePCTPNbz+TFQRTI/HTuk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB4498.namprd04.prod.outlook.com (2603:10b6:208:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 10:23:11 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:23:11 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "hare@suse.com" <hare@suse.com>
Subject: Re: [PATCH 10/44] advansys: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH 10/44] advansys: Move the SCSI pointer to private command
 data
Thread-Index: AQHYFJVnRKbjg1zFqEWwSGDOlPiV86x87+wA
Date:   Mon, 31 Jan 2022 10:23:11 +0000
Message-ID: <693d95b821153889112f8ba4917158046b297c44.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-11-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-11-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 781e9bff-110f-4ab0-1094-08d9e4a3aec4
x-ms-traffictypediagnostic: BL0PR04MB4498:EE_
x-microsoft-antispam-prvs: <BL0PR04MB449823679765714C914CA1879B259@BL0PR04MB4498.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zs2CitDvdegRyXoNqn7eklXoef6kRzh0LyKYTZ2xzDuXGkNpFZq+JOmrC+j+AajF4KiGTfndyeNWoTHqMG3jawp9SzQPJHWVml+3mW1kq2XsB6ac4hZwRIHZgR0TqcXIYNVoI9sRf9EXjL8FqI0AcpbOVWgZu1IpN+JfmdPSMBUMIMnoSsDVk4TGbt7mQSoAKqNPC1Jqc97knnf5vLZHRsG62TXb3hKezMraYAEqp2tBdk0L4gBQsX72k4K4bWb1J1ZvcioyJ6Zw9oesrjIJCgV2+y/ddO1o6nDjRAAJNB9j2pbLEkX5vehpgwNzbL+WQxIoScsS5b8TBI89LarUDEPdHiNHIBqe7Fsu0zyVCgKUjnHeU4wyc2Cp/qmqLvj2ArepKYHzC/CCITHCXOe7YQDFpGWKGEq0RqYePaTay8j0u7OuVIRTiH2xZjest7hKhzlWdfWLPggjuSH/3l+c+rCmeHtt5XzedTKDk7GArdLlg4e2Hdtr1Q1zrwvnryhpi/2y7o+5EahYugoHkN/Fh9E489D70HOnVPeLhFZ+lAFHztRDgtJ0vXRyz85WpfNIwQ7ICXgVU3ykDTXhJ9uCGE+ldOCqB/WdHoLLcGj+AzZAw1Tlm25ANe6jdEe6ATRhTKNZAOi7EoQX+00amKwOQYA0LQzfXKF1tMSDfvtLEpzmp5Qd96sTrHf0XaRI69e0+2jM0U/za7o50RLfOgsnyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(54906003)(19618925003)(316002)(5660300002)(4326008)(110136005)(38100700002)(558084003)(8936002)(64756008)(66446008)(2906002)(66946007)(36756003)(66476007)(76116006)(66556008)(82960400001)(91956017)(186003)(508600001)(6486002)(8676002)(122000001)(71200400001)(4270600006)(6512007)(6506007)(26005)(2616005)(86362001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXJYMXFMOHhjNWljenNic1pWaWgraDYwajhyQW1EZlhjMHR1d0MySVJNR0pi?=
 =?utf-8?B?WU9Pb2U5bTFwWTRtank1TjZzclJzbFZXNFo0eDZRSzYwMFBmcExoMDl1MFho?=
 =?utf-8?B?UTZSYzRaM2dQYllsb0hkcjVFdHBBeUJaOTFBSStYNWVpUXRsMUdOVDdVVlZz?=
 =?utf-8?B?MFkxaFlBMDlrV2VZQjdYd0ErUVk0Kzc2dWkvbGtBcTdrd1VLWWY0M0NSdVNm?=
 =?utf-8?B?TzZRMlU3a1BXeGhxYjlValJFRlZhbzBxTnJBYTl1LzdVZjlTUVdkcVVMNmc5?=
 =?utf-8?B?MVdtK0g1RWdjVmdKeGlycW5id3haS0FRVitJUUxBTE5NM0VWNm9Pa0VXZWJW?=
 =?utf-8?B?WDU1c0Z5QytEMmUrS21Gc04vdEtmQVcxZ093RUJHazlPQ2IrbVZUY2MyV0VK?=
 =?utf-8?B?RGN4dlFTYndJcUVtUjQ3VG1HVWRaSis3MnN0UEtoRmcwbDVVNXdGdWFqUlBn?=
 =?utf-8?B?eTRNTlorSEVVbGt6azVRSzQ1K0ZwYlZOVjYxY1ZRYlE5aTVrSXJ6aW9MeWxF?=
 =?utf-8?B?dXJnY0RQYWQ4ODFuWDI1dUpCWWxHUU9hNnFpZmZkcC9PdzlrUkFPMTY4cG9B?=
 =?utf-8?B?UStUUnY0MXBZbzJVQTd1QkN4SVJ5YS9oL3dyRFd1aDMrUTZzbnNmckFPdnZR?=
 =?utf-8?B?ZzNyMm1ZVDc0SUc4REw1Rk9tSDQ3eFhqbUZ6OVZScFRyeitjZUp5WWp5d2xq?=
 =?utf-8?B?cmVDMlFCUHM0aEhJZHhPdHk5WmxtS3FWRTRWQ211Y2VKYmU1VXdZS01yc0FP?=
 =?utf-8?B?Y2t3cmpJU2VBbUdzQXY5dG8zem9tNjNwckJXc1BpQnlxWDdMbjVTekg4UkJD?=
 =?utf-8?B?RlMwb0VHc0Rsdm9ROUtWa3FUMW9qdkpYZ05NK0M3aElPL1JXVDhOby8wZkRM?=
 =?utf-8?B?QmdybTBCN204NjdiWkg4a3U3d2dhK0llL2IreGFjSmtCd21FczRFeXlIK2J1?=
 =?utf-8?B?SEJCWFNZQmh0TEIrSkxBVVNtVENrdHpZYXFJTGpWY2ZJUjJCbHhhNm9IMnMv?=
 =?utf-8?B?ak9hMFp5aDdaQ0tJeUVQRExWaHFleVhuYUNmZWtrNFJTTTZWQ2RuOUV3NDQ1?=
 =?utf-8?B?UFdjeVdScVliQ2NaZ0ZpSFZ1YUl5TjVVeGExSWs5NG9tTG14RDJSeDZlQkNj?=
 =?utf-8?B?S3VLMDNILzZZSkNkQnpoZTBGQ0xNQjB5NXAzQUhiK0ljM3V0QWREL2FSQ203?=
 =?utf-8?B?WUhyR0c3aExiOG13Y2tLQ0wrRElESUNkcDN3K0hKNXVYL1JCZUI2MXJBL3Rz?=
 =?utf-8?B?ZDE2cEpXQ3pMUE5YTGdEd0VZak1VTnJ5WG5ENXFaQ2dSNnJKWmx2ZndFZSto?=
 =?utf-8?B?d0M3MER4Sm8ycHNpZXRiVU1RWHRSZ2J2cDdXSE1NcStBbkJ2UzBjV2xSdWps?=
 =?utf-8?B?Z1dRTWRSMk9IYjRkNWZkTFV2TGs3c2g3VW9Sc1EvdEVpRXRaSnE4dGhHV0JF?=
 =?utf-8?B?YnptbWI5N1NTU3gzOUJ2TkZDVC82RVBjR0h3Z0ZpWTR3RDRpK3F2OEFXalNG?=
 =?utf-8?B?Mit5Zi9wV3FzcVlxSHlKYVViZUFpRGtGdEVrYWhzb3R4MVFXdUV2TzZLUWM0?=
 =?utf-8?B?U3VwdTEzbWpGYzlJU2NUTlJqTzloSFplNG5oVnNQQllwZytCbGlJTzhFMk13?=
 =?utf-8?B?RzlqSlNka2V5YkFPQzY0bFppRjl2NlA2WlNFaEF3VjNqWlJZbENBQVUwRkhn?=
 =?utf-8?B?eFpETEhuQlBBdGVVUFMvVU1yZzZYa25UNUdjU0ZPWmVzc24rdDA5M1lsOUt0?=
 =?utf-8?B?OE9abU9Lb1RmU0MxT1JwOWtnbmxjcUdORUczL3VUNlNFS1E0ME1DVkFwRzNs?=
 =?utf-8?B?c2c3dytnMUR6aWhZS213Zk9sTmpRRk9CMi9PMFVJNXF3RmtHbnZKTFZ4d1RB?=
 =?utf-8?B?TTJVL2M2bmV5NFBVWHZXL0pSMVhFT1NEMWlWY3Z0ZEMxNDVNTU50a1A4dUZp?=
 =?utf-8?B?ckJTeklIZitDSXAxcEc3YWplVUxzbDlOVzN3ZXVDajJrUzVlS2FNOXJOZjRI?=
 =?utf-8?B?SElLdDNIdnpVMFNiOTBxKytzamxtRFBnZS9zazNxTUdEdVJaSnpBenV0NHp6?=
 =?utf-8?B?VmZLZXhYeDd6aUErUER2TGl0V216SmRSNDFnbHI5NFUwMENMcmtUME1NSFN0?=
 =?utf-8?B?SUFDeUxlTU1BaTZETGNQZkUxQXVnTjl6T2M4VEJ0YVBsSUMraWRmRUhxUEVG?=
 =?utf-8?B?NHl6UVh3U3o5MVlGWnZYWG05ZERZNmhiNkF6Qkw5SUx5R2l3Qy9QL0N6NCtJ?=
 =?utf-8?Q?i17IA+eo3OJ+8MjoIXePVc8HgSJpZ4TrSWHoY82uOU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C83E77237F54C4A8BA173DE00E85E2F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 781e9bff-110f-4ab0-1094-08d9e4a3aec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:23:11.0960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6PxESSzyCYAXwE+ldxlvgCDAsrSleDnCeyS0vT3elFOm5qRJePSNXJ+7kBeCe2qlxhjATKy2dWgjw15jxWGEsKNGMj/rgqM1KBJYWeL24U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4498
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
