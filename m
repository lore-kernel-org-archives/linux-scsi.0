Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB43C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 04:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344768AbiCOEbN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 00:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbiCOEbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 00:31:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C4E2B191
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 21:30:00 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3ON5t000822;
        Tue, 15 Mar 2022 04:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wra1RGI+rObGeTNnrUPkNC/ODlptkRqF/Z0gwBv9H9w=;
 b=SAKPR4gB/sQ81XTrDNS6yUaa91xkPAdKIOOdBnK8K22yJa2hLTzGagkGydUHBjNwh19N
 5ulHac0+OwzVcFWI+0ttD1/Sn1DQYG44DWhBQxH29CWd4soIaMc22KSn7CeqxKjSGPnS
 G2Eq5fxZnEnHoU/saI/CIfX2mXdrzKO510D2qssLYTxPi5TwKx42jnfUQ4AipODOjNwK
 rKxIxWE9JZP42djZpdyZMZgdvklUX3m2xfRSW0ZgZNjakn+bzXt9F6whzIAfMDZWHhi0
 3NICXJTGGkntekAeNStCTsZ3ByhcUZghHlHP4GecjJmoXaWQDGhJxqlSrMb1VzTygq1J CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et52pt3mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 04:29:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22F4H4st187963;
        Tue, 15 Mar 2022 04:29:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3020.oracle.com with ESMTP id 3et6578dmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 04:29:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPO2rBoU0Wxt422p1mFl38rn5gK1/MxntHW0D5iyd1u1apBNiNTy7IPXu0EHRARyIT1WaHAA90AxjW5pLdjEbrSPphgDJ3CQYlxs5YJ0aQXWHAnnonbnBkWLMgZZW6SUbxZG79HOeVfNxH3IMnZaD3Zuj9xEmuaKz5MtNxm2QGnmbcPfb0V79nBFtNnWXsDdtZydPPZuHHS2UENniI9wpaDH9g8cPLjrjYdIs2x3cdArYmOOxYYVQy7376AmL7bRkMxFbTvb5bkEmIS6Iif5lLybZAjhZlFs/TBal8jrm965NWqvt+hVilCvSb4EUb4br7vkSvEg/VgGq2ZrlMAE1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wra1RGI+rObGeTNnrUPkNC/ODlptkRqF/Z0gwBv9H9w=;
 b=OH2LK6iUZvciZo8YkmyNJN/kOF7AvmEGvYJGXUjSEp2G/SPQaoASDoaKcsesZM+XUeOV6zirdvWxeRk8w/7gcRAulCayvEcfyAMGoR6KKnxd4ws3gYZyNYs9GOJt7fTzm8G29fv+z1oA2o2aE/ki721IKZRWHZYwBRT3cgKrVxeTL9QUxwGR7TnlKr2HExbfEMICwCBo86yPgTXmX2EEyjl9hastR9kX+lORPBcb+JhLn6hoIl1rPko0Um1Fu7dD1Nwu1BBcL0UsXxt05pj5yxqGaApSf3MzcHuPJume+FjzYVOY04f8+Srik3owJdCzDaoi+fwpc46Q1mGUovVoYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wra1RGI+rObGeTNnrUPkNC/ODlptkRqF/Z0gwBv9H9w=;
 b=yxcdPEB0fiQLxz7i76n1HiCiGs6Z3nof7/4dqmFE0h+kMaM8krYxp7KVyd2N0RCWRIjGo85cZfMkktECw2M+ISseQxrVRY05VvTW6GrMIu1JjhyurSKP2WPApwPIyn84VSuhysQzvWrR3HClmvOF/IPN8/csls2sq2C10lhsDl4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4297.namprd10.prod.outlook.com (2603:10b6:5:210::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 04:29:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 04:29:55 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 00/13] qla2xxx driver fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yofdeiw.fsf@ca-mkp.ca.oracle.com>
References: <20220310092604.22950-1-njavali@marvell.com>
Date:   Tue, 15 Mar 2022 00:29:53 -0400
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com> (Nilesh Javali's
        message of "Thu, 10 Mar 2022 01:25:51 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:a03:80::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03d0f39d-a0a4-4647-3b02-08da063c74c0
X-MS-TrafficTypeDiagnostic: DM6PR10MB4297:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4297271A3ED7CEBD86155A798E109@DM6PR10MB4297.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLuwYnSOaWuBrzRy44zdJ2lgRvfqwSzPbHc7jXLA9cI9gX/3uet+mIi0h7gJYUpvYFc+Y2BHfs+dcsVeQYwnv5oY00g00A6CEmCstUIi9Fbo8mqLyUxZDQ7ZM7KVkTKEc6mfmqTTWPVoG17L9zIt3mqKriFVe58Whh7bleChDqgSIA1DngYZf7dwouEkbABI00+Qgs73bvxERwjbTvB4V7mD82rHWwGYqxegsw0ix1OKiGIUp9F/6pOgHDIWMIkHwwy24apB1c48yA+sNmUe0kUZbyCU75EGBCsdzl4f0os4mxl3UhrTyi3B8Ndr14HTrGB6FN4UVrhcIZhjjSdx0fJe4rSlGxjh7e2COBgFYviK6C6u+zuf72c1VK0+qXyQ61OT36G6BiUpW8K18QTDgD/TrIw5qxEtamoLFntqCwaf5gBuu/ro/N/ZKrmm+GeFgW6y/8vN41aQInUy6swcGQegF5HZvEvVWiTBXPAPXiBFmit2SMTZVIY6rvJe04TqhXV9K3ugziaSs+CwBOabyEUEJ/0YewcgdA+5p3hkIlq1Rvltflxc5UGekXVnWGLVyQU3GTTZjpX++6gP9a0WwgYt8TNtpc94+NUASBJqcGJKzndKXqVt3J+9PRs0WfPjI4gnSEVSg0kqdxP2ZhoHrL839B56kR0sBnJgw2ZUkemya0OOEPcJ0mLi0l2tyu361Qs7s59oBr3Q8iQzbnXaJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(5660300002)(6916009)(54906003)(558084003)(8936002)(186003)(26005)(508600001)(6512007)(86362001)(6486002)(36916002)(38350700002)(52116002)(2906002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aEWA9N1wtnSXMIHU4Fy1ooYFuKOA5M75kkAbE+nbrmjk+U7SDl6mEFZt+1hT?=
 =?us-ascii?Q?go10lCVHfI7HkCEvGxZc3/v329BwVGzq5mp7Je2dTbXQZYb6NpM4uaQnzIfh?=
 =?us-ascii?Q?OaMfDH+RBTMAIc88/2K4ve8S/KYYBTbJLk1kTCeyNkLEbENCmlWBXQ70xNT0?=
 =?us-ascii?Q?LlSqH1qokLwMGUTB2WDYpjTorEz1IaoKoadjjtwSwn/SQNndj4JJggYCB930?=
 =?us-ascii?Q?m8IEZLnplb693uZsM6mpuhpnqqYyc9x9FRcenLvaREX3tvJ2k/tPFmYZoh4n?=
 =?us-ascii?Q?nFH2L5J7wOpbbq4dDxAfBLf0I6UF5dTlaIBUVF6HyiPXZspM/6vabJavR8lx?=
 =?us-ascii?Q?p4nb/zy+Va8AxHR+nENrnJB0MRHs1jZtf7Rt1n5jgIO8n5/A+rLmnN6Jl3h5?=
 =?us-ascii?Q?wiKkxYr8+Z3SGYhzMWrlLp4gquWKQqnRGj6mhUNEHB1qiKFxSFx6Xfy9NNTN?=
 =?us-ascii?Q?rhConFR2x2DhlaIjf8C3Acg8oV0eJ33YbO2Vx3J6/FVTIpIODVluPKfLXNqB?=
 =?us-ascii?Q?TrYIRKV49WxXbx0NMb4AUNZBTDZwYz0m9AV3gPFUuNWcCt5vKQ5ayy8cZGD3?=
 =?us-ascii?Q?azETn7ChE/yd8mvJxL9Rr8WQcYh/MCEeUb9OakyAIsIkxn/WwoFjxa6qCGjj?=
 =?us-ascii?Q?o2a4X2Tk6VY7/IDZ5Mo1tJL3p/WvT6GTqpk9bBb29Ee0SvjtWzS05z0Z0G+U?=
 =?us-ascii?Q?nyyRnZ3MlEZghroo7C3k7Ezet42e3tQjsGS2xQnNtNMEw/zAsHvbQILrSmGi?=
 =?us-ascii?Q?3cwHvQfpbnkRYNLogXDSN+r935rcpkoZUxVdoq8goV/8ma1LX0WN308lCxQi?=
 =?us-ascii?Q?g3XOmEEnvmuw8x/e3nVx1YTPR66M2IcoleYyqhDIrPIpt1paKh0d5EIwv0vz?=
 =?us-ascii?Q?TeRDyw2ZSD7RF29fMAMUuXV9M/w3Qp6DQJf1uhhNDm0M7NbbUhQ/z5YABm79?=
 =?us-ascii?Q?BCrDsRKdPSak77ggNx5eioMlgY/FbgKY05pw+0P+zTPanXlmu8hin4dEtjvx?=
 =?us-ascii?Q?WHkPbYQz/Rlo9E++/EFuDfFIKiQcXKeSfz7o//JpoJ5DEaSeYp/VXiizIWDS?=
 =?us-ascii?Q?3u+1FqpwC3n4tkji001COyvPDFO6Dov4H919nw/qsrocmVaJb6CL4bzjIWF3?=
 =?us-ascii?Q?F9ImCRkNrraNZMYrh7BUMi38EKV6C23/MU9Cj6BH0bBNky6aCK50Z8rKIjgQ?=
 =?us-ascii?Q?k0LJ43J9aM6TtpEXbP99+bS085Xjh/qAZW7legZrr+QrpfrWuzldyQifu9y2?=
 =?us-ascii?Q?d9DHUHGWi6w1GlyapcHDb7rxkC8Xn//d+oYbOOQ4DmWo/DRcNsAOkodlzRIj?=
 =?us-ascii?Q?/1caMpYOiBYZkIIEGfkFYn6wROs55Z/bTwBk9RX+lPfN8PYZqv2BSw6l+Q5u?=
 =?us-ascii?Q?K/+DGI40Bs4idh7sMX5+7tL1dmVduSGFPNFegNuY2rDntGs0oz4twujC9ysn?=
 =?us-ascii?Q?shAjXKxcASEPq8UudTcxnLb0FcXRsy8cUNtn+71SuemaxwFSCHlTOg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d0f39d-a0a4-4647-3b02-08da063c74c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 04:29:55.4155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/8qJLFvvcKy5j2F+pjUkKjE4TdjvyrJK1dfPOxobOwmVcF0vXg677Ak7IE1TxdHhQ9J4RVAp1u3vSNOkm67w/Ec1I40Os4HdmRe+7gDUXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4297
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=762
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150026
X-Proofpoint-GUID: u3jAQwqYip4zAI2flyPXSLX78W1ce04o
X-Proofpoint-ORIG-GUID: u3jAQwqYip4zAI2flyPXSLX78W1ce04o
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver misc bug fixes to the scsi tree at
> your earliest convenience.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
