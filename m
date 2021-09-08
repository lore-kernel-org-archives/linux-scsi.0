Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E462C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 13:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D7861166
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 13:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349509AbhIHNqN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 09:46:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23902 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235682AbhIHNqM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 09:46:12 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188APNNh012550;
        Wed, 8 Sep 2021 13:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iq3BMqHK9UBOnlLLmp0A2FjpvjdND5whqdMFTOR3s1E=;
 b=xNv0vkYxj1L+/Akc8Vt7g87l2HsJvYUX1BPaJqzvEK/1KmOVxXIZAkinY2+9OmVzF9sA
 2C/HB6ZEhJ2K5zJuj5ZrqJdNgWy3UcjqJ6BouJXbEHFLdZara1h4+F3mAJH5a8j64rjR
 bIZk72YeLgwoaBTEHgL+bSG3ZmdHnHo0ZfH3xYNPcmiMermZPr7XzyeO37Cod2+aGdJe
 r65JhGkxmfUdTdzcGjouY+FOOiNU5PLa6U2zDoWheEmhsPIimIxX0xeUb5xbU/Rrc4FN
 h0fDa8DVD5r3NAB7gXl9gZuYL+YlsMW+O/ZZIQWganrpvHwOtT8aH6tKetcQdnnOHF0b /A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iq3BMqHK9UBOnlLLmp0A2FjpvjdND5whqdMFTOR3s1E=;
 b=FETEaWf1bF9oDOKLlErR3wtXkT5Xjk3kSSM4BYQE9tzGSAXqooZ0uAMzgx8pe6DbHQie
 vESNIcP6z3+wQBt0/p9n0yAjtFhwIQcXjKqE9ylKKjGopfh7NkAvDKs3JAR0bPsB6Fj1
 kldXXN8S9qq9DbSqtwyb68WHn7O0INsECj7Zq9X+m3repMgMCyDSQtngASzjEfrY5gAg
 VFhR5HIrMz6KwCoXauTDWd4NYWyAa1bIDXQbbkg6XkGspj9GJ1XnedVLqYBUsMkkZV/Y
 uIryi549Tr48QDj2BliSZ1z95DVkPj0kgbbnyZiCRIZFpkZiwkrgSQl8m6YmubcX1Fla Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcs1aq8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 13:44:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188DeDYn189344;
        Wed, 8 Sep 2021 13:44:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3030.oracle.com with ESMTP id 3axcpnrsrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 13:44:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Axh4Fzm8yN2A2c8AefmjLZwDkWWAlPvlMNYvHgCjV4CjgnqVf3SLwbv5ceAX22rPu1nx8TGq3c0qCTZmPalZQyjKkoxWMVU6mUPEgOMJxGtrhwUKExes0dwZXUePdta0nstElqRtNKUvz5kfda0X1MBTvEQTlOP+3urh/C4d3a4yiArmTdY+cw1v7eV5RJpBWlEE6bBtDbVAbU0tdxdXcCA/g4enYaf+WsKu2f5Nl1AvVl4ESX0LJ2vVJJZ0u1F27YENZGhZQIxc8CWpXDg2Ea2MAXkL46WfthFdZK0GjtHKXR3Yf1txDLTJvDpT3wQEo+ArJkDNCniS4Abm+m3agw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iq3BMqHK9UBOnlLLmp0A2FjpvjdND5whqdMFTOR3s1E=;
 b=JZ3mSWhUI31p9IxyJ/h7d9zUoZz8bwnRrznabcWjgWxWjhf0A1TYhTL+WaFvroY3TAKShgbmXneXVabSztqqp0V7/7CiYe0ESlMF5oAp7GMZdS8ye9y9jVtVIHPpO2/3SXWWWI+d74O0WoaZgkcSprzxtWs7BTXGpLJcHRGtQGsUS3QfNV3BGIEqtQ2jvcZhHh1NLpjUs8T9AvMj9lpUW2ijdUw96vBXZDyX5En9FaOD5iDc9BVGk7OEYhK9A3f6GtDuU+2Ce1P5opXokPrQUkaI/+J2rm9B9VV89oaOkCSsHqMLYrHra+IG6tPRI6yYLjJEsedXCZs4fOjnl9qXbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iq3BMqHK9UBOnlLLmp0A2FjpvjdND5whqdMFTOR3s1E=;
 b=iYiPC5+agxRNt/RLEfih/Scdq2ZAjPmvOCLlTHl1iP0UOXJrLHf2Uosjz8U7B5G6Ahis8FWMz5xJYsHdsy4jzKV0zWqyHyR8Do3InLlfAGLdl+2QZngRLCX1GPw7tCnz3hjN2Z48N+bON+oXg0xi69VrLLCcIRsfG5+C2u8hgyo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2558.namprd10.prod.outlook.com (2603:10b6:805:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 13:44:40 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 13:44:40 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 01/10] qla2xxx: Add support for mailbox passthru
Thread-Topic: [PATCH 01/10] qla2xxx: Add support for mailbox passthru
Thread-Index: AQHXpINqQ648tiimbUql28f3CteLsKuaJk+A
Date:   Wed, 8 Sep 2021 13:44:40 +0000
Message-ID: <46958089-7367-4AE5-B37D-FF7BA07A4F52@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-2-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5f9e1c3-60d4-4045-6dcf-08d972cece7e
x-ms-traffictypediagnostic: SN6PR10MB2558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2558EFD3FBE20BFEF357D01DE6D49@SN6PR10MB2558.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:250;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mHhe/ndlP6M1G0AiqsTPPH+bjFaxk5pZPC8trpHWGSmCst3oawGgWb55pfZsR0tv+gc04UuFzNkMs5xz5f7/N/wxpDCCx4Hlt19WWG+Dcrf3LwDcuFyM50n9jPMCVxXDr9AAN5s6eh2Yu6jJ+mQ77C0pME+woaK5+KWaFT3KUlNAXaFTD/PzDNfZ4OpJ3bB+9EJ/sAtyyQEFDTWeWsYzh/SGhaJcvdu1XkpJh9LhDOg7RpTVsSrP10FLFtWvJsXWMR0UToJmkxaqR1OqV8zwk0NwOTUlsPtUPnkrDXQHGCIfngHbN/Kgqu4nRplNiBfAHwBZMcMxXJw2uUI2JaMlMQ0rWYfiPV4ttCMYpKAGrtPe2YK5mLTU9y/k6Cdzmi5KG4Aa04OsOxTlHsv/vYq0vX/Bn2triBvhmZhvi0hzxNm/3eD6CoS3g3BJKkr51Hlu8fBw0MCNBamC/FjFAYRIlE/Se2Q6qXkvrKjj5d2zzo+OtHd36QG9goABTl9kEEC92/RjQPiH66qCBTv7tZzclCr59dtkwQ4e6jhsIuxBd2WReTWjUgT1+W5/r/4ajil5Xp8ZAHCNE3xfvRHCGCmmsmy/zS7jc848wvT9VCEIGnvoAKQ0CX1Y3tafu+0uVCpOpv4f2XyZCRSkYEivIAQRY+sx6PunXjL/9DevfP7EIOYsqoDY8qppEdBHequhizUFT8K4AlArr2/LT6OscbEcZOj6MaOlRbHspxKndLX76vFLy+z5seNSbjmPEmoYPjFw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(15650500001)(6916009)(86362001)(76116006)(38100700002)(186003)(54906003)(36756003)(33656002)(8936002)(8676002)(2616005)(6512007)(316002)(66946007)(478600001)(44832011)(2906002)(64756008)(122000001)(4326008)(66476007)(6506007)(66446008)(38070700005)(53546011)(83380400001)(6486002)(5660300002)(26005)(71200400001)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2Ym3hz9FFP8cZNVLtz+5xeEkwv2bN+AwCKn2yUYyLjv2adDkWKvcDR3xGksq?=
 =?us-ascii?Q?ykUjAveYXpGUfd79R9SewEjIm/V+AD6Pq9kMRYRurjNxrmu5WMSKFs4725/g?=
 =?us-ascii?Q?xRoFJ+v2ph8QhxU3A58j8GLrcIFme9FJbd7kuoUuSsDtRNr76uDHn8XwZaHA?=
 =?us-ascii?Q?w1uUlKR5yh8sPU9pjAEu03Dpt6My4xC3avqLgqsx5tunHkVuYFj9HzETrmNL?=
 =?us-ascii?Q?ESK5CeRwsdUhmyCPeZ4R3vIRBKy5jjPbHGkXJH2sp3ulc7EDflooWHmUTi2l?=
 =?us-ascii?Q?CYgqQf1iU360Kr9wUdtrniKmVu4vcEfO+5q7XGGnodrNGsxdSX8Cf5qj194q?=
 =?us-ascii?Q?6UIBJs/Ecj3oV3Ot0MqILrXy1HUgQW6lpkxBl+uzaYILhQCyEARgpg2gAayh?=
 =?us-ascii?Q?a7khU0hCiLv75EPf/nngMHZ+EuUCyLYO8Pbkg590RSBUo8ZkiwDnCGuKuhar?=
 =?us-ascii?Q?/rcrF8PI69PqHUJaUxP1GbDh3P0Xnx6R/n30rghGOXyVFa5q2ajb9Q5zJeen?=
 =?us-ascii?Q?T/i6f9lm4i6A0hvQ5GVOUWK77wACnAC58ZPm0etZfJNUKowTR2l9t7KIgTxX?=
 =?us-ascii?Q?A3I2rR3osYKZbVdlRVuaU8AIqRA+5sS9Q1UufB2Nu/Jyp9W5ydyxqt+Sa7vK?=
 =?us-ascii?Q?UCbrIhpY6S8CngaCVUCUIFRiit8RshY9Ph2aUcH4tdYINmaCDn9bNplpSt8L?=
 =?us-ascii?Q?ytwMZf3kh/x5mZ6IEFC62G5wns7jbHa6LSaWn5ln2MI66wfwiK2ae1/5nHye?=
 =?us-ascii?Q?0vhVn2miBfztdY0B738A3HP9l6gIGcUTTve9VdddnXSUz2OJzXKtUXYVRmr3?=
 =?us-ascii?Q?xgKmAEgY77WuoKKQfeKhOvhrB7yB5ITSHY8FK8LX/4sIghPTpmK2FoXJV6+L?=
 =?us-ascii?Q?DS6Hod8HVSNTtdpfDs9ezwBJ2gwhvuq74dNF3jzbJ3NPl7zBQvjX9Y9um1KT?=
 =?us-ascii?Q?kooUCOnteIwXbBNuFfmEJCOpnuG5zR7DJyMM4fGmgbrYflk7m8jtFuN8E9T1?=
 =?us-ascii?Q?cWsTlWpcNQDHZqprmCLtwOw2ybYRut8yclt+yhwBCIqiF4QT2sB+KH+LYfYB?=
 =?us-ascii?Q?5+55y8zv/fz0YjPrK/xdgLAFA3Dc2Ryhm8D2flq1WZWVPp6kuO+Hjyrk/u/M?=
 =?us-ascii?Q?iqKzeXPIXldrPpC2mXc0+r1ZABfALARiSAX5500NvFQq0W3BPnpY6ePeAWrZ?=
 =?us-ascii?Q?5+2bor+Mwq2/wRoJ31Z3Wv91SZO5NzsYWubgZw/sichQqoWGFbGxEv03R428?=
 =?us-ascii?Q?TUZqjfLsH/GVOkq2PAqcDNfrUsi7AtjUAkk8sux+xQpORabj5TanixN2zNUd?=
 =?us-ascii?Q?HJ3MyEjSKdZ64P/M6i3TaAlalYW3vHo/ZiPBEa1b+JbfMw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA2667BF4AA84F4CA24F449BED1E7A9E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f9e1c3-60d4-4045-6dcf-08d972cece7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 13:44:40.1688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jG0X4+vz2y9ui3gBwkmSf8muIvUos+UvVqy0nVgf10AFL79e/QezqPDEmIPoVf8EoWDMInf053R08PYXyMXO5gYgf1AZ3HY0jHGkY549Cmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2558
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080087
X-Proofpoint-ORIG-GUID: 0pMfr-YIgzdAKLdtNPPYPFp8IkU_YCQo
X-Proofpoint-GUID: 0pMfr-YIgzdAKLdtNPPYPFp8IkU_YCQo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 8, 2021, at 2:28 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Bikash Hazarika <bhazarika@marvell.com>
>=20
> This interface will allow user space application(s) to send a mailbox
> command to the FW.
>=20
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 48 ++++++++++++++++++++++++++++++++++
> drivers/scsi/qla2xxx/qla_bsg.h |  7 +++++
> drivers/scsi/qla2xxx/qla_gbl.h |  4 +++
> drivers/scsi/qla2xxx/qla_mbx.c | 33 +++++++++++++++++++++++
> 4 files changed, 92 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 4b5d28d89d69..0c33fb0de21a 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2877,6 +2877,9 @@ qla2x00_process_vendor_specific(struct scsi_qla_hos=
t *vha, struct bsg_job *bsg_j
> 	case QL_VND_MANAGE_HOST_PORT:
> 		return qla2x00_manage_host_port(bsg_job);
>=20
> +	case QL_VND_MBX_PASSTHRU:
> +		return qla2x00_mailbox_passthru(bsg_job);
> +
> 	default:
> 		return -ENOSYS;
> 	}
> @@ -3013,3 +3016,48 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
> 	sp->free(sp);
> 	return 0;
> }
> +
> +int qla2x00_mailbox_passthru(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	scsi_qla_host_t *vha =3D shost_priv(fc_bsg_to_shost(bsg_job));
> +	int ret =3D -EINVAL;
> +	int ptsize =3D sizeof(struct qla_mbx_passthru);
> +	struct qla_mbx_passthru *req_data =3D NULL;
> +	uint32_t req_data_len;
> +
> +	req_data_len =3D bsg_job->request_payload.payload_len;
> +	if (req_data_len !=3D ptsize) {
> +		ql_log(ql_log_warn, vha, 0xf0a3, "req_data_len invalid.\n");
> +		return -EIO;
> +	}
> +	req_data =3D kzalloc(ptsize, GFP_KERNEL);
> +	if (!req_data) {
> +		ql_log(ql_log_warn, vha, 0xf0a4,
> +		       "req_data memory allocation failure.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Copy the request buffer in req_data */
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +			  bsg_job->request_payload.sg_cnt, req_data, ptsize);
> +	ret =3D qla_mailbox_passthru(vha, req_data->mbx_in, req_data->mbx_out);
> +
> +	/* Copy the req_data in  request buffer */
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +			    bsg_job->reply_payload.sg_cnt, req_data, ptsize);
> +
> +	bsg_reply->reply_payload_rcv_len =3D ptsize;
> +	if (ret =3D=3D QLA_SUCCESS)
> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D EXT_STATUS_OK;
> +	else
> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D EXT_STATUS_ERR;
> +
> +	bsg_job->reply_len =3D sizeof(*bsg_job->reply);
> +	bsg_reply->result =3D DID_OK << 16;
> +	bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_l=
en);
> +
> +	kfree(req_data);
> +
> +	return ret;
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bs=
g.h
> index dd793cf8bc1e..0f8a4c7e52a2 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -36,6 +36,7 @@
> #define QL_VND_GET_HOST_STATS		0x24
> #define QL_VND_GET_TGT_STATS		0x25
> #define QL_VND_MANAGE_HOST_PORT		0x26
> +#define QL_VND_MBX_PASSTHRU		0x2B
>=20
> /* BSG Vendor specific subcode returns */
> #define EXT_STATUS_OK			0
> @@ -187,6 +188,12 @@ struct qla_port_param {
> 	uint16_t speed;
> } __attribute__ ((packed));
>=20
> +struct qla_mbx_passthru {
> +	uint16_t reserved1[2];
> +	uint16_t mbx_in[32];
> +	uint16_t mbx_out[32];
> +	uint32_t reserved2[16];
> +} __packed;
>=20
> /* FRU VPD */
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 1c3f055d41b8..8aadcdeca6cb 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -662,9 +662,13 @@ extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, =
char *, char *, size_t);
>=20
> extern void qla2xxx_flash_npiv_conf(scsi_qla_host_t *);
> extern int qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *);
> +extern int qla2x00_mailbox_passthru(struct bsg_job *bsg_job);
> int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha, void **pkt,
> 	struct rsp_que **rsp, u8 *buf, u32 buf_len);
>=20
> +int qla_mailbox_passthru(scsi_qla_host_t *vha, uint16_t *mbx_in,
> +			 uint16_t *mbx_out);
> +
> /*
>  * Global Function Prototypes in qla_dbg.c source file.
>  */
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 7811c4952035..9eb41dd39043 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -7011,3 +7011,36 @@ void qla_no_op_mb(struct scsi_qla_host *vha)
> 			"Failed %s %x\n", __func__, rval);
> 	}
> }
> +
> +int qla_mailbox_passthru(scsi_qla_host_t *vha,
> +			 uint16_t *mbx_in, uint16_t *mbx_out)
> +{
> +	mbx_cmd_t mc;
> +	mbx_cmd_t *mcp =3D &mc;
> +	int rval =3D -EINVAL;
> +
> +	memset(&mc, 0, sizeof(mc));
> +	/* Receiving all 32 register's contents */
> +	memcpy(&mcp->mb, (char *)mbx_in, (32 * sizeof(uint16_t)));
> +
> +	mcp->out_mb =3D 0xFFFFFFFF;
> +	mcp->in_mb =3D 0xFFFFFFFF;
> +
> +	mcp->tov =3D MBX_TOV_SECONDS;
> +	mcp->flags =3D 0;
> +	mcp->bufp =3D NULL;
> +
> +	rval =3D qla2x00_mailbox_command(vha, mcp);
> +
> +	if (rval !=3D QLA_SUCCESS) {
> +		ql_dbg(ql_dbg_mbx, vha, 0xf0a2,
> +			"Failed=3D%x mb[0]=3D%x.\n", rval, mcp->mb[0]);
> +	} else {
> +		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0xf0a3, "Done %s.\n",
> +		       __func__);
> +		/* passing all 32 register's contents */
> +		memcpy(mbx_out, &mcp->mb, 32 * sizeof(uint16_t));
> +	}
> +
> +	return rval;
> +}
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

