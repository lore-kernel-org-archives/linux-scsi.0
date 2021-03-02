Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BED7C28D15
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18CB64F1D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577346AbhCBSsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:48:15 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:60108 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575852AbhCBD6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 22:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614657514; x=1646193514;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MAAatlC24bC9LEwCIhupjONORF0WxqCJ3LLsV0Xn+6o=;
  b=FfpChOGa67Ay3/3+tN4lqon1TEFU4Eif5iHdGp0OYIXGnoaM9F2o9mRY
   jF7Wf5TDFR4v5l7iXMoT+8GBAcLMEPHtZ/qiq8ZC9O+SbGz42eexZ9IYg
   NVXlbukdyqe4Z5nj6uwjPbkKM3Hlq+fx6y2y+seWDveOrKoLruVFrMfVy
   DLDQOQE/pic4gclWDjZKwhyZq3aqbIcEeGrj5yFbPjq0MsAzkHGrTCSb3
   aBhEv7edcO+aRffIe34hjAan2gl0Kjh7RViyjSGH+ZKRKptv7AjZ716fD
   2g5T9euTzoaILL+qjR1rAbc7EDtQdQ8z6mpUnKpHvIdvXulH0blgU3754
   w==;
IronPort-SDR: f5CjmLs1HmQb48Dq0ebyfKI61GYd3oufXLp3/CEDxLAvWsSWHWNar0OCkJOVe7f0Fw6BSq5GJz
 5SOKbYUGwgu13cOgmh4Dj6/psf/6q0o7pVN5Uoq7ZzuK2jpvsG3lfnr8KCEoQ58d8TJZs3xNAR
 +w2R/SuGXfRHbJh6UQ0C6kbISSJwJUwHwp83uhp9INOVTocElYQWjA5cjKjHNeuWOC2lNHXZOu
 k9oDSQyWEBaatIs9xn79Eiv/x1NXw1pyAvJqa8G0/jnLaWNXs0cVTJbfQmowf+UXHhtv82ISmR
 V4I=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="165601794"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 11:57:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNkwNWF3rnBuaK4FME0/4buKooAo+mYKPn6vA1JtW1Wnm7Yf7rmuhSGky7Snw9A5z+PjzdUX57CSRDhkkmsxx13vMffdiCvp0s4UWS5Gdaw5wZXhr3Vx6Rcv+jX24uVSKA5o9Yn0vWWhJcNUo30fDgkuDPyce+nvgKaghwEbHZb36RDdGQ22RdIIMvSKH7n84pW4ydFSiT4+e4umEa3t+TH8pSixdqRNrVV0sz4grQVo1IYoT8z0h9YJSflcn51zM7UQusuaFnBGQrVan2aaaOBBAHifAq+Ary5+wWK2YOqYpMn0lNCZQh0slqlmD6hj1lYj0WtLByN+VNPv1i9eWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atuESJ3v7cJBehdRXwcjoDxKljcxjmoC1LY+L0aO9Y0=;
 b=oJq0kylF1fjEK+h5r5fbDlDtQWgCj2rCPQ09152/V1oR7NhfwEqhrKsAF8pSLmuOlgugkJEp5BtBaT41MO8y2PsssX5iuNDqYNdsZ5vQOk1C3o6lO7D5pZKKWlBrPdPZvvBO5ulmjONTL7BHH3YA8ZgiPMvcZ6PVqE925q1HW9F5Yg6Z1rt7Yo+3HaExaeHXD/4kcg8woWvrUay1lZY7FSSOIOPVD6UL5c39mJm0WiCjMs4oD4vve3ply+jXAJ4WXKarBZ5+T/cVyqdPWfXe9dkD7TiUPFVsOJsqmR7jUH2VPMXXOTIBkSoAL/+5zmkrFWEAo+Bu3COIB8iC1FGWlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atuESJ3v7cJBehdRXwcjoDxKljcxjmoC1LY+L0aO9Y0=;
 b=pLLlRRK1ihvLajr0t9KtgfrDXUAMkmAkif3Z8mcwd2inhZ54Lbg9UocuFQu0PnjjB45IR3QGHO2JnptxRvsem2hKyPM/qRN0bDVkJHNhxNRN6mB6Sn4SgYwQWLtjbRXUZJy64+JJQn3eSqyLzDFv+m+cdidqId+/jRVscMdBI9A=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7550.namprd04.prod.outlook.com (2603:10b6:a03:327::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 2 Mar
 2021 03:57:24 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 03:57:24 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 04/23] targe/pscsi: fix the warning in pscsi_complete_cmd
Thread-Topic: [PATCH 04/23] targe/pscsi: fix the warning in pscsi_complete_cmd
Thread-Index: AQHXDZaduIp8XdfQ4UeEu+pDi955PQ==
Date:   Tue, 2 Mar 2021 03:57:24 +0000
Message-ID: <BYAPR04MB4965D743C341C598DB030F5686999@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-5-chaitanya.kulkarni@wdc.com>
 <PH0PR04MB7416CD9028BA4018C349D99F9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: edb8e69b-9972-476e-eef2-08d8dd2f4a02
x-ms-traffictypediagnostic: SJ0PR04MB7550:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB7550C65D4EA09E05C242D28C86999@SJ0PR04MB7550.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DYBBIZIfg1/6PRFei50zVhVe5NmBbIm35XW9qq97YwidQnBYprQJfHwIG666YkBPqEa4Rb5SSxG4YOlIufMC0LUcwvkP2RxrP4IDR/K0+kqMfffoLsSYKohOaUP3FSuncXZJJP36O+Ho1A2/PpYkVKe+vWLzk84cEMjioOUkkIoKEUAwKiPGWTsWEVQi38XC15CfjVn/mYm2m2/b6fz0WgJ0NWYBnfrxeddIXAAjgfjSD6ej/Cnr1v9DEcePCwF3XhP+Hjn0db7r/dFStomD2w1U3o7Bto/51CWdVrFfk6m8VP6FSm8i4NuoQo9qt1dLWXmOYq1h2sIkNuCHqN4mxvfwxJNfDLYRreyMaOSc12Zuh7NHu0bL11x+2qynzL7fTr1LcBqai0dSKdDOvQKyXBtNeQ2MVwk37YK/4k0vQtloHpQRuJLRC3e2LJCfaXXfAHd0B8S95u5DqUolKJNvpods0aANiCINsVU9xox1qZaxE+7XE7fYXniOlS3Qm9e6dNp5+Z5uXSWL0/nWv+LCQocrzV40aRJDpkla/orLpR6ZLdXJRQ7Ov0n0W4/DLOws
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(66446008)(76116006)(83380400001)(9686003)(110136005)(91956017)(64756008)(53546011)(7696005)(6506007)(66476007)(54906003)(66946007)(316002)(66556008)(8676002)(2906002)(8936002)(71200400001)(5660300002)(52536014)(4326008)(55016002)(186003)(86362001)(26005)(33656002)(478600001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7iQikzd6e6gboXazdf585N0g6QeERawPNH5KyTUUgBuKD+MqGUDgPzZHosSt?=
 =?us-ascii?Q?umMqpP+awdDLr+G7bXxcjUevcBsDhwR25zijyeWyvuEjm0EkvfjpV/PdP/Z4?=
 =?us-ascii?Q?swT5NFg10WRgEzzMzZMZLs3DdObTXUjOQ/D8LoVFmylTu+KkV1u+4MR8Iott?=
 =?us-ascii?Q?Xiv7E8mV2Vth8lPuc8LFo+dfbuliWs6FytOY8J1Z0aSLAZhFSpYacVWce/7E?=
 =?us-ascii?Q?oeLugAj0lpdFv70slHQSvBxDeYHs9xQhiRQ56t1zujCrc5tfOxGIo6/Hikaw?=
 =?us-ascii?Q?RhxDBfByQc/JW15sHrtqCZ/mgsYNorkDJOMw9PwGcKau7OxmmhzxHn1XKgXa?=
 =?us-ascii?Q?GLVcX4EQYhUv+idMX5j4Rp1EGBacTxGOkpM3vY9QsTdIhhjCNIDYp5tL4KRT?=
 =?us-ascii?Q?yt975Jeu79k+s4ygIHUxcfi+ueG0FSzRPHRUBikDlDjOFokcjG+u/pczc26j?=
 =?us-ascii?Q?BXHK5udV2WMSGvjc0wcjzDm4ulwkoQp/yo31Cieg0CSdbIKlHIc2isCLbr7p?=
 =?us-ascii?Q?ug7CV9GKc/6KurRVZkmgISBCBqdGpR6hw5oGSmdSXtv1JlmqqzgJ+HoZlwoB?=
 =?us-ascii?Q?yupiWCb/UCxN4mJ9YdH+NOYIKQzwHBdsE8CYr7PPErTAU/CRzSkyMLNF4qov?=
 =?us-ascii?Q?fmVz7XUfvhjiOHa5ZU3IczGTg6Ky8qNj8/T6lr28K0E+cBUrCYqBlYXWoFvu?=
 =?us-ascii?Q?s0tUceL4DnmbKYWVEa1BcmAWZHu9EjZ+mz7H0J5Ov895MwBSxnj3FVYO6Qtv?=
 =?us-ascii?Q?ogG/MLiYS+8IChqoWkqw40KHIPjHnaYDWaFDPRIAucoPnv5KREX2Bz7ph1mc?=
 =?us-ascii?Q?L4IbRH8g/XdpDL2zRgoGQCUk8hdiTyzaBL5M6+XRQC/a6UiIekXUiFhk83Ps?=
 =?us-ascii?Q?t87lOHg+fNX4khy9+Lqoa2dzayTiGwhRgqrSj3DQXEotikp94mNjCvL9zAVQ?=
 =?us-ascii?Q?7iSdAXcD0UDt33cgY0j8Q8f17w7jM5nsIEqZybl+UGyZlFOp8dg+L3aptUfO?=
 =?us-ascii?Q?AUpd5o6O4Psb80jruaN7rHMrCj/V3nkgV+heWwbE3BTs6FS7v94CMmvssBxq?=
 =?us-ascii?Q?LtBzWH6e6t4DyC6YWF1/7bOZQEzyktcPbjkLgyVrJbjvbGYGEW8bQq3mvMur?=
 =?us-ascii?Q?36Axax9EVPE8fVXKJQsTp3JlKtvHQhEdRc6ThnhrNqN29DKvds8cZABcWWjH?=
 =?us-ascii?Q?P1JlH1SjeywB3JZvunnTDLp4ORfbulEi3itSZMcUPK/3J71onKDDaqfrY8uA?=
 =?us-ascii?Q?Aqkwo/lstJ8OjkClIUnUlqLGtFRsjNZBHwMqo1cbMTX0ofHsTGRqX3ANwGCv?=
 =?us-ascii?Q?Ct3Blyct4o7DLPvyE96xqk1Q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb8e69b-9972-476e-eef2-08d8dd2f4a02
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 03:57:24.6653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQfM5diKX3RfAlU+edtHc7wqSt3imbsGrV5KLWxFVx6eFYnekssrL6I7Wlb3n53llM8bgzem6JWY/WqtU0cmVfz/ri7gtQgCFn5Qbb2OeMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7550
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/21 04:30, Johannes Thumshirn wrote:=0A=
>> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_=
core_pscsi.c=0A=
>> index 3cbc074992bc..689e503e3301 100644=0A=
>> --- a/drivers/target/target_core_pscsi.c=0A=
>> +++ b/drivers/target/target_core_pscsi.c=0A=
>> @@ -620,8 +620,9 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u=
8 scsi_status,=0A=
>>  			unsigned char *buf;=0A=
>>  =0A=
>>  			buf =3D transport_kmap_data_sg(cmd);=0A=
>> -			if (!buf)=0A=
>> +			if (!buf) {=0A=
>>  				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */=0A=
>> +			}=0A=
>>  =0A=
>>  			if (cdb[0] =3D=3D MODE_SENSE_10) {=0A=
>>  				if (!(buf[3] & 0x80))=0A=
>>=0A=
> Do you have any plans to actually address that XXX? Because if=0A=
> transport_kmap_data_sg() fails (and it can fail for various reasons)=0A=
> and we get a MODE_SENSE_10 we'll trip over a NULL pointer.=0A=
>=0A=
> I know this is outside of the scope of this patchset, but would be nice a=
nyways.=0A=
>=0A=
Yes we I can try and fix that, but surprisingly parse cmd return type is=0A=
void.=0A=
It maybe a bigger change will keep it separate. Thanks for the reviews.=0A=
