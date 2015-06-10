From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: lpfc: Fix rport leak.
Date: Wed, 10 Jun 2015 18:48:20 +0300
Message-ID: <20150610154820.GI10549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36618 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965923AbbFJPse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2015 11:48:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@avagotech.com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

This is a semi-automatic email about new static checker warnings.

The patch 466e840b7809: "lpfc: Fix rport leak." from May 21, 2015, 
leads to the following Smatch complaint:

drivers/scsi/lpfc/lpfc_hbadisc.c:3905 lpfc_register_remote_port()
	 error: we previously assumed 'rdata' could be null (see line 3903)

drivers/scsi/lpfc/lpfc_hbadisc.c
  3902			ndlp->rport = NULL;
  3903			if (rdata && rdata->pnode == ndlp)
                            ^^^^^
Patch introduces a new check.

  3904				lpfc_nlp_put(ndlp);
  3905			rdata->pnode = NULL;
                        ^^^^^^^^^^^^
Unchecked dereference.

  3906			/* drop reference for earlier registeration */
  3907			put_device(&rport->dev);

regards,
dan carpenter
