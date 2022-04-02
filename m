Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1930C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 21:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbiDBVis (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 17:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiDBVir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 17:38:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71EA5574A
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 14:36:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 232F25mn016332;
        Sat, 2 Apr 2022 21:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jdUL4YBDQlp/9fp/aEckdd3fU8k1tG9gcK6RzHqd7NA=;
 b=qqN5b+TFy/j3xsh3BzFvjZPMsRNprf6sDDODvnEZt005CgN/dAoRwnStgddLuNWaZoQG
 3BXe2B1jxvuOX1WuIL3vhyxR7LKUuwMnuqgtFvR0UQit3+B51n3MvVPmfJpOsX5glT9h
 IM6BWklV+YbEFlTQdeWtz1ZHsM5CG4Zc+1G5XPNH18ee+IN7PjMJZ9MyUVLOSnK3ismJ
 MWKDquIuy4eyTjk6in3dspQz9+hNqGPumsp4CtsHRqH+MnJTNrQTz05SnJs23YTM5QUX
 3xkQjxlnFlerLfDEQnCSGXib08I5eTUZAuNuCgP+hCoPLYGDOf4LKZJMJt1lsLHFCMiX LQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwc8rjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 21:36:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232LFjQH027233;
        Sat, 2 Apr 2022 21:36:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx1dxdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 21:36:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mr08UDmb3nXa1Nuztvjj1hdoWRhQUH3vNC4kaOkJ4BDOwgxNqvd9gDibfkYNMdWJMR75BjIu7aM8fpmiAxLa6cZuxbCqtWwgGerZdqHn//2iCB4uAhGV3QZFS4KV3fsHy0M3sG1R5WV9YuGIjroFh4OR+U6XoJm1Kd/v2gzrsE7X5XxefUZ6+E0kRJf+zBuxBs2yCPvhrmbFAcLlEedy30majKPfl9xwqH4Y3Z++FKrBy8oAnU+a0NMASGXS0RUaVyT1S+8mcPKCLVDi3hrR/ApMTM7kEGp1WOZ5ODm8ro2iRLuAmPqzcHAsvlvP9RvSCasuUomK4GqR6+gaD9H7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdUL4YBDQlp/9fp/aEckdd3fU8k1tG9gcK6RzHqd7NA=;
 b=KURSInUMlAippYtz/SjLpzi45+a9rqf0ZMlW1MMp1lZ0RRQLKiuhURV8hUzHPyb2pbRo7Wve+5jj+1WfMDnp44RXE4Xo9WZFiTCx0+zQNg3IcnE2ad5QBtTUdSrOOdB2Jq/NU45UdN2TttuSixadzp9sY2tlxasxpjxiPO1SsVo9Zu0UThT0IeonfS08z+yqMljYmkpLV6piXyyjIbVCTakRVAb4dzPcgPxiGmlp06mJIl445mQVMQVdOMqgNfcLvucTdYV8C/hVuhUjiTkCtHl8XLpsVmFoZ1AaomDrY1uW9ZxMz9mJQn/XwLbdSUTMcSRowRJNmahhOBB8yRZwvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdUL4YBDQlp/9fp/aEckdd3fU8k1tG9gcK6RzHqd7NA=;
 b=NLbFyEeE78snUzHHy5nAjRVVBfilpHHJMZkcaoSId/dg0UswAm8VcrPVh/558qq2+/xOMqNCe07xEFMc5O5nLqoVYnP9jSkpjtxS8mSIfp3DYbnqD3p6YpjC4pH27cFQsjecMEwDBSm18ML15lriD9SH0yU5/ADq4RXlQvQUYLg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.30; Sat, 2 Apr 2022 21:36:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5123.030; Sat, 2 Apr 2022
 21:36:38 +0000
Message-ID: <938e519b-5aad-f3b9-6b7e-dfd9a4b9da02@oracle.com>
Date:   Sat, 2 Apr 2022 16:36:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V3 00/15] misc iscsi patches
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220329180326.5586-1-michael.christie@oracle.com>
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:8:2f::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c876381-bd9b-469e-09de-08da14f0de66
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2709835B92680E8C1FC19CC8F1E39@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y3kEOhqIcyep2CNgejm4JtSkUfsUEVDmuFtaRHZmNFyyp1Kg6szvtZ623zv/Fz9shRnDQjDet1hqMStqM/G9f5oKA61opdi8NVtrjwaIGKF4u1jjbowjcz9JumtfxfrpkxUR0aDe7AEkMoY0vgHvSP8QgG3/BdaAIyDCYT+BcrFLGb+sgwfytlmg6Md+O+WB3glUVCuXtU3Qi0/VRazI1Ciht4nZzDCLWLEnVZEm4cs25ZVy/pEL3PIXJBg1ZS2di/LBhKF5jHSj7Er5SjsZaXD6HVF4t1/O+CAhRx+XxwH5xTE+27tFT4VWDWXEkBCfHtbDPeolYd3Q8UdFvh7TV1k7TL0ORNpsgFB5Q3jFBc4xvsVKSMwRsLDIz+f6KOq3aOcKjA53NG+UpY7MaTn7wKpTd95CRzSKIIgRKyQ4nK4txci+FWlNqNv/y8imrKht3nN/cEtBX/BTLsY1DfYn85M6t03pPpsSbIjS0mapHGgPCLHuEtHluBCnbRy6a/BdM6viHlMS9XKZTD3J27YQ38GFjmpKmFKCSGOSij1iIwm8YQrrsyevuE76QQ5cN1gWQ3U8gtZAoUjKq8wfBDR3YHAYN5/HM1xkH6WbMRDXZV12XjVdphyLwFBqP1RwSfk7L0BqLV3J0F0VP4zNUili+PSqknsDGTUPkzMmLOjWbpCCU0Abr1/gellSvD+burbeYOyb91MmzVJ4i6v1M05RbZL+OO6M4DCE7+rS0D13pcE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(83380400001)(2906002)(316002)(66476007)(66556008)(66946007)(86362001)(8936002)(2616005)(5660300002)(186003)(26005)(36756003)(31696002)(53546011)(6506007)(6512007)(508600001)(38100700002)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0JvbHU1Q29wa1U2eDN4bkJPdkYrVko5cXVCWWM2QlJmUVo0SnJFUnZiNVhT?=
 =?utf-8?B?cFo2b1lqaFh2dG5hRkVtUEhWWjYwcnpDM08vQXh2TkozVFRoRHBHclNha1Vx?=
 =?utf-8?B?SEJQYXJOVWRhMm9rNUJjRUlGWC9mMlJ2ZTMxVjZHUE5LNGppdWFjbmxwVzlZ?=
 =?utf-8?B?QTgvWUZ0d1B0QUlCUWZQckl2SVdoNjRkdVNqY2UvOFhJVTdjc3orMGxMZG9L?=
 =?utf-8?B?eGtnb1hnVERXT3RrVGwzaXZvZzQwSFh4MVByK3ZSNUZqM3VSK0R6NjVEdkNa?=
 =?utf-8?B?dVFrS2FTd3RwcEE4NEVseHhwWllzNjZzeU90TEJ1bHMzYjJsUXF4U1JreWRM?=
 =?utf-8?B?dE1mZU1ZMGtCSzRkWHZoZTI4SFlqQnlNME04Mkdkd3pVamlYSFRMTFp4RENB?=
 =?utf-8?B?ektmYUZWYzdQc25VL1J3a2pHRXA4cys1azlYQStqbDZRb05LNCsvTWJDUEcw?=
 =?utf-8?B?RGVWV3RrWW1LZzVsWVRJdUYyQk5qb0F3OGJmQ1JLMCsxTElaeHZ5VktZWGt3?=
 =?utf-8?B?SGVkMkowVFRZUTYzQ1dCelZXeGtpR3I3Q1A2TzBnOUhhSDkrWSswZCt0WS9k?=
 =?utf-8?B?VTExMksyazF6emJqVjdzZ2theTgrbUNIY1dyMFFxZFcxSklHemxVY2RENnpT?=
 =?utf-8?B?T0k3dC9DeTJUTlRpeXFlREdGZDdWSFd3c0pQTVM0ZEJEdW95VHRwQ3pXZjlv?=
 =?utf-8?B?QWtpWFhnUEJYZFRaanYvZm1ZZTJEa3pRTEhRQkpvN2I3YTExaXhwbGc4elow?=
 =?utf-8?B?Ym5idmN6OUxUdHZvRXBDTHNnM2E4ZURvaG12MDNzc0UyK2EvdFJXNTRHZVZ6?=
 =?utf-8?B?NXdDNHE1TWhHVWZjanVIa1NJQ2NGOUpFSXdEVHYvVzE1MzgrdmlpZXJ1dXBz?=
 =?utf-8?B?S1BqSjhMdjdJVlJndytpWWE0N1F3WVZlenZYcmFSSGJsaDN3ZmY2K2pDcXAw?=
 =?utf-8?B?amw2d3g5NGVyakh0MCthN3ljYThMRk1IaU5IN0FBT0JwajRqZkxydytJNVZP?=
 =?utf-8?B?a1N4VEkybGtUQWNnbW02aGZFck5LU3YzNXlSYnViQXNPVmFLeCszaHQyeUJw?=
 =?utf-8?B?Ynp6NEg3UWJES1lYTVpXb1plRVN1RUpBbTlUckp6Q0hSOWpiRVVBcjRiaUNa?=
 =?utf-8?B?ajhiS2xMMERzOEFJQzNRSzRjVDdWM0hWQ0xjWG51ZVV0Q2Z0QkNGNG94ZmNw?=
 =?utf-8?B?U1V6OEhudUJPeW5ZY0RVV3NQRnZiY1FhbUoxUGRnU3pCSnM2eWtVWkpSY1JG?=
 =?utf-8?B?bXFLRnYreWhEOHlvVjlXTkpTUGJUNUxBa2JxVHRvemZacmowNTU2NnczRk9u?=
 =?utf-8?B?WE05NldqMU5GNTNHVXdnY2RiSUZUbHN5b21iQ25Ecm51TGFPL200R3REQTBv?=
 =?utf-8?B?SWxJQ3crMWlHMVdlNFpGRFV4Z1RVbkNEQ3lLYklpaTRQaWNPcHE3Nmg4Qlkv?=
 =?utf-8?B?N081aXhqM3hEUThkUGNFOGdHOVJWaXVLcTV0U2xmS2ZQbC9jWlBNd0tXSTBv?=
 =?utf-8?B?RlJBVXVFaU5LcVNKMlJ3MkdpKzZNdkltcnpZN29XY29yam9NRnNsdE9ycUVt?=
 =?utf-8?B?Rjh5Kzdkbkc5ajhTSkJkN1Nubk1od25uWmRxT1N3NVlnVldQbWdOQjlpN0Zp?=
 =?utf-8?B?dUdySTlYS01vRUVXTDhUK1MwTjNYRGVOMHcvKzkrYzlWdkNlZTYrQUFxMWhz?=
 =?utf-8?B?TzRHdnhoNkxtRmt2a0FQSnRMcUljQ2p6anRmTVloZFUzbUNlcUtsQ1pMVjl6?=
 =?utf-8?B?UWVvZFU4ZjZJa0Vhb2VvVnFtSUJsNDZjZisrc0IyS0Q3VXZQN1BGaXdmc0xH?=
 =?utf-8?B?REZLWXgzNGM1a2VZK2RIbU9IYkhmdWFqRGlmVU51aEd4Mks3NjlrZS9FZjRR?=
 =?utf-8?B?Sk1NTDJKQmJCeXBhTmZ2dU9wY21mN3p1ZjBqNVVZU1BtaHdEQlZaUEs2Z05i?=
 =?utf-8?B?alFUenF2VE1hejkrQ3dBbndJcnBVZThzb01nSXNJTmJneW91ZUlvSG9ONHEx?=
 =?utf-8?B?VThWZVVjLzNwN1BPMUl4V1Mrc0theTRHYUF0bTFrNDFTcjAycU9DRVFJTU1t?=
 =?utf-8?B?cFZNZ0RSREgyQWc0bGZtbnQ1VEl2WVpvWm9oL1RqdXVaNFZKTUhpeElRQ1lB?=
 =?utf-8?B?eGZWWWxQZFp2bkhaVUdUU243T0FTVktyVkEyNlhmMEFCaGF5Wi94THI3UTQw?=
 =?utf-8?B?M0FhOU5tb0pBZmRzaTFVSndneC83dkJLeTVpNW9sM2xYVnAweVRHbEtpZVhY?=
 =?utf-8?B?MFYxUkh4L1NJR2dsNjVUREFheWpYSWo2aTN0cXRPcW5iNjY4eEtOekxYckZt?=
 =?utf-8?B?R2VWMENrc2VsRTZqRmJQRHlYWGI2Q3cxSW5xRXRBOU5HdVNhWjBOT21pdytM?=
 =?utf-8?Q?TcvswE7gWZuE83Wo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c876381-bd9b-469e-09de-08da14f0de66
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 21:36:38.4000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETDDpJ6suEXBWa6wMrPdCFqpgsb08hDLv1im7ymtl2Pg3ZUNHGhDrC3q6Nmziil5XiH4/U4cvCpt7CCYlFmuh5be5ektINBgk0KzswUXHMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_10:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204020133
X-Proofpoint-ORIG-GUID: wcnH2UVy9kbnFRSKQwtI9lSElVjiIUYo
X-Proofpoint-GUID: wcnH2UVy9kbnFRSKQwtI9lSElVjiIUYo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/22 1:03 PM, Mike Christie wrote:
> The following patches were made over Martin's 5.18 branches which
> contain Bart's SCp.ptr changes and some other iscsi patches. They
> also apply over Linus's tree but that kernel does not boot for me
> due to unrelated issues.
> 
> They are mix of minor fixes and perf improvements and cleanups.
> 
> V3:
> - Added fixes for iscsid restart for issues found by Marvell.
> - There was a mixup in v2 where an older version of a patch was sent
> that used msleep instead of udelay (v1 has udelay but v2 has msleep).
> This posting has the correct udelay version so checkpatch is happy
> and msleep was too long
> 
> V2:
> - Fix up git commit messages.
> - Rename modparam that controls if we create sessions using the
> network softirq or iscsi_q.
> - Drop zero copy patch but leave the part that set the sendpage
> version of MSG_MORE. It turns out we were never using zero copy for the
> header and it was the MSG_SENDPAGE_NOTLAST that was helping.
> 

Martin, Ignore this version of the patches. Marvell found another bug
and the fix for it conflicts with these patches and is more important
because it's a regression.

I'll send the regression fix and the fixes from this set and then redo
the feature patches over them and send them separately, so you can
easily take the fixes in 5.18 if you want.
