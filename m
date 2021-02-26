Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6C2C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5FD64EFA
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBZCXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51546 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhBZCXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2JN3R027033;
        Fri, 26 Feb 2021 02:22:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/cz8VFmvyeWdVYeLQ2AFjrm4HO2PPKD01qZZdpWEanQ=;
 b=RzrCF0ZkiCzP6gNm7k8aBUFJ4tMcIHIxk8pVHv2qWVSFP9kECcN7TFPtcmWYgEpKciND
 7tw5yd81GauZULZh4HRYeTGHlFpOv8KaLnUnAdvqqh9q1MlWpZIdcdkvVXE+XjB3tf9K
 JZyG9hDgmDGmuPGRcFL+Tf2oqao2159sroDKfElWItkTVPRvhFgwPQaIiPR4+JWm7jjZ
 rQJzYIELnf0s72sseUS4c32+jLJTPDMF3AqKa/QhyWxX4Jk4J0GtB+RvLBBxw804A6BC
 REk8QuAIlXPvWKccKa0J3HdUJjlidm3RhEicZuSZSV/LMatQW4D3FOjZn/rcLgNZ9IQu iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur8hjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2KGTO073027;
        Fri, 26 Feb 2021 02:22:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 36uc6va4jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmnOmdtU1RaTwSt41VLn+wMBJuy4i+HIfBbQmFID765VQ4i17BZcI0mMOLeOniNLyet5R7/smo0dEcq+fT7wMMZ8uIwdVmUxkFPK+t3xK/s3yuqbp61SfTOFuzwhwBqXyh9lyWtps2TMcNoY3sI1ehGKPXB6cMQxrqEaEgROMvH150MeNocAXr/iVPM7cjB55AAim5B0Pe3H2Lg/NKae1wuQJcr2RXxcwHkgQDo04GWj60pXAsOP653Yfn3Q2mKyeLsoQixpj8AN/9mbxr4WL72e4nR2pCwwUPvRZ+PlWKB+NhNy0pwPmK1qlo1AILe4r/+LGcF8bBET5PY/V2PVUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cz8VFmvyeWdVYeLQ2AFjrm4HO2PPKD01qZZdpWEanQ=;
 b=i1JgrW1Q5jX2kUi/PwhZ+gOcurPSWG6tVL8txpN70DFFnl524XtLn6TiT7lD6ZdfFohMVYSa8Yo1onBfR2UMhhL1Q/rQ59hZnysZv8VrH2K4HjVAYd4mkUCYbUnYGJSLqF9YKRfHEiaHtKJmETipe7lvh+dFi93ALiNhRubRUzqW6NuAPQrOkvXLBtrVRjKG5A1TLFAC9LBdAbmbiHW98TuK4G4DD8msQ6JwRgEuezSN5l93oF9ObWxZqlUT8M1Pl7zA1JYIEOF83LS3i0nRNnQBdgUzSA9kYLqxmAFkhNkF3WnlvUpbYuELiaXf8l7dj2XzDr0IXU0cRfZdcWCmHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cz8VFmvyeWdVYeLQ2AFjrm4HO2PPKD01qZZdpWEanQ=;
 b=FK5sSao6QeXhTLnYg1qU4tkbKmLd9ek8/52/Bm0xXCUOIjSEasDcF0VD3qT6OiLSm8jg6axSEqJdkBRNQaTgfcsYVbUDh/zj386WP/QN5HTlzBpuPE3XkVjaSDBfOrh3OrQoO/89gE4Wav7B6ZgpzvpFf+AQUnLZfz8mgowbttE=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 02:22:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Justin.Lindley@microchip.com, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, scott.benesh@microchip.com,
        Don Brace <don.brace@microchip.com>, joseph.szczypek@hpe.com,
        hch@infradead.org, jejb@linux.vnet.ibm.com, POSWALD@suse.com,
        mahesh.rajashekhara@microchip.com, gerry.morong@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] hpsa: correct dev cmds outstanding for retried cmds
Date:   Thu, 25 Feb 2021 21:22:09 -0500
Message-Id: <161430583252.29974.13463116100989738644.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <161342801747.29388.13045495968308188518.stgit@brunhilda>
References: <161342801747.29388.13045495968308188518.stgit@brunhilda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e987742b-a2ee-4417-516f-08d8d9fd5ae2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696AF8EE00EE954FAA0E37F8E9D9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +H518tsnVR8XBzXwymCK6SAX8f3x52sXrpz5Jiyyfvlf8QhccaMIY+SOsr6vNQYAeCsgZ+389Pk+7BRT0WF23P7rJdnkQgyD+2FYOe1lNzHCARlKsCQFcLb0IfeqZccrxsUgtXnHCbZ6QGGonBEg/7tdgKg9/IObo8VqXrj0InNB+NVjm8sRKoIPWLHeNBuWRIWHGM711T3tCVNHKrFZtcW9Xx/qGF7C2iePEMMLLFRBJhO+cbf7O9yLuicF0rCAnXCPMwlPsimkzHebVAzyabs8xU2GdHA1Zqb1IhcOZs5CTBMljCLfx99aWoz8RZ/PpK2qZNpnvBv+rwAg+I41MjOYQLR21JYEBgA/jkc1BL7PPlbq1a75PUCZ5JCXQzAfhNDvtIDZylI/wwp8+ln9vjJj6Z8YtWpstyRcP6zJ7BJnWWJctbWK/spqVha7ocrJIt26yyk9lh4YdQDmK6aMt53BxpaWQ3nK1s2RgSauSUtowZ/PaB3jqVrp0Xj+7rFyl7Zi75IcXokqtdaMLEoUXyMb4mQ+Cj+kbRPIGHJCu8BlJbA0IIN78Uh7BR441altc/RPkC3LeMw3SFGt38lrrBGYo6Pznn7OhiBHfJ8dvsuUYX54gfjjpk5d990XFNhpZy+3JEi1QAGRRHM19AkRVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(4744005)(8676002)(2906002)(7696005)(52116002)(7416002)(2616005)(956004)(966005)(103116003)(8936002)(921005)(478600001)(26005)(316002)(6666004)(5660300002)(66556008)(66476007)(66946007)(4326008)(86362001)(186003)(16526019)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VVdqVS9ZMkhxaFRQNlVFaE9nMVZ6cG5SNjZYSUpyMVYxZWg2clZLNDc3ZjZT?=
 =?utf-8?B?bUF6ZyswcXRWdlNoMGMyYWZVZlJVTDFiYnlQa2FSQURVeWZZN0FXYlo5NTZS?=
 =?utf-8?B?aTViMG5pZXV4dEh0UkFqY0xPaFdkcFNzV1VTOGh2YlB6c2xJT0RzSnFobWgw?=
 =?utf-8?B?MFdrZVlybXhtQ1dMN2pEem5kdlFtcElhUlNWTHh4UDJVRkZiT0pHNDk1SmQv?=
 =?utf-8?B?Z0Jycnk0Y1lENDYrdjV0VTBuQzJBOGxaZWhnRDlJVFdpK1JKeW9FK3R4Nmho?=
 =?utf-8?B?REN2YnQ3YWdMQkIwekpsWVBlbnBVNmNsMXhVMlRCMjBGQTQ0ZkZGZjBqRmli?=
 =?utf-8?B?SEJ6NkRocXFxZ3pXK2tUZEsraVh0RU9JZ05CdldkeUNSdzFDOXQ3WnFKSzBI?=
 =?utf-8?B?TzNEVE5Jd0Z3TFRWZFR2cWdVY0E1TEZ2YXRxcHBjUTI3YU1EVkNqRFFSTE5Y?=
 =?utf-8?B?MTV2bFVYNExicHA3cjFkaFVyTnNyQk5lQm0va00zRG5qTzJmWnNVS3NpSE9Y?=
 =?utf-8?B?dUFYckFvQTRQUmFzejBLOXcrZDBXdnU2Q25ZWlprRjgxMkgrM2JjOGsvbFFT?=
 =?utf-8?B?UEJaY3FpL1BzT1FPbHpvRVdtTWtnKzBPOC9Ia21aRURRQU1PSnptcWU4RHB1?=
 =?utf-8?B?T1hBc1BCMXh5NEw0b1dscnNvVEtSc1N4RWhaLyt4aEtlL1VZeVV5cGxwM2Nk?=
 =?utf-8?B?Q2o5TUwyTnNVRzRnZ3psYWo2YWhBaVc4d1FNd21LQVljL3NwT2c0ODFUdHlj?=
 =?utf-8?B?RnhrZUhaMXhoamgvUlZ0KzR0dW5TbDFNM3VyMkprWVl3UWxrK1prKzA1TUFR?=
 =?utf-8?B?UXFvVUVJbGJ1OW42bjVMb1dLdnNaQUFIanlrQUNBbWxrMkJqTGJFK1ZJdkJh?=
 =?utf-8?B?M2ZpU1RXYWMzeXduWkJoaXFRZjVUSU1CZnN5NlVxK3p3RGZKS0lOcUJXU0R5?=
 =?utf-8?B?S0JseDdQMUpnUXBXRS82Zm55TnFNMzlWUHM4U1dDOHpKWjQ0MmsvOE1rRUtE?=
 =?utf-8?B?aFBqZmg3L2p1Sjc2MjROYnlNK0NHeUMxbFMvNjByQlNDcWZjdS9saFA5K0VU?=
 =?utf-8?B?K1N3K3lsTWZPb2NhLzEyY25NMnd4aXlsenlVS0Q1ZG5BVmNjSkZkaGdKRVpR?=
 =?utf-8?B?dGNNbE1sWFRlcThaV3Ftdzh1Z2h6QlI2YkQ3cGhoSm81WDMwNm9jSUdTbmFu?=
 =?utf-8?B?dXl6SkJrNGVYMWR6WFJ0NEpoWis0RmFFRWlPOG9kUUowcGRDY3lvT3p3eVFK?=
 =?utf-8?B?VGZXZGVBVElVd2xuVzBoSlYzUVpuUmpLbGFSVE95T0ZZOUczMTJ3c0FSUjVL?=
 =?utf-8?B?eEJGcFlMNlpjaDFMOUUrRDg3YXhNV3VRcE55MjdhWXQ0ZHJNeFZiSnEwNzV0?=
 =?utf-8?B?L2w2SXNYa3p5N0JoLzNyeW1WTm5wRzZtU0dSSXFMQklPTTlpZ2xBaHVtSjlr?=
 =?utf-8?B?elhsektVd2dKalh5SkxWaXNyeWVzYXFHTm1pdGJDZlV5M000Vy9uVEtxVVBl?=
 =?utf-8?B?Uzc3SzQ3N28vck9uZHVTdGcrV0tQYko4NmpYTTVoYmRPZ241eUs3Mk9mV3pj?=
 =?utf-8?B?UVBGWU9ZT1dtY1FBTjdCZ2poQjczYkx6a09MYndWOHQ4S3JyYUxaWkJnMkJw?=
 =?utf-8?B?d3JqelVkSWZKZEJ3VTRNNzhwc2oxNmFxWHFFVGJYRFV6UXU2cFduZ0NlUmdS?=
 =?utf-8?B?NzRnbVErRldCZ0NtcVlLUlJmR1hsaGpqNnV1aW1uWkZCT2RaQjl0bk9OSDds?=
 =?utf-8?Q?o/x8wqgF/l/AorUfVu+1loQPQ3VmrJ7SfdsNhud?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e987742b-a2ee-4417-516f-08d8d9fd5ae2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:25.0089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6OZpFyg7o0m3VMTCU3H9/0G2j8ByegZUeVWejH1RFyjI9W3QQ1/G4xBTCMrZndUBXANr4XDA6k0ahVanm0wXvnX6RVv6aezjHwsXMwoilQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Feb 2021 16:26:57 -0600, Don Brace wrote:

> Prevent incrementing device->commands_outstanding for
> ioaccel command retries that are driver initiated.
> If the command goes through the retry path,
> the device->commands_outstanding counter has already
> accounted for the number of commands outstanding to the device.
> Only commands going through function hpsa_cmd_resolve_events
> decrement this counter.
>  * ioaccel commands go to either HBA disks or to logical volumes
>    comprised of SSDs.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/1] hpsa: correct dev cmds outstanding for retried cmds
      https://git.kernel.org/mkp/scsi/c/f749d8b7a989

-- 
Martin K. Petersen	Oracle Linux Engineering
