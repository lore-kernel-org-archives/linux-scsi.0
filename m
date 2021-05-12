Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F77C43618
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 16:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D2861E2B
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 16:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbhELQDM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 12:03:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbhELPr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 11:47:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CFipVM172540;
        Wed, 12 May 2021 15:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=A85HW3Huit23m1ITqx+OzYGkKDxeAy80mDBq0L2AqFQ=;
 b=daq+6XjLlDTA8mhxs0JdLyKsxYAWKQykEMxUor91z29RFdLSg7jcECMUJ/NFoJY3fc+Q
 0X8V/b4VsSxUJuE5ITuqi+xGNqLmrOXAXJTaWxMk/1pu7naiMeU0U/y27w7b3an3B7Ig
 VVhehCxXvi0+FxQwPD6gFJKbuUABuDYQMtAzhgBZL1YGFgVT/NT27AHejZ83xlOPe6pu
 pR4NWpsHcX/LtinaSh7hfNKcNXoKzfOB9Zjhqjo9U+UKjIlrL7K3QS2MFz/vqEZ1zrI6
 wjQm+7yLuhWfn3I97pi4DBvv1omszq3tRb/XoDFMjYdudvQisuhXx8e2KvTiOjyzsf7r dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38djkmjfg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 15:45:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CFK3MM023529;
        Wed, 12 May 2021 15:45:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 38fh3ycxf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 15:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+2DWv3bQOK5tGShDutemmfbwahXLgzoaYRPCkIIoCOoSegyTR+J7QpBIuyclrWz6QRk1A0/b9sPQyuUBm+t4EGOwpoYxnpsMkqUCMXTXDiNsDESZRCpelNiUX/hUungZ1cY7ZnFdbbZZM8353jxiYDou8Q7RTmPRUTts2gTD6VTlCqpyJsy0fb0sPDOJ8ypRWxpfBxN7WRtXu+XMu1k/QZzc4DmDptDUEtOm6N8PtsdvjVZ28uH6GobT9yfeeQKHHWaENWiztlj3V19H0SYoHshX9g/4gh2HOZk89kDTzGwJWn0XZL2LHe7Eq1sHWa1wNZiHox+ayr1o5muMX1WRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A85HW3Huit23m1ITqx+OzYGkKDxeAy80mDBq0L2AqFQ=;
 b=LscOAm7efoSFhEWykysm/erlj8QS7peokPefOdVkrYPvHuWy2WNmQzYCUsO32e56oXH0IOhCtctKoPoGJMrx8U9DLuhcQDWOXpaCgp9dbb39WiRtj9P3e4yByiZp3EwJ+sU0wdm2fpl7RFxg5XzaDZKtxYBdHBpXFQi1hnEDSp52mmDpdEDNV0d5u7VVxFSzHa4EzuDOon3ylGLa4scgRBrs8iT4RZtrvPkByfI4VCaYzdABF0mTGj0RmCf7ZUhKfGRB9OFr6jBxiM34QWfLat+BXLWWI5SSYRw0MVx9nKVuo1z6YKmThgG8sXtRC0zYLNMQl7ka181e0BbFqx/QvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A85HW3Huit23m1ITqx+OzYGkKDxeAy80mDBq0L2AqFQ=;
 b=BYPJFjpfMsnUThsXmLcbEaqYFtM0uzqoxNxa8TSza6xVdmBDcNmsTTVki65Q4/t12aSMqF7YKNkIsjhRxt9njiHdagrNVlkoVTuWForTPeoDmA7JYWZFvB8/LsWI1jo2gfFaxZ1Ymzflmd4iku8+BG7+789M1UXiaA53K1G3txI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Wed, 12 May
 2021 15:45:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 15:45:36 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Martin Petersen <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaKrf/70A
Date:   Wed, 12 May 2021 15:45:36 +0000
Message-ID: <E391FC6C-9D66-4ACB-B2B4-DA971119361F@oracle.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.6)
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0eeb3c67-0a20-4b34-8683-08d9155cfcac
x-ms-traffictypediagnostic: SN6PR10MB2701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB27015CC6ACA81A68758C55E4E6529@SN6PR10MB2701.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TUo2pFe290LAuClbz8hADKrbdtUg9k/xCIzQmwdsiFZpwq/8D0KXs4e2Z+cjxWxujciqOlWe9HXiamCF/6JuyEku2MHP48kYfgoa9H6QxVEMYQN7YcgArhHT6PrHRgd0TcrPoCF84nO3e8rGGJqjeeWaGnMO2rzf0Xtpb3mXtCSS31OiqtEtqpDxhS9vF7IzOu+rE/y6+GvqWF1yowuVX9m7f5uNqaojtI9rUejs/PwOqZV5BSLYNDG3hswF0Svxc8VqKDAHaId4/Gj7N5UAL1ljFXI05SV7gvz8BlDIodRUIL2oglG//vQdMfs6jtwIrUyQd5zQwgRH3zUjAQ1wU5pVSvsv7+ihZIyWEFN2cA2rNiuw8+atvVhHMXV+fZTccF5tbsbJf/SA8jKQkKzAn8IQlO+D7DXQvIYlDK+SDZxcEM154t3N7CS57bO7AXcVUf3oLiwoJr9uME7rT9k7ytdOhNAaieUKAunzFDD3q3RW+llTMwQoCRAIlmB6ctmwATt0ORD+QP1n2n3TNkFSM49tVaMK9nb067RPgzJk9gZ9vm/zfbIC8yXOYJols8yJjyjOjfFLkBZ4UQjkxItFGdsDy+vMa1ZCUEHeoF1alJ/KgBrDke4m5O1K+MbzYYcm/QaRz2P5/GIo8jUUCkuRsK8s3ooMgJrU1zmnFdLHrDY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(136003)(396003)(346002)(6512007)(8936002)(44832011)(4744005)(186003)(86362001)(4326008)(33656002)(6486002)(478600001)(316002)(26005)(76116006)(71200400001)(36756003)(66446008)(66556008)(66946007)(6916009)(64756008)(66476007)(7416002)(54906003)(6506007)(2616005)(8676002)(38100700002)(83380400001)(122000001)(5660300002)(2906002)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dGVS2hXk5lpdYOTSii6aGApeMWuCDn7YJ3gonqRGzbc481lxHyFaN7sLO898?=
 =?us-ascii?Q?O/HdeLmb9G5Mq73CUhtOGSV5d8qFyi20UlcDwsc+BTQH1x6L25KkAzuQGxnF?=
 =?us-ascii?Q?ihBGk2On1aMul3QuBdyV5pA0uPg01klDOKbOY2OSLKqC/O4QsXrdT8iEnt2b?=
 =?us-ascii?Q?Rih8dqKF/Et88Uu6fZicz9vOMNT934rLav9LmSeJrOSiOrHzquUUcLDV80ku?=
 =?us-ascii?Q?ofaNT3idQPYfix0kgu+vQ/bf73285lBX/GF6g+QWnUL4eCMOz/Jfr+YvNCo+?=
 =?us-ascii?Q?BjvV6XkITLi4H8Q5ixtUH24AZCcZ7XLU5+nVqKWd9+B7tzBo631BGW9wuWdr?=
 =?us-ascii?Q?s1EEfcgqYGBBbHlFYQQKyLj41aV44A1yvHc6F41o3r3EIZPlHqaZpdIX1LOf?=
 =?us-ascii?Q?x/UAWulV4I+E0q7dIRu84leu8pNp14KK2OYowY5OB9461MAuDTcxwBFuXvwG?=
 =?us-ascii?Q?2pdIRmxpNw4Bpt2uQKqZUu8Zuh5qjIrn/gZ/x6zcMJDgkVgN/CgCS4eWbmwp?=
 =?us-ascii?Q?6y/7+dekGJFn8LdjOB9NUw5LbE01RXX9Knd9QF3XUzd62Dr1EUhQEoZ9KH7m?=
 =?us-ascii?Q?Z73wXDVQGPbA7gCI9sHXjLwDnQ3aEMz0F9EtntDflPefxg0SLKUJEHmd8E9g?=
 =?us-ascii?Q?kjYia8+XttZlyB2WMo4Z1TqdLkwG9Ppn9aOXAGLAb/uqzF2qAugEvLrOJHpt?=
 =?us-ascii?Q?hvzDOyFmP9gOoyrOaBkHfKzn3oKIcg1LB90OwyP8MDhgIK4eawMmZ6VIxcUB?=
 =?us-ascii?Q?aas6qUZFp4RwXf1scR0U62a9s3sErXs2WeqTNEGKYPro2bFAibMvHm+ec8bD?=
 =?us-ascii?Q?B3A8sGimVdgjWOMddlUKnlwho30jFzeK/DIYv0IKx9D5gTZYT7Ygb7uTP1M/?=
 =?us-ascii?Q?RUHI8cV1FysfLuOg6qiffovuO9MjuslKHYr1Jo+MK2telLkYuVOhlkWS89As?=
 =?us-ascii?Q?d/5r/TeYe/u9f1mpfU8RKFmO1oDiTME355FuuEex82wb4cq8Mq/CpJmqrDpe?=
 =?us-ascii?Q?0hfoIbbRtrbHnrwDIZZrBtbtULJcBbzyrvkpVGC+y9DUqvOtHnk713NaXbmx?=
 =?us-ascii?Q?TksKc/gWmi50wPOFA7+guGn3VMm+oC4lEdb6K9K1MvoY9WPLKHCDBnWW1bGW?=
 =?us-ascii?Q?3n1YQfI4buCM+kXPTYurq/5msLGMnwL9odiu+fajSZJ+8R+aw1NHrtXtBopD?=
 =?us-ascii?Q?s84/tS/E/nfv5+wuW3Hi06z17jaDL7NqVjpUu4T5R3XD9z2oiw2rc+1jXlY5?=
 =?us-ascii?Q?wTuVo/3nFbvspvSVIBZReFc6EDAiREINuSivYx7Wcl80/wEI0d4WnK15YkZI?=
 =?us-ascii?Q?ss2QypU3E6I6bAay+86EbGLeuWsr9f76UmOvtm1rDPidqQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <374027C562B81342B371D744112E46B5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eeb3c67-0a20-4b34-8683-08d9155cfcac
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 15:45:36.8626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FERJgYXCcTUDa539VBNJJESEu86oRmY91r9Ysaa3cR2eIeESrJ2I95stffes00L3sPUmU3sTUn6+m/hyD12yXO3r0QrqTX3137u1kEWA4Fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120099
X-Proofpoint-GUID: 4tjWTxXamwRKozFW_HifdJWYuAXGU0ed
X-Proofpoint-ORIG-GUID: 4tjWTxXamwRKozFW_HifdJWYuAXGU0ed
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 10, 2021, at 7:15 PM, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.c=
om> wrote:
>=20
> * Background :-
> -----------------------------------------------------------------------
>=20
> Copy offload is a feature that allows file-systems or storage devices
> to be instructed to copy files/logical blocks without requiring
> involvement of the local CPU.

I would like to participate in this discussion as well.=20

--
Himanshu Madhani	 Oracle Linux Engineering

