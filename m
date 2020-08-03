Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415E8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D1A5206F6
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 05:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgHCFvr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 01:51:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60308 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728142AbgHCFvr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 01:51:47 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0735bAta155429;
        Mon, 3 Aug 2020 01:51:37 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32pcc30f4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 01:51:37 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0735nsR9013882;
        Mon, 3 Aug 2020 05:51:37 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 32nxe44gx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 05:51:37 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0735pWT031457568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Aug 2020 05:51:32 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E06E7805F;
        Mon,  3 Aug 2020 05:51:36 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 079C67805C;
        Mon,  3 Aug 2020 05:51:34 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.201.133])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  3 Aug 2020 05:51:34 +0000 (GMT)
Message-ID: <1596433893.4087.34.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: esas2r: fix possible buffer overflow caused by
 bad DMA value in esas2r_process_fs_ioctl()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jia-Ju Bai <baijiaju@tsinghua.edu.cn>, linuxdrivers@attotech.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 02 Aug 2020 22:51:33 -0700
In-Reply-To: <81351eab-69c0-89dc-4e58-146a005b5929@tsinghua.edu.cn>
References: <20200802152145.4387-1-baijiaju@tsinghua.edu.cn>
         <1596383240.4087.8.camel@linux.ibm.com>
         <81351eab-69c0-89dc-4e58-146a005b5929@tsinghua.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_04:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0
 suspectscore=18 lowpriorityscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-08-03 at 11:07 +0800, Jia-Ju Bai wrote:
> 
> On 2020/8/2 23:47, James Bottomley wrote:
> > On Sun, 2020-08-02 at 23:21 +0800, Jia-Ju Bai wrote:
> > > Because "fs" is mapped to DMA, its data can be modified at
> > > anytime by malicious or malfunctioning hardware. In this case,
> > > the check "if (fsc->command >= cmdcnt)" can be passed, and then
> > > "fsc->command" can be modified by hardware to cause buffer
> > > overflow.
> > 
> > This threat model seems to be completely bogus.  If the device were
> > malicious it would have given the mailbox incorrect values a priori
> > ... it wouldn't give the correct value then update it.  For most
> > systems we do assume correct operation of the device but if there's
> > a worry about incorrect operation, the usual approach is to guard
> > the device with an IOMMU which, again, would make this sort of fix
> > unnecessary because the IOMMU will have removed access to the
> > buffer after the command completed.
> 
> Thanks for the reply :)
> 
> In my opinion, IOMMU is used to prevent the hardware from accessing 
> arbitrary memory addresses, but it cannot prevent the hardware from 
> writing a bad value into a valid memory address.

I think that's what I said above.  It would give us a bad a priori
value which copying can't help with.

> For this reason, I think that the hardware can normally access 
> "fsc->command" and modify it into arbitrary value at any time,
> because IOMMU considers the address of "fsc->command" is valid for
> the hardware.

Not if we suspected the device.  I think esas2r does keep the buffer
mapped, but if we suspected the device we'd only map it for the reply
then unmap it.

The point I'm making is we have hardware tools at our disposal to
corral suspect devices if need be, but they're really only used in
exceptional VM circumstances.  Under ordinary circumstances we simply
trust the device.  So if you had evidence that esas2r were prone to
faults, we'd usually force the manufacturer to fix the firmware and as
a last resort we might consider corralling it with an iommu we wouldn't
just copy some values.

If you want an example of defensive coding, we had to add a load of
checks to TPM devices to cope with the bus interposer situation. 
That's one case where we no longer trust the device to return correct
information.  However, to do the same for any SCSI device we'd need a
convincing rationale for why.

James

