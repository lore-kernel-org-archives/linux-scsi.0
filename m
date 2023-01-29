Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCD9C636D0
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbjA2XpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbjA2XpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02C6199DF;
        Sun, 29 Jan 2023 15:45:17 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TNTwsK023820;
        Sun, 29 Jan 2023 23:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=at47mmVi476RREMYyH1DUbe77tsbL/svWJPBSRmy4Ag=;
 b=hj+s5w7ODsZqKmvK9AfFAsnTqdQAJmNvMDt4dCZdshGI2dlhVeWR9TjDXv9iEavozMa+
 4RN6C1nYBsF9+81DHmvJCTVC6NB3NrnloejOwCO/3SNw1Xs/MyPe/nQAmy2P3iNjYzOT
 Tr3RDuUjiDK48YYOCbUdwbxVbVVa92tp/swp6+b26kVkW85mnLN1wk+r0Hv0uxFrmmxL
 nCswk9/Y8mYHfPXtSDmawa9eKJvxyJiUA2KMWZ1S3hN9ffopQi1hkHutIN3pdHGgHsht
 6/OIAURUCVlWPAFyPDcYTsiJE4z+LnqNVeqXYjthnZr4k40cWZuXNbM8kuNaC0RhqfMC /w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvqwss64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TIZL1M019074;
        Sun, 29 Jan 2023 23:44:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53n3c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvwlcouqC79T36VMVooi5kUKnnHwNUz6uJjpjus5h0vIFXeb9RMBAMRAJUVcH5xNIsDVQv+OhtOManr5qqIRnOCETMeqrYm9hJn/cT8Bmdd4PJrWkOzpOveSU2XOUyB8h4/iTqFE3qkWXRUmUz0+b2gDbPIjaIO32ab1U1/5+OVvEpSnyWOKRRpS/O776NLjdSglpDFH6bEqSoNh8voA+d8WrwsD/5YjLz8MF9D527s8HwObLrEdRNwu5vpTt7FN9YSVA8u6L9BR+QhtUsnB5Xd+S+6MOgqPlnhb+P10rbw9eI+bjL59YC7sB6aN2mhuud1uJTHHUA7mNa9tNID3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=at47mmVi476RREMYyH1DUbe77tsbL/svWJPBSRmy4Ag=;
 b=dwRttSXPQjiYF5rqmiz9Qc+4vUkt3FevNwFdFn9BLGWOdd6Kp1r9rDhA/e1DnMk324oOdBllzrF/8mHq0FBphoH4Z0NSbmcA/XJHkm/EQYcpj+BvE6+eUaGG70HbROOCjFf+W/lIaqZkfmOqK+svVPyGh5QmNma9o0r+jDcd6KOcdSbIrrd3GUic9N5OnC7NDwIecb3Eq8Irnmsk4uXoI8Trf9Xt42eWIIJn4rbumIv1/wmfv+0EL0hCU8+KqIRx/HHePmCkwKSjzSyU98Ou3xjnrAYfKeGnEN7QQgP11KLgYk7/SgRRUw8tGQHzEQ83dFSIfLcYzGksDqZ6KnL62w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=at47mmVi476RREMYyH1DUbe77tsbL/svWJPBSRmy4Ag=;
 b=0S4US3EB2dbBV4prYDGZ+q5Fmb+S2q7epvG7L8PxLDhV8m5hfm6sbVReaiZtRQnIXnn9jwlV8iLJpbpgp2RGP4MzdkSrx3ncNcnDaR9rsx9l5Gzrrt1b8BP5WTrorbG7VWchm9R+CNsa9FRZ7WlF11Z1291J2hlU495Cll92RQM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v3 00/14] target: TMF and recovery fixes
Date:   Sun, 29 Jan 2023 17:44:27 -0600
Message-Id: <20230129234441.116310-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0149.namprd02.prod.outlook.com
 (2603:10b6:5:332::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: fae82abc-692a-4c06-e7e3-08db0252cc3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f7vma+iZHz443sFdO1zRipa+Nq/C2iscDghFEp6X1gbj0COpYHfzbxaxm1BpAfnm8HLfi+2jnBJS2RVKoX7e+D3BpXHB4iOKLNNO773iTtnH+sVKX2WmRUrQj/Rl8wZw2t05G+tFv+nL/tAqU/PrUegkgIAeXihDPHX0gVWrc6cSsAsrVygJAxO0xBIfQXbXq7YsaRkIy+6tJUx+IPHf/mbgcwu7fgkuOyEgrKCeIi1uAzb4fjNjbaud+kzAzmCuBPwvOjwnUPNsmKAffVU/yX/Cq9dAWQ+UivdTBtCoSwsB0CmsyxFc4clcaCJ5AK8sQfVwLXN9Y1H2+qag1qFAjdn2eExyZ1sPPIG1GNqokmMMiFbXSZDPJTlLgg9vUzDvqsjG1FU/Nnj5ABW4ccs2RWQHofacUCPz2bbpJYURcgl6Jm9xlH4YcMgQKBvtnwKuz2k3ACk3vjWhmWRO1rfvSw7kS6OfNvc7lsmSSNqgQ5aWJkb31ovA4WIn+Hq9wNlH/Xfci7eZ62oul2u7X7u4gJCEXv9lYp1GYKFm1zR7gkX4PZ7Riy0/6Gu/hdrgx/1q6OF/fY92a8Wh+Wf0xBuUfu0W38ZWkC6srnpKNzHSl1gPwiu+uH/U4h65kMw+Bqa8vXW7spwtgEkERruXcyisSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4744005)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iWQMfLJjS1S6rZaiGB0lBw9pRzXg5+oJu2j+tjD098JWs3cATI4wRUOWxXe3?=
 =?us-ascii?Q?K81w8BkSE1HP9RX3erE4cT//lttvEo2KK6Dm1oU1gMIwIdu1q5gHObVltNgs?=
 =?us-ascii?Q?MyJrPdPvdHIu3qAlGJoyh1bdLCkKaNUmSscx5dshUcCzcMQ7zsvZ69IGsLe4?=
 =?us-ascii?Q?Ik7FT7Wb9iIxWpZ1jEpKfONZB6+k70AGVoL/assPEoCHnjpErmTR85Ka/hd9?=
 =?us-ascii?Q?5BPlKTo4N8NS8E1nl6nms/0oDSzwXGV7rpiqWhQLuOQDAmNOkR78N3bsitq0?=
 =?us-ascii?Q?e2gnsJkgbC566T3NDPAt1kjx/RiLVU7FvfLDzod+SxQSyMtFR++J9FlmwneT?=
 =?us-ascii?Q?dHfEFhzkUtR7wS1/u/BJQby2c7DxiaCs/BVTU3SzqMQQqv7+PvWHJKrfZI5M?=
 =?us-ascii?Q?y1hT85fMpvnZNcnBLgMrVe0vm8gE37gF+FTbUliw3oH8vkvC3S0pQfGxkKl/?=
 =?us-ascii?Q?5FrT0tjBP3DhXN9hO4RsRxH6OICMmgrvn0GWwTIDYvomVw+7dXXUcV2M7wP/?=
 =?us-ascii?Q?hQOuDa/gUQzlT+TGeSzBW177p+AbcjgrcZTexDArvA3RNsHvatVg3vfj/0qH?=
 =?us-ascii?Q?+Ir56fkv/+9lLu14cPwhK6zp8TLbGcpkK7l4C0GrZ3lFG2mPowNgHfDvoDEd?=
 =?us-ascii?Q?AER3r3aXmbFX65P1INFjoFWU1uiwJx62nwMY2HyZv99bWl2Zu6FtamWLwX0u?=
 =?us-ascii?Q?JVqlNSdOCpdS4SURwd7e1jK5Jp4klTcSnPJep7B5gS4FDge0iwDQcN6ebnd/?=
 =?us-ascii?Q?Zd45S23Kl2I6ePtIF/qsm5COJ5a0p62AvvNIeNyfP6GplOV9aUmu3uA7YdCG?=
 =?us-ascii?Q?FYRUwOT6J0zLtKRtFFpcogb/IYJbl+GpmwVZt1FmWQjDRdILRUyqNn67EqR7?=
 =?us-ascii?Q?Xga6nh0c7GgJnVPp+pZ4WZTpJBdfUD8A47V7lfCo9xk7MvKyEUzhSvAA9pdp?=
 =?us-ascii?Q?zcJiRkgZyHFLXQfCXxfIhDpgfh8QPQrvlgdPlYk2lhsmocfT8RXc/F7AForM?=
 =?us-ascii?Q?OvUH/XV4PEllmdZOYZY6GZ8pnW0o7zIwuMn750tfLDWobv4WUN60NpvETfFC?=
 =?us-ascii?Q?Wp4zSvbmaOxPgSEbfPmpHG9+ylbrWYV9pZFKWyamGsguC8KEP8o4NoKPQ7wI?=
 =?us-ascii?Q?rOz26BNVtUaYfJGqmoI27aescq84Z99VblkF+fWxmxC7gWg4SZV2g0KE3WMS?=
 =?us-ascii?Q?ZMpvLL78CSEjktBkdN4Hn/0WBnGqGh0+hYZ0UaPhNAfCMUwv+1JcPGm+SPm+?=
 =?us-ascii?Q?Rh1A50PqwLO6aaaHuZJ6ZfZ8nHSAAofTntyyuKMj021/zpt9QD37vo968vwG?=
 =?us-ascii?Q?GKChUI8X9GKOd1cp1w+5EJGsBbWrg/O8Tbq+brnmZpvfgFg46lAE5FH7YaO4?=
 =?us-ascii?Q?UCTPvK4Cb5PjWW9YV1/VSnSg6SjSC/M0Cx6gsGWKgZ01KT0nuEpVFjDAZ3ux?=
 =?us-ascii?Q?OciwHrFd1eDz6m3bjZKvjAcF5l0sUWPgMSEBdAYNmyqkyj2/hnB5CTkcFeVY?=
 =?us-ascii?Q?KN6rdsS005HUfY/CpUNWBAEfhlV5YZQ3nfLdFigexNoUqfZrKhpmCt/RJbpT?=
 =?us-ascii?Q?d99XF1GpIYEdZIuQbJBrjKenKnOXB6MAV+qXJoacTkwnn9qwNYULHp7JluQA?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +Vl6MAv02gTGzT1hewaUKlYfHQwUWUM/0WH+2LW9CNaaQXTm6Tkqf1YnU/0F/IVAlU+iX0/2HU+HgRa2Itq23NfJZDjYGdxUHBB2O3S/TDlOA6BFMB7602t8Ih8XWtP/N933FgeZkyqmJ6CSt7yMFEKaIDqZnhMs4RSQq9PJFvye4g+Go6nL7VIKA2+WXual0SB97d8jM4pKHaP+7PzOdgTcAfQvLMKTCf7EO8PZbxCB5j6P2p+tn5ozZ0oulmk40zgGGbgepvlXAqr3HNRSh/YwjuB7T0fy6QUGBpiXZXAKx73nMkILbLnOsF1pbDyhEr/n8fVBFWtGgOTbtcj9otnNldtmbGLS1MuRHio1UEwAF3nwZkNekOdvCEQ9AGu3t7AVfGSU21arqqGXtGIUqZhwlt5Eqa40zKi11K6d4t64sKB01jT/rEDRUbMze/qVnUQG2iZMXB7qKDUfgXB4bWja6/aNTDXFOtcy2+tL7ITvbzlLZTeAWalwFmcJWTZSstHvcVL39bwEsiNLw+JS79h9wBHUiWnVDcyi2Agk6PtLiU5dO1IhWfTNJhoQgOJUHcIOy6uZNHHIrzyePQmTkgkMvoGryJOScFJlZmVvb34wOhk6lPMo4P4XYEGQZ8/5Arjo1Wde/yJXf9VA0r51zh24n5y2rfuUz3mvTskNiG5pCFwobTobI6LryHyuEHfy6cVZievyq5GFa9xXGqcTSzsnB8xc3IKX438X3GfbJIDHHP635YoaD00RM4WDWHm1YgDsT6NRMpl1/M5bqC+ZkDknHNAPVgl+HXdP7VM8bve57c+QZGvO4+DUl6+USFuy4BiSiMqRAjkETlytVVH3nVSijgjkxCz3eLXKceKRKR7c1lgA2yBMsPLD8+QRY2Am
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fae82abc-692a-4c06-e7e3-08db0252cc3b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:44.1827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gv4P52Ph/4ofnjHz78mAj7NX8LRhzjfWvanndGXVkEmwZky0NiuSwlnrVIkjbdNtEzZniZAqDmJ7fcnVRTSzFxfhITD2v2JjUqYPvQgLfRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=972 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-ORIG-GUID: NTYFKHk5nAgbKRYCcdupuBGEYUYCkxNW
X-Proofpoint-GUID: NTYFKHk5nAgbKRYCcdupuBGEYUYCkxNW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over Martin's 6.3 branches and Linus's tree.
They fix a couple regressions in iscsit that occur when there are multiple
sessions accessing the same se_device and TMRs are executing and a
connection is closed. And they fix some bugs in isert for the single
session case when there are TMRs executing and the connection is closed.
It also includes Dimitry's fix for cmd cleanup when ERL2 is used.

v3:
- Drop patch "iscsit: Fix isert disconnect handling during login"
- Add patch to drop cmd lock in completion callout
- Add patch to clean up recovery commands earlier when ERL2 is used
- Add patch to handle use-after-free in isert
v2:
- Fix wait/stop use during login failures
- Add patches to support isert



