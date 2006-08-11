From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI and FC Transport: add netlink support for posting of transport events
Date: Thu, 10 Aug 2006 21:32:37 -0700
Message-ID: <20060811043237.GA29551@us.ibm.com>
References: <1155070439.6275.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:55529 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751176AbWHKEc3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 00:32:29 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7B4WSGL007660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 11 Aug 2006 00:32:28 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k7B4WR8p201436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 22:32:27 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7B4WRRM006697
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 22:32:27 -0600
Content-Disposition: inline
In-Reply-To: <1155070439.6275.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

James Smart <James.Smart@Emulex.Com> wrote:
> +/*
> + * FC Transport Broadcast Event Message :
> + *   FC_NL_ASYNC_EVENT
> + *
> + *   Note: if Vendor Unique message, &event_data will be  start of
> + * 	   vendor unique payload, and the length of the payload is
> + *         per event_datalen
> + */
> +struct fc_nl_event {
> +	struct scsi_nl_hdr snlh;		/* must be 1st element ! */
> +	uint64_t seconds;
> +	uint32_t vendor_id;
> +	uint16_t host_no;
> +	uint16_t event_datalen;
> +	uint32_t event_num;
> +	uint32_t event_code;
> +	uint32_t event_data;
> +} __attribute__((aligned(sizeof(uint64_t))));
> +
> .. snip ..
> +
> +/* SCSI_TRANSPORT_MSG event message header */
> +struct scsi_nl_hdr {
> +	uint8_t version;
> +	uint8_t transport;
> +	uint16_t magic;
> +	uint16_t msgtype;
> +	uint16_t msglen;
> +} __attribute__((aligned(sizeof(uint64_t))));
> +

What about using netlink attributes? The attributes do have more overhead,
but it would seem that using attributes instead of sending out a
whole structure would make it easier on the user space side to support
different kernel versions without syncing the tools with the kernel.

-andmike
--
Michael Anderson
andmike@us.ibm.com
