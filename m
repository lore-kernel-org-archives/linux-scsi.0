From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 17:39:38 -0700
Message-ID: <20050823003938.GA29211@us.ibm.com>
References: <1124723180.5211.25.camel@mulgrave> <20050822214617.GA26441@us.ibm.com> <1124747956.5211.38.camel@mulgrave> <20050822221427.GA26767@us.ibm.com> <1124750826.5211.46.camel@mulgrave> <1124753185.5211.50.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:49330 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S932289AbVHWAlL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 20:41:11 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7N0deF3137258
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 20:39:42 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7N0dAcX420214
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 18:39:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7N0dd1l012958
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 18:39:40 -0600
Content-Disposition: inline
In-Reply-To: <1124753185.5211.50.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Mon, Aug 22, 2005 at 06:26:25PM -0500, James Bottomley wrote:
> On Mon, 2005-08-22 at 17:47 -0500, James Bottomley wrote:
> > One apparent, but rather nasty, solution would be to embed object get
> > and put into the klist head as functions that take the node, so
> > klist_next would take the object reference as well as the list kref,
> > then drop it on klist_release.
> 
> Well, I'm not enormously fond of this, but it's not as downright nasty
> as I thought.  Patrick, could you try this (assuming you have a fast
> machine ... I'll be done with the complete kernel rebuild that touching
> klist.h requires eventually) you'll have to encode klist to device get
> and put functions and feed them to klist_init_embedded().

But, we have to pass in a struct kref, to affect put/get_device, correct?

While klist (and your patch) need klist_node. These pieces:

> +	void			(*get)(struct klist_node *);
> +	void			(*put)(struct klist_node *);

> +void klist_init_embedded(struct klist * k, void (*get)(struct klist_node *),
> +			 void (*put)(struct klist_node *))
>  {
>  	INIT_LIST_HEAD(&k->k_list);
>  	spin_lock_init(&k->k_lock);
> +	k->get = get;
> +	k->put = put;
>  }

In include/linux/device.h we have:

struct device {

	...
	struct kobject kobj;
	...
}

And get/put_device are:

struct kobject * kobject_get(struct kobject * kobj)
{
        if (kobj)
                kref_get(&kobj->kref);
        return kobj;
}

And then:

void kref_get(struct kref *kref)
{
        WARN_ON(!atomic_read(&kref->refcount));
        atomic_inc(&kref->refcount);
}

-- Patrick Mansfield
