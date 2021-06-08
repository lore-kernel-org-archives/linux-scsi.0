Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FDAC47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FF86127A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhFHDHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40052 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhFHDHj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15835dkx001918;
        Tue, 8 Jun 2021 03:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Tv80NzSmmv6WsqGanEFoOA2T5jfrNnRbfriyiyfAnX4=;
 b=zqB7c3bY3yp57nNXkmfvLBGCEvnpsH07/s0Mz7bkQ7gb5j+nJM4rQbJnkn9IL9er0uby
 XLDY7+DZA+PTzViFa2q452OFkgUuSh9oHafV+jqC1UcuLRHSvXxsDLgeXb857S+OCK11
 P2iD7Moz2h+h9enENehiuMxXlpOSGhoy1efMXbcGYhdYUTtSHQphml0OL5Gluc+YO5dA
 vL+15rqk/7PwAqxJPaAjqzyKxA4hVJM997lKTPnDN/O56OXzYQrdrp6uXjJz0jq/amX5
 DbkowLHmh9crp2OQh0nNN5OBOVHD+Md3xzSb5IzaOss2W/EBmtEircHEG0xuPtQ9VWBt ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 39017ncjmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834pBm084955;
        Tue, 8 Jun 2021 03:05:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 38yyaahxx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggcl4zeTf8Rk3jlK0APLg/OIwRUYf+/f/B/OtlHAw/J4gMb41JBxM6Ago7FMqdfM1pC2I47dLGOSYF+pB3CF3+cpzyEicRGmCUlC7Y5DCOIyNCvurHRn1ajjVebmHEDf3fwVmRB+qm9gW5Fz1iajunucWWJ2k2cnL6ZBpgSfs4bjPXd/qEiorsAsCP0rfHKrcv0zd96hCvoRIPRRw0f6w65Rz0BMUAscZOKyw3P5QYTY386Y10/AcC2GrVMTRJS0g82FDD0KfQI1yGlUhZY+cyrmowMD0LkXA5OS06BEzCCIRX6BKCT8uChIWXJm5az3crK9x165eyk3nkOxKgdRfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tv80NzSmmv6WsqGanEFoOA2T5jfrNnRbfriyiyfAnX4=;
 b=nOrI5BWV7TEps3vIaO2NI0cmnt39OEnGEp8+lW4A+tBTJIrzcOLaev/9PRXQoweb49jY45n/LkjjmQAi6uWgUozXT92hC1MrWAfZY10GirAjyKD21YfFjSkf/dZGE+r+5ybJwMC4I74LIyEHMmQeY0bnhvKixHgUFNMp/McMzvz4p4gdyIOks8T9XkflqYQNg+OZJDwR95+puBCnnJC2lb1QWF9q0MYlQXjXehRazFABA27DukKzXgEorrwOY8/bX2UgqZ/faQFZUzBZak4qUlLPei0rYNbOgjSCwSvNm4DHUTp44f5kzqzpZPXPMqHQlQ/mKfXO0aHI308Fs8IJSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tv80NzSmmv6WsqGanEFoOA2T5jfrNnRbfriyiyfAnX4=;
 b=kGJpURYxIERwj2chFrAPR6YDtyZ0nw+O/a2KquxUtiWsoqmwzUpdOV9PfqJTbTMHyawA4hmT8zOC+Cu1yJ0MFmxUHZQxX0TtL0djkIs1TEvBYNOrDVju7SqEV/QzFYaPJs0CMgsKD92H5JSn0OeFLDZjxRVLFg+HnKNMY19RnOc=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     GR-QLogic-Storage-Upstream@marvell.com,
        Mike Christie <michael.christie@oracle.com>,
        mrangankar@marvell.com, cleech@redhat.com,
        linux-scsi@vger.kernel.org, lduncan@suse.com, jejb@linux.ibm.com,
        njavali@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 01/28] scsi: iscsi: Add task completion helper
Date:   Mon,  7 Jun 2021 23:05:25 -0400
Message-Id: <162312149258.23851.812006069436135547.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210525181821.7617-2-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com> <20210525181821.7617-2-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 454eb282-b096-4072-23e8-08d92a2a4a11
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44701E036419A7B7679996268E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLIeY1ahMvoXzCeS7b+HvYgBDbh2u9ykLr6IJFIOP5bR4/1ugphU2mQQk09YKlCmOT4MxFZ/IHctIEo6PP/3EMhTgw+qHU6yo5OGHc6tdd7hrYD/59r5CTuq7iQEL+Ly9q4w6qyoKAN50giDAZt7VSbQPW//nw4aPeKLen0E0Du9VF/51s4wg13OcIjKZOQIncjB8nwiRHAL7ATGcMUKgzshJhbkuFNL/LnYOS3tLL7xyZCwqbjBLZebDDz4/vE8DGwjR8IuLukArqRa3RYkrSXsACw9o95moyY+9IPlvvAk+9OCQnp+Q6WkSxRMpHvsNUDuDdh3Tz/0EiclF0F+ioyKKaEfTSxgMDxHvAjMsGiKa0L9dvPaOGRYc71sOC4lFrMqWm5x+jWMDFqhDY6mRWotPH/N6hh5qcATq06PcDI1G22yiXWysjSyUYCkJXtNGRyWfkxqpIMrSAabB1IZZrYtc+VXRBM721iqC21rmEEsLBXlyeRKT5oQlBUcwvDRuZsTptozOT4BHNjE+h91ExOqwadLvLTDcpZkotDp4FrZAayuqOdf/MbMWb+cRMU9CWXbrWXu+wIkhU/6Gh/tnz1zKq2PM1RLoWyCAhBVs8nu1VsD8WsqpSJgKx5lwTXWXuGY2j7h+sCPtfHUbwf3brILW1kX/pYXm5eeqxrm/zOFSkuF7OaB0A6t7pr5K2xNWRRj7jXotexqQXGw7pcws5pjY1pIp3Yhipsc/Q4rs4ovlt58GNJR8F4b2bHP9aqy8SZntYjrvmYHoq41q3Aa445kkScR6yNvUeXr7arXoGFTMy0ArYa8Z6aqmkDZOEPH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(83380400001)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(8676002)(316002)(107886003)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(66556008)(66476007)(6666004)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkxCU2ZLZlJOUXNONFFBSWEwcy9YY3NKemEzOGI1ODVXZ21NNW84OVNmQ2NY?=
 =?utf-8?B?L2tTMnZyNEFkZkdiTGoxRlpYSWd2dXZpai9WWVJVSTc5TjY2TWo1cm9UMm5u?=
 =?utf-8?B?WCtsR0pENk1OSCtqbWZrN2RGVStxWmdmalhaS2NqeDZKNXc1bUdtV1N5Q1BB?=
 =?utf-8?B?Y2hBYzhXS2NnMjl4NHAzeWptMGdYckphdEltYjZYTTZ3ZEZPMnArRmVpbjBT?=
 =?utf-8?B?RVFDNmRCdzh3eTJRSlJLWjMvQ2RFTHFPZGs3V3JPS0szc09wWEZKZDdGSHAx?=
 =?utf-8?B?TVRPZ3FPSDBYQmpEcFl3WWU0bU9xWkdnWUtPUHIrTlRwM2ZnSHZuekxNNng0?=
 =?utf-8?B?b3Q5ZlZnUXlsRDhiSWQycncrWTcvbkJzWVc3Q25IeDNST2Mrb0g5cXM2dHYw?=
 =?utf-8?B?L040bUVyZlZzaXZENi9oVHB1VUU2UCtkcUlBRUE5cEp0WTNHODhRVjdYV1lp?=
 =?utf-8?B?VlJNZFd1VDNUcmE5elFXa2ZuOWN5cTYxTW5xMlVDQjQ1RDNJYTV0U2V1WHh2?=
 =?utf-8?B?dFhwUTRsMUhXQXpIT3FqVDlieVVURmlGcDVtMjA1RStwanlmZGRJeVY2R0pp?=
 =?utf-8?B?bTBhcm5DZDFNZms3K0ZKSzVZRnFBRVRMTDRkNWlqd0dRK0lObDVHSUh2VUVF?=
 =?utf-8?B?S1JoMmZwbnM3OEdFUXhjK3VEdnB4RWJKYmh4ZGRHM3lCaTV3ME5UR1pUTW1L?=
 =?utf-8?B?U0lMWE0rTnFNcEJMbWI3djNJTVBIR0RLNnNaMVdUZGZibmlSNi9zVEd5Ynhw?=
 =?utf-8?B?N25VWnpTUXJYL1grcHVLUWNrTEJWYXAvNEhVaVFoOWJOQUgvcUltRUxHNHhG?=
 =?utf-8?B?SC8wRUtaS2xieU1rNGMzaElmd1NJdFNiN3NIZWdEdmthMWhoSEF4TkQ1aFdD?=
 =?utf-8?B?cXQ4VGxqLzVkK3IrMi9BRXpGbndVL3JMVm5VZGdHWVZ6VzFVUG13MGxORklF?=
 =?utf-8?B?Y1h5YnJ2VE1PK20zQ3E1ZFk1dmM2Y1MzQWFQWDhadHhuNXF2MEwyVEh0dTlP?=
 =?utf-8?B?Y3Y0ZTBZYmM5dW9ZNllqMEdFUVptYXJKYy9CNGNsQ2s5RHYySmtrTi92d2lx?=
 =?utf-8?B?ZkMvSW1jTmgra3JaYlhlbEZTYm5ZT2RZcjgwdEo5VWRxMDRNQUlEWlZBTEdh?=
 =?utf-8?B?TWI2TzBlOGgzeDZVbGVCMFQrRnJLQmp0bUlyWEZUeUFwbHlPb1laSlE5NnN1?=
 =?utf-8?B?SmswT1NVWlAvTnhsbWNMVTNiNkcwblFSVTFwek1WM2ErU2xXWVQvNXJPWGZG?=
 =?utf-8?B?dFoxVGt5SnZQK0F5RVZHYlpXMmVJMUxPalRmd1VUa1hOdWJ2T051bFVFV3h3?=
 =?utf-8?B?eVJEeERWR0N5RjFzNGdFc2tJZ2kvWGJRZlFIK3Z3WFhSZU5pQWdnTmMwc0xn?=
 =?utf-8?B?aCsyRFNkcEZsWlpLd01iWTJjbjBndDQ0ckNMZXpickFHQWVlZVRQVDk5QlRS?=
 =?utf-8?B?Z0M1aVRZUEtIYmZkeWttZ0NVMVpvYnFOSXFaS3B2dHJUQ0pqaDdUMHRxWmNi?=
 =?utf-8?B?a2Q4QTdWeWx3VzJPTjRwQTVoQm9TeVRlb0V1V3FsRGdIcDB3SlB0QUxDTHhs?=
 =?utf-8?B?bFkyTldJNXM0ZCt4eTEwbHY5UzJ5ZG5mRFVPbWJnY0l1TGtsN05iMDd6Uncr?=
 =?utf-8?B?cUo1bzZPZjdUaCtoMkpVWld1ZkthblI5eit2M0NVNXNTcHhUUFJXdys5SjFi?=
 =?utf-8?B?Q284UTNIMGlxbW44b2IyYzRHSVJjdGFKKzNCZWNkL2lrTEVyNE1ncDZQUWpV?=
 =?utf-8?Q?xdb4Df9QeYQQQdzC1QzP4VIggacLzLrjPxYyhZw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 454eb282-b096-4072-23e8-08d92a2a4a11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:37.0709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJGICDUYDVs6qKIwh5ZCPl4SNES1EhLEEO/3YMX+Vt9Ov+PV51DAeAVJxtn4deKfghXlHLaJy9immLdm3cnHDM/rzt2qR2gLM9U0ezDUTgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
X-Proofpoint-GUID: a167MdimRqQAg5afbHVRDvQud71lEJKk
X-Proofpoint-ORIG-GUID: a167MdimRqQAg5afbHVRDvQud71lEJKk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 25 May 2021 13:17:54 -0500, Mike Christie wrote:

> This adds a helper to detect if a cmd has completed but not yet freed.

Applied to 5.14/scsi-queue, thanks!

[01/28] scsi: iscsi: Add task completion helper
        https://git.kernel.org/mkp/scsi/c/1486a4f5c2f3
[02/28] scsi: iscsi: Stop queueing during ep_disconnect
        https://git.kernel.org/mkp/scsi/c/891e2639deae
[03/28] scsi: iscsi: Drop suspend calls from ep_disconnect
        https://git.kernel.org/mkp/scsi/c/27e986289e73
[04/28] scsi: iscsi: Force immediate failure during shutdown
        https://git.kernel.org/mkp/scsi/c/06c203a5566b
[05/28] scsi: iscsi: Use system_unbound_wq for destroy_work
        https://git.kernel.org/mkp/scsi/c/b25b957d2db1
[06/28] scsi: iscsi: Rel ref after iscsi_lookup_endpoint
        https://git.kernel.org/mkp/scsi/c/9e5fe1700896
[07/28] scsi: iscsi: Fix in-kernel conn failure handling
        https://git.kernel.org/mkp/scsi/c/23d6fefbb3f6
[08/28] scsi: iscsi_tcp: Set no linger
        https://git.kernel.org/mkp/scsi/c/c0920cd36f17
[09/28] scsi: iscsi_tcp: Start socket shutdown during conn stop
        https://git.kernel.org/mkp/scsi/c/788b71c54f21
[10/28] scsi: iscsi: Add iscsi_cls_conn refcount helpers
        https://git.kernel.org/mkp/scsi/c/b1d19e8c92cf
[11/28] scsi: iscsi: Have abort handler get ref to conn
        https://git.kernel.org/mkp/scsi/c/d39df158518c
[12/28] scsi: iscsi: Get ref to conn during reset handling
        https://git.kernel.org/mkp/scsi/c/fda290c5ae98
[13/28] scsi: iscsi: Fix conn use after free during resets
        https://git.kernel.org/mkp/scsi/c/ec29d0ac29be
[14/28] scsi: iscsi: Fix shost->max_id use
        https://git.kernel.org/mkp/scsi/c/bdd4aad7ff92
[15/28] scsi: iscsi: Fix completion check during abort races
        https://git.kernel.org/mkp/scsi/c/f6f964574470
[16/28] scsi: iscsi: Flush block work before unblock
        https://git.kernel.org/mkp/scsi/c/7ce9fc5ecde0
[17/28] scsi: iscsi: Hold task ref during TMF timeout handling
        https://git.kernel.org/mkp/scsi/c/99b0603313ee
[18/28] scsi: iscsi: Move pool freeing
        https://git.kernel.org/mkp/scsi/c/a1f3486b3b09
[19/28] scsi: qedi: Fix null ref during abort handling
        https://git.kernel.org/mkp/scsi/c/5777b7f0f03c
[20/28] scsi: qedi: Fix race during abort timeouts
        https://git.kernel.org/mkp/scsi/c/2ce002366a3f
[21/28] scsi: qedi: Fix use after free during abort cleanup
        https://git.kernel.org/mkp/scsi/c/5b04d050cde4
[22/28] scsi: qedi: Fix TMF tid allocation
        https://git.kernel.org/mkp/scsi/c/f7eea75262fc
[23/28] scsi: qedi: Use GFP_NOIO for TMF allocation
        https://git.kernel.org/mkp/scsi/c/140d63b73f42
[24/28] scsi: qedi: Fix TMF session block/unblock use
        https://git.kernel.org/mkp/scsi/c/2819b4ae2873
[25/28] scsi: qedi: Fix cleanup session block/unblock use
        https://git.kernel.org/mkp/scsi/c/0c72191da686
[26/28] scsi: qedi: Pass send_iscsi_tmf task to abort
        https://git.kernel.org/mkp/scsi/c/60a0d379f11b
[27/28] scsi: qedi: Complete TMF works before disconnect
        https://git.kernel.org/mkp/scsi/c/b40f3894e39e
[28/28] scsi: qedi: Wake up if cmd_cleanup_req is set
        https://git.kernel.org/mkp/scsi/c/ed1b86ba0fba

-- 
Martin K. Petersen	Oracle Linux Engineering
