Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B02CC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 23:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA20207D8
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 23:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbgEXXqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 19:46:23 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:56778 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388266AbgEXXqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2020 19:46:23 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id E8A9B2733E;
        Sun, 24 May 2020 19:46:19 -0400 (EDT)
Date:   Mon, 25 May 2020 09:45:47 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     Daniel Wagner <dwagner@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v7 15/15] qla2xxx: Fix endianness annotations in source
 files
In-Reply-To: <2737709e-1423-da29-4697-dc517ad7e413@acm.org>
Message-ID: <alpine.LNX.2.22.394.2005250920550.8@nippy.intranet>
References: <20200518211712.11395-1-bvanassche@acm.org> <20200518211712.11395-16-bvanassche@acm.org> <20200519152401.oh6cewdru3fu7ogd@beryllium.lan> <alpine.LNX.2.22.394.2005201726250.8@nippy.intranet> <20200520085652.ps64ccmgjefc46cc@beryllium.lan>
 <alpine.LNX.2.22.394.2005211358460.8@nippy.intranet> <2737709e-1423-da29-4697-dc517ad7e413@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 24 May 2020, Bart Van Assche wrote:

> On 2020-05-23 21:28, Finn Thain wrote:
> > 2. The get_unaligned_le32() changes produce new pointer offsets in the 
> > assembly code for qla82xx_get_table_desc() and qla82xx_get_data_desc().
> > 
> > diff -ru /tmp/unpatched/qla_target.s /tmp/patched/qla_target.s
> > --- /tmp/unpatched/qla_target.s 2020-05-24 14:02:32.178019380 +1000
> > +++ /tmp/patched/qla_target.s   2020-05-24 14:01:43.487947966 +1000
> > @@ -12884,10 +12884,10 @@
> >         .cfi_offset 6, -16
> >         movq    %rsp, %rbp
> >         .cfi_def_cfa_register 6
> > -       subq    $32, %rsp
> > -       movq    %rdi, -24(%rbp)
> > -       movq    %rsi, -32(%rbp)
> > -       movq    -32(%rbp), %rax
> > +       subq    $64, %rsp
> > +       movq    %rdi, -56(%rbp)
> > +       movq    %rsi, -64(%rbp)
> > +       movq    -64(%rbp), %rax
> >         movl    52(%rax), %eax
> >         movl    %eax, -8(%rbp)
> >         movl    $24, -12(%rbp)
> > @@ -12895,62 +12895,62 @@
> >         cmpl    %eax, -12(%rbp)
> >         cmovbe  -12(%rbp), %eax
> >         movl    %eax, %edx
> > -       movq    -32(%rbp), %rax
> > +       movq    -64(%rbp), %rax
> >         movl    %edx, 52(%rax)
> > -       movq    -24(%rbp), %rax
> > +       movq    -56(%rbp), %rax
> > (and so on.)
> > 
> > Was this expected? I find it surprising...
> 
> The functions qla82xx_get_table_desc() and qla82xx_get_data_desc() exist 
> in qla_nx.c. Does the above diff perhaps refer to qla_nx.s instead of 
> qla_target.s?
> 

A similar effect can be seen in both qla_nx.s and qla_target.s.

> To me the change of "subq $32, %rsp" into "subq $64, %rsp" means that 
> the compiler reserved more space on the stack for local variables.
> 
> If I compare the assembler output for qla_nx.c then I see that 
> qla82xx_get_table_desc() gets inlined with my patch applied but not 
> without my patch applied. This is something that I had not expected but 
> that explains the above diff IMHO.
> 

Thanks for checking.

For completeness, here's the diff that produced the code generation 
changes in qla_nx.s and qla_target.s. These changes aren't the same as 
those in commit 7ffa5b939751 because these were intended to avoid 
perturbing line numbering etc.

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index ac54d2d1b02b..cff570b9c919 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1582,7 +1582,7 @@ qla82xx_get_data_desc(struct qla_hw_data *ha,
 	u32 section, u32 idx_offset)
 {
 	const u8 *unirom = ha->hablob->fw->data;
-	int idx = cpu_to_le32(*((u32 *)&unirom[ha->file_prd_off] + idx_offset));
+	int idx = get_unaligned_le32((int *)&unirom[ha->file_prd_off] + idx_offset);
 	struct qla82xx_uri_table_desc *tab_desc = NULL;
 	uint32_t offset;
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb15654bab33..856140564408 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2841,8 +2841,8 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		ctio->u.status1.sense_length =
 		    cpu_to_le16(prm->sense_buffer_len);
 		for (i = 0; i < prm->sense_buffer_len/4; i++)
-			((uint32_t *)ctio->u.status1.sense_data)[i] =
-				cpu_to_be32(((uint32_t *)prm->sense_buffer)[i]);
+			put_unaligned_le32(get_unaligned_be32(&((uint32_t *)prm->sense_buffer)[i]),
+				&((uint32_t *)ctio->u.status1.sense_data)[i]);
 
 		qlt_print_dif_err(prm);
 
