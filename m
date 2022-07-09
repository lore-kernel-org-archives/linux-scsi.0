Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C3EC43334
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiGIAqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIAqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:46:48 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DECE58857;
        Fri,  8 Jul 2022 17:46:47 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A7CFCC0D6B;
        Sat,  9 Jul 2022 00:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657327606; bh=S+4GHDxZZdQakfHyCA4pJwdiaEzlLJ0FrP4pzbFfw48=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HcsJYg2TL/6e/b4NRa35YTIKE6eKpeH3DvtdAqWFwPnD5nlaTjVAGTEV8Gi8ttvAo
         K6fhUDbbZ45iCL9CsC7BX7oUfk0rUQkd4/vt5wNwQTwZzICqJnjhpwwkmCW8TQ18cO
         Za5fDpduDgStGrYyzgqs2zu8txj5HHb7Zdz1BSKd3kBeRfd9jc+X4AH33ZDCIk3KB/
         T3bzdpagS9ZqGCq2A+AHOJ1LE1WrQjPqnBv+SO104RC5PRjd7vdxdef336wgTtINEA
         JQNRysd7B22L64inRuD+lnKQkV10Yw8Ui14sry2pfHke8i4zHBainYeW4aAqrHXPPi
         bO+EIHlfio0Yg==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0D731A006F;
        Sat,  9 Jul 2022 00:46:45 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 8A9D580072;
        Sat,  9 Jul 2022 00:46:44 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="ZLV0ZCes";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgBkYkVs8l7KTZrof/j5m2QCnlVtrXPbRFC7/ABG3dmBeJwDjh2gomG6E+BnbtO9LIFRr+dTadTspHt9mFDykNF6DU7+5MB4yqw5GK9o6/Tv74zd6sC5O7V98dn8x1N96XBOfG6yqkEOOke9B1YhQ8E5kShJLNgFENs2JZmebJq1Ka+Ujn9JL/ULEZ4tcTC6Rf5HJo9wtclSkCb7Dvs5NK/21GdEkRoBVml8TrpvLrx3iRlFTajmt/27YTa5Pcv8BEEav2yhKB9IOD3wxwTGqxfESSnAAs4R0+NaEhpXZ/Tl6seX+uoGN2nHG3NzpNAUKDc1yrh9zM+hSDPsUnPZfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+4GHDxZZdQakfHyCA4pJwdiaEzlLJ0FrP4pzbFfw48=;
 b=SKIkaYpviodUxllX3ye6b+2r6MaHQsgmLA5IRrDgCmQxHJGqvx5go5dD71nVJEbBjBVsI2pnvPC8bQ6lLy7PD82Dv388149nJAb/GxZs978oKPD15R+SXr31tjw1zbTwZT/u5XPtXkeAbEkVxOqSFQFYjNiYYBrssUK4Ru6AGr4CusHmx42oH1BfLvf+5PVClVSnnji5sfWMZ/e2IJ4ghOokZxSMIEnNysK0JP4EAgDgBCIh485N6rR0g7fFXv29QCHHH3P6LFSrJBQ5/SVBX3NEnrhk6HHO3tWRdg1r6dPpuvwMKPsfJrxVS7mq+rmUbePsQoAqUc/9zEW/LJssOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+4GHDxZZdQakfHyCA4pJwdiaEzlLJ0FrP4pzbFfw48=;
 b=ZLV0ZCes/zdEDik8lborp/8ntSK1uTZRSX9jo6M9cgHUtz5Y8IBP3D0jM8YTMt5zcCqigr8DAdNoWUCoRHqFaeUf8RR3kE1VyTYKlo9PKdQSr5jv+aeAFBX3AvY9NVjTJif8E483Ky7Pn1K/YQkrCHiizCiMb2l+j7ETmXNhz1k=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by CH2PR12MB4101.namprd12.prod.outlook.com (2603:10b6:610:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Sat, 9 Jul
 2022 00:46:39 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Sat, 9 Jul 2022
 00:46:38 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 10/36] target: Implement TMR_ABORT_TASK_SET
Thread-Topic: [PATCH 10/36] target: Implement TMR_ABORT_TASK_SET
Thread-Index: AQHYkZEUN/GDOLX590CPp1OsigUeDa1zT6MAgADtfoCAAPpuAA==
Date:   Sat, 9 Jul 2022 00:46:38 +0000
Message-ID: <d159a0bd-2ef2-10fa-007d-b90b5dc2d728@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <0004ae8cc8650a32f2aaab0ef9ee3b6e6eb6b69c.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707194018.GH23838@yadro.com> <20220708095019.GA31374@yadro.com>
In-Reply-To: <20220708095019.GA31374@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95b193c0-74f0-4b3e-97dd-08da61447ba0
x-ms-traffictypediagnostic: CH2PR12MB4101:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A30ms5ak9c1PYcf1LyzHFNsCEFAv41wtrRNkmdgEqoHFLsdZzWlZ4LlzGJuIiOZEzyvKBOYTzdpNYerQCV6RXtc8j+cPVTxA4C6ko6y5mlSFwie0wOCtD6sJ183sHSnVpqqwcXHrzjEefJnl2RWiliOw3YKxbhzcOXwRg87yu3RbeNDwvJtfJeA/+YyOXGphN6kKURLouwVIRicmeuIjZPIiZMwPkGKLfWnF7Z06lCloJ8kyNBhvC+KzUqxH8wRO4HZ2TzPLfZv+t9kOoAXolbHcwXaKNYaaXChSzKZ+qjWTtQxUCYUOfqZswfzKxvGxVcraYHOcSiz5b9tbzeUFnzxXvo8aa6cBQpEnSru1IhY8koo1gf0JH+RoW06HgCCvPF48kbzJaR9nFr0d4XJilEL8yG7o8NqQCi+ZZdVpDukaVIttL5YsIYO0DsT4Em3Y6gD7IggidSgU0jQxDRaVG4p16Hthlb44Ox2ggUwmofEg3x1d8aFbobk3vaR5P1BiHAFRRBSvpOOj5aK3QhxzalHAWQE8v0YW4KUyN0U7ElSzgcPB2soMPBY7cGAhS1LPkOLZYhFo5zWvrfgcaLK2QZFfKezyGGrZRS38unj6G/enn535266G2C52WWkxcoPU65ZcZJaCTdgXfHtRm8FjSM2aKnb7z7nQW8B60UvlXsaOoWz2BlQvcQ5pcxHRmgkWMH55TRDOKKEFZumBDBFjZbhhxxZj6tJUWlsdlGqq8Vrs0oXc3/eHIxnFj2tZs/QLGdjTxDfEZzNCKNCe7Uiko1WLPu/9+StxRglnOoVnvEUB1XZdE08N6uPMA9dG42Qa1grGgiSPdZU7DM80/hQJLzY2omaczIJpQxMbJhvXJLIYIdl/dn76Toc1dUqTZe/M
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(376002)(346002)(136003)(2906002)(38100700002)(186003)(36756003)(5660300002)(122000001)(31686004)(8936002)(4326008)(38070700005)(2616005)(8676002)(64756008)(41300700001)(66556008)(66446008)(66946007)(76116006)(83380400001)(66476007)(6486002)(86362001)(31696002)(54906003)(110136005)(71200400001)(478600001)(6512007)(316002)(26005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXY1QTdPUVNhOS9TeTR2SENKWngwZW9GbndZVlFRREhTQVNybzJ0cXZMcVFq?=
 =?utf-8?B?c0dUYXFIL0hOVDBpTlZMajB0OXhpV2MxaUpvTHJaczNscExENVFneUgxa2dL?=
 =?utf-8?B?U1NqdnJhTWFPUDhtQ21DbXhua0NCZGRVY3IxYmZEVm5zem9GVmpsNnlOT0pW?=
 =?utf-8?B?LzUydVlmNFI5Zjl5OXo1d2ZaWTJwYTVQVGMxVHF0Ty9uSk9XY25xam9FR1lh?=
 =?utf-8?B?eEEvWWdBdmN6dC9VdUJIVWtSMzNnM251UlBzQ25NeWZTemNQQ0JEMVQwbUJl?=
 =?utf-8?B?YW02WFZLWGRHdVp1Z1FGU3pnVzN5VkdZL2R4elM0TVFGRGpic09rUzRIRVg2?=
 =?utf-8?B?b0U5K3lHREZwNFV0WnhQUlpQRFBWRkhKUmRlZXVka2s2YWRTanJDTWhvK0o2?=
 =?utf-8?B?OHQ3TjdGTGN3MENwbWUrK01na1p2MVdwangzUytMTFkxVXI1SWpoa2I0QTRo?=
 =?utf-8?B?QUxJKzFGc2QremliVkZsbDlUcUhzKy93djJPblgwd1NRVDFTSEp2YnpnYlJz?=
 =?utf-8?B?Rm95Si9mTUJlTngwaGo3WTZGQy8rQkxQeTVRTnZ3MGp0bW5uVFh0anM5b1Zm?=
 =?utf-8?B?NFlKVncwVTVsV2hOeFRESnlkMEE2SXUwMkhEV1d5OFVUNldPQ0xkSjkvbFNi?=
 =?utf-8?B?ZGZRVURuLzF5UEp1WWN6U0VicGdGL0hhSlZoWVhJS2dvaHlzVXZtQmJUeHB4?=
 =?utf-8?B?ZndNQlVZb3FMbk5CWVRlbUVrTi9TU0Z0OGg1S24vSnFuMnFYZWV5QWRoQldS?=
 =?utf-8?B?cy9EYVZOa0Q2aUh2Ty93NUxRdGZlNTBTY0R1QzNLdTB3VFJkc3hJYUJYK1RN?=
 =?utf-8?B?dWpBL05jSURJdjVxakxOSHdLdnRZOURISEFoRTNKN0F6Zlp0MnhRd3gwd3lN?=
 =?utf-8?B?VDBMSTN1WlFuRkM2elcvbjF2djhqMmJEdFdpeHpUNTJVVkRhNEJGOVAyaXBH?=
 =?utf-8?B?dUpORDhjRzJHcGxJNWxURE9XdytQekNOL2gxYmd5aktodjZQMytZVlhWMC9n?=
 =?utf-8?B?RHNQQStkZVdseWJJSXdPNm03TVY3dEhYWjBkY0xJRFc5ekdXR1lJMXh2Z2ZH?=
 =?utf-8?B?WUY2ejBzRDVteG5BcFhrSENYZVFiTkgxd1o0RmhYaE50L29kVjBidERlMVZx?=
 =?utf-8?B?K1BEK0tXaU1TeXJ5azdIKzV3dEJkQVdHWmduSkt4L2dhM3lxQjNjenhGQkZI?=
 =?utf-8?B?K0FOVEtwNjhSSVFZMHJtWmZaOXJOeStzbjN5NG5rdkxsYmZvemtxampLR01J?=
 =?utf-8?B?UjBrTGYxSnQ0WThFK2kyL0pSbGhJN3FEdWRlUytDVjF3ZlF5QUYyelhRUUxa?=
 =?utf-8?B?a1hSYjluTVFvcmhpcHE2clZNRkFoZklucmIzbE1Rd2lHczgxZmloV0dPdFhX?=
 =?utf-8?B?N2oycmxTcnFsRVlxNHI1bkh5Q25wcElHb3BPTlVBRkFVZGdEOGd2WHFzZ2hO?=
 =?utf-8?B?WlhTMDNCYTA0RkcxU2k5Y3l1WnVycmlzdG5pc1F2aUwwV3hWQjZwWnZTZDVu?=
 =?utf-8?B?VEhUbW93U2tSVkhQQThOMEJKcDNsVm9HQlZkVUY2WFhYMUYyWjJCTUlOOFNh?=
 =?utf-8?B?aWJNcExYVHdBUFhLd1lla0twVGdpN0NHMy9hZGFFRkJSeFltK3RNWHVJclBS?=
 =?utf-8?B?OHdnbWx3N21ZeDY1bmN2MlFiWHM0MEg1Ty93K1VMOU4wa2did3FmMG9wZHNj?=
 =?utf-8?B?bmF4WXU4QllHaGM5ZDB4K0M2US9XV0lwcjl0T2J0NVZ6OWhtSVZ3cG51aGtS?=
 =?utf-8?B?WjgxaklVS0REeXEyMndDUXh0TUlEVnpQRmdzaVFwSU1BVmR0UjhSTll5Y1pw?=
 =?utf-8?B?Rm51c0h0c1QzWEQxNzl4ZldBejN3YUV1R0Rxd1dhb0t2SjlRL3RzdHRtVndC?=
 =?utf-8?B?MXBmY1VXajc0MHlLTWRCY3pPaGdHTkVBdzFGUVhIODNSc2FQbEg1cXEzVlgv?=
 =?utf-8?B?bkJxaXorWUxWYXFNeHI3c0RPc09QcFg3NzB1Nm92VkxKTlRkRm1pd2dOcWFH?=
 =?utf-8?B?bVBoNDVxS2RGclNWdjE0Qi9ndEIyRmpabW52TEZPdDJZYW1WdS9POFNPMmhn?=
 =?utf-8?B?ZUFQWWs5Q1EzeitVNDg4U2kxRlNBQ0pYVTlRVGVoRkhyalFTWmlVM2Ixeisv?=
 =?utf-8?Q?GSfG14/t2jpGbllGzhnrbuoRy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAC01BB5428EB0409D32AC8AF1463AE2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b193c0-74f0-4b3e-97dd-08da61447ba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 00:46:38.5514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JaR1Lw/QxNrEITsmz2/wWhqcvqPjeTS0pIBvMOEB1mS/3aZyGR0HqkqdlgdrwwIfEDoSePrJFhaFOhlX/391wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy84LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gT24gVGh1LCBKdWwgMDcsIDIw
MjIgYXQgMTA6NDA6MThQTSArMDMwMCwgRG1pdHJ5IEJvZ2Rhbm92IHdyb3RlOg0KPj4gSGkgVGhp
bmgsDQo+Pg0KPj4gT24gV2VkLCBKdWwgMDYsIDIwMjIgYXQgMDQ6MzU6MjZQTSAtMDcwMCwgVGhp
bmggTmd1eWVuIHdyb3RlOg0KPj4+IFRhc2sgQUJPUlQgVEFTSyBTRVQgZnVuY3Rpb24gaXMgcmVx
dWlyZWQgYnkgU0NTSSB0cmFuc3BvcnQgcHJvdG9jb2wNCj4+PiBzdGFuZGFyZHMgKFNBTS00IHIx
NCBzZWN0aW9uIDcuMykuIEl0IGlzIHNpbWlsYXIgdG8gQUJPUlQgVEFTSw0KPj4+IGZ1bmN0aW9u
LCBidXQgaXQgYXBwbGllcyB0byBhbGwgY29tbWFuZHMgcmVjZWl2ZWQgb24gYSBzcGVjaWZpZWQg
SV9UDQo+Pj4gbmV4dXMgcmF0aGVyIHRoYW4gYSBzcGVjaWZpYyByZWZlcmVuY2VkIGNvbW1hbmQu
IE1vZGlmeQ0KPj4+IGNvcmVfdG1yX2Fib3J0X3Rhc2soKSB0byBzdXBwb3J0IFRNUl9BQk9SVF9U
QVNLX1NFVC4NCj4+IFRDTSBDb3JlIGRvZXMgbm90IHN1cHBvcnQgVGFzayBTZXRzLCB0aGVyZSBp
cyBubyBsaXN0IG9mIGNvbW1hbmRzIHBlcg0KPj4gSV9UIG5leHVzLiBZb3VyIHBhdGNoIGFib3J0
cyBhbGwgY29tbWFuZHMgaW4gYWxsIElfVCBuZXh1c2VzIGZvciB0aGUNCj4+IHBhcnRpY3VsYXIg
YmFja3N0b3JlIGRldmljZS4gVGhhdCBpcyBkZWZlbml0ZWx5IG5vdCBhY2NvcmRpbmcgdG8gU0FN
Lg0KPiBTb3JyeSwgdGhlcmUgaXMgYSBjaGVjayBhZ2FpbnN0IHNlX3Nlc3MsIHNvIHRoaXMgcGF0
Y2ggbG9va3MgZ29vZA0KPiBhY3R1YWxseS4NCg0KT2suIFRoaXMgaXMgbXkgZmlyc3QgdGltZSBy
ZXZpZXdpbmcgYW5kIHdvcmtpbmcgb24gdGhlIHRhcmdldCBjb3JlIGFuZCANCmZfdGNtLiBUaGVy
ZSBhcmUgcXVpdGUgYSBmZXcgc3BlY3MgYW5kIGNvZGVzIHRvIGdvIHRocm91Z2ggYW5kIHVuZGVy
c3RhbmQuDQpJZiBJIG1pc3NlZCBzb21ldGhpbmcsIHBsZWFzZSBjb250aW51ZSB0byBoZWxwIHBv
aW50IGl0IG91dC4gVGhhbmtzIGZvciANCmFsbCB0aGUgcmV2aWV3cyAoSSBrbm93IHRoZXJlIGFy
ZSBtYW55IHBhdGNoZXMpLg0KDQpCUiwNClRoaW5oDQoNCj4+PiBTaWduZWQtb2ZmLWJ5OiBUaGlu
aCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+DQo+Pj4gLS0tDQo+Pj4gICBkcml2
ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYyAgICAgICB8IDE2ICsrKysrKysrKysrLS0tLS0N
Cj4+PiAgIGRyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jIHwgIDIgKy0NCj4+
PiAgIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4+
Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYyBiL2Ry
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5jDQo+Pj4gaW5kZXggM2U3M2Y2MDMxOWQ1Li5l
Nzc3MjFkYjFlYTkgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVf
dG1yLmMNCj4+PiArKysgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYw0KPj4+IEBA
IC0xMzIsMTEgKzEzMiwxMyBAQCB2b2lkIGNvcmVfdG1yX2Fib3J0X3Rhc2soDQo+Pj4gICAJCQkJ
Y29udGludWU7DQo+Pj4gICANCj4+PiAgIAkJCXJlZl90YWcgPSBzZV9jbWQtPnRhZzsNCj4+PiAt
CQkJaWYgKHRtci0+cmVmX3Rhc2tfdGFnICE9IHJlZl90YWcpDQo+Pj4gLQkJCQljb250aW51ZTsN
Cj4+PiArCQkJaWYgKHRtci0+ZnVuY3Rpb24gPT0gVE1SX0FCT1JUX1RBU0spIHsNCj4+PiArCQkJ
CWlmICh0bXItPnJlZl90YXNrX3RhZyAhPSByZWZfdGFnKQ0KPj4+ICsJCQkJCWNvbnRpbnVlOw0K
Pj4+ICAgDQo+Pj4gLQkJCXByX2VycigiQUJPUlRfVEFTSzogRm91bmQgcmVmZXJlbmNlZCAlcyB0
YXNrX3RhZzogJWxsdVxuIiwNCj4+PiAtCQkJICAgICAgIHNlX2NtZC0+c2VfdGZvLT5mYWJyaWNf
bmFtZSwgcmVmX3RhZyk7DQo+Pj4gKwkJCQlwcl9lcnIoIkFCT1JUX1RBU0s6IEZvdW5kIHJlZmVy
ZW5jZWQgJXMgdGFza190YWc6ICVsbHVcbiIsDQo+Pj4gKwkJCQkgICAgICAgc2VfY21kLT5zZV90
Zm8tPmZhYnJpY19uYW1lLCByZWZfdGFnKTsNCj4+PiArCQkJfQ0KPj4+ICAgDQo+Pj4gICAJCQlz
cGluX2xvY2soJnNlX3Nlc3MtPnNlc3NfY21kX2xvY2spOw0KPj4+ICAgCQkJcmMgPSBfX3Rhcmdl
dF9jaGVja19pb19zdGF0ZShzZV9jbWQsIHNlX3Nlc3MsIDApOw0KPj4+IEBAIC0xNTksNyArMTYx
LDExIEBAIHZvaWQgY29yZV90bXJfYWJvcnRfdGFzaygNCj4+PiAgIAkJCXRhcmdldF9wdXRfY21k
X2FuZF93YWl0KHNlX2NtZCk7DQo+Pj4gICANCj4+PiAgIAkJCWF0b21pY19sb25nX2luYygmZGV2
LT5hYm9ydHNfY29tcGxldGUpOw0KPj4+IC0JCQlnb3RvIGV4aXQ7DQo+Pj4gKw0KPj4+ICsJCQlp
ZiAodG1yLT5mdW5jdGlvbiA9PSBUTVJfQUJPUlRfVEFTSykNCj4+PiArCQkJCWdvdG8gZXhpdDsN
Cj4+PiArDQo+Pj4gKwkJCXNwaW5fbG9ja19pcnFzYXZlKCZkZXYtPnF1ZXVlc1tpXS5sb2NrLCBm
bGFncyk7DQo+Pj4gICAJCX0NCj4+PiAgIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGV2LT5x
dWV1ZXNbaV0ubG9jaywgZmxhZ3MpOw0KPj4+ICAgCX0NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRf
Y29yZV90cmFuc3BvcnQuYw0KPj4+IGluZGV4IGNiZDg3NmU0NGNmMC4uYmMxZTRhN2M0NTM4IDEw
MDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3RyYW5zcG9ydC5jDQo+
Pj4gKysrIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMNCj4+PiBAQCAt
MzUxOSw5ICszNTE5LDkgQEAgc3RhdGljIHZvaWQgdGFyZ2V0X3Rtcl93b3JrKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqd29yaykNCj4+PiAgIA0KPj4+ICAgCXN3aXRjaCAodG1yLT5mdW5jdGlvbikgew0K
Pj4+ICAgCWNhc2UgVE1SX0FCT1JUX1RBU0s6DQo+Pj4gKwljYXNlIFRNUl9BQk9SVF9UQVNLX1NF
VDoNCj4+PiAgIAkJY29yZV90bXJfYWJvcnRfdGFzayhkZXYsIHRtciwgY21kLT5zZV9zZXNzKTsN
Cj4+PiAgIAkJYnJlYWs7DQo+Pj4gLQljYXNlIFRNUl9BQk9SVF9UQVNLX1NFVDoNCj4+PiAgIAlj
YXNlIFRNUl9DTEVBUl9BQ0E6DQo+Pj4gICAJY2FzZSBUTVJfQ0xFQVJfVEFTS19TRVQ6DQo+Pj4g
ICAJCXRtci0+cmVzcG9uc2UgPSBUTVJfVEFTS19NR01UX0ZVTkNUSU9OX05PVF9TVVBQT1JURUQ7
DQoNCg==
