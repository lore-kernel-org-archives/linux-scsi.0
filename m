From: "Suresh Kr N" <suresh@veritas.com>
Subject: RE: Adding a new FC disk to a linux host
Date: Fri, 14 Feb 2003 00:31:26 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <JOEEIMDPCNOOJCHLMKHMCEGMCKAA.suresh@veritas.com>
References: <JOEEIMDPCNOOJCHLMKHMAEGLCKAA.suresh@veritas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vxindia.veritas.com (unverified) by mtvmime03.VERITAS.COM
 (Content Technologies SMTPRS 4.2.10) with ESMTP id <T60632b38320a891155930@mtvmime03.VERITAS.COM> for <linux-scsi@vger.kernel.org>;
 Thu, 13 Feb 2003 10:37:17 -0800
Received: from floyd (floyd.vxindia.veritas.com [10.212.96.111])
	by vxindia.veritas.com (8.11.6+Sun/8.9.3) with SMTP id h1DIb4T15854
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2003 00:07:04 +0530 (IST)
In-Reply-To: <JOEEIMDPCNOOJCHLMKHMAEGLCKAA.suresh@veritas.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

ok , i see this in scsi.c .
Is this safe in a Fibre channel SAN scenario ? could it corrupt an ongoing
data tranfer in a fibre channel SAN scenario ?
and also are there are easier ways to achieve this ( without you supplying a
scsi id etc ).

suresh

  /*
         * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
         * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
         * Consider this feature BETA.
         *     CAUTION: This is not for hotplugging your peripherals. As
         *     SCSI was not designed for this you could damage your
         *     hardware !
         * However perhaps it is legal to switch on an
         * already connected device. It is perhaps not
         * guaranteed this device doesn't corrupt an ongoing data transfer.
         */

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Suresh Kr N
Sent: Thursday, February 13, 2003 11:01 PM
To: Steven Dake
Cc: linux-scsi@vger.kernel.org
Subject: RE: Adding a new FC disk to a linux host


This works for me ( by the way is this still BETA ? i dont see this comment
in the kernel scsi sources anymore ).
But then i need to deduce the these input parameters of target no , lun no
etc , as i need to do this from a userland san management app.

I figured that the HBA apis give you the new target number , and probably i
could do a report luns or something to get the lun numbers as well. So this
way could work for me .

Is there a way to ask the midlayer for a full rescan ( so that i wont have
to find out these parameters )

suresh


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Steven Dake
Sent: Thursday, February 13, 2003 5:05 AM
To: Suresh Kr N
Cc: linux-scsi@vger.kernel.org
Subject: Re: Adding a new FC disk to a linux host


you can scan specific scsi ids.  read scsi_proc.c search for
add-single-device

         * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
         * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
         * Consider this feature BETA.


Good luck
-steve

Suresh Kr N wrote:

>sorry about the wrong thread name in the previous post. updated now
>
>
>hi everyone
>
>I am working on a san management application for a linux. My application
>sends zoning commands to the fabric to zone in a disk to a host ,  so i
need
>to have that disk acessible to the host without a reboot of the host.
>
>I need to do this from the user space. Is there a way to ask the scsi
>midlayer for a rescan ?
>In solaris , i invoke a command called "drvconfig" to achieve this.
>
>I have seen in the linux-scsi archive that this is kind of possible,  but
>the discussion didnt seem to state how.
>I am attaching the above thread here in the mail.
>
>I have verified that echo "scsi add-single-device a b c d" >
/proc/scsi/scsi
>works fine . But this does involve parameters which cant be found out
>programmatically.
>
>Also a side question here :In a FC world, to get the target number for
above
>command , can i find out the current maximum target number of the scsi
>devices, and increase it by one ? or  does the FC devices have actually a
>preknown target no , which would be collected by the FC card driver ?
>
>Could someone please help ? ( even a "non-standard" way should be good
>enough" )
>
>Thanks
>Suresh
>
>
>
>--------------------------------------------------------
>Message 2 in thread
>From: Alan Cox (alan@lxorguk.ukuu.org.uk)
>Subject: Re: Hot plugging a disk in runtime
>View this article only
>Newsgroups: mlist.linux.scsi
>Date: 2002-05-20 05:32:38 PST
>
>
>
>
>>1.. How is it possible to signal SCSI mid-layer (or other layers) of a
>>presence of a newly hot-plugged disk ?
>>
>>
>
>aacraid is one example that does this, but via its config tools.
>
>
>
>>2.. Can an adapter's device driver trigger SCSI subsystem to scan
>>channels for new LUNs / Targets ?
>>
>>
>
>It is designed so user space can do so - so yes
>
>
>
>>3.. Is this can be handled in a kernel level ? is there a user space
>>application that can be triggered to start scanning adapters (obviously
>>through SCSI subsystem) and registering new LUNs / Targets etc... ?
>>
>>
>
>echo "scsi-add-single-device a b c d" /proc/scsi/scsi
>
>if I remember it right
>
>
>entire thread is at
>
>http://groups.google.com/groups?hl=en&lr=&ie=UTF-8&threadm=linux.scsi.20020
5
>201420.g4KEK3x01892%40localhost.localdomain&rnum=7&prev=/groups%3Fq%3Dhot%2
B
>plug%2B%2BSCSI%2Bfibre-channel%2BLinux%26hl%3Den%26lr%3D%26ie%3DUTF-8%26sel
m
>%3Dlinux.scsi.200205201420.g4KEK3x01892%2540localhost.localdomain%26rnum%3D
7
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

