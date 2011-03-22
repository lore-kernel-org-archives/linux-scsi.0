From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] [RFC] iscsi_transport: show network configuration
 in sysfs
Date: Mon, 21 Mar 2011 23:43:01 -0500
Message-ID: <4D8828D5.4000200@cs.wisc.edu>
References: <5E4F49720D0BAD499EE1F01232234BA8722624A356@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58794 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1CVEm1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2011 00:42:27 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA8722624A356@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Sorry for the late review comments.

On 02/25/2011 05:08 AM, Vikas Chaudhary wrote:
> +static int iscsi_match_ifaceid(struct device *dev, void *data)
> +{
> +       struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
> +       uint64_t *ifaceid = (uint64_t *) data;
> +
> +       return *ifaceid == iface->id;
> +}
> +
> +struct iscsi_iface *
> +iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
> +                  uint32_t iface_type, uint32_t iface_num, int dd_size)
> +{
> +       struct device *dev;
> +       struct iscsi_iface *iface;
> +       uint64_t id;
> +       int err;
> +
> +       for (id = 1; id<  ISCSI_MAX_IFACEID; id++) {
> +               dev = class_find_device(&iscsi_iface_class, NULL,&id,
> +                                       iscsi_match_ifaceid);
> +               if (!dev)
> +                       break;
> +       }


That loop was a mistake on my part. I think you should use idr. When I 
did that loop for the ep code I was thinking that we would only have a 
couple sessions - maybe 8 would be most common. However, with virtual 
ports we are ending up with lots and lots.


> +       if (id == ISCSI_MAX_IFACEID) {
> +               printk(KERN_ERR "Too many iface. Max supported %u\n",
> +                               ISCSI_MAX_IFACEID - 1);
> +               return NULL;
> +       }
> +
> +       iface = kzalloc(sizeof(*iface) + dd_size, GFP_KERNEL);
> +       if (!iface)
> +               return NULL;
> +
> +       iface->id = id;
> +       iface->transport = transport;
> +       iface->iface_type = iface_type;
> +       iface->iface_num = iface_num;
> +       iface->dev.class =&iscsi_iface_class;
> +       /* parent reference */
> +       iface->dev.parent = get_device(&shost->shost_gendev);
> +       if (iface_type == IFACE_TYPE_IPV4)
> +               dev_set_name(&iface->dev, "ipv4-iface-%u-%u", shost->host_no,
> +                            iface_num);
> +       else if (iface_type == IFACE_TYPE_IPV6)
> +               dev_set_name(&iface->dev, "ipv6-iface-%u-%u", shost->host_no,
> +                            iface_num);


Is this supposed to have the "[" "]" around the address for ipv6, and 
who adds that. Is the driver or class? If drivers are adding it then 
fine, if not then we should have the api do it.


Thanks for working on this.
