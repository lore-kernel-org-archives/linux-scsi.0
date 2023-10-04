Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B47E8FDCA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 06:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjJDGUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 02:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjJDGUQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 02:20:16 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF80A6
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 23:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1696400413; x=1727936413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6sP83VQ2A2a55BmXSElVqZEv/TYdCtbFHJ1GQWfjry4=;
  b=VQ4Pl1pMFhyE59NqyKkkgpQ7gi0jXEe4YeEx0TLrWC7eQOtW6N/O6A7Q
   7jnaAQDYdtwfIko4J/am7jZKiEhWvM401FBExUQce7U8XMgycliUbNe0J
   kOOdThsPDAhXqxrrygDRy8J6e/UhgyBhTYg7TCGm6QssD8ANfsUAkxcM4
   YD5sy+NmXutHY+knknGh1fg60UWPupB1GKddkWWphlfIOUTtgyC399EhZ
   kcLzZUhcHo1Y9LNdAIKEBIB3cKYD3FLDc2bteIcDXSfDhnx6DwTWtewOk
   uZiG6wm9438Y5CweqzSSYZnat9jkuKN0+ik2EZO9n5YGlMuNK4sJjuc0E
   w==;
X-CSE-ConnectionGUID: p1cJGFTDQBC0lkhe7ghHuQ==
X-CSE-MsgGUID: KkueoisvSgmevmD/xXYGXg==
X-IronPort-AV: E=Sophos;i="6.03,199,1694707200"; 
   d="scan'208";a="351017643"
Received: from mail-mw2nam04lp2171.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.171])
  by ob1.hgst.iphmx.com with ESMTP; 04 Oct 2023 14:20:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmbskyTzd+nIB8tN/5xlVShcZFhvhxHD5SUovWSZ2iJwIQ3KTdZPiSDLF3qJGH1Y1zPyZ6tDabv8lce7eE1VOMkmMsilwZi86ocz9DMY1KMyFWAKlmePsn0cVYlw8qF1+DMN1wMK6T373kNEo7368pJpu91Lkff8H252WK9ogNTqZU0ulQ6xUQ3kwx1r3Fj/BGDVrlfiNdnFItO5b/hx2paYa5hwe3axL434avdboqKZGnCfsblLQOznGk06RyMe2tiL7c3WqbD64RCXsk38OPwrW0Bn1T5sQFDmKNOPgvvhAvEMolMp2awstrkL8Tjk7FjJ3KgIxZrTMjPe22hudg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sP83VQ2A2a55BmXSElVqZEv/TYdCtbFHJ1GQWfjry4=;
 b=I/nPufn6FB+snnqhsexcd4m2yVrF+p+htVgI8qy8ZDv2z2edX/Y0ZVMSuVS9SqrJGx8GX/K+S2bmIboZoyP3LrIv50PDckcu2Bi3JmVVNCWW2gtoEyHds5qSt9aPVE8Sj8peCnsqHxCAPl3VgYgQxOj3bc4wmnHDgG/jY1taciCzo/RngFX2NIZ7H/gjFZAWaOVWTAB7FNFsJsVoHr9DIw5uGBrvMjn3Isi6QJeX2jGAf3abV3Yi3BetXbkaJKE/0D7Y/UL4bxarHYpDZBIFOUIFjBvtJZ7kPSO9qhH5SUVjo2dqhtz9F7dbZ6o0GDTSKEP7otwZd3vMJp3kLMtBdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sP83VQ2A2a55BmXSElVqZEv/TYdCtbFHJ1GQWfjry4=;
 b=J+5kpO7WynxPqVN+/C3TU7QX5oKwvvYpL2fJQkDvW6s/EiVjQD99s6iMXQXX6+NcjjxXVx3T59/W7tF0ocKHhWxoWxPgjLTdHQMIRDOGCv2cEeEbWLmAdQF5sJWzHD0BJNJwQYpu/iA4fcqDj4jRQjYGHgrC/V8UHtHnA0RFphU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN0PR04MB8191.namprd04.prod.outlook.com (2603:10b6:408:15f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.25; Wed, 4 Oct
 2023 06:20:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f694:b5b5:8e42:b8f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f694:b5b5:8e42:b8f6%4]) with mapi id 15.20.6863.019; Wed, 4 Oct 2023
 06:20:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv5 0/7] scsi: EH rework, main part
Thread-Topic: [PATCHv5 0/7] scsi: EH rework, main part
Thread-Index: AQHZ9Ul7f0Njbzq+lkKlSvAd/cnoYrA5KxEA
Date:   Wed, 4 Oct 2023 06:20:08 +0000
Message-ID: <b828f7c7-241a-4351-a0ac-ddec67652919@wdc.com>
References: <20231002155915.109359-1-hare@suse.de>
In-Reply-To: <20231002155915.109359-1-hare@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BN0PR04MB8191:EE_
x-ms-office365-filtering-correlation-id: e12ad750-70c9-45b5-274e-08dbc4a1f579
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ZSu4ooIAXoVfGNkVUOKZJG896dq1tOtvyKLRcLGfGmPH/MVNScAyQIMLG42tMPjW55M6vgiKbTVABM3gej4iBLEyhajKhIknXdNBlTDjZobvUGHOKovGUCnSgXr5NZ7oDbFVrWr0WmWh59GU0nMaCVs3nTkmdy/3eszjwe143iU60sbv4CWniy1tk4EfWL0Q39sn5qHQVqrk1ZwgIsZvmG2AL+SDqDWnDAYFF+h421QXRSB0d36r3OjaMdfcvVJDB3dacNA4V8KnyPk3eklfuwoFIzqhBNwqbM1cHfypRbz4SEIjFUWsbvPwWfeMTyfCIiN2qrAWe/qMC6TUwTED393m1xsx6yQ7Zv9Lz06fv89iz45mEtRKj49n7Hvne7SmHZx7B3kktw/GA/qIajoVRGcQ9VMKUIWA1WcY0FwCsIrT7NhufIPKuezk+tODtmn8cJx4BCdcDNhJlMBWOmStSd3i+1Pt6sPeD3+O9bemPNPrnx0/idmTuui4SjPQNuRvPIyjfKsB2+qhJJLcNt3//VGVTN+4KqKJmbwEtmO0qmsiZPEWPm73kwRmLDpUZxVZcx+snajLtLvl7TMT4r7DPbqGxlb5eamMUzQaXFKUlNOT6fYrPKc+D2Ehzz2Z7P4hK2dta/r96aSZBGdNviXKdEKUZcStGBhB8hnPrtRhfcaVIooCliysFHPCS98CNMS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(376002)(346002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(2616005)(5660300002)(38070700005)(38100700002)(6512007)(122000001)(82960400001)(478600001)(316002)(66556008)(66476007)(66446008)(64756008)(86362001)(558084003)(36756003)(71200400001)(110136005)(2906002)(54906003)(6486002)(66946007)(91956017)(76116006)(31696002)(41300700001)(31686004)(26005)(4326008)(8936002)(8676002)(4270600006)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0UwdkNZZVJNV3pSOWlyclFkT0cxbzBjMXQrU0Z6NWhxTE9VWHNVdmw4ejVU?=
 =?utf-8?B?bDlxWGcxS1duNUpMNTU4TThpcEFSTUdxMDJGUG1IckJKbVd3aDkrakhGWE1V?=
 =?utf-8?B?S0FWenE3elUxL0F4aDBMOVg4YVh6bXRNdmtWRkVLbEE1NXEyVTRJalhYa0o2?=
 =?utf-8?B?bEZyTXcvVXBCdERDRURzWk5IYURiRDNpaGZkVjcwc3d1YlBMRlA5RFQzNlpT?=
 =?utf-8?B?eUozVWRvWVZ2M1BNWC92ZjhoSzZldHFFNE5CVTk4OXluQWNDclpsVmdaSDll?=
 =?utf-8?B?UnlJY1JTMTd5R1YzZ1Z1T3FrWWZoUVE3S1U1VzZwTzhXZUg0SlZCRUNiRWhW?=
 =?utf-8?B?SjlyU0svUzFlclM1Ry95NFZRNkR5NElrb1ZFNTJpSmc4cDE3d1lGQjdxRmZM?=
 =?utf-8?B?bVZoRlFERFFZcVVFcG9WS3l5SThkV0JPcHhrQUZCT3VXblc3cGhLK0lFWE92?=
 =?utf-8?B?bnRKcVk5RmczNHo3RldJUmVVZDJoT3VGSE1rNGxzYkRUM0d4YzFWUUVMS0JI?=
 =?utf-8?B?ZjdoSnR0RVFEUDFUQWFyT1dURlYrMXBVU2FaWmhHQkhLNnVwTThpbW5VL2lT?=
 =?utf-8?B?VnRNaFlieHFsaXZmT016WVpNZXVMQjNRSzIyWUI0cVNRMmRiRTlnQVFOaE42?=
 =?utf-8?B?UHFXOTk1QTVkanNvSmo3RTJKeE1iL1NvRkxCKzBrSmFuV014eFE3c0UxYUZQ?=
 =?utf-8?B?Y2xhVzVrVFJWd0V4OGdINEFVRlhXWkdVKzY5R0l2RFJEREtHRjk4UlRQc0Ey?=
 =?utf-8?B?WG5IOXdGK2ZKUWtNN2RuUzdBWHpabUNMd2p2RDFlbTJHcWFtTHA5Wno2Z016?=
 =?utf-8?B?WHBKUHl6S0pIbjJzcVJScU1YdHdBSDZ6RkVnM0EvNEVPL0g5WThpS0RuYUwr?=
 =?utf-8?B?M1lWRm4yUUlvUzRvSUwxbjlBOXk3YXhPWm52SEIxZjNLQXZFUmppS3prREJV?=
 =?utf-8?B?a29yM2wxdXRPejNJazVjU3RhbUtaaEdpQzhzUGpuVEZNL3RHOVFrTVo3WkRy?=
 =?utf-8?B?dUNYdjJDNmJMTzV2ZXlYL3dESmtWckdQUncyeFVzVjRrdnVvdkhVbStWTjJ5?=
 =?utf-8?B?eWRwTU9hNHZBRGJweUZoZHhoMzJmdk1la2lkUTlrdmdyRmxYS1dKMFUvczlZ?=
 =?utf-8?B?anBERXVNN3lBa2wxTzVmUU9XZjMvSE54WXlENW90ZG1QTjlLbzArM3dGMkp3?=
 =?utf-8?B?WjJ2bWhtOUM3NVRmamhCWXVmU0cyOEJQSERTTnRiUnF1VEdMNlRndkxmZTNL?=
 =?utf-8?B?c256TDRPeXNxT3A2bUJkbk5PQTRrUStIMXdjVkg5MzEzdEhsRng2WnB2RGpj?=
 =?utf-8?B?aCs2czd2L2lOVHpWdEJ0ZERhV256T0pQaEhWT2R3OUlJc3Mwam9haHBFcjJW?=
 =?utf-8?B?bzdZNTFKQ25uQlFYWGlTbEM3ZjBvVGNGcXpSbFI4czFmNUR3N3g0dGh5Z05F?=
 =?utf-8?B?dHpDZ3FLcEZjektZbjgyYlZnZGU2RGQzenk1UWZ6MWR3NktqUmtIM21VamRI?=
 =?utf-8?B?dVVkM1JHQ3dvRittZ2h3U0lGZStvRUN5QzFzMjl6NlVVNUJBZDV4WUFnZE95?=
 =?utf-8?B?ZUpTQmxKemk3U3VUSmNvOGVXcEtYalhkemp2eUlJbUdyQy9vVjREcE4yZlhr?=
 =?utf-8?B?czBRU0NEK3BJcWlDWkFqR2ZLdGlyYmlJdSs5eVBqdW4wU0hoTXo5RmRqQlkr?=
 =?utf-8?B?cnRmWXZJUVZxMmVCMTBXTFFtcTZKdlZPd1JKanFlRCtDVXZaN3NJRTdkNEdI?=
 =?utf-8?B?MWg1dEVwNGtwaUpaa0tFdzBOQzRsVy9TZCtwYTVHMmZDd0hUdG9tWnVPenNS?=
 =?utf-8?B?OEFXdTcvZVphU1QrU3V3ZFFpVTlvN1BjY3phYm5BYXNsMlVmcFNwNlppWUU0?=
 =?utf-8?B?UHpPWGZtQzVKbkdFSXZWZ2F1OE5uWTc2bUkvZ3ZTQ0duZGVmOW94TjZhaGZ4?=
 =?utf-8?B?ZlFPVU1UVmxlS01Tc3FHZFExUno4UlIrS3MyMUR5eDlxdGxJaEZ0T0lvU2Yr?=
 =?utf-8?B?Z3ludEJNYTBBQUs1MDA4SnpCUlRFdEY2SU1Sd2dMOTFpRzR5YTcvOHFLSnFl?=
 =?utf-8?B?WUp4ZWZYKy9pRUM4M3pSam5RYjFPVENBQ0h0emFmdHBqai9JZXpSWlg3S09W?=
 =?utf-8?B?aXlyTTd6S1g5UGVhVG5CZ1lCYWFPa28zblJjekNKQVNvQXU0VWtocFU5L2Z6?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6255142A715C264C9F452F00076AA101@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IwAE3JQrlBHukVm2Djr1S5SMoME4FalFbu+rlHSJ5SQiI6sMXUgkdCSY/HhSJb4QUnnO8IQ7iE14XSqAx4oqcjpAjo0cQsbHsxk/raJOH4NzPtBCa8sl3CqexING54KCrQgWus5FYkModa0YmUOW8hzXPsv9MVJGszogJm6gTKPHGk8yUM3kBzLuzleRUKY6Glc+eN2BHQKoBeZ9TW2Zs2qks1pj652STM9XWjzNJe8ueIOKsICkas7gKsYUYGclvHUFMlj1lHjLN8q37yQmK/+y2oho4i7TUVv805NYDVmhYP1euuqVrEgsTRaDN8CYGRZ/L5aVwY+cirRZDYYcXinE/uIPomnFVAX4IPBOjvUby/z/p4e+xnBf6yx3EDmq8ZOhwFQnxyK6FMc2mBsJGG8ZaM8JFDoMhf11ouRlxw5JtIoKEpCPQG//BUvHpPRE2I2dXMokBQz8cs26S74pRBOT+MtcDzYtTKnBPB1pByREEGM+n1f97PvVxy9Wj8WeI5NRQel6o1HYPeKjEbHM6n2FcHMVHcntuxxFOc0ojZqZ/sP8zWzNiPtfE9Sgf9gltVZPZsFcddPq0bYVGi4MVWgwSB7B9B/poN1iYRPA06s/e/fVm9nbfG4SuodR2+FS0aRhxFT7ngGb0dWeHBTgvM6spBDXcg6YRm0dQXjCpzqXcf1VlxHN9RLrK/sSxWNLteXOfTG1TjudHD2zY+9gEf5RGuWJ2uGDUePt1sRmt2w3pN/M4vDKq25FkQdsV8Ja1BfoyNvJnK0Rqf+zOcvfpYdazVf0N/fS1rxtzfahGkzyZk1zNrXf2LJ/Fdnf1se6dZ+hQkWKjkONibzBxy5yf1GrPJFMhSYV0bs/YgzVZKiwFr/YrWa1fqx27xTPgkgdI8iB432N+QZkwNoD9qaTZg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12ad750-70c9-45b5-274e-08dbc4a1f579
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2023 06:20:08.9785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7MfSRULI7S7yRSVMQ+aY8S9Oix93deoigRSgjr2ZtzMqsk8lwnnLhM0+GfYEv7UQa39V+3uUOabj4sRxIwipMSBY6TNCWyCq1aNbUwDcn5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8191
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QXBhcnQgZnJvbSBCYXJ0J3MgY29tbWVudHMNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hp
cm4gPGpvaGFubmVzLnRodW1zaGlybkB3ZGMuY29tPg0K
