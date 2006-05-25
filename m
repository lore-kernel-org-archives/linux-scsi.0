From: Kearnan_Keith@emc.com
Subject: RE: resizing LUN (not file system) while the file system (ext3) i sonline
Date: Thu, 25 May 2006 10:17:23 -0400
Message-ID: <4A8F680AC6EC43458BCAE06010D8E81B02841E4A@CORPUSMX40A.corp.emc.com>
References: <20060525140450.GA10267@laptop.exavio.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([168.159.213.200]:31602 "EHLO
	mexforward.lss.emc.com") by vger.kernel.org with ESMTP
	id S1030198AbWEYOSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2006 10:18:16 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20060525140450.GA10267@laptop.exavio.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lance.lmwang@gmail.com
Cc: linux-scsi@vger.kernel.org, admitriev@mentora.com, sct@redhat.com


Hi Limin,

The scenario was that there was no free space on the PV which was made
up of a singe partition /dev/sdc1.  The customer used back end tools to
expand /dev/sdc1.  I couldn't figure out a way to let LVM know that
/dev/sdc1 was now "bigger".  In the end we simply had the customer add a
new PV (/dev/sdd1) in order to vgextend/lvextend the file system.

Regards,

Keith

-----Original Message-----
From: Limin Wang [mailto:lance.lmwang@gmail.com] 
Sent: Thursday, May 25, 2006 10:05 AM
To: Kearnan, Keith
Cc: linux-scsi@vger.kernel.org; admitriev@mentora.com;
lance.lmwang@gmail.com; sct@redhat.com
Subject: Re: resizing LUN (not file system) while the file system (ext3)
i sonline

keith,

If you PV has free space, then you can create a new partition with the
free space, pvcreate it and vgextend your volume group. Yes, you have to

resize the file system as well. 

Thanks,
Limin
* Kearnan_Keith@emc.com <Kearnan_Keith@emc.com> [2006-05-25 09:11:34
-0400]:

> 
> Hi folks,
> 
> Since I am the author of the EMC knowledge base article (emc122304)
> mentioned I feel I should respond to this thread.
> 
> 
> Andrey,
> 
> You are correct.  Overcautious is exactly what I was shooting for...so
it
> worked.  Remember, complete newbies (Windows Admins that get Linux
added to
> their responsibility) read these knowledge base articles and then try
them
> out on their company's vital data.  
> 
> 
> Limin,
> 
> LVM can be done online by adding an additional PV.  I've had a
customer
> expand their single PV "behind the scenes".  Is there a way to get LVM
to
> recognize a resized PV?  If so please share because I couldn't find a
> command to do it.
> 
> 
> Stephen,
> 
> The article is dated 11/18/2005 and states "ext3 does not support
online
> expansion...yet".  So yes it is very out of date.
> 
> I will get to work updating emc122304.  Did this behavior start in
base
> RHEL4 (2.6.9-5)?  
>    
> 
> Cheers,
> 
> -Keith
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Stephen C.
Tweedie
> Sent: Thursday, May 25, 2006 7:46 AM
> To: admitriev@mentora.com
> Cc: linux-scsi@vger.kernel.org; Stephen Tweedie
> Subject: Re: resizing LUN (not file system) while the file system
(ext3)
> isonline
> 
> Hi,
> 
> On Thu, 2006-05-25 at 01:16 -0400, Andrey Dmitriev wrote:
> 
> > I understand that ext3 doesn't support online expansion (not in
RedHat
> ES/AS
> > at least)
> 
> Yes it does, and it should work fine in RHEL-4, or FC-3 or later.  Ted
> just integrated the online resize user-space tools into upstream
> e2fsprogs a couple of months ago, and only this week he turned on the
> resize inode feature in mke2fs by default.
> 
> > However, just because the disk array can be done online that does
not mean
> > the application layer can handle online expansion (some file systems
can
> > handle online expansion, currently ext3 cannot)."
> 
> Out-of-date information. :-)
> 
> Cheers,
>  Stephen
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
