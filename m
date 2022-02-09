Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53895C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbiBISUH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiBISTz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:19:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1BC03C186
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:19:14 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HBl8f008856;
        Wed, 9 Feb 2022 18:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/xorTbCZfrnEmMe5Ys9y5aAS9cl/HbJAEEajzvuZNiY=;
 b=iCO/2jHO0Aec883ZFIZwvR7k1dACJWw0d4xK4WNNQnw+kK3X5l2gW53BATxJUmQRcjzQ
 VwWKSCFjLTFbSpTHrMKRQlACTIpVhyfsKgAQyRafDUV1Eqt788FGVg9NfLULKjtVdX5L
 MVCj1NJ9uHssdS7BuYCN1n2khD58lN++V/7VlWt3h/c7p8PwLsGNu+jTer2PIko4I3p4
 xKyKIPcL+/4SERMPBxsViqhMLj8qBWTu3YgWuvA/04KVhhgKXvmePhOz7LXAFc8/466Z
 KRyIidNwJbRjhFdnA1TFp9kuyk03XDCThx4n2Ovb1Ynz25wif8IJgNSZcB9tcMcgt5SM Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgnjse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:19:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I1sCf018921;
        Wed, 9 Feb 2022 18:19:10 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by userp3030.oracle.com with ESMTP id 3e1ec34pj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:19:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBdb35CWcGilOE5yZTDRcOLe/1pMLYjErS+d6lI3UF1pDOLcqlkYxX3LF235AuyAEUqllts2waiBVUnAuiBrXpZY6jQhx+3zC8qheO/77Bc1aIE1x273SL1l41HlmcZN2fj8QniWu0k3l49Y/QgNiO+g51VTT6pI67n5qmFhcLP2Q15bKeo6H/wmtGzAcQ0hbkcA6nz8RKTRr3NlNsfqioPvK12a3cr0RzrFWFjc/47lvGSnd04+1djrz5cuapeUIhCYFHtLpAwwjBY4Nv5HdNafvdTRk3Zhfpckzx2pZSuzHcIDiWKwT9ORDrbt21c4UYhVbEjxwf7Dp+IFsdvXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xorTbCZfrnEmMe5Ys9y5aAS9cl/HbJAEEajzvuZNiY=;
 b=cuuWYZVtA7AoXkxTu/mbWhEjuGKDO/E4lk0Ys3QNJdJA1clFN/jXTFyRh/3WStPfoyPRQAEciSWPA5uW+qgj9dCEhpTq43hBwTTSyZg9zg1Yk1qJlBZwgFjUGMzSFQ+KifBdU8nUq0SSxMe/SGyMWiLxm7pidq+YHw4luClgFTeBqekuclT4OUpbs6elmi5EirSMvYwnhH8hfaDj6PxHQdvhZP25NW9UN8rjJ7B0nQX0I1ak7RHNc5Oxi+CK0RyoeoowfdwJ2XZPmWUTZteOp79vpd8fvkMZKhfhENE1ErTqTcjHvxkTxcc6HO6njSjrp1u0x3DiIfS5KZ6n6i9xpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xorTbCZfrnEmMe5Ys9y5aAS9cl/HbJAEEajzvuZNiY=;
 b=lRoxplzxegkBP00OQewniq7tVZXOQJbNStgPbEvrCDJ/kXZ7ZD9QMW8D5K/Bq5O42EELyaWu7+415JvqcOZ7fIpykEU9pDQz4kW73bc/nMlGOGzU5eQoJqjKNQnRXDFJEPYoE7zvQEioVidso0Qvr0+qg4dUnx1RoLQInkG+Yas=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB5261.namprd10.prod.outlook.com (2603:10b6:5:3a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Wed, 9 Feb
 2022 18:19:07 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:19:07 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 21/44] imm: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH v2 21/44] imm: Move the SCSI pointer to private command
 data
Thread-Index: AQHYHREizRkFAzgK6kCx1tJcwg+Bw6yLiOkA
Date:   Wed, 9 Feb 2022 18:19:07 +0000
Message-ID: <BA8AF5E9-9B1F-42B9-869C-CC83B8689F84@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-22-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-22-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 510cd703-5b34-4ff1-6147-08d9ebf8a93a
x-ms-traffictypediagnostic: DS7PR10MB5261:EE_
x-microsoft-antispam-prvs: <DS7PR10MB5261C433CFD7D639CE89082EE62E9@DS7PR10MB5261.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDHB1n6065NKwVN0gHXy+puQ105G79YRuZn+fRUqrThWhBgQBhsMNJoiPy9LDwh6ZxWGHMhQF0FPjdjZMWlijyuP75nsIXB6XfbGR4eccMiwmPMKUxS+nbIV8EE3WJxXMqKJgXSUJjrKvYgaNWY8taJzudErIJWg/siR9cBRl59rgmgJ5OzIq8JYEH/Tg7mFc9TXml6L+b4LrllxOs+KMxu9EXrtfyxKAIfJ3hzVS5hlTBIp32jvzkcuk+QWzeqXc88S6yRzZY0qqW3KyfYERxGpUxyVXF5tx1cm/QYVMzzd4Wl3cCaO6aNSi4cyVunDsInu5NEwJtpNswKXFGAP/1viDDUv1f43UgyQA5p3D0d7AFzl06wk1VS2y0syTOrgQ+FTYOjxCkHVlnSH6l+Z/EA+wYDUTd+9lDvbPE3kaJP74oDXfwS8ciog1GAYg90oVd+41I/qM7TU3uFBNiwUddxS248qcCervJmlpVv2H45q5dXoEkZqVKN2LqVjaUXqTrKr8mLGQsKp5i6tJ7Ia3Mbfip/40qL59imLaOo4TV2s/OQ5ZYFZ65aDXsMNaPT69xEmP/djz3AoxQS8jXe8bRU36yusX/A1WaMdoOxsR735SIk2o4JxWbXg/Q9fDn1gGCxzSqJVMQBjPFTHLj0QK7jdWswLlxQkKRVukUlfd4jAH3p/jg+vbPcSGsv3mc7+lT9PNL2G/P9NNO5bZhIOA7yVigpWsBWqUWDHQ08enTonGnnQsN0pKsTrSlyqSkWs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(5660300002)(122000001)(33656002)(66556008)(4326008)(2616005)(53546011)(36756003)(38070700005)(71200400001)(2906002)(186003)(8676002)(6916009)(83380400001)(316002)(508600001)(91956017)(6486002)(66446008)(64756008)(66476007)(86362001)(38100700002)(8936002)(66946007)(54906003)(6512007)(6506007)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uBWQEIszdyg3YM4uU3DTnv9/i6ZiGjOAo//nkyciuEdiR53AG8KJgkhl1/lu?=
 =?us-ascii?Q?sZiZ9AE+i3tDKU+Pw/e+H6CiHffw8LaDFzLqxFasp3GOEZy5TDbxgPyliyXh?=
 =?us-ascii?Q?iX1vwuCtLoE9tM8XewrAfKBQDKv+NeLkEQrGWcytBIp+Fyo2REV4AVEQm6H/?=
 =?us-ascii?Q?GTG80HHK+pEwRIrBB2aiRQmbD/LZefG/PXsGouz7EvdZp8iuyxaRUyXoWN/l?=
 =?us-ascii?Q?IcjUcV6mteR3E+7v9YKrVMZR7O8Vsd6BvQI/p33RoZRXr03bbCnuPQfdrb9v?=
 =?us-ascii?Q?1WOWnc8nxYb2rbDkG8/4ZzTc10XnWBnrXcEmt3on83lez6Uq855kfceEFXdq?=
 =?us-ascii?Q?lQr/DfXUavzpYMR0o4lJ6zeMHTfP/4Zbjxe7pxpNiC53V5IaK2+GdvzmG2rg?=
 =?us-ascii?Q?S0sP/2+2l3RNNSwqupqfl4sOwC9yCi/G92jZMNZPkFpIziJ3FIXpWOQDceTz?=
 =?us-ascii?Q?giKF1YuGFbwt2t/e+jsvq2pB9h2qKQAAq01hJmXgIHGicivg8z7hDDDh+vP/?=
 =?us-ascii?Q?syXyr7z3wnm6rJrHpPcLOTezqlgiljbAKtNPOJB7+gym6H12HUN/sr+NCnGQ?=
 =?us-ascii?Q?v8oj1l2nTGBTao5KiagcaJiB/W1dilAOWIMncZCALzlJP4KKLdhpTKmkV++k?=
 =?us-ascii?Q?j4KEXV4xUTLx6tFeSnd/zNpaDiS605aQspR2foyTc0EVoRPuB2uvctQH4wrU?=
 =?us-ascii?Q?I8CqjU40nJeG8jUbveaUv1E1MV9HNvEAuWofZD0sxAAs1Y5hcB/m0Os8r2P+?=
 =?us-ascii?Q?u7XeAVrdOPFqPYjYaq7bbJgPR4NSnrrBKZwIXtpFhO3Fvok+0HqSNpl8gZAV?=
 =?us-ascii?Q?WyafJzYVIN+oQHZnkmZ3dbaf5A1Qcf9Gsj2ZY+dm7pEwV6dWyCbDb2mNeYLw?=
 =?us-ascii?Q?xy28zuDMnSxUmr/bjxvynY2WMYZBWKhTvueNBezuLE8F1BHPZ9kw4Xtoy1MM?=
 =?us-ascii?Q?76TxhBkOZ+3406eGZX8l86RHEpYiqE0acuCoyfww5TJC7dHks+X1vKUz9hpd?=
 =?us-ascii?Q?I8ejURSTsPdqEumWHl0/03Wq3JPjwQerPfy6GS7NO2MoQGM65wmvcyO8gP+2?=
 =?us-ascii?Q?LQG2VJZU9DTtFgPFN+oc2KJV3eb6ph5+8hmUOvIWBaaX1Msn8ocWFFyIgHmh?=
 =?us-ascii?Q?ttdXcuLPOAyKqUHO9Zn0QcaWmVXmFa86gk+a9fBOWDzE70HtZiBGNPbhI8ja?=
 =?us-ascii?Q?V+9d/fx6NgbmcY5z0M6j1Txh9zZBjQA+u0ROMw/nQNHqtjHkVyIwLHSa0VZS?=
 =?us-ascii?Q?jMrTocJpZDosuOB1/VB+JrtRSS0rjIUMA7x/xtGNXVniVAeRaHgmCgOe1JoL?=
 =?us-ascii?Q?E8flBjTHBxmnrJ94qHxEff+imCg1xqpI9lIeOpOxy3bKR4TmG7JaS6prPXc0?=
 =?us-ascii?Q?Iqi1pJu6ydwITKo7ql56lh7H08omYR6uMYRVNOTRn3EPu+/FMMUADvT+Qz76?=
 =?us-ascii?Q?2HQMVkTIsU0ja9diWAFtScgOb8Ep3l8TEw/1ZcHQusx+ruNHZMqK6vUbny/e?=
 =?us-ascii?Q?vDAGcEFg125PsCicAq+KgnFOqI0RIfkH669scbGf/7rwuFpWDMpyCc3sQiGh?=
 =?us-ascii?Q?FFXa26xADdKMIh4T2slyE8UjzTMMo6yV4Il6w6gD3QIZJeeVteEi8/rA45RC?=
 =?us-ascii?Q?sGnZRUmyshH7yLyRGaKzq6WpLicyipGcWd1x6UIJr26hkelAG8/Ehp95GygE?=
 =?us-ascii?Q?fOGRTdmlsZBkcwjZnKgP0JIVo641VPp8fUvsfduU9b7YQUyB?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <79438C4D5878F248A60B110D4F5A73DC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510cd703-5b34-4ff1-6147-08d9ebf8a93a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:19:07.2134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wOHkfeE/GiyBpOEs6gujdZ3oNgs1FjxTK+bvh5P7Snb8gMADIbzFZ+gtbGdAWA9fcfb4VPdsBz8Esva3URD8xTifNDKwfmRwXRMUmN1s6KY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5261
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-GUID: I8W-kTX49QAFWcCyiNuQV73nPNxN_zjK
X-Proofpoint-ORIG-GUID: I8W-kTX49QAFWcCyiNuQV73nPNxN_zjK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer=
.
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd=
.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/imm.c | 88 ++++++++++++++++++++++++----------------------
> drivers/scsi/imm.h | 11 ++++++
> 2 files changed, 56 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
> index 8afdb4dba2be..3d86e3a52866 100644
> --- a/drivers/scsi/imm.c
> +++ b/drivers/scsi/imm.c
> @@ -66,7 +66,7 @@ static void got_it(imm_struct *dev)
> {
> 	dev->base =3D dev->dev->port->base;
> 	if (dev->cur_cmd)
> -		dev->cur_cmd->SCp.phase =3D 1;
> +		imm_scsi_pointer(dev->cur_cmd)->phase =3D 1;
> 	else
> 		wake_up(dev->waiting);
> }
> @@ -618,13 +618,14 @@ static inline int imm_send_command(struct scsi_cmnd=
 *cmd)
>  * The driver appears to remain stable if we speed up the parallel port
>  * i/o in this function, but not elsewhere.
>  */
> -static int imm_completion(struct scsi_cmnd *cmd)
> +static int imm_completion(struct scsi_cmnd *const cmd)
> {
> 	/* Return codes:
> 	 * -1     Error
> 	 *  0     Told to schedule
> 	 *  1     Finished data transfer
> 	 */
> +	struct scsi_pointer *scsi_pointer =3D imm_scsi_pointer(cmd);
> 	imm_struct *dev =3D imm_dev(cmd->device->host);
> 	unsigned short ppb =3D dev->base;
> 	unsigned long start_jiffies =3D jiffies;
> @@ -660,44 +661,43 @@ static int imm_completion(struct scsi_cmnd *cmd)
> 		 * a) Drive status is screwy (!ready && !present)
> 		 * b) Drive is requesting/sending more data than expected
> 		 */
> -		if (((r & 0x88) !=3D 0x88) || (cmd->SCp.this_residual <=3D 0)) {
> +		if ((r & 0x88) !=3D 0x88 || scsi_pointer->this_residual <=3D 0) {
> 			imm_fail(dev, DID_ERROR);
> 			return -1;	/* ERROR_RETURN */
> 		}
> 		/* determine if we should use burst I/O */
> 		if (dev->rd =3D=3D 0) {
> -			fast =3D (bulk
> -				&& (cmd->SCp.this_residual >=3D
> -				    IMM_BURST_SIZE)) ? IMM_BURST_SIZE : 2;
> -			status =3D imm_out(dev, cmd->SCp.ptr, fast);
> +			fast =3D bulk && scsi_pointer->this_residual >=3D
> +				IMM_BURST_SIZE ? IMM_BURST_SIZE : 2;
> +			status =3D imm_out(dev, scsi_pointer->ptr, fast);
> 		} else {
> -			fast =3D (bulk
> -				&& (cmd->SCp.this_residual >=3D
> -				    IMM_BURST_SIZE)) ? IMM_BURST_SIZE : 1;
> -			status =3D imm_in(dev, cmd->SCp.ptr, fast);
> +			fast =3D bulk && scsi_pointer->this_residual >=3D
> +				IMM_BURST_SIZE ? IMM_BURST_SIZE : 1;
> +			status =3D imm_in(dev, scsi_pointer->ptr, fast);
> 		}
>=20
> -		cmd->SCp.ptr +=3D fast;
> -		cmd->SCp.this_residual -=3D fast;
> +		scsi_pointer->ptr +=3D fast;
> +		scsi_pointer->this_residual -=3D fast;
>=20
> 		if (!status) {
> 			imm_fail(dev, DID_BUS_BUSY);
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
> +				scsi_pointer->ptr =3D sg_virt(scsi_pointer->buffer);
>=20
> 				/*
> 				 * Make sure that we transfer even number of bytes
> 				 * otherwise it makes imm_byte_out() messy.
> 				 */
> -				if (cmd->SCp.this_residual & 0x01)
> -					cmd->SCp.this_residual++;
> +				if (scsi_pointer->this_residual & 0x01)
> +					scsi_pointer->this_residual++;
> 			}
> 		}
> 		/* Now check to see if the drive is ready to comunicate */
> @@ -762,7 +762,7 @@ static void imm_interrupt(struct work_struct *work)
> 	}
> #endif
>=20
> -	if (cmd->SCp.phase > 1)
> +	if (imm_scsi_pointer(cmd)->phase > 1)
> 		imm_disconnect(dev);
>=20
> 	imm_pb_dismiss(dev);
> @@ -774,8 +774,9 @@ static void imm_interrupt(struct work_struct *work)
> 	return;
> }
>=20
> -static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
> +static int imm_engine(imm_struct *dev, struct scsi_cmnd *const cmd)
> {
> +	struct scsi_pointer *scsi_pointer =3D imm_scsi_pointer(cmd);
> 	unsigned short ppb =3D dev->base;
> 	unsigned char l =3D 0, h =3D 0;
> 	int retv, x;
> @@ -786,7 +787,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cm=
nd *cmd)
> 	if (dev->failed)
> 		return 0;
>=20
> -	switch (cmd->SCp.phase) {
> +	switch (scsi_pointer->phase) {
> 	case 0:		/* Phase 0 - Waiting for parport */
> 		if (time_after(jiffies, dev->jstart + HZ)) {
> 			/*
> @@ -800,7 +801,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cm=
nd *cmd)
>=20
> 	case 1:		/* Phase 1 - Connected */
> 		imm_connect(dev, CONNECT_EPP_MAYBE);
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 2:		/* Phase 2 - We are now talking to the scsi bus */
> @@ -808,7 +809,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cm=
nd *cmd)
> 			imm_fail(dev, DID_NO_CONNECT);
> 			return 0;
> 		}
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 3:		/* Phase 3 - Ready to accept a command */
> @@ -818,23 +819,23 @@ static int imm_engine(imm_struct *dev, struct scsi_=
cmnd *cmd)
>=20
> 		if (!imm_send_command(cmd))
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
> +			scsi_pointer->this_residual =3D scsi_pointer->buffer->length;
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
> -		if (cmd->SCp.this_residual & 0x01)
> -			cmd->SCp.this_residual++;
> +		scsi_pointer->buffers_residual =3D scsi_sg_count(cmd) - 1;
> +		scsi_pointer->phase++;
> +		if (scsi_pointer->this_residual & 0x01)
> +			scsi_pointer->this_residual++;
> 		fallthrough;
>=20
> 	case 5:		/* Phase 5 - Pre-Data transfer stage */
> @@ -851,7 +852,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cm=
nd *cmd)
> 		if ((dev->dp) && (dev->rd))
> 			if (imm_negotiate(dev))
> 				return 0;
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 6:		/* Phase 6 - Data transfer stage */
> @@ -867,7 +868,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cm=
nd *cmd)
> 			if (retv =3D=3D 0)
> 				return 1;
> 		}
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 7:		/* Phase 7 - Post data transfer stage */
> @@ -879,7 +880,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cm=
nd *cmd)
> 				w_ctr(ppb, 0x4);
> 			}
> 		}
> -		cmd->SCp.phase++;
> +		scsi_pointer->phase++;
> 		fallthrough;
>=20
> 	case 8:		/* Phase 8 - Read status/message */
> @@ -922,7 +923,7 @@ static int imm_queuecommand_lck(struct scsi_cmnd *cmd=
)
> 	dev->jstart =3D jiffies;
> 	dev->cur_cmd =3D cmd;
> 	cmd->result =3D DID_ERROR << 16;	/* default return code */
> -	cmd->SCp.phase =3D 0;	/* bus free */
> +	imm_scsi_pointer(cmd)->phase =3D 0;	/* bus free */
>=20
> 	schedule_delayed_work(&dev->imm_tq, 0);
>=20
> @@ -961,7 +962,7 @@ static int imm_abort(struct scsi_cmnd *cmd)
> 	 * have tied the SCSI_MESSAGE line high in the interface
> 	 */
>=20
> -	switch (cmd->SCp.phase) {
> +	switch (imm_scsi_pointer(cmd)->phase) {
> 	case 0:		/* Do not have access to parport */
> 	case 1:		/* Have not connected to interface */
> 		dev->cur_cmd =3D NULL;	/* Forget the problem */
> @@ -987,7 +988,7 @@ static int imm_reset(struct scsi_cmnd *cmd)
> {
> 	imm_struct *dev =3D imm_dev(cmd->device->host);
>=20
> -	if (cmd->SCp.phase)
> +	if (imm_scsi_pointer(cmd)->phase)
> 		imm_disconnect(dev);
> 	dev->cur_cmd =3D NULL;	/* Forget the problem */
>=20
> @@ -1109,6 +1110,7 @@ static struct scsi_host_template imm_template =3D {
> 	.sg_tablesize		=3D SG_ALL,
> 	.can_queue		=3D 1,
> 	.slave_alloc		=3D imm_adjust_queue,
> +	.cmd_size		=3D sizeof(struct imm_cmd_priv),
> };
>=20
> /************************************************************************=
***
> diff --git a/drivers/scsi/imm.h b/drivers/scsi/imm.h
> index 7f2bb35b1b87..12cbc7ee8bba 100644
> --- a/drivers/scsi/imm.h
> +++ b/drivers/scsi/imm.h
> @@ -139,6 +139,17 @@ static char *IMM_MODE_STRING[] =3D
> #define w_ctr(x,y)      outb(y, (x)+2)
> #endif
>=20
> +struct imm_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static inline struct scsi_pointer *imm_scsi_pointer(struct scsi_cmnd *cm=
d)
> +{
> +	struct imm_cmd_priv *icmd =3D scsi_cmd_priv(cmd);
> +
> +	return &icmd->scsi_pointer;
> +}
> +
> static int imm_engine(imm_struct *, struct scsi_cmnd *);
>=20
> #endif				/* _IMM_H */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

