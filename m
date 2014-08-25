From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Mon, 25 Aug 2014 13:15:25 +0200
Message-ID: <53FB1ACD.1040208@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaHYLPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 07:15:31 -0400
In-Reply-To: <53FB0FE3.80603@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

Il 25/08/2014 12:28, Bart Van Assche ha scritto:
> 
> From SPC-4: "7.5.8 Control mode page [ ... ] A task aborted status (TAS)
> bit set to zero specifies that aborted commands shall be terminated by
> the device server without any response to the application client. A TAS
> bit set to one specifies that commands aborted by the actions of an I_T
> nexus other than the I_T nexus on which the command was received shall
> be completed with TASK ABORTED status (see SAM-5)."

Note the "aborted by the actions of an I_T nexus other than the I_T
nexus on which the command was received".

In practice, this means that TASK ABORTED should only happen if you use
the CLEAR TASK SET tmf and TST is not set to 001b (i.e. _not_ to "per
I_T nexus") in the Control mode page.  It should never happen for a pen
drive.

Setting TASK ABORTED aside, the important part is that an abort can do
one of two things:

- complete the command, and then eh_abort should return after the driver
has noticed the completion and called the ->scsi_done callback for the
Scsi_Cmnd*.

- abort the command, and then the driver should never call the
->scsi_done callback for the Scsi_Cmnd*.

Paolo
