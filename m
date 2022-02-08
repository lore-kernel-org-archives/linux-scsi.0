Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E64FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 22:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387347AbiBHWXI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386238AbiBHTtV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:49:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EF1C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:49:20 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218JBBcR026745;
        Tue, 8 Feb 2022 19:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VBwm0bjQmROvYYYOKYOzZcbjspNpdDMm4CQ9oMOGbD4=;
 b=0gM3t+so60VjhpOPhOKEoZAAAeNOwR5967PwdLgoltPPIaf4Vi3ikry1yGlERz61QjaC
 sZtrVReCJZDsvy2OYTFcIUVGg1ZuH9JN4D+hpj9snJ1LUmdPxPU29um5GGTUdoHvFvMP
 VqTuY3i+iSzHQ8KsWxDrGNSbfga3upKwRgP3u1gveDdRVZz1AkNKPshze9FRRXfED13s
 /sbLYZXA0rfFM0P+SR4MqTj9nAtXIs0zdm417oX2+8p/qMd4Euiq0jM/OlfAoWysb8ND
 m0k9rZoZpgS8oXWAtDtVEjNiORO1MyPPq7HWuje8MFymXHK4SvsLFKfcktQK4Gn3YLFu YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28jdw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:48:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218JjYaO195499;
        Tue, 8 Feb 2022 19:48:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3020.oracle.com with ESMTP id 3e1h26w377-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:48:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZJ8a0DFJdB7gyvNuFd85lZQ/Q3L5t+nvJXRJv4J6o4iBbTtp3dkseEqINtiXz0rmFapJjjm2fDJTCJG6rFb6I56wxzCNVqf60dfU6GbAf099sk8i2hBOkm5pt/DJO7KK0gNq7wK9YPAtJlj8VYv3pwmWPBPTRMOz6M40z/0nX9s/jtWcHF8cQUPlpZvUiy3vHNBRk1Qowcodb8O0cPn+68y7Rl/ntT9CLkKYE93vqssDyn3nH1me3g2JV0kW3d1ILyp6TKGBHBZiLUZ//KuC/ZO5bqknU/PXD7oX63p7V8eW3RB36ZP3Egv57/qZEzQrp6BZq2IPoOdluF22EQskg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBwm0bjQmROvYYYOKYOzZcbjspNpdDMm4CQ9oMOGbD4=;
 b=W+I83ls+mb/OoSNfn2OqLhKuDU9Thw2lyjvBGxEmxrcAWoPfHmF2/DM3Ea5tJ0bQYp5/TNKczvdoRBXuoSRJHOV+t/jSqW/nOYnCjutQofMgoe2tOaAm98JzNsp07VwnttgXV4jJVTXHnq550PYhtLOpQTGmY0Ed7CARnK9FbCvCoMs/FClOjWGLqlbLZ/AsgG22wX/AVxwagSG9tDxA88ydM7GZZ9uALb2LqZ2mbafDcbrAdeeosYZGVIWUcraksQshkEJhnEmuoomv9+9kaGNSDT84LqbF7FxRyGd/+1jIKF8YENK88PU2lg85sgte6R2Ir/F1JHD9u0vSKq9vGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBwm0bjQmROvYYYOKYOzZcbjspNpdDMm4CQ9oMOGbD4=;
 b=0JBHe+YSdFdvsGZKZsijDpw+ttfnNy95clf2lScUHoXccnRk3kuo/4U8IEV+KC1qjH+JKET192XD11Z8JJpFFTrcM/jFORI+Nn3DDFoNG9a5OsR0vFDOSVrKJgpVwg9Db0hciznEQVCZG/QpAwofS//SFnjwd9GC1neP2l8JVRg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3532.namprd10.prod.outlook.com (2603:10b6:5:17c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Tue, 8 Feb
 2022 19:48:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:48:41 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 05/44] NCR5380: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 05/44] NCR5380: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHREheQaLWRo10EGCGgZrJy1SJqyKD5yA
Date:   Tue, 8 Feb 2022 19:48:41 +0000
Message-ID: <DA7E3B58-D79D-479C-8B1E-4103AA17902F@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-6-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9b6d5ad-790a-4234-e7d0-08d9eb3c0252
x-ms-traffictypediagnostic: DM6PR10MB3532:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3532C37FAC22B79218EDC0CFE62D9@DM6PR10MB3532.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:339;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4bp1nb6R3zvexdjIzlAA2v6y5jfykTpQ7GjkuAYNfOej9N21mg9K8l6jjhaEDuFqf8yIxZtJXnpxmtWKizVFdMBBaDyYM0sYOeHdfwmXLdY4sJZtBSzFc/qjBpb+JfDzdF1sj3DEXt4Suud7FVz7md5Z8LCeWAJSawQJpSS+B6ciW0eXH156SQMpo8wt1Qqvk9CvEz3KJRCHTdJDCJv9Z5/nLoj5P5g788UbHd/RYlfuJW7FKESgazVbxHnVD8g4xu7mCm74UMyGN5JiVDWDEygQNUu+Fm0n/WwkpLpk/dRjX0c3/9m3GlsaGCjpsiPS5d3lLYAu8bX8xTG9R0fh61J3lZS5WhkOX21I/KbywK/jYXTw2Jo3SaHxx7wLaeatMwP7jLW3BCZ5y9NPPhwnTG8Jal16It/0rout0XY3w0su+3TJ3P4SuUL9LWbVe3pqSMMs0yzeXgVhPeNFZ09EZqXD42Cohkke0Odm5ExRhWcydknm2MVHqYHS75kvbqscPIp6mxrIEoJ+0/GGRbaEKc5s1FKwSA5mdp2Mjdr6zuBpHU5JVLOhjk62lxl8Wc1ZUNWyPYHqOKEg6TdATahYWsFZRoiH5ksO+yzs/5fpNYRnF+nBT3N1Drp/ODOozQV/1rBOoWQtEoseJTXDsWjyKEBg82QFkhXOZyfgfDeLPfEiqrcFM+hMAzc0TMUAqN1ZZv4h2Ow9f3hKMoJDVTYg6/QHfjFEOlfpug/0wn76ndXtz4H1s6F7WykTdxoAPux/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6486002)(508600001)(38100700002)(53546011)(6512007)(4326008)(8936002)(38070700005)(36756003)(6506007)(2906002)(83380400001)(8676002)(44832011)(26005)(5660300002)(86362001)(122000001)(66946007)(91956017)(30864003)(2616005)(66556008)(71200400001)(33656002)(316002)(186003)(6916009)(66476007)(66446008)(64756008)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KauDtVqaZxT0o9BaYq1E+CdAG4mIB4fPbubWzI3RMj2O8oQHiOQvKDmssYE2?=
 =?us-ascii?Q?lFmlEanNlw+8oyEdMcHTN2aLV+GlLO+Fe4BUIYCDO60k0i5zrv2XU0sZ/HIO?=
 =?us-ascii?Q?Nx1lgFUHdQbMw+pwl8LxYwTpJF6avQfQovgpAT/lwmAUb+z80jtuxuDBVMe8?=
 =?us-ascii?Q?XlRO5dtb7UYYb6WrTMkVAaaZ76ueJ9WK+J7hCN59aOjUa5EUkbd7sTRKI0IG?=
 =?us-ascii?Q?slckhiCe1rmi5mWKQeaosHGPIKaNdiqu0FEaCbm1ljG+T8miYP2jqLG/Upoi?=
 =?us-ascii?Q?Gmejbl3PVcMPZ7oQ7VMjNE9mhzzccufnwp6OS6LFS6BtlhU1AU8EcqktvbHK?=
 =?us-ascii?Q?T4vE6UDMKWAQsyS1w/IKmmAsL4m0g7mDfolwQJsqy8vKqGdb562NzsldnTGS?=
 =?us-ascii?Q?eI8L8z04/+CZbByPejyYGYTbj5YYd8jkZt1l3Vb+jhO2JZLqXbmiLZLme1Qg?=
 =?us-ascii?Q?Gv7OYmkYIBVTa+uFDdwivtfnjkotVgagLcvxZWDQpAoAWPbMB7jSNzY/oEnP?=
 =?us-ascii?Q?5plmGPODI8EsjRHLxNrdKUMkwaR8vuBWDz9UbR3j5jZxMtE4pfI6d4ba/IZ9?=
 =?us-ascii?Q?/C+0OJrO1h2NJIw2rQT567nkyHZTcPBILxKeWBllcYZtpZTgH68IIJRxRsjH?=
 =?us-ascii?Q?GDZ0kJ0ajrz3h+JzNH+5+ChDMrenMO+0Zglc03gry/ArbU1JKAcEp4a5zRgt?=
 =?us-ascii?Q?P7rj3dxcy8wpRR/PiMWXiwFoEef5HxrYyPP6oJqFT6YIVfnZRqIse4qnrYBN?=
 =?us-ascii?Q?sZ/6k7hfLnmvJ2BU+QV6MRunYMPox8X7dbr+ZvXww8F9pNP4Tg2e4n3az9Xc?=
 =?us-ascii?Q?ibPm3O5EBeUOCf23czwDlRyRqU37jGMb4sjcwDWHJOLLay/5RGO4MNxdAkDc?=
 =?us-ascii?Q?yUDXcpRrEhAL0ccvSc9WkWb5sTAXSLhhQsRrcvl2wTaSloQRRgr7F8te8Jwr?=
 =?us-ascii?Q?OUuK+UfEPrbbuC8i2DdqIyi37H3/J8ItxAIYfTl6wMd8GYQMxx1jocT7dkmG?=
 =?us-ascii?Q?1lTvJFpUTzftBav9dkDsmvy/A6Ez6kKvZtwyfVW4OaRJcs1YOmtC0LaMdZg2?=
 =?us-ascii?Q?0M93GrSKTeAVsPe+MTbjn+RXvjszBZhCajDxyva8U8i09E8y8ufQ5z8jByfG?=
 =?us-ascii?Q?X8lz57A0cRYrTLoBwxKvgN/u5v7t/l/x3aLxCIpzw0v1VrwdzYY0PjH2ImA+?=
 =?us-ascii?Q?XueiWIBWfhwhjuEbfhCcZE6w1XHxUQWt4owIZ1gqyibcRd0NeABBlGowr/Lu?=
 =?us-ascii?Q?L2338FQF3Aupecnq8SkEFPcIqfUlM3Sjy7lnzqiF/G+ubUNE8yCvZcCuIwai?=
 =?us-ascii?Q?byZ2jxyVWm8RInpRbE0nk6bTLYCHum94+D9GUIJH3CKIL+RUXL6YRNa/ta0j?=
 =?us-ascii?Q?N0FF96wd6zpCfp/SnS1fRW9qKRepno4ITtVUDv++5VUuAdZzRN65F2CMe5rg?=
 =?us-ascii?Q?bX9Fn4mxfatZol/PnVWQqtnPjD47/xWiQOWQVK4K+tqBrnq70Uq/M4vRUlWS?=
 =?us-ascii?Q?h7QW+j2udBHJCV6tyouL5N5kZZzVsKzTHnv3R9tpX+M5khEB12h+qB98hPxq?=
 =?us-ascii?Q?/f9nCoHbv4gmaEHUuWE0a9MQG3qOSAdWe6nqISpUxV0KoYMy9KuUicgV/wdj?=
 =?us-ascii?Q?hvJOw1/QhCYKWrk38RT+aAEW/jDkowADXcHVgL5fLpbp7he5F3GTUrxPnKHP?=
 =?us-ascii?Q?cqi5JwrcFpi8dXVSGyikJK5cJrA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5C0C76694796424AB7D1795958A5CB5F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b6d5ad-790a-4234-e7d0-08d9eb3c0252
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:48:41.7470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yRISVoAwW9lNCRQc4e8HpOZN5fSlKpbkTqywX4qKfYXlzNH5kptSSEWq2l6mc/XGcfINqCz317rIHJ7k3DC2aPuBs5jloOvSn6fHepgQ0AY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3532
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080116
X-Proofpoint-ORIG-GUID: QBz8EpO0DckPeQnynBL9vSzvrMBdNWTp
X-Proofpoint-GUID: QBz8EpO0DckPeQnynBL9vSzvrMBdNWTp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Move the SCSI pointer into the NCR5380 private command data instead of
> using the SCSI pointer from struct scsi_cmnd. This patch prepares for
> removal of the SCSI pointer from struct scsi_cmnd.
>=20
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/NCR5380.c    | 83 +++++++++++++++++++++++----------------
> drivers/scsi/NCR5380.h    |  8 ++++
> drivers/scsi/atari_scsi.c |  6 ++-
> drivers/scsi/g_NCR5380.c  |  5 ++-
> drivers/scsi/mac_scsi.c   |  6 ++-
> drivers/scsi/sun3_scsi.c  |  3 +-
> 6 files changed, 70 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 55af3e245a92..73c1b2ec6214 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -145,40 +145,44 @@ static void bus_reset_cleanup(struct Scsi_Host *);
>=20
> static inline void initialize_SCp(struct scsi_cmnd *cmd)
> {
> +	struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(cmd);
> +
> 	/*
> 	 * Initialize the Scsi Pointer field so that all of the commands in the
> 	 * various queues are valid.
> 	 */
>=20
> 	if (scsi_bufflen(cmd)) {
> -		cmd->SCp.buffer =3D scsi_sglist(cmd);
> -		cmd->SCp.ptr =3D sg_virt(cmd->SCp.buffer);
> -		cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
> +		scsi_pointer->buffer =3D scsi_sglist(cmd);
> +		scsi_pointer->ptr =3D sg_virt(scsi_pointer->buffer);
> +		scsi_pointer->this_residual =3D scsi_pointer->buffer->length;
> 	} else {
> -		cmd->SCp.buffer =3D NULL;
> -		cmd->SCp.ptr =3D NULL;
> -		cmd->SCp.this_residual =3D 0;
> +		scsi_pointer->buffer =3D NULL;
> +		scsi_pointer->ptr =3D NULL;
> +		scsi_pointer->this_residual =3D 0;
> 	}
>=20
> -	cmd->SCp.Status =3D 0;
> -	cmd->SCp.Message =3D 0;
> +	scsi_pointer->Status =3D 0;
> +	scsi_pointer->Message =3D 0;
> }
>=20
> static inline void advance_sg_buffer(struct scsi_cmnd *cmd)
> {
> -	struct scatterlist *s =3D cmd->SCp.buffer;
> +	struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(cmd);
> +	struct scatterlist *s =3D scsi_pointer->buffer;
>=20
> -	if (!cmd->SCp.this_residual && s && !sg_is_last(s)) {
> -		cmd->SCp.buffer =3D sg_next(s);
> -		cmd->SCp.ptr =3D sg_virt(cmd->SCp.buffer);
> -		cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
> +	if (!scsi_pointer->this_residual && s && !sg_is_last(s)) {
> +		scsi_pointer->buffer =3D sg_next(s);
> +		scsi_pointer->ptr =3D sg_virt(scsi_pointer->buffer);
> +		scsi_pointer->this_residual =3D scsi_pointer->buffer->length;
> 	}
> }
>=20
> static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
> {
> -	int resid =3D cmd->SCp.this_residual;
> -	struct scatterlist *s =3D cmd->SCp.buffer;
> +	struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(cmd);
> +	int resid =3D scsi_pointer->this_residual;
> +	struct scatterlist *s =3D scsi_pointer->buffer;
>=20
> 	if (s)
> 		while (!sg_is_last(s)) {
> @@ -757,6 +761,7 @@ static void NCR5380_main(struct work_struct *work)
> static void NCR5380_dma_complete(struct Scsi_Host *instance)
> {
> 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
> +	struct scsi_pointer *scsi_pointer;
> 	int transferred;
> 	unsigned char **data;
> 	int *count;
> @@ -764,7 +769,10 @@ static void NCR5380_dma_complete(struct Scsi_Host *i=
nstance)
> 	unsigned char p;
>=20
> 	if (hostdata->read_overruns) {
> -		p =3D hostdata->connected->SCp.phase;
> +		struct scsi_pointer *scsi_pointer =3D
> +			NCR5380_scsi_pointer(hostdata->connected);
> +
> +		p =3D scsi_pointer->phase;
> 		if (p & SR_IO) {
> 			udelay(10);
> 			if ((NCR5380_read(BUS_AND_STATUS_REG) &
> @@ -801,8 +809,9 @@ static void NCR5380_dma_complete(struct Scsi_Host *in=
stance)
> 	transferred =3D hostdata->dma_len - NCR5380_dma_residual(hostdata);
> 	hostdata->dma_len =3D 0;
>=20
> -	data =3D (unsigned char **)&hostdata->connected->SCp.ptr;
> -	count =3D &hostdata->connected->SCp.this_residual;
> +	scsi_pointer =3D NCR5380_scsi_pointer(hostdata->connected);
> +	data =3D (unsigned char **)&scsi_pointer->ptr;
> +	count =3D &scsi_pointer->this_residual;
> 	*data +=3D transferred;
> 	*count -=3D transferred;
>=20
> @@ -1487,6 +1496,8 @@ static int NCR5380_transfer_dma(struct Scsi_Host *i=
nstance,
> 				unsigned char **data)
> {
> 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
> +	struct scsi_pointer *scsi_pointer =3D
> +		NCR5380_scsi_pointer(hostdata->connected);
> 	int c =3D *count;
> 	unsigned char p =3D *phase;
> 	unsigned char *d =3D *data;
> @@ -1498,7 +1509,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *i=
nstance,
> 		return -1;
> 	}
>=20
> -	hostdata->connected->SCp.phase =3D p;
> +	scsi_pointer->phase =3D p;
>=20
> 	if (p & SR_IO) {
> 		if (hostdata->read_overruns)
> @@ -1691,6 +1702,7 @@ static void NCR5380_information_transfer(struct Scs=
i_Host *instance)
>=20
> 	while ((cmd =3D hostdata->connected)) {
> 		struct NCR5380_cmd *ncmd =3D scsi_cmd_priv(cmd);
> +		struct scsi_pointer *scsi_pointer =3D &ncmd->scsi_pointer;
>=20
> 		tmp =3D NCR5380_read(STATUS_REG);
> 		/* We only have a valid SCSI phase when REQ is asserted */
> @@ -1712,10 +1724,10 @@ static void NCR5380_information_transfer(struct S=
csi_Host *instance)
> 				if (count > 0) {
> 					if (cmd->sc_data_direction =3D=3D DMA_TO_DEVICE)
> 						sun3scsi_dma_send_setup(hostdata,
> -						                        cmd->SCp.ptr, count);
> +						                        scsi_pointer->ptr, count);
> 					else
> 						sun3scsi_dma_recv_setup(hostdata,
> -						                        cmd->SCp.ptr, count);
> +						                        scsi_pointer->ptr, count);
> 					sun3_dma_setup_done =3D cmd;
> 				}
> #ifdef SUN3_SCSI_VME
> @@ -1758,8 +1770,8 @@ static void NCR5380_information_transfer(struct Scs=
i_Host *instance)
> 				advance_sg_buffer(cmd);
> 				dsprintk(NDEBUG_INFORMATION, instance,
> 					"this residual %d, sg ents %d\n",
> -					cmd->SCp.this_residual,
> -					sg_nents(cmd->SCp.buffer));
> +					scsi_pointer->this_residual,
> +					sg_nents(scsi_pointer->buffer));
>=20
> 				/*
> 				 * The preferred transfer method is going to be
> @@ -1778,7 +1790,7 @@ static void NCR5380_information_transfer(struct Scs=
i_Host *instance)
> 				if (transfersize > 0) {
> 					len =3D transfersize;
> 					if (NCR5380_transfer_dma(instance, &phase,
> -					    &len, (unsigned char **)&cmd->SCp.ptr)) {
> +					    &len, (unsigned char **)&scsi_pointer->ptr)) {
> 						/*
> 						 * If the watchdog timer fires, all future
> 						 * accesses to this device will use the
> @@ -1794,13 +1806,13 @@ static void NCR5380_information_transfer(struct S=
csi_Host *instance)
> 					/* Transfer a small chunk so that the
> 					 * irq mode lock is not held too long.
> 					 */
> -					transfersize =3D min(cmd->SCp.this_residual,
> +					transfersize =3D min(scsi_pointer->this_residual,
> 							   NCR5380_PIO_CHUNK_SIZE);
> 					len =3D transfersize;
> 					NCR5380_transfer_pio(instance, &phase, &len,
> -					                     (unsigned char **)&cmd->SCp.ptr,
> +					                     (unsigned char **)&scsi_pointer->ptr,
> 							     0);
> -					cmd->SCp.this_residual -=3D transfersize - len;
> +					scsi_pointer->this_residual -=3D transfersize - len;
> 				}
> #ifdef CONFIG_SUN3
> 				if (sun3_dma_setup_done =3D=3D cmd)
> @@ -1811,7 +1823,7 @@ static void NCR5380_information_transfer(struct Scs=
i_Host *instance)
> 				len =3D 1;
> 				data =3D &tmp;
> 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
> -				cmd->SCp.Message =3D tmp;
> +				scsi_pointer->Message =3D tmp;
>=20
> 				switch (tmp) {
> 				case ABORT:
> @@ -1828,15 +1840,15 @@ static void NCR5380_information_transfer(struct S=
csi_Host *instance)
> 					hostdata->connected =3D NULL;
> 					hostdata->busy[scmd_id(cmd)] &=3D ~(1 << cmd->device->lun);
>=20
> -					set_status_byte(cmd, cmd->SCp.Status);
> +					set_status_byte(cmd, scsi_pointer->Status);
>=20
> 					set_resid_from_SCp(cmd);
>=20
> 					if (cmd->cmnd[0] =3D=3D REQUEST_SENSE)
> 						complete_cmd(instance, cmd);
> 					else {
> -						if (cmd->SCp.Status =3D=3D SAM_STAT_CHECK_CONDITION ||
> -						    cmd->SCp.Status =3D=3D SAM_STAT_COMMAND_TERMINATED) {
> +						if (scsi_pointer->Status =3D=3D SAM_STAT_CHECK_CONDITION ||
> +						    scsi_pointer->Status =3D=3D SAM_STAT_COMMAND_TERMINATED) {
> 							dsprintk(NDEBUG_QUEUES, instance, "autosense: adding cmd %p to tai=
l of autosense queue\n",
> 							         cmd);
> 							list_add_tail(&ncmd->list,
> @@ -2000,7 +2012,7 @@ static void NCR5380_information_transfer(struct Scs=
i_Host *instance)
> 				len =3D 1;
> 				data =3D &tmp;
> 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
> -				cmd->SCp.Status =3D tmp;
> +				scsi_pointer->Status =3D tmp;
> 				break;
> 			default:
> 				shost_printk(KERN_ERR, instance, "unknown phase\n");
> @@ -2151,6 +2163,7 @@ static void NCR5380_reselect(struct Scsi_Host *inst=
ance)
>=20
> #ifdef CONFIG_SUN3
> 	if (sun3_dma_setup_done !=3D tmp) {
> +		struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(tmp);
> 		int count;
>=20
> 		advance_sg_buffer(tmp);
> @@ -2160,10 +2173,12 @@ static void NCR5380_reselect(struct Scsi_Host *in=
stance)
> 		if (count > 0) {
> 			if (tmp->sc_data_direction =3D=3D DMA_TO_DEVICE)
> 				sun3scsi_dma_send_setup(hostdata,
> -				                        tmp->SCp.ptr, count);
> +				                        scsi_pointer->ptr,
> +							count);
> 			else
> 				sun3scsi_dma_recv_setup(hostdata,
> -				                        tmp->SCp.ptr, count);
> +				                        scsi_pointer->ptr,
> +							count);
> 			sun3_dma_setup_done =3D tmp;
> 		}
> 	}
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 845bd2423e66..adaf131aea4d 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -227,9 +227,17 @@ struct NCR5380_hostdata {
> };
>=20
> struct NCR5380_cmd {
> +	struct scsi_pointer scsi_pointer;
> 	struct list_head list;
> };
>=20
> +static inline struct scsi_pointer *NCR5380_scsi_pointer(struct scsi_cmnd=
 *cmd)
> +{
> +	struct NCR5380_cmd *ncmd =3D scsi_cmd_priv(cmd);
> +
> +	return &ncmd->scsi_pointer;
> +}
> +
> #define NCR5380_PIO_CHUNK_SIZE		256
>=20
> /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during =
PDMA */
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index e9d0d99abc86..61fd3244a4ce 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -538,7 +538,8 @@ static int falcon_classify_cmd(struct scsi_cmnd *cmd)
> static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                    struct scsi_cmnd *cmd)
> {
> -	int wanted_len =3D cmd->SCp.this_residual;
> +	struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(cmd);
> +	int wanted_len =3D scsi_pointer->this_residual;
> 	int possible_len, limit;
>=20
> 	if (wanted_len < DMA_MIN_SIZE)
> @@ -610,7 +611,8 @@ static int atari_scsi_dma_xfer_len(struct NCR5380_hos=
tdata *hostdata,
> 	}
>=20
> 	/* Last step: apply the hard limit on DMA transfers */
> -	limit =3D (atari_dma_buffer && !STRAM_ADDR(virt_to_phys(cmd->SCp.ptr)))=
 ?
> +	limit =3D (atari_dma_buffer &&
> +		 !STRAM_ADDR(virt_to_phys(scsi_pointer->ptr))) ?
> 		    STRAM_BUFFER_SIZE : 255*512;
> 	if (possible_len > limit)
> 		possible_len =3D limit;
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 5923f86a384e..fb39a656fd15 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -663,7 +663,8 @@ static inline int generic_NCR5380_psend(struct NCR538=
0_hostdata *hostdata,
> static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata=
,
>                                         struct scsi_cmnd *cmd)
> {
> -	int transfersize =3D cmd->SCp.this_residual;
> +	struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(cmd);
> +	int transfersize =3D scsi_pointer->this_residual;
>=20
> 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
> 		return 0;
> @@ -675,7 +676,7 @@ static int generic_NCR5380_dma_xfer_len(struct NCR538=
0_hostdata *hostdata,
> 	/* Limit PDMA send to 512 B to avoid random corruption on DTC3181E */
> 	if (hostdata->board =3D=3D BOARD_DTC3181E &&
> 	    cmd->sc_data_direction =3D=3D DMA_TO_DEVICE)
> -		transfersize =3D min(cmd->SCp.this_residual, 512);
> +		transfersize =3D min(scsi_pointer->this_residual, 512);
>=20
> 	return min(transfersize, DMA_MAX_SIZE);
> }
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 71d493a0bb43..f31da6106b72 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -404,11 +404,13 @@ static inline int macscsi_pwrite(struct NCR5380_hos=
tdata *hostdata,
> static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                 struct scsi_cmnd *cmd)
> {
> +	struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(cmd);
> +
> 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
> -	    cmd->SCp.this_residual < setup_use_pdma)
> +	    scsi_pointer->this_residual < setup_use_pdma)
> 		return 0;
>=20
> -	return cmd->SCp.this_residual;
> +	return scsi_pointer->this_residual;
> }
>=20
> static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index 82a253270c3b..50cbffbf2dd1 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -334,7 +334,8 @@ static int sun3scsi_dma_residual(struct NCR5380_hostd=
ata *hostdata)
> static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                  struct scsi_cmnd *cmd)
> {
> -	int wanted_len =3D cmd->SCp.this_residual;
> +	struct scsi_pointer *scsi_pointer =3D NCR5380_scsi_pointer(cmd);
> +	int wanted_len =3D scsi_pointer->this_residual;
>=20
> 	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(scsi_cmd_to_rq(cm=
d)))
> 		return 0;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

