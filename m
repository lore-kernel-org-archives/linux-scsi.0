Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82955C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C38461D53
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhF2ENH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50090 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231952AbhF2ENC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:13:02 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T47KNs022123;
        Tue, 29 Jun 2021 04:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7d8nv23GL7Q/b1H+xRSHso6PotzzeTMXQfcqdkjIclE=;
 b=glucDkvFljktJ0J7TJBTQmoOBj2o6sLFDZR4Tyqex+6f8HNDgy4k1suhXiczS0Dj+Vd2
 tweVJaaJbq3wC3S2sGuJwCiLLdvfvwh5bxkXPv/5hBvDT811AN+C+8rENapbh2OVAq8J
 pDd6cNz1j5EQ6itsBznjFrcmHGct+KFBfUNhB/O5M85kFg3rg9Dh9AsX1nkZFuSYPEGf
 EuBoF9IlMGAGwiLjjrfdZOjTW3ID1n3Pk6CcFTY+4NELUzRiC2+fhtLAl05IeQjb428G
 BaFFhQREp+tughxgkEPgeQDdctlrQTZZP90CVZCuhtW4nby2AaRoB/iIPj1WFk4WesAt 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f1hcjsd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49rjT052345;
        Tue, 29 Jun 2021 04:10:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 39ee0tv4n0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRM5aekENdlSnuxmJazIjhY/WfgBPpFzFOccjyvrjAPnTV034H4IQd6QLU9zaZ3lZBF93UgkNyNJFuZehkE3AnvjNUi73etb79vYQMmWFn1tHQ423m7fx55GwJ2mIt/jS+DoJ3Tg4AQ8LDBzPJUn+OPAJuoxrtg9AXhoRuFVtmT6YdkqFCDPPNeLPfneLKlxZJM22mPPR9cyrysZKYZZpJ1jJcRT57XvYL8Kw+C4T68mal8peA/RCThHC1t6ECgVfEKZ3YG2vLQFdalf3Lw0fv34DFSscbIcDq1VmrbOZNbprgewttAEt6r03ZYe03hg2wFC99eDEdSq+TGCU07Cjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7d8nv23GL7Q/b1H+xRSHso6PotzzeTMXQfcqdkjIclE=;
 b=KL9Knn3ZWAkXfhlOlfWiCJamsiXmaGLDW2HMxUwIOujw1okhJMTJoyRuOMgMtPQwVXkFxjBDIH1HloohraPi1M/1OqvkjzM+1GuUT+Bzrp4FIIfEbcUhs3j4ipbZ0tf1wGitZtwEBUfdDdf2CigMYDK3FQotvxCHNZ5lRMFyM74A/fzqJzB3ngxbUuJJAR+wNH3yYPFMLrv1XB4vSSnxdnerQRN8wm49Ka3Gh67FxKYaGb6EV96R4lfu6Tk3/dZ7n0Blk6qcS/XTE2AUfXq9JtqtGKdILA675vsp9Aph3rUP/f2wWqwJwPy1ADwFcDlhgcw0CHf8SKm4jJjANIU32Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7d8nv23GL7Q/b1H+xRSHso6PotzzeTMXQfcqdkjIclE=;
 b=EcJei+1JHQFU28CsroVn4VKkiP73/HHExuQOPnfB2AU+3krRsJnUsVbnT2SMHyFDHV2sZ4zehbqPNiHgb5OFhau0WZ/qBMdoAye4VdEmuk2iabzKGqCx3KWLZnklOI2VVgE3seIMK+3wfWuZpOMirDqUlP6N6I0Po7YP2GUBUP0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 04:10:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        ram.vegesna@broadcom.com, dan.carpenter@oracle.com
Subject: Re: [PATCH] elx: libefc_sli: fix anding with zero bit value
Date:   Tue, 29 Jun 2021 00:10:09 -0400
Message-Id: <162493961193.16549.3013155723842647370.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619155641.19942-1-jsmart2021@gmail.com>
References: <20210619155641.19942-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9a284ff-19b6-446a-3c19-08d93ab3d13f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB541716D63A8BDA47599953AD8E029@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MFW1PkJ0lUKjvAPXMYsmX11x8HV4eqlrqq0YHJZQV8pJaqiOb0Hlx3A4A/w/lQztCSQguvqRGlKVq5U+4s6ooY/hsYi3T5zQDxyBSWZPzlhhN4EmjgacUBG2ZXisFXmqmXi5lVNZDbXFsink3GdXdFAWcRZd3Ci5djMuxvLTcF7l4BOLZJpHfMcFfcHSNSCAl2WyeFaiS8fwlQ0iNcoCzxI5kZcq9kf2v7cznXnxLPd3IgBNgdSpavf7PMMS2p01Pq2lW0xPAb31J20whAHajogr2HBnubIdUpvQUcTiTKY62wByYzilB9mCA+DxTvRL0UCI5cdm3VNtAnXFV6hMAnwCxp/+Y1h7TknvWqVjuk9l69Ah4X3RmUEG6e5CZc/1Xp5HfTH6hnjEtdZB+BKcwo7FnLV9EyEPbbnMEZK130+M47Hm6Edz7+qe1JzfTqEfRjfBYeaP/u3PomPz949nCtfkDip/UuMmvhHdR0P4sdd8lvL7mYUy5SSLgFpAXumjt/jINHpF2lLRrd3wyh3GxrLgWffMTJZN19nNcm07Pio7/oPMpUDuPQBSaNnliEemCaTA7qAXC5bhqRthee2AFtCE8KV2sYyTbaO/YEz4+fjOKkvY70vGfSPEjNqxGeDxl7SrmVaNSnLgvi5+/5t2W8rvv94W1SVJUxEi9U4weWUeMJOcQrnSE67VBONrPwcRDD1GbZjmh//8NGO7IghcCceD1asDbxqxUZy7avYWU9BkuLvmkF5R+ZXN1zB74GduFY4cDuNAqoZtoniLmyKIODpwOulXJmWrzUsmmpJ+7Y0xiAkQg3Ir2Q3W2wNmYjzW2QDmSkUMa+HheEJd2Cy6Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(966005)(103116003)(36756003)(6916009)(478600001)(6486002)(7696005)(107886003)(8936002)(52116002)(8676002)(4744005)(66476007)(66556008)(316002)(66946007)(26005)(186003)(86362001)(16526019)(6666004)(956004)(38100700002)(2906002)(2616005)(38350700002)(54906003)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UE1FNXByVXF2YlM0Vlc0S1Y0czNGbXRMbUtRQmc2OFZleUpvZGoybTBISFJh?=
 =?utf-8?B?SFc2UjhOcHMrYndod3ROLzc4aENTMWYxTjluWnBqQlg4cTRZQ2RFVERiZ2tZ?=
 =?utf-8?B?VlFrYXN4WG90S1Q0Y2tpZjdvNlVFUFZZR1pMbVRxdlVKWEZtdFBXN0hwT1hE?=
 =?utf-8?B?OG9hQ2V6WGFOK2dmWXZ1b2RZTHNSZHZoeG5UU2xBdE5Ka1NXZDdZbk5HTG1q?=
 =?utf-8?B?YmJZdkRnY2pLaUdSNzV5Z2NsUm1GM1djNHVtL1lBMzdnRVBjUm9VcWJQMVEz?=
 =?utf-8?B?c1pjR3dhem9aeHNjYlNzcDdPWW9DVlZJaS9BVkJmMklXT1JNLzhRR0c2cDZw?=
 =?utf-8?B?Q2dZYlpYcDVOcWZwTWJMN3p1SG9MSmY1bEdVT3g0c2hDWUxoaVFNaENHZHBh?=
 =?utf-8?B?eFBib1JHeFZMaUcxN3VxdCt4bE1rMFZCUXBINzlJOXVGNm50L2xtN001cjBD?=
 =?utf-8?B?aFU5YXMvRzVTQllkWDQ0VHFCaGV0UTlDR25UNXVTTXBHQUVhV1IxaUhFLzFp?=
 =?utf-8?B?UXFReG9wbjl1bk1QSWEzZkpsZUNXSUMzYklvMjdDVVRXUGNBRU5xd0VVOEp4?=
 =?utf-8?B?ZXpVNzRUdTNsaEFoN2xtZGVDdTlYTTFFWWNORHVZNVR0MXpPT3FsdU5KZ0Fr?=
 =?utf-8?B?Z3JFZURXMXNSak9wV2tBbUVpUXE5TVFkSmxrL3NEOSs4cUpVbk1IVDRRT0Nn?=
 =?utf-8?B?ZDJSUUZtMklUN0RVTGlEcVMwbHRQT3l5dStFUCtEZ3ZqdHBhZy9UNDJqTEYr?=
 =?utf-8?B?UHVORDhkTVFxNEJicWo2VlBpUThLUWlaT2llMGJFd1dkQnZEV1NSMk9CRnBS?=
 =?utf-8?B?TFVWb3FUL0EreGZBM3k1eWQvK0pHeE91WnM5TVc3YzZGNXBZenBVTWV5L2xS?=
 =?utf-8?B?ZTRROXJyaTkwNXZWZDN6MHJ2cWJocXhyZkRLOUt5VmJCYXFrd09lcnVkYmo2?=
 =?utf-8?B?ZmZyUWxQY2FSZzE5YVFVVXRzSkp4eDR0SFVBaGFlV2hnLzBWREU3OWdDQVVB?=
 =?utf-8?B?WXZhQUs2QzBTOEp5Y2plUnhGYUdGenc3WmpIYmh6cjlSV2xHWVJFbU5KM3ZQ?=
 =?utf-8?B?MXp2RklxQ3lwaUVSZm9tcXlHbVJxMk1vNHdqekVMbGFybEZzSGVMUSt2aHRW?=
 =?utf-8?B?Tzkwa0VPeUpUYTVnNWk4emtSVE5MR2JrN1hVM1Q0OEMvYVNSejdqN3ZxQk9Z?=
 =?utf-8?B?c1U5OUd6aGV1cU90RGxjN3ZZRDRQN2hQWEVDcUQ5eGxJaGhWZ0xCNkJ6alpY?=
 =?utf-8?B?d1Y3YWV5V1lDWXlpREdjTXdidTBLUlowektuWDRaQ0Jhbit2QUFaQTlLeXhs?=
 =?utf-8?B?TXQzNHhZenNRNUUxRXlmS3lEUlU2WjFuRXh5bElLRkpMemlaNmZScER0RFRP?=
 =?utf-8?B?WWFibENrNWpFcFdrQXRUc3hOOUVEcDVTNEI3blowTVBCcjF0MkpObXZacGho?=
 =?utf-8?B?ZzhQM3pWcEVreEh1ZXdVekpRNGxxdnRHVzlNZ2xxTzdKa3Qvb24zc25wMjZi?=
 =?utf-8?B?Y1ZGUzBlTUNFU3pJSzFGNXE1YkFKaUg5VnZYWisvQWVOUHhWS0FUOHFnMUFh?=
 =?utf-8?B?WWZiZzJsM1ZONXI2SmczWHNaam1IdDM0Z0xwVEZybTBETS9MUVZFNjJ3aktt?=
 =?utf-8?B?RUF0V0Q2SWlYZmdjTThUVVB4aTcxYS9yQkpjSGUzUmJGbndPY1Z1M2I0OWky?=
 =?utf-8?B?NWMvOHRsR3RMeFZHa2FsOTgvY2pkS0pLdmtVcktPTGdheHpDZW5IWDdpM0pO?=
 =?utf-8?Q?iMQgxu4VMsqysJAqfMRxjKMF4AzACid0sWox0MG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a284ff-19b6-446a-3c19-08d93ab3d13f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:23.5935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLAGSEGxYxNvuP1WAYJo5Hk7iC/o4vbDS31hEUA8ClKohwFhpW2zDhHRcT5TVhlQTzHRhBJ2VSyZSAizjAEHaEyi369v1bYKiw1JrFMi+Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=861 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-ORIG-GUID: -cvLz0Exdb-zZOVhLWlZcYM76ZkglyuB
X-Proofpoint-GUID: -cvLz0Exdb-zZOVhLWlZcYM76ZkglyuB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 19 Jun 2021 08:56:41 -0700, James Smart wrote:

> flags value is being set to constant and'd 0 which always results in 0
> 
> Remove the assignment line.

Applied to 5.14/scsi-queue, thanks!

[1/1] elx: libefc_sli: fix anding with zero bit value
      https://git.kernel.org/mkp/scsi/c/f6060eb13447

-- 
Martin K. Petersen	Oracle Linux Engineering
