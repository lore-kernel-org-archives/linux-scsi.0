Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5312BC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 15:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F58208B3
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 15:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgFPP03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 11:26:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728919AbgFPP02 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 11:26:28 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GF1e4I076629;
        Tue, 16 Jun 2020 11:26:25 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31ptqknbvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 11:26:25 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GFKaQj017382;
        Tue, 16 Jun 2020 15:26:24 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 31pckfwug1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 15:26:24 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GFQOfl55050652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 15:26:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13BBA112061;
        Tue, 16 Jun 2020 15:26:24 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66073112062;
        Tue, 16 Jun 2020 15:26:21 +0000 (GMT)
Received: from kashyyyk (unknown [9.85.142.192])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Jun 2020 15:26:20 +0000 (GMT)
Date:   Tue, 16 Jun 2020 12:26:14 -0300
From:   "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Nilesh Javali <njavali@marvell.com>, maurosr@linux.ibm.com
Subject: Re: Regarding - Patch - Fix crash on qla2x00_mailbox_command
Message-ID: <20200616152614.GA2645171@kashyyyk>
References: <DM6PR18MB30346814DE1F5807188A844CD2B80@DM6PR18MB3034.namprd18.prod.outlook.com>
 <DM6PR18MB3034B8373D1AF280C18593CCD2B60@DM6PR18MB3034.namprd18.prod.outlook.com>
 <CALJn8nNv3pEF2G3AfukziYZ2W8Hb94iguY=TUfxnKYsbjBrBiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALJn8nNv3pEF2G3AfukziYZ2W8Hb94iguY=TUfxnKYsbjBrBiA@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_04:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 cotscore=-2147483648 suspectscore=1 phishscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 mlxscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160107
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Saurav,

I've reopened the internal bugzilla so we can check what's going on.

Do you have a script to reproduce the issue you're seeing so our team can try to
reproduce it?

From what I've read at the internal bz, this issue was quite consistent to
reproduce on our boxes, I suspect that you might not be able to reproduce it
because it was related to EEH mechanism in power architecture, I'm sorry that
information isn't mentioned in the commit message. 

The trace seen at the time was:

38:mon> e
cpu 0x38: Vector: 300 (Data Access) at [c000003fe22872f0]
pc: c00800001382727c: qla2x00_mailbox_command+0x93c/0x1520 [qla2xxx]
lr: c0080000138272cc: qla2x00_mailbox_command+0x98c/0x1520 [qla2xxx]
sp: c000003fe2287570
msr: 9000000000009033
dar: 0
dsisr: 40000000
current = 0xc000003fe2241700
paca    = 0xc000000007a46800	 softe: 0	 irq_happened: 0x01
pid   = 779, comm = eehd
Linux version 4.14.0-49.1.1.el7a.ppc64le
(mockbuild@ppc-048.build.eng.bos.redhat.com) (gcc version 4.8.5 20150623
(Red Hat 4.8.5-28) (GCC)) #1 SMP Tue Apr 10 08:31:02 UTC 2018
38:mon> t
[c000003fe22876c0] c008000013834bb4 qla2x00_dump_ram+0xf4/0x220 [qla2xxx]
[c000003fe22877b0] c00800001389e280 qla25xx_read_optrom_data+0x230/0x390 [qla2xxx]
[c000003fe2287880] c008000013824da0 qla81xx_nvram_config+0xb0/0xb60 [qla2xxx]
[c000003fe2287930] c0080000138222f4 qla2x00_abort_isp+0x204/0x900 [qla2xxx]
[c000003fe2287a20] c0080000138023bc qla2xxx_pci_slot_reset+0x21c/0x600 [qla2xxx]
[c000003fe2287ab0] c00000000004b724 eeh_report_reset+0x184/0x1c0
[c000003fe2287af0] c000000000048f18 eeh_pe_dev_traverse+0x98/0x170
[c000003fe2287b80] c00000000004bcc4 eeh_handle_normal_event+0x564/0x650
[c000003fe2287c60] c00000000004bf74 eeh_handle_event+0x54/0x380
[c000003fe2287d10] c00000000004c69c eeh_event_handler+0x14c/0x210
[c000003fe2287dc0] c000000000171c88 kthread+0x168/0x1b0
[c000003fe2287e30] c00000000000b528 ret_from_kernel_thread+0x5c/0xb4

I'll see if our team can get more information on the specific data structure.

Thank you,

Mauro

On Wed, Jun 03, 2020 at 12:24:22AM -0300, Guilherme G. Piccoli wrote:
> IIRC Rodrigo's email does not work anymore...looping Mauro, he should
> be able to forward to appropriate folks at IBM.
> Cheers,
> 
> 
> Guilherme
> 
> 
> On Wed, May 20, 2020 at 3:33 AM Saurav Kashyap <skashyap@marvell.com> wrote:
> >
> > Hi Rodrigo,
> > Any updates on this?
> >
> > Thanks,
> > ~Saurav
> >
> > > -----Original Message-----
> > > From: Saurav Kashyap
> > > Sent: Monday, May 18, 2020 12:20 PM
> > > To: rosattig@linux.vnet.ibm.com
> > > Cc: linux-scsi@vger.kernel.org; Arun Easi <aeasi@marvell.com>; Girish Basrur
> > > <gbasrur@marvell.com>; Nilesh Javali <njavali@marvell.com>
> > > Subject: Regarding - Patch - Fix crash on qla2x00_mailbox_command
> > >
> > > Hi  Rodrigo,
> > > We are seen regression introduced by below patch for QLA 82XX HBAs. On
> > > unload, the disable interrupt, mailbox command (MBX 0x10) fails because of
> > > this patch and leaves the FW/HW in unstable state. The next load fails with
> > > initialization FW timing out.
> > > The only way out of this is to reboot the server. I  and  test team have tried to
> > > reproduce an original problem that is fixed by below patch but we don't have
> > > any luck.
> > >
> > > We would like to revert the below patch but would like to address original
> > > problem as well. Can you share more details about the NULL pointer
> > > dereference? Which data structure was NULL and what was the test case?
> > >
> > > ==============================
> > > git show 3cb182b3fa8b7a61f05c671525494697cba39c6a
> > > commit 3cb182b3fa8b7a61f05c671525494697cba39c6a
> > > Author: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
> > > Date:   Mon May 28 14:58:44 2018 -0300
> > >
> > >     scsi: qla2xxx: Fix crash on qla2x00_mailbox_command
> > >
> > >     This patch fixes a crash on qla2x00_mailbox_command caused when the
> > > driver
> > >     is on UNLOADING state and tries to call qla2x00_poll, which triggers a
> > >     NULL pointer dereference.
> > >
> > >     Signed-off-by: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
> > >     Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
> > >     Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> > >     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > >
> > > diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> > > index d8a36c1..7e875f5 100644
> > > --- a/drivers/scsi/qla2xxx/qla_mbx.c
> > > +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> > > @@ -292,6 +292,14 @@ static int is_rom_cmd(uint16_t cmd)
> > >                         if (time_after(jiffies, wait_time))
> > >                                 break;
> > >
> > > +                       /*
> > > +                        * Check if it's UNLOADING, cause we cannot poll in
> > > +                        * this case, or else a NULL pointer dereference
> > > +                        * is triggered.
> > > +                        */
> > > +                       if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags)))
> > > +                               return QLA_FUNCTION_TIMEOUT;
> > > +
> > >                         /* Check for pending interrupts. */
> > >                         qla2x00_poll(ha->rsp_q_map[0]);
> > > ====================
> > >
> > > Thanks,
> > > ~Saurav
