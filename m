From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi_netlink: Add transport and LLD receive and event
 support
Date: Sun, 24 Aug 2008 07:54:35 -0400
Message-ID: <48B14BFB.2070401@emulex.com>
References: <C4D2105F.1F8A%david.somayajulu@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54719 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYHXLym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 07:54:42 -0400
In-Reply-To: <C4D2105F.1F8A%david.somayajulu@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



David Somayajulu wrote:
> However I have one minor gripe, which is regarding the vendor unique id in
> the receive path. This makes it appear as if the scsi netlink layer is
> peeking into its payload (where each msg is treated as <hdr -containing
> address information><payload>). In the network stack, each layer looks at
> the packet it receives and consumes if it is the final destination,
> otherwise determines the next destination from the header and sends it. No
> layer peeks into the payload if it is not the consumer. The only integrity
> check is typically a checksum.

I understand your intent - but view it a little differently. I break the 
"stack layers" into the following:
- "scsi netlink", which is the glue logic for our SCSI channel, that 
everything use. It does the first level of message decode (consuming 
scsi_nl_hdr), performing the main validity checks (length vs netlink 
packet), and selecting a transport.
- "transport", which could be the SAS transport, FC transport, or the 
catch-all SCSI (midlayer) transport. Each transport has its own message 
types. It may fully handle the message, or can be a multiplexer for the 
components that belong to it.
- The component layer - with shosts belonging to the catch-all SCSI 
transport. FC components would be fc_host's, fc_rports, etc; and so-on 
for SAS.

In this case, the vendor shost msg maps to the catch-all SCSI transport. 
The SCSI transport consumes scsi_nl_host_vendor_msg, performs common 
steps such as driver validation, then pushes the payload to LLDD/shost 
for the rest of the processing. So same concepts as you describe.

There is only one violation of the "don't peek into the next layer" 
rule, but it's around scsi_nl_header:msgtype (not vendor unique id). The 
field belongs proper to the transport, but is contained in the glue 
header.

I agree the vendor unique id initially feels odd. We needed some handle 
to recognize the driver entry points by for registration/deregistration, 
and we also needed at least 1 validation of something to ensure the 
driver and the message match. Given that we had it in the event 
messages, I used it as the handle. I couldn't think of a better alternative.

 > I would suggest that we augment the " struct
> scsi_nl_hdr" with a bunch of reserved bytes and which are interpreted based
> on the scsi_nl_hdr->msgtype values, or have "struct scsi_nl_host_vendor_msg"
> sans "struct scsi_nl_hdr" as part of a union within "struct scsi_nl_hdr"
> which is interpreted based on scsi_nl_hdr->msgtype values. In all this is a
> minor issue which is more about details and doesn't matter either way.

I don't see what this buys... Unless you are just expanding the message 
headers for some future binary-compatible expansion.

-- james s

