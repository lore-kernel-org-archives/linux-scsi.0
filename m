Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CE7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 19:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2323E61527
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 19:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346443AbhI2TLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 15:11:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35586 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346211AbhI2TLw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 15:11:52 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TIsZ2e007921;
        Wed, 29 Sep 2021 19:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=j6d6YgqmXF/4t+n2Go6cxrDUwhsmkngz4BqA+4LO11Y=;
 b=E7mmAORh+n6/+3h8PQcpL/OxtCkfXvpXBO3i/NZ1gYF8EQJ9OD5jCA6U56pwWHwzUccg
 TdPMrGZP66VcQCmwfDFN6X7vhljNbshNwxciFK9LmkrKmeqGWAILx7knJL/KFfIYI6cZ
 JxYMc2mAad1kZ459gecFY1sKnyWjnae6KFIXxrcf6b1fo4hNX1sKDyE3wGQVVg7L84sp
 5A9EuscwwV7E5DRShQBfDIXqPCo5LPwU2GCjX52ILSTncL4RBAH5Oc+mtdLkOtMEuP8y
 aqSMoRaFNnOWop0mXf2Kbn9MnQ8A8Z63Crsy0s1oPKgxH8ckLqrKxe2mk5DI8sl/tvuL 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcw11d9-24
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 19:10:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TIjhSu144316;
        Wed, 29 Sep 2021 18:46:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 3bceu5wnk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 18:46:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cj9xgalkNi2QxUYeDOX6ZRadtxuNLipBZy+v/sWbpFc7B+Su3XetamQRM2RajkuGefqp4j9Syh1korVBpOzRT517JtxxkDnQlbJJ9i7TgFLx0Sxn9C6DkY974ncAsM5OBjwr9XJTJonpo6Jn4Jg8CEFM4bp7DtHhNoi4E+Yqy14KcUIGsFDZWDT4iCLNEu+gWF9cfvrCUrX0YPB11ahRoakpFNsQVLe28wBs+Xyq7cgE8zlZEg0Mh7rMX4t7T4z9k55b1bEknllLju2OFxx7Bu9pcKfroFLhUDc632rs86Oztvtf/83kKaWJBDnrDJrRkEHKBY4D+umlg7JvoqfgOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=j6d6YgqmXF/4t+n2Go6cxrDUwhsmkngz4BqA+4LO11Y=;
 b=ijRss3DhGT/Wv41rXd3IBvrjU+Xjq+QysgBCQw6TcTwwV1ONCouPlk/i+Ksv/ZF2m16PMDnjt9nSm6RIs5cWClIpaqUvqnN/pQKZkOsdM4HVHWMH6hCEyg9bVzPiKaj2pui2k60VsHBAk/P7enU5CuShzy9d7Rsog1gpRE+k4DTbQ/5VceaCwUVuIpebwFmz4QPQ3jB1Zl4sTX6MWoVF3YpJFtqawam3cd4OeEyt8eQ03vvWA1OZ5hOVfkdFCehnYqBzbTXoNYv/OmU5rHVwIEjO8nXXwVN25X8W5Xxl6CPrlHEUQD0kw6/Y0G4jGsxy2Tqis5MxL0NbXkM5SwauKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6d6YgqmXF/4t+n2Go6cxrDUwhsmkngz4BqA+4LO11Y=;
 b=AYnkq/Q6Ghz9wXAfc4wzVrUF25Y5iiTeLXAl6s2H6SXTilUkAfC+7t3cOmkR84yVBoz0Q1BI5rs9ukpCAU91iBfBYwyV54AJhyVVw2UB7mIRmf+adq4EaQhc7A7irZw31lK48sY2GEVPmpamF53dli1IPrg/iUzidAFSv5wse6I=
Received: from BYAPR10MB2934.namprd10.prod.outlook.com (2603:10b6:a03:85::22)
 by SJ0PR10MB5440.namprd10.prod.outlook.com (2603:10b6:a03:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 18:46:22 +0000
Received: from BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7]) by BYAPR10MB2934.namprd10.prod.outlook.com
 ([fe80::a835:7e9d:bf65:47d7%5]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 18:46:22 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: fix scsi_mode_select() interface
Thread-Topic: [PATCH 2/2] scsi: fix scsi_mode_select() interface
Thread-Index: AQHXtRLiE89Lavq2Rkai06dtmy1KC6u7WnIA
Date:   Wed, 29 Sep 2021 18:46:22 +0000
Message-ID: <97783F5F-67F0-43C2-99A1-1C680B94E3AD@oracle.com>
References: <20210929091744.706003-1-damien.lemoal@wdc.com>
 <20210929091744.706003-3-damien.lemoal@wdc.com>
In-Reply-To: <20210929091744.706003-3-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e604e17-3103-4698-0068-08d983796f10
x-ms-traffictypediagnostic: SJ0PR10MB5440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR10MB5440872BB6E827F16AF5773EE6A99@SJ0PR10MB5440.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tOo042Rkfluyf6iQPuU3Rbwci28/sLEhhd0LgeL2dRG6nSZ0TUz8LekK5JcJk4qaUaSafNKUMQIW9ibEPUZYF+lvNJXUmc9vTBwnyDXJ3mxEPP2r0VNGsOfFR316g1v9BFVp6WjTv8D44VAf5g0Nvgml5Wn98SOMdLH6HHtssAkOhqmYCTRmztiSDUd71vuJbimJr76QNqfN46r8bSRS1sLp5xtz4lOHikhGrvDlwNlU5CI1xnw3dEBhn/g8C6fvBDVnazwBNongfrDUv2vMAN/NHRrjMm9JUq3t2z7c+Rx7FIy7/LOLSLvpSofuvdoetRU2pcjZVfaqcIgwaWD1KKrlZn9sY/Ypv4K0GVZX2rj+IWvd56ij8JRBsyMSEK1/LA6D7dMgdYZO2FpF3qTQNy9Zii8NSI24tZQUDjQqA8yQNahWG1H9lL4Iasakhy/gGfyiCIZjVJQ8I8uhvePuu5cQrcITojg8xMuXfAvrvXgNR5hWX276naZWlEvjAfwwBQ3tMGe1UPhDQy+MSp1+Xj5qvPlrrn/6UblPDJBKpmBTyDtUica6wYeVrb8dmfsUY7GxQK76Y2u78X+hz8bpaOWFu5slGytnqzW8Sykwlwlm7k90DORBsQaxGXBOUG7hxZh/foqYd8YPJApv7h9CeGJV8oJEEsHMlOnBT2nz0/g1pVT4JVCCaQBN/9x6S86pAyRXMcPC55i2Xff0/uXjgw4RNnJ9CtBp+5UUYVBY3DsL5MjUDkUazMLN0hMk1aeE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2934.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(26005)(8676002)(54906003)(36756003)(83380400001)(2616005)(186003)(44832011)(71200400001)(5660300002)(38070700005)(53546011)(6506007)(107886003)(4326008)(316002)(6916009)(6512007)(76116006)(86362001)(66556008)(64756008)(2906002)(8936002)(122000001)(33656002)(91956017)(66446008)(66476007)(66946007)(508600001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fa64E69O8hr2rUl9GoiqcyNJ73ifUTL6wk73P3oyzFHY+BsWBfbb3Ev45VAj?=
 =?us-ascii?Q?xSTXTYr2EO16sLXgEyD+0cIjV0ARuAIoimRVQEpDvt3SOLSNhnaxpZ4dK1+l?=
 =?us-ascii?Q?hyekVXpzf592XwDjIxkKgVoR47EVTTlBHhVlpdRX4X+xOIOmqMmyr7LEQCBW?=
 =?us-ascii?Q?K6CRQMmXOQRsZUeGsjUuoyfnt8TThrVzZ44bQLSU5r8qfSWyYHiuAq9wYcl+?=
 =?us-ascii?Q?GZr+38OlzqBVqSsF1YUMXuFfyO1obEFqYIZii0eNfsasFcnnv7z0vR0xg0U3?=
 =?us-ascii?Q?75pMc/JGA6fY073nOfpgozlZHDfSkXVSMQQXwMFW/Po9mhFmgj+GKbVF5K9/?=
 =?us-ascii?Q?y1z9ncIfLimG6oyenoWie+0PYTFFPJZ9cPeZzOhuxYSLy93P9JlQWxchiaD1?=
 =?us-ascii?Q?2yxGMPj9H60s/Tsb4g0TQv0U9dpN8CW3iwlA9QH3dHgdDG4N8DGo+o8Jk7cJ?=
 =?us-ascii?Q?fxnERk5zVd2uY4t0ijh/rsYGbTII6/CGg1vJAXKqhcYEAQwwlaSJUWFgD6BD?=
 =?us-ascii?Q?n0IGipNFqa3TSYPBORGRwpQ+lbJMhJk+N9nIFUZk9r0z/JPlmnufrOoOlx/8?=
 =?us-ascii?Q?742/Gm4OKNDoPzA8thjxoDx1OgmH6HZzwNdv+j4ff7vDJ6lfocConL6bKpuK?=
 =?us-ascii?Q?nRQ/EcK/G/2/Qyc1/CrL7XY9pBoPaDpwf2ktUVD9ED+R+FHl0U7PfznJbMuT?=
 =?us-ascii?Q?MBqXpm9Zno4yovVySTX6FVpgwlyH1LV24VeJUX2f5qqd1TUZoPGgN/UtQMCr?=
 =?us-ascii?Q?hZPZ6UsagJSKnJlovk2fTGaEfvtEtTZdNbuzoOhu8whWjWLkIz4sYCU3l6jK?=
 =?us-ascii?Q?SHgex0XwIWAKKQG5w6ywcxv3NTsAR1CFmvJCcMeemrALewnfqKL2fAJfMY9W?=
 =?us-ascii?Q?ADrskP2qF3VdpCIRLet1mLq6jKe63tg2VhSBDo8TTw3uhVS/1/UAkmoBZb0r?=
 =?us-ascii?Q?jRIdLoFBpA8V0K8joQaannqmzZa4icsg3a1x+XabXXZoAXkjdu8BEnJbr9Nd?=
 =?us-ascii?Q?dE4nSUCF3zw+mzIi5EWvtsz0gChf1ZDD6xmViAUhq4uFmmCyKqKeHTdqUI75?=
 =?us-ascii?Q?qTy7EvXgSWbxqFkGwYmyVHJLNNI3MJ1vSr1YWgJHY80uIt3uQw2N/tNDqXtC?=
 =?us-ascii?Q?Pitx3VdZHatfeJW42R+9ylZJRI6KtWjifW0vDLi9GtP4cBeyQ/yn0BIxYaDa?=
 =?us-ascii?Q?Ma/dwA9W4yNYbqrfVHy+GHgwXNmJkni+/RVC52XyLC6GUAJqH/cJCabXTKJ0?=
 =?us-ascii?Q?T5z42TRifbercqRAKx5fkhAwUAZUPuQjCihu4zMiv8KSNpAb7ZZRDDVa26FR?=
 =?us-ascii?Q?NaU5dOfXdFwAKiMVt3b4zRj34c8gF9sR41eSI5JwxUfv1Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <430C3C9CCC8C094D893CEA58C223A043@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2934.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e604e17-3103-4698-0068-08d983796f10
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 18:46:22.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cjRqMwnl0fONbjGxSunOonvkIMsu2oGi5jGpLb55MNNfta/JOSkKy9+AVDc4TadSgnPscnONQ4v8+CzzF9CPOzg/TewFVjesfYIVosk4c7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5440
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290108
X-Proofpoint-GUID: WAaPTDlIm7ScoBztGIJRIHmGnkfYYeQq
X-Proofpoint-ORIG-GUID: WAaPTDlIm7ScoBztGIJRIHmGnkfYYeQq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 29, 2021, at 4:17 AM, Damien Le Moal <Damien.LeMoal@wdc.com> wrote=
:
>=20
> The modepage argument is unused. Remove it.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> drivers/scsi/scsi_lib.c    | 8 +++-----
> drivers/scsi/sd.c          | 2 +-
> include/scsi/scsi_device.h | 5 ++---
> 3 files changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index dcf105287a76..f1fe5803d7ec 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2001,7 +2001,6 @@ void scsi_exit_queue(void)
>  *	@sdev:	SCSI device to be queried
>  *	@pf:	Page format bit (1 =3D=3D standard, 0 =3D=3D vendor specific)
>  *	@sp:	Save page bit (0 =3D=3D don't save, 1 =3D=3D save)
> - *	@modepage: mode page being requested
>  *	@buffer: request buffer (may not be smaller than eight bytes)
>  *	@len:	length of request buffer.
>  *	@timeout: command timeout
> @@ -2014,10 +2013,9 @@ void scsi_exit_queue(void)
>  *	status on error
>  *
>  */
> -int
> -scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
> -		 unsigned char *buffer, int len, int timeout, int retries,
> -		 struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
> +int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
> +		     unsigned char *buffer, int len, int timeout, int retries,
> +		     struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
> {
> 	unsigned char cmd[10];
> 	unsigned char *real_buffer;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 71fa70b42c2b..89b5eea0ea0c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -209,7 +209,7 @@ cache_type_store(struct device *dev, struct device_at=
tribute *attr,
> 	 */
> 	data.device_specific =3D 0;
>=20
> -	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
> +	if (scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
> 			     sdkp->max_retries, &data, &sshdr)) {
> 		if (scsi_sense_valid(&sshdr))
> 			sd_print_sense_hdr(sdkp, &sshdr);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 09a17f6e93a7..1a9d2fe6aa02 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -415,9 +415,8 @@ extern int scsi_mode_sense(struct scsi_device *sdev, =
int dbd, int modepage,
> 			   int retries, struct scsi_mode_data *data,
> 			   struct scsi_sense_hdr *);
> extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
> -			    int modepage, unsigned char *buffer, int len,
> -			    int timeout, int retries,
> -			    struct scsi_mode_data *data,
> +			    unsigned char *buffer, int len, int timeout,
> +			    int retries, struct scsi_mode_data *data,
> 			    struct scsi_sense_hdr *);
> extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
> 				int retries, struct scsi_sense_hdr *sshdr);
> --=20
> 2.31.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

