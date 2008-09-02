From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [PATCH] scsi_netlink: Add transport and LLD receive and event support
Date: Tue, 2 Sep 2008 10:37:26 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC070168170B@AVEXCH1.qlogic.org>
References: <48B14BFB.2070401@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7463 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYIBRh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2008 13:37:28 -0400
Content-class: urn:content-classes:message
In-Reply-To: <48B14BFB.2070401@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
Thanks for the explanation. If this accepted to go upstream, I would
like to modify the qla2xxx driver patch I sent earlier (see below) to
confirm to this scheme.
http://marc.info/?l=linux-scsi&m=121745486321823&w=2

thanks
-david S.
> 
> David Somayajulu wrote:
> > However I have one minor gripe, which is regarding the vendor unique
id
> in
> > the receive path. This makes it appear as if the scsi netlink layer
is
> > peeking into its payload (where each msg is treated as <hdr
-containing
> > address information><payload>). In the network stack, each layer
looks
> at
> > the packet it receives and consumes if it is the final destination,
> > otherwise determines the next destination from the header and sends
it.
> No
> > layer peeks into the payload if it is not the consumer. The only
> integrity
> > check is typically a checksum.
> 
> I understand your intent - but view it a little differently. I break
the
> "stack layers" into the following:
> - "scsi netlink", which is the glue logic for our SCSI channel, that
> everything use. It does the first level of message decode (consuming
> scsi_nl_hdr), performing the main validity checks (length vs netlink
> packet), and selecting a transport.
> - "transport", which could be the SAS transport, FC transport, or the
> catch-all SCSI (midlayer) transport. Each transport has its own
message
> types. It may fully handle the message, or can be a multiplexer for
the
> components that belong to it.
> - The component layer - with shosts belonging to the catch-all SCSI
> transport. FC components would be fc_host's, fc_rports, etc; and so-on
> for SAS.
> 
> In this case, the vendor shost msg maps to the catch-all SCSI
transport.
> The SCSI transport consumes scsi_nl_host_vendor_msg, performs common
> steps such as driver validation, then pushes the payload to LLDD/shost
> for the rest of the processing. So same concepts as you describe.
> 
> There is only one violation of the "don't peek into the next layer"
> rule, but it's around scsi_nl_header:msgtype (not vendor unique id).
The
> field belongs proper to the transport, but is contained in the glue
> header.
> 
> I agree the vendor unique id initially feels odd. We needed some
handle
> to recognize the driver entry points by for
registration/deregistration,
> and we also needed at least 1 validation of something to ensure the
> driver and the message match. Given that we had it in the event
> messages, I used it as the handle. I couldn't think of a better
> alternative.
> 
>  > I would suggest that we augment the " struct
> > scsi_nl_hdr" with a bunch of reserved bytes and which are
interpreted
> based
> > on the scsi_nl_hdr->msgtype values, or have "struct
> scsi_nl_host_vendor_msg"
> > sans "struct scsi_nl_hdr" as part of a union within "struct
scsi_nl_hdr"
> > which is interpreted based on scsi_nl_hdr->msgtype values. In all
this
> is a
> > minor issue which is more about details and doesn't matter either
way.
> 
> I don't see what this buys... Unless you are just expanding the
message
> headers for some future binary-compatible expansion.
> 
> -- james s

