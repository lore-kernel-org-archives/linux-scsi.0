Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35046C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 13:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjCON2O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjCON2N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 09:28:13 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C9912860
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 06:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678886892; x=1710422892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hx2tiN6jtyxpVVHUuynrS3mmtA3GkDZ8krtj8wyo2Zc=;
  b=g0lptTFrr8T1odupyjRtPhRpcSSgtnYwcx3m3UOeHRnXXC7jF+S1X32g
   bnddIyzLzFXdua0/x6yAid0Sm9vlSPKEq08f6mZ5vQqn2zdjRI6GWfKhs
   VFSj/mIdSBhtMtobD01YQwC3J4mSpACLnDIwPLwVKlcD3HjbCuH9SvjYI
   DTJOvph6YoWkttsmyy0u+q8dD5n8szThN7LF/GSiv8FhnBN2HBCa6ljMQ
   5ivoFKKCQSyvYKuq6C++731FNfDSZ7hXSEzzW73XO9zgBx0FKmhQAMNp8
   Fbjxx8rUaNpWKDIN2LVB/g5je/kk8KCUeYCVRg9s8CFWWg0arhI4f+p2u
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,262,1673884800"; 
   d="scan'208";a="223975051"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2023 21:28:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/COEOGPzQ22FP62ZNW+wpszK+8jXk4pCzgj6ItpEvWHD7h1TbedPce4kalrbwZPig61M/LhF0iNMDKN2KGBMf+ZmEKqabffpwQIFuzXz0N8ZnsRZUrdMWMAC6sJNQ6ze3AnzfupOngNijLDUx09oKlD/RNzGjBJkVYPVUosU67136R1ypGwIrHlZoE80Fy3XYLG5pjqwd2DDdbg+hUUJG8wZ4NyhY6swhHDh+bTUIgo6g27PQDzFVR2Lip3fcj1+hwWzEt+GK+D00Rwpx6aa2DXVlX0x+se2zJnxLpAQRhQTc7ZIHydM/aXZuidKDAXwph+jwc5PAp6l3JYPQjP2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCVr44OpwjEXvfQHsJaUHUW8jhsw19qc7Jes0Vr6rcg=;
 b=B8u5yjUuYYNgTk9mdGq2t0to55Tf8xmuqfzHKue+Kn0ayTOoIGt1hqMOAL2y/lTuIbtkJzhHUDr44dTPXNBMdFH1npYzbqk1sf78428nXrSXOHjfn8aFAkEUZI4HfNAtKoMSWiywLbxB4ktQLhz+YKeERRnHVPaH8C7vy2QJoXKZHK8mg1LKNpGLpiUO6N7KoHWWaYl71pKNop0MED8Ut2mFWACWuFWKFniHYerzMWemQt5qQ4a8IsbxKelv50nDFLVTwVtBiihE1uaBoJClO18g3K76fC3ljbnfcWjc0zL58DwkLJTybVEnIAxE61EJTcVu8V4bscowvK2Gn9G6Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCVr44OpwjEXvfQHsJaUHUW8jhsw19qc7Jes0Vr6rcg=;
 b=ady9MQ3evsUyXAnQn7Q+2USRUHPpcZ7OcjitmJiZk5G712QIOfBJCbR2PK3f4qu1CWFDRjkY9PK+OhcZFXFK+1o9AnsTG6qb7TczeyxsHue9NhqTc580nF54ubs+dGM2Y6MNhRkra/u8vrcePKHK3EkAc/JfyT9QqMDJ9+MIeVU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB4856.namprd04.prod.outlook.com (2603:10b6:a03:4e::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Wed, 15 Mar 2023 13:28:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::2219:5d8b:8a1c:944c%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 13:28:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: RE: [PATCH 2/2] scsi: ufs: core: Set the residual byte count
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Set the residual byte count
Thread-Index: AQHZVrfKK/6DJNYaE02BMTYlflFY8K771mCA
Date:   Wed, 15 Mar 2023 13:28:07 +0000
Message-ID: <DM6PR04MB6575051A2CE0D8DBDCC93A14FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230314205844.313519-1-bvanassche@acm.org>
In-Reply-To: <20230314205844.313519-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BYAPR04MB4856:EE_
x-ms-office365-filtering-correlation-id: 773a0919-a9cc-4e7c-36ad-08db25591d14
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rw2SSBTUaW8+0ez91k2IhdiP6A47TiAoH8mlkSmyeP+lDPHYUdi0PDCt9xsIuN61DZOjEUtabXuEZXnJMRNJ0Llt7bUomcfkKOwvFjMjB9o/feQ/vpuJeMVjrgWvlkOlBa+WRZefRdegWaowwFF5RPWkRyYN/ufgmjMm7IGnRLpd/0O/D/NXiT8WRL99jD8qf/Ci2q1+O1mjR89XVYB/3YcxHkZCabdsEgQlJwXdW7PedWUqATvD+6zyjd2JB8a0LwnEkwo/eKqGivRtQdL/OHzJ1e9NJrsxLDXeMkAe5x/6z6LPnR6YajS7R9hHn8Pq4XvcKS61qfV0+BQx/xhzqcVocfMjz5Edoz4V2gp6FqiaGTQiy0u8ZMO2S9QeZivIknXIKDM0jO5kLEo6PpcAC1qBUM6/RKnoDAopFOkYN+xpDlgTSdAe5nkPdMPogIpEOLlYedjJ+reMwjvi830XJKcABF8TNQUylMH+SlZROaF/t/McYEKGlCPIqh9PdjJTBg4u8x7OHHSI45zDkVraDboeJD5SiK+hrIvFWT0QhVEoq8Y86+0bNqojMrTV/cHRlx3fdxq0NUl9lZkNwAQUOwL8NmNRTKCWTcAv5T1lcwVuM7HYd8mGLF8m+2CWnSEp3FGIuxL6rs8JoiHWRTGciL/iPD1MXR6y0HAMQ91/6E4Fbcvzsb3C0DmrCY6DdFm+3UZy6yQKpHRXGQeTDF8vlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199018)(2906002)(82960400001)(33656002)(122000001)(5660300002)(186003)(41300700001)(64756008)(4326008)(8936002)(66446008)(66476007)(66946007)(76116006)(8676002)(38070700005)(316002)(110136005)(52536014)(86362001)(54906003)(38100700002)(55016003)(478600001)(66556008)(71200400001)(9686003)(6506007)(7696005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?51FmRe22tur6HcZrxEqHFSK+GY+kbtojI3Dbgg1L0bYboQ9BewM6GcoSWYqk?=
 =?us-ascii?Q?KYwd3V1G810Nn5lBPTu8Y6v7DH3VGZbB9S441pmK0zPTfFXaexi63DW10c5Z?=
 =?us-ascii?Q?x5JjUj+Ia9OLC5m/EKtQGNYOX+IYqX6rq5EEwKf4/wXZxPLwtOxspOiyRmji?=
 =?us-ascii?Q?vF+OJYiF6oDWKqhTjBeHnGCAQVjbpyDSdHplGw6KeXF+fuNNZvPpCPcSSQFG?=
 =?us-ascii?Q?UM5BQvmNUS2834vGKKMD746uXIKuDZc/7VYa0nJFA0K/PluE6N2ZX4RO5qVf?=
 =?us-ascii?Q?O5iNce26+kH61ZDItOkG3LyZXbH9MMobkHZ/awNmcEqihGZMlSSuKOJ91e3D?=
 =?us-ascii?Q?q1Y9u2jnvbZUA9Mfd/xG4r/iqlBucdbGtHQTD6Af5uJxv2Mo/FE2dxQtX8ui?=
 =?us-ascii?Q?CwnN7NdzKtOXp7j43o7paCq7c2YnYp3feY4NfDy3suPNQRbZ+GYmo5OCqf0S?=
 =?us-ascii?Q?UHjN8yW1GEXZ8biezTBUUQoeV0f6aNgQX5Xr0+zCUoRVGxIVwa13iVR9ZFQk?=
 =?us-ascii?Q?gaxIn/ax5cDNMAbfI28qSOcaMXZczZSn02KqC12oAyMuz9QhHOGtsQYmdrd3?=
 =?us-ascii?Q?kAqdCY8K11ozeHbe5egCP9aHc6ryJvcR+1pSgh5O3rwAsIiN3tfGiaS8cNJ1?=
 =?us-ascii?Q?BwNqEla9xoUmIyRN15bulXP076hSFskLAww/IXExRFGjG/G3V7JLaAxVPxRM?=
 =?us-ascii?Q?tehjIMauRyGdYwZphhZ42Ov9Fdt0yytwerRqvBsWQ9DgJ8t2r0zfks3jKBDB?=
 =?us-ascii?Q?eTanMv1pyKSCtRKNXJNWcPgIK9Df7EKvLgxa2YG2wSm2ZVd78A4bYld0//f/?=
 =?us-ascii?Q?HpdcahzzZv5UBUVhBGxi3WXPSghQRmmCLLBIOAiR37oFG6GHGTdm8kLg9cAb?=
 =?us-ascii?Q?kXorImXRkWMNSqvaw+AbqinqVoG63QVYM8EtTqp6gH4PIJu0GdFxBPkQ/NHL?=
 =?us-ascii?Q?xcmR55tH2fyXFHWFhakQAygdUyQ2OCAdgem5fxhyWnSBkQNEYJKKLZaZcAuZ?=
 =?us-ascii?Q?MpQJfD2DfCFWAFjiUix83gktjAZb5JRzoo7Vtn24IcN4E19yACHNvh09FnRk?=
 =?us-ascii?Q?0+yC9LIbiXXm6GbiDK5o29BAs7xqQfJ+xioO7WmG7jlhDrDl9fncsGpwtqFR?=
 =?us-ascii?Q?Zut8BMlxoB5eteJdsPznVLzqfGA96Aim+q8LMd5fzBnvTEs4/jONVKsXUFAl?=
 =?us-ascii?Q?XeXwiKcYty/6x4NRnrs4IhWfqhwCXOSqhHZTw5n14VAYVPcvv8j0CxEL+Cvn?=
 =?us-ascii?Q?eOuAQl0s+p7DbgD0+BtKUXZHjbqtE8hWkp25YQg/e6Jw0migNSC+zYsB3Y+/?=
 =?us-ascii?Q?iSZdApnxuXcASI/O+grKfk+9YYmEtJQvUctNHneTZOXLpfBk+RkgVlAbzx6Z?=
 =?us-ascii?Q?rjZHBHK1w2DoqmTyDzKSQmbweVyTUFuhik0hl/x6pjnEVD8bojC3tmlA+st0?=
 =?us-ascii?Q?nJLN726LhkyJWVOhPpwTlz4pjyOEat0txH41pdwvcJfsDVFPTSZUv8MzTNZL?=
 =?us-ascii?Q?WAmgGm4ozt63wErq+Gf4XbOq3vxmHjULr2LnbAgKcRP7s2Be3KlkI+EvPWi9?=
 =?us-ascii?Q?8jmqQuH5L2jKvxs+J7ixA6SdHrgoSlSGz6jOiQT5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?MK0zTvsDBSY7qqZklcojB6Y7BFjhb80KIJupL1SIGzlDFZilu30Wt0UnMO2q?=
 =?us-ascii?Q?pMkYEqwXsYOAZ2gB6SjEx0Nob/Ev8I+CcpGjH+G5lhtQ173u00yjVyzg9BNX?=
 =?us-ascii?Q?edzz1nRK0eo8+/gWzANm3KIDHA/1cryYxze6iRWm9skAFUmdprH8XdTqnxoq?=
 =?us-ascii?Q?OyqO8qp7o4MdCpmjNQcJlfR8PmMBNNU01AuprnwMHfrj7RwADtJnj/btrCTD?=
 =?us-ascii?Q?uICcilUQlw9Dk64vB5ITc6xMDEmbqFQpzr2nXNkTvEHVxt2muFbFJQnYA3Y5?=
 =?us-ascii?Q?1M+TemWU/csGA4a+m4h5OLEaSKHPvYobAclmTV3T9dFt4jKwkGPc3PPhiSTH?=
 =?us-ascii?Q?1xTO9JHlkMhwEuZGpBtkA43utbv9RL0Kp3efUkUY8FQoLLwyZTWsMrqP6rl2?=
 =?us-ascii?Q?7hypVKj9YvRk5IDiBIbvlI2eGclAjE6EtpVpGaoXiN7L9KomnRsW9OdkN9/0?=
 =?us-ascii?Q?a4hDYvrtwCRei2vzl0LdwZhg9sZ0R3vhAOlxNj4nDqo3zDSfcBlHknl8VyL3?=
 =?us-ascii?Q?CF8RS/mWtWfn/GUp3oOxrRHroT0LxgGipaEc9ZFQzezS9E/oEuxm/+mWGKJC?=
 =?us-ascii?Q?VuVQxr7lb1ecrc46QIbUEI26EfcqAcUhwNCHJFzqlCvmDOh5kGmwAXta61w5?=
 =?us-ascii?Q?cjBkmo6SAQiKIyOv4AJM4mtekGgLODJa1+zNmCrmzH6P3qA3gi1D/zXe10vW?=
 =?us-ascii?Q?F/XalfpR+Oo9ZiJAREajH/2nQI1Z3y98cydE46tDxoLLfQqDft73v9eM87ot?=
 =?us-ascii?Q?lqinGG1jBrmVbHe/ZJRLtXQOqUAFUGy/DJKKz6BTyF950BpUE7/01cosh5o5?=
 =?us-ascii?Q?ZMcQvRfJ8m4W29qYrejT7fwoLDWDz3ooiV3QQtosw1KrlFqST5lTKd1Nze/M?=
 =?us-ascii?Q?imjQaUuNMlXYNxZ0R/cap7YFJWflnhAmJeUwYlqDIziv9NSOcevVFSPJRTSL?=
 =?us-ascii?Q?8JfdtCS9n2kaQ/1grUPMza+TJKuY1b6U7W037IbYvp8tMQKjqVgNorsap41o?=
 =?us-ascii?Q?t5UCVhKv3tiBKkkknk3WUquwzA=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773a0919-a9cc-4e7c-36ad-08db25591d14
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 13:28:07.2613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /VflbB7Aw/MOZiXHD2OTQKko8YMaJWuZA4LgALR9EtsXwnW5Edq1bYgVw0JCjnE7xpsS18VYPI6E6H7AQde7ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4856
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> It is important for the SCSI core to know the residual byte count.
> Hence, extract the residual byte count from the UFS response and pass it =
to
> the SCSI core. A few examples of the output of a debugging patch that has
> been applied on top of this patch:
>=20
> [    1.937750] cmd 0x12: len =3D 255; resid =3D 241
> [ ... ]
> [    1.993400] cmd 0xa0: len =3D 4096; resid =3D 4048
> [ ... ]
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/ufs/core/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ce7b765aa2af..7bbbae9c7c61 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5238,6 +5238,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp,
>         int scsi_status;
>         enum utp_ocs ocs;
>=20
> +       scsi_set_resid(lrbp->cmd,
> +               be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count=
));
> +
>         /* overall command status of utrd */
>         ocs =3D ufshcd_get_tr_ocs(lrbp, cqe);

