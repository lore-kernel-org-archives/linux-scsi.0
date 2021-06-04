Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC8AC4743D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 21:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3EDA61402
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 21:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFDVuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 17:50:06 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34050 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFDVuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 17:50:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154LjxqA104685;
        Fri, 4 Jun 2021 21:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/aYe3PclXF18J3MGw7f9wTSuPk4sXyzwMSEQ1Dtqlls=;
 b=km4GLtiOIZpHNK9CuJdokELi42qex6N4CSIOdrFqcRwFCWibvqGZfii4A9wfPPZyClnG
 cwHYw7D9RUtRtl/ru9undQOTVQN9KD6jZXGMg5VqpUV59xVn5C6o7baBnuHumiW+sauG
 vhReCOihh5AoSBUBwcAyYbpxNv0tAyt9rn688EtGLh/NCU4Yn2IHYEck+AcOWPGlBPMO
 Cf9RFMaPCuekX6V0dcP0FRF2HX5Dtw1oANU3ZzyRdkfw1xQiD6ZfzRtMa+bPJFKEoxBY
 kZzEOqMBf4xNAZ9YztfN3DnkSDSWs3V6yG0EoolQ26Snq/+PC4ugTv0n5ijWKpDizUwu 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38ub4cxynh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 21:48:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154Lec3L188342;
        Fri, 4 Jun 2021 21:48:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3030.oracle.com with ESMTP id 38yuym8m5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 21:48:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+cFSzzFUJ9xOSEHuvBw6QhACNyb5YvHykVNrkk4964yjSbJlpOJad7vKy1nQ3fsT8REuCLo6nZ6PMVoy3v3fd5U4NHUmVui5q2Sa+A2M2ihDV2ACMNY17WoItKWY+six9Q2C+oLt2fBNnksjou8Qf/7DvMi3NFa+Vur8UTgcMPWF7XqPWA4uWCLxlilr9pgR+ucuKjuqQHTOGAqqAn0FP/wh98rIJCCZ2NTJZdWBxCPZQiGUMMhj8OBGZZs3ZxNybVTWX3c2eLwmdaBuRX6UwFxvWM/K1r5O+RuRwEs0dfx4xjewkpJXcslgKT7jycp58hGkYY3LnYM4sQ7qHk8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aYe3PclXF18J3MGw7f9wTSuPk4sXyzwMSEQ1Dtqlls=;
 b=kXQtL4f8NyQb5BJ8N9lJRYC2oInD/PtFu7yoRiPPAMKAgHhXb6druq4kQdWuKCWiFlqI6GEHEpdhAevi1z7Rf/NoRQpKACt9qFIbneHZwSV9Xux1LVh7HcVUJYCliCthq3ioVxweLVhg6OpN2ITLHAzg3KZx4zavRqDCN9nXeiiEUDLiRVVfVri0VgkLBUYYDO3zFMrWeH9hlEnkqRnEM4A9Gq/P01nm51PkgMpSYs8YJoAoqy4J2ADKMUTZjSglHDHsTft+/Jz6V8yuhCEfTu7X5OFEFdsrVnP+OSgzM2pMk63euGMBShOHxqhhxmcpQbch84Zrov+bAVU2iCHOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aYe3PclXF18J3MGw7f9wTSuPk4sXyzwMSEQ1Dtqlls=;
 b=kB9X03KncY+/f1g9HusXiozWlN2ZL/XmVDRl19G44/JH/xWNVGY7twp+YxHMyYx1+i1ip8HoNUchXUcYV7U4vc+ON9kJ7TPVRvx37r0LdmvXdOFW7e79EdILympzRoXLOBCPTuAvtvCELhLwQ1A94lZLuhiwWBlI4y/L1Vf3zCw=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4734.namprd10.prod.outlook.com (2603:10b6:a03:2d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 21:48:08 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 21:48:08 +0000
Subject: Re: scsi: iscsi: Drop suspend calls from ep_disconnect
From:   Mike Christie <michael.christie@oracle.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>
References: <c429f1a3-348d-2cc4-7652-68ea4a63067e@canonical.com>
 <08f664af-30be-aa4b-aa82-2333650dee06@oracle.com>
 <f2679a9b-7ccf-b4b8-c028-1c164d532fee@oracle.com>
Message-ID: <2803b5c0-e774-129c-f168-3d5aabf9a6c1@oracle.com>
Date:   Fri, 4 Jun 2021 16:48:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <f2679a9b-7ccf-b4b8-c028-1c164d532fee@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:5:333::20) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0087.namprd03.prod.outlook.com (2603:10b6:5:333::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Fri, 4 Jun 2021 21:48:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0295032b-ead2-4149-eac5-08d927a270cb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4734:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB473476B2836B83FD0475156EF13B9@SJ0PR10MB4734.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AO90DwF48ZnCBPOV37kOPtYVYi8dadfozopdeLPgrFOaXg+baVmbBE1FC5eTlo4ytyGE0Su9BJck94kbfYfOsLbcITvivjbKN8RpYCe67T7hj9KQaw71B+v4XV56A/TN4Gjc5crTwSIfuptkzS3jVPIcDYHXleX5Zw6+FZxyIBysOnNioCgllB7Ls+hC5kZFFToFDT3gJDkwK8cbBiF+uRxTF3Lhkh8uSIJkQdwu4lkluCknvIx9L61XU7zzv0e2J8PhLQ5pk+nj9YlLIggr7cSDWiIl6rDcWDRm8jwCOCxnHDMLVSDcFyzE8L3iUXAYMmLZy3NIp4ASNhPmk0PacYoxuAzu3mPsB+v/RIyzPBkSvLFOCDRtJx/2wMXUQNGV2+h87rPO8EGjXxzBn1T2QCghEF2BDrYp7ZYckHrDs0POmXl0wRbvgvdBWa5IdNDiexmEvnuWb9ZBv/d79qvXV+9aFiyons04HYrzpi3OAqQyH2rjzj4gZJhZOEN72z0YLm2E2VwH57pUHCkugAtGhX8a6idCm5I4TTAvz6prGRTHKoephHz9X1KVbh+KikFbDGfe+MEcO3vSBrZknrOKdoT1r1QCspQSAZXFxOTdDAX6CQWsdwHvXGjSUD5ovlnzIiRiWwRdJRWEYshH4ShTiHccOBK/XJmwQmT4e9n78tP4wikHZ11QBv0uU2UpUhCoyErntE5befvrtIUYxUppKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(376002)(346002)(53546011)(16526019)(186003)(66946007)(66556008)(2616005)(66476007)(956004)(6486002)(8936002)(15650500001)(54906003)(4326008)(6706004)(83380400001)(6916009)(36756003)(31696002)(31686004)(316002)(6666004)(38100700002)(86362001)(26005)(5660300002)(478600001)(2906002)(16576012)(8676002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R0w3V3dxVndORjBSVGk0S3h6Y2Y1cDdHSVdhL2xqMEZXMGVzRHlxek1BVi8v?=
 =?utf-8?B?ZmdxaEUyRWhESTlQSjQ3b3ZUMUdadWhhbzhBUm8rSm1KL21YL2tMRlJCWjhl?=
 =?utf-8?B?OTZzOU55a1EzTGMvVE9WLzg0REY5aFZvNTA3S0JQRTRlL0NpZUhjcXFSY29F?=
 =?utf-8?B?a1FRbFBsYnNyRzB1RTUzdytoSTRFaFc2TmxKQkhpaVV3Z09WbHJ1NW9tVzlB?=
 =?utf-8?B?NFpUZUxmV2F6TWFtN3JrRG9HRmduek1MSStMZjkyL0JmMXhIc3dtTm83Y3N5?=
 =?utf-8?B?eUpVUG5vQ2xvVkpWTzROQytrVDJQcTQvbHYwSGRzM0lZTmdwNDByM2tPMTR6?=
 =?utf-8?B?QUhOUW5Hd3JpdEpZNGlGcStESEg4MEJuT2w3NUFOWkVFSnlOSkR4VFZEZGlF?=
 =?utf-8?B?Z2hsVlE4eFd1Uzhmd3ZWbVlkMUN0ZVNZSVNXbWQxMmtBanhBeVFqcmE4bUk5?=
 =?utf-8?B?WTF6VjRkT21RTVhNcDcyRlM0UlNzd1FaQVZBMFdDcU1Vc1dDQlcyNVU5TWEv?=
 =?utf-8?B?eFZDTTN2TlFCQkMzdWZnREdrMWo2dlZydWFCclkvZHA1V3ZQQ2plWUpjd3V2?=
 =?utf-8?B?VitQZlVRTG9jeG9lSWIzcFlqTkM4UVFyTzdlTEJ5QlVXMkFxRm1VSXdQSEJU?=
 =?utf-8?B?S0EvbUpyL21UeFRtZ1l3cktiZWpmLytZOUU1REtHNFQ1Q3lDcGc4Q1FxT0pZ?=
 =?utf-8?B?WWpSdGFtWHo4VHR1S1RJNkNodGJzRjhydkttdU5iKzQ2ZDNoK1lTVmZOcGdH?=
 =?utf-8?B?a3U3Y0ZrbEtGd2hDWFRFY05oTTJoTlhOdGx6cFZpRjdmbFB1a1NFa051T1lz?=
 =?utf-8?B?VjlYYjVFYmVFVjJSazJVaVlwZnJxR0UyWDgzcmVyL2hhdVl6U1kya0pjQkJl?=
 =?utf-8?B?RGJpS1JReXlUaGtGbkR6Q00yUlFrdEVFdEkyejdwM3FOdnhLSDNKdGJDdW93?=
 =?utf-8?B?YUc2WGVqYUlZOVd6RFZjYkVVVXhlTlZtbmw4UEZaaFBZc1hQZVFHOTZNZGVQ?=
 =?utf-8?B?S01aMEpLOUl0Zk1zSzhsaVdXL1dKZWovUVVnWUpKemZLalorM2JXQmY2MHVx?=
 =?utf-8?B?bUNQb1orTGloUS9UVVFLelYzbk9HQ0hTb21NbXBrcHNrNitaeDNiUC9GYXVx?=
 =?utf-8?B?SFk1MFg0Z3d3dmJKY0szU1ZKbkZMRFozNUwyNWpPSjJNNlhRRFlNRXFkamhp?=
 =?utf-8?B?K3VyOW9CdzRtUnAwYnB2NGplQ3NQTCtWaTFUQzM2MFlsSVY2em12MWQxcWh1?=
 =?utf-8?B?RE94V082K01OQ2g5UFZOSWZpbmMwTXpNL1o1ZENlVXNTdlVBcElPTkNzK251?=
 =?utf-8?B?OG0vRHF1eGlDc0pDSTkzdGxTMS9TUkE4YmJEeUY1dVYra0JiZWhRcnVOVzRP?=
 =?utf-8?B?NHdERlo4VHA3dE5Kc3JtK1lrWEo1cEQ0K2thaUd6NFIvcVBKOG9MWVZpeDFB?=
 =?utf-8?B?RUVJeTg1S0RabzlpTHpnUGZuNWxQSWVNWW5uazNoVXlFbnlvNWxuenZrL2k3?=
 =?utf-8?B?TDJ3RXhIZnN3S3pqWmlwTE0ra0U0OTB6bWFrWitLZVp0bmxuSmQwdG1jVWJZ?=
 =?utf-8?B?U1dZZThkYk85NFU2ME00ZWFNQ0ZkYUZDS3o5elNKb2tpcFFVeE9IVjdzeUdI?=
 =?utf-8?B?V3liVTBQSUNDV240SzdNQ3lXM2VTOFk5dFBFYkhQQnRBNTBoeG1ITjRQUlUx?=
 =?utf-8?B?eW9WdjdybmhYRnNMNlEyRjZRdHZockdpN016WVZ4SDR0aFRtUDczeC8zZ3p5?=
 =?utf-8?Q?M+G3/BpSd6OBbpZDwf/cei38vgItfSmymWKrfYE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0295032b-ead2-4149-eac5-08d927a270cb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 21:48:08.2861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLiLMrBE+hf7Ksr1wP5CQQSpBORPvIog8u/wlFbem/Ccrn0cmaM0do44dQkpPCigdOnEW50LOXJdQJwhck3y9S1hygIR82RhPIqdBAQ0D4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4734
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040149
X-Proofpoint-GUID: t53RDLfbfrQPS1EkQs5CPPbF3ej_-o1G
X-Proofpoint-ORIG-GUID: t53RDLfbfrQPS1EkQs5CPPbF3ej_-o1G
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040149
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 6:27 PM, Mike Christie wrote:
> On 6/3/21 6:25 PM, Mike Christie wrote:
>> On 6/3/21 5:25 PM, Colin Ian King wrote:
>>> Hi,
>>>
>>> Static analysis on linux-next with Coverity has found an issue in
>>> drivers/scsi/qedi/qedi_iscsi.c with the following commit:
>>>
>>> commit 27e986289e739d08c1a4861cc3d3ec9b3a60845e
>>> Author: Mike Christie <michael.christie@oracle.com>
>>> Date:   Tue May 25 13:17:56 2021 -0500
>>>
>>>     scsi: iscsi: Drop suspend calls from ep_disconnect
>>>
>>> The analysis is as follows:
>>>
>>> 1662 void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
>>> 1663 {
>>> 1664        struct iscsi_session *session = cls_sess->dd_data;
>>> 1665        struct iscsi_conn *conn = session->leadconn;
>>>
>>>     deref_ptr: Directly dereferencing pointer conn.
>>>
>>> 1666        struct qedi_conn *qedi_conn = conn->dd_data;
>>> 1667
>>> 1668        if (iscsi_is_session_online(cls_sess)) {
>>>    Dereference before null check (REVERSE_INULL)
>>>    check_after_deref: Null-checking conn suggests that it may be null,
>>> but it has already been dereferenced on all paths leading to the check.
>>>
>>> 1669                if (conn)
>>> 1670                        iscsi_suspend_queue(conn);
>>> 1671                qedi_ep_disconnect(qedi_conn->iscsi_ep);
>>> 1672        }
>>>
>>> Pointer conn is being checked to see if it is null, but earlier it has
>>> been dereferenced on the assignment of qedi_conn.  So either conn will
>>> be null at some point and a null ptr dereference occurs when qedi_conn
>>> is assigned, or conn can never be null and the conn null check is
>>> redundant and can be removed.
>>
>> The analysis is correct.
>>
>> The bigger problem is that this entire function seems racey with the
>> normal conn/ep disconnect or shutdown.
>>
>> Manish, when this function is run iscsid or the in-kernel conn error
>> cleanup handler can be running right? There is nothing preventing
>> those from running at the same time?
>>
>> I think you want to call iscsi_host_remove at the beginning of __qedi_remove.
>> That will tell userpsace that the host is being removed and libiscsi will
> 
> I meant iscsid not libiscsi.
> 
>> start the session shutdown and removal process. It then waits for the
>> sessions to be removed. We can then proceed with the other host removal
>> cleanup, and at the end of __qedi_remove you do the iscsi_host_free
>> call.
>>
> 

Hey Manish,

Here is a lightly tested patch.


diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index fb44a282613e..9f8e8ef405a1 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -72,6 +72,5 @@ void qedi_remove_sysfs_ctx_attr(struct qedi_ctx *qedi);
 void qedi_clearsq(struct qedi_ctx *qedi,
 		  struct qedi_conn *qedi_conn,
 		  struct iscsi_task *task);
-void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess);
 
 #endif
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index bf581ecea897..97f83760da88 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1659,23 +1659,6 @@ void qedi_process_iscsi_error(struct qedi_endpoint *ep,
 		qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);
 }
 
-void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
-{
-	struct iscsi_session *session = cls_sess->dd_data;
-	struct iscsi_conn *conn = session->leadconn;
-	struct qedi_conn *qedi_conn = conn->dd_data;
-
-	if (iscsi_is_session_online(cls_sess)) {
-		if (conn)
-			iscsi_suspend_queue(conn);
-		qedi_ep_disconnect(qedi_conn->iscsi_ep);
-	}
-
-	qedi_conn_destroy(qedi_conn->cls_conn);
-
-	qedi_session_destroy(cls_sess);
-}
-
 void qedi_process_tcp_error(struct qedi_endpoint *ep,
 			    struct iscsi_eqe_data *data)
 {
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index edf915432704..0b0acb827071 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2417,11 +2417,9 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	int rval;
 	u16 retry = 10;
 
-	if (mode == QEDI_MODE_SHUTDOWN)
-		iscsi_host_for_each_session(qedi->shost,
-					    qedi_clear_session_ctx);
-
 	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
+		iscsi_host_remove(qedi->shost);
+
 		if (qedi->tmf_thread) {
 			flush_workqueue(qedi->tmf_thread);
 			destroy_workqueue(qedi->tmf_thread);
@@ -2482,7 +2480,6 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 		if (qedi->boot_kset)
 			iscsi_boot_destroy_kset(qedi->boot_kset);
 
-		iscsi_host_remove(qedi->shost);
 		iscsi_host_free(qedi->shost);
 	}
 }

