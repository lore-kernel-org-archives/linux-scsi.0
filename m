From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 14:31:45 +0200
Message-ID: <1409229105.714.14.camel@br9vgx5g.de.ibm.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>
	 <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>
	 <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:35251 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaH1Mbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 08:31:50 -0400
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Thu, 28 Aug 2014 13:31:48 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8542A1B08069
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 13:32:45 +0100 (BST)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s7SCVl8N46596118
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 12:31:47 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s7SCVj85031178
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 06:31:46 -0600
In-Reply-To: <53FF1AD8.9020800@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2014-08-28 at 14:04 +0200, Hannes Reinecke wrote:
> On 08/25/2014 01:15 PM, Paolo Bonzini wrote:
> > - abort the command, and then the driver should never call the
> > ->scsi_done callback for the Scsi_Cmnd*.
> >
> In practice we rely on the latter behaviour; when ->scsi_done is=20
> called while the command is under eh_abort _really bad things_
> will happen.
> As soon as eh_abort is called control is transferred back to the
> SCSI midlayer, so any LLDD should never send completions for these
> commands back to the midlayer.

Mmh, then there is a small race window starting at the point in time
when the abort function of an LLDD is called up to the point in time
when that abort function has taken the necessary measures to make sure
that scsi_done won't be called for a racing command completion , isn't
it?

Cheers
Martin

--=20
Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
