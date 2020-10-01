Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946ABC4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C5AC20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QQpXelQV";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="OTRyy5/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbgJALFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 07:05:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46828 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731926AbgJALFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 07:05:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091B56rr015325;
        Thu, 1 Oct 2020 04:05:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Rfr2Z8252DAjqtM8jN4gX+9mbUbZM/x1spJUhoGAOuA=;
 b=QQpXelQVaj2ZDVJrdT+o3/GRGN6cIB15lhSy2EKhm8I7j2pyJ8vh/9a37lqQc6bKqMoo
 g5Qu94Q4tB6BO0anGawHf9zcrKFN+PML+SdIgIA1tmXENT2J/vcyh5EPD5BrUxE673OP
 9nxsdJB2kCB3hLT4byG40Cwd0uLcGPSBuMGNxG5Dq2JuTDzAjZGQn/X+3FrqZmKMLpfc
 5SBqOiRpou6TtiKrIsUFdE3wii4U/x1sqkGUEMkaXKvcm/3a5TV+r7SxkyhbACbl0CxS
 SK5bek6BUCtFNMwwzgpH1WXFWjwJtyJMaCdoorfCATqdY0avqxdwgkJ/phyl8AR/Tjm0 NQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemm9ec-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 04:05:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Oct
 2020 04:05:13 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Oct
 2020 04:05:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 1 Oct 2020 04:05:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaQ4fkKZ5UQ6SpUg/48dtH59IFujkCCYl7YXfaPeqi7nAB1ktBbvk7k+fmp6MGtuycqU+xpNbt5kF3t6zC/AnclLXPMv/bDBPUZXzsj2L+1nz+GI2FKoVCaKDj0Mr6GCNiBlWoXU/6hn07kilyBoCCcGb7r18Dlvdmw0C12GFGCzQkPtKSeNG+C5bG532LShtljYAlUDWe0H8qTWQgwjqS3P3aa8r+kQ6aNsyls40G9Tuwp1qVz0RN2in0zBK/j4bNom6c9nSt/k/LviOXq5/ZODK6jkCVMF49bS3Xhp+cpJqB87tZDHVBFbWC1S2e5gskAZAY3DQjSi8nN3QIGp0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rfr2Z8252DAjqtM8jN4gX+9mbUbZM/x1spJUhoGAOuA=;
 b=KcgP8wjtzUTvft08c4oFIabnMiZjneNIMMOPFTNsIt/Qba1W2LGwLU0q1co8p14YYn9JtWdMTJscxCE9LHQ507pnct46mgeDwVWeGmsRjfbuhlM41eBVc2SSNHbNsjh0qMTehJBMz4Y29o+D2wmRROw6HtbIB+5AqFkKm1OBE4ynOzOXJmdIS+VtN8+zXbYorsn/F6Uixw/mdM8kFUkTnUJdOZeucsrhmFFG3VNNjCLFSdriRp7Iwe877Oy+JQyDS6Em9Go4J2bBtDAgk5tmpTICeI99KqTAEyHw/FjPvtvv/OmAYLo5SWN2MIX4nL0gaQXPyCR1U4KP9X0DzCD/Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rfr2Z8252DAjqtM8jN4gX+9mbUbZM/x1spJUhoGAOuA=;
 b=OTRyy5/XrkP6w7lDgNvKxtGy6+o02di+RdZvzU7Vd5qhFOkkf3lrNm5jzfOl+vCA7QDl7SoTvWLwzO7JCNl9AEgCHffvxZgHNz7yP9K8LKqb+9qFLHBCbd4KoPdvSWphYxqnN2yF/XNRSq2aMEessnW7NbuNqLBoBsmiixN/Rak=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM5PR18MB1017.namprd18.prod.outlook.com (2603:10b6:3:32::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Thu, 1 Oct
 2020 11:05:11 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::e9ec:af5d:dfbe:2099]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::e9ec:af5d:dfbe:2099%7]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 11:05:11 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Ye Bin <yebin10@huawei.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: RE: [PATCH 3/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in qla_dbg.c
Thread-Topic: [PATCH 3/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in qla_dbg.c
Thread-Index: AQHWltDVqvU6kimsZ0iRjxdFadQTm6mCl8JQ
Date:   Thu, 1 Oct 2020 11:05:11 +0000
Message-ID: <DM6PR18MB3052A276A44699A8420C2051AF300@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
 <20200930022515.2862532-4-yebin10@huawei.com>
In-Reply-To: <20200930022515.2862532-4-yebin10@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.90.37.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf5c2b44-bbd4-4955-de7a-08d865f9ddf2
x-ms-traffictypediagnostic: DM5PR18MB1017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1017567FB377929CD4883C4CAF300@DM5PR18MB1017.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:207;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KqoWS3P4Owa6PwD9yblUNzDoBF1whyDcEywGaR/g8lNBrXbjgHEymr1qtTzziR55KlX5ew/v52n62170yZ1jLVckNiJozCmZb3z9j7UGslVYUZiB7xTRc3Z3gIsivRs8byoibEqrWzuJfPV+uv0+TF88eS79+bjchkMQTOdjif2Uy2AOuj9Yt0fEoBB7YDOVHLsvjQq71L/jQWhuWgRxVnEHfOq2eZt72zWO00L3/eKHDp3BA8GBNV0i9rVtP2QIsVXl7AIEYdWGn+9k2ScMfUyrI3IDg8TS8i5+QcxFBCp+RyH3gWw7Vfj9gkvoaVYmz1QYGODyZzEpXKx3OPLIQ+fv8kjNVswG3FD1E8CZu79zuiHc8b+Tu/aj8ErI1aOm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(110136005)(316002)(71200400001)(66476007)(66556008)(64756008)(66446008)(52536014)(66946007)(55016002)(4326008)(83380400001)(9686003)(2906002)(33656002)(76116006)(26005)(7696005)(5660300002)(186003)(53546011)(8936002)(6506007)(8676002)(478600001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: F/yUql1bOLAgKCJlhB4IYCiSzcqwToYL0E2eAI8oEUgQ1qWeCNpnOn7xk5EacKtkBWHasLYIKiySTnRn4FUxhkwhVBsfbUQOV3LXS0wW4WG9nTNFaTRsSK/ZaOZpwNVmcWRCGObz/MkuK4DDwMf31JI8ml/zm5ksGs3rPOasw4KFhBIm32yud703eW2UV/7g1tBrysX8BVrd87AeHz43bMSIwhkYhpnSWqdeJeGr8TtUDgmy1Af8tIgblh6BJI9/cKIX/8EdrhgUBN1qjYCTr/Vm4D4gx6TWjbFrK8iwqu3MijKYDKagZml8ZX1GBrTt+5VEu4b56xO6Y10nRKTdOaXNLnf5A8eV++jAGtOsmrcPg6sGOlSCT6xKxEKSn9zYN2ssKR4xbUlP0e0p1wyZnjXRmoBJevvhKw+qS5IfLwSkvDtgT3OlDAmBc3s427aKv5vdlrxJo4GB/oDsTT18cucJHyqY+y7Gs1N79HynIYOF+JzTdBLe358px9fG7ToD17QBDMBf01QAsomrkbqLW+wPaTA9cfyfpIUO2FVGRjTKgkEujdsas/OOqURAvCCalME76YO5fhM3ozSAs98t9/nq4KfYnkiBitA6qJHMIGzBrYk8XpbZDqUNmnVSp52NhiAqBSe5Kr0gsaXSLMH11g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5c2b44-bbd4-4955-de7a-08d865f9ddf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 11:05:11.6449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: duFSgTFASj8bXMpYQEDEt6/T+7cPZZwMTQztdziNgxjN7ag5Pcx4iGLD0DQEW1bp0f25fu/v1Gf9m0JD3ssbIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1017
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_04:2020-10-01,2020-10-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Ye Bin <yebin10@huawei.com>
> Sent: Wednesday, September 30, 2020 7:55 AM
> To: Nilesh Javali <njavali@marvell.com>; GR-QLogic-Storage-Upstream <GR-
> QLogic-Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org
> Cc: Ye Bin <yebin10@huawei.com>; Hulk Robot <hulkci@huawei.com>
> Subject: [PATCH 3/3] scsi: qla2xxx: Fix inconsistent of format with argum=
ent
> type in qla_dbg.c
>=20
> Fix follow warning:
> [drivers/scsi/qla2xxx/qla_dbg.c:2451]: (warning) %ld in format string (no=
. 4)
> 	requires 'long' but the argument type is 'unsigned long'.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_db=
g.c
> index 1434789c9919..bb7431912d41 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -2448,7 +2448,7 @@ static void ql_dbg_prefix(char *pbuf, int pbuf_size=
,
>  		const struct pci_dev *pdev =3D vha->hw->pdev;
>=20
>  		/* <module-name> [<dev-name>]-<msg-id>:<host>: */
> -		snprintf(pbuf, pbuf_size, "%s [%s]-%04x:%ld: ", QL_MSGHDR,
> +		snprintf(pbuf, pbuf_size, "%s [%s]-%04x:%lu: ", QL_MSGHDR,
>  			 dev_name(&(pdev->dev)), msg_id, vha->host_no);
>  	} else {
>  		/* <module-name> [<dev-name>]-<msg-id>: : */
> --
> 2.25.4

Reviewed-by: Nilesh Javali <njavali@marvell.com>
