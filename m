Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F223CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Jan 2022 09:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346457AbiAGJbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Jan 2022 04:31:35 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24700 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236635AbiAGJbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2022 04:31:34 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2072lPq7011035;
        Fri, 7 Jan 2022 09:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=b/dps/iyX/7tVlGeLrT5KnosResrTMcFkjrEJ2MsD8E=;
 b=n1JhBxZAub4+ZifGhcEOFjvr9YQ0dPFczIytZco44OZlB8xlvbVcfuhoS5msSeUeM2hz
 s++2gYyiCH8E2Z5GsF5bqMgUvdMmU+MCvxBiZpBzndGSWEF8k9sZwhRoIkGy5y4d7cSC
 XHXuIz4vNg9CK64IINUd0cQCWELohYQDmEZrEXRtT3jMpD/HYcBCVRGpSF+iaYgZcAOK
 TNrQynKYafnsohvy1DY4tdulb/vUmnwnN7ctVO4gdFRnru8egMe1QZn2z/KSvKn0eMhs
 7oiDCAAxa/6nZt5wp5VIK0guec+WHFeFXDuV/MIv73/Z79LAN9liw/9xx+wyVEEyyo+z qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4vb9gxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 09:31:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2079UESC176843;
        Fri, 7 Jan 2022 09:31:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3de4w2tu1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 09:31:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BILVk466nJiGxAfXu8AQ3ByfuqrggK6sopIyB4Sab5yF6ZE/kgtlaMJ7F05jaEZm1OmYZxIXcYD3x56N5yi1qFRmyNg8n9lf2FBMLFfoFNnW2nfV7MtAOZpcKOCak1CVyaa1xcPZ8gGv6juzkPsSN6RjaT/IVLAacK6g1Zyuh0lYVHlIjj8FjVmyRk9/yOedWtR2Msyu0wmfAjJqoCjxaI0wAb/4p9prYJpxCZ9R/tWKikv7/7tApfbEADRwe6watRopQx11lmU59h6iOEcx5lgwpCfLrnBZ/oj9BuMCBVkRELvblqXn7T/WV1lB1QE/fStsaAEcCO4QuwuKsO5YDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/dps/iyX/7tVlGeLrT5KnosResrTMcFkjrEJ2MsD8E=;
 b=McgwqXLpSlLIeZxsDPxyF1xJQ5YnJwxphEqCGJ/m2peNc+8nq/ioYUgrEwKZ7/D9xptJABu+n0H++KG7Q4AvOx8Y9zpPRQkXAXKz6uSSuOpdWy6N25aBD+/CkB7Jo51hugX68YRj3bUxSv/FDCJkTcENBm4X//2hmKVRSPzc4iMOpyBoOHj8SGUcjkeBF/cXCFXuxpNIb8eK9aHHOUsWTSlsqf+CD9xQadwx88uJ74m/Tw6EmPJVBG7I0kSWN97ukZ00qbkfMR0vWQykdc9froMQHE6+xH9V6nAtc+mV5gR+g2noUnprm8nbJH7FonupYiiLvJmH/ga+ejyqZPXYFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/dps/iyX/7tVlGeLrT5KnosResrTMcFkjrEJ2MsD8E=;
 b=NK/Y9sXPOMrUoNyTdkClXe0vMTgaZqLS4HmEoGKqq8Ltih87i3vANpg9mlBiQ2smKARAytEUBNB9PadA+7S5r1gozemje1u0ukc6ztntOwfwX/wRUPvUzwMIh6jL8zjfrikeqaqIonEEylAM29qoh64bDlzB8pVyb6UN+LvrxaU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2317.namprd10.prod.outlook.com
 (2603:10b6:301:35::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 09:31:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 09:31:24 +0000
Date:   Fri, 7 Jan 2022 12:31:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Terminate string in
 lpfc_debugfs_nvmeio_trc_write()
Message-ID: <20220107093103.GR7674@kadam>
References: <20211214070527.GA27934@kili>
 <fca6717d704ffa33cfd9d3cba519da8705195858.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fca6717d704ffa33cfd9d3cba519da8705195858.camel@linux.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bff4a8cb-39de-43d0-06e3-08d9d1c078fb
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2317:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2317E4C56C0655EC16C88CD18E4D9@MWHPR1001MB2317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5X10wmhieIuu+w9reRaFKp4VjZXLDyoOtkDg8Le7H7O2lQ04VoAKarVqJmGeGyLiIcmHgmZgC1tWSC0qRiwRUSy+p/nUd9oxZru3r90NzOecfqtHAmEXZQKhqeXsYqoEY0BkdgzH/TD5oJu75/LCf18DMDcp6tW4bojzo29iHfxgTJ+kbBAhqqPCUrkMGbsYgynsb3QSxsu3wQQNFlnc2Hd7L5G/ZiqNlGRtss4dayEki8GT2zxfX5s4MyWFuBe/09WiYfgFE2WizPo0OUmbH6UvVEdX+6fl/stEBoK2uuf/MowVu6maRe4R6ozEgqiLqivMsEmwiZlSERHYZW4v6o4GJLuMzJc3AKEMGBXBAQ3FSRGHjGlk/gH53bmh9IIT2iPK2Y024svI7Mlu1htjSGqgvXq77LE3y1xsam7cR+caUhjIN+w2jxZd/GHgSB28k4OfNd+J7RE6ZbPQBsp1hU7LKCSmd90DBUhUJhggEVBI9cvgbnMfmz2De8xn0yzp1i4rQ+lrNNr/BuVa6Bz/R8xWliFv2pkpIKkCL2ivPk1DN7+TYURuDqRVYhbiv9IkW2yPwfzlweZJ9XxGtKxzkIuGelZmQnVKO4p0obi26nq5J08YuvaBXDp3xxWveXL60IEnbGmPJW6nyTp00YJGG/+ssDubO9eKCdhvGg9fKugmmyJa3ReoD4LP+tjwjQ0NZ4UH2HWkvxYeIxcrGhUCUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(4001150100001)(9686003)(4326008)(1076003)(6506007)(6512007)(8676002)(316002)(44832011)(52116002)(66556008)(66946007)(6486002)(8936002)(508600001)(2906002)(6916009)(86362001)(38350700002)(66476007)(38100700002)(33716001)(54906003)(186003)(6666004)(5660300002)(33656002)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ANe76WUaAqr/BeOG6efggaZe3+CvD6N/hiXcGppDaby0kHO7coNhXMuuVUV8?=
 =?us-ascii?Q?cj9d7PQGRNwhqsyT63dUNtlCfoW+NUBLy/XtY9ootr4M+ahItynTiZm1yI7e?=
 =?us-ascii?Q?YLuZuLzY/Y5wVODttgn3nDw0nFJTLWlBD7Ls6lp2WxtL8IGnEPdQ9rGp16w3?=
 =?us-ascii?Q?GsC+ehRxLf6XIi7edGOk5Jy12Re+KSHNlVzsWLs8V/4p4gxJCBRGVb04dz3P?=
 =?us-ascii?Q?z18vUcwMfLO/FAixm6dNjgLEvPIgsZP19RC/P93OQ5U/rN1jqHJ6VJdpxUKl?=
 =?us-ascii?Q?nkCGcH0bBnAQYwA79JclvUSr35bQ9gn//Euk3DsgRvvyrk1U1dLkMy5vxGF9?=
 =?us-ascii?Q?f5QKKJnvidBf8kzy8d8rD/UgfUlieySVytJfcaCNdx6obXUSd4iHNnP9d71T?=
 =?us-ascii?Q?NGgX9y0NLfkvKnqPQ2135KrNx28eLUiASe3MmR7npXhUQ5B54LSOzLI9gfHI?=
 =?us-ascii?Q?VRrc7uUsOeX7imoL8TrhQdc9woDUBRXSn1cfnxExs3QnTho0AUBtyUJGOXya?=
 =?us-ascii?Q?U0+BJz5OEl2ewWHq06i7kQd+MOLxYGcSv+njJxp4AzSwpeV06VRWG2dviIkI?=
 =?us-ascii?Q?gtE8Id3WK3gAii03FTjUx30jcnHViADgs5ZJzOUnyxsG1YM6/ii58JUf18LA?=
 =?us-ascii?Q?geZvbnivmBh+kw07IBfW0/VG/kBuElmm8LFHmcmVJfPH5bRLP/OKjreDHQbE?=
 =?us-ascii?Q?3WsTZjHHLvkvyGO97RNJoAwK4YT7ov0VzG1unuk4mrVO/rKvImGECe7fwpW4?=
 =?us-ascii?Q?dh+2B38n0NDyDCMqTxvd9OKKfz9N1yMIny6J9Wrs6i1JaPPIETBuo+u412x2?=
 =?us-ascii?Q?3cCAIZ7+C+i31H5nSoa3YzaST0Dhs9vwc7YbCNaEWvWuZZEkTwg6Yy1j3+qu?=
 =?us-ascii?Q?gwOk5RLpWvH2Kq7kYHzeQV6srLKC/sB+6JCLEamZh1etjm80mDmD9d9B7zXT?=
 =?us-ascii?Q?0XEY/z/WkvWmFdKpGUl5zmcJRPJ59ZUIiNyVht6I4g43eaNq6LnWBwXmRyDO?=
 =?us-ascii?Q?bXCDXuIeFLyuTX0bABPFFjVIRo5TLHWMkMaNN/mbuzkFmduVyBOEsRSyHnHM?=
 =?us-ascii?Q?y1Rlyww4L7LJpMPKYRs1vknM4+LR9BPmdoqWqanVTTeqCkAALdsb6apfCwZJ?=
 =?us-ascii?Q?JIplovQS5RQC9MpQxXeU3RbBFy3HYAk2O6rgYRDzZuk3lznaLXXp/4AzBu+4?=
 =?us-ascii?Q?+IslMXsrWdv5L+qzreTXbiOq7E+XPeOMUrW7FXs1tS0a4P6ZWZG34BtiTC5U?=
 =?us-ascii?Q?mFq/eNtVLmBwWZTWIP52KWV5iw6OfgUYUv1GgVPiKG4vxBcSC43pJ1nQI6bx?=
 =?us-ascii?Q?T3z0+dT4ILCmRy0jOyiTeicYLrkMvtHzAdeCMc2B3hbsVnhxb3E+UkxQV9yt?=
 =?us-ascii?Q?ezdyto9dkUGpsa5286xeUyrleinlka1UxBuP3umV+Qz64lFMM6S1zS8quD0a?=
 =?us-ascii?Q?a6jydQs12jY3Y/pLwOEcGgRBebQDYN1JYV5Kv/ki5ggSyHx2YZfzw9X3/1JV?=
 =?us-ascii?Q?tCYZtmCo9QRb53s6CpCtBIOAym8UeiLFA7tXJPGkSbWfdSonlEDrEfD1fTaV?=
 =?us-ascii?Q?VMYB/dIKoaYQWtfQDnFvlaq93lptaNYrgR2LA9WIXbhfhSPhEGkf14G9jf2M?=
 =?us-ascii?Q?TEWzSWOOhrD+HkM2VzOzYgk6kUX8HQ/O09sgM8Uch7UrIz/zKnH9THP0eT4/?=
 =?us-ascii?Q?TqiM4UqUGrDJ17u3sdn0rzN1q18=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff4a8cb-39de-43d0-06e3-08d9d1c078fb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 09:31:24.5622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVYb5B7FYFd+G+b0dk10G/OTGSMXOXUXxDtB+yD0H/6QybQl1ZUIeH+TMFnr0AZa5sKiG47W9wJzGkUaspONV5QwQXrl092YGNFYaMaaI/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2317
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070068
X-Proofpoint-ORIG-GUID: vhblnDqOhXn1njzK3HRKKrvcTgawQZPY
X-Proofpoint-GUID: vhblnDqOhXn1njzK3HRKKrvcTgawQZPY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 31, 2021 at 09:55:00AM -0500, James Bottomley wrote:
> On Tue, 2021-12-14 at 10:05 +0300, Dan Carpenter wrote:
> > The "mybuf" string comes from the user, so we need to ensure that it
> > is NUL terminated.
> > 
> > Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs
> > support")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/scsi/lpfc/lpfc_debugfs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c
> > b/drivers/scsi/lpfc/lpfc_debugfs.c
> > index 21152c9a96ef..30fac2f6fb06 100644
> > --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> > +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> > @@ -2954,8 +2954,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file
> > *file, const char __user *buf,
> >  	char mybuf[64];
> >  	char *pbuf;
> >  
> > -	if (nbytes > 64)
> > -		nbytes = 64;
> > +	if (nbytes > 63)
> > +		nbytes = 63;
> 
> Just for future reference, next time could we do
> 
> if (nbytes > sizeof(mybuf) - 1)
>         nbytes = sizeof(mybuf) - 1;
> 
> just so we minimize the possibility of screw ups in the unlikely event
> that someone reduces the size of the mybuf array?

Yeah.  Good point.  Will do that next time.

regards,
dan carpenter

