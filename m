From: Kevin Fenzi <kevin-linux-kernel@scrye.com>
Subject: Re: 2.4.x end of tape handling error
Date: Mon, 17 Feb 2003 20:16:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030218031646.28526.qmail@scrye.com>
References: <20030210182254.2913.qmail@scrye.com>
	<Pine.LNX.4.52.0302102249480.804@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.52.0302102249480.804@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

>>>>> "Kai" == Kai Makisara <Kai.Makisara@kolumbus.fi> writes:

Kai> This discussion should really be moved to linux-scsi... 

ok.

Kai> 10 Feb 2003, Kevin Fenzi wrote:

>> Greetings.
>> 
>> I have had reported from a client that they are having problems
>> with backups that span more than one tape. Instead of getting an
>> EOT error or EOM, they are getting an I/O error wich requires the
>> driver to be unloaded and reloaded before the tape will work again.
>> 
Kai> What messages have they seen in the system log? Some messages
Kai> should be after this kind of error. It is difficult to see where
Kai> the problem is without any details. There have not been any
Kai> significant changes in EOM handling in st between the 2.4
Kai> kernels.

I have duplicated the problem with a dds2 drive I have here. 

Basically, they get back a EIO error instead of a ENOSPC error when
hitting the end of tape. 

>> http://www.linuxtapecert.org/ Says that the redhat 2.4.9-34 kernel
>> is the last one that had proper EOT handling. Indeed, if they use
>> the 2.4.9-34 kernel, the tape works properly. Thats not a very good
>> solution however.
>> 
>> Is this fixed in the latest 2.4.21-pres? How about in 2.5.x?
>> 
Kai> Don't know. EOM handling has worked with my test system (HP DDS
Kai> drives connected to a SYM53c896) with both 2.4 and 2.5 kernels. I
Kai> just reran the eom tests with 2.4.20 and 2.5.60 without problems.

My test system is very similar. 

HP DDS2 drive, on a SYM53c896. ;) 
Redhat 7.3 machine, running 2.4.18-24.7.x. 

To test I just used tar and tried to put more on the tape than would
fit. 

I got: 

...
write(3, "\305\230\240=:-v\t\237&\16\317\234+x\"N(\375\0\264\000"..., 10240) = -1 EIO (Input/output error)
write(2, "tar: ", 5)                    = 5
write(2, "/dev/nst0: Wrote only 0 of 10240"..., 38) = 38
write(2, "\n", 1)                       = 1
write(2, "tar: ", 5)                    = 5
write(2, "Error is not recoverable: exitin"..., 37) = 37
write(2, "\n", 1)                       = 1
munmap(0x4002e000, 4096)                = 0
_exit(2)                                = ?

I tried loading the driver with various options, in case it was a
buffering issue: 

modprobe st buffer_kbs=0 write_threshold_kbs=0 max_buffers=0 max_sg_segs=0

Any option I seemed to give it resulted in the same thing. 
I would be happy to test anything or provide you access to the box
with the tape drive on it. 
Will also try the 2.4.9-34 kernel that is supposed to not have this
issue. 

Kai> 	Kai

kevin

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)
Comment: Processed by Mailcrypt 3.5.8 <http://mailcrypt.sourceforge.net/>

iD8DBQE+UaWe3imCezTjY0ERAt84AJ9JIzGEwm5H9Id4Tg4k0/o0fzZmgwCgk3zr
bP+qoI82jXtyMY7XU2YHjWU=
=4Z2L
-----END PGP SIGNATURE-----
