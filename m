Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C6FC7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 11:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjFELAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 07:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjFELAa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 07:00:30 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD6F10C;
        Mon,  5 Jun 2023 04:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685962828; x=1717498828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wup+rQ2uAd/G8/qbXfj7dftbBh+dLJ/GWLWOFsepwHs=;
  b=lCCtabqMHw0GNFW03mbVWmdr78jY8KV3E/FMygsn/RrTThXdm3UbPhkq
   oWYHAbhxXf0NAdAQsb9XDDWZV14FzQAmXLWv0Gq1m7n1s8uGicPHewGT7
   2qPDHpSgFo9qj4oMpXGx3ZCvJaQpirPifH8vH1OTD2UQL+/+hGGepTrhu
   MD+uMVWoQXUSXX8KNcRoXbDhxYTYMSK9APqcOgFwXkrkAgD1aPMuyw1qo
   OkJ3pZ7B1GCQUl9vKQE6VF0nj5Wepl08AYg/+OXWpIStFs3srk4UFxJpl
   vTrW/d/c+zLpsgp3NTU6MRAmkva88m4Z9LKQJA5ABIaAG/ATHtFGFcwaV
   w==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681142400"; 
   d="scan'208";a="344657205"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2023 19:00:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6u3+oNTz8IvMH77aqY5GoS5N+E6fTCFLri+6xdt8IVUgSx3yGvR/+JOdroKXoUd9tZPJTBUHdEvF2I288sL1ZKf/CQxuKLcBoHk0KhqV0+30Z1K469hGpPiyI/O0tmjEhSyc/4gvzAjmMSe/p/8skAPvGSzjuWHGn7+d0X674iyqgd0UoSTwfMXiAmhlHRYqx7AQhpPRJIRZ9xMRgoJdd59XVbzQLWawpiku1ASPQhxYqMj7hT8tNrfClS3lHuorCEoViFXM/wIyWxATEeATs8A+UJiyMWq4b+nFSoWbjEtcJgXlZMpVqL+4Y5YoPOprpNV6fmwUz6QzlzPIowwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wup+rQ2uAd/G8/qbXfj7dftbBh+dLJ/GWLWOFsepwHs=;
 b=VMQ6QQshT8rBXzSDqktzMN4zZlcsoYGR/9umbC6QCbHIgGT8YfIzoktXKNTDgzsFkptSohxiUG6RfUmhtw5uQgS1oBxsNlwNPPgmeoFR6bNDl/bi9Hl/vVWMpx9FdHZiBrT9SHKxQT+8JJHPADIHthQ6vh/KnZYaXNQCAWEFthqqhgk/mBVPDhkClWXl9E0P7WZ4dcycK7/vclstCETx0W0clNQhO3EvLtAIBvT41Tp8zi3wc5Icq2RXxSCZnhUZjxNgab2BkxQSeB3KOd+qZGmWAKSCOrNOfTHYN01tQ7cMm+8pHWmb8l7+Zo9nBdKfRJIqPiXu8h1UEKDux3s4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wup+rQ2uAd/G8/qbXfj7dftbBh+dLJ/GWLWOFsepwHs=;
 b=URyMaVl4PFIiNJtPZosQLcVZtKFhmDoVhG3jd7qoAeANIgQ+LRUNL/rt5/QIkzWc8UhDQbOc1OEDKYgaMJ6NUn9vEXrFV8OTbAOrgk+7tSOTrzLJWiqnbRtuI5emwtCRUhqNchG4G9wDThI4PaXZZVId0ETwo2GzwHc2W6KXJ20=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN7PR04MB8604.namprd04.prod.outlook.com (2603:10b6:806:2e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 11:00:26 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 11:00:25 +0000
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
Thread-Index: AQHZl5vs20rOacw7KkKKDiaOeh5rbK98CqSA
Date:   Mon, 5 Jun 2023 11:00:25 +0000
Message-ID: <275763b9-b9f2-b5c1-4866-4f5378c2361c@wdc.com>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
 <20230605105244.1045490-4-dlemoal@kernel.org>
In-Reply-To: <20230605105244.1045490-4-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SN7PR04MB8604:EE_
x-ms-office365-filtering-correlation-id: d3ece494-ce27-465a-a7fb-08db65b41128
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YcmM3CL//xtB7VL+m9C4Dm0QoUm+ooN99nI8gUDU+TVcggSP2trzVPF9ZJjNTciO2ycRoLlMlUJfjdZdd6jVJETNm6oR1GGQ1FPuvDNmDSV1xqGRSb1oGFpcTLYMl0EgNEXse56S9EmXgBAkhuLpVOgSR5ZisiMBlnml7+zkkffFmccG4tS4T8siSEFLzz6js6a2OaKAQjCMyYY/bOtFoCtN2ImS8EZX3LzagEl6U/LhcttT2clc6yKTzLUldp6yd4nWzhWOK7ujPu0y1ykvCXxXdhJrj2FxfeY0GBO73mrgsR13oY4miVTz20UxqOQCcXoSCUpMWD6nHQbN4FTlAhD34WzJ64waaP9zDdjI8JLUBXaKCCzBhuz6iG1TbgG5x7WBlidEIezOJADtCnj/S7eeBTJExIVQbpFGfts46P/M+p2RWR2QJ3NZ7t7mZlNP5TVuHH3NM1i5Uw2pqTqqSX0JBRhsv3Q7XYCdBvMscNAub/5q752xGgrtgpHpQkKUsVgKIRyxW+5sDJQxawIdXzhhiCTiPjVOHR8s14aLtpAa0/dMwJUQcsHwzRLEDqFhSLpY9RrzxYuHcur3vCqzDgEEP5DQchAkQjEhP+hltAnX50769tAPfAO094t3rIQLNmSmUIdcPi7bUyQjfWfM74bmFRskdEKzcpM65/TmhR4qK+6W0bGYk4O5RwZXmU/2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(71200400001)(6486002)(82960400001)(2906002)(4744005)(66946007)(66556008)(66476007)(66446008)(64756008)(122000001)(76116006)(91956017)(110136005)(54906003)(36756003)(38100700002)(38070700005)(8936002)(5660300002)(86362001)(8676002)(31696002)(41300700001)(4326008)(316002)(478600001)(2616005)(53546011)(6506007)(6512007)(31686004)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RHUyVkNkK0twaWd2WWpVdzVoM3FST01CY2o3d0s0RnNEUUhQZ3hOUEtKRTVx?=
 =?utf-8?B?QzUxY1BtOENGWC9mSGJ6eTl5S3U2NnZjMGFRNkxWZWJWVUVacnYveHdhOWpk?=
 =?utf-8?B?aUpqLzRRUU1qRjJ1OU4wYzMxSk1GQ0FGNWYvMGFqdVFlL1I5UUlzS1FJN1JV?=
 =?utf-8?B?NHRITndmeXpJTG5hbVc0SUhJeHl4d2JGZTdRL1U2TXZOVk5HSEdpVkRJOVRY?=
 =?utf-8?B?aXM1czFjRDl5MndVeXlFcnpzeEhscVRjU1htM3JQQXBrbVdCNnFhb1lpUW5M?=
 =?utf-8?B?Z2hISm9MSG1oVkhYY1E1OU9Kd2xkTVE3K3o1Y3B0Vy94UUlYdldJSElrT0sx?=
 =?utf-8?B?bVVDbDRTZmlPMUY4NHVjRm9QQzh3S1lsMjYrWGV3bmFZOHM4OWhkamFiMG5Q?=
 =?utf-8?B?TXJ4ZWQ4S2lWSlVFbERiWU1qZFA5VTdwR2UrY0pSamNrL2VsN3h2Uk1wVmMx?=
 =?utf-8?B?T2hUMGdVcmNRQXR6TjIvcDh3Lyt4N0RKOTdlZ0ttdi9GMTFoUnJ3a0daZXRj?=
 =?utf-8?B?T1FsekpZOXRSSC9iWmoydGUvYlZNRkFQQWJQd2FPT3U0d0ZiWkQ0OFFHZCtE?=
 =?utf-8?B?bDU2OUxnRkp0WHNtNUM5RFIzbkpQMk1xaVJ5VGlYbGNrc0NHTWc1OTVMVVNK?=
 =?utf-8?B?aG1MQWt2djd4MTZMYm9BR09aaU1XK0FJN1NCd0RMT0JlQVIzODZMUHZzenFx?=
 =?utf-8?B?Qy9qVHhHRzZWY21TZWdQaC9yY2VveWNidFUrTm02b3l1amdrbnNXQ3YrVXhO?=
 =?utf-8?B?N0E3TE42aCtnRVZpZ3Z3bUJ4TzlWRlZZb0tRZTlobWpXT0s0bmtFemEvSkpp?=
 =?utf-8?B?Sy9leDh0b1NSRVY3ZDh3eEgzTldwaDE0dE04N003WU84ZEszUTk1UnZoOEdP?=
 =?utf-8?B?VzBVd2lYUk5WZmlzUEljQ1k2b3RMOFlWNTZqUm44WkdOMjJjL0hHUUVJOEF4?=
 =?utf-8?B?OXBNcDQwcGVsckZpaUV0Y0trTFgya1VQRTVtUm01aVREUXRSLzJGYjJ3aEZa?=
 =?utf-8?B?Q1JuSEVRQk5PNzdRZmVTYVZMbmtBaEpwTlMrcFduZDZySkhyUEc3eDlFWTVk?=
 =?utf-8?B?M3Q1WXE4K2lUYjlxQmVtVEpFeDd0dEM0SjJxRC9yUWZST0RUSUprM3lTQkNM?=
 =?utf-8?B?WlJubFBxZXRabm0xcDlpOW1ZaC9LTkZwNExrRDZEWHNodllWV01WUmR4Zkxl?=
 =?utf-8?B?ZUM5QnVSVmFXTVlBS0xjWjIrSzFOOEt5RDVzRXc1QUZjTHBHbzZpcml3N0gr?=
 =?utf-8?B?Tis4Tmx5dFA4RTJkTnU5UUVrdnVMTEFjZHp6MFdsUFNEbnhVU2FXSFY4azQ0?=
 =?utf-8?B?Z1lnSE5uS3E5S3diKzB2V2pmRWNrVEM3SXFEZzc2Ukk1T29kZ1NFOEk1cUFZ?=
 =?utf-8?B?aWlGdTdnRUZ0ZW82VlNZamlsaFZhWGZGdjNJVERRaFZYODRYQUd3Ty9WVlFk?=
 =?utf-8?B?R3k4Z2xKRXdJa0RZczlZS0JtV3dHM1FyVnliVHBNQkY4NjAwTThsSlpWNXZN?=
 =?utf-8?B?ZHNUNWU3SUVBR0JPK3lmbjMzK0xiUDIxNHpra1o1MjhHd3gyeEllUUsxUmtR?=
 =?utf-8?B?TDErdjRFQWNOTHA5OTZhY2VkcXJvOG1FUytKaEVrSTd3WFFsT2F1SStqQnAz?=
 =?utf-8?B?dk5uOFFNZWY2MDRLM2dXVDBLSHlWbmxWVHJtY1B2bnpzVHlGQWU1RUdVQjRr?=
 =?utf-8?B?MGVLOXVMY041VEhYaUJYa2dFU3htazBEUzJVUEE3MFllU0NjUmJhNEtSb3pa?=
 =?utf-8?B?WWlpaE0rYnFiNW1vaGM0czJwYjMrNE01UXMwQmJpT1E3cWdqeE9kVm1rRzdB?=
 =?utf-8?B?Ync4eDVmQXUzTXk0YTJla0JWWGdUaVNrcEV1bDJxSy9Eb2NwWE1WYVVuVkFD?=
 =?utf-8?B?dnFoR1dTZWJoZEtneC93R2xVYUJJaCtlcUV3UkZSRnRJZmllYWR2VG05cC8w?=
 =?utf-8?B?UXBrZ3FIcHNocDFySkxrSFc0d3ZzY0NoOU1ncFNvUG5tU3hZVWdrWFFML2tw?=
 =?utf-8?B?djZ4WUR2OStSNW9Ba3VxQmt4Q0hsUXZNc3piVTMzZC9vQ2YyWG5XcStQNDZm?=
 =?utf-8?B?MTloUlVYMWZWcTRSZGJNeFQxbDhVbkxrRi9FNGpoRGJtOTdPYjVUVXFMK1FY?=
 =?utf-8?B?eTVQY0lLYWViTnJnOXNTWDBuSTc5TU9JNmw4L2JiUkRhejZZeDNoTFFuc0Fl?=
 =?utf-8?B?Vkw0RGRVQklvektvMklwelBNbEhLbnJGWFFLMVpLL2YyUVByZ012Zk9ZZWpy?=
 =?utf-8?Q?erfL+2X+JuL0OSikI+UwI4t7lI7y2fyBwe83vT1hP0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2031BDB0E281DC4689F4937D9970BDED@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0seZvWwgz9SysxvXR+58j8PXWp21ByBYeYB7hirHLtQe8BUo/eVyP/Vn5urKluGwA3mkcDJVWKd59qEmeajzyT3sTOcUl8jZPIrHcjaRB9Tc3LotHXPm4TBN6KilTz4v6WbD7mHla2h5USN8wNcVYkl5yuG2kGfI663j9LNWLBYA5NB9/0VGxwmgOVvz1ijNbK8lH41tnLlEqAu2RwkdMgFlSvw6XuHUnVb+LB96FYTpG18S2xkYg9N1WjEutShK18C0+RDDA9aUvE88z/w0vvL/Sp/eMUg+t/4EMRPiZNaQ1IBG3p6dkjTBcKnsiQ9m1JXYVvqwTNfj7q66HS13AniEV1+Z5xF0sMCGjAu3zoP1gMemH4F9n7uC1X7w83eVVyHz9d2/5KCKyGaxQpc0sf1jB18i44+UXi1nBkCiPQT6MSM/a384nT0dyi5F8UUMGPWMBjvt6+v5uRZIhJ331f14OHRw6nDqFlbxblFHIox72G57fmgIvLh5ylZe9cw1Dhld4tf/HaZZA9FO0xxeiTjN0Z1E9uedYIDAv6KrWJlQjG50kH5W00xf5cnQIljU1TcNRpPOk+6AbCvAQRC0VVJquNn1Iisme2zWotqw1vy8kyyyK0XTUielOiFbTHw4Wl8jwC7AtOLE+U7dJh37XqIIGhOOW95szkbZffzuWMfD0gbVhSw9aFXEoj+RFEHdjEFvfWvyyogZ6atW8wnARVeq8f6bIOcWqQiPM5sJSjxGEbfrAyFYXkwKbLUpAeCvj5bvHNhkBXw5/j9hA4hDrVkZuREH7Oqc/Iq0jaY48GnVitwNLhBuxA71UFa/yBa+Fg0UrhXl4gJxB1AGG9VY63vM4j1RuEvKYMSHjhbTxblm7RMF1S2iun4bjuj+HFZ5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ece494-ce27-465a-a7fb-08db65b41128
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 11:00:25.9437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/8JcO5XkJwEiKqGnc2DL+lGzuyZq8I2V9ZClJPU4iBwJ535lK2DeVnUexOLCvGZ0upcLBcE7UUMsILG+J79d0IsEC49rPzKGqyF+Sw2AjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8604
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMDUuMDYuMjMgMTI6NTMsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBJbiBhdGFfc2NzaV9k
ZXZfY29uZmlnKCksIGluc3RlYWQgb2YgaGFyZC1jb2RpbmcgdGhlIHRlc3QgdG8gY2hlY2sgaWYN
Cj4gYW4gQVRBIGRldmljZSBzdXBwb3J0cyBOQ1EgYnkgbG9va2luZyBhdCB0aGUgQVRBX0RGTEFH
X05DUSBmbGFnLCB1c2UNCj4gYXRhX25jcV9zdXBwb3J0ZWQoKS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IERhbWllbiBMZSBNb2FsIDxkbGVtb2FsQGtlcm5lbC5vcmc+DQo+IFJldmlld2VkLWJ5OiBI
YW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL2F0YS9saWJh
dGEtc2NzaS5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9hdGEvbGliYXRhLXNjc2kuYyBi
L2RyaXZlcnMvYXRhL2xpYmF0YS1zY3NpLmMNCj4gaW5kZXggN2JiMTJkZWFiNzBjLi45ZTc5OTk4
ZTM5NTggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvYXRhL2xpYmF0YS1zY3NpLmMNCj4gKysrIGIv
ZHJpdmVycy9hdGEvbGliYXRhLXNjc2kuYw0KPiBAQCAtMTEyMiw3ICsxMTIyLDcgQEAgaW50IGF0
YV9zY3NpX2Rldl9jb25maWcoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCBzdHJ1Y3QgYXRhX2Rl
dmljZSAqZGV2KQ0KPiAgCWlmIChkZXYtPmZsYWdzICYgQVRBX0RGTEFHX0FOKQ0KPiAgCQlzZXRf
Yml0KFNERVZfRVZUX01FRElBX0NIQU5HRSwgc2Rldi0+c3VwcG9ydGVkX2V2ZW50cyk7DQo+ICAN
Cj4gLQlpZiAoZGV2LT5mbGFncyAmIEFUQV9ERkxBR19OQ1EpDQo+ICsJaWYgKGF0YV9uY3Ffc3Vw
cG9ydGVkKGRldikpDQo+ICAJCWRlcHRoID0gbWluKHNkZXYtPmhvc3QtPmNhbl9xdWV1ZSwgYXRh
X2lkX3F1ZXVlX2RlcHRoKGRldi0+aWQpKTsNCj4gIAlkZXB0aCA9IG1pbihBVEFfTUFYX1FVRVVF
LCBkZXB0aCk7DQo+ICAJc2NzaV9jaGFuZ2VfcXVldWVfZGVwdGgoc2RldiwgZGVwdGgpOw0KDQo=
