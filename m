From: Jeremy Linton <jlinton@greshamstorage.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 6 Dec 2006 17:42:27 -0600
Message-ID: <200612061742.27884.jlinton@greshamstorage.com>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org> <4577374B.9000204@cs.wisc.edu> <45774927.8090204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:3605 "EHLO
	austin.greshamstorage.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937809AbWLFXmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 18:42:37 -0500
In-Reply-To: <45774927.8090204@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Wednesday 06 December 2006 16:50, Mike Christie wrote:
> > For iscsi, we could negotiate a value like MaxBurstLength which says
> > don't send commands with a payload larger than that size. I would guess
> > other transports have something similar. We have to check or make sure
...
> Oh yeah the exception I am thinking about may not be max sectors exactly
> but something close like iscsi's MaxBurstLength limit. Maybe iscsi LLDs
> are supposed to be translating that iscsi limit to max_sectors in which
> case we are talking about the same thing. For this limit we do not want

	Sort of off topic, but the iSCSI MaxBurstLength doesn't set the max transfer 
size, it simply is the amount of data that can be sent without a R2T. If the 
transfer is larger then you have to wait for the R2T. In practice it ends up 
controlling the _minimum_ amount of buffer space that needs to be available 
_before_ the transfer starts, otherwise performace sucks. 

-- 
PHB REQ:

Privileged or confidential information may be contained in this message.
If you are not the addressee of this message please notify the sender by
return email and thereafter delete the message.  You may not use, copy,
disclose or rely on the information contained in this message.  Internet
e-mail may be susceptible to data corruption, interception and
unauthorized amendment for which Gresham does not accept liability.
While we have taken reasonable precautions to ensure that this e-mail
and any attachments have been swept for viruses, Gresham does not accept 
liability for any damage sustained as a result of viruses.  Statements
in this message that do not relate to the business of Gresham are
neither given nor endorsed by the company or its directors.  A list of
Gresham's directors is available on our web site:
<www.gresham-computing.com>   
