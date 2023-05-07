Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399BBC77B7D
	for <linux-scsi@archiver.kernel.org>; Sun,  7 May 2023 07:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjEGHIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 May 2023 03:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjEGHId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 May 2023 03:08:33 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5499F11B70
        for <linux-scsi@vger.kernel.org>; Sun,  7 May 2023 00:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1683443311; x=1714979311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ecfj00oDCk/DyHnDn3aIGjje3cA+wWd4cgfPXmirk1k=;
  b=pWD1vm6pm1iMaHVNmv5KAMJZAkskLY2NQKG+EjphXbHG7a6jdt2HGZnf
   ya1hoTQ7qH9QDUUxcjTylfXA/XMQkys0hO9J/osXVHnTIOGdEJuE7GR2I
   8HLBKjWGLS6TlD2kSnPAj64Cnjq4kArDj6vO0OLafNybJnSPr5pXMKlLS
   zGeA5nZqMlE5rs+Cx9yBoqjnvwpcU3Kj8pScgCZgUh4bVCuZv9sbfrQ6R
   cHh/+xx6/ZRuVUjYmj4OuKwuQMHNr08YSrtJkLmPPDvWQgE+dIHU3YSNu
   1m57kJWq8qY8LQovUPNAjtCIdnYDQW98o6jqmGmWIhqQsraeusulIDNi8
   g==;
X-IronPort-AV: E=Sophos;i="5.99,256,1677513600"; 
   d="scan'208";a="229969409"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2023 15:08:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR1dKEJJMnKPMN0VpWliVqRRGCybAzuOUk+eSSsJbDr6jZ4UyDTbXMh9NhqJZ4DSIDm61GGN1bJyi5d/X0ROHJjA6QJJ0eOru/m3YDp7qpTFE2LkfN825eDvqMWalQXgSar6GUgsmdLLFiBrpYY/nWkRjkFA8xZylS9W7LkljJKJrilpN8/XmR6xb6qFMxZJW5gtmEBRPPbDPFyttqQAOnOJ+oNLJj4WIY2/bmbJfVyRC1sK2ZuI3JApiflT0SuC4tkV9VuMNFTqDQNRL8l5txEYtZwSoRJpvz2yHok36Gpj4r1pwTl2Q/xz3roRm8KQFEbH30X9vL2EuTSG6tknaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+zk84ultM1QsLntZ3wOvc6CAjivvATJNyrz9wAc1nU=;
 b=PRQn0r/cEa4ZK4XzzERKj8YJ0NSN4Wkz9/LHWn1Q2LJTeUrf+/03U67lEGgA/GmDKMVB4KpuUrs49vdwyV4EE3tfSEcc2lBdWjCD+/YvN2IONnLgz2GMknh6msd6LhE1uMVENhuGlriVh1esNEXGDQ2jydTpHHezH3AG3bJHBrjvqaxuuQQbJ3FBXIuwo7d4hosb1bIq2POwtGMP69coGOu7dKD0eD4GCdxY62/anIgY1aiTXm0kEVqdtls8KYaJXNW15QpdLJpPxEyQYB8ZVyWn5pfwaPPt/hVg5aYXv2yoY4hTH8E7Xx2Z66kgKBYZOcML+jXgcry/GqyVIAcxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+zk84ultM1QsLntZ3wOvc6CAjivvATJNyrz9wAc1nU=;
 b=ei3lA1ZbWCBzjNTsE9sstpCZ8Izol63q1cwqqLH7nobvuidFSOWhXNE/m5DtPby9hG01tjp9v5Xxp0Aiahd2Cm95Ns8loo2GTlbzrjwsXCgRA7OVDO8NIjBqzxkJ0ikSKZo1FadcWtWRCVmWvyvWJsigdGe5Xgf5JTo6djHJBaA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA0PR04MB7324.namprd04.prod.outlook.com (2603:10b6:806:ed::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.31; Sun, 7 May 2023 07:08:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::188b:9005:b09b:81e2]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::188b:9005:b09b:81e2%6]) with mapi id 15.20.6363.031; Sun, 7 May 2023
 07:08:25 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH 5/5] scsi: ufs: Ungate the clock synchronously
Thread-Topic: [PATCH 5/5] scsi: ufs: Ungate the clock synchronously
Thread-Index: AQHZfuNpSy9KXgfGc0KGKxgsDqFk8a9OZNOA
Date:   Sun, 7 May 2023 07:08:25 +0000
Message-ID: <DM6PR04MB657581B1396166C81E77A963FC709@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230504235052.4423-1-bvanassche@acm.org>
 <20230504235052.4423-6-bvanassche@acm.org>
In-Reply-To: <20230504235052.4423-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA0PR04MB7324:EE_
x-ms-office365-filtering-correlation-id: 69ce026f-184a-4b47-3a04-08db4ec9da08
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jWmPqUS85pbxMZR3WCVRx1AczcOLQgw9gHTIVR9KZLZxi9d+LHxJy1FpB7fTHBzOgHX0cylQhAy7HV6QbSKOdDXkNXOx2TTv/s3hIi8phCE29qUWXyilhpLsSnELgwL/09rPSXpekmElrqeIGWNHhBmIXKzJPFBOTuc8beTs6NPVZyTIl71U5SIY6L90/47B+IUdeet40Rza+ocX07yN2Jvd7ZhgoR0GFO2b11iIt49EJhZJmXMaRLDLmPVhQMgeAT4JKj6CqehRSaZ72/dyWP3hak+wASFteopirdafNhcirUrulmV03TJvKdUI9dwXBlAmztLuinZoLZHksCl3CFN2sLUPCVxw7VAw3uyVE12BwH9S/dEL5yB5O1Kp+NPofqdcgQFaKTzvgW+T2n86yIXr6g0uvkecTFS/leAorwqXDh9A8QJr9dsgVITgXX/8xNAonuMYvEGvgLULYydwtdDtXRJ0I0fw0ppVOu9QCe2DrGuRLhNT1pX77uPe0n6e3GpN+lY+NDdiPWmMU8nkLS5eWbB6siZokru4SGNL5zygwS9LBlTSLZrqsqaaFEuVdWlbKTpWsUnQnoOTOggyd3SyThmM/FDC1msi4WIehouJBI1F4kR5k5NNIP4jpi0l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199021)(33656002)(558084003)(86362001)(54906003)(110136005)(316002)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(76116006)(7696005)(71200400001)(478600001)(41300700001)(55016003)(8936002)(5660300002)(52536014)(8676002)(7416002)(2906002)(38070700005)(82960400001)(122000001)(38100700002)(186003)(26005)(6506007)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s6yLLcxx6mlEVm2k1WKwat1Ro74Bq58UOTlURk8SY4NKK0hBBBdHgtV6yeUc?=
 =?us-ascii?Q?8qBIjeVjn01aYQs7xBtshdMcfoe+vW5nQNhPXKGVnIwk+Qg3MK3YqMrL6bW+?=
 =?us-ascii?Q?yY8+jovVgJJc9XQXg5x3GaHTBXuo3j8W1O8kXmk5fn91mJJEEpu7H/gLDdJh?=
 =?us-ascii?Q?s6pyKhN+UCxQg/2DH06S3Sc2v1T8a5CeaSY0KifPfd/wSpg1DDxItgQK7imc?=
 =?us-ascii?Q?b96xlzCpaUyiKuFFY5i3jVNN9Otw7NRR5anViuT/fAUaJxNWKq7p/8f7fTAT?=
 =?us-ascii?Q?vINpxPDNOzXWvefPP5nTswaP8HceYbKuom7eHDwjiVfh6sv02RZ3iUaXNwjO?=
 =?us-ascii?Q?Up5zH07FPy9UFYNQGGIrQp6pBO5z0Nv+jhhM02BvlvFQZoCmUURpkHRKvB69?=
 =?us-ascii?Q?pB5xu6hYeP6jgdh8JaJxQt8X2b4m2y+v40m9wp7vkt77ken5rOnL0p4sL+uS?=
 =?us-ascii?Q?o4ODKhaQCz/0D3AGfHpxhPunmCpNrE8Bg6Xydpq4gmy6tF2tN2Tn8eirRE+L?=
 =?us-ascii?Q?EOp4QmKt8GG/KbXFK78i8pFbHdVjhpyqVjgHOUwEbdvDpl0wUOL0oyNp+on9?=
 =?us-ascii?Q?p6MkErERn3BiXW1sbO9roL21XGU2/3xxJWFbZOKo/joNg39/IWwp/1uU7mko?=
 =?us-ascii?Q?4agx70dq30JNJIb0wWbOZKFIB9PYyESjr7G+TsdC5E39k8C/W5Qe99ajAbJW?=
 =?us-ascii?Q?+twUTLCdTkAbLiut0+oD1xNDZ+2ZDx11txPTruFgTqQgEx2+86DWiCf6Kd0w?=
 =?us-ascii?Q?ioe6AgNx8KY/zrq4EdOrpl3JqeSlq9uidisnXOv5CjM1S+ZoIohBiiEK4MGP?=
 =?us-ascii?Q?nE8cOe9sW8DIroZUCnzdNypbX2fTzrqix+sKCaaVYbGklYm/UhINRT3/s5tn?=
 =?us-ascii?Q?ns6m+n3hnwY2OOTdNfEno1IG3TdusmdlzZnolNxxz0Q8Gi3IyjCay9tI7OHv?=
 =?us-ascii?Q?7HqkaWqBnGBbQ/+MSdHotKLrsWIbu1baHkjMINqvcZbqmUfbZoHv+zmfDz3/?=
 =?us-ascii?Q?p//9IAHKe+gjB4p2degWzDTVytq5muKRjU4ejcvxagBThKQ5AcvBoLngOjEq?=
 =?us-ascii?Q?HkBBDLNuRsEYrK+Lyh5y4IWZ/zE40kSJ3jBFOVCJ+y+wh05R3NMd7nnBeDHX?=
 =?us-ascii?Q?mBjLoWSirwYNFgn52irzzqN2WeOWqLTey1Ye/E5dhsdrI62uhrzHD5DWO25i?=
 =?us-ascii?Q?mK7VcvF09uXuyeVVCbeCftqVQqiKDhoT0DHxIxEI6YgbSqBDBcvr9QTABpso?=
 =?us-ascii?Q?t/99J30yyWt16MSuRN+MDdLij+2/MQLE5s5aa/XMuGv733neJcS+A1vbC2uf?=
 =?us-ascii?Q?TOlSJg/1yeWCZ++SuUH8VcZkD2W8oJ29g/rGDnooYuWu6BqZxD3Grxqn2RwX?=
 =?us-ascii?Q?C7AuzB2n4Fcsxpt57VrUKt0jzTi5ZOa5ukulRUJDJHHzFkzrybJeGk8oiqF4?=
 =?us-ascii?Q?kKJafjR+1x+QsiWqecMCu1h680zT5VHDZFr3XtVuAHOu8gHasMDJOVnk0Mmm?=
 =?us-ascii?Q?ruk7QnimLX/NLsepGo9mqay+m8wWFdWt7vedr75uiS5VWFFbUrIGBqiWsvUm?=
 =?us-ascii?Q?NP6T54HlDsjKOckaKAIPF30KAbkx5GSS7TYDczwg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?2dRwoEkB2A77yu4yeYIucIFjCcAk6CDb9RDE+nj30k+WSumzVdFwz58oESyS?=
 =?us-ascii?Q?hhJMGFK2fJZjV/3/sruye0PBNJ6UYnxEilFtNI760OiGqjOkSt5sMjOkNj7C?=
 =?us-ascii?Q?9LkXdCLGGWNAplIYv73jm57UiCCaVXFrl+6D6mGztqLHVeV7EoAS4yOO96L7?=
 =?us-ascii?Q?ts+9dE19InUWI4osVOWLjEswzmk+G/+gILqSK/hWwO49IUlyi/VhchK7344+?=
 =?us-ascii?Q?ERNt1Wg87CJf9UofPFz1PVZC80xhKP7uH7kwsQ8m12w84QXB8CfsSWS3d3i7?=
 =?us-ascii?Q?8ezo7mE+moI4SjJY9hU84g25QIK+mosPMX50KFLmyAL3AhUgYJyztxzY87AM?=
 =?us-ascii?Q?/y7eRilBbaeey46zgU/OvPiO9Nx7mt9Ao7NGyVsUiwO0fmISNO1tfpr/GNzd?=
 =?us-ascii?Q?uU1AnJFLAyfrHikQhgzQNUREcTOzpVEKHn23AEWAYN981LPZ0sfKIgV7JhvG?=
 =?us-ascii?Q?d3FxdVMPBjW1571PPL8eo8kTk9RJAG54LPkriP/jvRGG/pqLqcklkeZTx6K7?=
 =?us-ascii?Q?s8AX8+Qg9iIllSkbJ4iltjbUdhYNftlVI+AIIQLqjFgfh6SCTJ8qIZmKLiOC?=
 =?us-ascii?Q?J/XIIFUch4ZhMp06msNU2khOWXHzKXmP7A6P6VdWnYDeDHbN1r8Q/9K2ZWMg?=
 =?us-ascii?Q?XFeD0IS5FH4hhB/iD7cE5qciXrh6/TyNMTEdTVrNOdUi5+QBXqRDu9yG/7J1?=
 =?us-ascii?Q?RQkFqOQRDAU9jgncvegm1j7Jk9yamslmNmn6ctbK7Sm12/RtQJP2WUi74QrQ?=
 =?us-ascii?Q?Kyy7h0m2h00LcSWp3SF2VH8g4vX5GfdOkzdJq4LcY5DcCIGNTof+C5lMHj+2?=
 =?us-ascii?Q?l58pDR00DsjA++g/HqFhqXPSMgNPTKN30DZMXi3dZ6goIknsjMiOIz3ExAFf?=
 =?us-ascii?Q?UBZqTkHrGL55+2sUdV0uvV6rhy1QF+RlIwEcbwdTRg0lG+4kgf2VyQ63ZXQz?=
 =?us-ascii?Q?GFjZG1JRU1DMhBwDUT+Jhvkua2aeDe0ftCGrXp3LOSBP3XN6tX5mDLA2dXwr?=
 =?us-ascii?Q?eZE33cT9DZKcLyOF+tmacP9YavG98QUuZwIQkWXyCIlppCUVg0LN4ucrpi5w?=
 =?us-ascii?Q?EUM+e0NkVqy/Ok3Qk5DUjqAnXApAag=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ce026f-184a-4b47-3a04-08db4ec9da08
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2023 07:08:25.5902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0yXjFLoNCoT7bb3Va44fefoYJULW7xxjbiy9kXL5qGro/TMBXJdyOAeU482pCvJiTWIf0pxnKw0eyoLFeAnTjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7324
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -int ufshcd_hold(struct ufs_hba *hba, bool async)
> +void ufshcd_hold(struct ufs_hba *hba)
>  {
How about switching to the block quiescing API as well - blk_mq_{un}quiesce=
_tagset,
Instead of scsi_{un}block_requests?

Thanks,
Avri
