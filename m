Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A411C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 16:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A12F613EE
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 16:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbhDUQ1w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 12:27:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37632 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240643AbhDUQ1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 12:27:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LGDqL1028722;
        Wed, 21 Apr 2021 16:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JuNg72zI2DCkx/JtOql55ZYA9p2Ys05PKpWf7X2Q4rg=;
 b=DSWsQ/pM53inmYa7BAba5K7hJ2Nc8r7jeaDXpURxyI4ChLGVOKrOJAdH85iCif5bTTu/
 yKTOV2/Sxd6s+8WR7BYXD7HM6cO2/R1WxyVZwf1OAA2t3NE9XXznEZ/d9BRH3RRmYLda
 5gxyykLLy7+aJPiMf7f+Ew9Jo4hDxnk7xj3zM1SyW6UV5E8uDQ49YjiiZBDTbhtjRLZu
 p1On2L81IhvED32Nu3vFOzCiORnTbvkDtdTZVsdFqFFpRXwLsH2DFyPK+9eP2rsvIPtu
 Xcny6PQ6pdEZestSlpWr2j7yedRjbQyd4wRQ5l3D4uxAUyvx5DJ7bxZkgj1jECFkQ+wV /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37yn6caxx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 16:27:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LGGBrP155121;
        Wed, 21 Apr 2021 16:27:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 3809k25kdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 16:27:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKantBA/yITO+FCC/yLbiIj5ip3RyvLQ14MY+ai7mLOI1wzMwYgagMS/h213jTBrYoUIYRvZCmCcSIKXpDieST2rGxOluL03sfOeT4s4e5Osl2cGEHN+AwIIJCO0IexqwVBBDBJHxlhYca8vMpmQmD7aqckv55OlN92N1ccRKpwtyP61omoh9twZWYPtmttY8jpUST/sCJ0qZajqKAkCuLEcxIFnH6rqLkPTQFsST+/M63hz65iiXi2HQR0rrkXKSKAhcDDuGRlUPZBeFDPyZEJqw/6GERJ2vRsv4pzoQ5LxADbqgSizV36hKsaR6/8V2p6bGEnczqwgdt2sFWzuVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuNg72zI2DCkx/JtOql55ZYA9p2Ys05PKpWf7X2Q4rg=;
 b=Lip+vSWAE5kwDMWnZy/KddF4Mrg3KF5eGLR6CEYP7wuJibidBzO/FeJnmeOIB6jhZxfcJsuMsVXwH/qSNKVQyntBrHRRxXC6R7lIRrLzCz9hedg/th4zI1CYOI3fEDRwRGMyP2TieMH3w8bONv3WiFKajxrPv6Gv+C6i9FOSFhFP6ZKI1nNjki6t5+W3fGiww55oy8modJeo5z012fcjlo/uDd+qo2PV4PV2Bdofw+W91KNRw37vnyEoGRlCOjkOs7XZ65MIAxIIvPXXjg8shB+fPzavKCtr7F9lsBwhmStKbtAsayHrG9MGR2ZstzpPTHb4/DUc7VJ7jb1ExfU/yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuNg72zI2DCkx/JtOql55ZYA9p2Ys05PKpWf7X2Q4rg=;
 b=lqYm9IkIzpSLKYK4clV30UvJYFFvnIbYc+hopRtCQOtmAKNNTKMo43jX28LNBKxKo4IkSMDGw8xpcpf6B879R5kJseW1XsxvqmpfarupoGO9VwuIAEEA3yip4X5j8kt4naZMXVMWVCHKl35sl/OiIAhLkF16iVRJc5mxbMH5LjM=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 16:27:03 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 16:27:03 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bruce Fields <bfields@fieldses.org>
Subject: Re: [PATCH 075/117] nfsd: Convert to the scsi_status union
Thread-Topic: [PATCH 075/117] nfsd: Convert to the scsi_status union
Thread-Index: AQHXNXo2BUl5yYjJDkWhk4L177onwqq9eg2AgAAj6YCAAWq1AIAAHoMAgAAELwA=
Date:   Wed, 21 Apr 2021 16:27:03 +0000
Message-ID: <53F490DF-785D-401F-B0E9-D5F0E07BB17C@oracle.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-76-bvanassche@acm.org>
 <67BD8DEF-7C29-458A-9135-6602192594D4@oracle.com>
 <8775e8c9-49cf-c3eb-0933-8029494f2ff8@acm.org>
 <5F9582A8-3E5A-4810-9579-51D2BD3A8B83@oracle.com>
 <ff1f2108-3743-ba0d-9d35-65e360cc144a@acm.org>
In-Reply-To: <ff1f2108-3743-ba0d-9d35-65e360cc144a@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 002f1164-5613-4dae-db6f-08d904e24c12
x-ms-traffictypediagnostic: BY5PR10MB4036:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR10MB40366FE90CB5F503234CDCAB93479@BY5PR10MB4036.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 285LcWTcf+s5OE+cSum/tioUf8IGerq7/cQLG5acxriDNVFhQZO1OZCiCwg/33kwLh8xKCrZ5hvU4aW7c8RVPKUnijDStKqAkOXDTpLGVBEOdXd1gulCbPC1gcXqibeVcJ8Cj9qyQq46+rPwHOKzez7otej8yPyqYSnKqbPF91lX8C+A9pXljD0tWie6QQx8q+AafoZzYL3YJaKnpYCOtTuNmIpUgFGf4kjaFDgPpH6Pd/360/OiNSA3BmFX7iYtjxrz7OjvOiERsamjdenbt9IBKlFxl/YM8dPvoqCl2LCepojvcf8YZ/e2IQiuHLZULVwb6u2OPBHEF5LyGE2J3HxluhzfG1Tw68XF3WYMBeCRg4VhbUodYE4cYWc9ltgVS7RqjPal3DuKadlChxeIXSiGzxMXCU7sBB07R+FOfO6Zy5i/S7GrITnEHyeiTGVtyVOxNSvnTYw924OBnf3iIRVrNrQpzk1Q6jICtCj98If3LLXKd76s8BSwmDZR//evWoTQ9x7S5qjK24UBm673hfZV3BHjc+t27cyIppTVb7FGncoR7i42jXeoxkbhvf2368FQVMBNbYLr+OHt4sx2O0Jzn6Z+V1bGQ5IZ6TML8jdT0bjvEnlPEzisfvnbYrhWHIEurnYEbKrQpV0QrPkp6z0Zn8Y3uJK/U/BC8sl67lo/sc7ZybhENYxxUdnExSY3jrS1TRdxaYr4/KYSgWb8cjheqkky1Ok3n1cqnEGiEwJMvz4tmISscAz83L48QXtV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(6512007)(122000001)(6486002)(71200400001)(86362001)(478600001)(66446008)(76116006)(83380400001)(4326008)(6506007)(53546011)(966005)(6916009)(91956017)(66946007)(66556008)(26005)(2616005)(36756003)(64756008)(66476007)(33656002)(186003)(54906003)(38100700002)(2906002)(5660300002)(316002)(8676002)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7xgrKMg4VyjiZlceyfgy7XYQsIbCXXghVv/w62jGVwiMrisMDLu/ERSSdJ63?=
 =?us-ascii?Q?9vGkDX3L0Gy/aE7lmAI5smBR5mmO9I405Pa+x6QdfdNRwc6hH58V7Elor9tx?=
 =?us-ascii?Q?5XYF40cfWKdBZ22+cst3KFa5yaj58lmILvD3kBu/nFCElzEb9bL5nFBjBkSz?=
 =?us-ascii?Q?w4ZBwkyXCPPDCPJImsm20mNzobCmsMnETO/TEdYoCTvqN3fmYe6MKrs0AT97?=
 =?us-ascii?Q?fv7dAXaHx49nEGSmLnpGD5Z6974X2rpbuB9mSNHmZHFUiS05a6nfRnU3+RrK?=
 =?us-ascii?Q?H+hTwXJo63MO3+Yyh5h7gsij0JN4blMpBBF0DIR3x+Tq4BNNHWgtI1t+SukL?=
 =?us-ascii?Q?vFycpUTW0Bjtfsc7p5GcHjQXJXnjGblq9z5ZASUNY8fGgYgZFDBdSWv0bvZp?=
 =?us-ascii?Q?MHx1guAvVHyw0SQsUleU/ayjr+hrYn72I+yhiJ+eWiCEZSBRSPorfNVvpl5l?=
 =?us-ascii?Q?FF1WKYXfBTWDMwzvFZ0zt5Vj1/DWWW5iWXT2cpH8JYwHHN5fY+2Y7rlupGFj?=
 =?us-ascii?Q?Jg7XFRMzlxPzHY38m/IgO6cVrt95vUIbQX/X2UCTQKg58hqTbXiVEbcJfwJE?=
 =?us-ascii?Q?6e6eVFMSV8pueNuaCqzTzCIS629pvJdyzYz4bZWSTX6CO52XNoNbLQAskN3N?=
 =?us-ascii?Q?cSXmoL9ZcEtfs12CyG9bB1Kjo94z5Iir5vm707jUP0zMT+NLYvMe3bFXp8la?=
 =?us-ascii?Q?snhaGoD2QfSkKP8HEjwagDQ1FjpZCVhJu+TcDw+02X6hXnA2yscT2vzlr7Vo?=
 =?us-ascii?Q?Zq1B2A9AAczp233BOxcpqau2mY/pCD5HAEC0MOK59saggEQbLrNlllJn12Qb?=
 =?us-ascii?Q?7JKgTV5zWZ8AVAaaCpiNw9JKkBN1kct8LFqCPK6PNIXg4Ypm5swJWwWpmse8?=
 =?us-ascii?Q?YdBQPswiH6/7Q9SD7qCebAWVpaqBZbqbx2/fCT/eB8stiTkxCbWncazPP710?=
 =?us-ascii?Q?RHhAV1XiwIO6jCwsTpacX/H8KfBtJ3NwHzRRZVWitIu52cgHdKH3/Im0E7tY?=
 =?us-ascii?Q?Ym4XiZ6x8YkC7zPiBflc3dF+rn0mazr6iGg0GGPbBc47sfx5Drv5X+m9YLEf?=
 =?us-ascii?Q?TeVyRSXW25Uyjqo/4YrKIGEJaVPwEN/4W8fjdltQ49hf6uf04fiSuh2Jt2Wf?=
 =?us-ascii?Q?l3azCMKQyH7u7nGIWZbF1Au+lwituvviShCHON6LuZGxHamfrktrmEpBT5h6?=
 =?us-ascii?Q?J6XrU74agSA79ZiHiqFeQhM9V74utt73wXWJua4fco6RtYHKua0WSJCwriV5?=
 =?us-ascii?Q?zK+wYM1eFAc88e8744KTOe6stwY/+uX9KgLx6+3gVmZ6yco4u6TpxYWfGrlt?=
 =?us-ascii?Q?xVfCCmHrnOJAx5aDTjK7wO/8ZqDT4No3URgJ3GifdS7PfA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3CB3042A5A9550449C14F680163C59E2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002f1164-5613-4dae-db6f-08d904e24c12
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 16:27:03.4024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: utOeNmSxvuOOo+d90UJFyQm85+oXTJTmG6Tp2eH8+uE0PGuMY4G0EAFb16SydKYqs+AhSVxrM/KTZSXeVwgl2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210119
X-Proofpoint-GUID: U73r2UpdFTPtwS2jCpdNKXzeOsZM0fHa
X-Proofpoint-ORIG-GUID: U73r2UpdFTPtwS2jCpdNKXzeOsZM0fHa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210119
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 21, 2021, at 12:12 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 4/21/21 7:22 AM, Chuck Lever III wrote:
>>> On Apr 20, 2021, at 12:44 PM, Bart Van Assche <bvanassche@acm.org> wrot=
e:
>>>=20
>>> On 4/20/21 7:36 AM, Chuck Lever III wrote:
>>>>> On Apr 19, 2021, at 8:08 PM, Bart Van Assche <bvanassche@acm.org> wro=
te:
>>>>> An explanation of the purpose of this patch is available in the patch
>>>>> "scsi: Introduce the scsi_status union".
>>>>>=20
>>>>> Cc: "J. Bruce Fields" <bfields@fieldses.org>
>>>>> Cc: Chuck Lever <chuck.lever@oracle.com>
>>>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>>>=20
>>>> Hi Bart, I assume this is going into v5.13 via the SCSI tree?
>>>> Do you need an Acked-by: from the NFSD maintainers?
>>>=20
>>> Hi Chuck,
>>>=20
>>> Thanks for having taken a look. In case you would not yet have found th=
e
>>> "scsi: Introduce the scsi_status union" patch, it is available here:
>>> https://lore.kernel.org/linux-scsi/20210420000845.25873-12-bvanassche@a=
cm.org/T/#u
>>>=20
>>> An Acked-by or Reviewed-by from an NFS expert would be great.
>> The NFSD patch looks OK to me, but I'm hesitating on sending
>> an Acked-by.
>> I went back and looked at the scsi_status union patch, and
>> that looks dodgy to me.
>> AFAIK, "enum" doesn't cause the compiler to reserve any
>> particular size of storage, it just makes a guess. What
>> keeps those enum fields from being 16- or 32-bits wide?
>> Shouldn't those be u8 to enforce the correct field size?
>> I'm not sure where to look for further discussion on that
>> part of the series.
>=20
> Hi Chuck,
>=20
> Although the C standard requires that enums have the same size as an int,=
 gcc and clang support the attribute "packed" for enums. From the gcc docum=
entation about the packed attribute: "When attached to an enum definition, =
it indicates that the smallest integral type should be used."
>=20
> Additionally, the following BUILD_BUG_ON() statements verify the size and=
 endianness of the members of the scsi_status union (see also https://www.s=
pinics.net/lists/linux-scsi/msg157796.html):
>=20
> +#define TEST_STATUS ((union scsi_status){.combined =3D 0x01020308})
> +
> static int __init init_scsi(void)
> {
> 	int error;
>=20
> +	BUILD_BUG_ON(sizeof(union scsi_status) !=3D 4);
> +	BUILD_BUG_ON(TEST_STATUS.combined !=3D 0x01020308);
> +	BUILD_BUG_ON(driver_byte(TEST_STATUS) !=3D 1);
> +	BUILD_BUG_ON(host_byte(TEST_STATUS) !=3D 2);
> +	BUILD_BUG_ON(msg_byte(TEST_STATUS) !=3D 3);
> +	BUILD_BUG_ON(status_byte(TEST_STATUS) !=3D 4);
>=20
> Does this address your concern?

Yes: a compile-time check that these assumptions are being
met is good enough for me.

Acked-by: Chuck Lever <chuck.lever@oracle.com>

--
Chuck Lever



