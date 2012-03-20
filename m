From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] qla2xxx FC target mode
Date: Tue, 20 Mar 2012 09:03:09 +0000
Message-ID: <1332234189.14019.19.camel@dabdike.int.hansenpartnership.com>
References: <1327796869.18763.211.camel@haakon2.linux-iscsi.org>
	 <1331941253.10203.280.camel@haakon2.linux-iscsi.org>
	 <1332062541.2855.27.camel@dabdike>
	 <1332116541.1612.118.camel@haakon2.linux-iscsi.org>
	 <1332147259.3152.3.camel@dabdike>
	 <1332202524.1612.299.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51649 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab2CTJDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 05:03:14 -0400
In-Reply-To: <1332202524.1612.299.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, Roland Dreier <roland@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>, Madhu Iyengar <madhu.iyengar@qlogic.com>, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, Arun Easi <arun.easi@qlogic.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Mon, 2012-03-19 at 17:15 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2012-03-19 at 08:54 +0000, James Bottomley wrote:
> > On Sun, 2012-03-18 at 17:22 -0700, Nicholas A. Bellinger wrote:
> > > On Sun, 2012-03-18 at 09:22 +0000, James Bottomley wrote:
> > > > On Fri, 2012-03-16 at 16:40 -0700, Nicholas A. Bellinger wrote:
> > > > > James & Co,
> > > > > 
> > > > > Ping..?  Any thoughts on this topic yet..?
> > > > 
> > > > Not really ... we're trying to get the participants to plan the topics
> > > > this year.
> > > > 
> > > 
> > > Hi James,
> > > 
> > > I'm asking because the invites for an LSF slot this year to discuss this
> > > topic with the development community has not materialized, and you've
> > > been completely silent to qla2xxx target RFCs + patches that involve the
> > > subject thus far..
> > 
> > It's not my driver, it's qlogic's ... I'm not really going to say
> > anything until they do.
> 
> Well, I think most of the questions unresolved around mixed mode that
> need to be addressed between scsi-core and target-core for-3.5 are
> really quite generic in nature to the individual scsi LLD.

They are?  I understood it was highly firmware (and even hardware)
dependent from conversations with various manufacturers.

> Currently where we run into difficultly with a storage stack that is
> made to allow 'hot' transition between different modes of operation, is
> how to relinquish initiator mode operation w/o having to unload the
> whole SCSI LLD, and also how to re-enable initiator mode when an
> individual TCM fabric port have been released by a generic wwn_group
> object under /sys/kernel/config/target/$FABRIC/$FABRIC_WWPN
> 
> So considering these current limitations here between subsystems for the
> initial for-3.4 merge of qla_target.c logic, we now enforce the use of a
> qla2xxx specific module parameter to enable/disable different modes
> globally for all qla_hw_data ports at LLD load time.
> 
> I've asked Andrew V. and Co. to take another look at today's linux-next
> tree to verify the changes for existing code in patch #2 for >= qla24xx
> series target mode support do not negatively effect the existing
> initiator mode operation of qla2xxx in any way.
> 
> Please let us know if you have any concerns.

Why can't it just work like scsi_tgt?  That has a separate queue for
target.  The two queue model is then mediated inside the LLD.  If the
LLD can't switch at all, it only accepts one queue attachment at init
time (either target or initiator).  If there's some pain to switching,
you still have to unload one before switching to the other (effectingely
this means quiescing and stopping the unloaded queue), and if it can
autoswitch, you just run two queues and let it sort out the ordering.

James


