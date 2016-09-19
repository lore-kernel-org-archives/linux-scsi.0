From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [RESEND] [PATCH 1/1] ses: Retry UNIT ATTENTION for receive
 diagnostics
Date: Mon, 19 Sep 2016 13:14:35 -0400
Message-ID: <1474305275.30327.16.camel@localhost.localdomain>
References: <20160916210607.054BF124047@b01ledav002.gho.pok.ibm.com>
         <yq1eg4fann1.fsf@sermon.lab.mkp.net>
         <1474302034.2398.4.camel@HansenPartnership.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752124AbcISROh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Sep 2016 13:14:37 -0400
In-Reply-To: <1474302034.2398.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

On Mon, 2016-09-19 at 09:20 -0700, James Bottomley wrote:
> On Mon, 2016-09-19 at 11:57 -0400, Martin K. Petersen wrote:
> > > > > > > "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:
> > 
> > Brian> If the ses driver receives a UNIT ATTENTION when issuing a
> > Brian> receive diagnostics while probing a SES device, it fails to
> > Brian> attach with messages such as:
> > 
> > Brian> scsi 1:0:7:0: Failed to get diagnostic page 0x8000002 scsi
> > Brian> 1:0:7:0: Failed to bind enclosure -19
> > 
> > Brian> Fix this by eating unit attentions for these commands.
> > 
> > James?
> 
> It seems to me that UA handling should be a part of scsi_execute_req
> (and scsi_execute) ... that is unless anyone can find a caller that
> would actually be interested.  I've been looking but haven't found one
> so far.
> 
> James

Since UNIT ATTENTION is usually reporting a condition unrelated to
the command that was sent (I'm not sure 29 00 qualifies as unrelated
since it indicates loss of device state), we probably shouldn't
require every caller to retry on it.  Could we handle this internally,
(maybe unless it persists for N attempts), before returning?

We should still be going through the scsi_check_sense() path and
the device handlers need to see the sense.

(removed cc: stable from reply)

-Ewan


