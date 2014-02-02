From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Sun, 02 Feb 2014 12:42:37 +0100
Message-ID: <52EE2F2D.1010300@suse.de>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050105090201000601060603"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaBBJj5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Feb 2014 04:39:57 -0500
In-Reply-To: <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050105090201000601060603
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

On 02/01/2014 04:23 PM, "Kai Mäkisara (Kolumbus)" wrote:
>
> On 1.2.2014, at 16.06, Hannes Reinecke <hare@suse.de> wrote:
>
>> On 01/31/2014 05:43 PM, Jeremy Linton wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> On 1/31/2014 2:46 AM, Hannes Reinecke wrote:
>>>
>>>> This patch make the tape always non-rewinding when SG_IO is used, thus
>>>> allowing udev to get a proper device id for tapes.
>>>
>>> 	Maybe instead of silently changing the behavior, if you just _HAVE_ to open
>>> the st device, add an ioctl or st/mt_op that disables the rewind on close.
>>> That way applications have to explicitly disable the rewind on close.
>>>
>> Okay, that sounds like a better alternative.
>> Point is for udev we simply _have_ to use the given device node.
>> And when this happens to be set to rewind on close we're doomed.
>>
> I don’t quite understand why it has to use the auto-rewind device instead of the
> non-rewind device. From the minor number it can see what the non-rewind device
> is. If the problem is that it is not guaranteed that the non-rewind device exits, you
> should rather change the order the devices are created.
>
This is due to the strictly sequential design udev has.
Essentially udev spawns a worker for every device which
gets created (= udev receives a uevent for).
While udev can and does make sure that all parent devices
are created and all events for those device are processed,
it _cannot_ make any assumptions about devices at the same level.
So when udev spawns a worker for the 'st' device, it is guaranteed that 
the uevent for the scsi_device has been processed.
It is likely that the uevent for the 'nst' device has been received by 
udev, but it positively impossible to make any assumptions what the
udev worker for the 'nst' device may or may not have done.
Nor whether it has been processed at all; it might be stuck with some 
other programs for all we know.

So you cannot blindly try to import the values from the 'nst' device; 
they might not be present at that time.
And redirecting the ioctl to another node is possible;
that's actually what we did for the old 'scsi_id' program.
There we implemented a mechanism to use the 'nst' node instead of the 
'st' one for these cases.

But we're now trying to deprecate the original (and unmaintained)
scsi_id program and replace it with the standard 'sg_inq' program.
Which is a standard program which just issues the respective SCSI 
command; most of the post-processing will be done by udev rules.
And implementing the same workaround here is really a bit hackish.
Hence this proposal to allow 'sg_inq' (or any program from sg3_utils)
to be called without interrupting normal operations on a tape device.

> If you absolutely have to do this, then do it. But new ioctls are deprecated and
> also it is a bad habit to change the kernel to make things easier for a single
> program.
>
Well, the actual problem here is that the 'st' driver is not designed 
for multi-initiator environments. The original design for the driver 
assumed that a single program had control over the 'st' driver, and 
there is only one instance talking to the hardware.
Which simply doesn't fit well with the modern, asynchronous, setup.

And it's not just udev which suffers here; try to setup multipath on a 
tape device ...

>> I'll be drafting up a patch.
>>
> If you do, don’t forget to update the documentation.
>
Okay. New patch attached.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------050105090201000601060603
Content-Type: text/x-patch;
 name="st-implement-MT_ST_NOREWIND.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="st-implement-MT_ST_NOREWIND.patch"

>From 6d0f1d306660c645d72f8e1543ce0bebc719f10b Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Sun, 2 Feb 2014 12:03:09 +0100
Subject: [PATCH] st: Implement MT_ST_NOREWIND option

This patch implements the MT_ST_NOREWIND option to inhibit the
rewind on close setting even on normal 'st' devices.
With this patch programs like sg_inq can retrieve the device
identification without interrupting the current operation.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
index f346abb..93906d0 100644
--- a/Documentation/scsi/st.txt
+++ b/Documentation/scsi/st.txt
@@ -399,6 +399,8 @@ MTSETDRVBUFFER
 		correctly returns transfer residuals
 	     MT_ST_DEBUGGING debugging (global; debugging must be
 		compiled into the driver)
+	     MT_ST_NOREWIND disable rewind-on-close even on autorewind
+	        tape devices
 	MT_ST_SETBOOLEANS
 	MT_ST_CLEARBOOLEANS
 	   Sets or clears the option bits.
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a1d6986..f550d0d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2228,6 +2228,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
 		STp->immediate_filemark = (options & MT_ST_NOWAIT_EOF) != 0;
 		STm->sysv = (options & MT_ST_SYSV) != 0;
 		STp->sili = (options & MT_ST_SILI) != 0;
+		if (options & MT_ST_NOREWIND)
+			STp->rew_at_close = 0; 
 		DEB( debugging = (options & MT_ST_DEBUGGING) != 0;
 		     st_log_options(STp, STm, name); )
 	} else if (code == MT_ST_SETBOOLEANS || code == MT_ST_CLEARBOOLEANS) {
@@ -2263,6 +2265,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
 			STm->sysv = value;
 		if ((options & MT_ST_SILI) != 0)
 			STp->sili = value;
+		if (value && (options & MT_ST_NOREWIND) != 0)
+			Stp->rew_at_close = 0;
                 DEB(
 		if ((options & MT_ST_DEBUGGING) != 0)
 			debugging = value;
diff --git a/include/uapi/linux/mtio.h b/include/uapi/linux/mtio.h
index 18543e2..e8b0417 100644
--- a/include/uapi/linux/mtio.h
+++ b/include/uapi/linux/mtio.h
@@ -195,6 +195,7 @@ struct	mtpos {
 #define MT_ST_NOWAIT            0x2000
 #define MT_ST_SILI		0x4000
 #define MT_ST_NOWAIT_EOF	0x8000
+#define MT_ST_NOREWIND		0x10000
 
 /* The mode parameters to be controlled. Parameter chosen with bits 20-28 */
 #define MT_ST_CLEAR_DEFAULT	0xfffff

--------------050105090201000601060603--
