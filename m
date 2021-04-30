Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAAEC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 19:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C0806146D
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 19:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhD3TiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 15:38:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhD3TiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 15:38:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UJZdeH121919;
        Fri, 30 Apr 2021 19:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1YaWT8YQP/8lketdrdl9zPaYOPfsG87NfPNsYaj/3Ho=;
 b=Skzzq7Vh1L/DZCCcBGml/es0SudXE6gjyfJ6/BCRLIRmAN8qnDdb0aHZpFywUEyulNP2
 52gY3Tv04uW4Mi8Lh2KSSgKDjQEyEWalWt9EAioSB96ryUAA4HMFtxLzY8I/RWUU80Kw
 TI914iFU7Sqv+7goStzEfz+uLEduzQet0VCaaxytNbumzhMZ5nYcgnNVHYML1dNEIx2j
 KjePtqemjHa4fx96ayVxf/vrG+XwwSpYXvX8ZHNX9pAZdoWZCW5VNCc8xhM+1jMQCx80
 NePP16543Y6G+iiuGsnb0etWyUNotTnOSMZTNXo7PUMM3VFfUhIbYEC6nInTG5432Q/r Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385aft8rsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:37:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UJYwNk050619;
        Fri, 30 Apr 2021 19:37:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3030.oracle.com with ESMTP id 3848f2wpvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:37:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLgDNdFAkuuNgTvogC5becpYz39GC3YBQX/XSnAM5KdxbaPTPWahOU/9hn5q30rtcJNyzapWwPyC/Q0FZ81VRhfMA1AA7R+7aybYFZTVR2JgEy67hGyMxJX4+GEyZvrMMPzmOExryJVSpX0XJOORmA1sFUNSOw2u0DkdSzoq3vLGr2xpDVr25M7Q9vrFCvavo/oUxxI8h1Ab8192jG9d6AL6BbagKmZNGaLXG9ykouy4p+cNBl363J87zTtcZ6U0NiK7DmWcx/7d53hkTziEtb8HSwbqAL75+SISL/+oD1OBSZ00brSWeVl978yODPlPiofl0u4tUwFWOScxaAcGpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YaWT8YQP/8lketdrdl9zPaYOPfsG87NfPNsYaj/3Ho=;
 b=i+YCuF09DarxpGDFTwMEWySqGuIP3c5jfAiJooZ1WtdJLvb5o/5aOciGT5zTZSchf6bBFoug/656wuAGeBXPKqUwTv6HJVZsZm5K+gGncnSTsCEop8CVIvGsb4CZKyM+W/4JHE8GXdnAfDtZ1FqdW9k17bEfG4mQrkAPODtEAwaPjWeYLk0zsa5tQVed1pN5AbPfmiTCH0lMU4fU+JQ/7Di619m+Yw417JqJq3Zdj5I3Y/ckgpCtB68LmW2jQr+iq+3UFBFbdIfMMjJMFWH04uSQwRFgwoC7kf5TWCTGZxel+c7cJP9K+1mtglLBfub7yMt9wQVlr2nEjOrjbTuu4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YaWT8YQP/8lketdrdl9zPaYOPfsG87NfPNsYaj/3Ho=;
 b=BoHSZhSfAUWIuXk/rYbW2xLwg00foeFJV55bHVoWKvzHpkXC4VhtWacmKFRjQEHcrqCdv2pFkHqCx4MT9jbEX2yZUT/RNfzNaWctB8hzKMil60Cue35UletElohytihvdl+47Ox+Zmys0C7BZIFqSUsPUS2DfNNYlqY0WHG9Apw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 30 Apr
 2021 19:37:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 19:37:15 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Muneendra <muneendra.kumar@broadcom.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Hannes Reinecke <hare@suse.de>,
        James Smart <jsmart2021@gmail.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [PATCH v10 01/13] cgroup: Added cgroup_get_from_id
Thread-Topic: [PATCH v10 01/13] cgroup: Added cgroup_get_from_id
Thread-Index: AQHXO/BdR87/stKNvEO4fZrzhk9c5qrNeJGA
Date:   Fri, 30 Apr 2021 19:37:15 +0000
Message-ID: <CD03AFED-957A-4954-90B8-B652583A9FB8@oracle.com>
References: <1619562897-14062-1-git-send-email-muneendra.kumar@broadcom.com>
 <1619562897-14062-2-git-send-email-muneendra.kumar@broadcom.com>
In-Reply-To: <1619562897-14062-2-git-send-email-muneendra.kumar@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 670c55ce-ca7a-450e-a67a-08d90c0f5c1f
x-ms-traffictypediagnostic: SN6PR10MB2701:
x-microsoft-antispam-prvs: <SN6PR10MB27016BCF62AB72CF8EA74F13E65E9@SN6PR10MB2701.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qdEU0ae/lkM44gp0+itPXHOsJRAVlEGnvUYZj7HOY7ZCQrds6B+75b5EBiZoByu003Rt06WcF8HjhZCicdKVWHyk/VnfORnXORMijwJHRlSeOutGCpqLC0k5oCG568qWmTaNdgRaB6y1GQD7YODu6wVxE0nr0f9nk/qZdT6iSFvAiffAJa8po5ZkRmKamngFpRvJjtqcma2rgzTZFaVh8CxpG5IJ6hBbD9fKiwlkCGT8EPFIHbiK52Y7hT3AxNskIPLudrw6SdmAUFk3vc214/LFYNvG9lzhrN7BAZDMEbyQmwlkqivioX6Y1vvCCmFlwDcwe0ia3CpLeldA4q53aHeO3GYnMy8klDBwg6Ix35sMhvF++Nl9+uqUaFMNfVZBawvPiYTLXEX/RhjDyNgRDFJcfzPVIeiVZhXQksOTa6v8LLO7yPXMdx29H4lqf0yyIIsIXl2k/EeIT5wez5U7QHrlKgUmFfTIgEQUSWwXqo+6/CANkWDgZBhkIoZm5JIZaA3AT9PlRoXKg1+LhwlBdIrkp3YmUzSpH3/KSo4qtlJkvRfYHZuzCX8wiWMUD9BMrr6sR2qugBMm+IrLwMBZkW5wm1h4gck52P+tCH1/uydNMUd/JjDIWMm4gY8vOyUfpu4p3BjWeoukVMm9524HR92O1TZS/T4op9C76gl3Yas=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(136003)(376002)(83380400001)(6486002)(86362001)(33656002)(71200400001)(122000001)(53546011)(36756003)(6506007)(4326008)(66556008)(478600001)(44832011)(5660300002)(8676002)(6916009)(316002)(26005)(64756008)(186003)(76116006)(8936002)(2906002)(2616005)(6512007)(66476007)(38100700002)(54906003)(66946007)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ewZtiWBYdbdlfXUDdKbhqVGqybRSk04by+P9PivuU8A/3nGHpwddfp5c5SSW?=
 =?us-ascii?Q?gHUv5LrEQKNixjVd4rwrhkiP0evMy0dNPlGsxEk0kdfoYubh3iPdpG7Rm30F?=
 =?us-ascii?Q?B7OPxk6BjSEUBdQVFY7l3HaCdyENpq1ejt6a8Njqn51jM9AhLszx0g6zojcJ?=
 =?us-ascii?Q?6uNHYmNH1fEwuHP3zdQ7oJUd5DUJhTTGuJOc4ylQXCmpn/gCN7s4Cwg8xoam?=
 =?us-ascii?Q?G5Nklr3aUD+MCxMQchY9msf62FwZjQghsGKpKzAbyv0fX3fUXUqiNi2eGChX?=
 =?us-ascii?Q?y6VouMPqXD29CInyYKfu3CVERZ9xJYxD4k5GmpwA+Tdr8dV1gBpRSMzjncPz?=
 =?us-ascii?Q?lsq8GBP5yV3CJE98XEdZgVfqa5KgLxLTeqXCD0kslT4FwJ1NJQ7kaOcVA9cZ?=
 =?us-ascii?Q?B4aPtSoUmVG0GPqfAhgRH54h/XjF+5OEfH07YXvXJRiCPE2GS5fAP9bFsUJw?=
 =?us-ascii?Q?fp7RkWrOxjEQbIfitEpeBmFoKsRWYC5dHSPS8PBSoMnc0VtT/wOg+f+6zq5G?=
 =?us-ascii?Q?jXyi9593LF2s9veIYxpweVg3IgS8J51FUcxBvt3rUeeL1ojUFxOv96WLx7le?=
 =?us-ascii?Q?rrkx0KaMlzh9QYJ2QyGex+3l4DrzQBcoBqcPFEFl+W++Ybh8jyGLd9B7C4xH?=
 =?us-ascii?Q?kI2LKbtYwXQ56t/J09ePyL7eWiOhsgcK1bYLaJ2AmAuBX4HD/IQRnHpvfIwu?=
 =?us-ascii?Q?h9+MxCW28BfNFxpLTpMN+HaXuomJLarKY1omJXzsrtQjHG6B1WNBcXoMOK1O?=
 =?us-ascii?Q?GQSBE3AaUBxL2nyW5T2QHPeoLAmQFlh6G1DS/C2AvPGXIuly4VKwfhKoF6Qs?=
 =?us-ascii?Q?ONPiwiQNDZOcD/CsqUgsZXNv1kzPaKeH+0qkDQ/Lm/iGnOMAYAgGjPW0B/TS?=
 =?us-ascii?Q?KWrAo258nfYg75C5gyT5RIWvoooPsEbS5NeoNU9pwhueFodctB7NRA+tISUb?=
 =?us-ascii?Q?q4Vp0aLImZmKkeGsFWDhO/rU/zpqXKv+Mk9zujP0E0B7/tXHGT7ic8+vSLJt?=
 =?us-ascii?Q?1IZ6aDjNd2EaxJi1zmO68BQMmPjMlOlPr064OSUzKBO05kLUhfwEWK0EueI8?=
 =?us-ascii?Q?EOXlFK4A+bWQUHRlRln86Uva7frRyIDVfZvq00xbFgFijV2nrAI9cg03UOXl?=
 =?us-ascii?Q?+0PUBzNufPRSeRQrlcc/+wQagCaY4Six6iQijs3gos1yKUz7nxsPVsGdZE5j?=
 =?us-ascii?Q?MaHK7Qz2TCxOoXXjDMls/pvb9/VMHBLeJc76z7zraJWbjt8zEh/V2gOkBZT5?=
 =?us-ascii?Q?+7pTPG1vG1CJYneXVjz3F3u+A1rZi/DYvqJdkplyIyCYjKMWySsvEJ16sZMP?=
 =?us-ascii?Q?x1V0Fl/OCMEgSwJjrhun6fHh6edt00RoVjUJ93e25wcARQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1A7AC121F810246AB53BCF4254FD124@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 670c55ce-ca7a-450e-a67a-08d90c0f5c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2021 19:37:15.8936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4PFclK7cniDeFaOzH+bm47j3vLry4iG0gez94NA4gTR7h7fEFZizdOudGGSVGHDws0RB/NGrP4ijjZevJYOrojHpk3G/foFHVx7kSiiAUBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300135
X-Proofpoint-GUID: Tz0UixgxDCZJTDsnabCoaEMiR3O6eUUw
X-Proofpoint-ORIG-GUID: Tz0UixgxDCZJTDsnabCoaEMiR3O6eUUw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 27, 2021, at 5:34 PM, Muneendra <muneendra.kumar@broadcom.com> wro=
te:
>=20
> Added a new function cgroup_get_from_id  to retrieve the cgroup
> associated with cgroup id.
> Exported the same as this can be used by blk-cgorup.c
>=20
> Added function declaration of cgroup_get_from_id in cgorup.h
>=20
> This patch also exported the function cgroup_get_e_css
> as this is getting used in blk-cgroup.h
>=20
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>=20
> ---
> v10:
> No change
>=20
> v9:
> Addressed the issues reported by kernel test robot
>=20
> v8:
> No change
>=20
> v7:
> No change
>=20
> v6:
> No change
>=20
> v5:
> renamed the function cgroup_get_from_kernfs_id to
> cgroup_get_from_id
>=20
> v4:
> No change
>=20
> v3:
> Exported the cgroup_get_e_css
>=20
> v2:
> New patch
> ---
> include/linux/cgroup.h |  6 ++++++
> kernel/cgroup/cgroup.c | 26 ++++++++++++++++++++++++++
> 2 files changed, 32 insertions(+)
>=20
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 4f2f79de083e..d2eace88d9d1 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -696,6 +696,7 @@ static inline void cgroup_kthread_ready(void)
> }
>=20
> void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
> +struct cgroup *cgroup_get_from_id(u64 id);
> #else /* !CONFIG_CGROUPS */
>=20
> struct cgroup_subsys_state;
> @@ -743,6 +744,11 @@ static inline bool task_under_cgroup_hierarchy(struc=
t task_struct *task,
>=20
> static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t b=
uflen)
> {}
> +
> +static inline struct cgroup *cgroup_get_from_id(u64 id)
> +{
> +	return NULL;
> +}
> #endif /* !CONFIG_CGROUPS */
>=20
> #ifdef CONFIG_CGROUPS
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 9153b20e5cc6..20e5424a8227 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -577,6 +577,7 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct c=
group *cgrp,
> 	rcu_read_unlock();
> 	return css;
> }
> +EXPORT_SYMBOL_GPL(cgroup_get_e_css);
>=20
> static void cgroup_get_live(struct cgroup *cgrp)
> {
> @@ -5768,6 +5769,31 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf,=
 size_t buflen)
> 	kernfs_put(kn);
> }
>=20
> +/*
> + * cgroup_get_from_id : get the cgroup associated with cgroup id
> + * @id: cgroup id
> + * On success it returns the cgrp on failure it returns NULL
> + */
> +struct cgroup *cgroup_get_from_id(u64 id)
> +{
> +	struct kernfs_node *kn;
> +	struct cgroup *cgrp =3D NULL;
> +
> +	mutex_lock(&cgroup_mutex);
> +	kn =3D kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
> +	if (!kn)
> +		goto out_unlock;
> +
> +	cgrp =3D kn->priv;
> +	if (cgroup_is_dead(cgrp) || !cgroup_tryget(cgrp))
> +		cgrp =3D NULL;
> +	kernfs_put(kn);
> +out_unlock:
> +	mutex_unlock(&cgroup_mutex);
> +	return cgrp;
> +}
> +EXPORT_SYMBOL_GPL(cgroup_get_from_id);
> +
> /*
>  * proc_cgroup_show()
>  *  - Print task's cgroup paths into seq_file, one line for each hierarch=
y
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

