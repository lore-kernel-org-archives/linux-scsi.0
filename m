Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_RED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D0CC4743E
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Jun 2021 22:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F32613B4
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Jun 2021 22:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFEWmR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Jun 2021 18:42:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35448 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhFEWmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jun 2021 18:42:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 155MdYIE050369;
        Sat, 5 Jun 2021 22:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Y2Q+VL3qU83kln5klqF1dx6cFO2bczJvpNRmmrMhNo0=;
 b=Gu2ngvtzdCop7RXNodvOdlE1ikMb28ouP0GTNcTnQUmUB3m2LBCwrTpeZAdD2SBnPxxT
 Xj2Pcwp2MkPydH7y4SO1X9esPTPZDlUGMc0RTjB1I0YRNUJh8qk3bdCo4taejNx0CPaI
 0/EOCbOUs+tGW6Q7XckPZPhECmidtdCXAtft1NT8O+j3nmkBZ+wxU3vyewFoxOj7JZB6
 vuITTHekHxD3A1gmx9NFWA+pNg2ve+5kiR06YQUBLEUBN3ZRe9DuiHEU8K6b3Pj4OVqt
 i1Df4QggmgTinK3GrJtGd/yW6IxtLJlDYx1Az/Y7vHXlgKF4sc9PiGh8np0UZShJRyzS Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3901wp0p61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Jun 2021 22:40:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 155MYmq1079865;
        Sat, 5 Jun 2021 22:40:22 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3030.oracle.com with ESMTP id 38yya96gw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Jun 2021 22:40:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuhZ66VNjDKj2STEhPaaTRFvG7YWA+6pAlii44U9zg0kWKUT1FnTound+Id6vTL67BT5R2vmgmAJnf7/h7PXOF4uPCpRlzhDNFjUYS//z5j7OxbRlZNMjM/uph30qjBAA2OXrvQkMWvVw6UBQL+IAQy88tBnAdM82pkksljQGLn7FEnGzH1Wy1zpoBLVgu0PVV2FZhpq55fVeoxIzQKduhbZLsobYwpF6RUDi+luLcS/Va1YrXzMPX8ctDzpwyEJU4glZKDRowKOc82db9CUY/whPqMa6yXhMFEijncFVDoRe1JSq9hQQHuHd+iu5hSkFyEQttO8+2K6d7a8dxXKYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2Q+VL3qU83kln5klqF1dx6cFO2bczJvpNRmmrMhNo0=;
 b=FWHURJKec5QcZtV0DIleITz6tP6RCt2eHFLEG2ubhe+Srl+HBmesPkgtjlkcqd2IkG1fpTpMWkV+k6QDv+IXgW4uCZX0jINZe0jodm3xCNTH66Wq4FIZ4YffErQ//m0OyZbv970e8NRP+PIFj3PaH1aumnuFSSILoLwfWQryIiBOijm2y+4vtm1EslNfEdaPnazxxhjsLtneGt8/zgGd6mCuaaEIdc8gO4wMSqBEBxw8z5DFlsTmZhPV5OkuuGy+Kt6aTCjhIqHbMbqRub2yTji7Mx/x8LV/lBqrS4qub7I3nejhcHGkMkDtfCxY/JEWhyCHMhN9oA1jx7CVWT37cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2Q+VL3qU83kln5klqF1dx6cFO2bczJvpNRmmrMhNo0=;
 b=Du7L/ytMpor6lSsdzN59JRps/KUby7xUddh1Fv0XSLm1AN1T9VxJ0aZ8W+JUhjab6bzczg6ipBlD5nRAuperdB7wON/wnLBNEhy7+Y7bgcP+SlS6GPtIZd6G4l7llvUrrZVP6OlRUmPV0W3ex7rd1kilptN9ARRBZukZM2LH26Q=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3701.namprd10.prod.outlook.com (2603:10b6:a03:125::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Sat, 5 Jun
 2021 22:40:20 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.030; Sat, 5 Jun 2021
 22:40:20 +0000
Subject: Re: vhost: multiple worker support
From:   michael.christie@oracle.com
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <YLjpMXbfJsaLrgF5@stefanha-x1.localdomain>
 <523e6207-c380-9a9d-7a5d-7b7ee554d7f2@oracle.com>
Message-ID: <faa6085b-dfd8-9ddf-8b52-20053ac182ef@oracle.com>
Date:   Sat, 5 Jun 2021 17:40:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <523e6207-c380-9a9d-7a5d-7b7ee554d7f2@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0096.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::37) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM6PR02CA0096.namprd02.prod.outlook.com (2603:10b6:5:1f4::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Sat, 5 Jun 2021 22:40:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da709be3-3b21-49b7-1bdd-08d92872e5d5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3701:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3701DD061175E3D11E6F5F1BF13A9@BYAPR10MB3701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ozocP/hYX1DIZFmFJY6FrhJir7o2wzfFTdQbh1wRkChga4JSiOB1/EXQlXupbSE8E8PM3y+SCUfUEGWxipvIRdg7DrXGSKq7eJQHf/emUPShsaegOyV0twPSYx7aZ9QVLanrEeZBKBL0KMx2OSJgCrAxw0R6BFUzYqg5SM0258jqvONdcFebaXau4LUUqtzAOU1CMFPQBNsPxcXuuSSrQPQF18wE0o+zIQC7jadv6NPOxHzyeg6Pfz6mG1vZ5r2Sjh+O/Qpxb+1pRHGsRgU4zPo+ZsQc/FbQ3zBiXDrDI89T1/MqiiEF4uEVfzsDiu00aSG5KPzWXwsk/hd2bJFewo7x86Ap1TjUcXfFFKDTEwcqYjQ6E3QVlesXljmXUW8Uqd6HkP6m12vE905+1pWU8DDoX0GW9RSuwQp2y1/yplWusZmI6st+KOx3SO7+B4wRIhC2ezQ1xrZ7tKUkBpDc8EJLp+3ex4uBnchaJyG4lnLDbFY54Jn626i7iktC5FNHb4wKxCiYqDXv9HvT/+fmgSqPueIn+a3YspzIwQh7NOIeq1MG4qkvY82Ub/PiTwITc4tEz62dbuxBsqhleO4GmOMBcQgQBDAYE2/Pm8P3h54+8r+aoOzqsqiW44nVA1ZrcoKppw5kZuwbihciYMCI7zXUnIL8jYkarkFFo45mXxLOIaNcwrCI4NClymP/BQXtzSszSJWoCCjhxgPurfK04snK6glW88wmqUeqDnnAide5hkXFpd82FhEp2fFzNuWnfwyvuDpintJJzqEF+F/1u11shb44tg9gmmDTZyFAv30=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(8676002)(8936002)(38100700002)(6706004)(2906002)(4326008)(31686004)(6486002)(186003)(16526019)(5660300002)(956004)(2616005)(66946007)(83380400001)(86362001)(31696002)(66556008)(66476007)(478600001)(9686003)(36756003)(966005)(316002)(16576012)(6916009)(53546011)(26005)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?hKlFmLHKR/AtGdU0sJuQ0Vej6Zl5Jlbm+Shevy/ybnfG6OSc8L9au40f?=
 =?Windows-1252?Q?AIEOaA5ag2g2US8aIh8mpPsW0q/VsMX6LCrhRsTi+9pdWKnX8nHuFcRd?=
 =?Windows-1252?Q?s0ZgefOsL2h8bK/YOj81CXHaQq8Cwe1ys8cn6FHze69bbm6fjbSCLXX0?=
 =?Windows-1252?Q?uV9j52F8d1w8Ts7sMtfU1uH2TxgVRi7VoFw1EpOW1uPgAzyXxypZP/rD?=
 =?Windows-1252?Q?7Dipx88if5MLSK2BEKQnDtved4f4pb3kH2Iq11751cvifjlo3tTcYvXO?=
 =?Windows-1252?Q?W8pvnsp3uFdV/Vxw8rwPgDLsA8mQfRb3X3Nobid/kyhYBRwW46PHCfZa?=
 =?Windows-1252?Q?vkq2Q16CoEPLEGIlgXpJTNrBJidcfD1wV8bHjL6RpdCL8NcGihDWwp65?=
 =?Windows-1252?Q?vEbfiAOCiaQzMRGdwp0JlM2EtXddEcnNnwIuqjiDQ3+wh46EFwW5Xlz2?=
 =?Windows-1252?Q?N7gIN63ENYk2SCDiUdaNnaY40uVs/I5wtkd+N2SAH4jkiZI/jhw/7E7i?=
 =?Windows-1252?Q?D7zOH4E7TDQLl9IePxZqeN7UVNxyv1RH67MVqhaP3+ONngCEwN+itCfD?=
 =?Windows-1252?Q?+V4kmh50lzQkg/UBQCvz4SRnNvfeD9I6JCJ9E3g+fF9ogsFvuvbjZMwz?=
 =?Windows-1252?Q?IXCg5AW+/MToPpEjbnaeiafkIxYxmDDX5/MOYEFF4FyH1z7IDRqWBe1s?=
 =?Windows-1252?Q?dUo+N+x8i0Q9CMldizHjdVar8DEyqUzQF58TtWwqU/E12lr2GTvCqyvR?=
 =?Windows-1252?Q?f/jfzSAWb8WpVXp1u+q/+wGIvWHNyQtQGNb3Ln0K2kW9r+8swbhy8wjK?=
 =?Windows-1252?Q?4DJgpGzcmIr2gBAblmgRTMiwvQHTDty0lnWaslCYNDwDt4zXoffL2nPi?=
 =?Windows-1252?Q?jyuuOKrtY1PL839CWKRY5L0UnajEqOlBnyNwsJppsOrA8tp/UycN0B1M?=
 =?Windows-1252?Q?rvGmdXMOxzMkPE/Vs1qh1miz5WPuUNQfBj7cMkg6oqqg0qcWkWQ0OJN5?=
 =?Windows-1252?Q?90DidKntyoFxAsCpTNDApnzR+r187n6HKEGtclMrcPQbxBnQcB/FpxM3?=
 =?Windows-1252?Q?HpJmw25/a3ngz31LQn7FloxYGPWEfmSWqXBieN8CukPqYUoYzCTnnuKw?=
 =?Windows-1252?Q?j4oRA3gOas4xt/4kqO9j5fptT/YO0dgoNb9E8e2QY4868rVbb/fAKgBQ?=
 =?Windows-1252?Q?ZjAEhKtAssixnpY5eP2fQW1vbGnnuDf27HrG+6pmS+nKW0B48MY4WYNC?=
 =?Windows-1252?Q?VRY0xP+u7g2RWyzXrykLG41cyjOVutTCL6SlriXWTdllvp0o8p8XMLma?=
 =?Windows-1252?Q?7L/ZxDC2jN1YA46XZabE7F9wvca0qsK6xBE0KxyfP1YWrQ7dmpcnJiWu?=
 =?Windows-1252?Q?HwCSY7rChY93rI6CX2LrvHGJXf/QaKUJHngjmyhMddoSu2l4YF9RqhQy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da709be3-3b21-49b7-1bdd-08d92872e5d5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2021 22:40:19.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KaRcEoF69xEq2cPNTuuKxDopw9nF0niQxdXhGXoFU1xQE7Gi2bSzdRYag6pI49/YzojFf/mdJV6RgYB7ypPRSIaQ+en03TM32Zj3jCHO2zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10006 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106050164
X-Proofpoint-GUID: aKsCqgb0ZOYZoZ75xOdCPjEn9SgYBca7
X-Proofpoint-ORIG-GUID: aKsCqgb0ZOYZoZ75xOdCPjEn9SgYBca7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10006 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106050164
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 5:16 PM, Mike Christie wrote:
> On 6/3/21 9:37 AM, Stefan Hajnoczi wrote:
>> On Tue, May 25, 2021 at 01:05:51PM -0500, Mike Christie wrote:
>>> The following patches apply over linus's tree or mst's vhost branch
>>> and my cleanup patchset:
>>>
>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/pipermail/virtualization/2021-May/054354.html__;!!GqivPVa7Brio!P55eslnMW_iZkoTUZckwhnSw_9Z35JBScgtSYRh4CMFTRkSsWwKOYqY0huUfBfIPM8BV$ 
>>>
>>> These patches allow us to support multiple vhost workers per device. I
>>> ended up just doing Stefan's original idea where userspace has the
>>> kernel create a worker and we pass back the pid. This has the benefit
>>> over the workqueue and userspace thread approach where we only have
>>> one'ish code path in the kernel during setup to detect old tools. The
>>> main IO paths and device/vq setup/teardown paths all use common code.
>>>
>>> The kernel patches here allow us to then do N workers device and also
>>> share workers across devices.
>>>
>>> I've also included a patch for qemu so you can get an idea of how it
>>> works. If we are ok with the kernel code then I'll break that up into
>>> a patchset and send to qemu-devel.
>>
>> It seems risky to allow userspace process A to "share" a vhost worker
>> thread with userspace process B based on a matching pid alone. Should
>> they have ptrace_may_access() or similar?
>>
> 
> I'm not sure. I already made it a little restrictive in this posting, but

Made a mistake here. In this posting I did not make it restrictive and
I was allowing any old 2 processes to share. So we would need something
like ptrace_may_access if go this route.

If we restrict sharing workers with the same owner, then I'm not sure if
need anything.
