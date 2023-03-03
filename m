Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82312C64EC4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 08:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCCI5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCCI5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 03:57:22 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA874ECD0
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 00:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677833841; x=1709369841;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=8kHCU9m8RXgcoGX+CU1svmrW5VKz2SjX0zYvvA3G2b4=;
  b=dXvoKD7qgstojG2jjjhqmKaDhgFb9YXiOE4MTt87z66EFWrFjBOUmtuL
   Rmm6+AZdVE36qPNRm4O3Vgky1Ni4t0EZEssvO9e1TIh/zkKx+08j6qhH0
   paQtaHY/PI6oLRnoc07zCupmN3Lr4HNY/b8zeMH5D/i14/YnL5pWDdd82
   Lhg4wIH1PiXB2NJZR1LZhET6FO4uqhrw9BNCye+FiNspKG8eoj7Cw73yE
   YsGU51bbVq3h6AjRMHwTPJi4rYhUdJTj+cdOyAcKo5csCcwPBU553hwa6
   QxtCwUdDWzFh/z3LOyL65GMgZRHeRaySD70PPQD+W79qQCj3Tq7cYbUgV
   A==;
X-IronPort-AV: E=Sophos;i="5.98,230,1673884800"; 
   d="scan'208";a="336695679"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 16:57:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckILfMoaW5BCb87Tff1auFH9Vf2NunPvxFG1g4KobARaDbzvigtIvoPtEiVmE68jfgss/XMFCkwl39/9l0zMNHEqINuBGFbypkiaWMxyeyu6jvML9D71QtA90jba2cx4wy8t7O82F+xnkd5vW5V1IBj8wmqh1VW3LEEQY2Zc9OuQETgP5OVZRpG6XCvXNNq6QGwl4j/NshvtIfjffJ7fAFl+XtBMFSkEfWYvKGMElB9YGcxr/rJ1hgiPEk2dwD8l49rNHfU8Ex9z86/hPeasBVzNJweZP/DcHvbWoRJJ6ni3/y/UfpTIfiHqGcJNC6EEtLaxY9h4M+Iyx/LiXvoXhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8kHCU9m8RXgcoGX+CU1svmrW5VKz2SjX0zYvvA3G2b4=;
 b=Vz/zvckXW0+8arbt/TM5XEu4d6r52KBQiH9Cdo+Yb30WkPrE6TXdhbecTfzEAvfJZ5rnQMam3/pkXsAaRkaFoyCpGM58njvG8YnquOJkJjqBURzp1R8woKCFGzDWc2SRnuciYzFW/QEm7wW0y1gWZD4OUJrYXAaNXlyun8aXzjkG0TxzRVegspjNsLOu9KrUeCrE7Fk4fBGfxCwxIUkwRa47zfqrwj3O9MZDiNPofyMz6UcbRHt2LuYnJDj+fWNnEcPYqcj4hmecKBFswM8HXqZiN7zZZK+JuOf/W2wjeP4cqzUmQv0zNWFxJUBp9YjhUuqEDKI4AEIVdclX0ON0Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kHCU9m8RXgcoGX+CU1svmrW5VKz2SjX0zYvvA3G2b4=;
 b=t3jccztNxxuETg3lnbCuH39XxWqEDbMimHKHM+XiiENPTfKgIwERkxbEwWH+mdVDe34rxMITBXq4lK2wue1nK74pziIHBkv9yWZkWYrddNXnecpAtWfEfzX24C5bGVK19Rs77InC/mslIrHehs0Sa2OA/RAXnYVmA3ubZfpMTKk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BYAPR04MB3893.namprd04.prod.outlook.com (2603:10b6:a02:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Fri, 3 Mar
 2023 08:57:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%7]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 08:57:17 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Thread-Topic: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Thread-Index: AQHZTXGx6nIjJMYC5EeQSEpL0Hi5Qq7onFwAgAAlDgA=
Date:   Fri, 3 Mar 2023 08:57:16 +0000
Message-ID: <7154f10b-0abb-e042-18c3-7ddd5b13b345@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
 <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
 <1120bc4a-0c3a-47ab-8f33-cc3e048c10c2@opensource.wdc.com>
In-Reply-To: <1120bc4a-0c3a-47ab-8f33-cc3e048c10c2@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BYAPR04MB3893:EE_
x-ms-office365-filtering-correlation-id: 62e1f3a2-2b74-4bd8-9660-08db1bc54a35
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MhVwtDDBBoJwYCvqADrrwsTLyJWi6r6iXBOPwQ2Leo3uoxrxYTpDoIgSMOlIUmdk9eKeZXImQ4nEGhuWeNGjqfPvQlAqLXIac/dMePpLzlRoUv/h6Ywob/JgfyNvqfHMHdU+myNS9zHbisyx6fKciRMNje8TKNOKLBqkhJpNeCQcIU3IX5GUnGwBkxGNttmHr2gLOZEnnMPIrWGAZ9e9ps+CkkFrotdXM4c9pwW8T7hMNoB/bD52iwU87UJpyPeKft5ON4yMcch39A7xAwKgNVVvOhJZtPUeLGsMx0DWIho1k6Sr7/jXE3rBHkgTzFZEon0eJQEwVV7O0YOdtk6Flp2bcOiqYnyTCMv/wmxK/cltSYngvc5ZZmBCJr/pKdUMaHJfjK896JH3uaHfa0hAzx3IAQTgGBPnfgszVb99PZRfqrd93xIktT36GpPJQPjxZPuom51kdhE64aFHVjG99CgWjkS+Uk+49RwJaxrWSF3ybfPlJnd2JqYdasdtHcgUjYeD73wiWIT6tYAcAo5amL0L5M37XydRjnaHkmBb76aGUJNjE/ATn31sTNECsKe3l06T4vkUa4GxeZSojUjQvtT4rcrcWWAcA+kfTSLu2nRvnEnl/qFnhyI4GMb6lsjWsO0jodlgPBWeW8PRYiTFhNyiJyEu4ySMEN/d18LkO/s8vuJsz8Ev8C0EtylwNIAMccEkZYlTt1Do4SrnJ9Mnov6EnDdG9Mw/xwcbIi0HNPwM6MziQWi5uFsZqjZa6Jphb+1ay+9en2TuhcntqYWkpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199018)(122000001)(316002)(38100700002)(41300700001)(91956017)(66556008)(110136005)(8676002)(31686004)(66476007)(76116006)(66446008)(66946007)(8936002)(64756008)(82960400001)(86362001)(478600001)(5660300002)(71200400001)(2906002)(36756003)(6486002)(38070700005)(53546011)(6506007)(186003)(26005)(83380400001)(2616005)(6512007)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzkraVJLMHRvSnc0ZExmMCtlaTg4Q1ZNUEkySHZwTEdNN3ZneUZYdjNsL3FL?=
 =?utf-8?B?ZVp0VHBUcXpwSUh2YkxrcEhNcHNXNnBLNFlNTTVBbWZDN3RYUVZQWnFPUTI5?=
 =?utf-8?B?SitxbmN2Q0RYTFRwOVdBLzluelpYc0dXOSs0V1VOc1hvRzQ3OS8vYW9oczdT?=
 =?utf-8?B?SG0wMXRZcFlpRkYzWGdJWWJZbnRzbVpJUVVheEdLWHBCMlBUV2dPVFJta2xU?=
 =?utf-8?B?UHBZZE12aVJBMkNKZ3FnYUhmRitvbzl3UUpCL1Jza2V2UXVUaUl6NkRQRytS?=
 =?utf-8?B?c0cveUNYU0xoc2JZQkNGdXFlS3RPWnpuSG96bjdWdGpjVS96SlV6am8xbXR3?=
 =?utf-8?B?V294SDR0T21FYTRoYVlyVm0xZDNLQkYyWXEzOG85aDV4NVNlaEtBS3AvUWF6?=
 =?utf-8?B?em5INzkrTVh6d0kxUmhrdFhHTFRoZVB5T2p6cm5RVWtRYkVudm5idk9VRm9D?=
 =?utf-8?B?aW56aWVGYWtVSUVZYmRCZVBPZHBydWxMaTBEbkJsQ3FKOFg4UmIrdXJuVTVh?=
 =?utf-8?B?SUlWbWFTcjQvMWM2WDVYOG41TS9ueHpaZFBTbGczUEV3alFQd3dYdUMrSGNr?=
 =?utf-8?B?Sjh6b1ljQThhZnZlQjJmbks2ODUxcWpqQWVXUFpvajYxSHNBdkJQbGVjVFdE?=
 =?utf-8?B?T2JvbGduL0xxZlFPSSsxMDZ3WkdJckVFUDV5bmxURXhydlVQdXpwbmxnRXJW?=
 =?utf-8?B?OWN4dGZtV2xSMnd1QjZRN2Q1V1JzSXFsRDcxYThJRGw3Slp0M0Z5RHYrTURN?=
 =?utf-8?B?Z0xTSVBqRXRqbDEvV2tGeWVvaUNmMlNsYnMyeGZsK1ZUMEc4K0o2L0FHVUF4?=
 =?utf-8?B?OE1mQTdzTVRzNHZXUEtBNnFINlc0Zk9HNUdIN1YzSjZMZnRuTGFWejJTNEVM?=
 =?utf-8?B?N004emx6MndVcGZ4TmNlVkNqTjdXckVVYThNdUc5SjE0aytsZVVMREVQWTFn?=
 =?utf-8?B?ODBQSGIxNkJaVWJQTVc3ZG90VjZTSUJ2QjFEU3Z1Z2RZZjhpYkdWaFZrZEdk?=
 =?utf-8?B?NlZxUWR4eUtLQVp2TmtPRHhIVUxsVVkvdGhUbys3TENXR1kyaFppZzZVbnVQ?=
 =?utf-8?B?MTBXa2NYSTFOU1F4eVNBcXF3WTlBdjhzQWNXQjBPN0U5SU5TUHRuNkdPYk9z?=
 =?utf-8?B?VmlNcXcwNkF5NTMwVG0xNnVIRHdvYUtPL2Zvd1Vqcys3L0pFRWE0NTBlVU12?=
 =?utf-8?B?VHFSQmIwSjhqTGJnRWNGRDRlOXdCNEJWZFZJUW1BWHU0eFhHek1pWnY3Z0hH?=
 =?utf-8?B?YU1YQmorSGlqT1lVMUhjdkc0SWVnVldqWjJNTUZhck05TGN1ZjE5NzluWFNV?=
 =?utf-8?B?SWUzaDNoT2hORWorNDdnRWM0OHhxK3cxMGp5UHhzSVBHWDQ5SVc2aS9OUFVY?=
 =?utf-8?B?ekcwSzhIQUhyazRhL0RMTHA0TldaNGhCT2llNzg1Z0hOQTFwYWZOZVZib051?=
 =?utf-8?B?WEpKd3pCZFNxSVZrQjhNVlNvVERmbDJBUldzb2ZSOW5jTXFQaElsb3JDZVVv?=
 =?utf-8?B?VEV2a1JWdXF0aGRwRDg3TWkyS3dkN3RIZG9zZnNyZy9vV0Ztb3BNNks3eVkr?=
 =?utf-8?B?SUFEZ1BIbXF2ZlBWZzY5UjE2aHJydjFhaHNJeStZNlRYMERpNkIzOStDRnpy?=
 =?utf-8?B?a3ViQWVVZ0xGSmVzblllUG9HVk5zTU5kWjJ2TXlKR29JTjFleFlORkVaVmUr?=
 =?utf-8?B?TWl0MXVseE1vRWJOOHJQS3dSamhoT1pKY0dvRVRIZDFSY3FEYkloWkJXdVpl?=
 =?utf-8?B?aVZSZzlZeXg2OVl0V1B5dTdyc1RoeDQzMkMra0trZlR1L0hUOUd3a1ZjTHZM?=
 =?utf-8?B?Y24xSlF6ZTMxWEM0RFBTVzMzWm9xT0o1S0hJeEhsS3c2bHZYQWU0R3p0aldE?=
 =?utf-8?B?aVg1R1JMc24zd2p0OXYwSFpRRFJmR1JUcGtUS0thT21qWi9vdWVwWDNnbWY5?=
 =?utf-8?B?SmdUemtsMmkyTElJb0J4L1RaemlWeXNNUDBZVk1JY3lZWWhISlJzTFFNUU1X?=
 =?utf-8?B?ck83eVhqQWx6L1RsV29wNXRTZFhjVGY3TkdBaE9lY2lZd0NjYVZ2RE4rZE5k?=
 =?utf-8?B?Wk1nZVlQMUdjTWh3ZkdFd2ZiUVIvY09VN0ZCVmh4aFYvWStZbnhCZ1g0VWtp?=
 =?utf-8?B?b01MZzVZcjNIeDFCLzZlRFhNWTNxYmJjV0Q5V3JzRGdOL1pUSFF4d29SUC91?=
 =?utf-8?Q?c9EamlC7GEHOvWTgKZiAKww=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <155F5157613B0049970580E03ED72049@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mJUZaL94+nI/dhcHBX6uMBStG71S77AmWmkUqojy6rFa8rFUUwg6x0nHzDV5l5arxGlsM+ywVwRTlMsJ7cfZoqv8XKRn+TU/VOlyioLOT30sPcLndI/iSzsETZY9HPjvKMFRQ8xn3aputV4rl/EmEIAxeY22cm/5Ph5zYkLRMk/4H1e6Y8yJla5MTIh1VjUSKYu34DFqsP+qRNBzfw3r1EWwWe8mJ7u6rNwfuKj/GvN7Gq5bcZg3zymt4cQEDUR5Z80lwOYVPvfP/opzEqZ3taDsW4y9eAE6N4d/HTY7SeFckWzUVWFTHdberZICoC5RpMnu6n8tR6AGBhfCgvm5yZ7ENtHVZhtWAqm+2VWAOnapLrpORagCj/mkIXTmBnYhI0RBwlryhxkz9TwM83S/J+G5PjF/L7axqzeCXQ/yHtpVgz73qTCIAdMwxSkH2H8Oyf6NinHbNvb7HwKSganlOB+km8vJfgmfE8UtreQOS2eBvkiFFt2cefo/kJpD3DcM2WNPUfPeNpBqZIbfIAYRI+IDGwxeAAXafbw+F5b0+EPmwpd0CJ+K87d2Xf6FvTLYBlqdbelM/m1olF2hj5VZVDHZbdLM2HU2ZPMlnBWrdAVVVfEup5rqpoml/rEwFh/3HyJyTmkqHQ4A8GtJ14rXMbcFtxwCs9Qg+1yeDE+KSYhdZS4Szvo61GI56txyFBi/r5naaDju4LyjWglee8+w7ZV19YbYnNUDlj2XucUuvgN0GSf8w8aNsCn0MZC28OXAmuoCjqQ7Fe7yzz1WR/s/8mh7OzpFvkaSrzm4hWPMVKwJdXvTK+woEcQObtztlwbl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e1f3a2-2b74-4bd8-9660-08db1bc54a35
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 08:57:16.9965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ELv97QC59r2q4k5NqqLumXaMOliX8fe13ZGOngVGNZjTslSjbn9sSBsJsyB7n+T9D2nLTIrsmjbaMAt+iE77mtQRupPxzSFsckrO4N6CiCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3893
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMDMuMDMuMjMgMDc6NDQsIERhbWllbiBMZSBNb2FsIHdyb3RlOg0KPiBPbiAzLzMvMjMgMTA6
NDQsIFNoaW4naWNoaXJvIEthd2FzYWtpIHdyb3RlOg0KPj4gV2hlbiBob3N0LW1hbmFnZWQgU01S
IGRpc2tzIGhhdmUgZGlmZmVyZW50IHBoeXNpY2FsIHNlY3RvciBzaXplIGFuZA0KPj4gbG9naWNh
bCBzZWN0b3Igc2l6ZSwgd3JpdGVzIHRvIGNvbnZlbnRpb25hbCB6b25lcyBzaG91bGQgYmUgYWxp
Z25lZCB0bw0KPj4gdGhlIGxvZ2ljYWwgc2VjdG9yIHNpemUuIE9uIHRoZSBvdGhlciBoYW5kLCBa
QkMvWkFDIHJlcXVpcmVzIHRoYXQgd3JpdGVzDQo+PiB0byBzZXF1ZW50aWFsIHdyaXRlIHJlcXVp
cmVkIHpvbmVzIHNoYWxsIGJlIGFsaWduZWQgdG8gdGhlIHBoeXNpY2FsDQo+PiBzZWN0b3Igc2l6
ZS4gT3RoZXJ3aXNlLCB0aGUgZGlza3MgcmV0dXJuIHRoZSB1bmFsaWduZWQgd3JpdGUgY29tbWFu
ZA0KPj4gZXJyb3IuIEhvd2V2ZXIsIHRoaXMgZXJyb3IgaXMgY29tbW9uIHdpdGggb3RoZXIgZmFp
bHVyZSByZWFzb25zLiBUaGUNCj4+IGVycm9yIGlzIGFsc28gcmVwb3J0ZWQgd2hlbiB0aGUgd3Jp
dGUgc3RhcnQgc2VjdG9yIGlzIG5vdCBhdCB0aGUgd3JpdGUNCj4+IHBvaW50ZXIsIG9yIHRoZSB3
cml0ZSBlbmQgc2VjdG9yIGlzIG5vdCBpbiB0aGUgc2FtZSB6b25lLg0KPj4NCj4+IFRvIGNsYXJp
ZnkgdGhlIHdyaXRlIGZhaWx1cmUgY2F1c2UgaXMgdGhlIHBoeXNpY2FsIHNlY3RvciBhbGlnbm1l
bnQsDQo+PiBjb25maXJtIGJlZm9yZSBpc3N1aW5nIHdyaXRlIGNvbW1hbmRzIHRoYXQgdGhlIHdy
aXRlcyB0byBzZXF1ZW50aWFsDQo+PiB3cml0ZSByZXF1aXJlZCB6b25lcyBhcmUgYWxpZ25lZCB0
byB0aGUgcGh5c2ljYWwgc2VjdG9yIHNpemUuIElmIG5vdCwNCj4+IHByaW50IGEgcmVsZXZhbnQg
ZXJyb3IgbWVzc2FnZS4gVGhpcyBtYWtlcyBmYWlsdXJlIGFuYWx5c2lzIGVhc2llciwgYW5kDQo+
PiBhbHNvIGF2b2lkcyBlcnJvciBoYW5kbGluZyBpbiBsb3cgbGV2ZWwgZHJpdmVycy4NCj4+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBTaGluJ2ljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5rYXdhc2Fr
aUB3ZGMuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9zY3NpL3NkLmMgfCAxMCArKysrKysrKysr
DQo+PiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3NkLmMgYi9kcml2ZXJzL3Njc2kvc2QuYw0KPj4gaW5kZXggNDdkYWZl
NmI4YTY2Li42ZDExNWIyZmE5OWEgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3Njc2kvc2QuYw0K
Pj4gKysrIGIvZHJpdmVycy9zY3NpL3NkLmMNCj4+IEBAIC0xMTIzLDYgKzExMjMsNyBAQCBzdGF0
aWMgYmxrX3N0YXR1c190IHNkX3NldHVwX3JlYWRfd3JpdGVfY21uZChzdHJ1Y3Qgc2NzaV9jbW5k
ICpjbWQpDQo+PiAgCXNlY3Rvcl90IGxiYSA9IHNlY3RvcnNfdG9fbG9naWNhbChzZHAsIGJsa19y
cV9wb3MocnEpKTsNCj4+ICAJc2VjdG9yX3QgdGhyZXNob2xkOw0KPj4gIAl1bnNpZ25lZCBpbnQg
bnJfYmxvY2tzID0gc2VjdG9yc190b19sb2dpY2FsKHNkcCwgYmxrX3JxX3NlY3RvcnMocnEpKTsN
Cj4+ICsJdW5zaWduZWQgaW50IHBiX3NlY3RvcnMgPSBzZGtwLT5waHlzaWNhbF9ibG9ja19zaXpl
ID4+IFNFQ1RPUl9TSElGVDsNCj4+ICAJdW5zaWduZWQgaW50IG1hc2sgPSBsb2dpY2FsX3RvX3Nl
Y3RvcnMoc2RwLCAxKSAtIDE7DQo+PiAgCWJvb2wgd3JpdGUgPSBycV9kYXRhX2RpcihycSkgPT0g
V1JJVEU7DQo+PiAgCXVuc2lnbmVkIGNoYXIgcHJvdGVjdCwgZnVhOw0KPj4gQEAgLTExNDUsNiAr
MTE0NiwxNSBAQCBzdGF0aWMgYmxrX3N0YXR1c190IHNkX3NldHVwX3JlYWRfd3JpdGVfY21uZChz
dHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+PiAgCQlnb3RvIGZhaWw7DQo+PiAgCX0NCj4+ICANCj4+
ICsJaWYgKHNka3AtPmRldmljZS0+dHlwZSA9PSBUWVBFX1pCQyAmJiBibGtfcnFfem9uZV9pc19z
ZXEocnEpICYmDQo+PiArCSAgICAocmVxX29wKHJxKSA9PSBSRVFfT1BfV1JJVEUgfHwgcmVxX29w
KHJxKSA9PSBSRVFfT1BfWk9ORV9BUFBFTkQpICYmDQo+PiArCSAgICAoIUlTX0FMSUdORUQoYmxr
X3JxX3BvcyhycSksIHBiX3NlY3RvcnMpIHx8DQo+PiArCSAgICAgIUlTX0FMSUdORUQoYmxrX3Jx
X3NlY3RvcnMocnEpLCBwYl9zZWN0b3JzKSkpIHsNCj4+ICsJCXNjbWRfcHJpbnRrKEtFUk5fRVJS
LCBjbWQsDQo+PiArCQkJICAgICJTZXF1ZW50aWFsIHdyaXRlIHJlcXVlc3Qgbm90IGFsaWduZWQg
dG8gdGhlIHBoeXNpY2FsIGJsb2NrIHNpemVcbiIpOw0KPj4gKwkJZ290byBmYWlsOw0KPj4gKwl9
DQo+IA0KPiBBIGxpdHRsZSBoZWxwZXIgZm9yIHRoaXMgY29tcGxpY2F0ZWQgY2hlY2sgd291bGQg
YmUgYmV0dGVyLCBhbmQgdGhhdCB3aWxsIGF2b2lkDQo+IHRoZSBidWlsdCBib3Qgd2FybmluZyB5
b3UgZ290IHdoZW4gQ09ORklHX0JMS19ERVZfWk9ORUQgaXMgbm90IHNldC4NCj4gU29tZXRoaW5n
IGxpa2UgdGhpczoNCj4gDQoNCg0KQWdyZWVkLCBJIGxpa2UgdGhhdCA6KQ0KDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jDQo+IGluZGV4IGEzOGM3
MTUxMWJjOS4uNzFlNGU1MTg5OGQ4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvc2QuYw0K
PiArKysgYi9kcml2ZXJzL3Njc2kvc2QuYw0KPiBAQCAtMTE0Niw2ICsxMTQ2LDkgQEAgc3RhdGlj
IGJsa19zdGF0dXNfdCBzZF9zZXR1cF9yZWFkX3dyaXRlX2NtbmQoc3RydWN0DQo+IHNjc2lfY21u
ZCAqY21kKQ0KPiAgCQlnb3RvIGZhaWw7DQo+ICAJfQ0KPiANCj4gKwlpZiAoc2RrcC0+ZGV2aWNl
LT50eXBlID09IFRZUEVfWkJDICYmICFzZF96YmNfY2hlY2tfd3JpdGUoY21kKSkNCj4gKwkJZ290
byBmYWlsOw0KPiArDQo+ICAJaWYgKChibGtfcnFfcG9zKHJxKSAmIG1hc2spIHx8IChibGtfcnFf
c2VjdG9ycyhycSkgJiBtYXNrKSkgew0KPiAgCQlzY21kX3ByaW50ayhLRVJOX0VSUiwgY21kLCAi
cmVxdWVzdCBub3QgYWxpZ25lZCB0byB0aGUgbG9naWNhbCBibG9jayBzaXplXG4iKTsNCj4gIAkJ
Z290byBmYWlsOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NkLmggYi9kcml2ZXJzL3Nj
c2kvc2QuaA0KPiBpbmRleCA1ZWVhNzYyZjg0ZDEuLmYxOTcxMWI5MmYyNSAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL3NkLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3NkLmgNCj4gQEAgLTI1
NCw2ICsyNTQsOCBAQCBpbnQgc2RfemJjX3JlcG9ydF96b25lcyhzdHJ1Y3QgZ2VuZGlzayAqZGlz
aywgc2VjdG9yX3Qgc2VjdG9yLA0KPiAgYmxrX3N0YXR1c190IHNkX3piY19wcmVwYXJlX3pvbmVf
YXBwZW5kKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCwgc2VjdG9yX3QgKmxiYSwNCj4gIAkJCQkgICAg
ICAgIHVuc2lnbmVkIGludCBucl9ibG9ja3MpOw0KPiANCj4gK2Jvb2wgc2RfemJjX2NoZWNrX3dy
aXRlKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCk7DQo+ICsNCj4gICNlbHNlIC8qIENPTkZJR19CTEtf
REVWX1pPTkVEICovDQo+IA0KPiAgc3RhdGljIGlubGluZSB2b2lkIHNkX3piY19mcmVlX3pvbmVf
aW5mbyhzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwKSB7fQ0KPiBAQCAtMjkwLDYgKzI5MiwxMSBAQCBz
dGF0aWMgaW5saW5lIGJsa19zdGF0dXNfdA0KPiBzZF96YmNfcHJlcGFyZV96b25lX2FwcGVuZChz
dHJ1Y3Qgc2NzaV9jbW5kICpjbWQsDQo+IA0KPiAgI2RlZmluZSBzZF96YmNfcmVwb3J0X3pvbmVz
IE5VTEwNCj4gDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgc2RfemJjX2NoZWNrX3dyaXRlKHN0cnVj
dCBzY3NpX2NtbmQgKmNtZCkNCj4gK3sNCj4gKwlyZXR1cm4gdHJ1ZTsNCj4gK30NCj4gKw0KPiAg
I2VuZGlmIC8qIENPTkZJR19CTEtfREVWX1pPTkVEICovDQo+IA0KPiAgdm9pZCBzZF9wcmludF9z
ZW5zZV9oZHIoc3RydWN0IHNjc2lfZGlzayAqc2RrcCwgc3RydWN0IHNjc2lfc2Vuc2VfaGRyICpz
c2hkcik7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2RfemJjLmMgYi9kcml2ZXJzL3Nj
c2kvc2RfemJjLmMNCj4gaW5kZXggNmIzYTAyZDQ0MDZjLi4zMDI1Y2IzNWYzMGMgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvc2NzaS9zZF96YmMuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvc2RfemJj
LmMNCj4gQEAgLTk4MywzICs5ODMsMzMgQEAgaW50IHNkX3piY19yZWFkX3pvbmVzKHN0cnVjdCBz
Y3NpX2Rpc2sgKnNka3AsIHU4DQo+IGJ1ZltTRF9CVUZfU0laRV0pDQo+IA0KPiAgCXJldHVybiBy
ZXQ7DQo+ICB9DQo+ICsNCj4gKy8qKg0KPiArICogc2RfemJjX2NoZWNrX3dyaXRlIC0gQ2hlY2sg
aWYgYSB3cml0ZSB0byBhIHNlcXVlbnRpYWwgem9uZSBpcyBhbGlnbmVkIHRvDQo+ICsgKgkJCXRo
ZSBwaHlzaWNhbCBibG9jayBzaXplIG9mIHRoZSBkaXNrLg0KPiArICogQGNtZDogVGhlIGNvbW1h
bmQgdG8gY2hlY2suDQo+ICsgKg0KPiArICogUmV0dXJuIGZhbHNlIGZvciB3cml0ZSBhbmQgem9u
ZSBhcHBlbmQgY29tbWFuZHMgdGhhdCBhcmUgbm90IGFsaWduZWQgdG8NCj4gKyAqIHRoZSBkaXNr
IHBoeXNpY2FsIGJsb2NrIHNpemUgYW5kIHRydWUgb3RoZXJ3aXNlLg0KPiArICovDQo+ICtib29s
IHNkX3piY19jaGVja193cml0ZShzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ICt7DQo+ICsJc3Ry
dWN0IHJlcXVlc3QgKnJxID0gc2NzaV9jbWRfdG9fcnEoY21kKTsNCj4gKwlzdHJ1Y3Qgc2NzaV9k
aXNrICpzZGtwID0gc2NzaV9kaXNrKHJxLT5xLT5kaXNrKTsNCj4gKwl1bnNpZ25lZCBpbnQgcGJf
c2VjdG9ycyA9IHNka3AtPnBoeXNpY2FsX2Jsb2NrX3NpemUgPj4gU0VDVE9SX1NISUZUOw0KPiAr
DQo+ICsJaWYgKCFibGtfcnFfem9uZV9pc19zZXEocnEpKQ0KPiArCQlyZXR1cm4gdHJ1ZTsNCj4g
Kw0KPiArCWlmIChyZXFfb3AocnEpICE9IFJFUV9PUF9XUklURSAmJiByZXFfb3AocnEpICE9IFJF
UV9PUF9aT05FX0FQUEVORCkNCj4gKwkJcmV0dXJuIHRydWU7DQo+ICsNCj4gKwlpZiAoIUlTX0FM
SUdORUQoYmxrX3JxX3BvcyhycSksIHBiX3NlY3RvcnMpIHx8DQo+ICsJICAgICAhSVNfQUxJR05F
RChibGtfcnFfc2VjdG9ycyhycSksIHBiX3NlY3RvcnMpKSB7DQo+ICsJCXNjbWRfcHJpbnRrKEtF
Uk5fRVJSLCBjbWQsDQo+ICsJCQkiV3JpdGUgcmVxdWVzdCBub3QgYWxpZ25lZCB0byB0aGUgcGh5
c2ljYWwgYmxvY2sgc2l6ZVxuIik7DQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKwl9DQo+ICsNCj4g
KwlyZXR1cm4gdHJ1ZTsNCj4gK30NCg0K
