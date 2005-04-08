From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Proper handling of data underrun
Date: Fri, 08 Apr 2005 22:44:53 +1000
Message-ID: <42567CC5.7090407@torque.net>
References: <20050408083702.GA6645@lion28.boeblingen.de.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:28105 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262790AbVDHMst (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2005 08:48:49 -0400
In-Reply-To: <20050408083702.GA6645@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Andreas Herrmann wrote:
> Hi,
> 
> Documentation/scsi/scsi_mid_low_api.txt says:
> 
>     resid        - an LLD should set this signed integer to the ...
> 
>     <snip>
> 
>     underflow    - LLD should place (DID_ERROR << 16) in 'result' if ...

     underflow    - LLD should place (DID_ERROR << 16) in 'result' if
                    actual number of bytes transferred is less than this
                    figure. Not many LLDs implement this check and some
                    that do just output an error message to the log
                    rather than report a DID_ERROR. Better for an LLD
                    to implement 'resid'.

Andreas,
The last sentence is were the stress should be. It implies
the LLD should use one or the other, preferably resid.

Historically 'underflow' has been there the longest but was
insufficient to distinguish between serious underflows
(e.g. on a READ of a block device) and informative underflows
(e.g. fetching a mode page with an arbitrarily large buffer).

So 'resid' was added later and conveys more information and
doesn't jump to conclusions that it is a serious error.
Perhaps 'underflow' should be marked as deprecated.

>     <snip>
> 
> ZFCP is setting resid and DID_ERROR if an underrun is indicated in the
> FCP-response.
> 
> In some error situations it occurs that the storage box reports a BUSY
> or TASK_SET_FULL scsi state as well as data underrun in the
> FCP-response.

Is any data conveyed or is the underflow value the same
as the requested length?

> Now zfcp sets DID_ERROR in host_byte as suggested in
> scsi_mid_low_api.txt. And the BUSY/TASK_SET_FULL state is returned in
> stauts_byte.
> 
> Problem is:
> Due to the its fastfail-operation the scsi-stack won't do any
> retry for this kind of failed commands because DID_ERROR is
> evaluated before BUSY/TASK_SET_FULL.
> 
> What is the proper handling of situations where the device reports a
> BUSY/TASK_SET_FULL and a data underrun?

See what happens if 'underflow' is ignored (i.e. not
written to be the LLD) and DID_ERROR is not set in
the host_byte.

Doug Gilbert
