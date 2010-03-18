From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 15565] New: SCSI Generic queueing completes commands in
 reverse order
Date: Wed, 17 Mar 2010 22:19:17 -0400
Message-ID: <4BA18DA5.6000902@interlog.com>
References: <bug-15565-11613@http.bugzilla.kernel.org/>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47833 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab0CRCTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 22:19:23 -0400
In-Reply-To: <bug-15565-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15565
> 
>            Summary: SCSI Generic queueing completes commands in reverse
>                     order
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.18-2.6.32
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: mh-linux-kernel@loup.net
>         Regression: No
> 
> 
> I've noticed after queueing the first command, subsequent commands
> appear to be executed and complete in reverse order.  The SCSI Generic
> HOWTO says "By default, read() will return the oldest completed
> request that is queued up."
> 
> This could also be a performance defect if it's what's really
> happening since it isn't desirable behavior if, for example, ios are
> typically ordered by lba and issued one at a time by kernel to a non
> queueing block device.
> 
> This reverse order behavior is trivial to reproduce; just queue 16
> concurrent INQUIRY commands.  The following are typical results I get
> from initially queueing 16 READ_10 commands.
> 
>    Completion Command #  hdr.driver_duration (us)
>    Order
>    1          22         14979
>    2          20         14981
>    3          19         14982
>    4          17         14984
>    5          16         14985
>    6          15         14986
>    7          14         14988
>    8          12         14990
>    9          11         14991
>    10         10         14992
> 

I have been told that is a feature :-)

The SCSI mid level processes commands from
pass-throughs (e.g. sg and bsg) in LIFO order.
For certain types of error processing it makes
sense. For READs and WRITEs it makes no sense.

Doug Gilbert

