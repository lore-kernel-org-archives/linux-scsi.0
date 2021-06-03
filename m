Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E63C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 22:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232CC613D2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 22:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhFCWSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:18:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCWSj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 18:18:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153M4gxX015498;
        Thu, 3 Jun 2021 22:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hY2MHd46xGqK43Tb0eVT5TU2fFv22MXeGcIIsnUSZq0=;
 b=cc7r7UGAwkzJZNADKweuBNFjsB2O43hmdolqRp+6hqstvM8yc794DsaZmXp/73J+8S5C
 BtOzBneCBKJfv66YpafI3flOodoenaYXCu6vfGiB7ornXLR6Xgew+X8voVblO4GAarQd
 B5esHX301BhR4Rr4Ruk2IkQ7nNk5Xm13fiQ5/W3BgmM/F/cvbObJxxnwj+twtBuoZw7A
 rMCA4bCWJDGcQr9xfwBpX9WtWZKLIS9fo52a5S4x5NDFICsURvOyjpaMGkSWTglnpC/Y
 RSYJ6BwuXdJcshXIP3kOJPXv5laRX0tYQFS3hUeIp4RFByqEOUurVbKxqJ8Y4ZQHnP4r kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38ud1smhgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:16:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153M6MoK194394;
        Thu, 3 Jun 2021 22:16:49 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by userp3030.oracle.com with ESMTP id 38uaqyp6tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:16:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxGGp9KJm5+wUKVIToyGmnZyfUKmXYZCME+hUqbu+Xgx+nXjNxqczJH+WvH2kvDPo4EXtdnJS+4DITMB5T9xKnCHmmoE97fvgy3ZqirvRxBkmRoPXb4FrqUw3UTqQoSgLztqQeeyiXHWiYh7TCf5qCCSKrh8+t6YGCez5vuJ0HVmewC1LcVE+a2DG9ZRJy73DC9TOMe3XQ52qBIbf2vqwXGisqHzTFD54iuILyeS4MT5CIrUUhDWY39CUn59ip2STpuzuOkOUXoVX8xSUVXVv95LAQH/y8fZKKug22KZAeNeRcUw+e25oMD2rJul6Oz2pD1Ne7TM3oUIDv0tKhZTnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hY2MHd46xGqK43Tb0eVT5TU2fFv22MXeGcIIsnUSZq0=;
 b=HuFTdamf5BZF6lHrOUU+AdeWSHkIjvlenP6zF4/3JAjkHUJ553N8DOg6X3nCoF0ulHhkYwp4vyDPUEw5XJu7TT5CSVSuPfrv+EIFZfYwEqYLtDp5/082JBOZhCH84xDDBo2iPmmxUOfcOFq7FaqxLbNQ9R0QRshgT6ItSD6D8vYFjHhdni5Oehd4Y1cy25piZlJtt2p0ZjrSE7jxMcp359P7DSJQfoIaJtZKak4oTy854yq3yZHw6P9rf1BXDBXvDNYOXb83bbNCy7lEmvtUKPTgILbFwMp80A/Bq1mnWDnkAJOWsW7OsiWbnzYRXX+xhv9MhAkMFIvh7/jsbaYbew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hY2MHd46xGqK43Tb0eVT5TU2fFv22MXeGcIIsnUSZq0=;
 b=maMKgBme6DuXJL1Yah0T7dT6ZsIsjfuJ7c91zlO8sRcBBagXYFXZvj554li45AWQtynl0RGqNTTzCF8o7Dr+5E0sf5XgKuwmTQbArxFfVH6vYSy9PTYACEWjJyZApsxFqvKUaPKajicQB0DQVRc3MQ2Sj/ALNbDNw4wYnW4M8LY=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4448.namprd10.prod.outlook.com (2603:10b6:a03:2ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 3 Jun
 2021 22:16:45 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 22:16:45 +0000
Subject: Re: vhost: multiple worker support
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <YLjpMXbfJsaLrgF5@stefanha-x1.localdomain>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <523e6207-c380-9a9d-7a5d-7b7ee554d7f2@oracle.com>
Date:   Thu, 3 Jun 2021 17:16:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <YLjpMXbfJsaLrgF5@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:5:335::28) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR05CA0059.namprd05.prod.outlook.com (2603:10b6:5:335::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Thu, 3 Jun 2021 22:16:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34b3663a-4e1d-44e7-81a4-08d926dd45b5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4448:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4448B2D3A3B5EEAE6FA17516F13C9@SJ0PR10MB4448.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIwJCAPSxXmQxYgZE0pC++15j/3BVh5IPo+ldZnEpeuLm9s5ARGgZFF+1lehSAs3/mIkIOKJlJ195wdKgaaeJgtg6esbJ1Q+YVkuvmDFJQk0ChSc8QlRuT8551SUUaD4CZuewm3adv4g18rz03R/tSxMSCiTJiVJux8fe0hL/hXCS41LhK1m405HzuWUhkbcoW7Yei65LYEklBkW+Z7NMW7pEdGkEWqxodR6yOWdwWBHakyNllix5p7suHjFz9lLWoHHi+DZIUDM0HmY0wHSgzQgOq4bKIB2sdt1PC3alOJWvpL2fPEA2ZLWcFIRCdfG8w5vHHmg5oM4QKuhLPqr10d3ntFwJiG48v1eXZDZpGfPVbkuBQ+Dj/vtQHw+OtxHI5pZChC5t9N2YRyo+P5pShbuuiikHgo6OuRLoWiJdq/taY7ibfIzqlmvRYefAwXBS9Izhx+VhgzCA1eyQSegf5B9MST92WV1vrjA0SCejYE0m6X2UWQaUFDnHyZI836pdr1mVcaZu0uZtDOm2NYe2dDeowvYQLhDHUnaqbacm7A9CRhkjCWxU+89uZn/mrWoa+ZFfv/tQGThUIAHPH16axhAG+7mB+jIeYAiS1Jls11ItI9Itwwn3nO+REr1Du9ake4ujCC5culL/2PnIFvPSfB/LllJTyuUzP82HVpo61jyBAxTIhQz6tXvISMuPjVI6D7mGjULJSDxboo4TiNdOwqDJhGYL/14v4LS8uR6/bM53lnizwTC9gPJFOnQ0tKhtvKGXqoILHlDSufiNfAvOoeg6NVzsdi85bQ6dSvzWSuQTbboi/6EquKOrVooZu5zYp0n98O2c1ogDLD2AemPZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(39860400002)(376002)(136003)(966005)(31686004)(16526019)(6706004)(478600001)(5660300002)(6486002)(6916009)(31696002)(316002)(8936002)(186003)(86362001)(36756003)(26005)(16576012)(53546011)(38100700002)(2616005)(956004)(66946007)(66556008)(66476007)(8676002)(2906002)(4326008)(83380400001)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?3+8y5ieC7uod/Xodkrd4PS/llej+PzszbkZS9j0x8cEOwuvArUQNtrqw?=
 =?Windows-1252?Q?bynlX1yPS3buBDIJPCfLgk20qQc4h6tZ5XIrPqgjS4L33texRcMHqODP?=
 =?Windows-1252?Q?OvKom6Kb9Mo8AAS+gco5X/lg94yR3OXNnfXT/rG+yb76YFFsaeFN6+q/?=
 =?Windows-1252?Q?qBPFFb3AijwYwRVG74Qt6owdbO8GKZNwqGjR+e8idOK6Kz+VBbXZSx9y?=
 =?Windows-1252?Q?/cXzeTkMfvrM9SvTnAwoBvAgHMMmvT590oZYrONTdFmJYdnsQmzeNhEI?=
 =?Windows-1252?Q?MQ2Dr7SnGxAmb8aLxxm8abL+8xHN6PcsIvynp8wXpAnvO0AGYF/+0NlY?=
 =?Windows-1252?Q?9MyeA5Npawq4p1Ou2EEslaRrQAuRkdRCm1LhCx8kB6GOPgREPFMUM+oW?=
 =?Windows-1252?Q?2R49nk3dCl4FCmW4a1nt0O2bP2/kmpnKPaYP03HvgKGFzI2YG37Tta9q?=
 =?Windows-1252?Q?EQxx6+s6KECWY3o58VA2/LsRKHzxe2KBj5X20xz0XDNZrGlrO49xo10Z?=
 =?Windows-1252?Q?D5etw5T3HxAAO8qZNRMg00xpG+Hq288agUYl1Zs/d9gVYhdZatT4Jp3z?=
 =?Windows-1252?Q?klpUJsNsxrdFwTW5fi76xBPMNxB1TxQXn/lGy0zmuK0yDVoORGTri9OL?=
 =?Windows-1252?Q?bCQf2W/dRT4IAxYrlP5yZzTe7Iy7emBETZ7M3taSwsQ6wCNmS52bJqv+?=
 =?Windows-1252?Q?06bOrkV9tmGeV2MqzM1ovupAqXZlidTjzsZAyd0buvGnp2XtsV/zasdD?=
 =?Windows-1252?Q?fKYAOxqG0yae4CWVFuHNlDPwJNTRowzz0Lws4pFwwKoAFYTDp2J02lKm?=
 =?Windows-1252?Q?l0NKnjaGJ1zbso6VoLbwot9F+qORBc60q8R3rMClOaLxcwoQ3h0fOt01?=
 =?Windows-1252?Q?m7Gcq4vBS8I6QObLNJEF0jlw2mGNfBxpnKrpKjra9AK+s9VSLd1B5DrP?=
 =?Windows-1252?Q?EmpaezlpMjs2QrJ2nMNg17pZtGGOc/rswwtjhd36JK1Dlm/sw97pubkm?=
 =?Windows-1252?Q?vjHCBzTo8QcUD430l0A0HUv9DHHKUH/BL28HZYzl4qrX4sdRsAQk4v+g?=
 =?Windows-1252?Q?yFbFwCP+qRZddzKyF3mD3STlqWQ6VG0i+FIXXieiKzyvyVeCLnvCoB/O?=
 =?Windows-1252?Q?DZwZqAzAb+gNSoQozbhSBYbnGZvlhq1hELuW5/fpquKQD4cPajsJMgIg?=
 =?Windows-1252?Q?b9Jwe+XR0m0XAQMAsn6AmSfAULqklA7vQygDDT7tGGZ3ZchLof8pUZ2p?=
 =?Windows-1252?Q?mhB1ZnP26hKVBAQIXKnmfbgRy90c7cUi8YuFk52Gib8Roq6zjTIFprZ4?=
 =?Windows-1252?Q?W18+SfD2U6aqJSNCtBcltIAF+e7BTzQVGMysgHWW41R0m/aAGSUV5zL9?=
 =?Windows-1252?Q?gdLGDDHaWAXj8W8WkZ15vjpzvaApIDPEMo7gyyIBmKMJQz+xnGWfE+k5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b3663a-4e1d-44e7-81a4-08d926dd45b5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 22:16:45.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNRUXHMm5ULbkKp/enzNmvaobMG6GJSVXfkox6uk85PO8uIu60rQmIhwkCw9UrAmPnc29Q3f8yhk8tdruS/zknbFFA+l1cSEuX1Ha++U1jU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4448
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030147
X-Proofpoint-ORIG-GUID: HahEWgh9p7SpC1gCDu-sGo4j09irTsIm
X-Proofpoint-GUID: HahEWgh9p7SpC1gCDu-sGo4j09irTsIm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030147
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 9:37 AM, Stefan Hajnoczi wrote:
> On Tue, May 25, 2021 at 01:05:51PM -0500, Mike Christie wrote:
>> The following patches apply over linus's tree or mst's vhost branch
>> and my cleanup patchset:
>>
>> https://lists.linuxfoundation.org/pipermail/virtualization/2021-May/054354.html
>>
>> These patches allow us to support multiple vhost workers per device. I
>> ended up just doing Stefan's original idea where userspace has the
>> kernel create a worker and we pass back the pid. This has the benefit
>> over the workqueue and userspace thread approach where we only have
>> one'ish code path in the kernel during setup to detect old tools. The
>> main IO paths and device/vq setup/teardown paths all use common code.
>>
>> The kernel patches here allow us to then do N workers device and also
>> share workers across devices.
>>
>> I've also included a patch for qemu so you can get an idea of how it
>> works. If we are ok with the kernel code then I'll break that up into
>> a patchset and send to qemu-devel.
> 
> It seems risky to allow userspace process A to "share" a vhost worker
> thread with userspace process B based on a matching pid alone. Should
> they have ptrace_may_access() or similar?
> 

I'm not sure. I already made it a little restrictive in this posting, but
it may not be enough depending on what's possible and what we want to allow.

Right now to share a worker the userspace process doing the
VHOST_SET_VRING_WORKER ioctl has to be the owner. Before we do a
VHOST_SET_VRING_WORKER, vhost_dev_ioctl calls vhost_dev_check_owner,
so we will fail if 2 random processes try to share.

So we can share a worker across a vhost-dev's N virtqueues or share a
worker with multiple vhost devs and their virtqueues, but the devs have
to be managed by the same VM/qemu process. If that's all we want to support,
then is the owner check enough?

If we want to share workers across VMs then I think we definitely want
something like ptrace_may_access.
