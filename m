Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4742FC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 04:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D553F22275
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 04:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gdyz3l3t";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="kG1HTUHX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgKBEoV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 23:44:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5526 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727726AbgKBEoU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 23:44:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A24di5O006019;
        Sun, 1 Nov 2020 20:44:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=EI5yK7DKwAGrHWozOnU2C20Fihc/ei9OUzYotIw3NTI=;
 b=gdyz3l3tjrhQQfPRIGijmlQKL9/qD2I2XQgxYmIwl+vPrP04Z4oPH7nWjMcio5F9sFTM
 iSx1afhtjVgnpqQ1DxYpTXE+tNI1zIi2MfX05FWjHHf5Gwf2v6LMwwGAsv9TKVT58/Q5
 +w/D4vD13p+QfLlTvJjSSoIxKeYTlakhKA9hrR8q+kWb3N3YrYbIi9OXW2l5VbjyDjvU
 20YR6ucNctuR8SWmhnRh2is5YTtjSpOUoLKzf57LVk5tsKi1+KcbMpLEXYKDvbj7EMRJ
 Z4QK9SNO6lLHqSnE+/B7RNEMFsBuKxsfAh2UeR+wpKHYYCyql0Xri3fJ+BXhMioHlImw FQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7ennxc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 20:44:16 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 20:44:14 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.53) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 1 Nov 2020 20:44:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSV2+hgSnYkyUqRIro14BHLbvBZuZz0fr2DDQaZVJAB++iLagWaQs8us9+MOTDFkrVRq81ipjDJvxrmMhaxthjcgEquUuZcPrxyJG2iEYlXShYWA24/hM616U5axpKfpfKHiRz33afgLHurHbfpH5hrN4dfgFJRdqJsVNo3rtt9YVGNmIpyXNILgSHPGwpVTCgmnJJ8nLjMnp7mQpaWWraSn1UqGdTifKVpOcaPc7KFO9TtuCnbvZw7UIUfMiwED1PnBQGR5DxxX2xVrUAtO4WjCDd20J1A0FQr4slrduWThbYZplKSxTRulp5Q2B2EgSZc4Eo5/t4peV6bwgQBYRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EI5yK7DKwAGrHWozOnU2C20Fihc/ei9OUzYotIw3NTI=;
 b=KdrlkkoozgI1UMYVcm0Yb1NAOmeuFSvp2pjpm30zp/WNa2t1nWOevGh3s5KvRnkYprFBGAPpfafISMtGIWreDve1EtpAaaU/lYCZhmWLoTSRd65Jb9SeAe4zPiT0h8nveGATQvY0uN1vzji67IyQo7p3XtcPCP/LK6op9jnvTM9SJ0BC8n+7xDNaITpdO21m3888RsZQzHv1Ihl309RMwdLEMlmikCbsqq3T4hF9dhIP1XFPIBKUYykGn+Xk0Ihy/aALiTZHRgTP6U7bbupfFAkyiKFCrsC/B72m4SyhjAoD94Ku2U6bC9Y8qWF8jlJO5E+xwYnOJuLhK75CbmTZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EI5yK7DKwAGrHWozOnU2C20Fihc/ei9OUzYotIw3NTI=;
 b=kG1HTUHXG+Ga5o7JviEtiR1Yy33ldI6kcPOTvFV50IfIL45swxlULTZM3sH1+4OVNnCfy9Hwl3M79bzBfq/3/ZQVmylpjkjuMFF8m5WfMsTdP+wGv8dnG6+qoMrGUvm+HQYn8Q2lJBxIze+LsSK+43IWZLEQkRMqjcxv1gz8Fvg=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB2213.namprd18.prod.outlook.com (2603:10b6:4:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 04:44:11 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7%7]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 04:44:11 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        Javed Hasan <jhasan@marvell.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: bnx2fc: remove unneeded semicolon
Thread-Topic: [EXT] [PATCH] scsi: bnx2fc: remove unneeded semicolon
Thread-Index: AQHWsFyo4eZrUValz0yeyQj3qWBVTqm0RK3A
Date:   Mon, 2 Nov 2020 04:44:11 +0000
Message-ID: <DM6PR18MB30341EB96B8A82BA6FAF9408D2100@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20201101143812.2283642-1-trix@redhat.com>
In-Reply-To: <20201101143812.2283642-1-trix@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.211.149.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f63ccd33-14f8-4259-99dd-08d87ee9f13e
x-ms-traffictypediagnostic: DM5PR18MB2213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB2213179CF4D503CEBC19C8F5D2100@DM5PR18MB2213.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bGJ+UBcIKKYVzI9A6LDaRnFQY5D+YlQH9KUtjkH54WGGCanm3qYd4PRcItEjUwVaC+8KsjlYkJCjM3BgE5/JDDB8l+KzXQ9ZRjYlzS22njbPj7BnX9rZjcrMNjZ2rjAHLSvyBM0fyhH/6TN4WwNA2DL9HQdmyYlFnJKH1QkeiwEsUR0xhN1vDIrbLbR/M+yORD/Jb/t+Xf15P3gIHLoBhlXZrQbpfrMKbvsUEpAIkdX5oIOwR5kum4I8n1ZtZZXmXcD+u+cZ42MLHK3DD2fELDgXU3eI/EkeqnxSLnyyyMKLdt9jpxyNjCRr+pBmoLOiQFubm4tWf0O4jtBTkQYUGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39850400004)(376002)(396003)(136003)(55016002)(7696005)(54906003)(8676002)(52536014)(8936002)(9686003)(2906002)(110136005)(316002)(86362001)(5660300002)(71200400001)(4326008)(26005)(66946007)(53546011)(66446008)(66476007)(76116006)(64756008)(66556008)(478600001)(83380400001)(33656002)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Ee/9WhAZ22vFNxNq4YNHBbI1HgALLRDCPubgabrHy51jhW13L5Ww/jOaBndvfo9E/uVD/WxAwowDS1yKCuPBm5RNMTozhVKuMHDIDWOGfacccRbnhMPlZRluzrDE5s34ZcgI/doAFbbyuAKkCB53ofQYfyxaA+deVkrVvADUM1QdJV9g2KjEq29mhwzLr06XZJ6QkyZyhLikFFWRf/htg8gXrVHjLqr5YDEPYIxOjGOvANjYMBVHPURRzxI+F0lkklqzjrEGO8PZGkWTJWF5pSKpbqbAJb/wgMMr8AiIr+UNI84SLiFEOcb49t4auyN7kbKtgEgPNsfKYqu93MeCYdwyoEpW78HUTx8VITy9EpTVaPTnPzabgBQEWdFYi0mjUFBN7rR6+o85O/0ekXqgfmAsH0GPKd2CQ+e31LS6pQKJ09cGRuG4En7vDQpofmEUYR/bJLf78AVTGHZPZcRMl8NPtgp85eD/UwBEcdF3JbJZzXTGV+bVkaQtFdbKDefGiP32nTk4clhlD8A3ciY+i7QcOMr0D2I5cxMnuc+cbm4dBjQk/5PEOXyU9QL9z1yhK6aKWstdnDTyzN1V1GiL1hGAu7t6hYEF8NoIVoLHTq1mlCfGbKa3rmbYRbyRm//mxbqEYc8Fe7JXpGpKZp0voQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63ccd33-14f8-4259-99dd-08d87ee9f13e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 04:44:11.1357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0IRmrXV22Gy0U/0JABgWDYTWCsYb3Hnjj9WBXG5xd5OWR20H44hX1TC7+aIPp2UuiydaxA2O9dhktwl47UAMew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2213
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_01:2020-10-30,2020-11-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Tom,

> -----Original Message-----
> From: trix@redhat.com <trix@redhat.com>
> Sent: Sunday, November 1, 2020 8:08 PM
> To: Saurav Kashyap <skashyap@marvell.com>; Javed Hasan
> <jhasan@marvell.com>; jejb@linux.ibm.com; martin.petersen@oracle.com
> Cc: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Tom Rix <trix@redhat.com>
> Subject: [EXT] [PATCH] scsi: bnx2fc: remove unneeded semicolon
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: Tom Rix <trix@redhat.com>
>=20
> A semicolon is not needed after a switch statement.
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 6890bbe04a8c..a436adb6092d 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2275,7 +2275,7 @@ static int bnx2fc_ctlr_enabled(struct
> fcoe_ctlr_device *cdev)
>  	case FCOE_CTLR_UNUSED:
>  	default:
>  		return -ENOTSUPP;
> -	};
> +	}
>  }

Thanks for a patch.

Reviewed-by: Saurav Kashyap <skashyap@marvell.com>

Thanks,
~Saurav
>=20
>  enum bnx2fc_create_link_state {
> --
> 2.18.1

