From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Buffer I/O error after s2ram with usb storage
Date: Wed, 27 Aug 2014 10:06:53 -0400
Message-ID: <53FDE5FD.8080607@interlog.com>
References: <20140422160115.46d8d2bf@parrot.com>	<20140428150139.0e10dfd9@parrot.com> <20140827104059.3a4bed94@parrot.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140827104059.3a4bed94@parrot.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthieu CASTET <matthieu.castet@parrot.com>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14-08-27 04:40 AM, Matthieu CASTET wrote:
> Ping
>
> I have got also a problem with a usb sdcard reader (without power cut
> during suspend)
>
> [ 1073.606668] PM: Entering mem sleep
> [ 1073.606742] Suspending console(s) (use no_console_suspend to debug=
)
> [ 1073.607146] sd 1:0:0:0: [sda] Synchronizing SCSI cache
> [ 1073.639076] sd 1:0:0:0: [sda] Stopping disk
> [ 1074.186688] PM: suspend of devices complete after 580.127 msecs
> [...]
> [ 1075.265183] PM: resume of devices complete after 615.990 msecs
> [ 1075.265627] PM: Finishing wakeup.
> [ 1075.265630] Restarting tasks ...
> [...]
> [ 1203.404593] EXT4-fs error (device sdb6): ext4_mb_generate_buddy:75=
6: group 6, 29065 clusters in bitmap, 32768 in gd; block bitmap corrupt=
=2E
> [ 1203.404628] EXT4-fs error (device sdb6): ext4_mb_generate_buddy:75=
6: group 5, 1601 clusters in bitmap, 32321 in gd; block bitmap corrupt.
> [ 1203.404648] EXT4-fs error (device sdb6): ext4_mb_generate_buddy:75=
6: group 4, 0 clusters in bitmap, 32768 in gd; block bitmap corrupt.
> [ 1203.404667] EXT4-fs error (device sdb6): ext4_mb_generate_buddy:75=
6: group 3, 1601 clusters in bitmap, 32321 in gd; block bitmap corrupt.
> [ 1203.404686] EXT4-fs error (device sdb6): ext4_mb_generate_buddy:75=
6: group 2, 0 clusters in bitmap, 32768 in gd; block bitmap corrupt.
> [ 1203.404705] EXT4-fs error (device sdb6): ext4_mb_generate_buddy:75=
6: group 1, 1600 clusters in bitmap, 32321 in gd; block bitmap corrupt.
> [ 1203.404726] JBD2: Spotted dirty metadata buffer (dev =3D sdb6, blo=
cknr =3D 0). There's a risk of filesystem corruption in case of system =
crash.
> [ 1204.141482] sd 8:0:0:0: [sdb] Media Changed
> [ 1204.141490] sd 8:0:0:0: [sdb]
> [ 1204.141494] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [ 1204.141497] sd 8:0:0:0: [sdb]
> [ 1204.141499] Sense Key : Unit Attention [current]
> [ 1204.141504] Info fld=3D0x0
> [ 1204.141506] sd 8:0:0:0: [sdb]
> [ 1204.141510] Add. Sense: Not ready to ready change, medium may have=
 changed

The unit attention doesn't look like a problem, it
looks correct. If the system is unable to detect
removable media being changed while the system is
suspended, then ....

If the media has a unique identifier, then this unit
attention at wakeup should trigger sd to make sure
that unique identifier has not changed.

Not sure why ext4 starts looking at sdb6 _before_ the
sd driver processes that unit attention. Perhaps a
TEST UNIT READY should be done earlier in the wake-up
sequence to flush out (and process) unit attentions.
There is also the case in which the removable media is
no longer present; and that should change EXT4-fs
processing to a surprise removal.

Doug Gilbert

> [ 1204.141514] sd 8:0:0:0: [sdb] CDB:
> [ 1204.141516] Read(10): 28 00 00 0a 75 f8 00 00 08 00
> [ 1204.141526] end_request: I/O error, dev sdb, sector 685560
>
>
>
> Le Mon, 28 Apr 2014 15:01:39 +0200,
> Matthieu CASTET <matthieu.castet@parrot.com> a =E9crit :
>
>> Hi,
>>
>> any news on this.
>>
>> Matthieu CASTET
>>
>> Le Tue, 22 Apr 2014 16:01:15 +0200,
>> Matthieu CASTET <matthieu.castet@parrot.com> a =E9crit :
>>
>>> Hi,
>>>
>>> while playing with suspend to ram I found a strange behavior with u=
sb
>>> key.
>>>
>>> This can be easily reproduced by doing :
>>> - plug a usb key
>>> - start to read the usb key : "cat /dev/sdx > /dev/null"
>>> - go to suspend : "echo mem > /sys/power/state"
>>> - while in suspend, unplug and replug the usb key (simulate usb pow=
er
>>> loss for computer that keep power)
>>> - exit suspend
>>> - there is read error on the usb key
>>>
>>>
>>> Because the power was cut during s2ram, the usb stack reset the dev=
ice
>>> <1>.
>>> When new data transfer are done, we got a UNIT_ATTENTION from the
>>> device <2> and IO error are returned to user space application.
>>>
>>> After some investigation it seems some (all on the 3 I tested) usb =
key
>>> report as removable, and scsi layer abort the transfer in case of
>>> UNIT_ATTENTION <3>.
>>>
>>> The usb storage driver call scsi_report_bus_reset after device rese=
t,
>>> but because of commit dfcf7775 <4>, we don't ignore unit attention =
if
>>> "sshdr.asc =3D=3D 0x28 && sshdr.ascq =3D=3D 0x00" ("Not-ready to re=
ady").
>>>
>>> If dfcf7775 is reverted there is no more Buffer I/O error.
>>>
>>> Is that possible to find a way to restore the behavior before dfcf7=
775
>>> commit (no Buffer I/O error after device reset) after a suspend to =
ram ?
>>>
>>>
>>> Matthieu CASTET
>>>
>>> PS : the same error happen if sg_reset -b /dev/sdx is used on the
>>> device.
>>>
>>>
>>> <1>
>>> [  117.070255] usb 2-1.4: reset high-speed USB device number 3 usin=
g
>>> ehci-pci [...]
>>> [  117.543922] Restarting tasks ... done.
>>> [  117.548390] video LNXVIDEO:01: Restoring backlight state
>>> <2>
>>> [  117.549179] sd 6:0:0:0: [sdb] Media Changed
>>> [  117.549184] sd 6:0:0:0: [sdb]
>>> [  117.549187] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
>>> [  117.549189] sd 6:0:0:0: [sdb]
>>> [  117.549191] Sense Key : Unit Attention [current]
>>> [  117.549195] Info fld=3D0x0
>>> [  117.549197] sd 6:0:0:0: [sdb]
>>> [  117.549201] Add. Sense: Not ready to ready change, medium may ha=
ve
>>> changed [  117.549203] sd 6:0:0:0: [sdb] CDB:
>>> [  117.549205] Read(10): 28 00 00 02 c9 00 00 00 f0 00
>>> [  117.549212] end_request: I/O error, dev sdb, sector 182528
>>> [  117.549218] Buffer I/O error on device sdb1, logical block 22560
>>> [  117.549225] Buffer I/O error on device sdb1, logical block 22561
>>> [  117.549228] Buffer I/O error on device sdb1, logical block 22562
>>> [  117.549231] Buffer I/O error on device sdb1, logical block 22563
>>> [  117.549233] Buffer I/O error on device sdb1, logical block 22564
>>> [  117.549235] Buffer I/O error on device sdb1, logical block 22565
>>> [  117.549238] Buffer I/O error on device sdb1, logical block 22566
>>> [  117.549240] Buffer I/O error on device sdb1, logical block 22567
>>> [  117.549243] Buffer I/O error on device sdb1, logical block 22568
>>> [  117.549245] Buffer I/O error on device sdb1, logical block 22569
>>> [  117.809462] sd 6:0:0:0: [sdb] No Caching mode page found
>>> [  117.809470] sd 6:0:0:0: [sdb] Assuming drive cache: write throug=
h
>>> [  117.812696] sd 6:0:0:0: [sdb] No Caching mode page found
>>> [  117.812703] sd 6:0:0:0: [sdb] Assuming drive cache: write throug=
h
>>> [  117.813688]  sdb: sdb1
>>>
>>>
>>> <3>
>>>          case UNIT_ATTENTION:
>>>              if (cmd->device->removable) {
>>>                  /* Detected disc change.  Set a bit
>>>                   * and quietly refuse further access.
>>>                   */
>>>                  cmd->device->changed =3D 1;
>>>                  description =3D "Media Changed";
>>>                  action =3D ACTION_FAIL;
>>>              } else {
>>>                  /* Must have been a power glitch, or a
>>>                   * bus reset.  Could not have been a
>>>                   * media change, so we just retry the
>>>                   * command and see what happens.
>>>                   */
>>>                  action =3D ACTION_RETRY;
>>>              }
>>>
>>> <4>
>>> commit dfcf7775815504d13a1d273073810058caf84b9d
>>> Author: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
>>> Date:   Thu Aug 11 20:25:20 2011 +0900
>>>
>>>      [SCSI] Fix out of spec CD-ROM problem with media change
>>>
>>>      Some CD-ROMs fail to report a media change correctly.  The spe=
cific
>>>      one for this patch simply fails to respond to commands, then g=
ives a
>>>      UNIT ATTENTION after being reset which returns ASC/ASCQ 28/00.=
  This
>>>      is out of spec behaviour, but add a check in the eat CC/UA on =
reset
>>>      path to catch this case so the CD-ROM will function somewhat p=
roperly.
>>>
>>>      [jejb: fixed up white space and accepted without signoff]
>>>      Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>>>
>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>> index a4b9cdb..dc6131e 100644
>>> --- a/drivers/scsi/scsi_error.c
>>> +++ b/drivers/scsi/scsi_error.c
>>> @@ -293,8 +293,16 @@ static int scsi_check_sense(struct scsi_cmnd *=
scmd)
>>>                   * so that we can deal with it there.
>>>                   */
>>>                  if (scmd->device->expecting_cc_ua) {
>>> -                       scmd->device->expecting_cc_ua =3D 0;
>>> -                       return NEEDS_RETRY;
>>> +                       /*
>>> +                        * Because some device does not queue unit
>>> +                        * attentions correctly, we carefully check
>>> +                        * additional sense code and qualifier so a=
s
>>> +                        * not to squash media change unit attentio=
n.
>>> +                        */
>>> +                       if (sshdr.asc !=3D 0x28 || sshdr.ascq !=3D =
0x00) {
>>> +                               scmd->device->expecting_cc_ua =3D 0=
;
>>> +                               return NEEDS_RETRY;
>>> +                       }
>>>                  }
>>>                  /*
>>>                   * if the device is in the process of becoming rea=
dy, we
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
