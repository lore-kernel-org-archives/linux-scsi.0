From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 08 Apr 2002 14:07:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204081907.g38J71S05041@localhost.localdomain>
References: <mjacob@feral.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA16711
	for <linux-scsi@vger.kernel.org>; Mon, 8 Apr 2002 12:07:04 -0700
In-Reply-To: Message from Matthew Jacob <mjacob@feral.com>
   of "Mon, 08 Apr 2002 11:34:02 PDT." <Pine.BSF.4.21.0204081129180.46879-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

mjacob@feral.com said:
> For the current discussion, it seems to me that unlabelled/unimported
> disks/volumes (i.e., ones w/o a UUID) still can be named unambiguosly
> by the unwieldy names because you're likely to put a UUID on them very
> very quickly. Furthermore, a minor amount of effort in userland tools
> can make the manipulation of said names not as much of a problem.

I agree, but there are the edge cases where you can't put a UUID on them.

I think, however, that what the discussion is showing us is that there is no 
one universal way to get a unique name for a volume, so what we want is some 
type of pluggable infrastructure which allows us to construct a unique name.

As far as persistent binding goes, I think having the ability to persistently 
bind the unique name to a device is a useful feature for those of us who don't 
want to know what the actual unique name is (or who want a nicer name).

However, nothing should prevent you from passing the name as a string to mount 
instead of using persistent binding (even if the string turns out to have to 
be a set of hex digits).  Perhaps we could even have a user level table of 
nice UUID to unwieldy unique name mapping, and you can use a user specified 
UUID without having to put anything on the device or partition.

The summary so far, as I see it, is

1) persistent binding might be a user friendly way of uniquely identifying 
devices
2) UUID doesn't solve the problem because not everything has one
3) ditto for WWN or EVPID

Another wrinkle is that UUID is partition specific, but WWN etc. are device 
specific.

James


