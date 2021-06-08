Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D96C47095
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3BD46124B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFHCZ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:25:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59452 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFHCZ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 22:25:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1582DoHk107166;
        Tue, 8 Jun 2021 02:24:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ovDxzkTsI8amSb36qFaAgDk8TW/S+M/sao6ZjdE0UmA=;
 b=C+DQfasZ0yWty03H88KDrilN6EqqSgF+/nhAX04BhnAkgB1HIdrC6YHtCF2iB5Ibsiow
 FNHLJ0HJAMKPrdBEQkJ64GahTAHDoJTM6ztsschxubdvZ6/oc04JzS6vDo5uRkhlJZeF
 eOQeZd9M6JShTfm+Yf/GdLnQoNuk/A/DMc8pXBJm8NEJLMKxMl9FqlpsCl4lMif/7mt0
 JjWMVEyw0reb8jZb79BoblBQ1J2o83s7dIQFa1GNMRRZ82G4jPLGu5NMcKbvjccp9wo2
 vo4prsIlYDOd/5CJEDsReI3KuNmqJ8yr2j6WlsRxZw3xPra6dC/cjo28tq4RB2m7/fFk 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nch7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:24:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1582F0Y0002507;
        Tue, 8 Jun 2021 02:24:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 390k1qjwv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:24:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FywAUkNZf1ykJYWYV3pEDM6tYUgSzc0tYeOXFzGqBqFkklS7AnB2UBS4HeR1rzYxs8N6Xofw5zyup2wggZzcL1g5ikzhSUjRPdWIL0gNSWTCf7mpE3kXr6LRi8X5Pg9fEOcVPWi7V374oFFE7X86EG3u5iB4+oflJJf3kH0JCBvEbzJpEZWZqeaxP/h70AYzHZ8gchFlON7L7EAF4uVyF3alACAosKN3+3xWVTvL0HwlyFRhicxVCL9o0IGdyJQbiTTpgmXlRkrjEJu4Rj5pW0clVhABr3Cn2Tviar71lpUrX3vMcf9BMNkfCEfsx4MbFPg+U2EetoTPXHX+JxlLAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovDxzkTsI8amSb36qFaAgDk8TW/S+M/sao6ZjdE0UmA=;
 b=YzvlO9gtUp1cfW5VyALTk0B4W2uPXppdeYCuaqfQ2xkuna8+b4THHdvn2hLnuBO9AWk7TMnv3k22qF3+9qwSk/Cepr/VmAiQC+RraXQRp3L2XU6Q5Y24x63mw2jn44e7+luZ7McqGR36iXDgMVa/zXqnbdpYEC31jSfYLY7kYOjMoCUhWwVveqTUiohcPPYAI4ywhQFOzJZeaqVsgbzk7zSdTHAG8j02JhOHB0cUs+iNfd44S5IhCUtyUK/yW+Vzm8RgPa0E+riMzF8WoZVK1bN21NQ3LOVz4Ix5BctjJH6sb1pEB3ju+9WFIEqs6W2tWSe5Aa16G4WMESj2+7HMNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovDxzkTsI8amSb36qFaAgDk8TW/S+M/sao6ZjdE0UmA=;
 b=zJ7WXEHPTJn11hZSiZq21ILWSUQWu8x2WkES3lRRc5El3OCWMAxudXMjjef/mj5v1SsFII0fDT4am/hFHQaBAED7qDzHO4ce1sNyC/lKAhLeYVq95+iEjTRH7uoHG59I3NpkjmEj5dVWubCz/KQwmqCqMHlZN4ASZH/rSYtk+os=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5468.namprd10.prod.outlook.com (2603:10b6:510:e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 02:24:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 02:24:00 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH][next] scsi: mpi3mr: Fix fall-through warning for Clang
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmwxjdqj.fsf@ca-mkp.ca.oracle.com>
References: <20210604023530.GA180997@embeddedor>
Date:   Mon, 07 Jun 2021 22:23:57 -0400
In-Reply-To: <20210604023530.GA180997@embeddedor> (Gustavo A. R. Silva's
        message of "Thu, 3 Jun 2021 21:35:30 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:806:27::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0147.namprd13.prod.outlook.com (2603:10b6:806:27::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Tue, 8 Jun 2021 02:23:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eccbef8e-b0cd-4402-e3f3-08d92a2479fd
X-MS-TrafficTypeDiagnostic: PH0PR10MB5468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54680BA20D7E186798B116DA8E379@PH0PR10MB5468.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6bcTwtAdcUSFMvhTMdHQyNIfPvSXxTph6+O+knV15bZMAJ7nZk15HkMB8hC0v/+62MUsX92j9Lsvez7OwZ8Wk4BLkPK984wQkBcEoZ7wItOHCNercTHrg9NHbnyoQRvnxsCo+gdKtK4vyIQXtOwPXK2ly2Xc/EtMHLQmyUTsnTztvnnfraP8jVfk+jlwmZDEqS/zESf+GFkylOnS60AJpYj971vzlnwV/yBXyn4jN2I7IoKIBrlCeEZDWkQyGhaHZsAm476tXX2prDfOIz2PpQXhyRmRNV0pYgnnoqMzHFy+wwVpexjt+zH5CM8Ys8AqVbjMtJ8BpOxpLVS7IC5PbCFt5mRHIMNXiKE7k/N1C+cBlrIdwjhfPzwZHsfGDv8bdOQUwgoqb5H4YKWhKf/hbplXoEKKYynj+5HITtCkUCUQld9L7JVgGZD6PRZ2OEm9brlgNDcGn6ZF41ubvYmVFtTrUR9jT6RezsRrXVst70MDHX3t1fty/GWlh2Nk+2HhnxT7f2rdwSeuBBeaAQYDCJ5moRafbLtXO722ibUW7LOkbZU8dVsNepmkFGvUzGJ9cyp/bG9ttL0L37NZ0hNFtj8qQMmc1ZWfl3XqmssFrx1N60eLWZzuX7MQAfoxN6Sz6UJNtvkErA+Yyw6N/oJspfHuQeU5AekqoUW2f3Qm8mE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(346002)(136003)(83380400001)(8936002)(8676002)(4326008)(26005)(956004)(558084003)(2906002)(16526019)(478600001)(38350700002)(54906003)(66946007)(316002)(86362001)(6916009)(7696005)(52116002)(55016002)(36916002)(66476007)(66556008)(186003)(5660300002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vcm/nSv+VQdu7D8UrIyMNbOHBWXJYj/Kb1x/2hyY9en4avFoDIPnyQ5+aJgq?=
 =?us-ascii?Q?RTIg+KobhPEsBmTluXH8f1A12jc2R3yEjX4+6qH6U3SPN1CflQ06ssMsl1ns?=
 =?us-ascii?Q?5GV84qQWpnmK0QZV6THOU7MAkJQ9//PmhGgItD9OI9u7sfe8uI7vVeguM+Eh?=
 =?us-ascii?Q?GrpS0+6vL4vt6zN21r8uP0OvyIj9rSNg77g8JLxtPK9kUq42sLovpbOCqHbm?=
 =?us-ascii?Q?2KePZAmeTdTadoSzBX2Ic0sIu1UjbVYsi/NtPr6PP7thspEj/BxMT1duE7yW?=
 =?us-ascii?Q?PIp4LeWeM/h9A8lSvGBddi3eLGFm4A5EVYim7C2Wg/RB4Js+jhnDhH5Jestz?=
 =?us-ascii?Q?vhe4ERJDsYS96xtXR0o8l0df0h/ylarGiMG6O0Fi8CACwnZmPfIgBbUQjwNO?=
 =?us-ascii?Q?2nl+Irux3EMn7wm7NlyLKg9B0VHx7EMm1oGok+0VYBC9hwpFdNps3TKfR27D?=
 =?us-ascii?Q?DdVNYnV8QyCtmuVI1MxCZTrRLQEuPPwaYsuRchE/uwWabsFBF2eY69ReJtN1?=
 =?us-ascii?Q?m3x22UtxJA1nEeq1fgCKxEDspi0zbFrs8MV5kNFRGDlqSrzP4KyrGOz4Wcm9?=
 =?us-ascii?Q?o/39682xCqZCygeu/bVULRxTkcAZE63wLbZhW+q9edz81GuEXikid+zKtBsT?=
 =?us-ascii?Q?x/5y5lb8/arMyNgdfcpdVqhEl0bDxzI/wcVk09CKqmLUDbfcPC3HDyo4GBWh?=
 =?us-ascii?Q?CAs2kfYuW46qvgHunFU3qqbdQ7GacV6h7CEMU4VOvQATvgJD/+3O98o8dspm?=
 =?us-ascii?Q?w6Ii4FpIMjntjd86cx+kubNe2NUEU1iq9NgxI1WSd0bUiU/NfAaT9j+c0nHx?=
 =?us-ascii?Q?LKVutp/AnOVV0TaznnWiu5jGdLb5SlBENqiHbSKpIrN/14luKgnEptODJGDA?=
 =?us-ascii?Q?1cOya3WOWveyw0wAlcyGn6YoKl3kvLP9dFhv7DsxGLhCg9B9NqxY8wsR05ia?=
 =?us-ascii?Q?XoBAS/PZNqJe6gLpMagYMiOOhAsuKhecV6W/izVgA+pF8mmW0pbM2BGrSgcp?=
 =?us-ascii?Q?TRWtlzVmgkTh1HSzRzs/KVTXMmG5CAxiuc/YxKKQ947yDU+gbRPBsXIhIvYR?=
 =?us-ascii?Q?d9DK+GZh+g1KbEUDWB+ehsKA/7Z4df3Y9ZBJa2HpOVclcupzLxnM86ThxpFf?=
 =?us-ascii?Q?OpCGQHTjz4H4gcr+r/6fr8KTdVP5CJ28hgEy+f/0O2QTA3lKS0DF3sQtlFtH?=
 =?us-ascii?Q?yDZTR7Pa0SqRYoVYevHtW11Fxfw5G1I2GolKNLYxZD0nAls3VVSn74a1tEhm?=
 =?us-ascii?Q?+oaUgH3POWuaevMRBIdEeJjm2zwUpIENQCPnEQe9PWdSoLrl8tnNaOz5dTOv?=
 =?us-ascii?Q?GjUP1n/NvDukzWcWem8lW+al?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eccbef8e-b0cd-4402-e3f3-08d92a2479fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 02:24:00.4323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnTOyVq//MyKxjRWkPSrgKQEhH9PKwcxMfR2buraCfcY3icV7enRGNbpU4eRnIvr8wS1Qg/Gdgn56fJ37QRSkClYBgLRERrlKG895x3Na00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5468
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=856 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080013
X-Proofpoint-GUID: VaLonCDXINRjaqMwG282mgiqWLW-pUsy
X-Proofpoint-ORIG-GUID: VaLonCDXINRjaqMwG282mgiqWLW-pUsy
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> In preparation to enable -Wimplicit-fallthrough for Clang, fix a
> fall-through warning by explicitly adding a break statement instead
> of just letting the code fall through to the next case.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
