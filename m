Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F246DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D517861221
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJUOqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:46:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12032 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUOqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:46:35 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEYMEV013675;
        Thu, 21 Oct 2021 14:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=A9FZk7XqR8q7c+YsxjK8lPVEW2GzJD1B/upa7MutQOc=;
 b=P3AQbksLmPHNF0dLNAowG6/UWUj/TLZCZFtpNNc7TNqIKujfQ/cIXmWRDKIBr/jhG3TR
 0XZ9q6F6ZXiy/EeDPu9Ff7LzlWf9WSpSx576GaUaTdEdX+BLSuSgIRQdSHNXLVxU8JCU
 jhnID5VlokHXHTLTRsOjy98i+N1vJMIbQbnTB/Tr3oWd2ceKZmPlpy4t2vNeFUWCaAAZ
 y+NA4OgpF5TsVB+1BqZT4FHXQPuFBkoIx1qRrbsuw3X3N5C9/oa+fx2LRYBeFrGpdWuG
 PrYRAskgilqGWu1nrklCHrX9XGdnDpIDdaAEW5NroI6rEOZ5VysVguG7ceGj5m1ZcunY CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm5a2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:44:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEauSe099777;
        Thu, 21 Oct 2021 14:44:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by aserp3030.oracle.com with ESMTP id 3bqmsj99a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W36mmRx2tsWHBEwb9suXHf/MoYe8xvL18k9fC2p9Ob1riCAThf2CxE60yhueR8ZbOFWDnmn0Qs6mPWp8liALqAkal0GbhQY/4B0CBBrFbvsX2nvRGr9RtB8ZYPwh8tXK91v7EcuuEZKXxJTgl4n0o2i0xk/uOq0DHwwAoGM/VtKEqaH72J2o+9hb4QQ33aGAHFgpv0BXAQMpsgqPGLflWOF+fcHGOgDzFWyS5JveI2v6x8HGbqen6LLFfK2jK8UbXV4oL5Wxtx8acbz5l9UJxA/QL+u3WpUXAuWJ/kKMampECZ6Z3T8IlpLqGabacmfMtBeouI3Ry0jpweZTeQE0yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9FZk7XqR8q7c+YsxjK8lPVEW2GzJD1B/upa7MutQOc=;
 b=j4QS7urnDHA8U/oFqPPlPw9GV3P2/CDDs/+GXzRGupI83Z4r/zH9Uas+/DQqYY2dY9Ww9L/KkOOYYG6zpIpaMxJBcqOw3oyaCgb9w415fU+pZ/rMj72LQkhsay2CXzklCkEB7wDO69fWHOwedScfjWq30QxOZw1lJy2AIYmOw6qOZ9VD1CBcCNV4gbQyfn1ko7bprtXkjly35tUA6ai8iahaAEuerHZsyQAPlFv2GNpojUyMUuxGGDkh7wKuBXOsrFON95FU4Yb9Q7qGPso5eGYTI4W/gQ75y7wB0HEOaf+twZ6MezzyzqKceVDzlH9Aw074jb33ModuPd6p4+11pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9FZk7XqR8q7c+YsxjK8lPVEW2GzJD1B/upa7MutQOc=;
 b=x6ojGoTrg8L0dEr4zE4vWa/yXtgFTGYopl6Z3hWRfvJRjsDL9llmtvsA0rPpy4MWkHcRaAtC0J5VTsg8EYPK7iRa9FL8FYY7WiAOUf/UTQrpOpEdp180rTi6eGYOPpjHePEYNIWbZymX2OXJ1jCCZtcSMKomoffAweeNKhm97e8=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by MN2PR10MB4238.namprd10.prod.outlook.com (2603:10b6:208:1d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 21 Oct
 2021 14:44:11 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:44:11 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 11/13] qla2xxx: edif: fix inconsistent check of
 db_flags
Thread-Topic: [PATCH v2 11/13] qla2xxx: edif: fix inconsistent check of
 db_flags
Thread-Index: AQHXxk3YdQOzxZPKbke2xcjIVdJJvKvdh5sA
Date:   Thu, 21 Oct 2021 14:44:11 +0000
Message-ID: <08A7D80E-AA06-454C-98F1-189873DA4680@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-12-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-12-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d56d9cf8-f487-46e8-69b8-08d994a13eb8
x-ms-traffictypediagnostic: MN2PR10MB4238:
x-microsoft-antispam-prvs: <MN2PR10MB4238402CA84FA23EA9BC1D52E6BF9@MN2PR10MB4238.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:48;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jb2hO3Jw5bz3jcjuvypdJ353oAo78klVPz52EujpSZQvs2xO5Bz7vMxuhHKP7PYwROLj/UOp+L6IUO//aBgC59YJmWlGRofrePx7XySS8MH4RDUtKJ3E9vWAXibTrQzf9hmemnANVUuQvERO0ArYXeKgexvgwT25N0CGMty4rDXdS1FCht2VJ8cLS+Ritl9Umk0/20Lsqf9M54SUWE8/lZTkImunPA6rbTzADN+P556lF5J3DFRqCpNQuQYcfURP72f6pa+xKhqTsoHGzp4JMgli/3Sv0NF2aZhFDfSzjpxmfnl3ph3qJJT+NpbNne/F4PuZ0VW2UZMhzRhMjxlnGZcYsUamm+np6XQ+em7F3r/6ySZuba/oaHKGTGys9METjpp3C9WgZYB9MuIUdF0WxQrqwB/T1wHDk9mKRTqUiZCQJNsnLVmL/aqPrkvTJziO/XWVh2Zsn4eB8kK2ln4mbbbW9O9tl6V40AYd6NTlsh0kGC6mPyXI6jetAFIy0mslZ6XrFaWNfjR8U0MDpePnhzIrO3wbz0ykcaAuKDm1T8thRlkRLtFZkEaWY0IbvFWPIAKLwkWjLYamrnqyh959MOpSw/ulN/+WBunh/n9Okc9xtw0F4TIgB0IeB8uKZU3xvFAR/GdWmTaQ6MoB+5mD0C7nwrQEd9iJ/H4GqqgCTsVm2JUkA9jGo5HMPc2cmKKmQy+5Y99he7wj0JB6pTIi/m1aPeUaEQLL1F54QijecXEzwsy4c7nS+AxZ+kN6teqb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(54906003)(122000001)(38100700002)(316002)(8676002)(38070700005)(83380400001)(8936002)(53546011)(6506007)(86362001)(6486002)(71200400001)(33656002)(4326008)(26005)(5660300002)(508600001)(36756003)(66946007)(186003)(66476007)(64756008)(2616005)(91956017)(44832011)(76116006)(6916009)(2906002)(66446008)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1MGqsJNw99ec0P58grkYngRscVSNF6raehbre7c/PZC89tuVSo8JL0BPUKfB?=
 =?us-ascii?Q?qK3uww35rX96oR//zgfhba76Et3aatOxdrkQFjW0JP9lkYr/wD7o+uNAPWus?=
 =?us-ascii?Q?l00GSZzRb+uDjjrL/0HIzw0uvdLv25XiKzB3re6FUHUpQkdroUhZTQolzdSZ?=
 =?us-ascii?Q?B0omzjBha/PrErNWwJEPpt8PGhKb5wuVeludrtiBINpRZZRQiVqF8C/wBsv0?=
 =?us-ascii?Q?IzcXU5tyCXXtiN+8mzku+hriqdS+tzwekR1/+v1lzPnQdrhBXMb+2OBVkltr?=
 =?us-ascii?Q?guBQqbE/+8UmUeh1wQFfjmxWrYG50DPDIMAOyQQSY8iZAibWto2C21nIV7xe?=
 =?us-ascii?Q?8lwvuYZ4zwhYjSakYh1nD+DVyQEP5f5YNys6vViF8QLQi7jKUQpS/QCmSeD2?=
 =?us-ascii?Q?A2OFkwi6UYK3RYxQksmAJcPxdil5+PNc9A0+Iispa5MggjOdfbjzzYvDov/+?=
 =?us-ascii?Q?d8F+6pxqFSLCwux5h9gFQSe2MMj9LARPCWEemjEaBJm8JoUFitV0LSqE0BEV?=
 =?us-ascii?Q?JNY6gK7e5CzDQr/kxbn65S1tlbZ/pF3WAuTWmUht0i9SOBWyjnPg3LOm1fgE?=
 =?us-ascii?Q?3vuPeRGBDq5sDVlzMpFA5cGNi2L0/t8JIojVF11+h4yhxK6VbyI4AnmXU2vB?=
 =?us-ascii?Q?LY0Y2oIGpassOjoLgWCllPPllI4EM/zHU2iJtKtJVnHWafXy2GlIbgGzGjA+?=
 =?us-ascii?Q?q2uWzuLXSZUHxqLQay+pKyvOmiWqV3dH+586TBVAwCXM+vc7ajTos7LjR+q+?=
 =?us-ascii?Q?y4FgxYIYTwPTBzzpNQT0UR2TQ/BCeC/PgowaDP/Zx71Y3ZVn20Z7WfkyeXlP?=
 =?us-ascii?Q?GbfdpdSehsU2h2rMxNnMDv998OYeJAd0p/dPHO2yJaDx2kqAZiGwtqdvUFtv?=
 =?us-ascii?Q?U51qP5xZJr5kjBp38jvOANVOEF6QfR9LJnrn6vkV38KfyyYGfP4uTCYHOknH?=
 =?us-ascii?Q?49NMjR9Sk8P5jeXgsjZNHezbqHUCJ2ImqO4WXg6plosxyGnzk8sT4WUrfHZm?=
 =?us-ascii?Q?dgIw2KCBhAK0NRnLobF+rR53uBRk/SllSe19yz4Qpk24ytEVMPwsgi+vhUAM?=
 =?us-ascii?Q?sEOI2Dgc0X/WEYOgWsow59lcaDCPGKTxb+3y2E8TeOXJnvvr0w5RiCKwBD4J?=
 =?us-ascii?Q?VydPpShOXos7Np+Qz53xesoai2bHQC839wzuaStT5I9ektShSXqW3SSAS1Dh?=
 =?us-ascii?Q?QviVMSljUI5G5rWirVEETWpLxtSr6HLAyRksJ90hfl1DH+y8QaIWqPJb7Xxn?=
 =?us-ascii?Q?ItgXvj5KlQT1cgxx/q5aICqe8ad0Sw/4Jk2osuzucjNevzij7zmGtFbTTRQP?=
 =?us-ascii?Q?OyJldur08CHKrVfagagKHdn4RtIts89yZG5vwB6Md1kWZHjSjDAf2NHjpBLm?=
 =?us-ascii?Q?zueVbbGuApNSm+/QfRkkqzX4sOSgmdNd8M+Jwfslycw5aFCcHWNUymUEwBr5?=
 =?us-ascii?Q?Kgc7Oy3Mwtxjk9KonrFWDsj8SKLpda8eYV+NgSJiRSk30ST7JVNS2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <88FAFDA288F9A4499C2894CC5CD81D36@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56d9cf8-f487-46e8-69b8-08d994a13eb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:44:11.1005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4238
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210078
X-Proofpoint-GUID: F9xk_7__u5cy7pB4XXFWwAWQJttsJ_J5
X-Proofpoint-ORIG-GUID: F9xk_7__u5cy7pB4XXFWwAWQJttsJ_J5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:32 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> db_flags field is a bit field. Replace value check with bit flag check.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c   | 26 +++++++++++++-------------
> drivers/scsi/qla2xxx/qla_edif.h   |  7 +++++--
> drivers/scsi/qla2xxx/qla_init.c   | 13 ++++++-------
> drivers/scsi/qla2xxx/qla_iocb.c   |  3 +--
> drivers/scsi/qla2xxx/qla_target.c |  2 +-
> 5 files changed, 26 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index 1ea130c61d70..440a3caa28f9 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -218,7 +218,7 @@ fc_port_t *fcport)
> 		    "%s edif not enabled\n", __func__);
> 		goto done;
> 	}
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		ql_dbg(ql_dbg_edif, vha, 0x09102,
> 		    "%s doorbell not enabled\n", __func__);
> 		goto done;
> @@ -482,9 +482,9 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_j=
ob *bsg_job)
> 	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app_vid=3D%x app_start_flags %x\n",
> 	     __func__, appstart.app_info.app_vid, appstart.app_start_flags);
>=20
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		/* mark doorbell as active since an app is now present */
> -		vha->e_dbell.db_flags =3D EDB_ACTIVE;
> +		vha->e_dbell.db_flags |=3D EDB_ACTIVE;
> 	} else {
> 		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
> 		     __func__);
> @@ -1274,7 +1274,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
> 		goto done;
> 	}
>=20
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		ql_log(ql_log_warn, vha, 0x70a1, "App not started\n");
> 		rval =3D -EIO;
> 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> @@ -1778,7 +1778,7 @@ qla_els_reject_iocb(scsi_qla_host_t *vha, struct ql=
a_qpair *qp,
> void
> qla_edb_init(scsi_qla_host_t *vha)
> {
> -	if (vha->e_dbell.db_flags =3D=3D EDB_ACTIVE) {
> +	if (DBELL_ACTIVE(vha)) {
> 		/* list already init'd - error */
> 		ql_dbg(ql_dbg_edif, vha, 0x09102,
> 		    "edif db already initialized, cannot reinit\n");
> @@ -1821,7 +1821,7 @@ static void qla_edb_clear(scsi_qla_host_t *vha, por=
t_id_t portid)
> 	port_id_t sid;
> 	LIST_HEAD(edb_list);
>=20
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		/* doorbell list not enabled */
> 		ql_dbg(ql_dbg_edif, vha, 0x09102,
> 		       "%s doorbell not enabled\n", __func__);
> @@ -1875,7 +1875,7 @@ qla_edb_stop(scsi_qla_host_t *vha)
> 	unsigned long flags;
> 	struct edb_node *node, *q;
>=20
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		/* doorbell list not enabled */
> 		ql_dbg(ql_dbg_edif, vha, 0x09102,
> 		    "%s doorbell not enabled\n", __func__);
> @@ -1926,7 +1926,7 @@ qla_edb_node_add(scsi_qla_host_t *vha, struct edb_n=
ode *ptr)
> {
> 	unsigned long		flags;
>=20
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		/* doorbell list not enabled */
> 		ql_dbg(ql_dbg_edif, vha, 0x09102,
> 		    "%s doorbell not enabled\n", __func__);
> @@ -1957,7 +1957,7 @@ qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t =
dbtype,
> 		return;
> 	}
>=20
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		if (fcport)
> 			fcport->edif.auth_state =3D dbtype;
> 		/* doorbell list not enabled */
> @@ -2052,7 +2052,7 @@ qla_edif_timer(scsi_qla_host_t *vha)
> 	struct qla_hw_data *ha =3D vha->hw;
>=20
> 	if (!vha->vp_idx && N2N_TOPO(ha) && ha->flags.n2n_fw_acc_sec) {
> -		if (vha->e_dbell.db_flags !=3D EDB_ACTIVE &&
> +		if (DBELL_INACTIVE(vha) &&
> 		    ha->edif_post_stop_cnt_down) {
> 			ha->edif_post_stop_cnt_down--;
>=20
> @@ -2090,7 +2090,7 @@ edif_doorbell_show(struct device *dev, struct devic=
e_attribute *attr,
> 	sz =3D 256;
>=20
> 	/* stop new threads from waiting if we're not init'd */
> -	if (vha->e_dbell.db_flags !=3D EDB_ACTIVE) {
> +	if (DBELL_INACTIVE(vha)) {
> 		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
> 		    "%s error - edif db not enabled\n", __func__);
> 		return 0;
> @@ -2438,7 +2438,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **=
pkt, struct rsp_que **rsp)
>=20
> 	fcport =3D qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
>=20
> -	if (host->e_dbell.db_flags !=3D EDB_ACTIVE ||
> +	if (DBELL_INACTIVE(vha) ||
> 	    (fcport && EDIF_SESSION_DOWN(fcport))) {
> 		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =3D%x %06x\n",
> 		    __func__, host->e_dbell.db_flags,
> @@ -3464,7 +3464,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, stru=
ct bsg_job *bsg_job)
>=20
> void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
> {
> -	if (sess->edif.app_sess_online && vha->e_dbell.db_flags & EDB_ACTIVE) {
> +	if (sess->edif.app_sess_online && DBELL_ACTIVE(vha)) {
> 		ql_dbg(ql_dbg_disc, vha, 0xf09c,
> 			"%s: sess %8phN send port_offline event\n",
> 			__func__, sess->port_name);
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_e=
dif.h
> index 2517005fb08c..a965ca8e47ce 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.h
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -41,9 +41,12 @@ struct pur_core {
> };
>=20
> enum db_flags_t {
> -	EDB_ACTIVE =3D 0x1,
> +	EDB_ACTIVE =3D BIT_0,
> };
>=20
> +#define DBELL_ACTIVE(_v) (_v->e_dbell.db_flags & EDB_ACTIVE)
> +#define DBELL_INACTIVE(_v) (!(_v->e_dbell.db_flags & EDB_ACTIVE))
> +
> struct edif_dbell {
> 	enum db_flags_t		db_flags;
> 	spinlock_t		db_lock;
> @@ -134,7 +137,7 @@ struct enode {
> 	 !_s->edif.app_sess_online))
>=20
> #define EDIF_NEGOTIATION_PENDING(_fcport) \
> -	((_fcport->vha.e_dbell.db_flags & EDB_ACTIVE) && \
> +	(DBELL_ACTIVE(_fcport->vha) && \
> 	 (_fcport->disc_state =3D=3D DSC_LOGIN_AUTH_PEND))
>=20
> #endif	/* __QLA_EDIF_H */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 2bc5593645ec..c0b813fc1ec4 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -330,7 +330,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_por=
t_t *fcport,
> 		lio->u.logio.flags |=3D SRB_LOGIN_PRLI_ONLY;
> 	} else {
> 		if (vha->hw->flags.edif_enabled &&
> -		    vha->e_dbell.db_flags & EDB_ACTIVE) {
> +		    DBELL_ACTIVE(vha)) {
> 			lio->u.logio.flags |=3D
> 				(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
> 		} else {
> @@ -861,7 +861,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_ho=
st_t *vha,
> 				break;
> 			case DSC_LS_PLOGI_COMP:
> 				if (vha->hw->flags.edif_enabled &&
> -				    vha->e_dbell.db_flags & EDB_ACTIVE) {
> +				    DBELL_ACTIVE(vha)) {
> 					/* check to see if App support secure or not */
> 					qla24xx_post_gpdb_work(vha, fcport, 0);
> 					break;
> @@ -1451,7 +1451,7 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vh=
a, fc_port_t *fcport,
> 			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
> 			    fcport->d_id.b24);
>=20
> -			if (vha->e_dbell.db_flags =3D=3D  EDB_ACTIVE) {
> +			if (DBELL_ACTIVE(vha)) {
> 				ql_dbg(ql_dbg_disc, vha, 0x20ef,
> 				    "%s %d %8phC EDIF: post DB_AUTH: AUTH needed\n",
> 				    __func__, __LINE__, fcport->port_name);
> @@ -1794,7 +1794,7 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, stru=
ct event_arg *ea)
> 				return;
> 			}
>=20
> -			if (vha->hw->flags.edif_enabled && vha->e_dbell.db_flags & EDB_ACTIVE=
) {
> +			if (vha->hw->flags.edif_enabled && DBELL_ACTIVE(vha)) {
> 				/*
> 				 * On ipsec start by remote port, Target port
> 				 * may use RSCN to trigger initiator to
> @@ -4240,7 +4240,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
> 		 * fw shal not send PRLI after PLOGI Acc
> 		 */
> 		if (ha->flags.edif_enabled &&
> -		    vha->e_dbell.db_flags & EDB_ACTIVE) {
> +		    DBELL_ACTIVE(vha)) {
> 			ha->fw_options[3] |=3D BIT_15;
> 			ha->flags.n2n_fw_acc_sec =3D 1;
> 		} else {
> @@ -5396,8 +5396,7 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
> 			 * use link up to wake up app to get ready for
> 			 * authentication.
> 			 */
> -			if (ha->flags.edif_enabled &&
> -			    !(vha->e_dbell.db_flags & EDB_ACTIVE))
> +			if (ha->flags.edif_enabled && DBELL_INACTIVE(vha))
> 				qla2x00_post_aen_work(vha, FCH_EVT_LINKUP,
> 						      ha->link_data_rate);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 9d4ad1d2b00a..ed604f2185bf 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -3034,8 +3034,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int el=
s_opcode,
> 	elsio->u.els_plogi.els_cmd =3D els_opcode;
> 	elsio->u.els_plogi.els_plogi_pyld->opcode =3D els_opcode;
>=20
> -	if (els_opcode =3D=3D ELS_DCMD_PLOGI && vha->hw->flags.edif_enabled &&
> -	    vha->e_dbell.db_flags & EDB_ACTIVE) {
> +	if (els_opcode =3D=3D ELS_DCMD_PLOGI && DBELL_ACTIVE(vha)) {
> 		struct fc_els_flogi *p =3D ptr;
>=20
> 		p->fl_csp.sp_features |=3D cpu_to_be16(FC_SP_FT_SEC);
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index edc34e69d75b..031233729ff4 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4817,7 +4817,7 @@ static int qlt_handle_login(struct scsi_qla_host *v=
ha,
> 	}
>=20
> 	if (vha->hw->flags.edif_enabled) {
> -		if (!(vha->e_dbell.db_flags & EDB_ACTIVE)) {
> +		if (DBELL_INACTIVE(vha)) {
> 			ql_dbg(ql_dbg_disc, vha, 0xffff,
> 			       "%s %d Term INOT due to app not started lid=3D%d, NportID %06X =
",
> 			       __func__, __LINE__, loop_id, port_id.b24);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

