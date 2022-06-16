Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E10C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379142AbiFPWqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378948AbiFPWqO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6867862207
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:13 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIjgow005235;
        Thu, 16 Jun 2022 22:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=poMWgmCOGSrIA3hVHIWPWO4t62+s7msBi/eO9tZmys0=;
 b=t0MFsp2ocTn3SyCxRVdjR4X1P4+zSW1tKqq5l3E9yFYAwXajuX6xjPvn23fUTv3ksQ94
 RsPbZq+4bop+depU3Jzw9TAGnp3WLRmyX28y/9hBdmvPzkl5/TD54CudrAx0EMnmeBy0
 IxGPg817+SgoPyJRnhwqlaRIh7MPQE986gf6IaVmpPU2JBd18YOeSqM+newCWNgAWoWz
 m+1idIDsVqnjhzSRvRxmuexBHZ3gn7E14I7cPvWPDoaHvafkcqve5QdiUp5IgI515kMk
 xv4V7rmZQwA1VV+WtkpKiImO7L2qP94jyDZz8VTW17g+iGenyllWkJw8Py2gx7riSY8C rw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjnscgbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaQMY003820;
        Thu, 16 Jun 2022 22:46:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbtax08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTAoPwiLAq3pPlm3tuhnWiX8abruRzYJOeotqLpjBsxlj269J47i1n1f6uZat7OM+MXTDBULXuaDzT3CnCsp99bEnqxhX5z+s+2pVYW6fkM+HOMmgJL/MlOUv9a/28u4XJsN/pu9b629e7cCSCIghLfgmu4wxFkQsNybgmS9VnBKsKSuFBMxPbV/e19Vi+kJywL+LZlyAlXQyJ0R5EZYHbytd754hMEtSM33gWbenh+K5A9Bu24BaJcxkabxuIq38yHSYw7y60OJN7bUeLlKNHRCu9LmUaU8lMP2SuJDgQQlOK3cDpwB1dPmSepvm9igma45vnxVu52GejEodF+ttg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=poMWgmCOGSrIA3hVHIWPWO4t62+s7msBi/eO9tZmys0=;
 b=dxtJ7gP7ENPKZnTK3OReM61WZ8ZlUgF5Leh9HI+v5Ojw+TL5t3ahkT2yoG+5RXuPCLzFo857L2YZRyohDQDPBq3GJtf3nOoX3i9svDmj3kyJJHlV5LUGQKUnapckK2cJVMhz8/fZ55kXy5/sBsM6oZe1c7B9wIu0s6ymLLtmNvLHQyIhc2/Dz3a0eOW5NeH8qNqH4f2+sTbtom/2Loc1Ah6VFZqQ9MSN4SxyaAqLktMmal9qzXEctU10dhTZzI7Qs8ajLWjVGZ89MAtyXDT8mwH/Wkpj3cPZqGZLcBRswuysoiIlEn9FAq/OpK6FbmgQy13qj5Ux/H40S5RNDEU/Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=poMWgmCOGSrIA3hVHIWPWO4t62+s7msBi/eO9tZmys0=;
 b=jNhQeEh4Bt1lYnVuyHfjogJHf5/ie39kNnN36LJOu1o9HWcBYzdBdFVEbbg5AQqWldSgbktR3dPxBMTJmTZEX0SF5s+rDL1e36Y+SWlUE6ruOwUuH74J2D0YcSkkL7PhDqCxW7PtH/fKc4+T1wSzQhRSJU4niMbwyBGVjav6bVM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3597.namprd10.prod.outlook.com (2603:10b6:208:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 22:46:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 0/9] iscsi features for 5.20
Date:   Thu, 16 Jun 2022 17:45:48 -0500
Message-Id: <20220616224557.115234-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50f343ad-5bca-4c35-d1c4-08da4fe9fee2
X-MS-TrafficTypeDiagnostic: MN2PR10MB3597:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB35973F59F8A21761923FD2B6F1AC9@MN2PR10MB3597.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdoqB82szrwrENMjmtNCoM82lxKlM927fy2clTFGr803gnczDefJU2fjGWelEt5JeK6pqjBw02Wp3pw8HYSDjTIxTUnMuGS4Or+wNuq6ghIY2PGB/6+GeaB1QRCBp/NciDR+DwssIueJjq++aLrlfJ7U84hgv0UrPPMXcCupzqU9FFbv8VyO5XcbSw9kdbqfwQKhokTeqAPQk09y8xHL42R2x392bBGSQnajYe09HaLb89rmXoasfj30UQO/4BAH1LdIunSjRooEhIQn1ZCEdb2pW7lcPhuvi6ttZNDBI6L1LLcJ9CcVbR4zSvAcML3PwPGurmEC6J8g+A+G/TugY96yIFTYUC1u+f0Az+4kexwxi1CovscHkne+GjiFUBfMLl/mC6Q7FBo4bXNEZRm2WTAN4TTvczDEf96kCMN+MMWjyO8eoqBTgGPbmAUiZJX3r13c44OzZZSPE29G6aMJFtyfgHrdVcskev1PO6UGM2q58So0VpOHcZwNzZmgiyFA97gExTIQHG5AUHw+Xq0yYElDWaTskqsjTvUecbkOTZaa2iZTG1Oe//ir+q+nhiPQQd//s3laG7N0pakmN7vIuHP+LBSPRogRg0ZPea1d1h7n9e44i97sbdTKqlNB3gaX8KKws7BOI/Muglv+rWAAWkZvffxw0gRc9L1tnrtIiyccG/qQPwv7hTxtu4t/R5tvHgPv/nyEa+XVj6GN7LnJuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66946007)(66556008)(6666004)(66476007)(8676002)(2616005)(26005)(6486002)(86362001)(508600001)(83380400001)(186003)(36756003)(1076003)(8936002)(316002)(52116002)(2906002)(5660300002)(38350700002)(6512007)(6506007)(38100700002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIFh2vSC4rsEXMVS0vH4lMsAjiO1+ZhiUOrRLj12wmlmVlYlvH43UzsXEmEe?=
 =?us-ascii?Q?b6phE9PZ+j3wvGEqTLNtgRt8WPuGFKLKz6hhhpN0QwLePqIWpIaKNguxmt1F?=
 =?us-ascii?Q?3iaVrX7LQccqvXR2XtPTBumh0LvLV7e74G+5kKqUvk/rLiiMbXUEcj22icdN?=
 =?us-ascii?Q?i99G5AO1I7ftVGMRxbmRSIgO2TTwV6CeFI9iv+x1tXLnhPG1RalrelXtLQyK?=
 =?us-ascii?Q?F5JO1MLRQpuYaEEaokj0LqbQA7/PrUZdpFUlr25IeQC+s3LthsiG3DWc5Z8y?=
 =?us-ascii?Q?bhLX7d6EmoF7SXfK1/OD8ejSX2BmBh5M0/8JRhf91LXTYGG1Fabt97eh8dwT?=
 =?us-ascii?Q?Bh34N0Vyc03mPQuqlKmTOhi+XCT7XuWld292ABySbUlFP6y2SN6eVw/pLhue?=
 =?us-ascii?Q?urxLDvMDqjydL2oAqyp1JQBs9vbrWhJ1t7p3GvvKmxds39KZim1T7tnmT5jG?=
 =?us-ascii?Q?VC0IC/gr27pk7ea8otqL2qM6Dx166GAT1tn1YxdVrGQb/IWAHOVQ/JxUbhcV?=
 =?us-ascii?Q?ZYb1VPJFyYYnzBZzbHnKQeYwGUpczdRYGcYw6X79ZKcbZ1MDfMmw8WDdbMvh?=
 =?us-ascii?Q?ONjiHo6o4iNi6FHCyZyMxhkoEroSMuw1X24eR3v+oFbTrk4CYDPczcS8J6/Q?=
 =?us-ascii?Q?mb7ubcojG5RMmvnID5dquSiqN4mAoZeVhIhorQr+tlYBAdBrWeVCsZ7aUO9Z?=
 =?us-ascii?Q?qSNtXl4ohy5msJOZkEbPwJ418HWJU1uuVPqPaN3Rx4uueF2mjplC078Lh+Xv?=
 =?us-ascii?Q?L7iJy/LXhop8R+KJ7Lsap3V9ytRul90zsRiCNwZ5v5T5QMDVyBIl6yIHQXB3?=
 =?us-ascii?Q?hiZZ/R6wDwisJfgN+LFO44NibrKDHCAFAFBykQfse4yQxUg4AjwtdoDtPOpo?=
 =?us-ascii?Q?5/6jYFKkD7NFEGlMDCAHrDpOjiWy9NKmp9DevFFYnn1g/e2oPe7sJDz/zjtk?=
 =?us-ascii?Q?hBk+C5nimTbdSuBVhjV/q+Jd3/uYJH9+dyxCf8W7nGp2eRmywKDTFEcbJP4f?=
 =?us-ascii?Q?RYGJw9Am5iEwwGoWDatmgzoq76U9nTsz7XSlaLsnHujuc3SBzT7b1MtPmn75?=
 =?us-ascii?Q?iuhcOmM7eLexg/qF48kAMVcAFNCypGRs6eFjRVYN/Fv+knSrHdTQYN3VYAxq?=
 =?us-ascii?Q?n94uEso6hdUCI0+YOAsvi5e5PExggHMh3qflXnWirpevH396x11qmlltBIw7?=
 =?us-ascii?Q?2JU3CZapFBRkP1wq7is+A1mHbRfytmuw/pWZxEi5+l3i3BBsFFXy+Bo0Xdn4?=
 =?us-ascii?Q?tQ2IPqRtw6MQnEdxAAyzgGOczBaAJ5AXIhTZZXZSMseNgQB2IfXSU952u7V6?=
 =?us-ascii?Q?SXY2qa0oF4anRAcq+2oSNHIEy4lKj2ncVDl+VaqdM6EbhAxQSKAKZOez8KsV?=
 =?us-ascii?Q?wAruzOf23/LQtQnXdaZNSOLL3AjhlgyCrRIf4+7zwlDr79ALwMDFr2Tnzulp?=
 =?us-ascii?Q?4lFYfzWAY3DYMZnO7dul7gpaenlWjeTXtQIMYn69A8i4KhgtiEGQ8yi4b+if?=
 =?us-ascii?Q?CVxl+hpdvgtpq6TcQ3NfXCp1xJvzrj/vv80h4PiLbVrap2Z3ztRjW1uGXDpB?=
 =?us-ascii?Q?0mYf261dNKeuypystDT2koqEX1urscY/ephaAFY3omwCPEQqnAlYm3TyJv4t?=
 =?us-ascii?Q?AULKrwfW5JQzNRRnw1mh93cGwuXAwClpWJQ6KMdonrbdtxjC4bDr2L6Dl0uh?=
 =?us-ascii?Q?4SnjGtI1hlIjllFwZIBGVvnqHaztsqNeIhxqnA/0p7vtVOt40USUZunJAJ2p?=
 =?us-ascii?Q?Podo2uNFaHX5m6dYIXqVaIFjZfmduMg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f343ad-5bca-4c35-d1c4-08da4fe9fee2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:05.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSRn72i3rUXwaBSVWfihi12tq6yEIw4hKjHQmq05Gr+UC3DiZxlzyJdOPDH+yHuFd74GntnGIzHwEgw1prT5JqBu4jd4ONrzv+PRau1fd/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3597
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=908 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160091
X-Proofpoint-GUID: ZkuNsHo21zXwS7S7oyq_gb8nYO9_2uUj
X-Proofpoint-ORIG-GUID: ZkuNsHo21zXwS7S7oyq_gb8nYO9_2uUj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches are for 5.20. They were built against Linus's tree
but they have no conflicts with the existing patches on the list and
can be applied before or after those patches. The patches also apply over
Martin's staging and queueing branches.

The bulk of the patches allow us to run from a workqueue instead of always
running from the net softirq. When using lots of sessions we see a nice
perf bump when doing throughput and IOPs tests. There's then some cleanups
and locking improvements.


