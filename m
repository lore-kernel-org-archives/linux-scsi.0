Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9497FC4332B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F43523A58
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbhAOEJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbhAOEJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43win144175;
        Fri, 15 Jan 2021 04:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SpVb8EG5l2sNs3e6AgwHtdYN1i1OpoNf5RP2tkOnWgs=;
 b=yOX7eue/GAtEwdC1q5x7hjzRxClbD8z27ntnlKbDg5uC+M5C3ZuH78IAIH1PVih0gmTA
 9BC4TYkKif4Zcb30aiivCLx0XwbrT9uvqs3vjvtRbB/j8K8/Ukh76yKhktfmpMYviab6
 BAnOPHYwaOfugPWudN7V6cEhUbXpeR6iD22eng6rJ111Gy+tYSqGiGPoH+hk5F4MSLTs
 Xjl88eRg8TVZSmp1N76ZYeVJtAK88WMdPFSMbwSBQFyUJwiOjnAOslD/hRFIgqHQdcrG
 vTGbl36TnAHsydr7gv7LHXuOyKeNEOYpdJRX/MXBYCOATUs8jLGJ1eMxfrFDNXbJ6BtX 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 360kvkb6mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46fG6095047;
        Fri, 15 Jan 2021 04:08:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 360kfagp82-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZ420hqdQSanUkdDpIfShah3i3Yoy9EPXfQMY8aMUvE8N6LYpKdG6o/bgqrjfQ+3B5bqd1mcqzuahuGaZxu7Uu0f5f9vdgfOYR6YfoW2u3rdSuOZSOw1haolmFhDrOxnG8rpF3T6EX/H1MoQJ9FakUp+YK6taGES2lUUtDA2gL4rTXPg8XrjCLtaaIyVxAsSobPQZAbXAqDA93NKV8ry1gARM0DlQLNxFJO6YTqotHQQVzluNOcJOkBzwrW4aJDSA9HP3YEFmtiN00c3pPNGNL1Fpwtmi2Ip0PIjao+EAHwtE6rLhjeLfcsS6cF/cpti2JiCcTrvpvI6fLW1S5wsTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpVb8EG5l2sNs3e6AgwHtdYN1i1OpoNf5RP2tkOnWgs=;
 b=juBeZBqGlyUpH4FjTQpMS9O24rJ9xXq09dxuIMc2HJCJlCbSpIJ3TQZR31zBH5KG+IxBefLxWDWbp59ylZij1MTkdk9gxpu6UpM7/vpKlfeamiNqIXHUrW6xKc4C9ubLPjnJaqAg6UdsiGcYEV0S7t4EatGb2VjeTjhY8DcqjbjePQzgX52mjqtR7LZyMI22ETHwww3NJoDFJzCAaCKsAFJre4rDJmyH+jPvIT0+Wu6Kr0EVj+oQ6l+P++L6q/sRyh/sv7NRGZAaZtCYy2WcCnhRlRssiyr+DMSWXfzJqIDyJdEkXxGqrll/AngxAt11WbYJg5PRlfsqjN/+4hK1ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpVb8EG5l2sNs3e6AgwHtdYN1i1OpoNf5RP2tkOnWgs=;
 b=BBAoNBq7QcLOkdUMq2F4TCO+Xnd4ZjxCxjuFciBY3GPVVemUfHQb/bV0bQCNACapb8vAUlLr1M0g7xxghZgI95//qtabuwrPLsd4a9fTDse5mcRddAxRz9h3bbjbEs2QMUGZ4v0DbrGG4YNZSKQecTdV4r1hS7p0lNzmvCA/MEc=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/7] qla2xxx driver enhancements
Date:   Thu, 14 Jan 2021 23:08:27 -0500
Message-Id: <161068333184.18181.8712062892757330668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111093134.1206-1-njavali@marvell.com>
References: <20210111093134.1206-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76193982-93b0-4759-7be5-08d8b90b431f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568C4E881C6684DE7EA47B08EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tolbPtuoFAF16YZ+8nzlPXacX/DpL5XCPzxjAi5AtMB8BFrdkLucPQWb5BWLG4aQAzEW13EsVo6hje9c5ZlgHHACwpLjOB8np2lOdqo2qHkKvCMhnFiOWmyoYIuUNnKSqMWcNN/R+jFfGjSiNk8naGnb5c7nSRKOhz00Oplf2noxVz9ESJRw/A/aD41PM0spgwR23Otu6CSjiSe5YrtckgNGmuXD5zGFsxNzPgfdwA5y9FCGOsky+Vtg/YiYA2Byy1xf6pFv++8P9d5OrPbHMyqSpEOE7yR5nEC3blHpr/bYKFk/l4dvlLtYw4xTk16BLLk5uYX1ZSYcaWw/KBgYIG8hih6vPlA+a6q+3TkTImusWDuxGNebG7uqCgBeHMgfmt6zx+a/pRkfefmxnafqf1kzzEMF0gdfLs5RN3XIliS5pk0gSpHo/0lEz2+vtFt7ZwPh47/CgGwSuNLj25x3uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R2VURGFOdWt3N2ZMYmlKK215MnZCVlZTZzlTRUF4aHZraG9aQVUxZkRKTWdH?=
 =?utf-8?B?cVBqMFBDT3pIRlNDMEw5aXEra1M0SEpTbFBvMlE2alFHeW5XaWYxQWJQK29S?=
 =?utf-8?B?dFlsaVd1QUNWU0F5bVk0aVJHbi80Y1RCcWVJYVFkbHFacjRNQVdJWEQydjR3?=
 =?utf-8?B?VG5lcVZtcVZzayt6dnBKSkVmZHVrdnBwdldwZE03d2hDWDZiZzYrSnluZjN0?=
 =?utf-8?B?NGo3dHFqdjlsY21ST1J3Vm5TQWlZTW5oTmtVUFRNemdTTVhZVERvMlhhOHlp?=
 =?utf-8?B?VkRic1E3SjBXTDNtT3lqcXREY1VmUnhmckUyWUQ4emt2Nm1iMzFWc0FadVYz?=
 =?utf-8?B?L3hHU2RkVnFnN1JRNStDMittMzQwb2I3OThqTFk3NjY5am0zSUtFZVpTK2V0?=
 =?utf-8?B?SjQvK1VlRUxMTzcxemNqVEw4Rkx1dm5mLzZWOUZpYUxuWndxYnRldUQvcXN4?=
 =?utf-8?B?clFOSUh4VHZONy9KT0tsSkpOV2cwVkU2Z2JZcGFiNnpQNlZ6alQrQXpLRDBO?=
 =?utf-8?B?eXNLT0ZOSVNmaStiR3AzUWhiMHE5RWEwRWFoU1VJazgzUmJEZ1NUbTBnd0FV?=
 =?utf-8?B?V2xrc1doMDlxZDlWM0RKWURPdzQ3enJsZUMvOVhYRjZQaGIzeEY4UVRwYnh3?=
 =?utf-8?B?L0JKblI0K2JhRFVueXRQTTBzU3B5cW1HUXA0ajI2SnRuS1k4Q1ZOWUJyYUNF?=
 =?utf-8?B?QldQbkFNUUZBWk5scVN2a25jQ29QSmd0L01ZTjhGa3BsL3p5OWd0dXA1ZUJ3?=
 =?utf-8?B?ZmxLVDJGZDFWUDZ2THYvb3RiV05kQXkwQk5XU2gyVkZOTUpmTHBqWFA2Ymlj?=
 =?utf-8?B?OFh2MUZrWTA1K0N1SkNPOTJHTEFXNW1NRExqR1BHR0k2L1B1NmtDY0hRZTZ4?=
 =?utf-8?B?QkkyK2ZmRmNqMVdVeC9HK1YyeXBnTG1lOVljS2FzZDVTYzRzMi9TRENkU09K?=
 =?utf-8?B?azRkVzlVK3ZrWHU1Vitnbk5sYzIwamZsVzZqaFd3a0Y2WURLVFNpUUY0RFJr?=
 =?utf-8?B?YVF4aVFkaUVSV1UrRlVXc1ZQdGQ0QzNsbXo5MjlwaWFMMnl2dS9mT0NxU2Vw?=
 =?utf-8?B?VHlGYXVZZit0ZVIrUi9HZ01vRWFFeVJyWkdtUFd2YzkreG5pbytqWUhvb05m?=
 =?utf-8?B?T1F3TTNxcFFwK3JxaU12aUtnK3F1RisybktnUkNPeGYyN1lhc1NoeWxWbzZq?=
 =?utf-8?B?UzN5L1YxRC96T1Qxa3VmeXNOTnhTbnVoR2NDaTJDSVFBaCtUWi9NcTg4Ulla?=
 =?utf-8?B?cWRNY25ZbkJ1WDhHT3hRWlVmaTZ4bjduWm56YWpMcHpQUjZZWEtPSjZqSDlS?=
 =?utf-8?Q?0FWT5AjU0xZ44=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76193982-93b0-4759-7be5-08d8b90b431f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:49.7200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQ8vKUWxqzHdSpQ/3Hdi6UN60IL33yMc1wIIth/b1S9lSXaJJ9HFP95EwxNcL1uBfqzsMTjm8+aGvO6AlYi7hqM8K7oRmhVa5opTzcBkiuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Jan 2021 01:31:27 -0800, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver enhancements to the scsi tree at your
> earliest convenience.
> 
> v4:
> Use defined enums.
> Make commit messages more descriptive.
> Add Reviewed-by tag.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/7] qla2xxx: Implementation to get and manage host, target stats and initiator port
      https://git.kernel.org/mkp/scsi/c/dbf1f53cfd23
[2/7] qla2xxx: Add error counters to debugfs node
      https://git.kernel.org/mkp/scsi/c/307862e6697a
[3/7] qla2xxx: Move some messages from debug to normal log level
      https://git.kernel.org/mkp/scsi/c/daaecb41a278
[4/7] qla2xxx: Wait for ABTS response on I/O timeouts for NVMe
      https://git.kernel.org/mkp/scsi/c/a04658594399
[5/7] qla2xxx: Fix mailbox Ch erroneous error
      https://git.kernel.org/mkp/scsi/c/044c218b0450
[6/7] qla2xxx: Enable NVME CONF (BIT_7) when enabling SLER
      https://git.kernel.org/mkp/scsi/c/ffa018e3a5b4
[7/7] qla2xxx: Update version to 10.02.00.105-k
      https://git.kernel.org/mkp/scsi/c/dc0d9b12b8a7

-- 
Martin K. Petersen	Oracle Linux Engineering
