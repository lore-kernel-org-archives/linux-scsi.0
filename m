From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/2] qla2xxx: Rewrite logging functions to use %pV
Date: Sun, 31 Jul 2011 10:02:52 +0200
Message-ID: <256822902b9b2221e206b75f384bdc68.squirrel@webmail.sf-mail.de>
References: <cover.1312067036.git.joe@perches.com>
    <f404820a01953db2c3608f90c40b8567646f079a.1312067036.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:35947 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab1GaIDx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2011 04:03:53 -0400
In-Reply-To: <f404820a01953db2c3608f90c40b8567646f079a.1312067036.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> +	if (vha != NULL) {
> +		const struct pci_dev *pdev = vha->hw->pdev;
> +		/* <module-name> <pci-name> <msg-id>:<host> Message */
> +		pr_warn("%s [%s]-%04x:%ld: %pV",
> +			QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset,
> +			vha->host_no, &vaf);
> +	} else {
> +		pr_warn("%s [%s]-%04x: : %pV",
> +			QL_MSGHDR, "0000:00:00.0", id + ql_dbg_offset, &vaf);
>  	}

If I would see 0000:00:00.0 in the logmessage I would become scared that
something is dereferencing cleared memory, use after free or whatever.
Only by looking into the code I could see that this code simply has no
idea which device it is on. Well, then don't print an address when you
don't have one instead of inventing one.

Eike
