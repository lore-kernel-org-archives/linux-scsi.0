From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] add execute_in_process_context() API
Date: Tue, 7 Feb 2006 15:26:55 -0500
Message-ID: <20060207202655.GD24775@redhat.com>
References: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45976 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964881AbWBGU1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 15:27:08 -0500
Content-Disposition: inline
In-Reply-To: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Tue, Feb 07, 2006 at 02:00:19PM -0600, James Bottomley wrote:
 > +int execute_in_process_context(void (*fn)(void *data), void *data)
 > +{
 > +	struct work_queue_work *wqw;
 > +
 > +	if (!in_interrupt()) {
 > +		fn(data);
 > +		return 0;
 > +	}
 > +
 > +	wqw = kmalloc(sizeof(struct work_queue_work), GFP_ATOMIC);
 > +
 > +	if (unlikely(!wqw)) {
 > +		printk(KERN_ERR "Failed to allocate memory\n");
 > +		WARN_ON(1);
 > +		return -ENOMEM;
 > +	}
 > +
 > +	INIT_WORK(&wqw->work, execute_in_process_context_work, wqw);
 > +	wqw->fn = fn;
 > +	wqw->data = data;
 > +	schedule_work(&wqw->work);
 > +
 > +	return 1;
 > +}

After the workqueue has run, what free's wqw ?

		Dave

