From: Konrad Rzeszutek <konrad-/HHyZTb1IPUUqSzUVP1SBw@public.gmane.org>
Subject: Re: Possible bug in open-iSCSI
Date: Tue, 10 Mar 2009 10:53:05 -0400
Message-ID: <20090310145305.GF22889@mars.virtualiron.com>
References: <1c469aa70903100004g3ac915e0i1b52ea84a8d77609@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1c469aa70903100004g3ac915e0i1b52ea84a8d77609-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


On Tue, Mar 10, 2009 at 12:34:55PM +0530, sushrut shirole wrote:
> 
> Hi All,

Hey Sushrut,

I am also cross-posting my response to the linux-scsi mailing list
in case they have insight in this problem.

> 	I am currently guiding few students who are working on unh-iSCSI
> target. Currently we are simulating some faults at a target side .
> Like we are adding an error injection module to unh-iSCSI , so that
> one can test how initiator behaves on particular error .
> 	as a part of it we injects a fault in report LUN size . where we
> report a wrong LUN size . ( Suppose a LUN is of size 2 gb we report it
> as a 4 gb ).(Microsoft and open-iSCSI initiators we are using ).When
> we try formatting this LUN on open-iSCSI initiator it formats this LUN
> . In fact it doesn't give any error when we try to read or lseek 4gb
> of data . But on Microsoft initiator we get an error when we try to
> format this LUN . So is this a bug of open-iSCSI or this is bug of
> read lseek ?

The Open-iSCSI does not investigate any SCSI commands (except the AEN which
gets is own special iSCSI PDU header).

What you are looking at is the SCSI middle-layer, or the block-device layer,
or the target not reporting an error, at being potentially faulty.
What Linux kernel does when you lseek to a location past 2GB and do a read,
is to transmute the request to a SCSI READ command.

That SCSI READ command (you can see what the fields look like when you
capture it under ethereal) specifies what sector it wants. Open-iSCSI
wraps that SCSI command in its own header and puts it in a TCP packet
destined to the target. The the target should then report a failure
(sending a SCSI SENSE value reporting a problem). Now it might be that SCSI
middle layer doesn't understand that error condition and passes it on as OK.
Or it might be that the target doesn't report a failure and returns garbage/null data.

What I would suggest is to do a comparison. Create a test setup where you
have a real 4GB LUN, do a lseek/read above 2GB and capture all of that
traffic using wireshark/ethereal. Then do the same test but with a 2GB LUN
that looks like a 4GB and see what the traffic looks like.

If it looks the same then somehow the target isn't reporting the right
error. Which implies that when Microsoft formats the disks they verify it - by
rereading the data they wrote in and failing if the doesn't match. Which might
not be what mkfs.ext3 does under Linux - look in the man-page to find out. But
by using lseek/read (or just do a dd with the skip argument - look in the manpage
for more details) a couple of times on the same sector and you should see
different data as well.

If the TCP dump looks different, and the target reports a error and the Linux kernel
doesn't do anything then it is time to dig through the code (scsi_error.c) to find
why Linux doesn't see it as. Make sure you do use the latest kernel thought - which as of
today is 2.6.29-rc7-git3. And if you do find the problem post a patch
on the linux-scsi mailing list.

> 
> --
> Thanks,

Hope this lengthy explanation helps in your endeavor.
