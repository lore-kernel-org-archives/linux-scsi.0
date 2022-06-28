Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39F2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 20:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiF1UMN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiF1ULw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 16:11:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235643C4B9;
        Tue, 28 Jun 2022 13:02:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SJBRa8022063;
        Tue, 28 Jun 2022 20:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nibEeBgyPx58cbD8OvsRtONw+EnsT+Od+C2KYGfknMI=;
 b=XuOFnk1eVjZnnuTzWozQemAIkbNC7kred97exUbn6omwmqPvYKDvJQQgjeHGqPSO0EoS
 8P6zmpJRhyZosQZQSVz/FM/p+XDB8LhPFk6tgdWoDAdumvDNFbyRCX24pLR+QKKeD1f/
 QXoWCXVDeMRuXaXd9vmx7EzQWyc3514ACk51MkPCcck9arHHeFZ06jIOO7uI/No7PnGJ
 BPJuWteR3LUnpJEGoAxhgsfEw0jfD5QLAkb7Ve1m9LJfO04k7esWOAaboX08XHOzVuLW
 2/0zaJW2Nf/PtRldPHNIe8+bC5/gO2NBfyo1xdHBkJiYQ8Qg8Xt801E5zu9Ssl3Zfa8c eQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwrscf3wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SJtS1A033538;
        Tue, 28 Jun 2022 20:02:44 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt25gp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:02:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDOi/w7Nnvbi6AKyswTQPMunW0uOAjOAN92WmwVt0w16SjH5HXhhSyzFPv4lirrYmtOokNepstcJ6O76BEE5rs6dX6A3JI+KnTkuSF9QeZAX1FUvaML/Knq8IBJyBQzfeH3hmzGk/Uxw1ZvFt9lhvJgO+hqeQY59h4RRseAu+OEyvbQ93sBeaJHURg2UDYqcMwibtwFmevtGSP6tIfEpHXdXcAaArns/R4gr+WEDYdug4+oRxzBD5ZdJVc2KjWM7W104o3fz3yLrPZIwK7CyZcn8zSdCTNv1GTayASD4fe4VLfk3vkzRtS6/JSfnPMCx9MCqnStUizknX6OghHBb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nibEeBgyPx58cbD8OvsRtONw+EnsT+Od+C2KYGfknMI=;
 b=O3iPz5a+5d0XkF3zNhV7wK4eEZPc9knCqoYlQOLElk/HF0SYuvFNwGPKao2bgNcbPTVJpRLzmn+edYZm32dtTbRdBG7vJlSl84cmoMdetpNE17JfdD2L5LSma1LQkYajAAc60U9Wk4Ns3+qHxPc7tOa33T79d1swrhOVT2ftn8qbxhpwcHAJg6o+QT6OMWBcCu9u/tpayVrQ4S6b1hcowo0dhDVFSBNAFMJqGAYp+G8PSQmdVR95WxLjtvL8vt4y1HqG+Rvv2Z3OYmtANsq8K399cuKsmboNyeGtNyvZ2vLFJ8CBhbYe9PGf+3EeSlg7AZylFWOsy7K94Xxtclx9JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nibEeBgyPx58cbD8OvsRtONw+EnsT+Od+C2KYGfknMI=;
 b=TRysYGlKJckrLhzTk4t8z1K4cHfCibcLS2lT5Hb0dIibIgXRDPXzDI9f9dr1zJZXCAdk9c5ITaWzM/1l7LEcC1jLxTe1fqCC+fkh9uqZuu8Cari8fVRW6jj4SoTHPqAyReXNKpgbTee7hPcF3A86PCBoY3uj2hKpfvilMjZjBwk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2376.namprd10.prod.outlook.com (2603:10b6:910:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 20:02:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 20:02:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v2 0/5] target: UNMAP/WRITE_SAME features/cleanups for 5.20
Date:   Tue, 28 Jun 2022 15:02:25 -0500
Message-Id: <20220628200230.15052-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 994f8a83-447b-4a00-0e85-08da5941265b
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eHBDKgjBS7Ggx38gRWMo4TiAq4QnrzMLseDzVFOufpvXWh8o8O1nR7SCFVfEAtVFurkiuhpDv0k9eCbFxGN8iZyllk33lL8Ds0umO37gDZy8Mx56C2qFJ1Z2misx6PYTYJXLEXpw6H15brjpw6ZicGciLZK2n+RXuihj7tr5fcoZjNEh7nSHLF1isp6QMFZsbRk2Wy6eFiumZG5Gd0smn19cS2gkEgThCEa8QFmFZJzlN4wjRR8UdUTUdjvv+EjkLqVnIRnfKyA2w4I1iXeJWW6oVXmJhEVl5zU+0UCAVfidw3RJc1VJPKt+SvRHY2RGu/ZO5+y7ggCDkJF7gEwPlLUWhOnzvsSO3z/bklrOkfrU6rWgyDXj//n/re/xc+2i6Ug5FS0l2WdDeqTmownyVA/Df9G5p7v9TS2039ibEU86lxtpAsH47DLN5n2iS1KV7OnwXjgt03Aflm0mvwSyK/aBuqXQMcVWar3QhB8THSPBy3RgHh7Wltwbodi/z9cZSguwROxiZPRx0CqqxXq3BvWXmOcm9drp606ybYnegHChkZ6Z6cmU8srkdAxvKvCAMMyV1mk40PLuYvAl2U4uSVUe1Ij7mYU6t/ERvpWbya0oXVfRaoQCLXcxrU1refr8BQQOtYwZ7kfW+CFjUC/6wpRpEQx6F76bSbzCr7AKEPbX8CMrziT1oZraOX7/ZBkQ123O7twwvIRzM7BooNL09cMV2Yz5E3HDr+NxxHA146Vu10mD9S81eB1eoALQ2Dm7v8kOdW811+n2EwXeKxVz3ny25XEPdVCZ3EgrF1vc6o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(39860400002)(366004)(376002)(186003)(8676002)(6666004)(6506007)(2616005)(52116002)(1076003)(26005)(41300700001)(6512007)(38350700002)(38100700002)(66946007)(36756003)(4744005)(2906002)(5660300002)(478600001)(86362001)(6486002)(8936002)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DFiX/O8OYMfjOWI0DIl7f3B/FyzCIyiIpYm52vyXctimjsafsLqr+xBGK4P+?=
 =?us-ascii?Q?oi+Q4rx7BSWQiZ4eR9RjqCEt4S0Xi8OznvcHDsgTi4ML7/EetYPsZcnaWGir?=
 =?us-ascii?Q?rspu5wP2+/Z00SP5l5ZdXpBlp57Msuhjbzo7n3TF4LDMHY/Shb4j+OT6xlnS?=
 =?us-ascii?Q?CW109K20elIphyyFqG/2hciFe+fQuKvE/EQ1VqwjONqL+T9JS35XCVUIjmlg?=
 =?us-ascii?Q?oQ8OB9P8tDyWyRQOxpB9Sa1h0o3KmYlfk/P5BY0rE9cosTig0aOgy7NSzB9k?=
 =?us-ascii?Q?B+wrtB9liie3ylDr8Y9zK3Hdh9opLoILHB8Y1Hf/MP5AyKI8y0YZKgtOB7qn?=
 =?us-ascii?Q?zuXDyLvBtKhdXDvJfzebG4ry9TuHZAr1ZrL3WB/lA/736EWqOU7OShLKKF1P?=
 =?us-ascii?Q?KTTMhPKUx1IL2otceEaYZTGv7usT277CAbsMem/2OGHy2lsFTaQpSpdIEhOj?=
 =?us-ascii?Q?2JhPOeAQIdRSyua/Eaka8bT17t/5qWVnHNnlhLQv6+nZW5xd9w5UDQ4boPnf?=
 =?us-ascii?Q?BW3HUjr6qkEbCLMhlHNl49IXvd1Olh6U3zd6jS52aFq32vY4m+tbMj0EXi55?=
 =?us-ascii?Q?BwkhxK7JYsKsKTPTxQQJZ69RwyVvjiiZl3FpmpkiN8KlFCul+sZDxTw6cXE2?=
 =?us-ascii?Q?9a+jlhCvHn/HDEH3LGcmeePvEoomD82geEB8ZIKDzaiHRjgSbyY+fpP4we7L?=
 =?us-ascii?Q?0IhoLGc7g8mVuEBBveurLclNcDlJAjlT9vJWgIeOHM2ITiGGERyi4J7kZ4l5?=
 =?us-ascii?Q?cyR8rHVXiYwihG70qcUdMpEJrkQwK+bxN4pvpfN2A8Q5SbHIkXa6x7bcQzfd?=
 =?us-ascii?Q?Wv8OqOzr+HEFTCPBqYiLglfS29wrcQE0vy+90SWQZqoZul3CSSFeNFvUcQ8n?=
 =?us-ascii?Q?82l9gqQg9fjk3HHDuyoppOAYfVlljMdCa2j5zrSrWQt+aQmMt/NRP8nRQ7rO?=
 =?us-ascii?Q?ZWwQnIpFL+5/+puRvDtU85NRz6yRIr1gQ27FOhfa6Av5HUdVmWXwGQgoJZI/?=
 =?us-ascii?Q?S66UGdpKZ0huQwBEsIQL68KtR0qQIOuNwr6Wkyf61GqW9DDY1ti0C1BisHaM?=
 =?us-ascii?Q?KuKl87YseclvfR4M8C7JYWHSbYCAE7sMkxN1UAD0XWUK62VZNE5nBnmbvb0B?=
 =?us-ascii?Q?+EIQvQJV/FX/UHkIbl0JIqWsZMOQ1o0Ordobs7tjfrF5uogGYMYGtwk894sn?=
 =?us-ascii?Q?heno3LmqRLGcHQUys4jJVa6wf9CO8LxVyQQ5DlPb+aVKXjxKxLP91cxOfKbe?=
 =?us-ascii?Q?2NDS2K2mOCnGVc1lE3+mWaJ5k7HwTZja1yl1SrjKaTw9ekc7lAeE5vj+aYgd?=
 =?us-ascii?Q?ZtkP0/FSPe9bN5yPXJd6H7m9ca8+D0wXQA46TGtVta5oiU1WUEX9VqoP6UIp?=
 =?us-ascii?Q?Zq3sK/4J7QeT7zZsL/X15WR3ASjtcfRuSvKNZnW6wDteyMUQfIG7ai6bPOIx?=
 =?us-ascii?Q?8V5Xa4Q1fNZ/i/56zc5qaOEw9vK86+GJ1mHhpltk88vhyANrBY2HfzBOQYFB?=
 =?us-ascii?Q?XDUd2hh+4w1LKGlqFoA3d5EfzH8GmIEEwvmKLTeYwkn0gZP8Qq68NHQAKlly?=
 =?us-ascii?Q?Y/jtauEl5+yiqru3cOhRWXfEQTvhu527h84BjQR9cD7psKy/WNBBi65EBie3?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 994f8a83-447b-4a00-0e85-08da5941265b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 20:02:38.0563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRemaFj2Nr4STgiZtR40eD71csgmwOw9Ff4LNwwHTU51FGeeNP3eMULVZWAiraoHE9c1Ed1v39HKTa4f3GbBwhdCMgNNam5e9IgRG0qDZWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2376
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 mlxlogscore=605 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280079
X-Proofpoint-ORIG-GUID: xiNHAQI2A5OpKh7WOrBildELrg3aI6Oj
X-Proofpoint-GUID: xiNHAQI2A5OpKh7WOrBildELrg3aI6Oj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree and:

[PATCH 1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash

They perform cleanup to target_core_file's WRITE_SAME handling and allow
users to configure UNMAP/WRITE_SAME after we have done the initial device
addition/configuration.

v2
- Fix coding style issues.


