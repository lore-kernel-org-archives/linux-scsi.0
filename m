Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD459C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 03:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiD1Drq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 23:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiD1Drn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 23:47:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AABF9968B
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 20:44:30 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23S37W5p019162;
        Wed, 27 Apr 2022 20:44:28 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fqhpn0ydg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 20:44:28 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23S3iSFo029116;
        Wed, 27 Apr 2022 20:44:28 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fqhpn0ydd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 20:44:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zgde79lzee159AUTaHV9U+X34Sc+23KFv7Z7Mg49C/vrLzqYVdp/zMvyWvicTsQctXKDu6qPsbMw73TEWlyRMGoh79HBzwVRVe8yD5oPfSr/gFe+B9AMaNUcmRe1XW9MO9usypeFvOPVm4IcDyFDw996uSIBhgpHykiuHwy/PHEeL5/jurw9NspX884RsPrfolVb4BfQ5vIksM/qdoYMULRDg6dO0arB8wANtfDpvNuZ+MTGs6wVo0i78teAKBFzz/48zFhBlEV3v1sF3zvOUZXkrcLLHjIfjovqDSnVLys/zvXmyp68YCWK0F4R3vn7V+S1FBzhge+7G4poxOb6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xy1CbKhNZOPOPB1ae/Cb1Ejt46weuP7Fy73y3GrsJVs=;
 b=f0/s8ES/iIbQSbq3ZuLTWJ7kQAbMeajVzeMAo5hOM9UyEpPzGAUrlouYrQ5Sr+aE6LzuZljDGImjsxA9slniKr0OvP26Kqc+YWBK2jp3cy8P0x3eGk/mNDiZauPsKAhiyelCyfo49OAHxBNEFcW2BW7OEmJMSluqDJ5KOjMbcEUerbne1eKUXJk5Pla3OOF+fPxq1WKqBi6J21L4ydCSZuTMMYXVO/fdlfLvSM88YmzmxXdqLTpt1WNG8SBsNgChmwt5N+7HIPKcJnyaUO1+FbBG/EW1B2ZwDUUe3hjBzHv0AaR8yrNJL6Q16LJ4PZf/m9IB6Bhi4PiQ6YGt6qDHaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xy1CbKhNZOPOPB1ae/Cb1Ejt46weuP7Fy73y3GrsJVs=;
 b=aytLAOW4lgHffITxsAUX8MNNhrAi+1bORzViMYmQnaJI+mY+LT4u7fiJw7WYwIOO5gHWCcrmzoMMAfV7ZszdIFyW3uHNCOHQWSf4qX1zMyU5Rv6hZEceEFYobxSLbW7ngu76fr9i+xM6itD5JhUuoVO0Yt/P7mTKzNSdnt79M/Y=
Received: from PH0PR18MB4654.namprd18.prod.outlook.com (2603:10b6:510:c5::18)
 by CY4PR18MB0984.namprd18.prod.outlook.com (2603:10b6:903:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Thu, 28 Apr
 2022 03:44:24 +0000
Received: from PH0PR18MB4654.namprd18.prod.outlook.com
 ([fe80::cc05:8152:caf8:3b3]) by PH0PR18MB4654.namprd18.prod.outlook.com
 ([fe80::cc05:8152:caf8:3b3%5]) with mapi id 15.20.5164.020; Thu, 28 Apr 2022
 03:44:24 +0000
From:   Anil Gurumurthy <agurumurthy@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>
Subject: RE: [EXT] Re: [RFC] scsi_transport_fc: Add an additional flag to
 fc_host_fpin_rcv()
Thread-Topic: [EXT] Re: [RFC] scsi_transport_fc: Add an additional flag to
 fc_host_fpin_rcv()
Thread-Index: AQHYT8sSd06N8kqwtUqAdXNJWkpBDqzxLSoAgAAEaWCAE4zAcA==
Date:   Thu, 28 Apr 2022 03:44:24 +0000
Message-ID: <PH0PR18MB465429EF9237D67E30F38306A3FD9@PH0PR18MB4654.namprd18.prod.outlook.com>
References: <20220414064358.21384-1-njavali@marvell.com>
 <9bd6ce27-d984-efc4-c907-babca6897300@gmail.com>
 <CO6PR18MB4500B4DCD9652CF8533EEF41AFEE9@CO6PR18MB4500.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB4500B4DCD9652CF8533EEF41AFEE9@CO6PR18MB4500.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35033dc0-39ca-4506-630b-08da28c9634d
x-ms-traffictypediagnostic: CY4PR18MB0984:EE_
x-microsoft-antispam-prvs: <CY4PR18MB098403AF3566121BA0D67356A3FD9@CY4PR18MB0984.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1WnMzUH/P9hfL+ftqwgWdxczwlD1Yy0KHy/ol6qzpEd37GtLIDD6n+FQEH26CksrSje8IS3TpexrLDb7Sx8bTCp6Gjyy5DIzaBiTqRjP6JKXdcEkS7G0pDDRflo39v1IKb2pTCN23MrVj7U4w31ISr5JHH6qdNMZ+I66/2xp5wexsB6avqL2YbqLPh8X72BlXujkt9ESsYbvJDjlpr5z+tZW7uQh9KVSlqJs5Y6hVWC+clQveTAVTbY9IbTQTO8K6uYXK+B22tm3duE1ZmcEZVhJa28gdYRC5I0KOsPvXbha452Mj0fEO/i+8ZuatLcigK6c3aJjx1G+Z5dywjwh47eHaL2YFQNaZ7Lr9tvgkk4KVLp2pZq0qLU9UyLafJP/7hmDDFhLIYIQhXKaYRFJfED2K8tmKXvVCGVuDbmmv4e8BkgVgCm6nAwupu3o5XALcqIQXpQ5wDfomEPNVCtYq5Toz1IPHaf4j3phPLoJ4q3YftuQl4eGZ0l0f0uhq0fRB1Enepo0kDj4O6FtM4vnrY3eG4D95MZpr59dEmCfj6e5Z2+bE/4SEqETICdehf3+yil1Hy1fPtc+V5nnpc9Pl1jxC1jVqJTMuEOtoWzacZkDhC1je9Ga1AOUrXJE2KUTSMo9qG6jIysTujBAn5kzmSNYDt8S7Oto6OKoDaeQY0GMVDSAI6EafJ4umCh4a0+PKbiC6nwCT6soyEhccwDmuQIUsy7Mh7xLnUEXQULWAQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4654.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(7696005)(4326008)(110136005)(76116006)(54906003)(9686003)(66476007)(2906002)(33656002)(122000001)(38100700002)(55016003)(38070700005)(86362001)(6506007)(316002)(66556008)(8676002)(64756008)(53546011)(66946007)(26005)(186003)(83380400001)(508600001)(5660300002)(66446008)(8936002)(52536014)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFlKdzVmYzgxK0phaENseThHSlVaczJyM2xjeFdFaDg4QUFUOG1JRXAyczQ1?=
 =?utf-8?B?WTJ5ZDBvU0h0Z3RPN2M0cVVrQmpLczBRRmtUUzdJRStOa1hYNGE2VU9EcC9q?=
 =?utf-8?B?ZUtPYjNUS0pMdUJwVkR5eGNDamwzVTVJRmJvKzRCTkJaN3NqaFlKSVFjQ1Y2?=
 =?utf-8?B?Mnd4L2tUeWIzczV1M2xLNk5hY3F1OG5wS1EzMWlFNTJLVjFIOEg4eURlWlln?=
 =?utf-8?B?Qm15TkR0NGthaExUVEpzNHc1N3ZpcDdmMndka20xRWVQOUhXWlE4VHpNVnJN?=
 =?utf-8?B?dEc0VGJQUitFcTRVczdGbHM4RE5XQ1NkdEdCVTV1YzhQQ2k3ZmRKTUlYcUI4?=
 =?utf-8?B?VUlTbFE4Z1BYc1NCbkpDS2FrdVV1NGVyQm1ZUS9vWXBBNGdDNTFxN3VCYVh6?=
 =?utf-8?B?elN1UEEwOHlqNXYwVENTOVRRNWNDa1F3VFlVcDYyOFc5Uk42RlF5OW4vbHNR?=
 =?utf-8?B?TmkvVEVnTmRqNFc5U0pCVmRFNk1SbmZoNnpWWXZUdXZ4WmNscHl1MlpwTEJo?=
 =?utf-8?B?Y1kvL0o0MTJhd3d1OFFJNVR5alZmcnVNK0FwcGdDRVpyQkRuTTVkUERPSFdR?=
 =?utf-8?B?YVQvaVI0SFFIWElOTVhXVHNyTU1JNTV0YzNHaWJsSm00TnE2WHNVM3N2cDY5?=
 =?utf-8?B?NElEbVllSHM2YVNWOVlrckNYeFFSV25VR2NydENOMXhIeFFtcDNuQ0dUY0V3?=
 =?utf-8?B?WmU3OExVMjBvYkVaNklvaS9NZklMSlNTUXZPVThpL2wrSmdQd203VjBoSW8z?=
 =?utf-8?B?VE9DYWRKbVdTRUZvREtGMTZURmlUVTRJWWE5bmlXc0hQM3RCL0tUYzJKVkEz?=
 =?utf-8?B?QVZmOVozdzVSdnhqWnN5Q0NvcTNJVURNbXhWdHNyTmpSZ0NEYjFBNW1PeTJE?=
 =?utf-8?B?THBkVzJaYldsQWhubmNQYWRmMEZrdnkwa3kwMzVHVEo0QTQyWW15VWhHSFNs?=
 =?utf-8?B?T1RJWGU0eHRrcFNFajlZakU0ZU1IbUEvRVd5SWZpNnhvOHRLQlNLb2NObkEz?=
 =?utf-8?B?V21LUFFUc3RXTWM0QW9NdFBYeVM3SlFERFd6STRmaVh4bGtmUG5sdmlJZnhX?=
 =?utf-8?B?NnluMFFpeXpWQlRMVURyTHhNOFFkSU1VUU03Z1k3aVdPN1I1aW84bmtMNzZW?=
 =?utf-8?B?QldCYUtCclVDWVJndTVnaEVyVE12bEF2R2ZDYTR3MUdZQ1RpOForSWRyRkJC?=
 =?utf-8?B?L250ME9BNWVqYm45VVNhTE95UUcyWU8vM0tJRUpINFZjQitoVk5UWHZ3d0Zk?=
 =?utf-8?B?MytMQnhDeFJwNjY1VlNoNDYwT1pROGpERlBmWEhEVjNRTDN2RkVqUStrVFNU?=
 =?utf-8?B?Z3hrZTFKZHU1cExxY1dXZGdGMVBDdE9yRmhES3l6UmtHcEVncXlibE5FYWp4?=
 =?utf-8?B?TjUxWTVlNG9XeWRJL2piMjQrV1U0MFd1d1VYY21HVmZuTzNvUDJzemxvZjVp?=
 =?utf-8?B?Z0NzRUQzOG96aStZZEkybEsrdFh5cnJxWkVGdEJmeGlUdHVXSndpSzV2Ykl0?=
 =?utf-8?B?dm44dEd3WkdpeFl0dmVkVVhscDJWczFvdDlrTHFpZEhET1ZPZDRHdkhmYXUy?=
 =?utf-8?B?dzZoZnpBZXU1emhQRm9xYUVVaWlXWENINGNkL1hwc0p1OFhMZG5kdXlSUlJJ?=
 =?utf-8?B?ZzdHMDJ2cEFnRk5HNG9UVklNWWkyam0wQWFrejgyTFJlejBVa3A3L3k1Szlq?=
 =?utf-8?B?bHBLMDFzZ0czb2VHdzI0cnV4UXkwV1krenhxSi9FNzhzbXdIRmc0cFk1dUQ5?=
 =?utf-8?B?MDRFSUFqWFY5QWVrdE5MQ2NmOGwzVlVDc2wvVVZiZTdKVlFKakJsbEdtbmZN?=
 =?utf-8?B?SEZGcmI4ZGsrUGF5dXNyRE5pOXlYUU1KSkdLMkVqd3FFeWZIVGUzRmQ0SGp0?=
 =?utf-8?B?VWozMldwbEFPd21SZVhGdXY2TDNuTjBZUWs3UVpUbVhFVnYvRXVidzVZZFdF?=
 =?utf-8?B?SXQ1NWNlV0FOQ0lOK2pUQ2xHcmY3OVNpODRzblNzdVlQOEFUWlBudVB6Smlt?=
 =?utf-8?B?Z1lsNnROQ2NMeG02ZW1vbG1ZWE93ckRBR0ZWOHhQRFRDQlZsMWx0NFpXOFpM?=
 =?utf-8?B?ZTVxaktEckJ3eHI0TklxYkN2RVVxSklYYmlWRFhnT2ErZ1c2Z2trczJTOVlz?=
 =?utf-8?B?ZFZTeUhqekhoWnErSGR2em43ZVRQdlZ2TS82NkJ5OVRJQU9vR3NHRjJrWWQz?=
 =?utf-8?B?eVNNZEhUcXV5VGJsckFGamtZN0kxMmlPMkp5aUw4REh0M0xxbFJ0eWFyK1J2?=
 =?utf-8?B?NU1XNkVveE5jWUltTFlqM2hSbDQzZXpwaFd0RHJRR0lNUlQzNGtGaVpValkw?=
 =?utf-8?B?RUZGSys1dSttMUFlakc1RmRYMlFXc2dMSUhQWFIvMW1NU1crNWNMZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4654.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35033dc0-39ca-4506-630b-08da28c9634d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 03:44:24.5431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZhTEPYe7d78RCJ5hIUDIa9CqcsD870WyUf0FUhgNR20dHy/1KBWuzCNyENSfLp9sFHa7T+qF8/k4a91Yv+aO6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB0984
X-Proofpoint-GUID: hycp1cVOrDgiI7ELWiyJytJ_XlTsSU0S
X-Proofpoint-ORIG-GUID: i3D3MzP2PPLq5vyZmU1Tcuo3Chhj2mgB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSmFtZXMgU21hcnQgPGpzbWFydDIw
MjFAZ21haWwuY29tPg0KU2VudDogRnJpZGF5LCBBcHJpbCAxNSwgMjAyMiAxMDowMiBQTQ0KVG86
IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+OyBtYXJ0aW4ucGV0ZXJzZW5Ab3Jh
Y2xlLmNvbQ0KQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFn
ZS1VcHN0cmVhbSA8R1ItUUxvZ2ljLVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20+OyBNdW5l
ZW5kcmEgS3VtYXIgTSA8bXVuZWVuZHJhLmt1bWFyQGJyb2FkY29tLmNvbT47IEphbWVzIFNtYXJ0
IDxqc21hcnQyMDIxQGdtYWlsLmNvbT4NClN1YmplY3Q6IFtFWFRdIFJlOiBbUkZDXSBzY3NpX3Ry
YW5zcG9ydF9mYzogQWRkIGFuIGFkZGl0aW9uYWwgZmxhZyB0byBmY19ob3N0X2ZwaW5fcmN2KCkN
Cg0KRXh0ZXJuYWwgRW1haWwNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KT24gNC8xMy8yMDIyIDExOjQzIFBN
LCBOaWxlc2ggSmF2YWxpIHdyb3RlOg0KPiBGcm9tOiBBbmlsIEd1cnVtdXJ0aHkgPGFndXJ1bXVy
dGh5QG1hcnZlbGwuY29tPg0KPiANCj4gVGhlIExMREQgYW5kIHRoZSBzdGFjayBjdXJyZW50bHkg
cHJvY2VzcyBGUElOcyByZWNlaXZlZCBmcm9tIHRoZSANCj4gZmFicmljLCBidXQgdGhlIHN0YWNr
IGlzIG5vdCBhd2FyZSBvZiBhbnkgYWN0aW9uIHRha2VuIGJ5IHRoZSBkcml2ZXIgDQo+IHRvIGFs
bGV2aWF0ZSBjb25nZXN0aW9uLiBUaGUgY3VycmVudCBpbnRlcmZhY2UgYmV0d2VlbiB0aGUgZHJp
dmVyIGFuZCANCj4gdGhlIFNDU0kgc3RhY2sgaXMgbGltaXRlZCB0byBwYXNzaW5nIHRoZSBub3Rp
ZmljYXRpb24gbWFpbmx5IGZvciBzdGF0aXN0aWNzIGFuZCBoZXVyaXN0aWNzLg0KPiANCj4gVGhl
IHJlYWN0aW9uIHRvIGFuIEZQSU4gY291bGQgYmUgaGFuZGxlZCBlaXRoZXIgYnkgdGhlIGRyaXZl
ciBvciBieSANCj4gdGhlIHN0YWNrIChtYXJnaW5hbCBwYXRoIGFuZCBmYWlsb3ZlcikuIFRoaXMg
cGF0Y2ggZW5oYW5jZXMgdGhlIA0KPiBpbnRlcmZhY2UgdG8gaW5kaWNhdGUgaWYgYWN0aW9uIG9u
IGFuIEZQSU4gaGFzIGFscmVhZHkgYmVlbiB0YWtlbiBieSB0aGUgTExERHMgb3Igbm90Lg0KPiBB
ZGQgYW4gYWRkaXRpb25hbCBmbGFnIHRvIGZjX2hvc3RfZnBpbl9yY3YoKSB0byBpbmRpY2F0ZSBp
ZiB0aGUgRlBJTiANCj4gaGFzIGJlZW4gcHJvY2Vzc2VkIGJ5IHRoZSBkcml2ZXIuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBBbmlsIEd1cnVtdXJ0aHkgPGFndXJ1bXVydGh5QG1hcnZlbGwuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiAt
LS0NCj4gICBkcml2ZXJzL3Njc2kvbHBmYy9scGZjX2Vscy5jICAgICB8IDIgKy0NCj4gICBkcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMgICB8IDIgKy0NCj4gICBkcml2ZXJzL3Njc2kvc2Nz
aV90cmFuc3BvcnRfZmMuYyB8IDYgKysrKystDQo+ICAgaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNw
b3J0X2ZjLmggfCAyICstDQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2xwZmMvbHBmY19l
bHMuYyANCj4gYi9kcml2ZXJzL3Njc2kvbHBmYy9scGZjX2Vscy5jIGluZGV4IGVmNmU4Y2Q4YzI2
YS4uZmQ5MzFiMTc4MWUzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvbHBmYy9scGZjX2Vs
cy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9scGZjL2xwZmNfZWxzLmMNCj4gQEAgLTEwMTAyLDcg
KzEwMTAyLDcgQEAgbHBmY19lbHNfcmN2X2ZwaW4oc3RydWN0IGxwZmNfdnBvcnQgKnZwb3J0LCB2
b2lkICpwLCB1MzIgZnBpbl9sZW5ndGgpDQo+ICAgCQkvKiBTZW5kIGV2ZXJ5IGRlc2NyaXB0b3Ig
aW5kaXZpZHVhbGx5IHRvIHRoZSB1cHBlciBsYXllciAqLw0KPiAgIAkJaWYgKGRlbGl2ZXIpDQo+
ICAgCQkJZmNfaG9zdF9mcGluX3JjdihscGZjX3Nob3N0X2Zyb21fdnBvcnQodnBvcnQpLA0KPiAt
CQkJCQkgZnBpbl9sZW5ndGgsIChjaGFyICopZnBpbik7DQo+ICsJCQkJCSBmcGluX2xlbmd0aCwg
KGNoYXIgKilmcGluLCBmYWxzZSk7DQo+ICAgCQlkZXNjX2NudCsrOw0KPiAgIAl9DQo+ICAgfQ0K
DQoNCg0KVGhpcyBpcyBmaW5lLiAgVGhhbmsgeW91Lg0KDQoNCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYyANCj4gYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
aXNyLmMgaW5kZXggMjFiMzFkNjM1OWM4Li5lMDFkOWE2NzE3NDkgDQo+IDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX2lzci5jDQo+IEBAIC00NSw3ICs0NSw3IEBAIHFsYTI3eHhfcHJvY2Vzc19wdXJl
eF9mcGluKHN0cnVjdCBzY3NpX3FsYV9ob3N0ICp2aGEsIHN0cnVjdCBwdXJleF9pdGVtICppdGVt
KQ0KPiAgIAlxbF9kdW1wX2J1ZmZlcihxbF9kYmdfaW5pdCArIHFsX2RiZ192ZXJib3NlLCB2aGEs
IDB4NTA4ZiwNCj4gICAJCSAgICAgICBwa3QsIHBrdF9zaXplKTsNCj4gICANCj4gLQlmY19ob3N0
X2ZwaW5fcmN2KHZoYS0+aG9zdCwgcGt0X3NpemUsIChjaGFyICopcGt0KTsNCj4gKwlmY19ob3N0
X2ZwaW5fcmN2KHZoYS0+aG9zdCwgcGt0X3NpemUsIChjaGFyICopcGt0LCBmYWxzZSk7DQo+ICAg
fQ0KPiAgIA0KPiAgIGNvbnN0IGNoYXIgKmNvbnN0IHBvcnRfc3RhdGVfc3RyW10gPSB7IGRpZmYg
LS1naXQgDQo+IGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmMgYi9kcml2ZXJzL3Nj
c2kvc2NzaV90cmFuc3BvcnRfZmMuYw0KPiBpbmRleCBhMjUyNDEwNjIwNmQuLjZkZTQ3NmYxMzUx
MiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmMNCj4gKysr
IGIvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmMNCj4gQEAgLTg5MiwxMiArODkyLDEz
IEBAIGZjX2ZwaW5fY29uZ25fc3RhdHNfdXBkYXRlKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LA0K
PiAgICAqIEBzaG9zdDoJCWhvc3QgdGhlIEZQSU4gd2FzIHJlY2VpdmVkIG9uDQo+ICAgICogQGZw
aW5fbGVuOgkJbGVuZ3RoIG9mIEZQSU4gcGF5bG9hZCwgaW4gYnl0ZXMNCj4gICAgKiBAZnBpbl9i
dWY6CQlwb2ludGVyIHRvIEZQSU4gcGF5bG9hZA0KPiArICogQGhiYV9wcm9jZXNzOgl0cnVlIGlm
IExMREQgaGFzIGFjdGVkIG9uIHRoZSBGUElODQo+ICAgICoNCj4gICAgKiBOb3RlczoNCj4gICAg
KglUaGlzIHJvdXRpbmUgYXNzdW1lcyBubyBsb2NrcyBhcmUgaGVsZCBvbiBlbnRyeS4NCj4gICAg
Ki8NCj4gICB2b2lkDQo+IC1mY19ob3N0X2ZwaW5fcmN2KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0
LCB1MzIgZnBpbl9sZW4sIGNoYXIgDQo+ICpmcGluX2J1ZikNCj4gK2ZjX2hvc3RfZnBpbl9yY3Yo
c3RydWN0IFNjc2lfSG9zdCAqc2hvc3QsIHUzMiBmcGluX2xlbiwgY2hhciANCj4gKypmcGluX2J1
ZiwgYm9vbCBoYmFfcHJvY2VzcykNCj4gICB7DQo+ICAgCXN0cnVjdCBmY19lbHNfZnBpbiAqZnBp
biA9IChzdHJ1Y3QgZmNfZWxzX2ZwaW4gKilmcGluX2J1ZjsNCj4gICAJc3RydWN0IGZjX3Rsdl9k
ZXNjICp0bHY7DQo+IEBAIC05MjUsNiArOTI2LDkgQEAgZmNfaG9zdF9mcGluX3JjdihzdHJ1Y3Qg
U2NzaV9Ib3N0ICpzaG9zdCwgdTMyIGZwaW5fbGVuLCBjaGFyICpmcGluX2J1ZikNCj4gICAJCWNh
c2UgRUxTX0RUQUdfQ09OR0VTVElPTjoNCj4gICAJCQlmY19mcGluX2NvbmduX3N0YXRzX3VwZGF0
ZShzaG9zdCwgdGx2KTsNCj4gICAJCX0NCj4gKwkJLyogSWYgdGhlIGV2ZW50IGhhcyBub3QgYmVl
biBwcm9jZXNzZWQsIG1hcmsgcGF0aCBhcyBtYXJnaW5hbCAqLw0KPiArCQlpZiAoIWhiYV9wcm9j
ZXNzKQ0KPiArCQkJZmNfaG9zdF9wb3J0X3N0YXRlKHNob3N0KSA9IEZDX1BPUlRTVEFURV9NQVJH
SU5BTDsNCg0KPlRoaXMgZG9lc24ndCBzZWVtIHJpZ2h0LiAgSSB3b3VsZCB0aGluayB0aGUgbWVh
bmluZyBvZiAicHJvY2Vzc2luZyIgDQo+dmFyaWVzIGJ5IEZQSU4gdHlwZSwgdGh1cyB0aGUgZmxh
ZyBzaG91bGQgYmUgcGFzc2VkIHRvIHRoZSBkaWZmZXJlbnQgeHh4X3VwZGF0ZSByb3V0aW5lcyBh
bmQgYW55IGRlY2lzaW9uIHdvdWxkIGJlIG1hZGUgdGhlcmUgLSBvciBhdCBsZWFzdCB0aGUgZGVj
aXNpb24gaXMgbWFkZSB3aXRoaW4gdGhlIHR5cGUgY2FzZSBzdGF0ZW1lbnQgYWJvdmUuIEZvciBl
eGFtcGxlOiANCj5GQ19QT1JUX1NUQVRFX01BUkdJTkFMIHNob3VsZCBvbmx5IGJlIHNldCB3aXRo
IExpbmsgSW50ZWdyaXR5IGV2ZW50cy4NCg0KVGhlIHRob3VnaHQgcHJvY2VzcyBoZXJlIHdhcyB0
aGF0IHRoZSBkcml2ZXIgc2V0cyB0aGUgdmFsdWVzIGFjY29yZGluZyB0byB3YXkgaXQgaGFzIHBy
b2Nlc3NlZC4gU28gaWYgdGhlIGRyaXZlciBkb2VzIG5vdCBwcm9jZXNzIExpbmsgSW50ZWdyaXR5
IEZQSU4sIHRoZSBzYW1lIGNhbiBiZSBzZXQgYWNjb3JkaW5nbHkuDQoNCj5Ib3dldmVyLCB3ZSBj
dXJyZW50bHkgbGVhdmUgdGhlIGRlY2lzaW9uIG9mIG1hcmdpbmFsaXR5IHRvIGJlIGRldGVybWlu
ZWQgYW5kIG1hbmFnZWQgYnkgdGhlIGV4dGVybmFsIGRhZW1vbiB0aGF0IHByb2Nlc3NlcyB0aGUg
ZnBpbiBldmVudHMuIFNvIHRoZSBwYXRjaCBuZWVkcyB0byBleHBhbmQgdGhlIGZwaW4gZXZlbnQg
dG8gaW5jbHVkZSB0aGUgZHJpdmVyIHByb2Nlc3NlZCBmbGFnIGluIHRoZSBldmVudCBkYXRhLiBQ
bGVhc2UgYWRkIHRoaXMgdG8gPmZjX2hvc3RfcG9zdF9mY19ldmVudCgpLg0KPkdpdmVuIHdlIGxl
YXZlIG1hcmdpbmFsaXR5IHRvIHRoZSBkYWVtb24sIHdobyB3aWxsIG5vdyBrbm93IHdoZXRoZXIg
dGhlIGRyaXZlciBoYW5kbGVkIHRoZSBmcGluIG9yIG5vdCwgSSBkb24ndCB0aGluayBmcGluX3Jj
diBzaG91bGQgaW5jbHVkZSB0aGUgY2hhbmdpbmcgb2YgcG9ydHN0YXRlIHRvIG1hcmdpbmFsLg0K
DQpTdXJlLCB3ZSBjb3VsZCBkbyB0aGF0LCBidXQgSSB0aG91Z2h0IHRoZSBkYWVtb24gd2FzIG5v
dCBhIHBlcm1hbmVudCBzb2x1dGlvbiBhbmQgZXZlbnR1YWxseSB0aGUgZGVjaXNpb24gb24gbWFy
Z2luYWxpdHkgd291bGQgYmUgdGFrZW4gd2l0aGluIHRoZSBrZXJuZWwuDQoNCj4tLSBqYW1lcw0K
DQoNCg==
