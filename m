Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97820C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 06:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596D420724
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 06:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhA0Gbz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:31:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbhA0DN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:13:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R3A3MK120258;
        Wed, 27 Jan 2021 03:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8AMnw/TPTARnwZE0kp3nyNSvZtv301hDjy2wwGfGe58=;
 b=r+NgD+ZK85MOeCsmdhAjDLo92MlwNAk4puvQqS9TLCLntxOWFPJttuUUWooGRXtS26yV
 KwOYhYGv6wenyQQ2gK5bktwAggxkesPEeH7pUiQv6k80HDyhpGspRZjEsnj5UewdO7iN
 0HBxa++YN1KOo9CUIB4eqF42MNS+aq+L4esd1MJ9PcjRgG3DA1Y/xyzBhoMUG8fDqRng
 exeOTbaAMgTXuFxw14rzx2BovN7vPT8hdiFRO4arEV6Z24sZGz+8bJ8qlc5ycQHHKJEZ
 UnGACZOE/dsK0RBUf0fBeltIqMPrB0x4jQEIfKY76diU1IUrrju0pde7i1BSP5TlWD0A rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7qw160-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:12:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R35eUB138696;
        Wed, 27 Jan 2021 03:12:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 368wjryy1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:12:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxNdsgaUAQhUE9iIx7q7I814LdHTd9dy7w8IZptr/mfko2lKCaz7BSWGVX/8WfdV49leyOKzQdb45XrDIy7kibu7MTiOqfSxAYXENn28pVK75ExZOWD/lrLUE0u4no/nqbmVAIq+GlqfdCv4zB47eVAKJszyKvEoA26vLfm+Pbh5eRzvNTyNz0SsTnCcxqqbae1NeVAObEQ8TGlHp8msLNaBOv4PtXFL11uMG2H0vfWBv0YylHlsjUI+11olcA4UFCNiyyPlQFEa7EOR18J7VW76sm4ZJ9UuxFUXTurDbbg9wTRHl9X+taU9QwnsDWWQhjJoGFkqgFUoKHbWRwUuxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AMnw/TPTARnwZE0kp3nyNSvZtv301hDjy2wwGfGe58=;
 b=RvR6ZYxpzNX7FlbhBsr60+vp/R/KCte4RRSzoKhiZYt58Hj1iU42D8dlEMrn3LtDaQZQLhZjMwOyr1znAvX7yvdAi9I0LACoT+IhIoNf9+JKS90Mb1uMD0VHMwcQYFn3cymZoRFgLB9+YMPrNOeLiy3qzlTdgRmZ6SmIsqn51OqDx+ZjuIFa/yB6gu9cvCUKpVzTAO61k8DX0MQYl3SXM8zll4p7QwEPvkcWo3IYwbhqBxlTfv28NyZ6lfm1BXlJs2dAdz0dCupAFlokpErlnMHFse+rWVvPxcl0YNuzcGQbocbNE0jQfkd81Oh9DLPWQUnkwxQ1QGsEa1Eat5TZhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AMnw/TPTARnwZE0kp3nyNSvZtv301hDjy2wwGfGe58=;
 b=Ksq0q+n7ub3KnIXCzeDdoCbXpJNDhFB+0qqn7V6V8NlGkLTBWQFeYW+uUgyVu39MKm8QtI5Ng1/hy+orkv3xwJM2EoAEvqUoZrsyEC2/drwvJGNgEzkTu4tIh5nUAV8rAqsxq+d+n3IIbHlermABWq3WA818Cci9u0zT/9BImEQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 03:12:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 03:12:41 +0000
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: lpfc: Add auto select on IRQ_POLL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh0vvzs1.fsf@ca-mkp.ca.oracle.com>
References: <20210126000554.309858-1-ztong0001@gmail.com>
Date:   Tue, 26 Jan 2021 22:12:38 -0500
In-Reply-To: <20210126000554.309858-1-ztong0001@gmail.com> (Tong Zhang's
        message of "Mon, 25 Jan 2021 19:05:54 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: MWHPR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:301:14::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by MWHPR1701CA0003.namprd17.prod.outlook.com (2603:10b6:301:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 03:12:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 196414a1-3dea-4c82-cd71-08d8c2716875
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4423EA89A5BFBEC422B70BAD8EBB9@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MBZQB7nEk9uaM8yWf+COIst+AptjuCpx/EmcUtvQLlYQ8fAbLuvHKWhRXkbrXAwBtmNqM8sXVHCKf1W2I2qN00RdIm2qUOvTY8yCBzpay5LjFOkPp2fbKue9gf1W/ablSCLJEklUDpzdoB+IL7/Df06oJTD6jLT9v7JS5ozLxNKAAPfGjX9HB5RMiQFGnDFRJgsNyCkGbm3X75FfhC8k0afy1L5UIxZlIRa5UhMGgAx2ofmjUIIqvEPttwQ9M4d1PAWc/VeSzZQqkd21EOr+TgSY54cteKkctoR9y6zGZW2kUD8FNWkw6hwztR2gYEznnuPF4wJmzMtO93P1+xBNfsGlzWvGsPtgR+0mdNfq0Wff6nhD3FE7Zs69w0RaKzcfdM5ZAJmPNqXSpSFii8CtnBZKNnl1c1jmxe8BGL4tWMkqGra8TQiCZVLV4OngAXN/u5ev7ZAmf7DXUhqcM3e6UwT7kd4XxiKvUmm/xB5sVosCTLMP+LlZaBcbO9l54Sky2YN1Jl1eL3YfZW5z5kRUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(346002)(136003)(396003)(52116002)(558084003)(5660300002)(2906002)(7696005)(8936002)(36916002)(478600001)(66946007)(16526019)(6916009)(956004)(4326008)(66476007)(66556008)(26005)(54906003)(8676002)(186003)(86362001)(55016002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tROrR4KR8+DbJxfTQ61bePtpzv1HGgAHBkD+5k9FFJddQgaCiNYKRRqtuxcz?=
 =?us-ascii?Q?hdCwC18p3Ots6NcZVPpKW0prRKwMHpZoxJIsYIuXYA87GND1MzI1rDclEssd?=
 =?us-ascii?Q?B/iVB+GX4VO2W/mHEKLcdU32Y3isK/XnBXEXxi09JUYh0xTiolnD91uxybGh?=
 =?us-ascii?Q?R4sOklccPQdKpWcX51eW9unQwvOw58lbeO7j2N6VLr8pLIKYdI5dkfuQTl6O?=
 =?us-ascii?Q?jAwuZLNwP3xspZvaKAOcWfycn1jwxCJ0ygaPMvNThhmkhTRfOkSn5+6u1+PZ?=
 =?us-ascii?Q?doIAwkUqXGIdrs34RpWvlq3MxtbEYRQQEx0BbhD9e8oc0THxZ3QIXmcKM4Zc?=
 =?us-ascii?Q?tS+C5jMiIqr2v/EQytHZbA46wLiQ2dtlyQ6qdoRR0PlpZeNuZ3ylmr+2YYF2?=
 =?us-ascii?Q?yE3+5c/YYhD6GHtJzgwCmkUzSh2Iv5EDMB9oQm5h2tB+V/edbNov5k2fJagq?=
 =?us-ascii?Q?nBXomyYA+HQgwMPkp705Pt14xjQbXlKgjyXb369Jbj00rAmeSy3w9ou3FKsK?=
 =?us-ascii?Q?t5qrjjnUkRYslZeLdGIbyOL8lzPmViLwrUCnhGxNq3iDNoRQ0NIp/yV2szp8?=
 =?us-ascii?Q?wg1zLLzVzy745NW/yS6p8IgBAit3iLPeLA4UVpKAQoXJjTyzRn6B7CemkDwx?=
 =?us-ascii?Q?BvN2yOsoDrUU+ngVUXid6DaKUJqXsga2ungtZx59X0kYtyy0c/BsM/PW+obE?=
 =?us-ascii?Q?nmhKkWiyQkDa2oFyipKnyBfomxDV2wKSvr3yiRC5c2U+nG17iwo55XQN3fuM?=
 =?us-ascii?Q?SAleGAC03FNwzJTGaaNeD7W1pMdbzugU678gA7F8dQVHR93dLQ5nYzHkdSEb?=
 =?us-ascii?Q?pHX0GCxBUgq+yvbkWFdJeAwH0QUNOD7UpI3zHcq1cIzU/bMqU+cUMgxzBCsH?=
 =?us-ascii?Q?c+gI9QwXuO0W863g0vPjBW2dm50jcUEvapnd8GGfuO84ZudEBJlf1chYxadT?=
 =?us-ascii?Q?H8Ql2GA1QvUTrhPSpWGF7A9tEhlgp9YVFA6VWwjAlCoYRcpXCQNWOKeQ40B8?=
 =?us-ascii?Q?UFpY+EkOCg3Lv2b/xndKNBpeA+XFkQmUxb/uShIPid14AKTD/u0M/aCOWtUt?=
 =?us-ascii?Q?0HATEpVw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 196414a1-3dea-4c82-cd71-08d8c2716875
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 03:12:41.3793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /PPVqMHPuyb0i34cj9MOKW8y26jhH7Hof7wsE1N1AtdItwOigY0r9x4oXFjMrmPzO3gajq2Za1NMBdRDgefkl8xwHCec/91N4xrt6Tm4NHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tong,

> lpfc depends on irq_poll library, but it is not selected
> automatically.  When irq_poll is not selected, compiling it can run
> into following error

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
