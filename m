Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858A9C001B3
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 07:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjGCH0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jul 2023 03:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjGCH01 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2023 03:26:27 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8099E7B;
        Mon,  3 Jul 2023 00:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688369173; x=1719905173;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=rOdgjb0nyolMj3zB3spzC2QeqvQrG5O/rcFCv5X+q8OX/O73Y7vKMFdx
   WufCeU3dMxJqpsDsp2hNq2YAxQVVDOtCoaKy3NeIzSzCcECHBQMs7VpYQ
   t9EI9d4GxywAAwZHHZ/cuTIHNePxV824mFSKqqNl6teMdpAzFjBVv48pF
   vaVCAneE0hzVhLEpLwqliY9mvxwtNhrmaI1fkQnLMqGcm03IccKOoRKvN
   j+FGrF9DT8dTNDwG2xLyQRYOIrVFUNOOdwgOETmFXgjTttO9+ynDtcI9I
   PF4dOS9L9oFxl/Q2Cvr3kcUEs7CDym6AVstz71mSd6UCx7rPjAOHSt3+N
   g==;
X-IronPort-AV: E=Sophos;i="6.01,177,1684771200"; 
   d="scan'208";a="241745485"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2023 15:26:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bm1XqCBwE7CMPRpaQVoph+tYKt4M8BVCd00vSSPnsiw4L8Ef2cjEUjyoCi/vUH5qZLbETMM7sPedhK0kjRq/lgGvV8nWpeS086zV3j8tYQyan1JhbzPWcGMLobQ869hcfQx2xvjHatI1+wLNCPnpk0RyLz98G3QHDQF0uexgvNT58jZ7EW2CxM+dq0HESuNFzbOUzsWD4nNON6OsEyiOcENTa1cAlhtc2EJb5Xe+4mpgbVntLyDRSbzZi+4nOBxo5cwMqrGEg65gdvM+gcc3r6WVdQKvXemhIge87wvtwo5g7SvU+2d2ZClwosqVUKy43xoqVZGOXjFb2wqBGAlV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=BXK5tUzGle6AHX/DYJVuXYEtQSA2KxJnidR5fNhvgrXJ1/rhiZ3FehpcraAUGD0KZGUg7BwLWdKbDHwgaGa1rrQDorMYHsPuZIG54nyqQBbQI0ID9f2I0EUiozKlsTM30G4vz/ghNftqb3PON4tLdoZZUkLl6UaAqgSL04/lJ9veyLM2/4Z2v8HYSPATwL84mAO5Ux4lw7UX2870A2x87Ibf+XOEIAwUiUx1hqPKHVobUL3A6ourudKls1hpIBZptqUB27LXiGbtYTsEOzdA06Ydi3+WmZuN1aOW9WJ9yVkt4It3x6Y89NqL4wXtD/zYwRJxQP7Kye5ShDLlDWIdBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=AsQQNacJPFNURaw1Tw9xUz0vcqR+8ZDtjdatKiJni0laH3gUjdoTb8Wi1izSohLI+RzLhe9zIXiaY4wG+zmiCOLqWaiiNdTNoqFMvcP3F2ohQEGdTBiUbgMKFRE1wtyxxkqGx95W+9hPM5x2CpqsOgnz5IdtBimbEmYuscMfIis=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH0PR04MB8065.namprd04.prod.outlook.com (2603:10b6:610:f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 07:26:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%6]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 07:26:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 5/5] block: improve checks in
 blk_revalidate_disk_zones()
Thread-Topic: [PATCH v3 5/5] block: improve checks in
 blk_revalidate_disk_zones()
Thread-Index: AQHZrVjf842OMTCTpE+bcwSnd7o9gq+npJIA
Date:   Mon, 3 Jul 2023 07:26:09 +0000
Message-ID: <6b538bcf-fbb6-01d9-663c-2111d218aea6@wdc.com>
References: <20230703024812.76778-1-dlemoal@kernel.org>
 <20230703024812.76778-6-dlemoal@kernel.org>
In-Reply-To: <20230703024812.76778-6-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH0PR04MB8065:EE_
x-ms-office365-filtering-correlation-id: 8feaa319-5f6b-42a4-3500-08db7b96c5a9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WjyvIkn0F7VYtnpB69A5VQJjEWw25OvBsoJIE5eUAatGgZgvG0mUo8xvRsSkKQxLbiERf5ZkohCI+ZouqwgZkSklvLyiBzjo6LRouHhUuSFPjrhcoxHRLiRc4kNZtEKOpiaU2uLnfttWQAY9oiS8B4n81d45YPv7RH3qlrRxO09SQPi1h07plIrYRLpqN6mg5bx6wizfW0xzVjeGxtgfJq5dzX1oFbnodZwqVtNAB24RY90uywfGSaiok4722rRtcDitOeTZgCbVzkBM1kBdERFFsnyDF2h1MLTkEVkDdkl61m+Fo+5Qoxb8iOVfXS+c6zLrwCtngFtKmzYRNERY4H8UAcMaDS/SwpTTpgg6SkiRCUvUeFgaPnugXPj21SE+nkeMdQjCyWxDjzoTtRRTCoo6IhMJmJtOJ9h+GIN35tcV6AJPmT/kKmavvsABUYZtbgPJ/2ZgbHGM2PqzHkznTHhdpiMcq5HrgB/TXO7EINcuKKHbuoP/Bw3k+0S7oCK0KAbx2Dh+yOVh9FtWEkQJ5SM0Q3swpj/WSp4g1nKObvLj4FSi7+AlpOLsp8oG92oG3xMKTQox2hhVFr8RpBFQgl2oAPq0hnadH7HvHXJEsoRqdms+fXXzFojyHLzd0cECArcDi5Y6sIEW5Tx/N+Quw180MTPqE/iAwHozYSbhgDQFQQ30w4QvLufs6z5VHJ2E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199021)(38070700005)(19618925003)(2906002)(41300700001)(5660300002)(8676002)(8936002)(558084003)(36756003)(31696002)(86362001)(4270600006)(186003)(2616005)(31686004)(82960400001)(478600001)(6512007)(6506007)(71200400001)(6486002)(76116006)(91956017)(122000001)(316002)(66476007)(64756008)(66446008)(66556008)(66946007)(38100700002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDFsQWpnc3ArV1JYbVJ4Z0hoMUZhMzI2emppMW1XVGp6SldndllEbDd2YzFL?=
 =?utf-8?B?Q0J2WTNWVzg3bXFnbGxXcSt0TzBweTVKdEI4RzVETVIyVE84VGRNb1lMMW9W?=
 =?utf-8?B?TzJRdzQ1NDZzUlFpU0tHYTl5eFdCL3d6OW50UURCbm9lWGpSKzQza3ZVTlh3?=
 =?utf-8?B?SXpMaG9TQkJhb1l3a3hrY2NNd3FUNTdFLy9Bd0xGc3hGVW9ZUEZ5OFQ4ZXha?=
 =?utf-8?B?YUlLVi8wcWg2NTcwWDBaSnpkb2NIZTJTeUNFQ3FXUytCNkxXWmY5NElTQ2Zz?=
 =?utf-8?B?UXJuaENOYm1LeWdMVWhITTFuc0gxNWo4bzZoNm5lRFhmQ09MQks5OUFDR09p?=
 =?utf-8?B?ck5nQVA2UHcwK1JYVkhvQnh3NHN4ekpUVWthV2toMnJpSFp5Y3h5RGFaSVp4?=
 =?utf-8?B?T0poWkp2U0ZMd1ppdnpETUN3b2xGOEFlWHltL2VXRGM3WWU3TVpPL1Y0eXpa?=
 =?utf-8?B?Wk0rQ29iUGZoMkdmY3pFTEIzVWo3eit3WWdEU1RtbHpyOTRXL3FLZldwZDBS?=
 =?utf-8?B?ZjNOZzk4YUtMYWJteUxURWhUWUxqSExRUmFtOVB3Yk1xbGpGbExsazJzQWRN?=
 =?utf-8?B?VW9VZVh3T2JsYzZTNFlFYVVMWG5KT0hrQXpGYUJaRXJpYXY0Q3NYQmsxWFZy?=
 =?utf-8?B?Q1BoVmpjTWZjUGRGd1BwRnFNZ1l0OHh2WktZOEdoQlVwZzFhYjdYZE5DNFFC?=
 =?utf-8?B?YUd3NUwxNXB0ZFJjVzlVZ2pYUUcybittKzJCeFZUYWdLS3prQkdLUnNvUUlT?=
 =?utf-8?B?Vmx0OU41REFDYUNaWHlQS3pTSVI4WW1sbGpFMVBkbjdJYXI2cHBzR2xhRjEw?=
 =?utf-8?B?cmhBMEJCNVpGZktPM1dweVYzdWgwaWN4MnJpUGI3YzRpSEE0QmQ3b01qeEx0?=
 =?utf-8?B?TWVxRDM4YVdUaW1hTDZrNVlQVmF4bFZhaG43Si9pMllOTEcyc0hYRzJWYXRx?=
 =?utf-8?B?a2plZ3M1aUs4ZmE5cHlVTFcybFJnUGMwMUZpaWRVdk81bXZmdjNITXBDenpB?=
 =?utf-8?B?NTVNT3NHSnJFS0dDc3FWc2xsVnNKZFFOc01BT1ZGWU1GbG84Yzg5cVRJOERR?=
 =?utf-8?B?c1hqYzM4djVNQUNrZTNvdUpMZndmaGhRenZEUEN2NE5ESUwrMHVYbUZ4Vjkr?=
 =?utf-8?B?VGJIcEZpMHNPcW1wb1FwaHppMWNnSFZLMy8ycWZGSG5QVE1halFhL00wUEFx?=
 =?utf-8?B?dkpOOFdua1BOVm5Gc0dYUks5YjNYSW5lejNYUEx3RFc3NmRLeXB5M3FEbURm?=
 =?utf-8?B?WW1NQkxVd3F6Q25iUFFJU1lNMjNwbllQenBGQ053TmYzUEg0Y2ExSmozZnpl?=
 =?utf-8?B?K1hWb2Rxem5tMitsMjhUYnEweTNGbjNDZW5ybDVnOVlqSWtmUHBkdzFkNENT?=
 =?utf-8?B?aEczbUNIMHdXNFdmVmRwU0NOWldFRDAzOWlqbG4zSkN5UVBkeENqS1l4c3Fu?=
 =?utf-8?B?cDJ4eE1mZFpHY0VCdzEvTmUyYklCR0E2K2JVRC9XT0IyeDlqNk95R3ExZVJs?=
 =?utf-8?B?YVN6d3FXUTlISVdJVmlxT2tuSnMrSEFzdEJWb0JwaGpTWGRUMUs4dng4VU9K?=
 =?utf-8?B?WWdFQklhd2NYVzNZZm12c3hDOW8wR1M3N2hwSVhHY3NXc3dGKzRxdUxsU0kx?=
 =?utf-8?B?eW95TERPZkhjR08xNURyaW8zRjh4UkowaEd3UUZadmxmTmJ0R2MzcmdTb1ov?=
 =?utf-8?B?MGl3WTJicWxLWVNtellmRWdldGI3Q3B0dkw0QkREeGdNbEVVWDJGTHQxdFla?=
 =?utf-8?B?dnE2cXJGQ2U1K01jTDdRa3Q5UW84cHBRZU9VYjNLd3B1ZTBwcmhyMHRMemtm?=
 =?utf-8?B?L3VSaEljOGNrNXQ2YklyYTBZVnN0eTlCSUFUeXZ6OVVJdHVwM0JpVkQ2Mmpx?=
 =?utf-8?B?MnhsVWYyeUx5U1BRaXg0M3BqVXNBNXIwWFJLcWNGaEZYZnMrQks5MDArc1Rv?=
 =?utf-8?B?N3dqN2JmTW10R3VGUE9XTjM4bEwrRUVWK0JOYXh2VTNJU3R3dThBTDNGeDVi?=
 =?utf-8?B?bDNtSFZBbmpza1VnRm5QNVFzblRqZjZ0by9sQTlocUExYXRQeTFjZUFDSUNr?=
 =?utf-8?B?aGJKcFJOWkNEd01NYlNEeTlYa2hiT0R5SGNOckdFbktzOXJjUGNXRmxBZ0Jo?=
 =?utf-8?B?T0VnQkRJN3hLYkNSaS9rem1qcG53QisvQ2lLL2ZPbVFVMmhXSWlPcUJEYWM3?=
 =?utf-8?B?ZllCNHFBbGRsRTFyRkFWMUJ3ZkRyTzZHVGZXY2NsWklIOWtJWHVnN0I0M0NH?=
 =?utf-8?B?Z2VyMEcxRXFkeFV4SzFxTUErakdBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E8C2A7B68D09F4B81051A0C3E1E0552@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?b3FxeXRrKzJkWTZ2Y0hyR2RLUmJQZ05vWGREZVRxVnNHOUNjZHhESEk3VGht?=
 =?utf-8?B?Nzg5Q0plVHpDSE00U3RhdEVGNFF0Nm9VQjRmUGNqRFdmdDJxb0NLb09hMFV6?=
 =?utf-8?B?SzlpVVJZd084VnlTRXI5aEdkNTVpNWZJcmtWYnIra0srSnpLSmRvMGVVUkVn?=
 =?utf-8?B?cENsaG1uMzdTcGFBdXZYUXVaelBKVHNHM054UWNCWWVSa0JsTmxQUFpyTzNh?=
 =?utf-8?B?a24xeWRQL0RoZmFuaTVrU212NlYwZmJVaUVCSFoxVm9tZEJWZDZZbXFKK0Z0?=
 =?utf-8?B?NkpoNlljN3ZHcGZLS1kyeWNySWY5ZFhpVjhiL0ZvM0xmRHVBWmRWcFpkdlI1?=
 =?utf-8?B?MDlmM3VqTGxwTlN1Z2cwZzkyU0lDZlIrRWJRTGpsZ1orbFZrM0lzVXVQb1Ay?=
 =?utf-8?B?bUVJbEFTVHFvODZjTEl3enMzL0ZmdjBjQitWS1VlbFJrZXd3QlY2Z0E0Q29y?=
 =?utf-8?B?ajU0OGdXQy9EM1dUVjl3M09ncjUvVnFsMFhZYmZFTFU4UGlqRWV2SzFwR2pE?=
 =?utf-8?B?ajhka0xBRmF3SkFJeC9jUVFySGpSWlEzOFhxWnhXK0VFTmNSazJSUWd0RDcx?=
 =?utf-8?B?Ykp6Tk1RSWsxeDJIbjBjTHZ5YjV5dkluZXdZRXpQR2Q0Z2xlUnd6bElOQTkx?=
 =?utf-8?B?ako5V0N6RytyYlNHZ2s1UHJhK2IzUHVrQWZpNU9ELzFBUW1BMW9EY0pNdWxn?=
 =?utf-8?B?TDRJdlNzK3hQL1BJNWU0RHRlb2cxb3NqbGp5d2lTK1FSb0cvZ2ZPL0dOWDZz?=
 =?utf-8?B?K0tud2h4eDM2RUIzVFY0cmd0bVVLQTBLTzU2NEFPZUM0aHM3czM4ekNPK1Ny?=
 =?utf-8?B?eTRPb0dHU21nN2g3UTdSbmNydnk4MHVNMXVncXNBeVl0elVoRnJiMjR3WUg0?=
 =?utf-8?B?S255SVBSRmN4Wko0RTg1akRlV0tlRTU3ZU9FVGkvTDFpZWc2MDZNMDEvV0Zz?=
 =?utf-8?B?aGlwU1dSOU95V1ZoZUFKSjdJVWdKa0VEVVFRZ01Hb3lCdmZYQU1LZllTNkgv?=
 =?utf-8?B?NGRDeDBYK1hzdHF6TEZVS2lUekdweEtMOWJjU1NjYk9VbFpkSmUxZExnbUcw?=
 =?utf-8?B?RlAra0NMVzdyK2xVSGdsdmpPbFNvT0o1Q1FWTHN2TE1lRFEydnMrMXdtdGMz?=
 =?utf-8?B?UllMNHV3elNQTGJKOEdhaGgwS2ZSNXdraDdacUVKckZVZFlzMk1FUUlUd3Vr?=
 =?utf-8?B?clZCSmJYa3Bqc1lwUlNBMlNvTXFnZEtqUlEzNnh6T2haZGg0eUE3alFUd0Fm?=
 =?utf-8?Q?oMMbwrAUxvaBm9M?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8feaa319-5f6b-42a4-3500-08db7b96c5a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2023 07:26:09.4260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ali7Z426fD7dZ/c8+18AqtgcV/ZJV8XO2toVdnQcmizF5i0e9Zr/gNsmg4ajdQxULWYeXPPGwmQlohwQXUtbvnWhS3p4/tlitaXKkbUs27I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
