From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] zfcp: convert zfcp to use target reset and device reset handler
Date: Mon, 3 Mar 2008 11:12:31 +0100
Message-ID: <20080303101231.GA20838@schmichrtp.de.ibm.com>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu> <20080301133632.GB5098@schmichrtp.de.ibm.com> <20080303093924.GA8698@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:53246 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbYCCKMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 05:12:36 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m23ACYOA026200
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 10:12:34 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23ACXfr1396900
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 10:12:34 GMT
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23ACWPY002656
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 10:12:33 GMT
Content-Disposition: inline
In-Reply-To: <20080303093924.GA8698@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

On Mon, Mar 03, 2008 at 10:39:24AM +0100, Heiko Carstens wrote:
> >  	if (!unit) {
> > -		ZFCP_LOG_NORMAL("bug: Tried reset for nonexistent unit\n");
> > -		retval = SUCCESS;
> > -		goto out;
> > +		BUG();
> > +		return SUCCESS;
> > [...]
> > +	if (!unit) {
> > +		BUG();
> > +		return SUCCESS;
> 
> Would you mind turning the BUG()s into WARN_ON(1)s? BUG() may crash the
> whole system, while WARN_ON() will just emit a warning and continue.

Agree, WARN_ON is enough for these cases. I will followup with the
changed patch.

--
Christof Schmitt
