Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981D8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiBISDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiBISDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:03:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6358C0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:03:39 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HMCsJ013393;
        Wed, 9 Feb 2022 18:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8zgkyaMqfrFLf7ibCZmByHGtud2Isi9e3Nn5t23Sso0=;
 b=sVuoFanh3gNV6U4OZipNkG4WTTl+SAPcf3agi9FOZ3Wx3aYWB33zTIcIRoqpqNyD5694
 cA28s1tPgCbqtG2rrFpUMxCttFU8HdwjVPpVCbX+Dev/K7kxt0oIZWl+H/lbcu0eYlnM
 oKKoVziNLl5WgvxYGWU4i5ZiCoxO5aXBQ7KzL5fKnWATYg0XOrER3riDqdMNkQxXo4TX
 UTnA6Q0OrBCKLlQ7BrXE6zkUirW0/x26hSC+oUnkVXIhQH5zPJfG0ag1bng/uUhzqapg
 xSjXMnX+982h6tHLV7pG+VW00lOLgxYjjg1ecKEc8ve8SE6QOSrIITIx1uv5PwfFwCey Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txk5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:03:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I1r9a018840;
        Wed, 9 Feb 2022 18:03:28 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by userp3030.oracle.com with ESMTP id 3e1ec33m4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:03:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIMbJ5ZtoNLJ3eYjEMWHMYwsv555+b7ENpyOdTew42w+Oc3NycyhrVIddb7R2lWAUO+zWMGEqScBEwdirf3q34TgHv4heTT4KqAaqRudWIYEFdShwI6qBG1R44g0ZC8GsP0XApcjrX1rWZJR2wR5ogTVgIOGa51B4O+KqWJ7j22WOqiOL38J5Q6RWK7coGOLKz2a/XtyLNNxa4EC4DOtq8szLANwo4A2cONtbetiZNLIk92jFKJPR7zV14TWOMFuoqHEOiMX9njHG/YXL7apMdDlvOFhAFNXPpU22xy+Tr4IH404pG6FM/lS+rqHoLTPG3F6YZ/nbMzDRLmK9IMALw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zgkyaMqfrFLf7ibCZmByHGtud2Isi9e3Nn5t23Sso0=;
 b=VktqXzS03b/gsvMSuR+mbAcg2vvlTuHjyaTdZDdTjA4yYJ2JT7+tWixGJiiWm4xggA3lsRIKFtuDhr5ahmHOtZxxO/otgZPp2/Sl8CPwSuGiDo0k95ko45w15KNVaEg1lGKpk9vuv7gpK5BIfO2omGFPNHTq2FpBI2hNaJ/mgdPE+qCegpVwXELlnlf1xNmvOv8NTKlIfUiPq81GqT7UCh2eCYROYdGtv4b6r1vGQTinFiUy432o+4ptblgUwpQlBoa8KmtplGcuKIv0CY+j4kyeRvzDfAmkZckhCQLh7Is2uLuNkS4HRU5I+pslbrJKtz+lVMAjqds5ZNBTBj2TrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zgkyaMqfrFLf7ibCZmByHGtud2Isi9e3Nn5t23Sso0=;
 b=gZavbz7mJNlUMlLUE7Ji80706dWm43X7YW2YuZx39dIUR/Iy0X4SGVNRS6PbD6ZCLf0zIPDCzTfOlMzLXAUu6a9CTpKRWim7EZRBOsi8YGwTGLDECxCmv0MJD67KCpezjmMvRXTux7B+6qvvuoYwdGYenKizdbPqqIWoFQdU6kY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1289.namprd10.prod.outlook.com (2603:10b6:3:b::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Wed, 9 Feb 2022 18:03:26 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:03:26 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH v2 14/44] csio: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 14/44] csio: Stop using the SCSI pointer
Thread-Index: AQHYHREfV+lyBeTvbUiDrdF19AjLVqyLhIkA
Date:   Wed, 9 Feb 2022 18:03:26 +0000
Message-ID: <1E833EA3-323F-4309-B057-21F56C89EB26@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-15-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-15-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82c3f712-2c0e-4728-872d-08d9ebf678b6
x-ms-traffictypediagnostic: DM5PR10MB1289:EE_
x-microsoft-antispam-prvs: <DM5PR10MB1289C8288316F4C4C1EF5516E62E9@DM5PR10MB1289.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: piazFXrkJ5COynYjgIivlQOjnFoNGEAAJl5bJHupcipHw58vuZ8C1TqKZXaJlDgVXtezMiKR/S7EWeB9sMamUGg8W/1OdLaS4QAr07yWk0pUssV16DF4WpeGZJ7kDU1m35WKY+2EJv/O0cbZCgXQC5jBX//hihjR0Yjv8r7OCJpvK0JYRmveo/MYTqJIV8OaROeoWmkeiuz7FjxtJRgKhUl4edCKkE/5dB1mwwOCWwRzY2rf2AnB/Npm7wcb+PMKCvRjSPudCMBE+exiOp7SZXnwQVcAkiE9/FPEREEFzpQ4Ll1NEgr5HhKAy//XBJhlowClo57ydBWySYffOnyzw7nNyQbX3pJOH3No/qby1Q9Yjv0y3a7UUO5U3sZv89ONtJoUU2+9Yiov7zsiPh7do5jjy3f8DwLFBg7H+C7Kpa8BkwS3vuDM7f49ipzLBbbbh33/FwPhGAd+sturPG1Q8sCLEJvpxcFSlzgF/g74cnVGo+n4miWGdTs3aOnz2gje1CX6m6QBfjt+vx0dZ+zMoCzSWnIu0rbIfZjDMQhi1vJKWs+WPRLNdT0back5qcF8rCkptNDLEvSBp32Ofs3XQg4zcS4lPdbh0pnqooMAf3tyfmT3h6/zHy1xaE/TCX29rhL4QdWh1p7IswAs30dlgvDux8BB0lWIFCdeJCi4bRGY0GCs03U198kQw72UUhaDo0KWoy1EZNAmG5Kv+eBDm3YWYJeFkGHhzPQcqhslzDHZzO0HCkgNxc4aIdR+L35e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6512007)(36756003)(316002)(508600001)(71200400001)(6916009)(33656002)(38100700002)(2906002)(66476007)(66556008)(8676002)(2616005)(38070700005)(66946007)(122000001)(66446008)(8936002)(4326008)(91956017)(5660300002)(6486002)(53546011)(86362001)(64756008)(76116006)(186003)(83380400001)(6506007)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HXSoeHhFwo069iei7UCFvR9OVFxTKLO5nNQpMCNP7HXPSW0zbJoPZ7PwPT4k?=
 =?us-ascii?Q?kB7JTDGPfTyftX6I2O2PJqSfwIqTs2eCfVJqiuLWD99u24nBFkeMemZaE7FM?=
 =?us-ascii?Q?Z7C1HWcE8CAJKcblsJkWkKra3wgLknQK9Ptrf84Y7pOGoS2bQUH9zHB5lgu0?=
 =?us-ascii?Q?78jx0fPQMKRhCUvVOyUc1OaoTC5W5r4lq1di6A13BSqICaZez/N06AaO161e?=
 =?us-ascii?Q?7b4Vbg/hE0UNniZL58hEVp6sfdhD6VXJ7QpVjWRN0nXiUU/zXvRmf9AsTnDH?=
 =?us-ascii?Q?vZAsGIAZo7v6B5dS3i8uCYQ5y1gDWey9RnCNywYGMIkOxSGmwkShJYx63ipR?=
 =?us-ascii?Q?U2vvpvQyIT5rFmMUdzepnWDmujX6lKTJN9x/3i+B11uQs1sL6ZXBzMeeEP7I?=
 =?us-ascii?Q?lyUtHPsMaG7W7qQRmNmKcvh4pjv5aDpqG8NuFL7APKMXN5rNnWz9g3jiYKNj?=
 =?us-ascii?Q?e5Po4JrLn6L/TRI/2bBK/HrA8wSNswPAbr+2M5gM16NGbGu9JE1vMqC9upD6?=
 =?us-ascii?Q?g76/HTOITqLDx9m14lRU3ecnLpM5YWiJBogOh2YOBYgvOP7c2gBJrDY3wZdN?=
 =?us-ascii?Q?D833hLdSmj0SjY691fIp8Q/JTkHYfFPaHeZCtt+kppwcp+RMnZk1dXwc1alR?=
 =?us-ascii?Q?CfYiWFPzF1tZKlXbwJ2vh3XsBRpQ0qQ3tIaUVsDg9RSgBw4rxUymtNRevg3R?=
 =?us-ascii?Q?vraFXg+KtPpvWvIG0sHy06R2NHol2TQ9jtxvAa3qNBQT38Ma+IfXwJiIvMMJ?=
 =?us-ascii?Q?dTZefnw2cgFB4jnmIkCbluogt+J8dis2XQHzwZ6zU9Orv2ZCm1ZXvJK0h9aM?=
 =?us-ascii?Q?fctlPc6+n63a/HIL7OH8dsE3L6+WcHPtIRVkno5xB4oDlFuqRQQd4kL7NfFf?=
 =?us-ascii?Q?dzkHMiW+fzwfiSARSxMDcLKOjoSEV2x2q5DqbdTZbq+vsbpY8klhrO8Zlni1?=
 =?us-ascii?Q?JDJZRcieVCjMXeFI1v3+0NKBmcPL/+NRegBdo6OO8k2E7OGR4HmJirppY/Z2?=
 =?us-ascii?Q?ovxqiv1ij71lmP6/s5P8YSb5ceIwzRBPzCW6DB8XS2Kid5vJbXyE/N7ulIOf?=
 =?us-ascii?Q?F+stDCPaDupkS3oJ+/iT8t4j1E9x3uuDTMtN8Ia+/qtlu+WStjiGl/wxMVAx?=
 =?us-ascii?Q?klku6L9uJ39ny1NRyE30osiiK9S+EBJ1iUy8AKCKaQPe7VIVt/kwEfoV11rE?=
 =?us-ascii?Q?yOn/4NueIapIn6SS024m/KWurqYuhocdpdxggOen6T5Jym2ZGn41Tn9SyJPc?=
 =?us-ascii?Q?1PbNYLZgUZyMc7fFi8Vl9rwqUgcBrhW/9l8AXyPKE3/GaODuZM+hMYy38nAn?=
 =?us-ascii?Q?Q0WyrswaykhnB5WJwPPT5YwVGZrIeaAJf72o8KFxIReZs2kGg0FKregFsjnQ?=
 =?us-ascii?Q?kEYdgJBAoP0imoz0z8RhxoPt3PVlMeciiK7w4RHIlBmGgnGj5zu7cGAsAcwT?=
 =?us-ascii?Q?+DonB0cmJESflnf32I5nqU2Gp16y3DSpQ0AKiCaB9J4hgL5tiEVnWz0siAp4?=
 =?us-ascii?Q?2tX+1CPbFVURM3SifPxRVyhKzHrkxB0QE9Lxij937tCnN6i+m1oqvmOOCwOZ?=
 =?us-ascii?Q?EvMMpMlO/EwPP9AYMb4vpOlfTrZ1TEAaJpY9t8+mt5KFE0NWGZEnyz0PZwDT?=
 =?us-ascii?Q?LRVNf9SK97EAI1b4oeyk1Jbf8TOqphngtU6diEQmpgHXmkNDFw1utcIYwhvL?=
 =?us-ascii?Q?QWzhm5gdxjgnZjTe9CPg+PNxsBk0ewMQ5xVw2zjLIBITJCv6?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <222B0351101CD94F8BD11FADC2FB29AB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c3f712-2c0e-4728-872d-08d9ebf678b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:03:26.8721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /tRrNCpDFO+jJvV9oPTDychcz2rnPIoYMPnH43nN6UZACoCmHuwDjcvMxQjWwstxhoAe1W4rqtRMUVC+1e4uGNTk1ABr2oPWG0Ta2UGsFnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1289
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-ORIG-GUID: TuLjaIyav4BxI4__Z1q6eH5GVOoffRyF
X-Proofpoint-GUID: TuLjaIyav4BxI4__Z1q6eH5GVOoffRyF
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
> drivers/scsi/csiostor/csio_scsi.c | 20 +++++++++++---------
> drivers/scsi/csiostor/csio_scsi.h | 10 ++++++++++
> 2 files changed, 21 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
> index 55db02521221..9aafe0002ab1 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -166,7 +166,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr=
)
> 	struct scsi_cmnd *scmnd =3D csio_scsi_cmnd(req);
>=20
> 	/* Check for Task Management */
> -	if (likely(scmnd->SCp.Message =3D=3D 0)) {
> +	if (likely(csio_priv(scmnd)->fc_tm_flags =3D=3D 0)) {
> 		int_to_scsilun(scmnd->device->lun, &fcp_cmnd->fc_lun);
> 		fcp_cmnd->fc_tm_flags =3D 0;
> 		fcp_cmnd->fc_cmdref =3D 0;
> @@ -185,7 +185,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr=
)
> 	} else {
> 		memset(fcp_cmnd, 0, sizeof(*fcp_cmnd));
> 		int_to_scsilun(scmnd->device->lun, &fcp_cmnd->fc_lun);
> -		fcp_cmnd->fc_tm_flags =3D (uint8_t)scmnd->SCp.Message;
> +		fcp_cmnd->fc_tm_flags =3D csio_priv(scmnd)->fc_tm_flags;
> 	}
> }
>=20
> @@ -1855,7 +1855,7 @@ csio_queuecommand(struct Scsi_Host *host, struct sc=
si_cmnd *cmnd)
>=20
> 	/* Needed during abort */
> 	cmnd->host_scribble =3D (unsigned char *)ioreq;
> -	cmnd->SCp.Message =3D 0;
> +	csio_priv(cmnd)->fc_tm_flags =3D 0;
>=20
> 	/* Kick off SCSI IO SM on the ioreq */
> 	spin_lock_irqsave(&hw->lock, flags);
> @@ -2026,7 +2026,7 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq =
*req)
> 		      req, req->wr_status);
>=20
> 	/* Cache FW return status */
> -	cmnd->SCp.Status =3D req->wr_status;
> +	csio_priv(cmnd)->wr_status =3D req->wr_status;
>=20
> 	/* Special handling based on FCP response */
>=20
> @@ -2049,7 +2049,7 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq =
*req)
> 		/* Modify return status if flags indicate success */
> 		if (flags & FCP_RSP_LEN_VAL)
> 			if (rsp_info->rsp_code =3D=3D FCP_TMF_CMPL)
> -				cmnd->SCp.Status =3D FW_SUCCESS;
> +				csio_priv(cmnd)->wr_status =3D FW_SUCCESS;
>=20
> 		csio_dbg(hw, "TM FCP rsp code: %d\n", rsp_info->rsp_code);
> 	}
> @@ -2125,9 +2125,9 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>=20
> 	csio_scsi_cmnd(ioreq)	=3D cmnd;
> 	cmnd->host_scribble	=3D (unsigned char *)ioreq;
> -	cmnd->SCp.Status	=3D 0;
> +	csio_priv(cmnd)->wr_status =3D 0;
>=20
> -	cmnd->SCp.Message	=3D FCP_TMF_LUN_RESET;
> +	csio_priv(cmnd)->fc_tm_flags =3D FCP_TMF_LUN_RESET;
> 	ioreq->tmo		=3D CSIO_SCSI_LUNRST_TMO_MS / 1000;
>=20
> 	/*
> @@ -2178,9 +2178,10 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
> 	}
>=20
> 	/* LUN reset returned, check cached status */
> -	if (cmnd->SCp.Status !=3D FW_SUCCESS) {
> +	if (csio_priv(cmnd)->wr_status !=3D FW_SUCCESS) {
> 		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
> -			 cmnd->device->id, cmnd->device->lun, cmnd->SCp.Status);
> +			 cmnd->device->id, cmnd->device->lun,
> +			 csio_priv(cmnd)->wr_status);
> 		goto fail;
> 	}
>=20
> @@ -2271,6 +2272,7 @@ struct scsi_host_template csio_fcoe_shost_template =
=3D {
> 	.name			=3D CSIO_DRV_DESC,
> 	.proc_name		=3D KBUILD_MODNAME,
> 	.queuecommand		=3D csio_queuecommand,
> +	.cmd_size		=3D sizeof(struct csio_cmd_priv),
> 	.eh_timed_out		=3D fc_eh_timed_out,
> 	.eh_abort_handler	=3D csio_eh_abort_handler,
> 	.eh_device_reset_handler =3D csio_eh_lun_reset_handler,
> diff --git a/drivers/scsi/csiostor/csio_scsi.h b/drivers/scsi/csiostor/cs=
io_scsi.h
> index 2257c3dcf724..39dda3c88f0d 100644
> --- a/drivers/scsi/csiostor/csio_scsi.h
> +++ b/drivers/scsi/csiostor/csio_scsi.h
> @@ -188,6 +188,16 @@ struct csio_scsi_level_data {
> 	uint64_t		oslun;
> };
>=20
> +struct csio_cmd_priv {
> +	uint8_t fc_tm_flags;	/* task management flags */
> +	uint16_t wr_status;
> +};
> +
> +static inline struct csio_cmd_priv *csio_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> static inline struct csio_ioreq *
> csio_get_scsi_ioreq(struct csio_scsim *scm)
> {

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

