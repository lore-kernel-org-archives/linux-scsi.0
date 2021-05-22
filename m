Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7364FC2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B906135C
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhEVEmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhEVEmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZNMW043063;
        Sat, 22 May 2021 04:40:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=j23CtmAMUnoafEilqsDpGtL6RYfD6mAKIoyxiZGIs4U=;
 b=dDiEYXqSqW+Hndsi1nXE0EP0vsDk4sjCB0RZmlsb1Ceuk0tV6KcD8kiK/LSulWyz49xO
 nA2BRT9CdtxazUN677FBjdOb3Vb2fEuFyj6qjl8H1olEvPCvKm1W/wueYe9tZqmjA7u9
 qYxMyRF3BEB2n2ihpcov3LcCxJvNPjAz9ROhvJnhdWvWvMmxKLL3Vc8aS8kSv5kyGHt8
 2yqU9pTx+xNamnXNszopXfTX7JFw1necvNzik48KB1Vp6qRKkAZVN6TpWqtFkK0Kw7Q/
 mWRspkaRvE57t46qX5JSECmbPUyfpYEbaBVBkDd6NPYNF3mBT7OoqALFZBQpC4+hy6nJ Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38pscs81va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4aljK072530;
        Sat, 22 May 2021 04:40:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 38pq2rp5bv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdP++maloW8qUQ6Q017Q/J3f60SCWRF9jt5LNA9qAX4xav121GZHVTF1mLbzJIG5vAHuwXNGJdR4lhzpNBxXjKFGKGWfe4SH1F0uf3HU8Wh2rrYFH/3B9ssYgPsdjHeEvpVRusNMBleDZ+bzjZPKlhBP52SrR43vsoe7mQa+bo3L7JbK7twNs2asm9GR5RjDt8ZBLrb86Lr6Nuzi+DIUQyCR0sr7kTfhbLsPcGW6XgdMxHD8Wp6SpBsXTZKY2YeQYx9UV11p2UxhY4E4q2FXIj8bvlC1lMmcTzuLyz3HmqxbSKIUGMUoGtoK4oY3lTAjLuJnxBFEIj+pnkmckUGj+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j23CtmAMUnoafEilqsDpGtL6RYfD6mAKIoyxiZGIs4U=;
 b=od7UJMPqgBZG2VnZYLedi9aEf3qJuvETtLixYzeoBuzOg9oyvEZ2nXLgB3BXsKTjLxUhdTcuTQ0IsiaiIWx4hhx5VkN3RWi81r8gruXZp1sdGdsiH+9Nws0LYpz7B1HiNUEAtxJei1G126E3jQN7laRHCvX0I/x2ROlDC2UrCSHATR8t9h7fDo4ZjFKK/MRrwzHCoI17ym0++nVqxkM/NG7nXCR7wBIZsYINAJ3+7j+C7eFzKx0D20Y8DOPWMqglVUzG11Pj74ZoHsHiDu0al//0QhaSfGoKkMliqltyw+cdkwQZSZ580o+Cb0UWaBa5yTxoB6zWsT9U27ZBjXZu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j23CtmAMUnoafEilqsDpGtL6RYfD6mAKIoyxiZGIs4U=;
 b=I/NztWhPiXU2wSnrJkiAetLkLkvLHDi/xu10tVgDoGx7sdz5AefCKQ4hiZty3WhUr1Ms0+p3SsycCl3atpr8xNEGLInOpsbhgeayC2QPjEgca3Y/cQCYBOrbitkpa0bhq78MJX8SGxEwh1x7x/sPJfhs6PQ+1sPemAhBg8AEJK4=
Authentication-Results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Matt Wang <wwentao@vmware.com>, Vishal Bhakta <vbhakta@vmware.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pv-drivers <Pv-drivers@vmware.com>, linux-scsi@vger.kernel.org,
        Elaine Zhao <yzhao@vmware.com>
Subject: Re: [PATCH] Set correct transferred data length for PVSCSI
Date:   Sat, 22 May 2021 00:40:37 -0400
Message-Id: <162165838887.5676.7922034053838420979.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <03C41093-B62E-43A2-913E-CFC92F1C70C3@vmware.com>
References: <03C41093-B62E-43A2-913E-CFC92F1C70C3@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b193f427-c57f-46af-461a-08d91cdbc5f6
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54816CFD6E585BF06079B57A8E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Py/O4mOu8ZZJK0UqNpwsGFeOADlCUfU5lJmcSRiySUQi4c1pBAVuR/+ewG9Bl46h8PQS06QQ5AdyfP5H0vgdev4Ritfn+mFyDytRJFWaLtSDu9fd2+nwJ8Uj1TLpUIga1OvpRIYBDDDRf2E5n36HXgg9a2j4K1oAqk694As2hLH/+wd8pxkprNqCdfSwjSamqBkiUVaFuotlKeHdKsbmlD7ec7aVBCooYkjr+gtIpUycfGPIC/LbOOPutbQRGvgoUhOxytVYuOg2nEmLi4xtbs4ySD5JW4v69+ZNDnTZimeKMyssJGFxGTExciTUKUc2YFoE/5V2INp8/TcPvPJTIh01KxLNEQyQYNtTwX4xtJZ4y6KpxEBbTmnmA7hdKTnpSxgf4RHu9ehXhrRQJPPkN6CYafiTYv893Gaplw2lia3H4d+PPc84kseWWyZ74FeGKFoTgt0BhsgRX8M4LgnLlVsjG4CGBsfVjygR4WmG9c5DdzcevO5/Veu8x7u2RXLysj7l2u+9DmU6fltdS3RPpUmscOwTvp6+Vrcem6Ulmw4TazdIAK6cPo9THrf4o+LH1qMHXZpeRSxeAgy3RbcC1BrR4H49zKDL/Hsp5ZF2Yk/9j4pe6xPYPQ2E/MU+daMmqVijrPtspvFufYMMrm3X/SmHx+ODaTxX4AHjhkU1QxamHUh4RNJSk7KLvkQV1ofxBXPXaEc5rJ5KaXflfvY8U9utSAWCzY4NNtrpymOIp+wdbgfgARazWnFl113+51ihIKyFPwj24WfVNRmNhdszA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(54906003)(110136005)(5660300002)(2906002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mm1JMUpqakcvRG9xSnJEejZCbjRuRy9oc08rYTYwSllKVE5uM21LMGlnYzJ1?=
 =?utf-8?B?eGM3ZGRhOVJUd2NmWUJjdXFPNmhOT3J2cTZQZWV4Mk5sUUZ0UTJLOWlzdk9N?=
 =?utf-8?B?Z215NDJmVXRJRmNrZlNrUmhrVGR6c3VOM2VseUJVLzdiTkhGNHlZb3BuWkxR?=
 =?utf-8?B?eThmNWcraTBLdnh3Sng2QlZ3cytYbW5wSjhOSUJ1NEhxTmZhUzFiT21TU3JP?=
 =?utf-8?B?VFhhUWwyNTdRRmFHbmNBUG9DZGJLc1c0ZHZyd05RUWF6U1BTY0k5Q1lLNU12?=
 =?utf-8?B?UGVFOEhCaGFkRjZIM2s2R0cwWjQvM3FHYXZDZTFVaG0vdUVLZ3hMZmhFMjZW?=
 =?utf-8?B?enByV24vUVQ2Wm0rc2VPV1I1ZVQvUGJwSmtjRS84NVdlSWl0QzlvOXVReWps?=
 =?utf-8?B?RGIvTE5MaTFaVzVqY2xkT2ROcDdrSUlNR0p6RUtZa2wzb1dMNUwxeDFmdm9J?=
 =?utf-8?B?eUFUMHZYRGZZT3lYWG5SVjVWeVV0NUZXSERlUXlWYzBTdXZkaERsdFBTSzNl?=
 =?utf-8?B?RmNXUGtQOVNXTkkwZnpmU1EwV0psSTcveDE1NDZub0ZkMFplSmYycEVra0Zv?=
 =?utf-8?B?dndjRlBjTnY5UjUxblJDZkp5dlAvOHlVeGw2eFBKY21kTFppZWo3WVVsR1Vm?=
 =?utf-8?B?Q2ZxOWlzVHpRc09hOVFtZ3JzbjdKREpZTWJkWUkvV0hWVElpTVJpU0dlcW5Y?=
 =?utf-8?B?TUd0Q0JVVStlNmJpN2JRVGNsaktoYi9TZTBOSWlaTVZYUzZvMHA1NjRFUzV1?=
 =?utf-8?B?cEJMbU5aZWlDRWJ6a3NWWW54cG1ZMksrSGZocE03cVEwMkkydERoSm5kUnZq?=
 =?utf-8?B?VjdHTms2VTVSQUkrYkJHdHJWMjcrN3VsRE8rbTN5YkhueFQ4ODUySEZsN1A0?=
 =?utf-8?B?cUdhTnhlR2IrcUlZK0V5NWVJaTNSOUM5QVlVUFNoeVRGekI2RUpiSlFxYUdy?=
 =?utf-8?B?ZmNQM09GdEhmaGRDUEoyV3BEb0Z0ejhZenFUMm8yeVltRENLbnc0djA5RUlZ?=
 =?utf-8?B?b0MrSTRGRzlFQjEvK1Y1NjYrMGdoTkZoNUYxaXl0cXc2dmhFTEpaS2c2dWdk?=
 =?utf-8?B?a1l4RDQ4d090R3A3Tmd2a3QyN1dTc0UvbEUwbjBIREhBcUgrQWk3ait3V0dr?=
 =?utf-8?B?WnJ1MktSVVB2TFNLTXNCQ2xTSC9WWVd3OW9pODViUFFuSkYzVDhQU2Q2UEZv?=
 =?utf-8?B?ODk3VVpkZjhVWFJGbWliZzhjUDNTVGh6cmdOVk0xNnY0WWFobG1yTlpxMENH?=
 =?utf-8?B?UkV0dzl4SThXdFM0cllzT0d6cjZRYytqbjZqdU5HNDBaK3ZWeHcwUmkrTVdu?=
 =?utf-8?B?NGZZN0xBcTUxcGg1TjJyc3AxaDRkZlNaUU9CQnpieUJXUnc4VUhTQVZ0Sjh5?=
 =?utf-8?B?Vk1CU3pVdWFtS1lMVXl1OFdaRXVFbmV3RzJ6dVJlYjk5NzhGTVdDc1l4Nm9L?=
 =?utf-8?B?cmJReldhWTJuTExvbW5XalRPY2MxU0pFOEs0MzIxZXJiZFBHNnl6OU1XOXps?=
 =?utf-8?B?N0ZyT3BIOVgyUllCS0RrN3dsNHRhRHc4bm9kaWpLWkpFd1NSYVExbzg0ZnVM?=
 =?utf-8?B?NDFKbm8vNjEwMXFINmpoakpNSUM3UHJyUDN0aE1MZS9NMlNocytZREpkNWRU?=
 =?utf-8?B?RHhIUDg0aEhpenFuQU1ycXZyNExxMGFqUnVBc0hHMFI5d0ZKdld5dklQcWNM?=
 =?utf-8?B?N3pxL1QvM2ZneGFYZVlVVWJpaDB3WW9qM2UxMk51N1FEa1Z1cXZXR0ZuS2lT?=
 =?utf-8?Q?TbNrhQNVrn+IGJVeNdMOzPzSXcc+j/Xt4gYXNu5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b193f427-c57f-46af-461a-08d91cdbc5f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:49.6025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6flrbk2v/mgMOpU/l6NOd8JMfaqXo7ns2zNVGLrUfBGQsaKQY9N99uUnan/KX4kuh6mVzT/jOiV6RMqmMI4UsgWhBG7aH+QyMwdjNCArK6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=852 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-ORIG-GUID: 76SV4W4UDGX_OU9podgzlILhQYx3Lwac
X-Proofpoint-GUID: 76SV4W4UDGX_OU9podgzlILhQYx3Lwac
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 09:49:32 +0000, Matt Wang wrote:

> Some commands like INQUIRY VPD pages may return bytes less than
> commands data buffer. To avoid conducting useless information, set right
> residual count to make upper layer aware of this.
> 
> Before (INQUIRY PAGE 0xB0 with 128B buffer):
> sg_raw -r 128 /dev/sda 12 01 B0 00 80 00
> SCSI Status: Good
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] Set correct transferred data length for PVSCSI
      https://git.kernel.org/mkp/scsi/c/e662502b3a78

-- 
Martin K. Petersen	Oracle Linux Engineering
