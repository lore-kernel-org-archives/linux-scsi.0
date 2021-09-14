Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B72C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F1E61130
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbhINDqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61904 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239281AbhINDpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:42 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXvfZ008709;
        Tue, 14 Sep 2021 03:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=q/f5OufAmAs8A6ge9XASyRbq1Fu9+yQKlQCjficqEkQ=;
 b=NfJ9QwW8z3wS4l7HZIWVNZjDcUVeBMs7nWh/0+arpwloGkuNGfdp1m3dyNes3s+re2iG
 P8U6D4aOMt7oEhVn4j7rj/WhkNN6zW2Q+UVGYzRRQb/iOYU8nYel8Ge1MJGNdbCOhS2a
 +XflWyPxb5mLN+QOJnpqoMtIa0Y6gIcNVtLWfSaMcknHfqkXYRMXKEpG5uO1mnQ+tBnK
 rOI1FxNQ0NX4Oj/oSFz51rd7EUKGzCQzhwi2mfGByJNJmnCsWvsCPvqlDoL9ARkuFjDV
 tPJobPIv+TCj4WlplzuoMIb62TloMeWC6WZ39C6yluYAhiJof9vLZ6CCwCoJ2IZpXaQI /A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=q/f5OufAmAs8A6ge9XASyRbq1Fu9+yQKlQCjficqEkQ=;
 b=pAf/4nlXxytFpI0ObcPEOVghcwsGA87NCMKBuA/bwLbyITKfwg3xfjgrb7QPUO/W8EwY
 RVh0h1vkkDFX9tXfLjj5cmeeNwaekdJ1NNdAHf8gXbPVH5oBssGK6yPdGqcE5wd0YYNy
 P5YJEQXtYgiRyptuNJRy8Vl3Nl9l/3VxBn57LI1PcbaA+qqQtgpYFY/joE8xnbDRmPJU
 CUqz7O91wiqLy4Sn9vwSqamQXF4KV1tVpqELbzn/++FxQYK0tHnp1ExxS6/N/7rudPXh
 SxriI5woddH8Z1N/n08izyECmd8eKrZ1BiBQ+jXul5XQGJ437A2ChybjsNTqTDB3vV2a Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sd48w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f8hU097913;
        Tue, 14 Sep 2021 03:44:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3b0hjuesuf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY1aBvjMOTv2Fn7X/UkWJmqlrXfnQ1SXl1j+CuzRCs66gvOMQopu5XM+Q4Eqvce27DhDHHk+fVxkQ4wVochbTHWSIBwYSxg9M36QmNWBDYjjk6I1s7kApOoC014PEyvLLVbOTtiAmB5Fa21i4rmQ/+AVa/erNjr6mJfnTyducM3SFf3kfJ0MbSrmUs8WKi5G2M71E7kCa03mpKcbWXApyMkyvD8n2xwl2dqetZBFVU8pXxO5wBFJBftxjpjx5cxEn8G5S3U5zgVyhUwTqvjAN9l7tp/DZ+piYf9a3mqfrtFrIi97FTlt3iOvsiG48RZR+hBeDwe7Q7KC8utIeEX2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=q/f5OufAmAs8A6ge9XASyRbq1Fu9+yQKlQCjficqEkQ=;
 b=Ll3Y5f8sq/kuRqKcvfWhlFEib7vYXG1PkKj6IlaKWvZJYpGmI2yT8gkUWMTEjpv7gLHgca9zwJ1Iy6Jm5r6VpVr+axhmC/OvXNnAPmsNSqs4SoH99ai74bPHpHlKoXZ9aLadzGgCaYBHLlt6Apto+9id2oTe/897UKR/4rjCQWbUDluBlrydpwCYflIq0mMI6c29wWIJ1k/ujUA/ZaizYlhEUOnWKQ8gxrS8/E6I9ke7UmkUOI+q8omRbS8byfd9+bjoCT4c6O5WtzoWISmystmrdujEIoQeZs26pdnvkiqOLlA6oUA6Mf3rxiTsbbClLVNGP9ULsVJSjjQHhRQ3+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/f5OufAmAs8A6ge9XASyRbq1Fu9+yQKlQCjficqEkQ=;
 b=A3K8FOFMJyGLuTuV7Nwmg3mHG8I35fV8+JiOwnF4mrnwFzMAMflTTq+CQgyXKKEdJLkuQEtt818KDImtvtYVaSwwoNB7Yfa1EWnlPrQtc9uv7HMZDmTiZvTBuN+5Oz8bujQdQnNTSyWlop2PHWfgtNgk0ec7G0SQ+WAsgTMHypw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>, nathan@kernel.org
Subject: Re: [PATCH v2] lpfc: Fix compilation errors on kernels with no CONFIG_DEBUG_FS
Date:   Mon, 13 Sep 2021 23:43:52 -0400
Message-Id: <163159094723.20733.16111219383272123459.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210908050927.37275-1-jsmart2021@gmail.com>
References: <20210908050927.37275-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82b5368a-e107-4ed1-0329-08d97731ec0f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502507AC218957614F6EA6F8EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFMvMcs0aC3HErR3CUg07T7GA8hHUA2iJUR5GXYPh+qpqspgP5V8IP03Voh49yH4eaOzLYNuarbykOTVJUhOKHYgrXacs0PYnIDl5ZNyDYdRRBa5pJv+yZUTxDeRj54YQk7eFZPhRKUpTof4Hd027JdCC2XFrIc8RRbEJSkBreugA0fpTz1EXU2CCIRSB/XdiZg4KdSEEXZznSenrO+vPl9b0aStNMoxqYiQkri9W+toEDsu3+cpHZaxgLiVX2lngI3FT9jeUPP6QOyIxAAfIMoGDBm2D41yiK53R/Y0J2hJzbWXEPgn+saje3QDcqPT015kRFOQfo2hxo+2/vDDoijNwP4DYn5nNMgHUs3rlwfoiRh0xX28YTeBe1jHU5xEkT0tZP4aSrvqJrMdf418Bp9B4kVPQoVSWBq6Xn9MIU1MZQ+yRsFzo6r8UFu/CK+cLHwmFLzJxheb0IcNt47CLRfVugfKF6ldfcIV6rRCdiVm0fM/q0tDOk42jqT/t8gCJnhtGvPtx/57TzmJfqAk9w3JKlx/sfscCmYpElVHtFSOG4s5lnDzcqBwstx8c3PrtYS588ejYM48TJgP5qANpaKKvN7E2HdlHvFcat4+mEh6ZaSS0wRijMtrQWBgKpa3H+c9zt1tZ+0tgjblApQ1/dPRzVqx/gkFoE9KmXofeNeH/kvoeHeBQVLIZnvJRDY8VkHS0b3N2A5GbhgP0srALsTAYikGFcZLFpD7b8JRIVAXESyUSAu9kB4r0yeCUqaB6RKxdq2B7eNrx+74ZNAkHh+GdJKMwwuJQTfMO+ZjQWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(83380400001)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW5pQitGeEZJT2czQkdaTlJZaGJBdVV4V3IvVE5VTW9BS2oybitKSzVWR21R?=
 =?utf-8?B?elllMlFSMzFOdFcydVF6U0VBOU4zeGk3NUpOVlhSV2s3S05yNGFZRmVNcnN6?=
 =?utf-8?B?NitlZ2VKcnB0SEptNWZ2UkFLcmhDUk5IQkRObXZlakVRTE5pUXZsMUMzV3ZG?=
 =?utf-8?B?N2kwNEJMOXVPeHZKdUlLTjZ0ZWpxZUt0RFJmRGE0Wm43TVRiZGNXUnpiM0VB?=
 =?utf-8?B?TFczY3dBQTJpUlFmZktLSnU3MFFUVDladTd1Q1pnbmFuWkRCeEsvRGNjNHRP?=
 =?utf-8?B?NG5YNHp4VlpnVUZIN09wcjVQN1BhWWhHY3F2TDU4dGlaeTUrTTdRQWd4VjlF?=
 =?utf-8?B?aXRqUUxlTUVpdUEzdkQ5NWpJS1l0dFZyVWhvRTZQK2dnTGxaTnF2cWVDelQx?=
 =?utf-8?B?SUFjbDg0MFVmZG5FSW04cW55SFVQcUkvQmVEeitGWGN1TkRHTGZ5V3czQ1dK?=
 =?utf-8?B?Tm9wTlN5RkdlYnljS2RLV1BkSytnVmhzVHVqQ0pQODl1UXlpMmhEa0RNcnE5?=
 =?utf-8?B?YmlsRkJ3dnFwWlZUSm5yTkkyR2QvZTRrMEpDV1puZ3lyeXl6SnQ4RGQ4dkRR?=
 =?utf-8?B?NmNEU0JkdDg4UGZic3FIdFBPaFBOZDQwN1BFOTBCSHZHQzI5UjNLZUp0QmFM?=
 =?utf-8?B?OER2YnlNc0hXTkhZNjBENHh4MStEOGowQVhWZHUzTFhNN1dHcC9jYkpoQlBV?=
 =?utf-8?B?Z0YyVXlLcm1maWtjdXFPZnVxb3RFTVY3bTlWRlp0M0JqelBJUEo1M3RiVlRG?=
 =?utf-8?B?dWJFQlZqQTFmcE94bW5YQy84SEo2N3FRRUtBZys0Y0JvWnJNTkpxd3lveDho?=
 =?utf-8?B?ZnI5WlVyanNZRnFhNkw3VWw0cGJyd1d6NFpWZk1RS2dZeE1PYXZrYjA0YjZS?=
 =?utf-8?B?UnRBUjJsazJrT2d3OVh5R1dOMEFJQllEanZIT0YwdDBBajBVbU9hWjZ2eDhk?=
 =?utf-8?B?RE82OHlvUnpCeE42VXVqOHk1MFFlMTgvUCs1NElHNFlPOTh1dmp0eHlLRklX?=
 =?utf-8?B?OVFkN2RKOU91b2lNVCtmVjl5RkphNk1XZTdsSmlYTnhmZXNoT2hqUlhZVW84?=
 =?utf-8?B?YjcySHhqRzNyK3V3WUluVk05bFc3enpLNUc3NjJCU2FNZkxNS3VqekY3U3ht?=
 =?utf-8?B?LzR0M09MQ1FiUEVjTW5vYldhMHB2RzZtUlo2Y0t2MXpxK3JxbjVKQkZ0enIy?=
 =?utf-8?B?Ny96MTA5N0xnMXd5ZnNja3VvdFV6ZWVudnhrMVI2ZXhDYTIzNWZ5Y2dJbG9Z?=
 =?utf-8?B?ZFRHSlk4c3ErL1AvaURSOE43djh0cHk4ZFVkSTNwWmdjMWc0R3RqQmZodzNQ?=
 =?utf-8?B?N2E5WldmL0lKRTJFREFMUVEzRzZwamYwZzZmV0ZMZ0RiY1BIdFVrQ2ozTTY1?=
 =?utf-8?B?L2RFRWtTQ3FSdnA0SG5rRW1tK1B2R2I3ZllrbUgzZ0tmMTlpcWVRWGs3TUtL?=
 =?utf-8?B?ZmxBZEJITDlmMUlESXJ1VXhPUzVsVWFoekt6YVZuaytXb1kxMjhCbmYzRWRv?=
 =?utf-8?B?bnJKam9VazVxck5KZ2hrdVNaYW40ZklCYTl0TEhIRGdoT04rRDBOTXFrSmFG?=
 =?utf-8?B?dGs4UENSelQ1eVdRTkY3Y2JRSHZVd2JhRFNUV25ldXk3NFFTaDZjeVJiM1cr?=
 =?utf-8?B?ZHZGQ04zWUt6VDZhc0ZtY0Q0OXY3Ync5c25uK2lqNVptcGc2b0F1NlJFczBH?=
 =?utf-8?B?dTF6OHVhRFJubW5LWGhQMUg4Qk1DQWtXSWRORE85WGVoTWlNRm9hWGFyQWdO?=
 =?utf-8?Q?J0wDr51cskgwRSZl6KvcJxQ3MwftIvCf4NOdA3Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b5368a-e107-4ed1-0329-08d97731ec0f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:14.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/H9UCDrc8+s1DzssJeDfVOPI/bWMcDJmUjm3MDuVFUZynucVBUpHmn7SrnOx5tEuFq3WrmOU5D6kiXRB1llAWYGmez3Xd5S4tj9VKvBgzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: zH-1ES2LG1rNY3LkjeEEWYtfhBx5mils
X-Proofpoint-GUID: zH-1ES2LG1rNY3LkjeEEWYtfhBx5mils
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Sep 2021 22:09:27 -0700, James Smart wrote:

> The Kernel test robot flagged the following warning:
> ".../lpfc_init.c:7788:35: error: 'struct lpfc_sli4_hba' has no member
> named 'c_stat'"
> 
> Reviewing this issue highlighted that one of the recent patches caused
> the driver to no longer compile cleanly if CONFIG_DEBUG_FS is not set.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] lpfc: Fix compilation errors on kernels with no CONFIG_DEBUG_FS
      https://git.kernel.org/mkp/scsi/c/37e384095f20

-- 
Martin K. Petersen	Oracle Linux Engineering
