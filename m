From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Sony VGP-XL1B (200 disk CD/DVD jukebox)
Date: Sun, 05 Nov 2006 10:57:35 +0100
Message-ID: <454DB58F.7060401@s5r6.in-berlin.de>
References: <1162685269.7801.16.camel@localhost.localdomain>
	<1162713408.7801.86.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
In-Reply-To: <1162713408.7801.86.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: Josha Foust <linux1394@lightn.org>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(added Cc: linux-scsi and quoting in full...)

Josha Foust wrote to linux1394-user:
> I've made some progress with mtx.  Is this the right place to talk about
> issues with mtx?

I hope some readers of linux-scsi have advice. I have only a few
comments, see below.

> I noticed the name STARMATIX in the gscanbus output and found this page:
> http://www.linux1394.org/view_device.php?id=512
> I first tried version 1.3.8 without the patch and it didn't help
> anything (I was using 1.2.17rel).  With the patch I got some stuff to
> work.
> 
> The status, load and unload commands now work, mostly.  The status
> command only shows 38 storage elements with the first one being the data
> transfer element and the last one being the import/export slot.
> 
> It will load and unload and I can mount the drive.  Unfortunately I
> can't always safely unload the drive (i.e. you can hear the media
> scraping against something to stop it spinning, and the media was
> damaged).  Hopefully I haven't damanged the drive...  The first time I
> accidently did it when it was mounted, but the 2nd time it seems I just
> did it too soon after the optical drive (sr0) was last accessed and it
> was still spinning.
> 
> The stop command that was added with the patch returns 'mtx:start
> failed' if it doesn't want to stop at that time.  You have to keep
> retrying until it works.  I guess if I don't get the error then it
> should be safe to unload.  Maybe there is a good reason it can't stop it
> from spinning at the time?  It can take a while before it will finally
> stop.  Maybe I'll just patch mtx to retry stop until it works before
> allowing an unload, or write a wrapper program.
> 
> I found this in dmesg from what I think was the first bad unload:
> ieee1394: sbp2: aborting sbp2 command
> sr 5:0:1:0:
>         command: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
> ieee1394: unsolicited response packet received - no tlabel match
> sr 5:0:1:0: ioctl_internal_command return code = 8000002
>    : Current: sense key: Hardware Error
>     Additional sense: Timeout on logical unit
> However I haven't seen it since.

"unsolicited response packet received - no tlabel match" could have
different reasons. A tlabel a.k.a. transaction label is used in the
FireWire protocol to match response packets with previously sent request
packets. A tlabel mismatch means that either the FireWire drivers
wrongly dropped a request too early, or the device's firmware somehow
generated a wrong tlabel, or there went something wrong with the
FireWire bus. You should check dmesg for messages like "ieee1394: sbp2:
Reconnected to SBP-2 device". These should _not_ happen during normal IO.

> If the drive is mounted and I tell it to unload, it does it, but it
> gives this error:
> Unloading drive 0 into Storage Element 3...mtx: Request Sense: 70 00 00
> 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00 00 00
> MOVE MEDIUM from Element Address 2 to 6 Failed
> Is that an error that could be detected before the unload action and
> prevent the unload from occuring?
> 
> The transfer and exchange commands don't seem to work with this unit.  I
> guess it just doesn't support them.  The 'next' command works, but it
> worries me that it might try and unload without stopping the media from
> spinning.  The drive doesn't seem to need the special eject like the
> C200.  I also don't seem to have the problem with the media change
> signals, maybe it was fixed in later kernel versions?
> 
> I managed to crash the unit trying to use the position command.  I had
> to reboot the unit to get it working again.  Here is the dmesg output:
> ieee1394: sbp2: aborting sbp2 command
>  6:0:2:0:
>         command: Inquiry: 12 00 00 00 38 00
> ieee1394: sbp2: aborting sbp2 command
>  6:0:2:0:
>         command: Test Unit Ready: 00 00 00 00 00 00
> ieee1394: sbp2: reset requested
> ieee1394: sbp2: Generating sbp2 fetch agent reset
> ieee1394: sbp2: aborting sbp2 command
>  6:0:2:0:
>         command: Test Unit Ready: 00 00 00 00 00 00
>  6:0:2:0: scsi: Device offlined - not ready after error recovery
> mtx[15550]: segfault at 0000000000000004 rip 000000000040361d rsp
> 00007fff501a27a0 error 4
> 
> I can't seem to reproduce the crash, it doesn't do anything and I just
> get this all of the time:
> mtx: Request Sense: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00
> READ ELEMENT STATUS Command Failed
> 
> The biggest problem is that it says it only has 38 slots.  Any ideas on
> that one?

Hm. I suppose this number is obtained from the NUMBER OF STORAGE
ELEMENTS in the Element Address Assignment mode page. Perhaps the
firmware generates a malformed mode page. The sbp2 driver passes all
these mode parameters from the device through to the SCSI drivers and
applications as-is. (The contents of this mode page is defined by the
SMC-3 or SMC-2 or SMC spec at http://www.t10.org/drafts.htm.)

> By the way, I am running the latest 2.6.17 linux kernel that Debian
> ships on amd64.
> 
> Josha Foust
> 
> On Sat, 2006-11-04 at 18:07 -0600, Josha Foust wrote:
>> So I bought one of these devices on the hope that I could get it to work
>> under linux, don't let me down guys! :)
>>
>> It seems to connect and detect fine, here is the related output:
>> ieee1394: sbp2: Logged into SBP-2 device
>> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>>   Vendor: MATSHITA  Model: DVD-RAM SW-9584   Rev: B104
>>   Type:   CD-ROM                             ANSI SCSI revision: 00
>> scsi4 : SBP-2 IEEE-1394
>> sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
>> sr 2:0:1:0: Attached scsi CD-ROM sr0
>> sr 2:0:1:0: Attached scsi generic sg2 type 5
>> ieee1394: sbp2: Logged into SBP-2 device
>> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>>   Vendor: Sony      Model: VAIOChanger1      Rev: 0100
>>   Type:   Medium Changer                     ANSI SCSI revision: 03
>>  4:0:2:0: Attached scsi generic sg3 type 8
>>
>> gscanbus shows:
>> SelfID Info
>> -----------
>> Physical ID: 0
>> Link active: Yes
>> Gap Count: 63
>> PHY Speed: S400
>> PHY Delay: <=144ns
>> IRM Capable: Yes
>> Power Class: None
>> Port 0: Not connected
>> Port 1: Not connected
>> Port 2: Connected to parent node
>> Init. reset: No
>>
>> CSR ROM Info
>> ------------
>> GUID: 0x003060A100012285
>> Node Capabilities: 0x000083C0
>> Vendor ID: 0x00003060
>> Unit Spec ID: 0x0000609E
>> Unit SW Version: 0x00010483
>> Model ID: 0x00000000
>> Nr. Textual Leafes: 2
>>
>> Vendor:  STARMATIX, INC.
>> Textual Leafes: 
>> Sony
>> VGP-XL1B
>>
>> AV/C Subunits
>> -------------
>> N/A
>>
>> mtx gives this from a inquiry reqest of /dev/sg3:
>> Product Type: Medium Changer
>> Vendor ID: 'Sony    '
>> Product ID: 'VAIOChanger1    '
>> Revision: '0100'
>> Attached Changer: No
>>
>> That last line is a problem, correct?

It shouldn't be, unless mtx doesn't fully support "independent" media
changers. Since media changer and CD/DVD-R/W are presented as separate
logical units on the SBP-2 target, it obviously implements the
independent media changer model, not the attached media changer model.
These terms are again defined by the SMC(-2,3) spec.

>> I haven't managed to get mtx to
>> make the changer do anything (with or without the noattach option).  It
>> just reports 'no Data Transfer Element reported' for most other
>> commands.  It is a bit noisy when the carousel moves, so I should be
>> able to tell if anything happens.
>>
>> mtx commands against sg2 just give this error message:
>> mtx: Request Sense: Long Report=yes
>> mtx: Request Sense: Valid Residual=no
>> mtx: Request Sense: Error Code=0 (Unknown?!)
>> mtx: Request Sense: Sense Key=No Sense
>> mtx: Request Sense: FileMark=no
>> mtx: Request Sense: EOM=no
>> mtx: Request Sense: ILI=no
>> mtx: Request Sense: Additional Sense Code = 00
>> mtx: Request Sense: Additional Sense Qualifier = 00
>> mtx: Request Sense: BPV=no
>> mtx: Request Sense: Error in CDB=no
>> mtx: Request Sense: SKSV=no
>> READ ELEMENT STATUS Command Failed
>>
>> I assume that is just a complete failure because it is not a media
>> changer device.

Yes, mtx needs to talk to /dev/sg3 to change media. I guess mtx or
whatever application client needs to talk to /dev/sg2 or /dev/sr0 to
stop the CD/DVD-R/W from spinning, unlock its tray, etc. (by means of
START STOP UNIT, PREVENT ALLOW MEDIUM REMOVAL commands). Your newer
posting looks like mtx is indeed using /dev/sg3 and /dev/sr0 as necessary.

It is not entirely unexpected that the changer does not support all of
the SCSI commands that mtx is obviously able to generate. Many commands
are only optional according to SMC(-2,3). Mandatory commands for the
media changer unit are:
INQUIRY
MOVE MEDIUM
READ ELEMENT STATUS
REQUEST SENSE
SEND DIAGNOSTIC
TEST UNIT READY

The commands that are to be implemented by the CD/DVD-R/W unit are
defined by the MMC(-?) spec.

I don't know if it is a problem for mtx that media changer and "primary
device" i.e. CD/DVD-R/W are associated with different device files (this
happens with all independent media changers), and are even attached to
two different "Linux SCSI hosts" (this is due to implementation details
of sbp2's interface to Linux' SCSI core even though both devices are
actually two units on the same SBP-2 target).

BTW, if you have a reasonably recent version of udev, you could
certainly also use persistent device file names according to
/sys/bus/scsi/devices/*/ieee1394_id which has the format
EUI64_of_node:number_of_unit_directory:logical_unit_number, instead of
the names /dev/sg* and /dev/sr* which may change by hotplugging.
-- 
Stefan Richter
-=====-=-==- =-== --=-=
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
