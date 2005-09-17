From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sat, 17 Sep 2005 19:48:32 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509171944080.10503@kai.makisara.local>
References: <1126845599.9276.44.camel@max> <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
 <Pine.LNX.4.61.0509171840110.10503@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:42716 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751146AbVIQQnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 12:43:09 -0400
In-Reply-To: <Pine.LNX.4.61.0509171840110.10503@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Sat, 17 Sep 2005, Kai Makisara wrote:

> On Sat, 17 Sep 2005, Kai Makisara wrote:
> 
> > On Thu, 15 Sep 2005, Mike Christie wrote:
> > 
> ...
> > This is not a real solution though. There should be some control over 
> > retries from the scsi ULDs but I did not directly see how to do it. 
> > Looking at the tests I did a couple of days, the number of retries seemed 
> > to be variable (i.e., the number of retries I saw in the same test today 
> > and a couple of days ago didn't match).
> > 
> I have looked the retries more and there seems to be several problems 
> somewhere, not necessarily in your new code. I don't have any answers but 
> here is data from one of my experiments. I had debugging enabled in 
> st and added a printk to st_sleep_done to see what results st gets from 
> the requests.
> 
...
> Sep 17 14:12:10 box kernel: st: cmd=0x00 result=0x0 resid=10240 sense[0]=0x00
>                                                     ^^^^^^^^^^^
> The resid here seems to have been "inherited" from the previous command.

Can be a bug in sym53c8xx_2.

>         I don't know how old these problems are because earlier the SCSI 
> subsystem has used the retries parameter and not even "thought" about 
> retrying the tape commands.
> 
I tried 2.6.14-rc1 (changed st.c to allow 5 read retries). This did 
not show any errors (no retries were done).

-- 
Kai
