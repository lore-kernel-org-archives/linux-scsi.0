Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D809EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 16:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjFPQXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 12:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245675AbjFPQXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 12:23:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0604230C5;
        Fri, 16 Jun 2023 09:23:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35GCicYK024827;
        Fri, 16 Jun 2023 16:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=TdUVZ5WLb1n70d7tyQkjUjsOC9CknMfghECj4iZiB1w=;
 b=W8GkKhhJN8DQTzZ8RXB5w6VhOGoiHKSsv30GhU8byMExXowU6IvUDGe17nhVgHJroBV7
 tLkwfBCpUsL1VsfKSHYsniAQZVUdGe5Zr3xTieE27n+ovLXGxsRLWz4GI1EaIvw9WF5L
 eDgckFMvN1h7iXNvXU5IE6RuW0RWwMspHRFr+mv1dGaDbxUoaM+sVrs3S5hwqEtmjg4l
 LGRLM4IPJnbkDjxVnG3gISGCzlNFvN4ocgKmRmZQAGPxpdIpLnjA2pZYOR7oFJnF/NFx
 uF+PM6h4PvRwSONzCK6YC8wFQslUieELbOFcfDrAkMuQxNzZTc4AOd+1Q2thRiHqnFkv Lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hquvmun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 16:23:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35GFaJRt033575;
        Fri, 16 Jun 2023 16:23:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm8eh86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 16:23:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcFqd223+A17XcabJq/OT8pVAslO1w+JZLPvlJmQ3+gFdD25wde9RX0Xk7ycJfRPwRQ4qT4e8Fg8tNSUD7ug2COBPTwtFlsxLBjpdnpUd2+73TwCawwGkH0bzY/hXURBK/QSx14heYpAq9Jzs50uGAwwr22Vfsi34M7K0iZxAth5Kr0cpQ8LtVO7m5b165UeiviWes9GSJOQunfy4lY3pSb+km9zjCTr8vzB/5HfDwrBoAF8suEK1Xez6JJViyl72gNaJ8/3xqIOpKhPXaikEge6jNxdKPPfa7LBdWN8u0qIopUM+holP7+/CasIYMJKQ3QJXDXhNqn2ZVVGpqLuKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TdUVZ5WLb1n70d7tyQkjUjsOC9CknMfghECj4iZiB1w=;
 b=UXJao3t5fw+NCRse9WhvEMo9IwZI021gfyLSYrIo6v9Aug+yibSiyvjbRbuKlrMpRpkr/3txUNqASMIKbultJJq8JSGMFt8emNJzDOgtWJCi+7mij0YVpIB9hXhawBRVBSO3xKceB4kCDzypTfTsuwIS/g9veDjpn+GtMpvJ2HKaEhOh93jp1giNjlWXw69osvchw61SF6q+wlqepsQ02uvmCujxNJd+TG2FQpeVAnVH/y0rqYVrvYqrkAOzrvUvzSSRgKOjnu1UPrtna1lmw3WmdWxc3qEofU89ZKcdicEAeRUoaIdsGrepnVXqGp3jl1HhAN3peXlf8MGh/KNCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdUVZ5WLb1n70d7tyQkjUjsOC9CknMfghECj4iZiB1w=;
 b=dSkcLwNm6TwD0EGzmhMBc5ukhxuH77Vs9H0CWA/qWwUCzFWGGDeCksiBWRPpeLBoST1pmuLqFyL+DCLK7o7YCu60ddcyncdBRauZ5vHLtMCoDGvlgutKCSZauBGHC7vuYg0tlX4/9HG9K/06CkIpUG5FjjVqautikD7Q3w8yxkU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 16:23:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 16:23:02 +0000
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 0/7] scsi: fixes for targets with many LUNs, and
 scsi_target_block rework
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkhftm0f.fsf@ca-mkp.ca.oracle.com>
References: <20230614103616.31857-1-mwilck@suse.com>
Date:   Fri, 16 Jun 2023 12:23:00 -0400
In-Reply-To: <20230614103616.31857-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Wed, 14 Jun 2023 12:36:09 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a03:505::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 73f8cc0e-2f90-45ea-a3e6-08db6e85f4e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PYzHsKtVttFMx4vOHIuMUOoQ05iX4I6IevjyjSkiPk4kQ8UvHQiVYuK+hjYOkCR771BXUzbKgg5Cw23/aM2WHyvp2V3/mDW2LcZzFxecBrNwwTIm9vMQQU3YA/a+Iv6dxf0A9ySZgn8h1Z8Ct7ZTFo2rPVVJ+f6gMvkk13GJR482BXY5ZUjUwAZAfocDtI7fKUP58mxGVCVx/4kCrbqNujupi4eZuUc2NmdEyBZMZ9lTlPUs4MLrRnd7s4cBQ/MQNnV92nOonOopFdAzW0qHWIS8S38DiwKAco+YWGiid0faRORg8Sb4D0/5yMNh1BllqV7iEXaCgv333ib96vJaep/pHgYoE5lvI6sKW1m2gZVMRD/ChErOp55rXavT0XdEiCMFYaHqNZ22Ayi/BON5+2sUn9Asl4ysB6xiQH7R6FCCJhcTOHKD253D1Y8eqm3yoKE0Z6k+5wu7DJmPlwjD41YrE2qIj0kUir/rlXh2hoDhf73aptXqvK1SqyjvHijAJLepuKYnGlgfQTC4coCFDSg2kw76quxgxm+HhKu9Jjs6iPSYx4ZZ7+JO/As28Mr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199021)(478600001)(6486002)(36916002)(38100700002)(83380400001)(26005)(6512007)(186003)(6506007)(316002)(41300700001)(66946007)(6916009)(66556008)(66476007)(4326008)(86362001)(2906002)(4744005)(5660300002)(8936002)(8676002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y1FVmhOYh3Y2H3KiMXZxMjjMUvOMtMRSbwxwhgUJ9WDJTgK7GV5yZ/M7hPim?=
 =?us-ascii?Q?0JDB2/ottV/GYBnKj7kS4Kw5DS6HlrrEe+KSk1xCFaAU7WAzoyLl0AwatvhY?=
 =?us-ascii?Q?ewIkneytzcvuI4sTh7+QyRjGIT9dx/pB15oj2rnwoMlA+waub2k+sFnZ24FA?=
 =?us-ascii?Q?rOw9Opn0oNVYqW84dyq+jBgXP5LthzteTyTPWHpVqOHhLuVdej5TXuTAvsoy?=
 =?us-ascii?Q?L6oMrngk2WjED7w55+/h4C1ko8PLxvcTqf2mwEEj+4/HKyrPCESaBjb+nRCo?=
 =?us-ascii?Q?R/nfVDZwM+1VlAHEatL2UgiqPrj6jxprVnYsu6gh2koEhJNDYqpJJsY1BJTt?=
 =?us-ascii?Q?oIpguSWNqQsGhpB2cvpD+Iz/voCR2NQ6k8iVRPVNs8+h7Dx0xHPVs8Lx122I?=
 =?us-ascii?Q?2XiSrJQZVK6sadj/xMQOe0LVBKzKAuFROJt4/G10jgmJifdWaIAn8jEgFRFb?=
 =?us-ascii?Q?OeRou33TGg2OlpIkrGeTZX/Uwzh5BaZtjgav/2/v65qQRniYAIyWVhLYsZH1?=
 =?us-ascii?Q?dhduxDsyGyxYmD80dgagZ9sZa0VII5jt0rt9YBUNII1UJkx0tpbietyvUJYV?=
 =?us-ascii?Q?efSw0gkQwU8iUO7kv2YivlOO5EmWGbXiQixEVQViE/xZUY0Fwb62ICwAw+OF?=
 =?us-ascii?Q?VDBRpkVgRwzE1tAUTm/srKHpcPXE0LipZrIEZFzXRfKt0D+PxGN+xCAu5kKl?=
 =?us-ascii?Q?bLtkMkcfEXsWjIYyDJQR+sGedyRHEMw/NLpELsMctq3nNVKJJ9rIV5l4IR/i?=
 =?us-ascii?Q?CI/o2/N2azaeIj0T94dilo1gqDo/KWNv+98LkHvIoxZ9Gg9+WMCMiW5BKQtr?=
 =?us-ascii?Q?JACe8NeN2gEcXbNdiqebEFhko3M9F0QNosWGEi5ZAeoo7vlRd/AgZxVjVm7s?=
 =?us-ascii?Q?kg247jxKSPKhPP6bE0060VdcS+ZGA7nwy2N4F7+KtY3fu2GsVpN+1sszjJvp?=
 =?us-ascii?Q?p6xhdxolDvnO5kdHF+tmt6ZI6b3BXRWE/SuzGEt3HiI4d5gAHQkRsgjSqg54?=
 =?us-ascii?Q?WpuVkwR4Sv08+M9V6V9ktBTbETxDi0pY2+gIPA2v9EHZF4+k6fG+SHc/P2sy?=
 =?us-ascii?Q?jGNsogDdtp/QSQtIbzsD1UfgUZTVxXC8pni+ETXpc1DL++CP3K38g+WDrxSR?=
 =?us-ascii?Q?29U9mcxnw82gQLw7DR1eiDFRKNwCJcxj35UKS6nEr/GKgYUlaYx9B4d1yNxz?=
 =?us-ascii?Q?zhV77ruhQGw3Q+g7LZVRUIZviBMtau5Mf3iIXLYy28FuaNPjDd8tbUR1n4hS?=
 =?us-ascii?Q?/MFwL/Hc4TGVwZCEWL+FAFZt2LDaR6jMJxfk9xvSpuG7Iwoom6hDr3P95zwd?=
 =?us-ascii?Q?MVUWkn8PE0NJHXuj0qWQdtzNb/ZdDmeov/qOsDaPuEa8GF6NzIKseu4SQH1N?=
 =?us-ascii?Q?kqCG6UDkz0YaF/Trm+wRguayKlIpM9J8qlYmpawOcLfV6phwk7b0rPlYMXTA?=
 =?us-ascii?Q?ro1aEhg5gYBWbUrlvtsPc6KqTK6rt0Tz0Xc2Ho6R6kTV8rpWwPuFJ+me2DRB?=
 =?us-ascii?Q?Obvkwz2GOYGnis9qECtJ08kQlRa4cZ/apsYzORDXo26KLsmABSibQ3DwrT/l?=
 =?us-ascii?Q?Noi990AwsIB33LyhNEwMk8sDvG/MGp/0ZrFVZN0H/KFZdfzsJOLWYR7H1xvZ?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3aC1ADbhZLAvRQqSLX10SFRue/slWoFCGo6K7aVpiiRzGPsm9pRajsFVdacdv2o/wDbEpZ0Nd3+N3sxeIUjaVsGs9LAQWPcAtiLL+FWeG+8lNS5uIk6YNKwHbpcmZ7yJdhBQTM+bOXxwfrIESw0i/h1eoBR8G5lFRVruF49ygRS3Q8d53k+UfSostyVNRED/Xl3Qttz2MGTFu5hKCJr0RBQi4qa+SPVvEeNKUb4zQaGYNwmJGyDie2UR4+SzsvfGHOoFimkweTeu0tw74VcfcWnO6BxKqwgsc+MGXQ6JiglwVoeSNqUtn+/GjcmnwcAKHJU02ywJRm0R5f4MqE0SYTzfp6aGJTfWeRQ6Xth8/LqaZGL9NFE5kjtL6SY0tHnFv65C9tVDq7aJ7C6/DQMen3GE1Zq68Ea1iY9v59Nq87DWTt63v7ErAc94tFTXAP0Bz141zU9nHrIRzoBzhcQXYCsK57I0Yx6zYJUupURw5pvaDIMxD2/GUDpgrgaLTpyCKVjF3jkHWF1OQvwI5rpKctxDerFkaxkal2AdlzKwJYZB7EBesdypY5hrfxlu8OshQUSutGN/SnRrMlfdSHKrGVrGoRnNpmKMORLAzFZD6tG0UcGvq3OfCnvGAOh2ilm8bYL+YnSGmB3MYO/hfWKedCXu+XJVZ3qP/yZijn9naGdVzvUyNdqk5/hhEzJKxh5kVt4czAsPqWRSj6eIMJei0FsFuEP1R8jj3QeXflP0kao7PUUDFIqF7jO7CBpSvJH3NZRNkm0JlGIbSPkEG/S91Mw45h4jMQxdUhlBVRyh5rKgsbnherfijTQb9q/qTCuWHDGVC26vP6x2pfCxGJL/FIt+mYXUAiypXdu+gDKdsPYqlEuPxxBS4yZKz3qs1qtR2gyuNLdh+3219Azn//QSruQTQyURx20J+c9Pchq9r04=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f8cc0e-2f90-45ea-a3e6-08db6e85f4e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 16:23:02.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcBchOsl/iR2yhkBHX1Z2RdYu1dIEj0yhiLrOyirtwcNPjTy4IssCGkq3FL2VKgc93bRBMEOuI9Ao3xe4y04P+mG/BUez2yyrZw8gzCZhmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_10,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306160147
X-Proofpoint-ORIG-GUID: 2IbkO3DwAnvvptuRvEkwXLSThvgIHLJM
X-Proofpoint-GUID: 2IbkO3DwAnvvptuRvEkwXLSThvgIHLJM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> This patch series addresses some issues we saw in a test setup with a
> large number of SCSI LUNs. The first two patches simply increase the
> number of available sg and bsg devices. 3-5 fix a large delay we
> encountered between blocking a Fibre Channel remote port and the
> dev_loss_tmo. 6 renames scsi_target_block() to scsi_block_targets(),
> and makes additional changes to this API, as suggested in the review
> of the v2 series. 7 improves a warning message.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
