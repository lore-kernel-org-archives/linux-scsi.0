Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A779EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbjFNHS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241271AbjFNHSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:18:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA14E2106
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:17:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k3aL023008;
        Wed, 14 Jun 2023 07:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=RpbC3axvyJdzFBTo1oKZPAm3v89iJEPr4wXKRIolsnU=;
 b=A7oAeXIoEkWit4ycbUqGs4eFfJXSs8UlJDEFrqSqUpxDBwezoBNOw7tauRVhk3w1dKa9
 GxcBejL3OgXU9b1SitCT5jVzvRbjJ999bRdfNARu7ArTofkSr8JmEplh9dwbIHeSEQB7
 YBOn99O16uBV/8df3Um9q//43pfcXljtIioQ4EXWfmPCm7aOYe6Fm/ur+wc6MeAmrY71
 iM6NMwoJcmxnCn916uMLEe17sq2oqezwAIOhjoIlLYORzfwo5mmoeANcJZ/lwg/PDHwm
 OCjs3I7qP6dzFaYddmVXcZPHn2Lnbe+SwTyoDS3LFth6D7BJwKfFcenmFyi5KADZaHil iA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqupw72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E603JB008936;
        Wed, 14 Jun 2023 07:17:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm5es3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoBPQH9SQFrWg8xkb4CNh84CqLyzNZ3RVYHphA+4mlv50HtpN7NkxGx9zKlA9Dq7Hyh4I20nilm57Eyk/Wdqej2vObsz+xP7mMymDApU45oXgjxmqHQnbhQYt3lIy//DKDbCbaYLBBCzOGaz7Jd8HAyc0uAj/0u76a1P6/dwFiUb7Cm3DMqUNFDmZm3WNUaRJJVeTcdPGzOtVTEg6dYbWZ2Pm1WS6/sNfmyk9Pxle7CEa7mtdLYZ57j8c0EUElZ/SAmTXPhY1UxeS5OLfspAYmjZuWEyVoEKFhY+5vOrJ0hIxCvD5TZyT2i8OGRZ95PUhwdd1kC/eYPfZEVBz1B9fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpbC3axvyJdzFBTo1oKZPAm3v89iJEPr4wXKRIolsnU=;
 b=Om+7GLKcHEYkzLEICzGgTIPm95I1vIFb6FvYxmzFgutESsy0IXCbL56oLdTlWD3PldQ3NAJjfQgpwuvV897pnt5fLqdrnpO+RBZ8lazh4PqGcDTIobbP6kAsiLJgOhn2MXK5goLNJwecmKdVAECXAaioTRUWL8yCKOt/ioxKaOIbsrLfOhElhQjrjaDZ94q2hqIAablJaakK2Tf7ziHfjx3bTZeCnSdAMraTQ5DyBw/rAJgVbiqo/ZtzM2yVK9hC0aFnbHd/3cdd381TVtKGhMAKoa34XJs7WtUhY0ca9nSMowg2n/nG96v7+YYWjCJtpWmUoyvghPIXKA5+oZZclg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpbC3axvyJdzFBTo1oKZPAm3v89iJEPr4wXKRIolsnU=;
 b=LLweqr1ifBfBha5bbzUutqoyun2WCfU5EPOSmsbBR+mWEHN91miWrob2SxWXcQbfv8Ikyyb9xFSI5kkh4O2Dq46PR4GzSvXMaf69EFithZCxs2Kt9uQTbifG+yfJ5JGF3k/5x2M5Yq2PvrhYBVNEI61/qs8nf+sVhjPvMvISbE4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:22 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v8 00/33] scsi: Allow scsi_execute users to control retries
Date:   Wed, 14 Jun 2023 02:16:46 -0500
Message-Id: <20230614071719.6372-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:5:177::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a888875-c525-4fbd-78d3-08db6ca765ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fwQX6txw/4SOKpwCBuEK4oDKpZ6YcY2gHXENa+FsWQqhm1It6CsQwpYkIs3H9aPW4H++S5/z2qWZVAQMQ81rzJ8jwZXt85iYqrlwG2phSp3L/7PdfG4Yyeqc6Q4DrObMqFMsP7YCOZGRLutETBA3NBghBPcT7DryzcdzPGTJW1hkKzve1Kms/GbXoKBeGS0kHG3f/y4U9ojWONaZ3WoDCfxR2eU4lwFhIAi8OmO2nNZwGtDmfzLkysugGRUU4Wkpyb8ijrelYiFSEwCLWp5Y9/a/t9bWoLTSJw5IBRMpEq0dciKAX5swcLbFLHPAWlJmoyFlLN61M+QBJZhJNAZPWv88ekB0EOgQM8fd0e0Ez7muuCE0Ab2u+UXKeFWHo/6rwMS+pJuWvNGJl2dk5ZbX/SeuORIvLpaFEFsbCSZfZym1I0dvi16jaFU9QvSZWRnCNInchNHmqNn0ckPM4/sKXj6lyIj7rM9OwRj8W4wMVEY5FwI0AyRrjY8OCxyMGOurYcextmjUiGMcPFHg/wvqrdAW20ngj9eDJfhBRDN9NU0Q178M7ns9RSHjksmK1Hy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MDAYD4nAnUyAXp15/V4vpEe8pKpCyPQH6OV3pl2ZF/zpd3Qd1J0IhGdJsgN+?=
 =?us-ascii?Q?VO/WrBUKvgFeGEYtQat7Uskx2bRFVBpBeURPJgyUG75VFlAIrf1wKKk2g4/T?=
 =?us-ascii?Q?y2iOLLUhCtImSEtzsQGpTt/y5XdMiFDvqTT8gMZYr2wzOSi4W2QR2WhP8KoG?=
 =?us-ascii?Q?EbMY/rDJZSAdGLE6mzmqeE7JM/r7MOq7QaUZ9ERHpIl++PjsF/aovN+3CDht?=
 =?us-ascii?Q?37yPLjumfZiafPf2zUsqsJ8OL5MC1fY3OHSWzYHG8d4r2TYDoydPpdaZeHhO?=
 =?us-ascii?Q?l11kHxS9y9KonhjckrXckHfEFTnqllTIBs+89WFgqfdZkkeBiVWFotFf+FGg?=
 =?us-ascii?Q?m7j007SWXXOJuggGvz4qeU8O57nAB0po1Mk5W3RTduLlZFipW80MqWxVPeU2?=
 =?us-ascii?Q?JvL19/Mk/yGKkXDJbs+9K2+qzzVz3Q3QIybGQGM2upHRchxdV0sU2zp9sX5+?=
 =?us-ascii?Q?YFISjyxZ4RUtlaBTg+J1x3Ba9JP7XMjoOPXiaTDDqrwOxvk23UCQDtWnIpmT?=
 =?us-ascii?Q?7nFk9+wewNK52dE4rOZjmdJmGsKI6NAFkP7RLYlk4zkAu7dwbSKT2dJ78sIg?=
 =?us-ascii?Q?4acL7emVjQYlXDoI3bfSBt2nrlU1NWoq1lHfEjV/6y4I1shb7c+WB+qzDhgT?=
 =?us-ascii?Q?UyS+j3v/C4Aeu2sOgI5vWJVJPpcmAjD4brL5YVyFW+DD6s3pBhHt1LSScmxJ?=
 =?us-ascii?Q?cIxwaY1aUXIZEzc61+IGvNC1LNKA5T85lOe6twqjC9KJ3bf0y34Kv7cswqCq?=
 =?us-ascii?Q?PvVnSm7hbchI4TukB4aQTPfvAvvTSB6rL49edcQ1krTb0vQiXH3Iej8peEWy?=
 =?us-ascii?Q?J2rheR9HrCYZ+WiREY/+IIRutKm4UMDKqgk0fv88j6ixs73zQmArKQWs34ds?=
 =?us-ascii?Q?zolIkkJ3NCuXyjvL+nrNkQxkXHPVakg7BcGmSC1RHjLXfpyfUqNLDysok+T1?=
 =?us-ascii?Q?GYp+ZcK2rV8GXXphEB8WMKLv+wza9EjWY9Zd92lUswHEpvCjSrE9uO+cECEs?=
 =?us-ascii?Q?yuOaSClpG2eMw3qzLmvgiuNrGVzGm1gAMhtR8F0IR286TAGtFBpzjop+kyEq?=
 =?us-ascii?Q?+nMXlKhzqxGrQEh9WjaThHpFaaiEdqtWW43bOMF0pfvW3p0kAit6a2OhOcjo?=
 =?us-ascii?Q?qHbFpd0qoymtqWs7ArBFnrHZ2uAnUDgybSDT//M8pBybYlEicgAKPDb9Q1kE?=
 =?us-ascii?Q?tLg1NxZl3aA3CubWCcwKntWruuh9EO5eAEQobDfAMMdH2sSZAx2lSlRbgAPS?=
 =?us-ascii?Q?5r+gkmJWbPnK11Hu0AU81FI+nA3K/YpwegnWvWdZwPzBM4sY320bLtGo+tYm?=
 =?us-ascii?Q?BgMz2oTvc2zILl2FdIuhvF61vluFxPhG33A+xtOLGq7566dvfibHO1X+Irvc?=
 =?us-ascii?Q?mKEe50ZR5ssUg4GItAz8Is41OUFvuhscEcHAKvjBljdX5PW1f6aQ380pAmnv?=
 =?us-ascii?Q?zd8HF0vWmxjYUzVPWTcEtaoLeUDvo85sALwwCebPOwKYXPwTniGPO/Nh5Scq?=
 =?us-ascii?Q?iFoqE4nAntaaouErsw9cgYYs5pnjKdhrGKQsi38/jE27H5TFdlhN2TLq4oTh?=
 =?us-ascii?Q?G1C5XI2X2mUlq4KNTwoDpvbXXLEYhvWKOk/mXKOoHe1o5ppS6LmJqNJZ4mHH?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 34QzSJ6zq0/7wER8dHkoqXaZqtcAe8g5S9wEKexUTBb77dr8jxG97gPsMTk8zw4Zdx4KGsOpqUi+1Ka2X4U7lIY3HLr1atj12svs2b2N/r90TjnOyq90fSpjMeYgajgAxpuMjvxgov7XyFvj3iSW0CpgIVzKrqye1tF65uuHmPhrEl+AYkuC/YN3k36nXtBvxEUNJWP/yIrETkhkEuYNIbJ2CwRSGp/JKIieB/W1WaAyzlwrw0cOcCZr31A+l/5zB3yWmljEvC3V2i9q64u/MEfGbNIbGGus1Vy4VUQCn02TRc3JBwPL5VkKXnlVSAJKhCKmDGIWWK0N6O98I3E48dp6QBnBWKj3I2auiBHj8lAs6SglkGEeBxp0GkJ3DqwGHcNC6ukWtNj9YQgYjEPF7wk2oR25GMv1/GS8YnXRDAYkfLlwa6eAxGCfoYnG17u9AC5uczEGTMQa+CvcDI1X8iRIc70JgATJdVgyi6ljlGLMWPzUgoz3l+sz/IebLNdxg+tiP8wzONfRWxXQheBmP8DnfKY4/7EjkboAmqITL/EGOJQF5no8jrbfIKaVnjT4Q2dxOmeZHvBnEOZbBKW910vnMY7YajekMmQ6x1JzEBChvWEiWVwJTKVnHAN/CO01bJOHItUIQWxI9wR6VuCIVu5Y4hX6paYIb7sdh87WNiJW1shv6g0h6y4g4iaY3dpXc37hgDvDCNKpXfKTDE21oIbdcE1CJxO8v9HeJLGYbg+dVHFpw6isLUbPhj94nNONhysFR1cj+MbFGB8KMcpPFa25Ss4ChVbSEbX1fnF7jbz4Onqa2oUc30htv4EEulacfp3qEPK7t6tEjuXtFdtHlGCAU1Td4fURTvy7dTMX3+DeCfa/sZEvB3OnFgzGUrzd
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a888875-c525-4fbd-78d3-08db6ca765ae
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:22.6091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKeYULX46a+JAqxO/Xof5SQP+dPqEu5cpI4Hs0z49nm1X6ZeUmyNlMPccVsM7QUL6KAyA9z4KcRTRpuTQWXV2sMCxssHOHbpuM1QjwNsP+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: dOD5_l7kOFt0aVASeIySGM_DmJxkHi7E
X-Proofpoint-GUID: dOD5_l7kOFt0aVASeIySGM_DmJxkHi7E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 6.5 scsi-queue branch.
They allow scsi_execute_cmd users to control exactly which errors are
retried, so we can reduce the sense/sshd handling they have to do and
have it one place.

The patches allow scsi_execute_cmd users to pass in an array of failures
which they want retried/failed and also specify how many times they want
them retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute_cmd users. We just have the special cases
where we want to retry with a difference size command or sleep between
retries.

v8:
- Rebase.
- Saw the discussion about the possible bug where callers are
accessing the sshdr when it's not setup, so I added some patches
for that since I was going over the same code.

v7:
- Rebase against scsi_execute_cmd patchset.

v6:
- Fix kunit build when it's built as a module but scsi is not.
- Drop [PATCH 17/35] scsi: ufshcd: Convert to scsi_exec_req because
  that driver no longer uses scsi_execute.
- Convert ufshcd to use the scsi_failures struct because it now just does
  direct retries and does not do it's own deadline timing.
- Add back memset in read_capacity_16.
- Remove memset in get_sectorsize and replace with { } to init buf.

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


