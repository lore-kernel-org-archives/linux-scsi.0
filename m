Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F17C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJWDEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiJWDEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:04:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39475D5C
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:04:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MCsDV1019473;
        Sun, 23 Oct 2022 03:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=dSETb7Pis7r0DOIQQKPm98EjN7F3IhJM4wZNw3lTIRE=;
 b=v6Ntjk7CnHU3wy/Hjx2W/RTBaT2vg8GD5iYXnbPmup4a7yv/ikutKbfyx8pfpgPVHV5z
 OeErskW4oORSg2VWdFCDHb2CENIpnMv9TGlos8XtkPzU7xHpAMIIA4wF8I4z4GXux3OS
 WcOWCoR6hAQw71MgbUq1olaNRCMIhDjHakizAMsH6zo8YOMnrtH88bKnTGz5utHJSKdd
 Yq/AsL5eT2OcVHuFE03JN0ubLX0HZW70H+FvFV8JLZY1bf+mOFQQiVbtUbbW+sgCOP55
 l5AAJEcugmRXjegbqqiCgVAPxP7spFBasAgTVDzpWjSQMZjq2+2KqzMnM5X0ICovZHHI vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKJKMd016384;
        Sun, 23 Oct 2022 03:04:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y90n7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjIzfZWlzLFeuhrF083z5N/LjtFsn/RZuYAdeg/bQ3LnklJOObezMM0Fcinfe2BMjrQPicG7LmvWzMF7Ch1Ex8WfRQG2YmniOZZv70pV8OzJJmPreWGGQlZ2X3xIqOo1O1NOfIvxDpO9AmM9ObgfxeSya8docO0iP6vjf+IfUktbCC+5UZd5opPMduQmrA6gGUDxBScret7HroOPtH8+c8QPEhk6yThm9WJx2KjMzGQu1jHnMBb6F1dc0tQDAUwhHypCpgblcHIYWdRjf4104XXCTqrMDrLQVUJ3GQpld/PVMZIudrXUGnrTLwNpe2eDMf/XH9wa+rHhyMlUA0xKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSETb7Pis7r0DOIQQKPm98EjN7F3IhJM4wZNw3lTIRE=;
 b=oFnvAqFurJvz6wHakY/31qVopq4pELRsrWJCZRqa9gQbFu0jqmQY1z/VVzJtWgrMUhGIaZqADQ4EMhcpRczToPBfVLgjogGzBZs+G9qkOQJTQYdvhlMH3+z7jPdHBmGS//kz82soOdfhneWzXG/zvI7fyogQ7u6XJcpJzftNHpAE7xc4mjH4PJrN/7xlAOCQ3Ufq3FUIFLgrKrNI8fo0BI/yr9G6p66g+jvDXX1JIu/KxZxsDaegEXdzUXhlgQyz/y8jfuLXPWiTRTOKSxTOM+79WSw37rkAziKCKRYwxbg/+sGbYvkUeDl8Gm/G52/cBgBDL7OY2G83eazeXF9rIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSETb7Pis7r0DOIQQKPm98EjN7F3IhJM4wZNw3lTIRE=;
 b=IuR8sBT8g5YDQyvykBojyJWbb3cN1u2AjgB/t0hMjnRWooUBSAS4GxT9UCFtZ68pjDSmyTp+9DIbYEq7pah57QfEpqPZ2ZKuLjz0S+etFPAdXWrPdZ8hmGEiHVH2rNap9hZBUDY8fFbErRB3wTAxh5YlnD+jtxYZFDsh9CySMbc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v5 00/35] Allow scsi_execute users to control retries
Date:   Sat, 22 Oct 2022 22:03:28 -0500
Message-Id: <20221023030403.33845-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:610:cc::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a290def-9f1a-452c-957b-08dab4a33f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H9JEh+dl6m9CqKutluIZbs75CRei1B4FRbAuy55H6tarGR0p+M446OJLAM+58vKgUOghGjABAhwiP8OxJ+2+ZBPGSuJ7B/2iT/DaTpjVoP5CIgo4eJQ2hsDLOK/YU2BzGTfcSRU95uPFM4bEBRgRpDeaY+6RxhTQgdJjo9Qaso2UjMz/8WI9hoG+UB1oQ1Xq4AWPtNsf+PCfJv9lmDKPp1MGUWF0mby3xZ+buAOrdnD2b0nVgTjl6Bke4INEHidUG66L5/asTq5EShnlnTGrEMQrAoYEIA1v/v8iVHeg1DZMy3JWMa7eKVmsvJMWMdmFNZFu2MeUIs9ktzrHz1HYT8yVPapOKcV+6yQKBQ2G9UesT3EphVOVM5Jmms3mOECP2cKLJYfkX/Jm1xN2C12hUkpIRyQWBgBGjwx+lsvZRsd+NwLZXGX4m+QIrRcjFyr9thuf021lFQCHV6aowGdKsFxVjIuPg90HidGlKko+vXKNRQu/hC3P6iWO1isyyWNQmg3HZ1wJbEnJO4yy1wNuKUdMU8jLBasUhw1ybrVS1vqaBMhC7d1ur4xILMro4g+Rf/gd9UcD64gmEVV3L1MLQotFPQMBezMIdYePQbTGet20suiOocJ+Hwn09ecNUySFLV1NgahNqSavGByHg/hzG7/oltPo5v0r10DS9AXaEZUOM/tkHKKW2si/inyBPdhSIWs9hXV0xXCq7YxWD1wfSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p/ceWHQA50ETbqW1cUNQ/QI49gzayUNBPoPW+Fc4DXLOzWG8RMGVSjzJLVNj?=
 =?us-ascii?Q?EsY656JmilD88AyguT4LNTqpF0cw5aPFw8/ZlBDUhMHWIK1QKXt/f0ZtK13o?=
 =?us-ascii?Q?cuC/ds1ZRRbTXxgHWmavBBjWRJMOSJYO3u2505HMxtjV5fF3cHA9z9hOyVV1?=
 =?us-ascii?Q?DDM5lAMXKQtNKW8QUtqulk1CbciRlkaCYItBJG9X57D54TaziZiFGMqGLrb3?=
 =?us-ascii?Q?1/VaOyo9Hha7w7PKRCcJwMn8s02XJPUz18E/0ZZ/Stf3Q2Dzf/dppEpAXBA+?=
 =?us-ascii?Q?v9/VSuRP7ixsB+/u75onzQTd3ttIcdKHBdUTOuNV9/oaNg/2wspynhMdgZ8S?=
 =?us-ascii?Q?uJ9luFbO6nRaqI5hbWDCsfSzJdEsbGk8M/70Tpvvj6qmMGOiXpGZFJKwdgmj?=
 =?us-ascii?Q?tCLoRTClLueAmV9hqVQdhrDGjzb2gITPKnow24Z5v6Z4JSo13PDiAELBJXYg?=
 =?us-ascii?Q?DkSzJFPsx3Xum2ZWdx2nhc9U/Yq4ntfAKheCJ7Yrwu8yN00lxWMpl/aXsrK5?=
 =?us-ascii?Q?4N3ndis0ngEk66zUEPx1YZI9R3Kpc6eaAQRgfGuOOKvaeHQWasDeBhaO15/9?=
 =?us-ascii?Q?/FVM80HJEDVk5izDPOtDQ8+GuN/+aoZszptzkGtw1E2IO3G6sqptPXCxo6yO?=
 =?us-ascii?Q?h4pZscb85n5xVeiD4ufgzLwH/2moHIRIG+fNh3e4cjVnp/mBBSl/mFyjs9H+?=
 =?us-ascii?Q?wi1pFBCZJRkTUKIioRT+vk9MJDgfog3CCiIWTIQJBa1RFMBIA0XS4p8Un6T8?=
 =?us-ascii?Q?QO/7gi4jSKWY86ZQVuprXWdajPDZOpGe45ZMEqgdfDoFR4ThgPk4dNvu9hWr?=
 =?us-ascii?Q?+1JrE1B/opF7j2RWpaVSeY340TeGfREfKmDayN1uvmYRrVHSiVMNdrOEbuVW?=
 =?us-ascii?Q?emBVe1CDacqUXBIS/z8l4g467/wSn/DBYnVc9h6o/3pJgi8Tf6rCg3iRf36w?=
 =?us-ascii?Q?0NzE6rNyzq50y+9KYGlsbstRxWCIB9wamt9XVXK92RQp+3M9jIjqz6h5pFL6?=
 =?us-ascii?Q?AUDBmHNxG8A4+t7A+ENpwQgDld6ySmO6KsE1YrKJ8PSxm2VM1Fpm6zkfOQNY?=
 =?us-ascii?Q?WbOtXjScO5mdu3l2PEHC4gegmShcARXCC5GNPnmw3D8+0WeudnB7ubZD5wj9?=
 =?us-ascii?Q?goDqfIbEScr/JeGW9txgRFTZW/TsNueC4ELdJFEoNIEUHphzSq71xxjxkmrD?=
 =?us-ascii?Q?GZLISEQxZz3/JxlNQZHPpxIkgh3z0YfBjP3Y/6jaBPeX/OePj5O332L8w34T?=
 =?us-ascii?Q?ZnksKnKa4EZoKxxVdlbvD4se0S1m6L7jn+IMFLNCfYPpY9bnZKPWpWJfxJN+?=
 =?us-ascii?Q?lB5/OKxBFGSc4rBOFMTWBSRWuOY/1ZGO5rlzc840O+Fx1psgB/0ezZPi6LTJ?=
 =?us-ascii?Q?BDjQDuYJk0qxYRGtB0zvtPCQP5EVxm6QeWpeLGFIj1Oonk2cU6+ZUwS1/Njw?=
 =?us-ascii?Q?OQxwi07g/KK5jlEcLSugIYR6/pFyG1In1mwZBaTJLV4BE9NdlOXG5PGMoKUY?=
 =?us-ascii?Q?vwHWUZJuUXFG2QJ5eo9oDg872NCAntH/c4tMi4gMtV63BuB6c8r5ZIyFBACn?=
 =?us-ascii?Q?EE/QXnTm5bCE5rWTYPky5za2fyMPa5UJ49ZkVih5tekAdbWWMB4Zerjf/qQw?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a290def-9f1a-452c-957b-08dab4a33f44
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:06.5161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQDjmGEdAdiFFOGCSTypHWojU2RDvFin9+NY88YXOvSbr2BPAlypXMBejMVK0JGjlc3llQCcbUUr+MTuH+n++BYHcm1MbWHpxoz7tO9FDR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: vW_a4RB89GRGFQRd0_W7HKCHxF4ZbePZ
X-Proofpoint-ORIG-GUID: vW_a4RB89GRGFQRd0_W7HKCHxF4ZbePZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches, made over Linus's tree but also apply over Martin's
6.2 branches, allow scsi_execute* users to control exactly which errors are
retried, so we can reduce the sense/sshd handling they have to do.

The patches allow scsi_execute* users to pass in an array of failures
which they want retried and also specify how many times they want them
retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute* users. We currently cannot handle the cases
where the callers check some state/sleep between retries.

v5:
- Fix spelling (made sure I ran checkpatch strict)
- Drop SCMD_FAILURE_NONE
- Rename SCMD_FAILURE_ANY
- Fix media_not_present handling where it was being retried instead of
failed.
- Fix ILLEGAL_REQUEST handling in read_capacity_16 so it was not retried.
- Fix coding style, spelling and and naming convention in kunit and added
  more tests to handle cases like the media_not_present one where we want
  to force failures instead of retries.
- Drop cxlflash patch because it actually checked it's internal state before
  performing a retry which we currently do not support.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args
 


