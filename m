From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] scsi:netlink support in scsi and fc transports for
 hba	specific messages
Date: Thu, 31 Jul 2008 14:56:36 -0500
Message-ID: <489218F4.8020203@cs.wisc.edu>
References: <1217454832.25166.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44790 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbYGaT47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 15:56:59 -0400
In-Reply-To: <1217454832.25166.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, David Wagner <david.wagner@qlogic.com>

David Somayajulu wrote:
> This patch adds support to the scsi transport layer for passing hba specific netlink messages to a low level driver. Also support is added to the fc transport, to enable an FC hba driver to post netlink message to a specific user process.
> 
> Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
> ---
>  drivers/scsi/scsi_netlink.c      |   13 +++++++
>  drivers/scsi/scsi_transport_fc.c |   72 ++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_host.h         |    6 +++
>  include/scsi/scsi_netlink.h      |    3 +-
>  include/scsi/scsi_transport_fc.h |    2 +
>  5 files changed, 95 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
> index ae7ed9a..3bc85c9 100644
> --- a/drivers/scsi/scsi_netlink.c
> +++ b/drivers/scsi/scsi_netlink.c
> @@ -24,6 +24,7 @@
>  #include <net/sock.h>
>  #include <net/netlink.h>
>  
> +#include <scsi/scsi_host.h>
>  #include <scsi/scsi_netlink.h>
>  #include "scsi_priv.h"
>  
> @@ -47,6 +48,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
>  	struct scsi_nl_hdr *hdr;
>  	uint32_t rlen;
>  	int err;
> +	struct Scsi_Host *shost;
>  
>  	while (skb->len >= NLMSG_SPACE(0)) {
>  		err = 0;
> @@ -89,6 +91,17 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
>  		/*
>  		 * We currently don't support anyone sending us a message
>  		 */
> +		if (hdr->msgtype == SCSI_NL_HOST_PRIVATE) {
> +			shost = scsi_host_lookup(hdr->host_no);
> +			if (!shost) {
> +				printk(KERN_ERR "%s: scsi_host_lookup failed "
> +					"host no %u\n", __FUNCTION__, hdr->host_no);
> +			} else if (shost->hostt->netlink_rcv_msg) {
> +				err = shost->hostt->netlink_rcv_msg(shost,
> +					(void *)((char *)hdr+sizeof(*hdr)),
> +					hdr->msglen, NETLINK_CREDS(skb)->pid);
> +			}
> +		}

Finally getting this done :) Thanks!

If shost is not null you need to do a scsi_host_put hen you are done 
with the host.
