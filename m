Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28C3C7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 01:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDCBFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 21:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjDCBE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 21:04:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950879ED7
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 18:04:56 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332Lj3BV009783;
        Mon, 3 Apr 2023 01:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=MKFFG1ngb+/H7j3polJ14GiOKn22ShLNVqewzu4esI8=;
 b=JKuLSK7VlXhAQ5b09Yh3ILUoFzdd+tCD53MAOTtL7D2BR8RsO7206rFci0Ye3CnpdPVa
 cRNvvCHJj5dK+Hk74ZYwAHpGlV2c0eAsZqLfjt9+klzIZoZLtLW6Pr3su3qVr+Jq+n81
 zRyZK/YIdCwruDk0coh4bA0P+bFcOH2CS67zPksIkopoEVPLBTYXagAxSWytiH3RZgEO
 EubPmpYLw6+RT3IDt1JE4Po12av4yq698pMNgjRynGXz/r/DEOJBqawzApiaqQliGr3p
 D00o5zWIcTsa9hwf9X08LDitak1GOkHI0ZmUnzs0B5nu471RtlxAv7RuXOjZ7lS1ZOYk uA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb71j08a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:04:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332KSNQj013934;
        Mon, 3 Apr 2023 01:04:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3dbj4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:04:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBy/yqLmNcrtqK/oku20r8kin2C3JcCYOYSFDKU7gwUoji8rFfUz2PYAFdKOf8dhuQOGIoyjMR8WmyEZ/5rvTaxig4KJ8th9zUuCmP0GjjqtKi4E1aU40INZJux5KeX3CVhlaGJdZUYaPRCTVt1MYzSHFkZAueBJjrpBtJahgmI3OImuXCZy91ldp0wsXJE2u/aSkXmku9NKIT2t+KE1uuXnxNHY7HVBplBT5Z37TsXspR4ErHJdWN3ZrtqxdVK6GtxehgbZ5SVJcmk8RMz+d3QJxIxb7fmsfwYS+/CiB+MHRXqsqBkOBkV6eUKfkF4Hz0HuxKniAPrpprVQjbkoTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKFFG1ngb+/H7j3polJ14GiOKn22ShLNVqewzu4esI8=;
 b=AwzHMgAxlWVY13Thh1OX6vsAW8qLRNYB32w3vGvYTWZo/1rg2LKyjqc6XObW0nMnXOKiIwWaUnNda77OZPvr8RQOdY3rlt+mkKLzeZfFjGZvqgY44Fygd0qsz+S2Sz/rf/VbfeMqlIwpZfo8dEMOK2vXjtUKSI4Ih0jFW4FHhVCL/mfnH/lirrrzeSARSQ+cr/LgW91WkbVtr1yBLcruC/si6HGb/XVfI66+CKJ5KFIJGLjQfGW2kbvJj6HLJEoKRIht3uSCLzXp7CGkbPqLyN5/nAxf1uoXIg/GMxI9PO/dei57qQg/AVJPHjia3DFzBJErhXXiLbG8L40+LXo64Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKFFG1ngb+/H7j3polJ14GiOKn22ShLNVqewzu4esI8=;
 b=uNxnRg36XD1v++P0qTg0Qqe5xPjJs6ocA02WsxESADZUHzfbYtUv/WaTLk6ZUrGiV35p5iVNtcUjbkKo+2caUQdaQQPhzjgNF0AyY39YKwPhFShgY2zIQCfysot1iZVaLuFgkFKxvYl87roZy3ccly0Ga3RJp/Gl63/aSQa0fdI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6852.namprd10.prod.outlook.com (2603:10b6:930:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 01:04:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 01:04:41 +0000
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/6] This patchset contains critical Bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0t1ye1k.fsf@ca-mkp.ca.oracle.com>
References: <20230228140835.4075-1-ranjan.kumar@broadcom.com>
        <167815780205.2075334.9513188954583912224.b4-ty@oracle.com>
        <ZCHAoUJaJLRRB9wf@eldamar.lan>
Date:   Sun, 02 Apr 2023 21:04:38 -0400
In-Reply-To: <ZCHAoUJaJLRRB9wf@eldamar.lan> (Salvatore Bonaccorso's message of
        "Mon, 27 Mar 2023 18:13:21 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0219.namprd04.prod.outlook.com
 (2603:10b6:806:127::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d7f0372-b06a-4cb4-7b94-08db33df67a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gy2/3bxkGUX5lgHVsWRiNxw+87DVqqn/E1xE0ItFQ8k2gTIhfddKi5JOJzR1AfOjwdc4cQX7rBn2Xmm8Hy3EmwsTNcYOd4U9X/TmPt+opUHtukzuxIeypGUgzq+40PtLx9FRURnvwVXnN8KkiSBTXDqxUvBl33WcjLZiGBHbhde5LZ5psR+F20/YFnQ+kK3lvKVsQ+zS8D1xxd2j+zPmxNp+L543Unw0O2yz0j/8TlUzbaidaxGHIzoNoio8bf7UKD+C5xQKgkLQDkPF28J22crENCUOjei8Pa1EWP9YGoWAxLIvJd//n7W35CzI9/5YEFZIFittq9xkvk/W37ioZMOAq2qeN7HdRjTm/JD9ihSqaKfkWJqDkh3O2OfRCekhaydb+UABhNp9/hfWEvhwoAcE/2w5N0gskYDMPJEdxRrcVF9m72VcnBibXYJOiHRoue1MLuUJyIhSHmtJB1xsQMZi2aIVYpu1xxe+zCwfS4P8QKyS2MAAgCcWPeryRNP0ANm5+5RuHeJpYsSI2M0Vy7M2m8XauT8F2WEQY2bZoTPfekC03MU5Eq3/FTaNmjiG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(86362001)(2906002)(36916002)(83380400001)(186003)(6512007)(26005)(6486002)(6666004)(6506007)(4326008)(8676002)(478600001)(66476007)(66946007)(66556008)(6916009)(41300700001)(5660300002)(38100700002)(54906003)(316002)(4744005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VY+sj44vLoAtrtyAIr8+PSduPOyYFi4djaN96IDTqAq0xrfzOSwGklWTIUgI?=
 =?us-ascii?Q?M2qQDNmwfUXM4YAHXw2FXQ2SDQecAou582hQ75OPd+nhif3weHqoHPI1Dj+d?=
 =?us-ascii?Q?rkD2qUfnaz3kLvCguyfW2zWex350/Yk9VuvL1vzTyIwVw7wyuWlLVtJnNXu3?=
 =?us-ascii?Q?O1tj9tO89rJ+g6fsgOtU+WBwgZHFiPtCwrVu6zES4VJLBsgMlJo+59W64wyY?=
 =?us-ascii?Q?iobFGPZCagSZZw7OCISihJ1IPzqXDxS0Wiolscv6Wt1p3tPpnCaPv4Q3H/Mu?=
 =?us-ascii?Q?aEyGBK0qDjPRI2GH5Pj/3zE3tFTuX3LUHCZMGv+hRpnfFzvihbd53tKFOk26?=
 =?us-ascii?Q?iAn2r6kZ+65UVCeA3uny1FuzIzrT+N+EuCnchc5ZglL65cMkJsBEQA8D84gF?=
 =?us-ascii?Q?p/ub/yidQSMwI1xWFuWXim9RNy+gOp0VV9yzZ2rRF2AJ9W98EF2lJrdOYETY?=
 =?us-ascii?Q?DrozVN/oFVoh/VjWIWle8IGWPRysX1P4bkaZ23yZvRS1ojDDFvlJs5koXzVX?=
 =?us-ascii?Q?lp6h8COdjcAgy4TKZI4nj2d98qWgbHvuAig8J0oQTX1bpiwr3CdU65FeppXd?=
 =?us-ascii?Q?N+16BnRDPr0vZczzZD3dviW3gWmt1H3pLiCW1MI7iNvX0gfK1Dv87GVl8IB/?=
 =?us-ascii?Q?TatlHsKp+eop7KF1QRxvpl6LMvQLIrIu8DCbT+XYwcGR/etcb9wRZrncJvZu?=
 =?us-ascii?Q?knl5DGHK3g+VVa49TPUtBKSJvhEPbRrSb5Jrrf7vFpyqDkeldRndRzdsCz/S?=
 =?us-ascii?Q?EwvtA9ScGnKq59rtcPObSnsRuo8HAiOHp60CxlPDi32RdDPIrLw60VBqeVJD?=
 =?us-ascii?Q?77vg3J684qwbXNDlLJQcov1Srphj69G5ccsNjdv98uhP4RMHcfZ/9TLf+ZuN?=
 =?us-ascii?Q?aWkE8zJcuKK2bEGnEuRIxCard/GwOH90Rhvk7jX4nICJgs7Cr24PgpOlTwlc?=
 =?us-ascii?Q?4xzU1kzpe8WIBdvAP9jPeUBa8y4tUYjXO2L7gzXXrQ/QnPpnlnwAWHp4uJhP?=
 =?us-ascii?Q?UehJaPKfswZxaghCkGy0St9Ns+lG7WeWC3Lj9O+sWe5mmv9rNVouHi5/A/iL?=
 =?us-ascii?Q?Xa+bJ9dq8fUPrelYzhGRW+rWG29Z19+4HZ2L1pePt0Lzdadm1yi2MhQ3JhRx?=
 =?us-ascii?Q?1whREU/k4JCCzweAze2Ry+Of0DvapWHoLx8XkgmTtM1MtOecVLhsgw5yydOM?=
 =?us-ascii?Q?Px2EdMxEvXWrkeE9KtedASu7z4KHOiCjWnKuuNljJuSDUjviuwcVxKFDhuWP?=
 =?us-ascii?Q?0ZbEoNXTn+bNhx4mw6w92XHJayiXTKEIBqV29SDJJdfVYKxA/gGUK5pwllLP?=
 =?us-ascii?Q?3Uv78Ww/OdFvevP0RZ2cxbJBmafFc0H/kOxps8+grfV1Hz1MfbHAF9763cKl?=
 =?us-ascii?Q?w6BxF4sb87NtRZpYk3Q9hs3czi7YLdtzC0odE67u8WFwoM8JdJdfYVy+Cni8?=
 =?us-ascii?Q?6bUL2atREB61ZkOt0sXlt5SABAIdKvdW8GI6i9lecmuMioD8hUw7FCm7HHzz?=
 =?us-ascii?Q?IARBhTLQa3FHVEZyBXSMyRjvofaY2bhxFvt17Tmql+QpsekI6hkd6vIhynSn?=
 =?us-ascii?Q?1qi6A4GyTiJA5TvQiGcIOTlSVcpC6VvVz2zHTL/XqVirlpps86T5Hi2oCUZi?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: v9VmKZUEwIxiwIoTsIVx5HLkRjVuHfi9O2WeMG53RGv/NAVpkvkks0U3knf0ymqCobDdG4JzyDYo1J9Ill7rW/ebmR7DC4QkXbFb0EDbGw0ZCChkuL2UqN7j8G2l+B1g1ZcypP9wNAZmoP/3nTmTtmo8eWvUwk2PFjy1GaSvHECE9U+2jH8HdeIaY5LqHSyBF1tEQ0EbfoPSd2NN/u4gZgfMBlRJxgvg9mz84LooA7QmGYl8UXHpXQhtc8fObAUjL9Nqr4kjJV1tIclm+4buuZlQmVRJQRgiqM4BsC29VnuFC4i9f7Ve8YB+ctvQWJG+cLFuQxo4h4Q23FvNubjpURy9UWszOV+eXRO36fFWzuPrNH3PTJ6wODqxrbAVPLBxUZqOP57IShAvzFBrBsd2y5QjwQCPdw1MPZ0iYUVOFKpP7hbNM0sTkzEDb52WKbWcNOszhDjY5EWz+/AIV6FpCACNh3GzAfGdHB2aZQ2+q9P9gXnFbO6KXtsW9+ttT7ENED+gYFtPR0YBkzK41tTquZfk+14/H8XhW0Z49UKNqxIkMM38JkcMjNf/BgZw1n0Ti4FBNYU/m8zmH65q9V/eed4uTXj9l6SCYeKlWGyI+DmQbkntR81eej8No0X3SNRcTPsChY8Kq9AqhUEJPyi/2s99b5oZeEbtlcLGfI4YYUTHk0Vb5Uppw7Hlhuq+WrZMypEybR8F32bripNHgdDnziD2zy1jbfvzOgbeALwsaaHetaTHUkDqk2kEYkB3XrNgHONV1pj3ytlRdw7XevkeI7eNW/4pmTP6L0FkoR12ez5/lscu1A2weF9p0c2v5xFh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7f0372-b06a-4cb4-7b94-08db33df67a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 01:04:41.4795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPJ+X2EykMAzIKRVFCca9AS787NjU7spVCieoG4gGiLiAwkMTET457W6Nn8Kz5xCgfZyWozfbLjmQUPmmIkUa/wiTNZWuvlPrrRDDJpGsmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030006
X-Proofpoint-ORIG-GUID: 48vSHvSVD5PK1r7fyTnXPkMyP8Kg8sEn
X-Proofpoint-GUID: 48vSHvSVD5PK1r7fyTnXPkMyP8Kg8sEn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Salvatore,

>> > Ranjan Kumar (6):
>> >   mpi3mr: IOCTL timeout when disable/enable Interpt
>> >   mpi3mr: Driver unload crash host when enhanced logging is enabled
>> >   mpi3mr: Wait for diagnostic save during controller init
>> >   mpi3mr: appropriate return values for failures in firmware init path
>> >   mpi3mr: NVMe commands size greater than 8K fails
>> >   mpi3mr: Bad drive in topology results kernel crash
>> > 
>> > [...]
>> 
>> Applied to 6.3/scsi-fixes, thanks!
>
> Will those be backported as well as needed to at least 6.1.y where
> impacted? It was noticed that the patches do not contain Fixes tags
> and no CC to stable@ so they might not be picked automatically for
> stable series.

That's up to Broadcom. I rely on driver maintainers to tag the commits
they wish to see in stable.

-- 
Martin K. Petersen	Oracle Linux Engineering
