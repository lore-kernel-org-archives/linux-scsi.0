Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B82C7EE22
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 22:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjEFWfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 18:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEFWf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 18:35:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A969EF3
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 15:35:28 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346MDe9o002284;
        Sat, 6 May 2023 22:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=BuAvrszC0u6D4g+QbHlHRYZNDP8v0bqOz3vr/UXAntY=;
 b=Y23RnLB/KCTXjkBGXnTffP8XiHw0zDPhrZCRF//3wMgotfekq8J/8fvMDqowOZwXH+t0
 +UksDPN3QU+4W0JwrmrrpWs0b/ZkzVC7oOE42jWmF0nnGi93pC0je7LoljLQ+q9Z+7OB
 Wl85QKi4HYKK+GwtRAVzbgzm2JpddB/Stx6KTHMd7lGIFRjnRxU0oW7Qyg60uoni3Nby
 LGDINg4lf4Nj/dHmiJv52uhp2Def4HWk05XomlKXjbdh8jbMRkFWA7DU5wE9EPuF8FoL
 t22UuihWwtG2wAkSCV2XFMj28pt7YvEOxewSOsmfrqsVNMrtrPtFbdKGFdKc1wbU/9V8 NQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qdesb8wxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:35:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 346KklE4038501;
        Sat, 6 May 2023 22:35:26 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb3uccd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9cRfGdNmqgjuTmIfSwTEv12EtY3du9prdN6BinDnS/UKhjx8kVz8DMp8NZQgrasgHsTXTYuqAHjB5fZ6b/DC5Fd2piEf05bXi6EQQmiQa/9on9e8I4+0viKHOmuMoI0pJA2/lfhtt5Voehq8gKvlDSNyOChBNODs3amLyZooVAIU+81IpWqXGHSuaQGkhmka5CfLkejBzpeRajcf1Kmg68Ge03QohXk1igNBVL3M1N+x/GA1vlOJ8m24YcGmXg0DMv8ujYtLzf0mznX4cK2Qu72OxySP/s9iMH7sI7COrWB4mlLuGUzvuazofuGQKqLl9D2tbPeZR3I0R8+Oy31lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BuAvrszC0u6D4g+QbHlHRYZNDP8v0bqOz3vr/UXAntY=;
 b=MM5ranCSuz1lV9kd1fodpcMWczsjKw1pODrEbAzd5tvgG3jal2oJJxJDaQJUrTIGTtQjObMjpP54s6wUuNCfgfs9QOeZQJS73vaUOqnq/6P0K1ZOLTmnow+Uaxx7UIpKi9Red18Adj+q4croEhF7FwFFHgHPFVGsgU9TLr0bwEGl3PCLtynt+6dRaD6GfLtPVAbylD7K5tsQYrePL6469ZhzN/uu1YWazLUngndKDzfdzhHIWXWcBeJOD9hZW9LEDTvEmc4xE2kUI4L2c79N4klXahsyoM4wjjQdjnrMQ8HdN542kYkYad/9sXjxsnTTGgJgf3cY7B3cY6cwfjjlgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuAvrszC0u6D4g+QbHlHRYZNDP8v0bqOz3vr/UXAntY=;
 b=th11VHa2gG46DlOKHE9ALuq0s7T0/sv67rnBDpOhdZM8nGh//PErtBP9OGucNDuqQjS73MTG79ZcQWw7+9htzDRbC+AOHXe92V6aip7jrm1b2e4PCR7sfjs5H//Oei7MHYA492/bq1xNx5e2SG1BzIMr1LHqXukBZD62DabX0TQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6510.namprd10.prod.outlook.com (2603:10b6:303:224::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Sat, 6 May
 2023 22:35:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.030; Sat, 6 May 2023
 22:35:23 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 0/7] qla2xxx driver update
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0rt2in2.fsf@ca-mkp.ca.oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
Date:   Sat, 06 May 2023 18:35:20 -0400
In-Reply-To: <20230428075339.32551-1-njavali@marvell.com> (Nilesh Javali's
        message of "Fri, 28 Apr 2023 00:53:32 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:5:100::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6510:EE_
X-MS-Office365-Filtering-Correlation-Id: abc630a1-bc26-41a5-7027-08db4e822e4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZ81DzgT1dm+Y7WEgEIEb+Ey4CqVi0GcSTbwP8CUscKQ6rIqP17v0CK+aWC3aOWzBm5qTbf0usMRJfk0BxYvVFS85f40pY+r21RkVKoEtIXzp5J51/Sz7EUavJOVx6UXqI6FeVWmgeQ0oRUp+NE7mDPYO0ugBqiesO9rFqHZkqSiy2q/+gX5A5dSLAG08oOjGVX2+jQRoHxUkkbeMMmtUzg0oMPbBfnG5w4GyIbSrLM3JYTGIUsKnl79oidHfTPBsxp867Brl/zPoGxmIwGuIre/ngCuiXKkPG6ifGWr+k1qIOngkbew9wlXacGdnf0mjZJuuDE4GiQeonw8rrTblXb3e6TDLlsBzyUm2QsmKNk3vZdhbscM7owGWvWE5ENixF/IYAkJv4ZnOgqmvRKg+cl6iMEUbRqm8XRvJBlk0EgbrevGfk6pDiC1nLQukTUqMCjUqnTYwQsn+TsB0Ilwm551nu+WnzYUgfKfUipXCG4fVmrRcxOzFywzlc1aMOPvHzJq8rVPvhkJOInDVSZ/3sEJza3WvLbHFDL2ObDkpi/wAECJJNlqvC3lcRrwc8Lj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199021)(86362001)(558084003)(478600001)(316002)(54906003)(66556008)(66476007)(36916002)(6916009)(66946007)(4326008)(6486002)(41300700001)(186003)(8936002)(5660300002)(2906002)(8676002)(38100700002)(26005)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?epRv/2VnLotBV53IiPOAxEy0/JEfzlitCKUnmcQrOZV9g33Imz7Ykb7U9684?=
 =?us-ascii?Q?YSEIHFfXW7bBPjhcJsTOHYE8W8Ib4sRbgnZY/nRglg83f4tBo82YqGwUOW+8?=
 =?us-ascii?Q?RHG4rkt2AojGbcaMqiKlPFFF0p9sUsNHeWQX28XVpM/5oqLQr0yK/rJTX9wf?=
 =?us-ascii?Q?cqc4XZJlEfMi/j8gTABXg97kF1YpJhuByln4egEtFSVO8LgMGTtcy8bs4OXB?=
 =?us-ascii?Q?+CAJt9A57qNkuSEscQymMk35hEy4rypiMOl/os3++Lq3LU0RaJ+PMp1PlgTH?=
 =?us-ascii?Q?Y/lmFhhX0+q9OTW+UmZ+BSxnZBZYA2St82D4emYB6x+vxazOKwXAsNO0jLCg?=
 =?us-ascii?Q?ja3XTL6o9Gq8TuLgkr4N6jGmYrQNO46507NYc0jwgRkmfjtrhUpiA7IsYLJ4?=
 =?us-ascii?Q?5Lo3L/ldHvryDsRNkuZPDluwb2HstCoHq6tmrorZMZGl96Qyq66x8XlxNEEU?=
 =?us-ascii?Q?l7ci6bEftBJXtncjpViQyXUZ3FNArvzBmgxu4lh2hZhOnSaWRH8PZycDK/7E?=
 =?us-ascii?Q?dT54i8vKtLJH9vCdIhTjMEz9pV06jW3l7ecD3Z0Tfeby3EvbP59jgSnjSl7/?=
 =?us-ascii?Q?bCOqNyZ9oBv1OtKnxRtqdl0TguIfYUWnRzfuUZz5fkMccX/281Xtk81TCmUi?=
 =?us-ascii?Q?ZBvUapUEMP+2EIjExAj4QaBQ23PpogJ5vQdrmwtQ8R3rQvyVnLhw0HbaXkXt?=
 =?us-ascii?Q?FGQyyB1MwTcUieRI+MR+IZqYufVur6b9yfDWsBUCLWAtZ7GdOkYLz/yxoo7U?=
 =?us-ascii?Q?EpnWns5azNpzji/1W932veOWBhkNr+4vKUP9vN0JviLpd3buF6vV4Ei9nfe1?=
 =?us-ascii?Q?b8Yp87qPG4AsFnvrqJ9CH+YpmetxdaGfl4gm1XQB/w8f8wYDb5aJ0yzZNAdz?=
 =?us-ascii?Q?TXYJz4W1uSgd+3rNm9uh7HM526HzohDOOwcGTS5mGscsw1GoiF/GrNgOnP5m?=
 =?us-ascii?Q?ywIxrHpNm0NdoM9ai7W6sAz2OiLCkkYcCIR8eM40oJ7WAoQVfn5Hlh1O3SGw?=
 =?us-ascii?Q?3JZ5wTLNL+rj0P0kyFqj70GSAfm7O3j2uEASgILlvgn50hDZaHpXKxiu7P4A?=
 =?us-ascii?Q?EaQuxL1SebZf++ki5WuuxJgoEl41sKh01LyB98Vgmzv5DRxeb0hYIweY6IqO?=
 =?us-ascii?Q?iRrbCrkP51s5d2rvl7nNaD/kNfZcPXqAGJPeWItSvgveFt/gIBTNxtGAs58D?=
 =?us-ascii?Q?Dzs5v2lc+5xJbrFColAhqdaUwfvYuV/tSuLnd2RSQ4bPEr61ll0IKLc7Axyv?=
 =?us-ascii?Q?aoBFb9IKbyqBprY9il55tnymAORzDVeX5ldisR8t8Gaj3TUd1GUc3aaUmAR0?=
 =?us-ascii?Q?nRRf+g+juDHtyxTG0RQqBLQ3UxWw4pwqzrioWtskrrVuJE29dTpgS1iiwI26?=
 =?us-ascii?Q?dCnHm6Tu3fMClHXPAXXdRdpdd1M44NCNuhmo3hvrz2Avdq0LKtKQ9dRh44AE?=
 =?us-ascii?Q?i+hpRVCZrE5WYnKaHsOeZ36ntrWfIFXZ2qrrLHTGmlgZ8J5NEJaECy1Kng+G?=
 =?us-ascii?Q?eo9y5GqttJXDlgL+KwVB7w3xsfpube7Y9GXeC+GTtJklo3hf69tdig6/e7uG?=
 =?us-ascii?Q?XlmXPn2f+dY5uhsQrIW7VGeRE+EKaFdadMFmFMa5xIcl4kFpvp9yuvSiFHrc?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TnI1qvacdvkwJp8eo6XoJKKpcMns0i/H1yZs8lt3mLpAY6VCrw+jFXa7H6lvlr52gLGt1nJJ1IGymp6Lco3ySvcUagG2rRjKVHnsbSwBQ5Adub4POb6Bl+5BDiRUCzo0urOzTWdS5YVV+sY2PXidVdyOpqVIBJ0To3magrI1KAOi145+GenzC/QTHZRMo6hnwkatQiZDWWqPjLpCOgljyn//K4DhRA5BWh/W/Mtwe4lTudj+2VcVfPITRlAxnJdPLSUFBCLdQ+CRsm94NoU5QzNSW3QaeerUE+jjawj+d+hYQJHQgczu3chZbzISjyuvxE7GmxJ0Gq37MLqnBmlnHufE/mk+yPUqnDVDmYDTcPciUxSbVInOOZFn+Cvp2m2RO61d0DtfLRx2B/4WkWcxiqTn04EuPtz+i0DeGyLrotlIQ5MsGZboPwMVbhrJnkbsy26sIhjSc3sARtmvIkj6drIIZ01/S2WY92brPzzIue3ugD9k1qQkMuJjIad9XEiy8kFvNzBQmSikXZ5N0IbYZYitzEnj4KBNy8uep2AlYF/yHCvSdrrKWgBMkZsoMvfn2Gmyy8oZa8am7Y7Pv040sFJM3rkg3ctZ4LgsM4Q+sHpSn8UhJFTXpg4+SHP6+EEzStzTalwcCkyG0ErEJVZ5S0nzI8nbxUMXWpTeGldQqM6IQMZzI+qEtHX7eWKnq7gPJLTVQSlIJSeZDd8pOGwPt2dvh3hxyTc/QaOLbDSXGPeUPTGciUaZExLaHpR+9KBRoppqWJlSzBTt/OSA1/iBy6hPADDo4IHYBaV3+5mhDXw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc630a1-bc26-41a5-7027-08db4e822e4e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 22:35:23.3561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzvujbZncMprZokl5DE+SEGWufOkEQX9MIXey/0r6xFBqf//4RZYPlExHLoxPw05MiDVqB9Dd7qLCEQrP4aMoUGP3A5d/B1Y1/YXt6Vvfxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6510
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=697
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305060176
X-Proofpoint-ORIG-GUID: lQzRlKlUt4J-vKNAooe3lOqpZeySZLgj
X-Proofpoint-GUID: lQzRlKlUt4J-vKNAooe3lOqpZeySZLgj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver enhancement and bug fixes to the scsi
> tree at your earliest convenience.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
