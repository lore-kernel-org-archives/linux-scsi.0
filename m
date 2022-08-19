Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EF8C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 19:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349461AbiHSTm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Aug 2022 15:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiHSTmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2022 15:42:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD91113684
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2022 12:42:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JInrU3006441;
        Fri, 19 Aug 2022 19:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fPV9HJh3PzuM4Jz3gBkL8EdpkqfynlvBH9FIX0k9iCQ=;
 b=owPXp6HuPZR5G8mzqyhy/1KXMSZh3fHA1Ymge7Ar2W79OB/AijKbjA3VQqAq7OrH9Kp5
 b8Ln51cRpTugTbSOeP+7jHganX36HtWZ4LGu4QCNuTXVWrF/aHJhrUUKNg/34uoM13Bd
 Gkcjh16j5+55kO9tHol7dTxXgGqYhcbiTw0IyV8KnMEc9w2QwagpSf9zCd+D1kXGwICY
 goI+/tP7VxaBytOIFM+Vdaye4Y31EBNTxLzDTOZyqZYJgC3pN0Qmx7oOkor3tAY+Qy1w
 qyoYzvj0PckFGFwnro95rH0gRHEzXqZgiELnLvwTLehof4u6WzGdXltWD/551D9XhZd8 nw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j2g4xr3aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 19:42:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27JGnTjH032774;
        Fri, 19 Aug 2022 19:42:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j0c2daaaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 19:42:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaWioYzWkzKE2Mmc5EDgFHs7M4pcghh7C2yPIO6aav/RygVk6t9GVJYbwelDsjfhx4jDt3cWipUDVWBhr65Y3Ig78LIetqkNrf2qJdf6KGXVzHdTdoXyB+1x5+SYzezaXB7Qne0NEY+QHLc/CY7dQmQPqr5HzcAtSanvb+3jltOc4q8i9+QvQgqEy4cHzeav9qqd/gakSIMS4PuuLSQ6rM1VUmX8CXbQ+7Yt2A0IMcyTK2uC60Du6A39ghDtuhgFyD4o0hOL6FauYqfeo69Pphrw/kyqOie/qgJoijsXkeXkXrukDNWuwzVef3MXA8Bgu/rYTAtre1KPB9GBRx/W+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPV9HJh3PzuM4Jz3gBkL8EdpkqfynlvBH9FIX0k9iCQ=;
 b=cOndVuMBB9sSeAb9zbIsgFM4kCxXb6kspFg5QNrr7L2Nkv85SA5FK0O0frApRwCACD9bcU7l1kov5qbiR2o20q7yto6Kj4sASXqvp/IJuE+MgIjRsa3etIMTF0tmyBQiw7N1NePXuQ2za1bzuk3UzljMAjxQudZrpwKTEMI6v+VVG5iCfTi1YXEsBC3RuVuq3MW5p27dMYMIBDhDjPsKDXr1slfgLqnkNtLDu+aTCjuogAl4tCOifYdcraxJ7efhLYa/jK5Ym84ryd8K9QvM1N/gdyPzW6CwlE6fTybFOgmnYsP011RpihMXeIgxmk9m65nD1guPgQQGT1oJ1+0XNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPV9HJh3PzuM4Jz3gBkL8EdpkqfynlvBH9FIX0k9iCQ=;
 b=Zlv4OzNrURgDwYBSxhZv+DdUWL7fB9SfGU7BfmEMnvZEJWZ4S/hzaSbbARkY+8Lso9DACBZZVTu+awcTihqWPilNL8jZqZU7y4o6g6HoNLDiFQCCzXwL85jGu1MsM25+dr7c51PnaGFq1cGhmcG0km+j3ZJ9vXFFpA9ci8pPVgA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS0PR10MB6199.namprd10.prod.outlook.com (2603:10b6:8:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 19:42:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4833:dbd5:3d83:84aa%3]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 19:42:41 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Michael Christie <michael.christie@oracle.com>
CC:     "jgross@suse.com" <jgross@suse.com>,
        Nilesh Javali <njavali@marvell.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "mrochs@linux.ibm.com" <mrochs@linux.ibm.com>,
        "ukrishn@linux.ibm.com" <ukrishn@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2 06/10] scsi: qla2xxx: Drop DID_TARGET_FAILURE use
Thread-Topic: [PATCH v2 06/10] scsi: qla2xxx: Drop DID_TARGET_FAILURE use
Thread-Index: AQHYrecF+Nrv8uc5Lk+bTHu9kC8m2K22q+AA
Date:   Fri, 19 Aug 2022 19:42:40 +0000
Message-ID: <69F41769-C1A2-4453-9495-DEA8DB9B3BE2@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
 <20220812010027.8251-7-michael.christie@oracle.com>
In-Reply-To: <20220812010027.8251-7-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 291e37f0-80e4-4752-c0e1-08da821afa7e
x-ms-traffictypediagnostic: DS0PR10MB6199:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S5cwn1OIfxq1aqAcZa1ushLHuqRcvi5VM4tlJSvpqGXySuJf7Ov/gvyC1soFpYqTAP5Hve5p1rmbebv5MNCLtL0M5xa3r8eZ/DPb+kIKdqymMhIB/f3WPKAzcRodNbaowckGgBopbayBftJ7M47fglHB654jz7WIhKoE7Y6VOZG5XvujG8Ty4bqnwWZPD6SeVRvKi0Q1+jatr39Ccc7O6edY7d2DuZxlAQlUz2Cfxs/e8wCjyPpgvYqq7U8m7Gtx4TVjrTaH0Of/X/gUPxnX1P82PWw8I9JxUJufaS4d/BDNpytm6t72Or3svLoQsNwmX+pO9PEKFBqWQGwo6NPgmsUO5SUEY2jTXDYx9x5h3Wd+ZNefbaUhodr60MsDjqEXMxqQv7UMDgg0goCZLEyIwWOUbfppbkHi4IVEzIOBJAZvWJqN715cagif3gPam3vM5PIcCu59uJVFavLLTEGUBcqI66JqydurBx7QsLUhDf+x1IGRtaUsEA3WZim8mtJtNpX9oedjjmAaM/Fnr28hvMdCfbnjlE9KJtUEOzBL0xih8df1owLDKor2oF5mZWthqFgQUYDjQQE1D787vbPBzegNWmODVAmdyPfXxZiRvdsFWoiw3n0CCSnA5d6gGOgHIxS0zzVmNA1gibsQYPmOLNoq3f2LWjXeq/qRR+llPM5dsemR1snTN8QMNDN9CebDnxaQc4/7JHGCEacJExbJXJQ/t6551Ft6EIN7X5Pf8JFKuf8sNSJfqeAZSHN1xmNGwcf4NbfLm7j+sP9y28omAuVgijZYkvNofCSPJUIUhH8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(39860400002)(346002)(366004)(33656002)(36756003)(86362001)(38100700002)(53546011)(83380400001)(6512007)(6506007)(38070700005)(2616005)(186003)(26005)(71200400001)(6486002)(478600001)(37006003)(41300700001)(316002)(91956017)(54906003)(8676002)(4326008)(44832011)(2906002)(66446008)(66556008)(76116006)(6636002)(66946007)(64756008)(66476007)(5660300002)(7416002)(122000001)(6862004)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y1T6CAFmqj1nz7l2n+R/dB3ExPM4rothg5K3xo9ROXLxYPwCIGScu4yvkra0?=
 =?us-ascii?Q?N5jbcqW9eUibtW2fl63GdYcLI6QJLE+MeRrcdSUaL3GOfFq5OtCQ8sKnQ4MJ?=
 =?us-ascii?Q?ZibEss1zJBwLFxIKGxv9olnNa/PRa5PMynfS7pL5YtyfU/5k7b8AaPzoWtRd?=
 =?us-ascii?Q?DYJD/y+pyS27YD7rmKJ+uXwGJknRN3UVMnFcIP8sInWnB3G5kkbKGvLZQOp7?=
 =?us-ascii?Q?tLOs3qtz32lqB45U/qWaOOOk4WtzjDNKfUYY6pGjSYfTBMoI96+QWC8xMkJ4?=
 =?us-ascii?Q?xHEp31qMm0WJT5WEy4mlL7k00V4eLFm7WW2xI5ROxmN4ikrs1cIIE3Xfd4+5?=
 =?us-ascii?Q?TMr60x4Dj357oX5IlGkYqBmS9mt5yEK/eqX8SLR+FThpJPLdK2XWQLXHtxSe?=
 =?us-ascii?Q?SZGo3NnlLoC4fWBv1R7XUsliXR8sX8UanbP20V4TxL/BAe2arCLgmUFdy1Jh?=
 =?us-ascii?Q?9lSe7A7RhZL+DtWtEU1kWbtKQMLLRyeAL6C3mOeS8ofuhIc9A49+b8Nr3xJ9?=
 =?us-ascii?Q?dTZ5zatahPWYOqgpzQIhC04vB4Bfad4gL0iUMsUdwjfFFDmf6f4FywnGMRxp?=
 =?us-ascii?Q?ru+GUXTIs0QUlmoA7k96RYGgAlAn6Mnmi9sOSO+8e+DimCp5Krc0ThSgdGXZ?=
 =?us-ascii?Q?QZOidLKjI5GnzvHUmeprvCb6BsHOarBPdNWA7sFziDwKXKsQkwd6uRklL0tc?=
 =?us-ascii?Q?GFy+hNVfQPwlcwPhN4d/bYlEWGSnx3Ez/Ut4+lO3zvssR2VQJfn0Yig2GmcH?=
 =?us-ascii?Q?yDGkNclODixtQexZ3uzsWLLrGiDtwUPpJPBQ26GVeYjH3IvUylliNkrzx7AL?=
 =?us-ascii?Q?ucs3F2eWi6ZUZTYsxq4TWys1r3tLyBGRpAoSqxUc6rBmGdY2C86mvSO8AZLq?=
 =?us-ascii?Q?lXIw0eW3IviurDB4iGZOKoeg4gawynXSlep+qYw8D0JfgDi7qns5E6mK1h/9?=
 =?us-ascii?Q?NFhMYxc79CU7vkkPkadafjM+/90dceBhwGiclRZkIeNt6Ir7GBBCql9fIhrT?=
 =?us-ascii?Q?a4hbVcHneguMYrvvHDjPOpl6C12TweaGyEJ/1wZ7VjQ/SyxuNf8wNoP0zRel?=
 =?us-ascii?Q?qc8wIz3fQLOyPbBHs/h6tFe+iEwkq2tdfmxtN5qgY5GK9FyNJnWONoVJZUZn?=
 =?us-ascii?Q?Rszr4lqzKEPJgAzNUMKO3IPG8ZiN0fpFUbOTogWNPIzOKXNKQT1ER+2irkuT?=
 =?us-ascii?Q?NV9LO/b9sTYgA8ADnyCDsJtcB5atHrCDKOB2IxYN5ZMTIyCE7R2ymcDMxd86?=
 =?us-ascii?Q?1ZP34m57j74mJ+mHJOaCkj1Fs683VMwZJgG4ATlFGQ2GKTHmbahDZas3bfxh?=
 =?us-ascii?Q?isPSMHuunHSuC+FBZPNPcCAQ+4hTJZsAtaj4Fe0viGFetQKuoRNizlZbFAhV?=
 =?us-ascii?Q?2dI3PBGkvujIYBiSYlkSETjMjkR427b67t4b/soMAO/4ABDbFpBXbruBe/7t?=
 =?us-ascii?Q?fuALb6W3qIahXyCUy9GcgjE6tO4CfXMyH7cG0FxBBkVcF5Tr06vKhPkvozt4?=
 =?us-ascii?Q?XPp3c7C663NCn9wE1dHGP4ZHCQ0LaMXevUv2X6qEj/Em4mDl71ef+h8T6yQO?=
 =?us-ascii?Q?KyPPdWua5ph2tPHX7iNTXj9YUibofaV0cqmEhSwCw/JLUYzdKYRfhtofga63?=
 =?us-ascii?Q?FQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8EE34898C9B6424DA083621EDC5C73BF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 291e37f0-80e4-4752-c0e1-08da821afa7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 19:42:40.9561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AnkpRKsX1bjZYwXyYGe8a8vQ9deAAAf43xWlch1MVVBkAtAfiRvBgBf2F9oW7DTJCToBBsYNMjL+3PRMYj0QyImDFrhC0cfG7LmbhLQ2RL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_10,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190073
X-Proofpoint-ORIG-GUID: njWBBbec1EFKyn09xgtpqjzagnBgKIQf
X-Proofpoint-GUID: njWBBbec1EFKyn09xgtpqjzagnBgKIQf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 11, 2022, at 6:00 PM, Mike Christie <michael.christie@oracle.com> =
wrote:
>=20
> DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
> because:
>=20
> 1. It's not propagated upwards, so SG IO/passthrough users will not see a=
n
> error and think a command was successful.
>=20
> 2. There is no handling for them in scsi_decide_disposition so it results
> in the scsi eh running.
>=20
> This has qla2xxx use DID_NO_CONNECT because it looks like we hit this
> error when we can't find a port. It will give us the same hard error
> behavior and it seems to match the error where we can't find the
> endpoint.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index 400a8b6f3982..00ccc41cef14 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -1551,7 +1551,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
> 		ql_dbg(ql_dbg_edif, vha, 0x70a3, "Failed to find port=3D %06x\n",
> 		    sa_frame.port_id.b24);
> 		rval =3D -EINVAL;
> -		SET_DID_STATUS(bsg_reply->result, DID_TARGET_FAILURE);
> +		SET_DID_STATUS(bsg_reply->result, DID_NO_CONNECT);
> 		goto done;
> 	}
>=20
> --=20
> 2.18.2
>=20

FWIW. Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

