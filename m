From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] FC Transport : Async Events via netlink interface
Date: Tue, 18 Apr 2006 09:01:21 -0700
Message-ID: <20060418160121.GA2707@us.ibm.com>
References: <1145306661.4151.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:8116 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750807AbWDRQBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 12:01:23 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3IG1Mej002009
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 12:01:22 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3IFvjMS265168
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 09:57:45 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k3IG1MnU026393
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 10:01:22 -0600
Content-Disposition: inline
In-Reply-To: <1145306661.4151.0.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

Looks good, comments below.

James Smart <James.Smart@Emulex.Com> wrote:
> +static void
> +fc_send_event(struct fc_nl_user *nluser, struct fc_nl_event *event)
> +{
> +	struct sk_buff *skb;
> +	struct nlmsghdr	*nlh;
> +	struct fc_nl_event *evt;
> +	const char *name, *fn;
> +	u32 len = NLMSG_SPACE(sizeof(*event));
> +	int err;
> +
> +	skb = alloc_skb(len, GFP_KERNEL);
> +	if (!skb) {
> +		err = -ENOBUFS;
> +		fn = "alloc_skb";
> +		goto send_fail;
> +	}
> +
> +	nlh = nlmsg_put(skb, nluser->pid, 0, FC_TRANSPORT_MSG,
> +			len - sizeof(*nlh), 0);
> +	if (!nlh) {
> +		err = -ENOBUFS;
> +		fn = "nlmsg_put";
> +		goto send_fail;
> +	}
> +	evt = NLMSG_DATA(nlh);
> +	memcpy(evt, event, sizeof(*event));
> +
> +	err = nlmsg_unicast(fc_nl_sock, skb, nluser->pid);
> +	if (err < 0) {
> +		fn = "nlmsg_unicast";
> +		goto send_fail;
> +	}

Is there some reason that you are not using nlmsg_multicast. The caller of
this function is somewhat simulating the function of multicast.

> +
> +	return;
> +
> +send_fail:
> +	name = get_fc_host_event_code_name(event->event_code);
> +	printk(KERN_WARNING
> +		"%s: Dropped Event to PID %d : %s data 0x%08x : %s : err %d\n",
> +		__FUNCTION__, nluser->pid, (name) ? name : "<unknown>",
> +		event->event_data, fn, err);
> +	return;
> +}

In the send_fail case it looks like you leak skbs. Do you need to add a
call to nlmsg_free or kfree_skb?


-andmike
--
Michael Anderson
andmike@us.ibm.com
