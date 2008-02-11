From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] scsi: ses fix mem leaking when fail to add intf
Date: Sun, 10 Feb 2008 21:27:41 -0800
Message-ID: <200802102127.42189.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802091515.48076.yinghai.lu@sun.com>
 <1202704118.3136.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1202704118.3136.79.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com
List-Id: linux-scsi@vger.kernel.org

On Sunday 10 February 2008 08:28:38 pm James Bottomley wrote:
> 
> On Sat, 2008-02-09 at 15:15 -0800, Yinghai Lu wrote:
> > [PATCH] scsi: ses fix mem leaking when fail to add intf
> > 
> > fix leaking with scomp leaking when failing.
> > also remove one extra space.
> 
> There are still a few extraneous code moves in this one.  This is about
> the correct minimal set, isn't it?


if buf allocation for page 7 get NULL...

if put 
+ if (!buf)
+	goto err_free;

still not right, because still undo 
  	edev = enclosure_register(cdev->dev, sdev->sdev_gendev.bus_id,
 				  components, &ses_enclosure_callbacks);

all just add 
+ if (!buf)
+	goto simple_populate;

there?

YH
