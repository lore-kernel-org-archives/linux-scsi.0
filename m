From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] lpfc: nvmet_fc: fix format string
Date: Sat, 20 May 2017 03:28:47 -0700
Message-ID: <1495276127.27714.4.camel@perches.com>
References: <20170519080447.1043039-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:46038 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750898AbdETK2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 May 2017 06:28:51 -0400
In-Reply-To: <20170519080447.1043039-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2017-05-19 at 10:04 +0200, Arnd Bergmann wrote:
> The lpfc_nvmeio_data() tracing helper always takes a format string and
> three additional arguments.

No it doesn't.  It takes a format and arguments.

I don't disagree with the patch, just the characterization
of the lpfc_mvmeio_data call in the commit message.

> The latest caller has a format string with
> only two integer arguments, causing this harmless warning:
> 
> drivers/scsi/lpfc/lpfc_nvmet.c: In function 'lpfc_nvmet_xmt_fcp_release':
> drivers/scsi/lpfc/lpfc_nvmet.c:802:25: error: too many arguments for format [-Werror=format-extra-args]
>   lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,
> 
> We could add a dummy argument here, but it seems reasonable to print
> the 'abort' flag as the third argument.
