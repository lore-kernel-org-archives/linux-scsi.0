From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Open/iSCSI] Memory leak in repetitive --login/--logout with
	v2.0-870.1
Date: Mon, 12 Jan 2009 16:27:12 -0800
Message-ID: <1231806432.1274.6.camel@haakon2.linux-iscsi.org>
References: <1231539756.4560.1028.camel@haakon2.linux-iscsi.org>
	 <496AA4D1.9060701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:42748 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751082AbZAMA1h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 19:27:37 -0500
In-Reply-To: <496AA4D1.9060701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Open iSCSI <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Sun, 2009-01-11 at 20:02 -0600, Mike Christie wrote:
> Nicholas A. Bellinger wrote:
> > Greetings Mike, Hannes and Co,
> > 
> > During some recent testing using the Open/iSCSI Initiator v2.0-870.1,
> > against the LIO-Target v3.0 tree, I noticed that while running the
> > following script:
> > 
> > while [ 1 ]; do
> > 	iscsiadm -m node -T $TARGETNAME -p $PORTAL --login
> > 	iscsiadm -m node -T $TARGETNAME -p $PORTAL --logout
> > done
> > 
> > for an extended period of time that I started getting OOM failures on
> > the VMs running Open/iSCSI.   Upon closer examination, this is what I
> > found:
> > 
> > <Open-iSCSI Node 1>
> > 
> > Linux ubuntu 2.6.27.10 #2 SMP Tue Jan 6 18:33:00 PST 2009 i686 GNU/Linux
> > 
> > Using open-iscsi-2.0-870.1:
> > 
> > [78196.520214] scsi7981 : iSCSI Initiator over TCP/IP
> > [78284.175307] scsi7982 : iSCSI Initiator over TCP/IP
> > [78338.568656] scsi7983 : iSCSI Initiator over TCP/IP
> > [78405.888822] scsi7984 : iSCSI Initiator over TCP/IP
> > 
> 
> 
> Hey, so are there any devices on the target? I do not see the normal 
> type/size info we see when scsi disks are found. Just checking. That 
> rules a lot of places out.
> 
> If there are disks, but they just are not gettting logged could you 
> remove them from the target so we can take some structs out of the mix?
> 

I tried the same test both WITH and WITHOUT iSCSI LUNs getting
registered on the Open/iSCSI side.  The leak in size-32 is still present
in both cases.

> 
> > Output from slaptop:
> > 
> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> > 1037001 1036598  99%    0.03K   9177      113     36708K size-32
> > 
> > -------------------------------------------------------------------------
> > 
> > <Open-iSCSI Node 2>
> > 
> > Linux opensuse 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC i686 i686 i386 GNU/Linux
> > 
> > scsi7046 : iSCSI Initiator over TCP/IP
> > scsi7047 : iSCSI Initiator over TCP/IP
> > scsi7048 : iSCSI Initiator over TCP/IP
> > scsi7049 : iSCSI Initiator over TCP/IP
> > 
> > Output from slabtop:
> > 
> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> > 914057 913581  99%    0.03K   8089      113     32356K size-32
> > 
> > -------------------------------------------------------------------------
> > 
> > So it appears that memory is getting leaked in the size-32 range with
> > each --login + --logout invocation.  I also tried the same test with the
> > shipping Open/iSCSI code in Debian v4 and OpenSuse 10.3 and these also
> > suffer from the same issue.
> > 
> > Also of interest is that running the following script for Discovery
> > SendTargets *DOES NOT* reproduce the leak.
> > 
> > while [ 1 ]; do
> > 	iscsiadm -m discovery -t sendtargets -p $PORTAL
> > done
> 
> 
> The leak in the size-32 slab would be a kernel object right? if so the 
> sendtargets test not leaking means that this is a problem in the 
> session/connection kernel struct setup/destruction. The sendtargets code 
> is all in userspace so it would not leak in those objects.
> 
> 
> I was out of the office sick last week, so let me catch up on work stuff 
> then I will try to send a patch. If you want you could try to stick 
> printks in iscsi driver model object release functions to make sure they 
> are getting fired, but that gets nasty.
> 
> 

Ok, I still have my hands full with LIO v3.0 code atm, so I am not sure
how soon I could get to this..

--nab

> > 
> > Please let me know if there is anything else I can do to help diagnose
> > the issue.
> > 
> > Many thanks for your most valuable of time,
> > 
> > --nab
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

