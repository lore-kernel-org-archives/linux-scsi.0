Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F815C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B7261408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 06:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhEYGfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 02:35:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhEYGfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 02:35:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P6Pnax044303;
        Tue, 25 May 2021 06:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kpqBswRmoTBz1yb+1jyhPzKy3jjw5mNq5lnu6kg/TkM=;
 b=eDnycDiIODBIJK55WrhOiPnuDpsp80S9sSgv2mGtfPbuBqdgxD+Dzgz4G26RxrNE8Ayw
 JOlJQM4x9AYaNXjpY3WU5Ax3oOBOFdPvw7jx0XxOB2yFSveF9dSYetRiVlpJxUon8CkO
 lK88k6b7A+l+tQ7r/1gpIDlbsuk8c5A4EheDdse+ShZ8X/ls6ORECNwwzaHj+/5bzQkW
 nWT26IdFwyoFlntMdch0d459LRVZMbq63jCil2ZluZ6eGAKqN44Br47bs4+idn2zfBWZ
 RKqdQJAphsluClWLRMFCTb0B8VyShWxYcuighQs019KABu+4MnhBHlF5x8dl4dH5AWTd Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8vesq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 06:33:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P6OoIY084263;
        Tue, 25 May 2021 06:33:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3020.oracle.com with ESMTP id 38reh8yn26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 06:33:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpCu35oFZnsNOcoS6clsaHrDkdepSF3cKjDSOGddp+vEk8r8jZn1Z6sYTaceF6/kCjZzHXWTETkRpEIdlTQ0OykBdSzgNbZvwXmP/uuoIVvDoqtI47xxp9FEVYd8tkeDmSG6kVOqbalujg+vUWlrlOjCcHSdmh/qfUaV4L57Kv+NOm8fRSfiL0UcpR2MHe6zY2Iz0FiXuyy87/jvzmxidJFL/w/cBvWdGIFqdTT7iGHh8dI9mBP+MDicyxSsuziu8Gwek7RTCAdOScECImo2jfnOxi3zEnL0T4q5jZea6nRdrTFZ0wcqSzt0LJOC4tftVYJC9842W7Wk8dPvl6Ko4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpqBswRmoTBz1yb+1jyhPzKy3jjw5mNq5lnu6kg/TkM=;
 b=V8zFxoGUfCLRaeluwfHTYuLSiCfNpbSIOrOqTEE6tsNraB/mkOGab18YGofX8yHKcmMlR7ZoqLGUty4NHBYK6SD0wHAUwMjiKVNbQ2rLHkPKvUodtZkb5abOd1tqKpfUr7gHVofoMFEfcRgCSk1DB5nA7Fr8Gw1kXuWfm8FSVIZo8bp48SXUv4VmzIDYylXMB0TvXtNhr/PdT9BZPkXegk4G90SW6gOOdpAtNGMYtdeblEW5IxsmB8m9iEJHtA0CTegboJ2lpSnUhPh2qhWrN5fCVfKtDhr2ZsoYGvAk05bw5zdlgSGAQGHEm2thxR5pspWaxtzgIviFhMi8Gffslg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpqBswRmoTBz1yb+1jyhPzKy3jjw5mNq5lnu6kg/TkM=;
 b=ldYqu3cJWTelUlBiDt6s7H1d9GGJ4KDxo4aZaCMgvih1Hrt02rS4NSefF2wQjn82shxs39RG/HuJXCh3o6UnahsiKUhzOwsBfSoIIZq4ATU+VCnt+JglJEWJqb5VFsHIPURh1RRruiZNPas8GsfV7tt1jtJh3Fbs/U8qe9zUEak=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3448.namprd10.prod.outlook.com (2603:10b6:a03:88::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 06:33:36 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::18a:7c1f:bf20:ba6c%3]) with mapi id 15.20.4129.034; Tue, 25 May 2021
 06:33:35 +0000
Subject: Re: [RFC] virtio_scsi: to poll and kick the virtqueue in timeout
 handler
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, joe.jin@oracle.com,
        junxiao.bi@oracle.com, srinivas.eeda@oracle.com
References: <20210523063843.1177-1-dongli.zhang@oracle.com>
 <ac161748-15d2-2962-402e-23abca469623@suse.de>
 <YKupFeOtc6Pr5KS2@stefanha-x1.localdomain>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <a0404035-2ab7-6b9c-f393-0bb0417c4b3d@oracle.com>
Date:   Mon, 24 May 2021 23:33:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <YKupFeOtc6Pr5KS2@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:646:c303:6700:18ee:a622:17a0:6b68]
X-ClientProxiedBy: SJ0PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::13) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700:18ee:a622:17a0:6b68] (2601:646:c303:6700:18ee:a622:17a0:6b68) by SJ0PR03CA0038.namprd03.prod.outlook.com (2603:10b6:a03:33e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Tue, 25 May 2021 06:33:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acf4e2e3-2c6e-4847-ad0b-08d91f47061b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3448647A046CB4FFFDB92298F0259@BYAPR10MB3448.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rOkf0PwIBoBtSpPJ0ilpEGu6P+PX12ftBJAFzb9+B8Ki2xwCaoGL6yshhrstfPE5lsoGBXLShOrkq3u0DC/2iELaf0TsbyXLGc+iyiCxgw+1lCcMf5q7lvPWzwpJygKItaoOK7EOJjTROWYEXQR2Mbqq8akeW5+zYKfbor62joVgdmRqlCApZ7Ka0lzhdIAteYGM1M2m2zzKT0ufbvL6WrVFXGP3xfg98B2TYUffNJF3qdusict0BhTZrsTb3SMB7yq+6+js6s94ZWVsD72I6z/ImUJysoWlm9N1APkqATXh7SLuQgJFGZhQpPCJPCJSAQ39TvqEvsZOQG0Uy3caii1Q0BD8bGIQ1SfpSXRI9OQPEPLwfAjr65PUJTmO6ZV6+cnEz5vS3tvL2mOsv6El/yHspzhLVgZefufXl9X5lQMKDG97w3xBUSdzFXT5N0V8hMJFkDDwEzl/h9RGLWlLnzAuWJAOG1/zG2TgdEIkfleptI2obx2b6YmT5isyA0gG7POlGA+evAQ7S2jblkz9/aUjU2ytEbagMVDjN7Gt8/6Y4zmOsQ0bEvShj2qmgAqZ9AHOAwyc7Dp+/8TlfpY9/Y87aBVERmoeQSEguQnCp462XE609I976JUxEcWtsD+4vQ2MXCIBWNGPWC1Nv1IRH6TwOMKcOYOo4Os4VjGNmPk3YahiRV9RSwuODNNYkMYH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(44832011)(7416002)(2616005)(66556008)(38100700002)(53546011)(66946007)(66476007)(86362001)(8936002)(83380400001)(110136005)(8676002)(107886003)(5660300002)(4326008)(31686004)(2906002)(16526019)(316002)(186003)(6486002)(31696002)(36756003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?OnIE3aOShigdwpy0cC9uNmtqILGgAQ7i4ctGBAkNXG2q5UpJ97xpaauq?=
 =?Windows-1252?Q?Ef45/sTkJD0h93YpGvN4KamZ87D6ZQ/Sd2Wg8BLdmE/42WHRQvw9J6Pr?=
 =?Windows-1252?Q?xbT2b9zyRkU5mKq4Gu3qFSZZVbO4LWoOeRheVvfnL42Rhn6wKHyTMBYY?=
 =?Windows-1252?Q?WhwTqxZ23RKQ9qxvg1UghrFZabxydiCEiJwn3Wm3xzktcjbj995+9Z08?=
 =?Windows-1252?Q?4XHzRgPBAmIIrzVxg46H7pn2fQDw2yH2ecLe4s7Od4nfOSBcKVtkkK2J?=
 =?Windows-1252?Q?McsWBQCdE+0u0jAu9GJY4o17UF5z1fBjJEFevaFWJWWVoW49VFeBdgyw?=
 =?Windows-1252?Q?O/jqlOicBp4Nfz2cAC7EKD9d09LAdpbjGZNb+XJN0pIc/LLnVGQQdRvh?=
 =?Windows-1252?Q?Qd7d3zGYTIk4pbgFq+rrpmhE4UAwjCVM44XuBDGDkq59r2RN9BcX0VHV?=
 =?Windows-1252?Q?D/Mmyy4YI7ygMAqFCkpHVaMK8pEHcSOnfoZ6zPhTocCSXzRhcGG/DYRQ?=
 =?Windows-1252?Q?6M7sTrHOC/WOXC1szgUHbPCSF3SmJ+2epBUcsCKbZ2R9lGt5WzXWZuXy?=
 =?Windows-1252?Q?LQEnnBxjM8ToNMr1JR7AEgOo7dX7fObbbrAJoXpPBXBtxRNhEAaUyjKH?=
 =?Windows-1252?Q?eEETrJAeERvabfnbm5IcpTIdeSIkD2g/NSzxmsOpJvaCY1xzhthMT7lU?=
 =?Windows-1252?Q?lap/ubU3NghWQzfarqDSXtYO2hHYai/ALFtww0EGVO8W+QtiUbFIseBZ?=
 =?Windows-1252?Q?15vujXj+ddikFtTD/tQuilBXe8YZ8Nc546W54PBvF6YIN5U/e2FQojUU?=
 =?Windows-1252?Q?YWFXQZkJn3EQJ1zV9KroW18eaiVWHdLpHWDxbwJKIF2/i+XLu877DAZj?=
 =?Windows-1252?Q?xqPW/e5ACsm67iGL9wtkY2udUHligIv3wf6bOAXC7vuxFzF8Hwpqz79/?=
 =?Windows-1252?Q?OO3Q5ggJXwsDU4JL0hqUJtnLIbRDt1qJWaFYFrmdJF0AZcM0AoL+lNQH?=
 =?Windows-1252?Q?GUlea83oDCSvKxdgRblVF+hqUojMfcgOpiq5N0q7Th7cZr16ByEq/Ls8?=
 =?Windows-1252?Q?0an/Kho719MU8OvuJOOhdSdwUXN6c0vt4qZKpnhwgb13Vp1S05x7dHGN?=
 =?Windows-1252?Q?H4VmBC+MR+opzRrStinMmmiSqOgBIetklHqhrIfDRJjLot9BcYQZArsn?=
 =?Windows-1252?Q?aoTFmJp7u9ivJAKGv+wBdG5TCDL4yH1WpSuyWPmjv5+F4m177TcMxSIJ?=
 =?Windows-1252?Q?QxoeveXNacF9MTQXv/CLa4GVx1vK59mYkPim1xVPg0b/8j5So0rhV+I9?=
 =?Windows-1252?Q?Rt5AqF1ESp5ikslPDSWo0RhhAkeWWgngToTP2Lf2A17Wq3BB0ilnAOql?=
 =?Windows-1252?Q?ktRyWVDAJHYRclIDd1lHEqVN6Nf7gQWsK7VxlqgbhkwhlY13Y1kQK1Uj?=
 =?Windows-1252?Q?Om8BaPGIBA7a7pSPqYG6H5JEW5wHn3ap/v/p6psrnfmlna0osiOFvir4?=
 =?Windows-1252?Q?T4IoJUYI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf4e2e3-2c6e-4847-ad0b-08d91f47061b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 06:33:35.7120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nZA49KYLNmvLMRjDO68zYAHtp+gTBqz2JJiVQgojHJ7VXFqyBpi1FQon2Izi4licCajaNZx5LijSySMe8CfGzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3448
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250045
X-Proofpoint-GUID: 0MW9WyoUiD-fseeOGX88lu-a8XISUoDk
X-Proofpoint-ORIG-GUID: 0MW9WyoUiD-fseeOGX88lu-a8XISUoDk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250045
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stefan and Hannes,

On 5/24/21 6:24 AM, Stefan Hajnoczi wrote:
> On Sun, May 23, 2021 at 09:39:51AM +0200, Hannes Reinecke wrote:
>> On 5/23/21 8:38 AM, Dongli Zhang wrote:
>>> This RFC is to trigger the discussion about to poll and kick the
>>> virtqueue on purpose in virtio-scsi timeout handler.
>>>
>>> The virtio-scsi relies on the virtio vring shared between VM and host.
>>> The VM side produces requests to vring and kicks the virtqueue, while the
>>> host side produces responses to vring and interrupts the VM side.
>>>
>>> By default the virtio-scsi handler depends on the host timeout handler
>>> by BLK_EH_RESET_TIMER to give host a chance to perform EH.
>>>
>>> However, this is not helpful for the case that the responses are available
>>> on vring but the notification from host to VM is lost.
>>>
>> How can this happen?
>> If responses are lost the communication between VM and host is broken, and
>> we should rather reset the virtio rings themselves.
> 
> I agree. In principle it's fine to poll the virtqueue at any time, but I
> don't understand the failure scenario here. It's not clear to me why the
> device-to-driver vq notification could be lost.
> 

One example is the CPU hotplug issue before the commit bf0beec0607d ("blk-mq:
drain I/O when all CPUs in a hctx are offline") was available. The issue is
equivalent to loss of interrupt. Without the CPU hotplug fix, while NVMe driver
relies on the timeout handler to complete inflight IO requests, the PV
virtio-scsi may hang permanently.

In addition, as the virtio/vhost/QEMU are complex software, we are not able to
guarantee there is no further lost of interrupt/kick issue in the future. It is
really painful if we encounter such issue in production environment.


About to reset vring, if this is just due to loss of interrupt, I do not think
it is necessary to reset the entire vring. To poll the vring should be enough.
The NVMe PCI does the same by assuming there may be loss of interrupt.

Once there is request timeout, the NVMe PCI driver first polls the ring buffer
and confirm if the request is completed, instead of reset/abort immediately.


1254 static enum blk_eh_timer_return nvme_timeout(struct request *req, bool
reserved)
... ...
1280         /*
1281          * Did we miss an interrupt?
1282          */
1283         if (test_bit(NVMEQ_POLLED, &nvmeq->flags))
1284                 nvme_poll(req->mq_hctx);
1285         else
1286                 nvme_poll_irqdisable(nvmeq);
1287
1288         if (blk_mq_request_completed(req)) {
1289                 dev_warn(dev->ctrl.device,
1290                          "I/O %d QID %d timeout, completion polled\n",
1291                          req->tag, nvmeq->qid);
1292                 return BLK_EH_DONE;
1293         }


Thank you very much!

Dongli Zhang
