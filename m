Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D69C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0F4661078
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhFSCku (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:40:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49984 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSCkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:40:49 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2VI6k005485;
        Sat, 19 Jun 2021 02:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6fgSTJrY4cWsApuVORDnfKvtIEvh1/or4FqUBJGFi/4=;
 b=WskXOUXxkOk3KdbtIK5eAOe5lEiJnt+kA8n2yungYZ/MoaLNHXFHBZXj1nyetrSw1J2h
 aqY/z2LR01L9dPqM8DrBIoXI7T4nDHjqxXKbtKpEUQFfR2Dnz4JcDlhEtAssjhroe2Zz
 N9nHszaxrPqELMohsSLPv7iyM7PXcFolyN6HgaPoscQPU98cm+Yf0P5jtZAD3gm6idGk
 SaQYr6CfpYqz6dYIdIejibIhtcTECayh+Op3Tvy8R+bfMgnNp5JhJk3Cyhl32QngnKVE
 /MReCSimy36+Ms169knqbN+1BgS3FIbJcGfEVQUew+8To/ua/DhXoJGscdn4bvVEneF/ fQ== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg15t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:38:34 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J2cXPF018261;
        Sat, 19 Jun 2021 02:38:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3030.oracle.com with ESMTP id 3996ma1mt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0vRr0thWFyMm9HPNdVGQNPOqU8Lt4hil37CifY1kwOsm4b+3yhEORAG+oili6UKLEF3NPsFgz3+vRUmD9ZH28+VR7kzNJ3mHG2+ytfKUZbFn8+PicanDUb/tAOSHPpwFOhdxj5a6LoRRROL2mRRvpFQ5vxy20fJAIgzG8SLA0XHoDk1YezpEgjtFAnHXeKH/YT5dvhlYNBMw8lt0Awj4QANq/FhfwhgSyKaywOj+bVHjcIOjERNpdEpPv2STXtTcKau36uSpdZb3RRhOrOYAnX5v/S7sVngZyakdQadJ0DwJd7etqVm7wnqs4oDCpMQjuoNYlqFXsnY03ORxbzWsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fgSTJrY4cWsApuVORDnfKvtIEvh1/or4FqUBJGFi/4=;
 b=UKSIKuY4juRXOeK/h1a0jaJ9np8LC632xN7DOo96WI9L9gulUJDPUrVEc8x/KSyQLJQwzZNG58iL180rNvHCGmomvZvlj9TJTeJKpcXEkYpudkFYeao3rTUJ8ewTiygrUIw7hSl8fQlTajQstV3tmUDv7uk3h9xAilnOZ0LEqlI+86HeiiWyDSVG8h1GYRHiFkp6rwjH2jRDAx54AaHezXX/tnImcOs5MdB6L43eVok3yDfwaCQsF/mtd9idc+J1mCWTwV9UXPaBkfShIk8E2dwHJz9P2SubDWlkvcN42PkUrxQDb1XPKwdzVcl01VSHdYYHd9vRpl1CC+qhG3PsVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fgSTJrY4cWsApuVORDnfKvtIEvh1/or4FqUBJGFi/4=;
 b=gjzit2yFMYz7ZAvk9zSZgAkE2/8hYZGgb96vIuPzrYldu6du6NlP9dD/O5AmDMknJBsX5dMxjSyg66hIFWXNoCJpss4rSBgmv8bJlwl++tAbpKrTS5ZJncAoBfhTtO3oPNRwnxWT7wtdF/K8vntiqWzUXmxWVSnx9vZaoeOAJ9k=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Sat, 19 Jun
 2021 02:38:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:38:31 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, ram.vegesna@broadcom.com,
        linux-mm@kvack.org, dwagner@suse.de, hare@suse.de,
        martin.petersen@oracle.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] elx: efct: fix link error for _bad_cmpxchg
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6nmy3xc.fsf@ca-mkp.ca.oracle.com>
References: <20210618174050.80302-1-jsmart2021@gmail.com>
Date:   Fri, 18 Jun 2021 22:38:28 -0400
In-Reply-To: <20210618174050.80302-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 18 Jun 2021 10:40:50 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0132.namprd05.prod.outlook.com
 (2603:10b6:803:42::49) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0132.namprd05.prod.outlook.com (2603:10b6:803:42::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Sat, 19 Jun 2021 02:38:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47453ebc-e6c3-4216-546a-08d932cb53ec
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45978B98A6A0E311E12993118E0C9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56vBSCcSNRvw+YsbDLZ3+cKHoy7CTn5l1a0VA8sH7gOW2epXNxGJ/fGYqNr9xQbU4jfTlE7abJukgFKDgf1rWUpEW+xemEz0PRQhQvdm3kYC/vd+VQzfCJmSkHAlwE2wga/RCetb1cgHiciIVAWbNs9R4rR1RuObsO7eK14KXnGSh4jUBpKmqhdu3cug7QSwZmnY7xZWkPDWGDp9+C/V7+SmLv3eD2vqeRW9v3uiDn+IV+vp9jixL8ibM0ocEG0Nsvgf+ar/wA12PCNCqulne/tyS6sGBjJLnkPepsX64eV7I0ygElU17orpXsHW5H04gJheqtoi1MK4XLE58DEluLUTVANbZ3cLEmA3sCy95XG0uu7CodJC2OcG4y1fU5BbNUiUmHO0Z7bpnQx7kb2V2V+i3bkjyUGlX8TNsYnWMQx4qSf0peKCWgb2onRV6J6V2elWQ2nGPh7jipCxUGdYu4W2jkhkD6J2fJva9RV3YTI6e6UdOh8Wek8ORDAEWWxBFoVDmN71qbp76VaJWaC2Q9uaGoBro/a/o1pEScsjZKWSALOH0eTI5jzlJJbmi3WhmYqo8WEXFXq4y1oHG2uYezCVOc4G44VDcyrM4E5ri+VPqyceR7r9cprdOheHy28TQrGQ4zYZtAr0Y47IQDOf4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(558084003)(66476007)(8676002)(66556008)(66946007)(8936002)(26005)(86362001)(36916002)(4326008)(7696005)(52116002)(55016002)(478600001)(6916009)(6666004)(186003)(16526019)(956004)(316002)(38350700002)(5660300002)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7mDMQ9YXLNTlEwysNgwWsGP4jVWiR0ot5kaFWE4IDf7/IDVzYNnAoS/9tQXO?=
 =?us-ascii?Q?XeHGMpK1UKwMU7pttx/W4tdAHyD9CcGcJEB+/pfqpQkHF/7odPdhs4QekejC?=
 =?us-ascii?Q?Yt3B3hYGMGN15wPePN1cUJvbGp+L90GQWbJc4BBCHef0cojWczpOPSnDCtHj?=
 =?us-ascii?Q?LDU9yYP2aKEAL3aKHPFHVq54sFD5IfG3M3GBN2Ya5Q+Mkf1bOdGiqb0Tz+6W?=
 =?us-ascii?Q?IlvsbL8WwjQ0ogALSG1Y+yDKKvvrRsqTJjC2XQ+AyglVZV0TOdPN33cGmm8A?=
 =?us-ascii?Q?f7E1HJX9Um+H2+80/TpnsOvcCbUtS74kbc/npuj/J+le/HMwUGg5d3gu2+oM?=
 =?us-ascii?Q?PmYsflH8Eu/KImuDrMjAf1WcDMRdAvKVwG1tht4D6d4+vSsPmR/QiK5OUwHD?=
 =?us-ascii?Q?j8UPsu/ArcvkAvh8spQzLAqT3PvRFXEERPJaI8Wjzq6XaXWa0XH7T4BlGcXh?=
 =?us-ascii?Q?PeIdVwB+QPjnUHkHJy4xxRuB1hms2u9/VCS+Qdd+J9QKZES+PfXK2V2KORag?=
 =?us-ascii?Q?slmWIam1Yr6eQH9i/2ihsyLDGGeKtEF7FbZFKIMYKk0375bjv21kvtF5e/Ab?=
 =?us-ascii?Q?/xYQpzGvQpnnHh3GG7la8qiOJ8GZ7ezaqS1NqAbCmxzoZxu0A+S9oTa8FVU3?=
 =?us-ascii?Q?GgkrB2QDLFVfz3QRjCO6sV3xz2IM5Ur1uWyCjvztqMIzVMN9ItUeo7fo7Myc?=
 =?us-ascii?Q?LonqY8tnXJ+bi5Zk+QzfCiNJ1nk5R/v95y9CYWjnCP63lajGW8OeI8PCNdld?=
 =?us-ascii?Q?hoThWxmqI7nsLYctFn5IjtOKlV74MohFMoJpTZ/pVv3pxMGi0RuDFXeK2fyU?=
 =?us-ascii?Q?+xbY9/jIZOlflISHSaO1ZhZr0D25KFZZWZKn8XpVVhbHyb1QN5v0qwAmKYdJ?=
 =?us-ascii?Q?gEsE6MWHyaKegazY2U7keslyac5BtvJnfhpVm+XxF3VQQCc0FRoWktqWrOPs?=
 =?us-ascii?Q?VJCxLky0bsgSnl14K9EUBd0RLqb/j0ucmXlTK7wXjS5FdWbNnHDjKBMg62Z0?=
 =?us-ascii?Q?eO5LEOAikQyzzZwUCYCJQ08qp4+ZxsJ/YezBZIiJOTLSxOmZ7fvQE04fv0zu?=
 =?us-ascii?Q?xRDBZ3L43ZT9UEDGfoVV9DbKYvYhB9GXl3AS8LOqDCO6YzXlB/fijrLRsCgm?=
 =?us-ascii?Q?Lz5ASY9g974IV5OtrfzdqR27S0nCgmA05wc4QKUCNGphAxLG0tHWGCDLYjVH?=
 =?us-ascii?Q?rQ7uwKlAMLip1DR3GkQQVkxfX30A+55meF2d29vD5yxtBtS+ZxruhaxKolGV?=
 =?us-ascii?Q?WdLjj+uAN0EwVqB+E5+K86Op6YTeKnqbIeR3A3c4/rJScAa0AFn+iJGrzBZg?=
 =?us-ascii?Q?0rD0+pOkRKUPfxJF1gqumKCy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47453ebc-e6c3-4216-546a-08d932cb53ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:38:31.8199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WjiuPPTDTcrZ1YjyL1eb8+XHZfFAKobFg8xBiQlvuv2ZIDsvcdyqjZ4s7q1h0mySaVQpbBmgFiC1j+a9JDu61nS2sJcaAmlX9Ie5boB00ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=978 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190011
X-Proofpoint-GUID: qIbQJ5ROKD5_b57lNy596IGWf2M2Cfr4
X-Proofpoint-ORIG-GUID: qIbQJ5ROKD5_b57lNy596IGWf2M2Cfr4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> cmpxchg is being used on a bool type, which is requiring architecture
> support that isn't compatible with a bool.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
