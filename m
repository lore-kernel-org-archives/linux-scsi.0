Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4017AC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 17:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjBIRSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 12:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBIRSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 12:18:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D134B66ED1
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 09:18:43 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319Gi008003604;
        Thu, 9 Feb 2023 17:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=07/Rv2DOUCfTV2T6uQIQCQgll2SiogCckVAlfPyBeJs=;
 b=eW7JY7ZPJHRdL5f8+GaKDol13FaagJhrGlR4fhBiMYbs4WbigALhdoSmmkOck6KA+vpN
 T8PA8D2dl2nrYaCTHCFp4psTdhaMy+BIZukCr0WrRNncflur35+Nb9Z9rHNrK8BFSIEq
 aDcjYtFdUeb0HXXIEPMb0oArm2SRQXyPxZV8nz+OqTCsEt9GOQBNzvcrqHRmRWRWVIRc
 j0ORWbLzv7/IU6P0rNio+maUXHKrYene19Pzw+itZcOd+RuyvF80EcS/Lch6uu/6h+bw
 iHk1XsLAZfHFX/1/wtGbPnJjuZ1IOfgXqW5EWY3aMixHcQzgmf0dwcNEllEIcOe3iAim mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwub8cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 17:18:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 319Go3vU013700;
        Thu, 9 Feb 2023 17:18:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt93sm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 17:18:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5+ojYScgb4V0+F3s846fsQwgMbPb+49gCXeKn54eQZD98/0C7WWW6sZ5Z1YQ0E05Gsp72iC6usbX9jBtHQGTP+u0V4BQTdT6LyKFmyi77VBWNRdYKqJrf/fHhkNuT9T+OzcrvsFHGXE/hlyszxyN+5MZ8GUM/xjvHDg47KT7Mr9dHzrNcCo7ViATOLfrL5Peef3vp0fQeFInJwwKPlvcbV30Icpxx1M8RC1ROISIwco617Oe1FPg61gwiiPrZioTehvFeZUSCBUfpNyyLlkxpeYr+F65cLNJqpGO/D24bX1E/KFaXm90BM9NAwQ/Tpp+flBQxh6NgGVgGigvC6a/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07/Rv2DOUCfTV2T6uQIQCQgll2SiogCckVAlfPyBeJs=;
 b=GQIMe9CTWo66yqsrUWaxwJnzWFnukSbG15TE6keHuG4/ko3M7Yst5Vimy2UQ2kjuGUhXMxgsOxT9esuIW1Q6YJ6827BpoizCF/HWm5fXS+fJeZbbSZSC0F0P5UhgaDtveO6hzi2AnZP7l53sd82kJiH3dkJSuJ4TVNh79KcfPBuLzOX/j/eX+uG7elquXl3qxOBPLildAlC/6bhtLVe0sDpuVAMWPrZW+V5Dzu7X/MqJcW1hZSP+QkahaxXsfovcxoutqfaccr8YApjZNxzZlOMRkZXL4EiGTBD4JEkRCjK7w8nMNQF6zW2lm0PE5jLRyfn+Bjz9JxJodSqz+CaC/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07/Rv2DOUCfTV2T6uQIQCQgll2SiogCckVAlfPyBeJs=;
 b=KPwWtzzusQgL1W4prDFcQewKYxmH7H13S7fPnre6j2n9RKQzzHSm3UgVRReXDtQUfm9j+DZN7yQdXTZY7vc14gEXqnXlYil23j5PwRHMPltnxjB/ZMFC9ZXnvjc83yjLuge6HwbY8peuczVcdlUYd1yqPlOaQBLWFZzIFDi0yiI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB7012.namprd10.prod.outlook.com (2603:10b6:510:272::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.15; Thu, 9 Feb
 2023 17:18:30 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::c033:cdf1:279a:4bba]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::c033:cdf1:279a:4bba%4]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 17:18:30 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "jsmart2021@gmail.com" <jsmart2021@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "mkumar@redhat.com" <mkumar@redhat.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH] scsi:scsi_transport_fc:Add an additional flag to
 fc_host_fpin_rcv()
Thread-Topic: [PATCH] scsi:scsi_transport_fc:Add an additional flag to
 fc_host_fpin_rcv()
Thread-Index: AQHZPHM6dfqsYz/4AEe+dXBAI3YRE67G3BoA
Date:   Thu, 9 Feb 2023 17:18:30 +0000
Message-ID: <1087E38F-7F47-4882-A31C-EFCE55B91553@oracle.com>
References: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
In-Reply-To: <20230209034326.882514-1-muneendra.kumar@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.300.101.1.3)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|PH7PR10MB7012:EE_
x-ms-office365-filtering-correlation-id: 2f178c42-a715-4c7d-0f04-08db0ac1aa55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LKha2JazXyOP5IRiL4vXsuyIDSF219rmjqW1fsrLRROyumfCTlvE+gLoHhOJpwtV94ZmxTamOVLtOkcmksZ8M7tCmAuDztYRYHxXxR8H3ywbaDc262vPbnf2z6gUZHFW1nCXvTbg25mrzPVou3nBkBLbMh2iMyn2HUdymgoE89bF0+n4ahMwRMBcj9FCAvf1OY7gsX8gjUVGb3wCqFekp/K7NW8MuuakX0ZGu6VG1/0kqRHnWwShm0Hue3e7uXbSSMkXj/MM7RAMLr1VXEDd7SozslC0LtkY8T63kRURKm10clcT21KNGAZTNWcLxp801D/adXB5/LynVC9C8XoVXXz8NuKbxJZmZAtoePdPEYAWPvn2ayQ1pilLhamuBpad5IIUl/XRBjJrOsGukmxTwYT3TpKG9/+npc8G6cHv9k7QYmPj2/96nhv5JW1iOUKGI16NSMCPgDpBGe/PSlR0kvaXR9pyrw1w8LFmwVtOpjQ+3BP4/p2QAg5DOp/YyMTP5BVGHiO/cssjuiEtcYj3azAQ8P40vUJSeyAxDzBl8CY143OhvW4KWQL3NHxIvHg0lV4gwgrCqSPaQoZp6NzFaGqp8QkKFS6M+VoatmYSx9wR8D3nBxeOESQzxe+nL3Q3ik+p/Uo6g2d6gTUoMXNHZpBweaBn2txn4BqMVRKayw2igLlrPl/dhXm3wVkNqQkSR1Wq0B5OMyGFpYh8MHEJnHEWcNrw4PChYWNKMXQx5g0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199018)(2906002)(2616005)(186003)(53546011)(6512007)(6506007)(83380400001)(38070700005)(478600001)(8936002)(71200400001)(122000001)(44832011)(5660300002)(38100700002)(86362001)(64756008)(66946007)(33656002)(66556008)(76116006)(66446008)(66476007)(36756003)(4326008)(54906003)(6486002)(8676002)(6916009)(316002)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ju2uolHn+DvddptMZ9sfJGrG5RusEzNaSpRWBso5MoRNe/+BHQ8AAQlq37Q7?=
 =?us-ascii?Q?AWvwa+VSCoMO1YLyMwpcjzhZ7y7EnXhtTdtt66S8PePP5kckBiLYwH7KGbQi?=
 =?us-ascii?Q?6iU6zM8Hx/sXNCcZWklaea4HUmWI2zkPr53Xw8GJ/7dWOFsbLnaY3hqT/ZJh?=
 =?us-ascii?Q?qXTo0IFP8ZMQVOIiPZYTp/tVZ8gygdYZ2bjbsfM1bYdf4I0b8vRbEY8VuEay?=
 =?us-ascii?Q?f1ASxLpRx291RYGTy8T/y2NYO8m/comZiFpu+v2exblGyNh5ure/erEf5ANO?=
 =?us-ascii?Q?PZ3gZgzRJVVFYkIMsn5p3pi4qBE//8ok+/Qq1kPyngkuF9d+eILr72OOOyr3?=
 =?us-ascii?Q?WXN+5ClMmvWYRCS4h857948p/V+UKUDckW3I82oTrJ0Ld6NE6EtcYg0Ua9cB?=
 =?us-ascii?Q?6K4o8gRyQ1JzNptG7v0dDpqtbbBahc+W4KaNHsSV+It07GB7/A88fnxTpt8V?=
 =?us-ascii?Q?OIJqWH+Uw5aOXDAxlB2XeogHy78RqTpzgIcK0gReADJ8q4hnaxEfQBnkc8P7?=
 =?us-ascii?Q?+lZ7GLF6+qxG/l/18rNUDCFOCC/OZ0OCzyKOv5HBSmY/Jewu4+3pPfC0VOYQ?=
 =?us-ascii?Q?NX3nzzLYbu6N3prCLq4ZKrgPxKLoLE27oWqava/izAkmamreNn333zRYHcXs?=
 =?us-ascii?Q?JMlfGN2U6DjlEDOdAIfx+C57foxOc6V3UC1/KjGs+8AM1dxA91tBwbg/+H78?=
 =?us-ascii?Q?xcuh41YrG0C3+/akKCdtxG5ckPeanbygCEAPTsWn2Wk63xvIbPR6Hp5WIY95?=
 =?us-ascii?Q?NZAlABj3dIvlD7c6eZ3Xqh4DDQqu7OkiyomhGNik8bxvl8OojQCfXYTdZiR7?=
 =?us-ascii?Q?Xk9qcFPNxnQ9hRBkC1NpLgBOXhc9YLxTDPb7peZsW3xiXVb/ZAtuSO3fsXju?=
 =?us-ascii?Q?4wuqVX0kMDWqO6TpHP1282duCaXwD9glufTg6Lp8XEWevHHCeQtZRcTiEVFu?=
 =?us-ascii?Q?nrgLkQPUXSDqb3ku+wEdNe0qI0kRIvTp8THQBlffdamROVWBIvINwek300mH?=
 =?us-ascii?Q?uuf01BpCSloCMue/0e1Q/8yFgDRgQdde8z4XlYi34gddc8yFzp9pDdLzA0wO?=
 =?us-ascii?Q?QmIwI3tdrO4QDDMTVa+8b+4KSf063vRbqR0FtkEmWDoeAiv8PomXIJB7Tmyb?=
 =?us-ascii?Q?frIr2eqPnpIGu7rfdBlxS9co23f6lhiSSYk1MFVbSzq4EclfmsMrBbSFA0Fp?=
 =?us-ascii?Q?yt/LqC5WA1WmdMtNagAH/vo92JiF/a5eHx3vGuapkwCWwdLgksbK/9+jPd7M?=
 =?us-ascii?Q?qao8RKVORaxGuGQB9/3uFud78Fr7ZY9ACd+6q2+VLSrT6TAsoVaJiW3pgWpN?=
 =?us-ascii?Q?60XuzR752MNH2qEzkh4ooC8VImkTqZFM+YYFjnueAnKVxVHAGKNhAYP5nz2n?=
 =?us-ascii?Q?XUvyXGAW2R3RDHJizZitwjIEwKRkmbI+vrB4PYxVPovcekomuiZ4D1ASho78?=
 =?us-ascii?Q?OmOePf7WtSDJxYa1JhFxYHqy/s4BnJTjsQRkI7JIJxYNQ2O3W0bJxlzebQz9?=
 =?us-ascii?Q?L4t6lpe1Vb4xNPE8lvoNQBEmoG4hXInVFDZXFnXRax8hLAimlmaVT+2eYXwl?=
 =?us-ascii?Q?UP4Pqm/IMitJCFlgQPKYfAo21cSam3KOcddnoe/7JfIOx8QD4OiwRA+qb44R?=
 =?us-ascii?Q?F8TYSPXxb8VJQWf0z/E9ShlFtjOKS04OiHuODGHs5H04?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E10B209461C08F4CABB95CA0C94E2BD7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FkJf+HI2kl7Eo+naYxkGQMW/7hoyhjIq2bfjAZwZFwjhD5HAwHuABJn4aVMTx4+cnv9xet0XNL37OM3YB6Rt1uj91ioIp/M7JroXuA679L3lw7wVqWCem7UZMiyzWp1Jk1P7nsVmLe9sq8lb+ZLgfNzAkt1B6/fZhGrn/ftiQ32AwSOShKPGdx0PJh2x7ShB1Wv2GEGVkSpBRJ8sGwH/ywG3WzeGZV4Ygprg1xIMTKgpTfqisqajKT6zQmr45tflQzyiisT8KN9NYZ5glV7Xyk3Vjs0BU+f9tbmAPOYvIPtVTGwTP+guU1Ocj2SghPCuNVecMbjetbcC1LfwM8CqYyjL0HngK9fw6pQXIVz/tGMsgRnbZAVkNMNVSTHINbA/CZHf0HKyCw+qmMdO/B1FEYvQP1FcdwriUcoTzZ5IyMBLeAKcBgflcbke3odCd+CjaFfjD8696RoYSmC+R4ASQDgkdA7L16kGbtYldhvagb8qShSkyV4ULtNFrfKSAjgEwqoSe28iFtoxevX9cdE1s1zVj8O2vK/E2uzEOEMsyvI6e9NzSGen4YwjJRvV8Hx2F2QFmTlqxCOB+xzmgMAlvDUWIJ161l61jIrLYPat0MRifP+BBQmF2W0pO/nfmiHaJ4Gu0o04tMd58ycOSGrj3vV4koV8Fz393Y7R0om/XMW0warGYFtuVfYcvyMsjTGyC7Yivny79gaqrnW/6cPn+mwA9MRLJsGhupentKJmNooqxu1EPMDqZKR8E2SA2FjFgILNKmd5l2vjznf+BPPi6dqI2kZblVY4aM+pKOJ/RSZyNVATh3/j1LsmnDggSL3TkavSp3jOjTxiTo3T+7WOUrctFaqMdeoSUCtPlHJPr3+8L8K6qdvUlXZiLPZvo2lNkuo+yOht1eh2SpE6UC4b+w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f178c42-a715-4c7d-0f04-08db0ac1aa55
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 17:18:30.5255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3grChUyJ+8l627AZTAIju2RkkoQKsokpqL+shFwQqGA4e4YdBsZajUsHlHrKRVVO1fNQ6ZkAstkhzcZD8UKgcMiTFpbf5VtZv/E6791ZBlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090164
X-Proofpoint-GUID: T5U7vBFOktExnXoI8HFIW61dJJhAdBHc
X-Proofpoint-ORIG-GUID: T5U7vBFOktExnXoI8HFIW61dJJhAdBHc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2023, at 7:43 PM, Muneendra Kumar <muneendra.kumar@broadcom.com=
> wrote:
>=20
> From: Muneendra <muneendra.kumar@broadcom.com>
>=20
> The LLDD and the stack currently process FPINs received from the fabric,
> but the stack is not aware of any action taken by the driver to alleviate
> congestion. The current interface between the driver and the SCSI stack i=
s
> limited to passing the notification mainly for statistics and heuristics.
>=20
> The reaction to an FPIN could be handled either by the driver or by the
> stack (marginal path and failover). This patch enhances the interface to
> indicate if action on an FPIN has already been reacted to by the
> LLDDs or not.Add an additional flag to fc_host_fpin_rcv() to indicate
> if the FPIN has been acknowledged/reacted to by the driver.
>=20
> Also added a new event code FCH_EVT_LINK_FPIN_ACK to notify to the user
> that the event has been acknowledged/reacted by the LLDD driver
>=20
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
> drivers/scsi/lpfc/lpfc_els.c     |  2 +-
> drivers/scsi/qla2xxx/qla_isr.c   |  2 +-
> drivers/scsi/scsi_transport_fc.c | 10 +++++++---
> include/scsi/scsi_transport_fc.h |  4 +++-
> 4 files changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 569639dc8b2c..aee5d0d1187d 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -10287,7 +10287,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void =
*p, u32 fpin_length)
> /* Send every descriptor individually to the upper layer */
> if (deliver)
> fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
> - fpin_length, (char *)fpin);
> + fpin_length, (char *)fpin, 0);
> desc_cnt++;
> }
> }
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 46e8b38603f0..030625ebb4e6 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -45,7 +45,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, s=
truct purex_item *item)
> ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x508f,
>       pkt, pkt_size);
>=20
> - fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
> + fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, 0);
> }
>=20
> const char *const port_state_str[] =3D {
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
> index 0965f8a7134f..f12e9467ebb4 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -137,6 +137,7 @@ static const struct {
> { FCH_EVT_PORT_FABRIC, "port_fabric" },
> { FCH_EVT_LINK_UNKNOWN, "link_unknown" },
> { FCH_EVT_LINK_FPIN, "link_FPIN" },
> + { FCH_EVT_LINK_FPIN_ACK, "link_FPIN_ACK" },
> { FCH_EVT_VENDOR_UNIQUE, "vendor_unique" },
> };
> fc_enum_name_search(host_event_code, fc_host_event_code,
> @@ -894,17 +895,20 @@ fc_fpin_congn_stats_update(struct Scsi_Host *shost,
>  * @shost: host the FPIN was received on
>  * @fpin_len: length of FPIN payload, in bytes
>  * @fpin_buf: pointer to FPIN payload
> - *
> + * @event_acknowledge: 1, if LLDD handles this event.
>  * Notes:
>  * This routine assumes no locks are held on entry.
>  */
> void
> -fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
> +fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
> + u8 event_acknowledge)
> {
> struct fc_els_fpin *fpin =3D (struct fc_els_fpin *)fpin_buf;
> struct fc_tlv_desc *tlv;
> u32 desc_cnt =3D 0, bytes_remain;
> u32 dtag;
> + enum fc_host_event_code event_code =3D
> + event_acknowledge ? FCH_EVT_LINK_FPIN_ACK : FCH_EVT_LINK_FPIN;
>=20
> /* Update Statistics */
> tlv =3D (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> @@ -934,7 +938,7 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_le=
n, char *fpin_buf)
> }
>=20
> fc_host_post_fc_event(shost, fc_get_event_number(),
> - FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, 0);
> + event_code, fpin_len, fpin_buf, 0);
> }
> EXPORT_SYMBOL(fc_host_fpin_rcv);
>=20
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transpo=
rt_fc.h
> index 3dcda19d3520..483513c57597 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -496,6 +496,7 @@ enum fc_host_event_code  {
> FCH_EVT_PORT_FABRIC =3D 0x204,
> FCH_EVT_LINK_UNKNOWN =3D 0x500,
> FCH_EVT_LINK_FPIN =3D 0x501,
> + FCH_EVT_LINK_FPIN_ACK =3D 0x502,
> FCH_EVT_VENDOR_UNIQUE =3D 0xffff,
> };
>=20
> @@ -856,7 +857,8 @@ void fc_host_post_fc_event(struct Scsi_Host *shost, u=
32 event_number,
> * Note: when calling fc_host_post_fc_event(), vendor_id may be
> *   specified as 0.
> */
> -void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_=
buf);
> +void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_=
buf,
> + u8 event_acknowledge);
> struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
> struct fc_vport_identifiers *);
> int fc_vport_terminate(struct fc_vport *vport);
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

