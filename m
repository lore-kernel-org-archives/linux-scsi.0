From: "Suresh Kr N" <suresh@veritas.com>
Subject: RE: Adding a new FC disk to a linux host
Date: Thu, 13 Feb 2003 23:01:08 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <JOEEIMDPCNOOJCHLMKHMAEGLCKAA.suresh@veritas.com>
References: <3E4ADA14.1080301@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E4ADA14.1080301@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

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

