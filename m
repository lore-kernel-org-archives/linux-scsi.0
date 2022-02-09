Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4FCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240556AbiBISpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbiBISpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:45:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D88C0401D2
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:43:02 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HURMt013354;
        Wed, 9 Feb 2022 18:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0nwtFsuruu5ruAykpt0D9Me1toKEhOpOrEYMEMjVRhY=;
 b=UxvCCFXs+/ZqmpHWcS51Z/Edg73gMvM8/50zGSsIe2EydxXnZs4ubUmViU2J74ErHR+r
 nsyf9kexDh4orxUcXAq/s8pfePuReS8bq46+s3qBoMUWMhilyLdgOPMmIVADq18C8Bwx
 pfds8o/tLM7K96+97bS96BiztcpUYV5bsAJ7/OUrj55840PeE5e2S3t89flcgP6uC+lb
 4UZ9f52kKScPDfEbbZFfdFH50jUl3h6dcZdR0Q4jPDM9g9DW/io8D87TEsxEFPgtaadx
 RA9SZ8ksAhXbvGecRH0fiBCdkjiOnELJhfvQWPyjLwdY3GQl5tKLKKzCfYGxSUzfK+4C mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txpb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:42:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IQAlQ167644;
        Wed, 9 Feb 2022 18:42:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 3e1f9huvak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:42:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNpIC/vrx4koeOLuBhgKoEP2KTZ+MkawkkIGA+EaUgtlU++IuISpdG9iUSCla1+dRyPM2R0Y5P28Ovtb/RpTqGfyLL4BOuBgq4pD6wi/XcKbotxvTZHwj5TPqL2eixnBwpaHILmw4B4r80/sRyTn2j2WiMvhfhxDt7aPbF8rx3+vPPvaHEmpZne0pyTiD6pgo+Cpl19RzRKYXS0wRxU2RzQuFqlowmqepwrCZS6xfvT73Kd/xPXofMyJc4rCBlCvY+i9ocQczpCiiPd/HOeMntbff/6eb8BDeXIx8bA0yfCyxdDJ39ax7q5s1Z2GwGYUUVq4ndu9/UZgHWb3KZ+BIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nwtFsuruu5ruAykpt0D9Me1toKEhOpOrEYMEMjVRhY=;
 b=hpCtJr3QDHQGR9s9r+5MrbJ3+pA4cTDfD4hvM3Kprot0P5jHA55G9sQfNaTOPHGn3rd2eMR24g0nmZ0L9vnP8J+/zNVbqEgxLtuwKUDjJFI9fYJH2OuuayjRUBgr/oaWNoVabGlxGgeGBtziF4hbVbe0A0G0c2OokBkmE5CRhSp1zdbyScVOk++N+WgEx6rZzAXOL2Qk7jTVjwNI1r26ICQeTnIFwv+lNl259cMNxJhhzenBWI0QhaBn9I8QUzUNoeEEtuTL8V6aYduKZmOCckS/yViIR5TlW+dXH+o8jR1XoP52EOBs3mDiJ9ql6t9+4kEDdjmAwbRU2AyW9kH+nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0nwtFsuruu5ruAykpt0D9Me1toKEhOpOrEYMEMjVRhY=;
 b=g6xbMGFVz5ZOVKvfUzse3NkKagrxhpUqzM7oJJIomRU933XTsbyyKr0wIrCbbOSo37UiDzteUZSjvsdGyllTOjxPaA30rymTu1UcbChziUJQelISPL5TTmnviGnKjy4Dc08aZsBKrhRdf8KcMq7LJy4PgSYx7HUbqMolh2/AB98=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1676.namprd10.prod.outlook.com (2603:10b6:4:3::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 9 Feb 2022 18:42:47 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:42:47 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 29/44] mesh: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH v2 29/44] mesh: Move the SCSI pointer to private command
 data
Thread-Index: AQHYHRFBox83zAeHx06lq3bHTkWVt6yLj4YA
Date:   Wed, 9 Feb 2022 18:42:47 +0000
Message-ID: <493367A1-D916-40EF-893F-CFE057D564BF@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-30-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-30-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0421c95f-6baa-47fc-7a1c-08d9ebfbf789
x-ms-traffictypediagnostic: DM5PR10MB1676:EE_
x-microsoft-antispam-prvs: <DM5PR10MB16764A894D57601E5A72B7C4E62E9@DM5PR10MB1676.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5/gVr/Gsy0UDeFOfuOnt9rH+L+YonewO2wAE4ASUHqcQlthVlVCEC98BQFpsysfFW4jtP+3dY5WngIrxQL7gEBlufBK4KFgjqlc0wXXnB+BDCB/1E6fZ8k6wVEPv4TqZcl5TyW2HLqBXstMahn6Rj8pmminEqeY0Wy3+F2sR6xH4UrC2y6ZUaSDzfatxLOFq5R4XX0U2CEFVKrVy/aKicTRR5EVtY+bTfLQPGJksXuv03fcK6SJVsDS1obs4PZvj9NzDRQcILkGARAKzBlRiKFQyddcKLDRyN7Mi3Hn2MY+ZK6ClCr4U6qUCxV1fyB+Y0wDuKRTdeXQv0amH9A82yWzZeaHjVN/YMzWMKQFM861c2UG+5SuuogRhc9qk1baR1PtEE9GIzWdflYBEWsOPI+ljFnIxgJj8+x8tv+0bGZ2Uxq4u2t+sF3pFsnkA6oqvwHnesh/g1+p8k7fFhVFQIO/YCjQ1Mc6GnG+NEdY1VbwBz+0NCd202PhnFxhAPRXu0aNfmQZtALr3jQqxcK1aJ2hDu3mAl/NqsYLm2JhhP1DsBs2aFc6PXWnpl//SYe8+zhnTHuJTs2Wsum4mV7oKWYzCncLt5ssI5SergIxpxeWfoOq/cDJu96pH1ja+Dx7BXoLFMze7el09n7pswfN1SAiTibCmLGNiPRsT+99aJMZufFtM6RgflHDbbwGO5UyZNL5mnPe4nBAPWfQgib0N1/YF9nm0oXDqRAaJSFNT+VsAA4Iq+FI/T4AnmGAnwjcz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(91956017)(508600001)(71200400001)(6506007)(53546011)(6512007)(45080400002)(6916009)(6486002)(33656002)(186003)(83380400001)(38070700005)(122000001)(38100700002)(86362001)(5660300002)(8676002)(8936002)(2616005)(64756008)(76116006)(316002)(4326008)(2906002)(36756003)(66946007)(44832011)(66476007)(66556008)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kgo/+RXUBW8Kwd7OmLKmWZqgdCX/T8u5PrQKRBlDYNSpxkDamezUbBT6fJDd?=
 =?us-ascii?Q?jbwQmGufaZzJGXUxnEcIcpulJo+kIZzJXEJfDNtATGoDxTgftiu6gcdlNBlg?=
 =?us-ascii?Q?As/x0pywg570/t+PNbGHvEmaIKo8mBrWPjc38HiqYpo1RrmG9mNgTDm8NW1D?=
 =?us-ascii?Q?O/pXBUMSBnJoDpr1VEIjDhdZQNJTD/4V0BOMjK7ieB7xY1GdETLxIH5xojyU?=
 =?us-ascii?Q?YUKuS/J3PnG8iGGsEaybPJPmA6Mk/vgDTiT9Z3sg1DbaIrAgvQpTa+ATmRUo?=
 =?us-ascii?Q?kyQl8GgcF8a3d189uRC7TbF9HBChfJ8b8munOgGSqSMb7vxzff/+w8+mDdD/?=
 =?us-ascii?Q?wT9wBM6QYwBL0ANgAYbdk58npp2EP7czOKCd2z9Tgr638cDD8VAwTPkKY09H?=
 =?us-ascii?Q?KCRUWLQ82VKP8vX3bKdFViRh/By3H5pCF/xo/3jy81/Op3ejsT4nKhCqWUai?=
 =?us-ascii?Q?dJgaZwF+7Vm9vZMA+RZFtfhG6ICo+YZ8qqriieudLnHJ/Z223du237eenlZb?=
 =?us-ascii?Q?YNJJODk4UVB8JYhEbsqSMxDq7tpkPvyGbyO30CK6FqTBpy7dO61xWGRF5szt?=
 =?us-ascii?Q?9eZzNAxwi0DaB5B6IRzwSkUy9vBIDtBXcNOS6M3ct2xVHXrVv9ASlgpLeXLT?=
 =?us-ascii?Q?/7+1n948SBDreaHFgg5A0/ANwIXoSZHcyw8GAlRflMGvj/bnY7lg5lc5ej67?=
 =?us-ascii?Q?AatFgxEkT4fEm98rhlxTzMotAwq7P2i0PUY487R1rj5h0qICyL6ExaGI4J1F?=
 =?us-ascii?Q?hAuZaEAhR9nLB7g1VReRuNQCdFR0UfGFynXoblNoYd7NFXSkpxpk2ekhPrAR?=
 =?us-ascii?Q?6ih/D7oj2cGIFJcm41Yb+kiUHPDrV/n9SBym3tN3CPZ2t9HuYhJRjWwNrZW8?=
 =?us-ascii?Q?AvkIWjE0ngidivuxIvSSLt+hj/2JAuz5AoL6i6Q08vs2PwfDdl3YJ0W0OsIf?=
 =?us-ascii?Q?QzmxQyfE0kHVJ05ntGsEbjtvjoCAf0hFYc171hwLsFa3X2ujN+mO8AL90GD/?=
 =?us-ascii?Q?pri5WmAPwCmyruvTPykLhNEXYFW88xELwBUReec8txnoubHMWYNwAXLrQLaV?=
 =?us-ascii?Q?PN32WweGGuEkQMx9bE3C59tilFcOM3lt9uGorwB0ClRvPU9RQ5L+5yaKaVji?=
 =?us-ascii?Q?5ekItkmX+h1uMledfLjpxok9QUTmg/7867hzz2LcaDKD5/BnOFdSdsGzPS0L?=
 =?us-ascii?Q?45GBLFZt4TjQj7KaQBIwT2TDPxJZQUDOtk+2vbSSbXDN6XtqoDD9epPkS8ST?=
 =?us-ascii?Q?y5eSkl8JLGYU7WdaThaGwHeR4Jm0t9oWBGAjgtymadIuTQ94DwE74T20WwFE?=
 =?us-ascii?Q?FXp5734Sxu27M2QlcbNdBs4P2OR9fsIDIgRLDRKEEGBPI7O1JZVe3l0kx8QX?=
 =?us-ascii?Q?m1lPLVWdo8tWPYX0Q8Ysz6jyhkvm2oI8RVw6I1ubgJYcgc4BiWHaGGnqO8XM?=
 =?us-ascii?Q?zFkFCAtPFSJ8m3FMgLx/5P6yTpSkIdWJ6/Xq4AyS97tvN/P1rP4skl+9GKKQ?=
 =?us-ascii?Q?TsmiY2dQSfnxyGGKNLvPT2uEYvux7so8XXKANXnF1WosS4KDm+/pvp4SDF1r?=
 =?us-ascii?Q?5j4Htqo5munXm/UDW9ZJn0N3YYAi46Ema9ZcZD06J18CbChxOz1oguGQZBcc?=
 =?us-ascii?Q?L7yGI2C+ibdELOweZRzBqdaPZ34n16wFKLaXphtDPm4a4TPqp11WlvB1J4ZE?=
 =?us-ascii?Q?kHYe5xh6bUVaMBk2E3/SxPZZ/XB8yiZ3zjdEGoXtqQxYI8Vj?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54E213C71F8AB447848A747D18A262BF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0421c95f-6baa-47fc-7a1c-08d9ebfbf789
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:42:47.0999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LK5NNCxnC/bn4qS7dAJFDaSOQfj9kiThjXE3FTUH+O9OW2rP0D3lnrnbyypYkx8iu9dffpJ/8UkuzXtofvdeApU/eijlDhBsBEegjv7g1Xc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1676
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-ORIG-GUID: p-AdqMT2FGMl6X0rjEpul2LfgJLcYpyX
X-Proofpoint-GUID: p-AdqMT2FGMl6X0rjEpul2LfgJLcYpyX
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
> drivers/scsi/mesh.c | 20 +++++++++++++-------
> drivers/scsi/mesh.h | 11 +++++++++++
> 2 files changed, 24 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
> index ca133e0a140a..de9ae36def42 100644
> --- a/drivers/scsi/mesh.c
> +++ b/drivers/scsi/mesh.c
> @@ -586,10 +586,12 @@ static void mesh_done(struct mesh_state *ms, int st=
art_next)
> 	ms->current_req =3D NULL;
> 	tp->current_req =3D NULL;
> 	if (cmd) {
> +		struct scsi_pointer *scsi_pointer =3D mesh_scsi_pointer(cmd);
> +
> 		set_host_byte(cmd, ms->stat);
> -		set_status_byte(cmd, cmd->SCp.Status);
> +		set_status_byte(cmd, scsi_pointer->Status);
> 		if (ms->stat =3D=3D DID_OK)
> -			scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
> +			scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
> 		if (DEBUG_TARGET(cmd)) {
> 			printk(KERN_DEBUG "mesh_done: result =3D %x, data_ptr=3D%d, buflen=3D%=
d\n",
> 			       cmd->result, ms->data_ptr, scsi_bufflen(cmd));
> @@ -603,7 +605,7 @@ static void mesh_done(struct mesh_state *ms, int star=
t_next)
> 			}
> #endif
> 		}
> -		cmd->SCp.this_residual -=3D ms->data_ptr;
> +		scsi_pointer->this_residual -=3D ms->data_ptr;
> 		scsi_done(cmd);
> 	}
> 	if (start_next) {
> @@ -1171,7 +1173,7 @@ static void handle_msgin(struct mesh_state *ms)
> 	if (ms->n_msgin < msgin_length(ms))
> 		goto reject;
> 	if (cmd)
> -		cmd->SCp.Message =3D code;
> +		mesh_scsi_pointer(cmd)->Message =3D code;
> 	switch (code) {
> 	case COMMAND_COMPLETE:
> 		break;
> @@ -1262,7 +1264,7 @@ static void set_dma_cmds(struct mesh_state *ms, str=
uct scsi_cmnd *cmd)
> 	if (cmd) {
> 		int nseg;
>=20
> -		cmd->SCp.this_residual =3D scsi_bufflen(cmd);
> +		mesh_scsi_pointer(cmd)->this_residual =3D scsi_bufflen(cmd);
>=20
> 		nseg =3D scsi_dma_map(cmd);
> 		BUG_ON(nseg < 0);
> @@ -1592,10 +1594,13 @@ static void cmd_complete(struct mesh_state *ms)
> 			break;
> 		case statusing:
> 			if (cmd) {
> -				cmd->SCp.Status =3D mr->fifo;
> +				struct scsi_pointer *scsi_pointer =3D
> +					mesh_scsi_pointer(cmd);
> +
> +				scsi_pointer->Status =3D mr->fifo;
> 				if (DEBUG_TARGET(cmd))
> 					printk(KERN_DEBUG "mesh: status is %x\n",
> -					       cmd->SCp.Status);
> +					       scsi_pointer->Status);
> 			}
> 			ms->msgphase =3D msg_in;
> 			break;
> @@ -1837,6 +1842,7 @@ static struct scsi_host_template mesh_template =3D =
{
> 	.sg_tablesize			=3D SG_ALL,
> 	.cmd_per_lun			=3D 2,
> 	.max_segment_size		=3D 65535,
> +	.cmd_size			=3D sizeof(struct mesh_cmd_priv),
> };
>=20
> static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *=
match)
> diff --git a/drivers/scsi/mesh.h b/drivers/scsi/mesh.h
> index ee53c05ace95..1afa8b37295b 100644
> --- a/drivers/scsi/mesh.h
> +++ b/drivers/scsi/mesh.h
> @@ -8,6 +8,17 @@
> #ifndef _MESH_H
> #define _MESH_H
>=20
> +struct mesh_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static inline struct scsi_pointer *mesh_scsi_pointer(struct scsi_cmnd *c=
md)
> +{
> +	struct mesh_cmd_priv *mcmd =3D scsi_cmd_priv(cmd);
> +
> +	return &mcmd->scsi_pointer;
> +}
> +
> /*
>  * Registers in the MESH controller.
>  */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

