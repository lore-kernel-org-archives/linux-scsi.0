From: berthiaume_wayne@emc.com
Subject: RE: scsi write barriers (ordered tags)?
Date: Wed, 5 Feb 2003 16:57:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049C0681@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: andrew.r.cress@intel.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, jordan.breeding@attbi.com

	Andrew, I'd have to dispute your reported finding. I have been
testing lk 2.4.19, reiserfs, with IDE drives both with write cache enabled
and disabled, and  with and without write barrier patch on file sizes from
4kB to 100MB. All files are fsync()'d to the drives, and with write cache
enabled provided vast improvements in system performance. Further, by using
the write barrier patch, when compared with write cache enabled and no write
barrier patch, only a slight degradation in system performance was
encountered. 
	Now I can't speak for SCSI and how effective it would be, but there
is a definite improvement in the IDE world.
Regards,
Wayne

email:       Berthiaume_Wayne@emc.com

"One man can make a difference, and every man should try."  - JFK


-----Original Message-----
From: Cress, Andrew R [mailto:andrew.r.cress@intel.com]
Sent: Wednesday, February 05, 2003 4:31 PM
To: 'James Bottomley'; jordan.breeding@attbi.com
Cc: SCSI Mailing List
Subject: RE: scsi write barriers (ordered tags)?


Jordan,

Also, note that most of the benchmarks that show an improvement with disk
write cache enabled are using large sequential writes, whereas most
real-life storage I/O will use small random writes, which, as James said,
usually ends up slower with write-cache enabled.  

Andy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@steeleye.com] 
Sent: Wednesday, February 05, 2003 3:25 PM
To: jordan.breeding@attbi.com
Cc: SCSI Mailing List
Subject: Re: scsi write barriers (ordered tags)?


On Wed, 2003-02-05 at 11:58, jordan.breeding@attbi.com wrote:
> I understand that SCSI drives and controllers are much more
 complicated than their IDE counterparts and that to implement ordered
 tags in SCSI is more complicated.  However, doesn't FreeBSD's CAM
 layer have some kind of implementation of this which makes it safe to
 use soft-updates and write back cache together?

Actually, no. [...]

Like I said, the infrastructure exists.  There's no compelling reason
to enable it (mainly because most of the benchmarks say it causes a
slowdown).

James

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
