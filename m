From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: FireWire/SBP2 Target mode
Date: Tue, 7 Feb 2012 20:17:30 +0100
Message-ID: <20120207201730.1c8cf6a3@stein>
References: <4E4BD560.4010806@bootc.net>
	<4E4D3B88.30003@ladisch.de>
	<4F29978A.3010707@redhat.com>
	<20120201224156.0773ebc6@stein>
	<4F2A55B9.4040005@panasas.com>
	<4F2A60DC.9030007@ladisch.de>
	<4F2FD1F4.9050702@bootc.net>
	<4F2FE705.3070509@ladisch.de>
	<4F2FE8DA.70502@bootc.net>
	<20120206212628.6880c506@stein>
	<5C167A1D-2203-4F1C-B538-E99DD87E7E42@bootc.net>
	<CAGRGNgWf0epcam-jpCzMCSqefCKDSm892mw-X49FrcoRO0QYrQ@mail.gmail.com>
	<476E7976-738A-4202-9FC4-FA5B060EA95F@bootc.net>
	<4F30D4F6.1040802@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F30D4F6.1040802@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: Julian Calaby <julian.calaby@gmail.com>, Clemens Ladisch <clemens@ladisch.de>, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Feb 07 Chris Boot wrote:
> On 06/02/2012 23:09, Chris Boot wrote:
> > On 6 Feb 2012, at 23:00, Julian Calaby wrote:
> >> On Tue, Feb 7, 2012 at 09:28, Chris Boot<bootc@bootc.net>  wrote:
> >>> Waiting until the bus scan is complete isn't actually that great
> >>> as I see the first LOGIN requests often before the fw_node is seen
> >>> at all. I'd have to turn away the requester and hope they try again.

An SBP-2 initiator should be prepared to retry its first login attempt if
it sent it shortly after a bus reset.  The target may still hold
reservations for previously loggend in initiators for up to reconnect_hold
+ 2 seconds after bus reset.

> >>> I'm fairly sure my little tweak in my patch is a simple enough
> >>> solution.

Yep.

> >> Stupid question: Could you use a completion queue or something
> >> equivalent to wait until you have seen the fw_node, *then* process the
> >> LOGIN request?
> >
> > The fw_address_handler callback is called in interrupt context, and
> > I can't sleep from within there. As far as I'm aware I must call
> > fw_send_response() from within the callback and can't defer that until
> > I've scheduled something on a work queue. Please correct me if I'm
> > wrong though, as that might be useful anyway.
> 
> Hmm sorry I've thought about this overnight and clearly I was talking 
> rubbish. Yes, I need to reply in the fw_address_handler but all I tend 
> to do in there is schedule a task to the the main part of the work 
> anyway. As most of the operations require fetching an ORB from the 
> initiator I have to do this from user context.

Technically there are two things to perform:

 1. Finish the inbound IEEE 1394 transaction to the management agent
    register by means of fw_send_response().  As far as I can tell, you
    don't have to do that in the address_callback().  But there is little
    reason not to.

    fw_send_response() ends the lifetime of an fw_request, so read the
    speed code before you respond.

 2. Finish the inbound SBP-2 transaction; here the login.  This and
    everything that leads up to it is definitely easiest to implement in
    a process context, e.g. workqueue item.
-- 
Stefan Richter
-=====-===-- --=- --===
http://arcgraph.de/sr/
