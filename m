From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] qla2xxx: Rewrite logging functions to use %pV
Date: Sun, 31 Jul 2011 01:08:50 -0700
Message-ID: <1312099730.1558.7.camel@Joe-Laptop>
References: <cover.1312067036.git.joe@perches.com>
	 <f404820a01953db2c3608f90c40b8567646f079a.1312067036.git.joe@perches.com>
	 <256822902b9b2221e206b75f384bdc68.squirrel@webmail.sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4403 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab1GaIIw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2011 04:08:52 -0400
In-Reply-To: <256822902b9b2221e206b75f384bdc68.squirrel@webmail.sf-mail.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 10:02 +0200, Rolf Eike Beer wrote:
> > +	if (vha != NULL) {
> > +		const struct pci_dev *pdev = vha->hw->pdev;
> > +		/* <module-name> <pci-name> <msg-id>:<host> Message */
> > +		pr_warn("%s [%s]-%04x:%ld: %pV",
> > +			QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset,
> > +			vha->host_no, &vaf);
> > +	} else {
> > +		pr_warn("%s [%s]-%04x: : %pV",
> > +			QL_MSGHDR, "0000:00:00.0", id + ql_dbg_offset, &vaf);
> >  	}
> If I would see 0000:00:00.0 in the logmessage I would become scared that
> something is dereferencing cleared memory, use after free or whatever.
> Only by looking into the code I could see that this code simply has no
> idea which device it is on. Well, then don't print an address when you
> don't have one instead of inventing one.

I don't disagree, but that's for Andrew to figure out
in a separate patch.

I just want to make the code smaller.

The output of the new code is the same as the old code.

