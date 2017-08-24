From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] scsi: lpfc: avoid false positive gcc-8 warning
Date: Thu, 24 Aug 2017 13:01:20 +0200
Message-ID: <CAK8P3a39cW5mC8qAKhpuMTcYjroRStv9z9yaiH3jTvb9wK34-g@mail.gmail.com>
References: <20170824003440.4270-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36914 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdHXLBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2017 07:01:21 -0400
In-Reply-To: <20170824003440.4270-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>

On Thu, Aug 24, 2017 at 2:34 AM, James Smart <jsmart2021@gmail.com> wrote:
> Arnd Bergmann, testing gcc-8, encountered the following:
>
>> This is an interesting regression with gcc-8, showing a harmless
>> warning for correct code:
>>
>>In file included from include/linux/kernel.h:13:0,
>>    ...
>>    from drivers/scsi/lpfc/lpfc_debugfs.c:23:
>>    include/linux/printk.h:301:2: error: 'eq' may be used
>>    uninitialized in this function [-Werror=maybe-uninitialized]
>>       printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>>       ^~~~~~
>>    In file included from drivers/scsi/lpfc/lpfc_debugfs.c:58:0:
>>    drivers/scsi/lpfc/lpfc_debugfs.h:451:31: note: 'eq' was
>>    declared here
>
> The code is fine: a for loop which if there's at least 1 itteration,
> will assign eq a value. Followed by an if test that checks for no
> itterations and assigns eq a default value. But the checker doesn't
> see the relationship between the two so assumes eq may not a have a
> value.
>
> I believe, simply initializing with a NULL will solve the issue.
>
> Signed-off-by: James Smart <james.smart@broadcom.com>

That's probably good enough here, as the warning is rather obscure
(only one instance in the entire kernel in 1000 randconfig builds),
with an unreleased compiler.

Anyway, I have successfully reduced a test case and reported
a gcc bug for it, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81958

The compiler test case is

__attribute__ ((__cold__)) int printk();
struct lpfc_queue {
        int queue_id;
        struct lpfc_queue *hba_eq;
} *cq_phba;
void lpfc_debug_dump_all_queues(unsigned maxidx)
{
        struct lpfc_queue *eq;
        unsigned eqidx;
        printk();
        for (eqidx = 0; eqidx < maxidx; eqidx++) {
                eq = &cq_phba->hba_eq[eqidx];
                if (eq->queue_id)
                        break;
        }
        if (eqidx == maxidx)
                eq = &cq_phba->hba_eq[0];
        printk(eq);
}

and I see no reason why the compiler should get this wrong.

I have also come up with a different workaround of my own
(sorry for the broken formatting here) and tested it successfully
over night. I have definitely spent more time on it than it was
worth now. Let me know if you prefer that version over yours,
then I'll submit that as a proper patch with your Ack.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -450,7 +450,7 @@ lpfc_debug_dump_cq(struct lpfc_hba *phba, int
qtype, int wqidx)
 {
        struct lpfc_queue *wq, *cq, *eq;
        char *qtypestr;
-       unsigned int eqidx;
+       int eqidx;

        /* fcp/nvme wq and cq are 1:1, thus same indexes */

@@ -478,16 +478,16 @@ lpfc_debug_dump_cq(struct lpfc_hba *phba, int
qtype, int wqidx)
                return;

        for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++) {
-               eq = phba->sli4_hba.hba_eq[eqidx];
-               if (cq->assoc_qid == eq->queue_id)
+               if (cq->assoc_qid == phba->sli4_hba.hba_eq[eqidx]->queue_id)
                        break;
        }
        if (eqidx == phba->io_channel_irqs) {
                pr_err("Couldn't find EQ for CQ. Using EQ[0]\n");
                eqidx = 0;
-               eq = phba->sli4_hba.hba_eq[0];
        }

+       eq = phba->sli4_hba.hba_eq[eqidx];
+
        if (qtype == DUMP_FCP || qtype == DUMP_NVME)
                pr_err("%s CQ: WQ[Idx:%d|Qid%d]->CQ[Idx%d|Qid%d]"
                        "->EQ[Idx:%d|Qid:%d]:\n",


     Arnd
