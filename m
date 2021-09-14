Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53C7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 18:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD092610CE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 18:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhINSOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 14:14:40 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16120 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhINSOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 14:14:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EHxi9U013642;
        Tue, 14 Sep 2021 18:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ON+yx+S/gB47ZkdQBQ4Ef3xtfAJ4DL2hQlVgteMd2Bc=;
 b=jim8FlSBFqF3LkLK+dsgUsBeqWs1LW4q7+nhaX9vcWFAXfwiBEmDSFmmXMSVkIl80a/e
 0F2n7SWwhjuLfUUCXcGgXXHcVU/r1HuQ7GOaWEmCLLZJzUp3hTvT7krAyf3h7gOz2p9j
 TFcoFNHpwIlLlIuSzvek3pWbU5Sgoz/dVRLpHhAMGeXXv3zKyIdjhAoUHohUtwgY1Q1a
 I3DprWrMbQNvWeilAr3pGWTwcGeE+TgucRMUu7C2AmD5D1MEPfoNRfUet5pJHSZl9wTT
 mGc6YAqtAtVAZMu2WKggsqcbYsChC+zkemyB8K9NsvqafHMWYMPbUdSYSFr5R8yPxZLW 7w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ON+yx+S/gB47ZkdQBQ4Ef3xtfAJ4DL2hQlVgteMd2Bc=;
 b=RVe/iwb9zxNI5sVwy79+qcDZ+5c8DRXMPADEeXniJvRIezjlomDOQZdgzPCI4S6gvuVT
 zMKRe0tSKN58QIJMrGzs5ODlxBIx/4mLP2veDAnV83kuPIDE22guTluxaLs9uQ1M6Mg8
 d1KPNbWOPl4yqJ/E8OtZvLVV+vdoDC7gzRRKPhbfgB3cuZQuYTA1uD98xlkhJAi9jwoJ
 a78TLJLPZhuB+0DSB3U41HhxObIJKvn03oMOjJRcQiObBAiPBSPBTG1DkbVpRAh/16NQ
 FzERgTxWTA489UmswM2iZpv8RtOz5outZtpw7uvJvLTJ1vaiUKP9O8hlB16I0XyNvQzE xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p3mjjcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 18:13:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18EIAY16087549;
        Tue, 14 Sep 2021 18:13:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 3b0jgdg854-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 18:13:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JN01vOQvPevOgEqBuq9CPqXCFguuyP0WN44cBHkDv28VJT9D+hB62CdoOmJEqTA17nVzFBMEUMA9roML3nI2OrtzUOKhCl7ZMFdyM4p4zBfAVg5m7VN1VGgBUqMOiXz13aujk7PHJyReJoPx4f2TU4c8tWmc3WuwtUuO4SGBEmRXcpDDrInpNi3zJ6qH/SdgYVqkfdoRSDZA6i9L+oQl1ahssmMtnT2FqM5tYBsPYWY7p1X+HSy1FC559wf6poBMZNjCKv9M0eFEHVb5gQUu0Bx9LmwQuWla0f1IP679SdVfdfSyAYi41HAnr7CSGXEe2OJ37iP94U9uIc+HUmfV7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ON+yx+S/gB47ZkdQBQ4Ef3xtfAJ4DL2hQlVgteMd2Bc=;
 b=R7LWZ0Eul5OZrnDcSoBzVz21/WAj8daihY35wf5x9KxrJVAR2cyoLrrWB094PAm6g01K2CrGamOwcOsWuuuTTnxox9wRmU5J09G5qD+TQNA4kvoJ5ZmBJQ1E9MkTdc2eQF2oHAGVhwfUowTV70yMHviJWdNt2ds24imfwVinfQGcs4kcK/UxDNOtSAihltGqBiQunA8KQQn0z5IcwgHegw4hYjA4vvoF4kpgjCcBqCpc+NFi/x0S9GO1VdjF2C1XWdwYvf2WiMr/Sa7vbJdTwNmqRToxHsOcynwDGsXOhFfdtzhKsODfKkO4zSJ7dWls/XhPwFaTFxN4MucBTxs1Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ON+yx+S/gB47ZkdQBQ4Ef3xtfAJ4DL2hQlVgteMd2Bc=;
 b=kxwun5rb9TWGOMAq9Bak4U2BELY1pzjp8oeQ7TfeJN9Xmp+INtLWsw09KORYiEnLhqP4VDG0TnKD/bP/GfBFh4hkzXlA/9BxOXew6y912x24GEBaS/byvy/fcqX46kHtJk7Frht+Cyy4oG2yNsgj5xzujuwNz91q1/xHSD7Vi9s=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5449.namprd10.prod.outlook.com (2603:10b6:510:e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 18:13:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 18:13:10 +0000
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Wen Xiong <wenxiong@us.ibm.com>, brking@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH V2 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf3zxd38.fsf@ca-mkp.ca.oracle.com>
References: <yq1v934yysg.fsf@ca-mkp.ca.oracle.com>
        <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
        <b73451e25a3f7881fb507500cb6bc0eae63f605b.camel@linux.ibm.com>
        <f754c31d348465f96ad4cd7541a86168@imap.linux.ibm.com>
        <OF31B21169.103CCF65-ON0025874F.00776468-0025874F.00778F79@ibm.com>
        <yq1wnnjxk0c.fsf@ca-mkp.ca.oracle.com>
        <743e68034d12f839a6bfbc6eab27562afcb5cf70.camel@linux.ibm.com>
Date:   Tue, 14 Sep 2021 14:13:07 -0400
In-Reply-To: <743e68034d12f839a6bfbc6eab27562afcb5cf70.camel@linux.ibm.com>
        (James Bottomley's message of "Tue, 14 Sep 2021 08:50:10 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0010.namprd21.prod.outlook.com
 (2603:10b6:a03:114::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by BYAPR21CA0010.namprd21.prod.outlook.com (2603:10b6:a03:114::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Tue, 14 Sep 2021 18:13:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70fb3e72-cd94-4219-f11c-08d977ab4f31
X-MS-TrafficTypeDiagnostic: PH0PR10MB5449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54495022824F95BFC852F20E8EDA9@PH0PR10MB5449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJpVijLcNlRZcmXRbjtpzuLscHUSbU1q3OEgkZQ9upXsI+1x3+NakSky+kvJWxV4HQ2WCM2TA7cwM53kDL2YO5C7P1bTfvq8FoaTY/3zR3Y+s7JODrLXa6z8f27Ur2yn+4XyVEyZfDjlYMA5qaHuoOIsZn3HjaIqKJWoIX6a1aCm4+GxQmMTMN97L1LogA6m4ie6NnEI9imEyj3Ldq1VKjsc05orj2V3qCXP/Q87vDjeNyzZYetYWF/2ihp7l/BEjbYOimjX/dbTxmGcuip7c4hFO9YIYAtBiKHoRbAOIGnn14WGJPOqXD+Zaa6Who6uCDkllvAG7J1dE8nH+GYlROKnxI+4OptYIm1//SsoB0ApPsghe32rYttCKSxqvB/KNOIgQzEUOwt3WpGXtfsG2DQdc6NvteO3JYyNMTvbjjB961zWPEErvr789mNL52cyO/LzynRAxt34/yIrmQDGSN2soOiu3gO+zWEPiCA+DfgSt0ON9lZUs8eQkkvY7aaOL0dPzwc3g5xGPasLHezfx1yabv41VUvH1j5+pwTHUQ6CsZwTlSt7m9FFTXmX/j4xCos9VouFjXWMa77u5D8OlKs4N4FHDxQbEd+mXXr6wotq/95k7I93jNYyppOw4TvNEoDusGrgL2YdUNNhujSESqegKL7/H4Tsn97RRuQuxm5JbgirMaY4Z9S9CV3wT8W0U50WKp48P+kRgkGSGLvnJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(366004)(346002)(55016002)(4326008)(36916002)(26005)(66946007)(66476007)(956004)(54906003)(38100700002)(5660300002)(2906002)(478600001)(86362001)(8676002)(7696005)(6916009)(66556008)(52116002)(38350700002)(316002)(186003)(8936002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lfu0dJxIuo5/WTN7duCquc1w/6W/HE1rHiqFkgMsb2tEDe0MeCOHzNrEDkG9?=
 =?us-ascii?Q?VQJx1vAO36iOWgIKurM2iESC9BtX4A5CgPgmAzfgwmELptpljQ7dhINkx0fv?=
 =?us-ascii?Q?sXKb6p9mKNobOgtrm9IjqGnTX+mG6oUEhxpd1wKfbKVRoBMn3YH9fl/n06Vi?=
 =?us-ascii?Q?XDXS4gqIaBHBOUP3AqgW91qhr1BHhTVC9bhryq87KSaB0STyd2nxsc6QG7ze?=
 =?us-ascii?Q?vasaNu0BXVw9nrlNzC63KpUTO/y3cTOT1nj8ctrjzxxwAZuNshNS0mFIEd+/?=
 =?us-ascii?Q?/WjryIo05JPtvsHkP0wVc0CmewOC8RiuYl0zwf9SzMum8B6D6uBdpvwtE97Z?=
 =?us-ascii?Q?/kqYbnQm0AhR5Gc6Ok6euvChwBfYfhoK5KWYNUmK3TGjQcvLI4yMBsoafUWc?=
 =?us-ascii?Q?pGF1SonAOrf8l1UVu3xuk0tfCj5o9ocHl/Kn+zhXe6NQsfFcHDiyG7txMF5r?=
 =?us-ascii?Q?yLuhg+zrIpAmHHlynaetXUN07mCzYTl0VXBVuDRylhE4vSaInoOAi6jADLt9?=
 =?us-ascii?Q?mh/yMXYddmxvX66LNUM2icStqvhRQsVjPO1J2tnavriR1MnQjBh8sKKNEFUs?=
 =?us-ascii?Q?rb/145kUWdyTRFikSRPsVXyqRAPci3MLd+rkoTZBYs2A+LErerkvF9fvlrtn?=
 =?us-ascii?Q?wcK5MkS59usCqBtmag7cZrmS6icE9fRFyp3SzUxq1joqZt4V0qkPqZvH8bhj?=
 =?us-ascii?Q?nApGpC3IvL7h/QtdNEZNf8238JYUahmrlACRVzR5kyUjbM9pfVEwqy4+BV1u?=
 =?us-ascii?Q?kwMMfuKjdMNKbgteuapuzQZjIgAjszYWmm0nYxm0I5M+zX/OEuS2eB/Nt5CT?=
 =?us-ascii?Q?ykWoXxsLc+4IjnOjc8KzyIJYE+8fxT+9E8/jDUokLMJV7OwNef6wCulD9U7i?=
 =?us-ascii?Q?zICtSd9dmAf8s3cqDC0dhdsXXjd8kOM/36ksD0D9AQc/z8Hlo5DhD2+1U+3S?=
 =?us-ascii?Q?9OOB9IIxqNeOR7HdG+IncL8PHMN4jARxBf5NSnOo4TVVLGyoUaIWJDW/pVKk?=
 =?us-ascii?Q?YIcF7exAa/VXR4+mwzyT/lCNbsT/bf8tKJczFnaglJPoYBEMhu/XnRLyFlcj?=
 =?us-ascii?Q?jMLhthBFb70BUqJcLNH1dv1GPFe/X2hazKjbafYLygKUwwwq/cVuiVO9BU6D?=
 =?us-ascii?Q?q8hkQPzgPudYeoQerdxIpdWGxr7k6K1vvqj6xhPTGiOMfM/chN7vvLZMwc4J?=
 =?us-ascii?Q?4qpiQDMCwBlNjTR49Sr1Nk3uvbzngrQ0EbN4kmgRhKrMuCJxbwBdavHWvM3a?=
 =?us-ascii?Q?QmgweHc5KXhNmi7LhqVVuc0skj8DstP7tlzRJXVznNDi65/EV4AJMJxjjPxa?=
 =?us-ascii?Q?k5PyS5ktsEQzZJu3T9nC/kn3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70fb3e72-cd94-4219-f11c-08d977ab4f31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 18:13:10.3890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8I9YpEB5zYSXbMv2hSg2rc6OcinQ25e2Rk7PiL5jTQ6drAFrPGx+84Sh0mvbPakYhrvMO0mEKv1pmaeBiFVZ11x/Asq+rqyVy5xmyTcIm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5449
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140104
X-Proofpoint-GUID: 7BWmrLVAF0M6vz9MKrfj-XB7KBSloZwr
X-Proofpoint-ORIG-GUID: 7BWmrLVAF0M6vz9MKrfj-XB7KBSloZwr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> I still think setting expecting_cc_ua is the best thing to do because
> it's designed for exactly the problem you're seeing, but open coding
> it in the loop would be fine as well.

The problem with that approach is that (as far as I can tell) we didn't
issue the reset in question.

We could explicitly set the flag in ses_recv_diag(). However, even
though scsi_check_sense() returns RETRY, scsi_decide_disposition()
bypasses it because a check condition is considered a "no retry" command
by scsi_noretry_cmd(). So despite expecting_cc_ua being set, the retry
is not performed.

Fun can of worms...

-- 
Martin K. Petersen	Oracle Linux Engineering
