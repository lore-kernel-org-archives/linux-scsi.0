Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FFCC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85A8564E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhBBL0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:26:15 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:19409 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhBBLZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:25:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612266063; x=1643802063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KX8/WPyPyaeTj/4Vb6UJZWWlzHZhbnGax2BZbozCm4A=;
  b=gYanpgjfKYscQiZMlWTx682JEbcbRMB0JBo/PQADNan2km4TOKOVN1U4
   sNtLb7i/ElBSuv5U56OtZ1qs/5syAXPWdE2Bbep6Sjh6Rr9TS0yq8TZcO
   i34/Up9faczS5+v0D74kXupmWXgULVmN3AniCQlqIZYsE6Pj9zwvrMs3Z
   spXTwO3KSuCoAhHMyvKeIksXgQgXvMnMrVB2g7LwwNXv19/GnOv04E3sr
   3uoT00EM5zodw4YFZ2zYN0NpCMN09qfa9lSPMjK7T+aH9px/yldg31n+3
   34W0E4K7lKAuCFAxc3RvD8DSSPWDID10vSbEYpxs5kTwkaQMH3NXEY5TE
   Q==;
IronPort-SDR: mZS3rxaJt0Gc02WAJFjrHgnz6y7qq43zLYh5oBe8vK4VbNKJt3dvL7hhG/1eEtSwzzsOen+6Fz
 iJipKEe/XK1fOMTkFkJ7wWDj+1lHN11ugvO2CnpvsUV2TBCl5kpNc6lsQQckEqrI47DwEOuN4X
 q/eDHtov79kmFRvaM05O1iFe8+RzEcFHSk1gV+KfeGdaMyahJ87Vfit7rYMKYMh0BlbRrFhR+K
 9UYwAKX+eYWonIi3RR9FpVHh5b5q5pfuR+KhuXE9TGN0kYlCF4/yhlCnO8oNXOxrgnA5ZofRwu
 w+o=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="262991210"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 19:39:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVea9fFnpWrbpNSqSx9IeBDVV5ZlY6l6klxOpcHAT538FwkvqmuyeysZKp1njEygTbCPqQojyVp+OAC3XDMCJyZkbeMI/MfdHKYPzxoI8pu6xCkbOpCQND/nZvR4/BD6dtxY/td1NoFmJELalL5iqmICPtCKUEaclcNikLZrRXFoEqtg4nLKnIhWwqShw0eGjCYK7YHcqpsNZZJJLAhQ9ZDRCNDFybChhwxk0RvRvBgGsGiYMGRIra3lHKTQtM0/cddBCg9zM8l+EEpKB/FH90jvewotxw+ShMZYh6yPWm6dTtaugxgfLs4+Uut/UaE1lGtljQvrLndc+lhgrpKbHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cpwkopksM8DcAIFeQSZNAsl+5tdDUCOpojrju9Sa4M=;
 b=FpNIhsEr/o3HBu6wNRYlV8VnaovLR/n/xmcJld9QecOxXNp8adFoWDBSB4M+fJKAn+W6z33lCiSUfnfwIU9YHxHonMyhPzXKfrnfpHPbLNSh2KWgqU8rxD/37lj+AsJymva6v+1b3wLlipgiUhdogsW327p9SltqwH9gJjQXXL4SlgCyorpJBppp7UCYA498fu5/xCeQfx92qjgvC8B/tqqmBP3YE21GY/yZcHAMSLivtaxZ3ncGUBnh9oObDXqGS1bxGgcSSDQC8tApcNsOTj1G9voH9/eXOIqANcOPUxuoSX3xVxyGXmLvgghJBYdtEGVJ6lt3BLJji0WWLOPJpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cpwkopksM8DcAIFeQSZNAsl+5tdDUCOpojrju9Sa4M=;
 b=zu3N8mccLONPYMMMgAaQPArnCzVHiSo5hNbzhRvavWaSUf4/wWwNg2eCH8iYGZeY7MC3dLONoKWSFswZWpErYlvSxID+opJ+sDwMeuFXf0NELjmm5pNCfOALeg9OBDqEkLYB7bYQkq+9fEyVrd00f8+HyI/AdHrAREwfsK4XiYI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0266.namprd04.prod.outlook.com (2603:10b6:3:6e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Tue, 2 Feb 2021 11:24:04 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 11:24:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 2/9] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Topic: [PATCH v2 2/9] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Index: AQHW+T20gCB3H9uAPUqvS/piDh3jCapEtnsAgAACqhA=
Date:   Tue, 2 Feb 2021 11:24:04 +0000
Message-ID: <DM6PR04MB65754BB7B07301D2B35B6490FCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-3-avri.altman@wdc.com> <YBkz7m7uMP4iJ/qn@kroah.com>
In-Reply-To: <YBkz7m7uMP4iJ/qn@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6caba4f1-44c1-4b81-1926-08d8c76d0c6f
x-ms-traffictypediagnostic: DM5PR04MB0266:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB0266D6FDEF8A443A310210C5FCB59@DM5PR04MB0266.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:288;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EO4zSpaQ6QAHlxE8cAvg+if+XjKejIg62SnaDy/vkbJ8bzGFoZfGwEB23oowW3K4OwThuiH76knfOU3Ur/eW2RciZaRsL7y9gwud9rmb4m5UPOD+qD3qbLmkIAubhJZhhrgaeeMUdIrajqtnncwP8YYnDlcr9rWI9Hb0zcEvX0Qvtc3Os3thnrpwAp2YV6MgFK2FaEIpVAiX4oC3OtCs39mzSxJfixFF1H1C3IJnP2/IciFHbKzWS05LP7fiUpPH8/eGOhrxWH77O7k+H5fx3qT1H84F1pF7y7E6Qg5KtgmvFbdR8qPWAMdITkXYmaDAG3D3oKUhJMkV4buv4+iaQIsUuu02CrLM7FQ6P2Z3daAyiAlTSMILmS+wDm4Y/i/VgbMbvta21ulfaC1IoK6hn14MbQywdt389TxAYCG6VXUUhbrc4uDsapVNksvSsAdwEz6e+XJIQyIyb6FOZ/vDbjm5NtuRmcyIlFQ7XJLLbZ6AsgDMQMtQbYvm5kvH9pgjdOWYWNOUOq3eEzADBAULAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(8676002)(4326008)(66446008)(6506007)(186003)(64756008)(66476007)(26005)(7416002)(33656002)(66556008)(8936002)(66946007)(7696005)(2906002)(54906003)(83380400001)(86362001)(55016002)(71200400001)(316002)(6916009)(9686003)(5660300002)(478600001)(76116006)(4744005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oCzQw1joOdh2wxCWU2ldntB7GIrGaUOMM3olOugycTrVRUDynOpPJDlZ2ZHJ?=
 =?us-ascii?Q?Cy3P3EOWaUB4B5AXN1NmPzVOhlQTeEkGWH9KIgKS5NhxZ51eugwLfMkRaMyR?=
 =?us-ascii?Q?65JrX6yUXH9K/eG798SCbUgNdE6vQYixiJmWMMe7/ZVE6zM+veeUVwAnEBUa?=
 =?us-ascii?Q?DQVBSf1HNn0+VbuLXY6NEhNZGxqj5HW1+8lSPJ+KuhRQmihS4hknxXntp2Hu?=
 =?us-ascii?Q?duI1EQjpv5P7MtTs15E/qpHqXkPUoewrtWW6WMWw5YiDBotH00W1FDqpCSaK?=
 =?us-ascii?Q?om4i8cTvotW2ryo6dzyIPdPRqWP7a2fLUm2RrSFuTargUjcmNTdVc5R6w9uR?=
 =?us-ascii?Q?RXIGmIKJr8X7nNuKBY57tvRi2boXONhvKelEUvYS5ZNyFieVdzUoxxB5ymVC?=
 =?us-ascii?Q?9Bq5yus+K6R+4pko8yWnXABOTMnOVIRiGTsl+dXScovRDxtmEHKH7ie9m/2w?=
 =?us-ascii?Q?vzn9VOGUnf0KPY/jlGKhG2bm0+zV7S4fEit6UGM8UUnhTK9R6gI6IorI/JrJ?=
 =?us-ascii?Q?TzFXbOOlknNtoxz8+6Gq+MW4IDR5N/BlNwTMNxsYilX1NjkHaQUMd9R1sCVn?=
 =?us-ascii?Q?lD41ywbZ8TG2JIIhVIOUI4xjVWWPN1zsXd1/ooR7k8QCC53F7Cgq1QJ+juYw?=
 =?us-ascii?Q?mTCiY2BAKVhxKkSl7mcaE4oeT3+Il0C08uURVb4AJavQA58JAqkjHJyEIJ5E?=
 =?us-ascii?Q?zAzymirRf//uQiatfkqiZh6A2Tizcbnb1Sya9ROBaSIHjFZeIvF2fEqfhpC0?=
 =?us-ascii?Q?H/A6eBTWHa5kzhInh9dsxBDOCHyLEoYqTL5maSJ9r1ApMq3qBMRWfHKuFjMN?=
 =?us-ascii?Q?89eUf8pdK35km5QjSL5L+i7YjKglm5Xm2FM/qjTw5BuR+c4M8yUvePBF7rTf?=
 =?us-ascii?Q?51AkQ1fS2VYwXRpqeG+wM9+2IMs/tLHAHnnxQQqnkcLn8mQ1Nd5MJjQPgYtK?=
 =?us-ascii?Q?MMYJMq9wyvMALWgM6tMHOLzHw24kF6qZqbXxhNK5TWcexDfqazUQ7rP/gfGY?=
 =?us-ascii?Q?QJ8x7Ss/OZFkIb1vkwVRUkADsf8JLVgYv6E1trMWN09LGF0nZzpiFStJrrHj?=
 =?us-ascii?Q?Vh2mCfKr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6caba4f1-44c1-4b81-1926-08d8c76d0c6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 11:24:04.5561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ec7OEdvzfDZMzxkZerxjNS2SfR7g+n1fdWLSf23wt8E6U01awnhQ522QQOYfrC02MCYNJeyy5IZORgHFWOpJsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> On Tue, Feb 02, 2021 at 10:30:00AM +0200, Avri Altman wrote:
> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > index afeb6365daf8..5ec4023db74d 100644
> > --- a/drivers/scsi/ufs/ufshpb.h
> > +++ b/drivers/scsi/ufs/ufshpb.h
> > @@ -48,6 +48,11 @@ enum UFSHPB_MODE {
> >       HPB_DEVICE_CONTROL,
> >  };
> >
> > +enum HPB_RGN_FLAGS {
> > +     RGN_FLAG_UPDATE =3D 0,
> > +     RGN_FLAG_DIRTY,
> > +};
> > +
> >  enum UFSHPB_STATE {
> >       HPB_PRESENT =3D 1,
> >       HPB_SUSPEND,
> > @@ -109,6 +114,7 @@ struct ufshpb_region {
> >
> >       /* below information is used by lru */
> >       struct list_head list_lru_rgn;
> > +     unsigned long rgn_flags;
>=20
> Why an unsigned long for a simple enumerated type?  And why not make
> this "type safe" by explicitly saying this is an enumerated type
> variable?
I am using it for atomic bit operations.

Thanks,
Avri
