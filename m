Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4480BC7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 23:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbjEXXe0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 19:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjEXXeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 19:34:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5970E12E;
        Wed, 24 May 2023 16:34:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ONUAK8012590;
        Wed, 24 May 2023 23:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=zNGTkb0qGHLPnnFixoUA1fe+n/KEo/VIzkw0P+tj6QI=;
 b=plcSjt2Y0LYygXdZN1/3xnW3tp75HcsdekvOkyKAAvT5ZZKoBkeFn0ODnMWOpSC2Gpkf
 eWubmdB4jTrBPTc3gka6vjlNi2JLfgORh/S5x6QgchJ0g8c6yL6Q+QIYMn03SOEVOY7Z
 kOTwbEzvZyasuFCg1/0P3z/TvmzL47PT8tbYhpCXcGZCn8sC8XLmSPAU1s2kK+WvVdvh
 gTrSUS00B/FzJOZmnkZq9goGnpb15YRnS/b54QzmMBzOJQFPMRUqsFLpCn+AN/PD4Mr/
 BhFYPAUoTdGNFHjGrclycfklCxCwRPylfVyBNuEHRG3j31f2GXh0dYnYT97XWTBw9kWl UQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qsva4806f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34OMHrQJ028521;
        Wed, 24 May 2023 23:34:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2t52hk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3YaLlK0574wwJIky8tvuYB8lRKe++GdcqPHNZvhHT4iQgql8ar65pqJbHGMGkzNrjQPgSli3IHd/sDWxy+t/r8CtWty98z6oEgHF8IeEYgE6dsnkzO1ckPTbo2bJVj5pVwIo2wVZtleFbjkVei5VFGB0Dh6Efe4O6dKFZJgFMAkvjP09pIBo0aLP1nrNomDLEpSOn9qhClUjLFGjcvGGc3LYyjGemxfWAKUGFHhEL9sZHl0eL9FF8nlJ125WSO4GOdVQ7jPjwiT9s+pg8q7X1vS4eqXoi97VmXoRynOnw7/wksTlfPPWhoLKwUmigAR7IK4XzwXd1QOteuAHHkTTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNGTkb0qGHLPnnFixoUA1fe+n/KEo/VIzkw0P+tj6QI=;
 b=bqYhXHRl2lo4yWXh9yaILtHJJEJjN5cSlpKnHa8TTL25gfJQd2CpaeU1ItWbPdE2ut2aRBlbZ4aqalah0AQMRAKsqEsBndzv9+X1O605CMS8WyPCc0WN3i8kKzkgC2vj4+nNj4VXvuVxG3doDBHB3/YFiUAEUuedTI/K6r6hX835RoJ7/dDSsvj3bAz2f4TKdkwrg9OoHI2NYqK/me0JqZzpMYCxk/OWCAPCvp/CuZFf4f6gfmUtPigrn87pswDsmKpuK7iTSszcF/PCYroS5G4Qv7BsdzoxNQ2cKcM1W1sYB6kdjBnLwsgr6ZmC3HTKOho/x2m+UWYlGz5Eg4B4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNGTkb0qGHLPnnFixoUA1fe+n/KEo/VIzkw0P+tj6QI=;
 b=zJmcloAbJFaMqGgZGt02gM0QVBxsXzpaqdxsItlOWFzv5tiAtLMfXpb8pBvkvelbGfEFZMjuAatGcgH2IZ6KBSerpJ/MKItzhuQjz9ceBTXWpeyacjLEmlSZ1TQqLHnjc1TDkiQ4EH+OBEzUMOAh8uD0HGp9tiojetOhmKclC0M=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6114.namprd10.prod.outlook.com (2603:10b6:208:3b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 23:34:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 23:34:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/3] vhost-scsi: Remove unused write argument
Date:   Wed, 24 May 2023 18:34:06 -0500
Message-Id: <20230524233407.41432-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524233407.41432-1-michael.christie@oracle.com>
References: <20230524233407.41432-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0166.namprd02.prod.outlook.com
 (2603:10b6:5:332::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 47bc3b79-5e43-495c-db20-08db5caf622d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g5WeI+zkcpt34thxLSdr2LJFJph333JzsrIoQ/i4UsSBGAeGOPPVg6o0UotkORjZb3EpovFL767IEsNb9p1rowvNRmlKSfJu5jQ7+/t5WCGZI8OlmPzDlk7PbaorbD5ORbOG4MepIQniAkhifhFZdqN2NV/+RdZaosFclYu9FpAYSxywnjnFG0B4SdMEOw91YwyZJZAua5cH9ucNTHCOrIhB/3cvp8MzE27JQf2ZW+q5XjKNGY9dKYJLiXhZ/xi/Bqr3+1f5Zn3rIlJZ0WyDMnYbEyI6lHOPUkBGjfmiTppLgV45NhnF5/YXOGKF4AfgLFxO4Ax8dqVBuXg0QUUpmyct7+TFPPsdUXH97/zpH1/hIF+RHexpPi11ycjkT0+raMxlJXDHEoRmgP9i5IGdioRgBplj9qcMEIVC+s3Os+GW6qz4vIMhhMEbQgbL7xO9RWLQ0RWEXhWp/uERM9TSR8mIY34hISuUqdrbP0nAD1B8tIStobUMo7InfRrS+9WAb50Dg7+gJLJFWcdNihwnoml+xR6BVIcXEJ9uLTGW7fKBQOrxDMyMrVMtiK6NVe81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199021)(2906002)(5660300002)(8936002)(8676002)(316002)(41300700001)(66556008)(4326008)(66476007)(478600001)(66946007)(6486002)(36756003)(6666004)(6512007)(6506007)(26005)(2616005)(1076003)(86362001)(38100700002)(186003)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nx4qHruDodSDjRr9z3DjwAWQ9mCKRVRfefVdPii1LXLL75PNRKTV8QRAYkH5?=
 =?us-ascii?Q?unaDxARI6x5nAXOGBI+2r5PAzjbbl4DyIbP2o2AJHAGBZQuufFikWlKRWqDn?=
 =?us-ascii?Q?t4tUriHw9vNG/9VfFPcR7gknM+jSh1WE++q6LAEB8T+oSPtJ5kBmmT2a/NNO?=
 =?us-ascii?Q?T+cibclni20mS2B1oTRkAgFrBOoPTA4ALQ7aOn7drxpOz2PYKpTeqglH4Wro?=
 =?us-ascii?Q?NdTp7XkaxA4mnAieris0bjkIO23xhDGARkPfGRcEI2av2JGUnserxl2Ni4Jd?=
 =?us-ascii?Q?6uAyuFNBjqAl0E1Bt9uMSoXD/oMlCDUfgyYei+6e3G45zt8sFEjUsbhrbQtu?=
 =?us-ascii?Q?YPTYm6cOswAp7QiktyVYGrMLrypP/k9VlpwWP2FRkwbe7j56BIfTJ1EeDcjL?=
 =?us-ascii?Q?dhTr5qbwIqESdShOq75nP2AJ9eUSkQAQ1T7DAIz+qBpDTt7iUhmP5XbIHbau?=
 =?us-ascii?Q?cbkqGfsQ7yz78Oo+PNNK8qFCPlTjmtMTJOHO3AAHnZTdqOOJuvgigwFXD/pR?=
 =?us-ascii?Q?K95NILXaJOcJilfqxvz7tXHt3D5sj0PtVFkTJlM6UZxqmxjDKrB0NsxSEPbU?=
 =?us-ascii?Q?d9cShctM1QMakVQpuGD8185TNax9ByafeF2afHy5ld6UfCD3pEHiYzq/N8EY?=
 =?us-ascii?Q?4uflx2dg6D6Rqz4pmS4SVP63yNseDYDZl8R2gFvEd7AMzcTQm5qzNy3ZcRRV?=
 =?us-ascii?Q?jHPXzaXFB4h/Kwfb6S1rolUkTcz2rH7GOL3OuEvCAz0oXHjMI/ErlzY0PdQw?=
 =?us-ascii?Q?uEBWIULd/i8JlhXK580cDWT3HgYTELA70nHBcMNXoppze2yPh7sZ8iAAKs1n?=
 =?us-ascii?Q?CUXN1FhjiP97MjrhdT/+tPC99OXCaWrpYAydgBdhS1ofV5okcjC8xNXyq8bg?=
 =?us-ascii?Q?aTlEYatibmKD1Pzwdey4HkeZWX3K1LxkOMF+0Wh4+sYxHmEgKPzWGB0+i2Sx?=
 =?us-ascii?Q?IYdKbdzUPIZsBUGJluIANH0oynHWWqdpuM6sWVXFNxFnp5m1YpsCrNUzEwPW?=
 =?us-ascii?Q?2iWSxYyh1A8OBBM7G/AxzoN/kdSGigM8Vn8IiTCfoLlTmJRjLaakBRIZh7Nn?=
 =?us-ascii?Q?m8IHTSihg5GY9wHmKy4mdLN/r0BXkEQrMlOZiL0SqOTE8cYW3hW6wl1G2hHC?=
 =?us-ascii?Q?v+YwfS4Obt0CV4bnIr5O/2888ZAv/niNAfk44n69PLkWbxBonY+IPcBCJLOA?=
 =?us-ascii?Q?WHJcIXGUWZ11XLR+FnYigCMR78pEUl5+dp5YZcSGGRo/jUkfqvvB5SPxypA3?=
 =?us-ascii?Q?zbpYvlStonFjMzy63UUrJklPLV24HcMY0/c3eMGp0+a0K/ieDKXW/I32AiFb?=
 =?us-ascii?Q?oVU7WPKPGDWFxsbnFxBZ3FvzP9ysNZet9gYKveeq3Yg7bgwUTYSEVAMVVpCP?=
 =?us-ascii?Q?HUoXbyAUMN3FKzLRtO4/GtbUt11VIVpXAItrLVlN2pcmBaczdUVyKJoHGhEf?=
 =?us-ascii?Q?POiWVwvIIrtnbU0+3sueWlCZh/A6Q8ngT4/pswmKMZk0L30FDJbZY1fCoZT5?=
 =?us-ascii?Q?+HUtsWbkMIUF2+ezV717uTOARZqeyw4nXTjfAK8n+n5m+f6yS7pPS5R5vvQ0?=
 =?us-ascii?Q?gBtTCplw/NKTAns27gFOVfhb/6AKTuo4s7k5PsQia0bZgVy4VpYocbtFwcls?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: e0bgqkUOYhjOg8lbtkFKtTMN6mGivUeH0Xd+bwqcf8tdpabuPpONrPT0HKIDJkMiYLVKv/0jVjQg+EA3tNkynMloYRNlM5fv0jvZatZRL5ibW3mcOnfHEep7WNiwPDcAC5r4xq5g8tKwL6v6r26h2pFlgKPCy6TwI9Do056E4+dufxEeNFGVjAY1zyuSclfmw/cPgpK8u7oIlnbYDfKxqHG6idweHPY38XUAmIb8GdGUoptaF+QlTpT1f+s+03nNktEstlL0VI098vlHIMuqxC8sliT0S5PZ7NVmAu+v52Ks8fpor9BWnZZvXw1qKusB1URW98D8wqErdOh++5lzzHcFYIjoW36WOdhfhVOaCyjj9oHvwmsH3Cyu+IfftHguG9zFXCrgAMJNy11tEMtccClKrBCwk9TQlRXy32JLjJEOCqnPxZ7VLndo9iT9V5EpRZAhHAEhX3AI1NQsxVumsGG3pQJMn7DXcvBHWD7QSPkv3DOjbD7d7WzifHae6Y+sjfDJroJjW8lqsEMWWloceSu2PIZfZ9RqNguVpeEqpmrKYPuKwaFkwCIE9acIdBJXIfkQJxWYMHgTj9NeLtTvjwO4hcdlwwO7g/Mklc73Xs4jPLkXDvcSbVN/IcQcEXBZP9v4CJ5TU+52Im6gNmihg63gvRva1kFiY7EGuF+aXCI6rUe7qa/t8OUIWqgjyu7sQt5rs51A0UHFzTT8ud9SiCxNMIDGnDxf6aXq3n45aUDSVtgdSIvtGnyM/ERLNcEjzuI6pyCTY67i40kgKk1elVcSvEuuN8f2o4JtT8v18zRvT0Arthss1rhl2xQw3GrX+Ipv1QhkFh+m4R/yvGHfRJDrWWO2vA9t0a5/zyDxLyw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bc3b79-5e43-495c-db20-08db5caf622d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 23:34:14.0711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6yInWM5lJVvBC5o8cFclf7VC/6VlsOOB9bdfi+ihvyN+hLGdYIv0J0JUieAbWHDW8svZoGNonWR6RJD+gjpOuYgdpA16LKrjulMQa4B0lss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_16,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305240197
X-Proofpoint-GUID: oNBvxRq70xRV-rbI8hbE9cZ9SdFfXr3f
X-Proofpoint-ORIG-GUID: oNBvxRq70xRV-rbI8hbE9cZ9SdFfXr3f
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The write arg that's passed to the mapping functions is not used so
remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index dbad8fb579eb..382158b39740 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -649,10 +649,8 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
  * Returns the number of scatterlist entries used or -errno on error.
  */
 static int
-vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
-		      struct iov_iter *iter,
-		      struct scatterlist *sgl,
-		      bool write)
+vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+		      struct scatterlist *sgl)
 {
 	struct page **pages = cmd->tvc_upages;
 	struct scatterlist *sg = sgl;
@@ -696,15 +694,14 @@ vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 }
 
 static int
-vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
-		      struct iov_iter *iter,
+vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 		      struct scatterlist *sg, int sg_count)
 {
 	struct scatterlist *p = sg;
 	int ret;
 
 	while (iov_iter_count(iter)) {
-		ret = vhost_scsi_map_to_sgl(cmd, iter, sg, write);
+		ret = vhost_scsi_map_to_sgl(cmd, iter, sg);
 		if (ret < 0) {
 			while (p < sg) {
 				struct page *page = sg_page(p++);
@@ -769,7 +766,6 @@ vhost_scsi_mapal(struct vhost_scsi_tpg *tpg, struct vhost_scsi_cmd *cmd,
 		 size_t data_bytes, struct iov_iter *data_iter)
 {
 	int sgl_count, ret;
-	bool write = (cmd->tvc_data_direction == DMA_FROM_DEVICE);
 
 	if (prot_bytes) {
 		sgl_count = vhost_scsi_calc_sgls(prot_iter, prot_bytes,
@@ -782,8 +778,7 @@ vhost_scsi_mapal(struct vhost_scsi_tpg *tpg, struct vhost_scsi_cmd *cmd,
 		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
 			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
 
-		ret = vhost_scsi_iov_to_sgl(cmd, write, prot_iter,
-					    cmd->tvc_prot_sgl,
+		ret = vhost_scsi_iov_to_sgl(cmd, prot_iter, cmd->tvc_prot_sgl,
 					    cmd->tvc_prot_sgl_count);
 		if (ret < 0)
 			goto map_fail;
@@ -813,8 +808,8 @@ vhost_scsi_mapal(struct vhost_scsi_tpg *tpg, struct vhost_scsi_cmd *cmd,
 		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
 						 cmd->tvc_sgl_count);
 	else
-		ret = vhost_scsi_iov_to_sgl(cmd, write, data_iter,
-					    cmd->tvc_sgl, cmd->tvc_sgl_count);
+		ret = vhost_scsi_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+					    cmd->tvc_sgl_count);
 	if (ret)
 		goto map_fail;
 
-- 
2.25.1

