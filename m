From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: convert zfcp to use target reset and device
	reset handler
Date: Mon, 3 Mar 2008 10:39:24 +0100
Message-ID: <20080303093924.GA8698@osiris.boeblingen.de.ibm.com>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu> <20080301133632.GB5098@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:38955 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYCCJj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 04:39:27 -0500
Received: from d12nrmr1507.megacenter.de.ibm.com (d12nrmr1507.megacenter.de.ibm.com [9.149.167.1])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id m239dQjE095174
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 09:39:26 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1507.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m239dP321818654
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 10:39:25 +0100
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m239dOkY002598
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 09:39:25 GMT
Content-Disposition: inline
In-Reply-To: <20080301133632.GB5098@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

>  	if (!unit) {
> -		ZFCP_LOG_NORMAL("bug: Tried reset for nonexistent unit\n");
> -		retval = SUCCESS;
> -		goto out;
> +		BUG();
> +		return SUCCESS;
> [...]
> +	if (!unit) {
> +		BUG();
> +		return SUCCESS;

Would you mind turning the BUG()s into WARN_ON(1)s? BUG() may crash the
whole system, while WARN_ON() will just emit a warning and continue.
