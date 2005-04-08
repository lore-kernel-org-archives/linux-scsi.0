From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: Re: Proper handling of data underrun
Date: Fri, 8 Apr 2005 17:03:32 +0200
Message-ID: <OF4E438840.23F5FE81-ONC1256FDD.0052928B-C1256FDD.0052CF16@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:24474 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S262843AbVDHPDg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 11:03:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

Douglas Gilbert <dougg@torque.net> wrote:

>      underflow    - LLD should place (DID_ERROR << 16) in 'result' if
>                     actual number of bytes transferred is less than this
>                     figure. Not many LLDs implement this check and some
>                     that do just output an error message to the log
>                     rather than report a DID_ERROR. Better for an LLD
>                     to implement 'resid'.

> Andreas,
> The last sentence is were the stress should be. It implies
> the LLD should use one or the other, preferably resid.

Ok.
BTW, resid is used in scsi_lib.c to set rq->data_len.
Who is actually evaluating this field -- the block layer 
(I have seen some usage in elevator.c)?

> Historically 'underflow' has been there the longest but was
> insufficient to distinguish between serious underflows
> (e.g. on a READ of a block device) and informative underflows
> (e.g. fetching a mode page with an arbitrarily large buffer).

> So 'resid' was added later and conveys more information and
> doesn't jump to conclusions that it is a serious error.
> Perhaps 'underflow' should be marked as deprecated.

> Is any data conveyed or is the underflow value the same
> as the requested length?

Value is the same as the requested length.

> See what happens if 'underflow' is ignored (i.e. not
> written to be the LLD) and DID_ERROR is not set in
> the host_byte.

Yes I will give it a try.
Thanks.


Regards,

Andreas

