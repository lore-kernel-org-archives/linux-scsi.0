Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D055C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 21:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D083D64EDD
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 21:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhBIV4J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 16:56:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbhBIVQv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 16:16:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119ISwgu048110;
        Tue, 9 Feb 2021 18:41:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gpoB7DHuhY433e1PAB8AA4J8nj9nuM/uguYhXdrQylA=;
 b=oechpnzaCut53tDWf+GPIl1D52qdycZgBRLmoIIVdsNCC1YgcwULAjpAvBF3DTHDfh+f
 NZTr3j0Cjqqmyzw0AqzP5cPdjhovUlgB0c0gQ+GlvDYcRz80adJvMTgd5+pJHK92CPFx
 ctxpVpnRTRYtWMLshiwcTSMXo4JPME6ViYT/rmCJ+t7PhVEavnSsjjYkCO5byhGqDboQ
 QWBsFShJ/hbKY/E+nyBd694SQjfLf+1QpPhs8251ClUQfOuDrTSBNyGHAJno8ymMrtxo
 7AMV6SEzqiLnnh2rhFFWXj9QozlGXesmtIcknCMUe3MB1LI21gRmF3tPeA88K1PUqG9i kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36hjhqrmbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:41:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119IP1RQ093972;
        Tue, 9 Feb 2021 18:41:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3030.oracle.com with ESMTP id 36j51wg42v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 18:41:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWEGNjWiNVMCDyMG107XkspO+rfRq08YYdn/jkUVXjqHZ8W7NTBKx1YP+qGfZ3QPu43PwyBCZCBuyP5U0lDH5i8UX7M3FbcPz+rMJONWC0yVw12wfSwle/8S331jTfl5CyZq2DaeYcCrViRqsnK8+O6L2Yym36DO78lqOiFLORB61kElijQ9kgDq3P1cHUJsleRJJ8UdDNhAE973UHDYUsPWb6hOvZIzmPfE3AONTFUrCqJsrrJKd3f6bmWnfQiwBHKcqGBPTxK2JS9paUFszW/qj0p3byagBcL1ZJhkrN5CtwafzQlFci2U+xJ/6leaMrgdTbBlruZqDEcUU5wTpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpoB7DHuhY433e1PAB8AA4J8nj9nuM/uguYhXdrQylA=;
 b=dgXm/UKy6W3oKhtxjKW0/7wnsiHoXxcRANJZPK2hA8kRi/RIxVWQ9x6zwK1tuLacBZorhrjdtyne4r49QsVm469uSpzqBeJM7nAcPKSLGq4xxnU9UX+zgvm5eiAEtilsznFhejnFVemWtqGwnWyuUoixQxopQTuA2ofQyU7ikkM7+XhZRfvXM2TbW+Dq/fOhwm1F5n4kQ5c5octJnSz6k8X7+CPjKaQwzQQNbei7aOYhi8rWuSm0mI0OxPaJ9t5gzKwmkDlCqzRMtuvw2w53YJ2eSIpEQVEvVXSTlxuyFAM65OteisbZzgCyzIpqJ+qP3JJi4hLlLaY4SDlJzeoJow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpoB7DHuhY433e1PAB8AA4J8nj9nuM/uguYhXdrQylA=;
 b=e9m9NJDDGE7l4O5dzFoskU4BmCTY6YDkQ8Yoj+P8dzdDevBNBZJ7hNRUOWIks0AoHSHNZT/RXxrHTmDUmjpkCkjMXFEZOloNksL0pvnpxCS1OAmnRi/6rKT5JDrCuMYPnT4Vh6Eq8lNRKzfCEbgybUST1qeYN8695H3JeJOZgbg=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4195.namprd10.prod.outlook.com (2603:10b6:a03:201::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.28; Tue, 9 Feb
 2021 18:40:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 18:40:59 +0000
Subject: Re: [PATCH 02/13] target: split target_submit_cmd_map_sgls
To:     kernel test robot <lkp@intel.com>, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     kbuild-all@lists.01.org
References: <20210209123845.4856-3-michael.christie@oracle.com>
 <202102100043.iwcq44PC-lkp@intel.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <0515e0e3-afac-dc0c-32d3-3cbd687ee5dc@oracle.com>
Date:   Tue, 9 Feb 2021 12:40:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <202102100043.iwcq44PC-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:610:4e::32) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR02CA0022.namprd02.prod.outlook.com (2603:10b6:610:4e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 18:40:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a263ff06-9acf-4ec2-3642-08d8cd2a3e61
X-MS-TrafficTypeDiagnostic: BY5PR10MB4195:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB41954E284988567DAF6EB7FCF18E9@BY5PR10MB4195.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +vPiaYA3Vq274qzZjKynp2mAbjcFWV0IZsjsbD7IGpu/r6yFtCWXeOWxvY4DYkABFWltHDdd7dtNICMUp7gKeBNbMoq5SeqcxAwMQYY+ILv32Duo2dz/mbVlwWba5dWaXzZsuIJWctFJmF38IpxZ15P2xRUzuMDZouI3XTDysdoIWhF5QMuAOUu2TqDfoNKXXj9ytKP7LFvCdGYGihJBb8xuB99UoFJN2oY94iv/gR3GYr07NQNmDlQEEhiyMOvelmhsJuuJd6aoAdZdDdMLmiwENytlvyeE3nn3+mJNKRC4GEjSqdTRKScmpd+Y2J0oXgc1y7a3oAn2jJaeX6g6PizJcKcsTaVvRGo8W8pQNtRwIf2xdUABKnnPrQvAj8CJgLBKqD6O12R8bBMn5ab+5lXIN/YInavcN7RtpdtBWMMVeVc2lJ5jwe9QEXQHfbq5e2HgSJI8eHG6Nmf/j0nUGjHNN05k9N1nL1m9ljWMg3+atzOR7rNKQ4iUZt4g8wnvt+Kcn8cIT4SgaCO7wzFIhEm6SIKvMbTyz12oM1naEu+z6pGZeOEQ6RuLNdf3p/Wh9UVqFmR3/cGT/r6wD2f7/oZjij5gWRCea9HuZ532EFXQ77SFQMl/bXWBoYcAot8F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(2906002)(8676002)(31686004)(31696002)(86362001)(26005)(8936002)(53546011)(478600001)(956004)(36756003)(2616005)(6706004)(316002)(4744005)(16576012)(66476007)(66556008)(66946007)(6486002)(4326008)(5660300002)(16526019)(186003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?/sF+f8HpAdmMIEGaY2XgfZfRLJWIj8DMDj0cHaxu3zty9YnFzOw3Pms2?=
 =?Windows-1252?Q?+CVSGVcKdwoNJF6Osrl03Rkle564m65ja/zi0roxLaSQOpGjpK7gUFTY?=
 =?Windows-1252?Q?5ZAX/m8E3BaRM6pfYFZkN/YYSxHJZbrfm+OW6GMKvg4Suyf3rqOgeSWy?=
 =?Windows-1252?Q?KFPmqOHLKWBlmesaVUfX0yYgZQ/4cQ4e03V9Q0FaWYX9J/VwJM1NydFm?=
 =?Windows-1252?Q?fjnvGNYv7h1wy1IxJscNy/X2yCpMAm0UJP5iJvGLOTO3cjWbD7ztfBCJ?=
 =?Windows-1252?Q?OduCmy59wuiz5S1ZR65JN5UGActz+qjBxHL5sQjCEk9JoDglzE5df8gx?=
 =?Windows-1252?Q?mdV8OuYbOvINghf0FMlFk0jxc+qIRvixK2BmMddVCW7rYywYfcia4KKs?=
 =?Windows-1252?Q?7zA/SbpUEbwBlOocZLIVbW544G1lNReFeVGhQ6Q5fBSvhXoq1BNI70x2?=
 =?Windows-1252?Q?Mqn7UZ22y1kq05rTVaxkEsbFZtFx2n64lfny28tKIJoLofiTstgI+RFX?=
 =?Windows-1252?Q?mGFaDUeBSR3ZycpeQf2JwrTV0Ma9kbadQ6cfbMaMhKI+F31AuJE+qaOV?=
 =?Windows-1252?Q?34SvUixAbwjHNPfv8vT7iFtecF/qgiXIyR9xf8C4KdE7dmHN/xsoUn+J?=
 =?Windows-1252?Q?t6sm4bB62z/VLbntlvepjwZ6W44UljZF8Q5Qir3jfSYGQk3ryblJYe1D?=
 =?Windows-1252?Q?+8O3Bz4suVRz5CcvNfqCke7QTArFLHj66UB48JjFf8l3WM8PE9/P2k/n?=
 =?Windows-1252?Q?8rnYi+Z2qKF+iMwvl5tbr/ftyC+912BET/HYUTZL1uBxe7Fnk1y1ihlq?=
 =?Windows-1252?Q?uJZodzObLczchj3QTFKWzVrz7gzUwDBZKk+7/5F9kWyV7WmC7brb4Jb5?=
 =?Windows-1252?Q?AzsNyVgljU3C8l3+zxxwHpUb3T0He2xyqRMu7bCvgcar3w70yHPM12eb?=
 =?Windows-1252?Q?oUDAtGrh8yZujm+dneaFWFuBwMQqHg/YQhze3/N2t7FPL+eKzVkeRDpP?=
 =?Windows-1252?Q?GvkLqCRmRTkDU5Fbu3gA/khVjQ7HN2jQcbqTQxklLZsb1kt/geZoou4m?=
 =?Windows-1252?Q?HBU1iFMvVofFnpeknczV0T4uKsfr1vsAIFyZrsTXI/IN9JzhhoEpLu6I?=
 =?Windows-1252?Q?a+bfT8TRHciBSMessYbPerY4+tI8MvpP8TX6anpXjNThp/cDFf/oecSX?=
 =?Windows-1252?Q?BkrjjCrauwG5XlLzLmM5/EdOxnryPtJi1IDs1xRklOuOkurmZUBho8U9?=
 =?Windows-1252?Q?xAy3uFr7fmHhJoxZGXlT/bv6P5D7zP1n21RsqkVPnIMLY7iN9myAOK9p?=
 =?Windows-1252?Q?9/R+XBAooS8nsco8bw5YHxQpJMa/yUuC0YCKbL+o8czwsfwgn+q8vXnE?=
 =?Windows-1252?Q?3aviisHGrNP4hhJXbgM91GRKw6MbAhnMKzKFij5Jh/Qc0wSaeyf+m4Xu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a263ff06-9acf-4ec2-3642-08d8cd2a3e61
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 18:40:59.5282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eJLIi5om865I4ibJBZdGkFJSG1e26tusrN2pUaRBj8KRpB455PUH6iQ0wtHDV7NguUvp5wDtJh/KpBOnwEUTnp+yCrhmq15Q5OgPkxTvJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4195
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/21 10:15 AM, kernel test robot wrote:
>   1682	 * @cdb: pointer to SCSI CDB
>   1683	 *
>   1684	 * target_submit_prep must have been called on the cmd, and this must be
>   1685	 * called from process context.
>   1686	 */
>   1687	static void target_submit(struct se_cmd *se_cmd, unsigned char *cdb)
>   1688	{
>   1689		struct scatterlist *sgl = se_cmd->t_data_sg;
>   1690		unsigned char *buf = NULL;
>   1691		int rc;
>   1692	
>   1693		might_sleep();
>   1694	
>> 1695		rc = target_cmd_init_cdb(se_cmd, cdb);

This is a valid issue. rc should be a sense_reason_t. I'll fix in the next
posting.
