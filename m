From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH RESEND] lpfc: Don't return internal MBXERR_ERROR code
 from probe function
Date: Wed, 6 Sep 2017 12:02:17 +0200
Message-ID: <20170906100217.3m6zkolhwt2243cm@linux-x5ow.site>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
 <20170906110256.4445e353@elisabeth>
 <20170906093034.hkyeg3pjxy3nmyig@linux-x5ow.site>
 <20170906115415.435a1bfb@elisabeth>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59167 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752241AbdIFKCT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Sep 2017 06:02:19 -0400
Content-Disposition: inline
In-Reply-To: <20170906115415.435a1bfb@elisabeth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com, Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Wed, Sep 06, 2017 at 11:54:15AM +0200, Stefano Brivio wrote:
> Thanks for your feedback!
> 
> I considered doing something similar, but there are different error
> coded which are set when we reach the label out_free_mbsx. I checked all
> of them (and I hope I didn't miss any), but they all looked correct,
> and in quite a few cases different than -EIO (e.g. -ENODEV).
> 
> So I think always returning -EIO in those cases is not what we want.

We still could pre-assign the rc value:

	rc = -EIO;
	rc = foo()
	if (rc)
		goto err_handler;
	rc = bar()
	if (rc)
		goto err_handler;
	rc = -ENODEV;
	if (rc)
		goto somewhere_else;

But let's not complicate things and get this one queued up.

> > Because as this patch shows there's always a chance to miss an 'rc = -EIO'.
> > 
> > Out of curiosity, do you know what's the value of rc in the failure case?
> 
> Yes, MBXERR_ERROR (mentioned in patch subject -- sorry, I could have
> repeated it in the message perhaps).

Ah ok I somehow missed it, sorry.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
