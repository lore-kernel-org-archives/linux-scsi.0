From: Jeff Garzik <jeff@garzik.org>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 17:46:38 -0500
Message-ID: <45E3634E.9000505@garzik.org>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com> <20070224003723.GS10715@schatzie.adilger.int> <20070224023229.GB4380@thunk.org> <17890.28977.989203.938339@notabene.brown> <20070226132511.GB8154@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070226132511.GB8154@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

Theodore Tso wrote:
> Can someone with knowledge of current disk drive behavior confirm that
> for all drives that support bad block sparing, if an attempt to write
> to a particular spot on disk results in an error due to bad media at
> that spot, the disk drive will automatically rewrite the sector to a
> sector in its spare pool, and automatically redirect that sector to
> the new location.  I believe this should be always true, so presumably
> with all modern disk drives a write error should mean something very
> serious has happend.  


This is what will /probably/ happen.  The drive should indeed find a 
spare sector and remap it, if the write attempt encounters a bad spot on 
the media.

However, with a large enough write, large enough bad-spot-on-media, and 
a firmware programmed to never take more than X seconds to complete 
their enterprise customers' I/O, it might just fail.


IMO, somewhere in the kernel, when we receive a read-op or write-op 
media error, we should immediately try to plaster that area with small 
writes.  Sure, if it's a read-op you lost data, but this method will 
maximize the chance that you can refresh/reuse the logical sectors in 
question.

	Jeff


