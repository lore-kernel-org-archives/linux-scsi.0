From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi write barriers (ordered tags)?
Date: 05 Feb 2003 14:24:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044476691.1775.72.camel@mulgrave>
References: <200302051809.NAA23237@orville.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA28611
	for <linux-scsi@vger.kernel.org>; Wed, 5 Feb 2003 12:24:54 -0800
In-Reply-To: <200302051809.NAA23237@orville.steeleye.com>
List-Id: linux-scsi@vger.kernel.org
To: jordan.breeding@attbi.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-02-05 at 11:58, jordan.breeding@attbi.com wrote:

> I understand that SCSI drives and controllers are much more
 complicated than their IDE counterparts and that to implement ordered
 tags in SCSI is more complicated.  However, doesn't FreeBSD's CAM
 layer have some kind of implementation of this which makes it safe to
 use soft-updates and write back cache together?

Actually, no.  The problem that caches cause is that they cache data,
not transactions.  You can force the caches to respect transaction order
by flushing them, but that gets expensive.

 I thought that I read  that sometime ago but I have been trying to
 find references to it on  google this morning and couldn't find any. 
 I guess what I am really  after is to fold:  1) Will Linux's SCSI
 layer get modified at _any_  point to support something like this to
 benefit  ext3/reiserfs/xfs/jfs?  2)  If this will be attempted at some
 point  will it be later in 2.5/2.6 or will this definitely be 2.7/2.8
 material?  Thanks for the info and the response.

Like I said, the infrastructure exists.  There's no compelling reason
to enable it (mainly because most of the benchmarks say it causes a
slowdown).

James


