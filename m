From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: RFC scsi: aic94xx: use of complete() looks racy
Date: Mon, 9 Mar 2015 09:32:08 +0100
Message-ID: <20150309083208.GA21902@opentech.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:54857 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbbCIIcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Mar 2015 04:32:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org


Hi !

 while reviewing some type missmatch of wait_for_completion_timeout in 
 drivers/scsi/aic94xx/aic94xx_tmf.c:asd_clear_nexus() a question regarding
 the struct completion use came up:

(line numbers are from 4.0-rc2 linux-next)
351     tascb->completion = &completion;
352
353     ASD_DPRINTK("task not done, clearing nexus\n");
354     if (tascb->tag_valid)
355             res = asd_clear_nexus_tag(task);
356     else
357             res = asd_clear_nexus_index(task);
358     leftover = wait_for_completion_timeout(&completion,
359                                            AIC94XX_SCB_TIMEOUT);
360     tascb->completion = NULL;

this looks racy - atleast I was not able to figure out what would prevent
complete() from accessing a NULL pointer (similarly on line 524/525+545)

e.g. in asd_clear_nexus_tasklet_complete()
85         tcs->dl_opcode = dl->opcode;
86         complete(ascb->completion);
87         asd_ascb_free(ascb);

so if the timeout ever occured would that not result in a NULL access ?

what am I overlooking here ?

thx!
hofrat
