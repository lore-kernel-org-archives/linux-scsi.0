From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: BusLogic cleanup
Date: Thu, 08 Jan 2004 02:02:47 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFC3BB7.7010308@yk.rim.or.jp>
References: <3FF513FE.17A1C2FD@primenet.com> <20040107153149.A29756@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl1004.nas911.n-yokohama.nttpc.ne.jp ([210.139.42.236]:1228
	"EHLO standard.erephon") by vger.kernel.org with ESMTP
	id S265597AbUAGRDx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 12:03:53 -0500
Received: from (client is using the wrong hostname!) yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1AeH5N-00392HC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Jan 2004 02:03:13 +0900 (JST)
In-Reply-To: <20040107153149.A29756@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bob Doyle <doyle@primenet.com>
Cc: linux-scsi@vger.kernel.org


>>So - now the questions...
>>
>>How do I test the eh_* handler functions?  I've tried everything
>>I can think of to provoke them but haven't managed to.  For now,
>>I don't know if they work or not.
> 
> 
> The best testcase would be a faulty disk.  You could also try to get
> into EH szenarios by wrong termination / cabling - but who wants to do
> that to his system?
> 

I have kept a faulty disk from a raid array of about 5 years ago
specifically for provoking SCSI driver, mid-layer errors ! :-)
AND I have buslogic PCI card, which ran fine under 2.2.xx, and 2.4.yy.

Should I take up the challenge?

The only problem is that I haven't used that faulty disk for the last two
to three years, so I am not sure if it still works.
The symptom was that it would fault after about one hour or two.
The problem looks to be a media problem and the driver firmware seems
to try hard to recover from the error by remapping, etc. and it takes 
almost forever,
usually 10-20 sec. This was too lengthy for the linux scsi driver / 
mid-layer
a few years ago.

If the disk is not usable by now, I have a working Nakamichi SCSI
CD changer (7 CD unit) which caused hiccups for some SCSI drivers
when I tried to access two CDs simultaneously in the changer
under linux.
Since the changer needs to shuffle the CDs to access them,
trying to access them simultaneously causes a lot of
mechanical shuffling and long deadtime in between, and again
this dead time of a few seconds (varying) was
too lengthy for linux SCSI subsystem a few years ago.

I am very curious if these are now handled adequately
by linux 2.6.0 now. (I still have a feeling that they may not.)
They were handled adequately by Solaris 7 and
Windows98SE.

Can the new buslogic driver work as module under 2.6.0?
This makes testing much easier than built-in driver.

Also, does the problem with the driver kill only the driver
and the device attached to it, or does the entire system
gets hung? Again, localizing damage is very important for
practical considerations.


-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */

