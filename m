Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780B4C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6568F650B0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbhCPDPs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhCPDPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G38xu4030085;
        Tue, 16 Mar 2021 03:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xde+yBCa+16aaw/Ti62fNUEtMoSqE5Dxu9LqcWHVMsY=;
 b=WgM2UVvaDqi0oH3j5UjKsRHrrGrsH73VVO9/z6RHIygtR2OKoVTXIvbn3s9tLLLlcdM6
 ebpDMHROxh461nX+K587Cjz5/uPDrUxIDHGUCvZtUCKDfZ0iGfidxZcQdn4OaHz7xdhI
 zjvkLH6UVFTgkOnf/1rSnK0DFQDPblnIF4O6CPdVOrYD+l+3Ecdx0paQy3rp4GG3Run/
 Me6zankmasKQk/QC0NVP+f8oFqX1XmFQ7zOm15C+7xOO4VlUi5b0iydIJlsd3Q24MNWH
 X7m7Y/xVyledMvlETh1KJSEMA0Eq0XW60n/A4PcO6IO5beDFyurrvVFqyeZ71L9QkIUT 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 378nbm64kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39dps138133;
        Tue, 16 Mar 2021 03:15:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 3797a0nb5h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVovVIutGw50YU8rOsU7I/lPBbTZc5tFrslmKMAQvi7y+F+xIIQyv0jQsVSqmSBctRB3BQMZtRoXcztQ65W7cDVDr+XVPG0OsZPIQCZsHP8tgSfr6pCmppBfaErYgO0eMpUzWyqJZD/3Tw2aHw0b0yKRDrSJZipfa6pGKP6bZRgEy0BtASxfxQQAig2gFdAhb7fKTEUmt/Sk098HMptlkNTnaI2FQD8OyhvSXQ3gJg4HEInshcU/ck3OsxBU1vL8CLXoBsblhrXZj3n9vW9woRXizBk/hLyt+4mJpRK/NB3tR5Nn18QP6aNAYuAFy5maOwVJ89K1Com+PVNQCP2TxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xde+yBCa+16aaw/Ti62fNUEtMoSqE5Dxu9LqcWHVMsY=;
 b=JOUlXnd8GIY0C6Siv3uYrMKZ3JgsG1s8nBRoKXrQs1HcwwKz9HGGNELLstGHPG7YdPSp4OkvmymWVRjwpFxtq73roHki4ZY+RdLsjZKdMsk5Ir8Wye0WcgatpgesgQmLq/6Q2zZd0vqyanw4XxQERzGszj4qmeqZ0CLtKowdmcOEnhT/B7j6/EQyQRdT5CMgYbuKt4hFq1Au+AUwbGzD6aZ2dcPe+sa8SndaaBkIjgfJRjJsICsvryU6NFcOZwr8vzJk5PDcV/bhY2cvPwwh5kqqjH3neUMIFW5p+21vSnZDJucfrCHI8ODpROAkAW34X8wA5IJmlmKgro9KSMeK8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xde+yBCa+16aaw/Ti62fNUEtMoSqE5Dxu9LqcWHVMsY=;
 b=iaOBNsSL7RuZm2H/4RK2p3VFkEApsdlNlEssrm2fuplD95uqMxxEnpUmgkReqD+rIvZScu3hjW+4QtgzwkRC+slggMAmOdj6BUMXFG0Lpr08dv+/xc5Sqq5tC/IrO9Sgstl+yM/M+YDAur0OKHz90HpasM+u6oC3mAXs5wARd+4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Akshat Jain <akshatzen@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Remove list entry from pm8001_ccb_info
Date:   Mon, 15 Mar 2021 23:14:55 -0400
Message-Id: <161586054342.25014.6105821607858979173.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210301181847.2893199-1-ipylypiv@google.com>
References: <20210301181847.2893199-1-ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5125fa6-734a-4ed1-3650-08d8e829b53b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4709FA9924AD3436A11CC6F88E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtI/SesVaiEokWkZqo+CLtdf3dZa+sgeKTQOPQTTSUtFCfqQvf5Qfqul1zC/Im05O7wvoocelfb3PkszwJ0Q1GrUYMr72xc7JkURsh20ND6hI/NlvU7ZTt/EVmPjzNGxDztxdi3ULfZPtaxSIef7hVO4Iex6RHW+t40ngfuwU8UJ0vib22aOv/6iHqzOIsNY2gfkNRZKUzkjXZMy0be2NtoMYcxEv2v9V1yUGYitrmSM5umsdNrJnB7isDltStJbsdHir7rpEMRenAXqRfnVcG75+vTOp74jiTIjsp0oa6fiGmsFDpF1/c58XdXuWFt8LL5NbL89bxUb0muJU9/J9Af20uS4yY4AvWCDHzMX50uT+SSrVMCVm6TNejMLkcGXjir2RM137Np23J/J/p0ZstqsZAuq+pDF4xspR63Fn3pXi+8rx7fAjHuAHrGyiva3WuXr5bDeDuwj3PoaOR/WhX2eZQguDcQuFSE75ZrLqS7EICDT23Z4SmhEOwIZHS/1csMq8bFXpkjQOwJzbAf5jhxvRX5bQrROOdSuqLvVDO/YeCCQl71k/ohTELiQqmgZQQTdWOcm+IBb9qCj2GMvfhL+bev/AJSFLNMvr1fhV9CJkpe2T9XtCAjrLWy4h8EmbA1i4m8ii9hTyFb7ZiIsXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(558084003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(316002)(110136005)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(54906003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R0RhWFJ1czY0M1U0dTJ6OTN2WWpCNjVzaDVvZ0FtcUZsUHFjM2RYcm5SS0Rw?=
 =?utf-8?B?a1AxRkhaZEJqdlZHbSt6UGhUc21TSk5jZG4wVzVNNXVFUkJIR3dPNmpDTHo1?=
 =?utf-8?B?TVNJRUFJOEJKSnJXOXVpRmFVeVM0MHpTYVJJOU56Ukd3bzY2ajhjdlVCRGtK?=
 =?utf-8?B?Y0dCaWp0NmNkUlpCNTdNMXJpUzEvSEY3MFR3Rll0R1JDWDNsRHNETXVTOFZp?=
 =?utf-8?B?ZjFPaHZMSkNnTHFwQWE4K0NUaG1jL2J4WlliZkRObU1sb3ZOdENZZjQvSXM2?=
 =?utf-8?B?cDMvaDhFWTNJTzFNanBrUnMwLzNwMzhQNFQzS2tNVEdVZ3YxempCT04yN1du?=
 =?utf-8?B?NzdPM3RhMmpMUW5yamdKemRLTkRHbGErYXFUOTNwaHhEWE4xR2JiWjhqYXhE?=
 =?utf-8?B?Mm10WGowdFZIUEhqbzZ6ZXdGQkNkV1hXSjFNTW1ZREtTdFlJNnhOQ0lKbk1p?=
 =?utf-8?B?ckJKSy9KakVTbmZmOG5ORjA3cmx6dlBFU1duSW1kQTdMcHgxbjBjVjB2N0M3?=
 =?utf-8?B?MW1CYzRhc3NYNTlFaVNxNnJ4a0EvZmYxUzcvODlBU0hrTWZ6MlU0VHhpL1BC?=
 =?utf-8?B?RHlnSHhudGJ0cDN4bkJZZmZyakl1ellyNXh0WkdOSTlBYzYxeGtFNXFNNWdB?=
 =?utf-8?B?UG1UL2VhNGhodFdSMTExd0I0T1Z2RGU0RGZvaU5IU3dxUnN1MmtZdFBZaE1P?=
 =?utf-8?B?SnlZVFRtVEJhb2NaQURmbFRaanRJQTFrNTZpSUkzZEJibG4xdS9qZ1VVdmh4?=
 =?utf-8?B?ckl2dTVHSU42b0dvOWpCcnRDSVYwMGhIWVJGcVpCU1ZDYUtieERsWHJJODhy?=
 =?utf-8?B?MUVBdnZtcUhoM0ExWnBBbzJkaS9ub29DZlZCMDg1OGVWM2NqUUZDRjZiMTJa?=
 =?utf-8?B?Q1IweVJDSFZnVmp3Vko1dFFrSWlCMzJFeGwwNTgwc21CS1gxYmhaQmxtRlZ5?=
 =?utf-8?B?V2FteU1nNm1GcUVyRmlhbldCaHYzSkQ3Tmt5MUZwMEw5QzV6RGYzc1pabUo4?=
 =?utf-8?B?U1k1ZVF2Sm0rUm0zQUZZZEpkS0lRQzJFTWY1NWRoSis0V04vUTFEQ0FvR3Qv?=
 =?utf-8?B?aEdkc21jYkxybHFMQ2pkN2x4SGc3cmRJblhYekx1VmtjV1ZYdUxrcmp4eFVr?=
 =?utf-8?B?VDNOYVZxV0NJSnFsMHQrT3ppaXJjN0s2SmdTSG56cTJVMVBjRDVmVngxY1Zy?=
 =?utf-8?B?YjdvYS94ZkVLemdtRzVtUWQ1MU9pZHN1TVFMK1dNTkdBOW0wRHFKVXVqcE9R?=
 =?utf-8?B?bms0ekRIMEk0QU9MS1VNV3U5b2w4ZDVMdUkxa1VYcGNPdVNSMlA3QSsrUFB1?=
 =?utf-8?B?MUM0VlhLMm4rRzZDQUZ0UlJFWjRHWURsclpQZ21SYlpOY1ovZDVETnlhQkVK?=
 =?utf-8?B?TmF3NGdjbzBjZk9UcnlqSVRXT2xudHFZREoxRTI3S3RZbnlkajhyR3Z6K25Q?=
 =?utf-8?B?TW1XM2t5UXZSb3pjRkxGc2hJQVhhUHYxVFFVOUVFMHphWE9VWEY0RUkrcTdv?=
 =?utf-8?B?WS84b1gvWEdWTTdMemR2aGFWa1NybWRYc3pwK0dwWnNqQ25JSHNFQmhJcUs2?=
 =?utf-8?B?SHczQm8waDhOdHQ0RFBrdWlnSlRRWU9rc3lZQkFjU25jOHd5ai82eHFnaGRs?=
 =?utf-8?B?T2JJSDFPYndSQTMwNzB5Z0tSeFl2b2ZRcUJDQjZxaXgrdEF0VkVHWmg0Qy9Y?=
 =?utf-8?B?ZUx0VHRybTkxa0pENTdUOWJtaFBmczlKQUJMb1RlNDhHZFluNGowSmFFYnpT?=
 =?utf-8?Q?pXdUUlUPCkQGjfqVMRYQ3thx9+X6cZybk8vYcNu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5125fa6-734a-4ed1-3650-08d8e829b53b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:10.6816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l53K8CT5yi/rPrndC3NgWhss7co9A7Pkuv6fhDzU2cjSMO6WEkYKNeu3YLKgkuWncxmUM4RVGlk5RJqzAjTBJcEpy9mF6ajTAzEVDxSLsoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 1 Mar 2021 10:18:47 -0800, Igor Pylypiv wrote:

> List entry is not used.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: pm80xx: Remove list entry from pm8001_ccb_info
      https://git.kernel.org/mkp/scsi/c/5b1be37f773b

-- 
Martin K. Petersen	Oracle Linux Engineering
