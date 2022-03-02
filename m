Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCF7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 04:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiCBEdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiCBEc7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 23:32:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E04AA4189
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 20:32:16 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222eVap010950;
        Wed, 2 Mar 2022 04:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=t7qlBgN9/A7qD8/Wq7QS50NceMRgCLtwc2bkr0ul6p8=;
 b=iY+32Wo2kpE7cwJPAzKESyAsOmJoiIEEjyS6jQZrXrVyh3veVx5IAkKmsracZBDu1UTO
 BLfpvpmqg01zK3I/XMiY0j0HXdBKXLOToCJcXS7Io6QXNsYcZnA7e+TINdFdCWN7waaO
 CmyResE9VFRrufp51JutE6JBf2veARacHd1n1XIOFMeOTD/ZOyGyty63YPINJf8bhmkL
 lLR4ywG0Gg7BVIBVZTFw9yA0YSR7s6xnyDdRNUgDBcxGBzaUNaPVfON7Qg4yXnIVF26S
 bdMnVZ7H0nQssyvTnj6R7xhaUj6pmMiSMchSlcB1EyM2/ayIKy0GFT8wx/3tsBbxMtdS +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvthn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:32:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2224G0ot080507;
        Wed, 2 Mar 2022 04:32:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3030.oracle.com with ESMTP id 3ef9ayv7f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:32:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwWoIzfrA2tkM+b96WH+VxMtaOGLa8zGq47xVQJffzZd4HOwhjeOOFapf8IMhfZcSPSVJQ/7VhQBk+ZvWnj95SZWgYn3AMb8idaQrxfcHev9wDAC8EhTDyhP+TWm8EuzhbiGmRvBGbVH5Rh7GwhDq0qCbJcmvkhQi4Eh4clTPpIrYPbJy/K2RG+49VB3K47kevF5I3LCBD2yFjoXTPMjIBAHocaARQem9I2NfoZWAo7jkM52a99qz/jmQi4cozInLB86RaqDQG3rjtJlo/Et6s6cBEFAD+2qQWwaZWX52+btt+wUD7d+MdO7EUwreqfUT4gUw+VCW3xS7cP+DiWX/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7qlBgN9/A7qD8/Wq7QS50NceMRgCLtwc2bkr0ul6p8=;
 b=gZqBp4Sa8XNxj79NivMNLSPHh7PfCb5wes7qauWJX2ggB9HQfsgGNwmyOavRKQ5UGZMTPZj0h3GlmWvGvIWWsjmrf1Lon0EZ8enmPtZW4IpCg5LymZMvoKeMxR1QA5ts79x+8KSXuywxNIRXsyFHMT4nIOT049bAEbJOFGvjcBM6y1gAQQeBqntrNocGLEPmLDJswJcMwwkmBBiZdVY3H5xc+zeExiRPlhRoJetem+hTBVspiw3vxsuIAukbf2M7Lq8pTC5gJT6d7YtSEoAAmFs5kYMmMJN/VLrO+Xz9iPhdG8Yt4+Om4tF2k/4WFeGTyvp9S0LHR0S+yMJ39g6sgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7qlBgN9/A7qD8/Wq7QS50NceMRgCLtwc2bkr0ul6p8=;
 b=BsKgGBDN2rqrF8rT1ro8xyWjdjf0zVZQYREmgY5Zkd2NduvQFARAzpXgsxvJbA9VKrWdfyjvXn9IGTVtETeQ6ZXTx+AtgwnTCiw/iVra+4wbaGkrvp9qjCo7UK+lDRq8V6tZDh3490ARHYrcb6K9u2wpZ6p1U+97olK2hrXX1NQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5582.namprd10.prod.outlook.com (2603:10b6:a03:3db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 04:32:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 04:32:04 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] lpfc: fixes for EH rework
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mti9ynyf.fsf@ca-mkp.ca.oracle.com>
References: <20220301143718.40913-1-hare@suse.de>
Date:   Tue, 01 Mar 2022 23:32:01 -0500
In-Reply-To: <20220301143718.40913-1-hare@suse.de> (Hannes Reinecke's message
        of "Tue, 1 Mar 2022 15:37:13 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1af86c05-84b8-4be9-ad09-08d9fc0599f6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5582:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5582D989FB229C895BC0D6CB8E039@SJ0PR10MB5582.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gdhGZixkBvHFfkrbSZDGbW+p4oz0YIbRQcV5fKjxAdy7HKqnKHuoC126WJ7z9BGjampqxVLwQ2S0L1EeZGzWoAk3MdX50xjv+6ThKrnxt0AZplPyw3VlUolAjLJOsZJE3o1K3dKd0VxTynEexgUs1qywNiORcvmEeWpEutjl66OWT/N74FBoXEv9RxtMWWWAwIqrxBju25GFsOkG6XRt7QlX8HtDzJaw563LQA0CbRSQZ53Ph3wKdt/HcmhMsdd1gIn6IYcjJ1G+xp5nGZ2VksJXE9MsfOsDr6t0/+XiDAod4fYRW8SaaQ4WztY55y3hbPEKBLdzCtzuB/VCBlzEKRShJI/rak0tXCMJ67Yxrlb9yFyhkFXQpb5B0V3jjXwwsyRR7ZIS+0MYGLDya7mJA3ECaP6O997UblGwrM3rwGfla+++cLPDOXvXnXPSyiV3CBttPIHfXi4wFxPe25T4IcWmnlSaSG0V95+wWMrtL4ZZ0MEgSH0Gzhr1GFnPg0F/Rw3LTWU80TmSkr1YgKesmeXFJHkXt2QlkqpfMS0C9gdgJsjpDgJwkLboHBJtFxH2oDp6Wi1JqYGCirLYaRiZrpixx6+1XlSSFZ8rE9duIUzwNfGu9/Mc0sA/OK83wgIP58Jw5/Sdy2SqHiZQMMnvc9Cl/3dV49VLE5G+/5HjLDXaa4F+uOUIE9EwWcle6olRNCpQxBi4sy5cew4dytoPXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(36916002)(6666004)(6506007)(186003)(26005)(558084003)(54906003)(6512007)(86362001)(66476007)(66946007)(66556008)(8936002)(8676002)(4326008)(5660300002)(38350700002)(38100700002)(6916009)(316002)(2906002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+/VRou7Bfkpkw0JKxB+RSPlmfHg0tCvatAvi76rW9PHkQGQlUiVhfQi2h79K?=
 =?us-ascii?Q?bJuw+eC4MLkNU/xgA0JV3OcfBUF3lCQHzE6io+ZkvQnY2v5f5TeugcaHPBv7?=
 =?us-ascii?Q?gxE1BE8VR6VJQWYi+sCFNalKrX1B9MoZrKyF99RFTGHEOVe/e9OuMfMFAixu?=
 =?us-ascii?Q?hzryWkZggyGWLFJFEXpreqotPf4ylF3oB704oj4Zf/E0C0NsCnVaMrhnNGkZ?=
 =?us-ascii?Q?Iii1gM6Dh9eF66PCnOoDCXUh3xsFJUB+qFv/RQb2QKZWEPQ6au5bcY4jlrdt?=
 =?us-ascii?Q?yJ22QG4LClXV3R85QjO3RvoP2AZoM9X03lG/8jRV52jnSpBtZFxNS+Ndm/3V?=
 =?us-ascii?Q?V3l2oxNC6Cg7Z0G6C0WOpq1aGC8lmLeG9gKOucB2ASR56/foOqwp1VkXukaw?=
 =?us-ascii?Q?0wyPJzmaOGDJJbLjtZQ7RyuvE4xEoo/iwBitTrzOZWtyZZBrudU7PZbEqupJ?=
 =?us-ascii?Q?PNn34rhTpsdQuMoS4u3Gj1WaYKG6yxe06Ep7NmPHAbma07K9do1om0Q4h+3Z?=
 =?us-ascii?Q?hcFsAuaLtl36soVZK37O518iwSgl0xKMjKn14sHwL27uhrDk/n+7JdalCGQ+?=
 =?us-ascii?Q?V03J54Q8xzvXCS97cZoSjPYpoji2iM+VfAsPkwJYRtzzwJmJ9Dwd+wLATaPp?=
 =?us-ascii?Q?e8jBf9ndJcLs05O8LGBxlmUmVWrJNib65YyQtATccHJY5YFyU7b6W9Mpldms?=
 =?us-ascii?Q?gU+m+eGRQppPoBsOZon5iBJFxVjPEhgCfXJ9+Z+z9J4iMNNjYVVPz4OnL3w9?=
 =?us-ascii?Q?lB4ag1oKsl4BoVmByKxIQWStZPAlo8Fx595qzgvpItupkPhWvT7D3Jc/C8k9?=
 =?us-ascii?Q?tbZ7eORXdWXbeHY1ASDc57oBhZwI0/F6ja+qZjEogfIOEdOB+41O13IOldqj?=
 =?us-ascii?Q?hiU3nGi6ky81rkAyvB3QNEcNA8hd9BHdDBDAUhIjf3gh043HOhSpSiFCog7x?=
 =?us-ascii?Q?+tx4hLUmhkcjwsfq3F377YIMBnCANOVQt+WlaS2Z0bYwtwfmF/TchJAAOVdy?=
 =?us-ascii?Q?XNhfLNuvSw/HZiyaRS8U2V20wij5yVg4IvLDnIW3t8A+ZT8uT7oNtgtFJ9Gm?=
 =?us-ascii?Q?KOhHTKdYOIF26R8caiqPAOxKR/+ZaTRDrWLGjLDbDDaHhN4S875Z482wC+AE?=
 =?us-ascii?Q?nOV7ZcUk6I/GQGC/jkqmueqrutyv096SsSh5rEAnK7iQ4D+rXgeRRgYsyTuC?=
 =?us-ascii?Q?d7I1WNmbDkZelGCEF+8Xeg10ygp2s4EzMf8pzCbPv1OJIn0CYs/CMpfdim1f?=
 =?us-ascii?Q?pZH2byBAwlSq0ATmfw2msYc4BIUn0LUo7xKp5Ra5RnnMcKen2eV52tCuQjip?=
 =?us-ascii?Q?/YLde9C3J72kec2py/zlfipPNh3z76QmKhl9oXlIrvL4QnwPiP48BYYeBD6+?=
 =?us-ascii?Q?/FJqx6oyckGaLqJOVJs3AqMh8lqv5ZaeVR8GPL7r5d/ynAJXV62Bn2tO9kVc?=
 =?us-ascii?Q?IyqRn7Xgpxmlp3HSh280BsZUosZvJXNBhP2KC2/duSxTEFVa4Z1H0dt8UKll?=
 =?us-ascii?Q?82xuxwJHJY7JC/nN4VLbVbpp6Lrur31pMCIAqthUgfmgUhzQjw9xAC5YDTST?=
 =?us-ascii?Q?fUg1BTKyccwVh3aZ+LDyysy9EAGdeRmcsPQopzi5gpMT94qxosfE7bBPcpyq?=
 =?us-ascii?Q?/PwmqkDWPAYe8pvfy/INDw/4AUI+fM6a9TJCP3qcZ5+BXXs3xrgB0Xl4JID2?=
 =?us-ascii?Q?XTL98w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af86c05-84b8-4be9-ad09-08d9fc0599f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 04:32:03.9470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sy93e8ueQM/wbOMW4C3vOugm5o/1iFsBSO0YtLlrjMtHJwdqnYtf67r/EgQDqbFeiwoqX5C5AXUMD4YXLtkRjb7cDjwA1tWkq9As1V12F7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5582
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=908
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020018
X-Proofpoint-GUID: VOjdDkAcUEer35rxe09qt8xB5sFh2_0V
X-Proofpoint-ORIG-GUID: VOjdDkAcUEer35rxe09qt8xB5sFh2_0V
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> in preparation to the SCSI EH rework here's a bunch of patches to the
> lpfc driver to make the conversion easier.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
