Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8317BC25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 14:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbiHPOgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiHPOgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 10:36:43 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F95A00D8
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 07:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1660660600; x=1692196600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zy9K3DmyGNK8e/H9i1T65mnZaD1uwo9AH3c5MTNb6nk=;
  b=qDmpMiND7+mVGA1DkFYAIi5gw2AK0hsG1XfYRF13uCSu4ROlNtTY55p6
   6hwzJBr8a7Mvy/5qVQqmXmH5TKWmIz8qmBuT+ZWNKgOCd4UQrane09znS
   UCW2dWTqJ5Hk4EJlJhE5mP3yfuuiBU8BsHHvnRSx6+MwSwN1SoyUka8vx
   3O74zsJGNDuKWapuQUZo6NQjDSYDCHp1WIEFhS+lsvVw5abySVJ555t32
   z/I53LmwhvgXE395MfekFAYk0W0Tk/WwglIIQCGTqUwjOBRMUrmLUXWiW
   /xXNxFfJQ2RD77+FXWVtRTj4qG9WgPw03Ic7b3avwur23hxM3p5QaEhqt
   w==;
X-IronPort-AV: E=Sophos;i="5.93,241,1654531200"; 
   d="scan'208";a="213934917"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 16 Aug 2022 22:36:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eez74DFNKwn0aKSiYUKGRgYs1EH5MgBzWXb2Rkd1S8ZdCoM1dr4U/IXp/yCtNksKyOaCQr5R6Dj/UShtVaSHmeqx7LVshtXsqN7O28uxYqY3MT+HQQFjpgyVqr+joCbRP4nh3rRfInNv5xcKrKEbFP4rQ9QzTAq8um5PbAgRCbxXU22X1DToMSPVzRiYVIOl3d6Rha6ALSer0booEfpaEAZHTuNnj78QAjbUIwVktlOQy0FOe38bsDdgY4s3e1vs0mhK5iF8pcsMTvijMYcU4b+5JZIDY5jTnkCy7qUrqAqvzNJ29lHz4CBGp0+ak68Np1kx61jY8NcdQpt7HFww2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zy9K3DmyGNK8e/H9i1T65mnZaD1uwo9AH3c5MTNb6nk=;
 b=ZAlfCIlV+r++bdK8b+c+vfmnQl1pPKAAAt1Uu/yhzD5PKiKGoYSvPKqSbLZCdVTNShcslgDAR2TF/f55wdKN7Rawfb3bDKsMDTLSgXjSG0ctlQAgqaqOJcNWqYJlSq5MVcu/y/dd/QUKbhJZDVw4jL19UGfaQ9ucCHsNZkCmFbI97hkDKyezWKc+njtSV95TS4rrigkGmYDzMNENKrA+PdOOaVKilemrd+pyN4z3SyEqNWzeWhsTxCVxeubmBTA2QKFb6Isvy5FvYxFolXIdiWzW++C2Cztbatjq8sOEqZKPbXjza0gGYNJkGHsGxAITivk8TRHczLIsB+rd7FkSaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy9K3DmyGNK8e/H9i1T65mnZaD1uwo9AH3c5MTNb6nk=;
 b=dHOlyWHloTsqRlk/7+g6TGlKlxgsu2DF85C6VtLJdu6FwvkzkEl7xDsFD/KkEWroyPw7eTvlHUtSRwhbPIysxxqQ8PqwQ+XMKug9hvayvBiyiIo8MOuAlilYCfkzK8/AY6NBCz26rM0sOUuwArlV5Ycs+ccZJfLnjbE8fxElfsE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB4615.namprd04.prod.outlook.com (2603:10b6:a03:16::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Tue, 16 Aug 2022 14:36:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%9]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 14:36:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/4] Remove procfs support
Thread-Topic: [PATCH 0/4] Remove procfs support
Thread-Index: AQHYroyWPigJYF3bpEil4sOvTR7I962uXANggACKzciAARS7gIABohFw
Date:   Tue, 16 Aug 2022 14:36:38 +0000
Message-ID: <DM6PR04MB6575DCF543E8C814B251B088FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220812204553.2202539-1-bvanassche@acm.org>
 <DM6PR04MB6575F397E1B519922D3C2C5AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
 <e71a33f6-0a65-561b-33b9-6772239c21df@acm.org>
 <ce3ae6cc-bd66-6139-f503-adeee3884313@interlog.com>
 <5b83ac46-9c69-6eba-c19d-5124a022e86a@acm.org>
In-Reply-To: <5b83ac46-9c69-6eba-c19d-5124a022e86a@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e7513a8-be5e-4a80-826a-08da7f94ba3e
x-ms-traffictypediagnostic: BYAPR04MB4615:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kXld/5q/WUylju3EA3y8b7n+AmjzKIUjUXlOCsDZwrITvigHamcQG8e3QQQU473QmARhNoI1CSQfc8BAMTLVa2/siP8iGaJqJ8jk2H+1FvNTyfEJC3oeW9q3h5nibjXm3s6BL6QkWOmQyCvCpsSg2YriPQU4HvdwHs/dm8WFMiV4VruEJRRGZ3jOgc9pcea4Q2DrQkzfDhmkVDOUO1aNo/jSLd+a27Q0TqGCDS+n9aIL+x+EK8sD62YUZUrnJ5eWXwfxyf8GDT79L7ggYgOfXG2ksthH4QXwRLPgMoMeCGOMxuyleK9MHut/LWW0tIHg0zRYR+sJGjp5NFbn5HwDWHneq4c5d2SMBwinUC0lmgteiXNtTk/H8ZGgO1oUGltRnixNPu6FQ7vHsJ8AV12ZXF9sJqwPZrrq/27eunQn9CjM6bG/F4q7Xn0+quEZiETklFevW64BBdSJb695NKtYB56YP44BBtp1gJNbKFWH2k8JUmZqptdGqV1n8YurTzgb+U77idQGarYOcts+qDqGkvrxOmBSwlxDxs0qCwcRAMmD12dsGCP+q75OB53mHHD3xKh49YA6ajh1XkT5BZjHQ6rIAjoOcu28R0RLbTsYmSmbf3ViHSPXtOEEMgo0kPpDrFfjQDeWdxb5qNAilz8At6Pi2gq3eC9VZL+K5O4Pvk7Da4GNeAYswm16qPiMrcpkBZujwsI/forVUXaFpxh2A5bLnx/HKlNXyP0aqoBnXwOvYCqEYXLoqubgthMFszyfv/MMRC3Sg3yS4gFUhdZr5ctKHtJDWnQV6vW50CKLQat2pxY+coEguZ1GypXafaQ/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(7696005)(53546011)(71200400001)(76116006)(186003)(9686003)(26005)(6506007)(55016003)(478600001)(41300700001)(33656002)(66476007)(38070700005)(86362001)(122000001)(82960400001)(8936002)(316002)(5660300002)(54906003)(2906002)(64756008)(66556008)(4744005)(52536014)(66446008)(110136005)(38100700002)(66946007)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHNWazBGaGZuKzlkcGJOTDV4NGNSUEc4REFtdXZlaXBzWUJaaEs1MGhucXB6?=
 =?utf-8?B?dERvelVtU0hZS1JOdUNVT0tmamc0ZndGOFpTTWpqS0pNYkpqdGgxak9OWEoy?=
 =?utf-8?B?ZE94MFNZVjczM21ZRXZOOU9HVFBCRTJSREI0bkNKT3dGVzYyaE5pNkVvbVlR?=
 =?utf-8?B?MXZGemxTSnl1TFBzeHZ4SUpHcENVZnZ3WnpwN1VtUTdhTDkxZ3dmdFhSWEla?=
 =?utf-8?B?Qm9RTTk2bWdGT2QxazY2U1c1NDh3c1liS01kK2FveEV5K2dQODRkSW1VVU9x?=
 =?utf-8?B?NkJWeklYcVlrK2lXbFpSYzNyelZvV3MwNkI4NVNjKzFGMGF2bW1Hemo3SVpF?=
 =?utf-8?B?Z0crMUNuNjBMcWdEY1MweHVqYlFIclB1ZEVWNVhIWHNJTTdWVDVvTmpBSEpE?=
 =?utf-8?B?eXdHb3BmcWdGNDdKdTZwSnlONkVjay9IS1M4bEprZFoyVVhRUlhvMTlUU0dm?=
 =?utf-8?B?dllkSlNaemxXbnJqLzAzN3ZCalF6VUR3Yi93VmR4c0R1Sm42d1RNbnExNU90?=
 =?utf-8?B?dUlXTG8wOTZ0OUJJUnMzNXZJV0lqbjRJbUt4SzZIR2JQS0dkeHBRYUs2Q3d6?=
 =?utf-8?B?cGJZUDJxMm9BcDlMVEhGTGZLcms0dTF0aVMyWlRQSDljR2dVcmtTZTV6VEJ1?=
 =?utf-8?B?alBlK3NQbHJ4cXZ0M2pGWlA4ZWhYMzR2UWZlRzNJckNvRFNrQ1h3NGFzOGFM?=
 =?utf-8?B?OGFoeEppcVhvRE5MRXF2OFZlZkVHbUZEbEFLenNSaWNKTzJUbDZPaC8vSjBE?=
 =?utf-8?B?ck9ubE42VldpSUMxdFB4US9vQzlGdXBuWVJwY0xQQ3l1dnJtWjdQdlcydk0w?=
 =?utf-8?B?andYUmxqSUc3cmliNDE2eHQ0MnlCTDcwNUd4N1ZCNWpHWHRUVUdwd1lCRnJT?=
 =?utf-8?B?T0lXZEZSYk5oQXNIckxmemhCUnREZUQzVkhxVVZrQW9YWTFZcmVka0Z0Rlo2?=
 =?utf-8?B?VHdrTlBUa1EvWit5cFFFcE9Dd0szVGlWcXNEaE5HZUw1T053YmZKYnZ5bmNT?=
 =?utf-8?B?eTZramFwSzd0Vk5YVU9MMlNlSTB1UTBLcnZUUDYvZGFBZWx2Q0xEKzVSbjVz?=
 =?utf-8?B?MktPd0ttTjR1cVU0a3lWUnBuMkVoVEJuS3BEZzMxZjkxQjMyeEROTEdiZ2NB?=
 =?utf-8?B?UXFINDNBWmtGMGlITVU3eHRnSjVoMGhXUC9MTDdwOU9EOHpySHVaTUxESXlk?=
 =?utf-8?B?ZzJpVk8xeVpRZ0dnVklHN0taMGdNSnhYUU44a014bjFSanhGcm5GbXhjT1Ix?=
 =?utf-8?B?SzNRYlJQQTZaSkZCYWthbzRSQjBNeEhzQ2FZNGorUzhxazAxczRYRnBOWFJ3?=
 =?utf-8?B?QWFmSnJkRlNNS3JkTVVra2JZSi9jU3RuNjc3MHYrTS9SSitROWxHemYvcTJM?=
 =?utf-8?B?M25DUkowSG9kK25EY2dVUHdCVFJ5YjIzc2hYSTR0UGE4LzdER3hCbkMrZXBl?=
 =?utf-8?B?dzRPaXZxWlVsV3JtbHJocGlpNjVHSWlyOUpuazVEcVd3ak9PS0pJS0VmVWtG?=
 =?utf-8?B?eCtsaG0rbEJTOVFaY3hzald1T2dkNXp3Z1Z1Mis0bnZ4dEgxR3BiSjBOT1k5?=
 =?utf-8?B?c1FtTURhUGlKUUNVMFFSbFduYWdEUmh4UTh2SzhkTFNudnA1RE9lQlpSaVY3?=
 =?utf-8?B?UlNpLyt6N0JqNXlndElEZnZoL0xVNkg0Q3NzVlV5eVdnVkZ1Q2hqb1dnT0NG?=
 =?utf-8?B?KzQ0ZDV1bzRoLzFwSmRTSG9UdExIMUpGZUkyMHQ3QllJa1FSRTdmd2RuaFU4?=
 =?utf-8?B?TVF1MHM2eE1ka2cycUdSVzAxV1l4WWg0SzlySUpoNFhUTWNaTmt5Q25qQTZJ?=
 =?utf-8?B?UFFjTjBNWmxyZWRXZ1JRYXh3MlNLaXNOak56MHU2L0xPM2NCdGt3SUs5K2Fj?=
 =?utf-8?B?VTRlWHlGV094ZVlpWk9MK0tDZmxWbGd0WDN6TXgvMkYwRktYVHFPS1JTQ2FB?=
 =?utf-8?B?dXpLM2FoUHJaMTJNZ3Mrbk0wYTBDeGc2cjg5Z0dLN3pmTlp5M1o1cDJHZUdy?=
 =?utf-8?B?SEtSQ29WNHFMYWtvZ2tNam1PK3VhU2RLUUd1aHY2cnhRdHpnL1pwR1BMdFkr?=
 =?utf-8?B?cFJXMFpTSWVFbmM5NXhPREJ2YWNPU3pLcjA4OGJZaWRzNlBKSUZZMTRZUjhn?=
 =?utf-8?Q?EyLiwMFiErVN7AiT71hObyNog?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aUpnakpFemtDdVEyakRLNVVUd0g4VnFqZldWc1B5MVp1OXV1SHhlb0IvMHBm?=
 =?utf-8?B?TnFWckVBcFJJVHZ1RWg0bXVJckY3bzhYbkhhN2dFRjVLMWZnNUVjZEJWa3VM?=
 =?utf-8?B?b0xMZ1RRZkFZWHJEODBiODlxZzBLV0ovbzhNMnhRcTdlNEVhcWt5VFlpQ3BF?=
 =?utf-8?B?bWU0SFFzYzVGRUtTMU1mNkNzc2c3VDcyczdEK0VkQ2lzTlg1K1ZxdTkzdjRN?=
 =?utf-8?B?MEtoeEpVOVdPWUJLdVZiclI1VFlwWlZjbTlhVjBiYVhDK09RcVhMd0J0dEdx?=
 =?utf-8?B?SU9kY1hpTkR6NzgzYStGL0EzWjNaaUthQW53UXJnN01zK3BheWwwNHRkY2hS?=
 =?utf-8?B?dm40aHJhejVDMjVua0drN01XaXI0UisrU1MwMTVOZHdNTjhKYVY5TFlnOUg3?=
 =?utf-8?B?RkJtTXBBSndqTEFucnRLSXo2MHBBN0xMTzVWOXdacG1TSVRPQ1d5QlhlWVNq?=
 =?utf-8?B?RXNtSFpWUC9KRnIrTEVNZGpnaU9mUkdOWm1PYU4xWUhBZlhSc3Vsd1AzcURx?=
 =?utf-8?B?U2VpRFpKTzBPaC9IVUFya09qNVRsaEM4Nld3WU1MYTh4LzdYU0NQY2JNejhm?=
 =?utf-8?B?bFBNb1ozd0VWcDllMS9nUnc5R3c2NnAyZXhqNTNYUDFZMURLcUo3VEszb3JV?=
 =?utf-8?B?Mk9HdmY4NXRkS3IvN1N1bG1Ecyt2OGg1alROdEJYejcrbWd2S0dLbmtsR2FC?=
 =?utf-8?B?L1lnbzNuQjJUekxnU1ZPaldsV1UycUp2STA2eS96MzdLdTd0TGRIa08yNW10?=
 =?utf-8?B?YSt5TEs0OENwb0Ruc2tUelozc3UzTmEyZngzektsQnRqVjUxTmkwa3RwVkFQ?=
 =?utf-8?B?YzZYN1hhTnJXdWNmeVQ2dVVDYXpvSlBQaldnR2M4OVZMWFMrcEJVMnRralc2?=
 =?utf-8?B?UW5PYTZNeGx5dW5hMzlXQWFzSXpLR2I0NGtsTnZLUGYxMkFCY0J2ejQzOFJa?=
 =?utf-8?B?dC9uRkw2b0FRM1dma2dxUUI5YmROZ0EweGtoYTdQMTBvUGdCdmkzTW9vTmVD?=
 =?utf-8?B?MDRjVTNrRVBEYTIrNUtYZjgvNUphaTlZNWFkVCsrb1VjV2tZWk0xVUE4Ykd5?=
 =?utf-8?B?L3dsdlZyVlBkZTY2cElTNXQyZzh2WGZEVkl1SDlGQkhOWG9sRnlKbG5yQll4?=
 =?utf-8?B?bDA5OCtVS2hkUDVwZ2RrcEViMGtrOFFrODgzamNFTG16d25yY3dBOVRZbzZF?=
 =?utf-8?B?RXFiQUZ2Sk5lWUxpZFZaQ3UzWVpNSlR3N0JOZTZBZkZPNVhGZkZDT0hVY2lw?=
 =?utf-8?B?YnMrbmp2RGJhNUhRUmxyRDZsZzE1MXZuWDBGMXR5MVR1RnZOYkw4L2wzUzF0?=
 =?utf-8?B?dXRjR3hZN25DUUpuSXBXbW1oUXdtWXN2V1kwMUZ3ajIwYmFsSktrTHBmU0hQ?=
 =?utf-8?B?cE5VV1FlQzJidjBESjB6d2V4dXpPTHpLb29Db3BwdURoZndFeDZLZkpiVktl?=
 =?utf-8?B?RURDc2xydWtTUVhldE5FSHBZeXRWeHhmWTlKSjUzT3dWV2NieStpNitVWWF2?=
 =?utf-8?B?MkZuaVBCVXU1T1N1MGdSZDhkaEhVeVBhaXJRUWRMQVdlU2ljdGRwdnppUWtz?=
 =?utf-8?Q?UCZ78Igq0Djc0pWgRnAaCbT7Y=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7513a8-be5e-4a80-826a-08da7f94ba3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 14:36:38.2580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8sK7dDV4//dqLWOeFKSQZTu8IhgcXzUKz2tZdiLAcp7GILYQUHM21tO+aFPVuvTWb7okz5T056j6tw9YVsebEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4615
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiA4LzE0LzIyIDE0OjA3LCBEb3VnbGFzIEdpbGJlcnQgd3JvdGU6DQo+ID4gSG93IGFib3V0
IGxzc2NzaSA/DQo+ID4gIyBsc3Njc2kNCj4gPiBbMDowOjA6MF3CoMKgwqAgZGlzayAgICBMaW51
eCAgICBzY3NpX2RlYnVnICAgICAgIDAxOTEgIC9kZXYvc2RhDQo+ID4gWzE6MDowOjBdwqDCoMKg
IGRpc2sgICAgTGludXggICAgc2NzaV9kZWJ1ZyAgICAgICAwMTkxICAvZGV2L3NkYg0KPiA+IFsy
OjA6MDowXcKgwqDCoCBkaXNrICAgIExpbnV4ICAgIHNjc2lfZGVidWcgICAgICAgMDE5MSAgL2Rl
di9zZGMNCj4gPiBbTjowOjE6MV3CoMKgwqAgZGlzayAgICBTS0h5bml4X0hGUzUxMkdERTlYMDgx
Tl9fMQ0KPiA+IC9kZXYvbnZtZTBuMQ0KPiA+DQo+ID4gSSBwbGFuIHRvIGFkZCBKU09OIG91dHB1
dCB0byBsc3Njc2kgaW4gdGhlIG5lYXIgZnV0dXJlLg0KPiANCj4gSGkgRG91ZywNCj4gDQo+IEl0
IHdhcyBub3QgY2xlYXIgdG8gbWUgd2hldGhlciBvciBub3QgQXZyaSBuZWVkcyB0byByZXRyaWV2
ZSB0aGUgdmVyc2lvbg0KPiBpbmZvcm1hdGlvbiBvbiBhbiBBbmRyb2lkIHN5c3RlbS4gTmVpdGhl
ciAvcHJvYy9zY3NpIG5vciBsc3Njc2kgYXJlIGF2YWlsYWJsZQ0KPiBvbiByZWNlbnQgQW5kcm9p
ZCBzeXN0ZW1zLiBJIHdpbGwgc2VlIHdoZXRoZXIgSSBjYW4gaW5jbHVkZSB0aGUgc2czX3V0aWxz
DQo+IHBhY2thZ2UgaW4gQW5kcm9pZC4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQpFaXRo
ZXIgd2F5IEJhcnQsIHRoZSBzb2x1dGlvbiB5b3UgcHJvcG9zZWQgd29ya3MgZm9yIHVzLA0KQXMg
d2VsbCBhcyBvdGhlciB3YXlzIHRvIG9idGFpbiB0aGF0IGluZm8uDQoNClRoYW5rcywNCkF2cmkg
DQo=
