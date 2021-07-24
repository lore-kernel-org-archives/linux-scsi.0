Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A2EC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B50360ED7
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhGXBvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:51:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14606 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233690AbhGXBvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:51:50 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2V8He028195;
        Sat, 24 Jul 2021 02:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PtkOgIYI3sydc4lZAD6FRUun+/wWPlKPDs4F4Fh/szc=;
 b=zeF7sk2GwZbl2Anbhw1PAYYyg0xiCSAaKt50Jc3tfTfQON0zYcB5YQutr7hR4pFacpli
 XwXP9/JE0VhOZob+8reaWZW5Ad2lGhk70bfNt6KGESYwGiNQizchg8UYt7CLg2IS20Qs
 Yv8G7JN7da2G36jl5xnaFEcgSwTRbZ5AJF0NjDwlAVDj8kJE4zFyH9YhY5KM8nRjecHQ
 sgBgmX917bUxQHFlNe9PfqsBiYQdUf31PRDgatFL0WKUe/9hmTNhPC4hJIvm08deOwxC
 5BXPttFsrA3HuOYjrRHKr5C/80Uuo+kVQuQbXuDbtfbIVAs/u3Q+PuyKLaBzd3+JOAxT jA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PtkOgIYI3sydc4lZAD6FRUun+/wWPlKPDs4F4Fh/szc=;
 b=vZMRGz/vhtqVBjb+IAbzYD5uvgCHQOiqxPbiLcF+fgBms9Slng93EcPm0DRc5iTA12eS
 cy5OHLzPRktYinlWT2Na6l0MsT6Ifhfsngh4YE17oxMDArW3yfxvMoap+a4VxsHLZfw0
 X2i8CAeKzTW3QJY5Yk43F+be6wRlQRRsHtsElwq3UOZuYVRzaog0XJMtcPD1FZCzu5kh
 LJ0l+2IYVteyN3YlK2/8X9tc15gk3CE4UR3uZzcHeUJko44YesX08tING7bOFGBHE0yf
 Fi9zGYcqWUS3qATSplHFoONmKJ7zHm+vG+j2idApmnBT9qxMaXRUTF8mIVRW613qSB+m Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a099c011s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:32:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O2GdMA090563;
        Sat, 24 Jul 2021 02:32:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 3a07yrnfw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:32:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EONU4E1W0KZFrU4aczjr46Ifkrylj5EoVM5i+zBAY8+MnwaIhTzW+i41+LiTCzcRwHYxjiaCUXwwrgsPUi477zXWvyIBK4nPp6hIIkajvxsSeYg2mVaksz9OCZDwv/W3WE7gGOtTrkVIUU9iYw2Jfg8sX2rkwrpBfPG3qnlsD7qmTemO+J4kNRxTjdMcBeLaFx1WBB0RKjYuab9c3crWl1N+kFWg0y1BMLcl2bRH/qDetPRP5dgPRZBPy9/vxx272JUpdcisVewKVJqQU0nwcQZJilp09vr1hP0CVezewmKYdvFWQwUpobMCgeNTntvLS507ua9MzgcOHLwDmM/M8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtkOgIYI3sydc4lZAD6FRUun+/wWPlKPDs4F4Fh/szc=;
 b=exdRMb2c4aw9JVqYx8a1tpOS6anTkShKygppUkrrKtBuSOIKPt2y2+ZnGHnAXwf7DU4aNt6JfMQUInR/YvHXqtpRMo1Ar7Y/E0IUQA0VX6zvcLQzVfO+0uHWQYtH3rZ1WQ23X72yjxin+3g6iXhrDA9F+W6vtk8CIV6MkZQqF9obaKBA0nGnNoHk7MuGGUagZAUwGqMpA7Vmy12OKJlv7KNc10tLz4ZTFLEqTcDE4KsIOj6fzri7TALXLetVpVSAYAhYGii/viAHG99GMW1PdiCwTC4RyqgwXq/LFcYkS3xeBYWWak7mFE7hSzrMij4MbEbpbSAs5dQyGwE3ILJRsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtkOgIYI3sydc4lZAD6FRUun+/wWPlKPDs4F4Fh/szc=;
 b=KSbDUjY388JH4UhvZYUmXhtcplqVHECRAiZlBgruB/HQfiZyHcODv3W+adjMeREx/jKeCL5/DzB1PonkXhXQpOgpGoSeOyopgpbJzJLJLnPXfR0luktR+ZqP54A1Lm+mYOAmtsVxhob5VInL0bs242JuI+GXJrMCpnvlaa91Sf4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4581.namprd10.prod.outlook.com (2603:10b6:510:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Sat, 24 Jul
 2021 02:32:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:32:16 +0000
To:     Salah Triki <salah.triki@gmail.com>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gregkh@linuxfoundation.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] scsi: aacraid: aachba: replace if with max()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8astphh.fsf@ca-mkp.ca.oracle.com>
References: <20210722173212.GA5685@pc>
Date:   Fri, 23 Jul 2021 22:32:13 -0400
In-Reply-To: <20210722173212.GA5685@pc> (Salah Triki's message of "Thu, 22 Jul
        2021 18:32:12 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:805:66::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR08CA0001.namprd08.prod.outlook.com (2603:10b6:805:66::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Sat, 24 Jul 2021 02:32:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f00e534-bef6-49ed-30cb-08d94e4b409a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4581:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45816F07E41938A1584FB2C78EE69@PH0PR10MB4581.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Pvfd6p76YX8kZaEfCRktW+Tmq/ZrJDj36GN8zPk003yO3H47aMMBReexQZPxsh6k0mRAup9qPZYYmpJsGGyV9RMBpVZc1KwNeUTqVVd+S7fQ+anXrOu7REpd4dhH35LnOFYP/W8lHcra8PqZjQ4B974oWUVPigBn6PKE+51r4u9P/k/bAfpKmJueEWKOrBXt/8ND/GjkQzUsUZ1ChUtW+gdI/naco9/LyV4ZJ/sZbwrsgbYegyFPVoe2HsSZgR2eT0UkskQi7Z/uH5PzynAOH3KXKJISgZlK/i43q6SHIO/7sr7kGZ679NuDny4JK9IL3NCpBKD0aML616jKXB0vzSrG04Afnfjuz5YCm+7grDaGlt8cW3W6wrjmZhTG8+h1ISe2r7180fjlY28nHLKL8IZwsZ9Bma2rRj3ZOJ/8YvVKDCbJOtXYFkxdjHX+Joq+8oOMUxKkjTOBHFHcp2b1t4nKoBHnlzyocq/7Bs2O+sztKDpLOBS6X4iDUmeBkx+DgQZWuRXEnp2yxE7FyciwhtxHrTLXaj+a46VCQP59PZrq79FkjYSaaFB+pldqVhogyNEXGwlXv2Ed8h+wOM7+6c7wz+mjANzg2uTVDWDVIaCVPCWk6OzwgLXm19tt2qFB5cjN3RzUpXq5UpN/pD8m7cPMREi+j5Zftm2iHRC48QwpWsXv2B6qSGFFjgu21J9/Tah4Tj1P9YXwRxoOa6Eww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(956004)(8936002)(26005)(7696005)(316002)(36916002)(55016002)(52116002)(5660300002)(2906002)(38100700002)(6916009)(38350700002)(186003)(8676002)(4326008)(558084003)(66476007)(54906003)(66556008)(66946007)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gqYjOc5gGr7EVjNEfX95ViAPtVf0jwlvfWZOhgFFacRfFv9dTsSkxUhJk+ZA?=
 =?us-ascii?Q?/21hdrc/ZHndfg/WJp9ptemd+3hthatnupzJS8NAgsImZi+GHdfU0ENuvtwm?=
 =?us-ascii?Q?UvWqaySsXurNjKMFhi8RLqSC7ScncjEk9ZqQYrVK3vAS4jgTU/oKRCxnGhkK?=
 =?us-ascii?Q?CiqcJxPYYlmSOiZfZ9tI07sSk5OXFn3cAalfmctBSyU/JakXZJKTdobkJ7j1?=
 =?us-ascii?Q?xqExDLGbRFGZRaYyp4IzAT24hlrkBmj9iu++f4q7AXOB37a11Ipep2HrApmS?=
 =?us-ascii?Q?pMsyoNtO7OVr8fcbYj44R741P5ZaLjK6dIcN6/GKNcMb61/Y8r7JH6yahlGz?=
 =?us-ascii?Q?+SqoNYFQH6NWdiqBg+rQcYgs1bE7EDHD1bm6kEDECWGRbgdCGvf0jDy+UYer?=
 =?us-ascii?Q?zeesMgvN2xYeBYTI1FmU25rENZa4B5tELE2TkMzVzK2wKCJMIqlNIARcXdaN?=
 =?us-ascii?Q?URhfZEtP77OKTm0IYfElyCpd0ag2qVgx9EeNrJSZxgvhymJ+L4ico8paDWgk?=
 =?us-ascii?Q?4eZHXphwM9JXkI91tb7UwMN5USU8CJaNCbv/OhEqwd+5rs6hJ+5ZCG19UoEf?=
 =?us-ascii?Q?peT3R313JHIWgLvnz0oAVy2Qfyl8DEGkW4ssW7VFkSZiV36VLylIuDAw9Q03?=
 =?us-ascii?Q?BXJ5LG5Egk1jv8SQyLUfAR0hZQ3Ci1TaFrniNSJtmi2daGGxrfWUXmHMgHEe?=
 =?us-ascii?Q?culYX6mBJ7Kfdx/tqQfJnaA7+KM3v7Wc/BZaNKTGREarQ30bbUX0YiILi4SK?=
 =?us-ascii?Q?yM7uXNuai6Bor7s1kMkNFZHI9ouAEbtypDmyrNfAwZ3uHzKoE3hvgghuGPJL?=
 =?us-ascii?Q?zPVtxi0zJS9pgu8X2dFSAK+ZaE4Km39eZ5fC/eMKeEgsh38RmqF/gnjOZFan?=
 =?us-ascii?Q?oABq0jyiAeqOVUSPJDmZc5tss4DM5jInyguwUgoGWPf4oLCgO1mHcxhv66Yv?=
 =?us-ascii?Q?KdyPyOcJfMZTixLXMDYg9oSYL/37wB8dFUla9r/M0vXbN5C+ikF2vZkYGmwV?=
 =?us-ascii?Q?HeUV3YotcrPNSYZXuB0BKqDL/mmk7CqaIIFeXKOItJgdxtwMexVlK+tuIIvh?=
 =?us-ascii?Q?v8qqEE7B1DCm7e4Nj3/7BiZDQJOSPZSQda3y3NsPp+hGOKFKwaw5Ww8P4sEr?=
 =?us-ascii?Q?eMsWIkz4mbtN4JPA0cPjE3Zz5FeS8XSdhREx49+kT5L5+crAfU//LV07a3pe?=
 =?us-ascii?Q?tny2KfSbwBr9TmB9B6u6j/YEhGQ2xYcnX25kV6cTvJv/1b8W/HJrOHu62MDf?=
 =?us-ascii?Q?XgQW+5S3Q+aRjebVykUZctf2OrTVIGZCpnETdkSIs8AltakABezXDnkfFJYD?=
 =?us-ascii?Q?7vlJE0x7ZqYgsqrc0Smsksn6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f00e534-bef6-49ed-30cb-08d94e4b409a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:32:16.3912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9dKkaC9HCz/t9dY8CxHlhSExgyMtdOyjD7A+RevZcciGhzFi6CQk39jNKj8VNNzi1EmQaNW2hLZluSQ4qe6di1Ym8vctz/frNYh+H8r9kE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4581
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240014
X-Proofpoint-GUID: -UId9o_Qwyo_7ms7ogjB6FGe6Ie398AA
X-Proofpoint-ORIG-GUID: -UId9o_Qwyo_7ms7ogjB6FGe6Ie398AA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Salah,

> Replace if with max() in order to make code more clean.

I find the original code much easier to wrap my head around than the
proposed replacement.

-- 
Martin K. Petersen	Oracle Linux Engineering
