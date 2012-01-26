From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] end-to-end data and metadata corruption detection
Date: Thu, 26 Jan 2012 10:36:53 -0500
Message-ID: <yq1fwf21nmy.fsf@sermon.lab.mkp.net>
References: <38C050B3-2AAD-4767-9A25-02C33627E427@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <38C050B3-2AAD-4767-9A25-02C33627E427-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> (Chuck Lever's
	message of "Tue, 17 Jan 2012 15:15:23 -0500")
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chuck" == Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:

Chuck> I'm probably ignorant of the current state of implementation in
Chuck> Linux, but I'm interested in understanding common ground among
Chuck> local file systems, block storage, and network file systems.
Chuck> Example questions include: Do we need standardized APIs for block
Chuck> device corruption detection?  

The block layer integrity stuff aims to be format agnostic. It was
designed to accommodate different types of protection information (back
then the ATA proposal was still on the table).


Chuck> How much of T10 DIF/DIX should NFS support? 

You can either support the T10 PI format and act as a conduit. Or you
can invent your own format and potentially force a conversion. I'd
prefer the former (despite the limitations of T10 PI).


Chuck> What are the drivers for this feature (broad use cases)?

Two things:

1. Continuity. Downtime can be very costly and many applications require
   to be taken offline to do recovery after a corruption error.

2. Archival. You want to make sure your write a good copy to backup.
   With huge amounts of data it is often unfeasible to scrub and verify
   the data on the backup media.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
