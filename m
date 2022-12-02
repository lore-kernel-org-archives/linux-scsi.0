Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268D0C47088
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 14:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiLBOSM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 09:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiLBOSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 09:18:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D265D89AD5
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2022 06:18:09 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2DwlOp010111;
        Fri, 2 Dec 2022 14:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=dq71MKxt4KXv4ujs3VF9eIuEAxmWkz6SJT1d/XQy5Y0=;
 b=RMG+hGepzhhhYx0ixbIkN9l65sGhrJTghTBCyZo9DtWeGA800+8yj8khzStbGEeUO/MT
 pqxJWfDGkmTC5Ou0/ZSrA2pC+Gkyp+lVD3UgPAPjC2il45hm3WvqyWKy0AzJyJ7W99SO
 aMYoqTHY5jiSzgVXA8hr67I2dpQYVQ1fbTp6SXNPTu5aWg3sFniyc2yhCftfPLTFE1FL
 idGRkVD0ppNGqeLP53r1cYuiHgu+dofsELJpHMuxQcTacA33ZvBWWI8kChDawLG1A1lE
 adZcccqmgwh5ea61n9wz1GJIB2YMAmCZU5+bpa6A0G2ZO9srabTQf9PCwx8ZBqZCo1yM sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7jqngg4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 14:17:49 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2E0GmC015264;
        Fri, 2 Dec 2022 14:17:48 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7jqngg4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 14:17:48 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2E5YOq027326;
        Fri, 2 Dec 2022 14:17:48 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma01wdc.us.ibm.com with ESMTP id 3m3aea25qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 14:17:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com ([9.17.130.235])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2EHkdJ56361272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 14:17:47 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E22CD7805E;
        Fri,  2 Dec 2022 15:27:41 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 670277805C;
        Fri,  2 Dec 2022 15:27:40 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.83.181])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Dec 2022 15:27:39 +0000 (GMT)
Message-ID: <d9d1f5da091895e2cb3fd17e5c49f2c25687f72b.camel@linux.ibm.com>
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Wenchao Hao <haowenchao@huawei.com>,
        Wenchao Hao <haowenchao22@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linfeilong@huawei.com,
        yanaijie@huawei.com, xuhujie@huawei.com, lijinlin3@huawei.com
Date:   Fri, 02 Dec 2022 09:17:43 -0500
In-Reply-To: <7fb4c882-c332-551c-8980-9b07ae9519dd@huawei.com>
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
         <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
         <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com>
         <70f4d744d64bc075138128a7a98b7186375170d8.camel@linux.ibm.com>
         <CAOptpSPfswNrmYe4rnKFM3zWXY7P0JuWY94p=mfp7tV9ghFQ2w@mail.gmail.com>
         <f2e3c4dc0bfad6b05f40d716738e56f2cbb80810.camel@linux.ibm.com>
         <7fb4c882-c332-551c-8980-9b07ae9519dd@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sblPG8Lh3VtLYCL_T-0--9sxMtZXedbg
X-Proofpoint-GUID: g-HChF0bfFYJeFGh_YDXRBH7KpBnejxC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_06,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-12-02 at 21:58 +0800, Wenchao Hao wrote:
> 
> On 2022/11/29 2:12, James Bottomley wrote:
> > On Tue, 2022-11-29 at 01:38 +0800, Wenchao Hao wrote:
> > > On Mon, Nov 28, 2022 at 11:24 PM James Bottomley
> > > <jejb@linux.ibm.com>
> > > wrote:
> > > > 
> > > > On Mon, 2022-11-28 at 22:41 +0800, Wenchao Hao wrote:
> > > > > On 2022/11/28 20:52, James Bottomley wrote:
> > > > > > On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
> > > > [...]
> > > > > > > We found some firmware or drivers would return status
> > > > > > > which
> > > > > > > did not defined in SAM. Now SCSI middle level do not have
> > > > > > > an
> > > > > > > uniform behavior for these undefined status. I want to
> > > > > > > change
> > > > > > > the logic to return error for all status which did not
> > > > > > > defined in SAM or define a method in host template to let
> > > > > > > drivers to judge what to do in this condition.
> > > > > > 
> > > > > > Why? The general rule of thumb is be strict in what you
> > > > > > emit
> > > > > > and generous in what you receive (which is why reserved
> > > > > > bits
> > > > > > are ignored). Is the drive you refer to above not working
> > > > > > in
> > > > > > some way, in which case detail it so people can understand
> > > > > > the
> > > > > > actual problem.
> > > > > > 
> > > > > > James
> > > > > > 
> > > > > > .
> > > > > 
> > > > > 
> > > > > We come with an issue with megaraid_sas driver. Where
> > > > > scsi_cmnd
> > > > > is completed with result's status byte set to 1,
> > > > 
> > > > Megaraid_sas is an emulation driver for the most part, so it
> > > > sounds
> > > > like this is in the RAID emulation firmware, correct?  The
> > > > driver
> > > > can correct for emulation failures, if you can figure out what
> > > > it's
> > > > trying to signal and convert it to the correct SAM error code.
> > > > There's no need to change anything in the layers above.  If you
> > > > can't figure out the translation and you want the transfer to
> > > > error, then add DID_ERROR, which is a nice catch all.  If this
> > > > is
> > > > transient and could be fixed by a retry, then do DID_SOFT_ERROR
> > > > instead.
> > > > 
> > > > James
> > > > 
> > > 
> > > Thanks for your answer, Of curse we can recognize these undefined
> > > status and map to an error which can be handled by SCSI middle
> > > level
> > > now. But I still confused why shouldn't we change the
> > > scsi_status_is_good() to respect to SAM?
> > 
> > Because it wouldn't be backwards compatible and something might
> > break.
> > Under SCSI-1, devices were allowed to set this bit to signal vendor
> > unique status and a lot of manufacturers continued doing this for
> > SCSI-
> > 2, even though it was flagged as reserved instead of vendor
> > specific in
> > that standard, hence the mask.  Since this was over 20 years ago,
> > it is
> > possible there is no remaining functional device that does this,
> > but if
> > it's not causing a problem, why take the risk?
> > 
> > James
> > 
> > .
> 
> Hi James, thank you very much for your answer.
> 
> I think we should think about the following functions of megaraid
> driver:
> 
> megasas_complete_cmd() defined in
> drivers/scsi/megaraid/megaraid_sas_base.c,
> megasas_complete_cmd
>         ...
>         switch (hdr->cmd) {
>         ...
>         case MFI_CMD_LD_READ:
>         case MFI_CMD_LD_WRITE:
>                 switch (hdr->cmd_status) {
>                 case MFI_STAT_SCSI_DONE_WITH_ERROR:
>                         cmd->scmd->result = (DID_OK << 16) | hdr-
> >scsi_status;
>                         break;
>                 ...
>                 }
>         ...
>         }
> 
> map_cmd_status() defined in
> drivers/scsi/megaraid/megaraid_sas_fusion.c 
> map_cmd_status
>         ...
>         switch (status) {
>         ...
>         case MFI_STAT_SCSI_DONE_WITH_ERROR:
>                 scmd->result = (DID_OK << 16) | ext_status;
>                 break;
>         ...
>         }
> 
> Both of these functions did not check the status byte, which can not
> make sure the status byte is defined in SAM.

Right, but the first one should be returning actual status from the
drive, so should be OK.  The second one looks to be returning
manufactured raid status, which is likely the problem.

in either case, just fix the code to return DID_ERROR<<16 if the status
is non SAM conforming.

> What we meet is the status byte set to 1, and the host_byte is set to
> DID_OK.
> 
> In this condition, the scsi_cmnd would be finished by scsi middle
> layer with BLK_STS_OK if the kernel version is before 3d45cefc8edd7
> (scsi: core: Drop obsolete Linux-specific SCSI status codes).

I don't believe it does: that commit should produce identical code
before and after; it merely replaced the shifted status conditions with
the unshifted ones.

> Because scsi_io_completion_nz_result() would return a non zero value,
> so we call scsi_io_completion_action() to handle this command.
> While in scsi_io_completion_action(), the blk_stat mapped by
> scsi_result_to_blk_status()
> is BLK_STS_OK which finally result in the command finished with
> BLK_STS_OK.


So as I said previously, get the driver to return DID_ERROR<<16 for the
bogus SAM conditions.

James

