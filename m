Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8270C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 02:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A589561155
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 02:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhIOCbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 22:31:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2592 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhIOCbX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 22:31:23 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EKxaMn026025;
        Wed, 15 Sep 2021 02:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=RaiRTZgeHE5J11XVzj/tsDF/pPjf/NWDvykiajyTRhU=;
 b=B3NCzivbffjc/qScBITOX4m9C9B6UA2jyrR9lNnlQuBifffoKpJKV3VQKFKw37cQNt9O
 ikgN8AYr1gOoi7rJSQjBt/wI4aZ+L2oUn+zQdEkKy3F4D7+ui2lcn31YWefUjHsBa7wD
 pXH644LzL1NnN4iQlbPAq0GIEE/dyQQ2thd/+AsEK94q4itjL/Wz9mHBR6C0KWmQaTCh
 CRGinq4d/Ep4JpjruxKDJ7pP5jEk8gh12OfO6Raa3M++66XmcTfVtUMYg3y7VSIpO4Vk
 Kv/F1XomdySfW1KSiA14bjhhc9EMk1Ei3xonTToM++Wy3F/emPYQBohlHsGbCDo1Ui6z tg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RaiRTZgeHE5J11XVzj/tsDF/pPjf/NWDvykiajyTRhU=;
 b=TO4mTJAf67iBbF2uYZ+Nr4HqWp6B0pDwkVhlD0kwUiI69+nr5eJ0Sl+ZXmubGGj6oWFm
 qIAa2tASsj80K1cTzz2zWxar3W+pmpPzIATWzbN9yn2AygrpFZqwD4t3HhifWWBymapQ
 5mfgGiI98cJXj5Hi75gPCJWEjn7g4v7c8E5BKpvT63MGW4o8OePRdDsnJU30UU63Kt7p
 jkW0HBcN5kPge7CmKgjYK9WGWpe3mwdFbh/tFpK6jA+NHtjNJyuD9zVBJb9fA0KDJcVg
 dDJoxsv0xPTFVoi1O0bOIIqJWGw5uWKwMwtoruKoYKqqBAiqDHUwRWItjZzNwymGbTY2 oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2j4sbtuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 02:30:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F2ARaJ069962;
        Wed, 15 Sep 2021 02:30:01 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by aserp3020.oracle.com with ESMTP id 3b0m9756qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 02:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLgU6HhhMsfp4OcPg/yHHvxm5i7cR7EPSAaX8nSTvvhuU85+S8UHHKJnhaQoEnvHKlZv6TRqViZDKSRjOpR3WeiekN8RF0IBToTgNTlbvVOR5yM+iIfd8xcJJeuYf2eFKFV5LewAlZ/VpdChK3zJ2lWQrPkqED1yf3IVF60KRNUUf9rPl7HXevlcSVMhPYvpNM70lz4T2F6C93H0n8UV6iClrfTAoRm6nsAytD20uecPA/Jc01QNNjmT503N1PV2GOX43/VjBVDCu+j/KRiv3gCmMfphdY7i1lcpqyrLpZhq95/nJZBEyI3rFqvHrxsUwDmYVPulJQnZgUvnV0Ch2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RaiRTZgeHE5J11XVzj/tsDF/pPjf/NWDvykiajyTRhU=;
 b=LwkNftG2ToOiNLjeb6Pq7x1clf2jpS7t+uwN/1GQIofNKBzem17JpRr4Jp5pyvf03rALtEsaWSddoss+mgXtzlqMGxuuaDtL90mcfIVkB/ry4WrUzWm9rT1uPCOk+wgpoPWXFO4M2vzNcGQbxtRl1iLKuHrgSVZUlw8phKpMAGNWaL/9B2bmr5cQKSQZIKXWIO2AX7BnJKQUeIpNJK1gs5V/6KpCZtE3yz/RkZPnqOIZrPfvNzQwWzo2jbkSe6bLoQhaCVLlw3nvMjWK3jcIKgNd24VclWu6puDKx6ethjV6g1dkm450hUaWnK392bQz6u9/pC4tNSzsouwbay3QRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaiRTZgeHE5J11XVzj/tsDF/pPjf/NWDvykiajyTRhU=;
 b=lwncJ3QsS69wfqCzv8ms0ibd9LiZOoSLiE/Q2xKwiIspcZeK5TPahOzXj+yyjtocC+6gJaMDTYHooSmi3Oy2E5IBkINXZlcq1/HF5stmhL4WtDRcUg+nmGIw2wb8dH1mX8YLDkBFYazeaHdcaY8MNnEFuTvpthb5ztTEPWeUuWQ=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Wed, 15 Sep
 2021 02:29:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 02:29:58 +0000
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH v2 0/4] pm80xx updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kamy3jj.fsf@ca-mkp.ca.oracle.com>
References: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
Date:   Tue, 14 Sep 2021 22:29:56 -0400
In-Reply-To: <20210906170404.5682-1-Ajish.Koshy@microchip.com> (Ajish Koshy's
        message of "Mon, 6 Sep 2021 22:34:00 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:806:f2::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SN7PR04CA0024.namprd04.prod.outlook.com (2603:10b6:806:f2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16 via Frontend Transport; Wed, 15 Sep 2021 02:29:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af054cd9-3e89-4907-89b3-08d977f0b67c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB448606E5194C3A480A8A5A668EDB9@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:241;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FwsJXX1hxP5ea8Md+QbfjttXv0THnkA5q/US0lR74OVVaf1Y20u1rE20HSHVI2ba95nuDPIw2dZZN25R6CBUJVmkaqB5PdmWu3/Xf1fYjMZjTuaFX4XVIb2vLd3Tx0ziynXtuIHFxbK4U3ATFFlCzjfozz/zMKW2bbPnPr2Wjj4mP/ixO2fn4oGeMRZJaqoLq+yePVIabBXqThJo2G+d8TSh7zaSqi//xL+4Ltr67b5L2hSRWbQIwQvTY/a61mHyQzq2j1AkS5kTust0CRZ+W7lPyA+dzdAOJtzNE4Vhj70msyPV16VMHD8bCh0b5qjZ+9ie/xJtJza3m1RD2bvOLk0UuIDEh+tLeS4/5rxgMdNRhPOPvI8gUOnxxaK9EVRjkFFkR1kj6gcTakS/d/FHHoYAet7KrFtnJEz0pEuds+mB097kJXgdEW9Q0p2UEJymXap20XLYRo3hHL11LiKowqyCvkGk7QZAo9JIVgKgW8ukTCaSr+jGKUSJ41viWzcC0fHUVAinmkJta9CsxltPKYX71/f7QYnsbgEV9VX7cx59ri/CHfcTeoVbbKggSdrt7AI2gBGYNPPjaTYNQuLliASchmIqacG0jvYhpVWVxiUzoMZhjJ35JjpRUAxCntPVDrVV78KLc603BUToTLtnS4Ro9ZGV+LH9EHVv8mq2UIPamgZewQZrAqG+xrZMGDmBI2O5VIArTWwFfOhW6S1OVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(346002)(376002)(52116002)(5660300002)(7696005)(26005)(4326008)(36916002)(478600001)(55016002)(186003)(2906002)(956004)(8936002)(316002)(38350700002)(66476007)(66556008)(4744005)(8676002)(83380400001)(38100700002)(66946007)(86362001)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZFWztiZ4QpQPgmuMQyfMXvbdihbe0SwEh9pskTlvc1cFHOCpLCyISGK76gmD?=
 =?us-ascii?Q?zl1VYJEQ0ER3KGa2Y3NQEH299f+QNIFZw6f5cIGuPq2URZeRfPcE7HOw6BNY?=
 =?us-ascii?Q?1t3D2bnhKNGlcqroN2XZgcoSFOQulQ/ychEMdKnc0XvfGMgdJ/Ik614IvDrz?=
 =?us-ascii?Q?k105QW3USWiXttDeAOYqof8uKroUvwIXmHhe3kdsqs82t9l/Auc3tYTAvrOV?=
 =?us-ascii?Q?m1uTHAyZaZcn3QMdY2OdSvDjij9CfrDCOclKJcJqI/l2TFaxVfK6Me3xVooq?=
 =?us-ascii?Q?bQS+eP+6cNPSJss/Li95CRA41ENYcPITszE11tQZwI7p2RhpKSOzvLRWRCBn?=
 =?us-ascii?Q?HospJpRa9ps+tqWMVQr7OHcEMtleB2eYCf+KLbgvrsNoCZJdrcSRXY6m/j2B?=
 =?us-ascii?Q?Dwp+mSDpH8vVkUfL695HDF9Gd3wTcdYyWerKjFn1M/KQ9rqHN0lAdMNTXnU3?=
 =?us-ascii?Q?aOlzt2cRLTT4fAwHDMj28DIN2tDGRVE/oX7+Bzai28rxHDU7Kuu+rP3HWs6Z?=
 =?us-ascii?Q?Phkzl7iERhDtYslKf/5W53lF1eaA+mj3G4wWJyOvGmM9yaFnUwTNxUvk4lBt?=
 =?us-ascii?Q?9VzU6+OsmGtkdSrDxLd6XSId+7kcomym81x36HI3aG0vU69Bw7mLDPZozQa+?=
 =?us-ascii?Q?hy4eeWo52Sg2PXJHG68XGML+R/dGb/MN1szAx0NZTRZlWII9NfT/i5TWHP4L?=
 =?us-ascii?Q?KOseWFEmdtq6Z0Y5y0jrCDzsZtUVYaqHjSjg5yfyPaYXOLEhdQPT867Sla8N?=
 =?us-ascii?Q?XKoQAY++wCB/fp2G/V0fj/ku2dOfBJMXqtLHi1h4iuUUvzsKyi5kVHVa44Oz?=
 =?us-ascii?Q?xZb7dC/GAnQsHP2G5y3ifG62Bh/WphDHTiZQsBe1GgbaJj/Nyv2pc4F3cNwn?=
 =?us-ascii?Q?DcOOmyadgyzR486M+yKI7uOWHK0tWyN8pxcS2oCIJWAs6FXHDb2pAbj5Vce1?=
 =?us-ascii?Q?TfCCAouZafGLWezLbp/Q5ee9b+B2mEQcJR1hhRGapnbmGN65WgQuT3Lb7dZ0?=
 =?us-ascii?Q?NqN4TOPFACVP6xY8gbU4o8VayvttRBDHWu0RDK1Bul4tFztXALXm7QxmHJO+?=
 =?us-ascii?Q?g83Kge9vC+Ev5ccVmVZmJVJepxNtsOsemDcfwvca1En2lH7wOI0Mm/8suCMW?=
 =?us-ascii?Q?OpbvARyvXu/z31AFxiODJh6rCs/Cgf6QL5Q47EE/KZJd2X9pQPM/iMOUWyEA?=
 =?us-ascii?Q?7IHFkaRqCP8pfu3MXulCkhO3h2NXeNO175sb9csSEdlCxJvVoWd5r1mWaBLb?=
 =?us-ascii?Q?R7SqFw6SNxRpzKioVXbJRN4HK7cE/6vsigK7s2AebYPX8eVDRFp3Y8TIvnO9?=
 =?us-ascii?Q?e/TrtkaeL8/OEU1+GLr2YxFt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af054cd9-3e89-4907-89b3-08d977f0b67c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 02:29:58.8829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOSqbNYhfL+Ih2iiZjprBivNp2QJSCKyYew1XkIBdJImafOL6PbNLRA8TMCX9nRJeijH3VnyxzkutS7EUK6uQawqQiWDhcXZrDFtd5+jihs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150012
X-Proofpoint-ORIG-GUID: d62AVDnfnvWGO4VaqT2sJ7iNSJ_R4dbs
X-Proofpoint-GUID: d62AVDnfnvWGO4VaqT2sJ7iNSJ_R4dbs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ajish,

> This patchset includes bugfixes for pm80xx driver
>
> Ajish Koshy (3):
>   scsi: pm80xx: fix incorrect port value when registering a device
>   scsi: pm80xx: fix lockup due to commit <1f02beff224e>
>   scsi: pm80xx: fix memory leak during rmmod
>
> Viswas G (1):
>   scsi: pm80xx: Corrected Inbound and Outbound queue logging

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
