From: Kevin Fenzi <kevin-linux-kernel@scrye.com>
Subject: Re: 2.4.x end of tape handling error
Date: Mon, 24 Feb 2003 16:53:51 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030224235355.30878.qmail@scrye.com>
References: <mailman.1044901620.21591.linux-kernel2news@redhat.com>
	<200302101904.h1AJ4US05141@devserv.devel.redhat.com>
	<20030218021039.28335.qmail@scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Some more information on this problem discovered by Tim Jones
<tjones@tolisgroup.com>:

Tim> Additional news.

Tim> This is actually related to the check sense bit not being
Tim> propagated up to the ST driver.  A simpler test (beats writing
Tim> 40GB to a tape ...):

Tim> use a 2.2.19/20/21 or 22 kernel, or a 2.4.9-34 kernel Remove the
Tim> tape from the tape device execute:

Tim>   tar -cvvf /dev/nst0 /etc

Tim> You will receive a "No medium found" message

Tim> Replace the kernel with 2.4.11+ and repeat the tar write test.
Tim> This time, you will receive a write failure.

Tim> This is caused by the check sense not being set and the ST driver
Tim> sending up a EIO instead of the ENOMEDIUM.

So, it looks like this problem is _not_ in the st driver itself, but
somewhere in the SCSI layer. 

Anyone have any ideas how to better track it down?

Happy to run debug code/test cases here. 

anyone?

kevin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)
Comment: Processed by Mailcrypt 3.5.8 <http://mailcrypt.sourceforge.net/>

iD8DBQE+WrCT3imCezTjY0ERAoNDAJ9kx5aTtxJZlxKL04IJmVTztvM5MQCeIuFS
Y4RxoYEC619ckzSxXGIAlcM=
=A5/e
-----END PGP SIGNATURE-----
