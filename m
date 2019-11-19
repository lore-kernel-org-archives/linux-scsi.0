Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67682C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 18:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43E3D2231A
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 18:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKSSOj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 13:14:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:48234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbfKSSOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 13:14:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 87068AF22;
        Tue, 19 Nov 2019 18:14:36 +0000 (UTC)
Date:   Tue, 19 Nov 2019 19:14:35 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Move work items to a stack list
Message-ID: <20191119181435.taxa56wbf4zd4f2f@beryllium.lan>
References: <20191105080855.16881-1-dwagner@suse.de>
 <yq1h838pivf.fsf@oracle.com>
 <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
 <4a1fedc9-03f1-7312-fd50-a041a78c0294@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a1fedc9-03f1-7312-fd50-a041a78c0294@broadcom.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Tue, Nov 19, 2019 at 09:25:54AM -0800, James Smart wrote:
> On 11/19/2019 5:28 AM, Daniel Wagner wrote:
> > On Tue, Nov 12, 2019 at 10:15:00PM -0500, Martin K. Petersen wrote:
> > > > While trying to understand what's going on in the Oops below I figured
> > > > that it could be the result of the invalid pointer access. The patch
> > > > still needs testing by our customer but indepent of this I think the
> > > > patch fixes a real bug.
> > I was able to reproduce the same stack trace with this patch
> > applied... That is obviously bad. The good news, I have access to this
> > machine, so maybe I able to figure out what's the root cause of this
> > crash.
> 
> fyi - Dick and I were taking our time reviewing your patch as the major
> concern we had with it was that the splice and then the re-add of the
> work-list could have an abort complete before the IO, which could lead to
> DC.

I think there is potentially a bug. The crash I see might not be
related to my attempt here to fix it. After looking at it again, it
looks a bit ugly and over complex compared to what should do the trick:

@@ -3915,6 +3915,9 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 				 cq_event, struct lpfc_cq_event, list);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
+		if (!cq_event)
+			break;
+
 		switch (bf_get(lpfc_wcqe_c_code, &cq_event->cqe.wcqe_cmpl)) {
 		case CQE_CODE_COMPL_WQE:
 			irspiocbq = container_of(cq_event, struct lpfc_iocbq,

> We'll look anew at your repro.

Thanks a lot.

Anyway, I tried to gather some more data on it.

(gdb)  l *lpfc_sli4_io_xri_aborted+0x29c
0xa1f2c is in lpfc_sli4_io_xri_aborted (drivers/scsi/lpfc/lpfc_scsi.c:543).
538                             }
539     #endif
540                             qp->abts_scsi_io_bufs--;
541                             spin_unlock(&qp->abts_io_buf_list_lock);
542
543                             if (psb->rdata && psb->rdata->pnode)
544                                     ndlp = psb->rdata->pnode;
545                             else
546                                     ndlp = NULL;
547

I looked at the assembler code and if I am not completely mistaken it
is 'psb->rdata' which triggers the KASAN dump.

So I though let's reset psb->rdata when the buf is freed in order to
avoid the report. So this was just to find out if my theory holds.

ff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ba26df90a36a..8e3a05e44d76 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -791,10 +791,12 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
        if (psb->flags & LPFC_SBUF_XBUSY) {
                spin_lock_irqsave(&qp->abts_io_buf_list_lock, iflag);
                psb->pCmd = NULL;
+               psb->rdata = NULL;
                list_add_tail(&psb->list, &qp->lpfc_abts_io_buf_list);
                qp->abts_scsi_io_bufs++;
                spin_unlock_irqrestore(&qp->abts_io_buf_list_lock, iflag);
        } else {
+               psb->rdata = NULL;
                lpfc_release_io_buf(phba, (struct lpfc_io_buf *)psb, qp);
        }
 }

Unfortunatly, this didn't help and instead I got a new KASAN report instead:

[  167.006341] ==================================================================
[  167.006428] BUG: KASAN: slab-out-of-bounds in lpfc_unreg_login+0x7c/0xc0 [lpfc]
[  167.006434] Read of size 2 at addr ffff88a035f792e2 by task lpfc_worker_3/1130
[  167.006435] 
[  167.006444] CPU: 4 PID: 1130 Comm: lpfc_worker_3 Tainted: G            E     5.4.0-rc1-default+ #3
[  167.006447] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 07/21/2019
[  167.006449] Call Trace:
[  167.006463]  dump_stack+0x71/0xab
[  167.006535]  ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
[  167.006545]  print_address_description.constprop.6+0x1b/0x2f0
[  167.006615]  ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
[  167.006684]  ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
[  167.006688] sd 7:0:0:0: alua: port group 3e9 state N non-preferred supports TolUsNA
[  167.006693]  __kasan_report+0x14e/0x192
[  167.006764]  ? lpfc_unreg_login+0x7c/0xc0 [lpfc]
[  167.006770]  kasan_report+0xe/0x20
[  167.006840]  lpfc_unreg_login+0x7c/0xc0 [lpfc]
[  167.006912]  lpfc_sli_def_mbox_cmpl+0x329/0x560 [lpfc]
[  167.006921]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[  167.006991]  ? __lpfc_sli_rpi_release.isra.59+0xc0/0xc0 [lpfc]
[  167.007057]  lpfc_sli_handle_mb_event+0x3f3/0x8d0 [lpfc]
[  167.007064]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[  167.007069]  ? _raw_write_lock_bh+0xe0/0xe0
[  167.007138]  ? lpfc_mbox_get+0x1d/0xa0 [lpfc]
[  167.007204]  ? lpfc_sli_free_hbq+0x80/0x80 [lpfc]
[  167.007277]  lpfc_do_work+0x100b/0x26e0 [lpfc]
[  167.007285]  ? __schedule+0x6ca/0xc10
[  167.007288]  ? _raw_spin_lock_irqsave+0x8d/0xf0
[  167.007329]  ? lpfc_unregister_unused_fcf+0xc0/0xc0 [lpfc]
[  167.007334]  ? wait_woken+0x130/0x130
[  167.007375]  ? lpfc_unregister_unused_fcf+0xc0/0xc0 [lpfc]
[  167.007380]  kthread+0x1b3/0x1d0
[  167.007383]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[  167.007386]  ret_from_fork+0x35/0x40
[  167.007389] 
[  167.007391] Allocated by task 667:
[  167.007395]  save_stack+0x19/0x80
[  167.007398]  __kasan_kmalloc.constprop.9+0xa0/0xd0
[  167.007400]  __kmalloc+0xfb/0x5d0
[  167.007439]  lpfc_sli4_alloc_resource_identifiers+0x260/0x8a0 [lpfc]
[  167.007478]  lpfc_sli4_hba_setup+0xbbd/0x3480 [lpfc]
[  167.007517]  lpfc_pci_probe_one_s4.isra.46+0x100b/0x1d70 [lpfc]
[  167.007556]  lpfc_pci_probe_one+0x191/0x11b0 [lpfc]
[  167.007563]  local_pci_probe+0x74/0xd0
[  167.007567]  work_for_cpu_fn+0x29/0x40
[  167.007570]  process_one_work+0x46e/0x7f0
[  167.007573]  worker_thread+0x4cd/0x6b0
[  167.007575]  kthread+0x1b3/0x1d0
[  167.007578]  ret_from_fork+0x35/0x40
[  167.007578] 
[  167.007580] Freed by task 0:
[  167.007580] (stack is not available)
[  167.007581] 
[  167.007584] The buggy address belongs to the object at ffff88a035f790c0
[  167.007584]  which belongs to the cache kmalloc-512 of size 512
[  167.007587] The buggy address is located 34 bytes to the right of
[  167.007587]  512-byte region [ffff88a035f790c0, ffff88a035f792c0)
[  167.007588] The buggy address belongs to the page:
[  167.007592] page:ffffea0080d7de40 refcount:1 mapcount:0 mapping:ffff888107c00c40 index:0x0
[  167.007595] flags: 0xd7ffffc0000200(slab)
[  167.007601] raw: 00d7ffffc0000200 ffffea0080ec5588 ffffea0080d3e988 ffff888107c00c40
[  167.007604] raw: 0000000000000000 ffff88a035f790c0 0000000100000006 0000000000000000
[  167.007606] page dumped because: kasan: bad access detected
[  167.007606] 
[  167.007607] Memory state around the buggy address:
[  167.007610]  ffff88a035f79180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.007613]  ffff88a035f79200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.007615] >ffff88a035f79280: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
[  167.007617]                                                        ^
[  167.007619]  ffff88a035f79300: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
[  167.007622]  ffff88a035f79380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  167.007623] ==================================================================


(gdb) l *lpfc_unreg_login+0x7c
0x8bb1c is in lpfc_unreg_login (drivers/scsi/lpfc/lpfc_mbox.c:826).
821             memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
822
823             mb->un.varUnregLogin.rpi = rpi;
824             mb->un.varUnregLogin.rsvd1 = 0;
825             if (phba->sli_rev >= LPFC_SLI_REV3)
826                     mb->un.varUnregLogin.vpi = phba->vpi_ids[vpi];
827
828             mb->mbxCommand = MBX_UNREG_LOGIN;
829             mb->mbxOwner = OWN_HOST;
830


Not sure if this is not again an red herring.

Thanks,
Daniel
