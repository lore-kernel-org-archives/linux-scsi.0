Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82F3C4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 12:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94B3622A85
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 12:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgLDMLN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 07:11:13 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42286 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730159AbgLDMLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 07:11:10 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B4Bxsol031196;
        Fri, 4 Dec 2020 04:10:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=wA4xBSSsGal/tA3HJx7g62qfjzndjfjElG+Kg8ewmaU=;
 b=Fzs187LaQnpekny2setSZ/skIIRCy+1uNscwS9w81B7dqcYLIqPG7B3KVYlRndRJOAUN
 +RqvsF8YvX85A5YuUeIhtdPCy1dH7PU+dt4Ek5ta1HRYF4ea4WfzNdxFdOUZ7jjj9Ghz
 yPMC5LM0knkW1r52WuIQyEbk/cWQJPah1lKmPAAfk9tsdL6wFGyLlwlu3PItdBbUQtBN
 5nMJmRcO0pBOjbAu5b1A+0qlhhygr/i4eCYqX20M7YMMlYECNiOXjQ0yni+CMhn+sNH8
 MliqCQsvPlDjEAXSFD92yORktQNG3837Y4awY2QdrSCERt1iqZfpG5Cb/1V8jsUVAbDu AA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 357jsjg9yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 04:10:07 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Dec
 2020 04:10:06 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Dec
 2020 04:10:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 04:10:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRAnbEwPnV5NFxRxi7gDcxPvRPo7ZSSaG+sMZFHFZik4VcXNFjKCaU8UgRDEKE/1C5hczsq8vxBJl/Bmb5p5Elzr/XyML759LPJ2IKKmSXGmGi5pNcK/PQpj0XZQygYh4l3+ipIHtwJUmauKtpu1J95bplSNv86KBlgwx1NEYqlVxauoQywwe9G7TXGyH+tDLNVieaVVHRrSTCYmD+oP7OoDRvgMBKutvVsALFj3Ii9X7FIAyG1kCm6AAj0Kg7Lw+ciyZHOZVwB415ieYGecwn5auExpcfgHzg8GtKaLfyGceeLARBdNChl9xkaf4S4IHETx8+VzPBLaOnR103jr5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wA4xBSSsGal/tA3HJx7g62qfjzndjfjElG+Kg8ewmaU=;
 b=dg0NUjN/OFfuRNJ8OHOW2A4QvpRhy8i/EgYuuCNCLIaGpaMbieVnTpwd0uTNoJDO+kK/ohb+pPxcUFGYh3Muf9emqOZOLUvEJsfHmrKEEOjumSJdHHTh4wLDnSIVkUdiMhlac5gSVvIXDUQlasYFNhtPQVv8oC996CNasshxCqLerIDHRI2JBo/jVAqVleiSfZiLA2O1uKJoKpGTKc05CxmGOkS//je9izk63pnpa/k2UwOBDsODOFFcyQLHHUtU8SpfikF5WIijBQIY8A7P9ZWLeWnh6GNKhywX6VmYvQOAOGMF5JcbPHnCcmjzBV8OJCVQFTbIU5EPUh92i9CQAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wA4xBSSsGal/tA3HJx7g62qfjzndjfjElG+Kg8ewmaU=;
 b=O3rXfhos3sYtVrusSaVXocL3TI2XMs9S5TSkfCj17vIt/MEvC3FzXZDAE7olpfemboftFeXJqPczazZsq73TvW3U5/63cn1ZPaA66PI40d8bPTHJ9rsLIGaCYG+8Kp3AYrnY1JcT/PW0rCt0mcYpWmnsCz4aQ6Wi468R87x4WWM=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by SJ0PR18MB4044.namprd18.prod.outlook.com (2603:10b6:a03:2ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 12:10:04 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::7475:4e06:6e00:1553]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::7475:4e06:6e00:1553%4]) with mapi id 15.20.3632.018; Fri, 4 Dec 2020
 12:10:03 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "subbu.seetharaman@broadcom.com" <subbu.seetharaman@broadcom.com>,
        "ketan.mukadam@broadcom.com" <ketan.mukadam@broadcom.com>,
        "jitendra.bhivare@broadcom.com" <jitendra.bhivare@broadcom.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "varun@chelsio.com" <varun@chelsio.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
Subject: RE: [EXT] [RFC PATCH 00/15] libiscsi: lock clean ups
Thread-Topic: [EXT] [RFC PATCH 00/15] libiscsi: lock clean ups
Thread-Index: AQHWyClEWbBPvU3sKEm4tkEveqjdmqnm2beg
Date:   Fri, 4 Dec 2020 12:10:03 +0000
Message-ID: <BYAPR18MB2998D0E155BDC4C595820965D8F10@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [106.193.86.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 873631ab-3d92-4664-f8fe-08d8984d8802
x-ms-traffictypediagnostic: SJ0PR18MB4044:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB404405C0426AED5C9AF6AD56D8F10@SJ0PR18MB4044.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xoscazv+Fa6T57IC5BdnuyAF9DFgVc0QfEZoqvYCCI+va+RleDG9qhf2el96iHDrQ1ilUf5HIhlg4Z5PzDn9X9d+1kDnrjuxQeOUBVAtFoLVlPc+hZd5Pm/tJeZ4icBRGn8JaxCNM0Ks1q73aXn4Y8/8CQKnHtqJfjkfR1C009aIECMVc4qkXB8wvWBTFsirq2kfu2V0pD9AAEevCbnfsqA2FczVMlap/VP6Bfg3ryJtsnB6xm9HqUh4yI0tTu+LkNWkpIiPjQXryIAWF7vu39eqm8aNEVuLcHNQU+qHb9gIDfSlgphm2AsiyXkOjTQXMZbsb1slClFBL5AficAHAOa0vXRzRqLKhKNlvm73tmbtriNPHhy6OXpgDtdIXfXJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(66476007)(64756008)(66556008)(186003)(83380400001)(7416002)(478600001)(53546011)(66946007)(76116006)(2906002)(55016002)(9686003)(6506007)(921005)(86362001)(26005)(66446008)(7696005)(52536014)(8676002)(5660300002)(71200400001)(8936002)(33656002)(316002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zEM5diK+2I6zl5BzajuN/iRz85Y3mi1FcMlI50bFJme79/YfZ39m8tLJA++Q?=
 =?us-ascii?Q?fXE3pCtUVqOmZT0Tbp3loAPFnZxBB6aLLE1H3igX4qMcb0/yK+38tgPLnmbh?=
 =?us-ascii?Q?cQRx7iXNouyKM8ITkUns6Tf7twQOgBlOoH68M+c08T4MJoC0PukBZTWggB4g?=
 =?us-ascii?Q?AfbCB+CCidaxEqnuGz5Ud+IskqlSwVJB0zDEV/2ZyvHbx6JaFr44UNs8ZGBg?=
 =?us-ascii?Q?sFcw+c4LguromQN8YYwdAKvMPTR9I0t6U+95Jaq2bL+H62xQL1ipQTqcDxpT?=
 =?us-ascii?Q?SN3kXhJYTIduzhQQzaOfdN7yyLPRbxtrm9GneKsQOQpnKCdxr7VRRQZM7dj4?=
 =?us-ascii?Q?UtuzAZ99Hr61DwRYK1W2Fcw31AiFs3xXubtL1wayh6RamYZcsAYk4TBOhfb7?=
 =?us-ascii?Q?vTuz2RRIUoLTF1WuvzxWpOwdPbetBeHsfth0CJBDCR0dKIjky7iam+prGDmX?=
 =?us-ascii?Q?J/ARA5IPQK+Byf8PLHOr/mKk95rZDdcYy8VAozcrAiIVc1sG599ChV84ZhdG?=
 =?us-ascii?Q?Y4t2ZHkC0pHmMN3DK9yH9ihz0TlaPqioamvKVIfcU+GYHnJv9mhFQvefY52I?=
 =?us-ascii?Q?HbZx+ZRuWcCviTP2jeZ11S/BQncbXxXhHyFJIeppp9ZEItqpdOyRemHYeTY6?=
 =?us-ascii?Q?SFJvaysxKFPzdXaxJ1Sf+ak/CTVqUg+lK3fOAZmkVoUnidb/9lVkPqCvkcWZ?=
 =?us-ascii?Q?Tv/ELgkhisRXMT/j8x+78wqM0YrtONp0PYSbl9e6dAWb+jG0KM4o4/VzoCg7?=
 =?us-ascii?Q?5RPEDQFFBu6arAaxF3hCaAZuLtKCyAztarkxhrPjKmjwVGVr3En9Qtv5YtX1?=
 =?us-ascii?Q?0vGcJWFhF2Q2Z9OqX0YuOow2w+o97RzBYBs9UQCSOQZ9soPoh2mnis7wySVx?=
 =?us-ascii?Q?Hsomsgtxz2L+9jY4cMw04S069W0QQmbg3TU/09A2afU5Z1atnZ33maNfgwZS?=
 =?us-ascii?Q?7wYF0d/wSLZfZOlUtq+2MN8YJCQUeaW4uNHACp8cRHU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873631ab-3d92-4664-f8fe-08d8984d8802
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 12:10:03.4045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aqBdrZx1q13zzvoRrpjgCedvwxwvUpxPXUzPNVpe1ToCnsBIgHFMg+qcy6Z7Opq0Z6Z3ccxcUHdrklJaiFgSwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4044
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_03:2020-12-04,2020-12-04 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Wednesday, December 2, 2020 3:00 AM
> To: subbu.seetharaman@broadcom.com;
> ketan.mukadam@broadcom.com; jitendra.bhivare@broadcom.com;
> lduncan@suse.com; cleech@redhat.com; Nilesh Javali
> <njavali@marvell.com>; Manish Rangankar <mrangankar@marvell.com>;
> GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; varun@chelsio.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> james.bottomley@hansenpartnership.com
> Subject: [EXT] [RFC PATCH 00/15] libiscsi: lock clean ups
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The following patches made over Linus's current tree cleanup the locking =
in
> libiscsi so we again, for the main IO path, have the frwd lock only used =
in
> the xmit/queue path and the back lock used in the completion path and no
> taskqueuelock. The EH paths still use both the frwd/back lock though.
>=20
> These patches are not ready for merging. I have only tested iscsi_tcp.
> Also, even though the changes to the offload drivers look like minimal AP=
I
> use changes, I wanted to try and get some tests done as the changes affec=
t
> the main IO and error paths.
>=20
Mike,

We will run the sanity test for qedi and bnx2i.

Thanks,
Manish=20
