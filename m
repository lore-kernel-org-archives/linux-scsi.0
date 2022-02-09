Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6A9C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiBIS5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiBIS5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:57:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A17C05CBA2
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:57:02 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HE2rM027620;
        Wed, 9 Feb 2022 18:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GYaX/OvbyqomtkTjpxsk2LnDkjoSjCrdAmkfGYq+owY=;
 b=aaLRquyogqafi6qcZ9LrKJxSZFaAJ29aaMNatVQAnTTK+aO53x4tvUHZMTfKA1qXxVKj
 YpHkTTxAdroWxA0WZBQPrulX5Xe+X3oKBAYW5kKYiBzQAvVL5Nmb2UIGRDwkVlNFq8qY
 OhFviDjGoUBvgYyjRN42rePbyj90su3fJ/Xbidm9UZpovhRMfegPsOl7EZxLZHVMT12j
 Xo4PXJHez88sX7VUwWRzOkeNvZyT6MCsK8AI8yILGA/hPnAO9TwLqJvpa8m45bdlyPOF
 IzGDQMS5jM7MbAFJpuOl+/w6N9uYYdC2A/0POInhBwja+9UvExTGxzMysN16vMUM2eGf cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdswfvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:56:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219Ipdu4105668;
        Wed, 9 Feb 2022 18:56:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 3e1h28tah3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:56:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Obkihv/gKREEl2ghaS5vu7BJF+pQ0oGb1gPZOUPT5/wUrexZOoF2ZHUXSrFLAOP9kIHpj6AMJrUAvB9+XaUdwJzYlF1uKGlerlvHSYyDkaScgO1HbJeydgmCocimihs6zF605lbHrANx3McaEX0WW92RhJwSfo3moivrkABVbi+uoB9jlCOmV2jq5gD/Fru1Xn45f4w12UtB2Fnec8DOA6BbRMAsB393/j3KPn3P1xbc7iVtqluvQeKPPKGVMLGhixraIYtdAj/TK0V0181Vi+cT6IKKaP+t3Nb5JjfNYCFQT9FPOkzclCO01RQh5+XgaNXOsdvU/jJE//Oa7GwgCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYaX/OvbyqomtkTjpxsk2LnDkjoSjCrdAmkfGYq+owY=;
 b=SDYWhVajXDOyvziALK73WgFQmW7Kz+D54ccJRcWaVmLKnN2tKEBRzEO8VSfMS/LIqqZjMgbgf6V5zs8Dzj+KCcyoTYe7du91mmDESm9xUy+lBpJ1964LCW7EpbdXpr8VLQbvFyO3rPEkyBtFoVB8ETzZZiFakkskfJJ7BqcfnD87G3IOxnA9/M6qKctyFjWKpz8ISpKGu/VDaM1rHc5aXjZ7PmrnpcRWeZyqH2WhN86k4kMF7O4NkJxK3Gs68EagGMZP/F3M0MdWzz0jHB4swP2d2OD0CYBypoM9c6UzEVbfqNGUYlabwSDlxA0IhKLgMGiz9xgPUNNGMlAj42PPhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYaX/OvbyqomtkTjpxsk2LnDkjoSjCrdAmkfGYq+owY=;
 b=vXWvySw7Ih3+Gm979+nZFsXjZzC1tQ+DIFb575WXAeMhlX1vJzkzZNupmx3Wa+2NpjqcXtl7J/W1c0T/o2IHui9toIQKgKLCrCkifdFx5v6gvinCsWiFrGSKQaOVuSlX78YCbw3zT2ZVRz0788lnr2Xxr7UotVWClIcuojm4oEU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MWHPR1001MB2224.namprd10.prod.outlook.com (2603:10b6:301:2e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 18:56:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:56:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 35/44] ppa: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH v2 35/44] ppa: Move the SCSI pointer to private command
 data
Thread-Index: AQHYHRFF2rPgYAHdAEqclBHKBW5+8KyLk3YA
Date:   Wed, 9 Feb 2022 18:56:52 +0000
Message-ID: <88DC70EF-4725-42B9-A9CD-85ED86F6A31D@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-36-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-36-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dc84f65-42af-4f3a-b9d7-08d9ebfdefa7
x-ms-traffictypediagnostic: MWHPR1001MB2224:EE_
x-microsoft-antispam-prvs: <MWHPR1001MB2224293AC602BEE089211585E62E9@MWHPR1001MB2224.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sKAA2kvlZDHnee9gj8izo3fAoGwSLf1tp0P+GJWY5YeqXzuz1aOK2gjewxJUoInTKrhyHDE8SIMVAuCy8JClNx2jFKk+nJYblauT3q/+j59XClJFBo3BYKYqiPhvd0bUar0xS4B5pkha4uYQUUrL0eqQow0CSj0C/SlPTyzAoT2Q9pRpeDhh2hnTRC7dUGI5r49EKRFc2qIbUuJ6QO6ePBe0s3VxjDKpPSCKJQ5QKkGF8NptyONfn2laxMyscZJlNyIaVEGS8PVADdkzRZaxDfVTuLpNYtcma2H9RimQ4t/p/AaMAS1AsM4Osz3W+K8lH5Kn6bwzl3oMArwpMTVn4CEchBUM2xPhXxXDCwPdNPcBfQ7rhR7dQOkiNX31bOhDDrm9q2Turcru7TcF79ljxv+HhVrt6TbK1vwG/FTpzxabEGf8SwwlhAYXLuCDm2umE+7bFg0bQa1NWdTY2rNlqcqYMtziwtRsRM/wjtjRBhADR2cDmL5bgeOMbpC1CQJ/ersMVK3hr3FIs1TaJNvq1obiWG5y+hCGs3HBAECbVfhVGmmt3QfdBZEFrMIdh5dhNsS9EY9KwEd7/O46Q3XrN8BSM2Pn0dQpXXQIkpFmEwCdHRgWoIXs8oUWWL7bQYcUfoSP3fNG9mR4MZoQPNyw5LQtyeTXVSA+6/qZ8RD7C5FldZ2VE2PVnU0jQLL83qRzEQBr4dq5yCza/OL8/cXmUq0ur9jq/j6amKnuK0xjaprpKWEB7gRjpjtK6XGr/VBe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(186003)(122000001)(36756003)(6916009)(33656002)(38070700005)(71200400001)(316002)(66946007)(54906003)(44832011)(38100700002)(2906002)(2616005)(5660300002)(6506007)(6512007)(6486002)(8936002)(86362001)(508600001)(83380400001)(53546011)(91956017)(4326008)(66446008)(66556008)(66476007)(8676002)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?owJN85WSfMIE7cdZSz4jTephPy2NBlhUfm7pZZdxEgEeezFyWOPZjW5Wbrrz?=
 =?us-ascii?Q?pT4QFRDWisH3/6VjGqUdqg8yFY0oHgYY3zKo+94rEOBaXmH0I5vNqPMeeXPB?=
 =?us-ascii?Q?wqC2/mk+hX49KmccIX4CY9DIdKLZFNRraPl1jZHdKOmRynA+AFgnk8eniGSy?=
 =?us-ascii?Q?pemIZsQ9b9jBOxglOImycapxFYn/1F/AdU268JRnHUAokC3vtBO1kfwOM3Bb?=
 =?us-ascii?Q?7eD7WbqNC1QEI/unAzo0PAwhNjcm2M9vRg7bSTLOBPZ7hYv1SKLmg2ZGIP0n?=
 =?us-ascii?Q?9y/1diI8ZcJQ/ZHDgbDD5XIW3ddcjKML6lMD3+/TU2A89EuGkJ0d5gBCmLJm?=
 =?us-ascii?Q?AQUyVdSxhnY5ni5IeZOBqnkndFmUs0mymyLwQE3EoTPnbx2NexXUWIQq749B?=
 =?us-ascii?Q?2KcbEblqz0zJaz8tHUk1pDpPjiWE0QlzQYwaNMlhJZPRitfWdGXnTXMsWj5c?=
 =?us-ascii?Q?EZhvgj9+dqVttsg3BGyd6UyOQEZIGy/I9z7hTMfKZ+hgelDj2eOGRZRlhm4D?=
 =?us-ascii?Q?l2lchifQhmtlQlyP8GgftsuFWHsN2Q7HkOxzSIlVJ5oaoLfFLsiIMO4+hryq?=
 =?us-ascii?Q?8fQlxpF+VPS0/z89En0NoUEz9BER+wpiPjuEefViVJXqacQxkhuW4o8CnSMB?=
 =?us-ascii?Q?PO9H8ObdmNXrtsRIUuCQJ+7d005T2Q01Yhw5Xa1KIvAZOCq9nBTmdqWy4pGU?=
 =?us-ascii?Q?IWRp8iF4rzWpENRifzDFqLYzTWUL2LvRuBs2FNkocwSvDQD1sEJsqg469Qnh?=
 =?us-ascii?Q?RyJuaZe0fqCJ7GBU4XceZrUpLNhoOOGdyZOQqyhwu6N82AIoxBY++cGCX6k4?=
 =?us-ascii?Q?wdLJ6ZCiMpPwi4B2ApssjnlisWV7JVJ7HmQ0z7p1pRV30thV3pxjWuEoPeaU?=
 =?us-ascii?Q?oP6eUhZSf3c+K9dkJH+BgJBrA04TjDpkFhc0SBRWdGHCcvqUR67xlGfZpRxO?=
 =?us-ascii?Q?Qt3/q9KlQzOq/igCihB1KRAj1VkiThJtyW18haeZkZ7c/+b8sLSSmdVWxlhI?=
 =?us-ascii?Q?jQxH2CwEKxxLXkOXOnVWxNrfS7HN/m5E1xM26YSNVfjMrZ9hem5ifFFjPMNj?=
 =?us-ascii?Q?Mdq+LKn0IU79wIx96fEs++LsiP3dpunzENOiKocxPJ3qcCj8T/VxlwrtNSiV?=
 =?us-ascii?Q?QS4A+KLiu2ditMLLmqA08lCko9tGxkInfz1ob0EJJ5+V4LvrPEcai9BWK0B0?=
 =?us-ascii?Q?wGkiILLWwbOjGuqUsh4+Abs0yfCm1yNawG0BaU/UKq/TDxRZQppJWyw0ghoA?=
 =?us-ascii?Q?/3tflj+1hLru9v7SNtrnzxfcRao+HUzeF6pVehpD1pDWDJQYTc66O08SuqXT?=
 =?us-ascii?Q?bmwRwODlAoJXXuVb20m4xSjRf7MHQbExDzhFE5tppddUZW7wElTx1cc+uPx/?=
 =?us-ascii?Q?XruZNjJHQpnjT6NJPtWS56Hy/YFyk4H05NuW+8u3vwLbLeciIvoWvfOKObo5?=
 =?us-ascii?Q?FWOgdfEpZ/KeiT6rggLU0/3toFvTo6QT4fIz5+eq6346bQ8V12On4Pu2tjcu?=
 =?us-ascii?Q?cS6CiQVtSYUG5LIDUCPNHeAEQxwBDPYoA1Lq2GGkzi5Bo+OIMFU8cmrqJTyo?=
 =?us-ascii?Q?GhNE/VgF1RARWXVi5TH2hd9zwEEfvVROI2ojrnxnAiB0+UDYorvJnL1LkGa6?=
 =?us-ascii?Q?wn8AC+Zz97HkpOUxYKVbFLibbbKQ+sTnmprEhpkXIkrUCvbrUTFJvqPykiDA?=
 =?us-ascii?Q?Lp8r0sPlD3NKNMbuCBEHACpU9DLE2PRaYudwApuabCWNr8uR?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1EDE3D7B8BF8F64C8564F543FC7E103E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc84f65-42af-4f3a-b9d7-08d9ebfdefa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:56:52.8854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UD0otjooH3jrwmJZbsJ82lgpHe0uboN9bKsiNXjBYNl733gQcol3cwnY7s/yucz4OBLbA70rZBAJ5uCKa/BUBXapTtVU3GW+HULeMnCixrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2224
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090099
X-Proofpoint-GUID: nDd4gSyEoPgVqVQy1CZnuCyQ1c1ORy8o
X-Proofpoint-ORIG-GUID: nDd4gSyEoPgVqVQy1CZnuCyQ1c1ORy8o
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
> drivers/scsi/ppa.c | 81 ++++++++++++++++++++++++++++------------------
> 1 file changed, 49 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
> index 003043de23a5..ac948768eba4 100644
> --- a/drivers/scsi/ppa.c
> +++ b/drivers/scsi/ppa.c
> @@ -45,6 +45,17 @@ typedef struct {
>=20
> #include  "ppa.h"
>=20
> +struct ppa_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static struct scsi_pointer *ppa_scsi_pointer(struct scsi_cmnd *cmd)
> +{
> +	struct ppa_cmd_priv *pcmd =3D scsi_cmd_priv(cmd);
> +
> +	return &pcmd->scsi_pointer;
> +}
> +=09
> static inline ppa_struct *ppa_dev(struct Scsi_Host *host)
> {
> 	return *(ppa_struct **)&host->hostdata;
> @@ -56,7 +67,7 @@ static void got_it(ppa_struct *dev)
> {
> 	dev->base =3D dev->dev->port->base;
> 	if (dev->cur_cmd)
> -		dev->cur_cmd->SCp.phase =3D 1;
> +		ppa_scsi_pointer(dev->cur_cmd)->phase =3D 1;
> 	else
> 		wake_up(dev->waiting);
> }
> @@ -511,13 +522,14 @@ static inline int ppa_send_command(struct scsi_cmnd=
 *cmd)
>  * The driver appears to remain stable if we speed up the parallel port
>  * i/o in this function, but not elsewhere.
>  */
> -static int ppa_completion(struct scsi_cmnd *cmd)
> +static int ppa_completion(struct scsi_cmnd *const cmd)
> {
> 	/* Return codes:
> 	 * -1     Error
> 	 *  0     Told to schedule
> 	 *  1     Finished data transfer
> 	 */
> +	struct scsi_pointer *scsi_pointer =3D ppa_scsi_pointer(cmd);
> 	ppa_struct *dev =3D ppa_dev(cmd->device->host);
> 	unsigned short ppb =3D dev->base;
> 	unsigned long start_jiffies =3D jiffies;
> @@ -543,7 +555,7 @@ static int ppa_completion(struct scsi_cmnd *cmd)
> 		if (time_after(jiffies, start_jiffies + 1))
> 			return 0;
>=20
> -		if ((cmd->SCp.this_residual <=3D 0)) {
> +		if (scsi_pointer->this_residual <=3D 0) {
> 			ppa_fail(dev, DID_ERROR);
> 			return -1;	/* ERROR_RETURN */
> 		}
> @@ -572,28 +584,30 @@ static int ppa_completion(struct scsi_cmnd *cmd)
> 		}
>=20
> 		/* determine if we should use burst I/O */
> -		fast =3D (bulk && (cmd->SCp.this_residual >=3D PPA_BURST_SIZE))
> -		    ? PPA_BURST_SIZE : 1;
> +		fast =3D bulk && scsi_pointer->this_residual >=3D PPA_BURST_SIZE ?
> +			PPA_BURST_SIZE : 1;
>=20
> 		if (r =3D=3D (unsigned char) 0xc0)
> -			status =3D ppa_out(dev, cmd->SCp.ptr, fast);
> +			status =3D ppa_out(dev, scsi_pointer->ptr, fast);
> 		else
> -			status =3D ppa_in(dev, cmd->SCp.ptr, fast);
> +			status =3D ppa_in(dev, scsi_pointer->ptr, fast);
>=20
> -		cmd->SCp.ptr +=3D fast;
> -		cmd->SCp.this_residual -=3D fast;
> +		scsi_pointer->ptr +=3D fast;
> +		scsi_pointer->this_residual -=3D fast;
>=20
> 		if (!status) {
> 			ppa_fail(dev, DID_BUS_BUSY);
> 			return -1;	/* ERROR_RETURN */
> 		}
> -		if (cmd->SCp.buffer && !cmd->SCp.this_residual) {
> +		if (scsi_pointer->buffer && !scsi_pointer->this_residual) {
> 			/* if scatter/gather, advance to the next segment */
> -			if (cmd->SCp.buffers_residual--) {
> -				cmd->SCp.buffer =3D sg_next(cmd->SCp.buffer);
> -				cmd->SCp.this_residual =3D
> -				    cmd->SCp.buffer->length;
> -				cmd->SCp.ptr =3D sg_virt(cmd->SCp.buffer);
> +			if (scsi_pointer->buffers_residual--) {
> +				scsi_pointer->buffer =3D
> +					sg_next(scsi_pointer->buffer);
> +				scsi_pointer->this_residual =3D
> +				    scsi_pointer->buffer->length;
> +				scsi_pointer->ptr =3D
> +					sg_virt(scsi_pointer->buffer);
> 			}
> 		}
> 		/* Now check to see if the drive is ready to comunicate */
> @@ -658,7 +672,7 @@ static void ppa_interrupt(struct work_struct *work)
> 	}
> #endif
>=20
> -	if (cmd->SCp.phase > 1)
> +	if (ppa_scsi_pointer(cmd)->phase > 1)
> 		ppa_disconnect(dev);
>=20
> 	ppa_pb_dismiss(dev);
> @@ -670,6 +684,7 @@ static void ppa_interrupt(struct work_struct *work)
>=20
> static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
> {
> +	struct scsi_pointer *scsi_pointer =3D ppa_scsi_pointer(cmd);
> 	unsigned short ppb =3D dev->base;
> 	unsigned char l =3D 0, h =3D 0;
> 	int retv;
> @@ -680,7 +695,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cm=
nd *cmd)
> 	if (dev->failed)
> 		return 0;
>=20
> -	switch (cmd->SCp.phase) {
> +	switch (scsi_pointer->phase) {
> 	case 0:		/* Phase 0 - Waiting for parport */
> 		if (time_after(jiffies, dev->jstart + HZ)) {
> 			/*
> @@ -715,7 +730,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cm=
nd *cmd)
> 					return 1;	/* Try again in a jiffy */
> 				}
> 			}
> -			cmd->SCp.phase++;
> +			scsi_pointer->phase++;
> 		}
> 		fallthrough;
>=20
> @@ -724,7 +739,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cm=
nd *cmd)
> 			ppa_fail(dev, DID_NO_CONNECT);
> 			return 0;
> 		}
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 3:		/* Phase 3 - Ready to accept a command */
> @@ -734,21 +749,22 @@ static int ppa_engine(ppa_struct *dev, struct scsi_=
cmnd *cmd)
>=20
> 		if (!ppa_send_command(cmd))
> 			return 0;
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 4:		/* Phase 4 - Setup scatter/gather buffers */
> 		if (scsi_bufflen(cmd)) {
> -			cmd->SCp.buffer =3D scsi_sglist(cmd);
> -			cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
> -			cmd->SCp.ptr =3D sg_virt(cmd->SCp.buffer);
> +			scsi_pointer->buffer =3D scsi_sglist(cmd);
> +			scsi_pointer->this_residual =3D
> +				scsi_pointer->buffer->length;
> +			scsi_pointer->ptr =3D sg_virt(scsi_pointer->buffer);
> 		} else {
> -			cmd->SCp.buffer =3D NULL;
> -			cmd->SCp.this_residual =3D 0;
> -			cmd->SCp.ptr =3D NULL;
> +			scsi_pointer->buffer =3D NULL;
> +			scsi_pointer->this_residual =3D 0;
> +			scsi_pointer->ptr =3D NULL;
> 		}
> -		cmd->SCp.buffers_residual =3D scsi_sg_count(cmd) - 1;
> -		cmd->SCp.phase++;
> +		scsi_pointer->buffers_residual =3D scsi_sg_count(cmd) - 1;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 5:		/* Phase 5 - Data transfer stage */
> @@ -761,7 +777,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cm=
nd *cmd)
> 			return 0;
> 		if (retv =3D=3D 0)
> 			return 1;
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 6:		/* Phase 6 - Read status/message */
> @@ -798,7 +814,7 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd=
)
> 	dev->jstart =3D jiffies;
> 	dev->cur_cmd =3D cmd;
> 	cmd->result =3D DID_ERROR << 16;	/* default return code */
> -	cmd->SCp.phase =3D 0;	/* bus free */
> +	ppa_scsi_pointer(cmd)->phase =3D 0;	/* bus free */
>=20
> 	schedule_delayed_work(&dev->ppa_tq, 0);
>=20
> @@ -839,7 +855,7 @@ static int ppa_abort(struct scsi_cmnd *cmd)
> 	 * have tied the SCSI_MESSAGE line high in the interface
> 	 */
>=20
> -	switch (cmd->SCp.phase) {
> +	switch (ppa_scsi_pointer(cmd)->phase) {
> 	case 0:		/* Do not have access to parport */
> 	case 1:		/* Have not connected to interface */
> 		dev->cur_cmd =3D NULL;	/* Forget the problem */
> @@ -861,7 +877,7 @@ static int ppa_reset(struct scsi_cmnd *cmd)
> {
> 	ppa_struct *dev =3D ppa_dev(cmd->device->host);
>=20
> -	if (cmd->SCp.phase)
> +	if (ppa_scsi_pointer(cmd)->phase)
> 		ppa_disconnect(dev);
> 	dev->cur_cmd =3D NULL;	/* Forget the problem */
>=20
> @@ -976,6 +992,7 @@ static struct scsi_host_template ppa_template =3D {
> 	.sg_tablesize		=3D SG_ALL,
> 	.can_queue		=3D 1,
> 	.slave_alloc		=3D ppa_adjust_queue,
> +	.cmd_size		=3D sizeof(struct ppa_cmd_priv),
> };
>=20
> /************************************************************************=
***

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

