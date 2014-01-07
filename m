From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Mon, 06 Jan 2014 21:44:50 -0500
Message-ID: <52CB6A22.2000203@ubuntu.com>
References: <Pine.LNX.4.44L0.1401061025410.1282-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401061025410.1282-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/06/2014 10:38 AM, Alan Stern wrote:
> Indeed.  I can't see any place where the SCSI or block layers
> would stop the queue of a device when it gets runtime suspended.
> Maybe some other layer is doing this.

So I've stepped through it in qemu a good bit, and found some strange
things.  At the time that sd_resume_system is called, the host is
still in the recovery state as a result of ata_port_resume, so this is
why scsi_request_fn doesn't dispatch the request.  It requeues it for
after the eh finishes, but when the eh finishes and sets the state
back to running, scsi_request_fn calls blk_peek_request, and it
returns NULL rather than the requeued REQUEST SENSE.  It's like the
request is lost rather than having been requeued.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSy2oiAAoJEI5FoCIzSKrwTu4H/RONbp4lsY5jfSCwRCB23W5q
dn8ZmGDzUbjzEeq/DJzARlWdxYadepIDDUKLNVYW1eUrN0+sPLV8jIlDZZgg3dbm
kh0MMPjB2sMbz1zgTQ0/7rZw7WQZfE/vwAo95QQD42FK+SsRMwMoLaN6GsZrikrT
MXzDMXCRLqaow4kSPj7uonN5wlw+1Y5Sn5LJ/SdzPyz2JX/x0lk8zMekNC0i6/tF
ooQymcRFdiDFhr9E6VKj3+TEpVH708zA9vVSjzIZ6KIUD8mA+r2d8pPUWSrjuSzC
U9EVNmawGJMsq70Ql2I8+0J9csz8I3ijQjpfxhw7+V89Fx+t+AH901hYnNY8Qeo=
=hCxT
-----END PGP SIGNATURE-----
