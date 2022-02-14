Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4334C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 22:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiBNWgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:36:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiBNWgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 17:36:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464F8DF77
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 14:36:43 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EIjURg028571;
        Mon, 14 Feb 2022 20:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=d0EGOjkofdvJX/tTbrx6V2ZTkf3KukFWBK4ie97umno=;
 b=d0brSvBEcIVxYGkSj3Yfierj9/sbHJTv1GiM39dUbKbL2KJ/pjVpWvgErxlHEZ64aLM2
 Ew8cfj3bI7YQM9iEnI87M7z1EaxXQXtt48Xd0XrO7WFgbmXZ55C1Y3RpthoGhPF/+zGF
 RwRSxWshVD/suwGmmgj14Qhy8Vw3ZqbJ2Hi1mj/rHihAI1B3Va5I1OmpnOVi2TBCLwnf
 0pdbe/GAxqn+fOL8ODIP8O5okoLaI6Rtqf/Lmz83uCa23bJeevRypf4BFaS0FpY5UAe/
 EatRIWtkqM7rtHAq38RHxkRzWoD9MSjMzwYgvOAH/j8AWONWbb9AyyGKQRWQm29aNR/m zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63g15qr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:12:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EKAQtn167304;
        Mon, 14 Feb 2022 20:12:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3030.oracle.com with ESMTP id 3e62xdp6b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjB7Uy2Rgje+FFoMy/nxbWWqaZVdSxg2SjfbH0p1qTfxZXXZuj96Qzi4rYFWTvXQFr1tyP+B/n50QKG19ICs89LBI80lXHwmFp8PQ6Cnj9tnEwCdissZ6qT7yh3fQ6QFpSEkIQZ1WLINzSZmpJqBX8KftkhUBrHj8uae7PWaMJe6L+HhmSZW6RJyEg67pey8D9VNv/0H7blOUG/SKCm2tJstkrUg32jES7dX6h0POv+7Rlc9qnmrcT9/kMWHaAwNMk6shxPnMNeBeR0cUuFsf9meMfyL69dUmQfErUUfyndbGbE8DhEpRVLJQ3VMxWKDoyS6Y5nU7XUWWq0zYoHl5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0EGOjkofdvJX/tTbrx6V2ZTkf3KukFWBK4ie97umno=;
 b=lnQPuXhw870fBv8ZPsytDzkPnBkXWXN5/4xvoqXnxYip45YUo3vjMstaC0JP5k485mwZni7sQ0YsuaVPtWjnZC+YuKjytkI/yN9k90az17PClaZEh33AX2a5Po057mmIaTadaNg4q9aAdPciwSGGhKaF1DMvXHfNzkDpU2QkQleF0Bvsv+QGmY2YJTIYv/Si4bz+nhrdziAaO4EOmctpkbBvI8V0Ep5sV2+94LuAYt1t8Yzs+R88mgbCCc9L+emSM7v/jGKim6yD4L6HAFFx1w21igN+Ha2g5+mmQl8m6tFz9U2EWbxr9AcfN3a3POERjlLqtlFvryxa/Pmhli0YjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0EGOjkofdvJX/tTbrx6V2ZTkf3KukFWBK4ie97umno=;
 b=CA74ynC5YDqsedOH1agEL3G/HcTNlzphhW8YXQOs7KqnYT1625Y2uPwM6nfeM6XZ7V4I0+fj4awiDNrTIRwenT+nRxUJfIpYD2EkZwmbkYH+Z3muXlKbR8MDQBEIWdrBLTHlWoMXoO7VEPccvxS8EWcKuoMPufDHfJ7SuNGTm8c=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH0PR10MB4828.namprd10.prod.outlook.com (2603:10b6:610:c8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 20:12:31 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Mon, 14 Feb 2022
 20:12:31 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v3 26/48] scsi: iscsi: Stop using the SCSI pointer
Thread-Topic: [PATCH v3 26/48] scsi: iscsi: Stop using the SCSI pointer
Thread-Index: AQHYH5d/Ao/2I5p37kqyVo+HO7UnUayTfzQA
Date:   Mon, 14 Feb 2022 20:12:31 +0000
Message-ID: <16C7F403-396A-44E4-A26B-F29368CF7BDF@oracle.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-27-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-27-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fdc89d9-9fdc-45e1-94c9-08d9eff65504
x-ms-traffictypediagnostic: CH0PR10MB4828:EE_
x-microsoft-antispam-prvs: <CH0PR10MB4828FBD7CE7E2E213B92ADE0E6339@CH0PR10MB4828.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XiqtdTC//vvoD1vFUZ1ZtLiNvmbtbpuCno/0SGn4DOlFdeDdAmuDFkYDgVsZW1bWBdDwo3VrpLMUhN92TB4HVdeNFcYV+OeWlLlYu9miIS47laltbzrZoUB+fIlnSyndLGnwH2wAkBOj1p0jKGjSmAlNBHa7i4FYcoA6ZIu4RjwA6IQQKB77gr1HwPlsCULfyMqOnIGi7dJnJzDfzbQ9NP9I3t+JG882i20Yd1b+bAsNe21P4kIkTMhzCb26X3KN6xkxoxBoGvRpiB4GmwPvLihbGveyW8+Sh0yAxqutT9vU0iWKiw1Ge+T3A1rw9rF076/LNRjlIofjt1xwU4RuDzsbTF4qhlV2W++Kzl64zj+FuHga3gNVoYEd+r45xcZYGdsK1idN1izy4rjmcBJCYkRVKO8lzUzfVl2WV9v78pT//NQ8ClKaMIoPX2EuHFXb0sg7355MmgbECGseKF5Gpl4qNhv5wLfl2cidLT/O7Sy/BQ3rCZ2jH0LqBP8Tr4LMQcS+j5A0kyn4clZNDaAky+X9FaReMt7SrcItCdB220oGkxfRyWfr5jTg+gr7WD4oc6P9xJLfd7s7++F6v8a6h97+5ebaJfshB9pgRKI91XdmBCaBaZfimUjLIDlg8WjEUciKolTjI47z1ju7VKdD6OdGOPd3APg2TQ9N77RZsThWrzeAyYDBxTOi2ggxqVxsseh5yQWhXtO68wirXq1XZmuJU+07gZx4k1u8A/0ZKa9IdG/Z2T4QThdCWvXJYKUO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(30864003)(186003)(2616005)(5660300002)(2906002)(7416002)(8936002)(53546011)(71200400001)(33656002)(6506007)(36756003)(83380400001)(6486002)(508600001)(6512007)(6916009)(38070700005)(122000001)(38100700002)(86362001)(54906003)(316002)(4326008)(66946007)(8676002)(76116006)(66556008)(66476007)(66446008)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jCX6j/0segr6gvArC8nBIcursXaYLtG3txPA3bfudc3zJR9+th8e8IGAgV34?=
 =?us-ascii?Q?qqeqqmb7Gz5tS0AEpHzn5ywut6s1cJPCD69rqLX4VwB4ukfW66P+sHsaXFPK?=
 =?us-ascii?Q?LECg+r0U9lj8Q6w/mqEsw80+sSKc9XjgpLW0FDEePjY+uJp69/ouvkNm3ygC?=
 =?us-ascii?Q?h/NniFz9ofZvLkl+Af2hQ6jUZ49kM6E6fRv694hEcqO/sq0oGXOt/ccKMpYL?=
 =?us-ascii?Q?gL/OXKYtkVQMDPdNflbdQsfoizksWUXwC0lrkaIKYO2M6dS6OQSbm4PkqIAA?=
 =?us-ascii?Q?2UjLk4doUxZO2h7ZhCwUgYGRIec5p+H2SCKRJXi2FjoAugKOt9MUPs0eD1cA?=
 =?us-ascii?Q?SqW5Wrhzmu+SdJ9i1rGYR+P34MDsMjTcS7QCq3yIHu0TJ5VHpr4rQRtvBzPL?=
 =?us-ascii?Q?bQEcJv+9RGFHe1zapHgCgASNdUdBi8fYTc4uTse+9HEPLOrqJ4ldHe1lrHLK?=
 =?us-ascii?Q?xfBvpJOtRNBA2LPxII3ImanXxMIK6HAk8arqbeo1nTxvYHxqmLNCLFPOu6vl?=
 =?us-ascii?Q?Cavo86JAy20i0ZASn19OV23KBAToIP+1IH62AaaaLLKSdVBHEwBdNP3HwZlm?=
 =?us-ascii?Q?l4X0rhDjj5wqSg2kmwZDAipMFdgV6goaCaeyCtwsHzoKilzwyh/LJMIOXfp4?=
 =?us-ascii?Q?7S8OduPIfdopD0I6KFlFWVRHDi2j2KRBs25ixGqaJriTxgAS6UD6JXgnSiWK?=
 =?us-ascii?Q?nquJ6KLfxMjxT2WR9afiQ7prm2ZSK9vxbz/B4BhVtA1hUp5ENYOpaaNcB7uf?=
 =?us-ascii?Q?MKYVHXhqX3Z9TrvVH11qIYmMD7d+dDnMVzw4mapl+8q9PAKiXtw7BsCo+wJO?=
 =?us-ascii?Q?x1a8CckfLPW6CczFBeOlom4HlVXu5BSVYYArqJ5+As/YGnoTiSTZtK7KPAx5?=
 =?us-ascii?Q?WHzhyKo29Pz526XE7b/p3u55kyFkla+i50Aw/u9bAfSKuvgIkgGlcTSwaK84?=
 =?us-ascii?Q?TIyD420YoO6mOjqwsZ6eNNHzww+VwXJI3sIPo4cz2inhyc/g0b4wxcVBD2+X?=
 =?us-ascii?Q?DbIoLALbrLxcqI+uDgHBiNi7ncZWkZVU2G9Vo9sbdG3r9+9KARnqgOpPF+zd?=
 =?us-ascii?Q?FQZRyXEzQdR3CqQ3SMWQePzA4bBy6ySIn23gdLuWcPev32JBQMHIca/m5RZe?=
 =?us-ascii?Q?sr3dS/5Q3uIv79Nn1qcYoPLcsVko2M6l5x6rIwV5xDIVNGuX0hfmkqCvcMr3?=
 =?us-ascii?Q?ibTUbqhY+JnnIfAMQL8/pEgW6aSwS/CqbKhWtGLm/7hggU/Nw463Lois7KPf?=
 =?us-ascii?Q?RZVU+90hD3JmppLdn5V/W2bl2SAq0DhDhxpTUSSCOrIr2n+Yue3DaHuKbDlo?=
 =?us-ascii?Q?89RIav8Nre6xLMYJwxZfSec+yyoxC00w+R+KTHyx02Htc7SsNPAAiGusMdMg?=
 =?us-ascii?Q?8UUg8cnBgy8QduNdOEKtwIHHsFo9cq3/kIPsKOA1knwsTNFWb/h6ZHwz4DYz?=
 =?us-ascii?Q?7tInxi/lLAUNM7yGrJ3gleo6th9g+fgC+csh8HaNk/7N8S0PcyG2pA9vTdDF?=
 =?us-ascii?Q?2ysY+cPEEFwu+octkAYqmo63kb7Uf8SPh38Lhph/d/PHhQuu9DOlyV9Fuk+p?=
 =?us-ascii?Q?ata54Vg4jH2MJrT+8GHsKcCRFo8K0PtsaQWkrkocc2JwLxY2iAhD4fSXsU/W?=
 =?us-ascii?Q?soVp/DLn8HPkoe5bwJwsuZ8ux1jLACBERTt7oyRUM4i9gGc6zq/6B8l5eT+s?=
 =?us-ascii?Q?4qpCtIWxvv47YSH1QU4iOaQaXrAv/ibWzrsafknG9sQj25h7?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A64694C07E118D4FB9F00D0D8E53FA7D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fdc89d9-9fdc-45e1-94c9-08d9eff65504
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 20:12:31.5899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4CmBzvxc4IeTnyxmOVGlJdxe15QbWdsGlmYDQscAOrGMLOIHjCEp7U9QjDdPWcfPP7M+e0Is9emPzuCivl7IOqCFLxTY5AvJY5PIErPnoOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4828
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140117
X-Proofpoint-GUID: QVsHigvS1i27rD4H-ZkUnL0DYHA1eLt4
X-Proofpoint-ORIG-GUID: QVsHigvS1i27rD4H-ZkUnL0DYHA1eLt4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 11, 2022, at 2:32 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Instead of storing the iSCSI task pointer and the session age in the SCSI
> pointer, use command-private variables. This patch prepares for removal o=
f
> the SCSI pointer from struct scsi_cmnd.
>=20
> The list of iSCSI drivers has been obtained as follows:
> $ git grep -lw iscsi_host_alloc
> drivers/infiniband/ulp/iser/iscsi_iser.c
> drivers/scsi/be2iscsi/be_main.c
> drivers/scsi/bnx2i/bnx2i_iscsi.c
> drivers/scsi/cxgbi/libcxgbi.c
> drivers/scsi/iscsi_tcp.c
> drivers/scsi/libiscsi.c
> drivers/scsi/qedi/qedi_main.c
> drivers/scsi/qla4xxx/ql4_os.c
> include/scsi/libiscsi.h
>=20
> Note: it is not clear to me how the qla4xxx driver can work without this
> patch since it uses the scsi_cmnd::SCp.ptr member for two different
> purposes:
> - The qla4xxx driver uses this member to store a struct srb pointer.
> - libiscsi uses this member to store a struct iscsi_task pointer.
>=20
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Manish Rangankar <mrangankar@marvell.com>
> Cc: Karen Xie <kxie@chelsio.com>
> Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>=20
> iscsi
> ---
> drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
> drivers/scsi/be2iscsi/be_main.c          |  3 ++-
> drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
> drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
> drivers/scsi/iscsi_tcp.c                 |  1 +
> drivers/scsi/libiscsi.c                  | 20 ++++++++++----------
> drivers/scsi/qedi/qedi_fw.c              |  4 ++--
> drivers/scsi/qedi/qedi_iscsi.c           |  1 +
> drivers/scsi/qla4xxx/ql4_def.h           | 16 +++++++++++++---
> drivers/scsi/qla4xxx/ql4_os.c            | 13 +++++++------
> include/scsi/libiscsi.h                  | 12 ++++++++++++
> 12 files changed, 52 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniban=
d/ulp/iser/iscsi_iser.c
> index 07e47021a71f..f8d0bab4424c 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -971,6 +971,7 @@ static struct scsi_host_template iscsi_iser_sht =3D {
> 	.proc_name              =3D "iscsi_iser",
> 	.this_id                =3D -1,
> 	.track_queue_depth	=3D 1,
> +	.cmd_size		=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport iscsi_iser_transport =3D {
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
> index ab55681145f8..3bb0adefbe06 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -218,7 +218,7 @@ static char const *cqe_desc[] =3D {
>=20
> static int beiscsi_eh_abort(struct scsi_cmnd *sc)
> {
> -	struct iscsi_task *abrt_task =3D (struct iscsi_task *)sc->SCp.ptr;
> +	struct iscsi_task *abrt_task =3D iscsi_cmd(sc)->task;
> 	struct iscsi_cls_session *cls_session;
> 	struct beiscsi_io_task *abrt_io_task;
> 	struct beiscsi_conn *beiscsi_conn;
> @@ -403,6 +403,7 @@ static struct scsi_host_template beiscsi_sht =3D {
> 	.cmd_per_lun =3D BEISCSI_CMD_PER_LUN,
> 	.vendor_id =3D SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
> 	.track_queue_depth =3D 1,
> +	.cmd_size =3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct scsi_transport_template *beiscsi_scsi_transport;
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_=
iscsi.c
> index e21b053b4f3e..fe86fd61a995 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -2268,6 +2268,7 @@ static struct scsi_host_template bnx2i_host_templat=
e =3D {
> 	.sg_tablesize		=3D ISCSI_MAX_BDS_PER_CMD,
> 	.shost_groups		=3D bnx2i_dev_groups,
> 	.track_queue_depth	=3D 1,
> +	.cmd_size		=3D sizeof(struct iscsi_cmd),
> };
>=20
> struct iscsi_transport bnx2i_iscsi_transport =3D {
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb=
3i/cxgb3i.c
> index f949a4e00783..ff9d4287937a 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -98,6 +98,7 @@ static struct scsi_host_template cxgb3i_host_template =
=3D {
> 	.dma_boundary	=3D PAGE_SIZE - 1,
> 	.this_id	=3D -1,
> 	.track_queue_depth =3D 1,
> +	.cmd_size	=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport cxgb3i_iscsi_transport =3D {
> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb=
4i/cxgb4i.c
> index efb3e2b3398e..53d91bf9c12a 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> @@ -116,6 +116,7 @@ static struct scsi_host_template cxgb4i_host_template=
 =3D {
> 	.dma_boundary	=3D PAGE_SIZE - 1,
> 	.this_id	=3D -1,
> 	.track_queue_depth =3D 1,
> +	.cmd_size	=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport cxgb4i_iscsi_transport =3D {
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 1bc37593c88f..9fee70d6434a 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1007,6 +1007,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht =
=3D {
> 	.proc_name		=3D "iscsi_tcp",
> 	.this_id		=3D -1,
> 	.track_queue_depth	=3D 1,
> +	.cmd_size		=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport iscsi_sw_tcp_transport =3D {
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 059dae8909ee..d69203d19f2c 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -462,7 +462,7 @@ static void iscsi_free_task(struct iscsi_task *task)
>=20
> 	if (sc) {
> 		/* SCSI eh reuses commands to verify us */
> -		sc->SCp.ptr =3D NULL;
> +		iscsi_cmd(sc)->task =3D NULL;
> 		/*
> 		 * queue command may call this to free the task, so
> 		 * it will decide how to return sc to scsi-ml.
> @@ -1344,10 +1344,10 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscs=
i_conn *conn, itt_t itt)
> 	if (!task || !task->sc)
> 		return NULL;
>=20
> -	if (task->sc->SCp.phase !=3D conn->session->age) {
> +	if (iscsi_cmd(task->sc)->age !=3D conn->session->age) {
> 		iscsi_session_printk(KERN_ERR, conn->session,
> 				  "task's session age %d, expected %d\n",
> -				  task->sc->SCp.phase, conn->session->age);
> +				  iscsi_cmd(task->sc)->age, conn->session->age);
> 		return NULL;
> 	}
>=20
> @@ -1645,8 +1645,8 @@ static inline struct iscsi_task *iscsi_alloc_task(s=
truct iscsi_conn *conn,
> 			 (void *) &task, sizeof(void *)))
> 		return NULL;
>=20
> -	sc->SCp.phase =3D conn->session->age;
> -	sc->SCp.ptr =3D (char *) task;
> +	iscsi_cmd(sc)->age =3D conn->session->age;
> +	iscsi_cmd(sc)->task =3D task;
>=20
> 	refcount_set(&task->refcount, 1);
> 	task->state =3D ISCSI_TASK_PENDING;
> @@ -1683,7 +1683,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, stru=
ct scsi_cmnd *sc)
> 	struct iscsi_task *task =3D NULL;
>=20
> 	sc->result =3D 0;
> -	sc->SCp.ptr =3D NULL;
> +	iscsi_cmd(sc)->task =3D NULL;
>=20
> 	ihost =3D shost_priv(host);
>=20
> @@ -1997,7 +1997,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(str=
uct scsi_cmnd *sc)
>=20
> 	spin_lock_bh(&session->frwd_lock);
> 	spin_lock(&session->back_lock);
> -	task =3D (struct iscsi_task *)sc->SCp.ptr;
> +	task =3D iscsi_cmd(sc)->task;
> 	if (!task) {
> 		/*
> 		 * Raced with completion. Blk layer has taken ownership
> @@ -2260,7 +2260,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
> 	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
> 	 * got the command.
> 	 */
> -	if (!sc->SCp.ptr) {
> +	if (!iscsi_cmd(sc)->task) {
> 		ISCSI_DBG_EH(session, "sc never reached iscsi layer or "
> 				      "it completed.\n");
> 		spin_unlock_bh(&session->frwd_lock);
> @@ -2273,7 +2273,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
> 	 * then let the host reset code handle this
> 	 */
> 	if (!session->leadconn || session->state !=3D ISCSI_STATE_LOGGED_IN ||
> -	    sc->SCp.phase !=3D session->age) {
> +	    iscsi_cmd(sc)->age !=3D session->age) {
> 		spin_unlock_bh(&session->frwd_lock);
> 		mutex_unlock(&session->eh_mutex);
> 		ISCSI_DBG_EH(session, "failing abort due to dropped "
> @@ -2282,7 +2282,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
> 	}
>=20
> 	spin_lock(&session->back_lock);
> -	task =3D (struct iscsi_task *)sc->SCp.ptr;
> +	task =3D iscsi_cmd(sc)->task;
> 	if (!task || !task->sc) {
> 		/* task completed before time out */
> 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 5916ed7662d5..4e99508ff95d 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -603,9 +603,9 @@ static void qedi_scsi_completion(struct qedi_ctx *qed=
i,
> 		goto error;
> 	}
>=20
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!iscsi_cmd(sc_cmd)->task) {
> 		QEDI_WARN(&qedi->dbg_ctx,
> -			  "SCp.ptr is NULL, returned in another context.\n");
> +			  "NULL task pointer, returned in another context.\n");
> 		goto error;
> 	}
>=20
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c
> index 282ecb4e39bb..8196f89f404e 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -59,6 +59,7 @@ struct scsi_host_template qedi_host_template =3D {
> 	.dma_boundary =3D QEDI_HW_DMA_BOUNDARY,
> 	.cmd_per_lun =3D 128,
> 	.shost_groups =3D qedi_shost_groups,
> +	.cmd_size =3D sizeof(struct iscsi_cmd),
> };
>=20
> static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_de=
f.h
> index 69a590546bf9..5f82c8afd5e0 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -216,11 +216,21 @@
> #define IDC_COMP_TOV			5
> #define LINK_UP_COMP_TOV		30
>=20
> -#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
> +/*
> + * Note: the data structure below does not have a struct iscsi_cmd membe=
r since
> + * the qla4xxx driver does not use libiscsi for SCSI I/O.
> + */
> +struct qla4xxx_cmd_priv {
> +	struct srb *srb;
> +};
> +
> +static inline struct qla4xxx_cmd_priv *qla4xxx_cmd_priv(struct scsi_cmnd=
 *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
>=20
> /*
> - * SCSI Request Block structure	 (srb)	that is placed
> - * on cmd->SCp location of every I/O	 [We have 22 bytes available]
> + * SCSI Request Block structure (srb) that is associated with each scsi_=
cmnd.
>  */
> struct srb {
> 	struct list_head list;	/* (8)	 */
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
> index 0ae936d839f1..d64eda961412 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -226,6 +226,7 @@ static struct scsi_host_template qla4xxx_driver_templ=
ate =3D {
> 	.name			=3D DRIVER_NAME,
> 	.proc_name		=3D DRIVER_NAME,
> 	.queuecommand		=3D qla4xxx_queuecommand,
> +	.cmd_size		=3D sizeof(struct qla4xxx_cmd_priv),
>=20
> 	.eh_abort_handler	=3D qla4xxx_eh_abort,
> 	.eh_device_reset_handler =3D qla4xxx_eh_device_reset,
> @@ -4054,7 +4055,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_=
qla_host *ha,
> 	srb->ddb =3D ddb_entry;
> 	srb->cmd =3D cmd;
> 	srb->flags =3D 0;
> -	CMD_SP(cmd) =3D (void *)srb;
> +	qla4xxx_cmd_priv(cmd)->srb =3D srb;
>=20
> 	return srb;
> }
> @@ -4067,7 +4068,7 @@ static void qla4xxx_srb_free_dma(struct scsi_qla_ho=
st *ha, struct srb *srb)
> 		scsi_dma_unmap(cmd);
> 		srb->flags &=3D ~SRB_DMA_VALID;
> 	}
> -	CMD_SP(cmd) =3D NULL;
> +	qla4xxx_cmd_priv(cmd)->srb =3D NULL;
> }
>=20
> void qla4xxx_srb_compl(struct kref *ref)
> @@ -4640,7 +4641,7 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *h=
a)
> 			 * the scsi/block layer is going to prevent
> 			 * the tag from being released.
> 			 */
> -			if (cmd !=3D NULL && CMD_SP(cmd))
> +			if (cmd !=3D NULL && qla4xxx_cmd_priv(cmd)->srb)
> 				break;
> 		}
> 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> @@ -9079,7 +9080,7 @@ struct srb *qla4xxx_del_from_active_array(struct sc=
si_qla_host *ha,
> 	if (!cmd)
> 		return srb;
>=20
> -	srb =3D (struct srb *)CMD_SP(cmd);
> +	srb =3D qla4xxx_cmd_priv(cmd)->srb;
> 	if (!srb)
> 		return srb;
>=20
> @@ -9121,7 +9122,7 @@ static int qla4xxx_eh_wait_on_command(struct scsi_q=
la_host *ha,
>=20
> 	do {
> 		/* Checking to see if its returned to OS */
> -		rp =3D (struct srb *) CMD_SP(cmd);
> +		rp =3D qla4xxx_cmd_priv(cmd)->srb;
> 		if (rp =3D=3D NULL) {
> 			done++;
> 			break;
> @@ -9215,7 +9216,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
> 	}
>=20
> 	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	srb =3D (struct srb *) CMD_SP(cmd);
> +	srb =3D qla4xxx_cmd_priv(cmd)->srb;
> 	if (!srb) {
> 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> 		ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%llu: Specified command has alrea=
dy completed.\n",
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 4ee233e5a6ff..cb805ed9cbf1 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -19,6 +19,7 @@
> #include <linux/refcount.h>
> #include <scsi/iscsi_proto.h>
> #include <scsi/iscsi_if.h>
> +#include <scsi/scsi_cmnd.h>
> #include <scsi/scsi_transport_iscsi.h>
>=20
> struct scsi_transport_template;
> @@ -152,6 +153,17 @@ static inline bool iscsi_task_is_completed(struct is=
csi_task *task)
> 	       task->state =3D=3D ISCSI_TASK_ABRT_SESS_RECOV;
> }
>=20
> +/* Private data associated with struct scsi_cmnd. */
> +struct iscsi_cmd {
> +	struct iscsi_task	*task;
> +	int			age;
> +};
> +
> +static inline struct iscsi_cmd *iscsi_cmd(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> /* Connection's states */
> enum {
> 	ISCSI_CONN_INITIAL_STAGE,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

