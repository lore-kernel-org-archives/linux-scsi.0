From: Andreas Reis <andreas.reis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Fri, 11 Apr 2014 21:08:21 +0200
Message-ID: <53483DA5.5040303@gmail.com>
References: <Pine.LNX.4.44L0.1404091358340.28384-100000@netrider.rowland.org> <53467950.3010403@gmail.com> <53468297.1040909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53468297.1040909-l3A5Bk7waGM@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

I did set the scsi_logging_level as you wrote, but it still resulted 
into exactly the same dmesg (resp. sudo journalctl -b 0) output with the 
entire patchset (including the "scmd->eh_eflags = 0;"). Except for the 
reverted "do nothing"s, for course.

However, I did miss to mention the following which is printed once with 
or without the scsi_logging_level change:

[16254.735372] sd 9:0:0:0: Device offlined - not ready after error recovery
[16254.735393] sd 9:0:0:0: rejecting I/O to offline device
[16254.735397] sd 9:0:0:0: [sdf] killing request
[16254.735488] sd 9:0:0:0: [sdf] Unhandled error code
[16254.735489] sd 9:0:0:0: [sdf]
[16254.735490] Result: hostbyte=0x01 driverbyte=0x00
[16254.735492] sd 9:0:0:0: [sdf] CDB:
[16254.735493] cdb[0]=0x2a: 2a 00 03 1c 10 f8 00 00 f0 00
[16254.735498] end_request: I/O error, dev sdf, sector 52171000

Another:

[19389.907015] sd 11:0:0:0: Device offlined - not ready after error recovery
[19389.907037] sd 11:0:0:0: [sdf] Unhandled error code
[19389.907044] sd 11:0:0:0: [sdf]
[19389.907049] Result: hostbyte=0x05 driverbyte=0x00
[19389.907055] sd 11:0:0:0: [sdf] CDB:
[19389.907060] cdb[0]=0x28: 28 00 03 13 0d 28 00 00 08 00
[19389.907083] end_request: I/O error, dev sdf, sector 51580200
[19389.907121] sd 11:0:0:0: rejecting I/O to offline device
[19389.907126] sd 11:0:0:0: killing request

In case it matters, the stick's partition stays readable with regard to 
any data on it that has been cached.

On 10.04.2014 13:37, Hannes Reinecke wrote:
> Andreas, can you test with the entire patch series and enable
> 'scsi_logging_level -s -E 5' prior to running the tests?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
