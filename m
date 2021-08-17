Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DB8C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A813C60F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 02:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhHQCvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 22:51:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1214 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233438AbhHQCvA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 22:51:00 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H2eQOe000965
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 02:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ck/1bV7ToncaVD0TmTDEQ3wmHDn07C70SgK9pI2/uKs=;
 b=hR4Oj/DPoq9pnf9NRx/sXTGcnEZqKAi/bu+PvnipFwhItjuhZn9PsGeEKW+DlY3BcLK2
 fsV1e9i32dmqVznS+NtDJMLCB5H+3ySQujhIqH/BMIBl4JC6f6/YmPXFBMhbL4QB0axB
 7UujJ2f5YxTZhpyQip1JwmV9lDRz2iBqcZTgIK2uXbTcAt6T/SQEEjmSBakItiuSB9Z0
 IwdisDfzni2witB7MGy1S3/Ze5ZFrLBwWsbPf8KftknGi960togcJFRglb5Gog2OyZ0y
 hLsMIvMSix7RyzxjwXgk8151mkBDpD2/TzIy+hq1IrvMFZj/I+oPNE7994jtM5DxbufN Uw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ck/1bV7ToncaVD0TmTDEQ3wmHDn07C70SgK9pI2/uKs=;
 b=d+2KTEih7c9w+DrdKfHH7Ou4MhSQYu7PNiG8yODfVTYu991OGSPysaipPT5wXYADndBw
 NB+1TluEvSQDV+3WjPkrp8GfQ5yyfH0jcZVV+CwCbcSR0LmXJWuHCEzEirxw0CF8OkgB
 hBIttYRIUxrh/xrrYnkaqKJtt7RPnLrkyMU/i3sI0uECXi6HQQlHO5nePGuo8FtgQzaR
 Amk22qxb/9N6MS0Dvq5rYKifiHDfKJda+GiLiGMxEFFoRBPtYpxdbfGO5DaH9cyhBTmy
 j8ZG8Xpk+pG3yN+MLWLjG9l6fPWUzQuYxJDWzofv8wBDRlX8wL5I8dFZ4ZY1fGfrp6CV Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgmbam5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 02:50:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H2ijYp132105
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 02:50:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3ae5n6qpax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2021 02:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5D1Z0oP9hLx72g/tHZ1UbjqaH0meVxj73audIUVyRVy0PQWJj3TFiXL9axL3vI8J9+I9vD8Lfy8efEMRY/e6aNTnGOWVwYKXKBQ2FTxJAgg40zs60ZYLzlZDzi7nIaUHyNgCa2VyAi0bhBMEfRkgnZT+x9I1FjagXsQRzM52eQLRQA9WsmjKvABr1eBJcxZjsHbAuRa8eYtx2FWPkJB9ppnlEbYSYTIGX52I/QmAh2jAWD9eybTnj44MO0MX7KONEYLHpOSUnta8PDEWSy+7A4L4YtUT7usttzRVK1yN6W0C3snnsQsvEJ385EdFeAWtI4ko9shY3EwtVaEfcWHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck/1bV7ToncaVD0TmTDEQ3wmHDn07C70SgK9pI2/uKs=;
 b=c2usYSUamOmMv5GE+6dqOJ1SoD8j2y9wc+wab0Xd6+Er3sRyLayv3ov7UlDrd4zu4MdtCFC3xp87WnzoK7IJLH0atjiydMF4V6IKD00Swkpzs29hHoEkYrvB5iOXCS3TFAHqBgzj/1apjbeibUUa1Tn5gxyxW+aH/yawpt7kLdsmaKWqcEubwX+/QqribUXW3rMJ9127bS8pV8P33UDJ+ggwSvWHd8l+9L9je3lgHirSxKegtesxIzUvkfCpzC9GhmShrRWLD+CTP5ylSVDX0B0X4rZXoA3twaH0uBsB7w679UjFZgn7zLlaiPjqQ7pVJUyJdRp5/GNqxMG3Ykps0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck/1bV7ToncaVD0TmTDEQ3wmHDn07C70SgK9pI2/uKs=;
 b=Wv7IYG4j78KZzWtlXBzdm09YmqyaLAfbccihlv3IQFrVS4+FLbRdXYOMvWWFcMZdv/4OWteelPZh1QChtzn3IZkOyKAkvglQQ2dw0Oo/eZWz6Ihp7q1UwRHmBqEVzLpFywtZkrJornHvycNK/KJU1JrWLxrvvuzsYvTNrPU3xeg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 02:50:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 02:50:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Subject: Use the proper SCSI midlayer interfaces for PI
Date:   Mon, 16 Aug 2021 22:50:12 -0400
Message-Id: <20210817025014.12085-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0175.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0175.namprd11.prod.outlook.com (2603:10b6:806:1bb::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 17 Aug 2021 02:50:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee46e5e2-425a-410b-5f47-08d96129c39c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-Microsoft-Antispam-PRVS: <PH0PR10MB546689C18BDA659A96CBE28D8EFE9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hM8deX8NrvuG42jNaU5ovf/07AnM3smr2SxqYuRLpFtbtgl337zPLmzwDRi704pwEGE3dh9p+IeZKlnEy7z05pG8O3aOrKS4BBTHWpHTol/EfNOF0iD7mhdv+4ekBYzfCddzszKnsj3VzYFYZlrLp83OP3gKZMVE7bjdqwxFjK7tTYUVAfyWKP2XhsDCxXK3wRPoYjiMCvl+IOFzINC5txo/x+BJFO67actPTzdgXtcfPH+NVGUO6/A8OzfP5VosqLpojt6XrwfqI8FoZMXZ01sQoaGtqcP+WsffcT6r8bzR1wF2zLnplJuTcImTwrgZyNZNa0A8fEEyyRyCdlajzTBe5l9PUhouWJ0E4+2oYgbAAQuAsrevBHb0roCGs8mm5tv6XvScncoJn/aQmIbKdUPDGkaFmzHAThuNDJRBCsjEJDHEDkwr6IRTrGF7HXhho2CbSqEy2hNPXGE59uwVtzH1wYbGYktc6Pfswe9+210dT/VFwEVFR943Tn87uwLjb9nbSFF9eQj3m3w/paMLx63c2hpVflDlxJUEB3hthbbJnBPLzhiyIb3G5CfdYsTgkdfgqOr6yBKYi/OR593Z3WZ6gyM1bx1zwlBtaU4A+YW1gNlNwK8cJeRSJI1JTib7/61w/DHXnDE0f+LSJpoKSLcWY+UvsW3nnITTNOA1mIwBpR6YQFyvBxM7ZR8rCETEmjjA7xlG71eFuWuhq/LHwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(396003)(346002)(366004)(6916009)(316002)(956004)(2616005)(186003)(26005)(83380400001)(6666004)(6486002)(52116002)(7696005)(86362001)(5660300002)(8676002)(36756003)(38100700002)(2906002)(38350700002)(66476007)(558084003)(66946007)(8936002)(66556008)(478600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BtV5GrGnRp8+RqH/AdPd8AoD4ECFlGqAmOnpKbpVxZF9rum0qXCY2jBZxL9Y?=
 =?us-ascii?Q?k1L3gaNuamdm9ebNxqEIXHawe7qvPHEXmSMrlpXRyPU3tBadEPrQsD0P49p0?=
 =?us-ascii?Q?O0DD5BzAXikSTEn/FETkDUIDSf+o10unPKjpDFUmvikZkMQk8GR58HQd8urg?=
 =?us-ascii?Q?2YBS/KDmffGcEA5R7nfBHQ8THtrdEpvdBOlhX9xiYCDoXqvd69ULoSbSp6k7?=
 =?us-ascii?Q?BszzCKLwwO8VeVYpOq3tQC8oXpMaDl+st6Xm8/l151f9qV17I/oPMnGL7D46?=
 =?us-ascii?Q?hcTZLX0IDsBrdSRjE064FzRPd/STuJG/k3HDQBAFKp+Xvoc+m8cwbrQtQPtr?=
 =?us-ascii?Q?BuRVoLS8mltKFj5yvKVvrrPxAnQTGSMFBEc1/gn/jcmCH6Pc/Gko9HAhi52U?=
 =?us-ascii?Q?kDsYkUxvMGD5m6fvqwSYBac+N1/tkxmo5cpqQ2vSWdxANpAOhcwdE6ZHlJQf?=
 =?us-ascii?Q?JHS6qMMxrXjt1N+XOehLU5+DfZvhmJjI2igCF3pnQl897P/RDUpW+6luJXGu?=
 =?us-ascii?Q?YohaLAbsyPbv3gWx3sigAEaaGwj9rBjFLo9lSdMhKd28lfIpK9ho698goxf+?=
 =?us-ascii?Q?+XONnMqLdsgZ5LtpRatbQkccXFbQmMPROIw76dHFWNYULlh8drTQJ7rUmH6u?=
 =?us-ascii?Q?Jj0TZ8oyyjFFITD2LpyVz+muo50Nmlv95azDJemY6Siu2sQMxxvcO7iDSSOU?=
 =?us-ascii?Q?VFrmzGurO6D6fuoo4ASvHp2Edx/eoC1QQpL6R3xpAP5BTf22DYmZp0NEch4n?=
 =?us-ascii?Q?AK6lGnLyDmuzIjPoy4Oc+sO/ZCf+cWnjaviIydfl/iMFlZXpqboqkpY085TX?=
 =?us-ascii?Q?LQ1YNxw1XelEBptF5mjgF8HKU23xkB0DB7sqVIqdZi95BbFyun9L9RCVLPZB?=
 =?us-ascii?Q?k6U+BfSxXdqcBJ51kxLXdhSzTsNfZBbqL6j5YFBl5r24avXAoiKhk+Xx6PKL?=
 =?us-ascii?Q?T0ylnNUUKSC6GfGlRFeT+2a9YmVPUlb15YKG8F/+GlrA/b0cZ1hvgpuUl42D?=
 =?us-ascii?Q?dENMPypdOriE8OE0HyEelv875qWz/0rABUWTZCMV2sWm2qgkJgl72ScptJHB?=
 =?us-ascii?Q?RhPYnQkeIDeHP09sF+cZaQdkdfJhKPdlLNMQSx5aguLBn2HIgq3hC+13281K?=
 =?us-ascii?Q?VaRMzCgIViIx9Jc7boGvp+ZlQpbnimTw936QuoNbmP4tr4YBDg79ZnaxC/uM?=
 =?us-ascii?Q?+6hK7KxiqK0pKP9ruXy3ARdIO9PRkGK+CnqZiuWeLy1J0pIuqi0NYgPYcX8G?=
 =?us-ascii?Q?KlFYNAs3FnXkvwoUlrL3PAIHnd5pkZUqkYgfzYBoVNJS37yvjTklrd2qsHwz?=
 =?us-ascii?Q?COMocalapQbKeT/z9MK4iB//?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee46e5e2-425a-410b-5f47-08d96129c39c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 02:50:25.4786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27DEeIlVtCE6dt8J3YTxc/3qBDqP0e5a9LlPPbQ2pDPuAMlIy9gZ6pu5R6N+nWPBaHdLDsvGGewWT5XZet2/SqWJ5KEPQY23+JNResB/hds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=415 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170015
X-Proofpoint-ORIG-GUID: -V20dXd9Zq4Wla3v-39LNL4Nw8zOHkAP
X-Proofpoint-GUID: -V20dXd9Zq4Wla3v-39LNL4Nw8zOHkAP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the remainder of the PI interface cleanup patches.

Changes since v2:

 - lpfc patch remains unchanged.

 - For mpt3sas I addressed the zeroday endianness warning and fixed a
   copy and paste error for the check flags.

Please review, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering



