Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805A8C433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55E1323B5D
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbhAWCq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 21:46:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57762 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbhAWCqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 21:46:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2jYqe001959;
        Sat, 23 Jan 2021 02:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nHdTlY+rWwWJqLQtdoBtcvNMCNYRBzTvhTa2EuYYUoM=;
 b=xaO6xjaV5oGF1AgSNTYMbDFlcKXuGoFCG5eqGzVIhP0o33e1LGYqDSGSIx+giA+hdDTq
 eBc/bPfBHZlc3Vlt7OJ0I/l9CFQ1X7BXUV0YuwMeXnMbJuylWdRIW7Q4u+dMFBY9miDC
 Kbc0wVpM7fL04wyEDkXIstDTv2ETRBtwTkNRTAZ5LsAKO+X9y+S7c3Fpvn6mz7CQhOeH
 T3x68/DEn7btrzop7Sg/jcrTKletLwOKqU8kogIMnOpqxyWDcWhlX0ZshRNZwesxMWyI
 LeUHZPeRfNyIwbYRTOeCtqxfyTqDN5ksy5KnhPY+X6CKxQWtTDVX1T+Zf0QVC5ndEb68 dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7qg069-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:45:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2Z0Pe161143;
        Sat, 23 Jan 2021 02:43:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 368b4gr57u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:43:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQtyjVpaqM2fHwxBBQxLCyq8358nlKOwRDA+hDxQAD7AD+wpayIoCys7LjzWHdqrwMTVC8bvRkR4HRE+Zo85XUUq2ueuZI4nahxmmxrTLIDt5a+Xq4dvdMZkMfwM/0SKmxnQpaNzdBFo22h/GKWzYOM3HOdyQphA9xcwAiPKExV+fZuVsImsHfNisbgN5eZ49FFOhLXH1YukEoHyICxcP1kmw7pdQb78jk26Y5iG+p48Q4ChJ7ZN2geAkD1uJaJEKPqjtCfq8yzXGrAL+8so65whtmLXemcbo6/d2M9q/UxpKiDLgVLP3ykC6P7g3/jm+yAH/1F4mD/u3Jv7TjTGDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHdTlY+rWwWJqLQtdoBtcvNMCNYRBzTvhTa2EuYYUoM=;
 b=WYM5tTe3GOzqOprWLwev4/pRfSYveg30L5iwRcfdsJPJ9PVjp9mrLU4yRaqYH3ogvRUAbROtyGgPaMn5EuZlj6aTvOb2ZaE1qlc9sw17X7BVVteWfo0yHt83GFG6tMOWA31578yWBtddZUXqMIGms4Rm6KAEru626I16tBx/W3FdY3bfBN5PaPEuYUkKpFvPhsZ05MaTovswD4U0/ARTiboqDxqGGH35vHgr6zs13h98bpGk15bs5z/aEPwzVZrqpkW7l7uy6z/oCc/iZAYDOKYPbIm8WO/HH1LlU9xkmsZqUP3yNuUHEbVQVXFRMZ6WtkWLrKJAWtgQGCwLRCRB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHdTlY+rWwWJqLQtdoBtcvNMCNYRBzTvhTa2EuYYUoM=;
 b=gpeEWJXJfUHBm85KmBp9YNySSh6J6Id2MHT8PWrvnCeWnatsXPY0nhWzToWeGrRq9JHJjr70A3Aj8f+l8+0utOz7PBGCHUZybd+CFeqqd14uuWxppYy7RPfcQLWZZsIEjUF3PKvvh06WNwvKTPPsFYo0gug0rXfSQyTVPn2JNMs=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 02:43:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 02:43:32 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: Re: [PATCH v3 2/3] block: document zone_append_max_bytes attribute
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtx0bcfs.fsf@ca-mkp.ca.oracle.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
        <20210122080014.174391-3-damien.lemoal@wdc.com>
Date:   Fri, 22 Jan 2021 21:43:28 -0500
In-Reply-To: <20210122080014.174391-3-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 22 Jan 2021 17:00:13 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR18CA0066.namprd18.prod.outlook.com
 (2603:10b6:3:22::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR18CA0066.namprd18.prod.outlook.com (2603:10b6:3:22::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 02:43:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a47747a-69eb-49fb-8e90-08d8bf48ac28
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45367574CA95DAD13A418DF78EBF9@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9iCU4zzeYzpY5iq+BW6Vrm+GDWh1yReGKhjuwPYo03KaDUXcVFMU3pR+4Hgbyl0+l/LAh8G4DGPl2IiFuAIIp220UFx5Mb+JADJisKsvNZEC41ojBKlFakBpAM7YLk5DfhDmsbpmWdhqQT0zrCmX+NuE3WIqIypMGRHhte/+fzfUk4fblxcd1AzcXtBbGIc+arng5rtZuLQN6GY1kw333hJXU716yRBZhvlg1svHCbAenazFsdJuYtrPeuuwr5lLSq7Z3Lhl/yfQbW8EkYFfAp7i8oLU8uT4vAhwIRt+vVrx+rhyTznaZh2MzfWqAuLqHE/1XYRTZlZbFKdfFUUZM3fsttqU/VRrEJ7doSbBx98Q9d4akVOeAKXK79I3V93FbMXkKjgB4cM8w0uaE8HaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(36916002)(52116002)(2906002)(558084003)(8676002)(5660300002)(7696005)(956004)(4326008)(186003)(16526019)(26005)(6916009)(54906003)(66946007)(66476007)(66556008)(478600001)(6666004)(8936002)(55016002)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?97DnGy/L5AWyIwnaOy9/+KD9VAnataXEYdd7fW+zsJ4lzJIJ5cvnPhniX60m?=
 =?us-ascii?Q?uFOU2d7KbBIRDgGBBwRrLOWTjPoavKZnXqvTdomocQCAG6rGNGgVPXldgPS7?=
 =?us-ascii?Q?68gois12C8hEnWT4Lg8RQYTWqZ1uBOY5yNilJd5l/w3sPtFPofwOQ3N3BzI7?=
 =?us-ascii?Q?fAjdK0C07aLMMVmhY6YKg3Pz/Ip0epbu1z6xmkbllehuAMSH2F/3kY+6MSBV?=
 =?us-ascii?Q?IOpyCdDwhTIwMqIq7gYApX3+R23K+5msc2BAOR6iQjBhAuUR/QyfbG5HePFh?=
 =?us-ascii?Q?W7crV6+3bZoTM812yZhHyQAm0fiOuzhzFuHdAT6kZ7ndSVEbfuqg35Lr1PU2?=
 =?us-ascii?Q?N9vOLPhHM90euhsxI6wwPosWKb3Fa0g0QzZFCMlEusyLLCvfMM1YZaxl5OQ1?=
 =?us-ascii?Q?gaIgdgBtR5HEgQtBP5kSvzJJDRNacwdVMp94ka6XuUSZ/YxujtTREScmgs3A?=
 =?us-ascii?Q?pZlJYBS7NpLyV9HENTEO3mQZinhov9+rRrlm6mFXNPxyxV+QcE4JZnwW36hB?=
 =?us-ascii?Q?FkNVoPBkSn6zj3mlJMlLhI9tc688dSMcyDkd7QG1qB5lBEBmQYqQTNj+VxYx?=
 =?us-ascii?Q?NcyG7XkjbudXZWkEHSoSfep/8NLn+8KlJdbg67L5hP177Wa5zEKXeyV7G9/h?=
 =?us-ascii?Q?Z1tzQ9FDJ6eFul+Q7ZKyJXMErddLyiUUoBe/cSEhK0oZ/BusyevvNQRAjl33?=
 =?us-ascii?Q?6G3Xp75QnIHVl/E6yUV5JIfY2CJ7r6z+6C8zXehGUev6iTbt37zdfII2WgN8?=
 =?us-ascii?Q?S4Xi2Dr7Np5smh8iK3OrRgWlCql9ojXm/eBCc/gn0+fC3jPxkyetXzRUT/2o?=
 =?us-ascii?Q?TLIhcj7yVnT35xugyZenmbh+ckObSydEEc+Qjy6Bd39GnFXqCHBiRzDetykJ?=
 =?us-ascii?Q?CxmGdd7Fz9Sq1LqcRJ/DQF69HUh1WDCRJY8yLreOY5j5tXfrpwoM3k/b7yK0?=
 =?us-ascii?Q?DQx6DraIdW9b5jlFkvu1MO0MMe9HDt+a79kRdTqHAYTMRI/GnE4uk4j528up?=
 =?us-ascii?Q?dn3mDa12DpWZHJO4PREOaeLa2XT3xg7W7rNa7NN0iJatu5b2rcTpHExz8Phf?=
 =?us-ascii?Q?jywLHWHw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a47747a-69eb-49fb-8e90-08d8bf48ac28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 02:43:32.0810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Li1gGUq12GZ0ku9ciMxN8Wef9r11FSVudS2lRIXyhFMM4vXA28gdYP39BmyGL/U/jSg3o4HhtOgGiyk3cawcpywfytA5xSzj4I4+w47CYJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The description of the zone_append_max_bytes sysfs queue attribute is
> missing from Documentation/block/queue-sysfs.rst. Add it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
