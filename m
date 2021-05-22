Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438D4C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B5961090
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhEVEmN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhEVEmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZcZT004259;
        Sat, 22 May 2021 04:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XYcQk2VtycRRkjYlN+/STIekEVZJU6BtusTgTOCd0Vk=;
 b=hk/AHkom/pTYEZ1DSvNmRUfjiBHIi+cPWCn5ke+9istz7cDGP+h9q4l2kJ16LyTtj6WX
 48i1eilyDTCR9TF2C7fYjJXYLXS+cgfR8WPGPVwg5ai54VMYo1xPhMODnWeIdiTl8+6b
 Aj7lUTpk8ZtBgHQtyYFktG63vOuGSP1A9hKDRwIy3kAuRyq98W0yVWguQbgQ/FCvRVxy
 B7kTqnJWyCJLR7HwFJmK/QXzs/Cqc/LjVCtgq0HGbUifJqa2k7C/ZGkN5L1OF37KSUDQ
 IETmZTtyLoslo25CU1nj6VwwsmsNm0K35h6nttLk7ot4aXsyYnNAUDmChfYwLpMe909z eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp00hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZiRk168410;
        Sat, 22 May 2021 04:40:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 38ps9j32fa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtTeayAkdF7on2ZzH/P7YESYG4oDauVlFkdElyoDuVMLhFG9FL7ELvf6GeWo27LVnZJwiJX6Ymt2UJPi8M0m1HlkGz4reVYL8KjNbb7icsh4PODPC37Nfqb+okFt3S1asUwySpAotimfXbNtBHxXqnWw/PVyU8OskoyhoPYc5ausU/0Iu6L9QiB16vQHspAzmuM+IKQ8jz23lUEl0/kQw1RW9LLaM2t4CgJX/ACEox/NDYcTMsTKfY9M0W0jrWV4ofnJHdrH4WuXbcEm41KYSUNee2np9Y6OkPCj9UhmH6dCtZuL3ZqoEJA6sN5O10PjIrsONgVf3WrSfkf8J6OwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYcQk2VtycRRkjYlN+/STIekEVZJU6BtusTgTOCd0Vk=;
 b=a8OajO5gnE7aQee5ihYzHZYrCpx7r6Y1eQFClPOLHwR8qf5qFJtHH1Y+FPoGNQlwHOPKrAcfb+YvDKGKPE6vKD0sVJJN9/aG0RgDM6y1SRkyruV02k518FN262ekWUGRXz0eVe6aluLrA8P2wb+r3XCcwD0Z5bUYrbqVthsH/GJHplCp2Jh9uaG6XN6AIO8bIiQ0gJsd0vi8mLWwxRZ7+WAa5hYJPqqE0ad2BXfOf8bUTOSH9+bbE04wQg2No9Tj/WIJra8CSlYdOJSqmi8IQLWpy6Ekpjv/ZsPlmcEM6aRI44BsSsKzCqjA4kRpK0OW1ml0clMcKuk79rXMHrWvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYcQk2VtycRRkjYlN+/STIekEVZJU6BtusTgTOCd0Vk=;
 b=b9mEUyWy3kVnk1a9GHfHt8SfHLPKlK4iMoScw3/1XZcmTDsiMKzx5MKIulHCuHZ2caaVYsCcV6MwktcWyd6Qt/K15leYs9NKJB9LcxTBioG9hK9eZgfv59TzaPACpHOTCVE/DXqJq37fKvQpZxHZRRe52JdJ4q2zdBeFcW8moQc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux@yadro.com
Subject: Re: [PATCH] scsi: qla2xx: wait for stop_phase1 at wwn removal
Date:   Sat, 22 May 2021 00:40:30 -0400
Message-Id: <162165838888.5676.11733627018140786.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415203554.27890-1-d.bogdanov@yadro.com>
References: <20210415203554.27890-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b183e9a-7138-4c73-7f0c-08d91cdbc21a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5481DED10B7882BFE43FEB7D8E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hADY2YETu6xVPwZhLub2D4v6QIebFhNtMd1E2w0xiT7HQkL7zGOSqmVqCuBCSIvP4ZXuo8b8QE2HxnlsSp4023akdqOZMYacGiSeNTCvtxyuUD0v3lOhW4BHqNuuHyNAllYfMaGek3HMy4RUsDzB4RznM+vB4k9pzmB5nLkWm8+fupGKsQwAral4970TOXKZv0JzjrDO2iYlsdD/2fQk4RbE9/oibj/MUORY5Ua7GBsBfaiKkxMFccmXSr4CHdwEoild3zyQAdXBGRrN4eiXmQigIwRhUyMn+hn2gZE00YcD8/5oy6j2pkZ+hMRzJn8WsjVE+TWdKc2UE+3V8oAK4sWx3WuiCJDmktR54zh3U1rDXdBu+l6epu/aw8nQ9nXARMmCoIvxndDwesO95qzhW+ucWHf1caX1jq31qNg2AxuJUYTFKZBRuJbZXX58fbTC6zqs97hSuGdm8W4WJkSIXUba+ltsIrkKvEf1OHD4tvxqQxspyhr0BvU+4tckJDg/aexfdTHHnbuOnaIWNMHrSBNEPFAkiEOKrYbvtzPUKLsJKJA9+5vcoCmX4wPD0CWU5k3VHbElVbO55zXYIgDRtDKvrHkRznf0el2q7dE/3NWabWDstZQVR3DgYxf5ioRijV1j7i3ECaiArJYTjjD5Y9T3+a4KT2Bnp4xoS5PytPWqIh352KfhuzKpP4XlQWFoxE/vsTBTb8Mx548H8gwa4Z9guvu7fComyI9b1TfquVI3EmfT5ilhKqcy0x19H1r7yLDm5+Vbhztv12jFYH2v3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(54906003)(110136005)(5660300002)(2906002)(83380400001)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QU4zbXVXamNCajFHQ3p3dHJpSG14V3RjMVhzTklKQ3UyL1dlMTVEa20venRw?=
 =?utf-8?B?WEhRTEdBdzBtMUJmU09NcFg1YVNVcWtGb3N5cWhaczMrK3hKNnlBQkNlRXQ2?=
 =?utf-8?B?MmxKSWhXUFBmWnFJOVhwdGxOU3FwT1M4bWl4NkJ0SUEyMk1yY2JLYzlwMVNw?=
 =?utf-8?B?dU1mS2tOSE9PY0VLQmxBTitzZUJTVXN6T2RVVUU3aGVrVk9lVWNnaFZ1Yk5N?=
 =?utf-8?B?UGl0Mlg2bWE0OFF3ZURnOUJRb1R6cFc5Q1dvVm04WG5WMXN1cjUrczdDTFB4?=
 =?utf-8?B?UStWSyt3T2hSZHZYcVoxR3VQRDdvZjR2ZGNlTms1cXpvSXpBNFJWMVVXSUsx?=
 =?utf-8?B?b09DZE5oZjRyWFlOd01VOGlrQmNBT21yQ1ozTTFLQ2FnT2ZrTGk0TU00UE9i?=
 =?utf-8?B?MnZLS0FxM1piVUpNZUFMVjRYZVp1OUR1WiswSWxKUG5hZ2dqbUQ2Ui9UaG43?=
 =?utf-8?B?SzAreHRhbU51ZnFFTmVyeHcxNmJJNEF6MkVqdFZoQk8rUnowcm5JbjViNFly?=
 =?utf-8?B?NmEyODIzYjRqU3gwUXU3TDIrQXFLcjVGajh0eEtyT3pvSy8rVXZzNWdMVk5j?=
 =?utf-8?B?YlJxRkF5NW43OFUyRW5mYWZnTDRUZFZwaXVEaTN1VVR1RTlBeVI4Y1dDc0lF?=
 =?utf-8?B?K1cxSDNtOTdmMy9yMG9ydFNRUU9FVTZmZTgza2VBbmNBMWZ6aHJXYVduakV4?=
 =?utf-8?B?R25jbDVxTndZOC9MWGNJTm9Yb2Q1MjNPL2lmSk5Ud05wb2pTNkI4dS9mMEJD?=
 =?utf-8?B?ZUY4WkxicGRKcXpvYVQvYXRxNnpITXQ3RW44dFR2ekZBOGN2M3FYUW5EM3hB?=
 =?utf-8?B?SXI2cVliRlR0MlBKVEl3MjN4SHlCQlQyU0Vsd2RCMzNoWkVSd2wwc0lQUUkr?=
 =?utf-8?B?TjNMMnQzYTZHQ3daK204RnpOUStWYUpwVVh5VXBwQ0Q1dHpSRVRGeEExWWYx?=
 =?utf-8?B?Y0M4V0E2VHNuS1F6TTdsMVhLY0NVaGs0bklCZFRqOEdvNzhpVmJsajlUY0x4?=
 =?utf-8?B?dktwalFjMVpXQk9JR0NENlU4V3hJdGI2S0R4R0xqSktBSEFVT3g2VTRKTVBB?=
 =?utf-8?B?RzdYZEpGL21VMWRPRUk1bFBCRGZPVUM3SkhJaG0ycWllc0J5eVJmY2hPb1g4?=
 =?utf-8?B?bU5waHJmK3FlayswTjdTQ3Bqd3J3SWV1UWhUYkhnWmhIQ1lZWi9UaUZ3NzQv?=
 =?utf-8?B?YXRGWm1FbndwOUFYZVVENGV6WWNkN25abFlhVEtiUC9XN0RqQnVmdUxGaGpF?=
 =?utf-8?B?eVRUdGRPZ0JkTDRFT0FzdGRYWWRkcDV4S2lnN05HWE0wWVdESk9NbjVWNnM3?=
 =?utf-8?B?MzRnVU5VYU1LTWRwbXZKSHQ1OHl6M1M2WWZlQmQvTDZMUFFENFpTbm9YNnk5?=
 =?utf-8?B?SHJ0dSs1L25qWGZRZkpLU08rMi9QZml5N1NGb2FmNGhhNU43bXA5MmtlenNH?=
 =?utf-8?B?QXNjR1VUVmZ2YzhXN1Q2ZG5qNmM1N0FuSUJuVTBGZStLNDFvTzBGVlBxSFY2?=
 =?utf-8?B?a3NQcXorYUg2WjFPWnFCTVdWZG9leEUzTmdEL3VjNWpVMStOaW14V2lnUTh5?=
 =?utf-8?B?Z3F0U3lEVkZVdlZEdzFKSHpvaUFBek83dnZxQVpDMTNqSWkyTE1NSm5OK1FD?=
 =?utf-8?B?TlBBOWFaNFNLdTB3RHZSeFJjL0tsQ2lNUDA1dDk5cXV2YlM4SjdFOG5oNnlM?=
 =?utf-8?B?ZS82Z0RKU3cxVmg0L0NtdWs3aGZnbVdKTWd6bldRYnpTazlhblA5aFdDbk5t?=
 =?utf-8?Q?eL2SN7iEQp9UHmOIY5W6jkWa9rhSlLuGcOzZ+1E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b183e9a-7138-4c73-7f0c-08d91cdbc21a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:43.1270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPp/wlcWtIc2sZcM6YWAtyXn9glawAXAZDMKGvyBXXPZnmGVMGTFzrpAHdcn4zktsCHvnI05DkH23N2VTPILED17sZ3enwb9eQLNIcjCGRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=980 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: QGM7iLIkJLFm-iSLXwiZ3zR1abPRzzry
X-Proofpoint-ORIG-GUID: QGM7iLIkJLFm-iSLXwiZ3zR1abPRzzry
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 15 Apr 2021 23:35:54 +0300, Dmitry Bogdanov wrote:

> Target de-configuration panics at high CPU load.
> TPGT and WWPN can be removed on separate threads.
> TPGT removal requests a reset HBA on a separate thread and waits for
> reset complete (qlt_stop_phase1). Due to high CPU load that HBA reset
> can be delayed for some time.
> WWPN removal does qlt_stop_phase2 where it is thinked that phase1
> has been already finished and zeroed tgt.tgt_ops that is used by
> incoming traffic and causes several panics:
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: qla2xx: wait for stop_phase1 at wwn removal
      https://git.kernel.org/mkp/scsi/c/2ef7665dfd88

-- 
Martin K. Petersen	Oracle Linux Engineering
