Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD601C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FCF64F18
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCSCWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:22:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbhCSCWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 22:22:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2KwM1186138;
        Fri, 19 Mar 2021 02:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=joFqwkaf4t42Tg7i/WCL69Qp6qtFzyggVDwbNRdzTW4=;
 b=b2XooQY7ETlaSCn0J3ZxZ9bZwNTaa+7MWwpdF/0lXiwVHAaX9oiu12ayegognHG0ZgjL
 oVtKmJmRia1lfjML0NJabAflWaGQSFUlY7r5ylNwHjK1x7okQXYJ96dVmWoREp4mI6TN
 1nk26kEjOZ8Vi8Jrtfc+st6PaQ6C7LvpJOIR3dTiQ7TwUNI5TFmyjlVQN/H3oNqvQq5U
 ZyPmjNAl8dJKXznrMnEsfA1jKHuVgtyt/6QMA67tNHmPtnzs5IojdLuyZ/5H66t0DdC8
 g3GMrcHqY4AfQ4aiHXaHfScLt5i1AitM3QwlGzMTxTvOVL2hWoox8pl79T2EY6vt4B2v lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1p1cuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:22:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2K6q6195361;
        Fri, 19 Mar 2021 02:22:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3020.oracle.com with ESMTP id 37cf2uxrwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=altvhdGLkeEaTlezoOt6lL+CPyMNurRmO84HOvh4Q/KkKVGF7wejBy6K1t+6Y+hJeGdaWiL74vxmJAcN+qpEBqJuBpY5mTZC7PLILVXqg97MBxUPs3UfRJU/Svzhi6DZVRd6Ez+DY/pLv1+FWK04gt7QY9bvBlh/aisdamRlXSsmEE0Ec6PJRMdwC83MFbEiAvBCiK06c1jXIbh/0KTTBfSRr0NC9D6+n8br40Gh3ofw6PS2MUOOLt0P0C7ZodDYLIQ2chtf/VpGlLM3qV2F6YbKTGdH56ghBw5WnvCk5mlXcczH0s/rDoz1sW8rhK+lT97gT0m9X1H5BjsQqnE7iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joFqwkaf4t42Tg7i/WCL69Qp6qtFzyggVDwbNRdzTW4=;
 b=Lc+cROlUAzUyrOWMqOeOq1l6nrGXUe3RvtGxyyhP57nWTfhCKNXOmXiyQo3vGHc90+XWCevHSWAvM6isq//bFikitTNzn7q7L5LOlZjWbdPqCveDH+g2LJz2KYZjFpMRfQTVG1K/k1UK57q21JG7KXonu0IrOwk7v6PHQe0hn+7lT3Au+OExiOQmBKVQChCEMMbvHTKVytM6u0k5yd931LmMeAz2NiYEs5D6QYzV1Br3XqRNr96VspxdCbMErRsdE6dJKpRUrsvcuOHzBLpAnSCjDkRhxwYJMo99fzsUamokwHmOy9ROh8yvOem1YGdI32xyEl75LJXSrh3d15yMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joFqwkaf4t42Tg7i/WCL69Qp6qtFzyggVDwbNRdzTW4=;
 b=JxOlA9ZblOWGmM0xvpAVFC4g+Dh/SC9XPx3hsMAO6AVsV4gANEfpWqvlkAqVPBbMDHtiIPO5euwmscyo3VtrQW89gKRM8Ou7O54MDJdsg69FL/KEGo3zj6MdOezfYxQHKeFs6DBrX0PXnsr9zfgkp38YPCskEA1ISsEJ7DJb2fs=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 02:22:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 02:22:01 +0000
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg4rq3xh.fsf@ca-mkp.ca.oracle.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
        <PH0PR04MB7416236DBF6578C221CC65319B6B9@PH0PR04MB7416.namprd04.prod.outlook.com>
        <yq15z1q36eh.fsf@ca-mkp.ca.oracle.com>
        <PH0PR04MB7416ADF8D9CC7F0600292A5D9B6A9@PH0PR04MB7416.namprd04.prod.outlook.com>
Date:   Thu, 18 Mar 2021 22:21:56 -0400
In-Reply-To: <PH0PR04MB7416ADF8D9CC7F0600292A5D9B6A9@PH0PR04MB7416.namprd04.prod.outlook.com>
        (Johannes Thumshirn's message of "Wed, 17 Mar 2021 07:45:35 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CO2PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:104:6::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CO2PR04CA0091.namprd04.prod.outlook.com (2603:10b6:104:6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 02:22:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5ba962b-f9ac-4b23-2443-08d8ea7dc773
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760673726061951ACB9058B8E689@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/abgqO55YO5fMJV1W9ljEvM2G3op1eU5u8QqXWqpl7mOPEUDgODlgk+7G4YPmlP/mg/blVubhr8/Ktp7YgusvGdTwno6HV1wzzJENxgD1PiMa0YjZ9bvQbzJUplTtGochN+/uZ84OK1A1rX15TGE9Fzl6Dl89+OYBLR7ZyK2rWY9HBXnY/vkaoiZ4RZjeddzL4yUX5dDIqnRaTwCI8qTlWiGKs4nuRdQhINPz2aqvriXYW16+55PGrFyNoH3Vo6qVrW9KWkMZF7mv1Y62+UyLw7dfbP1piGQ7eVdqHZuFllKwzmNU/qIuqu+ts2hG7Fd1BQwClbE6LiP7r2X9HoL3+v7Qln0I5wXEpsYCorg/K0maku7DIzz+aXRoIy0GLaY8cpaIN+7KdpCFh8rY2x+N959P13HchKaNtoFTK0Jlc2cndLoGkbnFQNgFhx8xBPuDux9yJKAyhvuDSopbRheujQObvZUcOKRJ6nsy4/sb4sFYnsWHWNztb6FQtBSXPGdJlKVAOp2lKxRnrl7V5gXT7jcMoTQloB1BfXRaqCcILrWSvcl5gjXTmZPZX95e3WLucJ9agJPJ8CFDTsPjjyTleiMqNyaDHxQ0S5BgZ91U9wiAoxl3x/wa4XWP3Lrdru/GW+cHHLgmeNKSiZ/iYp0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(366004)(376002)(39860400002)(478600001)(16526019)(186003)(26005)(316002)(7696005)(52116002)(956004)(55016002)(5660300002)(4326008)(54906003)(6916009)(6666004)(36916002)(2906002)(38100700001)(66476007)(558084003)(8676002)(66946007)(66556008)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h07M2U2lcUCmc6JHE5F0Nvyvadrhq5YaS2u64VXtQLQuLB/E/3kgyeytLU7U?=
 =?us-ascii?Q?SMwi5Fx3nlh0ehJfFRNwAZwKuFKHe2ucXlbZECQJ84wsdCcIG3WfuSCRLaW7?=
 =?us-ascii?Q?951BCGUTHMngEoF67v1EWhxRtwE8E+j4KHDUWNRHo3JYECUahmwBPbGlWhs5?=
 =?us-ascii?Q?FCXcJ+hbMyIULDpdiULIQFsqRG79DEiiTdTC3m3y1fjo8JdzEb0MqKv9Pjo9?=
 =?us-ascii?Q?S9V1HzNfunS3ArTUJBGLvWUHQSo15CO9w5s7qDHYPo6TgEnaDFNgAPoPUvTR?=
 =?us-ascii?Q?APhssmoTvIYXuo1ZrxOkJURHRiLESasj5W8tijsGpjBJjcFjgL2uCkakbdw4?=
 =?us-ascii?Q?T2pTsmWAizpZLr+r5tNIx7NpH8oDcptdl5hknS996QRrlLN2e4exETUCR/JV?=
 =?us-ascii?Q?BfY+icwA4nlpND0FTCGB7i8EpSLUylGwwsjSSmA/S4xy9Z6IMD1tYT5LIlIL?=
 =?us-ascii?Q?kXbSvdNYHSTIWLwu7xISFHm6s1v6hgyDQz4LCjWur6QMjCRAGjiotJsn0lm2?=
 =?us-ascii?Q?RvvRZFo3TfDTYJXED3on4YGfQpvXTu63RRjj0IJSPZwU94DRumq2PfO8+ffG?=
 =?us-ascii?Q?xZ6S9HgT/cKzUrJWZfEnqNU3fBFCbJ5ZXUtIarLrglrv9LI6OLZkjQAyiyXB?=
 =?us-ascii?Q?H5lbXOHMv37BnlYptnf2SeVvOOm+UrdZb5NXCaut/MElP18nFJyVU5W+x0XT?=
 =?us-ascii?Q?ygIG+53QK7glCD+wtcwzQTcxo5yM5zW4OTfGwceTM6Gtbv9OkoTrxz8o6+N6?=
 =?us-ascii?Q?0uXf/l0bRHM+LFFe0Xs+McDQptarE0FZRLsY8ZwHMjMGA/4C32O3ZgsIE1tO?=
 =?us-ascii?Q?SxNG6C5WZTxoBduDCaa/bA7vC2HJYQd3hL5CIwbJwkLRYfSrhLdMUzf/uwRb?=
 =?us-ascii?Q?hf41VUzcS/xUyzLOmswZ02SDylW7oOfLq8sPgcEPrHuRg7h1twuaLY4t410d?=
 =?us-ascii?Q?fxz4Zw+s/818fl5TCasAbTB/v8Q/Bo9rJf7rMbvzIED9V1jODqvqwEFz1aiy?=
 =?us-ascii?Q?xt9jOlzuFX3O09S1sWja3qUQqffpNi5Z8vbzkvViRqGbNA1I/tPeiU9sBNV3?=
 =?us-ascii?Q?sepU4lxFk0LHJrfjKPqEIY2DH1psoGHyXWvv1N08L9zwUzXGVS63WS04uClp?=
 =?us-ascii?Q?2uoQWtEbfI2lzIB3AysvckdRqq7EZDW1jwAXowwAbrCC0PMzWG8piWgeeiC/?=
 =?us-ascii?Q?7h51p4Jv2xqdaynPz5Sikx34MPuUWZnqP9CJJDMA5FSWzezaHIw2vy3fw6tJ?=
 =?us-ascii?Q?uQfhNxya1ZVLcD6UlB75WKSzjj5QKD3+j34eGQhishzTO6mzaoloDLBfm28z?=
 =?us-ascii?Q?UIIJdWlyxt5CvijZEzB/sCYp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ba962b-f9ac-4b23-2443-08d8ea7dc773
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 02:22:01.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDhX+M9p8elYsFsg3UrESUV44ZL8+tV5EHsVjBPZWgOP+g/nANaybxCVN5bmyqVlh1Hlw8NHAr0RFinlCfjBTm8EDfDG3lhY1IkVEDrFgAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=875 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190015
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Should I resend the patch with the Fixes line applied, or can you take
> it as is?

It's already in scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
