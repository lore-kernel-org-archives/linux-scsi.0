From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] remove IDESCSI_SG_TRANSFORM (compile fix)
Date: Tue, 03 Dec 2002 18:20:44 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DEC5B4C.4040208@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2002-12-02 at 17:21, Christoph Hellwig wrote:
 > On Fri, Nov 29, 2002 at 04:44:35PM -0800, Mike Anderson wrote:
 > > Thanks for catching this Christoph I thought the only use was inside
 > > SCSI. I could make a patch to scsi-misc to add tag back in. Another
 > > option if it is still needed is to switch to "->name == "generic").
 > >
 > > Though I have not used this interface I thought if one was using
 > > an sg
 > > device to a ide-scsi device and the flag was set that sg
 > > commands that
 > > where not 100% the same as ATAP commands where translated.
 >
 > Well, imho IDESCSI_SG_TRANSFORM is broken in 2.5.  Now that ever block
 > driver implements the sg ioctls a sg request can come from sd or sr
 > aswell.

Christoph,
Thanks for alerting me to the implementation (by Jens) of
the sg driver's SG_IO ioctl in drivers/block/scsi_ioctl.c .

It goes by the name SCSI_IOCTL_SEND_COMMAND which is the same
name as the old ioctl defined in drivers/scsi/scsi_ioctl.c .
As far as I can see if you send that ioctl to a block device
(including an ATA disk) you get the new functionality (i.e.
similar to sg's SG_IO). However if you send that ioctl to
a char device (e.g. st, osst or sg) you get the old
interface (i.e. as found in drivers/scsi/scsi_ioctl.c).
Somewhat confusing.
So old utilities like scsiinfo will now fail for disks
but continue to work for tapes.


I believe IDESCSI_SG_TRANSFORM translated 6 byte
MODE SENSE ** commands (mandatory in SCSI-2, 10 byte
MODE SENSE optional in SCSI-2) to 10 byte MODE SENSE
commands (mandatory in ATAPI, 6 byte MODE SENSE
commands optional (or not supported) in ATAPI). The
correct solution is to stop applications sending 6
byte MODE SENSE commands to CD/DVD writers. I don't
believe cdrecord uses the IDESCSI_SG_TRANSFORM
ioctl anymore. [Perhaps it comes from the cdwrite
days.]

** Equivalent translations for READ(6), WRITE(6) and
MODE_SELECT(6) command are done by the ide-scsi driver.


Doug Gilbert

