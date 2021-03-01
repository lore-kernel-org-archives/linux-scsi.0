Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABEAC433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061E764E2E
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhCAM6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:58:21 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33752 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbhCAM6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:58:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603498; x=1646139498;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=ncRbtOSP7E6dvXYuFOtHSJjruRB8ZCUOLXOhxR10wVBNMeSvGkFEjQ2b
   AquaP2ge4sVCNw0QDzeYAEMvGKhFbFHoELgkVsLCBt7FSA18aoS3yCQG/
   yXGSm1JzwYcw6NPumCcWN9jFFwYR1Cu74v+GfblqDfl4QrnlqJTMfR6lF
   YzQF1Gj+eZxQ0VX0zXJLeiSWc4hqJqQ05tLHz3g5iuDJWu920zHBDaez2
   XZKSuRKtr+rY6xJevEAm9cbQgh/SiTrhToqOT49v7DIKexecTN3mdLJ3W
   b+yjZLJGuNqM96ONghQ1k0SYdyO3qEaPbwfzmgz44LCS+NcZnb+zsyYPt
   Q==;
IronPort-SDR: 0a7uUM6ff3YCRaTZs+ZyyQnEFQJjSz/LnxCqxY/lcMbRU67ccR2X18Gxtgy7I9tc1r9+TGR8Xr
 iqFtoQkt0HUHma6IK16d0rrRGN+0L4ANGzDVecosmVrjrVGiwVEYUqRhqgEox7eS25/I7okujt
 m6igksDpZL35OhUP/4Wm/xHQcxIvueDaY4gpo7OLplybLl7KkL2o6Bqt3V8pqlf3prcFm2+Prl
 WyZAIH2G3ghK+UMv6XyWObjOKq4Lcr9WWx5bhPHrFOuW3r+bSkuo8A8S1MhDgrWbfwHduqpIqg
 Q0k=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161079751"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:56:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hg/GL8X2ok+M7R5b/GdiQSJyeCLB3XBZShFS9xqq3le4hV94Se9zgoYt/zAD0bW03n7ry+Wiwpfsgc8C5dDu4+rrDL/d8NpHggzv5XAUemIU5N7RbPfQOi5xCNhiDzPVQ3XOb9jEDC3Jd1B5TB0uvLyAYi1ZYYp4Hvsv1RoipINZEd8A6uyEaGKEeDamtV+qe6+dDYsVTxBWLGETkuCGEm4Si+5VlBHlOzfENLHGWS3wVc7BdqlE0H2kjRrE+fYKy286bW2Xe0gxtwBs1dED+f9nIEJA8ILyzMOzkba8NOCCSkNAuWPncNpuzea2SS2HRj5VHRgd+suB3kztmKL/RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=J4nhzpoYYS/FEynteMa97g5/ZO07v1OrwSnMP7mBHMoMe/0b09ZraZGds2d4Pg/XTKJWFaNxufH2XdA+FmN7PWoSrjva7l9IaBsYl1rfBo1bdlRZbaz1IF3Rlw1i8eHxKRS/MhRHd/gVKCsUmbtqPKHUWAPCCK5ypN4X6YGi+74BigP4m+aQ81r3l5y6Lw3+Tkf+MqxtJ8N6axtvP0antlL2aBMozETi9afFMS67t0Xjz23qXHP+wh2bmiynGDsr+5uBIzNpQN5o0hAvE3rJBFdBSVPh+hrE5UVIS8qVqjxJpFqcy5TQKXVkejijz7sOQy0Rvn+Pm6h/kMCGJWXKkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=MSnbN6rvNND4Wic1UimepY+Q56awbRKC6rtirV+/kVUvnaaBChVf7Ppw2ZkoLLIZiYbCQfm/9ftbUKnSZ0dX5zWIrOm1OBQ1PsTWawp7seYsXHEdgX4OsnJ4wx/3S01gHphRzFf4y9SLGouwBBdK6v6jvQLHWF4AyQT5B2//otw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7192.namprd04.prod.outlook.com (2603:10b6:510:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 12:56:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:56:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 07/23] target/stat: remove unsed macro ISPRINT
Thread-Topic: [PATCH 07/23] target/stat: remove unsed macro ISPRINT
Thread-Index: AQHXDZcHK+42F4MSnUi95g0Tzu0IeA==
Date:   Mon, 1 Mar 2021 12:56:46 +0000
Message-ID: <PH0PR04MB74166BB7D48C0104CC9D32DC9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-8-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 54612777-4492-4c3c-1216-08d8dcb178fd
x-ms-traffictypediagnostic: PH0PR04MB7192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB71921EBB15357192805926EA9B9A9@PH0PR04MB7192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jzpqheD8Y/9ks7kU4GbgPYgDT4Qf+ebd18Z/iWWF3Ps9OnN5AipZCtWYej7re+pVyo9/4NvQ4bzyMpZYI4NwQ4S9zSkTNSCLVBO33/4szUZX4dTGz+bqEJakCEvmuDaYGrPaaHXHJrkcu4o1Pg7WbBdKyFAzZ7ZtZmtnz0px9n2eLBOWtga8LgRN9EEq3thpsvgaSWGp6IFC6EegH4D7zsBBIFVydfX2BD9RBkd3RAExqA/RrN22/zVPP+w6CLS2jjHPp2kRid7VUmpWFEQazrNneSVYo51HHQ5oONcrb4mLLYrmP20lkowVFO7qiaL8f4xaVPa8hXCvxShcdc3JzRCpWAsK+wRFgogT5ikEpCAWXA9jpMstosKsBwuMFkhA7+d8dg3itU2IMD7NqxktF6it2wAJlW3YeMUu8EH6pP2QFotolWN5grAwprP8NLyoJ6emda+2v+umxyDrtonNcpsaDK8GwssH1cRvdIveZrOmQ3I8imbr0eoGnlo6jKUxbjfJ4Shwrq1ICm1QZvMrTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(66946007)(54906003)(110136005)(66446008)(76116006)(64756008)(33656002)(66556008)(4270600006)(91956017)(316002)(55016002)(8676002)(66476007)(9686003)(5660300002)(26005)(86362001)(8936002)(478600001)(52536014)(4326008)(558084003)(71200400001)(2906002)(19618925003)(6506007)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?m77T9oTja7TDaThOhN7N4bSei1bRj29S3AqLwzt1CiYIXs1+5URJU1Pik3or?=
 =?us-ascii?Q?b9D/6H8P9SpmkGZsMIQvIEq4A+9/+2nVLJbYUlc6PSvg6/8C3sSGOMBPrjT4?=
 =?us-ascii?Q?RQIRhW2X87MJr4LogriI/juw69UfKHm/UiBOS+zxztyene/sAgafs82Bic7V?=
 =?us-ascii?Q?JmhSfIpu5zcll36Ujccb3erueybp1cjfwBeYTXYDjSkOv58heiw2Vir4LNvq?=
 =?us-ascii?Q?mp6IMHk/2h3jy+4P9aJv4WUHhy+XqCEPs4FzNyV14zPxW7lJsRoJi9W/4/A8?=
 =?us-ascii?Q?eSxX7/teZ0Z7uA/dK5sxSm8aQS2y6ej9P7i5at7uqSVCp+LeFir5I403/9mJ?=
 =?us-ascii?Q?PDCxq5m6Hfjy35v3GA+ij7JCfMf7GYYRJUD+eV1EUpvjN30mE8ZyKJouSpfB?=
 =?us-ascii?Q?bOnGZRLATRk0f1EvXPglbSS1IzQh9VbySR2QRD1A2HoS+6V1SZprMpp+8y/D?=
 =?us-ascii?Q?YEO6ASfnpn4+FhXxXZ5rSlml41ggivowutyK4sA+NWu2T3KnN9MWwbumAfN6?=
 =?us-ascii?Q?ckX2KsUZkSdAQWsYcrUZjBLrsJ5ROYQkt0B5Y/slpoT5CgAEK23CxcUCIH9o?=
 =?us-ascii?Q?kxY8bKAYbBS+W1j38Un71JuHNoc/DGfD9cpYBu3jsBxnPOjvfTuaxzX+GFuA?=
 =?us-ascii?Q?DdzKxiffHiJ1aOjVHludjirCMSuatP1a09CYjDBruu96HbtBRpZwN2nJUfJX?=
 =?us-ascii?Q?e4lJ27U/2BY9HR8ijB/3oTCOb6UnAA/13IRXHp3y5F53/mzjQKHLZQMql6uy?=
 =?us-ascii?Q?EI7GoNQElB5FH6gzHdYpjwrQ+8bNcP0LP9Hozw0V9G0lGCJLVoOaplOw4sni?=
 =?us-ascii?Q?zhuMSIbgvJBoCVFf2NnNsc6TsznjuS8qcF2HxyQVWMXnyIag5wlX64SnDwMv?=
 =?us-ascii?Q?iQ5FlEJ8n88m7HAuYcILtHqawCvuu7+SNWf7Zv8Cx4YJJvDluLih89JBYvyk?=
 =?us-ascii?Q?TPkn6/kqZiUqX12eoUkmP6cVCiRo20/zK9BZz/T67emvhmlPkqj1dZcmfnvL?=
 =?us-ascii?Q?0/V5WHoJn4D8sK4Ipm27pHx5A430RMsZDNcwg8l93OVFoVWUNG/YQKIgy/XT?=
 =?us-ascii?Q?9G1OvZ4JokST86zmIUFRJWzcZASnlPBkgfzgLRx22dAKvneMWQ5ZRPhOjIpv?=
 =?us-ascii?Q?Obd2JkUUIlXaVDjhYBSXRJfhsi6CWeL+wJqQcOqOPnepa55D2Uab4M+QR0iJ?=
 =?us-ascii?Q?QutnSAxQTQRIOPDJFImGmCKlfXtd41jOhWbS0XwKUSuVOua4xV4wkE98T0qJ?=
 =?us-ascii?Q?Svnwy7xYxfwm3uq+nkkE+0qRbsL2J1FuFPSv2nqKejijPP+sPzeT6OsiZ5uU?=
 =?us-ascii?Q?3wnQCPzstMG/79lKngrD9ZNr09pAAT/iGh8yc/jEwBmORA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54612777-4492-4c3c-1216-08d8dcb178fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:56:46.9142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXmrvc1y3bn+nLf4GVNhhaIPYe9o3avd6Wgcv3FCGJkSaL2D4TDV37o1BoXp5Th4WH/OW8tcB2NQ2p929SbktNAMapleCJLRca6EIjd8/9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7192
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
