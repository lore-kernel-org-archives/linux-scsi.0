Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D45C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 22:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355856AbiDZWh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 18:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239922AbiDZWhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 18:37:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73D91552BC
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 15:34:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QIvZ1j003693;
        Tue, 26 Apr 2022 22:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PG9nd0VQ7x+wbYeAb5nhKBJ9W0EVIywzsUuJshaF5QM=;
 b=fVZAQca1XufkO7oLk35JvkuRbWx/2EXo3QLXCu5RWbRw9mxU2kd90H4/ruxAm9lPUaue
 eIrXtB7i06KVYd5z+zFa25MTLGjthKM0cDxClKz6hi9umzpHQeT8pDRGyNkRGdH23KpX
 spUSJj2Wl5AEu6HzpMJ1p+ZYALARbKERfdhSHeqnuyqECrkT8doJhV7evcG68XdJYEkm
 SQaucvAxscnDFkl4Ocw9qQfYKbOYI2O218BDB+m9dU+QiCFpDmLfdnrKrKxFEpBTk8Lb
 LI44GJeHirSKWTDPYWgrYKESaZtOme8PnMQNFY4lNzszTJPmLSfU7tAzcnXrgw5PyUXM rw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4q82k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 22:34:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QMUXSL015847;
        Tue, 26 Apr 2022 22:34:43 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yjyy2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 22:34:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3UvNeTx0rRIo/kxi5tPz+vfonkVSxOPaH/tqiVm5toyheZivN/q402SA24aew9n7Zgl01ZMIKT1MuTR/MaBeget+7291G8Vg36BQ/lD7SuuX3RbImGEpMj2Grx7AbtfbXJK4Moerq1YzC5x+uXF3LvgQBUf4uSN2mgUOXxcEd8MiWOB6TdYepPBmSAyeBStN8VOZH+JTH+wVgUr8jyt7+BY3BipfurBfCKj+9emTHCUL/zD5voVZKIaqYdOUvXdTTwf0vd202JgVLb8OCogCHGtxo356P4fTmvTo9Kcys/NpNQ4d3l9vyV9v7E95EKxyEcoljEz2ksnBs5Kt9d9zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PG9nd0VQ7x+wbYeAb5nhKBJ9W0EVIywzsUuJshaF5QM=;
 b=a42d2MLv7FEvO/i7xzPFx6qPLNjob6yEkJCrDRafIyuuopeAfmH5ou48P1ea1f4RFUVpo6JYFF0z+/xOi6SJqfWQnk19zq3WfCd9Fyu5NOYyQnpksiwF9otqXqQFfv0wYZGF9KWl71RpMwsEIiPRYPYpp4Qu53IfdluC21/dYgK6Lgy7poulnM01tOM0/oc08ltxlF7U/CJUdEiihs2wle+maKSV4i9k2B44AhAxfyT3K1EA+DzpvBqDl2FjFD39MfygKbcufyyEw1SNPjIbpLEi6nbvKrR+wrQEXOzKEAB2iFlm10Grb4Epj0Yp+aCseKb+roMKdUt8SoglQTH9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PG9nd0VQ7x+wbYeAb5nhKBJ9W0EVIywzsUuJshaF5QM=;
 b=PPZQOG89hCX6gJ4fX85O8xWGN7d4H48mJa7xSXOdwthwwH/j3WD59y5vQPQdxdG4CXruv+OrHgluEjc6yuk5VTgsXZXlQXmEi0yOH0Ykp7xrLGqRgBzqWSKD4JLbOo2Fi5knv/6oLuuFF0Pac2pscjqqaQXMoTvx7gMwOeylEvs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB3047.namprd10.prod.outlook.com (2603:10b6:a03:83::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Tue, 26 Apr
 2022 22:34:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 22:34:40 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6c7pj7s.fsf@ca-mkp.ca.oracle.com>
References: <20220426181419.9154-1-jsmart2021@gmail.com>
Date:   Tue, 26 Apr 2022 18:34:38 -0400
In-Reply-To: <20220426181419.9154-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 26 Apr 2022 11:14:19 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 230b38c4-c545-43a3-ea09-08da27d4f3bb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3047:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB30471D1798A9EB4054B8F50F8EFB9@BYAPR10MB3047.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sgeWhDxGXaPepZSneK+Zm1U6Lb628IpwX9vf142bwTl1HT4fBpqSxf2jhhhhRGtcFUR7TWVLoGQW1Ds+T1cfDJu/rqbVkWMhHk9HZJa2fnthrM/XHRLPDuWtfYjmo3hVWG9Pj1jRGdX39fLPPeq9TMi8PqxQ1ZGGBIAHlyvKOFlsZIbux6WATFSFb7UJrbf9am/TbsuIcPlkfgrlhK6uoeJRGjnHN8iKToAfzevkWxMLp27nMzmeHM4/t+XJ2+bbxOVrpjXVfk1XmTWimnOnGn/xILn1qqGw5IyGp8XO5/0ivmHzcxq27YgiaMu7tAtsWUDFEEIjfqTEDwnRZk/O4yeq5Kk42BnU9Ql/RaQ2EJLFfiKQWEct8BXGs6srIJJDMtfX9JLzuBQZmhJokGJwWNskGmug4FaV4RbSnOemFnkEHue9f2ERwfHCaePB5zcvIa8QMhhCKBOU1HKDkuA1olc52V9RkSzWOyZ9X28Q9Upb5pHDVNtnA7mL3FFM7wTo1os0CrFljtNHw41ij2CPQOZsaYNKwqyXMtgYT2qIJuB7GBGHkLXumnJSaLA38kqe54iIKfARZP3sng+3lxF0kVNvCMtFFRqQT3hduM7btn0jpAz3K/4MHZEDztsh/dXbMSgcglQvYA9RIOIO2VGT7lZ60gZkwG8PlDUxh3xOorZtuvwA5PHPnrZhJaKpWGM2mDB17fQ6vVITnfgZGdHycQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66476007)(4744005)(26005)(66556008)(186003)(6506007)(4326008)(6486002)(6916009)(316002)(8936002)(5660300002)(6512007)(66946007)(508600001)(83380400001)(52116002)(38100700002)(38350700002)(86362001)(36916002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f0eExTauvo87rOEbePMJXQT623iRYpjnzSl/fU1lVf11FqGukhDqFqRFOUdN?=
 =?us-ascii?Q?VVB0Og9jtQotVFFkPiHGl1B/dIW/jJeaBMLlYVOGdRdpKvSoj6iORCWB09X4?=
 =?us-ascii?Q?sBDsddDPDZKrpu/NCS4NqHS/mKvKIPwnGckRaOBdeGjzJwdWnp3z8oGULR6B?=
 =?us-ascii?Q?D7ON8eW64NF6rJYC4rWHvqvw9O2Z3lHL2onPsTSvavV5VOphyDUQrs8kCXu1?=
 =?us-ascii?Q?Y6toywLTPMRCkAL5Lf/r5LXgB79SdEf6II0sp5vRDjG3zOwaOZglXSwGwREQ?=
 =?us-ascii?Q?EomovaMug5yzI91XwOvDeY772vq88GKxHlSDpjNNpL0ySFlw7YrDK73dp1Ia?=
 =?us-ascii?Q?3jc0zafCbECZVTfILpqGyNLhS/cHcTnnK6uXYL/92/Yz4ft2vKSnwLM47++l?=
 =?us-ascii?Q?d6RDtHqU5Mvxfq2XTxVxrAalm+PJ1Iva5OoeBQqnwqE4WSOCBkhP+40JBbiY?=
 =?us-ascii?Q?yvP8euKgWrSrPP4GcA8KXCh8BYF4sqqi6Jd8O3rDl83nzG9K65kEPNUX1U+4?=
 =?us-ascii?Q?1NaC4A8eLYXw0WY3GrHNUn/y8JFQbu/XYkvw7I7fuZNpc/tQxYTQ5D2qUUCY?=
 =?us-ascii?Q?Uq2cBrOE1lpFOsrECKfMp23VnmU0oXvfQ+oBuhNi5nrTNyZJ4R3Cg34SsQCb?=
 =?us-ascii?Q?YT2yA2E2fJ4OsTXAsrc0awQBBD74OxRc14eM9IU1lSfAEAR3/h5mp4n7py3a?=
 =?us-ascii?Q?BMC6F8HvFjCKVDm7N+hcqff7iH4Cn1KNKvUrORABi9rGu/1CSmT9laqDVYV+?=
 =?us-ascii?Q?3ES16Krn313JgmKqz5Pp/rpyoK6EVv3lbsvQCP7iOB34opEKMdA4NUBWuvf4?=
 =?us-ascii?Q?waI6G/7AqflDhIiiBjAIY1SoUMCAc0sSag7U3/B4WU36mKS3KauTNFax1pGa?=
 =?us-ascii?Q?vAGvsbCz/lFKN/Xk/wnR6OFN8Q0o5ExehvuMt+MS7xko9dd4wJZcdsAlSpaZ?=
 =?us-ascii?Q?NXST8Zb3XzHUSjuBx1OZj2ZKK8xrbufjbPLcpFWNLPmn1/dRG6sn5TumCW1o?=
 =?us-ascii?Q?ecZZ6tXVoHS+s25kvds6ptQeg7vWmgsNJsEsU/iVJEJblu6vnbDNcIu6MkRq?=
 =?us-ascii?Q?nZMaQMbNQ6rT/SGX1X83nTF+lFA75YNNMTIUKbZa8wZjv3dEPY9Yho73C1pQ?=
 =?us-ascii?Q?+QJq/MmdiySPjCyquFSq7g6Q5ohu3HtOfFcTxsnZMOZxhuJYI0MhcGFL3mZt?=
 =?us-ascii?Q?k+XSI1/qqAa+M2z1Jypxn2PxkNXVpQ0ANK+zoQUNnP077rJxBvanU0mtoa43?=
 =?us-ascii?Q?keafUJ0GaCsYGD8WpgZy9mJyn/FrQCSq9/Gnq5ApulwHarq1MPhMbeVEjdDb?=
 =?us-ascii?Q?zWwb3yEoagVe+8i0npCY5urJuj6cDHU16XPT0okqqKlvwovwB9GqJ7ta2/EK?=
 =?us-ascii?Q?MMrakd/s5ofBgLmBsDe4xL39jYHtUI6uVGv9jQjELZApnfgMpWwMlowliBC6?=
 =?us-ascii?Q?HsGFBunj44Ha+vu6U10MyIJwaaSKwlaVrx6AHiE11gj2kZR5NBa6PpoKzdYj?=
 =?us-ascii?Q?veUwc++eYbe9DSZg74hJZ+GWViSccis9KBGWo4k0NE6yJS7CueKUA1tZTxdX?=
 =?us-ascii?Q?dcO6KC3+9f+sUn6nRqCDBlx0jrkEQt4s+j1uzrkPyo1vdKN6/4VhFrztg2uW?=
 =?us-ascii?Q?z4jg/NDTNo3NPpxZzDzvueKigzEG5fxQqY4+otajjHvGEvObET1/Y+33WhTz?=
 =?us-ascii?Q?guLJMLavM7VuUkVXXIjh0m2D/5LwrQvF4e68exm4HTm7FIUHj5PDo3K8lPsh?=
 =?us-ascii?Q?UxbsCriAobkdJpwTDIVcK8+qQjRtN8U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 230b38c4-c545-43a3-ea09-08da27d4f3bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 22:34:40.4574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJDVcqSiEBguoRo46EQ6mtgMP3J9iZP5VGHpxe9q4OeIpvpfDa4+TfsQnCvncn+0SSj/r28PWMCYFsNcyGT3k/dYZEApq+1ypULAulPgCVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3047
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=604 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260140
X-Proofpoint-ORIG-GUID: XopDs2Kajw10TGn3Iuwx8JolezOwbfQt
X-Proofpoint-GUID: XopDs2Kajw10TGn3Iuwx8JolezOwbfQt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> If no handler is found in lpfc_complete_unsol_iocb() to match the rctl
> of a received frame, the frame is dropped and resources are leaked.
>
> Fix by returning resources when discarding an unhandled frame type.
> Update lpfc_fc_frame_check() handling of NOP basic link service.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
