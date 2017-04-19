From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Tue, 18 Apr 2017 17:05:55 -0700
Message-ID: <1492560355.3306.64.camel@HansenPartnership.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
         <1492560140.2689.30.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59806 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754052AbdDSAF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 20:05:57 -0400
In-Reply-To: <1492560140.2689.30.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Wed, 2017-04-19 at 00:02 +0000, Bart Van Assche wrote:
> On Tue, 2017-04-18 at 16:56 -0700, James Bottomley wrote:
> > Actually, I think 3/3 is wrong.  You need to start the queue as 
> > soon as we see it's blocked and the device has gone into DEL.  This 
> > is safe because DEL ensures nothing ever gets from the generic 
> > request function to queuecommand, so the device driver never sees
> > anything.
> 
> Hello James,
> 
> I agree that restarting the queue earlier is safe but I do not agree 
> that patch 3/3 is wrong. Can you explain why you think that patch 3/3 
> is wrong?

The shutdown occurs in driver removal, which precedes the queue start
in 3/3.  To avoid hangs and timeouts, we need the queue to be started
before the driver shutdown tries to inject commands.  They're not
fatal, but they will likely show up as annoying messages (and time
delays) which we can avoid by starting the queue the moment we go into
DEL.

James
