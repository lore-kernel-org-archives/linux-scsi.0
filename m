Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7CAC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiBIS5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241348AbiBIS4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:56:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FD6C050CFF
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:56:14 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HK0Jl020152;
        Wed, 9 Feb 2022 18:56:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=e/tVanfMfY8R+lGDUiq1Gx+VUvfEeorojz8Aym1zTSQ=;
 b=QDnDrW6mA4l58dERQ9UbrbkiPNBjt482WML10JbnL6ZxDWQ+I26O/EA175mcl8SqQ15k
 c04pRrM3y0asQ0lBgtDxF4bbkCIsQEBTZMnyVeNOWQ+84M0W0KGuHA3f+6SoMJ+M4/dE
 cBrQ5ihksOs4fnOf7I2gSVyewiO4bJtzVSi/O9isajAJXVbX6qcLfsonI4t+azMTNS3w
 FYkR9eotfKZ4fwJXkrOJBfFph9f5t1fjJtrnj0u5F7DkMudYShW2mDuaTY+drToXNr6L
 BFyWEuoH6ZM3b7f0e8SKiK3cAuotiEX3qty3wQXfl0N/MiCdtgy1QxbUQ7OFRWH9WFJh Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e366wxtjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:56:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219Ipuqa018318;
        Wed, 9 Feb 2022 18:56:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3e1ec37j16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:56:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/NFP5PfFIQ479G49iWaIai2eEF3aFscCCMLY2sOqD9V+nLn+XJ2s+VuIr9W5rKbdlT1igYxgoSVbw0zCpKPUlmc0sE3l4MKfk+XwLuNN4TYbbtFzRyoV/0LJfufXYD/BWcXRvi8nZu+SR3+r1IHDTUXLPz+DRxgHUiXGO7XA9ngMnykvlLhw0ahEDl7aI30e8FW2X1LhCz5sGosa79gyoeZd/8X1One4H0aKrVyvV2NivoUY2LeBTrspMCTKGDXUfwG04mj0FcBLTuXuz/wBdR3jZ+E0UMbr2LZoZGkdiT2oiWuHDhYgpTb/iD1qGUilAvZTo9uWNvHvY0LnSat4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/tVanfMfY8R+lGDUiq1Gx+VUvfEeorojz8Aym1zTSQ=;
 b=PzDAD41O8akXF6dlsJyk4J35uBYoNGULSXYvIAy1ZVFs8tnx3qy3yVDaJtI/Vfc1th7djFPHxTiHha6zCY+1+Uk86SkKZg5FvGvy1M5BwRiUTzhAVZ1KARMauD4qHBnywiyY411JZcM6F6gBUjAK3MIC/IYdzz34HAD0NQ5ZMl1JmrYyy95eAZdoUp2HI7JaaHyXcfh4CzHWW06fA0gqiLqi2H5709/KuUaw7v8aBQknLlvwiy3fnf54oboN84sbjc/ad5dv6OlYfOmtytSoRitBW7iIvmLzyN0RxOtQTq6q+iDhZU69Bp8zygnCLlgXXS+jFEA3YF/ehn9aRQ4O/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/tVanfMfY8R+lGDUiq1Gx+VUvfEeorojz8Aym1zTSQ=;
 b=TOBXOTHgP7nyswkLoiyuAMZsdfQB+9U2V2Q6m/kQszi9cJbLqy+dUwcy8eKmMMgjtU1C6v5+xp8D+81AOGyom2yG3i8gpPwzyyHxa2Aa041/nIDXs8QP5W2QrOTK2qv6ekyV44aIubtb+fGyG4tNF7kPAB0e2pyI+/t0p+Eod0k=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MWHPR1001MB2224.namprd10.prod.outlook.com (2603:10b6:301:2e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 18:56:07 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:56:07 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 34/44] sym53c500_cs: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 34/44] sym53c500_cs: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHRFCw3O2Rn/Fb0KYznsoURL8TqyLk0GA
Date:   Wed, 9 Feb 2022 18:56:07 +0000
Message-ID: <C8C1C434-21A5-41D4-9C84-424DA540E0F1@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-35-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-35-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 329e15fa-75a9-4b67-e6d6-08d9ebfdd4bd
x-ms-traffictypediagnostic: MWHPR1001MB2224:EE_
x-microsoft-antispam-prvs: <MWHPR1001MB222411BE8B10C2DE4916BAF1E62E9@MWHPR1001MB2224.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MEhZ8ZPlvL+mch3xi/r257XtFlqZZhU+39Nj/VP9tb+MMyeNNnPQVYwyBpLaWlXV34JHOAQhroqPDNR9C4cXAtYv3OMa/D9fcWua5sA/cMxWXZTdyNcuGiey1u8VdVtzCwk9fQ4kRGBiGr3KbNSbb6AUBi0Kf2CXBC5WG9aAB20mcnMaP0VycpwK4UO3WKnhXfca/UL5dMi/pAxi3rqU5GYB48AZOn8oq7e/gUrYHSNCdNFQ61v1h2c5B/OxqsPo1mUGDclv5Omx8BUs1ie4awtDSAz9XyHqqfUYHAPnBLJmvgAqZAixgSnl+JxH8o3H6RtUL+14U278UwsChocnTABep8xLY/SBahDU4rrRz0RXzEqav75bLVwKk1VvczOw88YjQzUDBKnV3LyIdZiezzyV01ypYUD9KsFwPqcB+tfjkPfaMUNrMVqETD1mfT9YYTLWqF37gmVvJsSnM36zZl2Jx7z1ar3o4fBiGIFNxI+H1EhlXZ7xxtHrhpmegv/9PYED0hNVEqmRcy4Nol7v0EDZs0XyKcvcCSapUtidBpVPMp6sl7FF6FgkR/oYM1jSX65yn+5fGDzRiX7XqR41t36dEtkGzkVnrTGNwdhPT4CcMQIleK4BQPChJb+SPj6R4b9H9G/CyUlFIO6HacFx55apKNMauIAmBHs/F3BgoZ4VCWSsKzJ88EopsCw8bjQz8ROBrSWCrN+1dEpC1OsTyu8UEI1svzrOngI9GXi8A+xHk6V8OOo973Gqg10uIpiS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(186003)(122000001)(36756003)(6916009)(33656002)(38070700005)(71200400001)(316002)(66946007)(54906003)(44832011)(38100700002)(2906002)(2616005)(5660300002)(6506007)(6512007)(6486002)(8936002)(86362001)(508600001)(83380400001)(53546011)(91956017)(4326008)(66446008)(66556008)(66476007)(8676002)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nNdStqpd9zNFwKLE75h1JZJXOSZSTtBrt/x5ICcGVk0mzvfX1m7FF+QZTyQw?=
 =?us-ascii?Q?4FQsvpNe/y1ZfGG2Bf+DXiN1AQpNBmVbkkdfr6Gb82RYNCfp8k230EV2vYq+?=
 =?us-ascii?Q?YGdtEcbxtIL3Ekp8P0HfNhd+urnleTV34dt//8jiJpz3jZeUnOUQWino+Rvx?=
 =?us-ascii?Q?3jBt5FWoRc3+OdNHCF/ecf4QrAaA46fZRSXN9+QIidoXd1ZAc48CKXsy3XAC?=
 =?us-ascii?Q?Q8QeAgjX/jQOXfdnH4UBxkZPNQT4JkPbLkHpSQ19BlAuvgJsuVLcYfkKkpXz?=
 =?us-ascii?Q?Y1KZaj6WzHcO3mDOVcKSV5H+HDfkIsn60n55++oQ0v+1nNF4lsXXQseQlO4D?=
 =?us-ascii?Q?8cCfW6VmF9LBbFurMup/mSuD3KfWg6PC/K3gsKO8L3ixjkPcNR63QpgS9BfK?=
 =?us-ascii?Q?KeJw91HWJJHJVgWhFlQANSwG3CFOkPFffX62ks6fs13fGeJ/JkeNixGTdPVF?=
 =?us-ascii?Q?pJx+vcW8ysms+c6JRcm4qE0CsLUapmiwLFWl823VDyBSBRUigvfcjXMW+ysA?=
 =?us-ascii?Q?GIVmSYuespKJ49t1U/TJ68mPViyRPvFqBUgj3W6Evrpqymksk6b3s1u3i8UN?=
 =?us-ascii?Q?XKnOt1U/k1lWaP0LOBXxaHhYsQK6cDwXkjtUtsYNpuDpjTFgVsM4k19buvIN?=
 =?us-ascii?Q?nVk5+PkXPUNsi4GZxXf6WbXKkj4sJCBtTpxX7kd0EXccLJ3n5E4XMnxP3H0m?=
 =?us-ascii?Q?BzCkwiqE0JKiCURw/YjeSI7R3yPMP0FVGewkyc6LVBlThxcsGIcGtNOBFBPH?=
 =?us-ascii?Q?NSCVddKe4Mv3DYkLn/Puazrv4qW8t5CTIRvGB6I0HMRlBenctqucyEQKisNp?=
 =?us-ascii?Q?fTkN9Aq61Mi7dwVFJaeC9j0+fVdowNrf7mCf8Iju1ocNh/EWMfU2DPOR7eRd?=
 =?us-ascii?Q?/ltoX8Wlshn4l5e4XAQiElopEFzT9FwMM5fJImStZtHwk7gHbiIqkc5dTbyd?=
 =?us-ascii?Q?FkStZpbXLfpZbkBcIwIxVV8lHXRqsdgF2DG74IBYRhapJ+xfQ9sGi60hVjJi?=
 =?us-ascii?Q?ku+Y6yRNG8a59hk2jyZnrx2I4BhwMM1sNK7yCfVShVUCAu693sf4wvuQfcoG?=
 =?us-ascii?Q?cTUjyXoRVbwPajYcrpQ0WVd5dcBoDb63RWN4TxcxFVkVHfDxtXO+2ta/b/VB?=
 =?us-ascii?Q?Hp9rPbLUhu+gAkUQBjFV05pFeaPXcz4P8IjY429pow0jVj68fE5I6mn4EVXu?=
 =?us-ascii?Q?7tkxc0yl2EDF9Dog8Yzf1NV58jvKFwhsPndAtzMhQ3gM8eGZYDN2F3ftGEH1?=
 =?us-ascii?Q?TimIOJhWVe/FZTVWBfNjbFmBvhtJ/ComNq0SlqENruN4lHLw9uLrsGDyq+UI?=
 =?us-ascii?Q?XoDDfGZtFGBSZskT+G8fqJyk1YRqEXrgd+sY4+z7pldpO4q/PwFIN51nC5JV?=
 =?us-ascii?Q?3sWCr/tLYbki9fKyIIcuHe8KjNdX5/1LurR7rZskZHrvZ7p8PJ2nKa/LIECW?=
 =?us-ascii?Q?tkuwcPWFtVDa68XrSWfNZr1IFyuIu4zo15Nhx7J1NbQSakkbwMXnPUUvFV53?=
 =?us-ascii?Q?kd8qGxYxkNXbaTBt6si56enjkt9MLnKU3uo8IbFgT6Wl5bbw0IM+C5P+2qjN?=
 =?us-ascii?Q?v/sfV+NGjhYNr3woUYjmcHskBgozPjSD8+1z6H8cOiQqbcpHoloKPSMMHouQ?=
 =?us-ascii?Q?duFM9aOJA76Ivz6TWXE+6MBm2sqB2ySlP+eK5Sa44UKV1N3tcejlSiqXBviY?=
 =?us-ascii?Q?Pto2NQyaWFWaUJ1cJbOAMHIevHEo4Qrw8KZhtDJbqPYCxVN5?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <119B5947DB7DC8409C13ADCBB98995F7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 329e15fa-75a9-4b67-e6d6-08d9ebfdd4bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:56:07.7323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jzY6r5xIeTwl4wTi9H0Zi6Pi+tnOpzjQBBuyMup8mHKq26j8RZ7XD8K34h5Z4H37cMfjbGJSuMZ7ADoOqgqsy3f3Zr9sLNTUAzsB0LJu+As=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2224
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090099
X-Proofpoint-GUID: jppKiMAyje3sAXVmmfe_tB6uH7t3hFCE
X-Proofpoint-ORIG-GUID: jppKiMAyje3sAXVmmfe_tB6uH7t3hFCE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd.
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd=
.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/pcmcia/sym53c500_cs.c | 53 ++++++++++++++++++++----------
> 1 file changed, 35 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym=
53c500_cs.c
> index fc93d2a57e1e..298df2180bc7 100644
> --- a/drivers/scsi/pcmcia/sym53c500_cs.c
> +++ b/drivers/scsi/pcmcia/sym53c500_cs.c
> @@ -192,6 +192,17 @@ struct sym53c500_data {
> 	int fast_pio;
> };
>=20
> +struct sym53c500_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static struct scsi_pointer *sym53c500_scsi_pointer(struct scsi_cmnd *cmd=
)
> +{
> +	struct sym53c500_cmd_priv *scmd =3D scsi_cmd_priv(cmd);
> +
> +	return &scmd->scsi_pointer;
> +}
> +
> enum Phase {
>     idle,
>     data_out,
> @@ -351,6 +362,7 @@ SYM53C500_intr(int irq, void *dev_id)
> 	struct sym53c500_data *data =3D
> 	    (struct sym53c500_data *)dev->hostdata;
> 	struct scsi_cmnd *curSC =3D data->current_SC;
> +	struct scsi_pointer *scsi_pointer =3D sym53c500_scsi_pointer(curSC);
> 	int fast_pio =3D data->fast_pio;
>=20
> 	spin_lock_irqsave(dev->host_lock, flags);
> @@ -397,11 +409,12 @@ SYM53C500_intr(int irq, void *dev_id)
>=20
> 	if (int_reg & 0x20) {		/* Disconnect */
> 		DEB(printk("SYM53C500: disconnect intr received\n"));
> -		if (curSC->SCp.phase !=3D message_in) {	/* Unexpected disconnect */
> +		if (scsi_pointer->phase !=3D message_in) {	/* Unexpected disconnect */
> 			curSC->result =3D DID_NO_CONNECT << 16;
> 		} else {	/* Command complete, return status and message */
> -			curSC->result =3D (curSC->SCp.Status & 0xff)
> -			    | ((curSC->SCp.Message & 0xff) << 8) | (DID_OK << 16);
> +			curSC->result =3D (scsi_pointer->Status & 0xff) |
> +				((scsi_pointer->Message & 0xff) << 8) |
> +				(DID_OK << 16);
> 		}
> 		goto idle_out;
> 	}
> @@ -412,7 +425,7 @@ SYM53C500_intr(int irq, void *dev_id)
> 			struct scatterlist *sg;
> 			int i;
>=20
> -			curSC->SCp.phase =3D data_out;
> +			scsi_pointer->phase =3D data_out;
> 			VDEB(printk("SYM53C500: Data-Out phase\n"));
> 			outb(FLUSH_FIFO, port_base + CMD_REG);
> 			LOAD_DMA_COUNT(port_base, scsi_bufflen(curSC));	/* Max transfer size *=
/
> @@ -431,7 +444,7 @@ SYM53C500_intr(int irq, void *dev_id)
> 			struct scatterlist *sg;
> 			int i;
>=20
> -			curSC->SCp.phase =3D data_in;
> +			scsi_pointer->phase =3D data_in;
> 			VDEB(printk("SYM53C500: Data-In phase\n"));
> 			outb(FLUSH_FIFO, port_base + CMD_REG);
> 			LOAD_DMA_COUNT(port_base, scsi_bufflen(curSC));	/* Max transfer size *=
/
> @@ -446,12 +459,12 @@ SYM53C500_intr(int irq, void *dev_id)
> 		break;
>=20
> 	case 0x02:		/* COMMAND */
> -		curSC->SCp.phase =3D command_ph;
> +		scsi_pointer->phase =3D command_ph;
> 		printk("SYM53C500: Warning: Unknown interrupt occurred in command phase=
!\n");
> 		break;
>=20
> 	case 0x03:		/* STATUS */
> -		curSC->SCp.phase =3D status_ph;
> +		scsi_pointer->phase =3D status_ph;
> 		VDEB(printk("SYM53C500: Status phase\n"));
> 		outb(FLUSH_FIFO, port_base + CMD_REG);
> 		outb(INIT_CMD_COMPLETE, port_base + CMD_REG);
> @@ -464,22 +477,24 @@ SYM53C500_intr(int irq, void *dev_id)
>=20
> 	case 0x06:		/* MESSAGE-OUT */
> 		DEB(printk("SYM53C500: Message-Out phase\n"));
> -		curSC->SCp.phase =3D message_out;
> +		scsi_pointer->phase =3D message_out;
> 		outb(SET_ATN, port_base + CMD_REG);	/* Reject the message */
> 		outb(MSG_ACCEPT, port_base + CMD_REG);
> 		break;
>=20
> 	case 0x07:		/* MESSAGE-IN */
> 		VDEB(printk("SYM53C500: Message-In phase\n"));
> -		curSC->SCp.phase =3D message_in;
> +		scsi_pointer->phase =3D message_in;
>=20
> -		curSC->SCp.Status =3D inb(port_base + SCSI_FIFO);
> -		curSC->SCp.Message =3D inb(port_base + SCSI_FIFO);
> +		scsi_pointer->Status =3D inb(port_base + SCSI_FIFO);
> +		scsi_pointer->Message =3D inb(port_base + SCSI_FIFO);
>=20
> 		VDEB(printk("SCSI FIFO size=3D%d\n", inb(port_base + FIFO_FLAGS) & 0x1f=
));
> -		DEB(printk("Status =3D %02x  Message =3D %02x\n", curSC->SCp.Status, c=
urSC->SCp.Message));
> +		DEB(printk("Status =3D %02x  Message =3D %02x\n",
> +			   scsi_pointer->Status, scsi_pointer->Message));
>=20
> -		if (curSC->SCp.Message =3D=3D SAVE_POINTERS || curSC->SCp.Message =3D=
=3D DISCONNECT) {
> +		if (scsi_pointer->Message =3D=3D SAVE_POINTERS ||
> +		    scsi_pointer->Message =3D=3D DISCONNECT) {
> 			outb(SET_ATN, port_base + CMD_REG);	/* Reject message */
> 			DEB(printk("Discarding SAVE_POINTERS message\n"));
> 		}
> @@ -491,7 +506,7 @@ SYM53C500_intr(int irq, void *dev_id)
> 	return IRQ_HANDLED;
>=20
> idle_out:
> -	curSC->SCp.phase =3D idle;
> +	scsi_pointer->phase =3D idle;
> 	scsi_done(curSC);
> 	goto out;
> }
> @@ -539,6 +554,7 @@ SYM53C500_info(struct Scsi_Host *SChost)
>=20
> static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
> {
> +	struct scsi_pointer *scsi_pointer =3D sym53c500_scsi_pointer(SCpnt);
> 	int i;
> 	int port_base =3D SCpnt->device->host->io_port;
> 	struct sym53c500_data *data =3D
> @@ -555,9 +571,9 @@ static int SYM53C500_queue_lck(struct scsi_cmnd *SCpn=
t)
> 	VDEB(printk("\n"));
>=20
> 	data->current_SC =3D SCpnt;
> -	data->current_SC->SCp.phase =3D command_ph;
> -	data->current_SC->SCp.Status =3D 0;
> -	data->current_SC->SCp.Message =3D 0;
> +	scsi_pointer->phase =3D command_ph;
> +	scsi_pointer->Status =3D 0;
> +	scsi_pointer->Message =3D 0;
>=20
> 	/* We are locked here already by the mid layer */
> 	REG0(port_base);
> @@ -671,7 +687,8 @@ static struct scsi_host_template sym53c500_driver_tem=
plate =3D {
>      .can_queue			=3D 1,
>      .this_id			=3D 7,
>      .sg_tablesize		=3D 32,
> -     .shost_groups		=3D SYM53C500_shost_groups
> +     .shost_groups		=3D SYM53C500_shost_groups,
> +     .cmd_size			=3D sizeof(struct sym53c500_cmd_priv),
> };
>=20
> static int SYM53C500_config_check(struct pcmcia_device *p_dev, void *priv=
_data)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

