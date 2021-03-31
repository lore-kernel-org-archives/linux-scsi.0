Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E505EC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B186101E
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCaQqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:46:51 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39469 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbhCaQqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 12:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617209190; x=1648745190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kijc7mpzTmoFQUrs6cTx7Isq3P5lvw/joCkqAOfkxo0=;
  b=pMuGuO3ycfyIlolIVmTmExgGmqWUFGYcV2VzZX4KZzNLVap+Yb/SA3kZ
   NYqX4XSxEIhKh8IKI1K/OlsU6WLDNBxBf8iYbllZr6F/rUDeNUgD3n6Xu
   ST9uiT3UWyfW/HFRJecslQlH8SW/SVILK+sA70XX47EO35MOQph0vpg6Z
   lmQeObJ/OuH1bBZgMTjeS0Iz1rzadGGktOY98izJbGWj9Ci73216tkv3t
   vI93MeV2DmZ7dJ7Qk2BPDwI3QZSBDhxuNMpIUUccnTfiCEfWZaSevx00e
   nlkxLlxhj89vOVgpQfzx6Uq7TCO4hZU4hWd38qMBp3E6NpRONgWnVp3iG
   A==;
IronPort-SDR: rY+QJgqxCUX6FcEsaGRp3TSR4Fis/Le1Mzj4KY3jw3RRwrej3of7deDVsUz9xFR1UgVw43OOhO
 GHd6nXFQYgwA5P4XS91I0rI3SkRYlJL5nYTMfoiZ/miWIKoJaAYvWOQ2mbQnfk3LndKsb6dK6+
 ocCXiHAu05U4yDAAbyMPW65ti6DB6Ep5XGyoCUzgqtpnwOcVoanQc1jeNEM65yPvb5tRTni2Uj
 M+64mKs+Lwxaeug2WPFW4MWHUcVYhjlrvbexRSvlBjbf8bK/SRPvWQjPA3LTTyXSojpRquwk2e
 /JA=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="163372368"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 00:45:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liNUlopz2FMfyDNXAlaI65rezpOgr1RyE9aAE1MuOJxGk+xVOeNZg3rHhhSVN9Mz6pZtMDazWDhpXD+aoINgGtQIOU/dqc5ihEaVBlP6vrc3Z7Y6Jjbrx+NcCpS7+AxkNiDpc1f1pnyzDcDO466p+4AfcBlaZcHzBR/0kPbIrGOSypzTDOCmjaxAXikIWNjtygRy87K7Q7RWx8sqLDFvlnmiWzfoywKqI+IFsqzE90olaDA2cfyIVklvhvnaC5rTBULsg0pHMjqpGiF6NWoeDl5rX5WxiW0mfdRJmJX/tpFGSMrXCc73qgJPvBSSzX7KvuSqBzKiMlQ34/EP75joJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpf4eQV4k7JcxnoFeHGPAm1qZf93ThRWW9Z6ZnivMIw=;
 b=aktKW/9eTeh0kzDfhe7kZ9hZ23/Uqsu1Yw5T8F5o4tctHN+tALBPkW+TbwR9JlLCkDJpkxcBnQw/3HmHtFC0ZHKvwYveQfSGcDq+BkZp/L1EaCXgmPoB+ToklQwb3AwGEpYtL8DnWVlz7NzednfQpFfC2dvJN+1nPE6jr/UMPOWVzQVVUlwRc5RiYoWhoDhW3ZQL/tZIuHZ8gccVN2WwZopLJ0HSkuuBkoftwSrYEjGMD42F2FDOBRsuGVDdmNt45mlRln+BFm9rBec6+Z6aqpXg7RnbD/hEu+P+onaV+a9FICjHnkiB6UTc4cgKqlXDCZNCcikbyzGiHxgKXaXN0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpf4eQV4k7JcxnoFeHGPAm1qZf93ThRWW9Z6ZnivMIw=;
 b=tm6XHxrli6ebfE5KoZ3yPTFGLDQ/P1fkITgMDOF/j9j2w19+w2oPu1rm9Exuaajzo1Lepg5TVZOjkJgfLlJJmkmt3bcG/1rg971NTkVrSn/+0Fc9XYNNQKlzL4DpF8IQq/i/JfCLKXdBfOc9eTyvjcQxssF6NKRN67wk6ISwbZA=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by MN2PR04MB6333.namprd04.prod.outlook.com (2603:10b6:208:1a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 31 Mar
 2021 16:45:04 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::4c67:96fe:ee31:730a%6]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 16:45:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] scsi: ufs: Fix task management request completion
 timeout
Thread-Topic: [PATCH v4 1/2] scsi: ufs: Fix task management request completion
 timeout
Thread-Index: AQHXJeluDHVEm07RiUyOVABPGwr9daqeTcVw
Date:   Wed, 31 Mar 2021 16:45:04 +0000
Message-ID: <BL0PR04MB656448E22577076A27F1EADAFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <1617166236-39908-1-git-send-email-cang@codeaurora.org>
 <1617166236-39908-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1617166236-39908-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1f1d8bd0-c73d-47a8-2c42-08d8f4645596
x-ms-traffictypediagnostic: MN2PR04MB6333:
x-microsoft-antispam-prvs: <MN2PR04MB63338BD76F34D9F3265CA584FC7C9@MN2PR04MB6333.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jk75/NJjnIqwVOVL6uCikNyWd6mtnei0vhVJk2XGjyh0wct5IWClX1NugPREvqTfGDspYzhxwUNyg7VH2hc01xsmgocC1YDWMeIQT2i4azStgxKGzbGlWNAXm/WdXqfFXN4gKlWwubVsKwfoOy7C27UwUpve2rOyXIAS++bxjDeIo1qJDFIs+tDeOprIfQru+POqkaX5K3PI3TF7ZmOFKSWO2xXm/lop18Ullvnx+FS78W0CTkyQxgojcofBJsg57/zyXvpsc1cohvfz9JnOR9j73jctKCDcz4Av/erVvRCJAXgaNAGK/b3D1MBOKEV5yp/Q5sf0fYO0kjZ6RhIs3v7WKvlXkqqBPCKDYZ1wer+AHO3WDHSWB0EPFzC7pvtYYziTQsO4V7lXZ9oO42PHs3DhbLe4k2klyKlSqJl/AH00OnKaLsmP9AIB/mEN/gWpRiHfeu6hBEuB4TqcfWYYS6NudZv/Fq64wM7+hCbbswcU8yh20AaCbovD9ZcLmeq/q1m0PPGVOOLPJuEVf7NGIIotpxeiox8wFRVOpsVOX0KQdmmsBLb1OoPYZRCthPS0/RAxz6HiuE0YjDU7pDgdgRsqvmBZUupJYYU0DXx3Rocx4/KlAfjEfn6uicTzYiwfBiF8g5iN53Mp4nnf7vznzmGwkYc8QFSQb0zq8Z5Ksvk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(38100700001)(8676002)(76116006)(33656002)(316002)(71200400001)(7416002)(2906002)(186003)(66946007)(110136005)(54906003)(83380400001)(26005)(66556008)(66476007)(55016002)(66446008)(64756008)(478600001)(8936002)(52536014)(5660300002)(4326008)(7696005)(6506007)(9686003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fXhmZlbGA7yljta1NzovTxdelfvudOLAz+9PUBzkjPDj1Rjq5uaJvZssYITg?=
 =?us-ascii?Q?iRzM8zhFYv5jYBF6RqJKAYOPWS2d+C9eZdYxMB4YHaW1VnVJhfjiuFp6foeE?=
 =?us-ascii?Q?IVm1OsNWxQT1j8+nFHG78U+UWkqrBmVS2HJrSjWYpojRuZBEscvddEgywXO0?=
 =?us-ascii?Q?BF5FDfVQs1iqbd3mJ8WXc7v111amPpBm9dCz3MzYyb6a6ncwKomB15cRr3Q6?=
 =?us-ascii?Q?mOnGDkUkKxpd4VplsTQsB2DjwKNGXJqKtp7RVTmcKst+BUVEqfWJ5jmwUvkJ?=
 =?us-ascii?Q?AKA1TFH04YyXBdpolfpuKVZmSzvqTO02DOLsBb0m5NcRCBa/Vpt6lZ25A2ME?=
 =?us-ascii?Q?SYJkeYCBwyRG6RHRkIX9eYJIFxzzW7lkYkfVvcjJk5yOZH04UvNWji+eVuHo?=
 =?us-ascii?Q?8B+wGboiukxLwLrzr8GQ07nW3VSryBljT/cUdDDWyUGK5K8sq8UaStrGxP+x?=
 =?us-ascii?Q?lqs4MKZ/bIEI80kt2WmQAn+4ANuP5xrrc7GTGAAr3eZKHGppIIq7IafoBIKF?=
 =?us-ascii?Q?sJ7yv+X4vKlaq5TuihuPHtpqim9DfrSa9t6cd9/eWkuI9THL4NtL1U0sf7+7?=
 =?us-ascii?Q?Nz3hzPDEuJ1hlkae4U0gX4LX7Bau9n0ZNA+R4AwvdkH10bIDqqfu/+tFe6rK?=
 =?us-ascii?Q?3HKrzt89sXQz3ZNJE1JpkNXqM++dYgQMgmzDBux4T0gPFKaX/J8CL9nqhaOW?=
 =?us-ascii?Q?lOvRyRIFnNFjBsG1VltjwXaaKKa/vxXKuN2Fu3TahDIXSx29eRJXeMkGOJjN?=
 =?us-ascii?Q?0joiJWoxO3j5czLYgdfsSrlpRAq56aM97HO2KAuNmXZy9FtHfyrNBsrIia3n?=
 =?us-ascii?Q?3B5HqcGn481IL4Rbtn7B4rnofbxe7BGc+34TVkPD/ib0AIS1n1M+8+841yVi?=
 =?us-ascii?Q?iAKh9pJDT3cXgIF+buzl5ReJ9PztvGlGAlbghp34xK8TM4hvJOxShXIV0TJE?=
 =?us-ascii?Q?78Ce+9af6J+uBZBuaGqAj9lc9YqQTOMDdm08HYQU7wYLborY3iILoJNLYWZs?=
 =?us-ascii?Q?jHIByj81wfj3Fff2wZoHmtg9rqQh/hHfyFVDH9hdeQB5r+1bKVCpWHaU7+FJ?=
 =?us-ascii?Q?dIAWO8ARkjZplA2yHg02sHQcxtr5Zr3sBWRvydYB7QCQXDdCw9J1GkpKlZfH?=
 =?us-ascii?Q?d034IoFYbcm9luc+0dGiqAWwGUEadQl+Y60ZDjtY5QZsA6p9nlD/a80jY28t?=
 =?us-ascii?Q?iLuOu14K+g9Mni3YSkDZyKnydO8dvAfpQfH1z4eCLMq5pexwHndWs4U48j6N?=
 =?us-ascii?Q?moVzk2jlcySwMgdddzJVsklImduZJeOXuNFVLh8wV6GX44ZkbQ1BbRYVXDh9?=
 =?us-ascii?Q?DwEKqJ8M2VeW+fhEM+Im5YSW?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1d8bd0-c73d-47a8-2c42-08d8f4645596
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 16:45:04.2378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y4CGV0B5/9iaDYQsRMI/8SjMuLbB0ENKzN+L3Y6mmz5uMTo/dVYCk9ejkM6ebu5Q4cJDLQrdPd0mBO5AsesmxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6333
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> ufshcd_tmc_handler() calls blk_mq_tagset_busy_iter(fn =3D
> ufshcd_compl_tm()),
> but since blk_mq_tagset_busy_iter() only iterates over all reserved tags
> and requests which are not in IDLE state, ufshcd_compl_tm() never gets a
> chance to run. Thus, TMR always ends up with completion timeout. Fix it b=
y
> calling blk_mq_start_request() in  __ufshcd_issue_tm_cmd().
>=20
> Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate =
and
> free TMFs")
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b49555fa..d4f8cb2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6464,6 +6464,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
> *hba,
>=20
>         spin_lock_irqsave(host->host_lock, flags);
>         task_tag =3D hba->nutrs + free_slot;
> +       blk_mq_start_request(req);
Maybe just set req->state to MQ_RQ_IN_FLIGHT
Without all other irrelevant initializations such as add timeout etc.

Thanks,
Avri
>=20
>         treq->req_header.dword_0 |=3D cpu_to_be32(task_tag);
>=20
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project.

