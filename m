Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36B2C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 23:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90F53206D4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 23:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAVX7O convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 18:59:14 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:20026 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgAVX7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 18:59:14 -0500
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MNrGOr021399;
        Wed, 22 Jan 2020 23:59:10 GMT
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0a-002e3701.pphosted.com with ESMTP id 2xpv7nsy42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 23:59:10 +0000
Received: from G1W8107.americas.hpqcorp.net (g1w8107.austin.hp.com [16.193.72.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3427.houston.hpe.com (Postfix) with ESMTPS id 3C58085;
        Wed, 22 Jan 2020 23:59:09 +0000 (UTC)
Received: from G2W6309.americas.hpqcorp.net (2002:10c5:4033::10c5:4033) by
 G1W8107.americas.hpqcorp.net (2002:10c1:483b::10c1:483b) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Wed, 22 Jan 2020 23:59:09 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (15.241.52.12) by
 G2W6309.americas.hpqcorp.net (16.197.64.51) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Wed, 22 Jan 2020 23:59:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqBdWZaqK3XpIbOw8wOfJifs+lUMnyuJZNhlPrPcK4oX+mTg1/G/jI3jfnpQj6ltha+1KSzywGkv22gB35mniUep44jeypz6TUYCc3ZoOUpmwbhVLZIxIVHhiqbFuRiJG2pAmdtZPwVvkkgO38WPFxkx7T6wMXs6/8HHw364Y9TOcFfZGlMXEo+x38sGOlxczdbfPE5txicRf3Lh848KQ+90XklD/JkKS7QbKYPQJH/MXuI2/kBbyDA92L6EEAl8LzOQONEYPTwW+tUdK1yv7UaZu8/DLZSpx7lF132mF42S9FA9dW/4GPzHZSz0U881lldbBSHyBKZMAONQn5dQTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MknAh2+ZSgsSoemn6OIBtJuPgSUxVPvl7c5jewNlPhQ=;
 b=GaZxqzXJirZlRh78nuIwRvRflTRjo+VOn7e0VjxCaFRGRo/1JSrgrgDcwiqT2/NtBdSvO5gBuEP89tn8K8/4Mnmdkboq6Sew+8cFarukZJA99HCVBVZLwTEyFZLNRycB0/4+pNCVk+mh5GtoPwn/2s8Bafz8jtkD/uLSRrAm62vq6NvQvFLvdiUFK5uUB/1ptlAHIVuZHigp+IWOyGdcjsE5s6DVcVwABrQ+4anfFoaIMlB09bbEfqcVfni5HzGSy4HHgWOW+Qzj2537FNpg39zDeUXJkIyQjkpLFFUCTtqkTTEMF8IIR0VxyPj0a1ZD5ANYuM1BtNmGEGQ1b1pjoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM (10.169.93.144) by
 DF4PR8401MB0652.NAMPRD84.PROD.OUTLOOK.COM (10.169.92.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 22 Jan 2020 23:59:07 +0000
Received: from DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c85:3b6c:9ac8:75d4]) by DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::c85:3b6c:9ac8:75d4%12]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 23:59:07 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v4] qla2xxx: Fix unbound NVME response length
Thread-Topic: [PATCH v4] qla2xxx: Fix unbound NVME response length
Thread-Index: AQHV0JDlS8FzB/9qt0mIVKLLKR9nE6f3V9BA
Date:   Wed, 22 Jan 2020 23:59:07 +0000
Message-ID: <DF4PR8401MB1241B973AEE70A60D1D08133AB0C0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
References: <20200121192710.32314-1-hmadhani@marvell.com>
In-Reply-To: <20200121192710.32314-1-hmadhani@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.211.195.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 28c2f2b2-1241-4af2-a53c-08d79f97116a
x-ms-traffictypediagnostic: DF4PR8401MB0652:
x-microsoft-antispam-prvs: <DF4PR8401MB0652738C07C209205974986DAB0C0@DF4PR8401MB0652.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(8676002)(81166006)(81156014)(66476007)(76116006)(64756008)(66446008)(66556008)(66946007)(316002)(52536014)(86362001)(5660300002)(8936002)(4326008)(33656002)(55016002)(9686003)(110136005)(2906002)(26005)(71200400001)(53546011)(6506007)(186003)(7696005)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DF4PR8401MB0652;H:DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nvf4ZhwJLuzl65e6Tgstx90IPaMt0z+7GuG+bJKVtkBXEqvy5sudz3ifZBgrm4FzTESl/N1wBBb4zdBeAeWhVt2KHwEYkgr/m3Eq9rf4H1Xuf0qU7Ar+REFiivg/mE67otnyCB7Q/v/JZZ6HD5KAQzMq6cUP13wX8RbEO6/ERJFOt6S327DbeyIeUBJDLfqEGQE50xxT/4wxNZJ5Up8GGgvhKBWmP/HFBytz7dbfTYcIAsrmeTXR6h2us8bYxOdfv3B6+TXdzora4YVvdH96/ZwbAqMljm88nDSUqNZiL0P5AVCPKHwi2bR1NAM4t6guSrmIkHuUVSmFiL49Ff9TijxAZj4bDN+B2720RvMu7G1Ja+fyKumCIt4dQnbaQJDRmiqPDWMGFRSkNPf89jWieceBhh/LHJMtJdn4On4TKpTst7617IB//WETsZUS3rPb
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c2f2b2-1241-4af2-a53c-08d79f97116a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 23:59:07.5655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zjvg7be5nszJfyL8KZDDRsp/6iXXZHVHAYl0ymoLeioK5vcfUISlw8jRwsBvHb3t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DF4PR8401MB0652
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001220197
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> On Behalf Of Himanshu Madhani
> Sent: Tuesday, January 21, 2020 1:27 PM
> Subject: [PATCH v4] qla2xxx: Fix unbound NVME response length
...
> We discovered issue with our newer Gen7 adapter when response length
> happens to be larger than 32 bytes, could result into crash.
...
>  drivers/scsi/qla2xxx/qla_isr.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
...
> +		if (unlikely(iocb->u.nvme.rsp_pyld_len >
> +		    sizeof(struct nvme_fc_ersp_iu))) {
> +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> +			    iocb->u.nvme.rsp_pyld_len);

Do you really need a kernel stack dump for this error, which the WARN
macros create? The problem would be caused by firmware behavior, not
something wrong in the kernel.

If this function runs in interrupt context (based on the filename),
then printing lots of data to the slow serial port can cause soft
lockups and other issues.

> +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> +			    "Unexpected response payload length %u.\n",
> +			    iocb->u.nvme.rsp_pyld_len);
> +			iocb->u.nvme.rsp_pyld_len =
> +			    sizeof(struct nvme_fc_ersp_iu);
> +		}

If the problem is due to some firmware incompatibility and every
response is long, the kernel log will quickly become full of
these messages - per-IO prints are noisy. The handling implies
the driver thinks it's safe to proceed, so there's nothing that
is going to keep the problem from reoccurring. If the handling was
to report a failed IO and shut down the device, then the number
of possible error messages would quickly cease.

Safer approaches would be to print only once and maintain a count
of errors in sysfs, or use ratelimited print functions.


