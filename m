Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43264C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17749610E8
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhDBDyl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbhDBDyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323s4D8125915;
        Fri, 2 Apr 2021 03:54:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kL82FdWoMdyf0388tgNTjHx/09xhD+sCOEIXZkRLo/I=;
 b=WJGeOw8tHEAPyz67939q7YN0f92tL1zxuCIqEShMR7sh+eCbMQKiExPg+Sb7OoSTBQ4C
 SuYXrKPmoe2nYqffpISxuuRA7ICq7DAUBD5sGmIjdhitWqq/ne//WVYMaqbf6D7uJCha
 C7zWjOhYq2k59pZoMCW3uuG0xOWQ8LT6/RL7ALgO0jZCLjRibnMMghDsh1GQN72DNtrY
 fXZrC35Ef2lO4VzfqHFe4EaweWSXZUmTpDYGjqL6UcAZ9I/Vs0soVHlV4jv2minTFsKT
 8B2EuJnFJ36CQs0Rkq+e2gJ+gm3x4uIjjSkAxmVGEpL2VnHxFYRjsF7A7Z6DpjssgysL Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37n2akkq73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323owkR170973;
        Fri, 2 Apr 2021 03:54:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 37n2ac2k8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtrvdASc12JgiyLSHwiyjVshT6xukFo+N05xgti8LNI0cuYqb+TT5PTRHbb1prwnMOjALBkRNIQKNpj1talvgYabR8/hGwc/sHT/X4bnTa2yhKOvxaYBHtUxuVZ11fkY4YETPqdNBnUjUaxPFPyT1kIiIoXgSK0Rg4pnROqnIjea5vlI3jez/c2jH7UZhaysWZpZdSbSk4XgSSeyAOVsF1QVY0qFHY8yjEoGNCI4iisyiZW2psxf3XHXNVdDr0/mTUhe98683/ib9AMfxn+/uDHY82pbGzRuDMJsCH1jgO7IH54R85L0ZkTMrJkdNKenS8kFnY9kCYGLM0YnMBtiqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kL82FdWoMdyf0388tgNTjHx/09xhD+sCOEIXZkRLo/I=;
 b=frT7KabD99eTP6mGWXAxwSmBJhDp5ZQpM4/kCGkEhLqtMYd/fywMCICAxu1DgIV2U/HxaNwikCdKrkuqtngcw3jpTIioiLthpE4w9WNE/A7ak40MdD2R5wdWmfj4jP99n2SVIChr+vdV6pP5AGGMyHTiED9Wst5JPhmbXKfHvdRmYZlLW9Er2sqIsZ0fFdW/APM6umqW6eGSY+aTw0YePZqUHLItpLTKkUhI8/fF2d0vhSseHxLa9Wdrm6KC8jmx7f8PIHmO8y1dIo5kiD3mP6cFqjRYurP7IsWGkyxcFnKLb9jNryD0GKUoU2YvuV6AzYHOrObPs7ib+Y477vQkpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kL82FdWoMdyf0388tgNTjHx/09xhD+sCOEIXZkRLo/I=;
 b=fBU2ihVvdVbPprcTkBRW3Bjy2bT3QfdXWYwvdN6/gkuc+sRrmzv8/AqXdzeqiJpVjtypxujdlFYCjLih4KBrACOn1weH+dlM2vvJ0yX3E6yMO2Ko2NyfSccmpkToRXn2JrD7rSg2dJHgvbARzOs+viiqNbdF5WrxCzsuKMIJmjE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 03:54:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        loberman@redhat.com
Subject: Re: [PATCH v2 00/12] qla2xxx driver bug fixes
Date:   Thu,  1 Apr 2021 23:54:18 -0400
Message-Id: <161733541350.7418.8985611855724335726.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85039683-99f6-4c76-f871-08d8f58b04e7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47118F9456AB293BA2D661C28E7A9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TzZOAFR9OwfgNyx6hPehnMibpgSAqNuc0Tnzx14UHAWJC97Ppi0l2/JfaLhzcJP8eIf+ys8iEMFs5ghZslatxu2+bBaMsx//27Q+xQ0Q28fuUy+kZujem9VUx7hHQyevVrj3SwU8+4h34vj1GI31pUZfk+1pMw9N0u6GK6z9nA6KdGDIyoNx7q8Z2ofVw7A0edwpyE2Gnk29swQkgPxjjmRua3BRbHUfGJRL5Ad5vpveCODIHM53UfQLS9wu4i8OS5553oR0XB6tEkXqD0WXIQ34x7sNgb/Bp7H5ixTqSSHPsdVSd8WkM5mxgo6rYDk5kB9UERDF4CaVVxer5PLx0sK71rU2OX5Lrzsx2mcuQa3ocK9F//P7oVcxLZEGB8D/azuHo5ddUhaBtg6FIxjAzDG8syr0f6nxQ/d2fSlZnScC5nrxTuIDGi/sOgQUS42J457TW87HJ0k5ClyskhMIt+gq87+oTerBUrVJMRPyAk3iyqIwtGfFJ+ehdl2/ocXhCqv6TW60Tv4zGMHkWeXvGVVtU0KUTDZQXYifkclRUH42nh4ul5bHfTHxa/AKkoppwiJSpoDM8eK8bOCf4w2ocoNOAjzHaa36PoMZX3sLwvDEkHDnLNEXe3oQQxml5EZk3AW9fb1YL9W5L7ZHR32jeydS3iXekZ5I3bTaMMZ4pkXZVWOnVZAi04ilbzElq8sxvced7DVmCwmlrdPsbWKvQ0sIxpmKET4RZuCottscI1M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(38100700001)(4326008)(316002)(5660300002)(478600001)(966005)(86362001)(66946007)(66556008)(66476007)(186003)(956004)(103116003)(8676002)(6666004)(8936002)(6486002)(36756003)(2906002)(7696005)(52116002)(83380400001)(2616005)(16526019)(26005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S29iVXNNOEdYdngwNU4wb3pETk9yanBsUE9VeVhpTWplZ1JiUGVRVCsyTjJK?=
 =?utf-8?B?azhWYUlaVUZNUUU4TFNlQUVrbXlLQU1FM3JJaXBYMytUOTBFbmdMRCt0ZXRN?=
 =?utf-8?B?TDdTbExIbmJycld5MGZSUENOUHBqMmg3UUhjNTVMZ1pPRlVYaVdqdXZJaVFE?=
 =?utf-8?B?WmQvejdzSFp1Q1NsY3hSQXhlTEc2OVhMMVRSb3hHTW94dG95bS9JSUpuYWkz?=
 =?utf-8?B?QjU3MEg1algxZyt6LzR6a2c3eWt5RUtHRjJDWXcwN3hXckduK1lTUHlMNWZh?=
 =?utf-8?B?NWtwNXB6ZHNkb24rbGNESHFqTmxEN1lvR2hUYkVIci9ZOUxidUhnUUlXR2Vy?=
 =?utf-8?B?OE1YU3V0dk9VR2VXdjQzdGVLa3h2SWpZN0ZaQUhhaEFCeXF3MG1IcktwS0xG?=
 =?utf-8?B?VGN0NXlzenp5VFBKUFNWMi9KVldGOVNqK3VBMmh4bWZzKzJ1TmlUQVJQaysr?=
 =?utf-8?B?RFlFUVEyV08ycXQwQjNXRVJCc2NTbk51dmZXNjRQN0tRSitPQWdKemdQOHRa?=
 =?utf-8?B?eDNUdWVVeDZwK2FSNTFxTlNoRXFjdkRTdFl1a2JQRU8xYStGQldOR3BPcG5I?=
 =?utf-8?B?U29yalk0d1ZyYUI1VDZnampIN3podEl1eDExS3ZreFRrV0I1VEYrM1h0cThj?=
 =?utf-8?B?N010S2srckVYNi9wZlhNZFJKRExPVUFQVEY1ckllT0E4VnFRZWZkT1hERUJw?=
 =?utf-8?B?dVR6djBBYzFwamtGSWNsbDQ1TkNCc2VpYXd3SFdCckVnTXNyTEZHNndpVzVV?=
 =?utf-8?B?S014SjM4QVNyVFloMjNjbXZ5emxPcnNHUVUvYnZ0TzZ3M3NzbWQvN3AvdVo3?=
 =?utf-8?B?SkFJam9PemJpcnZseTRaa2pRbkh2TXEvMHBjVUdLdnQ5QWVFbjNYWFhVUXpT?=
 =?utf-8?B?eGtuY0VwYWdMUlFicnliNitobG85S05QZkgvOWJ3ck1XK0hORUlCcHBwOVlW?=
 =?utf-8?B?bzE1Szd3bVltSGpEbVc3LzYyM1VCNjlkNTlNY1RTTjErNTVVYjczbDJpZGZa?=
 =?utf-8?B?dEdCaDJzckw0VklUSnBQdGJ4OVJuN29FVmxkSWlRa1pzRGFBYXFucm1VNEhx?=
 =?utf-8?B?czN4K0lCQnpQNlQ0RGRZN2pYaUQ4Mm43ZkpGNXBCelBaRWZmTis5M0RoUllE?=
 =?utf-8?B?bnJzWXpZOURBMHpKYVhSM2JuM3pPRkROcnR4NU1PVGEzWExSYlZYK0hUUHl2?=
 =?utf-8?B?cFZnTUNrLzUrcDhmaWxQMHBlODViRUJQR1F4RzFkMHQ1alJWeWRPTlBlWDU1?=
 =?utf-8?B?Wk9VbUE2cThmYjVIZFZhcnUzYVMxdVh5Q0JldXFvZ090YUFtb0tZWWQ4K1Zu?=
 =?utf-8?B?Vk5CblFnRGFEVVlTbnpoR015emw5enA4aWhsemlGakRBZjc5bzRhSC8weEFh?=
 =?utf-8?B?cEhXNktZUkpiL1FoZktNMlc2ams1MEZOaFAwR3lLYTY0VDF5MUM5VlM5SW1W?=
 =?utf-8?B?UWNNa25KOXc0QlY1T2xQSGhHR21MYW5SVTE0QTZwSDlSajBFOTlhMFByaVhq?=
 =?utf-8?B?cFU2YVVSWlZKaS9pWk5hbElyYmdWMU1taTRBUTdUV0lUZ25jcEtCYUoxdlEv?=
 =?utf-8?B?b1dEZEV4QkNMd3FEbG1PVDlHZHFjMVJOQVFYcnNjbXllWW1wV2JkcTBwcDl0?=
 =?utf-8?B?b2IrSlFnNlNudUdpdlhSb1VLQ1hMbERoa0Z5T09LdUxzblF3ZnVmN05nMjAr?=
 =?utf-8?B?S3k3ZjJuQkg4NkNVTkJ6QVdyMU9ranRZcTEwTkt4QXhObndFYkVTVEkvTzEx?=
 =?utf-8?Q?ukvBp9XJFZUiJ4JTjL0OnZVyYrk8aPessqXKvCS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85039683-99f6-4c76-f871-08d8f58b04e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:30.6138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pd/GJIr7i5rEFUoIuz5c5URyw8wZEhP4THKu6zfIZg7wd8ZIZrROdjr+w+HRPZmGEWbfmjMHIW9Dm1pdzbtPefHB6tSlXRvsqwfRJztFNXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-ORIG-GUID: 27BPdqgTqxYPCiFE4czz0GgItR65gVMh
X-Proofpoint-GUID: 27BPdqgTqxYPCiFE4czz0GgItR65gVMh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 Mar 2021 01:52:17 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.
> 
> v2:
> Fixed multi-line comment format
> Created new helper routine qla_pci_disconnected()
> Added new commit "qla2xxx: Do logout even if fabric scan retries got
> exhausted"
> Added Reviewed-by, Tested-by tags
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[01/12] qla2xxx: Fix IOPS drop seen in some adapters
        https://git.kernel.org/mkp/scsi/c/bcafad6c2d52
[02/12] qla2xxx: Add H:C:T info in the log message for fc ports
        https://git.kernel.org/mkp/scsi/c/a63f4c454149
[03/12] qla2xxx: fix stuck session
        https://git.kernel.org/mkp/scsi/c/c358a3d92b32
[04/12] qla2xxx: consolidate zio threshold setting for both fcp & nvme
        https://git.kernel.org/mkp/scsi/c/5777fef788a5
[05/12] qla2xxx: Fix use after free in bsg
        https://git.kernel.org/mkp/scsi/c/2ce35c0821af
[06/12] qla2xxx: Fix crash in qla2xxx_mqueuecommand
        https://git.kernel.org/mkp/scsi/c/6641df81ab79
[07/12] qla2xxx: fix RISC RESET completion polling
        https://git.kernel.org/mkp/scsi/c/610d027b1e63
[08/12] qla2xxx: fix crash in PCIe error handling
        https://git.kernel.org/mkp/scsi/c/f7a0ed479e66
[09/12] qla2xxx: fix mailbox recovery during PCIe error
        https://git.kernel.org/mkp/scsi/c/daafc8d33ff6
[10/12] qla2xxx: include AER debug mask to default
        https://git.kernel.org/mkp/scsi/c/1cbcc531d01f
[11/12] qla2xxx: Do logout even if fabric scan retries got exhausted
        https://git.kernel.org/mkp/scsi/c/022a2d211ce0
[12/12] qla2xxx: Update version to 10.02.00.106-k
        https://git.kernel.org/mkp/scsi/c/10d91a15f26e

-- 
Martin K. Petersen	Oracle Linux Engineering
