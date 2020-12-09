Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C19C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 07:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C21AD23B85
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 07:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgLIHlh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 02:41:37 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:63606 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgLIHlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 02:41:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607499696; x=1639035696;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W3jiun7WeyWq7rrV4umgzgMeN3/0iFtAVfqiIzYgneI=;
  b=HdfdsTfxx5uQk3bCfUb3XCzlSsyj7Tqk2AcNuLTnFLNZXnnZCVDZpVIk
   oLaLQThf22sWWQ4hO8AlFuFsbc4763ZC8h4b4qQI9cQF9ICFiqdS6mB0X
   ujOpdyAc8FHPZ7WBA6mwXikFXuTEtx6Zpp35iM4kce3GsDRuiI4g++vln
   PKx1aBvTSMxRWHIwdZa3CTwpw3DJcX9oN5qbsHvmsM851KHd6PDQ4E9yk
   c7iYoQGdi7ot7kOUAEcx5c+diKrH8pi1gMguBB/uJMkjeX/YfmdprbRgu
   3FkhYPoL1bpiF5C4YKJTm7/KG6LUKFviJLmVJm1mpO0GaQYjpa4f3txqk
   Q==;
IronPort-SDR: Nccv2x57WR6ZxCx+IY1pR7D8UPxlwQ92kqzyc0nETbJTmwPNaRPst8XFbFDIULpA/PuGfraxsb
 +saTyA6stDjV2cZm3lpVg01VEZOPcyHYpKy0zA2sj0X7DdcP4TXpzJeduS5XUEPKhhNPnjDy8l
 PlcFfmdzF1Y78eQzj9EDtAf3SlmZpNNJtgox3hPVvMYv4TpSCsVYML99l2pRktKjMk276gOHEF
 tYr/A3U6aklELYE5vbTvsP9rQNxIx6BqzEJ6mGzFao//0psUG0W2uqxaMSRvrrpdONQ6xgFslH
 sd4=
X-IronPort-AV: E=Sophos;i="5.78,404,1599494400"; 
   d="scan'208";a="159213133"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 09 Dec 2020 15:40:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZvTUsed4VHAozzDzVMef264d9d7ZfRdrynrHOZS1CLvgyGcjweI96/EHAIKqAn/sjpapmEDaovLsAj4KVSTumqudSDX8YQ8wVk4Vhnbr13clzLIrmIzfvpRD8kuv9DHE881vLETaYA11AqDEWeCbuJq25GYT6D/4zjCEpnJpu88AKLTAbnNqkP4M5G3wtCa3QEwR9dceGJMfzO//oXqHb4FFxbpyYmTY6cMCfcaEdvy9qaq8VLSDAmniEpC3QD9JIcgBxBYYKVPovPtz428PLdMKGmi/Gavre+RhhESzsPK4pUwhVUixANRSve0C5o5yqtz0qvYHHzqL4m5Lutp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3jiun7WeyWq7rrV4umgzgMeN3/0iFtAVfqiIzYgneI=;
 b=eNU+OXjmmaR0Wcz1IHKLO4oaAmBCBEROpa8KwcgVf1vnSibUEOXUDx2HHZcXACO4XELb1WK291I0oNlHrlfWn/yKObQWWhU9tsk4E9qHUBkyYqfqGWG5dgKPi+XjL/d2MJMRAPWk3muRfIp4HX94W8UXlABcti0/H4UfJ6nCbWEvCOoCy12GkoHFJx9O20g2SgTYtvCIHYvC/nlFERX8tVeowwSXca33k9Plpzyy0Q9/WeR4ixkqGivMNqDl+2hNaxndxsAoo+OvAXBGFw9uid/lY8J58NLjvAtAk0yezV4Q7SpzoXXNKvzYfVzStGKxbDy6rKFCvoNA6OW6ZLjFxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3jiun7WeyWq7rrV4umgzgMeN3/0iFtAVfqiIzYgneI=;
 b=OYM0OT7pnlLBy7BCQx2bhHYvsYBYLaWOCfZ8Jzh8AI6TD8qoV0eviG0WRr4ax32avHBiJBODLVtblnZZVliXd9Fozy5HtUAh9zLqQdc8PKDAdls10Fk+3zOupa+HFHhMqju83VsqY6RhDclRgYZgNFekiIA8lFeWoO6/w7Sisls=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0730.namprd04.prod.outlook.com (2603:10b6:3:f9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.13; Wed, 9 Dec 2020 07:40:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3654.012; Wed, 9 Dec 2020
 07:40:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Topic: [PATCH v3 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Index: AQHWzaZ8p0p5Ox8520exeCmeSmtzuanuYT1A
Date:   Wed, 9 Dec 2020 07:40:28 +0000
Message-ID: <DM6PR04MB6575B928898B319E8ACF1395FCCC0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201208210941.2177-1-huobean@gmail.com>
 <20201208210941.2177-3-huobean@gmail.com>
In-Reply-To: <20201208210941.2177-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a639622b-f374-4fbb-bbfc-08d89c15b2f3
x-ms-traffictypediagnostic: DM5PR04MB0730:
x-microsoft-antispam-prvs: <DM5PR04MB07300822DCC2C7477C241CB6FCCC0@DM5PR04MB0730.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uLdK9wUld+ByCeed65Wrhwa1vq/8Tpsgf7w5SVpw2odDi/filwufULr9ABIpzBpMlxtVmkvtsb5VzZ/BTXR1Xg9+NjunH2hQ3C6j+teTLOGdHkFe83bO9OACo5BZ7CPlnOBVsm/eLZe56P6zgTzJfDbCXsZ3BjEaW9x89f8sLEMsvRbxhf8d1dp5NxXn3B47E+a8JJ3/Jzpq3gcCXsblLVEIvXwkQpZVE2OHrKXXjSh5/5pQGqKNLdHfWFBp+wlSRQ7EetJulVeStQ0jmUVXhwcY+w+gvVQwKbvy4czL7HwTFifYa/CC0oP/Ssrjoz/mJH+9jp3lDNRcSoCVaJCP9mIt7rKZeLOGwanQlZOG8vW4uV3pnbcKqmQcj1L0R96zfzOLIkwG3Kooy39VozAH83DtvqYnXqvmuiwTRUgyBAw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(86362001)(52536014)(54906003)(6506007)(64756008)(9686003)(5660300002)(66946007)(66476007)(66556008)(66446008)(4326008)(110136005)(26005)(71200400001)(4744005)(7416002)(33656002)(921005)(76116006)(7696005)(55016002)(508600001)(186003)(8676002)(8936002)(83380400001)(2906002)(145543001)(213903007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0eS3jhQay8fPOhW2lUpVuyLoTpfAAsZtHw5CzBSx+SjkQBzObtea6b0q/Ide?=
 =?us-ascii?Q?eaFVo91ZJrvnVQzU5aMxRj44PYjT2lz7HtijMy5W/7G9Pm4RBlTTiw13ClH2?=
 =?us-ascii?Q?FpQVE8WbGV7ETos3/pSb4C24Bb39siDnzrxXyn+Wl8P2nc5Y6c8A/dGpbDzR?=
 =?us-ascii?Q?xltB+bbeEwto9xVIqBao30+fw2B40u+oundyXfjQ9vhN8+p7i5GNr1nTwZW8?=
 =?us-ascii?Q?luQdTOcAlFcG4F+t8jFpP51hBc7ARkTGZ+jBR/r5IP4WrRoLd5ffO3E3thv7?=
 =?us-ascii?Q?TxFAdFUe8dYuj7+88+Ua7CAhuXp9X7TzAU30PAfhytkdJmuxgIr87x7RLuMs?=
 =?us-ascii?Q?qgxAUBPJBrX71ZX/sE1BjcUlgLUMkuWQjyWlGRsBuXcZ7Yw41CmEUNu9MP1/?=
 =?us-ascii?Q?Sw5AWpKDYG7SFOLB+ARyyVn8JNc+YAuSF31RAIZeglvnVThAl2g4RThglR9J?=
 =?us-ascii?Q?3s7dXnrzVgGxw29fej+zH5EWDwwqXgz2FYBg44fJpTpdy9nPmodPp3w4tITA?=
 =?us-ascii?Q?3+b80gF7EnwCBGqvJybBoNk2HmQQjY8Jmf5RcTcTkQrEcx5BE2uOwpLQDaH2?=
 =?us-ascii?Q?81PqSlqdm6Ml9qtOTcCayhoF2vCy4EDTpsQElAoFotWcnnX1zdb65b9gKL7V?=
 =?us-ascii?Q?BND9ondVJiEn9SdhTMBmGdbi4JuCr/FylnETWPptZI6FgrUoqIFhP6oZqMcs?=
 =?us-ascii?Q?Vns7BZtjQia+dJQruukS1YMG/+cAvpDvSYD6WLtqpo2R89gHU/Rhl2KKAoS8?=
 =?us-ascii?Q?WQXMvr5BUN34KuX10tFFGRqN067ukFyiBbR/Acy5Kp+wJhVCeijs7BSA3Rfe?=
 =?us-ascii?Q?SXQBgs2yqm6EWA6T0FOC3RcJ+Gp9JfEwWxwhFEiFEuw3fz3iJcyeqw/8P2p0?=
 =?us-ascii?Q?voYB8qR+iYY8Lb3iP4f3vSyQprRHhi1JvvZRvXwTRVTIVRPFXOY3OngnhwXY?=
 =?us-ascii?Q?BF1s2+DwVw6BLCIafcL5ppqT9lPv8APxAe77Oqe+I/k=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a639622b-f374-4fbb-bbfc-08d89c15b2f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 07:40:28.2657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IrLRd4sYjSivK2YAse6/uEuXo2gv+mHxDHyp60KtP6e80AcVfZ7ivzZ9sXbTS3tjCNafB95zH3RmDzwTQNimhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0730
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Bean Huo <beanhuo@micron.com>
>=20
> According to the JEDEC UFS 3.1 Spec, If
> fWriteBoosterBufferFlushDuringHibernate
> is set to one, the device flushes the WriteBooster Buffer data automatica=
lly
> whenever the link enters the hibernate (HIBERN8) state. While the flushin=
g
> operation is in progress, the device should be kept in Active power mode.
> Currently, we set this flag during the UFSHCD probe stage, but we didn't =
deal
> with its programming failure. Even this failure is less likely to occur, =
but
> still it is possible.
How about reading it on every ufshcd_wb_need_flush?

Thanks,
Avri
