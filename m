Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F65C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 01:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbiAEBzl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Jan 2022 20:55:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41054 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236992AbiAEBzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2022 20:55:41 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204NiKAq008803;
        Wed, 5 Jan 2022 01:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=60rwnoqf6EmkZNSJzyxHHasAVn6U9O4bwwsqlTVhv+s=;
 b=gcSnLDa8MBYzBa9ndYgsScRATADEjqeHaS5UjuRlT46GGq79ppfV6pUfggwbi0hoAqt+
 y5H6iRHA5qSHtZ+1WE2JFr6znlUsrczA8RllXxT+jWtL4NoIfv/27fzzD+jK0JlxntJw
 rZ8Ispy9wgbKvp4JUug1mCecYMpd4ROa2RHnuBXhVmNvLgy8utoCVOgJeBeJOK75/hWW
 tXKjZkYNpwXI8kHPUZ1fLm88TFtG0WVINQPLw9KKcrfNaouV/UyDzYfWNDrU2Xf+ZivC
 z2Eu4p5M8HI58pvaEh32DF+ITvrfMd3888Te/sGqUdm0g7TmLg7vZKtpTB0D4YsFWoIg YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc3v4kq8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 01:55:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2051pchk175731;
        Wed, 5 Jan 2022 01:55:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 3daes4g4yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 01:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONCkx61SkFGFyuq/buQuSQCEZXuxpIJ+jue7YyNVL3Mrrpk3YPm8KMGlsyw28MBrP9s+YYUFvOVRCuVxFUcNg//zc3NZ8r31/9AcKzaGwB5zpGM/wilxrG8Q7PnVMdQMn0rsrWi2d2QA5vfexGdXGFyPgZykQxVZ5pURflck6ZkaTlwqPC9BloymzJhgYnNEaSQSXyx+2uhHSgULnA80w8B2JhS33vqLUP6F3tJB9FsYrnwoOa6b540odXQVOCSICb0ESvh8At5gDai8dJPlrmJ3h0bzpeiXhNbN4KelppeST9ghjY1X1xHhkIrW84AXpItDHBmShGv/dmJaclhdTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60rwnoqf6EmkZNSJzyxHHasAVn6U9O4bwwsqlTVhv+s=;
 b=TQIV2CLAB9mnGVCfhqfDfXSxVTT0u62P/FkP/69pZ+XeJt8G9qnT19RzAOAm/tmFHU3krS7Ykznj1oU5gvFeIdCP2wr/6wQGKgmeO+qysYKC4rm4L5u6t8aXSCya8VGtjxe6Kh8DL+Qbhexe5jLraUdpczvmx1/h/yFe5rPKTcxWizp+bpVPqkYn1XJDkRdm6NaOc8AmDAcgENCnE2Rdx0q/QVotKWKLzDSFROttvb8W/RPR9y9HREKDaBCnbYzJcIUYTjKMeWPYwMUFXqxodUUdQ8nOo8QLMsWlFk0/iQjs5mpYgcsNK2HNNO4+n1kz3oAFlmoPgc4kudP2Af6g0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60rwnoqf6EmkZNSJzyxHHasAVn6U9O4bwwsqlTVhv+s=;
 b=Ewh4rVM2cv/92ZZF3dgtxlzOjp3e3iK0OUvpn4lLAH/QUXvVJeNWFDjcRCKdkaJOKXyxo8rze5ua/OAP7JZY6SN9f4FPnq9K+ZNZj164CGu2ZeyYwHpj1NFBUEj9IefBXUi1hoGhctWVVBfjKfmrZHeO2MWycgj64QIRRh4+mQ8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Wed, 5 Jan
 2022 01:55:31 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 01:55:31 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Topic: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Index: AQHX+JT7FAEaXZI6BkCL9hReofoy6qxQgZ+AgAA44QCAAiJ+AIAA4HoA
Date:   Wed, 5 Jan 2022 01:55:31 +0000
Message-ID: <B4E26038-022C-4495-9043-055D12BA34F6@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-3-njavali@marvell.com>
 <02990604-CC38-42ED-B3D6-11CCA0C5D43E@oracle.com>
 <DM6PR18MB30347380BBCF7EAF7EDA92C1D2499@DM6PR18MB3034.namprd18.prod.outlook.com>
 <20220104123204.tkfn5jfknhns67i3@carbon.lan>
In-Reply-To: <20220104123204.tkfn5jfknhns67i3@carbon.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8afd0e82-0dce-4c5e-1f0e-08d9cfee7485
x-ms-traffictypediagnostic: SA2PR10MB4682:EE_
x-microsoft-antispam-prvs: <SA2PR10MB468270B222F6557D5ACC8CB2E64B9@SA2PR10MB4682.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /r6itagyRb3MkicBYaEteBR76rR9RVi+hQWXPYT45iuLc37BlP0DREnLRmnvBnUJggKvc3CKkBA5lu4esFCCENG9BixCyLMns+gBHBfM1VHWLwial3b95IKckUG4m7BdgB33aOhQhSO/bHE5ArIuzY16U3kOzYaEnzA2T2d0iOkM9wh+UeT/4YeHI9s/l5MLXdRVy7Mk702LpeLGGT+6k+fv3ijj3BTveZgySUvHU2EOg5BA19XoMLqhNt+3V9MKTlzD2Kb7WbWnufHMw5G5uGuh+18FyJCIVFH3s//xTCK1ZL3zMwZivYHs+YMKdyivyfFwLunjcJoiHI0rDssjz69B+SbzISTw++paSbZDLRo62dttF7EPt9ZqVFK+yESzKdrUw4g1DSZbqGA7D/LOLfGqwW+oFCNwewCaBvqz5xw9irYOk7HZFNQXfA81nA1WOqvG60tqXW2sR21hVJHkxigpI+lFZLNBLHZLhmt89CH3bQWJUgwkMm9SWnQc4PDsjNe8k4X+REFjls3yqFtjI8hQNy0feQGVfE6sca9VllT9Gh53SsynP1l7qgVOAgLQGxFPWCkNYLldLCB7NZHGE4eqCEzqrMMPr5bLY6TSeh2BPRpbDvx/eJU6QKe7ot3boyvD65a+vvfKRhbL8KCwZJwRd55te4mZGZpwESM6TTkw1a7jp9lS8wQIII2PphL09+p4h6l+NuxQP1WBwtgcNCeY41u0xtsrNbhedil/2qvSZVxU/YfKWoQGjmI3mVdpf8wYG1QlDQOnxZkh227AmDD43v+ZGRC/X+JT1Wrj6P8XwbrObFokvSKoSNUQa1jIgfgIvLqRMoBuH4fkIboBDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(5660300002)(33656002)(66556008)(53546011)(44832011)(6512007)(8676002)(2616005)(508600001)(6506007)(91956017)(76116006)(38100700002)(64756008)(186003)(2906002)(4744005)(66476007)(38070700005)(966005)(66446008)(86362001)(122000001)(316002)(71200400001)(66946007)(8936002)(26005)(54906003)(6486002)(6916009)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mun2Xcx7olVU2zvrTJ1eiKpsEclofBLg20o9+RUPTX+xh90lKEhkRTzemSsI?=
 =?us-ascii?Q?YHCj7a5/MESa4oKRDtqAmuX82OtZgeG3fpISTbrXFefGYTwar8qcsCGJBMRQ?=
 =?us-ascii?Q?wLQnQF7aR7xr3S2EXF+wmHThZthoQQSA2P/IP8s4T98WTaQZnZiMRTF+xHU3?=
 =?us-ascii?Q?5OOYj7xrrH1DV5mX85CPm8BxxEPq+JJLi+kH6r2npdiZ8AEpPZjU6nrgQ0/N?=
 =?us-ascii?Q?ITReKddZJzD5Nw1E119yUo/gV4gwMs7IyjLm7zvXEVs06rR1ijqM7+anePQH?=
 =?us-ascii?Q?ByvNxzf6shrvrEubsYCQcPvyLNuDuk37jegMRgPNJpfhswrxrfHsj3PXvUHm?=
 =?us-ascii?Q?4/XZfIjTrxLgaSNXI3UdficTFc2e+GUkX6rcijcYW95MI7ZnwD0XB+wuxDPN?=
 =?us-ascii?Q?1BSjm1LdKDgjDDaa49KBLthaMHNv8uT9iteXGRKyMJe9vAwKPrqY3nyz3U9U?=
 =?us-ascii?Q?wpSoauaLlzyuH7wrSkJSuuaiEyp44N+DLEcwWCFIEBPGNnlzr1n5cJv6TaUH?=
 =?us-ascii?Q?Pxb6Q22iQYrMVWksS+/LEAl1t5dkLlKFt3mQByW/wU9OCukCgQFL0c5i0ynq?=
 =?us-ascii?Q?LsQvu9QjJrh8myvkU4+ULUG3FjS6ll+lXdomBf6SOWqsW0cPqQAEhsBj0V7i?=
 =?us-ascii?Q?ElbNG3z4LfCl/PtdQNjsZoibCyq9ch13Q2ocCMexvFJOwEnE7NIVLsd6crco?=
 =?us-ascii?Q?4Ot6X2x7P5P8PKaOJ452JcXkt+JwfBEpfC8ygqZgxomYDaq7UwPlobvKVQWJ?=
 =?us-ascii?Q?hmro0BEqtGnIm3WI2JKOAk70YFGgR9BCbDsAHizEJG0g6m84gf9eA5n9ag7Z?=
 =?us-ascii?Q?2Q33XLbPWd9tTVx84Sr+EFKHsSfRp3EqB/WNNjkDR7j4c8xGrOqUUcPqoqFP?=
 =?us-ascii?Q?hN7sj3ChQEZXy1FKTqCgaY/rtmqYKmt1YZmWVINCq/0/g3Y7hq2C7UoUrkxb?=
 =?us-ascii?Q?7SuBtPJJHEuPGJkT3JWqA4wIewpQTI8EjJssJg+VpRrjQOXBLJnhZ1h8Z7H5?=
 =?us-ascii?Q?rptJPhUV93faauInsoOLyqNlRywUSvIeyjsvzySz36Kx2AF2FDIWl2dNPqXQ?=
 =?us-ascii?Q?xAVYCzEpGtShWDiVAb0E2hHD9I7nVj/MflfSOSvnbL+2uLEvy9csB7IZmDxF?=
 =?us-ascii?Q?6KyEZ4ObuI8+4VrEuf0mXzZ2ULDqdprclAcSeb3G7ALephqkpNNEEW8XMjDJ?=
 =?us-ascii?Q?sHV/OFUrcV2RJFWOsayWpWUCyj/TJgM4fn1Su4N0EJA/vCVbEI645YYLToUO?=
 =?us-ascii?Q?Ek9DHCwi1zMIMVCaAaQahLQ2qxr/VlWKV/Z34JI431lvbxXQsvL5Ix2VxkqL?=
 =?us-ascii?Q?1ZzLkb7Fn/xkpCSWi2C3mKrW1U06bp4LH84M9ibaTIR29hIC7FpJmYPm8JKM?=
 =?us-ascii?Q?WemrhIdL0SL+GVS5RuCkmes0iln7OIKf1AYqvWM0viGu1bnuDgQxsWh1+yW0?=
 =?us-ascii?Q?qpVZWeuP600CE/dI1nwBMwayTnSotgClZXIHimPYzANrppQ78xNFHFG+Id9o?=
 =?us-ascii?Q?mPGUs7dxUCQ/ZxCOrR5QpjTnrEcyNGGCK+YLcjwtpQNZda8dEK172+S9I+JN?=
 =?us-ascii?Q?0LjEk+zYgBEy67VY4aUJFvA+HUct4Fv8wdHsKPmcL/6WIfe00KpR6JYPL5Ye?=
 =?us-ascii?Q?cc83AugKDc2QFrTfUv6q/P4+Dh7tmyxuVI4clZAdNSFCHFW2Up+y/h7Lh7Vg?=
 =?us-ascii?Q?z1Jn5dlG4jzUtOrmZmxZkWpbBkM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0786F2F52660643B61DF19EA9CACE1A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afd0e82-0dce-4c5e-1f0e-08d9cfee7485
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 01:55:31.2589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L4KP/yX2F5iJgz37Invtmk77QKCsaCHGkxpZJPn6cLw5/rpmrgqPJcAntk7JM04gXVuZDbkg5iKKUUiFuBKzkYcKu+yHSvDWmqZrlxWkMpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=894 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050010
X-Proofpoint-GUID: u8a4u6156OvOZuW2pvz26tfnbZRd0aXS
X-Proofpoint-ORIG-GUID: u8a4u6156OvOZuW2pvz26tfnbZRd0aXS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 4, 2022, at 4:32 AM, Daniel Wagner <dwagner@suse.de> wrote:
>=20
> On Mon, Jan 03, 2022 at 03:56:06AM +0000, Saurav Kashyap wrote:
>>>> -	sp->free(sp);
>>>> +	/* ref: INIT */
>>>=20
>>> IMO, There is no need for this comment spread in this patch. Please exp=
lain If
>>> you think there is need for comment.
>>=20
>> <SK> Thanks for the review. The sp reference can be taken and released o=
n various paths. These comments make=20
>> life simpler during some ref issue and also make code more understandabl=
e. For various scenarios, this comments
>> helps in determining final reference count and check if its released pro=
perly or not.
>=20
> I think the better way to address is to get Sebastian's patch working:
>=20
> https://lore.kernel.org/all/20131103193308.GA20998@linutronix.de/
>=20
> Daniel

This patch would be good to get it working for debugging reference counter.=
 However, for the current series, I am okay with this patch if better=20
description is provided for the comment.

--
Himanshu Madhani	 Oracle Linux Engineering

