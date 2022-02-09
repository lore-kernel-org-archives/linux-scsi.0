Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5E7C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbiBISTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiBISTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:19:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0334AC03326A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:18:20 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HQF3b020151;
        Wed, 9 Feb 2022 18:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FbPE0MxX9KcxwZxssCDCEOxZSrm7Z2b2vyWdgxf1VTY=;
 b=04Nk1y0vORxgujWpLAgmAbEkoQFJSUmD98ZgQJkOfM5PFFJFV0ezWFwpLE+tam+joXOR
 bZKCMx3fMCI3vU69biQzTA9bPR18cyOc35FVz63KFpECiYHdTpRz4TAf3STaf/ZeG4B1
 ushKYrULnxNaE3PCExg/GgNI1lF9olE/gx9FklRxNr4cHBidnD8pIPcmuJSJLCol5M3Z
 AbnCo10ZFWfs6kvEUefRp1ZN6+O2ZlNQgXgcfMVpXWZVt1o//P69Ik/mONPDajlVQXEb
 ufJRBJHGlzUezY9JX0uZork9mMxT4UwSC/CsKX7Jp+oCWUxR9CKIjUIraR9S6RcyUMU+ SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e366wxqnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:17:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I29fB067101;
        Wed, 9 Feb 2022 18:17:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3e1f9htamj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:17:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwzu+QqPvIzqlUSdS5CYKeSJ4Sa245p2PJCXiEJ89KrCqMM/X7+R+8wwwukYQmXBDfUaxcNJAwcIqaSkk7bItvgY3dWcgFfPlJXHYOkt7gTwVfqRpnzWvsgXXXL+dZDwQynU4s4jht+ydVR5Ex4ju3mVGy/ucD9AZja/aTP5kaM6xpOwU3Il4LmmE09jbFvZETGThgvh82jx8W3CaV+KDC7D5LJI11DS5qBfsFUCbRf+aTBBlmImOMkyQvEHirjzZhuHYYNgtLJMnruPdXve/G9OsevRopk42rWDn6AfCW3Hm4u2FNfMR6Ihy8PjDd3O9kYwbejtrG6rc+YfxwrObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbPE0MxX9KcxwZxssCDCEOxZSrm7Z2b2vyWdgxf1VTY=;
 b=KEwJR7GycYQqh61DwBzozK+DCyCJzHg+3zDjL1Zr8gGnJTfVejTcNR2p0m2ZtXP1JhoDTzuQf6BsuwYAQPGpNdpAHQIr+Hi13ETP/J0NoHo3GOoxncNKb2rPls+1pOerowmyrnQJZgRxJZrng4JV976H7HkY/sL5/rkTUgYelOZZP7U9n8puix14brYzgaGht05CFb7MRgcs7lXTiyp1eOAjj80YJdYa5/QFVCAxNlDBZBESPcyIjHeiIcdZoEnu/LLW4QcMCNn1ii7rXtV0BGqkYJePpPStF294OZSGOR9N2iNX2sHUZgGjWcOD6SBcqyYjHHgUe5TvgGB5VoAxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbPE0MxX9KcxwZxssCDCEOxZSrm7Z2b2vyWdgxf1VTY=;
 b=Jix01yQ6pNT97vgV2YssYo7cHkUaudeUW9sUDzFOmaG0mdnvwBPA/OJkDCv80RsapcJ4cEDAkSItmzDHsNhLgqSum5GPH2ogBwuhayH/x5eRPoOEZt11rLZQPLV1003IFkSHm1bhkIFjmZy0LKA9zH94uvbVj7ZthiF649R5xXg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB3252.namprd10.prod.outlook.com (2603:10b6:408:ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:17:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:17:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 19/44] fnic: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 19/44] fnic: Stop using the SCSI pointer
Thread-Index: AQHYHREhC9Mrre1FGUyY/WeWYVQBf6yLiHOA
Date:   Wed, 9 Feb 2022 18:17:28 +0000
Message-ID: <09430E30-584E-4F01-9BAE-D3EC3C7CD57C@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-20-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-20-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c6f9629-5c8f-47c1-989a-08d9ebf86e5a
x-ms-traffictypediagnostic: BN8PR10MB3252:EE_
x-microsoft-antispam-prvs: <BN8PR10MB3252EB8CF5932D3CB1685685E62E9@BN8PR10MB3252.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:279;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /iRY6F5NPZCBzCFWbZlQUFyltPOBhMVLIXme89rcnMJkfJSyI7BCz31MC3/IwH8+uZ+QyVilfQklqzxM4OmQQUXdhw7e5TOBrwakB66J5Kf8V+c0vr75vKb5EXnGBTWQ1NVV6/64PoSArNFs1IBwEOK4yQwaBWUQJiuyVNvRi+UK2NoHOccG02rT7SsNlqbqOUhulsSwPptbXaEwVhyOyG4l/SYeHwqwXUcfIIxyQlC9TVuGuxoQDZFdIb27ymHxCh7b/Ztw2PKEjaR0xZtJett5Lm1N3I92vthLqPeYSpzpBFpvpTJD2k3h+GJ5vwq/wx34NsogV62HfT5EdKWP3rgim0mEgG6pKnMv/oKkFNJMzXWp6uQYuT4Q9wYvsrZ1SVTmtHjsTT79JRpCApr3UPE6ty6SxS42bBZl9gTc3tp5a0O4t4NjLSC9pbre25//+kWp/0kUDbtDBGburuP3CrJZrHvMCb0tEKetgyGeBaWD2z/yJ/W7wB4LiNan1FaNEcghlzRRM8kiDdmGof1KSu0a4KypA+gMFtGBiFtpuDRcQXZkjayl5I0MTBc+LQFbr7KfDp4qS6KTpToLzMlDKvRvFTDBeeEi4fvlHf4GAX7u5T/jM8146I4N1LN5ODalQaHIhUbmGaBSf57BVgT9mEoTMs5NJLWhsu4oe2BVdgExY2pZHkmaJIpTj0g6EJo9JJG0IQnyQlDlVkeY8cHOJdvZlIVQ5KbVGrfFRZiwlQ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(33656002)(38100700002)(86362001)(122000001)(71200400001)(8936002)(44832011)(5660300002)(53546011)(6512007)(508600001)(6916009)(54906003)(91956017)(6486002)(4326008)(64756008)(66446008)(66476007)(66556008)(8676002)(76116006)(66946007)(83380400001)(186003)(36756003)(2906002)(6506007)(316002)(30864003)(2616005)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LUKSSDCDBD5J2LdAQY9xASgx20fqZs+WKkD4sW6yA91MAnxNpRt1ymWfpi48?=
 =?us-ascii?Q?sHKsZlxmx/RamgQ6uo7sRbZzi9dUJHoYg60AvKEm7nZ3AOO5buXsdxk+OtR3?=
 =?us-ascii?Q?KehhdIlnXaxB8q+qiCsryScJkPhJ+BytZNeEV7jTk/RfFccHqRFYjBl1eBO4?=
 =?us-ascii?Q?TvlPFDwbLOxlzRIlVWBXj6vYIY3zRdyhf9vB94Fnx1DLuxLqZVVlGMBTjjB8?=
 =?us-ascii?Q?wSHYhl9SPEbGOTuvjhCjlS05ZXm79Waz/Yd8BMVntRbjgQodtqtDfk9zng4Y?=
 =?us-ascii?Q?8u2Awv8NuiQXcOLYYPI0ImnEYnzlWmhU3dSs05/n+fEeTVfqTkj2blrUajCZ?=
 =?us-ascii?Q?6/ctshgulKKCTHMKLj/J4nEYhPbtAqkmiUJA+of9BIINnYyMf7OaE/S1vZIg?=
 =?us-ascii?Q?qZ/0hZjvzkb6AYI1i2GLqbtoyWWLrTimpst61wHdSDJrZsfROY84WF9rn54Z?=
 =?us-ascii?Q?4ti8rjQqg1DBpfRJzG7VsdQlMfqBwbzS/V11vA96oUVS1wpzYJQTFs/cOvks?=
 =?us-ascii?Q?pzmOWepwkWFi7JXa/Iw7+8r4OnIk0QI/tyg2aM3jQw790S6dZ6v/clStYXg9?=
 =?us-ascii?Q?A1IMNz/YGBbvN3P8LLHa3Vod2Q/McJ5riCf4AMzYQjGfonirDf4sWqDm1fOw?=
 =?us-ascii?Q?0a+Pakg4bbaPayAcha7aIWxQO+H2LMvWnaCGMqTT06W6k0oNsmH2hnhbYyQi?=
 =?us-ascii?Q?sW+3shp1gpkCN08pqNhy35t+ASpGxEiM8z4TLnt8Yk1MNNi6w+gBy9GpdX1+?=
 =?us-ascii?Q?25IOB/eEfbSliWHKNKGj60PTk4T7vltsUb7pl3/qjbZh1lfJW9OQhbiYTZSb?=
 =?us-ascii?Q?AA794u02GTrNRONEKsPhxMIyMsKJaV6FjYEILWy5dY7lMnI7ozfPFYqr+ft6?=
 =?us-ascii?Q?OOMaf0CX6eDg3gn4OTIiNBNQbroyv+OoeSqzsUHnGHx/IFTKKSdrlwtov53K?=
 =?us-ascii?Q?1isQZMbx1WwDybz34tjIhYXD+nVE6sOJwfUfb559OopFY/oNXkgQr6p5LAYl?=
 =?us-ascii?Q?zJk3JdVio2MuMsiet5/upP+FxRSGSaPgU3b87sdmldoO7k+GyRnMI9tXc0V8?=
 =?us-ascii?Q?ACQsCAZkR5yZ/HbuNLmaUESwEuzQvDx6RxxFf2rGWlh8D9LLW1JlG5rQU061?=
 =?us-ascii?Q?A2SQsKf8nrvzTiOzIwrkCzoyDuo3u8c5lY6zX22DWOj47c8ftVpIsN9ZZ945?=
 =?us-ascii?Q?Ne6w0b4C4EsbhO4c4XVECnox6LmREKUByH86X4FF2OzenqZdYGEfbgAtduot?=
 =?us-ascii?Q?Yd3BTM/DwRZ5oR5ud9qR18pVGRJTpwICgEK/xXL4zDuJQeQ/V9MFIUM/bMo+?=
 =?us-ascii?Q?uWfgHkhKjroHJDHWE21wXJfbOAPhd/2Xlm/LA8eh309g+knCLLYtY+gUbrr9?=
 =?us-ascii?Q?vxqRvXmQ1Boq7fUMx1mgX2x075SisOPvzXfXpC8R9nuhBZ13gWtWV1b5cBTZ?=
 =?us-ascii?Q?sAMjryzk8buRvHWj5trGteUhybLePraW/FxYC1uErf3E4OGP/DJ2D6wUyeLG?=
 =?us-ascii?Q?nshpTLfs2mQVuaMfeb5lrnoj0dfoPqYmlTJ40n+H8WUuWZ5oUL0kRmi7nmiP?=
 =?us-ascii?Q?d9KuHwdhUku0JISnOD31fxD7stXc3uXEkB5cbF69mTh2aFZUyxPiDyYLsAHg?=
 =?us-ascii?Q?6X9ylsw6zFE1LsfNqqM18n3MNRR2GLcDa40D+1Mwj7HpgTBkyvIzX8hWLHjS?=
 =?us-ascii?Q?P1fDqAiiixca0NBvdo27Xa0W9sXja7Hk4keOoKkfosJ9/TsL?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E0E217E1D0AF44CAE76A76A6F6D4893@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6f9629-5c8f-47c1-989a-08d9ebf86e5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:17:28.4546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J2hxr3rPGPCOHX7Rl8vqIpGhbZNCjVdRh1Oo5JccKMMRDEqNsXHeRhuCfNc9pNcZF33vFtD5IG1AXNiDSavrbwv9bp9Npny7iNsdZGbzhbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3252
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-GUID: EM7zY98k-PFQzSzp91j1zb56Sy05aVuD
X-Proofpoint-ORIG-GUID: EM7zY98k-PFQzSzp91j1zb56Sy05aVuD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/fnic/fnic.h      |  27 +++-
> drivers/scsi/fnic/fnic_main.c |   1 +
> drivers/scsi/fnic/fnic_scsi.c | 289 +++++++++++++++++-----------------
> 3 files changed, 163 insertions(+), 154 deletions(-)
>=20
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index b95d0063dedb..aa07189fb5fb 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -89,15 +89,28 @@
> #define FNIC_DEV_RST_ABTS_PENDING       BIT(21)
>=20
> /*
> - * Usage of the scsi_cmnd scratchpad.
> + * fnic private data per SCSI command.
>  * These fields are locked by the hashed io_req_lock.
>  */
> -#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
> -#define CMD_STATE(Cmnd)		((Cmnd)->SCp.phase)
> -#define CMD_ABTS_STATUS(Cmnd)	((Cmnd)->SCp.Message)
> -#define CMD_LR_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
> -#define CMD_TAG(Cmnd)           ((Cmnd)->SCp.sent_command)
> -#define CMD_FLAGS(Cmnd)         ((Cmnd)->SCp.Status)
> +struct fnic_cmd_priv {
> +	struct fnic_io_req *io_req;
> +	enum fnic_ioreq_state state;
> +	u32 flags;
> +	u16 abts_status;
> +	u16 lr_status;
> +};
> +
> +static inline struct fnic_cmd_priv *fnic_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> +static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
> +{
> +	struct fnic_cmd_priv *fcmd =3D fnic_priv(cmd);
> +
> +	return ((u64)fcmd->flags << 32) | fcmd->state;
> +}
>=20
> #define FCPIO_INVALID_CODE 0x100 /* hdr_status value unused by firmware *=
/
>=20
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.=
c
> index 44dbaa662d94..9161bd2fd421 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -124,6 +124,7 @@ static struct scsi_host_template fnic_host_template =
=3D {
> 	.max_sectors =3D 0xffff,
> 	.shost_groups =3D fnic_host_groups,
> 	.track_queue_depth =3D 1,
> +	.cmd_size =3D sizeof(struct fnic_cmd_priv),
> };
>=20
> static void
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.=
c
> index 549754245f7a..3c00e5b88350 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -497,8 +497,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
)
> 	 * caller disabling them.
> 	 */
> 	spin_unlock(lp->host->host_lock);
> -	CMD_STATE(sc) =3D FNIC_IOREQ_NOT_INITED;
> -	CMD_FLAGS(sc) =3D FNIC_NO_FLAGS;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_NOT_INITED;
> +	fnic_priv(sc)->flags =3D FNIC_NO_FLAGS;
>=20
> 	/* Get a new io_req for this SCSI IO */
> 	io_req =3D mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
> @@ -513,7 +513,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
)
> 	sg_count =3D scsi_dma_map(sc);
> 	if (sg_count < 0) {
> 		FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
> -			  tag, sc, 0, sc->cmnd[0], sg_count, CMD_STATE(sc));
> +			  tag, sc, 0, sc->cmnd[0], sg_count, fnic_priv(sc)->state);
> 		mempool_free(io_req, fnic->io_req_pool);
> 		goto out;
> 	}
> @@ -558,9 +558,9 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
)
> 	io_lock_acquired =3D 1;
> 	io_req->port_id =3D rport->port_id;
> 	io_req->start_time =3D jiffies;
> -	CMD_STATE(sc) =3D FNIC_IOREQ_CMD_PENDING;
> -	CMD_SP(sc) =3D (char *)io_req;
> -	CMD_FLAGS(sc) |=3D FNIC_IO_INITIALIZED;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_CMD_PENDING;
> +	fnic_priv(sc)->io_req =3D io_req;
> +	fnic_priv(sc)->flags |=3D FNIC_IO_INITIALIZED;
>=20
> 	/* create copy wq desc and enqueue it */
> 	wq =3D &fnic->wq_copy[0];
> @@ -571,11 +571,10 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *=
sc)
> 		 * refetch the pointer under the lock.
> 		 */
> 		FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
> -			  tag, sc, 0, 0, 0,
> -			  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> -		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> -		CMD_SP(sc) =3D NULL;
> -		CMD_STATE(sc) =3D FNIC_IOREQ_CMD_COMPLETE;
> +			  tag, sc, 0, 0, 0, fnic_flags_and_state(sc));
> +		io_req =3D fnic_priv(sc)->io_req;
> +		fnic_priv(sc)->io_req =3D NULL;
> +		fnic_priv(sc)->state =3D FNIC_IOREQ_CMD_COMPLETE;
> 		spin_unlock_irqrestore(io_lock, flags);
> 		if (io_req) {
> 			fnic_release_ioreq_buf(fnic, io_req, sc);
> @@ -594,7 +593,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
)
> 			     atomic64_read(&fnic_stats->io_stats.active_ios));
>=20
> 		/* REVISIT: Use per IO lock in the final code */
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ISSUED;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ISSUED;
> 	}
> out:
> 	cmd_trace =3D ((u64)sc->cmnd[0] << 56 | (u64)sc->cmnd[7] << 40 |
> @@ -603,8 +602,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc=
)
> 			sc->cmnd[5]);
>=20
> 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
> -		  tag, sc, io_req, sg_count, cmd_trace,
> -		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +		   tag, sc, io_req, sg_count, cmd_trace,
> +		   fnic_flags_and_state(sc));
>=20
> 	/* if only we issued IO, will we have the io lock */
> 	if (io_lock_acquired)
> @@ -867,11 +866,11 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fn=
ic *fnic,
>=20
> 	io_lock =3D fnic_io_lock_hash(fnic, sc);
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	WARN_ON_ONCE(!io_req);
> 	if (!io_req) {
> 		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
> -		CMD_FLAGS(sc) |=3D FNIC_IO_REQ_NULL;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_REQ_NULL;
> 		spin_unlock_irqrestore(io_lock, flags);
> 		shost_printk(KERN_ERR, fnic->lport->host,
> 			  "icmnd_cmpl io_req is null - "
> @@ -888,17 +887,17 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fn=
ic *fnic,
> 	 *  if SCSI-ML has already issued abort on this command,
> 	 *  set completion of the IO. The abts path will clean it up
> 	 */
> -	if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> +	if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING) {
>=20
> 		/*
> 		 * set the FNIC_IO_DONE so that this doesn't get
> 		 * flagged as 'out of order' if it was not aborted
> 		 */
> -		CMD_FLAGS(sc) |=3D FNIC_IO_DONE;
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABTS_PENDING;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_DONE;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABTS_PENDING;
> 		spin_unlock_irqrestore(io_lock, flags);
> 		if(FCPIO_ABORTED =3D=3D hdr_status)
> -			CMD_FLAGS(sc) |=3D FNIC_IO_ABORTED;
> +			fnic_priv(sc)->flags |=3D FNIC_IO_ABORTED;
>=20
> 		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> 			"icmnd_cmpl abts pending "
> @@ -912,7 +911,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic=
 *fnic,
> 	}
>=20
> 	/* Mark the IO as complete */
> -	CMD_STATE(sc) =3D FNIC_IOREQ_CMD_COMPLETE;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_CMD_COMPLETE;
>=20
> 	icmnd_cmpl =3D &desc->u.icmnd_cmpl;
>=20
> @@ -983,8 +982,8 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic=
 *fnic,
> 	}
>=20
> 	/* Break link with the SCSI command */
> -	CMD_SP(sc) =3D NULL;
> -	CMD_FLAGS(sc) |=3D FNIC_IO_DONE;
> +	fnic_priv(sc)->io_req =3D NULL;
> +	fnic_priv(sc)->flags |=3D FNIC_IO_DONE;
>=20
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> @@ -1009,8 +1008,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fn=
ic *fnic,
> 		  ((u64)icmnd_cmpl->_resvd0[1] << 56 |
> 		  (u64)icmnd_cmpl->_resvd0[0] << 48 |
> 		  jiffies_to_msecs(jiffies - start_time)),
> -		  desc, cmd_trace,
> -		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +		  desc, cmd_trace, fnic_flags_and_state(sc));
>=20
> 	if (sc->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
> 		fnic->lport->host_stats.fcp_input_requests++;
> @@ -1095,12 +1093,12 @@ static void fnic_fcpio_itmf_cmpl_handler(struct f=
nic *fnic,
> 	}
> 	io_lock =3D fnic_io_lock_hash(fnic, sc);
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	WARN_ON_ONCE(!io_req);
> 	if (!io_req) {
> 		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
> 		spin_unlock_irqrestore(io_lock, flags);
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_REQ_NULL;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABT_TERM_REQ_NULL;
> 		shost_printk(KERN_ERR, fnic->lport->host,
> 			  "itmf_cmpl io_req is null - "
> 			  "hdr status =3D %s tag =3D 0x%x sc 0x%p\n",
> @@ -1115,9 +1113,9 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 			      "dev reset abts cmpl recd. id %x status %s\n",
> 			      id, fnic_fcpio_status_to_str(hdr_status));
> -		CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_COMPLETE;
> -		CMD_ABTS_STATUS(sc) =3D hdr_status;
> -		CMD_FLAGS(sc) |=3D FNIC_DEV_RST_DONE;
> +		fnic_priv(sc)->state =3D FNIC_IOREQ_ABTS_COMPLETE;
> +		fnic_priv(sc)->abts_status =3D hdr_status;
> +		fnic_priv(sc)->flags |=3D FNIC_DEV_RST_DONE;
> 		if (io_req->abts_done)
> 			complete(io_req->abts_done);
> 		spin_unlock_irqrestore(io_lock, flags);
> @@ -1127,7 +1125,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
> 		case FCPIO_SUCCESS:
> 			break;
> 		case FCPIO_TIMEOUT:
> -			if (CMD_FLAGS(sc) & FNIC_IO_ABTS_ISSUED)
> +			if (fnic_priv(sc)->flags & FNIC_IO_ABTS_ISSUED)
> 				atomic64_inc(&abts_stats->abort_fw_timeouts);
> 			else
> 				atomic64_inc(
> @@ -1139,34 +1137,34 @@ static void fnic_fcpio_itmf_cmpl_handler(struct f=
nic *fnic,
> 				(int)(id & FNIC_TAG_MASK));
> 			break;
> 		case FCPIO_IO_NOT_FOUND:
> -			if (CMD_FLAGS(sc) & FNIC_IO_ABTS_ISSUED)
> +			if (fnic_priv(sc)->flags & FNIC_IO_ABTS_ISSUED)
> 				atomic64_inc(&abts_stats->abort_io_not_found);
> 			else
> 				atomic64_inc(
> 					&term_stats->terminate_io_not_found);
> 			break;
> 		default:
> -			if (CMD_FLAGS(sc) & FNIC_IO_ABTS_ISSUED)
> +			if (fnic_priv(sc)->flags & FNIC_IO_ABTS_ISSUED)
> 				atomic64_inc(&abts_stats->abort_failures);
> 			else
> 				atomic64_inc(
> 					&term_stats->terminate_failures);
> 			break;
> 		}
> -		if (CMD_STATE(sc) !=3D FNIC_IOREQ_ABTS_PENDING) {
> +		if (fnic_priv(sc)->state !=3D FNIC_IOREQ_ABTS_PENDING) {
> 			/* This is a late completion. Ignore it */
> 			spin_unlock_irqrestore(io_lock, flags);
> 			return;
> 		}
>=20
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_DONE;
> -		CMD_ABTS_STATUS(sc) =3D hdr_status;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABT_TERM_DONE;
> +		fnic_priv(sc)->abts_status =3D hdr_status;
>=20
> 		/* If the status is IO not found consider it as success */
> 		if (hdr_status =3D=3D FCPIO_IO_NOT_FOUND)
> -			CMD_ABTS_STATUS(sc) =3D FCPIO_SUCCESS;
> +			fnic_priv(sc)->abts_status =3D FCPIO_SUCCESS;
>=20
> -		if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
> +		if (!(fnic_priv(sc)->flags & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
> 			atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
>=20
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> @@ -1185,7 +1183,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
> 		} else {
> 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 				      "abts cmpl, completing IO\n");
> -			CMD_SP(sc) =3D NULL;
> +			fnic_priv(sc)->io_req =3D NULL;
> 			sc->result =3D (DID_ERROR << 16);
>=20
> 			spin_unlock_irqrestore(io_lock, flags);
> @@ -1202,8 +1200,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
> 				    (u64)sc->cmnd[2] << 24 |
> 				    (u64)sc->cmnd[3] << 16 |
> 				    (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
> -				   (((u64)CMD_FLAGS(sc) << 32) |
> -				    CMD_STATE(sc)));
> +				   fnic_flags_and_state(sc));
> 			scsi_done(sc);
> 			atomic64_dec(&fnic_stats->io_stats.active_ios);
> 			if (atomic64_read(&fnic->io_cmpl_skip))
> @@ -1213,15 +1210,14 @@ static void fnic_fcpio_itmf_cmpl_handler(struct f=
nic *fnic,
> 		}
> 	} else if (id & FNIC_TAG_DEV_RST) {
> 		/* Completion of device reset */
> -		CMD_LR_STATUS(sc) =3D hdr_status;
> -		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> +		fnic_priv(sc)->lr_status =3D hdr_status;
> +		if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> 			spin_unlock_irqrestore(io_lock, flags);
> -			CMD_FLAGS(sc) |=3D FNIC_DEV_RST_ABTS_PENDING;
> +			fnic_priv(sc)->flags |=3D FNIC_DEV_RST_ABTS_PENDING;
> 			FNIC_TRACE(fnic_fcpio_itmf_cmpl_handler,
> 				  sc->device->host->host_no, id, sc,
> 				  jiffies_to_msecs(jiffies - start_time),
> -				  desc, 0,
> -				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +				  desc, 0, fnic_flags_and_state(sc));
> 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 				"Terminate pending "
> 				"dev reset cmpl recd. id %d status %s\n",
> @@ -1229,14 +1225,13 @@ static void fnic_fcpio_itmf_cmpl_handler(struct f=
nic *fnic,
> 				fnic_fcpio_status_to_str(hdr_status));
> 			return;
> 		}
> -		if (CMD_FLAGS(sc) & FNIC_DEV_RST_TIMED_OUT) {
> +		if (fnic_priv(sc)->flags & FNIC_DEV_RST_TIMED_OUT) {
> 			/* Need to wait for terminate completion */
> 			spin_unlock_irqrestore(io_lock, flags);
> 			FNIC_TRACE(fnic_fcpio_itmf_cmpl_handler,
> 				  sc->device->host->host_no, id, sc,
> 				  jiffies_to_msecs(jiffies - start_time),
> -				  desc, 0,
> -				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +				  desc, 0, fnic_flags_and_state(sc));
> 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 				"dev reset cmpl recd after time out. "
> 				"id %d status %s\n",
> @@ -1244,8 +1239,8 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
> 				fnic_fcpio_status_to_str(hdr_status));
> 			return;
> 		}
> -		CMD_STATE(sc) =3D FNIC_IOREQ_CMD_COMPLETE;
> -		CMD_FLAGS(sc) |=3D FNIC_DEV_RST_DONE;
> +		fnic_priv(sc)->state =3D FNIC_IOREQ_CMD_COMPLETE;
> +		fnic_priv(sc)->flags |=3D FNIC_DEV_RST_DONE;
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 			      "dev reset cmpl recd. id %d status %s\n",
> 			      (int)(id & FNIC_TAG_MASK),
> @@ -1257,7 +1252,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic,
> 	} else {
> 		shost_printk(KERN_ERR, fnic->lport->host,
> 			     "Unexpected itmf io state %s tag %x\n",
> -			     fnic_ioreq_state_to_str(CMD_STATE(sc)), id);
> +			     fnic_ioreq_state_to_str(fnic_priv(sc)->state), id);
> 		spin_unlock_irqrestore(io_lock, flags);
> 	}
>=20
> @@ -1370,21 +1365,21 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd=
 *sc, void *data,
> 	io_lock =3D fnic_io_lock_tag(fnic, tag);
> 	spin_lock_irqsave(io_lock, flags);
>=20
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> -	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
> -	    !(CMD_FLAGS(sc) & FNIC_DEV_RST_DONE)) {
> +	io_req =3D fnic_priv(sc)->io_req;
> +	if ((fnic_priv(sc)->flags & FNIC_DEVICE_RESET) &&
> +	    !(fnic_priv(sc)->flags & FNIC_DEV_RST_DONE)) {
> 		/*
> 		 * We will be here only when FW completes reset
> 		 * without sending completions for outstanding ios.
> 		 */
> -		CMD_FLAGS(sc) |=3D FNIC_DEV_RST_DONE;
> +		fnic_priv(sc)->flags |=3D FNIC_DEV_RST_DONE;
> 		if (io_req && io_req->dr_done)
> 			complete(io_req->dr_done);
> 		else if (io_req && io_req->abts_done)
> 			complete(io_req->abts_done);
> 		spin_unlock_irqrestore(io_lock, flags);
> 		return true;
> -	} else if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
> +	} else if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		return true;
> 	}
> @@ -1393,7 +1388,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *=
sc, void *data,
> 		goto cleanup_scsi_cmd;
> 	}
>=20
> -	CMD_SP(sc) =3D NULL;
> +	fnic_priv(sc)->io_req =3D NULL;
>=20
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> @@ -1417,7 +1412,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *=
sc, void *data,
> 		atomic64_inc(&fnic_stats->io_stats.io_completions);
>=20
> 	/* Complete the command to SCSI */
> -	if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
> +	if (!(fnic_priv(sc)->flags & FNIC_IO_ISSUED))
> 		shost_printk(KERN_ERR, fnic->lport->host,
> 			     "Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
> 			     tag, sc);
> @@ -1429,7 +1424,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *=
sc, void *data,
> 		       (u64)sc->cmnd[2] << 24 |
> 		       (u64)sc->cmnd[3] << 16 |
> 		       (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
> -		   (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +		   fnic_flags_and_state(sc));
>=20
> 	scsi_done(sc);
>=20
> @@ -1468,7 +1463,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_co=
py *wq,
> 	spin_lock_irqsave(io_lock, flags);
>=20
> 	/* Get the IO context which this desc refers to */
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
>=20
> 	/* fnic interrupts are turned off by now */
>=20
> @@ -1477,7 +1472,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_co=
py *wq,
> 		goto wq_copy_cleanup_scsi_cmd;
> 	}
>=20
> -	CMD_SP(sc) =3D NULL;
> +	fnic_priv(sc)->io_req =3D NULL;
>=20
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> @@ -1496,7 +1491,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_co=
py *wq,
> 		   0, ((u64)sc->cmnd[0] << 32 |
> 		       (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
> 		       (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
> -		   (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +		   fnic_flags_and_state(sc));
>=20
> 	scsi_done(sc);
> }
> @@ -1571,15 +1566,15 @@ static bool fnic_rport_abort_io_iter(struct scsi_=
cmnd *sc, void *data,
> 	io_lock =3D fnic_io_lock_tag(fnic, abt_tag);
> 	spin_lock_irqsave(io_lock, flags);
>=20
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
>=20
> 	if (!io_req || io_req->port_id !=3D iter_data->port_id) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		return true;
> 	}
>=20
> -	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
> -	    (!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
> +	if ((fnic_priv(sc)->flags & FNIC_DEVICE_RESET) &&
> +	    !(fnic_priv(sc)->flags & FNIC_DEV_RST_ISSUED)) {
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 			"fnic_rport_exch_reset dev rst not pending sc 0x%p\n",
> 			sc);
> @@ -1591,7 +1586,7 @@ static bool fnic_rport_abort_io_iter(struct scsi_cm=
nd *sc, void *data,
> 	 * Found IO that is still pending with firmware and
> 	 * belongs to rport that went away
> 	 */
> -	if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> +	if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		return true;
> 	}
> @@ -1599,20 +1594,20 @@ static bool fnic_rport_abort_io_iter(struct scsi_=
cmnd *sc, void *data,
> 		shost_printk(KERN_ERR, fnic->lport->host,
> 			"fnic_rport_exch_reset: io_req->abts_done is set "
> 			"state is %s\n",
> -			fnic_ioreq_state_to_str(CMD_STATE(sc)));
> +			fnic_ioreq_state_to_str(fnic_priv(sc)->state));
> 	}
>=20
> -	if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
> +	if (!(fnic_priv(sc)->flags & FNIC_IO_ISSUED)) {
> 		shost_printk(KERN_ERR, fnic->lport->host,
> 			     "rport_exch_reset "
> 			     "IO not yet issued %p tag 0x%x flags "
> 			     "%x state %d\n",
> -			     sc, abt_tag, CMD_FLAGS(sc), CMD_STATE(sc));
> +			     sc, abt_tag, fnic_priv(sc)->flags, fnic_priv(sc)->state);
> 	}
> -	old_ioreq_state =3D CMD_STATE(sc);
> -	CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
> -	CMD_ABTS_STATUS(sc) =3D FCPIO_INVALID_CODE;
> -	if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
> +	old_ioreq_state =3D fnic_priv(sc)->state;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_ABTS_PENDING;
> +	fnic_priv(sc)->abts_status =3D FCPIO_INVALID_CODE;
> +	if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
> 		atomic64_inc(&reset_stats->device_reset_terminates);
> 		abt_tag |=3D FNIC_TAG_DEV_RST;
> 	}
> @@ -1638,15 +1633,15 @@ static bool fnic_rport_abort_io_iter(struct scsi_=
cmnd *sc, void *data,
> 		 * lun reset
> 		 */
> 		spin_lock_irqsave(io_lock, flags);
> -		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING)
> -			CMD_STATE(sc) =3D old_ioreq_state;
> +		if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING)
> +			fnic_priv(sc)->state =3D old_ioreq_state;
> 		spin_unlock_irqrestore(io_lock, flags);
> 	} else {
> 		spin_lock_irqsave(io_lock, flags);
> -		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
> -			CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TERM_ISSUED;
> +		if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET)
> +			fnic_priv(sc)->flags |=3D FNIC_DEV_RST_TERM_ISSUED;
> 		else
> -			CMD_FLAGS(sc) |=3D FNIC_IO_INTERNAL_TERM_ISSUED;
> +			fnic_priv(sc)->flags |=3D FNIC_IO_INTERNAL_TERM_ISSUED;
> 		spin_unlock_irqrestore(io_lock, flags);
> 		atomic64_inc(&term_stats->terminates);
> 		iter_data->term_cnt++;
> @@ -1754,9 +1749,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 	FNIC_SCSI_DBG(KERN_DEBUG,
> 		fnic->lport->host,
> 		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
> -		rport->port_id, sc->device->lun, tag, CMD_FLAGS(sc));
> +		rport->port_id, sc->device->lun, tag, fnic_priv(sc)->flags);
>=20
> -	CMD_FLAGS(sc) =3D FNIC_NO_FLAGS;
> +	fnic_priv(sc)->flags =3D FNIC_NO_FLAGS;
>=20
> 	if (lp->state !=3D LPORT_ST_READY || !(lp->link_up)) {
> 		ret =3D FAILED;
> @@ -1773,11 +1768,11 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 	 * happened, the completion wont actually complete the command
> 	 * and it will be considered as an aborted command
> 	 *
> -	 * The CMD_SP will not be cleared except while holding io_req_lock.
> +	 * .io_req will not be cleared except while holding io_req_lock.
> 	 */
> 	io_lock =3D fnic_io_lock_hash(fnic, sc);
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	if (!io_req) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		goto fnic_abort_cmd_end;
> @@ -1785,7 +1780,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>=20
> 	io_req->abts_done =3D &tm_done;
>=20
> -	if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> +	if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		goto wait_pending;
> 	}
> @@ -1814,9 +1809,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 	 * the completion wont be done till mid-layer, since abort
> 	 * has already started.
> 	 */
> -	old_ioreq_state =3D CMD_STATE(sc);
> -	CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
> -	CMD_ABTS_STATUS(sc) =3D FCPIO_INVALID_CODE;
> +	old_ioreq_state =3D fnic_priv(sc)->state;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_ABTS_PENDING;
> +	fnic_priv(sc)->abts_status =3D FCPIO_INVALID_CODE;
>=20
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> @@ -1838,9 +1833,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 	if (fnic_queue_abort_io_req(fnic, tag, task_req, fc_lun.scsi_lun,
> 				    io_req)) {
> 		spin_lock_irqsave(io_lock, flags);
> -		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING)
> -			CMD_STATE(sc) =3D old_ioreq_state;
> -		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +		if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING)
> +			fnic_priv(sc)->state =3D old_ioreq_state;
> +		io_req =3D fnic_priv(sc)->io_req;
> 		if (io_req)
> 			io_req->abts_done =3D NULL;
> 		spin_unlock_irqrestore(io_lock, flags);
> @@ -1848,10 +1843,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 		goto fnic_abort_cmd_end;
> 	}
> 	if (task_req =3D=3D FCPIO_ITMF_ABT_TASK) {
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABTS_ISSUED;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABTS_ISSUED;
> 		atomic64_inc(&fnic_stats->abts_stats.aborts);
> 	} else {
> -		CMD_FLAGS(sc) |=3D FNIC_IO_TERM_ISSUED;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_TERM_ISSUED;
> 		atomic64_inc(&fnic_stats->term_stats.terminates);
> 	}
>=20
> @@ -1869,32 +1864,32 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 	/* Check the abort status */
> 	spin_lock_irqsave(io_lock, flags);
>=20
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	if (!io_req) {
> 		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
> 		spin_unlock_irqrestore(io_lock, flags);
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_REQ_NULL;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABT_TERM_REQ_NULL;
> 		ret =3D FAILED;
> 		goto fnic_abort_cmd_end;
> 	}
> 	io_req->abts_done =3D NULL;
>=20
> 	/* fw did not complete abort, timed out */
> -	if (CMD_ABTS_STATUS(sc) =3D=3D FCPIO_INVALID_CODE) {
> +	if (fnic_priv(sc)->abts_status =3D=3D FCPIO_INVALID_CODE) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		if (task_req =3D=3D FCPIO_ITMF_ABT_TASK) {
> 			atomic64_inc(&abts_stats->abort_drv_timeouts);
> 		} else {
> 			atomic64_inc(&term_stats->terminate_drv_timeouts);
> 		}
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_TIMED_OUT;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABT_TERM_TIMED_OUT;
> 		ret =3D FAILED;
> 		goto fnic_abort_cmd_end;
> 	}
>=20
> 	/* IO out of order */
>=20
> -	if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
> +	if (!(fnic_priv(sc)->flags & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 			"Issuing Host reset due to out of order IO\n");
> @@ -1903,7 +1898,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 		goto fnic_abort_cmd_end;
> 	}
>=20
> -	CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_COMPLETE;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_ABTS_COMPLETE;
>=20
> 	start_time =3D io_req->start_time;
> 	/*
> @@ -1911,9 +1906,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 	 * free the io_req if successful. If abort fails,
> 	 * Device reset will clean the I/O.
> 	 */
> -	if (CMD_ABTS_STATUS(sc) =3D=3D FCPIO_SUCCESS)
> -		CMD_SP(sc) =3D NULL;
> -	else {
> +	if (fnic_priv(sc)->abts_status =3D=3D FCPIO_SUCCESS) {
> +		fnic_priv(sc)->io_req =3D NULL;
> +	} else {
> 		ret =3D FAILED;
> 		spin_unlock_irqrestore(io_lock, flags);
> 		goto fnic_abort_cmd_end;
> @@ -1939,7 +1934,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
> 		  0, ((u64)sc->cmnd[0] << 32 |
> 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
> 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
> -		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +		  fnic_flags_and_state(sc));
>=20
> 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 		      "Returning from abort cmd type %x %s\n", task_req,
> @@ -2030,7 +2025,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cm=
nd *sc,
>=20
> 	io_lock =3D fnic_io_lock_tag(fnic, abt_tag);
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	if (!io_req) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		return true;
> @@ -2042,14 +2037,14 @@ static bool fnic_pending_aborts_iter(struct scsi_=
cmnd *sc,
> 	 */
> 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 		      "Found IO in %s on lun\n",
> -		      fnic_ioreq_state_to_str(CMD_STATE(sc)));
> +		      fnic_ioreq_state_to_str(fnic_priv(sc)->state));
>=20
> -	if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> +	if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		return true;
> 	}
> -	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
> -	    (!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
> +	if ((fnic_priv(sc)->flags & FNIC_DEVICE_RESET) &&
> +	    (!(fnic_priv(sc)->flags & FNIC_DEV_RST_ISSUED))) {
> 		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> 			      "%s dev rst not pending sc 0x%p\n", __func__,
> 			      sc);
> @@ -2060,8 +2055,8 @@ static bool fnic_pending_aborts_iter(struct scsi_cm=
nd *sc,
> 	if (io_req->abts_done)
> 		shost_printk(KERN_ERR, fnic->lport->host,
> 			     "%s: io_req->abts_done is set state is %s\n",
> -			     __func__, fnic_ioreq_state_to_str(CMD_STATE(sc)));
> -	old_ioreq_state =3D CMD_STATE(sc);
> +			     __func__, fnic_ioreq_state_to_str(fnic_priv(sc)->state));
> +	old_ioreq_state =3D fnic_priv(sc)->state;
> 	/*
> 	 * Any pending IO issued prior to reset is expected to be
> 	 * in abts pending state, if not we need to set
> @@ -2069,17 +2064,17 @@ static bool fnic_pending_aborts_iter(struct scsi_=
cmnd *sc,
> 	 * When IO is completed, the IO will be handed over and
> 	 * handled in this function.
> 	 */
> -	CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_ABTS_PENDING;
>=20
> 	BUG_ON(io_req->abts_done);
>=20
> -	if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
> +	if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET) {
> 		abt_tag |=3D FNIC_TAG_DEV_RST;
> 		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> 			      "%s: dev rst sc 0x%p\n", __func__, sc);
> 	}
>=20
> -	CMD_ABTS_STATUS(sc) =3D FCPIO_INVALID_CODE;
> +	fnic_priv(sc)->abts_status =3D FCPIO_INVALID_CODE;
> 	io_req->abts_done =3D &tm_done;
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> @@ -2090,48 +2085,48 @@ static bool fnic_pending_aborts_iter(struct scsi_=
cmnd *sc,
> 				    FCPIO_ITMF_ABT_TASK_TERM,
> 				    fc_lun.scsi_lun, io_req)) {
> 		spin_lock_irqsave(io_lock, flags);
> -		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +		io_req =3D fnic_priv(sc)->io_req;
> 		if (io_req)
> 			io_req->abts_done =3D NULL;
> -		if (CMD_STATE(sc) =3D=3D FNIC_IOREQ_ABTS_PENDING)
> -			CMD_STATE(sc) =3D old_ioreq_state;
> +		if (fnic_priv(sc)->state =3D=3D FNIC_IOREQ_ABTS_PENDING)
> +			fnic_priv(sc)->state =3D old_ioreq_state;
> 		spin_unlock_irqrestore(io_lock, flags);
> 		iter_data->ret =3D FAILED;
> 		return false;
> 	} else {
> 		spin_lock_irqsave(io_lock, flags);
> -		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
> -			CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TERM_ISSUED;
> +		if (fnic_priv(sc)->flags & FNIC_DEVICE_RESET)
> +			fnic_priv(sc)->flags |=3D FNIC_DEV_RST_TERM_ISSUED;
> 		spin_unlock_irqrestore(io_lock, flags);
> 	}
> -	CMD_FLAGS(sc) |=3D FNIC_IO_INTERNAL_TERM_ISSUED;
> +	fnic_priv(sc)->flags |=3D FNIC_IO_INTERNAL_TERM_ISSUED;
>=20
> 	wait_for_completion_timeout(&tm_done, msecs_to_jiffies
> 				    (fnic->config.ed_tov));
>=20
> 	/* Recheck cmd state to check if it is now aborted */
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	if (!io_req) {
> 		spin_unlock_irqrestore(io_lock, flags);
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_REQ_NULL;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABT_TERM_REQ_NULL;
> 		return true;
> 	}
>=20
> 	io_req->abts_done =3D NULL;
>=20
> 	/* if abort is still pending with fw, fail */
> -	if (CMD_ABTS_STATUS(sc) =3D=3D FCPIO_INVALID_CODE) {
> +	if (fnic_priv(sc)->abts_status =3D=3D FCPIO_INVALID_CODE) {
> 		spin_unlock_irqrestore(io_lock, flags);
> -		CMD_FLAGS(sc) |=3D FNIC_IO_ABT_TERM_DONE;
> +		fnic_priv(sc)->flags |=3D FNIC_IO_ABT_TERM_DONE;
> 		iter_data->ret =3D FAILED;
> 		return false;
> 	}
> -	CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_COMPLETE;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_ABTS_COMPLETE;
>=20
> 	/* original sc used for lr is handled by dev reset code */
> 	if (sc !=3D iter_data->lr_sc)
> -		CMD_SP(sc) =3D NULL;
> +		fnic_priv(sc)->io_req =3D NULL;
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> 	/* original sc used for lr is handled by dev reset code */
> @@ -2272,7 +2267,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 		goto fnic_device_reset_end;
> 	}
>=20
> -	CMD_FLAGS(sc) =3D FNIC_DEVICE_RESET;
> +	fnic_priv(sc)->flags =3D FNIC_DEVICE_RESET;
> 	/* Allocate tag if not present */
>=20
> 	if (unlikely(tag < 0)) {
> @@ -2288,7 +2283,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 	}
> 	io_lock =3D fnic_io_lock_hash(fnic, sc);
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
>=20
> 	/*
> 	 * If there is a io_req attached to this command, then use it,
> @@ -2302,11 +2297,11 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 		}
> 		memset(io_req, 0, sizeof(*io_req));
> 		io_req->port_id =3D rport->port_id;
> -		CMD_SP(sc) =3D (char *)io_req;
> +		fnic_priv(sc)->io_req =3D io_req;
> 	}
> 	io_req->dr_done =3D &tm_done;
> -	CMD_STATE(sc) =3D FNIC_IOREQ_CMD_PENDING;
> -	CMD_LR_STATUS(sc) =3D FCPIO_INVALID_CODE;
> +	fnic_priv(sc)->state =3D FNIC_IOREQ_CMD_PENDING;
> +	fnic_priv(sc)->lr_status =3D FCPIO_INVALID_CODE;
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %x\n", tag);
> @@ -2317,13 +2312,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 	 */
> 	if (fnic_queue_dr_io_req(fnic, sc, io_req)) {
> 		spin_lock_irqsave(io_lock, flags);
> -		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +		io_req =3D fnic_priv(sc)->io_req;
> 		if (io_req)
> 			io_req->dr_done =3D NULL;
> 		goto fnic_device_reset_clean;
> 	}
> 	spin_lock_irqsave(io_lock, flags);
> -	CMD_FLAGS(sc) |=3D FNIC_DEV_RST_ISSUED;
> +	fnic_priv(sc)->flags |=3D FNIC_DEV_RST_ISSUED;
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> 	/*
> @@ -2334,7 +2329,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 				    msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
>=20
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	if (!io_req) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> @@ -2343,7 +2338,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 	}
> 	io_req->dr_done =3D NULL;
>=20
> -	status =3D CMD_LR_STATUS(sc);
> +	status =3D fnic_priv(sc)->lr_status;
>=20
> 	/*
> 	 * If lun reset not completed, bail out with failed. io_req
> @@ -2353,7 +2348,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 		atomic64_inc(&reset_stats->device_reset_timeouts);
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 			      "Device reset timed out\n");
> -		CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TIMED_OUT;
> +		fnic_priv(sc)->flags |=3D FNIC_DEV_RST_TIMED_OUT;
> 		spin_unlock_irqrestore(io_lock, flags);
> 		int_to_scsilun(sc->device->lun, &fc_lun);
> 		/*
> @@ -2362,7 +2357,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 		 */
> 		while (1) {
> 			spin_lock_irqsave(io_lock, flags);
> -			if (CMD_FLAGS(sc) & FNIC_DEV_RST_TERM_ISSUED) {
> +			if (fnic_priv(sc)->flags & FNIC_DEV_RST_TERM_ISSUED) {
> 				spin_unlock_irqrestore(io_lock, flags);
> 				break;
> 			}
> @@ -2375,8 +2370,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 				msecs_to_jiffies(FNIC_ABT_TERM_DELAY_TIMEOUT));
> 			} else {
> 				spin_lock_irqsave(io_lock, flags);
> -				CMD_FLAGS(sc) |=3D FNIC_DEV_RST_TERM_ISSUED;
> -				CMD_STATE(sc) =3D FNIC_IOREQ_ABTS_PENDING;
> +				fnic_priv(sc)->flags |=3D FNIC_DEV_RST_TERM_ISSUED;
> +				fnic_priv(sc)->state =3D FNIC_IOREQ_ABTS_PENDING;
> 				io_req->abts_done =3D &tm_done;
> 				spin_unlock_irqrestore(io_lock, flags);
> 				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> @@ -2387,13 +2382,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 		}
> 		while (1) {
> 			spin_lock_irqsave(io_lock, flags);
> -			if (!(CMD_FLAGS(sc) & FNIC_DEV_RST_DONE)) {
> +			if (!(fnic_priv(sc)->flags & FNIC_DEV_RST_DONE)) {
> 				spin_unlock_irqrestore(io_lock, flags);
> 				wait_for_completion_timeout(&tm_done,
> 				msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
> 				break;
> 			} else {
> -				io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +				io_req =3D fnic_priv(sc)->io_req;
> 				io_req->abts_done =3D NULL;
> 				goto fnic_device_reset_clean;
> 			}
> @@ -2408,7 +2403,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 		FNIC_SCSI_DBG(KERN_DEBUG,
> 			      fnic->lport->host,
> 			      "Device reset completed - failed\n");
> -		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +		io_req =3D fnic_priv(sc)->io_req;
> 		goto fnic_device_reset_clean;
> 	}
>=20
> @@ -2421,7 +2416,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 	 */
> 	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
> 		spin_lock_irqsave(io_lock, flags);
> -		io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +		io_req =3D fnic_priv(sc)->io_req;
> 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> 			      "Device reset failed"
> 			      " since could not abort all IOs\n");
> @@ -2430,14 +2425,14 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>=20
> 	/* Clean lun reset command */
> 	spin_lock_irqsave(io_lock, flags);
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	if (io_req)
> 		/* Completed, and successful */
> 		ret =3D SUCCESS;
>=20
> fnic_device_reset_clean:
> 	if (io_req)
> -		CMD_SP(sc) =3D NULL;
> +		fnic_priv(sc)->io_req =3D NULL;
>=20
> 	spin_unlock_irqrestore(io_lock, flags);
>=20
> @@ -2453,7 +2448,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
> 		  0, ((u64)sc->cmnd[0] << 32 |
> 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
> 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
> -		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
> +		  fnic_flags_and_state(sc));
>=20
> 	/* free tag if it is allocated */
> 	if (unlikely(tag_gen_flag))
> @@ -2698,7 +2693,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd=
 *sc, void *data,
> 	io_lock =3D fnic_io_lock_hash(fnic, sc);
> 	spin_lock_irqsave(io_lock, flags);
>=20
> -	io_req =3D (struct fnic_io_req *)CMD_SP(sc);
> +	io_req =3D fnic_priv(sc)->io_req;
> 	if (!io_req) {
> 		spin_unlock_irqrestore(io_lock, flags);
> 		return true;
> @@ -2710,8 +2705,8 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd=
 *sc, void *data,
> 	 */
> 	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
> 		      "Found IO in %s on lun\n",
> -		      fnic_ioreq_state_to_str(CMD_STATE(sc)));
> -	cmd_state =3D CMD_STATE(sc);
> +		      fnic_ioreq_state_to_str(fnic_priv(sc)->state));
> +	cmd_state =3D fnic_priv(sc)->state;
> 	spin_unlock_irqrestore(io_lock, flags);
> 	if (cmd_state =3D=3D FNIC_IOREQ_ABTS_PENDING)
> 		iter_data->ret =3D 1;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

