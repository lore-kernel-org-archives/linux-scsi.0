From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH v2 02/10] be2iscsi: Fix closing of connection
Date: Fri, 24 Mar 2017 13:54:29 +0530
Message-ID: <00e40e9717ff37125d0b88d2ca3517ce@mail.gmail.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1489634685-4975-3-git-send-email-jitendra.bhivare@broadcom.com> <cd622545-9b55-4be6-4130-bf7f2fc00abb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35430 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdCXIYd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 04:24:33 -0400
Received: by mail-wm0-f48.google.com with SMTP id u132so6906435wmg.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 01:24:31 -0700 (PDT)
In-Reply-To: <cd622545-9b55-4be6-4130-bf7f2fc00abb@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

> > +	attempts = 0;
> > +	while (attempts++ < 3) {
> > +		tag = beiscsi_invalidate_cxn(phba, beiscsi_ep);
> > +		if (tag) {
> > +			ret = beiscsi_mccq_compl_wait(phba, tag, NULL,
> NULL);
> > +			if (!ret)
> > +				break;
> > +			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
> > +				    "BS_%d : invalidate conn failed cid
%d\n",
> > +				    beiscsi_ep->ep_cid);
> > +		}
> >  	}
> >
> > -	ret = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
> > -
> > -	/* Flush the CQ entries */
> > +	/* wait for all completions to arrive, then process them */
> > +	msleep(250);
> > +	/* flush CQ entries */
> >  	beiscsi_flush_cq(phba);
> >
> > -	return ret;
> > +	if (attempts == 3)
>
> Hi Jitendra,
> when attempts is updated after a '< 3' test, then I think that the test
here
> should be changed to 'if (attempts > 3)'
> tomash
>
[JB] Thanks for reviewing Tomas.
My bad, made some last minute changes to it. Will re-send the series.
