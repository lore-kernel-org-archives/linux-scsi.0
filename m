Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B280CCA479
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbiGGVi4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiGGViz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:38:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAE7286C1;
        Thu,  7 Jul 2022 14:38:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCToJ026380;
        Thu, 7 Jul 2022 21:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DNY+0/uSNtqlm6tUIT7tkO479YfGtJVOkQeB1RUw1sc=;
 b=EWG/laVsGVCYDbthmtoFo8BNkb/zmx7n9rxo9+fWUO8wc6195RJ15et4iY2eo21df6FW
 Vt2F4g/+1Yx6fKwGCLGuGMluQ2RDbvnUbvTJFSS2TrNcdK1O81EJpZDK7niaOugEM+El
 1zk3Q62dJUvBtVwd4ct9bFKWCeDCZnnQuZ72KD2C0tfZ04rjbcu2oWB2wgIcT+E8rkVW
 ylAS3sWHsQdajKwEvWCQ/IroZMp5kBLF3e2AF+1pAO0iNdYkBknWBOanZybokNJgaGii
 JDp8lvoq1bJmdgr5tlzyZDzLFOs5ZbSHpVGKc2rtFh5XoKzQshb7rZ98leJHnSCUTb9j 4Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubypfx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:38:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LZMSR006464;
        Thu, 7 Jul 2022 21:38:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud7bxnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:38:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqygadjcX4E0nG9ukL7QZhebHKFIEBZtq/aUOyM7FHzHYaVB4oqehv0i45BPa5SRQn+vi5KYBEf9fiLvaG79L+d3YC0Z1QtYBv3869lRGGnQL2Oxrk3FNnwe/tcmYA+kcYwzvvHbkB3vo5ULm4KsKUoQqTMFdv8P9jqRIH73HyHS9XUhVA/0f1F0nNIxAACCL0f4pX0EK6/QRN3uvtPPScVL3mQgbmVhA9l7dL6mHz6vQz0nbzZGyhJYMJ8WYmCDnJgXvlg7Bll6v5M81kiH5VGIGZU+a1LQXGSK+4o0jTyx1tBxH1wK15WTT65X8kQhlUYnydbVkH7uK7mPKtn1GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNY+0/uSNtqlm6tUIT7tkO479YfGtJVOkQeB1RUw1sc=;
 b=BsLs2oCqZcoMe2lzoem+yQPUxZs/7ogvla39kG/Pknkp/r3p85QSdwgVo+E28pCgccWPegVJfHaGif65rwfOFltpZIhPnuDjkSeGh8Dv9gxrYO5VtXt5IPUbEtWJtyXP8ACmzDo6NNothK5vv5n9VIeBEcWRz6Wb5UsfU7xpiV8jpARJ0SXE5BxBCDNZtP+BJNtSG2l9FuETe/SjB+lgSPIku1OmU9n+Xev2rMnoOOpzLyfUvf+18AaO0HuOb/4P8z578eF7sADlj17+r5KJLxcrqLoOBuevvD0pUZFkylorxerNc6t0E7J+lkbdeF3oM0n/4oZN6BdMZYROBm8tBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNY+0/uSNtqlm6tUIT7tkO479YfGtJVOkQeB1RUw1sc=;
 b=wsYyFzV/U+eCTyAfuyZd/lWrxTKIgSKzOnKNqAB3aZqTtL8lw6O3z+ygofYMAAa8FfEXkct9xtdxfw0rqVOcwSf4rj5imGoMbSdkkYCtINmgi4MlOC/O4cek0rwIzhyGVWwTEsFAIv0HPgp72TDmox4DgxFjhjRXYxNKlaha2fc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Thu, 7 Jul
 2022 21:38:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:38:43 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Mike Christie <michael.christie@oracle.com>,
        <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmig4n8y.fsf@ca-mkp.ca.oracle.com>
References: <20220628022325.14627-1-michael.christie@oracle.com>
        <20220628022325.14627-2-michael.christie@oracle.com>
        <YrqJhyzhjaEkTJL/@infradead.org>
        <yq1mtdk7j59.fsf@ca-mkp.ca.oracle.com>
        <20220707205751.GA3509@yadro.com>
Date:   Thu, 07 Jul 2022 17:38:39 -0400
In-Reply-To: <20220707205751.GA3509@yadro.com> (Dmitry Bogdanov's message of
        "Thu, 7 Jul 2022 23:57:51 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0194.namprd05.prod.outlook.com
 (2603:10b6:a03:330::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94aa77b5-15a5-4806-8eb8-08da606110c8
X-MS-TrafficTypeDiagnostic: CY5PR10MB5961:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w28St8DecmO9kbVHhjYfmxJYWzEVdNxywbXakvZTUaqiXz+lOWU4xxb09F3S/ypY8qm3aJY3g8Y47Cjb4oumCOchVIt9Hlyc16MDZVUlWkNz0r7YwsRGy0MXhGe6Hds+4Ulkktax6jiZUss6BjAOhUhQF6CyDTbw4GvqmYPEs8l4lRmo4Q53AGemtreWvi8BzVAo6cTjetY231refIhIP1Uk0+L0knoFX2pAOrZ/kN68Z/ct0cJqDncO+DTqh6FHkbAsrxDa43bTDZ8FMeix41dTe3vmrON+Qfg84qW1LXk5IxbVVfjnfIhuKqbNi17msViN4zmJ3lISeqDvdjFZR/b/lnpAnrugC2uV28lvXiNQl7HV02f6adk5DGWCuE17+I4b1FmxKbtgux5mNsiZRKye7pyLNg5HB1nTFnWxwn8dAadqOwkWOaSGxxkkJLlj5s3/1/1FMddkTec75GSZlS6kqMHQi3ijKn1JVNkYfnMoM+OgHBCk374rJ9vQfl+QF/SVOban6Tn4QeOz8SrgJFCspAyyzOYF0rqRMdlVj+zMVhBzY55KEDiHdSVchf5bm8L0PjQzrXokLoVLndmlJluVtASUBSRsxidkjlrrrghldkwTD+RGEL88H1VOPkmm7qg9jdNGpsUNh6DYMpoGSPUjBVFO/svu60KUUCUGf4LAd/3E911hIHlk8rMvNPNgmg9rbNVRoCVpJgLU06aWA/54csW5Zu46qMiR8dAxTMytasOABqF8eLbx6W38DskZswg8suBKwvXckwWxFvZ+1ecFdD19cbs2SkRBy/qUXzSaGv25ZifC5ydiJdzA1LvJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(376002)(396003)(366004)(346002)(6512007)(8676002)(66476007)(66556008)(5660300002)(8936002)(86362001)(66946007)(478600001)(36916002)(6916009)(41300700001)(2906002)(186003)(6486002)(26005)(6506007)(4326008)(52116002)(6666004)(558084003)(316002)(54906003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wQX3q6lw0HYdCLCDZKrJgI/boHRBX9BMFazSbIYl6/sa7lINrF6LUnU3fdQq?=
 =?us-ascii?Q?hyOM358lakittXuuec3awo7UByk4h7yri1YNxc/wvj4WBfPfyQ7GgVku+gCe?=
 =?us-ascii?Q?+IcoKIU5USzSZH4OKbRnkEV+dAQCb02Zy3njaVZk5YCifXH2WV6ZToDusWnB?=
 =?us-ascii?Q?yopRDpoMhCv6uyouviP/QhM6eJnEPD9ecyTfJxSDkV7AbIY4/7f8I2RClWaP?=
 =?us-ascii?Q?taN0yL2dLEoV/+15eNnhLf+qEj+caqx8mmJ4ZrSMDEQg+EJnjmhHAqRv+bod?=
 =?us-ascii?Q?6zxdGQ9XhRGIE9hzfCjTRtkf7fCqOUUjlwbNd3Owvql9rre/tneDb56wzTOk?=
 =?us-ascii?Q?qWL5yEnCtedYVTRtzFij/lj1CRK6/g8Sz+EpPLxEmWuvWQ/WPLXNxZMtWs3J?=
 =?us-ascii?Q?QJBnJ2hYXhaoiEG3TOPnmob5952gMphH3QjnWSSNjAh0x0Qt8ytZ0vBV7R0m?=
 =?us-ascii?Q?VKbeclwJS3iKxUbXYBMsdzZ1h4iaSDB2MrHHApQvt+e+iNVupmUUR9QA0i44?=
 =?us-ascii?Q?9HNtJBPIw4pCjrzDNbqvRzys3Av6wQ6k2wM1sScM8Q1G/h0xDq6zuK0Beq9c?=
 =?us-ascii?Q?eKv95aqOy0MY69Dmt8FOIoldypVU47znmpnzuXHFcSQMOYFig6/3hIsLfMBM?=
 =?us-ascii?Q?840W30j27ISPYKb5DryCjlc019vhLkvVWRb1LHHzIRqKW9TPppywP3JP/neV?=
 =?us-ascii?Q?vpWGJ2oIOs20PY9bVZDewcwJMoBPuNs+pPo5R8OeO16fVG69DTSuH/1IlWmD?=
 =?us-ascii?Q?0H94lJrB1P8cbC36TkSxp76cact17DPTYlWWRAH8rPknQ+V+Nj6Se6A6pB0K?=
 =?us-ascii?Q?Pggz97IrV15XRsVeBlvMBHmI6VZAOVrEZrLalqi9QSNldYgCRVe5U7MwBNj9?=
 =?us-ascii?Q?Af+dQ1o7a4qS9QgGwhUQusaaYgmuwP1iziu0nTVebTWB9QiOwcqUsDc2YtEx?=
 =?us-ascii?Q?As4014YnEj9uenGJzIVFjvoh+HLo4iiHkw4NmXLs+d2JhA33RLPr3lxTsSuj?=
 =?us-ascii?Q?OUJLciFFIbZ9NrohqOCU802PzY9vgWL7GIj4YxS5nn2eLnTgsnPiIc3WEwNi?=
 =?us-ascii?Q?59ilXNX82YiSjJx9OnJVQ6F46LNHvGemzWr0tbIECGUTpWPs6jEnPpGz5+tC?=
 =?us-ascii?Q?hsDEVSZd4hkWhSc2VwF6zMMamopurpkgMAJAOA+Bx6u3nvYap+TaauNrJztT?=
 =?us-ascii?Q?/6QEa8AHAtsUBBiprNiNQExDZiGaSLN1pAT9hok3RGbp8QUtSJCHgKjTuPzz?=
 =?us-ascii?Q?CmKQjf0Crbd3FS+t3uFm5j+4ZQgTAer3lXJNUDRAsDRkHigA8cqhbZWJnRfY?=
 =?us-ascii?Q?/os9J2aVANk5SnENu16S2EWHHBXtBfu1ykPDf2cUQs/MkuE685uhXySl40jP?=
 =?us-ascii?Q?KLXAfnLosY3khKS95dttiyOCAc+budaXn4zCwBiAbQUG+kunkRrOo1Sr4HUo?=
 =?us-ascii?Q?NQJyf+l/79aDM0Vtw44bpBWbvIfQONXr/LeaJ2TTuJsFTJQZeB1TAf0fVKMm?=
 =?us-ascii?Q?zNx4fYVK46cL96KITsYIUMB1xbs77dMbfxrqu0ZV6AsdtRhoicXafYzbZm6t?=
 =?us-ascii?Q?SR+ugUO8UBc4BXQrPo+CHFRJFFaUSf+/HrIrzPd6qn6mETP3voCo6Shn88NY?=
 =?us-ascii?Q?/Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94aa77b5-15a5-4806-8eb8-08da606110c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:38:43.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OFNsPW7aGC2LYVesm5PnuwiG+itGm14HkMyBDlSt4J5EYMP9NBu6V9ou4JS9msUVKifTSW5rf8Nbucq1uhxHEAnSV0HVqa0dz/x1oONdug0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=915
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070085
X-Proofpoint-GUID: uGnJ70aMTuVjaiM4w1dqm9TUa2iXorZE
X-Proofpoint-ORIG-GUID: uGnJ70aMTuVjaiM4w1dqm9TUa2iXorZE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> I have a patchset with complete RSOC support with CDB mask. Even
> dynamic mask due to device configuration. It passes all RSOC related
> libiscsi tests.  If the community want it I may send it.

That would be great, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
