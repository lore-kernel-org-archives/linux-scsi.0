Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE116C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 02:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiB1Cb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiB1Cb1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 21:31:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB9D6C1E2
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 18:30:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RN22X2030109;
        Mon, 28 Feb 2022 02:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NBV4RurO6s3ZcZZcJGsuBlEvwW+DeN63A0ZCvSHjamo=;
 b=LWDju9VK/RWQLH/KBudhj5rC+W7xVD5GknSMQLGBSJMAgxxBC+kp2w9Vxmw93Q06TfLi
 w4eEovfaZ97PzNijKyjL8rJOc9CQWf24SmASpZjxEMVk1I4sgrN73lCwfdeCKxpx/N6b
 iHQrPMfiHlIrqYFtXXEJHnub2eJvzrRsDKqYEDFWugaYrfKgJI6Exqg+1dEDK5A4WSom
 ohAQMJaKBoDXrVuZRbHUmYeRSlR88eAcOL+y3YtveG9zmueIRqH+zOTMgMlxqSUlXNHR
 NXJ7bTOxIcyX6K6ckqLnkKK96/EktLajhGAoCi8I8AHUhgrJTJlVoBpq205X75g7Yk3O 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamcawju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 02:30:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S2Ajg1015091;
        Mon, 28 Feb 2022 02:30:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by aserp3020.oracle.com with ESMTP id 3efc12fafh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 02:30:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgtZDqUGjEftfYu0+hIdStGc/7Bi0xnXMsZg3AaBwEzcUgYOZeDAQBZkQfqQ4OEAg6lrESudNC6HWwKytVYHBg39Z4y30lGfGs2VdXFfFI2YidTVq6WdETZsSdYqv/pQgqojgkrUNQJh5wEdoras6geQaDpy0Nxn4ayey2949CegR5QTx5ALCbWoHgFLwykircNqDwBXOE1ekv/K1Fs+0Ep0TTfv+7ZQx3WsWLWKYbBYfCMD2smwzEq5Dr6vlASwGwcQ1KXQ0wKtfw7mKYcWwwg3s9FMh95LUZxEnWE4iwB2EFDwdbnFeT6VK7tyu3Kx+cKy5j22nNLu87X7Qrn/xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBV4RurO6s3ZcZZcJGsuBlEvwW+DeN63A0ZCvSHjamo=;
 b=lFNTvrosBzGipw7KWls9aYFWB8IOr9i3m/r67qE7jmoBm9C34Y3hSRu7/jXlC1aPI76Iw7GW9JkVomMx+MJPlxAh8un290HLqggeFBAVhPaLpM70JyG0aikL73OyEX+5lWrqibwSuPIHcZw0bzXmw6Z9Hj/4VUZvO4uvWx6lMmC09XDtAybUHxVYISWFEWSaZxiN24P2PvJYgr4hRLXCZI72PWSt68TuFC89T3zWblJ/FELAAy0iQDyLWaZiTY6AZE/w3twd+Oi+u3D15BZURX4Xk1RJGiFM1tvigVNJaQk27cIwCSxwADfP3tgqJcaisslU1nQeMFBsrYg03Cm5Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBV4RurO6s3ZcZZcJGsuBlEvwW+DeN63A0ZCvSHjamo=;
 b=F0v44b341uCKfcnKhCnUn6P+I8WLMHHVdfLJW9lq9IGmVpFH/owbpmrzHT6zP7pQrs+5+e5P42wztjBRk1nXniu+oiebtj5vn+klhfSGRuTdqEUY7yjBY2DVHnWbtjxJYcXBUJuMctqziQLXx22ZGXJo9kXi+LyWH12P8OFqHXc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR1001MB2243.namprd10.prod.outlook.com (2603:10b6:405:30::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 02:30:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%6]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 02:30:28 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3] scsi: ufs: Fix runtime PM messages never-ending cycle
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6eb9168.fsf@ca-mkp.ca.oracle.com>
References: <20220216075122.370532-1-adrian.hunter@intel.com>
Date:   Sun, 27 Feb 2022 21:30:26 -0500
In-Reply-To: <20220216075122.370532-1-adrian.hunter@intel.com> (Adrian
        Hunter's message of "Wed, 16 Feb 2022 09:51:22 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0013.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d58f9b9-48d0-4ec7-e055-08d9fa6248e8
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2243:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB22432FF8A72108CA4484A8618E019@BN6PR1001MB2243.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7UE2hN1mCxS7TSqmkx9GKSE1Xn2ErRlTqOGuGLq6xeZzt2g8KEETC81S7defz68Ok0QkCO/I0tkt5NK6uA2ooh3NDHnQmqCBKl2iOkdnY3+MPu2eby9VNchsxSx+xn1bFUdkfDDQNZSv6FF0p9Ra3ylSbJLvqpDyMP7EwI2iUDzgn2wDfJ6U54arCqmk70Wpp4WPctID3HLw3foaNLqVe6RbY+lyynCTJceMoM6FQCetKb7fMATje5pC/syarRfAAvqOdgN4Ch5WKrhaOHBSfaMVtkndg8bganNTUjpYkVzoAYULr0AitADQ+T5iHFh/aPaPlfvXSPZ0kWblzozNc0VWOhmBhoRlSIUv5hi5iaT6OsT3XIoVAko5nJ4pFPChPZig5VYzilNPKYV/WVo2QMmGJGzv2dPILTvMGT/ObsJd0eefJ8baFE3ogjGbAKEdqA2sCw5BVWWezb0cwzyXlqKAn2MTpbmckLsoJH/yPZ3R0E5jZw5aTkklYDZqMlsDX+fqtOWlGunMR+WMBhwGVlpBw1ZeEHhwgIwZdzk2vQ6LwXmZmcR8Y+Isi3Q2bZCfGT9iwnsPOV98B1MPqeRycgbjyS7JmjMNSfcG/8tqqZFVFe73iQc1yRtbWh4ktPFtKWgdw/t2bBJpc5XbT4m6KSX8yiPOqHBgi4yo7YOgZdf7/FjaXeE73qFfjci33dTgBN/6ckDu8XrLycXbfE/nKfG/Rgs2wkVYR9j76XeQ9v7RxdCaXkjNRcTR1HiSrGt+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(38350700002)(38100700002)(6486002)(508600001)(15650500001)(54906003)(6916009)(86362001)(8936002)(66476007)(5660300002)(66946007)(316002)(66556008)(83380400001)(4744005)(6506007)(4326008)(6512007)(186003)(52116002)(26005)(36916002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RgzJxgcF+qYp5oIltGwD/mI6jekA9Ux9ZuQO76VRPGDwSBW66eK+f/xOci3u?=
 =?us-ascii?Q?hcalXyHw7wI1Cuba6IcygKji9RntB3wc0WAuUiCYI0WhTxJQP1UmFv43K0Lf?=
 =?us-ascii?Q?PXLsJnf12Hr/Qg1vdfFFlRdjnOW4VQHC2unHa4FervqR+xOqdQSJwJ8rm9sv?=
 =?us-ascii?Q?9l5MX+Dy/jo6DED/+1lZMoJXu2v0ugRWX6vL9vGWUOWojo6hOkwX3lWAz+R+?=
 =?us-ascii?Q?2x+t/lVYonmdzZZOvbaWWemLN3GNMbCp4fqZxYwJYIcaLvFycAggNH6KXcGq?=
 =?us-ascii?Q?Rd2OyPl6u3dYJD/tkoG5dRzJ22939oUmVyuK3oG3rog3bRU6vCKIYb8PFn9K?=
 =?us-ascii?Q?neUaW0PzXLFnO+MQmAKT6Qn6GdlhtAkYvxy7nztaBVVREGCZ1Crptt0TjeKf?=
 =?us-ascii?Q?CEMMa+8nWghljbdddrl53+jSSI1mFckDkEcdUwxz0cpL9A9NgGuXjXHPG8hx?=
 =?us-ascii?Q?KKetE5ldVyEYYYFnvQD44ZW9BVZDcWrcPbEOpUHhqrfBjEZ9wQRUI1bjsBm8?=
 =?us-ascii?Q?auaZcQZTN/d8xGx9/Xaex124O8fY6+ghX6pOGra4nZNkX1Z7xMstOz/IkcFx?=
 =?us-ascii?Q?s/dBVgLk1s8dsRqZcNP7Xg0t2IH3G//K03LW/czrC2G+tKlfH8jDcKVN+eTN?=
 =?us-ascii?Q?IgcJhAZorGGZ8QEzFrE+brLCRojosLXCUTBBNpx3++tp9D50XICIMTgUhkqy?=
 =?us-ascii?Q?g5qJinq9JJRPDRsrkCc6EdiEsuGFrictQ6Qyas0ru1zvYD5ae++6vRlH5uJC?=
 =?us-ascii?Q?JbiUm9na6X33VzmTpowGczLk5io+W/eETTmHaGSJ0hZzWkLX5aVC2PEAGtS1?=
 =?us-ascii?Q?s3P6erA+NIwDhg0n6f8IsB2QowTsWZJtPNocScxkBUI0qatGURc5UG6k9OFD?=
 =?us-ascii?Q?am4vQlVceuhTCHO9PAmv4ZTH9mv4Hppp4xcgxxymzB/1gpFgMkvRVpP5FiGC?=
 =?us-ascii?Q?n37kJqd3wrqy1OP6rpB3hvG7sZ73o9SSzbrhVXJa0sLkZw0EO6kQKUEpkqpR?=
 =?us-ascii?Q?5vMqcYmMNl3JuYgJVmzQGZvFK1xQseW0vwNIxyY7XH7+TavL29LysX5NiVm2?=
 =?us-ascii?Q?8JUabaiJhTkEzUMoNJcwGKbCL7xVQb3Ug+CcNd4hAYyOhhvIabJc+S061lmI?=
 =?us-ascii?Q?Xy7DSjsRyM4ZY7Umzu70VnyPlTzoR1aome7ibkFyK2Ftwq8q4VRqNKTI+mA5?=
 =?us-ascii?Q?OugzF21vYXbYrztK+5PKt2escL+8/H9ud6QaNc8SQ0gdoafqmjcFhybmQ3Xv?=
 =?us-ascii?Q?v8W4O5nOmXWDgX/j0O9PdVoYSKDkjkWjImqIVIuWcMtkDCW0IMjgXOQxKt2a?=
 =?us-ascii?Q?6mZe2JdIyGjn4vVPO8HhaQCGIkdWGXdnCC47sUIS2baEliHnTFPRMrBIJ8D6?=
 =?us-ascii?Q?6pBlXUQzDMSgEOifWunfs0E6ERAUlmC0Mj/iIqwdtB6vF8XA7dmqmaiOBQOi?=
 =?us-ascii?Q?COrOy3DHPx4qaeVbQeR57vpQ+foFk6RO8eF+bXN3o3gL+BiW3/2sZCMQ1Ywt?=
 =?us-ascii?Q?sLSeNzzdjCGPX+1R/c2pSIfGCl3/+KwCIJYr1unx0fFtURoe9YUXYJ9m8bXO?=
 =?us-ascii?Q?NL68pU2/FTGU+KS1Aer3kBXb7X/tJBB0fOBhH2u1wjlWQlIbl6DfQTtS1SVe?=
 =?us-ascii?Q?1cuP55OO0XbUDOcXWgdWRcJYZ3P2KqtV7Y97rwYstlIaB/wXUoHgTG4jfRaF?=
 =?us-ascii?Q?yLO8fQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d58f9b9-48d0-4ec7-e055-08d9fa6248e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 02:30:28.8002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPBf+LT9pAhByk/70ZWBEX1RUs9YIgqds8R13YpZuYn+2O/ZzUjJ4KmRrZNr0uPOWp5K7G/Z+Rfl+nBL58u3JAZPQmemAtdC+8tSNEaR+5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2243
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=931
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280012
X-Proofpoint-ORIG-GUID: 1heWCat-ZFrRudm47oax32oxy-DjJo42
X-Proofpoint-GUID: 1heWCat-ZFrRudm47oax32oxy-DjJo42
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> sd_suspend_common() messages are removed.

So after chewing on this for a while I think I would like these messages
to remain in the non-UFS case. I suggest you rename no_rst_sense_msg to
quiesce_suspend or something like that. And make the sd messages
conditional on that as well.

The ufshcd.c s/dev_err/dev_dbg/ changes should be a separate patch.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
