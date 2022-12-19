Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E327C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 19:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiLST6j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 14:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiLST6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 14:58:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112BB13F5D
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 11:58:35 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJIwoV2012204;
        Mon, 19 Dec 2022 19:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=nA3F9iwNuCS7MHUOWSZQ1G1Duiwr7z51lEZFUKMAMiY=;
 b=Lf/gvv9p/LCaTRq7W4wZBuSNrfgy+w3cAtXfdZLJwbTDyHCzPQw5DPvWgbTYcwIVHXVO
 FE734LQVrukpbzQQ7wy6HBg9ysjUPj6kI7BnfjQiGeqUtLIXVhNv/JFgi/6BxtI+b9RG
 +2OurXCieAgheSfXWXz7f4hLkR58o2C0k6eTkO2mSVqvUK2d46GUAKplhDhXVV11iHHp
 T+qcky0YjK8mUPx6t+6ON09UxPB/atWpap2/1y/l4ufayPLfK4ipBW5cSCiVXSA0WEAw
 nf8S7HbRNK+1nnynrLaoxhlZk6/EpURWXyUcdAQb2z0+1kH77dT5mc+47XRE2bwA5CXq 8g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tsuu5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:58:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJJm2uX027582;
        Mon, 19 Dec 2022 19:58:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4740bqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 19:58:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ivvk8PWCoo7gk9HfdsVbx3RH/i5+SUW2I9JPFtahFy5kki7bXajornau6u8ok5eGtAqFUz2y9mqr4hZw/JEuvvmBA3lkIwxFAPrpImaW5SPEUkMdC3zduHtXQvj6FYG6ihVTMz3ofwMSJcVyjPnCIJLnbpH42vyiFPr8LbrCFdhjtHKAhq7MzU3qz0Nbjz23cqsCLb8sw77gX9f4bTMM2KHqJ0sAV3TbFbMo8n8s+G8zUJ8rsRUBENS/Icx86CK23jAafQnfDxiBuw95h3cXfNlnGG8hep2S1yAKavpVjvxbYbLxvR/754GrnjqyUWib8D9kfVFiTbur0frp2MktKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nA3F9iwNuCS7MHUOWSZQ1G1Duiwr7z51lEZFUKMAMiY=;
 b=PfVps+ZDp9SDnrAboJTgpS5xcRwoiyRqIf/LkXgmA6nzw3FBwJ4mVlreQcx4Q/WDQ6/7BksDIhrqm+7/Jhg467FCzpQnhWBbNbKYQdP4nCxoFtg2Ozw7cnCca38qtfk5RGh0NYL3bjjCzCk99NyKVqBUVpnlvLcPKnzdgrG9HhN05zDzuV3/0RT0+xBL94C/ZzL1RrLPe4CjC+A95U+XcvFHBnLstLw3xQu4joYQvFLBFwsekm8KcrJjvcdY0v3hNVEwuq20kBfyq6G+Ja93sjvybc2gUoVJ+jhDGrtskqm5rkKtbt+q8HGUdOx49whna3xCnyklp5RscG78tJoL3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nA3F9iwNuCS7MHUOWSZQ1G1Duiwr7z51lEZFUKMAMiY=;
 b=PzkthQ1Z9xhKewIe+y1ppTRC3kinCRRqu9VRfKcaoem1OH++UhP26H59NktLA3hjSanigV2wXbpAfX1yvZI3RdyDWgWSFD+VV+looT2hCJnG1pwO5NcGU9Qh4Mafl5j5VgVJBVmKI1GSDxAXjs8NJvu96IWYcXR3T0T7LpQjMAM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA1PR10MB6661.namprd10.prod.outlook.com (2603:10b6:806:2b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 19:58:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 19:58:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     dinghui@sangfor.com.cn, haowenchao22@gmail.com, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 0/2] scsi: iscsi: host ipaddress UAF fixes
Date:   Mon, 19 Dec 2022 13:58:16 -0600
Message-Id: <20221219195818.8509-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0412.namprd03.prod.outlook.com
 (2603:10b6:610:11b::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA1PR10MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a28494d-ef86-4e8a-f057-08dae1fb611d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /VgXvbReV25ntCoCbLBNf5GNs5qNJ/eALKwyx/bxs86q894VhwkDdRn0R5hAXASoZoM7FxDGrupoAVD8wtE60C6XETTIikK9dsbocdxqKz/ieBZ589UrIl0nefHUWPkwnra3rBaJSuWP2ZFGmbVu5UOEIQQ5my4/Z3xGA6/cfpPgSEce2hFXgZL4pq3UoGCg/FmVxCO1mnusLr+irnoQ5/B3NjBKuKKVghXWteoEUf2bImnHZehuT7slF519b81UKU4A7QO65Adb6WV0TwUn/68lpatD84vQVlMPzy12XOk8NvOwqUlXVnz1XprWXJC1Gz/xq+LGMMRjBPdHGwUGCoMoDL13x6AbXhNmLKwjD/jWkkkuprL7pKpr4HJiXUzT4DLj4E6LX3VycNmzaA+DEqSrtwIfIEMCauRQi/rPJwzpifhV0gUg+DgW/5jUHl0zQCeunJsc3XN3P3ujSjfzs1QoNlsZrKkgoFOsCGaEo9jvZ+CgOo8LvdBDlYUZStuIXzFQEgbiyd1AgbIp1q2dCCGn2nc2tfdBSiJ5af6oWVqusqvQm3nmY0qsDISU5DDcWiCAK6YX7I/Dnsb4Od1Ii7hnE7ramFgZOVyzNq2Eb2f0pmj4KEvSjumNfOdp1z8O2IGMYc5s6jrPlZhO0Ip/mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(36756003)(8676002)(6512007)(26005)(186003)(66946007)(66476007)(2616005)(41300700001)(478600001)(1076003)(2906002)(86362001)(4744005)(5660300002)(8936002)(6486002)(83380400001)(66556008)(6666004)(316002)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dxVI9HAIafB5KKBzs+qV4WGSTW7XLM1bspuyKnN6OOjEvmkmwuHpSF8JcIdY?=
 =?us-ascii?Q?VPdFlBeIoIVdL/Bl2QRMXezSHsTsI0FT7SDyFjili9J6BrL5kMNrYAsRMuK0?=
 =?us-ascii?Q?uvdmiT5vS3en5B23GJSepEz6i5KIoTEMv0eYuZLt5MTMas2ZRU3bIdZ5kjok?=
 =?us-ascii?Q?MXsceAggvnMdW7hI/FhwyugwFijQ/uxy3phklzVrxFGnqT7hrxf/O+mFNQuF?=
 =?us-ascii?Q?nNJJgwf70b8IO7uaJjfBUdeb8XUCUABYTkLLavMaic9tnHRvSoVudq6WrB3k?=
 =?us-ascii?Q?BX3IVOLjzKMm/NSO98ibNXVj/mRLwiQvyDIPyrSetVkb3+K+dnwtkKK+yEfT?=
 =?us-ascii?Q?HOKTGbWJpGThnrhpopX79zM8cePWWSDwWhezWk55/cF9ynVNpPiuQcXX4dWq?=
 =?us-ascii?Q?pry7ZqFTDY7SksceYGXT7ZIvFrG+BbEe0nHU/cJVP+U22X9HB45gC6wyUl+0?=
 =?us-ascii?Q?4VpEM15XQgsLWcRgEyNMz0VCBgP1NuE5rL35k0Ox9ieNGiKQmlK/2RKCkblL?=
 =?us-ascii?Q?IdfanShOu/oM7p6LEqa8DoT8v3re5ofo88ypi6AeZ2giKhU60sxnKYC0piaY?=
 =?us-ascii?Q?hC4AVQqq14wOsLvhHNUGtfGpl1LzB0sMIYc0bzRkIwqmgI63a9BHvxoxwLyv?=
 =?us-ascii?Q?zRPUEMtP5Novwi+M5fK8wSLJ3JMQbjIOaS5oGsYWhgnBkLFjCsRxmc+yHrx7?=
 =?us-ascii?Q?uuEwRmOJuFLwdTh0Iw12CsXUUXhcO4V9QZ9DGj6AI6rHmgPsF9WztXwIPSX2?=
 =?us-ascii?Q?XV61WN1OKry/ZI3NAl1tcLzZz50mMJbweGcy4DKsbPwZI8KUAeJuq1ucN+N8?=
 =?us-ascii?Q?UHhUTSCaMBYt0n7GtzoVUdLcM8U/tWZQY8oKe9WlnpMXL3/a96fYxK49JS37?=
 =?us-ascii?Q?3ptZIh2GVShhOeLns7LXSJassJdGelw9UDIzTNgg1jM6SyNgO2siXqEVIqXI?=
 =?us-ascii?Q?r9nn37U/YU58aqG/oigkIKckqruEY4BLcjJz5wPCTlI+Bh5JNbUqjn64kkSr?=
 =?us-ascii?Q?1jjA2cA3AgZf94h6IZzZBP9oMcNmirMMy+EabQNg2yRuDiB9LbE3cuwKJNsd?=
 =?us-ascii?Q?vTZRNMYX6N+Re7F2qrXwlVGKmaNTtdk0x4x9AzVXCRc6tLHT0h2IFPXQutAp?=
 =?us-ascii?Q?7g77rgNLuxIdR7aYupZDmbsL5QiDt/dNFitTTg7LNPAC1jfUHtS8BeIZgl0B?=
 =?us-ascii?Q?ZxHBTGscYuKRMCX5H66gri7JyVmfF9jd7SICq08OJkU+mfj6f4KDD1dEImot?=
 =?us-ascii?Q?KbvN4sY9JWjhG4Q3N2xihsUPSDb8tbnz0ISOrl3SBbJRdFknl989YlaPHw5B?=
 =?us-ascii?Q?LnGrLA3OVcqrtV5qGzf67Gc9xcyvQPWY4ECJYazcU/rRxL9HH2U7YII6zJgo?=
 =?us-ascii?Q?YCog1X31u8ZO2f7egYRnGoj5nFDUdBP1QDcHWaV78BqiQYvpJyc+bct4yCsE?=
 =?us-ascii?Q?OxkXrQLqhHwDN7AOPqqK4i/uwYxsjUGJ0g3Jtj0oNeobbDoyUrqbtwpBcfbg?=
 =?us-ascii?Q?Fci8zBMGWxgrj+YVvqmsilxPeW9luf34X9OCIV2IxTIGfwoYM0+f/GUh5Abd?=
 =?us-ascii?Q?NUvvNYqV0YsdTYGnY8dDP28xus/yYRc6Nf+Wa5CnfipNAvkt0fMLQUCQhlnK?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a28494d-ef86-4e8a-f057-08dae1fb611d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 19:58:21.0145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TD3fSn8rBsC4QYxs0QsYMvixU/8pFkBw9DZKLp4khmQkF3gdpOp7Ez9FmWMro9ZlIo2fFpalXKRA9Kg+nHh9MP7asmBg0ubYlxdRKXY3XSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=906
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190177
X-Proofpoint-ORIG-GUID: l4YO--0eTXgpUZbce3r189G3fcb_ZTs4
X-Proofpoint-GUID: l4YO--0eTXgpUZbce3r189G3fcb_ZTs4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made apply over Martin's or Linus's trees. They
fix 2 use after free bugs caused by iscsi_tcp using the session's socket
to export the local IP address on the iscsi host to emulate the host's
local IP address.

Note that the naming is not great because the libiscsi session removal
and freeing functions are close to the iSCSI class's names. That will be
fixed in a separate patch for the 6.3 kernel because it was a pretty big
change fix up all the naming.


