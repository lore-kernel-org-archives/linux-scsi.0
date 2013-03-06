From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH v1] lpfc 8.3.37: Remove redundant NULL check before kfree
Date: Wed, 6 Mar 2013 23:32:00 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950DA4F5D@G9W0745.americas.hpqcorp.net>
References: <1362600754-6139-1-git-send-email-s.syam@samsung.com>
 <2b628a59-616e-40c9-b5c4-a9899ae38b80@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:5775 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3CFXdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Mar 2013 18:33:47 -0500
In-Reply-To: <2b628a59-616e-40c9-b5c4-a9899ae38b80@CMEXHTCAS2.ad.emulex.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Smart@emulex.com" <James.Smart@emulex.com>, "syamsidhardh@gmail.com" <syamsidhardh@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Syam Sidhardhan <s.syam@samsung.com>

If the other approach is taken, then not all kfree() calls are protected by a NULL check.

One example in lpfc_els.c (from 3.7-rc5):
	if (!pbuflist || !pbuflist->virt)
		goto els_iocb_free_pbuf_exit;
...
els_iocb_free_pbuf_exit:
	if (expectRsp)
		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
	kfree(pbuflist);




> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of James Smart
> Sent: Wednesday, 06 March, 2013 3:10 PM
> To: syamsidhardh@gmail.com
> Cc: linux-scsi@vger.kernel.org; JBottomley@parallels.com; Syam Sidhardhan;
> Smart, James
> Subject: Re: [PATCH v1] lpfc 8.3.37: Remove redundant NULL check before
> kfree
> 
> Syam,
> 
> Thank you for the patch - it is valid.
> 
> However, I prefer not to merge this.  I would rather force the coder to
> think about the pointer value explicitly rather than depending on the
> convenience/one line optimization.  We've had errors in the past covered
> up by this gracious behavior.  Additionally, we have coders that work on
> linux and vmware, and the semantics of the kfree() routine differ.   For
> now, I'd prefer to stay as is and force good habits.
> 
> -- james s
> 
> 
> On 3/6/2013 3:12 PM, syamsidhardh@gmail.com wrote:
> > From: Syam Sidhardhan <s.syam@samsung.com>
> >
> > kfree on NULL pointer is a no-op.
> >
> > Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> > ---
> > v1-> Corrected the from address.
> >
> >   drivers/scsi/lpfc/lpfc_bsg.c |    3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> > index 32d5683..2166097 100644
> > --- a/drivers/scsi/lpfc/lpfc_bsg.c
> > +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> > @@ -1129,8 +1129,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
> >   	return 0; /* call job done later */
> >
> >   job_error:
> > -	if (dd_data != NULL)
> > -		kfree(dd_data);
> > +	kfree(dd_data);
> >
> >   	job->dd_data = NULL;
> >   	return rc;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
