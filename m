From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support	for
 posting of transport events
Date: Wed, 30 Aug 2006 13:51:48 -0400
Message-ID: <44F5D034.20804@emulex.com>
References: <1155936609.12933.5.camel@localhost.localdomain> <1156959620.7701.6.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33199 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751255AbWH3Rvy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 13:51:54 -0400
In-Reply-To: <1156959620.7701.6.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Looks fine to me...

Please note the later patch that updated the vendor id to 64 bits.
http://marc.theaimsgroup.com/?l=linux-scsi&m=115625508127308&w=2

-- james s

PS: for anyone interested, I do have some additional code snippets that
   adds netlink msg receive support. No real reason for it now, though...


James Bottomley wrote:
> OK ... I looked through this, but I'm not at all keen on entangling SCSI
> with NET (i.e. requiring NET if SCSI is selected).
> 
> How about doing it this way?
> 
> James
> 
> ---
> Index: BUILD-2.6/drivers/scsi/Kconfig
> ===================================================================
> --- BUILD-2.6.orig/drivers/scsi/Kconfig	2006-08-29 10:54:52.000000000 -0500
> +++ BUILD-2.6/drivers/scsi/Kconfig	2006-08-30 12:25:59.000000000 -0500
> @@ -27,6 +27,11 @@ config SCSI
>  	  However, do not compile this as a module if your root file system
>  	  (the one containing the directory /) is located on a SCSI device.
>  
> +config SCSI_NETLINK
> +	tristate
> +	default	n
> +	select NET
> +
>  config SCSI_PROC_FS
>  	bool "legacy /proc/scsi/ support"
>  	depends on SCSI && PROC_FS
> @@ -222,6 +227,7 @@ config SCSI_SPI_ATTRS
>  config SCSI_FC_ATTRS
>  	tristate "FiberChannel Transport Attributes"
>  	depends on SCSI
> +	select SCSI_NETLINK
>  	help
>  	  If you wish to export transport-specific information about
>  	  each attached FiberChannel device to sysfs, say Y.
> Index: BUILD-2.6/drivers/scsi/Makefile
> ===================================================================
> --- BUILD-2.6.orig/drivers/scsi/Makefile	2006-08-29 10:54:52.000000000 -0500
> +++ BUILD-2.6/drivers/scsi/Makefile	2006-08-30 12:25:59.000000000 -0500
> @@ -143,6 +143,7 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioct
>  				   scsicam.o scsi_error.o scsi_lib.o \
>  				   scsi_scan.o scsi_sysfs.o \
>  				   scsi_devinfo.o
> +scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
>  scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
>  scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
>  
> Index: BUILD-2.6/drivers/scsi/scsi.c
> ===================================================================
> --- BUILD-2.6.orig/drivers/scsi/scsi.c	2006-08-29 09:53:39.000000000 -0500
> +++ BUILD-2.6/drivers/scsi/scsi.c	2006-08-30 12:25:59.000000000 -0500
> @@ -1115,6 +1115,8 @@ static int __init init_scsi(void)
>  	for_each_possible_cpu(i)
>  		INIT_LIST_HEAD(&per_cpu(scsi_done_q, i));
>  
> +	scsi_netlink_init();
> +
>  	printk(KERN_NOTICE "SCSI subsystem initialized\n");
>  	return 0;
>  
> @@ -1135,6 +1137,7 @@ cleanup_queue:
>  
>  static void __exit exit_scsi(void)
>  {
> +	scsi_netlink_exit();
>  	scsi_sysfs_unregister();
>  	scsi_exit_sysctl();
>  	scsi_exit_hosts();
> Index: BUILD-2.6/drivers/scsi/scsi_netlink.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ BUILD-2.6/drivers/scsi/scsi_netlink.c	2006-08-30 12:25:59.000000000 -0500
> @@ -0,0 +1,199 @@
> +/*
> + *  scsi_netlink.c  - SCSI Transport Netlink Interface
> + *
> + *  Copyright (C) 2006   James Smart, Emulex Corporation
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +#include <linux/time.h>
> +#include <linux/jiffies.h>
> +#include <linux/security.h>
> +#include <net/sock.h>
> +#include <net/netlink.h>
> +
> +#include <scsi/scsi_netlink.h>
> +#include "scsi_priv.h"
> +
> +struct sock *scsi_nl_sock = NULL;
> +EXPORT_SYMBOL_GPL(scsi_nl_sock);
> +
> +
> +/**
> + * scsi_nl_rcv_msg -
> + *    Receive message handler. Extracts message from a receive buffer.
> + *    Validates message header and calls appropriate transport message handler
> + *
> + * @skb:		socket receive buffer
> + *
> + **/
> +static void
> +scsi_nl_rcv_msg(struct sk_buff *skb)
> +{
> +	struct nlmsghdr *nlh;
> +	struct scsi_nl_hdr *hdr;
> +	uint32_t rlen;
> +	int err;
> +
> +	while (skb->len >= NLMSG_SPACE(0)) {
> +		err = 0;
> +
> +		nlh = (struct nlmsghdr *) skb->data;
> +		if ((nlh->nlmsg_len < (sizeof(*nlh) + sizeof(*hdr))) ||
> +		    (skb->len < nlh->nlmsg_len)) {
> +			printk(KERN_WARNING "%s: discarding partial skb\n",
> +				 __FUNCTION__);
> +			return;
> +		}
> +
> +		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
> +		if (rlen > skb->len)
> +			rlen = skb->len;
> +
> +		if (nlh->nlmsg_type != SCSI_TRANSPORT_MSG) {
> +			err = -EBADMSG;
> +			goto next_msg;
> +		}
> +
> +		hdr = NLMSG_DATA(nlh);
> +		if ((hdr->version != SCSI_NL_VERSION) ||
> +		    (hdr->magic != SCSI_NL_MAGIC)) {
> +			err = -EPROTOTYPE;
> +			goto next_msg;
> +		}
> +
> +		if (security_netlink_recv(skb, CAP_SYS_ADMIN)) {
> +			err = -EPERM;
> +			goto next_msg;
> +		}
> +
> +		if (nlh->nlmsg_len < (sizeof(*nlh) + hdr->msglen)) {
> +			printk(KERN_WARNING "%s: discarding partial message\n",
> +				 __FUNCTION__);
> +			return;
> +		}
> +
> +		/*
> +		 * We currently don't support anyone sending us a message
> +		 */
> +
> +next_msg:
> +		if ((err) || (nlh->nlmsg_flags & NLM_F_ACK))
> +			netlink_ack(skb, nlh, err);
> +
> +		skb_pull(skb, rlen);
> +	}
> +}
> +
> +
> +/**
> + * scsi_nl_rcv_msg -
> + *    Receive handler for a socket. Extracts a received message buffer from
> + *    the socket, and starts message processing.
> + *
> + * @sk:		socket
> + * @len:	unused
> + *
> + **/
> +static void
> +scsi_nl_rcv(struct sock *sk, int len)
> +{
> +	struct sk_buff *skb;
> +
> +	while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
> +		scsi_nl_rcv_msg(skb);
> +		kfree_skb(skb);
> +	}
> +}
> +
> +
> +/**
> + * scsi_nl_rcv_event -
> + *    Event handler for a netlink socket.
> + *
> + * @this:		event notifier block
> + * @event:		event type
> + * @ptr:		event payload
> + *
> + **/
> +static int
> +scsi_nl_rcv_event(struct notifier_block *this, unsigned long event, void *ptr)
> +{
> +	struct netlink_notify *n = ptr;
> +
> +	if (n->protocol != NETLINK_SCSITRANSPORT)
> +		return NOTIFY_DONE;
> +
> +	/*
> +	 * Currently, we are not tracking PID's, etc. There is nothing
> +	 * to handle.
> +	 */
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block scsi_netlink_notifier = {
> +	.notifier_call  = scsi_nl_rcv_event,
> +};
> +
> +
> +/**
> + * scsi_netlink_init -
> + *    Called by SCSI subsystem to intialize the SCSI transport netlink
> + *    interface
> + *
> + **/
> +void
> +scsi_netlink_init(void)
> +{
> +	int error;
> +
> +	error = netlink_register_notifier(&scsi_netlink_notifier);
> +	if (error) {
> +		printk(KERN_ERR "%s: register of event handler failed - %d\n",
> +				__FUNCTION__, error);
> +		return;
> +	}
> +
> +	scsi_nl_sock = netlink_kernel_create(NETLINK_SCSITRANSPORT,
> +				SCSI_NL_GRP_CNT, scsi_nl_rcv, THIS_MODULE);
> +	if (!scsi_nl_sock) {
> +		printk(KERN_ERR "%s: register of recieve handler failed\n",
> +				__FUNCTION__);
> +		netlink_unregister_notifier(&scsi_netlink_notifier);
> +	}
> +
> +	return;
> +}
> +
> +
> +/**
> + * scsi_netlink_exit -
> + *    Called by SCSI subsystem to disable the SCSI transport netlink
> + *    interface
> + *
> + **/
> +void
> +scsi_netlink_exit(void)
> +{
> +	if (scsi_nl_sock) {
> +		sock_release(scsi_nl_sock->sk_socket);
> +		netlink_unregister_notifier(&scsi_netlink_notifier);
> +	}
> +
> +	return;
> +}
> +
> +
> Index: BUILD-2.6/drivers/scsi/scsi_priv.h
> ===================================================================
> --- BUILD-2.6.orig/drivers/scsi/scsi_priv.h	2006-08-27 23:39:16.000000000 -0500
> +++ BUILD-2.6/drivers/scsi/scsi_priv.h	2006-08-30 12:38:15.000000000 -0500
> @@ -8,6 +8,7 @@ struct scsi_cmnd;
>  struct scsi_device;
>  struct scsi_host_template;
>  struct Scsi_Host;
> +struct scsi_nl_hdr;
>  
>  
>  /*
> @@ -110,6 +111,16 @@ extern void __scsi_remove_device(struct 
>  
>  extern struct bus_type scsi_bus_type;
>  
> +/* scsi_netlink.c */
> +#ifdef CONFIG_SCSI_NETLINK
> +extern void scsi_netlink_init(void);
> +extern void scsi_netlink_exit(void);
> +extern struct sock *scsi_nl_sock;
> +#else
> +static inline void scsi_netlink_init(void) {}
> +static inline void scsi_netlink_exit(void) {}
> +#endif
> +
>  /* 
>   * internal scsi timeout functions: for use by mid-layer and transport
>   * classes.
> Index: BUILD-2.6/drivers/scsi/scsi_transport_fc.c
> ===================================================================
> --- BUILD-2.6.orig/drivers/scsi/scsi_transport_fc.c	2006-08-29 09:53:39.000000000 -0500
> +++ BUILD-2.6/drivers/scsi/scsi_transport_fc.c	2006-08-30 12:25:59.000000000 -0500
> @@ -32,6 +32,9 @@
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_transport_fc.h>
>  #include <scsi/scsi_cmnd.h>
> +#include <linux/netlink.h>
> +#include <net/netlink.h>
> +#include <scsi/scsi_netlink_fc.h>
>  #include "scsi_priv.h"
>  
>  static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
> @@ -93,6 +96,29 @@ fc_enum_name_search(port_type, fc_port_t
>  #define FC_PORTTYPE_MAX_NAMELEN		50
>  
>  
> +/* Convert fc_host_event_code values to ascii string name */
> +static const struct {
> +	enum fc_host_event_code		value;
> +	char				*name;
> +} fc_host_event_code_names[] = {
> +	{ FCH_EVT_LIP,			"lip" },
> +	{ FCH_EVT_LINKUP,		"link_up" },
> +	{ FCH_EVT_LINKDOWN,		"link_down" },
> +	{ FCH_EVT_LIPRESET,		"lip_reset" },
> +	{ FCH_EVT_RSCN,			"rscn" },
> +	{ FCH_EVT_ADAPTER_CHANGE,	"adapter_chg" },
> +	{ FCH_EVT_PORT_UNKNOWN,		"port_unknown" },
> +	{ FCH_EVT_PORT_ONLINE,		"port_online" },
> +	{ FCH_EVT_PORT_OFFLINE,		"port_offline" },
> +	{ FCH_EVT_PORT_FABRIC,		"port_fabric" },
> +	{ FCH_EVT_LINK_UNKNOWN,		"link_unknown" },
> +	{ FCH_EVT_VENDOR_UNIQUE,	"vendor_unique" },
> +};
> +fc_enum_name_search(host_event_code, fc_host_event_code,
> +		fc_host_event_code_names)
> +#define FC_HOST_EVENT_CODE_MAX_NAMELEN	30
> +
> +
>  /* Convert fc_port_state values to ascii string name */
>  static struct {
>  	enum fc_port_state	value;
> @@ -377,10 +403,182 @@ MODULE_PARM_DESC(dev_loss_tmo,
>  		 " exceeded, the scsi target is removed. Value should be"
>  		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
>  
> +/**
> + * Netlink Infrastructure
> + **/
> +
> +static atomic_t fc_event_seq;
> +
> +/**
> + * fc_get_event_number - Obtain the next sequential FC event number
> + *
> + * Notes:
> + *   We could have inline'd this, but it would have required fc_event_seq to
> + *   be exposed. For now, live with the subroutine call.
> + *   Atomic used to avoid lock/unlock...
> + **/
> +u32
> +fc_get_event_number(void)
> +{
> +	return atomic_add_return(1, &fc_event_seq);
> +}
> +EXPORT_SYMBOL(fc_get_event_number);
> +
> +
> +/**
> + * fc_host_post_event - called to post an even on an fc_host.
> + *
> + * @shost:		host the event occurred on
> + * @event_number:	fc event number obtained from get_fc_event_number()
> + * @event_code:		fc_host event being posted
> + * @event_data:		32bits of data for the event being posted
> + *
> + * Notes:
> + *	This routine assumes no locks are held on entry.
> + **/
> +void
> +fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
> +		enum fc_host_event_code event_code, u32 event_data)
> +{
> +	struct sk_buff *skb;
> +	struct nlmsghdr	*nlh;
> +	struct fc_nl_event *event;
> +	const char *name;
> +	u32 len, skblen;
> +	int err;
> +
> +	if (!scsi_nl_sock) {
> +		err = -ENOENT;
> +		goto send_fail;
> +	}
> +
> +	len = FC_NL_MSGALIGN(sizeof(*event));
> +	skblen = NLMSG_SPACE(len);
> +
> +	skb = alloc_skb(skblen, GFP_KERNEL);
> +	if (!skb) {
> +		err = -ENOBUFS;
> +		goto send_fail;
> +	}
> +
> +	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
> +				skblen - sizeof(*nlh), 0);
> +	if (!nlh) {
> +		err = -ENOBUFS;
> +		goto send_fail_skb;
> +	}
> +	event = NLMSG_DATA(nlh);
> +
> +	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
> +				FC_NL_ASYNC_EVENT, len);
> +	event->seconds = get_seconds();
> +	event->vendor_id = 0;
> +	event->host_no = shost->host_no;
> +	event->event_datalen = sizeof(u32);	/* bytes */
> +	event->event_num = event_number;
> +	event->event_code = event_code;
> +	event->event_data = event_data;
> +
> +	err = nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS);
> +	if (err && (err != -ESRCH))	/* filter no recipient errors */
> +		/* nlmsg_multicast already kfree_skb'd */
> +		goto send_fail;
> +
> +	return;
> +
> +send_fail_skb:
> +	kfree_skb(skb);
> +send_fail:
> +	name = get_fc_host_event_code_name(event_code);
> +	printk(KERN_WARNING
> +		"%s: Dropped Event : host %d %s data 0x%08x - err %d\n",
> +		__FUNCTION__, shost->host_no,
> +		(name) ? name : "<unknown>", event_data, err);
> +	return;
> +}
> +EXPORT_SYMBOL(fc_host_post_event);
> +
> +
> +/**
> + * fc_host_post_vendor_event - called to post a vendor unique event on
> + *                             a fc_host
> + *
> + * @shost:		host the event occurred on
> + * @event_number:	fc event number obtained from get_fc_event_number()
> + * @data_len:		amount, in bytes, of vendor unique data
> + * @data_buf:		pointer to vendor unique data
> + *
> + * Notes:
> + *	This routine assumes no locks are held on entry.
> + **/
> +void
> +fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
> +		u32 data_len, char * data_buf, u32 vendor_id)
> +{
> +	struct sk_buff *skb;
> +	struct nlmsghdr	*nlh;
> +	struct fc_nl_event *event;
> +	u32 len, skblen;
> +	int err;
> +
> +	if (!scsi_nl_sock) {
> +		err = -ENOENT;
> +		goto send_vendor_fail;
> +	}
> +
> +	len = FC_NL_MSGALIGN(sizeof(*event) + data_len);
> +	skblen = NLMSG_SPACE(len);
> +
> +	skb = alloc_skb(skblen, GFP_KERNEL);
> +	if (!skb) {
> +		err = -ENOBUFS;
> +		goto send_vendor_fail;
> +	}
> +
> +	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
> +				skblen - sizeof(*nlh), 0);
> +	if (!nlh) {
> +		err = -ENOBUFS;
> +		goto send_vendor_fail_skb;
> +	}
> +	event = NLMSG_DATA(nlh);
> +
> +	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
> +				FC_NL_ASYNC_EVENT, len);
> +	event->seconds = get_seconds();
> +	event->vendor_id = vendor_id;
> +	event->host_no = shost->host_no;
> +	event->event_datalen = data_len;	/* bytes */
> +	event->event_num = event_number;
> +	event->event_code = FCH_EVT_VENDOR_UNIQUE;
> +	memcpy(&event->event_data, data_buf, data_len);
> +
> +	err = nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS);
> +	if (err && (err != -ESRCH))	/* filter no recipient errors */
> +		/* nlmsg_multicast already kfree_skb'd */
> +		goto send_vendor_fail;
> +
> +	return;
> +
> +send_vendor_fail_skb:
> +	kfree_skb(skb);
> +send_vendor_fail:
> +	printk(KERN_WARNING
> +		"%s: Dropped Event : host %d vendor_unique - err %d\n",
> +		__FUNCTION__, shost->host_no, err);
> +	return;
> +}
> +EXPORT_SYMBOL(fc_host_post_vendor_event);
> +
> +
>  
>  static __init int fc_transport_init(void)
>  {
> -	int error = transport_class_register(&fc_host_class);
> +	int error;
> +
> +	atomic_set(&fc_event_seq, 0);
> +
> +	error = transport_class_register(&fc_host_class);
>  	if (error)
>  		return error;
>  	error = transport_class_register(&fc_rport_class);
> Index: BUILD-2.6/include/linux/netlink.h
> ===================================================================
> --- BUILD-2.6.orig/include/linux/netlink.h	2006-08-27 23:39:23.000000000 -0500
> +++ BUILD-2.6/include/linux/netlink.h	2006-08-30 12:25:59.000000000 -0500
> @@ -21,6 +21,8 @@
>  #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
>  #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
>  #define NETLINK_GENERIC		16
> +/* leave room for NETLINK_DM (DM Events) */
> +#define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
>  
>  #define MAX_LINKS 32		
>  
> Index: BUILD-2.6/include/scsi/scsi_netlink_fc.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ BUILD-2.6/include/scsi/scsi_netlink_fc.h	2006-08-30 12:25:59.000000000 -0500
> @@ -0,0 +1,71 @@
> +/*
> + *  FC Transport Netlink Interface
> + *
> + *  Copyright (C) 2006   James Smart, Emulex Corporation
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +#ifndef SCSI_NETLINK_FC_H
> +#define SCSI_NETLINK_FC_H
> +
> +#include <scsi/scsi_netlink.h>
> +
> +/*
> + * This file intended to be included by both kernel and user space
> + */
> +
> +/*
> + * FC Transport Message Types
> + */
> +	/* kernel -> user */
> +#define FC_NL_ASYNC_EVENT			0x0100
> +	/* user -> kernel */
> +/* none */
> +
> +
> +/*
> + * Message Structures :
> + */
> +
> +/* macro to round up message lengths to 8byte boundary */
> +#define FC_NL_MSGALIGN(len)		(((len) + 7) & ~7)
> +
> +
> +/*
> + * FC Transport Broadcast Event Message :
> + *   FC_NL_ASYNC_EVENT
> + *
> + * Note: if Vendor Unique message, &event_data will be  start of
> + * 	 vendor unique payload, and the length of the payload is
> + *       per event_datalen
> + *
> + * Note: When specifying vendor_id, be sure to read the Vendor Type and ID
> + *   formatting requirements specified in scsi_netlink.h
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
> +
> +#endif /* SCSI_NETLINK_FC_H */
> +
> Index: BUILD-2.6/include/scsi/scsi_netlink.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ BUILD-2.6/include/scsi/scsi_netlink.h	2006-08-30 12:25:59.000000000 -0500
> @@ -0,0 +1,86 @@
> +/*
> + *  SCSI Transport Netlink Interface
> + *    Used for the posting of outbound SCSI transport events
> + *
> + *  Copyright (C) 2006   James Smart, Emulex Corporation
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +#ifndef SCSI_NETLINK_H
> +#define SCSI_NETLINK_H
> +
> +/*
> + * This file intended to be included by both kernel and user space
> + */
> +
> +/* Single Netlink Message type to send all SCSI Transport messages */
> +#define SCSI_TRANSPORT_MSG		NLMSG_MIN_TYPE + 1
> +
> +/* SCSI Transport Broadcast Groups */
> +	/* leaving groups 0 and 1 unassigned */
> +#define SCSI_NL_GRP_FC_EVENTS		(1<<2)		/* Group 2 */
> +#define SCSI_NL_GRP_CNT			3
> +
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
> +/* scsi_nl_hdr->version value */
> +#define SCSI_NL_VERSION				1
> +
> +/* scsi_nl_hdr->magic value */
> +#define SCSI_NL_MAGIC				0xA1B2
> +
> +/* scsi_nl_hdr->transport value */
> +#define SCSI_NL_TRANSPORT			0
> +#define SCSI_NL_TRANSPORT_FC			1
> +#define SCSI_NL_MAX_TRANSPORTS			2
> +
> +/* scsi_nl_hdr->msgtype values are defined in each transport */
> +
> +
> +/*
> + * Vendor ID:
> + *   If transports post vendor-unique events, they must pass a well-known
> + *   32-bit vendor identifier. This identifier consists of 8 bits indicating
> + *   the "type" of identifier contained, and 24 bits of id data.
> + *
> + *   Identifiers for each type:
> + *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
> + */
> +#define SCSI_NL_VID_ID_MASK			0x00FFFFFF
> +#define SCSI_NL_VID_TYPE_MASK			0xFF000000
> +#define SCSI_NL_VID_TYPE_PCI			0x01000000
> +
> +
> +#define INIT_SCSI_NL_HDR(hdr, t, mtype, mlen)			\
> +	{							\
> +	(hdr)->version = SCSI_NL_VERSION;			\
> +	(hdr)->transport = t;					\
> +	(hdr)->magic = SCSI_NL_MAGIC;				\
> +	(hdr)->msgtype = mtype;					\
> +	(hdr)->msglen = mlen;					\
> +	}
> +
> +
> +#endif /* SCSI_NETLINK_H */
> +
> Index: BUILD-2.6/include/scsi/scsi_transport_fc.h
> ===================================================================
> --- BUILD-2.6.orig/include/scsi/scsi_transport_fc.h	2006-08-29 09:53:39.000000000 -0500
> +++ BUILD-2.6/include/scsi/scsi_transport_fc.h	2006-08-30 12:25:59.000000000 -0500
> @@ -29,6 +29,7 @@
>  
>  #include <linux/sched.h>
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_netlink.h>
>  
>  struct scsi_transport_template;
>  
> @@ -284,6 +285,30 @@ struct fc_host_statistics {
>  
>  
>  /*
> + * FC Event Codes - Polled and Async, following FC HBAAPI v2.0 guidelines
> + */
> +
> +/*
> + * fc_host_event_code: If you alter this, you also need to alter
> + * scsi_transport_fc.c (for the ascii descriptions).
> + */
> +enum fc_host_event_code  {
> +	FCH_EVT_LIP			= 0x1,
> +	FCH_EVT_LINKUP			= 0x2,
> +	FCH_EVT_LINKDOWN		= 0x3,
> +	FCH_EVT_LIPRESET		= 0x4,
> +	FCH_EVT_RSCN			= 0x5,
> +	FCH_EVT_ADAPTER_CHANGE		= 0x103,
> +	FCH_EVT_PORT_UNKNOWN		= 0x200,
> +	FCH_EVT_PORT_OFFLINE		= 0x201,
> +	FCH_EVT_PORT_ONLINE		= 0x202,
> +	FCH_EVT_PORT_FABRIC		= 0x204,
> +	FCH_EVT_LINK_UNKNOWN		= 0x500,
> +	FCH_EVT_VENDOR_UNIQUE		= 0xffff,
> +};
> +
> +
> +/*
>   * FC Local Port (Host) Attributes
>   *
>   * Attributes are based on HBAAPI V2.0 definitions.
> @@ -526,5 +551,14 @@ struct fc_rport *fc_remote_port_add(stru
>  void fc_remote_port_delete(struct fc_rport  *rport);
>  void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
>  int scsi_is_fc_rport(const struct device *);
> +u32 fc_get_event_number(void);
> +void fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
> +		enum fc_host_event_code event_code, u32 event_data);
> +void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
> +		u32 data_len, char * data_buf, u32 vendor_id);
> +	/* Note: when specifying vendor_id to fc_host_post_vendor_event()
> +	 *   be sure to read the Vendor Type and ID formatting requirements
> +	 *   specified in scsi_netlink.h
> +	 */
>  
>  #endif /* SCSI_TRANSPORT_FC_H */
> 
> 
> 
