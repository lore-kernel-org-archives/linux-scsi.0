Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1352DC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 12:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7CDE6186A
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Feb 2021 12:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBUMHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Feb 2021 07:07:39 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55350 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhBUMHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Feb 2021 07:07:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613909257; x=1645445257;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=48xxBvaVXqMR8eDYAiH+dLYBfv6mFa7VEUCsDP8na0Q=;
  b=dXuygPVd+JliWSQVwxya6c0teYV2wEc97b9mr3Z2ezCQy6nIoP1CIqbH
   QAfR74EclCKSkmDufL0YJ62mZPtsksBPhnHCW3dbn21NTE23K1svCftxk
   VmiokZolrtLsdUHMDZo9+rYhZHFUIboIWDC/PaKmod8OpX0mo6KafoRKu
   KXA/9/z9KIiTu46k3t1fSiT0g5YNYxWU9Y9gukXTTznH/WIiRgSaXEQ9Z
   BABVMS/sBuyiRGqDx7Xm7xb6HFDj8tbqUY3ONotL+1PGgcu9XI+JboMy7
   bICh8TJjJsX8FNRzEve3ImtabF88/LUJxA5zdrWqMXeFcSlsb+Ci6YJ38
   A==;
IronPort-SDR: SM3lUN33+EAn1GebpVPgbtULFb7samANOvsCGZ30vJn9n2IhnipINO3gAaDLwZxWXklSGinnr9
 RWWzv1zXYz02GSTlxj0lhb0VgpISzKK0qGIug1TCVk03iz4mHSeei6jFew/JNdo4Ha2uZ2tU+A
 PljTHpejw7gWRnEgAjOL2ggla6BO3g63PxNkDMtLP7+RvkBumBtEcKpMpYdfIkGjfRB5ia5XmJ
 xcpi/oWT9SUwIfQeoZiBHMcx9jxtRSQz7kOytZUxxqVe+Tao7KKkLtv+YzoLRS1XgJv4ogLU1R
 7tY=
X-IronPort-AV: E=Sophos;i="5.81,194,1610380800"; 
   d="scan'208";a="270976350"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 20:06:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/BGKiXPG9SRe7uMTTigSVMCuuu7X/9+bcx3yC3KyxStKAaGqW320nZvw5s+eg3ycb1681swLA2Qj+n8D77umS9NaqATQnswPDGbZnPlNXLxf4UaW0lYrr/nWWXnXd7aLv243gJKvu1sDfZhmRHPsjWFqzQIBaDdZE1iaLVfM2yI2S/Po8VDhC+cBU0jGxb6fDItyNYAgfX/PSQ1jMhy9iQl2dbpkRoUJ+9H0AUeH+CakXJ/GqgCDSh7HDEa8Pyxs00s9R6sMoIQJJg5oL4KmBz9VyUhceoUmZkN0g78K22ZgvcqLsAcU7CL3OptMvu1RVpGy+RZ9rM1d6nYp4ccoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48xxBvaVXqMR8eDYAiH+dLYBfv6mFa7VEUCsDP8na0Q=;
 b=OzX/rA0wR8YpKoFGm0HjacWg/08kSsFrbkGA0xzHN33zmYY9CHJuGhTg2dOGvpu+bYz1Zn1OnjfTxKkdT3mlaAm7HSIWpjJSE3RLyw42easJRnPBsJNfGJcHPDtpTlp79XuOyMRBmn7aoZ/PO72ZpHq4vTj8elo2HbkjTDGBONvwbpHQzWvPlRqGAmcPrc/wamB3nOtrPoToL22HOKW2kMVgFksp4R0zHY16iIZGjSb1zhYkej4q09x9ImF+KtkCZHI2/UvX1tcZiPJXEOorjvSbeSCvKOQL2Kaq6h5vOEH/AlY8l9fpabSJ66XJp2XQ4Yn0HXpVq4aW03dDWVRZ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48xxBvaVXqMR8eDYAiH+dLYBfv6mFa7VEUCsDP8na0Q=;
 b=hMBFaaBHaIXQ0N0e6OVTonzzVON8B1hWVCeUl9MfyAWPrvICC7R4/gthIBDDKi06a8layMU850OdU8cijHduB7IB35B1nwdiZW5Z9SiMJRm+BUkbR+y3IOhPXPBGSvJXV1ToNdyn1BmdQMQ2L9+M7Oq9QbSMG7BsvMlgHVH3NQ4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4553.namprd04.prod.outlook.com (2603:10b6:5:21::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.26; Sun, 21 Feb 2021 12:06:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.032; Sun, 21 Feb 2021
 12:06:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v21 2/4] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v21 2/4] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHXBdWOT8koNgvd7EKOQ+mE7NwdR6pih9Bg
Date:   Sun, 21 Feb 2021 12:06:28 +0000
Message-ID: <DM6PR04MB6575DFFA248FC9B5FD5BFBA4FC829@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p8>
 <20210218090747epcms2p8812c04126d57b789f471126055577ae8@epcms2p8>
In-Reply-To: <20210218090747epcms2p8812c04126d57b789f471126055577ae8@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d72758df-6bc9-4a49-fc26-08d8d6611e97
x-ms-traffictypediagnostic: DM6PR04MB4553:
x-microsoft-antispam-prvs: <DM6PR04MB4553FD9BD6174000F64721D9FC829@DM6PR04MB4553.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GzyFrvOr9uou/aXaXtt3TYbclpW0eHK/sa6Shh9W4/NbJNHvpYbfkYT0qDD/BF+ENcDHx80cLp/Z9lCZI0VvvuvV01fo3iGY/bewL+Cze6eAyVF3d6/U+Io33s+fkoI6O4wERzRw4yMJuPgUgchESLN6tEPpdHPdz/CZqHph96hP+NxSl9rPhXv0Ie6AmcoS4f2zXLOyqpAdAh1c/2sfHMwrx0OCVaj7i00PUkxp4wZoY9fdpu7nACMaGUuSjoJ54TDsLA0459DL30ExuCDx63WQ3VxHM+bGJ7/MmU92wCTGoBAdVKAwCK6duDEMOWK3Xtqii670cfgMA+aLDVRAt21+PFJLvucwYSNOuLUjgxWV4Hgq3SdYGNQnaI6YeyCX8agQ/CspHbTSxRd2OBIMoZ9hPuER/YN0cEmHcgXn9CX01hbV/ymzy+11+mNG/oMEe5CbsgYFIFshnHDblAMw43Ccq+jQCh9iyM8i6b1GDIlNcqdNQ0g/E/Nnymjx/QpU7cjDWaENBPfKds+GVtNun9tv4OqYx/rKsTGnXhqxkXEOGpIjok+yXwj6wbBOnCSw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(39850400004)(396003)(136003)(110136005)(316002)(6506007)(8936002)(71200400001)(2906002)(55016002)(7696005)(83380400001)(9686003)(4326008)(52536014)(66446008)(66476007)(5660300002)(66556008)(64756008)(186003)(33656002)(921005)(26005)(8676002)(66946007)(478600001)(86362001)(7416002)(4744005)(54906003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NGpxTEduMVlKWnBDMlFmVVNTZndmRmNmY2VHYWdnL0cra3ZNbng5QjZXb3RZ?=
 =?utf-8?B?ZDVoVGtsOVVsTUFqUXVsaFQyTGZOOURoRERsY01INTJPMDRuR1JhZnhNbWZR?=
 =?utf-8?B?ZFFJSllSaDRNYkZqbE1JZ3B6VEVERDBSMFJDZ0dCU1lJQ2htWllJWWdRbDIz?=
 =?utf-8?B?MGduSGE2U2gyKzJzVjhYdFBDMnd2OGRJMnEzQkJEMFF5MFhLb2REYmtQWkUv?=
 =?utf-8?B?UHhDbHM4Ulo1ejhZazVmR1dJK0dGeEQ5dEZJRTRVQVhmOSthSTV5eER1TE50?=
 =?utf-8?B?NHllaFhNYXRkMUUvRXhPRmF3aWF5cG03eEFIeTFWbVd1WkpicHZiNXlBN0FF?=
 =?utf-8?B?c0JCQjBoMmxibjJnbDBaOGtQdWJEVmxPcmVNOC8yQzJJMmxNcDZNNytxR3Zy?=
 =?utf-8?B?anhlUFNyQTdkN1FzdEsvUzNPeU1ISkMxL1BlRjBQOFBQYjNNcktndnJzY1NK?=
 =?utf-8?B?NGNycCsreDFhbnBnWSttUVB3YllxbjJ6YkwrTUdaRFNuVzZqVmw0SjF1UFEy?=
 =?utf-8?B?eXpJVUg1SXlJM1E0b3ZIaGY0TWI4VERESmFtWTYrTzNNQjRXcjFqV1hYdTdq?=
 =?utf-8?B?c2N1cXBzRjl4WUE2eFBMWlZ2eDIxb0JLRWR5NldxSG05a0prUFRDOEY1Z09P?=
 =?utf-8?B?eGNyVi9GRGtUcG85WDVxaGVYYWtNVzZsVE9GVTZOS1MvWVNEb0dJWWVDQUs0?=
 =?utf-8?B?VDJ4N2UvaHBWNUpoQ2o3NVV3K2t3L2pCZ2lmZzlNZjZkV2hmbGc5VUw3dWp4?=
 =?utf-8?B?a21LRmVmWTZMOUZmYzZzZDFDamF1dVkvQ3R6dVo3bzhpc0RGTWlJQWxLK1Vw?=
 =?utf-8?B?Ui9aRU1ERC9RaGpiMlhUL2tYdks4S2poZzYzdlpsNE9CZEo3R0pGbVBYRm9T?=
 =?utf-8?B?cElXNkE0YVlZWDJiZi93RDF1U3dIMkZucTFwc3pMbXk0Um1OOENrbDkwUnUw?=
 =?utf-8?B?SjJobFhZUUFHa2Z5bnI0VUpoSzZoT1RHTllpb3cwMXA3Y3FnWVZTazZjM3Z3?=
 =?utf-8?B?bkxTMWxEVVU1SytzN1U2QUhGUDdNTU9ZV082MWNQTVhGRkhGY3FzZU5ZUU9o?=
 =?utf-8?B?Ky93MkcxcnRVcW9EK0NSYWhZTHBLZjlIbzA0WWNEN3hSQUkxNUxpMEUyY0FN?=
 =?utf-8?B?NU1vSkxzVXd5SlFUd2QvOG5aMG1UbFRrY2Q1ME9vbmZaNU5hdkNhN1VTRGRJ?=
 =?utf-8?B?Q2tRTUNKWUN1a1Z4ekJuZWs1bmJiUFZDQncwcS8zUE5CQjFyQXpKN2dpNTNa?=
 =?utf-8?B?OThZdndGK1Eza0xQc2ZKMHhEc29KenhiN1hQU0dDMmJCVExRNFZwN3dpa1NT?=
 =?utf-8?B?UEVYclFObHVQd0YzSlVmUlVBUFBHRFRENHl5b0ZrdlBaeVd6cGhuYU9SUDJa?=
 =?utf-8?B?MGt1OVk5NEpFSWJ6ZWZMaWZNYnlGOFB6UGFtaFdxNEV2TUliRUQ3UW4raEY0?=
 =?utf-8?B?aW9nVFBFbGxxVThCWFc1dWJSMWYvNi9uU1dqamNaaU9PQWtwMG90U25GUWdl?=
 =?utf-8?B?eHRxeDFOMk9QSnE4WlR6UkQxZDArd0w1WHdKd2h0QkdHejVkRGFRUThzVGsw?=
 =?utf-8?B?eW5nQ0pvTlJVR3ZHd1YwTi8rU1piaGI4SzVRVzBuREE1Vk1HVUtWbytVaHEz?=
 =?utf-8?B?QkU0MGxVM1Y3VDFvZ0d4bU9WZ2VZNjRuVmptTlVGc3VJeWJVTkhtNTI0aWNN?=
 =?utf-8?B?b0RVWm1WQXRQWmhKRlB0a25tVXErSjNOSDgveU1YNGhuNDArWkxvZDREU1Yw?=
 =?utf-8?Q?qxduOwaWe42yv0+nt8RK53wGGzjShnVBy1dCSdI?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72758df-6bc9-4a49-fc26-08d8d6611e97
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2021 12:06:28.5268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6yQ/fGSxMZlgYuVpEQIwxRA6O2hpeD9TmZfcWOZMAyfaJNY1NAXiFgVIJA8RDufXNRF7gwz0rcO0eILTpk5y9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4553
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArdm9pZCB1ZnNocGJfcnNwX3VwaXUoc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVmc2hj
ZF9scmIgKmxyYnApDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IHVmc2hwYl9sdSAqaHBiID0gdWZz
aHBiX2dldF9ocGJfZGF0YShscmJwLT5jbWQtPmRldmljZSk7DQo+ICsgICAgICAgc3RydWN0IHV0
cF9ocGJfcnNwICpyc3BfZmllbGQ7DQo+ICsgICAgICAgaW50IGRhdGFfc2VnX2xlbjsNCj4gKw0K
PiArICAgICAgIGlmICghaHBiKQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiArDQo+ICsg
ICAgICAgaWYgKHVmc2hwYl9nZXRfc3RhdGUoaHBiKSAhPSBIUEJfUFJFU0VOVCkgew0KPiArICAg
ICAgICAgICAgICAgZGV2X25vdGljZSgmaHBiLT5zZGV2X3Vmc19sdS0+c2Rldl9kZXYsDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICIlczogdWZzaHBiIHN0YXRlIGlzIG5vdCBQUkVTRU5U
XG4iLCBfX2Z1bmNfXyk7DQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ICsgICAgICAgfQ0K
VGhlb3JldGljYWxseSwgU1NVIHJlc3BvbnNlIHVwaXUgbWF5IGNhcnJ5IGhwYiBzZW5zZSBkYXRh
LCBpc24ndCBpdD8NCg0KVGhhbmtzLA0KQXZyaQ0K
