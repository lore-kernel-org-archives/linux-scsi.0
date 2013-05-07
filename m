From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] ufs: add support for query requests
Date: Tue, 07 May 2013 15:03:04 -0700
Message-ID: <1367964184.4108.27.camel@dabdike>
References: <20130507142540.GA20764@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47877 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796Ab3EGWDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 18:03:07 -0400
In-Reply-To: <20130507142540.GA20764@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: draviv@codeaurora.org, linux-scsi@vger.kernel.org, kbuild@01.org

On Tue, 2013-05-07 at 17:25 +0300, Dan Carpenter wrote:
> Hello Dolev Raviv,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 3aee47c623a3: "[SCSI] ufs: add support for query requests"
> from May 2, 2013, leads to the following Smatch complaint:
> 
> drivers/scsi/ufs/ufshcd.c:723 ufshcd_query_request()
> 	 error: we previously assumed 'hba' could be null (see line 722)
> 
> drivers/scsi/ufs/ufshcd.c
>    721	
>    722		if (!hba || !query || !response) {
>                     ^^^^
> New check.
> 
>    723			dev_err(hba->dev,
>                                 ^^^^^^^^
> New dereference.
> 
>    724				"%s: NULL pointer hba = %p, query = %p response = %p\n",
>    725				__func__, hba, query, response);

We don't actually have any callers of this function either, so nothing
ever exercises the code.  Given that we're not supposed to put stuff in
the tree without a use case anyway, I can just remove it and then it can
be resubmitted when the function has a user.

James


