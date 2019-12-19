Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922A1C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 05:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4855E227BF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 05:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="qB/TGdCa";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Wlgampbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfLSFzy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 00:55:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53700 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbfLSFzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 00:55:54 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ5tn8R019697;
        Wed, 18 Dec 2019 21:55:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=qw5oUp9krnNDjUaPn+q6MTYZm2jYH6NJzEZ2HyyXoQM=;
 b=qB/TGdCa2PODoEMhX6RDW+hKtTnk8Cg4RrenEU6/fBCIOB/vZgeqZYB1k7aycTfhZ7Q9
 OAFMgJ8iWPW9XKK5acx/+sSXFwpgNn/gvQaW98HwPHv015zq7uL5IiOf8UkFgelDMpo6
 IUDGFTeNMg9Tq16vUbJRwDh0C2YSrDLfYZpJUBPXU6yRubTCWNuq/X2nkAzDgoo3LDiD
 /8OhxKRN7eOtJhCxUiFI0MZpt16fnGP8tLY78bVPPnduMtqWOgitGoCyTymfWLLKRVFN
 NbeRO6BbwiL7z+D7o9SIPX704b94raw0lMFTlstE4cYXIZhWvJT6/lgx0f+32Kj+H70p +g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wxneb1s4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 21:55:49 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Dec
 2019 21:55:47 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 18 Dec 2019 21:55:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKTmPq1TTb7iNR31vnJTCZ/AZAAQEAlW3uANFAg9f8Zzi+ln5++4aQgt0/l6EgYhkQ2jJT5ODcPbXS4fmntNGFWETteJhNo3L0hnN9sNSq1SR+bW8K9lakT2IYSSvs64ELUOkvXROCqZB1UG41KCMMJ1MkuO2+oTUPfs/b87hgLxLkbT6GNt7Jj8BGDLfGObidcL5hJV3V4h1SP09n4hOREzgVdy9Gqz07a0sbzxroGlbSVQ+vY08XpABAEBIKo0uJqYzPaBeWiViZGXxE5yZ1mGM0e/1nnN3LR5/TcFNSUltNINtCzBFS4E7HyCuvUkiA1zILdV/4Qk+QR75+IkXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qw5oUp9krnNDjUaPn+q6MTYZm2jYH6NJzEZ2HyyXoQM=;
 b=KYM2RCByGe+dILEO0ThNVts0eB2gvoNh3Iy/1bHYQZWyYEp1KXtK82gEUQDDe9qIFBxIjb7Z8Dtj0YNUdqlTuiaWki+Bq0ZxOzZokzi/faYv6MmFgkZe4A7UsEs2Zh7AekfUB4HpNqnLEnfbiHjOQ0IfuiLM4BAhdr4Do1Ecxp/tHBReTPaXv1RxmprJiWmG2kETuXpEQuPvxijX78patmkIyX+I1rZgNl7G58UhVSbiLOSQo8c0aENozHgQzXbGO73ImMPW8CnrybTz+y5eLGwUCKa30w5dwPeyBYr2jZ7lQIOcaRibCnatMwGqM8Q8FU4VVg1EqgRYJjV3Hg2K7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qw5oUp9krnNDjUaPn+q6MTYZm2jYH6NJzEZ2HyyXoQM=;
 b=WlgampbxJC1UBjbp35MGOBpJdqcCulmtFCtNVSXn9ImfNUIgDKbTrkNibJzEamqyYhsVRZuPxfwvMLlUvoJEeiOoUqw1Px7TZ8HjFZDsTaTZbeFBEvwMle3ImQ2MN9nlrfJtGs8RH0rzlc9Y8QObcPya692nDu2ITyQEzGX5nHw=
Received: from MN2PR18MB3022.namprd18.prod.outlook.com (20.179.81.79) by
 MN2PR18MB2814.namprd18.prod.outlook.com (20.179.23.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 05:55:46 +0000
Received: from MN2PR18MB3022.namprd18.prod.outlook.com
 ([fe80::71b6:15a6:296b:d72e]) by MN2PR18MB3022.namprd18.prod.outlook.com
 ([fe80::71b6:15a6:296b:d72e%5]) with mapi id 15.20.2538.022; Thu, 19 Dec 2019
 05:55:45 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        "QLogic-Storage-Upstream@qlogic.com" 
        <QLogic-Storage-Upstream@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
Thread-Topic: [PATCH] scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
Thread-Index: AQHVtUXiqoQyQCCWl0SuaAvTA+GDZ6fA9vfw
Date:   Thu, 19 Dec 2019 05:55:45 +0000
Message-ID: <MN2PR18MB30227FB22733182ACF0BEFD8D8520@MN2PR18MB3022.namprd18.prod.outlook.com>
References: <20191218015252.20890-1-natechancellor@gmail.com>
In-Reply-To: <20191218015252.20890-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30dbd85b-fc7c-4c20-0958-08d784481747
x-ms-traffictypediagnostic: MN2PR18MB2814:
x-microsoft-antispam-prvs: <MN2PR18MB28140AD3B1D71450D9FCBFE3D8520@MN2PR18MB2814.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39850400004)(376002)(346002)(199004)(189003)(13464003)(33656002)(19627235002)(9686003)(52536014)(81156014)(71200400001)(7696005)(54906003)(110136005)(81166006)(8676002)(4326008)(66476007)(64756008)(76116006)(316002)(5660300002)(966005)(478600001)(66556008)(66446008)(66946007)(26005)(2906002)(186003)(8936002)(55016002)(86362001)(53546011)(6506007)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2814;H:MN2PR18MB3022.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lRmnKY7r/tf/Ag7blQCG1S81wxE7TQJvJK2ViY7afZ8YR0MxeRbanz4qG/CguEkVDQ/HFAd8BebfGxVFPgTSU68A8KXrWegTlhfIGIjLbc0GwCUD/wEDHcDyq2jYWnbg/lHvJGzGm29in/PluJYEYs2uXYnBg78Tn4yT3zz7+rldipzB2ncLT3cgwf2kkdUNtnzDFYPhJs0XcBonYwESa2tg3dpgLeChKXXyxTCPZy+UFWy+CBJyXNlr3NiG6HWnR5qzPUtzeWKyw/ccSpJNxLqNQe5OlzOfSsovTbBeZ+ZdHa791n1snt58p8QnfpEdRbwiT7s49AfOVyiWofI68Y370wQ80dLt89vNeIJRT084Qnm0UbWSBfoQd4Typc5gaUJLqWmsg7nnarXbVMKEYfeuQlpoB0WHawiO1rJtVx31T6YADtE/XqLi0N7Umi18Vj8BM7gSNF7F1g/+NqsY+zthSz0tIv+l4yIAc1Uvyao7iyyZA4YWHWEPZrAr7tXwBvUUteNsx2IUQsh6bN3QueMuHLRmOKXvpFnRGKt61xE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 30dbd85b-fc7c-4c20-0958-08d784481747
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 05:55:45.7328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3kcUL4iNB2bZCLVsMPcCbIJ5EHnQ/71kuZ6TOXyu8dEkdKAnh5esrrdZ5dWdhkAXdio6i12oPeTeOIhw85ocCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2814
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> owner@vger.kernel.org> On Behalf Of Nathan Chancellor
> Sent: Wednesday, December 18, 2019 7:23 AM
> To: QLogic-Storage-Upstream@qlogic.com; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; clang-built=
-
> linux@googlegroups.com; Nathan Chancellor <natechancellor@gmail.com>
> Subject: [PATCH] scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
>=20
> Clang warns:
>=20
> ../drivers/scsi/qla4xxx/ql4_os.c:4148:3: warning: misleading indentation;
> statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>          if (ha->fw_dump)
>          ^
> ../drivers/scsi/qla4xxx/ql4_os.c:4144:2: note: previous statement is here
>         if (ha->queues)
>         ^
> 1 warning generated.
>=20
> This warning occurs because there is a space after the tab on this line.
> Remove it so that the indentation is consistent with the Linux kernel cod=
ing
> style and clang no longer warns.
>=20
> Fixes: 068237c87c64 ("[SCSI] qla4xxx: Capture minidump for ISP82XX on
> firmware failure")
> Link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__github.com_ClangBuiltLinux_linux_issues_819&d=3DDwIDAg&c=3DnKjWec
> 2b6R0mOyPaz7xtfQ&r=3DAt6ko6G2bmE5NMB-
> 6KMSliwRneAzZrOmmK21YHGCrqw&m=3DuRvAonUUcyFaz2S6vZ8po-
> QrrPYNB3gw84QZKl9wS78&s=3Dt3EPVR3mOgGj_emNe0i_rdomyiK4K9noSBB
> WMFBt2Ag&e=3D
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
> index 2323432a0edb..5504ab11decc 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -4145,7 +4145,7 @@ static void qla4xxx_mem_free(struct
> scsi_qla_host *ha)
>  		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha-
> >queues,
>  				  ha->queues_dma);
>=20
> -	 if (ha->fw_dump)
> +	if (ha->fw_dump)
>  		vfree(ha->fw_dump);
>=20
>  	ha->queues_len =3D 0;
> --

Thanks
Acked-by: Manish Rangankar <mrangankar@marvell.com>
