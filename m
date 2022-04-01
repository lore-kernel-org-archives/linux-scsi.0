Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6219C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 18:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351446AbiDAS6c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351447AbiDAS6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 14:58:31 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D771820CF
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 11:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648839402; x=1680375402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iSZky+wJ6+gRW4hGKlsvUeO9hv9GJN4sMP4ko3Y5tso=;
  b=l2rwNKeu2KA4p95nYe5vAobDNoNFhKzdOAI28mpBHTIN/ZPpcWo1MQU+
   tqfz85kbKjiCm2akAKPkleLRsISrvNJ5Y/uJIhvneFUwidaod6hHz7ka3
   Yt4yPz80dEl2RCrB4I8Ru0s/2zhtabjFU/w81Ougi8Yzn/BHEbenabzvt
   bkRSuvbhRwL7selgOBMq2ZL05SwSMLl5y3xGVlkZba/kiIkSU/fPU/9pC
   4fQiG3cwaeE2AlU/CuETvhaLUtPpGv1kpdZZsOW6DkXSFd3+3FK+aF/AD
   SrbGilUdBKeGb4bOiByPvsl5uYdZ94cq/oBlKZD4+4lUUHRaP8sE43tjb
   w==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="197776489"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 02:56:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfKa8MuGO0Aa37PB1n5qE+bOUjwNF3SpeAf+BWPyCcUVb7zKwdAoKrwYXQpRgXdADR0O825GUSWWvw7BGDWm7Q3uX1mGfk8p/yTyHAsKieRkw81jUisAMsF4HXhBUj2hSBHYmzyMwxqT8zY5o/RmQwSJlpJhfVoLbTotD+sXsecsOeuZYjBH0VVVNceQlAXZwS0QIti0HBCj6GTiHUSm+ldjKfG8f0KcoX+/Y4Tl5efm8pgUMs3AFZ2IQVSWG51YPepOj1m99JmTUHwEMIQSkCDuSCoQSMIAHovR/RW8kyCOhkv9u0m46mqDIe9T8qCseyNUT2xXZQ6pVPr4OvJxDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSZky+wJ6+gRW4hGKlsvUeO9hv9GJN4sMP4ko3Y5tso=;
 b=J2vJjOyzCg9naw7++lfxRyQnyavF8KTYeOMp4+DkRzpJDNnF3ujBTa38kpEaNGsKTo4E/K/LmEZgj6rgjl1h4wJUbXUdQy82VKmJeZdYNWvioJMUJNq8En7/ADB/Gg/hiyKm0Qm0N5lqRnMA8y/EIkxTr76NWaIoaonRX4HFNMu534/qxsE9z3BFNhgdRkkOiUNXX5S/sEjR+WCQK/pKqVXtX3jCaoiri85GvQRvWJq2eA7EvvzMO+ARm/DZ4s5PfpTSI0VX273MYuFp4yN6KZZL4u88ep4XvhYAitDv8R1mrjXwjH3KM3YcMcY3QWX6zKgBALbjIDVepic4oZbm9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSZky+wJ6+gRW4hGKlsvUeO9hv9GJN4sMP4ko3Y5tso=;
 b=duB2Us6gvWqt3QJPTGdVrGUca/0HFjwtQIzq+1PUWe/KnZTVN1LEouknOZOtF61JNHyIeXIhPRsaA8PbW9BMkqA3cI3scNxzAaZ0IxQM4MsL/mmU1LPh0XOgaQ+SjRYVDaTjPjPzsY46/2qd8x8HF8Qpir0/pvtIn6PybNRhsVM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB5319.namprd04.prod.outlook.com (2603:10b6:a03:d1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.23; Fri, 1 Apr 2022 18:56:37 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 18:56:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 04/29] scsi: ufs: Remove ufshcd_lrb.sense_bufflen
Thread-Topic: [PATCH 04/29] scsi: ufs: Remove ufshcd_lrb.sense_bufflen
Thread-Index: AQHYRU+bY98Dt5jj/Eu3Yhu2hnwFzKzbaYwQ
Date:   Fri, 1 Apr 2022 18:56:37 +0000
Message-ID: <DM6PR04MB6575205BE01398FFC19BEC9DFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-5-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc6409b2-eb33-48d4-4536-08da14115969
x-ms-traffictypediagnostic: BYAPR04MB5319:EE_
x-microsoft-antispam-prvs: <BYAPR04MB531946DC2535C3BCDF22E16FFCE09@BYAPR04MB5319.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2YqzgESlPPDUudMoeuJ0ild5Qz3p2CC1Zni7B3Q79ayWAoavEr9BG+PE/PUwNqQZBXb5IG5az98qBF762PlNRGjIWvNqCnHvsjqAJTMa3ATCezxUWtshDP1Y9pNGzZ2oMnI4rHNO2J6lubg+Pxd2OvazB9EMAq+qkq7Kyh9AxHFm5OlXevvZVFFFRlWrDcC2pY8BQpDUEdqqw56QWIUwf0Hoxsjjjs/25EPlsCMKFGwQGpEXp4+ECXjUp+CxqZi+4EVpAHgRH8Ry4axNSqBPlJvPdCzVQ/NnponoSlz+5UZOm/cdkEli3/p/S52IbHm/mWe4g56zynlgUbFpLjUYymWZpVwllrNhLPrSHvyM4YQ5vzyri7eTpfirN87azqZKDikpm+D4KniuXrMM/JYX6NhfX+3aJ3fIdII/Tw8IYL7oucSWP/2gnZhy4nyBEYkS1B/UcBthEDhbwTrHmmCn783HpG95utcT+Wh41UAt0KSd06qZRriQ0m4bALrh5SgX/2PyuiIycRz6AxZJMMvcJm5RAuDt2j7oQnRynlLxkvSWpZnUogFfOtfth9XHlrwlyaQkWQ2nQENCrTD10YJFuYwT5Q80qD15JeuCTfGqrvUCXuGVomlen1pBh1bjUkS14qCZ3SCzPD16i4yv9kr1Pkn23y2x7ilUaGEkgWg3X8z4gE7qUZ8xo+/UJ61UXxSJ74XUbYDHB7U0gtOVzgIYJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(55016003)(110136005)(186003)(26005)(86362001)(38070700005)(54906003)(2906002)(8936002)(558084003)(4326008)(6506007)(7696005)(7416002)(9686003)(66946007)(5660300002)(66446008)(66476007)(66556008)(508600001)(8676002)(64756008)(71200400001)(76116006)(52536014)(33656002)(122000001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2tLjoRi0vDDxlzhJxU4jCteQfFBDMyfDx4Q7ln/WrOBFUoPcrDonqdICdd56?=
 =?us-ascii?Q?OXALg7BAYQP8w2OXmoeNJGkY/gB8rZIA2tbxQGHkoWUDOtXSFdxo8kEEp1g2?=
 =?us-ascii?Q?gpOjg9wUD6tciWYkm5N29ZKHU2nl0lYCVUzi230y5pvpuuPsmoKlrgyYVbmM?=
 =?us-ascii?Q?3kzOApFYAbzKk2emLvCyWDRnrZRnl7bH7PdlZQhhkbW9jvQC0g2KqBQucp+e?=
 =?us-ascii?Q?sksNaV2YlfMxHyipE+jQXv+pPqUZMqYwa20LjGuJz66mvfXe9I4Rh7qRpN5J?=
 =?us-ascii?Q?vslq7tvXAOVSB3z/M2F6J2w+2IByTDMQM+RUF99hQkHoSDOA2Lsnfa1xdI21?=
 =?us-ascii?Q?jFfXsJlqNPOvXdrn5zus9QtamN+/SaLqBWuxCy4VGVvDdz3xNNIllWqg+ORD?=
 =?us-ascii?Q?zDyy9NVGrc2x8pktIDn/AE30aCE8bHgteRvF65qkpqy+cYGEQ0NxlHTc3OVH?=
 =?us-ascii?Q?Qmi7vr9SXbsImBj1hZjNex0B8YvZdzlXRJDUtrGZuqgooPm2az3Cl1Nunr2v?=
 =?us-ascii?Q?Y2eY08b0ehd7Hgfew8q52gX/K/Do8vFuq80CocALGUwySqcpU4MVa9JZfNIL?=
 =?us-ascii?Q?eYSUG0NMHKReHh3I4dnx3gwvy4m36GyMG9hY5ZvXGLofBW+KJ8Hg70Io4p2d?=
 =?us-ascii?Q?a+AYMSBAJt0TvZPESRJRVsSGLg5woWDzQ+L/tJmiX6TvLaS9YQa1F7/SknZU?=
 =?us-ascii?Q?L1oaFbXH9BkeaggW05KzEiRnS0SHyuW/IG7vUAm4oNkQic19l6+gyEqwLBXJ?=
 =?us-ascii?Q?ZgZVv0SSvCc/p/YFtkTHeXtO9v8OtYr8JdWrQ9izVEDRHKJBlLO2C7AKF4vb?=
 =?us-ascii?Q?GmDi2lzKTjWsMEtc2FKPL0ZakrlzjrMeREcojIo+WFV15j/2ETaQleGdDigU?=
 =?us-ascii?Q?KfIpGZSdIh8eCi0BIgCis0oRE8J/14oFvWc0E439FgwwbsYSVLnVz2UcY8SB?=
 =?us-ascii?Q?MBJ5/qo2rb3AN2EaE6fQn6YWzgKwZ8L+TLzs2syAgFrCXUVotKs0UsOdHuGt?=
 =?us-ascii?Q?adFEcHPvkhfEH9grLa6GfZ/sNH85kSYIp2QffjXrgY10j9s8EuEYv9VRuu5n?=
 =?us-ascii?Q?ijMp5F4Trn7J5l6Mf5pDrpeH3otxQCSbwkMNgUt9IfPZ9/vprluT/KwAcVFm?=
 =?us-ascii?Q?CwS0uH8QPW8zb9i6HXnc8R25S0WfzlbfNNLW/eZ1Q/edojou6NAvl1q1OLm1?=
 =?us-ascii?Q?n22ZY95ZcPjO3ZOOL5cl60omEy4yJp2zz1Gm34LKFmLVCUtPDONHoYMHf+0X?=
 =?us-ascii?Q?2BgM+nG3Q1TYgDl0LEd1dE1P4nieIhcokmkabdFmJXjCrNruEjukUtbALFiY?=
 =?us-ascii?Q?Z6h598z253vqrncTSbqDVrM4AlKqe2Da1ziVnSYaiWtcPVBVvEMMyicSnusN?=
 =?us-ascii?Q?87jMnjQP8OyLGNXkK2VXf0BQz1o8mGzqWOSP+XRtZJuZ3c5EjeNjzvcbzCZD?=
 =?us-ascii?Q?jYkMSBA6pSKRgteDTA+hUxxwZt1v1cv8PgVJC/uDUeDAQss/liUJy9HELZcI?=
 =?us-ascii?Q?h5EB4p756V6i+Vme82Gzx5V+mVVNTqgXK5Ds6pWmdR6VNG0SVqkqT/Ba/+nU?=
 =?us-ascii?Q?uVwAOSH5jgPHrlFSeLdBluiluTS2MhzxEFSg/WUWDYr3M8CVGQQFXwp/oHzI?=
 =?us-ascii?Q?DEBRiAevqr+Gvoebc0Tr21nHMttk135E//L20p8c6Bh26kDDlpszftKkB126?=
 =?us-ascii?Q?5ZyUNHSj9ub3iCOUUTptQktoxkPIj60mj0J1RADwU8xbXkVZLlFExjKDRZZo?=
 =?us-ascii?Q?5NHJIy08ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6409b2-eb33-48d4-4536-08da14115969
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 18:56:37.1553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3s/euRX2S3slVefKgpRYmXcl8RFwCn+u4vdn2rCnlsOMcUxjIw1HZwtD7p/UqKSRQpEGgxj4d9UR7fywslUyzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5319
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> ufshcd_lrb.sense_bufflen is set but never read. Hence remove this struct
> member.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
