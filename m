Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42822ECAAA1
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 06:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJWGQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 02:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJWGQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 02:16:53 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC260E85
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 23:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666505811; x=1698041811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UyeqNVhIXpeDu/VXO5jsWMsaPfABDfJ7yE9LT1OPflA=;
  b=eri18OuH+M51wbDK4oEv5wyv9re5uYdGV6gKZJT4s/bmmJiIzgc5TAV3
   X/YbmoAASFcKITagECgoDW8I5sdd0HfPem9qoPUhKuWa2mr5QXJApF5lv
   g8pLoCdRbmmeCiSQNCHxOYc83wXNF3i3mpckrQ8gi3SwwVZcLUzdplkIA
   4iOGnwXGS6s1/tS0vZzjV3+euJCCJlAx9P16/WJQiSj+9w6uoEvtcx3+I
   FtitcZXrY2D0f+ByKU1bVIayzvs4Zn7AEHQTznkYkT2V/NskT2PVTHHzs
   Ffi9iI4msylpuZ5IQqIqVry8jr1PLSjhqshcHdz/POoDcnO/gmcLePNxo
   g==;
X-IronPort-AV: E=Sophos;i="5.95,206,1661788800"; 
   d="scan'208";a="219684388"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 23 Oct 2022 14:16:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsSBCyC9yo3Nu37yTsJlp/Tr/cULdNDimPAOGxl0Ge9zu6oZJrUF4IDmeTV+8P3cJ+BOkUd4QLpK6Scpwi7CFwUC5Od9p13LIga9bCGZUwC7P+qU0akPE6Htx6cne5xb4NNi6+AJxCPXruhrcXrsctz83hrfhpBezxZLY1s+GcRS+DrwNT3Gr3RoNtgr1k8fggaODJ0W8MKngU7a+LyXXWCEStdWmAHyIcT9D8ZQ2KBbgwkntx+iwC9d2v+zFRY5MFH86d/uRotN5bDoXG7vbi9VSW7HL1i0YCBEPflknWpcYaiMOeuWMeLkGr/DuK4anvBdZT3uOuqSO2yAry1Wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmnXAGKXX5EmvlEr76mRxf4BHcHt5OKNfL12TCmmENc=;
 b=Y42tyRA7L8qtGqvj7pxoSBY2BWKjF28AQcvTPPy8JLdqFsPat+eZ8CF+3YooD4Wv0tZtcKIY2vzpZa5uO2BoLZaD9yCRYpxlEqBSFC8dx8P1URNwKsTf5CaX1hPXqvcEH6OLSHrJONoZny0iUZc42N1n4xGaHYgOcXvO8A15nREZ6E6qLZhqTm3GjL+t9ANVGea6jD194wQ3DXPZTGUDd99zrwwYXLRctD85nBAagBK2S8iha0ADrGo8QhndKOFhKrflGDNOc00Y5Sdr+B+bvZaS8PaFu+igPUsx1vto9+gusJbJHodn/yVMllDTWy0ohI88Ncoi+/FaTixt5lgdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmnXAGKXX5EmvlEr76mRxf4BHcHt5OKNfL12TCmmENc=;
 b=GdJMBgQKhHMqxyRfUh3y2jkS6M+VCxrFcDJQ4FVDpPlwonkGiY8h8sAqiXuQlQjElw+yNv+Yn+cIXwFMxypcyjkHJeuqKdQTwzkf5PC4uodc2Kp7B9ON+PSOOOLzguuvPR0dEffQss/walMDM4/buHLkd13UUaEAFqvKipVTQ70=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MWHPR04MB0737.namprd04.prod.outlook.com (2603:10b6:300:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 06:16:44 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5180:bfb7:53a8:7c52]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5180:bfb7:53a8:7c52%8]) with mapi id 15.20.5746.023; Sun, 23 Oct 2022
 06:16:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: RE: [PATCH v4 00/10] Fix a deadlock in the UFS driver
Thread-Topic: [PATCH v4 00/10] Fix a deadlock in the UFS driver
Thread-Index: AQHY5cZIUyfk8BIu5UGSp+A7Y8Udhq4bgQyA
Date:   Sun, 23 Oct 2022 06:16:43 +0000
Message-ID: <DM6PR04MB6575AC3D9239CFA6F8598EB2FC2F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <yq15ygcwnb6.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15ygcwnb6.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MWHPR04MB0737:EE_
x-ms-office365-filtering-correlation-id: 4cae23c9-62c2-40a6-f435-08dab4be27fb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9JR2HV010tJA4HiMMQeMkC2PhHV3wvrKQpKO5jK0YCMVTW/bw1L0fKgOs+2pwGnAvHDMrx9lrwXev4j15z150mmU6IZlzKWy167oNPixM/6ZtyHykeLUk+2SeiW4bGOzbaKkfaM1UmR0lYVXb0bWv4i/KHpwi7Bi5Y5wXLCGNGgwypDXaCDbw0BKIxyj8vi9PPksnlO5a5WB9Kwq7kDuiJQZ3YefecssL38RM5cSG+xe1rnFf2HoxR4DhTV+gaQbnV5DA3OyTUhtyZDnGQL4c25q+jatPydHaMWlUcBmgzaOpA7A+h1ha80jBag32u/4OGEko7lUOkspihEyiTREGcaNiLymiYKzXufzo0JU9NaMHiCewvckjoZDetpfuZ4jStQZyWs+nwuE9svhmoMBlYP5f2Qtff/FOKVSJBp4Z4n9ypEod7jDBWH5Mov9RyyjjBd4dI6P+l82El7mF5Ocw+CDsTsYMP/8Y8ON2bdUfGWOzfWx4ccIzuSqVzB7PFbBbDrF0FhAz5BLFz8ueHNSJdoqKnOMDWhAnzaM2SzPNjIZ7QHDkJKs+KCPTWijlAWEsMjd3YziSex9NXbUrOXmyW7uY/tVsm32B2hJkdIC/R5mLSaayhaC0RIRYjbk60vbn5OlLAR0b0mc/NAFfp5SZczZ7C/LK5qQhUPlgfoDZl1cnrAVFWXoFY6SWw5qOtmcZX3Ba3Ozk6ZSD/pilk44dEI9mILw4K5Z4lXB5SytXibf2g2rQF8aKwTG9s0/ksZAx+95zyR+hbUchizzJw2CPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199015)(55016003)(110136005)(33656002)(52536014)(83380400001)(38070700005)(38100700002)(4744005)(2906002)(478600001)(5660300002)(54906003)(66446008)(66946007)(8676002)(66556008)(66476007)(71200400001)(8936002)(76116006)(64756008)(41300700001)(316002)(4326008)(9686003)(186003)(82960400001)(122000001)(26005)(86362001)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a2E7v0wqtrPdt2OuVEr2je4J7i+xpuCWLsLVKS9wXxvapmOsu4z9e+Np7h4z?=
 =?us-ascii?Q?ivmsC9tOe9Yteytf1CKTZ4TDfvlVejWZ7ulIGuEq2twAmtlhDC2Yr+nd/Fgb?=
 =?us-ascii?Q?wyrhZogkZgFrg1G9hSA7rzHJasHuW7agrOx37G7JBFG6cB33b9gRtj+yUGpY?=
 =?us-ascii?Q?/9md5+x3SjYeJRAu2qTkjkqHUkiO3dJDCAJO8x/ffBS/lcn8Ix6v+uF0byPJ?=
 =?us-ascii?Q?7mSk47K1EEswD9StJV6JglnqafGLEh/YlJXkE2GnoiEArGHBlVm4zfy606z/?=
 =?us-ascii?Q?Eh3SDwe/tJHVJ4LaK2B23WnB2nTkwrBjnWgKehhIvI//U85Z6F8bQ+KvZH0h?=
 =?us-ascii?Q?TRkqpXU7EcgxjRHB6L5SoSiAlUW5qtedTEMTWpjRjz1GYUfj00N5l6NQ/4zE?=
 =?us-ascii?Q?7y2ZcRRp8crYX2nPb4A1cNkN0wYIHrPEk00RjjXlMHTHdUszZElJoC/1/g+B?=
 =?us-ascii?Q?0nIkPqhxGW76daQsMTkahAhfxTNVFU05/6rtNo+uIXIqSzIYwhRc018nZi5n?=
 =?us-ascii?Q?wGsf35xRUcSsNnewC+FQulHKlEfz2LNk0XRX47Dk+wsaKtNWerc0TFcgNY/s?=
 =?us-ascii?Q?BqGQMgT8AM+8aZ56KOlllD29WvnKhelzgSAE0M2cZEW7np1epm7PIfIrY03n?=
 =?us-ascii?Q?kmg91g596Y1EEsquJlfKT3K1HZK1H6vfeLoveWICmvLz49SIGmTzySgUqYow?=
 =?us-ascii?Q?2bKCaBoR5SwcXp6sikPAD7FLtoJXSQhzN07F3HkLrzp/VEb6o8zF0EOKBeLV?=
 =?us-ascii?Q?u6nmbf3RsaHHOMI8PpKPzvWs/FiOlQVvy5U8DznsibliUgJ+mVgKXpJStcgI?=
 =?us-ascii?Q?ITEDsbdqBjS8SdG4iL0AIn8LIdcJAZLEkJuLMP1G8zEh90swtFsMCXbuj49o?=
 =?us-ascii?Q?Z5MeVRzN4tmP61alLmiag0U1+fo+FBX34/NGz42yMjreRvAAIgSLllsqCEca?=
 =?us-ascii?Q?tvuSXpaSO2CnweQ5IlhdGnZgYgbPP8wQyNZm2QWddkG6ruZkV/rv5+zksBqM?=
 =?us-ascii?Q?6xd9I/F9QSLLw7o7FRx2PNO1yNeZ9XccpMZobbZtsRIcSpGYrVQKRGy4bJU0?=
 =?us-ascii?Q?/TuEBYITZtG6DsVETjptMiA3UHJjLiz5aHgN9fiyMyflI0QjbkU4s31PxINM?=
 =?us-ascii?Q?iW3j1p++L5o+CIGRjcaO/X90NNS6joTBrOnBKiKWawUXiMMO3TAVjmn+dpU7?=
 =?us-ascii?Q?0EAv+sTxGpaQcCbZBFe2zvPcG4p6AaNr8o7cBpjN/qJLp8wZI4HUeOH9ZpI1?=
 =?us-ascii?Q?SvGodzG5GgYsUB36dWEzPg7z8bwgR8wLFk7fF23Q22JvbCsrCjeMwDuUxK9B?=
 =?us-ascii?Q?DXI7WlvgPG8vQB8ZrdUHmAQ1d6dqrWP6TwK6DC/FFrspxpojtjh5Chn3acSe?=
 =?us-ascii?Q?auqJbktmarHnGKLAJWe9MHavWQ8i6Ve+RL8xbX5BTUXAxJTG3V2chtpoGCtT?=
 =?us-ascii?Q?zkIfGRlq7gBFj/Gr7OzcDzrCx3PPX4G9o+j5pg/sSS8/hQ+SgeFfkq354UWx?=
 =?us-ascii?Q?eRycBO0Q9dMLBQOafcLkfg1+7wRrHvdCdDosZhHA8uKpjK0KxqK0BICM8tyT?=
 =?us-ascii?Q?x1GIM8UigSr3ZBS4knI+qKADFkH0l2rjygAjAo1b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cae23c9-62c2-40a6-f435-08dab4be27fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2022 06:16:43.2861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QO/KLioDqhNYvKOQkSELasDWfNW9Q/4oqIt3qzBlAlYBMZnXTXgXocWy/rnr/QxGS15AZaTo1oHLnt4ASAX26g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0737
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin Hi,=20
> Bart,
>=20
> > This patch series fixes a deadlock in the UFS driver between the
> > suspend/resume code and the SCSI error handler. Please consider this
> > patch series for the next merge window.
>=20
> Applied to 6.2/scsi-staging, thanks!
Patch #6: dcd5b7637c6d (scsi: ufs: Reduce the START STOP UNIT timeout) wasn=
't acked by any device manufacturer.
This timeout is now reduced from 10 seconds to 3 seconds, after it was redu=
ced from 3x60 on August.
Please allow few more days to verify it internally.

Thanks,
Avri

>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
