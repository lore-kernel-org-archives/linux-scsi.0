Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA57C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 14:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbiCNOs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 10:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiCNOsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 10:48:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A16941981
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 07:47:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22ECkfZN018588;
        Mon, 14 Mar 2022 14:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : cc :
 subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=tedjwHwOKlRivmjlrnVChMldujbkYE0DzC+CAUfqcYQ=;
 b=rjC5Qfv5HVj/5uOHmzZSCeWzMvJYomoIbxnllsrWHdXSFxtzTaqF0+0PeNRridv6fejL
 SDZIAYpcygCLBjV6VFhxpsVDM/E8/8CblbuZS0srQr6p4mVpRVwi/lW3scDBddAInsIS
 X++s50On94/PCggTv5VgiVrp2gOLICkNnlQuj2+i8fepZxxtfYwWPo5NhWVUII1+01rG
 do5ILkXja5V97kOI8AyxfpRoDEYoSrF6VXDIZ44rozZXZ8wrtgdVbx9+CLE+oRf0uK5F
 aXBOTckGfQhlAubOF08dXW3mhmVcTXIg4fkuGHAMjZcCWQ4j5Nlpt3NF6tCMUTgYW8Mv Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rgd99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 14:47:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22EEjGHW177794;
        Mon, 14 Mar 2022 14:47:13 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by userp3020.oracle.com with ESMTP id 3et656t6b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 14:47:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlCN1KeB81D2xXZ+BAxO3tKsorNPfQRIS7hAhDb6xbdOywB4CTffABIEIeQfMbNKYxv6TENTti8CHeqvh2YU+jGbg6qsMFNajkP2MeCmVzEnAvbfE95V6drEmCGpb/9TahlWbpn81c5GlGmpLCb0Ppx6AcYFJWFIpQ4SHJ4MsALunWzDdiGKHln+b7LwxJRs6ssI5ZkCqID6YGLr79rZ/QoPNXoBOrQVezfhumlEAEiCoVI0EBdtxwJIG0B4jFIQHKqAGR/HV2XfhQmbApol3Qbd6r1RY+Y+gLXkKFiO/VeDYde+zhCD9Z9RG8hk6urpO47F0E0Za5hnaElKBOCytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tedjwHwOKlRivmjlrnVChMldujbkYE0DzC+CAUfqcYQ=;
 b=Cf3/ShEH0SOkbncWXkRr+msI8Dlr+mbmW3wHIOvUGH8GtiMQiwYTMK8kfEyPmyqmKWEYUAqxyWKbfSHTc0OkPF3iG7xstgTDQ07fsBbKbYee7yWMzfux0NOMYAxq0SZSFGeX4NQnN+1J9UWX47gRMdL0fc68hr2nMAN5guDR2pGAkMWB2trYVYnrR87ZDZYPjUDOHpp7pOR1ZEEhDAnQ9s38E1F04rcRMrQ88CwEfm42VVPXWN2vXzake4zqdhe54MVdpCVJI4VXEjNeC1h7PSCgoO9pHufy/VibGyY0pSUtroJQZ7b+qpTJsX26tZGCfHAeDmbvaDlh184m+/y7LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tedjwHwOKlRivmjlrnVChMldujbkYE0DzC+CAUfqcYQ=;
 b=ykw6NWE83v7EuCvPebP0D88pRwQKGJ0J2taV76fWVN+Ty8/e2w6t+5/I4d7CfIqURLwfEidCoWjXdqtTKDnY/oExmZWpmaVSvcGh+Zn36PFaY4WLUCnaoXfDtbjBO5s2HrpUkExQFbFrJS35Mvhh3wbfQFKxZGkX1RjgOKs9WBY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5305.namprd10.prod.outlook.com
 (2603:10b6:610:d9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Mon, 14 Mar
 2022 14:47:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Mon, 14 Mar 2022
 14:47:10 +0000
Date:   Mon, 14 Mar 2022 17:47:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@qlogic.com
Subject: [bug report] [SCSI] bnx2i: Add bnx2i iSCSI driver.
Message-ID: <20220314144700.GA5867@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0189.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: babf3902-5deb-4118-608b-08da05c98520
X-MS-TrafficTypeDiagnostic: CH0PR10MB5305:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB530547F6BB210FC0C1B6BCF88E0F9@CH0PR10MB5305.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m17yvQHwWIpbzQyqeze/WhyC7w/IPLkFFdmVL3k7ElGuXqpUOnMKWtRB3LJ+fntcDXmycVRyiBu8N7bYmP5tA6OTvktEIb0xIPfIcjHwJFoMWWvpnJIfJYVRWLU6UA8VjZVG6aomsM3TSi7JJPBL64ar9pnMdaWTNdvaDb8O/+KANIIz3byQ4uMzSP3/gKN1lvdc5qix4+Gs+k6j5S40PDkOwMbtNbPo0EMAfiI76CydGr3V0C6e7m/lB2p2MaZvcE7DMp8dkNXy6uMPH06CevkQU2xTNkquvhZ3nib+ZSt4Huw3aLtg5R9bE2O3Nl6+XRNBbP3sWlCENXZL1RJmPohFR2taomklCWnHB9+OCiQjQ8/lGDCA05h3USC89qu+3PVrfRiirOIGNp5TzFxHqktqmbjd6XuU4MiWP7KFfD3Yj7nX4MCXv8j0AA+ZY3PJJZefN7JZz6EHxIZ2HFnOXjlPSkGKg4XSh4fwRyP80HJ51Jlseh7PN0Gi0m4ctTTxF9+0iSJw5jtNmKP5AW104YWP1Z2GhFxQsq5F7XvyBCP+iFkNJJhbnA8muT1KzhrdkB6pnhm7O6gjLUifZkA+V8cRZnJ7N6XksP+rSuObTKMjHG5DSvrQ0BXeCutn4VAAdZVlFap0moN/JmSckv0cJSYd0ewlvKya5lm9mW4yKirFPao9xQcRaASUTU03JGZ5LArcijX25UO2jGAZF5xfbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(186003)(109986005)(33716001)(6512007)(86362001)(6666004)(2906002)(6506007)(52116002)(9686003)(38350700002)(6486002)(38100700002)(1076003)(508600001)(66946007)(4326008)(8676002)(66476007)(66556008)(5660300002)(44832011)(8936002)(33656002)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?plq+/i2r4cZP87wSgsViQfRMMW1GkENumNMzIyutMfAGVcsyzTCPKeSWmVvu?=
 =?us-ascii?Q?esdEp42Rx6SfQvgppZZA7IjJK+VojVmxVoTopKFSI9ka3YFA7X1AejfjWAu0?=
 =?us-ascii?Q?1P7NbgtyevD8468isxKL5hYPTNC6PZC+mIrTjhRifavvADUn0mlgVCaWOmE/?=
 =?us-ascii?Q?i58eGdIn2MBnPPTpPs+ZoUK2Kzw6BUqDHlIgxMpB197vV/Wfy4dyD/ax815G?=
 =?us-ascii?Q?Jml30YO/IuuFvoiNEypD/jv2pLUIUTLYqmGdxqbVcQk4gJsF6Z/MsybKteln?=
 =?us-ascii?Q?HmOwBU6gGiKptbN81q+Qlm8qdUNcWO/ZHQT0oqmHXKMDCz3f5THT20gIVqOM?=
 =?us-ascii?Q?CokATMtz/isXcuHwBGyv4Ppdytbjhvit6HUvl+vfmO4aL2DTz7eM/U3bpaZW?=
 =?us-ascii?Q?ZACIT9rk0FhZTicPsclOpEkb33GIFJjsdem77z92hMcAkwp0WH6fy89ep/CW?=
 =?us-ascii?Q?br/yAi9ohaB6rXtFh16ZYiUhzKt+CitCirala7BjvNzpfCVi44lSg/NmXT2k?=
 =?us-ascii?Q?/lsYynXuZbba/Vvb09wLLbqy1nnYHb7PvwN/KFwt2RO1SuDbhK0AtFIPZupa?=
 =?us-ascii?Q?LmqHpN048/eCs8Xja3vuY7+gv3KEPb/KsGa3Ax1BUyXB02d3MQxVhUxkTW3e?=
 =?us-ascii?Q?5dIvx2AqCSVpLihsD4MXFxVJf5nmRkeL5lR/d5iSO4j3WQawDHCmvouNxWxF?=
 =?us-ascii?Q?ukWU8DLnYdAUQHJKcOSFuxrRpeJn5KczP9OfYYkWvKlEkdNNjg5VAf0udxFn?=
 =?us-ascii?Q?rvsVqxjgeE/CnWBrhFWQ3Z3N9k9qfCjvr8kp1jjMf4rDf373AxO3f/aqVHT7?=
 =?us-ascii?Q?9Ws9HtqwfnjevXE2Pdm4s52EzMeZYb+XzQ6uy/7NdbflqTgMbrfzkl7ei0dH?=
 =?us-ascii?Q?kYUcgoC/d+rw1qptXk6hyoRk32ByiLJXspPVmlkjUAXeAufIxZKCiWnCw1ej?=
 =?us-ascii?Q?9BaFGdSjB7nDiMHMvHw9iDeQ/yuKs/ZnHfWGO9P+W5ufdR4idLDAk79V5pav?=
 =?us-ascii?Q?7TTG9nVFOcVI0lPfsmBG8dpIo/FcT66l1QM7AyYQqGTh1Avv7aEzgz3JEXvb?=
 =?us-ascii?Q?FaTTGwOZEsr0GM/Q37eCAvcieioY98Vm4rRDjkmPp5E/Nka9J+HYB/hJmvGP?=
 =?us-ascii?Q?To7rOPhJ+QLa8iy08QYGyA8eZyEJ72PD7xCL+SxejoKAJIy8rGK0LGkXP2VI?=
 =?us-ascii?Q?cpAZw+hWFsRcqsE5oAbto6oZNRshfLHC7t0xCGCbhlsi1KR5Cj2n9f3DBG7W?=
 =?us-ascii?Q?rkZmAdsQvgf7OTlQaQVQASIyFlzua0ZEAWPzzF0BKsBla7Izd0zTQFDvzabr?=
 =?us-ascii?Q?SQJK0JJUBlz397KO3QyeAjMid90nzo7d1t1gdNtDNsnYVOHiP7y/UZm+xOKc?=
 =?us-ascii?Q?whrxqvIdwNtqIqYY8rkoAE725c1HrYuIadlRTP/kYRhDajZa7QxObREV7Y8D?=
 =?us-ascii?Q?//kEyC9/uEFsyOntKNJOZCEITCbIzCXp+DbcFrsS2OYsOizb8KxWZA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: babf3902-5deb-4118-608b-08da05c98520
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 14:47:10.7653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ps+CS9Y+5LWv/+VZpKhkjG6YkfIrpR+lnzvcUPf+pRDEs/b/idw5pUqkRMrMmL/LbXf230kXrKfSXQZ7urV8DhTnTOo+914t5vMNtTMPeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10285 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=918
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140093
X-Proofpoint-ORIG-GUID: a5K5uGv_YD4jMBrLp5zHtjNmsencCRp4
X-Proofpoint-GUID: a5K5uGv_YD4jMBrLp5zHtjNmsencCRp4
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello QLogic SCSI devs,

The patch cf4e6363859d: "[SCSI] bnx2i: Add bnx2i iSCSI driver." from
Jun 8, 2009, leads to the following Smatch static checker warning:

	drivers/scsi/bnx2i/bnx2i_hwi.c:2372 bnx2i_process_iscsi_error()
	error: out of bound bit 'iscsi_err->completion_status' '0,2,5-6,11-29,31-43,64-66,80,128' to 'test_and_set_bit()' '64 bits'

drivers/scsi/bnx2i/bnx2i_hwi.c
    2204 static void bnx2i_process_iscsi_error(struct bnx2i_hba *hba,
    2205                                       struct iscsi_kcqe *iscsi_err)
    2206 {
    2207         struct bnx2i_conn *bnx2i_conn;
    2208         u32 iscsi_cid;
    2209         const char *additional_notice = "";
    2210         const char *message;
    2211         int need_recovery;
    2212         u64 err_mask64;
    2213 
    2214         iscsi_cid = iscsi_err->iscsi_conn_id;
    2215         bnx2i_conn = bnx2i_get_conn_from_id(hba, iscsi_cid);
    2216         if (!bnx2i_conn) {
    2217                 printk(KERN_ALERT "bnx2i - cid 0x%x not valid\n", iscsi_cid);
    2218                 return;
    2219         }
    2220 
    2221         err_mask64 = (0x1ULL << iscsi_err->completion_status);

iscsi_err->completion_status is something like:

#define ISCSI_KCQE_COMPLETION_STATUS_ISCSI_NOT_SUPPORTED                (0x50)
#define ISCSI_KCQE_COMPLETION_STATUS_CID_BUSY                           (0x80)

1ULL << 0x50 will overflow.

    2222 
    2223         if (err_mask64 & iscsi_error_mask) {
    2224                 need_recovery = 0;
    2225                 message = "iscsi_warning";
    2226         } else {
    2227                 need_recovery = 1;
    2228                 message = "iscsi_error";
    2229         }
    2230 
    2231         switch (iscsi_err->completion_status) {
    2232         case ISCSI_KCQE_COMPLETION_STATUS_HDR_DIG_ERR:
    2233                 additional_notice = "hdr digest err";
    2234                 break;
    2235         case ISCSI_KCQE_COMPLETION_STATUS_DATA_DIG_ERR:
    2236                 additional_notice = "data digest err";
    2237                 break;
    2238         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_OPCODE:
    2239                 additional_notice = "wrong opcode rcvd";
    2240                 break;
    2241         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_AHS_LEN:
    2242                 additional_notice = "AHS len > 0 rcvd";
    2243                 break;
    2244         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_ITT:
    2245                 additional_notice = "invalid ITT rcvd";
    2246                 break;
    2247         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_STATSN:
    2248                 additional_notice = "wrong StatSN rcvd";
    2249                 break;
    2250         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_EXP_DATASN:
    2251                 additional_notice = "wrong DataSN rcvd";
    2252                 break;
    2253         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_PEND_R2T:
    2254                 additional_notice = "pend R2T violation";
    2255                 break;
    2256         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_0:
    2257                 additional_notice = "ERL0, UO";
    2258                 break;
    2259         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_1:
    2260                 additional_notice = "ERL0, U1";
    2261                 break;
    2262         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_2:
    2263                 additional_notice = "ERL0, U2";
    2264                 break;
    2265         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_3:
    2266                 additional_notice = "ERL0, U3";
    2267                 break;
    2268         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_4:
    2269                 additional_notice = "ERL0, U4";
    2270                 break;
    2271         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_5:
    2272                 additional_notice = "ERL0, U5";
    2273                 break;
    2274         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_O_U_6:
    2275                 additional_notice = "ERL0, U6";
    2276                 break;
    2277         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_REMAIN_RCV_LEN:
    2278                 additional_notice = "invalid resi len";
    2279                 break;
    2280         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_MAX_RCV_PDU_LEN:
    2281                 additional_notice = "MRDSL violation";
    2282                 break;
    2283         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_F_BIT_ZERO:
    2284                 additional_notice = "F-bit not set";
    2285                 break;
    2286         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_TTT_NOT_RSRV:
    2287                 additional_notice = "invalid TTT";
    2288                 break;
    2289         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DATASN:
    2290                 additional_notice = "invalid DataSN";
    2291                 break;
    2292         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_REMAIN_BURST_LEN:
    2293                 additional_notice = "burst len violation";
    2294                 break;
    2295         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_BUFFER_OFF:
    2296                 additional_notice = "buf offset violation";
    2297                 break;
    2298         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_LUN:
    2299                 additional_notice = "invalid LUN field";
    2300                 break;
    2301         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_R2TSN:
    2302                 additional_notice = "invalid R2TSN field";
    2303                 break;
    2304 #define BNX2I_ERR_DESIRED_DATA_TRNS_LEN_0         \
    2305         ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DESIRED_DATA_TRNS_LEN_0
    2306         case BNX2I_ERR_DESIRED_DATA_TRNS_LEN_0:
    2307                 additional_notice = "invalid cmd len1";
    2308                 break;
    2309 #define BNX2I_ERR_DESIRED_DATA_TRNS_LEN_1         \
    2310         ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DESIRED_DATA_TRNS_LEN_1
    2311         case BNX2I_ERR_DESIRED_DATA_TRNS_LEN_1:
    2312                 additional_notice = "invalid cmd len2";
    2313                 break;
    2314         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_PEND_R2T_EXCEED:
    2315                 additional_notice = "pend r2t exceeds MaxOutstandingR2T value";
    2316                 break;
    2317         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_TTT_IS_RSRV:
    2318                 additional_notice = "TTT is rsvd";
    2319                 break;
    2320         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_MAX_BURST_LEN:
    2321                 additional_notice = "MBL violation";
    2322                 break;
    2323 #define BNX2I_ERR_DATA_SEG_LEN_NOT_ZERO         \
    2324         ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_DATA_SEG_LEN_NOT_ZERO
    2325         case BNX2I_ERR_DATA_SEG_LEN_NOT_ZERO:
    2326                 additional_notice = "data seg len != 0";
    2327                 break;
    2328         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_REJECT_PDU_LEN:
    2329                 additional_notice = "reject pdu len error";
    2330                 break;
    2331         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_ASYNC_PDU_LEN:
    2332                 additional_notice = "async pdu len error";
    2333                 break;
    2334         case ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_NOPIN_PDU_LEN:
    2335                 additional_notice = "nopin pdu len error";
    2336                 break;
    2337 #define BNX2_ERR_PEND_R2T_IN_CLEANUP                        \
    2338         ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_PEND_R2T_IN_CLEANUP
    2339         case BNX2_ERR_PEND_R2T_IN_CLEANUP:
    2340                 additional_notice = "pend r2t in cleanup";
    2341                 break;
    2342 
    2343         case ISCI_KCQE_COMPLETION_STATUS_TCP_ERROR_IP_FRAGMENT:
    2344                 additional_notice = "IP fragments rcvd";
    2345                 break;
    2346         case ISCI_KCQE_COMPLETION_STATUS_TCP_ERROR_IP_OPTIONS:
    2347                 additional_notice = "IP options error";
    2348                 break;
    2349         case ISCI_KCQE_COMPLETION_STATUS_TCP_ERROR_URGENT_FLAG:
    2350                 additional_notice = "urgent flag error";
    2351                 break;
    2352         default:
    2353                 printk(KERN_ALERT "iscsi_err - unknown err %x\n",
    2354                                   iscsi_err->completion_status);
    2355         }
    2356 
    2357         if (need_recovery) {
    2358                 iscsi_conn_printk(KERN_ALERT,
    2359                                   bnx2i_conn->cls_conn->dd_data,
    2360                                   "bnx2i: %s - %s\n",
    2361                                   message, additional_notice);
    2362 
    2363                 iscsi_conn_printk(KERN_ALERT,
    2364                                   bnx2i_conn->cls_conn->dd_data,
    2365                                   "conn_err - hostno %d conn %p, "
    2366                                   "iscsi_cid %x cid %x\n",
    2367                                   bnx2i_conn->hba->shost->host_no,
    2368                                   bnx2i_conn, bnx2i_conn->ep->ep_iscsi_cid,
    2369                                   bnx2i_conn->ep->ep_cid);
    2370                 bnx2i_recovery_que_add_conn(bnx2i_conn->hba, bnx2i_conn);
    2371         } else
--> 2372                 if (!test_and_set_bit(iscsi_err->completion_status,
    2373                                       (void *) &bnx2i_conn->violation_notified))

This test_and_set_bit() will overflow if ->completion_status is more
than 0x3f.

    2374                         iscsi_conn_printk(KERN_ALERT,
    2375                                           bnx2i_conn->cls_conn->dd_data,
    2376                                           "bnx2i: %s - %s\n",
    2377                                           message, additional_notice);
    2378 }

regards,
dan carpenter
