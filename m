Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39A8C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 12:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF1602075D
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 12:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="je2tbc1z";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VSdXqrZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgHKMUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 08:20:45 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:17766 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbgHKMUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 08:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597148436; x=1628684436;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YUyOKJBR40/MT0ng/2QW+6KSy68wt+XVtCajjHAPDFU=;
  b=je2tbc1zxL5sNVCSu/bsuAJOvz8woMUhStDGyCP05+hgugrtsxqHI3vt
   lWIYh+pzj9hOsyi3+HHca6jC3zH4nQZElUrQTO/ANZPqzM8B6FnzIK+3P
   /8pgQnEm8klvIx3Kx6vyLArd0J+TPUek9xNyUa5JV59VzjcPDd5vrhBrr
   VMlVy/Aw6Y34bwAgXr2hwIP8Tgl3Qhs08//PTLaN3UAtsm1SC0ojOXcxR
   2tKLuwEfy1I4RDfMejjyTmZKZciRtvovnfo9jPTXJ56wBEJzKT4yja0Qy
   ybTtw7sWZ8vw+ZUSc1wbofg6jNhTZZjfyt8VUCmzfH+ofRqymR4KWTh0d
   g==;
IronPort-SDR: doh5YiBaw+a6tPrHb7laUNE/N8Rbx3cVf8I83LPSpQB//hkuyy162jfCabmtuUHn/outJ5W98Q
 wvSJs8u1p1Ku1KYxTxzB2R9U2v7uMEEkFjKUjnGWR6UmUU+GNkbLg8pe6uZZlb5qQpBh0MLL+3
 qmJATghFtcejDQUh2Ey01NwjwgwgSzs4wNUHVGIDU3a1l3w7C6L9JDzZMVzefVqlyVEtdkhN5j
 w7SFhAIWyO6Ip/0IG8ZZWhihzbcBPAmKZEL7KSeEfvWFySU1/HnNmrYy1yYuxINwHJwH/fHjS/
 /SE=
X-IronPort-AV: E=Sophos;i="5.75,461,1589212800"; 
   d="scan'208";a="148989681"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2020 20:20:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ftv0whBauaD88ohfc6AZc+43ef88pJB5agNSrhs/Ftz0Ox3yItbvHSIrMefl2u6It3XuOpaA4nUFYvy3hH9cD9EYOSENWSD0OrmYnjzpLK8qsjvChSanVUYw1bPQbYgwK1UvZXtHuuL1aVEUNmZcP+Ia2YidGmYu8wnYC/sjYEd1W6f22C+fTkexC7089b4hLRhA1TWm0fOGEfa0PoxosAwpPJQPQP0Bg001Y2pUlMCI3JgfDP/Hi1YVzKnvpVVpTq6gOI90GVDXVS8NvUTz9dpMC+UXfndl7VzFqMks9I+SFRAK/Ztf3OkAEPMlylnRWTMNFksQwGWjUY8cV2u3TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smIMNEceCoetEbne5cyVXD8FRtst86fqI/yBgUzNNjk=;
 b=FXvfQYvV4vBX3DfEyrcvCH90QyxuE+dyWF5o5xIfYTsfVLfIafggWtT4VvRHDQuqV1SnEcV1OLP+/m3lUoWh069Rju3V5bBjAW055sJP3nTqc5o0iPQk0K0kt9c31FkNCY1+p/GvYks9TnyXTDQYmioePiMFhRRKsX+MbaQGW8SlEPIolDazpCx1wQnmzE5PvqFdvrA49k7r/vnFQ+jqT+YR7eNgrdZrekfs/7jzFDnw2xet+U30XCtzEDM/AS6QtWXBaYr7YstASCGr6JFyFwyobsnQdb89R/HvPNgxaREn6LDQtMzE8JpumFVNdGehSG4SOHF2Bd8EvUKOhx5sPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smIMNEceCoetEbne5cyVXD8FRtst86fqI/yBgUzNNjk=;
 b=VSdXqrZI6vW9RO9Oq372aAR3b4sbpY0Nc4AuYPsIaUV1avyiiqGZjQt7BNzItAzftkVSBtVtTKgDycfT6yp2uZL2tydVpO5/k/owPDDfhF6KOyxfSAfHbAW/6pCQcJvQ9E2ZMLJPohYT/KIEFVrLJWPz60cO4OaGQVCDX03wxs0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN2PR04MB2351.namprd04.prod.outlook.com (2603:10b6:804:12::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Tue, 11 Aug
 2020 12:20:26 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68%7]) with mapi id 15.20.3261.025; Tue, 11 Aug 2020
 12:20:26 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Can Guo <cang@codeaurora.org>
Subject: RE: [PATCH 1/2] scsi: ufs: Fix interrupt error message for shared
 interrupts
Thread-Topic: [PATCH 1/2] scsi: ufs: Fix interrupt error message for shared
 interrupts
Thread-Index: AQHWbx4HOuqfYrnFSkanGiAtl5Qaa6ky1Mdw
Date:   Tue, 11 Aug 2020 12:20:26 +0000
Message-ID: <SN6PR04MB4640A7618C2425D6E837C20EFC450@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200810135548.28213-1-adrian.hunter@intel.com>
In-Reply-To: <20200810135548.28213-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa4daf5d-8800-4db7-9bca-08d83df0ee19
x-ms-traffictypediagnostic: SN2PR04MB2351:
x-microsoft-antispam-prvs: <SN2PR04MB2351EBFC5A3360B191D002A8FC450@SN2PR04MB2351.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Dpvg1NBZmNGcE7vQ3QNJ0ie/Jfd02DXx3io8y71eefzsF9FdLWrde/j0DhCAPGxUmYJ868IN4Dc/FlFzJlzv7j7lecLrh07bTfqmyBrtJrA4koqdBjkEFg/1+LM9sIvzLx+WeUZrsZKjxkpAAIEcP58I/nPZ/4vviL1TU7vldhKXjOWFqI5K55MMeQVvq8ORg9YoEH5V4XDXllddo5zm1SAPLSeSgi/RHh3b3dmc37KSLXpq8KnAFwMrGuse5/NnaAuMH4lSJeifcD/6F+ccC4qO5fb6pvO+oExsamqtT+2vNmwC4be8GcywvN/6cV+2aQwbMgvXGf0of8YaVnhfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66476007)(9686003)(71200400001)(8936002)(7696005)(4744005)(54906003)(6506007)(4326008)(5660300002)(83380400001)(64756008)(110136005)(8676002)(66446008)(66946007)(76116006)(52536014)(66556008)(186003)(86362001)(498600001)(33656002)(55016002)(2906002)(15650500001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vxpRegkMDrLScNNerW1Zom99JnknG7pSg5A50dRR3D3QyNHiyOqz4q00gpPzMvRep1cpLCWJQJvUA/9wNnSqQYs0pPtHrHO8kJcC7tqWxJROZjQSrEce/r/Iw3cG+5ywUY3YhYbeSZOGEiW3MV60QUZgilSXPLxUw4HqEpDpFW0JdJjUAtXpCVHLKGQQEc+ajltEI3cUyMSmsUouThyJcIWU3/vvT1rNGj5b0Fg/tjFfs/xvrn6CSSDkJfzUdcXO6EUQFfAFd+e8dOfWoNZ7whHKIbQBx0KxW7bq7nnon4iGfEEiCoDZbcnSX85RdLK8sTgVSYQ5rX0eIVoHe2u4I6B45O8YKTLTifCUOn/c0L35mAA3Cb+5Rbrir2HiWXR6n8w0zl+dUOxD7USe3PnpaLUE5NCdqXLewgwTm5hVMb3/1x5Pxc/FcZ5pNg794strbxqfUIQA7jnuk4H/A5toZ6wVTd+bi/m89UQRSWVV/brF/Exz2PTovNv24f5bpZY1fCBGyEAcNr2wqzl+dnMkcBMgca5JlGEV3Rb0JeE25HPDtCsid6Rbt4eWe6nehmqOaBfsZLKDSnAsicvYVk6L5p8dX0Sx+/mY+v32Anb4AvjJAi61CJX9TZqx5oHrr1BS1ASTwGxLGSHWirpqHDPBtg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4daf5d-8800-4db7-9bca-08d83df0ee19
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2020 12:20:26.7776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0SRt6lM3+nHYCcdzBphOmA5f1FZ8+Rwaw1/rP76ckDjs35W7aYCxU1eVdidQyv7gmGcFeJVrfZnMtVUwZc8LBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2351
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> The interrupt might be shared, in which case it is not an error for the
> interrupt handler to be called when the interrupt status is zero, so
> remove the message print and register dump.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: 9333d77573485 ("scsi: ufs: Fix irq return code")
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cdcf56679b41..d7522dba4dcf 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5994,12 +5994,6 @@ static irqreturn_t ufshcd_intr(int irq, void *__hb=
a)
>                 intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>         } while (intr_status && --retries);
>=20
> -       if (retval =3D=3D IRQ_NONE) {
Maybe    if (enabled_intr_status && retval =3D=3D IRQ_NONE) { ?

Thanks,
Avri
