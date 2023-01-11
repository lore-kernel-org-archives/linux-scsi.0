Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBB0C5479D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 18:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjAKSbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 13:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbjAKSag (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 13:30:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8434743
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 10:30:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BIE9ck007161;
        Wed, 11 Jan 2023 18:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VZrbHvCajH55RprbZpXls5H7FPaVTlp0rpAAMSVAJXc=;
 b=XPAt70wbP2gg+HAlAzWVKdXTwaglewOZUo9tPo2JT7iXEiwTAIXB3BFPsO4X2kVHVDjp
 +dzl+r7HfHcrZPulI1CxRaF0gd8Q0JSHuddIH8/QBiOWJOj8pBMVmuycQc0BwojIhGC0
 pFvDyUdCitdmtuI8pv5L1YtnwBB//QSMbOS/ORQx3w0Ne+eOOjnsWemUEV1GHyIMzaon
 AgSNL5zRZKlh83ThSZ6uYaHWI8en3HkmER6tpyv6zGQvMRHucYvtmIZU9EtNsW8XCtGU
 IpnpgPjVamV29/r2hkFHTwjKk6rxlsM4Gz3dmanp1Gj4XG0NjlR+hoMnHxMfecb+7ayr Eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n185tbcmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 18:30:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30BHWuEV022630;
        Wed, 11 Jan 2023 18:30:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4e41t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Jan 2023 18:30:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DETwKP5r/xbwvD3l5xh5DhoHYSYp/5wIF/PlMYj2o2vIb2GtTGLEvH8UXtjJxqQLiJwjhxComfmOhsyV6Ijilp8GcYyKIr9H7/25wbqnL/waAZbcNKHY+EAT+h4FDT4rCGXpxAti7ARL6uID7G9Tki3RWZd5h2yEbjdJp/tF5OjvG9xmEs4bzPyS9BUDZCeCTpLiu+wWtXNU8kz9e0wfAVBrLkmahVOzBe2jAwwHs6eRAENp5/yN9d6gDR2+/L96BRP7COBiSGVgirViST3jCSCZVQNo35oB4J2GrFlpbSaefVyQgXSbFztFZYndTIzySH9Xbt6B6JjiN48OelLXbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZrbHvCajH55RprbZpXls5H7FPaVTlp0rpAAMSVAJXc=;
 b=AgAirMB3rIkQTe6atfGs2l6zpyWL/QzEXktaHYuvp20WIvLdyI0Lra28M0Xs2WgBUIjvJ+tT8SnqpujPJ9P0sVHYGuvyG7yWiEYGg56mNurHjL1UpweF98sDPp0wV07Ao8IWdzzd53RACcZzSOnzWc1khS59eJBFXcB6WNcjuW8u98JMKu6IjOV/IqITJASd9FelBg15u+JYU21HYFR+Mm0U4/vgVz4ogeF7R0TiFRyCADC5Zq+5XfxlMPIrryPrS8sBQ1KqKF06xoS98utN2Gt+LFBbRt6a+XdUkGoR6o4SqNPbF44rBwzxyb0xEK+4h5ziXelIjy7Tq0CuiLPV7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZrbHvCajH55RprbZpXls5H7FPaVTlp0rpAAMSVAJXc=;
 b=yA+T0zyNgHUfOgxXGiUyfwpoV4ZjIeHhS95Wp0cVU30oSJjIPCesvT7F08OZNim1FEYIn+5TMfKJC/XxiUWs9oOo9mHmvYdk+K04u4awmz5mdZicY/ktsREH5eRs8L4h9wooTRNVMGVJbWmsCjJeEFyglTlnfTSaIuwSN5KLJtw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH3PR10MB7395.namprd10.prod.outlook.com (2603:10b6:610:147::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Wed, 11 Jan
 2023 18:30:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5944.019; Wed, 11 Jan 2023
 18:30:32 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Quinn Tran <qutran@marvell.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>
Subject: Re: [PATCH 07/10] qla2xxx: edif - Reduce memory usage during low IO
Thread-Topic: [PATCH 07/10] qla2xxx: edif - Reduce memory usage during low IO
Thread-Index: AQHZFb+K8AfbH9OnkEaliWFuLhcJfq6WupmAgAH51aCAAM15wIAAKCCA
Date:   Wed, 11 Jan 2023 18:30:32 +0000
Message-ID: <3275E25D-63A7-47EF-A79A-873DFCDE6EC2@oracle.com>
References: <20221222043933.2825-1-njavali@marvell.com>
 <20221222043933.2825-8-njavali@marvell.com>
 <698E44FC-670D-4B12-AE8B-9A9B789B546B@oracle.com>
 <CO6PR18MB45000483BCBD811F77B98D72AFFC9@CO6PR18MB4500.namprd18.prod.outlook.com>
 <BY5PR18MB3345E0DB6B84EFA5AD669857D5FC9@BY5PR18MB3345.namprd18.prod.outlook.com>
In-Reply-To: <BY5PR18MB3345E0DB6B84EFA5AD669857D5FC9@BY5PR18MB3345.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.300.101.1.3)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CH3PR10MB7395:EE_
x-ms-office365-filtering-correlation-id: def6003c-1585-482b-bb2e-08daf401ec2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z6RnqHQdlacXJeG2kz0Fz8/qVWacnq9mG2EDH46XLmGg6BxmT4Lzwp4KR8wdaUBboFayCydPe3BhPHEs8xJnpom+IyeXesGEmvNnsBN1Pujhl9QswD1PqKgBFdFVqWuKzzlwKRsCvjscEqDhsL9cucUzDWpdLCDjAdcJagZQMBw6XZxjcXC5LbYi8a2Z9v3/w9xH2f84e+gPqk4EGCydu3910wf/iXmv51uUTE2d+JiY4ls9xypLxK5EjjLpMT/+SxHkzxjM3H6LymOUhGTfxH7l2JpyYyabhezqyrSIR6+A+PJEaNkzBZCzPUNcwKSf/NRnF9HmLTCRS2BsDoYySeqcX1a9RMP4FJUYeKWMjoGUkC8t5piyl2A1ECmIqNxTudwvqxt3Q4S7ANMy0JLI+zYKCQsJeiKhq/Gmj6TriIgkK3IvtG6W7ahKCcRkWMFNP7DtJjf8GZC85uqGjkBSTEu1LUxtVEQJG/cJC7mQRVawAsJ7CzWYJ+M8TENJPLne50ZP9vzJe1gT1vDC2jCQy86DHftGqyLb3kJCvY7Z6hYVYDRrsNls/4CjQCG8zt4TBt99tM70R1ipNjCAgxwdo52loKYoaSMa4pxTMFx5um9WjeX2Li6CgryAV6JCs3u/pZtpUbg2WkgcNjrHj4mxTyTj2KNij027Rzr1zHyBCcvzIimyADDy56xJF8d8XGHPM65/6a0Wq7DdS4Hr0PQ6RDWo+HlYrDNWr6tyjcY4hDA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199015)(66446008)(44832011)(4744005)(2906002)(41300700001)(66476007)(4326008)(6916009)(8676002)(64756008)(86362001)(8936002)(66556008)(76116006)(91956017)(36756003)(5660300002)(316002)(33656002)(66946007)(6486002)(83380400001)(71200400001)(6512007)(478600001)(186003)(53546011)(2616005)(6506007)(54906003)(38070700005)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8RNqXDuh3VXgmehNLRHQSSJP5npE1sjhkdsUb8BffWM7w8p1c7R7DscaMf76?=
 =?us-ascii?Q?sA1YzCai/lzcjN117da48d5bMULRcHjfn9aDjOIcnA3HPR3friir5FfN3DNy?=
 =?us-ascii?Q?5Rnr+84xmBVnMD0LbKAX2AoJcgcGOVazKMspnHSYsxGxTtMRFAnof6H0bTMg?=
 =?us-ascii?Q?JKMSY/MiwkmJKiW3Jp0p73Wg4de951JyP4HmLwLBdLqaK5DPVhsgwu9I/X8M?=
 =?us-ascii?Q?K2ZoGfShwe/HyXQio3XW+cAuaVfwozaeDH85zdYB6HlZp65pB2tTPi63Mdij?=
 =?us-ascii?Q?bSw4DlvRRIv8Jrfbv7bvwPsE0rBPOfqIgrjPaxXY6uxs/yqaQjiyXXqICFbv?=
 =?us-ascii?Q?EhBEsKhuzsTb60q6BoVgehUy3zWlTmx7BiZQl8w4LGxucvl62hEbQg4fVx4K?=
 =?us-ascii?Q?JC+z7mKYXZaZ2EVPgZF+c3m/WyfHad2zEQ/yPylHkVHsBuxVdzSXOJK0Zagc?=
 =?us-ascii?Q?+AKZ5i7uRy0pnjrC5SJCM7TKvVZUaxmGunu4gnoZ4ESk0XYwsON2q7kP9xSp?=
 =?us-ascii?Q?59b8V2qxSn+DvREH8bCYDkS6ZRoyJZIIaklO7XFwVitssPeT592aG6N/ACMc?=
 =?us-ascii?Q?jWqUMycPJ/fV2zEXinDgnTiwq1OY6AezPAe2h6Np/aBJVzfxU2TbaworWlgd?=
 =?us-ascii?Q?qFrrjkP64A4Q+UQ/02PbfQSPxQ3H4B66BXw4qawNye5VqEekznM50TLHXPVd?=
 =?us-ascii?Q?caa0IeCz59QYaFfQlAP+dNi7iNjr8ivYUzGzzbKkTKcnvN9/z+ouMB3nHTBx?=
 =?us-ascii?Q?3AvMNrgnFYYEfpzmz+D/sd5Utg4etzrSvGxwA4zIkbPgCNuN1QOGIe2rOOSQ?=
 =?us-ascii?Q?na3fsU74bX81a+xJnlED6ReTXpOnd39Yg+S/s4oiwMT98qRuQGLEZSzPA15N?=
 =?us-ascii?Q?KtKSWT71OaUQJFw5PUje1h8k766W/L6pCtmYmRfeHIDsY/MTmLMoeNWANl40?=
 =?us-ascii?Q?+GrW2zp/gHivH+XAckXMcZBKBQUxvaJX5yW3b1yFCdJVbW+LEj21twCNrWAL?=
 =?us-ascii?Q?ceAKpSjDPjoxarNwbjnQTvwMw8gbJxeHQFXPkruUWrfWMmCeCmRFoSzmEJ2z?=
 =?us-ascii?Q?ABINBO/3ktzfDBOx4qA6YhRGI+WocfU2CgdBoNgVIZ1jkhM3K1DxUAAhjVNE?=
 =?us-ascii?Q?+8OxObOjsgPNihNbAq1P4F/tf3D75KIRg4lh7/950pZGpM2nKnNj7he3OZre?=
 =?us-ascii?Q?6muvBNQN7b+i8QfcbHLSqpeMOqNEnjLtLR0ZVjQihI+oiozWkHgVJOA2jUUz?=
 =?us-ascii?Q?0CiLtGvBDAbE0j7VSehALyNXHnbrSjKpiJrh3TmcwPi9nwPlmqKN2/KEBuri?=
 =?us-ascii?Q?MEyOAo7iAN8djxRKGaOms1/yM2/Ds5n+A52wB5fTh+KB7kzfcAHa1Cnufw4k?=
 =?us-ascii?Q?ffmoQlh9cwGojK9cLn4QmDsi7/v/Teksaj8oJ/NDTPCbcGZ0Z+c+ngCr3OFK?=
 =?us-ascii?Q?UUwW7IIKYH7LeWGrM72bCX6XCeOZYsQHYRBLsedkvI6CY4kdnsGx4+pFDSaX?=
 =?us-ascii?Q?WyrGYu+tUr3N3NrLpMzZ69pIVjvllY5TrMqzsawNXNxQtcxxDLAuFKWjpILD?=
 =?us-ascii?Q?NXHg+cJQARALDdgUA5B/lh5uYPMoqInS9rc2j9fpU7XK55EUzJOIxZ3i38Za?=
 =?us-ascii?Q?7huOjnrwc8Loi60hKUqLhVRE9FVa6ZDuE+EMxIxnUg9eRhhmnk7TD1X0eLda?=
 =?us-ascii?Q?nsgeV5wmZr8w75Zf57qg+iK9x6I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C22DFFEC7CCFA4CB3E9729EB4966270@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jcp8kr8Z6XnzjPwGlza9SrYO1nNROZpUuFFwXpBJjGxR/l7udMwMtoPXtvyNEhOgVQXLMEsR0etUOiKnz8lGqfIZIm0TBfXCJKsSnKBh3ugrVrxc5iXv1aV0W+bcczP+27Qi6Hn50FP/D9U7hLw7g71hf8Pqnfb8a1pNJNk5AYaoAFzl0klh1B4n52G+yP5abZeiX4UJ2AaP7z2Nrw1xt2prksH7zhpz/3rObAcI4EoMJPxG8KJemm2QndhQRMPippyacnCt4bCdjMRuEzdCzU+Io2+6nR8gih+wDjZaxqg0W7PBXKzkCNqn339svIDVJyCpWyQcenEo+8bbqzMxcYuQRjoyku8O4jNzQd1C0dnJQ22JuiutrA+fKfAbYW7Y70WoDJRUTPx5OnHM+0h0VT6ex+9W3KuqlqkCYdsVZFulDL4I4ifR5F0fyNcBOZ8dr5bScog+FDOsG/A81y3xpYffGAMwgDY+SG4+nWV0OrnjpDy+grQu9cuDro3VwggmIMo+eb3lBLwEe5ncYb+QfYaeDzBYi4cV7gZHqHsktRJlqlGRBrqNWSJq8pIROapgFTVb9csOlSSnLVjJmmgrZzvZ6V4xRd3opVlFOSe9vjY79OiclAb/3nyJQ6Vor1BncQQO/sX5ipjylRtDMJnGhBOSwxF1CwOTj9/Wmjlpma4HceGJ7DupNsPB3hfbr1kg/+7Ja9L6frgU2HgmTzq+EznMEyjs8OgWcZoVLfeSdxRGlB2sQitpExt0TBO9maPumUm0OVEZL/qFNJUoSTz7JRmqeFAfemGR12wInnc/g38=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def6003c-1585-482b-bb2e-08daf401ec2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 18:30:32.0623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lp8PjIx+sp5XFKiXLcylpm0IK+O8Q5coqYmaYe8jmnX0c/PLtH1r5hi1dw01SCUFcrOfvfNzHRiitfnodiWXQNBtGuvbfn2Lph1nBeF7l0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7395
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_08,2023-01-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110136
X-Proofpoint-ORIG-GUID: Hxg4d5W95F0viJvpfKfeSDscp1jNyarg
X-Proofpoint-GUID: Hxg4d5W95F0viJvpfKfeSDscp1jNyarg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 11, 2023, at 8:53 AM, Quinn Tran <qutran@marvell.com> wrote:
>=20
> +void __qla_adjust_buf(struct qla_qpair *qp)
> +{
> + u32 trim;
> +
> + qp->buf_pool.take_snapshot =3D 0;
> + qp->buf_pool.prev_max =3D qp->buf_pool.max_used;
> + qp->buf_pool.max_used =3D qp->buf_pool.num_active;
> +
> + if (qp->buf_pool.prev_max > qp->buf_pool.max_used &&
>=20
> You are assigning qp->buf_pool.prev_max with the value from qp->buf_pool.=
max_used a couple of lines above to max_used ... . This check looks incorre=
ct because now the value for buf_pool.prev_max will be the same as buf_pool=
.max_used.=20
>=20
> Am I missing something?
>=20
> QT:  Thanks for the review.    The 'qp->buf_pool.max_used =3D qp->buf_poo=
l.num_active;'  line seems to be overlooked.  It changes max_used, where pr=
ev_max is not the same as max_used.
>=20

Indeed. Thanks for the clarification. Rest of the patch looks good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

