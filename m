From: Doug Ledford <dledford@redhat.com>
Subject: Re: aix7xxx driver 5.2.4/5.2.0 vs. 6.2.5 with onboard aic7896/97 Ultra2 controller
Date: Tue, 7 May 2002 10:45:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020507104517.C21626@redhat.com>
References: <3CD7E47A.10809@hol.gr> <200205071431.g47EVI906181@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aladin.rdu.redhat.com (aladin.rdu.redhat.com [172.16.57.71])
	by lacrosse.corp.redhat.com (8.11.6/8.9.3) with ESMTP id g47EjHf21595
	for <linux-scsi@vger.kernel.org>; Tue, 7 May 2002 10:45:17 -0400
Received: (from dledford@localhost)
	by aladin.rdu.redhat.com (8.11.6/8.11.6) id g47EjHb21645
	for linux-scsi@vger.kernel.org; Tue, 7 May 2002 10:45:17 -0400
Content-Disposition: inline
In-Reply-To: <200205071431.g47EVI906181@aslan.scsiguy.com>; from gibbs@scsiguy.com on Tue, May 07, 2002 at 08:31:18AM -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, May 07, 2002 at 08:31:18AM -0600, Justin T. Gibbs wrote:
> The old driver works around this issue by treating a valid but slow
> sync rate as the fastest rate.

Not intentionally.  If that's why my driver is getting the higher rate 
then it's a bug in the driver.  It was never intended to ignore slow speed 
settings in the serial eeprom.

Ahhh...I know what it is...there were, back in the day when the 7895 was 
new, some BIOS versions that used odd combinations for slow speeds vs. 
high speeds, so there are a few specific instances of things in the driver 
that would cause a particular low speed to get bumped to a higher speed.  
At the time, the problem machines were showing up as 10MB/s when they were 
suppossed to be 20 or 40MB/s.  So, this particular BIOS may have left 
around the same type of speed encoding as those older trouble machines.  
I'd be interested to know if changing the speed and saving it, then 
changing it back and saving it does solve the problem.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
