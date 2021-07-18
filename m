Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6866C636CA
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Jul 2021 21:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6FA610A2
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Jul 2021 21:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhGRV4H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 17:56:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24834 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhGRV4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 17:56:06 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16ILqMbI007428;
        Sun, 18 Jul 2021 21:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+ViXhcssfO8BaZfRrM6rjy89HVDjpxkaJZmkyvQD2H4=;
 b=MLLAYRge9zZgWrIZCYTcjOmwOj6VnW9IPF0TVYU7z7N59CH4XBHWI9paWg3OhBrEtkeX
 UqTh3mo0iR/YgD+QXoylcHnojXAYZcswWghzK1EefDan74ssygbcLMVkimQ0cPhEWjm9
 yfWyOlcclVfr2qGTgwMXOZNZuosjxTrSiI1tI3uC0o8Mp/VWQ8FsxoMN56lIjPgDPUZ3
 7lP23c+Db0VExZb51OWzYOJtPlobQX/OiIiw17/MnGW68s/7wJ+MQP2JzLXeNwesuvyE
 47gTkUdSItYZyoR7okwWLS3jCB4sZWJh9VBVmtyzKSMyW8G0lExCQ3LjJI/jbdcsfzmW Fg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+ViXhcssfO8BaZfRrM6rjy89HVDjpxkaJZmkyvQD2H4=;
 b=CA+G7beQztjUF5OxnC8aiP3r7NB/cHj6w7JhpBBIB0s83xYYONN+wssSUB94hrX75GwY
 LXIVk1TfqC6BwEnXjZb0JJQFmX9e/I4FDmv2iSCLa4DtRLs9iSmObUHQ8dlsPN/Mw0jy
 8CC7MeD9ogZkCbiO1CNlLdnwASlPtdH+KnlReudTXv7MoUTPaMUe7nGExTlHa5QQ0g1d
 uPW6jvtFK0qY97wn6YesZAtF1qC6wXgVgrUtbLjDMcRPRBPlxYAce6uDrPYVGngVJZnf
 2artdnQJ2ZJO4J6mO7IOHxXd6B0WbMbvEHapprD62Ba7di03GRDOc31yw0lWnLqt8Bao Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39uptrsqcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Jul 2021 21:52:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16ILo6Ov061285;
        Sun, 18 Jul 2021 21:52:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3020.oracle.com with ESMTP id 39v8yrdanm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Jul 2021 21:52:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bo+pahjdjLFBCmNyh7yaVS2BnUbLPo60JI5fBFS9JqWWRu25qgkpYontSw+EjbVPsnuoi0Mr3ThBruz/cXpWEEPXZLh0Fcoy4ijJzukhHgP2YSrRfqnRBxbCAcKh79wxJw1ojMnIxiBj5NsiW7nqABuNE1ri6O5FoXMifQQKuCGEF1wqGCrc/STPc3ZVs9pztZGdh9fxay2lbDhDCM26dl6svntE/XjmkxMV+k7dhwgIchpwDUvhF2HM58GepnDmkR67QIUQGsaNqfiafzWhEKlyX6sPxivo6csiwSXjDGxqwKR/aildCRqPAhhmTIawJoZLD6gY6GYb1EBDCoPgmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ViXhcssfO8BaZfRrM6rjy89HVDjpxkaJZmkyvQD2H4=;
 b=aKf51zK3O5qHfp8mXMHgZxGQ13q61vVidH7Kl3WYS4pTh0FRcj+8kv3rZ2l1//NnSZE0no6wIYSmKWBq++ZzV8PXq8ucSXUZ7cS+Q9LMd2LqAxc54WyToA5jdV4YAO4pUJKG8tKp0q7ayx1vWX38Zi0ta0Bm7m39ywevf4b9YoeDjlgwh1+acIvCjougo/5hY3BrOLzNRYmWkjnMjgIGeNoLNsNcjdOIIuisiII7hRxfOQEfXr93UXPD34A24jbTrr5/VM1LmvuOE3FXiPOa8V1g0fclASUyrpDD38ru4eA6Igyx+tO5mJdmaqGbRT+1NMyI0LN8CMAMHFHUfBXo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ViXhcssfO8BaZfRrM6rjy89HVDjpxkaJZmkyvQD2H4=;
 b=sXruWJLTAglFSJIWtxcc7PbOSwXel+hNvgOyvKa9N93jGhT+sPXY7mJCzgxDXAktdJ2f/xQp/aXTijF1i/U7lOdyf+b4HOqm3Y30doYqPw3Q87uOCt/0njZa1UekXs8j0P1suOT8sftfl3+n4ZXl94MA8dsPocLEZhixnZXLeUw=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5404.namprd10.prod.outlook.com (2603:10b6:510:eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Sun, 18 Jul
 2021 21:52:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:52:44 +0000
To:     Keoseong Park <keosung.park@samsung.com>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpinto@synopsys.com" <jpinto@synopsys.com>,
        "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH v2] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnpn1e8y.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210628055801epcms2p449fdffa1a6c801497d7e65bae2896b79@epcms2p4>
        <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
Date:   Sun, 18 Jul 2021 17:52:40 -0400
In-Reply-To: <1891546521.01624860001810.JavaMail.epsvc@epcpadp3> (Keoseong
        Park's message of "Mon, 28 Jun 2021 14:58:01 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR05CA0092.namprd05.prod.outlook.com (2603:10b6:a03:e0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11 via Frontend Transport; Sun, 18 Jul 2021 21:52:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f03f4496-459f-49c8-3662-08d94a365f58
X-MS-TrafficTypeDiagnostic: PH0PR10MB5404:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5404EDD67588CB0B090B93E28EE09@PH0PR10MB5404.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nJMJlBDwo59EGRVJXiwHB1uATucsviJyBt3Exc1hQOL6pYHeDVrVneDmpufm2l24+0L09vFemWu2+9f8GhyVhoKVbDbKorXaiF9Cv0DA3VvTaBl/InuhcYpahseGhIEG8KQurr3rP/TsKb42N8b/uBxZZJK+w7AXOZWLQQRtipAnJ6kua3ktT20oSYlzl8Xm08j5/fgYRywYC6QZx1SWoD810iTUPGJ9L++XtodEfzDyafxU5WURaArste+Q1xNxhu6HOTrvTbHf6w8KGZiZK1QltYn/Ec7F74HusgYfLeBeP3ETJ2aIBK42hhStwfkMkU1PSYAJovYOym617PzIS3/ibcYum0/Crs5vc73Oofq36RMbNsNTWReRGDOTJIXhALFtzkm8QfMGyY09bRzYX6gsvadT9CAT9zaesKmVDmdNbNEE4C9EhJ3F2HCbJTrORQMA9lhn2Y9R/cI0sPt/82kIQh4UIfPmx8LiiL441khjOfqRt44VwC5RznQnuNFU0EJsnIuVlU77xnu3AxeSq1zAKWZJg4Mql1cAhQDLtHJqYLKLmFNeGvaYaC3LboJknXNKezjqwnvl6X9kOvN1N6ODDAPwl/csmQBM17cLjRUXzc6vUbM25X1nrUy7thvEE9II1/F55//0sbBx6gT/XXbOZ0EZuYLQcYmjLtkxYf1dSdz9vxoFQkXRZxnP3hnMuRBEwRvjoTh84BAo3HUCjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(376002)(39860400002)(5660300002)(86362001)(26005)(956004)(8936002)(478600001)(4326008)(66946007)(8676002)(6916009)(36916002)(66556008)(66476007)(316002)(55016002)(7416002)(7696005)(38350700002)(38100700002)(54906003)(558084003)(186003)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SEtLkvtAOXCQlg0zzWoP2C+sn1bK5G5aUp8jjkQfrRNPW9XNXjstKe9/ak9H?=
 =?us-ascii?Q?2xRwc/QmWAAVNlIiFnczCWGIHkWjaIZLoWqGfnII2+6YPd82G9LOSTnkRKUD?=
 =?us-ascii?Q?qszNLCg7w1FSZCzrv/upn1CLTIUD6ZMVVxRWZCw5hAhlvML4hg57Qcozdy/o?=
 =?us-ascii?Q?nsDw2hpMUNn4N2XVwlGa0ha2QCj9QB4D+ATMAwatozy6ZuXzr0FzS1blDBNi?=
 =?us-ascii?Q?XfZJiDUVkLmNW7fWnQ0KYhzxzMWWEPLNc+TlbN9D/x9vx/jOrUU2P+0/fpTJ?=
 =?us-ascii?Q?60/6S9ZbvMaGKHVCrJBY+b/t0A2xWBLG87VwFyP6ZV0LIBdGl547KZQOkDhx?=
 =?us-ascii?Q?RzHbw+oEY9BU7AWVIg7Qi+Y0OtBLHQAQDezIvq0FlvsbMtlzRPdkbXQ0phee?=
 =?us-ascii?Q?ERf0JrqhEI9vD7mi1a7LOxl2ElLOojzM5iIDVwPhTKUUV93hSuPxbOmhsqmI?=
 =?us-ascii?Q?nWUIDKWWXmmyZAFaj4Per3b2Vs/8S2lYX3N+u7iR+EuTRpJahCARgQc6gm+B?=
 =?us-ascii?Q?MZwa+JLaaj30xWvWy1QR7khsFCbNSgxzc7L3pW8oHi9kgrkSQNjTERpTV80O?=
 =?us-ascii?Q?YEazOijAXE1mCHXTnkoeW365nqdfrZigbTDdb+q43e9jAhmuZ/iyzVYxBpx1?=
 =?us-ascii?Q?KSLyGdDsZ+6x8B7UlcvjxhZNj0FdzAjRgeoCGi4PiopcoE53RZMgNELUJzKB?=
 =?us-ascii?Q?GDwvb0e7juUIf/cti8O4WUGE011x8Srk253vil03DD5FKbLkNoYhe7K2/kAy?=
 =?us-ascii?Q?Yox6GhHuu2uIVGi2j4IH1dwJcS6fObqxHSysx+WkW5YVHvLnDsayoUV2xBjn?=
 =?us-ascii?Q?s6wRyVfyuk//60fcnbNg5ILOFJLY80UViHcaNb25Tej/SugsG6KzAwq3NpfR?=
 =?us-ascii?Q?h/36belFGlEVxtk25+2dg1JmmO58QY+6WdlEj/hP5pYjYncXqPdj9S6T7y8p?=
 =?us-ascii?Q?S6E1/B03ylQv2oKaWpyVriLPHiQSwLWAAM/pwfXfGflYcQanTSq9pipd1lew?=
 =?us-ascii?Q?w4Qt25hI9wAunFx6b/RwK8q7SQv6JEC8kfIpn2SE8KWk07yblcsYTksaT8ZJ?=
 =?us-ascii?Q?xRWwqH5qOwoDQ/PGUwqCXY4iTYznz102UiDid2V0JhFjm1+cPRiDOd2YoE5D?=
 =?us-ascii?Q?6VJfgvRvHmz+m+qWq3Q9hnadFbqUYHSaXADUaac0HZuvenDtn93YoIkgSMQA?=
 =?us-ascii?Q?SrReJXt3RI40Di/V45Lwq+9zLbhI686nihovNOJMoT2C0tiSdmZWkBkgNZ6L?=
 =?us-ascii?Q?CuHbjeu+MylsERcl8FXTZ46y9uKJQL/gsgbigb76e64hPNm3zHp5h+9s3aA8?=
 =?us-ascii?Q?7Ogr1NzwB2bnQt3ZB9O0N+yD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f03f4496-459f-49c8-3662-08d94a365f58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:52:43.9226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +B4oVWZjl16ivdL8GnsNQkIGQr1CUhQPlreENupCUFR3bqQsGxI2WoEx3jLh3amI9off4hP9sg7wOXFfb2pu5jtNu0cVSppC+/+zvDaxBE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5404
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107180149
X-Proofpoint-ORIG-GUID: 1mJUzvJ8m5P77katzKmsoy6M0DIT1m9A
X-Proofpoint-GUID: 1mJUzvJ8m5P77katzKmsoy6M0DIT1m9A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Keoseong,

> Simplify if else statement to return statement, and remove code
> related to CONFIG_SCSI_UFS_DWC that is not in use.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
