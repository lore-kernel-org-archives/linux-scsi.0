Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A00C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26F464F83
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 07:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhCLH1j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:27:39 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35597 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhCLH1S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 02:27:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615534039; x=1647070039;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=EopT/m904KeE+uAEbsSt5EtcnLrjvrXMK2dasRctR+s=;
  b=Bm9bhsYLBtmM+Xlni4eCmYEwLXb5ENY1mKJmAMPcB9EieXpGB1LlXSzZ
   wi0OHsfsZtPSKQtOw15HgfYIy9p+TDwtFSZYl1L6cE85cNuKSL9fV+6oJ
   o5/k/vXyY0fVTLjuFjOtipHm4if4NZkiShh3OzzVhoeJxJL5+5mfj3Rl2
   i3i8AfzN6IhcYGjnttJeIE2+bxzbZ7LU7DqOVfDyCegQKTtwSf1Scju4n
   JjkyfX8N5EdfQkMKxt6JAj7moYaVUNkFFcONw2WHegnVjrz7wC+/df9z3
   RW3TW+8XsuU+sRHT5a+kBoR5Gyc9ndl7BTayxpVBSKXsdf0sZqM64glZO
   Q==;
IronPort-SDR: h7wmbrEHklskD6fF4uPjDpZGK8V54cGTEuCKOZpP3ZNKVzHGatX9wPewdPtF44sZLea7wrqzFL
 1BRGRMjH7VsMjEA9aBvQuxCHIqcXpXA3U7O0KwHQlNg9v4jJgsPem+Du/FIbmcmEFzZ4/WnqJn
 eznKKRGch1KuMuji2fZ3xrSfSolurQ77sWxHx/okzGF/xqKlqmg11Z2RzjB6HOyyJlYAadaO5p
 uILuLbBunkH+68Mdezf7qP/N/NPOnm8IIGgv9/wTOt1ysCRyEFdcYizriEc2WE4XCKw6tOiRDt
 +Xs=
X-IronPort-AV: E=Sophos;i="5.81,242,1610380800"; 
   d="scan'208";a="163143981"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 15:27:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRG1qYnDLyTeWawyr9mw9HcmpEgMEM278xfavs4e88c1Y7dYx03bnAfh1Me+pfQfNKL5wAbn0dBEqOw5wRcrP9s5+fU1ogH5wLhnVolq2fxzUpl2bX6evlvVjFXJOGgAOvRPuY9JQOKLaijPtTxPMJZQj7qZA5gnZk5eLyfpucTxmtX4c+4y489kGJZfCak5HIA/tkfqOdRThdPtVzUxgI/apGEAlyxCZRKT0pGnc6Cc/k3dK17169IMzFdnv8GeOR98SiF0+2DODmpn9dp0GEl2qgQ/QcyyvugX5x97E3pLVpYK5RDd24qzpQWwEE1IZNo4fRP0xZtAHcUyJNh1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EopT/m904KeE+uAEbsSt5EtcnLrjvrXMK2dasRctR+s=;
 b=CV1X+kye21ulqvuKD83QmxNxQ+IY4saDq4zY3jXbiqYTdmd6Htkbf1IsrdfuEC+0lZFnlc2vTD0dawuwrkHYOkOOseEvcUa2ZZ4yoDpTJc28L9vN6GwZkWURPn+V1oVfRs3RCwUCracWCx7Js7FbyC0mbP7bVlnND4luWiQcDxyiXIdE/7aw3Ulwvd72ny8ZczJsZ91/JoiLKYr6E0j13imuEXLl3xIlcc+EOX9m1Im2spb7cu+G70YF930kyjWpFKK6/AV0fDP6FG0bULAPwPuTFHm/u6z79QYRhsLykL0R4uO2SE4gyyD9THEpNaBStHX9EmfHls22VNr8tfoNeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EopT/m904KeE+uAEbsSt5EtcnLrjvrXMK2dasRctR+s=;
 b=VX6ga9+5xZdaQn2tdfHPwTD0UMKzwi4QDS5Ti9y0bemkD1NFhv2EJbe+K2CjKUxco8gPauvdgtRey7ycPXRtn1RSJ5VLykbFheLGemQKnBdOHFbSgKbmj2g69xPJn7kwZea7Yyf/0pwmEBHQuNLSy2wsA9GmI7lR6qEsVuYvaUQ=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4980.namprd04.prod.outlook.com (2603:10b6:208:53::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18; Fri, 12 Mar
 2021 07:27:16 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 07:27:16 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ927MRhl54FUuu2AgpdB7HQw==
Date:   Fri, 12 Mar 2021 07:27:16 +0000
Message-ID: <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:bccc:6f52:efed:4bfb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0af85379-b477-4fd8-39e8-08d8e528434f
x-ms-traffictypediagnostic: BL0PR04MB4980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB4980188E67117B7E93A004B6E76F9@BL0PR04MB4980.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C50tZJgGNyIzbbfTKL74EqtQLPdBfzVGT8np2+Q6fuQxkMiw7RAtU+e8xOOv3CKFCcSbjYLPDRtChfRtdg9JdfJ5OPY4faf9nYs6aCHejE61jChy+UaP1GiX/kpv6f+4tPQ2a6ZEun4tSmK5UuPP0Nc6EEvYeqk9bR2FsBlh0ju1q483fiPCMGcqvHuIvTwDDKyLj3N8qRtEUDCWrysQ6JsEv8KeM3PYRumKb75NU+mM7IdlIG2PHMEsfNen3UyrPZRufAMS0U3CwY5ihRu1RR9/cN+gxAsygfvskitN6iN9FUC9IuXBv6tnkmFw70E6HATV/zxE84t58FIPKEYFtEg35bxNYL7tPmcJH/v2a2xWApdKd28945cBthaHFrvV3nKpJPPOQiwrzdwA790z3kt898D4nESPLV5iDlfyCAKarqS7vSoyehs3yotqhwiEnmICPbiKt7jwdfsiu5xdSdliO7Oo5E0LI/7MaFhrHiwS0pe71DmdzmVN4l4248Sal2LALtbXFekYCqRVe+Oysw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(4326008)(6506007)(66946007)(66476007)(76116006)(55016002)(91956017)(33656002)(6636002)(83380400001)(2906002)(186003)(66556008)(5660300002)(86362001)(8676002)(53546011)(71200400001)(8936002)(66446008)(52536014)(54906003)(316002)(110136005)(7696005)(64756008)(478600001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?mESYMFw+3DKnhhfxjBNBwnM7VL07ag7r1nIukuxqfn6qPlfOxnCvEvKejPD3?=
 =?us-ascii?Q?XbC9wrydrKijbVVoNThz1LMLcd6gsd3NawduUB0tL4uKWCh1NbU6E9CJmeFC?=
 =?us-ascii?Q?CkTByAsw7F2Gniwyosf6B4fqcVGNLfS4YdLukbvennGNRDr0F2HU9k7Gnve0?=
 =?us-ascii?Q?i+x25AuXi1Z7ZIAujCINrNxQFoM9lqKPcryW99XybyoOb1r3TNwohaKXbVuQ?=
 =?us-ascii?Q?uzdwM6pzwgchkVLXpy1H+LxbQGCkwo67yj3MJaPi7rKvcqq3f8XpqCtlUn4D?=
 =?us-ascii?Q?U56kgiQCL25RXSQsYZOlyKDB/NFVtBkyZIRiEXGC8Q7520Ixck8MFyYNsO0D?=
 =?us-ascii?Q?HLs0jxj67wnN1ZdGQUXAuWR/N28Ql/FOEdEJmVHJHew+goY7dMRh6ZIz0mcv?=
 =?us-ascii?Q?LAn67V92PWo+g2anMGldOakoIqgaGt5oUEhHBgTfwT65dRJYny2ro4fR2rGA?=
 =?us-ascii?Q?b08+FfIZBaV0/eCSpF1QenC+iecABZI8n5CnK0jGB7qnMVgRtxpppHan7Fb4?=
 =?us-ascii?Q?qn197o/c0ykeOhyi8ivZL6w9ysXq+NRV10jZfOSAC3aKf495LNaheGD0/K2a?=
 =?us-ascii?Q?jRKrCT6SN7oYI0Jh4LIWXr9sP8BlTpUWvvCculFPV2KwonmGQkEsMKHfpfuQ?=
 =?us-ascii?Q?xxii6xu1EGI7q+VSmJwSiuDxEDkkhxcVnsQUs/lA2S1TtPN1GZkGjreZ1SLh?=
 =?us-ascii?Q?hUHiFN98ywg4FTa0w3zJLVsi9ftuL2eXv/LT5MINqFn3A4asdWNDPIfAoQSo?=
 =?us-ascii?Q?WKAfkfAp+4n7imCAoxnYETRILfeG5EtDoDiggnFvr1nxbcuhLkrD/xAKxaOH?=
 =?us-ascii?Q?JKn5dL4/s4bzfQKbbSa0+VjeOtCWKgDOVfAtcspE/nurlAeSZX5GAASF5Qhe?=
 =?us-ascii?Q?jKS4BUpQdfUIJ5898sLB3P/i2Rvp3XOL3GXDfLQLGm5ILA8EAwyOimbsm76r?=
 =?us-ascii?Q?Uzth728pVLGvdEzybR3VP/Sv8QhvI+N99dw4HSQsY+HjmyANS8bgFzrc7XM/?=
 =?us-ascii?Q?6M0r81U9141Ub8PQbG4qpCAsXotBAODTsLH+Zg12+MUz4Frh6NSSeKt5jukh?=
 =?us-ascii?Q?BP5KYmPK12j/PfaG5Jt6e8OHOUQZ2FABGuDtn4uY/Jjt/76lNIcKCmtT+H/B?=
 =?us-ascii?Q?un69N3DgpKHCKYzfGfO2F+9OHXbOxe95bl677VUqLEIF0GaV7DbjDcwnvNP/?=
 =?us-ascii?Q?T+PEhfUofhciouLOQSDVIHhFSpN9nNu0gEGlGguzNN2+eru4TXqKdRqEKcLd?=
 =?us-ascii?Q?kuAUhpOnPoPw0vXAHjby1tNxMa5XrjKBondIaPTXNfFSe2vKuUJ6AWOF+nHp?=
 =?us-ascii?Q?pyMzS7sUCeJFtsKB9p6e9xPc53hr/1+QyKfhh5bP1tKwmzGGXxzdhcn8easn?=
 =?us-ascii?Q?/GeyPQ31rPSo1EJIYAy43SoglI4LyZaeQhHIA77M46h8yhyTCQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af85379-b477-4fd8-39e8-08d8e528434f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 07:27:16.2597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5WIMtAEJ9kfnYPj8qk6VgihX4rJ/1OyB0sLRedqM7Pc2o1RvAOkn0vUtI4RoaCDmqLSA7PPRnhzM7/QjMtAtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4980
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/12 13:38, Shinichiro Kawasaki wrote:=0A=
> On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:=0A=
>> On 11/03/2021 16:48, Bart Van Assche wrote:=0A=
>>> On 3/11/21 7:18 AM, Johannes Thumshirn wrote:=0A=
>>>> On 11/03/2021 16:13, Bart Van Assche wrote:=0A=
>>>>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:=0A=
>>>>>> Recent changes [ ... ]=0A=
>>>>>=0A=
>>>>> Please add Fixes: and/or Cc: stable tags as appropriate.=0A=
>>>>=0A=
>>>> I couldn't pin down the offending commit and I can't reproduce it loca=
lly=0A=
>>>> as well, so I opted out of this. But it must be something between v5.1=
1 and v5.12-rc2.=0A=
>>>=0A=
>>> That's weird. Did Shinichiro use a HBA? Could this be the result of a=
=0A=
>>> behavior change in the HBA driver?=0A=
>>=0A=
>> Yes I've looked at the commits in mpt3sas, but can't really pinpoint the=
 =0A=
>> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for shar=
ed =0A=
>> host tagset for CPU hotplug") is the only one that /looks/ as if it coul=
d=0A=
>> be causing it, but I don't know mpt3sas well enough.=0A=
>>=0A=
>> FWIW added Sreekanth=0A=
> =0A=
> The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive and H=
BA=0A=
> Broadcom 9400. It can be recreated by running blktests block/004 on the d=
rive=0A=
> (after reboot). It is also recreated with SATA SMR drive with the HBA, bu=
t not=0A=
> observed with SATA drives connected to AHCI.=0A=
> =0A=
> I reverted the commit 664f0dce2058, then the WARNING disappeared. I suppo=
se=0A=
> it indicates that the commit changed HBA driver behavior.=0A=
=0A=
Can you send the warning splat with backtrace ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
