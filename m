Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDF4C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241057AbiBISwA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241263AbiBISuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:50:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AB6C03E95F
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:46:35 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HD6DM013525;
        Wed, 9 Feb 2022 18:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3rI4Ee9irVtLjFEgNSQbs500qYte2IdnihMZtgV6Wjs=;
 b=cgheA+72XsOH9GK+Dl5cHHa6b07oszvCV/9Jq7+dHiGQ4uJpacvNh/SMV5E9EZgiJ6Wu
 WQNlB4KsSBdbar/PYiNOJsViy7TFfBx9omWnR78dxeDX5WdbE8iL9zTnlHxuk21840Cd
 yldhO2YBZ4XVBmKBfW7JrtwHYm914s021BaVQgIxPWZnYcOECytE2TjTMWiqajbQIDq7
 8NZIhKGCjyiB8+Yl2Y3vb9gsBGgvE784OOFH+bFh6TK8Cezfp0yJ25Ub/upTPvblasZf
 S5mF3bxR6kHwTb7JYw+vPX27pqWn5pNykFYJ/ZyFgTxhRzmcRxCnDaWWW8cPaE/VSOmq qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e345sqddc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:46:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IQHmL058750;
        Wed, 9 Feb 2022 18:46:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3020.oracle.com with ESMTP id 3e1jptjeg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:46:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYMvCpa+7Ql04NhI1ep5+4wf5KLv5w7R8qAyx7lOn3cAywz2cuOLsD1R6UWiWeVpCigDPVjjnNrLFUtUcucK9fSIDQht6P2A3xvQS6ppmawoRW7is9Kx/CwzmmZexWUWNj5ke+vmcG+GsMTfS6Ka48x5W9EC7mfXULf7lpft9sOyoSurWZCSCaJqWrK99C3iSpjUjoK/f6ggFPbwttDDYMBPpOIbEQGbKKMqnMNwyMyMZI/1JPnyDnLISN9iJwCmFMKThi+OGEZOA3Vah3cXEMGurY3o+3Rcf/S3BO38iIbKaM+cUaK/2bAUeKrTU+iowsIMtX8v2w4MO4dlLxAQxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rI4Ee9irVtLjFEgNSQbs500qYte2IdnihMZtgV6Wjs=;
 b=IRht8VPtNnA3MhV60trZIRoJK0J8O1lNL1FqcguenQ0khDt6TLSbTU5spf0ULZieVjigkUwtjQKndouIOcAjjC3V23J5oIDQIM2I0hUdIwijdKNaimEReK6GUVeNK5+Rw5AEU9V7PtKsl4KxUC8SFBx75P+pIWBFD0lLpEhjS8rcUcnd3Qx5IRg9mWaQRieZeAN3R6jiXnYhGujs7hitV/kPM5a8k7lSa1AB9uSvvjW6Qpx+UxeDwc7G0NYYMbnpU6MUklEkuIKPjB6D4xrL/ZbPvhEvE9hXxxBQpKcAkFtc4fyc6QdH6NRotFVtNKFOSIAI618gIIDNVk++s+CDQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rI4Ee9irVtLjFEgNSQbs500qYte2IdnihMZtgV6Wjs=;
 b=KTPjPWfqUj5xn2712gMj0GyzQmrfgwXkIdW0isdmgqAX56AlrXF+1lQU8U/W5bunfT/FyL3wVCamKljRB6c2qZ6jfc3vJREHbSojodToVmcefwL91xvJgXf8sTFPXvfQsG6hS/H4q9zJ1lxDw6eNsGgMZkAbkz5zHgZ0JM21aJk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5288.namprd10.prod.outlook.com (2603:10b6:408:12c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:46:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:46:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 31/44] mvumi: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 31/44] mvumi: Stop using the SCSI pointer
Thread-Index: AQHYHRE3SyzMcqUeK0a+rfnEg2ejmKyLkIwA
Date:   Wed, 9 Feb 2022 18:46:27 +0000
Message-ID: <B7585CD0-D6FD-4D95-BF95-A7F6EA1B11C5@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-32-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-32-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18ded7ce-6b12-4db8-0930-08d9ebfc7ab2
x-ms-traffictypediagnostic: BN0PR10MB5288:EE_
x-microsoft-antispam-prvs: <BN0PR10MB52887A8054A235EDF328E519E62E9@BN0PR10MB5288.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8PDiM5/BSp4TUvYun/nrxj5efM4ImEw/Z6RkNfn5ewe/G4HH0WNraDYJokdHEJRSvkpwVqN/svgL+rNKUZvmwDMog3XiF2OKNv6yXp7qKuI3msKFfTlLp2XkeNj8JQE6njXWgI8oQ40UG3lwlTX1++yH3hd2sb4VrmYfB6NpetUyZkfkxgtLcW99ovXuNXlxwsgK5Iu635Liqkibi1d/60spbtvAmNVBWoQ7YkLgC6XurwCow6MF+0q+MtkL8GGdEynYHyXHozvPCpTDoHI5rNwU9YSGh8GJLwsWYxUL4qiZQVbwxzAxrbbqZ92Rt6YJ8cJ+/SAjr4r/j5UCQmy3ikxCT4AM0h/EYXvgXN8sn8BOszT3DPLEUA68ZGmBi+MIWN8TMFMOJS9/v/1BPX7TKhWuDfWDIge+kL6dCpdiPEqrvqi8wVCmx5XFNMZkS1xONii3Nxu2PE4pCR+pQvbWIjnwEbsBwNPfK3KgGoQFwlBj/V8ngwUgzxvFMOjyqV7oUz2mhVbDPsaoSGUKW+UB0tPu5laCWOOosFjGQnygndXwEsFEY3m7ss1GE0cwb4XfrR3xCSAEwGYpnzGt9Pq1ZLeSvLVKiDZSYIebTbiTg7TAAiYgFKYJXwQnPB7DmO3Vb7ZSqLLpYZ4JRt+obl9mq+bCb832V/df/9Q98ywHfcQLboABszlFg3FZfnRYBZWUZ0OMQrN1RRLzWziJff17DamN/Z4QjDClX+VIuvPhhogt6vZ5Es3ucN9xgIgykZ/P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(38070700005)(6486002)(83380400001)(54906003)(76116006)(6916009)(316002)(122000001)(33656002)(2906002)(186003)(2616005)(44832011)(86362001)(6512007)(66476007)(508600001)(71200400001)(5660300002)(38100700002)(64756008)(36756003)(53546011)(8676002)(8936002)(6506007)(66556008)(66446008)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l1rt4i8jXAm9r3IyRjU+oZdDGmw0Ei6cSPXTc/dNeTRLtd0mcyWtc/8IDpPb?=
 =?us-ascii?Q?CqSUIXGkQojV3G4vjnwlLmTwlJ+N6+KzpYtrW8yiQHPa4hmEXmVaZQxZWWVI?=
 =?us-ascii?Q?8h9c2MgmJ5kej1ZXU+OFB0pBXn/dJMiR1uuJNW0GC4J6Mcz1BFkiJA78iP9C?=
 =?us-ascii?Q?TG8q4h73S6HeE1y3mdJWy5Z9pGxVSiSTkltRCTGFUreindXEcT4qIMJ7kS8k?=
 =?us-ascii?Q?zsN2Ajn8uyGN11kzaps1w0gKqQNNkj94miDESU9wus5hN6JNpEtD6ZJr/4h3?=
 =?us-ascii?Q?Ja9CSBI3REBEke81hB+OlsHR1Bi2s+LchuCvRDTJ3ewnSoDar/oi5xsG2MgS?=
 =?us-ascii?Q?RI8rXSvctC2igH562rbwrXlR7B754COnLCVp9V1sNLkslX8BPdYKNTWCy2XU?=
 =?us-ascii?Q?z9b3bjC+k9vfz/IJTCX6JhskEY4w9IPiGMfxq2hKawdCKv4YqvYZlTaWBBBz?=
 =?us-ascii?Q?Rk6ldX/GPseH/Lq9Q8WIiZV7gncWeKERpwn239Ev0EjvGqolrkhThg8IKc3f?=
 =?us-ascii?Q?nbt0v8Dh2Qv9nve/sg4nGkrx/HUs1u5FtZlTVX0Zg2/ZjlTDjtVXmlLvk3mE?=
 =?us-ascii?Q?QWGJMcVKy4WdFpwg5r3P5y602U8mSbId3dGC1HwpZiUmK7u3G4hMm/bLPxyW?=
 =?us-ascii?Q?WGP2lgeJmvc4qUfqPG/aNqz+0T/VYxiIZcHLxoBHt4stdeJ8rFPT/bBXNdwz?=
 =?us-ascii?Q?aGdyoDaNDOeILo7ko2wVFZzqbnnatv2YdvizBk/GOQxchz1fHNGg187nwM0+?=
 =?us-ascii?Q?gwC1fKyo7fsINcvIEu+vqOvrrXEp95c8HCmy/qCAyChfxwi2lNKuEU4HEdNi?=
 =?us-ascii?Q?teR/ZLSCkblGT/bX/VGbUSW/JHy+s8LwxUJSLoLb/PT8K/ZEK5Kw7pu2nzdY?=
 =?us-ascii?Q?uwoph4G7ctN0y2qqvndgOX9qOHQRZAzPYqR3soIllYWA3wa4q5PvrJ/g7oz7?=
 =?us-ascii?Q?Tqv6QYrHBMDJkwhNRb8A4l4jDwZOWGvrdgrE1Lzd1xq2JHB6znZqvVCdZX6J?=
 =?us-ascii?Q?0Tedgawy1zY/eRC7SrCLX+lo8pw0X0w/N0P/yGWaIz9gcU9cc3LdmWsDTE4k?=
 =?us-ascii?Q?lrevs4RikoMq3O+t7tyCTF8jemts/CKJevHUYeNQHxlz/2KfuDr07ueWmTSt?=
 =?us-ascii?Q?QfY5Kt8Gs7PBUnSkMKHggaSJFrY+rV8jUqi3A+kb89jJYhPN6XmyckNya2za?=
 =?us-ascii?Q?So9kSGBQTIoNuU/ThNuuAzVw5OVmMmB6RfiMz0WDwW34SfR9o7EsEJuoFVSF?=
 =?us-ascii?Q?Qnyj8nPkF8EDbZb6PoRYgGsxQdsdbAiR5cVpGRctEGP8qc3AqtPRqSOK7YSw?=
 =?us-ascii?Q?oZOyPE+ASGwopTjHbF/SUXjyTuXCdvq/7cZr3oh3mcSSusf+yPeWT/ovN7Ab?=
 =?us-ascii?Q?DMZURS3Gv8IscuFyWIvP4HRbm7XIWvz2Vvg+eCmywkV6Ad3hSw6856vYxgrI?=
 =?us-ascii?Q?EHZ1VUgu30bpbEsVzOvzHxsN6DOB8I9KLxsYnCBmEXx/McMcAoA2L6+EnhIR?=
 =?us-ascii?Q?rd7S/hgIpFqOxbZYQhWPVjo2nqggJHXXNjkorE/qBl5J69/lkKpL8HJ33bkV?=
 =?us-ascii?Q?mTITGi7kgfHrnVICZnxfDV5Kn8si3Ja1Tjsf5hH5iSReE12ODQSGH+5nSZEA?=
 =?us-ascii?Q?WZgYW4mEnun9lFWZJHNyarYLr3T0d6apTsQj/OwsJKCnLxgqYen1uQTA6hFV?=
 =?us-ascii?Q?hIIAtqTlPT9H+tc64CHCC3k4U/Wn/P4mpxYAaAhdj5qXbv13?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9522C41FF3F5BD49B5E844907141DF39@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ded7ce-6b12-4db8-0930-08d9ebfc7ab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:46:27.1316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nNI9d0jujApsSYfb9mhCd1zs7T0LcHOvn8V2aqypP95w/R9o0uWODwydqcVdDvAPqotMLQK6yhC6R4Br3TMWngqj0zfcHlP2VaNAc/slmo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5288
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-GUID: gmmqIdv9SRw95h7tO5y08vXOC42c8sS-
X-Proofpoint-ORIG-GUID: gmmqIdv9SRw95h7tO5y08vXOC42c8sS-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/mvumi.c | 9 +++++----
> drivers/scsi/mvumi.h | 9 +++++++++
> 2 files changed, 14 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 904de62c974c..05d3ce9b72db 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1302,7 +1302,7 @@ static void mvumi_complete_cmd(struct mvumi_hba *mh=
ba, struct mvumi_cmd *cmd,
> {
> 	struct scsi_cmnd *scmd =3D cmd->scmd;
>=20
> -	cmd->scmd->SCp.ptr =3D NULL;
> +	mvumi_priv(cmd->scmd)->cmd_priv =3D NULL;
> 	scmd->result =3D ob_frame->req_status;
>=20
> 	switch (ob_frame->req_status) {
> @@ -2097,7 +2097,7 @@ static int mvumi_queue_command(struct Scsi_Host *sh=
ost,
> 		goto out_return_cmd;
>=20
> 	cmd->scmd =3D scmd;
> -	scmd->SCp.ptr =3D (char *) cmd;
> +	mvumi_priv(scmd)->cmd_priv =3D cmd;
> 	mhba->instancet->fire_cmd(mhba, cmd);
> 	spin_unlock_irqrestore(shost->host_lock, irq_flags);
> 	return 0;
> @@ -2111,7 +2111,7 @@ static int mvumi_queue_command(struct Scsi_Host *sh=
ost,
>=20
> static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
> {
> -	struct mvumi_cmd *cmd =3D (struct mvumi_cmd *) scmd->SCp.ptr;
> +	struct mvumi_cmd *cmd =3D mvumi_priv(scmd)->cmd_priv;
> 	struct Scsi_Host *host =3D scmd->device->host;
> 	struct mvumi_hba *mhba =3D shost_priv(host);
> 	unsigned long flags;
> @@ -2128,7 +2128,7 @@ static enum blk_eh_timer_return mvumi_timed_out(str=
uct scsi_cmnd *scmd)
> 		atomic_dec(&mhba->fw_outstanding);
>=20
> 	scmd->result =3D (DID_ABORT << 16);
> -	scmd->SCp.ptr =3D NULL;
> +	mvumi_priv(scmd)->cmd_priv =3D NULL;
> 	if (scsi_bufflen(scmd)) {
> 		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
> 			     scsi_sg_count(scmd),
> @@ -2179,6 +2179,7 @@ static struct scsi_host_template mvumi_template =3D=
 {
> 	.bios_param =3D mvumi_bios_param,
> 	.dma_boundary =3D PAGE_SIZE - 1,
> 	.this_id =3D -1,
> +	.cmd_size =3D sizeof(struct mvumi_cmd_priv),
> };
>=20
> static int mvumi_cfg_hw_reg(struct mvumi_hba *mhba)
> diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
> index 60d5691fc4ab..a88c58787b68 100644
> --- a/drivers/scsi/mvumi.h
> +++ b/drivers/scsi/mvumi.h
> @@ -254,6 +254,15 @@ struct mvumi_cmd {
> 	unsigned char cmd_status;
> };
>=20
> +struct mvumi_cmd_priv {
> +	struct mvumi_cmd *cmd_priv;
> +};
> +
> +static inline struct mvumi_cmd_priv *mvumi_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> /*
>  * the function type of the in bound frame
>  */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

