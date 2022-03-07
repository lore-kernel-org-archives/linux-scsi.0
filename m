Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B72EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 03:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiCGDTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 22:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiCGDTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 22:19:45 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B881E022;
        Sun,  6 Mar 2022 19:18:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jz/VEw9WMVDwDbi9yAebLmQUDWb3obQbcgca/NA72h9G8gYCnxzi2GKus0wQG06zMkUdfqfMy4CoQ0aI3fWxI8fGBvf2X7UoaseNIgz52izSl1qiAYdiQk6p4kOtrs9zYaWP5jpz3wNvA2wRY3+JZs+zbita4bXrN6CLMxfnGCDSyBEjPcHAuWZf9CS/79Hu4TnK7hDhrAENF873mDXJXveFS6qvGKDOLBM/TvYzRlAhci1ZYSsikxuU3nhEnRIpbKy/z4IYmazypJbL7gRa/0U/ehrXnz+3wZxQAoex3YpWZB9zvtJ/Bpxd+sGrFRR+EN4efwh/rkSbNUYkYanZmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MQs9HtQHUf22IIYwV4waRy2yq7Wmj8+d8rkzBqMEM4=;
 b=fOmm0r+5KkR64JibGSfZiV7Id6oNy4OwI8sI28tJzjA4x6qNxEZ++xaZ301g3yFrvaVfWQ4fW7UFKS6iCtzW65Uvn+b3HSlqIpm4eCvpqtVqXkDzJmRllCLReTJp2+j83qyaxgbgX9UxwiHLaLIXmHMv6KMhRZQ5iLE6nrkuiKcBaicETPTPyJp48RueAoi8WZTK5QThe0j+pLoQF5hPXgGTT8pvbw0KEsrY8RE/hR2T0w+uQ/nrBFozPN2eHZF3eYJFiuphX61LRav0rG/ZNWiAjWd7oshcJJ0v5AXOGMFoLURs3xN333HnTCbJ+kDjVgjCXOuGSxhL03VQdDOgTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MQs9HtQHUf22IIYwV4waRy2yq7Wmj8+d8rkzBqMEM4=;
 b=pNSQzBXSwiq78kcBUg8guOSOThYLlzQbmU/44/2dKverCcGDIpKq8tR6g2MDLUmT7L71guMWhvdBBiz1esZoPuWfj9AGL647cmkyhNJcYiAAxDnkyIdpg6dJBsw1xO+Mh49GiT7nRl7geZ41I5OORw0W3z6KA4fxPuIc0Q8ZJNklRN0wkFrTEyB4esZU43sP0tWEonOOeeLcMrJjTvv3X0rpGDU9LUgLe5x2I4UNu/tgL7IeKZGhhWZbg8IVhwDgETXsQR87Gxz1ah9YNN0hkhXpT4FbxJUqUrZPnNbZhA/ZaE6VZYCKiaVStmlZ49J7UPvCe9ST8kmP4nTbBeX+gA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SJ0PR12MB5455.namprd12.prod.outlook.com (2603:10b6:a03:3ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:18:50 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:18:50 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 09/14] block: move blkcg initialization/destroy into disk
 allocation/release handler
Thread-Topic: [PATCH 09/14] block: move blkcg initialization/destroy into disk
 allocation/release handler
Thread-Index: AQHYL+GGiFOHII3WHEy1IL6hlCxn8ayzRF4A
Date:   Mon, 7 Mar 2022 03:18:50 +0000
Message-ID: <5b99e124-02e1-e3c5-86b2-28a0edd00ce7@nvidia.com>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-10-hch@lst.de>
In-Reply-To: <20220304160331.399757-10-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b453d98b-dc15-4dad-3721-08d9ffe9336c
x-ms-traffictypediagnostic: SJ0PR12MB5455:EE_
x-microsoft-antispam-prvs: <SJ0PR12MB54558A55E438C773DE782B8FA3089@SJ0PR12MB5455.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ec3q/Df7aGYZmO7wJxGknySu7H2k5pCtIsymwF4vH4BOZu8TOb03OVrKS3I8830WLT/FdK84qPZ/K6PvoxvlHcsc2vdo+8qg0d+MmjWpgB8jYSaOaw1KEtVEO/sCBLQJB+iQAg5X4NFwSlugGYiW+5e5PjD6+otqOg6ISNd7L/K5bwXLqyW8fMJ9m8Eg2b3J8X5J7cj8lXZEUzGRWheoAmh9xAJgjy/yWX+7AGraslJABEpRvt0QkH5EXS65NNSrD+2jcp1arT5UlRaviYuW7tkNHx0AsyIlQoyIwIXOGzFGWscIaE3KbN+ZbTHMLzP6ardtBRcOR31AnNibI22sr2H+JIQ2902Bz8TW3IGQJRuuMnmwHSJX8vrDZwJxdGTIwFZDKQm5UqcnAbbbTYYGoxsqZ2vsAd5/O7RffolLNTPiICCVhBtfOQOZTcSNiK4ajgC0Jl5H53RWGzfmgBmACmmoBdaa54PDqFraTVnmEd1syRNM92BhrbfYAUj4H4oQp1E3RxLPkW/WibaQOHgFxsa3sdqlwMmlkVCgVswETgHhxP8T5PBOtOKVF8TU9YxYS+xmTYwLiNEuaKJB/xpy/lD+JeovCmwhdzmcteuPqEfnFh0wxhQH0LhkhV+vgtF4B9bcXDci6vcgHHGKoR353CrVjvIK3Rzk5nroJ39uuN/dvKcGXECFjJ0l1rhySTeohv4Ax/X1s1Rkgnm6/NBs1IUtgNjuxLjiU+PXygd4teXF/ZxiYOMkHmaPCbEazd6CjbCsnyhPPefh6TWymut2OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(31696002)(316002)(122000001)(38100700002)(6512007)(6506007)(53546011)(4744005)(186003)(71200400001)(54906003)(508600001)(36756003)(6486002)(86362001)(31686004)(66556008)(66476007)(66446008)(64756008)(5660300002)(38070700005)(8676002)(4326008)(66946007)(76116006)(8936002)(91956017)(2906002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3BzL0dHY1lGMnQ0bUQ0WmRubFUvUXB1M2QxQ0kzcGJ5alJ5bFcrenVZbllj?=
 =?utf-8?B?RlhOZ2JyNEcrSlhvMnRZS2R4VXNhMWFwNEdwU2xOaEx5UGdWVit0VkI4YnRE?=
 =?utf-8?B?cmp4TXluU3hQc2lqVDVydjNqLzIrTk1uMzZsbnBZMzQ4QWZ6bGhKVXRFZ0Yw?=
 =?utf-8?B?T1U4cjlLMVBrS3Jza044NnFQdWF5K3N3aFd4V3IvZlhOUkkyUDd1aHVCZ3FU?=
 =?utf-8?B?NVM2L0xoRDk2VWVuWHJuREllZkhJTnhQRk9VSXh1QzY0K204UkRRbGdIUTFa?=
 =?utf-8?B?dWd0M2dLTzNBNDAwbUNwR0NKQTVxT2RwMWR6MmE4RXIrajJnUEJ5UFJySHlh?=
 =?utf-8?B?YzA4aThzVDd3NU9uamtFUFRNZHVNQ0tHK3grWU8xWVdsN1FucVJwVGhibi9t?=
 =?utf-8?B?amdWejA2M1VhaXJoOTh5cU1Id1BScXF2ZHNSQU5mMkZqZzExb0dmV3h6QXl4?=
 =?utf-8?B?a0MxMjk0dndIMnJsNHJaNlRBVVRwMW84SlJudlp1WDZnaHBFNXFLemV5NU1F?=
 =?utf-8?B?ZSt5MVQzcENaUXZsSUFQSnU4dkxHTFVjNGlGdkdtQ2JKem1KT0h6alpScm1G?=
 =?utf-8?B?dXkrSkdKcHZqbCtkMmtheE8zMXUzdzFLT1Bza005eDVXRm9DQ2lqOE1DVmUv?=
 =?utf-8?B?bm55RXdBSEZUS3BoQStHRUV3THNPVGVqWnRIZEUxZVN0eDJmUUs2Znh6aEhF?=
 =?utf-8?B?UGJTTTNyOHJRdjRyay9QMTAxM1dPN1ZEMTh3MHpqQ3BRSE50R0I1eUx3MzZp?=
 =?utf-8?B?V3NvNC9yR3JxU0J2dTZGUzRsTXBUYVg2cmZ4dEZ3NkRXc1pZaGpobGdyUitG?=
 =?utf-8?B?YjVXTVpTVVBUb2ltMDFmc2dtaC9sUFdLbDlUU2VRWGdNVWpZODExeVc5RVJB?=
 =?utf-8?B?Y1lyYVRla2UwQkVvRzBPQnBPUVkxOWxKU2w2NHBOTmJLTlhHNTZac2NJRi9v?=
 =?utf-8?B?bzA4d3JEWUpJTDkxUm9TcVREYVpEd1JIQ0kweVI1WVF4N1NHWnZWN25icE1M?=
 =?utf-8?B?eWRKbkQwamxDTXBHSi92TVBtYXRtRloyRGtJdEwvRms2dzBjMUp3OFBZUjRR?=
 =?utf-8?B?NWFzR1ZMdGxDZmtNY2djbno1V203YUFTNkYzSWcrb05tNUZPMlp1eWdvSDBJ?=
 =?utf-8?B?UTJjai9laHRMMHhMc0lZdEV2Z0lXa2R1RjNubitNUnp6akl3elJrR2JLNVJo?=
 =?utf-8?B?SFlsZWxUdWxQSmlDVnErc29zWG15eW1VNGpCajNwTkFidWt4QUNnbFhWRG5n?=
 =?utf-8?B?aXJNbEFaT2dEbXFHUmswaTVTd3B6blZCMGJZZUNqWVgwUHVDVjE4VXhiNzBm?=
 =?utf-8?B?WHFPZkp2alBPbkRFSzY2QitUS29JcW9oYVhGK3Q4Rll4Wk1MUkdFSDZzY1lp?=
 =?utf-8?B?UkNBNjZ3SU51RGs0clB2MDJzUVVoTVVRRWxScy9LQ09tcE93RUJ0dFEreCtz?=
 =?utf-8?B?ZHFtNTN5UTQ2WFMvMnFDYks1K0k1NExHR0RwU21oVDlPd3dDNmVadjNSR3pO?=
 =?utf-8?B?REJQWDduK1J6czc4K0hhbkRMbS9ySUxpcWpPM0dCbmpIcGxXbnpLeDlrS09B?=
 =?utf-8?B?aE1nVUtHeXRPeDFyeVdzaUtYZjFkM2J5dkM2T3F3QWZGekhVbFVPTjJWdVh1?=
 =?utf-8?B?WFBhT0djL3h0aDhPaUpkNlNkNWxDcU1yckQwaTJKRlkzY0wwUzNUZXhGZlRE?=
 =?utf-8?B?UmswWklLQk5CZDBJblptWS9QdFYrYzk3VG1nK29GUUhiQ2NVOVZ3Skx0UUcw?=
 =?utf-8?B?K2lXOGJjalRLNHl4eTR5VkgwK0k0My9Yb3VCM3ZmaVBiNkhwbWFXYWF2ZnNS?=
 =?utf-8?B?cXhEUlJJbCthcWc0MUxCTlBDdWVUY1pubTNPcWRaYm82UjB3YTNRNjZEbEFQ?=
 =?utf-8?B?eWt6cFZodzE2TVA5ZmczVkVWUCtyWUhDcHFYTE5BV3VaZEZnRkNLdDY3Wi9S?=
 =?utf-8?B?aEM0V2lGSHNucXRQQ0c3YmFaUDJ4Vlk0TVlUTnIzcWFNYXc1QUEwb3RGTWI0?=
 =?utf-8?B?VVAwTUdWaEljT3NQUkJ5Lzh0WlF4c3NaYytMS1VpRTc5cFkxWjI3YkN5ak1V?=
 =?utf-8?B?Z3lRaEtkS0Z2MEN1RHMrNi96aE1CT1FpaHFIWWgrZkhEZWp3MlEwNWwrZFRl?=
 =?utf-8?B?VjhWbzlyWG4wQUl6aFNGZkhBUFpLczJ6U3lXei9MSjd5Y1lNUUNjUnNldE9z?=
 =?utf-8?B?UUQ4Z1FtRlNtQ25tNkg0QnorTWlRSmZuczBRNnMyMzduQVhaYzdTT2ttTUZB?=
 =?utf-8?Q?Km/zOwRVUCOQt1qkTiNpS3OCvVMAb4cm3bcYKjPltw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B1530B49A682640B9273ABB1E324106@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b453d98b-dc15-4dad-3721-08d9ffe9336c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:18:50.3422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: my8fOd0iowsmVScFKc8mJZcsZ1kEdhf2IFa7TDgWFELjGifLA2sn7AhT/F/Gs1g04pmmMQ7u1iYXkj4FFMQztg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5455
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMy80LzIyIDA4OjAzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gRnJvbTogTWluZyBM
ZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+DQo+IA0KPiBibGtjZyB3b3JrcyBvbiBGUyBiaW8gbGV2
ZWwsIHNvIGl0IGlzIHJlYXNvbmFibGUgdG8gbWFrZSBib3RoIGJsa2NnIGFuZA0KPiBnZW5kaXNr
IHNoYXJpbmcgc2FtZSBsaWZldGltZS4gTWVhbnRpbWUgdGhlcmUgd29uJ3QgYmUgYW55IEZTIElP
IHdoZW4NCj4gcmVsZWFzaW5nIGRpc2ssIHNvIHNhZmUgdG8gbW92ZSBibGtjZyBpbml0aWFsaXph
dGlvbi9kZXN0cm95IGludG8gZGlzaw0KPiBhbGxvY2F0aW9uL3JlbGVhc2UgaGFuZGxlcg0KPiAN
Cj4gTG9uZyB0ZXJtLCB3ZSBjYW4gbW92ZSBibGtjZyBpbnRvIGdlbmRpc2sgY29tcGxldGVseS4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pbmcgTGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPg0KPiBS
ZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IFNpZ25l
ZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KDQpMb29r
cyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNv
bT4NCg0KDQo=
