From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 09 Jan 2014 10:53:19 -0500
Message-ID: <52CEC5EF.4030201@ubuntu.com>
References: <Pine.LNX.4.44L0.1401091032430.1493-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1401091032430.1493-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/9/2014 10:40 AM, Alan Stern wrote:
> We should change the code in the block layer.  blk_pm_peek_request
>  should allow requests with REQ_PM set to go through, no matter
> what the rpm_status is.  Then the disk driver could query the disk
> (to see whether it is spinning) while the disk remains in runtime
> suspend.

No, because if the disk is RPM_SUSPENDED, the port may be
RPM_SUSPENDED, which likely means that you CAN'T send down requests to
the device.

We need to put the device into one of the transitioning states to
block other IO, without allowing the port to suspend.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzsXvAAoJEI5FoCIzSKrwg30H/A52cy6+GAzE372KVMkP/bI+
LQe4FTTIjo8PDBuYeASzmjdiD8x51++w/QfUQEtSTEhr7qWhyXdMbb1B6eGuDlv/
KqOBTTuhC7eiLArGLTGyLRiLOLEiQb7lHStw4ZCpQpZ88f9pNPdcLCslp8zrz4Of
6pt2lLztdG8zexmKyu0Zq/oSe6ajKqVgrSqjoCO9jQL7NUecZNlBnOnsF4jri0MY
GPk3HIb0gZjtVVfeWAiEE9s4MpRlMYHfx+dg8uxNJiAhJcMQeHJLCTKAKyEMKG68
45Ehqp5XITJG8Mx/Mb6gOzA/mFDShzqRiA0i6MtKBcnr+zNeRnWKRV1UbDKcrxk=
=B5lj
-----END PGP SIGNATURE-----
