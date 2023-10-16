Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED5FCDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 14:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjJPOAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 10:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjJPOAB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 10:00:01 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D47EB
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 07:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1697464800; x=1729000800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=liZoaPm5/BRvkxEG9jG/ZOSsLnmt901SO8shE2Ufnzg=;
  b=VuFebHCmZO9PM3QpC1w85P4o4TLEXoSgOOUGiocBnnECpgIvqdrlCPri
   LbU7IVDgTTkdHYGTe1ko9n3/5/APQMoB6nUEmn1jist9upJtB6BefY6e/
   f9jf9+8JoWOY3SNHIxBEQold8nVEwCRHh0d1abZYc1H+Hqgl2eKY3Rh/1
   PHKjofsg3L8pTs5dY1NfagQ7wt2hOWlAe55ibbR54WyCLY50cfy5DGnxr
   jwCIGFi8NzbyDJhSyJFEC3YA39jhf1yTYFyPG/eD/FELHIcQw5aUAdumq
   FNyAwTnJOI2BTAjHtg+U7rkluSLejJ4U3w1/2Ij/tjpjYEcUlO7Kwzqq+
   Q==;
X-CSE-ConnectionGUID: /vFrY6ggTuKnvQkMUMKrNg==
X-CSE-MsgGUID: nDEMkc4kRw2FwTPGy1WlCQ==
X-IronPort-AV: E=Sophos;i="6.03,229,1694707200"; 
   d="scan'208";a="246940590"
Received: from mail-sn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.40])
  by ob1.hgst.iphmx.com with ESMTP; 16 Oct 2023 21:59:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuqVE/07DBvvkoElJ8Waa7BFPBK889aBFViVXiTwnxSjrStijGCySVTYJ/dnAgWOkNFQnGdQE6Ob0WAC/mVmRtZzbmoO4o39sbUNK+VVpRrhcmlpAbtPLc7eJSzenvYmEoCITGH/dqTc0IOUMr2uwOK65eZU969Wn59y7QqWdALOm2wPefeRpSFLkmfdc5k1yWCu/ofmd6Q+Neh2z4jEcz5sAOQOUYIX8h721mmnELLx3DD/BQgPRbOMugQbDZ77KdpJU1B5mydQTPmuZgiN9e93Num3dh2jSHIcZp8Z8QxA+iVh7N3ajGjo2W7J9ckMv5vZjL3/VDL9Rdq2bSJYrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liZoaPm5/BRvkxEG9jG/ZOSsLnmt901SO8shE2Ufnzg=;
 b=GS78wdmBtu2iOvoo6NcSYYMg13nS4Nl3siKTwVkwEIE7eo5GuBh5RWVfrrRpfFsJIBRYUoM8BgXSmgNgDBiN9eBJg6TUTDgJlHR40d3gw203OszO5/H9qcd9TPeg9fhFTnNIPMJpZXfAt0U6e2WUNNy8ZDuRxJYYLo67hyDYQkjw8LnPYNvJaA82AKQngZ6T3eUjvYKEvETdD0Nr34v/QsrKW5MCRYIMcWGaKRIXPBkrZziLhPDtK0i47BlBvtqahDNm/ZnqVeu8Nz8bZkL87TVUYKggbp+umUCUlWTRbfm1i3P9ROuU6sE3arQCc/EC4hPz3k9jgY8TP3gB8pgZNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liZoaPm5/BRvkxEG9jG/ZOSsLnmt901SO8shE2Ufnzg=;
 b=ZEM0t7l3z2WYvzPDWpWFDqdg2yxaaNhocLimTqUBREq8KgqbPTj+9L5x3YB4P4xNDqTclddNlq+1/IsORGSodNImz9uqb1raIXPzyEFWjGc5e4gMwOi7R/Gsm3manbYQUGKnddjThjxGC6d4Rg0apSH5ZVO8rasSdBoiM+ZfHyU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL3PR04MB7914.namprd04.prod.outlook.com (2603:10b6:208:339::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18; Mon, 16 Oct
 2023 13:59:57 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5b7e:bd22:eb0a:2aa6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5b7e:bd22:eb0a:2aa6%5]) with mapi id 15.20.6907.018; Mon, 16 Oct 2023
 13:59:56 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 5/9] scsi: set host byte after EH completed
Thread-Topic: [PATCH 5/9] scsi: set host byte after EH completed
Thread-Index: AQHaACqJK4656HOgjEGNlUkwoEnpubBMccEA
Date:   Mon, 16 Oct 2023 13:59:56 +0000
Message-ID: <de189b84-073d-45b1-b72a-8a2cca993a4c@wdc.com>
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-6-hare@suse.de>
In-Reply-To: <20231016121542.111501-6-hare@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BL3PR04MB7914:EE_
x-ms-office365-filtering-correlation-id: 1166f286-c1eb-44d6-3c1b-08dbce502dc8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8c7UKcmplPaSHj1PSjkubigCB50fn6sIOOYcYy3hSEOl5BX4/b3OUK+pvwD3M32L5dK4Z9372Wx78VFx8dFk97NeHDe+N7vUeMG0Sh9mbB/dNMdm329nFeTSiD1rpeHIgD3XTrrMM9LFQvgZyxAF9TdQ/Jpmnlu2sPVnlb27jTyqwhd8KQtno2JPRBdUaZun2U47QRtkMxmStNRNXBp/T+RoABOf9KokKyWnlUYfRd53SOH4BYjLlWVvvRMjKJOxn6nLECBywhRW/yckkptcTGetAkjjwVtApj4wWbU6piRZzkMnuughVpjNg7AzUoBe7cIppRbH/ub0uYsNOaCK2IW6vNiLRYrhOtUD/370KawkZ6E5QwHVavh/q86xJI4x8LC9B+I7I/kK4853s3g5HwKe6CHYHzch8JtCvc7E3TxJodZOnm/VFkW1RxJq0vNLuwBmqARllpgufWE8QDHJ/R5GctMVXlGPRcfkZPF5AjPcg7iXUmajmM8179M6yYi6CMRdcoQdDcyzXDjWPG4gTUOa5BRf+ceveZUW1Ba/BMhGbJA7qeAFiVPpAD0bsAby4M+Wjq4clEwMLsidD20n3zT4P+KtGEBTupZj70pAzEGQAS+AA1KvPTf6HoP3fIz8B7nncJUltWTONWbJ5OZ5qx1XnuSZzc/LOqf344yngya/eKrfNZGTwPIqSIChZogd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(376002)(396003)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(41300700001)(6486002)(110136005)(478600001)(91956017)(71200400001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(54906003)(6506007)(26005)(53546011)(6512007)(316002)(2616005)(8936002)(4326008)(8676002)(4744005)(2906002)(5660300002)(36756003)(38070700005)(122000001)(86362001)(31696002)(38100700002)(82960400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkszRTA5QnViQmVVRGk1N1NEY0VMNlZUUGlKK2F0SlJqclg2K1htUm9ic1Bj?=
 =?utf-8?B?aENrYjhFZkEyYU1OU3FyVkNvV0JCaDRBWDFaUVJ6RllpNDUwZ0xqVmJkN2FV?=
 =?utf-8?B?TklEZGFpb1IrOTIrVWZYZlVvVFVpUnJsVTd4UE4xdG1KOHNDeFphNkhVZG9U?=
 =?utf-8?B?WWZOZTRZT21xZCtGNW5JZDdtdkdobGpPSmJxcktZK0VSQnJXN0Ird2JMajYz?=
 =?utf-8?B?OFVNWkVXbmtNa2ZhTDYvbVYvZHFkVmI0ckhQTWQySzl6cmZWTHRWNHN1VXdL?=
 =?utf-8?B?OVJLWXJJajE3Z25MeEl0TGgxaGFvcklMWnlqalFvbVJqWHM4ZG9RRENWSzZx?=
 =?utf-8?B?MG5XUjJtNzl4RmVxTzRrMC9CYTNGS3d3QU9JQVFYM3pkbm41ZURITmM1T2xS?=
 =?utf-8?B?RC9DellsTkEvQk5zcjIrYVVXUE9IUkxwNk1Ed1dGUWYzWktjTkhiRzBjemdN?=
 =?utf-8?B?bEJNLzdhaUo2TUlUVVlEVkNHdDZEclR4dnc5TlQzWnpiUDJQQjZjME5jdDlu?=
 =?utf-8?B?S3NpbDFVQzlFNzBOYkppQmw2cmdWbGlvVEtkMDR3WnJ4YnVhZFE5dDNiYXZO?=
 =?utf-8?B?a0N0V3RoNnc5YUhpV1lKcGl4UGY4RzgyMytHZTB5a09NbWptQW1ROTg1dlo5?=
 =?utf-8?B?UXVQU2tXSXF0ZmoxMXYzOGdxTG1WYlUwMkdOK3lsbXpmRTdxb2FDSlgzTHk1?=
 =?utf-8?B?N1EvRk0xVTY1Qjk2S0ZPMFY4L2pkNWJKTDVtU3E2Si94YzlKTEJrR3c5OU1l?=
 =?utf-8?B?cjlWN3VKUC9DZFIzY0ZHTEVFWjBocytZT3FQWXE4QWFrOCs5VzR3eGVqM0VR?=
 =?utf-8?B?RkFCd0VwZXd5L2N0OVAyNU5nRW9hYkFTNzgrMU8xNXBJQlJuR1h5SXpCZkhh?=
 =?utf-8?B?bWcyNTl1ajZLTWhLWHJLSXBCSG5ZZnd2Uzlmcm5MM0Q4dTFTMXZCbURrbzF6?=
 =?utf-8?B?Z2NHTHBzN3ZhN2tERldpd0ZTL2FaM2g2QzRNYjJzcWlMSzRrNkZWVXkwd1cz?=
 =?utf-8?B?OXJZTXNCczNSblNrRnNEWHJTZkxEVmFPK0d2YnNocGh4dURGN1NWa2x0WDNZ?=
 =?utf-8?B?WGVhTFlJQjlvc1lSamFhSTR6d0NTOUhUU0JoRHhnOWhSR21pemRsT1hhNnpF?=
 =?utf-8?B?UW0xVWRUdVlmbUZuNUJJb0gyQlZ6bDNHK3IrUDdwTmhxSHgxU1lZUkMxOE1K?=
 =?utf-8?B?cUtvWm5qbmNRUisweUxlN1NvZlZ3bndLejlOc3FXNi96V1F2R1FJZVhCVkZt?=
 =?utf-8?B?NjltU2xEZUpUTUJSbGFMVytFR3NBeHhadXdoMU1pUkR4SCtzSzcra1o3MUdX?=
 =?utf-8?B?R0k5Z1BJWTVyU0Fjb3FmQWFZWmVObU9HbWp3a1NZTVE3NzZEalp4ZnR1Q24r?=
 =?utf-8?B?NVI1Uis3cHIrT1hNMHRsNVBzdHBBNkNTc3dTVjkxdTVCeFZwR1RuWG1QZEFp?=
 =?utf-8?B?OHQxbTA1M1RMTTZtd254ZnNrdUVORzlHSXpTUUJ2TWxSMFUyTU5kR1Z4bWJo?=
 =?utf-8?B?TkdHdnljbHpnTlhXSStWQ1JmQ0tvd21JSnkwZ0tyZVlxY0J3Sm5uSjlQNTRt?=
 =?utf-8?B?SDlEUWJWSFV0QmFPUUtOQit4ekRZL3hvYVVIdXdSMkxETE45ZDViZlAwb28z?=
 =?utf-8?B?VTBJOXdGNmxDS2xaMnpJUXcxOGl1eVBLU3daQXRmbFk4VVlwSEx6WFJ1Rkhs?=
 =?utf-8?B?M0FXMUFLU2EyNmxzWXhJSjlCTEdvR3RUZ3YzR3ZxTDBWSTdya2ZGTis2RFMx?=
 =?utf-8?B?UkRzZnFPYUZScmt3VlBWZm16NC9rZzVmaGRySHF1WGh3UXQzNFBkREtpM3JV?=
 =?utf-8?B?RFhaejVtWUZjajRaMzEvSDBPTVhtdFFwcmt2djl0QlJ6cHdtRDhWdFBPb0l1?=
 =?utf-8?B?T1c5bHRmWitSYkxtanN6TVJrQ0svdFRmdFZpaU5VSGs4cHQ0djcyZ29RaVpO?=
 =?utf-8?B?TWRnWXA5SndUZEIwWEZtOE9aeGNmNUs2MkM3T0QzZ3o4UHZYaHJJSUo4OWky?=
 =?utf-8?B?Ynk1QnpZL0FuYnNGS0cvbHJjOGM1c0tFdnh4THJQSk5uS3JhMnF1WjU4VlNU?=
 =?utf-8?B?bTZPa2hmdUd2RXgrMVFRci9taTgveGs1ZDcwdVNOTVJ0ZmZSa3pCQVRCTkVF?=
 =?utf-8?B?UUhyZ0Y2WUxSOWJxQThzWlVrZFJBN0EvMHRkN1h3eFFqMzJXcytQVnIzT2ZS?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A07D358B61D1D1458720ACE53BF1C0FA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rRw/21kxtrluIJe9OKCtBB3KgvWsx8Slavc/km+hJpulLU3ycOqo/GT58uwqbBETERlBmRBVHKbD3lJl69kojrn7ex3KQmR4js4DmdssLYrtBy9t8CPnLqwhfDuyDqFJehWd+m3d+6YGz95I7Qya3AHW9tbW8CgQj1fHJMct1l85CelOm5Kulrp3CnTVc0tSmL+l5qE7Ho92UFSDwo9qrT6NnQyRuqxTSqHQ9FvospFAg3auLwvByyzigu6yqYQpxt4t6kyC0Lk/h3VOBtg0czC1xShuBXto+KCjyCxG059RJKvuGpx1KBg4DfuFDfgYK2iXtj8aoYd1SyAoH3nPVWuzKDc7cWneFRvq8OuxtRVc1nNEQUjfkoAZWc91mC/GPbf+fu1BU9yCv4j9xKXrkzx3wKkCXrMPBVGgOn+BZtaaowuaNABnIzTe7NUibpI28vyYdcf7HTlEkTTQYZS3Ii5orFHwyKTl+l376FBC8jkNFrlDKM42AdajuXgU83snETyDCUmDiNVWTHGj9CC69WgCKfD6mCAoByxRNxNoAgKzSy83KV+eOrRsEVYGMDzk0VIvs7BlhAWHdoM5ThXTuTyMewdJWdluJ8RV6bZZTA5sFftIiOdgxqXcwxWGE1iKx8AoJkf+nt0nH9zmYTapppE1zb8S77clZD8RF9ooSWYWZ3wo/C72LgiRL7Lw6eglEy54Z2UOnLL6gIwNRYowyhDzzyLBvHfUlOuBf1PrF3LmB8AzLI+BgzX8GaK6EIzDlCtnCkF+P5wIRLnfjIrWhq1mPPgIloZcLV67kyFmthb/kdQkDFB8WJK7nCEVYFjvXJNmnNwR5NgPPolboz98+WfXLeI6o+Oq74baPI3YLSAUabXGbmZO9y/c0wuEoGxhC6e+Z/cqjxplDydGQKPoQZsgtdI5t7IPFae+vRjcGyQ=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1166f286-c1eb-44d6-3c1b-08dbce502dc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2023 13:59:56.3766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BGg5THdIgeHz3yed79eUTfOmn4tyDSGrwBCIbEw+FEDfFE+tYZa6g+IRqQ30/ySLjHPnmlqQLXsQLI9Tfrge2Otzjlx3yHAZ78yaerhmeQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB7914
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTYuMTAuMjMgMTQ6MTYsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToNCj4gLXZvaWQgc2NzaV9l
aF9maW5pc2hfY21kKHN0cnVjdCBzY3NpX2NtbmQgKnNjbWQsIHN0cnVjdCBsaXN0X2hlYWQgKmRv
bmVfcSkNCj4gK3ZvaWQgX19zY3NpX2VoX2ZpbmlzaF9jbWQoc3RydWN0IHNjc2lfY21uZCAqc2Nt
ZCwgc3RydWN0IGxpc3RfaGVhZCAqZG9uZV9xLA0KPiArCQkJaW50IGhvc3RfYnl0ZSkNCj4gICB7
DQo+ICsJaWYgKGhvc3RfYnl0ZSkNCj4gKwkJc2V0X2hvc3RfYnl0ZShzY21kLCBob3N0X2J5dGUp
Ow0KDQpJIHRoaW5rIHRoZSAnaWYnIGlzIG5vdCBuZWVkZWQgaGVyZS4NCg0K
