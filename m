Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA38C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 21:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357427AbiASVfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:35:08 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22030 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357428AbiASVfG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jan 2022 16:35:06 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JJVgOE032608;
        Wed, 19 Jan 2022 21:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wp/IbRaoI3YVZkY+zCBB6FEIB6Toc8fBtq/YsinBR60=;
 b=sswOOnigW9VeLmE7KdF+yAwt+qrI6USbNd4pGc7hCN5nvB83Aap7KH5Ap/7ZJ3ADSK4I
 4jDpyxT8mFdQVnrmpsOOnTvkiK79tqiBGljU2eWIvUGVwU/1u44rrrtDFy5ZqU9zqd/l
 EeKehtZXYxGev2VOiqTfPoKbx7C1UtqQCB1S1Mj+hTCI2gjCK3BeiKbnFnqOkYTc9mLp
 BxzMJqUgBqTVzFgDtIgREiuu2ZErMWWYOcjpPTf1SjdLyT+6jml2gZSZ6nNj7KKq1kL9
 e9yCTdGwpJBeFShOKIHhFfVmEgmCBQbhL5mG9v3luiNSUMUFAV9aQaSjsCvM38SQZfC0 Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q6hbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 21:34:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JLKRJe164121;
        Wed, 19 Jan 2022 21:34:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 3dkp36k4b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 21:34:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0JhX12YuxRdrOBhW5JetWhpem85lfiJnJ/w/wZ86ErAaZaNFYdYCVPopF3ANmOBURjSDCBc0VtKTnDBVHuVvbDRepEMQ1BsABnD8hLMdw1RNTDjYIzDh6JcWHa1jZHKjKkjPDdAkNfk4Ar2CBYATPn3SRqq81IfdDzN3kl4FC++DAddIhFmWr23sl1rvq9O2UjciHZnYLwtGUmtXZhqHY9Iq0ODoZNhdpadPaOBhl+BSxnC13ufWhEmJsOhhc3oiZRvCRlmVhXNXGhsAEFYQqfMO/H7M38iFcWAQvQej47sRz6R7nzdyGUNkHMey4qumcLqt89m23ib11lR5wYSQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wp/IbRaoI3YVZkY+zCBB6FEIB6Toc8fBtq/YsinBR60=;
 b=bX4711uQDN7lpmjNs2RycIPNGPkSRhM8tl5FeFoA9KYmH6V71Gf2zPITHYAQqwWlI0IuKVIGxg5zTAI78IRADd/Vbah3NhMQoziSNYC6j+GeDN+cYUsuV4JbTGVo5c1wJHIVdf8ew/3HYBPQtewgnRM1zC2qxK6ootrgg46YVkNScWSfvkwcq4mwhCrjJW2gnNzLXK6S967agvXfFXTsu7z7pKckCvWYPzl8msqOSxadBBgbeh/ivhK22FYsj8USHNx2OUZDIz5507IZ155thanFfPtAmDQEdm9vvbhO18eho6+1EGSHTlkIOidVfi8Z8JiJkgJZA98AGRsSwuOA6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wp/IbRaoI3YVZkY+zCBB6FEIB6Toc8fBtq/YsinBR60=;
 b=lANp87kXh6ffbFdafcnb+OpGF98nV0cHlIQiB3Xr7E9EK+XCLmanTEuszyuVXf98UJoezsNVkrwMYyh5aARX6pAhSLAFIoVo9sloaBULJ71mMGgibsTqF3H/y1KGUXjLB2AACLpZWcz1efY+kX99468KMH0gaqHVGJemFPB7AIA=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BN6PR1001MB2322.namprd10.prod.outlook.com (2603:10b6:405:30::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 19 Jan
 2022 21:34:55 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%7]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 21:34:55 +0000
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [Bug 215353] VMWare LVM partitions not recognized, sees base
 disk, fails to Boot
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yqfjtv5.fsf@ca-mkp.ca.oracle.com>
References: <bug-215353-11613@https.bugzilla.kernel.org/>
        <bug-215353-11613-RqfRS2EOOE@https.bugzilla.kernel.org/>
Date:   Wed, 19 Jan 2022 16:34:52 -0500
In-Reply-To: <bug-215353-11613-RqfRS2EOOE@https.bugzilla.kernel.org/>
        (bugzilla-daemon@bugzilla.kernel.org's message of "Wed, 19 Jan 2022
        20:06:55 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0090.namprd11.prod.outlook.com
 (2603:10b6:806:d2::35) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d81352e-0d6c-4a4f-cc48-08d9db9388c6
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2322:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB2322326129FC8097670E095E8E599@BN6PR1001MB2322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: coOhKBLzm3lRv1y+SFrVaU7zXhhuIxz9Qc2TcYU3EvzvYAstI2CODASFpXh3MQcazbY1Q41AoZhsZ1DH63xnLxee+w9huitfUeqpHMQroLdO8wqCkXkJWfFR2TcDgFNToos4b6GGweFwTDln4mVwySFiaf+Z2nNwyEE+lyOf31UiFUP1S3E1ygL1/k5m+N5FtlVxxuuIbBi7sJEYEarFel88STfBgw6DM87AjUQZzybGRiI7f7BNEQ4X+5tbYiamO1W6j/iDHC93TSn8q6a8tZWMp3Sd+bL08yBB00yrrpyrOP/GlvDT8j8QrNucuxEWKCPFmA3UQ39WVOuDaYai2keyHOGVNvjeB5kzwCmdEg1wiIS1sNer+2Gk633FKQie6VQAi/8x762EFpvpd5P2wbZyih3hGjxZ16NnDYAQA9om4ZIh+aUUg1gmoPwIYsa2qH/bfESnks7tmf4LLPW8Aq9UL3RJGHjdSdIu7BQqRAVuVsoFHf+eCZ0ijpQnnH+S6/xN0KtZ09jbZyyo/nsdsZMfqh39XAlWZPxpGLYr1Xmnrzw6eghvK6kJrgoGYv46MuASfvhtL96bU3ygUEof2da4tCst5zAoJ0VOORaNAhtYDgMUEg/Y9P/N7NUS0/3Z1qc1YRaq2gZ/ixJ5U+KzQez8AnZvNrk/XZu0KCe+d1woUaRjLh+nrw9gaSyMNH9RAA2o4uZwj9ouN0mWuS5img==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(38350700002)(38100700002)(66946007)(5660300002)(66556008)(316002)(83380400001)(66476007)(86362001)(8936002)(2906002)(6666004)(6512007)(36916002)(6486002)(4326008)(52116002)(26005)(8676002)(6506007)(4744005)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4xiOqJtTtdOaVlNSO/JQRIzaBMo08rNkKzD/A1IAGUmgIMx6IeI/lNY5Ar8+?=
 =?us-ascii?Q?ZTtVpROO0bOX3otSZE3aEikcxl4RIZiHVkYOSNomp7jTpmT5LwUSKnPOxmfw?=
 =?us-ascii?Q?HYS4DMrUeyKFvFY85on9K6eB9F6zMtWzbS4PU6ui3Ua3FKqLNFdu6cfz6B8V?=
 =?us-ascii?Q?oKL1fWh6xnoDOlg7eh36l7aEH2apssHHyg3tQ2fijS6yzt/aFHVKQsax5p0L?=
 =?us-ascii?Q?DVZDflDxDYsl09uorRssu0fPh2G8v16yOppaU6pOba4Egvam9CqTgCFJUpgC?=
 =?us-ascii?Q?Gjw82bdeXidoZpNQdXtYjlvsBxJ4puM0X222EiZ3ue0uOBXCCT4uN9K40527?=
 =?us-ascii?Q?NF7DuZLs4nGpsvIuH2xWeLw4ty/0qs98jpEqmOWIm+nZYKjVHegaTWweTdZ1?=
 =?us-ascii?Q?R7+Zuf+7TeKMZ5ek9uGIOZ8QKotnVXmzzQjRMim5wHbJB1vZS4O7U73UKElb?=
 =?us-ascii?Q?rJ5T21ckAzk8m9X+X0dsEVBg5tLEHyp/v75oG1c36vhQjGtbAYwRaAkktqk7?=
 =?us-ascii?Q?MnUywvmn4zYhbDvP76x5jV/GmRNVi4Gzd85SV0FG1S7INycJnqqHbd1AesvP?=
 =?us-ascii?Q?b3xL0tqGxW38vQLso3uaWCOY35S6hGZimbR016FWzs+EHlLxBT3LEJenyS71?=
 =?us-ascii?Q?olSejmYTjLoi4CjuC62Qr6uSvKoW7BC324kJycSsD4sR5LGftKV7K8O2B580?=
 =?us-ascii?Q?p71w5i9NeUP49YxzfOvzpkmBUsHCOEcfjfvfYmOqK3yvTqRtQAmRTrbuu6bY?=
 =?us-ascii?Q?UrGVytT5JEEl1i7UQLjothf4FNuv22K7Yee5BYLrBs1uSPeb3ERuwQWw45ap?=
 =?us-ascii?Q?wENXctMVGjJ0BvJ/ZkI+IspM0twX9qumN3tHrL8QrQM+0PcjAqueUEzmFe3F?=
 =?us-ascii?Q?ZJxsWuMtL1K3pufYfwMWiyFWZUNUT5oyDb1K0xISuhmx6U+rqmtf/iEy+y2X?=
 =?us-ascii?Q?AJOaoOJsFfULrOvL6MVJZHTr7jGVtU5Sl5a0/SXCo5IkjChDbS3Iz7XNZ3Wu?=
 =?us-ascii?Q?TW2NboSAPuYYClBEbJLbcO2h2gmMgkyXSYhWCP4bik1A70pOVyyeJSrodpyC?=
 =?us-ascii?Q?1lsdRSnw2UVk1KhGxP1wEXysS+GHafXAC8iRAzUud40Ge/uME626vsJUf5Me?=
 =?us-ascii?Q?DiKLS3XNptGBSTgwB13x9ukyJIZ0FwWcuSw6SNyhfzVkWAq4a4JBjzoMDe80?=
 =?us-ascii?Q?Sk9C2SwNO+HDdHb4ydqQAkG7tGjLfv8Ypcvim8E/kfv2KzjrpONp947+BILU?=
 =?us-ascii?Q?0G9ThbH/lVwk2VRX6U3II23x4MVXjZC/Sa/TT5oZG73UVCjhriLLjDUwgsVU?=
 =?us-ascii?Q?6XazXmzGRPgdC7HO4ZheSLFXAQfvwGgXe+eUDSFc7yV7XWMHeE5Ty/WBqA1z?=
 =?us-ascii?Q?vW4J11zFa7GKaAIWFl5x6NbUDU575u59hBhu1oL4eeGZkR3XmpJeVQV97bws?=
 =?us-ascii?Q?C8acVzjPdpCerFgEXMUWwyTt+gV5ylALKIy5q5JHGID2ZLB3HpCwPTRS/S8C?=
 =?us-ascii?Q?k7sDErWiZWwN8HZhZ05dyb3MT02PPkh9iw/yMvQN74NzA37r+SZ0FfrfpqIy?=
 =?us-ascii?Q?mb2yJAs7Clir0hi2GUQyCcxZXP1AqbVLVbcSpVcmkiqoV0ZcY2UPGUTElYEu?=
 =?us-ascii?Q?QXO+XYIGj6/ENgLPHBi2gjVRy57FNWF0z4x/60HNHpJEEbu8AwCZu9ifnl9Z?=
 =?us-ascii?Q?MiUHOg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d81352e-0d6c-4a4f-cc48-08d9db9388c6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 21:34:55.2604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Os4h4ZCqNZ88g7uu6XjfSATEjMirMhlWTmaGGw2EKoko1hdPN/O1CqagyjvS3gintAOzAtTEfgeuLLcbtoZCgnjT5iXdaBMErsbruD7GoDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190116
X-Proofpoint-GUID: wUAsMp_b3uAWq50NGguhnW5R3m-9sgLy
X-Proofpoint-ORIG-GUID: wUAsMp_b3uAWq50NGguhnW5R3m-9sgLy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Update: Testing with Kernel 5.13.x (specifically 5.13.13) - Still
> fails to Pickup LVM partitions on /dev/sda (which is detected) in
> VMWare.

5.13 is no longer supported. The fix was merged in 5.16:

142c779d05d1 ("scsi: vmw_pvscsi: Set residual data length conditionally")

and I believe it has been backported to all the currently supported
stable releases.

-- 
Martin K. Petersen	Oracle Linux Engineering
