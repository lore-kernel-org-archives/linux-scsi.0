From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: Help - memory leak issue in SCSI stack
Date: Mon, 30 Aug 2004 19:42:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093909329.3026.1.camel@localhost.localdomain>
References: <519672568F040C41B6FAC21ADF51B18FF0B7@mailnode1.commstor.crossroads.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:14511 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S265462AbUH3XmX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 19:42:23 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FF0B7@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@crossroads.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2004-08-30 at 14:03, Lee Xing wrote:
> Please let me re-post my question with text wrap.  Your info
> would be appreciated.
> 
> Test environment is the same as what I described in my previous
> email.  This time I used 'free' instead of 'top' so we can also
> see 'buffer' and 'cached' besides 'used mem'.  Here is the 
> output from 'free':
> 
> time(min) used mem(MB) used buffer/cache(MB) buffers(MB) cached(MB)
>   0            277            111               13         152
>   1            385            121               13         249
>   2            491            131               13         345
>   3            599            142               13         443
>   4            705            152               13         539
>   5            809            162               13         633
>   9           1070            186               14         870
>  10           1116           1090                1         906
>  11           1116           1089                1         906
> 
> Q1:
> In above table, 'cached' increases in similar amount as 
> 'used mem' does in each step.  Does this mean memory increase
> observed in this test is not memory leak, but is because kernel
> increases cache (buffer?) to hold disk data?
i think so. if memory leak, u should be able to see this number keep
going.

> 
> Q2:
> Why does 'buffers' drop from 14 to 1 when 'used mem' and 'cached'
> reach stable stage?
> 
> Q3:
> What are the differences amount 'used buffer/cache', 'buffer' and
> 'cached'.  What are they exactly in the output of 'free' utility?
> 
> Thanks,
> 
> 
> Lee
> 
> 
> -----Original Message-----
> From: Ming Zhang [mailto:mingz@ele.uri.edu]
> Sent: Friday, August 27, 2004 7:02 PM
> To: Lee Xing
> Cc: linux-scsi
> Subject: Re: Help - memory leak issue in SCSI stack
> 
> 
> On Fri, 2004-08-27 at 18:59, Lee Xing wrote:
> > Hi,
> > 
> > I think the following issue is memory leak related but not sure how to narrow it down.  Your help and suggestion would be helpful.
> > 
> > - Test Environment
> >     - RH Linux 9.0 (lk2.4) with patch 2.4.20-30.9
> >     - Dell 1U server with 2 SCSI disks.  The first
> >       one hold OS and utilities, while the 2nd one
> >       (Seagate ST318453LC) is the target iometer
> >       sends I/O to.
> >     - 2GB memory
> >     - Linux 'Hardware Browser' -> 'SCSI devices'
> >       shows "LSI 53c1030, Driver: mptscsih".  This
> >       is probably the built-in SCSI HBA but I'm not
> >       100% sure.  I can double check if some one
> >       tells me how.
> >     - iometer (v. 2003.12.16) and dynamo (v. 2003.12.16)
> ps, iometer has new version now.
> 
> > 
> > - Symptom
> >     run iometer on a different Windows machine, and 
> >     dynamo (the iometer client for Linux) on the Dell
> >     server.  Use 'top' utility on Linux to trace the
> >     memory usage.  Here is what I observed:
> > 
> >     Time (min)       Used Memory (MB)
> >         0                 305
> >         1                 461
> >         2                 589
> >         3                 679
> >         4                 787
> >         5                 894
> >         6                 898
> >         7                 973
> >        10                 1087
> >        15                 1087
> >        20                 1087
> >        30                 1087
> these memory can be used as cache or buffer, check u /proc/meminfo.
> 
> > 
> > - Question
> > Can we say there is a memory leak somewhere based on the above table?  If not, then why the amount of used memory keeps increasing within a certain period of time?  If so, why the amount of used memory
> stops increasing after 10 mins, and how I can trace which layer or component causes it?  
> can u set a text wrap? this long line is so hard to read for terminal.
> 
> > 
> > If I understand right, the following layers/components are involved in this I/O test:
> > 
> >     - Linux upper-level (sd) driver
> >     - Linux mid-lever driver
> >     - LSI low-level driver mptscsih (if the
> >       built-in SCSI HBA does come from LSI).
> >     - Linux libs, etc.
> >     - iometer
> > 
> > Any suggestion and idea would be appreciated.
> > 
> > Have a nice weekend!
> > 
> > 
> > Lee
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
 --------------------------------------------------
| Ming Zhang, PhD. Student
| Dept. of Electrical & Computer Engineering
| College of Engineering
| University of Rhode Island
| Kingston RI. 02881
| e-mail: mingz at ele.uri.edu
| Tel. (401) 874-2293 
| Fax. (401) 782-6422
| http://www.ele.uri.edu/~mingz/
| http://crab.ele.uri.edu/gallery/albums.php
 --------------------------------------------------


