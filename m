Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C792C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 06:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbiDBGeO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 02:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiDBGeN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 02:34:13 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAB615B072
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 23:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648881141; x=1680417141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ay5DLihH8H/KfQCwysSO4iIy6IZQcAH2GKZpKvNJXG4=;
  b=mMeKmlU/LqKxtCJufML5TluUHTQ/GrUttOjs7wVgrua09gd1HjKbK4R+
   Di6dNlu7ZErKGeDTVlLWQjIOhRaLxDHe70UyfOnQSds/4hZHk96j1iU/p
   HZyNONPAV0R0UYJm6sioU44Q5H/8VHaJTJGMLfqcQBndJ6y0VQce/5YaO
   uQKvn/2q9fDJc71sNd+rusCi/ZRDMAij4dII0Mn/Q/5tpu5MmaW2uALsp
   Dli2iLoIFfehsJ3gMVb2akX9MiqYuUzTKULNedp+O5pI/dc0hfEQEGNdb
   fmjTNXQD6WAPzwwoE+Hj4kJhkUFpxJKOGnFERv2u4nuPlkfAxUFluB7Ps
   g==;
X-IronPort-AV: E=Sophos;i="5.90,229,1643644800"; 
   d="scan'208";a="201740979"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 14:32:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ber/2eySgcpK3+xriiKWyyEZ4yD+wQ4Gv7yG+Pe5VTLNj4d/Srb/yy1popbtd1lRP1x86JmV33UJpDic9amfPK/Idry12O4wLegCyT0PptKIg1OdntD8R/AANPkORVSVXtkvQFJkWc1xAvCk3PAuckUDz38WKoWnh1sE8iCfmhil9bSuwqSs6HbdSi4XsNzRwXLz1HoKnoJRAar1AetjObZpGdEl1RNbLEMdFj0uuCbVaRCEkF95LfFJn73PHAvpN1UrSp5sMNH5SSy+96EDDVJRfRjyRH/SXADCmuLRGrw1TxiuylGZBOgz2k1WUdwltrNdJ0g6S5HYRtSCwDfYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ay5DLihH8H/KfQCwysSO4iIy6IZQcAH2GKZpKvNJXG4=;
 b=cQULna3/raf/OHAfbLgwTPyNR5K4OI9GDKjXCOIKfCrOEGnQN+CC/FvONiwbBGhadS5BIy0LlN+wiZh0fmrMr44p0Xjqf9+yhD3w9Bh7HoCQlmDFZJuBnZwoLj1JDyfx+Aeihog+Y36HzEZF9AhYrSTUMVymfyR4hRe8rmglhop1xovK3vl19N0xe1HHzcJbvKmELPu4oC7Cp4cMF8lb6qKIf7Aazfrsd2tsjEPNRwK9zcy/CP9AdxLfywFwNL1/VI/qkSSn9JRfkSe1eSdi2zuparoVUEHVF/wPgjJyJIfJEfGuUvyEmivCEBpBTF1ZX50r/uJ7j6m73StOuPihTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay5DLihH8H/KfQCwysSO4iIy6IZQcAH2GKZpKvNJXG4=;
 b=nL+gXsipNhku1JT1yDOFcqbbLsdgIldAQX8eT4UPhWeH5f5MdRuzkvtGVwuKNozhooZ0F+dMV603bb7nsoS72xqYhrIj40/h9jnns9NrOY79W7C1z2yyt8QBxbXm7Bqo+8YQcu83hlrPWyrq4Wd+rgclT3w+XbC3NI2DkN59zjo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MWHPR04MB0303.namprd04.prod.outlook.com (2603:10b6:300:b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.19; Sat, 2 Apr 2022 06:32:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Sat, 2 Apr 2022
 06:32:17 +0000
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
Subject: RE: [PATCH 10/29] scsi: ufs: Invert the return value of
 ufshcd_is_hba_active()
Thread-Topic: [PATCH 10/29] scsi: ufs: Invert the return value of
 ufshcd_is_hba_active()
Thread-Index: AQHYRU/DEaa2Ob4sSke7YB6QPXbw06zcK/mg
Date:   Sat, 2 Apr 2022 06:32:17 +0000
Message-ID: <DM6PR04MB6575FB3708F77548892AEC6EFCE39@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-11-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-11-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5143784-49ce-4780-d611-08da14728851
x-ms-traffictypediagnostic: MWHPR04MB0303:EE_
x-microsoft-antispam-prvs: <MWHPR04MB030368635F954FEA23A35131FCE39@MWHPR04MB0303.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZatD6iGF4cerTLBVzykh8GskblEqTpPhamzLtoeNWX89xhA4H4odNj3Koly+DkfdFLRNze3u3qViNMSOPkq4RCquis4TxzkEmAI18vQqudZerGWMRIQvc3+s0MuPqk/VOQ4O904ktztOWX2H6XnpaGrNHVcmYUwcbHeQmMng7uYL5cdFvt2Gxw5o0E2nqLf59IrRAOJ6TulBH7aWJ2slmjGWJ6B8PPmSpycczRspmPpxRvnG9E1JeMu6RvmQPwe3i96NQU+FOI3FxPimAcFbPedvFCWy7XjL8IUtiwhgdS7QOEKTluGDwssWDqgvzLfCnRo6XB0lJ4zGW94TgO2mph02/vObdahlDxT4hu/o47sdE72YS+4RuCtvuQUgugIRgQIJccgCKuTW3xy8BpjeKYN/MuwhxfrTE0EnZNWvgUT8bwd1Wn/zlMcrmE6DSTU/W+cLxvkxYiC+m3z5qnnu5tfztn8hh89f1hDT+I1c/4FvOwWxnvniYDVy3Am0GWHGb47ZZu6iHrFLaUOLO6NN/cdtfQiwl9bkZLzCrjHxCVbJN98MjDg8XFXD680IyWC8Zo5UIhFDvICgFI1pFglWotjR0X66SjlWEbc7qut9NKckbK1GLelUo6EcVYeNp/1BEVq/M+DoUPa441inP28c4RdqI6m2oYJ9D7Ez6Guzg++U6xh83IEOEC1Ty0rHefJr6QIvzmdnoZ92DRuGwjNDwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(186003)(26005)(2906002)(7696005)(558084003)(71200400001)(6506007)(33656002)(508600001)(9686003)(76116006)(66946007)(66556008)(38100700002)(66446008)(7416002)(122000001)(66476007)(38070700005)(55016003)(4326008)(110136005)(5660300002)(64756008)(54906003)(52536014)(8676002)(82960400001)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WRRCdymzQq9eXhflkcWStK9e2+bEUsaJh5+4RamzJV3MGwROGvHBXxaLHGQD?=
 =?us-ascii?Q?Zu+C/S8qhYITRGcwXomRL3Nggm2Os/XVp0v0RTNoWDXaVFIjOcE2XHcnF98W?=
 =?us-ascii?Q?ZHoivhoWgkWHSszT/l9f9/gzi7SEWQ+0CW50hPrPE4Uy3CM83wWZf3wnkLdN?=
 =?us-ascii?Q?uUzWxNyO1vqChGdKgchlHyyh7SpbMhh9BGZghrQlmylDiD6uK1UcwV44k0bi?=
 =?us-ascii?Q?Hm5LRTN+n1NxLqXPDcIT0vDDWbinmbzhnRmvJr+uYiEmveKtlYCmKOxCjNgF?=
 =?us-ascii?Q?ZkbUcfeDPchHQJIhSBYyteItDMecenf6XGG6iPkIhioe3vC0Di5+Sv6pqsxC?=
 =?us-ascii?Q?OcpyqIYptmPdNBF6no4IGpqaATbQZvimVB4CNuQKuK5Lg5+OLUYqL5qRC0ep?=
 =?us-ascii?Q?d+wWkUCI9zgrg8WkOst0z5hLLNNW6DbnPs+4G3eBlCTLDZBcg8JAtcIkf5bO?=
 =?us-ascii?Q?3ris6wQd0+C1gkIGwaa8mF3HSFcDo0eCtcc4hQdbOtPF0B7Fl0lqthu6vm4Y?=
 =?us-ascii?Q?DBNEQhvcz4DrXqW5yUewGddnmLE9ZFUrocVBeJ9Bzqm+RvPcx79j3J/zzIDR?=
 =?us-ascii?Q?0gu/Rmx6ILqzrs3bR1g5IvXkyi0htOQNpLotD4qx5mHbfQb827fCQzlV0bhv?=
 =?us-ascii?Q?TkbaGQ+lJv+gZjsg7BiHt1Z+IhFmXTd5uuYB/FTw9l2MS3ltezslVnfrgUMA?=
 =?us-ascii?Q?So5tHaUk/SYZ4nTkuwCfTckEbhK59JyzuxOuie90OJnCaUeVCasRfJzRfUbk?=
 =?us-ascii?Q?dXkLAZ6U7pC3o5maYl45BOHLXynWt5kIUWnHR/JktABlcDKNj94ojsK6+gn0?=
 =?us-ascii?Q?B/DfwyvDd3o9Acvt3EjvLe/WYGxGa7s0xGLADybdqgr5lIKxV22sMiXeWLmk?=
 =?us-ascii?Q?ald3W/mZjXAT6idAyFVS5qkaY8Tlv49OeWeddE2PPjIbWvqu/lFLWpQ5w5d5?=
 =?us-ascii?Q?fyxI80VskW7UVNzatlYECPGjfrITes7373td13RgraF/JyZGt9bsCgUgba2I?=
 =?us-ascii?Q?qNFpAWQEMbCwiKz1DnVbf2W9Fhyj0cOKCtzfCGme8VcBpPJkG/Iux4vxPFLW?=
 =?us-ascii?Q?luWL6Y5jSygOThe14HeNy4YpUANfUY3LZYKTRtowMWa3SvpFz/vYEPA6Td4s?=
 =?us-ascii?Q?wc5BBeskqoSsdDC7uqu1NgRS1xtgGeYcetnXPh2+bW8ON36o+/vwNzlCkxdN?=
 =?us-ascii?Q?kBNRiFdAwNLLNx1vq8XDTpOzrym2rtiZNGU0oAB1RnCXHW4zlGdQwI7SwwjU?=
 =?us-ascii?Q?A2OA6GyT50qNAFppTv9+kPCIGHBVa6TEzuNQv/w1p9g1rbQsqkVxty6nKB4O?=
 =?us-ascii?Q?0IRgJl5b3ty5t7v7uBJXfU8TdIoEDV2m7YeH8CIWg7PbOSY9dtuKDIUM0bTb?=
 =?us-ascii?Q?ywKe/f/yB+zysCPPxdP9o8BQoB4rgRHFXXNuE3msyo9fXQluChtacX7/TblG?=
 =?us-ascii?Q?MvJ/mpQbwl8ra9lsugb7qxt2cknNGiZyZFPMuagJWZjRty9ry0jTzuQl6S+I?=
 =?us-ascii?Q?zBEjHcxI3Y4Vg5iQ6GkJOjm0Zc+rbEd9T5LOGbh+PfQNdFsQV3wFXCss4CU0?=
 =?us-ascii?Q?8enuKe6M/qMhdvxn/aCJd4IX/MzAvSPnzUiJi5Kao8UlGVHY/tc49N7le1hZ?=
 =?us-ascii?Q?yhDnIHwjys0ImvI5vR6E8qv8Hqo16793lmracVFfPEzRlPndYhVgI2c9b1oz?=
 =?us-ascii?Q?QRwAesY4xrrRnOsR8LR1Uo7xwUD1q8bv2JG/b1DYbQFJUPWUFjjcTJGDe1Vi?=
 =?us-ascii?Q?dEutG9JLxA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5143784-49ce-4780-d611-08da14728851
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2022 06:32:17.1301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kuAw6O/uhlGPTBpRwkZPfcIrqEp5z/f8lKIvEuVHZl7L2MM6MgpGy77ITyrHD41DpDOWrzKVDiBQ3bgkmxh2Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0303
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> It is confusing that ufshcd_is_hba_active() returns 'true' if the HBA is =
not active.
> Clear up this confusion by inverting the return value of ufshcd_is_hba_ac=
tive().
> This patch does not change any functionality.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
