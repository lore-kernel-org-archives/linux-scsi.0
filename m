From: Jochen Radmacher <jr@dioscuri.de>
Subject: Re: megaraid_sas: Optionally add SCSI devices for individual disks
	in a raidset
Date: Sun, 24 Aug 2008 16:51:22 +0200
Message-ID: <48B1756A.3040301@dioscuri.de>
References: <2834632.1190561219180854948.JavaMail.root@ouachita>
Reply-To: jradmacher@gmx.de
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040202080509000303070606"
Return-path: <linux-poweredge-bounces@dell.com>
In-Reply-To: <2834632.1190561219180854948.JavaMail.root@ouachita>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=unsubscribe>
List-Archive: <http://lists.us.dell.com/pipermail/linux-poweredge>
List-Post: <mailto:linux-poweredge@dell.com>
List-Help: <mailto:linux-poweredge-request@dell.com?subject=help>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=subscribe>
Sender: linux-poweredge-bounces@dell.com
Errors-To: linux-poweredge-bounces@dell.com
To: Joe Malicki <jmalicki@metacarta.com>
Cc: megaraidlinux@lsi.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-poweredge <linux-poweredge@dell.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040202080509000303070606
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
I am running a similar patch for some time now, and haven't had any 
problems so far. (I posted the patch a while ago in linux-scsi, but 
nobody cared.) The only difference is, that I hardcoded the creation of 
the sgx devices and additionally made them read only. (sdev->writeable=1;)

This is what I have tested so far (kernel 2.6.24):
"smartctl --device=sat --all /dev/sgx" (5.38) This works for all 
harddisks. The controller logs an "Unexpected sense" for the smart 
response from the hardrive, but this doesn't do any harm.
The smart daemon does not work corretly in this version
hdparm (v8.6) mostly works, but setting the suspend timeouts doesn't 
show any effekt. Manually supending (hdparm -y) works.

My main intention was suspending the harddrives automatically if the are 
not used, so I wrote this little script. (idlecheck, see attachment) The 
wakeup is done automatically by the controller and takes about 6seconds 
per disk in the raid array.

Joe Malicki wrote:
> This is very dangerous, and you shouldn't use it/apply it unless you're feeling adventurous.
> 
> This lets one, optionally, add /dev/sg* devices, and optionally also /dev/sd* devices, for
> disks in a RAIDset.  It is modeled after similar functionality in the aacraid driver.
Just a little sidenote: If I remember my experiments correctly, the 
device nodes for the individual disks get created in front of the nodes 
for the array, so you need to change the fstab entries if you use this flag.
> 
> I've been successfully using this to upgrade individual disk firmwares behind a Dell PERC 
> RAID controller with sgdskfl from scsirastools - AFTER the RAID array has been stopped
> with other tools.
> 
> Use the kernel option "megaraid_sas.export_disks=-1" to get /dev/sg* devices.  Unless a
> specific option has been given, the patch doesn't modify behavior.
megaraid_sas.export_disks=1 gives you the sdx devices
> 
> Note that the driver currently says (and has said for some time):
> 
>          * FIXME: Currently we don't export them to the midlayer at all.
> 	 * 	  That will be fixed once LSI engineers have audited the
> 	 * 	  firmware for possible issues.
> 
> So using this is certainly high risk and one should be careful.
> (only signing off so others may feel free to use it, not encouraging this
> to go anywhere unless LSI feels it's safe)
> 
The only thing LSI needs to change in the firmware is the handling of 
external smart requests, so it doesn't create a warning in the log.

One more idea (If it is possible): It would be nice, if the driver could 
detect, when a drive is used in an array and not create an sdx node for it.
Greets,
  Jochen

--------------040202080509000303070606
Content-Type: application/x-sh;
 name="idlecheck.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="idlecheck.sh"

#!/bin/sh

### settings ###
TIMEOUT=2400

################
trap cleanup 1 2 3 6 15
cleanup()
{
 echo "stopping"
 RUN=0
}

checkdisk()
{
	rwsectors=$(iostat |grep sdb|awk '{print $5+$6 }')
}
RUN=1
IDLETIME=0
checkdisk
while [ $RUN -eq "1" ]; do
 rwsectors_old=$rwsectors
 checkdisk
 if [ "$rwsectors_old" -ne "$rwsectors" ]; then
  IDLETIME=0
  echo $rwsectors " - active" >/dev/shm/idlecheck.state
 else
  IDLETIME=`expr ${IDLETIME} + 5`
  echo "$rwsectors" " - idle since $IDLETIME seconds" >/dev/shm/idlecheck.state
 fi
 if [ $IDLETIME -eq $TIMEOUT ]; then
  hdparm -y /dev/sg0
  hdparm -y /dev/sg1
  hdparm -y /dev/sg2
  hdparm -y /dev/sg3 
 fi
 if [ $IDLETIME -gt $TIMEOUT ]; then
  echo "disk haven been shutdown" >>/dev/shm/idlecheck.state
 fi
 sleep 5
done;
echo "clean exit"
exit 0;

--------------040202080509000303070606
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-PowerEdge mailing list
Linux-PowerEdge@dell.com
http://lists.us.dell.com/mailman/listinfo/linux-poweredge
Please read the FAQ at http://lists.us.dell.com/faq
--------------040202080509000303070606--
