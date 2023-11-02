Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D43DC4167B
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Nov 2023 15:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbjKBP4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376703AbjKBP4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2023 11:56:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BCF137
        for <linux-scsi@vger.kernel.org>; Thu,  2 Nov 2023 08:56:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2FjREE006486;
        Thu, 2 Nov 2023 15:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=BZyjiE9mnAURwm7IAxgFmkadmQQGEmsYp8ukNj40Fbo=;
 b=eS9AUlmFB4s61I5hNkHccl33h+fSeFLDRXGiVGUxucbn7kgw3qYhdmBfpTMT0dRmcJhj
 CTGb1kBFxRNz06XriUQE+A/HyirWz0ZzSrWG43KhbcTi+an8f01IKY44YmghwESZnTRi
 fdUab8t7NMD18JnMO96GVHVIz76VGTBNjDG9uN2V8c229SVEQ5jVQF9eWcfYUIOSnHaK
 qDTrCqyOfcKVwNZxMRsFpke8+6rtld7K3bCm7aMXEcRlImLW4XLCYUqEZ1Kkdmuzr4yY
 XrpT8TVu9760VkLeFoVt/09pp21Kd3HX3GhMlBei5tLcvnFpp8tFeD9UdfODY1zVgUTd AA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0s342aa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Nov 2023 15:56:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2Fr3YJ020058;
        Thu, 2 Nov 2023 15:56:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr8td1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Nov 2023 15:56:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggDRljjW3ab35zWHeXSNYmNMiVm7Br3fqEZpyFTBzHsNAzfubaekeNljmk6Ub3mF7QzP+1pLaaxa6/rWvv5eOi4XlQ/Rgx6ZxAKdp5kbpeF3XNlfevjfJxVdZ9NcAz1+cU1ipoufoURS3gfD4E+UvCD6PfNKQ5N56qd9poIh402RWaPCeI5Cl77OfagGz2I2yeA3iEV2Le4YY9CkgnkXwmmMoRllBV+l6EVWpNL2pN1Y9wN36Oca5ESwEF+6pTVasGiMLYMGPRLaI/y68mftpiop/nmLDJrUpWZVvpXcYd85/6n7QtnIqPkRs688/5poxWH0zXJ1QRFi5ScHsN8Swg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZyjiE9mnAURwm7IAxgFmkadmQQGEmsYp8ukNj40Fbo=;
 b=GilFScZGSBC/CcZs+2Z3V9pPkDyfJAZisxWpw+dCDJtTX/Yym7PykUq7xnkTGuODFWsQGk5loulSqwzK0jheb69moevNATm21asInPTzXNUpCDy09JfeeKkZn4Lgu2uryo0Y7s2vpIRqfBMGvvgmrsHlVmmAUErQ8mHeNBhPDXoAciXOnY4YbLgZ2gIU26h+uTvlJ8PCfAGDeiveLSou7fcCUJBTx5S0LOKJy9l/bePrDoxLMCLOFPugg5/t4N+l23koVDxo4tdCCLZOFLcbyGb46a+IrgR/8Qe4PACPplxEj/t1mkg6LHqSJ8jfv4SOJ2dThwiW0cT9jpKGvGZ8Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZyjiE9mnAURwm7IAxgFmkadmQQGEmsYp8ukNj40Fbo=;
 b=xpVU/qPBMzCQbxx5VNjElL7H+ZE1bn3BK7toT623kaQ6Re/SJyZh24QubTJsTwoWpy1c4K2OeKJbvmttvGS/zf2hRqMtUrYUwdEtkTviovEvRPC0iypFrWpfyR1rgAkZtUWmVj5BQ3/XRDb9OmNHZiyyTgVH+2E2Z56FwQi5+n4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB4742.namprd10.prod.outlook.com (2603:10b6:510:3f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Thu, 2 Nov
 2023 15:56:09 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4426:5fe3:a960:f8d4]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4426:5fe3:a960:f8d4%4]) with mapi id 15.20.6954.021; Thu, 2 Nov 2023
 15:56:09 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Justin Tee <justintee8345@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jsmart2021@gmail.com" <jsmart2021@gmail.com>,
        "justin.tee@broadcom.com" <justin.tee@broadcom.com>
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.16
Thread-Topic: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.16
Thread-Index: AQHaDCxqqbAS5sqKEEa1L6236bMtXLBnMcoA
Date:   Thu, 2 Nov 2023 15:56:09 +0000
Message-ID: <2DD6533E-588A-435E-BF2E-C9129249E5E2@oracle.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|PH0PR10MB4742:EE_
x-ms-office365-filtering-correlation-id: 50e946d6-a8e7-4f4f-995d-08dbdbbc3b18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5PR2HxpJg0chdhGK3JLWqz5w3hDXAecbCgn2CVC3kcA2DqJZgls3fJZfYqxaiMQ4kO5ZRl6SkxwxNC07+YqgHTc3zPMzPcmbHoLUauRb/ixpFBnZE76uTZHXics+HJxzSrxA4ccUH8mQatM00ljZPhrSDU3JMbLGIG5QhBDF+UNOqc3E653YHbRyKvZ1U259pEjYhuSOEzKYcVZPPIXJ1Lx9ZFSawz8mrLx7Fds4IIqbk/ctWkWZAy62mpSk07gNPDHSrosZpT6MT95ocH19xL/7xd+J89qPrD/nhpGAj0g6VkpsNXTanIXpluMT8lJXIQsqGfFiok8tC4R9Ilq7J6GJrHrmFU6ZwV61kFtJibpdiSpc9BuRwHQKCGRHyTTQpGBkUueYWwYCe0w7BdLCAK2NREu4EBO8arL/MrzC3083eltrHAgD2Seiwx8iIRqqoJtugMw2tXvkxpIkPw767/5wQHum43vpe6UaCw3+Ytgcebn4l83irb+2ry3DuikztrP/lChdbrN01VBqsFF9VQJmaQKGDGCbHZBdEPtSmhQxKEFGx6YgCek0lRG95jqya9cz1rMYVIe3rO0glaPsR2a7UEDSTlT08GR61XLgYQerkucqMVaad4S5IFvej73GGTfXGELcKDk0b9STzzSscv6vaPbJoPtykCW2o5DaeYq5pU0xnFz1mEX9N58qIujD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(396003)(366004)(376002)(230922051799003)(230273577357003)(230173577357003)(64100799003)(451199024)(186009)(1800799009)(26005)(2616005)(6512007)(15650500001)(38100700002)(33656002)(86362001)(36756003)(122000001)(71200400001)(5660300002)(2906002)(83380400001)(6506007)(38070700009)(478600001)(53546011)(8936002)(54906003)(64756008)(6916009)(66556008)(66946007)(66446008)(316002)(66476007)(4326008)(8676002)(41300700001)(91956017)(6486002)(44832011)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YmE0cdjB27IgXtqXIcgRDim/18rMFuWNToMzuG1T9DB17vpdbkCwgAAdlJgn?=
 =?us-ascii?Q?hZiikJmkycSWuGEnK0ROlYmMxgnlyjahfXkjvLAA5p4r4612Hn+8BsbXtqza?=
 =?us-ascii?Q?G3Uz7/SkoeQ8z9iXD9/w3b+qMgcnSIJnHl6GL3LTrvXqtVxR+hYEM9Rrpz+N?=
 =?us-ascii?Q?5m5TfPXgKQhhDnXbfYDtm+JtzGPaZni2bZBsjrGYkRy31CmUcnvoW/LiPfzk?=
 =?us-ascii?Q?5TodgciZUx7Mq/ugUoy/igGx0FU2U5SdVNhyg3LMaelbZtWEkUnRFM4mR8+Y?=
 =?us-ascii?Q?NdPy63kDrMFxHZn6ikq7xE+VCiHWMATCZIo2WfNGy99H/MIZLMpojovJATq1?=
 =?us-ascii?Q?1NptyYXcjCMJSFuKe+AjSWVAXkS7gzbzMMonZccpWirocKill7+iRfq2ToX6?=
 =?us-ascii?Q?FIMAwVMxKVTTe4/oVi4pl6wAZASVlBjx6MyUr3Lgi2wHwbcn+zqio8Rn/IK6?=
 =?us-ascii?Q?hi8YvUV2JtZ4mZOF/88JJAinTYuykn6XI4CB4Zazk+S/riJPN/TDgy2mqyvQ?=
 =?us-ascii?Q?g/S7JnJf6Y5GLJR8ZQuvz9eDUaUst/BMQl8KSS7zs6WHiX/zZucNGcIyryLf?=
 =?us-ascii?Q?OmvOO2dReWsiZoTcTw1JlMbnIEdDB3BRLcd6dARY3CdEjEheOpYwJ8503BAh?=
 =?us-ascii?Q?zFn70l8F1NTaexSt8Kr9ZOusgH5bTEdYCRsYdGEE0cGMHJoWAyj/TnEUw61o?=
 =?us-ascii?Q?esz6/HP8sQFXLLOxcfidOXvGNsVOavezmgLFP09QJjl6mlphVaaupfsuW4sW?=
 =?us-ascii?Q?xKgm99T0IUtHzt9/cdP8g2oJV142PTg/2WgqdpGgEga6zZcFBbZHImUHD2ZQ?=
 =?us-ascii?Q?TTgUSbj+ilmq7cQXj/4oRagVbvsai88HsRx/O8LjFvaUL9wpAMCH3AWwfo5m?=
 =?us-ascii?Q?vu2RrDQPOrv2vfvoLsdM9Gk2l8GIVXN3FljG5RHHJG9AZJILEEmKpLo6W77U?=
 =?us-ascii?Q?p++7YDtExgyty9IhzDFKN+HTRcGX2jsM42nFk26UKWbEX8P5UCc3j7T8FceA?=
 =?us-ascii?Q?cn8H+IB0/kVjsuAwqbOWJKZrTWVKIr5zR+IkEX339dSz1d/5jGF4KLeexYC0?=
 =?us-ascii?Q?b88wcX80HtBvB3j06Wuqj5xuTrPrt4eMvOFqAN0jDl1IAOA+sTHqbta/THHY?=
 =?us-ascii?Q?qxfHX0OmEEszeTat3wspDA2p7EPdY31F55K751Jvd2tPGtBeJ4of+tBWoQjy?=
 =?us-ascii?Q?s429anpuibHcI2tGG8frMoBij5AM6P3A+1L+pewxoNONb5f4uVQONa2M6m43?=
 =?us-ascii?Q?q2sZnhfz1zDLUcDmva/27KjWk8dtjmH4AWr71zCvANZkY+jTctwAo6zdi0fa?=
 =?us-ascii?Q?sj4VkiEF+aNSwzzFChpwuf9W0LTn+ShUAEEGsJUQFizk01S0WhdNuJbPnYU6?=
 =?us-ascii?Q?7iSyMeIYKS7sKFLYT16gG+dJ8emurbl/Nqa5Ip+wge0KlFUQonvKr2InQRbB?=
 =?us-ascii?Q?gtdzqI1JMDcCNAOnP41AO4rhzwTqcCi7Jsm8+xowA8wSETgxt1yATxOiXWoS?=
 =?us-ascii?Q?hCd1me2SmxaLrh107C3TgVcUmPyagb+oTvIuFxo+RBPpgZXtpl2LIbfkbvnG?=
 =?us-ascii?Q?L9wO2uXPoun+zsgSFVClUUmvmhqPmmGbMJrR7M9DpCCwcpfnQztX3EZGA/ow?=
 =?us-ascii?Q?zRY/GIGz6qJpjaDT4ixrDmY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D48A8792B9B2AB48A6D7A2EED63CD179@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F/f/vBkAsU3mPTx1PCMOODAcSliQ2xeZlVWtBNkaesS6T1XbLZGerr++wncJiX1RAFrXpAfyV1OAhAKVyqOA94cie3XaF4BhRDk5cFcG71cH14YquC6CNDnGDeyZvwC3h0PTXYZ6L9itVYCnbIifwHCIhuqoX64HhYUB2jgtyu1itzPayOyQvb0xpoh47VHruinvaZ1uN8P7UTZgiEpedZyvtwxP9Yj1gKZSU5jcoXM3umGmt2qRtsCwPLVWkguR/usUWZf+B1IHqUeI5zLNS0QrbQygvrkQq9s1kq62hAeOSabz58bGpGEI8A/5uHccAeTIxn2rsw0LIfEPqGW/Hs+PzjL3Nz3hnVAqk7aHSXIIOy6HYpa7NgifokQEaalDSi2XOcQ1c0QrTQciVb3Dgfj+WZBd2nG2gdRGXMWB5RyX5W7HInydaeANOPwojOey26IyG44OwgkEKiLwZSkIP9LWtqM2J6I911ga9NMhB0GKzla34GXW1IOCCnaeYcsb4QlSqfMmax9wnD88xhmDI9dIWyHrfcy5R6LOCiD+Z2c54ivzab7CPrFqu+45PRExytvslrNcYAcS7LdDLKKc7mg4TtLk5q9fOheJrx6f31adpXI/zY7GMvlS0CZWgmEkP7abJCvNzEk5gBqMCdK1TAunAqCpz9jHTY1Zm5dxzTf46cm36bCoQzBmJXhs69br1oQWGeYITg01eCqm7MvyY/vgPcw+EY5XbRHQ0aUMmZC8e4TkJE8AUdyT8w45Z5d4yg0O0TeWoPsOfVoyKfRMjufO5t+2E/FElNteUqn+Hqbf3DVxCCwktFC/++U81p6d
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e946d6-a8e7-4f4f-995d-08dbdbbc3b18
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2023 15:56:09.4345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JbcA27I9EOiv1WVGck7sTUjsSHlfXKYru1Xsd/FKfducU+r4GUxX365A32x44PHPd58TokmsWzpLgacKwgRpQLlDSDq+q5+GQeCfA7W9eY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-02_05,2023-11-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311020129
X-Proofpoint-GUID: BMSVKkPZoJn-yFuYvzVlpserKif3E1-b
X-Proofpoint-ORIG-GUID: BMSVKkPZoJn-yFuYvzVlpserKif3E1-b
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 31, 2023, at 12:12 PM, Justin Tee <justintee8345@gmail.com> wrote:
>=20
> Update lpfc to revision 14.2.0.16
>=20
> This patch set contains a user input range check correction, static code
> analyzer fixes, refactoring of clean up code, and logging enhancements.
>=20
> The patches were cut against Martin's 6.7/scsi-queue tree.
>=20
> Justin Tee (9):
>  lpfc: Correct maximum PCI function value for RAS fw logging
>  lpfc: Fix possible file string name overflow when updating firmware
>  lpfc: Fix list_entry null check warning in lpfc_cmpl_els_plogi
>  lpfc: Eliminate unnecessary relocking in lpfc_check_nlp_post_devloss
>  lpfc: Return early in lpfc_poll_eratt when the driver is unloading
>  lpfc: Refactor and clean up mailbox command memory free
>  lpfc: Enhance driver logging for selected discovery events
>  lpfc: Update lpfc version to 14.2.0.16
>  lpfc: Copyright updates for 14.2.0.16 patches
>=20
> drivers/scsi/lpfc/lpfc.h         |  1 +
> drivers/scsi/lpfc/lpfc_attr.c    |  4 +--
> drivers/scsi/lpfc/lpfc_els.c     | 53 ++++++++++++++++++++------------
> drivers/scsi/lpfc/lpfc_hbadisc.c |  2 +-
> drivers/scsi/lpfc/lpfc_init.c    |  4 +--
> drivers/scsi/lpfc/lpfc_mbox.c    |  6 ++--
> drivers/scsi/lpfc/lpfc_mem.c     | 47 ++++++++++++++++------------
> drivers/scsi/lpfc/lpfc_sli.c     | 20 +++++++++---
> drivers/scsi/lpfc/lpfc_sli.h     | 10 +++---
> drivers/scsi/lpfc/lpfc_version.h |  2 +-
> 10 files changed, 93 insertions(+), 56 deletions(-)
>=20
> --=20
> 2.38.0
>=20

For the series

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

