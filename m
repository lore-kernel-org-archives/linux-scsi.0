Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F61C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FDD761041
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhIJB7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 21:59:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51406 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229587AbhIJB7Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 21:59:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189M8nDc007230;
        Fri, 10 Sep 2021 01:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gK7Ett2CDT51dT2gFv76J6aO5rX2jcpb5IAL6Fhpv2E=;
 b=0bm9SmHkXNI3K4XAFnXYsd2ib0eMuTRQFnNllzBqUMx+IDW3QhpDABLdl+0DyVgjrcyh
 Oqmhd8vQx+VYT8TMvpX1rrVD3otOkDSqkszE000huQhYEYo1hqdplpl4NcmB1x8qwC74
 /agi9pzYDLV7bm0ZN7JANHI9U2riJcoilQoPUfnrZvLDEvPItSPskECEG3Uw3BdSSXxb
 E7IAYyrlXnW794MiJhydPMwq6BCZP48Ho4eaoG0g0V7ubTVZd78KeMELh/xoQMS9857s
 0V221Cii6xcDz53mwj0KY2uTLY4TcOqB4i82hLVWn1AfVJX8xPnj29aVUVfttyuXFNbE bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gK7Ett2CDT51dT2gFv76J6aO5rX2jcpb5IAL6Fhpv2E=;
 b=NjjPYZsuxsZwYF1C667cdIF/254Kofo0Ae+k6bu/OpjuEimTmj2iOUzA5QD7pJzMXKgK
 99XKBOzgd7Q39l3t6AOPCU0wlVoPVBrJi/jLHd9sQEeEJc2khk96pIGt+mACp5Zo8Yi0
 YZiiMF+VkLfGl7Hyi93RkBRRcuz90PIjuPWlE//4QhEQORrsJc4sFA0h72IaNuBMeaoY
 QuIHmB1CdKXHfyW8C5k28Zoa04kaHTzqhjqSRZxCRrmFXo7NRLtwlGQI3lQvFfvNcQ14
 1ZU4/5dupnLZyV6asfq2hmedRHGZlLjjYIdkhMvu+NSSU7d5qzyXyQGgTcOlGDfXP3k2 qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ayttbgckq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 01:58:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18A1st82135873;
        Fri, 10 Sep 2021 01:58:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3aytft89qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 01:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBANHjVCStUay0RGWzqdQC+zpAQy3QzkAcpH95WTIe7uQbZHOtvwFTzSy4KvjQdNvQbRWt1bPtpVLSa9z2BlWGqGcY4lU+IYFopFWRv1gMMaKYAD5Kc+S/si+mjtJK0NAUPwor56OU1cI4Z3dE5IpKuo4+/+X4cq3ZMzV/IBJ/vPxuylWWUqJJtTJqbq2DLk5Va1qRFFXLhtYEbVNykZupWX+Hv8dF6DOSUkYrGrrQBDpm7IlJlbJJ9e70ExCP/vy1UwPe6OlPl8RoBmai2HCXYWC9qXV5/YN12M3gkMKXX7Zj3EAExVA3CmV4cPZ6hG8ScDVWiG5+HU/0g2s67V9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gK7Ett2CDT51dT2gFv76J6aO5rX2jcpb5IAL6Fhpv2E=;
 b=PA4w7/1CTGSckn1JuQx3eAJqaMbN9oOqNg/OTgQjjfBXLkYWAv6Vwj6ac4vpdDlNckY+mZhTGIJWzOHosQFnZ2q/QySfQb1GqjC75TnuKZp7WV4cfj4ZWBEt3nVmog+LvzPptLoQG6JbO/WZj8xxotv5cDSZEtX2nGVH59WK3aO4l2Zwv4u4CnLX8bIhgYJN4LkB3UNQPzlsahzYbrxvxpL8kVhfECQytCB0YvkWtgNQ9jhEda2+CCh/ryvjRic9RIEJmLBjuANofH7wFEKMSzI1dNOeNJofudkV0jNuSD+b5NHPql6PkamqoDd7686iLFrUaP+nQULYHdCcswDvUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gK7Ett2CDT51dT2gFv76J6aO5rX2jcpb5IAL6Fhpv2E=;
 b=SV6UXe8jvFDeudccrru04onMVPivzbLpiPaN6IO3LTRmSZ+dipBeUJiwvKrDD5CkDhKACNy7zPLUA2aoqJHTbvLcnsKyp/PzNUflttyQq/B/eg+I1cnbagKqfup5gp4HVePoePGuJc7ifV+n/Rs1El/I5kFRNokdpCj1tVpOwFI=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5641.namprd10.prod.outlook.com (2603:10b6:510:f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Fri, 10 Sep
 2021 01:58:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 01:58:00 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: remove SCSI CDROM MAINTAINERS entry
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilz92osg.fsf@ca-mkp.ca.oracle.com>
References: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
        <d086adfb-9cfe-6f3c-aae1-b9106436037d@kernel.dk>
Date:   Thu, 09 Sep 2021 21:57:58 -0400
In-Reply-To: <d086adfb-9cfe-6f3c-aae1-b9106436037d@kernel.dk> (Jens Axboe's
        message of "Thu, 9 Sep 2021 19:35:43 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0040.namprd04.prod.outlook.com
 (2603:10b6:806:120::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by SN7PR04CA0040.namprd04.prod.outlook.com (2603:10b6:806:120::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 01:58:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d755328b-0c39-4001-99b2-08d973fe6b1f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5641:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB564163CB911B294E282992CC8ED69@PH0PR10MB5641.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNZRAF9R6AbfHai5oA8b9+O+yf2P8cC8oDOPUW3eZWI/T9/XyD4MHV/Xv+9XKYo6g8NFMbrsoluNdtPVqH+L8DRYFekWH/HBpQ1qqwYYiCDQThtSdtSsOgPR8UhDdxTo+uFuJs2z86ryLhKYbPFJBjUQz1S1VB/PsOPIinERHLSsXVhL1ILjIFizGvcSEYlr0u7gmEPuaIbmmoaHYAUm4C0lC/QQ7izpziOLX8pZ/MZ1WZhQznfmVAJONhGCcMyrsMkkhDUlrwbArh15c1Il/SKbLZKGwYd3ssS8E6s96V6Bvct3xIWabJUrw99b+4kZrnxaAXeqchgL3r9T3o07gNHvyx77BjurO2PTWiWik17cM0GAncTQtiSb4RYSFL8DHhor8IgsFqZ1fMYh8q8JnIDxfVFRFek/y57SEW/rkMd8zKHS8/Db8vZIrCKv5DJb0z1oyjz7u6KB+sFwiiIXR/4omlI2KEKt51itZNF97BAruIz6RLRZKJak8EqwiGZ0hw5URDfWahHybG7yRHWNENufxn9oIZ2UZP/hsa7EKxe9rT7nSPvM7zu6jsLPYUU7S5U5e2Hvwpo9xfU8p5Onhzr2dcaDsioew5Nc+7UgAjlrBYJUV3VOgCocBrmGXtkqkzUR/Y85oBnkshxk0oreFvXdFk6I8IuUzP5lpCNWCT3y7QSdBiny+HRGT0dhkW1Sbu7uUP4czLEvn04gj1bPuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(8936002)(36916002)(52116002)(38100700002)(186003)(54906003)(956004)(6916009)(53546011)(478600001)(316002)(107886003)(8676002)(66476007)(7696005)(55016002)(66946007)(66556008)(4326008)(5660300002)(86362001)(26005)(38350700002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CedaUzQ9OvDUP/wEI0exWHbNeHFOJrl9/SLYo0jr1IzL1HtjWMhMo0JSA2kb?=
 =?us-ascii?Q?M7SUJOYQ3Rw6QVR1tiSuz9+fUGn2bxM/YeTiCACGkY4t5rV5eHCEgFdtCPp4?=
 =?us-ascii?Q?CS9Mb2pr3PS3LdPWEot9BRh7iI2NDXNSpHeoJ1Fg8PiUJB/lVXKsrs/YggGH?=
 =?us-ascii?Q?aaVOqa6YlLj/0cXYx/wVXDH2LxcnsfnRKpiYdEpUjgB/3UtHxLfu5P8lLlzg?=
 =?us-ascii?Q?aiMSXejZWK0jf5aJBKIcmvEU0CFKDqYoD9nWrniVs5L/+BdlUBKZ6iLro1ug?=
 =?us-ascii?Q?4SaF2H7K7UxXOUVviGC7NMgcL2SOZtNQ8re39VAIoXDRzxOGhx5ppoO0hcBI?=
 =?us-ascii?Q?6HBGRn6kj12t4xi5rq0N2idGRhv4tcMa0j+ebhR4YG9TeJmKNVJoeBPIZvJM?=
 =?us-ascii?Q?UgqOJ5eBwSYldcAvwdZD2O3seFEfUrOpKfZqfTh8JRakSCcG0ubJt3wkC9ue?=
 =?us-ascii?Q?OTtkaERitbXlElp+paKNJpUv0wii8FPne7jYoQgx2RHF+gL2VW5ExH8VRfvb?=
 =?us-ascii?Q?mY4Gm3ytal5SX0E/580Mb0UT4REVI0YU5rzg0l/+UYsPLPweUcMG5/Yc+sgV?=
 =?us-ascii?Q?t+riPTy0CSuZJCnpSO4RortaCHKO7Y6jTa3zTxi5btq8HFp6/pB/q84/y9C4?=
 =?us-ascii?Q?d8HskF8GCuogHT2tSwO7R8fPI50y6C9G1ej22dEtUu3mHTALUHSL8yUtesyd?=
 =?us-ascii?Q?6A/hq9Ec/hwPfCbcZ8H7U5NO+kOvvrXnCqYPHIDkQVzCh0DsB6T4Ime9QtVI?=
 =?us-ascii?Q?hbo48WaJpNvoMc6VRHNkJue79Ub0zj6CigffiGZ0JjyLtocs8t93Sp5r9Ur/?=
 =?us-ascii?Q?oqstQmBzbWHMobz7xThi7arWaVxIXnOfZCpmYUtqbshOMfY6XXu6aXUlFLYd?=
 =?us-ascii?Q?jm86lvU0QiNNu2ZaIcpslrPYX3FY3erpTdQswUGktYGnKV5FSWsjJgzIizXK?=
 =?us-ascii?Q?Oa/Mt9Ow2UUzi9UjpZMUpm5F2KUh1kxMTjPBOt9tFaBw/XBC3teM1XpCM+oX?=
 =?us-ascii?Q?9qGdkZa8DEUnj1Vv5Xok7sI4tBcNsNKPCg+vr2cHTWCijiqpscSeSiULaSZ2?=
 =?us-ascii?Q?Og3b1JhdDI+TiGAsAR31V8STUyRrPndH4vWC/evHWpOFJrjeZQcWqSGIctfT?=
 =?us-ascii?Q?/hxB9xYuALILiv0ignpPSnPwAB11hBI6ZlCerbYq9NxxIFuX9JWzORbT05aM?=
 =?us-ascii?Q?lp6ldIADjXOXCQfBmrqvJ07xpmvqkFMLgpfwAQ1JNGGAUKKRchkp93ZStFZf?=
 =?us-ascii?Q?W+wXWpHmy1lTxN+L76FqD+IbCUnmlM36chVC1Ve6WIZcoyoxtz8oeOyC0vcy?=
 =?us-ascii?Q?Yz/r0PSRzE/iswyz/V5M3e1F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d755328b-0c39-4001-99b2-08d973fe6b1f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 01:58:00.6791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YFQH3PLcDz7A5mj961oofIlf0eo10Gll1XN2564/r/MmoJKneAY4OqQnUo6/0X+m8soZ+USGQX0fpewYeY7/970vt/FYQ6Htc5kV6/qwhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5641
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100010
X-Proofpoint-GUID: vOvQepwx0J7bIhAX3zZBepsdJPAOUKnY
X-Proofpoint-ORIG-GUID: vOvQepwx0J7bIhAX3zZBepsdJPAOUKnY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> On 9/3/21 8:11 AM, Jens Axboe wrote:
>> There's little point in keeping this one separately maintained these
>> days, so just remove the entry and it'll fall under the SCSI subsystem
>> where it belongs.
>
> Ping...

It's been in scsi-staging for a few days. Just haven't hit the main
branch yet.

-- 
Martin K. Petersen	Oracle Linux Engineering
