From: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: Large disk drives
Date: Fri, 7 Nov 2014 13:53:51 +0900 (JST)
Message-ID: <533357.25557.qm@web100006.mail.kks.yahoo.co.jp>
Reply-To: Norman Diamond <n0diamond-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

If READ_CAPACITY_10 returns something that looks valid but might be off
by a multiple of 2TB, and READ_CAPACITY_16 fails, what do we really wan=
t
to do when we read the partition table?
=A0
If the partition table indicates that everything fits in the capacity
returned by READ_CAPACITY_10, great, it isn't a large disk drive and we
can do all 10-byte commands.
=A0
If the partition table indicates that the disk drive really is large an=
d
the USB bridge has problems, I'd say we'd better not touch the drive an=
y
further (with possible exceptions).=A0 If the USB bridge fails
READ_CAPACITY_16 but the USB bridge pretends to succeed with READ_16 an=
d
WRITE_16, well maybe it wraps around at 2TB and writes the wrong sector
on the drive.=A0 If READ_CAPACITY_16 fails, I wouldn't trust the USB br=
idge
with any 16-byte command.=A0 If the partition table indicates that the
drive is larger, the user had better be told to find a different USB
bridge or use a real SATA or SCSI controller.
=A0
A possible exception is that if a USB bridge is well tested and confirm=
ed
to handle READ_16 and WRITE_16 correctly while failing READ_CAPACITY_16=
,
an antiquirk could be configured to say we rely on the bridge.
=A0
By the way, I've seen some USB bridges that lie about whether they
performed various SAT commands (ATA passthrough), but told the truth
about performing an ATA IDENTIFY DEVICE through SAT.=A0 So we could att=
empt
ATA passthrough with an IDENTIFY DEVICE command, and if it happens to
return a sane looking result, we could comparre it to the bridge's own
translation of READ_CAPACITY_10 and READ_CAPACITY_16.=A0 If the passthr=
ough
yielded a sane result and the capacity doesn't match, we know not to
trust the bridge with 16-byte commands (except if tested, as mentioned)=
=2E
In such a case, we don't even have to look at the partition table.=A0 O=
f
course if the ATA passthrough fails or if the result is garbage then
abandon this test and maybe look at the partition table.
=A0
By the way, it's not just USB bridges.=A0 I have a particularly obnoxio=
us
ExpressCard with an eSATA connection.=A0 Where the SATA drive operates =
on
512-byte LBAs (whether real or emulated doesn't matter), the eSATA brid=
ge
translates groups of 8 of them into emulated 4096-byte LBAs.=A0 This sh=
ould
make it possible for a 3TB drive to be used when the PC's drivers don't
know how to use ATA commands on sector numbers bigger than 32 bits, as
long as the PC's drivers can handle 4096-byte sectors, right?=A0 Well, =
no.
This eSATA bridge's firmware wraps around at 2TB.=A0 The vendor went to
all this effort just to screw up and maximize the amount of damage that
occurs by hiding their screw up.=A0 I don't know if eBay's warranty cov=
ers
this kind of defect, but it wouldn't be worth paying for postage to
return this POS.=A0 I should have bought the Brooklyn Bridge instead.
To compound the oddity, the same ExpressCard contains a working USB 3.0
bridge.
=A0
(Sorry I can't construct headers to get this message threaded correctly
in the mailing list.)
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
