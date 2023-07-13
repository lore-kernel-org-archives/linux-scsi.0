Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB51C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjGMTeh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbjGMTeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:34:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F238A2700
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:34:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DJWk0L006726;
        Thu, 13 Jul 2023 19:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3MDRavUnKUFqvrF5V3PjcDRZgXTCzeEZqWRTWH3vj2E=;
 b=pfXg1kpSsewQX31gTLoJuIPVI3Kn6SgGvM35FVDUec4j1jk9JeclZTJq9Kss1M2pvOZU
 TATf96mH0oBXZxm4nm+1QB8mQbHa0nH+5WbOhLGvbd53U5aEprbqnwqD6q89xwdtjLXG
 UYnnJNKVY+qdLfv/xIZXoBxKgQ3JMJsh5WX/welw01FwWhnXCGjcjWVZtMUPQQp6Dzbu
 Uqmn//Ghsj+nkWd9lqbNF/ErooJuVNpZtgxB1oSGf98G3e2FGVxvgkqw5ycSAv619uNg
 5zxiZrIPN/XB23SL5pVlymh3M5GT+Cq3QC1XtjxBE6Chi8BK8qr+uop0LFaDZtxxXmA+ 2Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqgr0056-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:34:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DInCVq008611;
        Thu, 13 Jul 2023 19:34:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvr1ncx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:34:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myPS1KWNSy2fuQ1bBfk+EUjploYecf3TY+LFHKzRco13OTUsPtq1phOsMc7DlWAJ18hgnQqtJxwAo1XK9/ZSobnu2NSyeCSmZw7aED4Esf4eYKJ0jNq6bRN4if0ET8ijJuntitdPnZXe15VgxxHPPBGsSLG9kYPRpKfQmL3D3N7Za7bw8lNa2tD7VrrB/hVtK3AfQXhFhuMmPcEMQzrUn6ZX3SK7ncDkc6RoMoTRQl1ZUD+Gzb9GphRZa/zB1YCQwqKh1SCRntR1uPuHWspVD5F6TVO1JcvAn/nX81y6dbCqBZ1ygl83GZnWwwJHgMr6PcdiFc7nm2cSlugCDdQtOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MDRavUnKUFqvrF5V3PjcDRZgXTCzeEZqWRTWH3vj2E=;
 b=CbF5KMwNGIBpRgQ4LkaW7+EhgEdIUV2HD0s5H512VBIdOVbo1k6HjU1crwefpy/oRF/nXLWRmI3Z6csfNl8lSX7LSN2j4bBgPmqJep6SF83lqpQO156i4TBw2RlPGs0MIrrdOanDFc42xoJCCah1PtGZdSd5Ym7yJ+kvkVr1DC9khO95Fk+Q+nl5PdPHzWpwwglFUGMnarrXltb4uC0TafVoTSnA+JF6+D9bJz3VdMdS4s8NAJcTLUv3oLTb9RVESN35j5FhdJ6yMQpfuO0QU3gxZcRHNmir3jKTnRGzxt8ZNRDfIYtTuhy0aI9pqJ3amMpxCI7wGkkSxGn/M0WPrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MDRavUnKUFqvrF5V3PjcDRZgXTCzeEZqWRTWH3vj2E=;
 b=dERq4kQTk29qLY3FyEZXt7rTNxaYjlgm8ANXTs9aRxVM9+vgXzwrOXxd2Hr5I+m1SG6L9GEqKHZpgLY5KRahkrTyrKmVZKYsvofkXvgb687YLiesU+Ta8BAQFGam7NyPdyUGD1WIAewb+ynVRsL2ZCpidVC0edh/XGlIxMBhNSs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN7PR10MB7032.namprd10.prod.outlook.com (2603:10b6:806:345::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 19:34:12 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 19:34:12 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 08/10] qla2xxx: Fix TMF leak through
Thread-Topic: [PATCH 08/10] qla2xxx: Fix TMF leak through
Thread-Index: AQHZtKBOR475rAMJIkmtiEvdCiVjQa+4GLKA
Date:   Thu, 13 Jul 2023 19:34:11 +0000
Message-ID: <A9A7E9DA-EA78-44D7-80F9-37C3F869A6A3@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-9-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|SN7PR10MB7032:EE_
x-ms-office365-filtering-correlation-id: d35bcaa4-f6c4-49ee-741d-08db83d822a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MEsGwVwVqbGiIdKNlZC8g4WkB/xxzUH9ZPobqq/zTIsIsWmqsATt6WUWutpCHJiayL/GurKbejJLUOtxRXBkGz2lm2iHyI5fIn09MgUuWKimpjQhoRng9cpFAUnBW/hVM0iZq9UkFq1aHpX2KYVKCAZuPaYHl2IRjNCqz3147uT8iBRZUqCIYs/5yoU5QP1HyAR9AtOeMFRUTg8GLXPqsQth0CKmHryBvxWS/o0qDvsiB3lZxS78p+Z/JS3F/IIOjY0q3Ib5Ih4eVZJoxUgZ+k0vuGzNJ0Xur8dk4ez7hD1kxdKHo2EGNR/S6sdd4lQew+I1L1ABQm0SG1VJS39j8ju9FlVF5cQRNF0ZM9YWsFjrHvC1W1o0lad0W0ZrzaEPe99pq6uAHSi4z39PUhZW8Q6on3Ld1WT+suc9KntAM6cwFRzVJ56EM11SoPrs31ySosfB/eXBCzlq/NaXDqx4fFnoIIxXp3y2Mx36nemvrcXedOFfBvAoOD6xC8RQSgB+RM76NA4MBOXRgKyKBLGA3DF+65gYk3gexR2qYV+9zwRL99kcF2heTq/HRzZqE3/4Kp3/4yny3F4QHufVVK7T+nVf28r45xw5oGgTjdhbfss3dN5hKwFDoBErUEMKHVTW0szn2WAxBKC6zPKubXfvQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199021)(478600001)(71200400001)(6486002)(91956017)(54906003)(6506007)(186003)(26005)(53546011)(33656002)(6512007)(2906002)(76116006)(66476007)(66946007)(41300700001)(6916009)(8936002)(316002)(64756008)(5660300002)(66446008)(44832011)(4326008)(66556008)(38100700002)(8676002)(122000001)(86362001)(36756003)(38070700005)(83380400001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OU9NakxsRVpIZjJjZ1dqUXZnRTU5S0hpNFhLMDlFN3lzOUY3Y2FVai94L0Zw?=
 =?utf-8?B?YmQzZGxxN2pVUm51MUhyLzFDdHdDL3RDRldKQUpZVWZsenpQWXpCMDJLR1dP?=
 =?utf-8?B?eTlUOStLUUVTZklVR3kxNUpYemFBaHpxTE9jMVRtV25FdnR3SVRtNThvTGdS?=
 =?utf-8?B?bXA3MDUwN3BuZzQ0TDgxc0lGSHdXSXRlZkM1bmR3ckUyV1RUVzVEbHFQTzI5?=
 =?utf-8?B?UWlqRUFsVHlUcnVWM3FNNzYrNFVRMnJ4U1VJdk1GMy9oclZsbXVDc0V0ekhu?=
 =?utf-8?B?RE43USs1UkpVenlXc2Q4NVVRS3dUY1RNbE5iRVA4a1RoRWFiQ3VkQml5U1hw?=
 =?utf-8?B?d1ROT0ZNOUhyVUc4YmpJMGZiOTNJOXRicktCZWRmc3JZVkRmYWNTai80dStU?=
 =?utf-8?B?cXZhV0VJVjRob25lNXpRUGt6TE1JaFUzSHlWMWIxMmIrNmQrT0Y0Z1M5YnY0?=
 =?utf-8?B?VlR3T3FwWDRoMmtMQnYrRCs0RFo4MWZnMTZZbm1saktIZkNuc05oeTYydnVs?=
 =?utf-8?B?QWVoVndxeE1wQmZqbFdhNHFpZWxFZXB3VHJnTzMxQTgyRVNydzQvQVk0cklI?=
 =?utf-8?B?RUFvbzdhZlRkakJIS29TNzUxSEgzRmFqdGpyTzhjSTI4LzVlQXVTVENsK1R2?=
 =?utf-8?B?VGVtRnRtMkIvMzZDNUV6OFJ2ZHVzc0luanJyamNjM2FpYU8zQzBqVFlKT0Fv?=
 =?utf-8?B?YXVxMm9QdS9oZGt6Q3NTeitXN1RSdTBaN0NybDVDV1NWZ2NDZ01yY2IwMzVI?=
 =?utf-8?B?VE9iZjVZUFZ6M1dDYmFtaDlIRnk4UXpUZXFvYm9OU3JZcTAzd0UxUWl1VnYw?=
 =?utf-8?B?Smo5Z3YvK1JYZW9pSHE4c1FzTVZUWVlSRkFYbU5memlwRjNOcEpyb1dMbzBB?=
 =?utf-8?B?VG8yRjRhQmUva2s1RmlRbitIVGFYWEdPL2toT0N4UExLL2t4UWNlNkM2c1RN?=
 =?utf-8?B?akprMGtZcjBESUtnc3JBby9DZWMwSVc5RmVCR0dQTHdhQWpBNEgvWWVoWHRw?=
 =?utf-8?B?ZkZxS0ExcmxsR1dITWgzUlcyR3hTT1pOLzhoVWJjNTEvSDJsRi9Fd3Zzb1BU?=
 =?utf-8?B?WlBEb0I5ZVdSb09tZ2Yxa08zS0hHZG13RS8rTU4zdXFRVVUzeXQzTlBOaDhX?=
 =?utf-8?B?SkdJYkpBRkFlZUtwOXB2ZWZTbTcxem53ZmdrRXM4Z0xsS0l3Smd6VThlZjUr?=
 =?utf-8?B?Nkw4YjEwdVN4Z1p5ZzhZa1hNNVNxdFNReXpoS2dQekRtMUFzTnQ2MHM3N1oz?=
 =?utf-8?B?VnhQUnFkWkhHTUVjKzJTR01uZ3FySWd0QkpKd2pXZkhDRXpvajh1dFVCSWJJ?=
 =?utf-8?B?bERMNzVjTjBXL2ZmZEU5dnJFMnZncEVDdUJ4TDY0V1NCSlV3dFdZS01MNk5C?=
 =?utf-8?B?a1RuVStpeGRCUmZFcFhEMTNCTDRiYjc3Ly9Rb2Y3dTBuUG9zZ3M2L2ZyZG9W?=
 =?utf-8?B?SGNodU5BMHltb1VYMXE5dDRlbzVsU3E2VEdSMDFJcW9kSktkK05LeHFOc0sv?=
 =?utf-8?B?SEZob0pza29JMTFac3FHZDlzcEF4REZMVkFHYVJHVllob3JNT0N5Y21udUd6?=
 =?utf-8?B?eURPWXFTUkNsaUltcWNUOHRHMXp4ampuUTFnVzR0Vng3SWhyQlFFN0JZdE1G?=
 =?utf-8?B?V20vWm10ekxqdll2MHVCTExFNnBQMEduU1NNMTIrQ1pEUVZPdHBTUnhIZnht?=
 =?utf-8?B?M2RtSENVOHI0Z0RUWlFRb0EzZ3RSWWI3NWxOczdWd3BMT0xONm9lL3JHU0ZC?=
 =?utf-8?B?R1l2bktWb0x0RXhzLzBQN3Q1WUJDTkc5TlJsQ0FUUVdEUklKTmFXdVEyQmp3?=
 =?utf-8?B?R0NEemY4N1YzQ3FvZ0ZKOWZmbFRvZUFFS20yeTJpbGlzM1U2TXc5bldZSWsz?=
 =?utf-8?B?N3kwVFVzdjlEOXhjc3E3VmliV0Y2NlhrUjl1bFQvMVFBaWtvRTBvTUhpeDhW?=
 =?utf-8?B?MGVxRlR6VVduYXVSVDdKQ3R6Rmx1RmlRY3VkRE5kNkd5cTVBdTV3bWtpWDhZ?=
 =?utf-8?B?eHJlelFOZy9Jc3FLcnBLUTBDYVNwQVRDZFREZStvRjY2REFJdU9UUWY4Rjhs?=
 =?utf-8?B?V1IvV0dycnN6SGVXWGJjMHVxZFdqT05YQlVPK0hqeG1ZRG5OdVZLVW83WGY0?=
 =?utf-8?B?UTQ3UlRISEF5ZkRwYlllR2hZTExGOHc3VDdIVUsyZ3lyYWg1ei9nV2VQSkFs?=
 =?utf-8?Q?7J8HE3qblkd/rQ8w7ITOut4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BA1A16A730B6446BF04BBF4F29B1F86@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D5P6wKadG7/DZ6hoiZUqO+Jc+YotW8LYpAsq+f8NE+/Rw8u4yZQP7p4+5jNFdSZgUhv9XZuktwnne4QAaJK5VM24Ohnkvf4UZTz0NoOr/XrpobzSE2K1lYM8VtHi6nJq9hFIwSPVsEpQ0saXpT7F+yJAKYYEgV/rZOg/4gt1lLsGFiOpRoxeEu5Yo+qzl8eRL0TzOrv2H0nddaK/ls67ZPHxGKMT4+ynCxIwYWKmZSvs7eLu4XJBn1mMU5zBB1tbCYwicaEZDfDSWaX1EDcLGyE3FJ6EgPtbKk2+u+vHu7wDMiZbNI4IXiNldlV9wcdjGrmDScQ6mkVbhnszkRjQmaQWGsqhiUgSnosvZjy742PAcxyfLjVVGtRqadpoXEhdqOZZVbO26EDdTm9OuvZSqZHRgNaFIipeHCCXwJsWKhtvNxPUadjsWl2lxPJStCVTH9YWH8tTJ5ha9AFYqe11rEGCh7Jxb7hokC25BozM8kyQ2jBFrZMzzFL7HlHGQFTRkFtSJMazor6wdo3KQNTEEL3auTuneobHctzzZ6uKYRDqFTsUH3vjFUzeRo7tJRiX5iON0Uuz9V2hhmj0r58lPUhSbxnBicKviBtuYK0ULzq7/T8BS/G9j5PJ6SxgiNLcYv81/q1bqlkKkSPQt5HPUdJCjXg28MfJpj1KYWEcMk9ugTVVrUbCSGUkZ7uMqgupHI/BzZXWRklduAseIVNTX2ar0qW5uQSou0lB0mSSlf1hecwbMWvX4eMY6UIWqdBX7yOE9dBOWLhYL508I5sB03BQ4DGILsyiPomFJranxZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35bcaa4-f6c4-49ee-741d-08db83d822a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 19:34:11.9602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GlMxmHYwjlChsdPLQnQldn0h8G+OJEYJF5jsDSWlkQhbhtsNswTmxR5xm0drssOxNoLd3BFZ5xj59fvsGcqUdnKhsbC+NVAX6GUhW8Gees0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7032
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_08,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307130172
X-Proofpoint-ORIG-GUID: qGsp0nbiFCKdEonm31-wDs-Cmsc2s1Xh
X-Proofpoint-GUID: qGsp0nbiFCKdEonm31-wDs-Cmsc2s1Xh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gSnVsIDEyLCAyMDIzLCBhdCAyOjA1IEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IFRhc2sgbWFuYWdlbWVudCBjYW4gcmV0cnkgdXAgdG8gNSB0aW1lcyB3
aGVuIEZXIHJlc291cmNlDQo+IGJlY29tZXMgYm90dGxlIG5lY2suIEJldHdlZW4gdGhlIHJldHJ5
LCB0aGVyZSBpcyBhIHNob3J0IHNsZWVwLg0KPiBDdXJyZW50IGNvZGUgYXNzdW1lcyB0aGUgY2hp
cCBoYXMgbm90IHJlc2V0IG9yIHNlc3Npb24gaGFzDQo+IG5vdCBjaGFuZ2UuDQo+IA0KPiBDaGVj
ayBmb3IgY2hpcCByZXNldCBvciBzZXNzaW9uIGNoYW5nZSBiZWZvcmUgc2VuZGluZyBUYXNrIG1h
bmFnZW1lbnQuDQo+IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBGaXhlczogOTgw
M2ZiNWQyNzU5ICjigJxzY3NpOiBxbGEyeHh4OiBGaXggdGFzayBtYW5hZ2VtZW50IGNtZCBmYWls
dXJl4oCdKQ0KPiBTaWduZWQtb2ZmLWJ5OiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+
IC0tLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIHwgMjAgKysrKysrKysrKysr
KystLS0tLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYyBi
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCj4gaW5kZXggMDZjNGU1MjE1Nzg5Li40
MDg5N2QwOTU4YzQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0
LmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiBAQCAtMjAzOCwx
MCArMjAzOCwxNCBAQCBzdGF0aWMgdm9pZCBxbGFfbWFya2VyX3NwX2RvbmUoc3JiX3QgKnNwLCBp
bnQgcmVzKQ0KPiBjb21wbGV0ZSgmdG1mLT51LnRtZi5jb21wKTsNCj4gfQ0KPiANCj4gLSNkZWZp
bmUgIFNUQVJUX1NQX1dfUkVUUklFUyhfc3AsIF9ydmFsKSBcDQo+ICsjZGVmaW5lICBTVEFSVF9T
UF9XX1JFVFJJRVMoX3NwLCBfcnZhbCwgX2NoaXBfZ2VuLCBfbG9naW5fZ2VuKSBcDQo+IHtcDQo+
IGludCBjbnQgPSA1OyBcDQo+IGRvIHsgXA0KPiArIGlmIChfY2hpcF9nZW4gIT0gc3AtPnZoYS0+
aHctPmNoaXBfcmVzZXQgfHwgX2xvZ2luX2dlbiAhPSBzcC0+ZmNwb3J0LT5sb2dpbl9nZW4pIHtc
DQo+ICsgX3J2YWwgPSBFSU5WQUw7IFwNCj4gKyBicmVhazsgXA0KPiArIH0gXA0KPiBfcnZhbCA9
IHFsYTJ4MDBfc3RhcnRfc3AoX3NwKTsgXA0KPiBpZiAoX3J2YWwgPT0gRUFHQUlOKSBcDQo+IG1z
bGVlcCgxKTsgXA0KPiBAQCAtMjA2NCw2ICsyMDY4LDcgQEAgcWxhMjZ4eF9tYXJrZXIoc3RydWN0
IHRtZl9hcmcgKmFyZykNCj4gc3JiX3QgKnNwOw0KPiBpbnQgcnZhbCA9IFFMQV9GVU5DVElPTl9G
QUlMRUQ7DQo+IGZjX3BvcnRfdCAqZmNwb3J0ID0gYXJnLT5mY3BvcnQ7DQo+ICsgdTMyIGNoaXBf
Z2VuLCBsb2dpbl9nZW47DQo+IA0KPiBpZiAoVE1GX05PVF9SRUFEWShhcmctPmZjcG9ydCkpIHsN
Cj4gcWxfZGJnKHFsX2RiZ190YXNrbSwgdmhhLCAweDgwMzksDQo+IEBAIC0yMDczLDYgKzIwNzgs
OSBAQCBxbGEyNnh4X21hcmtlcihzdHJ1Y3QgdG1mX2FyZyAqYXJnKQ0KPiByZXR1cm4gUUxBX1NV
U1BFTkRFRDsNCj4gfQ0KPiANCj4gKyBjaGlwX2dlbiA9IHZoYS0+aHctPmNoaXBfcmVzZXQ7DQo+
ICsgbG9naW5fZ2VuID0gZmNwb3J0LT5sb2dpbl9nZW47DQo+ICsNCj4gLyogcmVmOiBJTklUICov
DQo+IHNwID0gcWxhMnh4eF9nZXRfcXBhaXJfc3AodmhhLCBhcmctPnFwYWlyLCBmY3BvcnQsIEdG
UF9LRVJORUwpOw0KPiBpZiAoIXNwKQ0KPiBAQCAtMjA5MCw3ICsyMDk4LDcgQEAgcWxhMjZ4eF9t
YXJrZXIoc3RydWN0IHRtZl9hcmcgKmFyZykNCj4gdG1faW9jYi0+dS50bWYubG9vcF9pZCA9IGZj
cG9ydC0+bG9vcF9pZDsNCj4gdG1faW9jYi0+dS50bWYudnBfaW5kZXggPSB2aGEtPnZwX2lkeDsN
Cj4gDQo+IC0gU1RBUlRfU1BfV19SRVRSSUVTKHNwLCBydmFsKTsNCj4gKyBTVEFSVF9TUF9XX1JF
VFJJRVMoc3AsIHJ2YWwsIGNoaXBfZ2VuLCBsb2dpbl9nZW4pOw0KPiANCj4gcWxfZGJnKHFsX2Ri
Z190YXNrbSwgdmhhLCAweDgwMDYsDQo+ICAgICJBc3luYy1tYXJrZXIgaGRsPSV4IGxvb3AtaWQ9
JXggcG9ydGlkPSUwNnggbW9kaWZpZXI9JXggbHVuPSVsbGQgcXA9JWQgcnZhbCAlZC5cbiIsDQo+
IEBAIC0yMTU5LDYgKzIxNjcsOSBAQCBfX3FsYTJ4MDBfYXN5bmNfdG1fY21kKHN0cnVjdCB0bWZf
YXJnICphcmcpDQo+IHJldHVybiBRTEFfU1VTUEVOREVEOw0KPiB9DQo+IA0KPiArIGNoaXBfZ2Vu
ID0gdmhhLT5ody0+Y2hpcF9yZXNldDsNCj4gKyBsb2dpbl9nZW4gPSBmY3BvcnQtPmxvZ2luX2dl
bjsNCj4gKw0KPiAvKiByZWY6IElOSVQgKi8NCj4gc3AgPSBxbGEyeHh4X2dldF9xcGFpcl9zcCh2
aGEsIGFyZy0+cXBhaXIsIGZjcG9ydCwgR0ZQX0tFUk5FTCk7DQo+IGlmICghc3ApDQo+IEBAIC0y
MTc2LDcgKzIxODcsNyBAQCBfX3FsYTJ4MDBfYXN5bmNfdG1fY21kKHN0cnVjdCB0bWZfYXJnICph
cmcpDQo+IHRtX2lvY2ItPnUudG1mLmZsYWdzID0gYXJnLT5mbGFnczsNCj4gdG1faW9jYi0+dS50
bWYubHVuID0gYXJnLT5sdW47DQo+IA0KPiAtIFNUQVJUX1NQX1dfUkVUUklFUyhzcCwgcnZhbCk7
DQo+ICsgU1RBUlRfU1BfV19SRVRSSUVTKHNwLCBydmFsLCBjaGlwX2dlbiwgbG9naW5fZ2VuKTsN
Cj4gDQo+IHFsX2RiZyhxbF9kYmdfdGFza20sIHZoYSwgMHg4MDJmLA0KPiAgICAiQXN5bmMtdG1m
IGhkbD0leCBsb29wLWlkPSV4IHBvcnRpZD0lMDZ4IGN0cmw9JXggbHVuPSVsbGQgcXA9JWQgcnZh
bD0leC5cbiIsDQo+IEBAIC0yMTk1LDkgKzIyMDYsNiBAQCBfX3FsYTJ4MDBfYXN5bmNfdG1fY21k
KHN0cnVjdCB0bWZfYXJnICphcmcpDQo+IH0NCj4gDQo+IGlmICghdGVzdF9iaXQoVU5MT0FESU5H
LCAmdmhhLT5kcGNfZmxhZ3MpICYmICFJU19RTEFGWDAwKHZoYS0+aHcpKSB7DQo+IC0gY2hpcF9n
ZW4gPSB2aGEtPmh3LT5jaGlwX3Jlc2V0Ow0KPiAtIGxvZ2luX2dlbiA9IGZjcG9ydC0+bG9naW5f
Z2VuOw0KPiAtDQo+IGppZiA9IGppZmZpZXM7DQo+IGlmIChxbGFfdG1mX3dhaXQoYXJnKSkgew0K
PiBxbF9sb2cocWxfbG9nX2luZm8sIHZoYSwgMHg4MDNlLA0KPiAtLSANCj4gMi4yMy4xDQo+IA0K
DQpSZXZpZXdlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUu
Y29tPg0KDQotLSANCkhpbWFuc2h1IE1hZGhhbmkgT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQoN
Cg==
