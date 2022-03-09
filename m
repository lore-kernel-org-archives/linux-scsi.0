Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD570C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 18:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiCISbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiCISbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 13:31:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8914148668
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 10:30:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229GHlL9021312;
        Wed, 9 Mar 2022 18:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eyqs7qTPuObocJxrJQn7R4yNhEDkXnRCsIk8c/cYcG4=;
 b=tsjct+SuFLuADdWi57Mc3jYAsuafES5moVvLi5Xp6UUJqu2bJgCM8rG6hp6nC2MUuKCv
 Ze1HWGePQDc2r9V1fkIdBqbHeP6Czy/n9trgCJnGAv4ANPU9tltwtC7kzJ8eCtQNrl9g
 x4/NDN7VZq0TDicTmjQ2eTIu/t9lGE3YoNj5KVoo12Ws5X7g/BMMRnlsDFAmt7vuqDCX
 26EMmetBv086C+FGxTzcKDJ6eL5PitgDG8qrThf8ND6lljlacIchrtiOTIOhbvxGER9K
 PpEwnNfvTRcguv91kiW7w97fSEy9Jv+T3RQFgzDFozZoAP5f+2OmJtC1nbTguYU68JQ9 Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsk3ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:30:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229IBtQu108918;
        Wed, 9 Mar 2022 18:30:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3030.oracle.com with ESMTP id 3ekwwcyawu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:30:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWWzU17R9Dx0i9T5rdnArmnZzHtIsC22QOPy98W2nbFz35TWNQZh7UKt1JYjV2Y7VjIrVNiGoO+Eq3ThLuVCFMOOv+wiEB6fRB0cbIMUe99bNoOytIESIjlp4ZZ836aTQZu+229m//KAgee5xTq7OLpZh4pfbLHAMdnQVqyNi1b0dlSEMf8lsKiJfKjkG/IYJy/a9Ic1xFJe0T5MB27VNwuRh8f4zJJNOytb1XgSYQsaXlYim6Tu8fsEgM+kxwhgiD1UsazY89lpHN2cc3MD7Cqv2wygdHVjHa2YWs0U2ZlRC7eeBzRrYPTxLNfDCR6c7qQ6OMk6KKdcXDVvVuH+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyqs7qTPuObocJxrJQn7R4yNhEDkXnRCsIk8c/cYcG4=;
 b=P6WEYA8zPf6CKAaSYBGNJNwduzrhP+Ppady0u3x53sLTPOhYak3u2pOS+i47Gw9xawQ9kZb7CYIG9/bTiVepQil9m/6KUHMdhEtJAC+ckE7Vx6QruoJLdUlzX97OoMzv6w5EXX3XhELZq3s9j85asw1aGFSUJgLfA1EYL8eI/4Nh6OTUeAA/gnF7Jf80PAwX1IX02Ek8cK4gyFOphviqyM2p6XeHTDCcAIwWzx1c8IKjyqdMrrVJSKKitJAK/RHDtPqVKRiqaXl/rwRS3YyxekwNCELHb+SgdaHWqMuZHafKGovkUg1zAoIPy3pDpNYQVfd89dxQRnrfR4eAet+bRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyqs7qTPuObocJxrJQn7R4yNhEDkXnRCsIk8c/cYcG4=;
 b=RQwcCNxqtHuCLRf8R4FJs6A+7JwqQec9CqDUOLu62VtrpJGSLEZTGgB7RQsTpkFvC2i32kqvWhH8slW2BAuB72MGgBD2XdJjpiwjPsvf3PJiRrfPFd1keYfZgeuXr8upELjuU1jRyeVhF27zjEaXBeS+aA7CdM3sMXU8zrESz/I=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR10MB1748.namprd10.prod.outlook.com (2603:10b6:405:9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 18:30:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:30:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 01/13] qla2xxx: Fix incorrect reporting of task management
 failure
Thread-Topic: [PATCH 01/13] qla2xxx: Fix incorrect reporting of task
 management failure
Thread-Index: AQHYMsWC9BaY5lygxUuxB928ptGGfqy3YfIA
Date:   Wed, 9 Mar 2022 18:30:27 +0000
Message-ID: <4E002274-30DB-47F0-96DD-B3AD3151FA9E@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-2-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a9a6f8a-659a-4db4-643f-08da01fae240
x-ms-traffictypediagnostic: BN6PR10MB1748:EE_
x-microsoft-antispam-prvs: <BN6PR10MB1748BB25A85D8B82C393C157E60A9@BN6PR10MB1748.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6q2PPtYgEh4YvTSzHDRS3JXjSf8FaJGpochinw5nnKdsMELDYwT30GpVWsP3ikVG81n/GrFRp9bbR2L2w2SRUetZp31n+24aQbgGwZagINuU68AujednYm975RW8SctNL0in9l+CBeuFx5lGA1lCeQJDmWSEdc17cYkrdz0MbA+12nbyJQKk5vb4LI53e7nmgzAJ/Nl++yD6Bm7DfEV31J9o6+8F8Ib+zva5HsxcUF0S1lp3TmrtbHeZNvltDi5KQscV4otFBHuC03HVJx8yv343OzjkDwzXIQ1sUGsFTBqA0rcOFaW84dcq6WOf9NXAG9HUlRvTKV4Mr1AL2fhYXeQldRYxOJvNy7+rOQYoQxndQL6+gKvuOrYiA9PHXVqoMdQToIcfX5HqNOD5o2bbQGYubU1co+rVBx3n2gkZPpbC2AsFa0TA7Kn0UeSXs73fGaRvJAuMfX1a/up6yI2MGCAa4iMbIIpk3jiEh4ZNTJylBUygBrmNzXmo43TZUpxuUOLaVPoyNPsq3feIS5QJwzUgEwKKnuVlRcOhaATipY9szREBbTMK1qxgwL8esKM7K8KQOoTt7Xb42XJVHEDwqR5gay2C+pbNZa8N2f+/VTfkb1vaiz8pYMCa7xJy1jEoKWc62OF41zP2wHiz9AwhGkuteVHzQw8FtANFT9jWiXCRXWVXTIdn9k8Yf4e2fF7VkMB1AxebWkMRzJCd77ysf7+5P1zvWJ8HVdZv7pEZ9rlvNxGERi20U1XDzcDaLIa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66476007)(66556008)(36756003)(38070700005)(71200400001)(76116006)(5660300002)(2906002)(26005)(6486002)(122000001)(38100700002)(66946007)(86362001)(6512007)(64756008)(508600001)(2616005)(186003)(4326008)(33656002)(8936002)(53546011)(54906003)(6506007)(316002)(8676002)(91956017)(44832011)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lW8DAEji0hbk5c8d0X3UorAYVb3qfYXoZ1i60DTITcLMuwbQJBxOjIMnr6dh?=
 =?us-ascii?Q?x3dR2SvGyjJ8VnZu7Z+4qGFVKxEX2iIRy9EvhFCqgjqzKNIaCPhpKdfqXndu?=
 =?us-ascii?Q?YnU458kPwQKcKk+XC0F26rzBIiqV8Z8ERcSWmj3dHmkAlj5l/e7+TP/m0GWA?=
 =?us-ascii?Q?UTcymGSBrcNjub4mARafCEqbqyiGQW1umpQF5SLqBlqxlLRtTYIIjAK4ErDd?=
 =?us-ascii?Q?8ANoEb/VeyqPUiwTkWbWr7IKK/U02JNARGD5DbOG/Vp5RqPS4PSnh/Dddwdg?=
 =?us-ascii?Q?HB/uGNBEYpzXJJ349kwLdDGs2PBXDBkN7fHUZ8n6nIiMSlpIbCUIvUbQYzR3?=
 =?us-ascii?Q?OA7zxzlq7JVQZ/5ZNyS9aQNLqqceii+ekSsPhA/SDhK1g3ZTquMM4U12htuO?=
 =?us-ascii?Q?ByhfI5NiuvHSUkXqO7dG46cMGsZ1bG+hMuh5OYlE9WXPX3/2oB0n139BcdIE?=
 =?us-ascii?Q?TGWzlh+sWegUzyXgbnwjU3GgTudsh2gV6tZKcnC4xRsB9l7LbFAxbx3zDkVH?=
 =?us-ascii?Q?3ZDuUcM3Ih0XiMb6dEK+tP+EnOEQF7H51Kg+d4qwvDWmi6G1UIS5imcUpMN0?=
 =?us-ascii?Q?LJxzx9jT0ern75F0bEcmqg6o1ZDXP+ymVgU46KeiCSkHiYEgBF51oAjiPfRo?=
 =?us-ascii?Q?MiIT5WH3EDkm6pguXITq+vVGNfLD5bfG7DGQ6mLjyU96/2KMxCbVyPYf9lac?=
 =?us-ascii?Q?CIb5ggrS+lAEWOhm8kwDlFq6v4AslXn5R/uPfwQ5VhCcwI7hc4bf7jMPvJ1Z?=
 =?us-ascii?Q?xeJxv2/zVwM5ozrTO2vOOvmudTxJStvsdb4cdwuClzSXjZJZApdjGBXZQ2fy?=
 =?us-ascii?Q?n8oq3b8ZqZEwL2q7QS48AZJG/rdAXvgC0OuFpD1XFN6Tr3YUkRfST2YUE3f6?=
 =?us-ascii?Q?Z2214QjLQgTd0bqwSQ/O5oRse9RrI+xEgqTJuuCTSChXtR9GtIKbzebX0tuv?=
 =?us-ascii?Q?QzFgL2b6E4Nx0deRuDhFYd7AZidvJCwuL9CZWRKZHdLoY3TMZrX1LOUqsM4R?=
 =?us-ascii?Q?gLrljIdSagsA3r1fyooJXjMp0ogxEYn42gcpAiScXg2OC3Yc5EwFvEY0ECtn?=
 =?us-ascii?Q?N3DDbGD++aEd5xSEg1cv76iZMo5LekobDIhoLAv0hMY/FIxPeLxcF/0WX/jZ?=
 =?us-ascii?Q?Z46de/FZ6O+KqM73qWDZ+eQbkepspJvJ3TJD0H1YpsUcWr61xBlFgEKRjcbZ?=
 =?us-ascii?Q?BsBG5lOeYpF8a/LGj+GFtNX2nbyGYnXnCfElnHWM8kiObwjknx52Dog+B28D?=
 =?us-ascii?Q?nLap30hzMMYtgca6amW8mJhCZ11++BpphSF2MjqFBDffLrBeSvkhPCg5Wn7w?=
 =?us-ascii?Q?lBmgta/hVetGh4mtiw1DNHNJvcft469Ob2LeHX3h9DDUltj71Fr0OeNktAzs?=
 =?us-ascii?Q?t8UX7U3F+DTvQ8YKQInnuriFIHyd6/A8DwCKiW3crDxLYJ0n4odsiddhe120?=
 =?us-ascii?Q?Gh9cTMD5V8jrx0oZdD+4Wu/lCb5Xta3A+RB9iXwINj8Q/iVVtpFJUy76aonj?=
 =?us-ascii?Q?g+am5jX3TnVFWww=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <83BF7B5D63A2AB448DFF6F57BC4E1CEA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9a6f8a-659a-4db4-643f-08da01fae240
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:30:27.4887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yop3bU5bBQWOOfTqJjqT7A7aJzaXZTyHlsufWxEzACSIv7wV2culIi4CKyWTbOQTlGWjvIbNjKHu+Il7W9VeJ8IL0+pI9OdU1ul4Re4PZAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090100
X-Proofpoint-GUID: qXyL_U3IdqUDRBujkrzW0t10lrEIsnow
X-Proofpoint-ORIG-GUID: qXyL_U3IdqUDRBujkrzW0t10lrEIsnow
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> User experienced no task management error while target device
> is responding with error. The RSP_CODE field in the status
> iocb is in little endian. Driver assumes it's big endian,
> where it picked up erroneous data.
>=20
> Convert the data back to big endian as is on the wire,
> where current code will pick up correct status.
>=20
> Cc: stable@vger.kernel.org
> Fixes: faef62d13463 ("[SCSI] qla2xxx: Fix Task Management command asynchr=
onous handling")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index aaf6504570fd..198b782d7790 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2498,6 +2498,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct =
req_que *req, void *tsk)
> 		iocb->u.tmf.data =3D QLA_FUNCTION_FAILED;
> 	} else if ((le16_to_cpu(sts->scsi_status) &
> 	    SS_RESPONSE_INFO_LEN_VALID)) {
> +		host_to_fcp_swap(sts->data, sizeof(sts->data));
> 		if (le32_to_cpu(sts->rsp_data_len) < 4) {
> 			ql_log(ql_log_warn, fcport->vha, 0x503b,
> 			    "Async-%s error - hdl=3D%x not enough response(%d).\n",
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

