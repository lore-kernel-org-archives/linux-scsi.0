From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] add execute_in_process_context() API
Date: Tue, 7 Feb 2006 12:34:55 -0800
Message-ID: <20060207123455.7e19a2bf.akpm@osdl.org>
References: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
	<20060207202655.GD24775@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965083AbWBGUfv@vger.kernel.org>
In-Reply-To: <20060207202655.GD24775@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dave Jones <davej@redhat.com> wrote:
>
> On Tue, Feb 07, 2006 at 02:00:19PM -0600, James Bottomley wrote:
>  > +int execute_in_process_context(void (*fn)(void *data), void *data)
>  > +{
>  > +	struct work_queue_work *wqw;
>  > +
>  > +	if (!in_interrupt()) {
>  > +		fn(data);
>  > +		return 0;
>  > +	}
>  > +
>  > +	wqw = kmalloc(sizeof(struct work_queue_work), GFP_ATOMIC);
>  > +
>  > +	if (unlikely(!wqw)) {
>  > +		printk(KERN_ERR "Failed to allocate memory\n");
>  > +		WARN_ON(1);
>  > +		return -ENOMEM;
>  > +	}
>  > +
>  > +	INIT_WORK(&wqw->work, execute_in_process_context_work, wqw);
>  > +	wqw->fn = fn;
>  > +	wqw->data = data;
>  > +	schedule_work(&wqw->work);
>  > +
>  > +	return 1;
>  > +}
> 
> After the workqueue has run, what free's wqw ?
> 

The callback (execute_in_process_context_work())

The trap with this patch is that the caller has to run
flush_scheduled_work() at the right time.  But hopefully anyone who's using
it knows that by now.
