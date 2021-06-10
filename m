Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F183C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE88461420
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFJDDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:03:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57046 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFJDDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:03:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A2twHI036509;
        Thu, 10 Jun 2021 03:01:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DAbqP0w1sCVB+C8at7yvhIeKrVwHx10jlEVlWPPKkmM=;
 b=sIkCH2vp8JKac/g3DuH8Yy/viHeJZPfMZjVRii9boHsM7CtYvXrowpVDUKW+T61HB0RX
 vHiZweaTALvezX3djTibgJAWpniBoFP30VgWju962lW0dJbKbxZCE6tISJCTaAl4Z88L
 yFtSTY2U7PnJg4w50Dc9x9OLxSDiU/p7NWwVrwDzizViOykPLx4v/TpaQb+PXHk37liH
 zmjflmHA2HosPoffEQX8IDasppBghNgjPlgDArr+COWPJfZLv3tqfNVGyDG0XhjxXkZI
 IFPZfWUtvQeFpsVGmfcDHWWdjNgUryupb7vKVHapi3U7KmLo1JCnSNG3WJSAXNYbanhh xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38yxscjsbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:01:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A30Reg034686;
        Thu, 10 Jun 2021 03:01:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 38yxcw6srq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:01:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdJA4S5uL/pZS+aoei/eJf/EWkVOu7maIabhLGvq6i4+owRNLrqHQLcrO2GFVkUP7zsaixz4WqSO46jc3RO2PNnx0pUwDXSXY6OlSdCsXYts8G+O9j9NClKr0hYuIkUhj9DymIRrSxN6ZM89GSfokIC2WayS1YHzA4yLGpCPv/3GVmiA1XzoMpfxGr+G4ICl0YzDiQHyPMWe9C/i9UCGBhXgaezptTLd0gRkWXdFy5NtncoSCT55A/xhlFhXw8AJWKW5tr+WUX0BGkgKDvNJGAV6WVdEZkKQqwP8950mNO9aAR6tNvaq/gHoLL4T4kZF+0QlAfxhvjFDn+qpf8PoDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAbqP0w1sCVB+C8at7yvhIeKrVwHx10jlEVlWPPKkmM=;
 b=R15dyf7HYBZrlkP5QP4qvDYxap/Un8TrmqDdPYmBWFjQetoOK8l9767D2a24k3VxEi4vefzvnmbLnzzA3tV/WOjryPEo5Uhc/FPXQuYgvZicEVxsL7TCzqft95rgG4iBLv6D0cWu9txfp2aLNAd9KkKNByWZx+LSdF4IO0xE1Bi4MwWSWtjs46haYcDTbV+doBG9MkpRNb/RDMT0RR112ZsZmbc1w8abSr6eiBs9IFtmGyII4j/IjkVbibH/RRHsqmYzsh+hhOV5HQtcUwtOjT9ZdwE7XWc9uxJxRYrAsM8bypKBBotetXlWAthNPatCASP+ZDzRae8n40lOBGdC7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAbqP0w1sCVB+C8at7yvhIeKrVwHx10jlEVlWPPKkmM=;
 b=ao6DYYncsltkeyKu+LMv0C46oqnA8lVlVh+0PUQzYTldbGxv2NICbcntlbDS5iNOzQNPlqz7UCARAAHM2RWWpGUZhxtK+JhehIr48RhSSot1ZS5FPYDPZL+A2O1T7UQwCZy+Tc6+bJq2Rda7I6lbLESCtzxZ65eJEiFCLO25gM4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4775.namprd10.prod.outlook.com (2603:10b6:510:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 03:01:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 03:01:41 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: mpi3mr: delete unnecessary NULL check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl8eh184.fsf@ca-mkp.ca.oracle.com>
References: <YMCJKgykDYtyvY44@mwanda>
Date:   Wed, 09 Jun 2021 23:01:38 -0400
In-Reply-To: <YMCJKgykDYtyvY44@mwanda> (Dan Carpenter's message of "Wed, 9 Jun
        2021 12:26:02 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0055.namprd13.prod.outlook.com (2603:10b6:a03:2c2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 03:01:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2032c4fe-9e1e-4c1a-4656-08d92bbc1256
X-MS-TrafficTypeDiagnostic: PH0PR10MB4775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4775C143F08E8578D6B0C26E8E359@PH0PR10MB4775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxTpv1ebkcAQUIxSKRNaxLEzyeI7IEutlx52/DBPDXz8p8TXYRnxDhv0d7iTSQcDrceQQYEl/B9yxaCFE1DnJLjv06LXFE5jpFdR3GN5f6vhhvblOqRyfy8Hfq8yRG/o+VMJxFbRQ+7Rv7qk2DTjd11llu/+BzyuR575+X+rO7kQk0C2pnqMYXEin1wXKqmQ3lbA6cs6tQ11HHsvWsWMZNeOw7sjAABz8qjKpM/fCIni4h6I2mS9hudzZNcU7v1yb2QROkACHJSP8SyYAogUdASDzDIhvQYnigoDFDtBkSLQeVWzxzFHagbBQMZkTa/pSJ6KyOCJMwZcNOhRJOMBLefNe89xu7bxbUqrUnT41vKpWhV3avUVNJXV3l2okrkvt28JK+f3MCw2WG7O4nqG71187Bx3agg+H4R0VbatW4zs+/ixJSbZbA1pnB76RpBm6GTvA7Pj1wDzozBNF9SbbgLNSeN4mzUyVIMFQH6pRjUIkPEqBB/Q67Lqf4D6ZUJYNI3WPXKC6qYru3mEl15eY4iWId0Ji7VkwykyyFdGYPPGAJ7vsUgF0q++1Blvn4IuVGOwfQ8ohM45/WOFktc4SmigWgAmyuN82FSE6rNcMj/4QRQEhB1wrbb/H4HovQxxyvPaTE/hxiEf8k0z9IDqmorOuOZFzTJq/yrRQfKGj9tcjhRDLkvKlCPR5KFVZsGD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(39860400002)(366004)(6862004)(66946007)(86362001)(66476007)(316002)(54906003)(26005)(5660300002)(83380400001)(16526019)(6636002)(52116002)(8676002)(4326008)(38350700002)(2906002)(8936002)(36916002)(38100700002)(7696005)(186003)(478600001)(956004)(55016002)(558084003)(66556008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uUvlkCDQLWeL7QrXHby7bbLrwXMupezkup3J/l3KsldlxnwI+xJlrgB7RBnO?=
 =?us-ascii?Q?v8NqNyEAHS8vshisScHonX5daU5fO3qIsP5YGiO0P4lqyLe/bogEa1Xmqxbc?=
 =?us-ascii?Q?G9dIc5YmEKD0ELqVJCT292/eQVvY0tQTypbxBcOcoBCxq3i8Pqal1HQkL0kk?=
 =?us-ascii?Q?G3H1KgJM/N2Kvrl+xtde1On+SviB6PbPuWKig8nBcQQH7+G8Tbgk3L1Eha4E?=
 =?us-ascii?Q?QvuT0CNh021hpCjCxkzfgFvi41Bj4V0eCbcZhZkrCYDvY7sZlwGY6wKQFbdg?=
 =?us-ascii?Q?VMQDS0bsnOXqzQiI3Az8XvnpZb2jLLLpnVhp6L3YbhEWiqAIg+9Tvje4w7RS?=
 =?us-ascii?Q?Tl5JRCoy3lazwEwKGUPUFUsVRdEZ8fkMByp92c1AXISJWH3ysV1JAmKJYWIv?=
 =?us-ascii?Q?NgxEvmFoM8+SKFmsmA6UcLgOzDjDh6ldGWkYmTNhHKCDAMcA/eA0u/eboIFA?=
 =?us-ascii?Q?42qtqPdWz29LpTA8QbMeoG72yeyVP+vUU8Nfw6fwd3JLvp+p0neB9jtvvCN+?=
 =?us-ascii?Q?dsG+IqoTUZ262xfWNTFmuDaf54PEFllBiQzLLHnwJH0hINEmre579nPRw6L4?=
 =?us-ascii?Q?4hzvOzhcQO4CsL/bSUOZYRqxh32563H4F4QC5oUcA3vAA8ujT2QxEO2+33pA?=
 =?us-ascii?Q?qUhRvAF2DU1KUDm5gF401GPuPDNvSJB/kznqhzkME9ngW9QXeBnIBM3t711c?=
 =?us-ascii?Q?mEiUaWDjDUTp+mIJGeJS6ijZDpKoxbb8KviN00rrnOISpDfsdH82klFRoUMB?=
 =?us-ascii?Q?WA4rf3u+eYh+JsqxOxRx4IiNVJq6jFHFSwJ7W0Y00nPwjULAGy44ZhsisTOd?=
 =?us-ascii?Q?sk2qrKWzJXKYYpszvrMIblSTZg/SNm8vjPfR0BkBFNKhKNDXiNoHiua+3GZQ?=
 =?us-ascii?Q?ZflQSiwWMvJsRDyJ81xtVAitithaNuqmERSvCeED9Vm3ae2xG5Bvc0/4FNRA?=
 =?us-ascii?Q?5tWlt19nv1EVUXN6NFVKvAOOSxVI4OEXKEEv/prFCNsQy5+iqUYnQAvrAXxt?=
 =?us-ascii?Q?MEafa081LCtX3y3Ka2jdL73rJEWW+V8TVu+N1lQZoWM+ZUvlesvJ2DlFbPM5?=
 =?us-ascii?Q?nhhaKm/D02SsNfNM4sHMpy0b6aA2prysq/eu6jE9JGj0dsrtrmU3AoaZBzGU?=
 =?us-ascii?Q?4h1kUH21zE816gZfSbScSxgZksL64PdPM2R7nH17J/AdXb3aoS7ampuabE+m?=
 =?us-ascii?Q?hthbpttBkOEbMKU58PMItMtRrrRHy/fOC5cA4HpJS6bClxKmKDImZAA+FVDd?=
 =?us-ascii?Q?zRztnm2AOQU0/LctHsiXt8KAjgtKHgXPDNu1wgEL+qPlmIi+FALRf/bgHDrU?=
 =?us-ascii?Q?SNL9L6Vp+k9M6UO4+hUHc0a5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2032c4fe-9e1e-4c1a-4656-08d92bbc1256
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 03:01:41.2240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWd2M7lMZQo91xGgem1giRN9kewgxDzVAcB64P0qKylo5m9XiTHg4IEvBQisU9IlC9587dnsn5tzaM7aa2iU1sojZ6fuiEsebG0cjkVCoZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4775
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100018
X-Proofpoint-ORIG-GUID: -1IFGhc8BKS2htARtJtJRxM7BmJhDP1s
X-Proofpoint-GUID: -1IFGhc8BKS2htARtJtJRxM7BmJhDP1s
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The "mrioc->intr_info" pointer can't be NULL, but if it could then the
> second iteration through the loop would Oops.  Let's delete the
> confusing and impossible NULL check.

Applied 1+2 to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
