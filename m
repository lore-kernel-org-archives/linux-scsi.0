Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC43C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiACAnY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:43:24 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3412 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:43:23 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029AFrZ031706;
        Mon, 3 Jan 2022 00:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=I1lB0ixbIIA7SSuPCRt7CGwKDYBlG5iQWG4X4LEbWJ4=;
 b=shNapc2foQwPtxgQw8lZDznkuHMJg+2XHuj/0VCxrumvRk63A9o1OplDbS3CZ5KgvtHr
 9igODeiozfUUALFL4un8kfe608gX+1Rqy3cAMTKYCADlldz5aeGdrwff2c4ZY4AeQVxh
 jkv243wWgaYovv4ZBglb6jUAcCNjXjSiamKXvxD3eZvbEpL1/VOnEFWWGWisOpU74zWD
 hRr+MLd1yMGkK7Onlr8rVVfrODL5GtPQDhPguOt89RcrbYrYdiOwFfDkwNmHEg8v8ukH
 FKSuoobWuvK0PgHwJgd7LReUtCBiHOBAc3ZcqAl1yZW/uDQ45CGa/nlnKFTKZyhBTtbt cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daejshpxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:43:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030fvr5176499;
        Mon, 3 Jan 2022 00:43:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by aserp3030.oracle.com with ESMTP id 3dad0bfrq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:43:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfoRq5CufuqSah0DLljUrpw2f6hwRBBzGgsiHC1C14KlLgwW1FFpdCsD6gmH4FQAdk196S5pw5puoe+4i3aSgkmSsN0sDArUkEUAzWAf0fJg/RHWUmwTWilu+CCFGvWe3Omd0tzyP4cW1i6h1lazXP8BWW69ZnOUE4GUDirwFP9KQYpaYIUoakaamSxxttnVmOtUyMTW4c+Ufd9a8JpBWWMLFPWOyydisBHfgGQFwnDgZm7U33oMHubACpsGTlrrXEgpEyCugfDRWH/q5Au2S2+nwhYKOpYxyyvzvN+3ByyZ2Jboe97vw0UudW/Nk0OMc+LejJ7lJb2OjqKZJWxxGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1lB0ixbIIA7SSuPCRt7CGwKDYBlG5iQWG4X4LEbWJ4=;
 b=cVIwmU2DAg16WZO+bGMMYKkWKg/P1J1LCymmMn/q2j2ZttbiSTh7pIxbGMuioB6CxVOcRgxabmizvEqN2H6kkzeBJdtWXz3e8jmLtlU5GD3qjZxdqZIqZ3D8dZhkszhtCTS4Nq4zVh8x6b/aCxEmFN6YXgfrQXIFnd/Sjp8+rQh78j83DE3YYbZDi8Gh6o+gJVNPJql9SQ3r9tUFS0YOh98K0Sm2Sr04UiWOIg3WWcIf4TlEA/kVBYp8boW/dm6V/p2E/d665kaUNkp1JoJYU4+MlO2IVW2zQFaxYezi3ArbfirNHk23Dkh/V5/vhYRMlyJdzru6nNFqoTnV6qgUkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1lB0ixbIIA7SSuPCRt7CGwKDYBlG5iQWG4X4LEbWJ4=;
 b=lLnSD2D2+6D9f3P7FP8tJw2vxoaCa5PMgShU9eIS+XO9/sKEEkp03MgaLfC3RXLr5GfteXekpxjWfod8P5MyOb4kdb8TQTtK6EL+wf0n6SHZKc8O6d+e4TVl0iz/FKhAgpU39165AcdsfWDRIobo8yaYP3T8y7G3IgF9HL9OMLw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Mon, 3 Jan
 2022 00:43:18 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:43:18 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 08/16] qla2xxx: Show wrong FDMI data for 64G adaptor
Thread-Topic: [PATCH 08/16] qla2xxx: Show wrong FDMI data for 64G adaptor
Thread-Index: AQHX+JUJkVN3ww7xIEao5BRZLTGnw6xQhKIA
Date:   Mon, 3 Jan 2022 00:43:18 +0000
Message-ID: <016F0E49-9A80-4302-8BF8-C0214AAD7F41@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-9-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e14d45b5-42c3-4627-e768-08d9ce520922
x-ms-traffictypediagnostic: SA2PR10MB4537:EE_
x-microsoft-antispam-prvs: <SA2PR10MB4537AF951864D3163DC01B8BE6499@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /skzDAEDqsPa5z+pWZfCpDMCS9E0fbXxU7/PxQPRQ96QXs6wgk3o9FDvqDnFXy10K4CEtfDXmi1KQmAAuitqNmbr/+HN//eDwUHMsSOLSJJIg28ztIfhZhlb0JlO/1U6v+55+KmX9lq6khlv2zbVBlRuzfipZNg5KI7XLMvdbFGl/F4T03wuorL9fBq2P4nsBrnNj/hvFugeHcl9Sa6/aZEtL+axT4FSQjnweO2B+stu+MFwsDmLZqCO+2RQN5JNt2DXKM8OoiSMMjM1qq/bLk/74e6eFBot+IK3MkML7dzMJ+5Ygy8ObvP8JpZflAL1xcMFbfuS0/9cZvFyh78nYRu0XSVQ11bN3Tm8V14m7BvCL2cXAQDIvBSUZmHH0cBreCRbBIczqSE4X/Oc7TGCLod6PhQISoM+Gd2y93tD5I8Emkh9pA5HWPRzY9eB/NAUM/PXGKVwgFT26Q4Ognv0dTZjFOctKqZSxztE1cUPv6YcQgNArdPnML5+144x3KXleYEHSqja6YfcM+2Ifq3Z2d9AyO5sXqggj6sh+aaoBTyT/FavczIxp81oRBEM/ChAwAUSecauKnlXPTUudDt3NmdORdUS3/O/X4q4CvKpcb1sNuU4m7sFpNBL/f2sjauXw/CmdV5iuNqtpJkKJQmL9UKLL0PkWM56dlHSNcG8gto2yy+CslBwpNNCwzZxbkGja8XlAtZS93AoRsiTi81bkPRYXuF2vwmQLHGSP57FkfA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(8936002)(6916009)(66946007)(2906002)(76116006)(6486002)(86362001)(36756003)(83380400001)(26005)(508600001)(316002)(33656002)(4326008)(71200400001)(38100700002)(186003)(122000001)(54906003)(8676002)(44832011)(6506007)(2616005)(6512007)(53546011)(5660300002)(64756008)(66446008)(66556008)(66476007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B6uGKnZ3UCxGa0HaIerzsra/KUtkhwT0IrwOhmLD4bOhBuXfA8iWU4wueQnT?=
 =?us-ascii?Q?aT3GNbcu2Jgu3mtdVlbcIJLiGYNp3rs27ZCE18vM5bKUIrt8Qz5gRFhTIoc6?=
 =?us-ascii?Q?WH7F/ClP3R//M9jkTWj1XILrEPCDdMORnNky4MZuuWZLx72hoTpJ7BrCYZZQ?=
 =?us-ascii?Q?RCxiJ8Fn8KDPdYMhC9EGTUdXR9NdQfjla25hvUeqs/PwkfmsyWCs4XXg77wh?=
 =?us-ascii?Q?pVpLcR1AW2QGF1k+SyAl8bzlSBmAfZWjfgclXcyiH4T5HI52x/9Xps8QWs/m?=
 =?us-ascii?Q?MO15UdWffilZ/Jftb4s4W2kPOu6lQEMnG4e9TslCGhxcT35WvPLxEb01cOjw?=
 =?us-ascii?Q?db9Hj74tjczVw94OsWoEuFqvoIJ4EmVZtZBV407rhSHVPv6TTn6ZqvLGGmqv?=
 =?us-ascii?Q?cFZ75cvIPG43dmvw0JAHEwW27mCPrb3mAHDRnPPIZHIPCNJSh7StULdKJw1n?=
 =?us-ascii?Q?O8iqxceMI1DPLCL70AwmpR8rTDjgGfICSkZ3Jv78dl6Foz6dcxPLbRQFCj6/?=
 =?us-ascii?Q?+s9S7Rdn3oTwiE0Ih3yh+Gu9akJIs6EXj6tyMePLJ4nu6IL9neu47mn/Ijj0?=
 =?us-ascii?Q?0Qj+gx4uSxCS5ZM6FWjAXicPiuitDeunDF5HsFhfRNanDR10JgNlXqVkBUNk?=
 =?us-ascii?Q?umdJOpsn3fQN0MLGgl8V5cRpdTPOStkbs+HPkRAYp6MODvLtXVqs7OLJ7FFE?=
 =?us-ascii?Q?5Xi0giz0EtagDKWvrFqbCs3xWaXOwzBFfc77siv4GGXBYpifs+v4N2lxA+U0?=
 =?us-ascii?Q?OWY691DWELjfbfx+KRjCCiR0ulZDwQjlGY7qyzzeSb8rP2xvmNDeB6H40Qxe?=
 =?us-ascii?Q?KIibDWe1ZxoQaTKGSFhboUB9GYwyDssgc3z3m67+pLnzEgweUwj7W3HnlB1m?=
 =?us-ascii?Q?RlFKeG3ey0GiJd0pca7gYvPQN5kXH0qpLI1V1h1van6e/vmrFUO4qey71Fgq?=
 =?us-ascii?Q?dxy7vnakK5tLlRbUAXsQ6fXlW3pilykmXc3WTEe3G1M9jBvyzIocju60a/yL?=
 =?us-ascii?Q?VuMs9GrXO2b0TWi96Fh+Dmmfkxnj9zXLPlYWCOwDna5/f6B519mJiViTP2kO?=
 =?us-ascii?Q?K5PipX+LwLDnW9y+CiOyZy2HCp+odrwXub6PB4QBsMiAzhOhzRgN3GfSGTZo?=
 =?us-ascii?Q?HZfXgQ+W1fxsAbc5Lfimbg/KBEggf/4jyFdXYE63UYAn3/dNybBA3ymgzdmG?=
 =?us-ascii?Q?U6PByXdextLdT6/gqxO3DfrNgibtiD55OhUfi9KkIIGcXU32JFHvQpMcaRI5?=
 =?us-ascii?Q?noT1/id9QSxhIlu4aPfOzjOTSHCT12i+ASqxk91+FPo00MON9cco4m5XOoBH?=
 =?us-ascii?Q?ZHZH/eSOKg9Ff7dZfm9eY69N7sF2cCR/k8bERUsGOmYcMcoJIH0CeNiKqd/2?=
 =?us-ascii?Q?eepYNc6tZhsQdXGzFhG+FZhNwIpfnXPcz6ABY6KRVAmAh4im6OdauUW0S0Fr?=
 =?us-ascii?Q?rG+Nzzub2TO/U01PEl3suweRVnbi5YMSMGFzPJNUQeEIMHOv6TvTSZdZGERx?=
 =?us-ascii?Q?IyhabPMcJl/okk/xV4sMUMHqATosIbluNN49LSL6U7m2fOlFQ7/7k70tsRBE?=
 =?us-ascii?Q?I7nfAw1uD4+jkzZVur49n6XHmQRRDAL4pNCO7YITjRsv9dVBcu2an+WY43ll?=
 =?us-ascii?Q?pUYMwocW//hWjg0h8uSyhC3nd+3bj3Q9DGaj4LmF9TPz22bGKYxb6DsYilOT?=
 =?us-ascii?Q?oZ2LGpqy9kYUWzl4SJd6EJIzOSA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C92728D64C0EF64EBADD15DCFEF3C1B7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14d45b5-42c3-4627-e768-08d9ce520922
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:43:18.5245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m78tvi/SoK0RXYA4Pnrj04nHmGvy04wCuEmebyUa2zgM34SM6yDxrocSP2o3kJHnOYhAhwqigVE8RIqSg0ABtIQjAl4TjBI7dxrZFkh1pgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-ORIG-GUID: BIFIj9dFrKgxgWaXhpl7w63NRJdQkgRn
X-Proofpoint-GUID: BIFIj9dFrKgxgWaXhpl7w63NRJdQkgRn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Bikash Hazarika <bhazarika@marvell.com>
>=20
> Corrected transmission speed mask values for FC.
> Supported Speed: 16 32 20 Gb/s   =3D=3D=3D> It should be 64 instead of 20
> Supported Speed: 16G 32G 48G  =3D=3D=3D>  It should be 64G instead of 48G
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index a5fc01b4fa96..bc0c5df77801 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2891,7 +2891,11 @@ struct ct_fdmi2_hba_attributes {
> #define FDMI_PORT_SPEED_8GB		0x10
> #define FDMI_PORT_SPEED_16GB		0x20
> #define FDMI_PORT_SPEED_32GB		0x40
> -#define FDMI_PORT_SPEED_64GB		0x80
> +#define FDMI_PORT_SPEED_20GB		0x80
> +#define FDMI_PORT_SPEED_40GB		0x100
> +#define FDMI_PORT_SPEED_128GB		0x200
> +#define FDMI_PORT_SPEED_64GB		0x400
> +#define FDMI_PORT_SPEED_256GB		0x800
> #define FDMI_PORT_SPEED_UNKNOWN		0x8000
>=20
> #define FC_CLASS_2	0x04
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

