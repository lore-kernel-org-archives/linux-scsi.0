Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E92C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 13:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbjG1NyG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 09:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbjG1NyE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 09:54:04 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6082D61
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2023 06:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690552443; x=1722088443;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o5W/gbF0f4IDveoEPq71qoWy3HWNH0KeYLNOJ+PwqtE=;
  b=OG4khQSyDDYqECmvEkAMERfGA8EwKgoREn3+PYQU0dyLqzByfBg4wNuu
   tBSCHAk/Ape53U2kQF1gAjoslNs55Ox4m4OO2mbEKsM0OEkrB8QLibGxD
   yN8F4embyNkt1b8X+goBmiaRxXjB61ybemiA4wvnKp5lNwA/F790EHsjY
   09NqqOAfDMgpJ8jcPP59rqr/WgoqHRUS9VvzRY3+au7JiypC9LXdfJFY9
   hm8/WwCbJpfusPzo1aX/nR2/lE49If+5uVIDCylLnqNgoQUGz+2N+dqFQ
   gScuAWgtVdCLMdIT2QQ4HkMup5CLs1Z2UYRDXX1gPo2CvpeOTQIMj7Z7Q
   w==;
X-IronPort-AV: E=Sophos;i="6.01,237,1684771200"; 
   d="scan'208";a="244017309"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2023 21:54:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfuvFCswAigjNvFjMxYJ1LAFDOPmfclM7thhAm1wC4OXxk0aTX+BEpZIvXiO+7Qy4gvgy7n2wttOTZxRDztjmM1xGCdK9VxtccDib8uoeWpGDno+gIUTAW1DRPKyM3JFSSLFrain0cgcBBjHMBKHFsAcocojgOtt76QLI+KWoe0BIgN1dN3fccm9jFXOLNBKXfhvEgHKFbbYlP4bSdMfLiYYINXkLcNQJhodsQbOl3hyMFEea4J18nsrPbt/+4vg5F3CVFhHAEDEUksQC5HgSQAIvQoGsHiEBGEOqbJb3NIkDl9gJaNZffkrxmhU4OWX98bcu/c5cr3h4lPfwuoJug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5W/gbF0f4IDveoEPq71qoWy3HWNH0KeYLNOJ+PwqtE=;
 b=C11zWYYQLqoImVXHoVKQb7KIxJ+wN8w0g2CulVTapq8KPTuDip2XHjm8gGLPTHAv3vHdC/fvYew8lvseeeIKW2zNUhuUkqg9milsAESXmappS+NOkQqsk/gbg0x5yPSm2wHgFrRfxgZxTcnCXKn6kCEUgE6Xulf8pEkQIEwJmZg5NBYKxUeHc4RH+of0Tugy8tbIg8tq8rkBZf1kKj5iqx24a13RXmqU+v5u+OSBN/kxwwvqBrV4uhz4r/ir9V816O7XQsxBV54/fbu4TVVpJX3JOz5qFmB4iS9lS0gqHvWfAIKIvKCT1lSi/YF/W9A8N8M6H5WhWUsnmrOSppgwYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5W/gbF0f4IDveoEPq71qoWy3HWNH0KeYLNOJ+PwqtE=;
 b=RvJbRGhvS171OyIs2kCMR2gNdPle5+KtBLaPg9PuCsxjq9z5IcdvTwAmxJhtFDwpuPCFVPLdRuu1yp259fpNCMA6+jWTT3UhZ78LqwKcjE3aZ2gUZFLY8XTr+lvleREjArDU3TMtITfT6P++9OKlF4ePYsbN0HHD30pKlb1lynw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH0PR04MB7334.namprd04.prod.outlook.com (2603:10b6:510:b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.29; Fri, 28 Jul 2023 13:54:01 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 13:54:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: RE: [PATCH v2 12/12] scsi: ufs: Simplify response header parsing
Thread-Topic: [PATCH v2 12/12] scsi: ufs: Simplify response header parsing
Thread-Index: AQHZwMNyCQ4MLSFNCEW1CBuAZSLhdK/PNDGQ
Date:   Fri, 28 Jul 2023 13:54:01 +0000
Message-ID: <DM6PR04MB6575737BD21A08B19F6C074BFC06A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230727194457.3152309-1-bvanassche@acm.org>
 <20230727194457.3152309-13-bvanassche@acm.org>
In-Reply-To: <20230727194457.3152309-13-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH0PR04MB7334:EE_
x-ms-office365-filtering-correlation-id: d0bf2248-0e58-408b-8f6f-08db8f721912
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Vt8lxilEKQN1XMZluWRwzy4u8RQvBrcJak1JM0JsOqvZWEKzNShd9XjLkwCyt3+cA1HarjBlMbnwD8z5sVMP0kdk/YAhyk7FLOkbVMcEr0WtfFRGXCf/cKdLPPIqiHbAZRUm08icLgOYD4mbxOqyzJKF5fsbrjZDu7IUs1I6f+T6Pe4kLIQ6wLW4WH5QDFyyF0T28P7eFyBnN8i6598jAYO2ZZ+C8YaCeDOb7ggaR6DAG9RP9UgQ1fwv+RchUiEwF0L1JA9E3a1n07a84u+Cb+yHRED6hclEThaCnD5Q/XrLITVcx5outpuJVnRBsDpeIcE8HrI5RSHlg7/16byDZ5bg838k/xiJKT1g12qvqz5Td1nBykpZcF740U3zkkxwpyeFHjiNbvaOL7igaHXCvgPApHVy/25zqxFirDP1OuJcmUHyMV2V07ZbPPEq8lG5TFBBgZcyU3oILelZNlcqOskOd/UnPTy+r3Br1mXHEdQu8P0mlhiSECRNZgdytDlQK+HKlDOqaObETckUrhFfJNrTDOvgC3W7lLkTIqWJfGXJNWRjecnLskvfFrFNQEH/+P25LxkkqTGu2NAIWvrw8AOU7VNgFJ/reHXnOG5SSYWUc4Y8SFdhjN1kqvZk7RB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199021)(38100700002)(55016003)(54906003)(66446008)(82960400001)(110136005)(64756008)(7696005)(9686003)(478600001)(71200400001)(316002)(8676002)(52536014)(41300700001)(76116006)(66476007)(66946007)(8936002)(66556008)(5660300002)(4326008)(122000001)(186003)(83380400001)(26005)(6506007)(86362001)(38070700005)(558084003)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g31XiU+IZEg4q2Gr4H5gfu2jNYgkW6IOFrqVaDQ+f+cYDPauNn5YwjaJSarK?=
 =?us-ascii?Q?4aD6ILQ05Tv4DnzkpLtvyWdllk1bIqL6Sw8p1T6Ba287bwQ1B4zIQ65tVN+t?=
 =?us-ascii?Q?p/ESrvI8DK8Bu+t3hcKFEKTVmW92TgOfGZ5Q8A53OXLIsmGrWRTjXEAUD9jT?=
 =?us-ascii?Q?b3ZcLJK7HRI5YO1Q505wmP5qdWD53DudF35+AG12Ui7qk8rNhTgFls1TtzCB?=
 =?us-ascii?Q?/ML+rouPYEtvP5nsTzaQN9/TWcJ2Oo+81N9Ft/QpLZqaUX/eQmQbcRjjlMed?=
 =?us-ascii?Q?mx0Jr7PgRDGBUI0lcbtRpMYYevm4wUs7IKuUijnNrfSMjTXHEbA9EGJhpNTk?=
 =?us-ascii?Q?rCmpIUdwcHbrQA4N/MFyvZSWe15GdJiDnaerz5ob/KROm1gRCCULvFMWK5Zd?=
 =?us-ascii?Q?EUsiwHax08uN20yxuykQK5zxKxj7auu5xGKEAElrwNhol/v7DQsuoVzW3+4r?=
 =?us-ascii?Q?vq/I9TqPaGGzJ0tBCD+CGyb3UtuiUCV+xavOhV8VPr3M64TpaP4xSRQReMFd?=
 =?us-ascii?Q?ifxqDAI++RW85byl+TT3J0DjKzbsz217nB30ZvX/i7vZcUu9g5vgk+TSepVy?=
 =?us-ascii?Q?ip6nttYKaZeqPKWfr+nRlXfabUZs2O3g5YSVeu7Gh98QDoq88kZSDqgqlI8n?=
 =?us-ascii?Q?S40iTf2qiu0URux7zJ6+9qeG/eyyBdcUzTTyfChSj2fIpvE58YP7DZseZGZt?=
 =?us-ascii?Q?jXGjQe+hfCnq3Li+YUggRyfIYJwimPOJDFdjOl3Yux3FF3s7K+aIm7MNZ/z3?=
 =?us-ascii?Q?EO8riho1Hb9d9nVifxL+z1bwZo0Q71SSVvQm/B2TLdtvl8xrJng9SA3Lux9y?=
 =?us-ascii?Q?akqE7+AgU11d3NnuX9nZ6iRmoLC7AZ1LDgHxKDHSKCFxoagaFkXsH9fv4cMu?=
 =?us-ascii?Q?UGCca5ZcPl2AjN8NV5OY0/B3grBJrezfRKBsSXBm/pWTv8GxXZ/J3UCSLgiV?=
 =?us-ascii?Q?prJwMe6eN2zSr2Z5LTwP4nBR8U9y2ScAOIzHETLvON6D3cWAMW/I9fVN/VHj?=
 =?us-ascii?Q?y7XsIC3yAdbiSz0JI47Bwd0VmIg3qobn2Ck2z+qnWPRhkkZeHw0BUb6rysYS?=
 =?us-ascii?Q?444ltH3kJb/uW9J1ZhQTbUp2QGA/6i7la/0JYcml1bzz8jKnH7VXH6W0UIQt?=
 =?us-ascii?Q?C4I+CjolaFMiHoKP1qLDRlM00mRuPqJb5H87y2HwdFip/CS0XIkgaWNaN//G?=
 =?us-ascii?Q?PBNJ0Mf8qwmjNxZXOQ+POFZRNGDxXi8DXlxUHfONpitDTRZyhfjkpszcd3Sx?=
 =?us-ascii?Q?OIVCo7dApwYtNZicPm5p8X0v4P1p/rnBDsLbbTfEgFZyx3obz0QsnZi9oBsq?=
 =?us-ascii?Q?nqqOUZUiQ8+yFE4XtcoqQyuq46vHxuNHMC/G8ZQesCsw3Irq57hJa04OKn/6?=
 =?us-ascii?Q?TJZ/y5tcwP/BJAB407KDhoNvIv1Zg4b0GzodxAxO9kDlX2eA6J+CE33/7qeW?=
 =?us-ascii?Q?azsAt3ztE6Fx4IvVDLcR+6DjyDiKNfQzUQZiB78lU80JtmQcuMTTENkJdCdb?=
 =?us-ascii?Q?loA2FpF2XVYfhJQPcs6zIT0C7HZM3KyWqZgpLyQ1EEujYm+Q1x375ncUrUVj?=
 =?us-ascii?Q?0m+os5yHdWUzkv0D6ZiHoo8JMoWAcoAfjNpYN/zZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?WqZfQhNBZT7R8R5/eaS7Ilxvo/plRkltVnD0t91ghh3GRmw1C95lXGTVO/oO?=
 =?us-ascii?Q?edKxdNDgfGjeHfQnZ6xMW6Gnkx74KA1SHYt/mGEUvtwnB4frdLQ2wS+lXT1z?=
 =?us-ascii?Q?fZCDOO8KdoD1SLa9zyvsWtgZJP0qR3nK7t3Nk5bEbt3XbjsNeNZmi1p0lE/w?=
 =?us-ascii?Q?ziSURhaNk6jIS0uSKw9B+979HFREUIJEbwqp2WVyQd5PwpiF5eH/QZrJ3ar8?=
 =?us-ascii?Q?9hPy60OOCeKGiNB+USA0QvXguydLZYew4Xz28ok8pcw3n5zzruQbnoNxTXii?=
 =?us-ascii?Q?LCSXebaOvFgvrMW4RQe6VsNE8xQn5GLCjcGx/87Mg11mStedj/U+gAQFOkY/?=
 =?us-ascii?Q?E/U3GgLIq/sCDNha9xfqO9/DK/aOAfP6xn3qMqOed8BpYyO+xBR8gNaliArw?=
 =?us-ascii?Q?UI459Ysczv12Gx47fS+h9zhNsq5ylf1iCVDEzJH+6Q5OCNAguy9ZWo0HCRRb?=
 =?us-ascii?Q?AaKiZ3nR7Cx9CkWQciPqoTnksIhZtcVhezW6UAioiFLvHEXVwM3wM2s7p8uR?=
 =?us-ascii?Q?HQLv2lYYbnkjiStHh+x5IyyqtGbjqwIq86dcG1YNPReXtD3qv9UAYG6jGgfP?=
 =?us-ascii?Q?fQubRkKOMy5J7pJy2xl5JDVwYhCvRHP4FwMW3A+axUp1mrcyJWrfFMaApF2J?=
 =?us-ascii?Q?dQQaDwuXT4cw8WrudpnvzOZsQhX+bhM+k3pK7rAh2OogINt5d3DIAJ08NB3L?=
 =?us-ascii?Q?ic1mNJOGIcPzFzGdbTsvSGoXeMVigUaKHMbdEccQiSl7YBFsLxj6iMBZVpQZ?=
 =?us-ascii?Q?KYMsWO77N/H3fsr5rEX/VnoeVn/hivQyYSOUESJgO0pP9YNLLEe4D4V+AxfS?=
 =?us-ascii?Q?M8QDL4dCLbPmqEVCrUBsgTTaVikAlp22UekwO3Agnjd7SriNghZ+INTW3V6m?=
 =?us-ascii?Q?/5LFW+rVuuBjQowmKKUGo8R+K7rRSGFpm75kie4nwT0BU568tl4CkGIlisNB?=
 =?us-ascii?Q?4332kXeFsfgde0HgZRYgImqstPwr06jrPAwAACD+zBA=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0bf2248-0e58-408b-8f6f-08db8f721912
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 13:54:01.2147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+kt3kvJR+/CIh98Bn7OlX++yo0Kdc0Z4Ou2SOTkuCOokZIgzXuJu99l1nVAa55BMvgxNZ4PU2/hEjDPihalOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7334
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Make the code that parses UTP transfer request headers easier to read by
> using u8 instead of __be32 where appropriate.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
