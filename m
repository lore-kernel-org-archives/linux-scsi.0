Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F97AC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 17:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbiHCRad (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 13:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238162AbiHCRac (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 13:30:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DA213D32
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 10:30:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273HDlcf023847;
        Wed, 3 Aug 2022 17:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yAQ/yh35j6AQtJ45DmzmslfsE/ArJHKdFfMu/GmZjDE=;
 b=j8CfMxaEi0xYypp8arwRCRqajEocLGtar/AanMP8MCxRWuYzNVML8oNB66e4222eiC1n
 X2AjmbB8MFUiPwbPgUoYrAgKwuS6gMK73ZNl6Hgr8rypLDviIBdLGaDOjL0itLJ0masw
 JFzmN9WBy1WOsOVivrDmwiDWepJhS1KgZBXtAGUn574SDe5zbI6q9BvF9EY0/4q0EQuU
 J/clgx7xKb2MZFfNynSuzfORqAOxla3Gs9ABV/ix/w86ykHdeOYHtrLr7CnmNhmksAYY
 jaTdfCEKhdS3KVbmkA7jCNOc1lk1dT91brIgrIzCOvnPizQkWVH5NsTD8FZ9UJrjnEFr Kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cag07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 17:30:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273G0MNw030887;
        Wed, 3 Aug 2022 17:30:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33hqff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 17:30:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GavxOwCv7o9uoPGU8IJvJtEHPidkN5FbvyFjcj5UgNqqyAIlXKYNmnNsEKqzdyQRqXFDG0f+8cq4namHCsDQnmOmnhGmCwHnG4Jx4BLZJUgNtA0hGUCh1sjN9kY9mSkYXeKM9AIxkbk/NgLlLNUSzo6gImVEfZ0RHNvq9/QyO3EXEuZUGcpbPkAL06dzuiHlTFzqL/8oj5TmHKjbfYBySa1oKb090Uiop/YlLHiNMq6TEkq2fBb3Iiz70RPOOkvkD1QXBwx21+jxWqs5LOTOaEEXQXulZEPhSDZRcSsVWksibelKRzMpvfMX7GcVf/XoWSKuUVRPrsIbmIVbCbNyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAQ/yh35j6AQtJ45DmzmslfsE/ArJHKdFfMu/GmZjDE=;
 b=Zu0xF8PyPAcyNx3ZIrj2Tn5PUp+kygi44K55eF3d7uKQTCgG1+fzIq/FAka4OxnDNC8dVBxqMaK4ThGoI5Tq0RtRZjpTcGaZzF3AjwtgSXZq+cZ//TMEn0Nu0bBL2Tv6Ec5QdZDdYF7dvfZSx9GeSkmQOby1CSZf8vFvdZ4payurpNwh/+wBARlmFH804z7B37/zLUNdXWwBUWhrqqfMPOVFCGkusetGzttmMurZpaP5zQsAGI9Tlt+wd83Fr5DySbfKgq6OEvg/BmteetBYXuFnC1y+jGmlFsi4AHcJmuGoqXPmUFtcZsfq6sKw8ozyuGIlmq5vvEr7HbSJErdxLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAQ/yh35j6AQtJ45DmzmslfsE/ArJHKdFfMu/GmZjDE=;
 b=UJTEj/0C76AxmPFZIr67LDvzum6vvbdyUy8b3M23h8ERo0oXSwkYlxjq1hNp0nEV/oiGmfIijqzBUQZaKwF291G3cInm4e824ZhQlDnPGVYp6gHmKdUvTTVsP1HLKaUERrNGqvdnS91g1dU1b/S59t5LC4jWIlOA2w8i1ZKwjew=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Wed, 3 Aug
 2022 17:30:25 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 17:30:24 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH v1] qla2xxx: Allow nvme report port registration
Thread-Topic: [PATCH v1] qla2xxx: Allow nvme report port registration
Thread-Index: AQHYong2uB6kih00W02wmOeCno//Va2TzFaAgAmsJgA=
Date:   Wed, 3 Aug 2022 17:30:24 +0000
Message-ID: <76E241FF-6DFC-4CD5-8271-658A1A504577@oracle.com>
References: <20220728115007.4376-1-dwagner@suse.de>
 <20220728134755.fnc4ttqjwwzbm5dl@carbon.lan>
In-Reply-To: <20220728134755.fnc4ttqjwwzbm5dl@carbon.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12050087-c742-4446-8ced-08da7575d988
x-ms-traffictypediagnostic: CO6PR10MB5572:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9vSTMvR+BUh4TrXC9qmL5feASAUB1fflnbKMGn7J/Gm5QUoDo0qhd5jbp8tDjUH4C8Q4eGnvsaIIF/D+wX9sWwMq3rRBJORtGarXmk1epe7IqVI/lxkY4sVPBdLzCciaxmvmnDu9b9RFoA85nJbuIbG7IqseNrZVdQDbAL541WDmuIxAdRCpPOa9sPlFJJ7fynfBe9ewDPDPLIalTb8ZYMxKfeTBpmYjfRsshqSBIl5UbKB6mvNHGxHC1PKAZRL5FvMw9HqU2MMpYi5EdFbAmdYunBxsui4IMw/4/k5aJL2LiMkNVmwzji4Kk6obtirPyDm9S1fquOVOKr9wG7RfHjU4tMidhJ09Zb582TnzYETBlxRJZ7YTTfNEb2+JrCfc7WBiNpi4aSR/FFZxu9Dsj1C0MvUXoUIpSCOQ86I4eBWRJPj2IB05OMB7GGUV5ZiW5iSusDQV76gFVloJCRI9qZC0eXc9ZNA+j6iwOvG+IuWc76hmbt0xIefVY0EOpfFmi1CDYXiW1yb/Kz7JC30VQAmvHiboAIkMmyWXNQw/n20/4f+waO6CKUTl4swGG4jPZ0xHDOXhZMr+yUTF6WIfh3soTws1Fe6BXtsHQzhchFAYdnPk/C1qpwVlip8SUjYcFDn6BQTnD7wetPQW9Oe1l/a1al184+5rdk70QnUYzdVgZ5ablX/bnVCmjwdlfGpQB4CKQZDnxEUU8WX4u650KI7NdKlzqLiMkSXoIrrlkB7sJdYcr+xo8PGtQt9T5rpL2AUw0WKZLr4SAQegLsD6iF7tlcwtYpkJgXvKLgf/xxsTirUpX8G77EhaWMUXz1IW4RLzDjXNRgLwnS5hK2Lrtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(346002)(366004)(376002)(6486002)(41300700001)(83380400001)(91956017)(38100700002)(54906003)(33656002)(86362001)(8936002)(2616005)(71200400001)(44832011)(38070700005)(64756008)(66476007)(53546011)(6506007)(26005)(66946007)(186003)(66556008)(6916009)(122000001)(66446008)(4326008)(316002)(36756003)(8676002)(76116006)(5660300002)(478600001)(2906002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bmiBN6LZHfH6ORDp25US2fdftN6X3aJASepSxdG6HIECTQ94yRpDbFnrLWEA?=
 =?us-ascii?Q?B637/LvBYZyxcTU6A34EHsgPpgDyR28JVFyFOjb+lSnj6fWWWrX68GevXLKn?=
 =?us-ascii?Q?4oesKC5Pq6oBlpqazfFySsEhC+eBg8vg+et/K0mqcNea6zNN28ti3P5r3DyO?=
 =?us-ascii?Q?obN5mDDoTzEcCAQ8BKWqPGqY8kQjpljatUMktMf9ZI2M47RoJErkeoWcULlY?=
 =?us-ascii?Q?03y5+FM14f4mO+XYOxOHc6Gu2fZ06XOYQrw0bQMBvtohELEq8doUtXpsh4wQ?=
 =?us-ascii?Q?OGKXqymfFS5CAasHi66RJow+Iz+Y1es5gjmzWCOpqXAkkkiqzuG/r48W8FYm?=
 =?us-ascii?Q?otSyO0D1dtmFX5BZZH3ILelcMnV62fpSfE+zTRZbKO1ccI6lXYtN3bnH9+7H?=
 =?us-ascii?Q?VkQiYk7kukw0ljF/66yEmqY95coDSqGM1DNVtSc0fq3WWY06J8vmJcLnLj2x?=
 =?us-ascii?Q?9km6f/+HIXMF89KwOfmgoaAB8mpeV9MR3TSizv1fV1+/L+RKbtX1MVLp9Y5b?=
 =?us-ascii?Q?Nz9dYA47l9yu6Qa4yso2M7P0+SYXgymyh1ftMq3bMBYOhzOVpGoIq+LInehl?=
 =?us-ascii?Q?00gK43VvBPeRzkX8qaKL3EzvyhqTej8tOygSP8mDR84jxXE1GTOm7mupjMg/?=
 =?us-ascii?Q?exurZv6sPSALUa+42e+hXvc9N1uDOjQhDLt8vp7ELb5v0E0a06kdW+9iRNkT?=
 =?us-ascii?Q?qZ8BLWvTCgmoYjND0zycbNKMGsMqc+2DvnTnnBI4tm+/IRgw9z9uPOxxikhf?=
 =?us-ascii?Q?NiLNBKeSDzl81oJ2VbA0nbFWaDEyTjDLSBNlZbp4BOuBVT+kkqgbbYeEj0FD?=
 =?us-ascii?Q?aSKuDt95RcFzYBO5tIle3Z9eTv/wC/tojvVvVInyJuluf3NrmiOD8ZLf1p+Z?=
 =?us-ascii?Q?+0RgukCWNLM5MJhU26Nqnte7kmtXR9sHOcueftjDpDpHnmMGUy5c9STdQMjC?=
 =?us-ascii?Q?KO4UbHHNlfpGKAWqOLQJec6T9tArU3nK6Ukhh4vDXcYRbpfLQk5gfczOUGYv?=
 =?us-ascii?Q?OelLaQC48YbfJ9tk4iSaEVIqxvsxO6yPdOY8i6q1JVxDvWP7UqY+pNI0gJ//?=
 =?us-ascii?Q?KY3Mi+CZRm2HdKOjxxxktIA6iSm5y4z4CIbEkWFqyhFP5a3G6ZXvtS5rbZQb?=
 =?us-ascii?Q?SPIAFdFHDkH5i0nVc5B38aFnf1dOFzvhd2j36CTMwUVnfQXlW1+3F4wFR+9R?=
 =?us-ascii?Q?ywRqQoUihkTvGPI4xWb1MXuyvay1XSloleikHT6GoIhPkdJxUmtPqcW6WpBA?=
 =?us-ascii?Q?logDqR6Zy5uBQzZm1S5+Ixxb3Y8MaNnuX1Azr/iMLlE3WHcJvC0OyxtynWvu?=
 =?us-ascii?Q?GNSvKGazWPStiA9nLibex7OwZTOvkRpbEk3sds00mz671ugW6rx6PuSLXAx7?=
 =?us-ascii?Q?TtDXtlNGIttCNIQ9XlE1cc9fTvpPdShmi1BwGi7jzakMqXRydjx6Uo5O8thI?=
 =?us-ascii?Q?b8FU5bGhqNOs2KgbM4Mm6cyJRNQ4D1UKoAh5sh76/BT0nmQleKw14ZzP0oct?=
 =?us-ascii?Q?pkHVElYJ2DGuyjlP555gWgWDCIpS67byrXj7BFf83qWSVWYtmI2Ajxm5JG+F?=
 =?us-ascii?Q?Smoa7DiWAj4jYhFsKrMl52xTljyCdcznYibpwKG10K8L4h4o0zYhABRl/Lnx?=
 =?us-ascii?Q?+g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A513E3344D5AA43B99D077D3605A097@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12050087-c742-4446-8ced-08da7575d988
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2022 17:30:24.6949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MdUbpIxZ9xjTuAqzbxqRNwpruc5nRUqG9MlS/qrGGr5rcZxfhWZfEronIRt5sqi4I09hjx8MGiYm0U/cLdnfaGH/oPfATbWl1i8ktDHqScc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_04,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208030078
X-Proofpoint-GUID: Bm0rsPZ2VNclXkjZMVgNeinjA0t60wH4
X-Proofpoint-ORIG-GUID: Bm0rsPZ2VNclXkjZMVgNeinjA0t60wH4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Daniel,

> On Jul 28, 2022, at 6:47 AM, Daniel Wagner <dwagner@suse.de> wrote:
>=20
> On Thu, Jul 28, 2022 at 01:50:07PM +0200, Daniel Wagner wrote:
>> Move the both ONLINE state check into qla2x00_update_fcport and call
>> both register port register functions.
>>=20
>> Currently, qla2x00_reg_remote_port and qla_nvme_register_remote check
>> the state if it is ONLINE. If it not, the state is set to ONLINE and
>> the function is executed.
>>=20
>> qla2x00_reg_remote_port is called before qla_nvme_register_remote and
>> hence qla_nvme_register_remote will always bail out and never register
>> a nvme remote port.
>>=20
>> Fixes: 6a45c8e137d4 ("scsi: qla2xxx: Fix disk failure to rediscover")
>> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
>> Cc: Quinn Tran <qutran@marvell.com>
>> Cc: Nilesh Javali <njavali@marvell.com>
>> Signed-off-by: Daniel Wagner <dwagner@suse.de>
>=20
> I see the offending patch got reverted. FWIW, this patch works for me
> fine.

Do you see issue with reverted patch?=20

I see no issues with the code change per say, just want to understand if
you were seeing issue with the offending patch reverted as well?=20

--
Himanshu Madhani	Oracle Linux Engineering

