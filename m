From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.23 regression: lpfc_sli.c: off-by-10
Date: Mon, 23 Jul 2007 02:32:15 +0200
Message-ID: <20070723003215.GQ26212@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41502 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762882AbXGWAcu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:32:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

The Coverity checker spotted the following off-by-10
in drivers/scsi/lpfc/lpfc_sli.c:


<--  snip  -->

...
static int
lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
                            struct lpfc_iocbq *saveq)
{
...
                        saveq->context3 = lpfc_sli_replace_hbqbuff(phba,
                                                irsp->un.ulpWord[15]);
...

<--  snip  -->


due to the following code in drivers/scsi/lpfc/lpfc_hw.h:


<--  snip  -->

...
#define IOCB_WORD_SZ    8
...
typedef struct _IOCB {  /* IOCB structure */
...
                uint32_t ulpWord[IOCB_WORD_SZ - 2];     /* generic 6 'words' */
...

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

