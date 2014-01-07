From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 10:40:34 -0500
Message-ID: <52CC1FF2.1020301@ubuntu.com>
References: <Pine.LNX.4.44L0.1401071015120.1296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401071015120.1296-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/7/2014 10:20 AM, Alan Stern wrote:
> This raises two questions:
> 
> Should the host's resume be allowed to complete while the host is
> still in error recovery?  Wouldn't it be better to wait until the
> recovery is finished?

Ahh, right, my other patch changed the ata_port stuff to schedule the
eh, and return  from resume, so that IT doesn't block the system
resume path for a long period of time while IT tries to spin up the
disk.  Both the libata and sd layers were spinning up the disk.

Still, the sd request should just wait in the queue until after the
recovery completes shouldn't it?

> How does the queue end up in a stopped state?  (The stopped queue
> explains why blk_peek_request returns NULL.)

I was guessing that was the cause from reading the code, after
stepping through it with gdb and qemu, it turned out it was in
SHOST_RECOVERY rather that stopped.  I suppose it may be stopped as
well, so I guess I'll have to go do another debug session and make
sure, but I think that was a red herring.

The flow seems to simply be:

host is in recovery
sd_resume queues REQUEST SENSE
scsi_request_fn notices host is in recovery and requeus REQUEST SENSE
recovery completes
REQUEST SENSE seems to be lost...

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzB/yAAoJEI5FoCIzSKrwk0oH/Ays68TYzM2T0GQ6l95YyZy/
j3UU6gRrqv4HGcbRjXwyX1itCTrL+1QKVE4sa1cDc2Uv7oHSU8e28Es428WjseUm
fCfeil+lQpDcSAVX78Iaw7ehWr/EhFlEqk9vtV6ch36nLAujbFUoCmt7AzREoah8
1tcYDlHgU4oT95mvP8JLiEGkhxeJ8THOxSp2QUgP6oEZ72XdHgr7YC/oEPHjvAaG
3CeaYHvetKWxvK/Pzcmm6P5hkbv0GfiXBGR3MdEk5NAyug7JLzfajfxeamxayt4Q
0h2gSak05JHVt/H4l5jNrSpuqwmgriSxn0hZM/ZUwwGC9zS3XR0MQmzV8TY2jJs=
=Xs7s
-----END PGP SIGNATURE-----
