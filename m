From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: Conversion to generic boolean
Date: Mon, 28 Aug 2006 12:15:40 -0700
Message-ID: <1156792540.2367.2.camel@entropy>
References: <44EFBEFA.2010707@student.ltu.se>
	 <20060828093202.GC8980@infradead.org>
	 <Pine.LNX.4.61.0608281255100.14305@yvahk01.tjqt.qr>
	 <44F2DEDC.3020608@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:25474 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S1751363AbWH1TPn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 15:15:43 -0400
In-Reply-To: <44F2DEDC.3020608@student.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2006-08-28 at 14:17 +0200, Richard Knutsson wrote:
> Jan Engelhardt wrote:
> 
> >>>Just would like to ask if you want patches for:
> >>>      
> >>>
> >>Total NACK to any of this boolean ididocy.  I very much hope you didn't
> >>get the impression you actually have a chance to get this merged.
> >>
> >>    
> >>
> >>>* (Most importent, may introduce bugs if left alone)
> >>>Fixing boolean checking, ex:
> >>>if (bool == FALSE)
> >>>to
> >>>if (!bool)
> >>>      
> >>>
> >>this one of course makes sense, but please do it without introducing
> >>any boolean type.  Getting rid of all the TRUE/FALSE defines and converting
> >>all scsi drivers to classic C integer as boolean semantics would be
> >>very welcome janitorial work.
> >>    
> >>
> >
> >I don't get it. You object to the 'idiocy' 
> >(http://lkml.org/lkml/2006/7/27/281), but find the x==FALSE -> !x 
> >a good thing?
> >  
> >
> That is error-prone. Not "==FALSE" but what happens if x is (for some 
> reason) not 1 and then "if (x==TRUE)".

If you're using _Bool, that isn't possible. (Except at the boundaries
where you have to validate untrusted data -- and the compiler makes that
more difficult, because it "knows" that a _Bool can only be 0 or 1 and
therefore your check to see if it's not 0 or 1 can "safely" be
eliminated.)

-- 
Nicholas Miell <nmiell@comcast.net>

