From: Rudolph Pereira <rudolph@usyd.edu.au>
Subject: Re: fc remote port timeout with qla2xxx driver
Date: Thu, 1 Sep 2005 12:58:39 +1000
Message-ID: <20050901025838.GI27270@usyd.edu.au>
References: <20050831060134.GA26115@usyd.edu.au> <20050831224409.GL11577@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EemXnrF2ob+xzFeB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ankara.ucc.usyd.edu.au ([129.78.64.57]:44778 "EHLO
	ankara.ucc.usyd.edu.au") by vger.kernel.org with ESMTP
	id S965042AbVIAC6p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 22:58:45 -0400
Content-Disposition: inline
In-Reply-To: <20050831224409.GL11577@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org


--EemXnrF2ob+xzFeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 31, 2005 at 03:44:09PM -0700, Andrew Vasquez wrote:
> Hmm, could you try the attached small patch?  This should close that
> whole where the fc_remote_port state is restored to a correct state.
This seems to fix the problem. The debug now shows:
...

Sep  1 10:05:15 baku kernel: scsi(0): LOOP READY
Sep  1 10:05:15 baku kernel: scsi(0): qla2x00_loop_resync - end
Sep  1 10:05:36 baku kernel: scsi(0): Port Update -- creating RSCN fcport f7c2a080 for 81/7/6000.
Sep  1 10:05:36 baku kernel: scsi(0): Handle RSCN -- process RSCN for fcport [ffffff].
Sep  1 10:05:36 baku kernel: scsi(0): Handle RSCN -- attempting login to [81/ffffff].
Sep  1 10:05:36 baku kernel: scsi(0): Sending Login IOCB (a0004000) to [81/ffffff].
Sep  1 10:05:36 baku kernel: scsi(0): Port login retry: 210000d02367d125, id = 0x0081 retry cnt=10
Sep  1 10:05:36 baku kernel: scsi(0): Process IODesc -- processing a0004000.
Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- loop id [81] used by port id [0b1132].
Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- retrying login to [81/0b1132] (2).
Sep  1 10:05:36 baku kernel: scsi(0): Sending Login IOCB (a0005000) to [81/0b1132].
Sep  1 10:05:36 baku kernel: scsi(0): Process IODesc -- processing a0005000.
Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- status=0 mb1=0 pn=210000d02367d125.
Sep  1 10:05:36 baku kernel: scsi(0): fcport-0 - port retry count: 29 remaining
Sep  1 10:05:36 baku kernel: scsi(0): qla2x00_port_login()
Sep  1 10:05:36 baku kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 for port 0b1132.
Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- found RSCN fcport in fcports list [f7db8100].
Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- marking existing fcport [81/0b1132] online.
Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- Freeing RSCN fcport f7c2a080 [81/0b1132].
Sep  1 10:05:36 baku kernel: scsi(0): port login OK: logged in ID 0x81
Sep  1 10:05:36 baku kernel: scsi(0): qla2x00_port_login - end

one thing that I forgot to mention is that I'm prodding the scsi layer to get
rescan for devices by doing:

echo "1" > '/sys/class/fc_remote_ports/rport-0:0-0/device/target0:0:0/0:0:0:1/rescan'
I did this above at 10:05:36, as shown in the log, which led to the
port_login. This explains the delay between loop_resync and relogin.

Apologies for the basic question, but is this what one is supposed to
do? (I believe the dm-multipath stuff does this when it tries to update
devices)

If so, it seems like there might be a reference counting issue hanging
around, as I am able to do a rescan _after_ the FC port is blocked (as
indicated in the debug output), whereas I'd expect the fc_remote_port
sysfs stuff to have disappeared. Related to that, when the port is
disconnected, /sys/class/fc_remote_ports/rport-0:0-0/ still exists - I
presume this is part of the same issue.

In any case, thanks for the patch, as it seems to fix the real issue for me.

--EemXnrF2ob+xzFeB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDFm5eK6c0oCC40tsRAoTyAJ9owpyVGgwoZYJ/nEn581H4vGz2uACfZBOA
Swv48AjwPVBJey3urXYr3HI=
=R5Ax
-----END PGP SIGNATURE-----

--EemXnrF2ob+xzFeB--
